Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:41404 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751733AbdIODk4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Sep 2017 23:40:56 -0400
Subject: Re: [ANNOUNCE] xfsdump: master updated to ce8b006
References: <32b02ec1-de5d-f268-e726-376678c15e17@sandeen.net>
 <CAMKF1spg5jrxPnm8_wwsW=pj90pVjsFxsthfiV3FaJfK+z62FQ@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <aef2d3ee-8a55-771a-f80d-4b9b261614b2@sandeen.net>
Date: Thu, 14 Sep 2017 22:40:55 -0500
MIME-Version: 1.0
In-Reply-To: <CAMKF1spg5jrxPnm8_wwsW=pj90pVjsFxsthfiV3FaJfK+z62FQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Khem Raj <raj.khem@gmail.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Felix Janda <felix.janda@posteo.de>



On 9/14/17 10:31 PM, Khem Raj wrote:
> On Thu, Sep 14, 2017 at 7:57 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>> Hi folks,
>>
>> The xfsdump repository at:
>>
>>         git://git.kernel.org/pub/scm/fs/xfs/xfsdump-dev.git
>>
>> has just been updated.
>>
>> This is comprised solely of fixes for building against musl
>> libc; if all is well I'll tag this and push it out as 3.1.8.
>> If those using musl could report success or failure I'd appreciate it.
>>
> 
> Just tried. we still need
> 
> https://patchwork.kernel.org/patch/9946149/
> 
> to get musl builds going.

Isn't that more a bug in libattr?

Yes, it seems it's been fixed by Felix:

http://git.savannah.nongnu.org/cgit/attr.git/commit/include/attributes.h?id=37a27b6fd09ecb37097b85e5db74e4f77b80fe0a

-Eric
