Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC969C6FD18
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Mar 2023 01:57:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbjC3B5C (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Mar 2023 21:57:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbjC3B47 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Mar 2023 21:56:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55859618C
        for <linux-xfs@vger.kernel.org>; Wed, 29 Mar 2023 18:56:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E668C61EC7
        for <linux-xfs@vger.kernel.org>; Thu, 30 Mar 2023 01:56:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ABF7C433D2;
        Thu, 30 Mar 2023 01:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680141411;
        bh=fqyAAyxRcxvoS52JYXml48/xWr4ZwY8kz2rHKYmoq8I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ey2/OlM0qkOQxbSHVOLbvYR3ZP8q6xAF1xO/+xF52oMlWmX9g4VobK7+TS7tApPTJ
         3S9VMcqXrczYGZEU5c2hEiXBmdaglT73Gk+gSxBizNlNfCWPepvfk4OZpDMTsvoSY0
         du8UksU68ohZ7SMooXAUlLnC7tv3XyfMD1ABNiLTTanjITZfb17y/RZ2CxdLCrALXS
         YEEeolqsD2+jJAzIy0KVJsKrYWp4LgajSJNrCoqRwj4fJEhkcDz6f5bvgBzm9bkxdj
         rHhFqdTW6oT20p/tSAXuU4eiDH8Q7DqoMEDz+MM+9XPc7Tm3yMREPcJ7AQz+Snh5w/
         2hxYFm+N6sGkw==
Date:   Wed, 29 Mar 2023 18:56:50 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCHSET v10r1d2 00/17] xfs: encode parent pointer name in
 xattr key
Message-ID: <20230330015650.GB4126677@frogsfrogsfrogs>
References: <167899414339.15363.12404998880107296432.stgit@frogsfrogsfrogs>
 <6e6f7948dfdeac87accb8cd437f0c22d21a2e8e0.camel@oracle.com>
 <CAOQ4uxhVgPt93Wi3Z577gncWSxOE8S0fq5aasLJbffk8Rkg-GQ@mail.gmail.com>
 <20230325170106.GA16180@frogsfrogsfrogs>
 <CAOQ4uxj4ZwdCps2qFZCn9hTWcEaq1xUSJs=f1N5B4H4stayDPQ@mail.gmail.com>
 <20230328012932.GE16180@frogsfrogsfrogs>
 <20230328222959.GD3223426@dread.disaster.area>
 <20230328235449.GB991605@frogsfrogsfrogs>
 <20230329001900.GE3223426@dread.disaster.area>
 <20230329004633.GI16180@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230329004633.GI16180@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 28, 2023 at 05:46:33PM -0700, Darrick J. Wong wrote:
> On Wed, Mar 29, 2023 at 11:19:00AM +1100, Dave Chinner wrote:
> > On Tue, Mar 28, 2023 at 04:54:49PM -0700, Darrick J. Wong wrote:
> > > On Wed, Mar 29, 2023 at 09:29:59AM +1100, Dave Chinner wrote:
> > > > On Mon, Mar 27, 2023 at 06:29:32PM -0700, Darrick J. Wong wrote:
> > > > > On Sun, Mar 26, 2023 at 06:21:17AM +0300, Amir Goldstein wrote:
> > > > > > On Sat, Mar 25, 2023 at 8:01 PM Darrick J. Wong <djwong@kernel.org> wrote:
> > > > > > > On Sat, Mar 25, 2023 at 10:59:16AM +0300, Amir Goldstein wrote:
> > > > > > > > On Fri, Mar 24, 2023 at 8:19 PM Allison Henderson
> > > > > > > > <allison.henderson@oracle.com> wrote:
> > > > > > Right.
> > > > > > So how about
> > > > > > (parent_ino, parent_gen, dirent_hash) -> (dirent_name)
> > > > > > 
> > > > > > This is not a breaking change and you won't need to do another
> > > > > > breaking change later.
> > > > > > 
> > > > > > This could also be internal to VLOOKUP: appended vhash to
> > > > > > attr name and limit VLOOKUP name size to  255 - vhashsize.
> > > > > 
> > > > > The original "put the hash in the xattr name" patches did that, but I
> > > > > discarded that approach because it increases the size of each parent
> > > > > pointer by 4 bytes, and was really easy to make a verrrry slow
> > > > > filesystem:
> > > > 
> > > > Right, that's because hash collision resolution is very dumb. It's
> > > > just a linear walk from start to end comparing the names of each
> > > > coliding entry.
> > > > 
> > > > > I wrote an xfs_io command to compute lists of names with the same
> > > > > dirhash value.  If I created a giant directory with the same file
> > > > > hardlinked millions of times where all those dirent names all hash to
> > > > > the same value, lookups in the directory gets really slow because the
> > > > > dabtree code has to walk (on average) half a million dirents to find the
> > > > > matching one.
> > > > 
> > > > That's worst case behaviour, not real-world production behaviour.
> > > > It's also a dabtree optimisation problem, not a parent pointer
> > > > problem. i.e. if this is a real world issue, we need to fix the
> > > > dabtree indexing, not work around it in the parent pointer format.
> > > > 
> > > > IOWs, optimising the parent pointer structure for the *rare* corner
> > > > case of an intentionally crafted dahash btree collision farm is, to
> > > > me, the wrong way to design a structure.
> > > > 
> > > > Optimising it for the common fast path (single parent xattrs,
> > > > followed by small numbers of parents) is what we should be doing,
> > > > because that situation will occur an uncountable number of times
> > > > more frequently than this theorectical worst case behaviour. i.e.
> > > > the worst case will, in all likelihood, never happen in production
> > > > environments - behaviour in this circumstance is only a
> > > > consideration for mitigating malicious attacks.
> > > > 
> > > > And, quite frankly, nobody is going to bother attacking a filesystem
> > > > this way - there is literally nothing that can be gained from
> > > > slowing down access to a single directory in this manner. It's a DOS
> > > > at best, but there are *much* easier ways of doing that and it
> > > > doesn't require parent pointers or dahash collisions at all.
> > > > 
> > > > 
> > > > > 
> > > > > There were also millions of parent pointer xattrs, all with the same
> > > > > attr name and hence the same hash value here too.  Doing that made the
> > > > > performance totally awful.  Changing the hash to crc32c and then sha512
> > > > > made it much harder to induce collision slowdowns on both ends like
> > > > > that, though sha512 added a noticeable performance hit for what it was
> > > > > preventing.
> > > > 
> > > > So why not change the dahash for parent pointer enabled filesystems
> > > > to use crc32c everywhere?
> > > 
> > > That's not difficult to do, but it'll break name obscuring in metadump
> > > unless you know of a quick way to derive B from A and maintain crc32c(A)
> > > == crc32c(B).

Yeah.  So I've sort of figured out how to spoof crc32c in much the same
way that obfuscate_name() does for the dahash -- fill a buffer with
replacement characters, figure out which bits to flip to end up with the
same crc at the end.  I quickly found Mark Adler's spoof program which
seems to work more reliably.

But after a bit of performance comparison, I realized that constructing
namehash collisions with same-length strings is about as computationally
easy with crc32c as it is with the dahash.  This isn't any better than
what we have now.  I ran a dumb benchmark of the kernel crc32c
implementation vs. dahash and noticed that for the sizes we care about
(i.e. 255 bytes or less) the old dahash is only slightly slower than
hardware accelerated crc32c.

I then noticed that obfuscate_name() totally does the wrong thing if
ascii-ci is enabled, and indeed, trying to metadump such a filesystem
causes metadump to throw errors all over the place.

In short: doing this doesn't buy us anything, but now someone has to
implement a robust obfuscate_name() for crc32c and we have more software
to maintain.

> > Not easily, but....
> > 
> > > Granted I had mostly written off name obscuring in metadump on parent
> > > pointer filesystems anyway.
> > 
> > ... so had I. The name obfuscation needs a completely different
> > approach for PP enabled filesystems because of the name also being
> > embedded in non-user visible structures and potentially changing
> > attr tree dahash-based indexing.
> 
> <nod> I've wondered if we just have to record (dir_ino/name) ->
> (newname) and use that to update the parent pointer and any dabtree
> entries we find.  That's going to be a bit of a mess to iron out since
> we can't change the "mounted" filesystem.

For now I've fixed this by implementing a gigantic name remapping table
so that we remember (dir_ino, old_name, new_name) tuples.  When we
encounter the equivalent parent pointer, we can use the exact same
obfuscated name, which means that xfs_repair on a restored obscured
metadump works again.

While I was at it, I also implemented a 'parent' command for xfs_db that
dumps the parents of any inode, similar to the existing xfs_io command.

> > > > I'd much prefer we have a parent pointer index key that is fixed
> > > > length, has constant hash time and a dabtree hash that is far more
> > > > resilient to collision farming than to have to perform
> > > > encoding/decoding of varaible length values into the key to work
> > > > around a collision-rich hashing algorithm.
> > > 
> > > Wellllll I was 10 minutes away from sending v11 with all of my changes
> > > integrated, but I guess now I'll go rework the dabtree to use crc32c,
> > > encode the crc32c in the parent pointer attr name, and get rid of all
> > > the variable length value decoding.  Now that I just got rid of all the
> > > intermediate patches with hash-in-attr-name.
> > 
> > I apologise for not being able to comment on this earlier. What time
> > I've had available over the past coule of weeks has been focussed on
> > the parts of the repair patchset that are ready for merge and I've
> > had little time to follow the progress of the parts you are
> > currently developing.
> 
> <nod> Sorry, that was my kneejerk reaction to "let's go reopen this
> thing and go back to where you were a week ago".  I appreciate yuor
> help getting the online repair patchset ready for merge.
> 
> In the end it took about half an hour to put everything back, so I'll go
> test that overnight and let's see where we end up tomorrow.

Now that I've had a day to go sift through all of these changes, I've
realized that you're right -- putting the ondisk format back to:

   (parent_ino, parent_gen, namehash) -> (dirent name)

Simplifes the parent pointer ondisk conversion and runtime code quite a
bit.  It also makes it easy to implement obfuscated metadumps.  So I'll
go run v11 through fstestscloud with all of today's changes integrated,
and we'll see about getting something out in a few days.

Again, sorry for being a jerk.

--D

> --D
> 
> > -Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
