Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD193C77B60
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Apr 2023 18:35:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbjDDSfD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Apr 2023 14:35:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236383AbjDDSe2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Apr 2023 14:34:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43F685BB6
        for <linux-xfs@vger.kernel.org>; Tue,  4 Apr 2023 11:32:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C271B63557
        for <linux-xfs@vger.kernel.org>; Tue,  4 Apr 2023 18:32:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A11FC433D2;
        Tue,  4 Apr 2023 18:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680633135;
        bh=SVzNfO0iU41+v0b29KhgDJgnREYVUY8Ye77ODgy2I88=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bsPhcGqesFofj0ZoMbEy6km225UWcEZT8lb4ZTdjO88K0DYLbNTAJ/W1obiLsGlW7
         uGVtEypzxzBL/mYfpIUubXINS9l2Z0r3pAvIQGa32IXkBE/6kMcpwTGii0iKt737JK
         d+v9h4jCMJX0FR/2nhcM+GGV6a+NY3nd+nB6Tds4r1eJdqalp3pJy9nyogZCsJT1jL
         jU9F7IDeaXVTolFM4T2wxipO3GhH/NuOCqBaRgLzwuFTC2lSKrOMC08r5VtrM2fSvP
         G352hnc4Fcvq3CwmELxDuKqWdYy3l3h4vGS0rNb3QJxnU/ka2VS+tWGhMahJvY0C/W
         kT0LFONQvbzuQ==
Date:   Tue, 4 Apr 2023 11:32:14 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 1/3] xfs: stabilize the tolower function used for
 ascii-ci dir hash computation
Message-ID: <20230404183214.GG109974@frogsfrogsfrogs>
References: <168062802052.174368.10967543545284986225.stgit@frogsfrogsfrogs>
 <168062802637.174368.12108206682992075671.stgit@frogsfrogsfrogs>
 <CAHk-=whe9kmyMojhse3cZ-zpHPfvGf_bA=PzNfuV0t+F5S1JxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHk-=whe9kmyMojhse3cZ-zpHPfvGf_bA=PzNfuV0t+F5S1JxA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 04, 2023 at 10:54:27AM -0700, Linus Torvalds wrote:
> On Tue, Apr 4, 2023 at 10:07 AM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > +       if (c >= 0xc0 && c <= 0xd6)     /* latin A-O with accents */
> > +               return true;
> > +       if (c >= 0xd8 && c <= 0xde)     /* latin O-Y with accents */
> > +               return true;
> 
> Please don't do this.
> 
> We're not in the dark ages any more. We don't do crazy locale-specific
> crud. There is no such thing as "latin1" any more in any valid model.
> 
> For example, it is true that 0xC4 is 'Ä' in Latin1, and that the
> lower-case version is 'ä', and you can do the lower-casing exactly the
> same way as you do for US-ASCII: you just set bit 5 (or "add 32" or
> "subtract 0xE0" - the latter is what you seem to do, crazy as it is).
> 
> So the above was fine back in the 80s, and questionably correct in the
> 90s, but it is COMPLETE GARBAGE to do this in the year 2023.

Yeah, I get that.  Fifteen years ago, Barry Naujok and Christoph merged
this weird ascii-ci feature for XFS that purportedly does ... something.
It clearly only works properly if you force userspace to use latin1,
which is totally nuts in 2023 given that the distros default to UTF8
and likely don't test anything else.  It probably wasn't even a good
idea in *2008*, but it went in anyway.  Nobody tested this feature,
metadump breaks with this feature enabled, but as maintainer I get to
maintain these poorly designed half baked projects.

I wouldn't ever enable this feature on any computer I use, and I think
the unicode case-insensitive stuff that's been put in to ext4 and f2fs
lately are not a tarpit that I ever want to visit in XFS.  Directory
names should be sequences of bytes that don't include nulls or slashes,
end of story.

Frankly, I'd rather just drop the entire ascii-ci feature from XFS.  I
doubt anyone's really using it given that xfs_repair will corrupt the
filesystem.  This patch encodes the isupper/tolower code from the
kernel's lib/ctype.c into libxfs so that repair will stop corrupting
these filesystems, nothing more.

We're not introducing any new functionality, just making stupid code
less broken.  I wasn't around let alone maintainer when this feature was
committed, and I wouldn't let it in now.  I am, however, the stuckee who
has to clean up all this shit in the least impactful way I can devise.

Can we instead simply drop ascii-ci support from Linux 6.3i and abruptly
break all those filesystems?  Even though we're past -rc5 now?  That
would make all of this baloney go away, at a cost of breaking userspace.

> Because 'Ä' today is *not* 0xC4. It is "0xC3 0x84" (in the sanest
> simplest form), and your crazy "tolower" will turn that into "0xE3
> 0x84", and that not only is no longer 'ä', it's not even valid UTF-8
> any  more.
> 
> I realize that filesystem people really don't get this, but
> case-insensitivity is pure and utter CRAP. Really. You *cannot* do
> case sensitivity well. It's impossible. It's either locale-dependent,
> or you have to have translation models for Unicode characters that are
> horrifically slow and even then you *will* get it wrong, because you
> will start asking questions about normalization forms, and the end
> result is an UNMITIGATED DISASTER.

Agreed!

> I wish filesystem people just finally understood this.  FAT was not a
> good filesystem.  HFS+ is garbage. And any network filesystem that
> does this needs to pass locale information around and do it per-mount,
> not on disk.
> 
> Because you *will* get it wrong. It's that simple. The only sane model
> these days is Unicode, and the only sane encoding for Unicode is
> UTF-8, but even given those objectively true facts, you have
> 
>  (a) people who are going to use some internal locale, because THEY
> HAVE TO. Maybe they have various legacy things, and they use Shift-JIS
> or Latin1, and they really treat filenames that way.
> 
>  (b) you will have people who disagree about normal forms. NFC is the
> only sane case, but you *will* have people who use other forms. OS X
> got this completely wrong, and it causes real issues.
> 
>  (c) you'll find that "lower-case" isn't even well-defined for various
> characters (the typical example is German 'ß', but there are lots of
> them)
> 
>  (d) and then you'll hit the truly crazy cases with "what about
> compatibility equivalence". You'll find that even in English with NBSP
> vs regular SPACE, but it gets crazy.
> 
> End result: the only well-defined area is US-ASCII. Nothing else is
> even *remotely* clear. Don't touch it. You *will* screw up.
> 
> Now, if you *only* use this for hashing, maybe you will feel like "you
> will screw up" is not such a big deal.
> 
> But people will wonder why the file 'Björn' does not compare equal to
> the file 'BJÖRN' when in a sane locale, but then *does* compare equal
> if they happen to use a legacy Latin1 one.
> 
> So no. Latin1 isn't that special, and if you special-case them, you
> *will* screw up other locales.
> 
> The *only* situation where 'tolower()' and 'toupper()' are valid is
> for US-ASCII.
> 
> And when you compare to glibc, you only compare to "some random locale
> that happens to be active rigth n ow". Something that the kernel
> itself cannot and MUST NOT do.

What then is the point of having tolower in the kernel at all?

--D

>                 Linus
