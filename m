Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56212 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754962AbcISMoK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 19 Sep 2016 08:44:10 -0400
Subject: Re: [PATCH] mkfs.xfs: clarify ftype defaults in manpage
References: <1f98ea1d-893c-d1c0-2307-3f5a9b478238@redhat.com>
 <20160919021604.GA340@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <c7136664-8b39-5be7-4e64-b7de7ef00519@sandeen.net>
Date: Mon, 19 Sep 2016 07:44:08 -0500
MIME-Version: 1.0
In-Reply-To: <20160919021604.GA340@dastard>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>, linux-xfs@vger.kernel.org, Chris Murphy <chris@cmurf.com>



On 9/18/16 9:16 PM, Dave Chinner wrote:
> On Fri, Sep 16, 2016 at 03:48:14PM -0500, Eric Sandeen wrote:
>> When CRCs were made default, a few leftovers related to its
>> prior non-default status remained in the manpage, in the ftype
>> section.  Clean those up.
>>
>> Reported-by: Chris Murphy <chris@cmurf.com>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
>> index 9578c4d..033bc36 100644
>> --- a/man/man8/mkfs.xfs.8
>> +++ b/man/man8/mkfs.xfs.8
>> @@ -636,13 +636,13 @@ do not need to look up the inode to determine the inode type.
>>  
>>  The
>>  .I value
>> -is either 0 or 1, with 1 signifiying that filetype information
>> -will be stored in the directory structure. The default value is 0.
>> +is either 0 or 1, with 1 signifying that filetype information
>> +will be stored in the directory structure.
>>  
>> -When CRCs are enabled via
>> -.B \-m crc=1,
>> -the ftype functionality is always enabled. This feature can not be turned
>> -off for such filesystem configurations.
>> +When CRCs are enabled (the default), the ftype functionality is always
>> +enabled, and cannot be turned off. If CRCs are disabled with
>> +.B \-m crc=0,
>> +the ftype functionality is disabled by default.
> 
> I think that's wrong:
> 
> $ sudo mkfs.xfs -f -m crc=0 /dev/vda
> ....
> naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
>                                                          ^^^^^^^
> 
> i.e. ftype is enabled by default for all configurations these days.

Oh hell, you're right.  I'll resend.  In retrospect that was probably
a mistake, but it is what it is :)

-Eric
