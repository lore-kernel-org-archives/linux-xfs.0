Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 293E07F37
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 16:56:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EF1DF8F8033
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 14:56:19 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 0SSvjrBMmI1hDGsW for <xfs@oss.sgi.com>;
	Wed, 26 Aug 2015 14:56:17 -0700 (PDT)
Message-ID: <55DE3600.4000401@sandeen.net>
Date: Wed, 26 Aug 2015 16:56:16 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: properly terminate string in quota's
	restore_file()
References: <55DC9A41.8060006@redhat.com>
	<20150826115308.GB11759@bfoster.bfoster>
In-Reply-To: <20150826115308.GB11759@bfoster.bfoster>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>, Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 8/26/15 6:53 AM, Brian Foster wrote:
> On Tue, Aug 25, 2015 at 11:39:29AM -0500, Eric Sandeen wrote:
>> This code copies up to the entire size of devbuffer, and then
>> tries to use "strlen" to null terminate it.
>>
>> But strlen works by *finding* the null, so it's at best a
>> no-op, and at worst not properly terminating the string.
>>
>> Fix this by placing the null at the last byte of the buffer.
>>
>> Addresses-Coverity-Id: 1297519
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/quota/edit.c b/quota/edit.c
>> index d226e89..a53a7e6 100644
>> --- a/quota/edit.c
>> +++ b/quota/edit.c
>> @@ -385,7 +385,7 @@ restore_file(
>>  	while (fgets(buffer, sizeof(buffer), fp) != NULL) {
>>  		if (strncmp("fs = ", buffer, 5) == 0) {
>>  			dev = strncpy(devbuffer, buffer+5, sizeof(devbuffer));
>> -			dev[strlen(dev) - 1] = '\0';
>> +			dev[sizeof(devbuffer) - 1] = '\0';
> 
> According to the man page, fgets() NULL terminates the provided buffer.

Yep, I should have looked more closely.

It copies at most size-1 (511 bytes), including the newline if it fits,
and terminates with \0.

> Next, we attempt to strncpy() just the device name part of the string
> (copying up to 512 bytes from a 512-5 byte buffer).

In fact since the original buffer (via fgets, 512) will be <= 512 long,
copying again from 5 bytes in will always result in less than 512 bytes
copied.

> I'm not quite sure,
> but it looks like the above line could be trying to replace a newline
> with a NULL terminator..? E.g., it expects the last character in an
> already NULL terminated line to be a newline.

Yes, that's exactly it, thanks.

There is one very corner case where if the last char in the buffer is
part of the device name, the buffer won't contain the newline, and the
'\0' will actually take out one char, rather than the newline.  But
that's one heck of a corner case, the exactly-sized-device-name case ...
probably not worth worrying about, though I might send a patch just to
satisfy my OCD.

Thanks for keeping me straight on this one, sorry for the noise.

-Eric

> Brian
> 
>>  			continue;
>>  		}
>>  		rtbsoft = rtbhard = 0;
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
