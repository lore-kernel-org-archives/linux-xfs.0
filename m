Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:37642 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727607AbeJZVN0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 26 Oct 2018 17:13:26 -0400
Subject: Re: [PATCH v3 0/2] Try to squash metadump data leaks
References: <20181011194424.20306-1-stefanrin@gmail.com>
 <5209fec0-c7b3-ae1f-a909-23adfdee1072@sandeen.net>
 <69b32a73-f6c1-8991-af1e-d1818266c985@sandeen.net>
 <CAAxjCEwKqkK6RuE34tXXW=hZXyw5JsU2bhVh73ZRfyW2rGxmXQ@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <db5b1207-0b8f-cbc6-370f-c2c9d07e8407@sandeen.net>
Date: Fri, 26 Oct 2018 07:36:28 -0500
MIME-Version: 1.0
In-Reply-To: <CAAxjCEwKqkK6RuE34tXXW=hZXyw5JsU2bhVh73ZRfyW2rGxmXQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Stefan Ring <stefanrin@gmail.com>
Cc: linux-xfs@vger.kernel.org



On 10/26/18 12:29 AM, Stefan Ring wrote:
> On Fri, Oct 26, 2018 at 2:36 AM Eric Sandeen <sandeen@sandeen.net> wrote:
>>> Hm, I think another case we're missing is interior nodes on multi-fsb objects,
>> i.e. everything under /* Zero unused part of interior nodes */ seems to be
>> missing for the process_multi_fsb_objects case as well.  Urk, what a mess.
> 
> It is a classic game of whack-a-mole ;). I do understand that it is
> this way for historical reasons, but if it would be redone today, it
> should obviously use zeroed buffers for writing out and copy just the
> bits that are known to be needed.

Yeah, I was thinking about that last night.  I'm not sure it'd be a whole
lot easier, though - for every single type of metadata block we either
need to zap the holes or copy the bits, but every boundary is the same
and would need to be computed and handled regardless.
I'm not sure it'd be a win.

-Eric
