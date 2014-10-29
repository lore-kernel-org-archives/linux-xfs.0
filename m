Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4381F7F3F
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2014 13:45:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 20C268F8037
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2014 11:45:43 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id jFDZ85bAthhNmGtG for <xfs@oss.sgi.com>;
	Wed, 29 Oct 2014 11:45:42 -0700 (PDT)
Message-ID: <545135D4.6010908@sandeen.net>
Date: Wed, 29 Oct 2014 13:45:40 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] xfsprogs: don't warn about log sunit size if it was
	auto-discovered
References: <544FD3E1.1060000@redhat.com> <544FD47D.8020409@sandeen.net>
	<20141029183841.GB4226@bfoster.laptop>
In-Reply-To: <20141029183841.GB4226@bfoster.laptop>
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
To: Brian Foster <bfoster@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>, Stan Hoeppner <stan@hardwarefreak.com>, xfs-oss <xfs@oss.sgi.com>

On 10/29/14 1:38 PM, Brian Foster wrote:
> On Tue, Oct 28, 2014 at 12:38:05PM -0500, Eric Sandeen wrote:
>> Today, users doing a bare mkfs on storage with a large default
>> stripe size may be surprised to get this warning:
>>
>>  log stripe unit (%d bytes) is too large (maximum is 256KiB
>>  log stripe unit adjusted to 32KiB
>>
>> through no fault of their own.  The fallback is appropriate
>> and harmless, and there's no need to warn about this in the
>> defaults case.
>>
>> However, we keep the warning if a large log stripe unit was
>> specified by the user on the commandline.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
...

>> @@ -2379,11 +2383,15 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
>>  	}
>>  
>>  	if (logversion == 2 && (lsunit * blocksize) > 256 * 1024) {
>> -		fprintf(stderr,
>> +		/* Warn only if specified on commandline */
>> +		if (lsuflag || lsunitflag) {
>> +			fprintf(stderr,
>>  	_("log stripe unit (%d bytes) is too large (maximum is 256KiB)\n"),
>> -			(lsunit * blocksize));
>> +				(lsunit * blocksize));
>> +			fprintf(stderr,
>> +	_("log stripe unit adjusted to 32KiB\n"));
>> +		}
> 
> Right above this particular hunk we have the possibility of lsunit
> inheriting a value from dsunit. If the latter is specified by the user,
> we don't print the message for an arguably user-specified lsunit. Hmm,
> do we care about that case?

I don't think we do care.  I think we only care if the user manually
specified a log stripe unit and we're changing what they asked for.

I'd put "inheritance" in the "using default behaviors" case, and not
warn about it.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
