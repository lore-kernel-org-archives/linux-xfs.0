Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:54482 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727868AbeJ2B6V (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 28 Oct 2018 21:58:21 -0400
Subject: Re: [PATCH 0/5] v4 Try to squash metadump data leaks
References: <20181026201943.24131-1-stefanrin@gmail.com>
 <3e653734-6470-3160-58e8-5bdf866dbd87@sandeen.net>
 <5228ed5f-b238-1596-a829-6bf482da7e2b@sandeen.net>
 <CAAxjCExbUX1hDDV_0yK5Uu1eGf3aC8XT0CN-eL66+9GNDtdRVg@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <4f1f1db3-8689-dff1-3845-0a3e582fd849@sandeen.net>
Date: Sun, 28 Oct 2018 12:13:07 -0500
MIME-Version: 1.0
In-Reply-To: <CAAxjCExbUX1hDDV_0yK5Uu1eGf3aC8XT0CN-eL66+9GNDtdRVg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Stefan Ring <stefanrin@gmail.com>
Cc: linux-xfs@vger.kernel.org



On 10/28/18 7:38 AM, Stefan Ring wrote:
> On Sat, Oct 27, 2018 at 1:33 AM Eric Sandeen <sandeen@sandeen.net> wrote:
>>
>> Also, here's an old script I had lying around to test metadump.  It's hacky, sorry.
>>
>> Things to watch out for... it looks for an "fsstress" binary from xfstests, so adjust that path.
>> It freezes and unfreezes the test filesystem, if your mount fails it'll freeze
>> the fs you're on.  ;)  There may be other rough spots.
>>
>> It also runs the xfs_metadump/xfs_db in your path; you could change that to a
>> local ./xfs_metadump to run db/xfs_db from a git tree instead for testing
>> w/o make install.
>>
>> Right now this is detecting some corruption induced by metadump/mdrestore
>> with your full patchset in place, FWIW.
>>
>> Sorry I didn't send this sooner, kinda forgot I had it.  really should turn it into an xfstest.
> 
> Thanks! The corruption is caused by the last patch in the series. So
> dev inodes can have attribute forks. I will have to zap the data and
> the attr area separately.

Cool, glad it was helpful.

Check patch 2 as well, the "break;" is also causing corruption I think,
and it should probably just be a no-op ";"

It may get resolved by the time you get to patch5 but best to not have
regressions along the way.  Sorry for the piecemeal review here ;)

-Eric
