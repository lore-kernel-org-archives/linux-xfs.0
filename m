Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33248 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752532AbeD3Kaz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Apr 2018 06:30:55 -0400
Received: by mail-wm0-f67.google.com with SMTP id x12so10884218wmc.0
        for <linux-xfs@vger.kernel.org>; Mon, 30 Apr 2018 03:30:54 -0700 (PDT)
Date: Mon, 30 Apr 2018 12:30:50 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [RFC PATCH] db: Stop core dumping on attr3 if block header is
 not recognized
Message-ID: <20180430103050.4z4waenrvxyo2ld5@odin.usersys.redhat.com>
References: <20180418094935.12495-1-cmaiolino@redhat.com>
 <9514c503-e5ba-3ca0-dd5d-83d4c81f97f5@sandeen.net>
 <20180423082646.wmz4vkhhuysdbepd@odin.usersys.redhat.com>
 <aba7b7cd-e6ec-62c1-dfac-b7c3e87ed2f9@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aba7b7cd-e6ec-62c1-dfac-b7c3e87ed2f9@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Mon, Apr 23, 2018 at 08:54:37AM -0600, Eric Sandeen wrote:
> 
> 
> On 4/23/18 2:26 AM, Carlos Maiolino wrote:
> >> So it seems like casting it into something the user might expect would
> >> be better?
> >>
> > Not sure, in this case, the 'user' is expaecting an attr3 type, while xfs_db is
> > reading some other random, non attr3 type block. So, I wonder, what you meant by
> > 'something the user might expect'? The way I view it is: "The user is expecting
> > attr3 type", but there is no attr3 data in the block being read, so, the way I
> > understand what you meant, was trying to print the current block using attr3
> > format, which, IMHO, might fool the xfs_db user. I think saying the block
> > doesn't match attr3 format, and printing a possible magic number found in the
> > block works better. After all, xfs_db is a developer tool, not an user tool. If
> > I use myself and my xfs_db usage as an example:
> > If I try to print some block as attr3, and I see a message saying no attr3
> > format has been found, and I got a dump of a possible magic number, I can check
> > if that magic number matches some metadata format, or if it doesn't look as a
> > magic at all, I can simply consider the block corrupted. But well, this is just
> > my way to view it.
> > 
> 
> So, don't get too hung up on your "it's not actually an attr3 block" testcase;
> imagine the scenario where it /is/ an attr3 block, but the magic is
> corrupted.  Now imagine that you want to examine the block (to see what the magic
> was, and what the other fields were, and if it even looks like an attr3 block,
> or something else), and possibly even fix a field manually.
> 
> If all you get is "unknown" that's not very helpful.  You /could/ hexdump it
> and count bytes, but that sucks.
> 
> If you tried the same thing on i.e. an agf header (with bitflipped magic) you
> would still be able to print the whole structure, and see what was wrong.
> 
> Because attr3 only prints semi-validated blocks today, and refuses to show you
> anything that doesn't match, it's a far more difficult situation.  The root
> cause is that "attr3" is a multiplexer that will really decide between 3 different
> formats, but will /only/ show you one of the 3 if the magic is undamaged.
> 
> That's why I was wondering about explicit types for the leaf/block etc so you
> can force xfs_db to show it to you in that format (like you could with i.e. agf).
> 

Got your concern, and I agree, I can work on it if you are not in a hurry to get
it merged.

> Meh, for now maybe I will just merge the "don't segfault" patch, it's at least an
> improvement.  A nicer outcome isn't our most pressing problem I guess.
>

That would be great, I can work on the leaf/block separation in the meantime
without having my xfs_db crashing on it :)

Cheers
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
