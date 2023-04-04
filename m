Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D685C6FD1D
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Apr 2023 21:00:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234251AbjDDVAg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Apr 2023 17:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233755AbjDDVAg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Apr 2023 17:00:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E25B65275
        for <linux-xfs@vger.kernel.org>; Tue,  4 Apr 2023 14:00:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F4C363406
        for <linux-xfs@vger.kernel.org>; Tue,  4 Apr 2023 21:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 837EAC433D2;
        Tue,  4 Apr 2023 21:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680642009;
        bh=sqSPVGsfI8pnHobRehxPHT7ms48GALZu9emmoJfFAz0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YWja+BJCsJG2aljSiytseYR8YjpjiX/S6gQXMfaS2FJyNlEDFg0OF2rPwsfD0Fz1W
         J9wz5xPe1P3P6efr5hsnkhGYyvfcfcMUBBq3P4ZpAYLYyrEREdu9FpcgZabF7A94/M
         YszgtBUWIa2+iEogRmlUfkV5XLv+6JeRxIDQhdOyoGeQTOusnYQpJUN2r0prwbnGag
         fNjYakesQ1RdmfRf0A14MTaMHlXvs8VvUV1mmr5a+NWMYp+QFJ8DnFl8jW2Bak/jls
         No0UVo84WKFlHQqu4dfmM7WFkxowqN5iZwSGgAaWHpOX3LuVmMprtqKVTf3NdC7DGW
         t+6dVqv1n4ZaA==
Date:   Tue, 4 Apr 2023 14:00:09 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     david@fromorbit.com, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCHSET 0/3] xfs: fix ascii-ci problems with userspace
Message-ID: <20230404210009.GA303486@frogsfrogsfrogs>
References: <168062802052.174368.10967543545284986225.stgit@frogsfrogsfrogs>
 <20230404171715.GE109974@frogsfrogsfrogs>
 <CAHk-=wi2c0ezx_OR50h3R6+9+ECu3yDkrEuL34EobZ1b8pWnzQ@mail.gmail.com>
 <CAHk-=wiBm6VNykd5qH9y_SmL+Z8BJDXNwiny8Z0Yss86Wb6STw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHk-=wiBm6VNykd5qH9y_SmL+Z8BJDXNwiny8Z0Yss86Wb6STw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 04, 2023 at 01:21:25PM -0700, Linus Torvalds wrote:
> On Tue, Apr 4, 2023 at 11:19 AM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Limiting yourself to US-ASCII is at least technically valid. Because
> > EBCDIC isn't worth worrying about.  But when the high bit is set, you
> > had better not touch it, or you need to limit it spectacularly.
> 
> Side note: if limiting it to US-ASCII is fine (and it had better be,
> because as mentioned, anything else will result in unresolvable
> problems), you might look at using this as the pre-hash function:
> 
>     unsigned char prehash(unsigned char c)
>     {
>         unsigned char mask = (~(c >> 1) & c & 64) >> 1;
>         return c & ~mask;
>     }
> 
> which does modify a few other characters too, but nothing that matters
> for hashing.
> 
> The advantage of the above is that you can trivially vectorize it. You
> can do it with just regular integer math (64 bits = 8 bytes in
> parallel), no need to use *actual* vector hardware.
> 
> The actual comparison needs to do the careful thing (because '~' and
> '^' may hash to the same value, but obviously aren't the same), but
> even there you can do a cheap "are these 8 characters _possibly_ the
> same) with a very simple single 64-bit comparison, and only go to the
> careful path if things match, ie
> 
>     /* Cannot possibly be equal even case-insentivitely? */
>     if ((word1 ^ word2) & ~0x2020202020202020ul)
>         continue;
>     /* Ok, same in all but the 5th bits, go be careful */
>     ....
> 
> and the reason I mention this is because I have been idly thinking
> about supporting case-insensitivity at the VFS layer for multiple
> decades, but have always decided that it's *so* nasty that I really
> was hoping it just is never an issue in practice.

If it were up to me I'd invent a userspace shim fs that would perform
whatever normalizations are desired, and pass that (and ideally a lookup
hash) to the underlying kernel/fs.  Users can configure whatever
filtering they want and set LC_ALL as they please, and we kernel
developers never have to know, and the users never have to see what
actually gets written to disk.  If users want normalized ci lookups, the
shim can do that.

ext4 tried to do better than XFS by actually defining the mathematical
transformation that would be applied to incoming names and refusing
things that would devolve into brokenness, but then it turns out that it
was utf8_data.c.  Urgh.

I get it, shi* fses are not popular and are not fast, but if the Samba
benchmarks are still valid, multiple kernel<->fuserspace transitions are
still faster that their workaround.

> Particularly since the low-level filesystems then inevitably decide
> that they need to do things wrong and need a locale, and at that point
> all hope is lost.
> 
> I was hoping xfs would be one of the sane filesystems.

Hah, nope, I'm all out of sanity here. :(

--D

>                Linus
