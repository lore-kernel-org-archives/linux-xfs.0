Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ua0-f176.google.com ([209.85.217.176]:36078 "EHLO
        mail-ua0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751803AbdDMIMk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Apr 2017 04:12:40 -0400
Received: by mail-ua0-f176.google.com with SMTP id a1so29419574uaf.3
        for <linux-xfs@vger.kernel.org>; Thu, 13 Apr 2017 01:12:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170412174515.GO8502@birch.djwong.org>
References: <20170411141237.9274-1-jtulak@redhat.com> <20170411141237.9274-3-jtulak@redhat.com>
 <20170411223405.GC12369@dastard> <20170411234326.GA5109@birch.djwong.org>
 <20170412110633.GC6834@bfoster.bfoster> <20170412174515.GO8502@birch.djwong.org>
From: Jan Tulak <jtulak@redhat.com>
Date: Thu, 13 Apr 2017 10:12:18 +0200
Message-ID: <CACj3i70U1_Z+mkwc9EkQ+ThWqWrZmtQCqnnULpnVAbNJcZM2XA@mail.gmail.com>
Subject: Re: [PATCH 2/2] mdrestore: warn about corruption if log is dirty
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>

On Wed, Apr 12, 2017 at 7:45 PM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Wed, Apr 12, 2017 at 07:06:33AM -0400, Brian Foster wrote:
>> On Tue, Apr 11, 2017 at 04:43:26PM -0700, Darrick J. Wong wrote:
>> > On Wed, Apr 12, 2017 at 08:34:05AM +1000, Dave Chinner wrote:
>> > > On Tue, Apr 11, 2017 at 04:12:37PM +0200, Jan Tulak wrote:
>> > > > A dirty log in an obfuscated dump means that a corruption can happen
>> > > > when replaying the log (which contains unobfuscated data). Warn the user
>> > > > about this possibility.
>> > >
>> > > > The xlog workaround is copy&paste solution from repair/phase2.c and
>> > > > other tools, because the function is not implemented in libxlog.
>> > > >
>> > > > Signed-off-by: Jan Tulak <jtulak@redhat.com>
>> > >
>> > > I think this is overkill. mdrestore is not the place
>> > > to be interpreting the state of the dumped image - it is a basic
>> > > "restore the image" program, not a "check the validity of the image"
>> > > program.
>> > >
>> > > Secondly, if people are having problems with running log recovery on
>> > > a restored obfuscated image and getting corruption and not knowing
>> > > why or what to do, then that is a /documentation and training/
>> > > problem, not a code problem.
>> > >
>> > > i.e. the problem is that people who aren't developers are trying to
>> > > use tools that were written for developers to do forensic analysis
>> > > of failures. Don't dumb down the tool for clueless users - point the
>> > > users at the documentation that the tool requires to use correctly...
>> >
>> > Looking at the patch, that's a lot of code to add to mdrestore that has
>> > nothing to do with metadump restoration.  For that matter, who's to say
>> > that the metadump'd image is even an XFS filesystem, and not just some
>> > garbage with the just the right superblock values to pass the
>> > perform_restore() checks?  (Ok, ok, that was a little over the top.)
>> >
>>
>> Agreed wrt to the mdrestore bits...
>>
>> > The key change we're trying to make is to prevent people incorrectly
>> > replaying an XFS with a dirty log when the fs image has been restored
>> > from an obfuscated metadump.
>> >
>> > So in my mind this brings up two questions:  First, how do we prevent
>> > log replay in such situations?  Second, how do we teach people not to
>> > attempt log replay?  As you point out, it's better that we educate
>> > people as what problems each tool tries to solve and where the sharp
>> > edges might be on the debugging tools, but the answer to the first
>> > question ensures that us fallible developers can't do something stupid
>> > even though we theoretically know better.
>> >
>> > Frankly, if the goal is to nudge n00b members of support teams away from
>> > a behavior that won't help them towards starting their failure analysis,
>> > then then I think we ought to patch the log recovery code to detect an
>> > obfuscated fs image, complain to dmesg about someone making an illogical
>> > move, and then refuse to mount the log.
>> >
>>
>> I don't think this is really appropriate. Some users may very well have
>> no other option but to create a dirty log + obfuscated metadump for
>> whatever security/privacy reasons they have. The purpose of warning in
>> that case is to notify the user to either verify the resulting image
>> shows whatever problems are exhibited by the original fs and no others,
>> or to notify the developer that other corruption might exist and to
>> ignore it as a side effect of the metadump process itself (provided it
>> doesn't interfere with rca of the original problem). Refusing to run log
>> recovery in such cases just gets in the way.
>>
>> I'm not tied to having an mdrestore warning at all, but I'd much prefer
>> to see it there rather than include obfuscation logic in the kernel just
>> to facilitate a userspace tool to continue on silently corrupting
>> filesystem images.
>
> <nod> I've changed my mind overnight.  Now I agree that we could put a
> message in at metadump time, because it's not too late to ask the user
> to try to send us a metadump w/ clean log.  Eric also convinced me that
> it's not so trivial to detect an obfuscated image, so that simply won't
> work without a bunch of hackery.
>

Ok, I will send again only the dump patch with modified message (+ man
page update), without this mdrestore patch. That way it should pass
and meanwhile, we can continue here about what to do (if anything)
with mdrestore.

Jan

-- 
Jan Tulak
jtulak@redhat.com / jan@tulak.me
