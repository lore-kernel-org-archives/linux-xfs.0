Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 16 Jul 2007 00:04:13 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6G745bm030567
	for <xfs@oss.sgi.com>; Mon, 16 Jul 2007 00:04:07 -0700
Date: Mon, 16 Jul 2007 17:04:00 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Fwd: Re: xfs_fsr and null byte areas in files (fwd)
Message-ID: <20070716070400.GU31489@sgi.com>
References: <Pine.LNX.4.64.0707151747390.21990@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707151747390.21990@p34.internal.lan>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: xfs@oss.sgi.com

[Justin, thanks for the forward]

> Subject: Re: xfs_fsr and null byte areas in files
> Date: Sonntag 15 Juli 2007
> From: Martin Steigerwald <Martin@lichtvoll.de>
> To: xfs@oss.sgi.com
> 
> 
> Okay, trying once again. This time just with xfs@oss.sgi.com (no CC, no
> nothing) as according to my test mail that seems to work best.
> 
> Well maybe my build problem is already fixed. I will try on another day.

Your domain is on various RBLs so spamassassin scores are causing your
mail to get classified as spam and are being dropped.

> Am Dienstag 10 Juli 2007 schrieb David Chinner:
> >On Mon, Jul 09, 2007 at 11:13:48PM +0200, Martin Steigerwald wrote:
> 
> >>1) Is there an XFS qa test available for xfs_fsr? If so I could use
> >>that one. Are there some hints on how to get started on XFS qa?
> >
> >Yes, test 042. Download it from CVS, build it (installing all the
> >bits it asks for ;), edit common.config to add your test and scratch
> 
> Hi,
> 
> Do I need both partitions for test 42? On the notebook I have only one
> free partition and since it is a primary partition and all primary
> partitions are used up, I cannot split it.

Split the single partition with LVM. i.e. create a physvol using that
partition and then create 2 logical volumes within it and use those.

> I can try with an external USB harddrive and hope that this test setup is
> similar enough to the situation that yielded my xfs_fsr problems.
> 
> >partitions (both volatile) and the 'check -l 042' to run test 042.
> 
> In order to test xfs_fsr on my laptop I tried compiling XFS qa, but I get
> a compiler error in dmapi. I do not know what dmapi is, well I read
> something about "Data Management API runtime environment" on google and
> thought I may not need it to run test 42. But I do not find any option
> in "./configure" to disable buildin it.
>
> I am using:
> 
> ---------------------------------------------------------------------
> shambala:~#1> apt-show-versions | grep xfs
> xfsprogs/sid uptodate 2.9.0-1
> xfslibs-dev/sid uptodate 2.9.0-1
> xfsdump/sid uptodate 2.2.45-1
> ---------------------------------------------------------------------

$ sudo apt-get install libdm0 libdm0-dev

You probably also want libacl1, libacl1-dev, libattr, libattr1-dev
libblkid1, libuuid1 and uuid-dev.....

> I used
> 
> ---------------------------------------------------------------------
> export CVSROOT=':pserver:cvs@oss.sgi.com:/cvs'
> cvs checkout xfs-cmds
> ---------------------------------------------------------------------

or you could build them all from xfs-cmds/acl .../attr .../dmapi, etc.

> to get xfsqa, then changed to the "xfs-cmds/xfs-tests" directory and
> typed "make".

It's the prereqs that you are missing....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
