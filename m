Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:50020 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753830AbdGNOEz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 14 Jul 2017 10:04:55 -0400
Subject: Re: Parent pointers
References: <59680165.9020201@oracle.com>
 <20170714085016.4j2yeyihezmb6nkp@eorzea.usersys.redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <817aafad-6b64-3700-6752-c63d7e5cdde7@sandeen.net>
Date: Fri, 14 Jul 2017 09:04:52 -0500
MIME-Version: 1.0
In-Reply-To: <20170714085016.4j2yeyihezmb6nkp@eorzea.usersys.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>, linux-xfs@vger.kernel.org



On 07/14/2017 03:50 AM, Carlos Maiolino wrote:
> Hi,
> 
> On Thu, Jul 13, 2017 at 04:25:25PM -0700, Allison Henderson wrote:
>> Hi all,
>>
>> I've been doing some digging on adding parent pointers to xfs and wanted to
>> send a note to folks here to get peoples opinions on it.
> 
> Are you talking about parent pointers in the BTrees?
> 

No, see [RFC 00/17] RFC parent inode pointers. for example, from long
ago.

"Parent inode support allow XFS to quickly derive a file name and
path from the mount point. This can aid in directory/path policies
and can help relocate items during filesystem shrink."

It has a long and ... difficult history.

-Eric
 
>> I got in touch
>> with Brian Foster not too long ago and he had some code partially done from
>> about a year or so ago (looks like it has patches from Dave Chinner and Mark
>> Tinguely as well).  So I am hoping to be able to use what we have so far to
>> create something updated and finished out.  I am still pretty new to the xfs
>> code, so at the moment I am still just going through old discussion threads,
>> and reviewing the patches.  But for the most part I just wanted to see what
>> people thought and get everyone on board with the idea.  Suggestions and
>> feedback are much appreciated. Thank you!!
>>
> 
> It will be better if you can describe in more details if you have any specific
> goal with this, and/or what kind of improvement you expect to have with it,
> adding something new without a reason, is usually not well received.
> 
> Cheers
> 
