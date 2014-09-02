Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 66EC67F52
	for <xfs@oss.sgi.com>; Tue,  2 Sep 2014 17:02:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 13512AC006
	for <xfs@oss.sgi.com>; Tue,  2 Sep 2014 15:02:32 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	mcVlGR21r4ER0eRN for <xfs@oss.sgi.com>;
	Tue, 02 Sep 2014 15:02:31 -0700 (PDT)
Date: Wed, 3 Sep 2014 08:02:16 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix double free of trans in log recovery on I/O error
Message-ID: <20140902220216.GJ20518@dastard>
References: <1408648692-15957-1-git-send-email-bfoster@redhat.com>
	<CAOcd+r32+6gafv5+MCNyNTH1Ncas9CJHHrku+Y=sZefDzzS1Zw@mail.gmail.com>
	<20140825142025.GA10135@bfoster.bfoster>
	<AFED541EB7FA490C8E16DCB81F400B1C@alyakaslap>
	<20140831210507.GA11913@bfoster.bfoster>
	<3476A2CBDE694DC6BD06DBDD15165151@alyakaslap>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <3476A2CBDE694DC6BD06DBDD15165151@alyakaslap>
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
To: Alex Lyakas <alex@zadarastorage.com>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Tue, Sep 02, 2014 at 12:51:35PM +0300, Alex Lyakas wrote:
> Hi Brian, Dave,
> I tested this patch on 3.8.13 kernel with the scenario I described
> in http://oss.sgi.com/pipermail/xfs/2014-August/037637.html, but I
> still see the issue.
> I placed the metadump at https://drive.google.com/file/d/0ByBy89zr3kJNV2UxMERNTkE4aHM/edit?usp=sharing
> 
> During log recovery, 3 IO errors are encountered:
> [  340.381199] XFS (dm-0): Mounting Filesystem
> [  340.439897] XFS (dm-0): Sleep 10s before xlog_do_recover
> [  350.440143] XFS (dm-0): Starting recovery (logdev: internal)
> [  351.584647] XFS (dm-0): metadata I/O error: block 0x1
> ("xlog_recover_iodone") error 28 numblks 1
> [  351.584660] XFS (dm-0): metadata I/O error: block 0x40
> ("xlog_recover_iodone") error 28 numblks 16
> [  351.584665] XFS (dm-0): xfs_do_force_shutdown(0x1) called from
> line 377 of file
> /mnt/work/alex/zadara-btrfs/fs/xfs/xfs_log_recover.c.  Return
> address = 0xffffffffa0372728
> [  351.584969] XFS (dm-0): I/O Error Detected. Shutting down filesystem
> [  351.584970] XFS (dm-0): Please umount the filesystem and rectify
> the problem(s)
> [  351.585047] XFS (dm-0): metadata I/O error: block 0x1e00040
> ("xlog_recover_iodone") error 28 numblks 16
> [  351.585050] XFS (dm-0): xfs_do_force_shutdown(0x1) called from
> line 377 of file
> /mnt/work/alex/zadara-btrfs/fs/xfs/xfs_log_recover.c.  Return
> address = 0xffffffffa0372728
> [  351.585068] XFS (dm-0): log mount/recovery failed: error 28
> [  351.585332] XFS (dm-0): log mount failed
> 
> Two IO error callbacks are handled before XFS is unmounted, but the
> last one crashes with stack[1].
> 
> Do I need some or all of the 9 patches that Dave posted? (They do
> not apply to my kernel, so I need to apply them by hand).

No, I suspect that there are other problems that have been fixed
since 3.8 that you are missing. e.g.

9c23ecc xfs: unmount does not wait for shutdown during unmount

THere's bound to be others, so you're really going to need to look
at the differences between 3.8 and a current mainline to determine
what other patches you are going to need...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
