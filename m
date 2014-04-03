Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EA23C7F9A
	for <xfs@oss.sgi.com>; Thu,  3 Apr 2014 14:06:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E15B6304059
	for <xfs@oss.sgi.com>; Thu,  3 Apr 2014 12:06:36 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ysCkjBWLpTyJE5vT for
	<xfs@oss.sgi.com>; Thu, 03 Apr 2014 12:06:35 -0700 (PDT)
Message-ID: <533DB140.8010103@redhat.com>
Date: Thu, 03 Apr 2014 13:06:40 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [Lsf] [PATCH] xfstests-bld: Simplify determination of number
	of CPUs in build-all
References: <1395997399-3000-1-git-send-email-sedat.dilek@gmail.com>
	<20140328161806.GA31772@thunk.org> <20140331025148.GF16336@dastard>
	<20140401023711.GE4911@thunk.org> <20140401222823.GJ17603@dastard>
	<20140402142620.GA6901@thunk.org> <20140403011411.GL16336@dastard>
	<alpine.LFD.2.00.1404031102310.2124@localhost.localdomain>
	<CALCETrU=JWigDSv6ymepS2tjL+EkO98VDC03-RSPuhQVk3yvZA@mail.gmail.com>
	<20140403173504.GB23737@thunk.org>
In-Reply-To: <20140403173504.GB23737@thunk.org>
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
To: Theodore Ts'o <tytso@mit.edu>, Andy Lutomirski <luto@amacapital.net>
Cc: xfs@oss.sgi.com, lsf@lists.linux-foundation.org, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Sedat Dilek <sedat.dilek@gmail.com>, =?UTF-8?B?THVrw6HFoSBDemVybmVy?= <lczerner@redhat.com>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>

On 4/3/14, 11:35 AM, Theodore Ts'o wrote:

>>  - There's an undocumented way to write results outside the source
>> tree called RESULT_BASE.  It would be great if it were documented and
>> spelled consistently.

I'm not actually certain that it was intended to be used this way.
See 1686f9ab "xfstests: Introduce a results directory" 
which explains just where this variable came from and what it's
for...

So that's probably why it's undocumented; I don't think it was
envisioned as a configurable.  As for consistency... patch
sent for the typo.

If the functionality is needed, just make sure it works right if
you set it manually, update the user docs, & send a patch.

> There are a bunch of inconsistencies, which I've chalked up to
> historical accidents and a desire to not break compatibility with
> developers' test runners.  You mount the $SCRATCH_DIR on SCRATCH_MNT

$SCRATCH_DEV you mean. ;)  I don't think there's any real resistance
to fixing things that really need to be fixed, but this one
doesn't seem too critical.  OTOH, adding an alias from SCRATCH_MNT
to SCRATCH_DIR for consistency could surely be done if anyone cared
enough to send the patch.

> but you mount $TEST_DEV on $TEST_DIR, for example.  I've just learned
> to live with it....
> 
>>  - SCRATCH_MNT needs to be in /etc/fstab.  I think that this should be
>> changed or documented.  If the latter, then SCRATCH_DEV seems
>> redundant.

Hm, I've never needed SCRATCH_MNT in /etc/fstab... 

> The various test scripts do need to be able to find the device where
> the file system lives, and parsing /etc/fstab would be awkward.  So if
> your comment is that either the /etc/fstab entry shouldn't be
> required, or the xfstests runtime environment should be able to derive
> $SCRATCH_DEV automatically from $SCRATCH_MNT, or vice versa, instead

I guess I don't know why you'd expect to derive one from the other...

> of having the user specify both, I'd agree that would be nice, but
> that's why I put together scripts like the ones I have in xfstests-bld
> --- to make life easier.  :-)

All I've ever had to do is set up the 4 variables in local.config.example
(by copying to local.config & editing appropriately) and it all just works
AFAIK.

(No doubt docs could be improved, but we can do that by sending patches.)  :)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
