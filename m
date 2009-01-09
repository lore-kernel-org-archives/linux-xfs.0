Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n095dHMN011744 for <xfs@oss.sgi.com>; Thu, 8 Jan 2009 23:39:17 -0600
Date: Fri, 9 Jan 2009 16:38:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [xfs-masters] 2.6.29-rc: kernel BUG at fs/xfs/support/debug.c:108
Message-ID: <20090109053858.GP9448@disturbed>
References: <20090109044121.GA31280@orion>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090109044121.GA31280@orion>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: xfs-masters@oss.sgi.com, kernel-testers@vger.kernel.org, xfs@oss.sgi.com

On Fri, Jan 09, 2009 at 07:41:21AM +0300, Alexander Beregalov wrote:
> Hi
> 
> I got this with the latest git (2150edc6c5cf00f7adb54538b9ea2a3e9cedca3f).
> 
> Assertion failed: fs_is_ok, file: fs/xfs/xfs_btree.c, line: 3327
> ------------[ cut here ]------------
> kernel BUG at fs/xfs/support/debug.c:108!
> invalid opcode: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
> last sysfs file: /sys/devices/platform/w83627hf.656/name
> Modules linked in: w83627hf hwmon_vid i2c_nforce2
> 
> Pid: 250, comm: pdflush Not tainted (2.6.28-07966-g2150edc #1)
> EIP: 0060:[<c029cfce>] EFLAGS: 00010282 CPU: 0
> EIP is at assfail+0x1e/0x30
> EAX: 00000053 EBX: ef2ed170 ECX: 10000000 EDX: 10000000
> ESI: 00000000 EDI: f6b158a4 EBP: f6b15838 ESP: f6b15828
>  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> Process pdflush (pid: 250, ti=f6b14000 task=f6b0d1c0 task.ti=f6b14000)
> Stack:
>  c04bbeb0 c049ba44 c049c4d3 00000cff f6b158f0 c024f3ed 00000008 f0ba7000
>  f6b15894 f6b15878 f6b158e0 f0ba7000 00000010 f6b158fc 00000000 ef2ed170
>  00000000 f0b98000 f0ba7000 00000000 0000000b c024bb8d f6b158e8 f6b15890
> Call Trace:
>  [<c024f3ed>] ? xfs_btree_delrec+0xebd/0x1270
>  [<c024bb8d>] ? xfs_btree_lookup_get_block+0x9d/0x100
>  [<c02492bd>] ? xfs_bmbt_init_key_from_rec+0xd/0x20
>  [<c024a260>] ? xfs_lookup_get_search_key+0x40/0x80
>  [<c024f7cc>] ? xfs_btree_delete+0x2c/0xa0

Looks like the same btree corruption problem as this:

http://oss.sgi.com/archives/xfs/2009-01/msg00118.html

We're working to find the cause right now, but I find it interesting
that you are running a CONFIG_XFS_DEBUG=y kernel and the first
point that something is found wrong is the same place that the
above non-debug case is detecting corruption.

Can you reproduce it/have a reproducable test case?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
