Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:38374 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726108AbeJ3V3o (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 30 Oct 2018 17:29:44 -0400
Subject: Re: [PATCH 0/5] v4 Try to squash metadump data leaks
References: <20181026201943.24131-1-stefanrin@gmail.com>
 <3e653734-6470-3160-58e8-5bdf866dbd87@sandeen.net>
 <5228ed5f-b238-1596-a829-6bf482da7e2b@sandeen.net>
 <CAAxjCExbUX1hDDV_0yK5Uu1eGf3aC8XT0CN-eL66+9GNDtdRVg@mail.gmail.com>
 <4f1f1db3-8689-dff1-3845-0a3e582fd849@sandeen.net>
 <CAAxjCEzE9dkTHQ7hZuUnTpNMCs4AzusFKyxejy1h8ZMXz3n8Qg@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <f003934c-025f-845c-6836-36f5b4a7e10f@sandeen.net>
Date: Tue, 30 Oct 2018 07:36:26 -0500
MIME-Version: 1.0
In-Reply-To: <CAAxjCEzE9dkTHQ7hZuUnTpNMCs4AzusFKyxejy1h8ZMXz3n8Qg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Stefan Ring <stefanrin@gmail.com>
Cc: linux-xfs@vger.kernel.org



On 10/30/18 7:29 AM, Stefan Ring wrote:
> On Sun, Oct 28, 2018 at 6:13 PM Eric Sandeen <sandeen@sandeen.net> wrote:
>> Check patch 2 as well, the "break;" is also causing corruption I think,
>> and it should probably just be a no-op ";"
> 
> Sorry about that. I think it's more than that. The single_fsb function
> takes care to only write something out when there is something to
> write and to only recalculate the crc when there has been a change.
> I'd like to carry over this spirit, but I have the impression that in
> the end the two functions would become so similar that they will just
> merge into one.

I think the "recalculate crc" flagging is a little inconsistent, tbh - 
or maybe I should say it consistently recalculates it more often than it
needs to?  It probably makes sense to follow the existing examples of
when it's set, and if there's any cleanup/optimization to do, that can
be done later.

-Eric
