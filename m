Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 727D87F90
	for <xfs@oss.sgi.com>; Thu,  3 Apr 2014 12:43:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5F0378F80B6
	for <xfs@oss.sgi.com>; Thu,  3 Apr 2014 10:43:19 -0700 (PDT)
Received: from mail-qa0-f43.google.com (mail-qa0-f43.google.com
	[209.85.216.43]) by cuda.sgi.com with ESMTP id ToRS30Z6k8gGT76x
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 03 Apr 2014 10:43:15 -0700 (PDT)
Received: by mail-qa0-f43.google.com with SMTP id j15so1974228qaq.2
	for <xfs@oss.sgi.com>; Thu, 03 Apr 2014 10:43:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140403173504.GB23737@thunk.org>
References: <1395997399-3000-1-git-send-email-sedat.dilek@gmail.com>
	<20140328161806.GA31772@thunk.org> <20140331025148.GF16336@dastard>
	<20140401023711.GE4911@thunk.org> <20140401222823.GJ17603@dastard>
	<20140402142620.GA6901@thunk.org> <20140403011411.GL16336@dastard>
	<alpine.LFD.2.00.1404031102310.2124@localhost.localdomain>
	<CALCETrU=JWigDSv6ymepS2tjL+EkO98VDC03-RSPuhQVk3yvZA@mail.gmail.com>
	<20140403173504.GB23737@thunk.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 3 Apr 2014 10:42:54 -0700
Message-ID: <CALCETrUj+46CriTgV84djr-UbXJnwe2d_Ct4xHUz2N0aGnYu9A@mail.gmail.com>
Subject: Re: [Lsf] [PATCH] xfstests-bld: Simplify determination of number of
	CPUs in build-all
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
To: Theodore Ts'o <tytso@mit.edu>
Cc: xfs@oss.sgi.com, lsf@lists.linux-foundation.org, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Sedat Dilek <sedat.dilek@gmail.com>, =?ISO-8859-2?Q?Luk=E1=B9_Czerner?= <lczerner@redhat.com>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>

On Thu, Apr 3, 2014 at 10:35 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Thu, Apr 03, 2014 at 10:05:26AM -0700, Andy Lutomirski wrote:
>>
>> virtme will eventually be able to use a separate OS image, probably in
>> the form of a directory with appropriate xattrs set.  I could support
>> images on a block device too, but that's boring :)
>
> When you say OS image, you mean "root file system, right"?  One of the
> reasons why I'm actually build an actual root-file system image, and
> didn't try the virtme approach was that I wanted to boot 32-bit
> kernels on my development machine, which is 64-bit.
>

Yes.  I've actually done this to test some vdso stuff.

> Having a 32-bit chroot environment would certainly work, though, and
> would save the effort of creating the root file system image....  (and
> of course having a 32-bit userspace also is a great way of exercising
> the ioctl compatibility code paths :-).

I agree, as long as there are giant quote marks around chroot.  No
actual chroot would be involved.

I'd like to support non-x86 architectures, too.  Last time I tried to
convince a modern kernel to boot on a released QEMU on ARM was
painful, though.  Maybe -M virt is the way to go here.

The tricky part here is that virtme currently relies on finding a
statically-linked busybox binary in $PATH.  It'll need to learn how to
find one that will run on the guest, or it will need to learn how to
live without busybox.

>
>> from inside a virtme checkout.  You'll have to compile xfstests first, though.
>
> Fortunately, xfstests-bld will handle do this for you, since it grabs
> and builds all of the depedencies automatically.  More importantly, it
> allows the dependencies to be saved as part of the test output since
> that's important when trying to have other people understand how to
> reproduce a particular test result (since sometimes the latest
> xfstests requires the latest xfs_io from xfsprogs, so it's a bad idea
> to depend on the version of xfsprogs shipped by your distribution).
> For example, for this merge window, I've been using the following to
> do my tests:
>
> fio             fio-2.1-19-g0b14f0a (Thu, 23 May 2013 21:27:54 +0200)
> quota           0d0a674 (Tue, 26 Mar 2013 17:13:33 +0100)
> xfsprogs        v3.2.0-alpha2-60-gaa210c4 (Thu, 13 Mar 2014 21:23:50 +1100)
> xfstests-bld    1efde7a (Tue, 1 Apr 2014 14:42:07 -0400)
> xfstests        linux-v3.8-336-g3948694 (Thu, 13 Mar 2014 15:20:54 +1100)

I haven't actually looked at xfstests-bld yet.  I suspect it could be
made to work with virtme fairly easily.  My current hack uses assumes
you'll use distro packages for all the dependencies.

>
>> They will be considerably more useful once I add read-write host
>> windows to virtme.
>
> Yes, you definitely want that for the results directories.
>
>>  - There's an undocumented way to write results outside the source
>> tree called RESULT_BASE.  It would be great if it were documented and
>> spelled consistently.
>
> There are a bunch of inconsistencies, which I've chalked up to
> historical accidents and a desire to not break compatibility with
> developers' test runners.  You mount the $SCRATCH_DIR on SCRATCH_MNT
> but you mount $TEST_DEV on $TEST_DIR, for example.  I've just learned
> to live with it....

Given that RESULTS_BASE only occurs in an error message, I think it
could be fixed without breaking compatibility.

>
>>  - SCRATCH_MNT needs to be in /etc/fstab.  I think that this should be
>> changed or documented.  If the latter, then SCRATCH_DEV seems
>> redundant.
>
> The various test scripts do need to be able to find the device where
> the file system lives, and parsing /etc/fstab would be awkward.  So if
> your comment is that either the /etc/fstab entry shouldn't be
> required, or the xfstests runtime environment should be able to derive
> $SCRATCH_DEV automatically from $SCRATCH_MNT, or vice versa, instead
> of having the user specify both, I'd agree that would be nice, but
> that's why I put together scripts like the ones I have in xfstests-bld
> --- to make life easier.  :-)
>
> Cheers,
>
>                                                 - Ted



-- 
Andy Lutomirski
AMA Capital Management, LLC

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
