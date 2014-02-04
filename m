Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 052317F51
	for <xfs@oss.sgi.com>; Tue,  4 Feb 2014 16:23:05 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E279330408F
	for <xfs@oss.sgi.com>; Tue,  4 Feb 2014 14:23:04 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	VNpLY2grbCm2IT9Q for <xfs@oss.sgi.com>;
	Tue, 04 Feb 2014 14:23:03 -0800 (PST)
Date: Wed, 5 Feb 2014 09:23:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [ANNOUNCE] xfstests updated to 197f773
Message-ID: <20140204222300.GD13997@dastard>
References: <20140124025846.GL27606@dastard>
	<CAOcd+r1wUaMyrhvkq++WoswM1ND9+VZJNx0mZeC1Uiu663xbtg@mail.gmail.com>
	<52E95EB8.8080003@sandeen.net> <20140202223525.GW2212@dastard>
	<4D99B558BC4F49568900AE5DEA05DE86@alyakaslap>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4D99B558BC4F49568900AE5DEA05DE86@alyakaslap>
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
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Tue, Feb 04, 2014 at 07:53:04PM +0200, Alex Lyakas wrote:
> Hi Eric and Dave,
> Thank you for your comments.
> 
> I don't know whether my information is of any value to you or
> anybody else, because I am using an EOL kernel 3.8.13.
> I have run xfstests several times on two different kinds of block
> devices. One is a local file attached to a KVM instance through
> virtio, second is a custom Device Mapper. My local.config file is:
> export TEST_DEV=/dev/mapper/vol-0x5
> export SCRATCH_DEV=/dev/mapper/vol-0x6
> export TEST_DIR=/mnt/TEST_DIR
> export SCRATCH_MNT=/mnt/SCRATCH_DIR
> export FSTYP="xfs"

I'm not going to go into every test failure, but it
definitely sounds like you are running on a RAID device that
exposes sunit/swidth to mkfs. That is the likely cause of all the
log size and stripe unit related failure. Also, you are running
deprecated tests and some that are known to fail. You should run the
"auto" group tests as those are the known "good" tests that should
be regularly run. i.e. Try running:

# MKFS_OPTIONS="-d noalign" ./check -g auto

and that should solve amny of the log size and enospc failures that
you are seeing. What is left is likely to be things we really
need to fix.

FYI, we know there are things that need to be fixed - I currently
see 13 tests from the auto group fail on CRC enabled filesystems:

Failures: generic/263 generic/313 xfs/021 xfs/033 xfs/066 xfs/073
xfs/189 xfs/216 xfs/295 xfs/296 xfs/299 xfs/301 xfs/302
Failed 13 of 240 tests

Several of these are test issues, some of them are bugs that need
triage and fixing. We're slowly working our way through them fixing
the test issues - we've been fixing 3-4 a week for the past few
weeks, so the situation is getting much better - 3 weeks ago the
same test machine was seeing ~25 failures in a run.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
