Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:58560 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751685AbdDLBsd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 Apr 2017 21:48:33 -0400
Subject: Re: [PATCH 2/2] mdrestore: warn about corruption if log is dirty
References: <20170411141237.9274-1-jtulak@redhat.com>
 <20170411141237.9274-3-jtulak@redhat.com> <20170411223405.GC12369@dastard>
 <20170411234326.GA5109@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <0baf80cd-08d8-8238-95d1-5895cd1b4c22@sandeen.net>
Date: Tue, 11 Apr 2017 20:48:32 -0500
MIME-Version: 1.0
In-Reply-To: <20170411234326.GA5109@birch.djwong.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>
Cc: Jan Tulak <jtulak@redhat.com>, linux-xfs@vger.kernel.org

On 4/11/17 6:43 PM, Darrick J. Wong wrote:
> On Wed, Apr 12, 2017 at 08:34:05AM +1000, Dave Chinner wrote:
>> On Tue, Apr 11, 2017 at 04:12:37PM +0200, Jan Tulak wrote:
>>> A dirty log in an obfuscated dump means that a corruption can happen
>>> when replaying the log (which contains unobfuscated data). Warn the user
>>> about this possibility.
>>
>>> The xlog workaround is copy&paste solution from repair/phase2.c and
>>> other tools, because the function is not implemented in libxlog.
>>>
>>> Signed-off-by: Jan Tulak <jtulak@redhat.com>
>>
>> I think this is overkill. mdrestore is not the place
>> to be interpreting the state of the dumped image - it is a basic
>> "restore the image" program, not a "check the validity of the image"
>> program.
>>
>> Secondly, if people are having problems with running log recovery on
>> a restored obfuscated image and getting corruption and not knowing
>> why or what to do, then that is a /documentation and training/
>> problem, not a code problem.
>>
>> i.e. the problem is that people who aren't developers are trying to
>> use tools that were written for developers to do forensic analysis
>> of failures. Don't dumb down the tool for clueless users - point the
>> users at the documentation that the tool requires to use correctly...
> 
> Looking at the patch, that's a lot of code to add to mdrestore that has
> nothing to do with metadump restoration.

(tl;dr: slightly different approach suggested at the end)

So, yeah.  I hadn't really thought about the bulk of code when I made
the suggestion.  The whole "given a device or file, get to a libxfs_mount"
thing is repeated enough that I wonder if it shouldn't find its way
into some factored code, which would make it nicer to read, at least.
That doesn't address the issue of linking with new libs, or the
overall elegance of the tool, though.

> The key change we're trying to make is to prevent people incorrectly
> replaying an XFS with a dirty log when the fs image has been restored
> from an obfuscated metadump.

Yeah, the way this started was a metadump from the field which ended
up "showing" corruption which was only a side-effect of this situation.

I had never considered this outcome; Brian diagnosed it and I don't
know if it was obvious to him either.  It clearly wasn't obvious to
support personnel.  I'm not sure I've ever seen it before, and I have
replayed obfuscated metadumps.  And yes, we could talk about "better
training" but in reality "you should have read the docs we just updated!"
only goes so far.

We have a lot of warnings to help people not use tools in bad ways
or that duplicate information from a manpage, if it's highly
relevant to that point of operation:

"Filesystem log is dirty; image will contain unobfuscated metadata in log."

"ERROR: The log head and/or tail cannot be discovered. Attempt to mount the
filesystem to replay the log or use the -L option to destroy the log and
attempt a repair."

"Only one AG detected - cannot validate filesystem geometry.
Use the -o force_geometry option to proceed."

Handed a metadump, AFAIK there is obvious way to even /know/ whether
it's safe to replay the log.  It would involve a mount -ro,norecovery
and intuiting that the filenames are obfuscated, or digging in with
xfs_db, coupled with more xfs_db work or logprint to see if the log
is even dirty, etc.

Anyway, there seem to be two intertwined objections:

1) xfs_metadump has no business cracking open the image log, and
2) xfs_metadump has no business alerting the user to this situation

I'm pretty sympathetic to the first argument, a little less so to the second.

> So in my mind this brings up two questions:  First, how do we prevent
> log replay in such situations?  Second, how do we teach people not to
> attempt log replay?

(honestly, in many cases log replay is fine, right?)

>  As you point out, it's better that we educate
> people as what problems each tool tries to solve and where the sharp
> edges might be on the debugging tools, but the answer to the first
> question ensures that us fallible developers can't do something stupid
> even though we theoretically know better.
> 
> Frankly, if the goal is to nudge n00b members of support teams away from
> a behavior that won't help them towards starting their failure analysis,
> then then I think we ought to patch the log recovery code to detect an
> obfuscated fs image, complain to dmesg about someone making an illogical
> move, and then refuse to mount the log.

(I think I like that less than the current approach; if given a choice
beetween cruft in userspace or kernelspace I'll take userspace each
time ;) but I see what you mean about denying at the point of potential
failure...)

> I'd rather push back on the incorrect behavior at the time it is done,
> instead of training people to ignore a priori warning messages.

I don't think that a:

 WARNING: Replaying the log on this image may corrupt the filesystem!

would be ignored, tbh.

Anyway -

My hope here was to alert the person handling the metadump that it may
require special handling.  I don't think we need that warning on the
xfs_metadump side; it's not that user's concern (the unobfuscated
data /is/ their privacy concern.)

What if we used the mb_reserved field in the first metablock header
as a short flags field to indicate OBFUSCATED | DIRTY_LOG | XXX???
and fill it in at metadump time, so that the state of the metadump
can be trivially indicated and/or observed without all the somewhat
inappropriate extra libxfs/libxlog code baggage?  

I see value in that by itself, because the recipient of a metadump
doesn't /really/ know what they've been handed; what (if any) messages
we present to the mdrestore user based on that information could be
debated later.

-Eric
