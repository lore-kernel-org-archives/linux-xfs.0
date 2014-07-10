Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F077C7F56
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2014 03:39:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AE7508F8049
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2014 01:39:01 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 6YLdPV5zYUzXVvPi (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 10 Jul 2014 01:38:57 -0700 (PDT)
Date: Thu, 10 Jul 2014 10:38:45 +0200 (CEST)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 2/2] xfstests: Check fs consistency on TEST_DEV only when
	needed
In-Reply-To: <20140710010711.GJ4453@dastard>
Message-ID: <alpine.LFD.2.00.1407101031150.2659@localhost.localdomain>
References: <1403617014-17870-1-git-send-email-lczerner@redhat.com>
	<1403617014-17870-2-git-send-email-lczerner@redhat.com>
	<20140710010711.GJ4453@dastard>
MIME-Version: 1.0
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
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com

On Thu, 10 Jul 2014, Dave Chinner wrote:

> Date: Thu, 10 Jul 2014 11:07:11 +1000
> From: Dave Chinner <david@fromorbit.com>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: fstests@vger.kernel.org, xfs@oss.sgi.com
> Subject: Re: [PATCH 2/2] xfstests: Check fs consistency on TEST_DEV only when
>     needed
> 
> On Tue, Jun 24, 2014 at 03:36:54PM +0200, Lukas Czerner wrote:
> > Currently we're checking file system consistency on TEST_DEV after every
> > successful test run even though the TEST_DEV might not even be used in
> > that test.
> 
> It gets mounted/unmounted for each test, so even if it is not used,
> it might still get modified...
> 
> > Fix it by checking for number of write io on TEST_DEV device before the
> > test and compare it with the value after the test.
> 
> Doesn't work for ram disks:
> 
> # ./setup 
> TEST: DIR=/mnt/test DEV=/dev/ram0 rt=[] log=[]
> TAPE: dev=[] rmt=[] rmtirix=[@]
> SCRATCH: MNT=/mnt/scr DEV=/dev/ram1 rt=[] log=[]
> VARIABLES: external=no largeblk=no fstyp=xfs
>            large_scratch_dev=no attrsecure=no
> # ls -l /dev/ram0
> brw-rw---- 1 root disk 1, 0 Jul  9 15:51 /dev/ram0
> # cat /sys/dev/block/1\:0/stat
>        0        0        0        0        0        0        0        0        0        0        0
> #
> 
> Nor does it work on loop devices.
> 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > ---
> >  check     |  6 +++++-
> >  common/rc | 11 +++++++++++
> >  2 files changed, 16 insertions(+), 1 deletion(-)
> > 
> > diff --git a/check b/check
> > index 40f99d7..66d0f72 100755
> > --- a/check
> > +++ b/check
> > @@ -544,6 +544,7 @@ for section in $HOST_OPTIONS_SECTIONS; do
> >  		rm -f core $seqres.notrun
> >  
> >  		scratch_atime=`stat -c %X $SCRATCH_DEV`
> > +		test_write_io=`_get_write_io_count $TEST_DEV`
> >  		start=`_wallclock`
> >  		$timestamp && echo -n "	["`date "+%T"`"]"
> >  		[ ! -x $seq ] && chmod u+x $seq # ensure we can run it
> > @@ -626,7 +627,10 @@ for section in $HOST_OPTIONS_SECTIONS; do
> >  	    then
> >  		try="$try $seqnum"
> >  		n_try=`expr $n_try + 1`
> > -		_check_test_fs
> > +		write_io=`_get_write_io_count $TEST_DEV`
> > +		if [ -z $test_write_io ] || [ $write_io -ne $test_write_io ]; then
> > +			_check_test_fs
> > +		fi
> 
> Which you work around without mentioning the reason for the zero
> value check. ;)

That's just a safety trigger :) Didn't think it was worth
mentioning.

> 
> Personally, I want the test devices on my systems checked regardless
> of whether the test tries to modify them or not. I, quite frankly,
> don't trust the block device stats because they often get broken or
> are inaccurate. Indeed, there were recent virtio block device
> changes in 3.14-rc1 (or was it 3.15?) that broke the device stats
> and that took several weeks to get fixed properly.
> 
> Hence I don't think using the block device stats for something as
> critical as determining whether we should check a filesystem or not.
> 
> Reducing runtime of the test harness is a good idea, but we should
> not do that if the cost is that it reduces the reliability of error
> detection.

With the patch 1/2 we're going to check scratch dev as well, so if
accepted, the xfstests run time is going to be possibly much longer
especially so on the file systems where fsck time is quite big. So I
think that trying to reduce unnecessary fsck on test_dev is IMO
important.

I like the idea Eric proposed with the _require_test check for the
test that actually require test device and then actually check the
device only after such test. Will that be acceptable ? If so I'll
rework the patches.

Thanks!
-Lukas

> 
> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
