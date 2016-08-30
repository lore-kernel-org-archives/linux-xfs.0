Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6E40F7CA0
	for <xfs@oss.sgi.com>; Mon, 29 Aug 2016 19:53:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3B0AA8F804C
	for <xfs@oss.sgi.com>; Mon, 29 Aug 2016 17:53:47 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id dXhaq2ZMJpMksz4n (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 29 Aug 2016 17:53:42 -0700 (PDT)
Date: Mon, 29 Aug 2016 19:53:38 -0500
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: Re: [PATCH] xfsprogs: don't populate fs table with foreign fs paths
	unless foreign_allowed
Message-ID: <20160830005338.GA21506@redhat.com>
References: <1472478012-23627-1-git-send-email-billodo@redhat.com>
	<20160829231205.GO19025@dastard>
	<20160829232615.GA29648@redhat.com>
	<20160829234044.GS19025@dastard>
	<20160829234704.GC29648@redhat.com>
	<20160830002513.GT19025@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160830002513.GT19025@dastard>
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

On Tue, Aug 30, 2016 at 10:25:13AM +1000, Dave Chinner wrote:
> On Mon, Aug 29, 2016 at 06:47:04PM -0500, Bill O'Donnell wrote:
> > On Tue, Aug 30, 2016 at 09:40:44AM +1000, Dave Chinner wrote:
> > > On Mon, Aug 29, 2016 at 06:26:15PM -0500, Bill O'Donnell wrote:
> > > > On Tue, Aug 30, 2016 at 09:12:06AM +1000, Dave Chinner wrote:
> > > > > On Mon, Aug 29, 2016 at 08:40:12AM -0500, Bill O'Donnell wrote:
> > > > > > Commits b20b6c2 and 29647c8 modified xfs_quota for use on
> > > > > > non-XFS filesystems. One modification in fs_initialise_mounts
> > > > > > (paths.c) resulted in an xfstest fail (xfs/261), due to foreign
> > > > > > fs paths entering the fs table.
> > > > > 
> > > > > What's the failure? I'm not seeing it here on any of my test
> > > > > machines...
> > > > 
> > > > On my box, there are a few ext4 mounts, and test xfs/261 
> > > > populates the fs table with those paths.
> > > 
> > > I have ext2 and ext3 mounts on these machines as well, and they
> > > don't throw any errors.
> > > 
> > > > So when xfs_quota commands
> > > > in 261 are executed, a "foreign filesystem" message is thrown.
> > > 
> > > What is the output that is causing the failure? When someone
> > > asks you to describe the error that is occurring, please quote the
> > > /exact error/ that is occurring - describing it via paraphrasing
> > > does not tell anything useful about the error as I cannot correlate
> > > that description to the code that is throwing it.
> > 
> > Ahh, ok, I'm sorry about that.
> > [root@dell-pesc440-01 xfstests-dev]# ./check -d tests/xfs/261
> > FSTYP         -- xfs (debug)
> > PLATFORM      -- Linux/x86_64 dell-pesc440-01 4.7.0-rc108052016bill02+
> > MKFS_OPTIONS  -- -f -bsize=4096 /dev/mapper/fedora_dell--pesc440--01-csdf
> > MOUNT_OPTIONS -- -o context=system_u:object_r:nfs_t:s0 /dev/mapper/fedora_dell--pesc440--01-csdf /mnt/scratch
> > 
> > xfs/261 2s ...QA output created by 261
> > Silence is golden.
> > print command is for XFS filesystems only
> > print command is for XFS filesystems only
> > print command is for XFS filesystems only
> > print command is for XFS filesystems only
> > print command is for XFS filesystems only
> > print command is for XFS filesystems only
> > print command is for XFS filesystems only
> > print command is for XFS filesystems only
> 
> Bill, slow down and work through the code from first principles. I
> don't care about getting a fix quickly - I care about the process
> you use to find the problem and whether you end up fully
> understanding the problem.  Walk through the code in the debugger if
> you have to - it will show you the flow and how the pieces connect
> together.
> 
> The question that needs to be answered is this: what set of initial
> conditions is causing this error to occur? We don't really care
> about what previous changes caused the issue at this point - working
> that out comes /after/ diagnosing the problem when we are trying to
> work out a fix.
> 
> So, yes, the issue occurs because there are foreign fs types in the
> fstable, but that's not the underlying problem nor the problem that
> needs to be solved.
> 
> Use the debugger and cssope to connect the dots between the fstable
> initialisation, the fs_path initialisation, and the function that
> prints that error. That should give you a good idea of why the error
> is being printed.
> 
> Then have a look at print_f() and see what it does with the fstable.
> Then tell me whether we should even care about checking for foreign
> filesystems before we run the print_f command. At this point, the
> fix should be obvious.
> 
> And then have a look at printpath() and tell me what the foriegn
> filesystem handling bug it contains.
> 
> And, yes, I could have written and tested the patch to fix all this
> in the time it took to write this email, but then you don't have the
> opportunity to learn from doing it....

OK, will do. Thanks Dave.

-Bill


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
