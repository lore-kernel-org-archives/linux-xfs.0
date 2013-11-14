Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CAA717F3F
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 12:55:39 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9FB8D8F8049
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 10:55:39 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id KCSYCWpIgbS4Tmyp for <xfs@oss.sgi.com>;
	Thu, 14 Nov 2013 10:55:38 -0800 (PST)
Received: from Liberator.local (c-98-240-215-156.hsd1.mn.comcast.net
	[98.240.215.156])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 712646AB3132
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 12:55:38 -0600 (CST)
Message-ID: <52851CA9.8080903@sandeen.net>
Date: Thu, 14 Nov 2013 12:55:37 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH RFC] xfsprogs: suggest "-d" option for repair of RO mount
References: <528261AD.50501@redhat.com>
	<20131113125921.GC24615@orion.maiolino.org>
In-Reply-To: <20131113125921.GC24615@orion.maiolino.org>
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
To: xfs@oss.sgi.com

On 11/13/13, 6:59 AM, Carlos Maiolino wrote:
> Hm, even in single user with a RO root filesystem, changing filesystem
> on-disk filesystem structures without have them replied in memory looks
> dangerous to me, you will keep data consistency since the fs is RO, but how
> about memory? You might have a discrepancy between memory and disk metadata
> contents causing in-memory only problems?
> 

The possibility is already there; it's just a question of whether we
suggest using it.  And my other patch suggests an immediate reboot
when it's done, for just those reasons.

A user needs some way to repair their root disk if they can't boot
a rescue environment... and ext2/3/4 have been doing this since forever.

I know, none of the above are exactly arguments that its' safe... :)

-Eric

> On Tue, Nov 12, 2013 at 11:13:17AM -0600, Eric Sandeen wrote:
>> How dangerous is dangerous?
>>
>> We could offer the suggestion of a "-d" repair, if we're
>> in single-user mode with the root fs mounted readonly.
>>
>> This change suggests -d to repair any RO mounted fs.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/repair/init.c b/repair/init.c
>> index c3f380b..a7a7613 100644
>> --- a/repair/init.c
>> +++ b/repair/init.c
>> @@ -97,8 +97,17 @@ xfs_init(libxfs_init_t *args)
>>  	else
>>  		args->isreadonly = LIBXFS_EXCLUSIVELY;
>>  
>> -	if (!libxfs_init(args))
>> +	if (!libxfs_init(args)) {
>> +		/* would -d be an option? */
>> +		if (!no_modify && !dangerously) {
>> +			args->isreadonly = (LIBXFS_ISINACTIVE |
>> +					    LIBXFS_DANGEROUSLY);
>> +			if (libxfs_init(args))
>> +				fprintf(stderr,
>> +_("Unmount or use -d to repair a read-only mounted filesystem\n"));
>> +		}
>>  		do_error(_("couldn't initialize XFS library\n"));
>> +	}
>>  
>>  	ts_create();
>>  	increase_rlimit();
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
