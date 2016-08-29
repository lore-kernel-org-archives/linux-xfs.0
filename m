Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 419117CA0
	for <xfs@oss.sgi.com>; Mon, 29 Aug 2016 18:47:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 96E52AC002
	for <xfs@oss.sgi.com>; Mon, 29 Aug 2016 16:47:08 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 8jm49UEEHzNAsqei (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 29 Aug 2016 16:47:07 -0700 (PDT)
Date: Mon, 29 Aug 2016 18:47:04 -0500
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: Re: [PATCH] xfsprogs: don't populate fs table with foreign fs paths
	unless foreign_allowed
Message-ID: <20160829234704.GC29648@redhat.com>
References: <1472478012-23627-1-git-send-email-billodo@redhat.com>
	<20160829231205.GO19025@dastard>
	<20160829232615.GA29648@redhat.com>
	<20160829234044.GS19025@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160829234044.GS19025@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, Aug 30, 2016 at 09:40:44AM +1000, Dave Chinner wrote:
> On Mon, Aug 29, 2016 at 06:26:15PM -0500, Bill O'Donnell wrote:
> > On Tue, Aug 30, 2016 at 09:12:06AM +1000, Dave Chinner wrote:
> > > On Mon, Aug 29, 2016 at 08:40:12AM -0500, Bill O'Donnell wrote:
> > > > Commits b20b6c2 and 29647c8 modified xfs_quota for use on
> > > > non-XFS filesystems. One modification in fs_initialise_mounts
> > > > (paths.c) resulted in an xfstest fail (xfs/261), due to foreign
> > > > fs paths entering the fs table.
> > > 
> > > What's the failure? I'm not seeing it here on any of my test
> > > machines...
> > 
> > On my box, there are a few ext4 mounts, and test xfs/261 
> > populates the fs table with those paths.
> 
> I have ext2 and ext3 mounts on these machines as well, and they
> don't throw any errors.
> 
> > So when xfs_quota commands
> > in 261 are executed, a "foreign filesystem" message is thrown.
> 
> What is the output that is causing the failure? When someone
> asks you to describe the error that is occurring, please quote the
> /exact error/ that is occurring - describing it via paraphrasing
> does not tell anything useful about the error as I cannot correlate
> that description to the code that is throwing it.

Ahh, ok, I'm sorry about that.
[root@dell-pesc440-01 xfstests-dev]# ./check -d tests/xfs/261
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 dell-pesc440-01 4.7.0-rc108052016bill02+
MKFS_OPTIONS  -- -f -bsize=4096 /dev/mapper/fedora_dell--pesc440--01-csdf
MOUNT_OPTIONS -- -o context=system_u:object_r:nfs_t:s0 /dev/mapper/fedora_dell--pesc440--01-csdf /mnt/scratch

xfs/261 2s ...QA output created by 261
Silence is golden.
print command is for XFS filesystems only
print command is for XFS filesystems only
print command is for XFS filesystems only
print command is for XFS filesystems only
print command is for XFS filesystems only
print command is for XFS filesystems only
print command is for XFS filesystems only
print command is for XFS filesystems only
 - output mismatch (see /root/xfstests-dev/results//xfs/261.out.bad)
    --- tests/xfs/261.out       2016-08-09 15:45:47.471465224 -0400
    +++ /root/xfstests-dev/results//xfs/261.out.bad     2016-08-29 19:45:58.166965834 -0400
    @@ -1,2 +1,10 @@
     QA output created by 261
     Silence is golden.
    +print command is for XFS filesystems only
    +print command is for XFS filesystems only
    +print command is for XFS filesystems only
    +print command is for XFS filesystems only
    +print command is for XFS filesystems only
    ...
    (Run 'diff -u tests/xfs/261.out /root/xfstests-dev/results//xfs/261.out.bad'  to see the entire diff)
Ran: xfs/261
Failures: xfs/261
Failed 1 of 1 tests



> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
