Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:51988 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391251AbeIVCoQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 21 Sep 2018 22:44:16 -0400
Subject: Re: [PATCH xfsprogs] build: don't assume $BUILD_CC has fsmap.h just
 because $CC does
References: <20180906183529.117251-1-briannorris@chromium.org>
 <30774ff1-57c1-c9f4-4ec3-31c177b11489@sandeen.net>
 <20180906225534.GA114388@ban.mtv.corp.google.com>
 <20180921183700.GA203751@ban.mtv.corp.google.com>
 <1daeaef0-af23-0d2d-cc30-e6f3ef12205c@sandeen.net>
 <20180921193412.GA224566@ban.mtv.corp.google.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <771b2add-c502-b98f-5e2e-bceb9cadb5b5@sandeen.net>
Date: Fri, 21 Sep 2018 15:53:38 -0500
MIME-Version: 1.0
In-Reply-To: <20180921193412.GA224566@ban.mtv.corp.google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Norris <briannorris@chromium.org>
Cc: linux-xfs@vger.kernel.org



On 9/21/18 2:34 PM, Brian Norris wrote:
> On Fri, Sep 21, 2018 at 02:12:31PM -0500, Eric Sandeen wrote:
>> On 9/21/18 1:37 PM, Brian Norris wrote:
>>> Ping? Should I send a new version that combines our patches?
>>
>> Hi Brian - I'm not ignoring your patch, I've just been working on getting
>> libxfs synced for 4.19 before merging anything else - this is usually how
>> I work when patches come in near the beginning of a release cycle.
>> I'll revisit your patch & reach out to you if I have other questions or
>> suggestions when I get there, ok?  Sorry for the delay.
> 
> No problem at all. I don't think I understood the development patterns
> here anyway. It just wasn't clear if there was a next action for me.
> This makes it clear.

Eh, it changes from time to time and isn't exactly advertised, no worries.

And this time I'm a bit behind so xfsprogs is as well.

Normal xfsprogs cycle lately is something like:

Release the last version to match the last kernel, shortly after last kernel release
Start merging in libxfs changes from next devel kernel to prepare for next release, cut -rc0
Pick up most of the accumulated pending patches, cut an -rc1
do the normal soak/patch collection until release, rc's as needed
rinse, repeat.

-Eric
