Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:57478 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753194AbdHWCNE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 22 Aug 2017 22:13:04 -0400
Subject: Re: [PATCH 1/3] libxfs: handle 0 blocksize or sectorsize in cvtnum
References: <2b5a5742-5343-671f-8b89-9d1dc9841c17@redhat.com>
 <2e0acf4a-a863-8304-65d3-5027368c69e2@sandeen.net>
 <20170823010153.GZ21024@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <c09f8778-361e-b3aa-4eb6-00215e4af005@sandeen.net>
Date: Tue, 22 Aug 2017 21:13:03 -0500
MIME-Version: 1.0
In-Reply-To: <20170823010153.GZ21024@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On 8/22/17 8:01 PM, Dave Chinner wrote:
> On Tue, Aug 22, 2017 at 04:12:48PM -0500, Eric Sandeen wrote:
>> Blocksize and sectorsize are unique in that they must
>> be provided, unlike every other suffix which can be
>> calculated from constants.
>>
>> Nothing protects against unspecified block & sector size,
>> so catch it if it happens and return a parsing error.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/libxcmd/input.c b/libxcmd/input.c
>> index 7a69dc1..7b86225 100644
>> --- a/libxcmd/input.c
>> +++ b/libxcmd/input.c
>> @@ -330,8 +330,12 @@ cvtnum(
>>  	c = tolower(*sp);
>>  	switch (c) {
>>  	case 'b':
>> +		if (!blocksize)
>> +			return -1LL;
>>  		return i * blocksize;
>>  	case 's':
>> +		if (!sectorsize)
>> +			return -1LL;
>>  		return i * sectorsize;
>>  	case 'k':
>>  		return KILOBYTES(i);
> 
> With this you could have mkfs call the generic function, too.

Yep, or at least closer; mkfs does a printf and usage()/exit()
and it indicates a user error (most likely)

in libxcmd/xfs_io it's more of a programming error, with no 
printf to the user at least today... so would need a little more
finessing.

-Eric
