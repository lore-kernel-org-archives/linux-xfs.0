Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:52078 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935114AbeFZAeW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 25 Jun 2018 20:34:22 -0400
Subject: Re: [PATCH] xfs: remove deprecated barrier/nobarrier mount options
References: <56f0a68c-9c1b-712a-a0e8-e596f8272561@redhat.com>
 <20180626001620.GA5711@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <77374aad-a84d-9cd0-7a41-f5e8e0595dd2@sandeen.net>
Date: Mon, 25 Jun 2018 19:34:20 -0500
MIME-Version: 1.0
In-Reply-To: <20180626001620.GA5711@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On 6/25/18 7:16 PM, Darrick J. Wong wrote:
> On Mon, Jun 25, 2018 at 07:03:57PM -0500, Eric Sandeen wrote:
>> The barrier mount options have been no-ops and deprecated since
>>
>> 4cf4573 xfs: deprecate barrier/nobarrier mount option
>>
>> i.e. kernel 4.10 / December 2016, with a stated deprecation schedule
>> after v4.15.  Should be fair game to remove them now.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>  Documentation/filesystems/xfs.txt |    4 ++--
>>  fs/xfs/xfs_mount.h                |    1 -
>>  fs/xfs/xfs_super.c                |   34 ++++------------------------------
>>  3 files changed, 6 insertions(+), 33 deletions(-)
>>
>>
>> diff --git a/Documentation/filesystems/xfs.txt b/Documentation/filesystems/xfs.txt
>> index 4d9ff0a..07dbd4e 100644
>> --- a/Documentation/filesystems/xfs.txt
>> +++ b/Documentation/filesystems/xfs.txt
>> @@ -223,8 +223,6 @@ Deprecated Mount Options
>>  
>>    Name				Removal Schedule
>>    ----				----------------
>> -  barrier			no earlier than v4.15
>> -  nobarrier			no earlier than v4.15
>>  
>>  
>>  Removed Mount Options
>> @@ -236,6 +234,8 @@ Removed Mount Options
>>    ihashsize			v4.0
>>    irixsgid			v4.0
>>    osyncisdsync/osyncisosync	v4.0
>> +  barrier			v4.18
>> +  nobarrier			v4.18
> 
> I'm not removing mount options this far into the 4.18 cycle. ;)
> 
> 4.19, perhaps?

Yeah I kinda figured.  Resend V2 later?  Edit on the way in and stash it
for a while?  V2 now?

-Eric
