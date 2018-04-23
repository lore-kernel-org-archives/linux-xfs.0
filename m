Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:60100 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755419AbeDWOyj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Apr 2018 10:54:39 -0400
Received: from Liberator-5.local (174-23-155-86.slkc.qwest.net [174.23.155.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id DFBFE4872F9
        for <linux-xfs@vger.kernel.org>; Mon, 23 Apr 2018 09:53:36 -0500 (CDT)
Subject: Re: [RFC PATCH] db: Stop core dumping on attr3 if block header is not
 recognized
References: <20180418094935.12495-1-cmaiolino@redhat.com>
 <9514c503-e5ba-3ca0-dd5d-83d4c81f97f5@sandeen.net>
 <20180423082646.wmz4vkhhuysdbepd@odin.usersys.redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <aba7b7cd-e6ec-62c1-dfac-b7c3e87ed2f9@sandeen.net>
Date: Mon, 23 Apr 2018 08:54:37 -0600
MIME-Version: 1.0
In-Reply-To: <20180423082646.wmz4vkhhuysdbepd@odin.usersys.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org



On 4/23/18 2:26 AM, Carlos Maiolino wrote:
>> So it seems like casting it into something the user might expect would
>> be better?
>>
> Not sure, in this case, the 'user' is expaecting an attr3 type, while xfs_db is
> reading some other random, non attr3 type block. So, I wonder, what you meant by
> 'something the user might expect'? The way I view it is: "The user is expecting
> attr3 type", but there is no attr3 data in the block being read, so, the way I
> understand what you meant, was trying to print the current block using attr3
> format, which, IMHO, might fool the xfs_db user. I think saying the block
> doesn't match attr3 format, and printing a possible magic number found in the
> block works better. After all, xfs_db is a developer tool, not an user tool. If
> I use myself and my xfs_db usage as an example:
> If I try to print some block as attr3, and I see a message saying no attr3
> format has been found, and I got a dump of a possible magic number, I can check
> if that magic number matches some metadata format, or if it doesn't look as a
> magic at all, I can simply consider the block corrupted. But well, this is just
> my way to view it.
> 

So, don't get too hung up on your "it's not actually an attr3 block" testcase;
imagine the scenario where it /is/ an attr3 block, but the magic is
corrupted.  Now imagine that you want to examine the block (to see what the magic
was, and what the other fields were, and if it even looks like an attr3 block,
or something else), and possibly even fix a field manually.

If all you get is "unknown" that's not very helpful.  You /could/ hexdump it
and count bytes, but that sucks.

If you tried the same thing on i.e. an agf header (with bitflipped magic) you
would still be able to print the whole structure, and see what was wrong.

Because attr3 only prints semi-validated blocks today, and refuses to show you
anything that doesn't match, it's a far more difficult situation.  The root
cause is that "attr3" is a multiplexer that will really decide between 3 different
formats, but will /only/ show you one of the 3 if the magic is undamaged.

That's why I was wondering about explicit types for the leaf/block etc so you
can force xfs_db to show it to you in that format (like you could with i.e. agf).

Meh, for now maybe I will just merge the "don't segfault" patch, it's at least an
improvement.  A nicer outcome isn't our most pressing problem I guess.

-Eric
