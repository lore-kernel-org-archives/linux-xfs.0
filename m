Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f48.google.com ([209.85.221.48]:37785 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728732AbeJWBpy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Oct 2018 21:45:54 -0400
Received: by mail-wr1-f48.google.com with SMTP id g9-v6so4577767wrq.4
        for <linux-xfs@vger.kernel.org>; Mon, 22 Oct 2018 10:26:29 -0700 (PDT)
MIME-Version: 1.0
From: Jan Tulak <jtulak@redhat.com>
Date: Mon, 22 Oct 2018 19:26:17 +0200
Message-ID: <CACj3i73FyABTkX1eCDvL+ccUhD1kWowS92=PFVyGiPvi6HWGFQ@mail.gmail.com>
Subject: xfsdump cleaning patchset
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>
Cc: Eric Sandeen <sandeen@sandeen.net>

Hi guys

I did some xfsdump cleaning where I focused on getting rid of all the
memory leaks reported by Coverity. There is still a lot of things to
do for another time: issues by Coverity that were not fixed in this
set, sprintf -> snprintf because there is a plenty of places for
buffer overflow, etc...

The set has about 30 patches, so I won't spam the mailing list with
the first iteration of review and instead, I uploaded it here:
https://github.com/jtulak/xfsdump/tree/for-review


The changes:

- Whitespace fixes. After speaking with Eric and because nobody
touches xfsdump anyway, I run a few sed commands and tried to fix the
crazy indentation to kernel style. It was an automated replacement, so
there can be places where it didn't work as intended, but in overall,
it helps with readability. Other whitespace issues I tackled are
trailing whitespaces.

- A lot of free(ptr) and close(fd). Xfsdump did not clean on errors,
so most of these are added to return -ERR; statements. These
after-error leaks were not an issue on itself, but it really polluted
the Coverity output.

- Other changes like dead code removal, null dereference, or
enlargement of a too small buffer for snprintf.


The patches are organised in this way:

- Whitespace issues are in two patches (indentation and trailing spaces).
- Resource leaks are one patch per file, with Coverity issue IDs (CID)
mentioned in the commit message for issues reported by the web scan. I
also used a custom instance of Coverity that reported some other
leaks, and those do not have any CID. If that seems still too
cluttered, I can break it to one patch per function, but that might
produce too many commits with two or three changes.
- And the remaining changes, like a dead code removal, are one patch
per issue/CID


I tested it as I could, but xfstests coverage is not large and part of
the tests requires a tape I don't have anyway. I also tested it with
valgrind to see if any errors got introduced, and from this
comparison, it came out clean (as much as I can tell when valgrind
throws 2k errors on me both pre and post patch).


Have a look.

Cheers,
Jan
--
Jan Tulak
