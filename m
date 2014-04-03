Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DA3D97F7E
	for <xfs@oss.sgi.com>; Thu,  3 Apr 2014 12:35:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 57ADDAC001
	for <xfs@oss.sgi.com>; Thu,  3 Apr 2014 10:35:22 -0700 (PDT)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id T35sdehIfetv4Gyq (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 03 Apr 2014 10:35:20 -0700 (PDT)
Date: Thu, 3 Apr 2014 13:35:04 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [Lsf] [PATCH] xfstests-bld: Simplify determination of number of
	CPUs in build-all
Message-ID: <20140403173504.GB23737@thunk.org>
References: <1395997399-3000-1-git-send-email-sedat.dilek@gmail.com>
	<20140328161806.GA31772@thunk.org> <20140331025148.GF16336@dastard>
	<20140401023711.GE4911@thunk.org> <20140401222823.GJ17603@dastard>
	<20140402142620.GA6901@thunk.org> <20140403011411.GL16336@dastard>
	<alpine.LFD.2.00.1404031102310.2124@localhost.localdomain>
	<CALCETrU=JWigDSv6ymepS2tjL+EkO98VDC03-RSPuhQVk3yvZA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CALCETrU=JWigDSv6ymepS2tjL+EkO98VDC03-RSPuhQVk3yvZA@mail.gmail.com>
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
To: Andy Lutomirski <luto@amacapital.net>
Cc: xfs@oss.sgi.com, lsf@lists.linux-foundation.org, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Sedat Dilek <sedat.dilek@gmail.com>, =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>

On Thu, Apr 03, 2014 at 10:05:26AM -0700, Andy Lutomirski wrote:
> 
> virtme will eventually be able to use a separate OS image, probably in
> the form of a directory with appropriate xattrs set.  I could support
> images on a block device too, but that's boring :)

When you say OS image, you mean "root file system, right"?  One of the
reasons why I'm actually build an actual root-file system image, and
didn't try the virtme approach was that I wanted to boot 32-bit
kernels on my development machine, which is 64-bit.

Having a 32-bit chroot environment would certainly work, though, and
would save the effort of creating the root file system image....  (and
of course having a 32-bit userspace also is a great way of exercising
the ioctl compatibility code paths :-).

> from inside a virtme checkout.  You'll have to compile xfstests first, though.

Fortunately, xfstests-bld will handle do this for you, since it grabs
and builds all of the depedencies automatically.  More importantly, it
allows the dependencies to be saved as part of the test output since
that's important when trying to have other people understand how to
reproduce a particular test result (since sometimes the latest
xfstests requires the latest xfs_io from xfsprogs, so it's a bad idea
to depend on the version of xfsprogs shipped by your distribution).
For example, for this merge window, I've been using the following to
do my tests:

fio		fio-2.1-19-g0b14f0a (Thu, 23 May 2013 21:27:54 +0200)
quota		0d0a674 (Tue, 26 Mar 2013 17:13:33 +0100)
xfsprogs	v3.2.0-alpha2-60-gaa210c4 (Thu, 13 Mar 2014 21:23:50 +1100)
xfstests-bld	1efde7a (Tue, 1 Apr 2014 14:42:07 -0400)
xfstests	linux-v3.8-336-g3948694 (Thu, 13 Mar 2014 15:20:54 +1100)

> They will be considerably more useful once I add read-write host
> windows to virtme.

Yes, you definitely want that for the results directories.

>  - There's an undocumented way to write results outside the source
> tree called RESULT_BASE.  It would be great if it were documented and
> spelled consistently.

There are a bunch of inconsistencies, which I've chalked up to
historical accidents and a desire to not break compatibility with
developers' test runners.  You mount the $SCRATCH_DIR on SCRATCH_MNT
but you mount $TEST_DEV on $TEST_DIR, for example.  I've just learned
to live with it....

>  - SCRATCH_MNT needs to be in /etc/fstab.  I think that this should be
> changed or documented.  If the latter, then SCRATCH_DEV seems
> redundant.

The various test scripts do need to be able to find the device where
the file system lives, and parsing /etc/fstab would be awkward.  So if
your comment is that either the /etc/fstab entry shouldn't be
required, or the xfstests runtime environment should be able to derive
$SCRATCH_DEV automatically from $SCRATCH_MNT, or vice versa, instead
of having the user specify both, I'd agree that would be nice, but
that's why I put together scripts like the ones I have in xfstests-bld
--- to make life easier.  :-)

Cheers,

						- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
