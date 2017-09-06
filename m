Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail02.adl2.internode.on.net ([150.101.137.139]:60698 "EHLO
        ipmail02.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753704AbdIFLT6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Sep 2017 07:19:58 -0400
Date: Wed, 6 Sep 2017 21:19:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 0/3] XFS real-time device tweaks
Message-ID: <20170906111953.GS17782@dastard>
References: <20170902224145.1291030-1-rwareing@fb.com>
 <20170903085602.GF32385@infradead.org>
 <30E1D468-6E15-469E-8026-8EE542201422@fb.com>
 <20170906034443.GQ17782@dastard>
 <9729DF06-8F96-4F93-BF50-133F9BA2770F@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9729DF06-8F96-4F93-BF50-133F9BA2770F@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Richard Wareing <rwareing@fb.com>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "darrick.wong@oracle.com" <darrick.wong@oracle.com>

On Wed, Sep 06, 2017 at 06:54:41AM +0000, Richard Wareing wrote:
> On 9/5/17, 8:45 PM, "Dave Chinner" <david@fromorbit.com> wrote: On
> Sun, Sep 03, 2017 at 10:02:41PM +0000, Richard Wareing wrote:
>     > without having to strip the inheritance bits from all the
>     > directories (which would require two walks....one to remove
>     > and one to add them all back).    I think this is about
>     > having some options during incidents, and a "kill-switch"
>     > should the need arise.
>     
>     And soon after the kill switch is triggered, your tiny data
>     device will go ENOSPC because changing that mount option
>     effective removed TBs of free space from the filesystem. Then
>     things will really start going bad.
>     
>     So maybe you didn't think this through properly - the last
>     thing a typical user would expect is a filesystem reporting
>     TBs of free space to go ENOSPC and not being able to recover,
>     regardless of what mount options are present. iAnd they'll be
>     especially confused when they start looking at inodes and
>     seeing RT bits set all over the place...
>     
>     It's just a recipe for confusion, unexpected behaviour and all
>     I see here is a support and triage nightmare. Not to mention
>     FB will move on to something else in a couple of years, and we
>     get stuck having to maintain it forever more (*cough*
>     filestreams *cough*).
>     
> Fair enough, what are your thoughts on rtdefault,

I don't think it's necessary. If you want automatic selection of
the target device based on the first allocation size, then the
first data allocation on a file will add the RT flag to the inode
before calling into the RT allocator....

> Or instead of a mount option, would a sysfs option be acceptable?

sysfs is preferable for options that are dynamically configurable.

> My hope is we don¹t move on, but collaborate a bit more with the
> open-source world on these sorts of problems instead of
> re-inventing the proverbial FS wheel (and re-learning old lessons
> solved many moons ago by FS developers).  Trying to do my part
> now, show it can be done and should be done.

Sure, nobody here has said what you are doing is conceptually
unsound. All of the comments have been about the implementation and
trying to understand what features from the implementation actually
provide you with the benefit. Then we can focus in on a solid,
maintainable solution...

>     > The other problem I see is accessibility and usability.  By making
>     > these decisions buried in more generic XFS allocation mechanisms
>     > or fnctl's, few developers are going to really understand how to
>     > safely use them (e.g. without blowing up their SSD's WAF or
>     > endurance). 
>     
>     The whole point of putting them into the XFS allocator as admin
>     policies is that *applications developers don't need to know they
>     exist*.
>     
> I get you now: *admins* need to know, but application developers not so much.

Yeah, exactly. Sorry for not making this clearer. In general, we
try to make the fs do the right thing by default and so tuning is
not necessary. But if tuning is necessary, the policy is set by the
admin and not the application as the admin knows a lot more about
their specific hardware and execution context than an application
developer.

>     In reality, we don't want people using fallocate - the
>     filesystem algorithms should do the right thing so people
>     don't need to modify their applications. In cases like this,
>     having the filesystem decide automatically at first allocation
>     what device to use is the right way to integrate the
>     functionality, not require users to use fallocate to trigger
>     such a decision and, as a side effect, prevent the filesystem
>     from making all the other optimisations they still want it to
>     make.
> 
> You make a good point here, on preventing the FS from making other
> optimizations.  I¹m re-working this as you and others have
> suggested (new version tomorrow).

OK.

> And xfs_fsr would be the home for code migrating the file to the
> real-time device once it grows beyond some tunable size.  

Keep in mind that the allocation xfs_fsr does will follow whatever
policy is currently in force. e.g. if a large file is on the wrong
device, then just running the existing defrag operation on it should
relocate the data to the correct device. Sure, fsr might need some
help to recognise what "wrong device" means in it's inode scan
routines, but the mechanism to move the data should be pretty much
unchanged...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
