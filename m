Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:40338 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750725AbdGNSDG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Jul 2017 14:03:06 -0400
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
        by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v6EHijZG030061
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 14 Jul 2017 17:44:45 GMT
Subject: Re: Parent pointers
References: <59680165.9020201@oracle.com>
 <20170714085016.4j2yeyihezmb6nkp@eorzea.usersys.redhat.com>
 <817aafad-6b64-3700-6752-c63d7e5cdde7@sandeen.net>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <59690307.9090407@oracle.com>
Date: Fri, 14 Jul 2017 10:44:39 -0700
MIME-Version: 1.0
In-Reply-To: <817aafad-6b64-3700-6752-c63d7e5cdde7@sandeen.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, cmaiolino@redhat.com, linux-xfs@vger.kernel.org

On 7/14/2017 7:04 AM, Eric Sandeen wrote:
>
>
> On 07/14/2017 03:50 AM, Carlos Maiolino wrote:
>> Hi,
>>
>> On Thu, Jul 13, 2017 at 04:25:25PM -0700, Allison Henderson wrote:
>>> Hi all,
>>>
>>> I've been doing some digging on adding parent pointers to xfs and wanted to
>>> send a note to folks here to get peoples opinions on it.
>>
>> Are you talking about parent pointers in the BTrees?
>>
>
> No, see [RFC 00/17] RFC parent inode pointers. for example, from long
> ago.
>
> "Parent inode support allow XFS to quickly derive a file name and
> path from the mount point. This can aid in directory/path policies
> and can help relocate items during filesystem shrink."
>
> It has a long and ... difficult history.
>
> -Eric
Right, so to expand on Eric's answer, it looks like Dave and Brian had 
been working on some improvements based on that set, but it's not quite 
finished yet.  The idea is that we add an extended attribute to keep 
track of the parents inode and generation, and also the child entries 
offset, and filename. So in this solution the EA is name={parent inode 
#, parent inode generation, dirent offset}, value={dirent filename}.

My goal at the moment is just to get it compiling again and finish out 
some of the sub routines that maintain it.  It looks like it hasn't had 
much attention in a while, so I wanted to let people know the direction 
I'm planning to move in before I get too far in.

Allison
>
>>> I got in touch
>>> with Brian Foster not too long ago and he had some code partially done from
>>> about a year or so ago (looks like it has patches from Dave Chinner and Mark
>>> Tinguely as well).  So I am hoping to be able to use what we have so far to
>>> create something updated and finished out.  I am still pretty new to the xfs
>>> code, so at the moment I am still just going through old discussion threads,
>>> and reviewing the patches.  But for the most part I just wanted to see what
>>> people thought and get everyone on board with the idea.  Suggestions and
>>> feedback are much appreciated. Thank you!!
>>>
>>
>> It will be better if you can describe in more details if you have any specific
>> goal with this, and/or what kind of improvement you expect to have with it,
>> adding something new without a reason, is usually not well received.
>>
>> Cheers
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
