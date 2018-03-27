Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:59376 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752048AbeC0Bos (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Mar 2018 21:44:48 -0400
Subject: Re: [PATCH] xfs_scrub: fix build with older kernel headers
References: <7ea1df02d0f2549b6249c8bee1f6ae02bf1251a9.1521925697.git.baruch@tkos.co.il>
 <20180326180946.GT4818@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <f48bedc9-b532-3e1f-f434-2409a5d93469@sandeen.net>
Date: Mon, 26 Mar 2018 20:44:46 -0500
MIME-Version: 1.0
In-Reply-To: <20180326180946.GT4818@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Baruch Siach <baruch@tkos.co.il>
Cc: linux-xfs@vger.kernel.org



On 3/26/18 1:09 PM, Darrick J. Wong wrote:
> On Sun, Mar 25, 2018 at 12:08:17AM +0300, Baruch Siach wrote:
>> The OVERRIDE_SYSTEM_FSXATTR macro in include/linux.h is meant to
>> override the linux/fs.h kernel header provided struct fsxattr for
>> kernels older than v4.7. A few source files include linux/fs.h before
>> the local linux.h, making this override ineffective. Remove these header
>> includes from the source files, and rely on the linux.h include alone.
>>
>> This fixes the following build failures:
>>
>> In file included from ../include/xfs.h:37:0,
>>                  from disk.c:40:
>> ../include/xfs/linux.h:185:8: error: redefinition of 'struct fsxattr'
>>  struct fsxattr {
>>         ^~~~~~~
>>
>> In file included from ../include/xfs.h:37:0,
>>                  from ../include/project.h:22,
>>                  from ../include/input.h:24,
>>                  from phase1.c:38:
>> ../include/xfs/linux.h:185:8: error: redefinition of 'struct fsxattr'
>>  struct fsxattr {
>>         ^~~~~~~
>>
>> Cc: Darrick J. Wong <darrick.wong@oracle.com>
>> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> 
> Looks ok, but I think this is already fixed by commit a440f8773794
> ("xfs_scrub: fix #include ordering to avoid build failure") in for-next.

Agreed, it looks like this is against master & not for-next;
Baruch, can you check out for-next and confirm that it's ok?

Thanks,
-Eric
