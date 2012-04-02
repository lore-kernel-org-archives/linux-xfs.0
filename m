Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q32I3api231257 for <xfs@oss.sgi.com>; Mon, 2 Apr 2012 13:03:36 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id WExoTml4VubKg09V for <xfs@oss.sgi.com>;
	Mon, 02 Apr 2012 11:03:33 -0700 (PDT)
Message-ID: <4F79E9F3.6010305@sandeen.net>
Date: Mon, 02 Apr 2012 11:03:31 -0700
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS Kernel Panics in CentOS
References: <CANoMt5NBie68Auyj_V-6QZBbtLPzKu_sWsTFCceO3dYhJu5uZg@mail.gmail.com>
	<4F763734.9040906@sandeen.net>
	<CANoMt5O5T+FTrmL-2c5tsT=wm434iVNeFarPdybcs1q_oPtW=g@mail.gmail.com>
In-Reply-To: <CANoMt5O5T+FTrmL-2c5tsT=wm434iVNeFarPdybcs1q_oPtW=g@mail.gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Mark Rechler <mrechler@brightcove.com>
Cc: xfs@oss.sgi.com

On 4/2/12 8:09 AM, Mark Rechler wrote:
> Hi Eric,
> 
> Thank you for the reply. We are running CentOS 5.8, with the
> 2.6.18-164.10.1.el5.centos.plus kernel as it was mentioned in a bug
> report that has similar behavior, but ultimately a different kernel
> panic (http://bugs.centos.org/view.php?id=4089). We have tried
> running xfs_repair in the past and it has not proved useful. The odd
> part is that these are fresh systems (just installed). If it helps,
> we are also running glusterfs on these boxes though load does not
> always correlate to a kernel panic.

I can't say for sure what's in that respun "extra" centos kernel,
but I can say this:  the error you hit indicates that xfs read a
buffer, and wound up with a metadata buffer which had unrecognized 
magic - i.e. it did not look like metadata as expected.  Seeing what
looks like corruption, it shut down.

This reminds me a little of 
https://bugzilla.redhat.com/show_bug.cgi?id=512552
which I fixed for RHEL customers a while back, where cancelled
readahead in MD was resulting in xfs thinking a buffer was
uptodate, but in fact it was uninitialized, hence it found
garbage and shut down in this way.

Something similar seems to be happening in your case, if xfs_repair
comes up clean; somehow xfs is getting hold of a buffer which 
apparently doesn't match what xfs_repair found to be a consistent
filesystem.

So I might suspect something in the storage stack?

Also please be sure you don't have kmod-xfs or xfs-kmod installed
on your centos box, which is a truly ancient and completely unsupported
backport of xfs from long, long ago.

-Eric

> Thanks,
> Mark
> 
> On Fri, Mar 30, 2012 at 6:44 PM, Eric Sandeen <sandeen@sandeen.net <mailto:sandeen@sandeen.net>> wrote:
> 
>     On 3/30/12 5:02 PM, Mark Rechler wrote:
>     > Hi Everyone,
>     >
>     > We've been getting a lot of errors (across several kernels) and eventually a kernel panic. Any insight into these errors would be much appreciated.
>     >
>     > Errors:
>     > Filesystem "dm-3": XFS internal error xfs_da_do_buf(2) at line 2112 of file fs/xfs/xfs_da_btree.c.  Caller 0xffffffff883c1826
> 
>     Saying which CentOS it is would help ;)  And, standard disclaimers about how CentOS doesn't come with upstream _or_ distro support, etc etc...
> 
>     But xfs_da_do_buf(2) indicates on-disk corruption, having encountered a bad magic number when reading from the disk.  Have you tried xfs_repair?
> 
>     -Eric
> 
>     > Call Trace:
>     >  [<ffffffff883c1725>] :xfs:xfs_da_do_buf+0x503/0x5b1
>     >  [<ffffffff883c1826>] :xfs:xfs_da_read_buf+0x16/0x1b
>     >  [<ffffffff883c1826>] :xfs:xfs_da_read_buf+0x16/0x1b
>     >  [<ffffffff883aeb71>] :xfs:xfs_attr_leaf_get+0x2e/0x99
>     >  [<ffffffff883aeb71>] :xfs:xfs_attr_leaf_get+0x2e/0x99
>     >  [<ffffffff883aec7f>] :xfs:xfs_attr_fetch+0xa3/0xd5
>     >  [<ffffffff883a7aa8>] :xfs:xfs_acl_iaccess+0x64/0xd4
>     >  [<ffffffff883f264a>] :xfs:xfs_check_acl+0x1b/0x2b
>     >  [<ffffffff8000f550>] generic_permission+0x40/0xca
>     >  [<ffffffff8000d902>] permission+0x81/0xc8
>     >  [<ffffffff8000999d>] __link_path_walk+0x173/0xf42
>     >  [<ffffffff8000e9cc>] link_path_walk+0x42/0xb2
>     >  [<ffffffff8000cc9c>] do_path_lookup+0x275/0x2f1
>     >  [<ffffffff8001278e>] getname+0x15b/0x1c2
>     >  [<ffffffff800236f6>] __user_walk_fd+0x37/0x4c
>     >  [<ffffffff8003f1f6>] vfs_lstat_fd+0x18/0x47
>     >  [<ffffffff8008c46e>] default_wake_function+0x0/0xe
>     >  [<ffffffff800efddf>] sys_lgetxattr+0x4e/0x5f
>     >  [<ffffffff8002a996>] sys_newlstat+0x19/0x31
>     >  [<ffffffff8005d229>] tracesys+0x71/0xe0
>     >  [<ffffffff8005d28d>] tracesys+0xd5/0xe0
>     >
>     > Code: 0f b6 40 02 89 44 24 04 e9 95 00 00 00 44 0f b6 Z3 44 3b 65
>     > RIP [<ffffffffff8841bfaf>] :xfs:xfs_attr_shortform_getvalue+0x24/0xe2
>     >   RSP <ffff81020752dbc8>
>     > CR2: 00000000000002
>     >   <0>Kernel panic - not syncing: Fatal exception
>     >
>     > Thanks,
>     > Mark
>     >
>     >
>     > _______________________________________________
>     > xfs mailing list
>     > xfs@oss.sgi.com <mailto:xfs@oss.sgi.com>
>     > http://oss.sgi.com/mailman/listinfo/xfs
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
