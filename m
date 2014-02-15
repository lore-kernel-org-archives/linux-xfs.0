Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6C12B29DF8
	for <xfs@oss.sgi.com>; Sat, 15 Feb 2014 16:24:09 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5A139304043
	for <xfs@oss.sgi.com>; Sat, 15 Feb 2014 14:24:06 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	vrRvJ2P0VTX2CXGJ for <xfs@oss.sgi.com>;
	Sat, 15 Feb 2014 14:24:04 -0800 (PST)
Date: Sun, 16 Feb 2014 09:23:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
Message-ID: <20140215222356.GU13997@dastard>
References: <20140212004403.GA17129@redhat.com>
	<20140212010941.GM18016@ZenIV.linux.org.uk>
	<CA+55aFwoWT-0A_KTkXMkNqOy8hc=YmouTMBgWUD_z+8qYPphjA@mail.gmail.com>
	<20140212040358.GA25327@redhat.com>
	<20140212042215.GN18016@ZenIV.linux.org.uk>
	<20140212054043.GB13997@dastard>
	<CA+55aFxy2t7bnCUc-DhhxYxsZ0+GwL9GuQXRYtE_VzqZusmB9A@mail.gmail.com>
	<20140212071829.GE13997@dastard> <20140214002427.GN13997@dastard>
	<20140214160123.GA28125@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140214160123.GA28125@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Jones <davej@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Eric Sandeen <sandeen@sandeen.net>, Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Fri, Feb 14, 2014 at 11:01:23AM -0500, Dave Jones wrote:
> On Fri, Feb 14, 2014 at 11:24:27AM +1100, Dave Chinner wrote:
>  
>  > > I can fix this one easily - we already have a workqueue for doing
>  > > async log pushes (will split the stack between xlog_cil_force_lsn
>  > > and xlog_cil_push), but the reason we haven't used it for synchronous
>  > > log forces is that screws up fsync performance on CFQ. We don't
>  > > recommend CFQ with XFS anyway, so I think I'll make this change
>  > > anyway.
>  > 
>  > Dave, the patch below should chop off the stack usage from
>  > xfs_log_force_lsn() issuing IO by deferring it to the CIL workqueue.
>  > Can you given this a run?
> 
> Looks like it's survived an overnight run..

Great.

One thing that has been puzzling me is why I'm seeing stack usage
reported that is way above what we declare locally on the stack.
e.g.

 29)     2048     224   xfs_da_grow_inode_int+0xbb/0x340
 30)     1824      96   xfs_dir2_grow_inode+0x63/0x110
 31)     1728     208   xfs_dir2_sf_to_block+0xe7/0x5e0
 32)     1520     144   xfs_dir2_sf_addname+0x115/0x5c0
 33)     1376      96   xfs_dir_createname+0x164/0x1a0
 34)     1280     224   xfs_create+0x536/0x660
 35)     1056     128   xfs_vn_mknod+0xc8/0x1d0

I pulled 128 bytes out of xfs_dir_createname by allocating the
xfs_da_args structure, but I still couldn't reconcile the amount of
stack use being reported with the amount used by locally declared
variables (even considering in-lined leaf functions). For example:

Locally
Declared	Used   function
  88             224   xfs_da_grow_inode_int
  32              96   xfs_dir2_grow_inode
 168             208   xfs_dir2_sf_to_block
  56             144   xfs_dir2_sf_addname
  16              96   xfs_dir_createname
 120             224   xfs_create
  52             128   xfs_vn_mknod

There's a pretty massive difference between the actual stack usage
of the local variables and the amount of stack being used by the
compiled code.

What it appears to be is that the compiler is pushing 6-10 registers
to the stack on every function call. So a function that only has 3
local variables and does very little but allocate a structure and
call other functions saves an 6 registers to the stack before it
starts:

Dump of assembler code for function xfs_dir_createname:
214     {
   0xffffffff814d7380 <+0>:     callq  0xffffffff81cf0940
   0xffffffff814d7385 <+5>:     push   %rbp
   0xffffffff814d7386 <+6>:     mov    %rsp,%rbp
   0xffffffff814d7389 <+9>:     sub    $0x50,%rsp
   0xffffffff814d738d <+13>:    mov    %rbx,-0x28(%rbp)
   0xffffffff814d7391 <+17>:    mov    %rdi,%rbx
   0xffffffff814d7394 <+20>:    mov    %r12,-0x20(%rbp)
   0xffffffff814d7398 <+24>:    mov    %rcx,%r12
   0xffffffff814d739b <+27>:    mov    %r13,-0x18(%rbp)
   0xffffffff814d739f <+31>:    mov    %rsi,%r13
   0xffffffff814d73a5 <+37>:    mov    %r14,-0x10(%rbp)
   0xffffffff814d73a9 <+41>:    mov    %rdx,%r14
   0xffffffff814d73ac <+44>:    mov    %r15,-0x8(%rbp)
   0xffffffff814d73b0 <+48>:    mov    %r8,%r15
   0xffffffff814d73b7 <+55>:    mov    %r9,-0x48(%rbp)
.....

If this is typical across the call chain (appears to be from my
quick survey) then we are averaging 40-50 bytes of stack per
call for saved registers. That's a lot of stack space we can't
directly control the usage of, especially when we are talking about
call chains that can get 50+ functions deep...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
