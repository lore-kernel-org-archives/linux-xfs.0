Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1AD237F9A
	for <xfs@oss.sgi.com>; Thu, 22 Aug 2013 10:30:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9B4DEAC007
	for <xfs@oss.sgi.com>; Thu, 22 Aug 2013 08:30:20 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id vqIJMTg7LuU5f1sl for <xfs@oss.sgi.com>;
	Thu, 22 Aug 2013 08:30:19 -0700 (PDT)
Message-ID: <52162E89.3000701@sandeen.net>
Date: Thu, 22 Aug 2013 10:30:17 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_db: add header to freesp -d output
References: <521541EF.1000604@redhat.com> <52161AAA.1070107@sgi.com>
In-Reply-To: <52161AAA.1070107@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 8/22/13 9:05 AM, Mark Tinguely wrote:
> On 08/21/13 17:40, Eric Sandeen wrote:
>> Today, xfs_db's freesp -d command dumps out a bunch of numbers:
>>
>> # xfs_db -c "freesp -d" /dev/sdb1
>>         0        4        1
>>         0        5        1
>>         0        6        1
>>         0        7        1
>>         0       12   174772
>> ...
>>
>> which are not useful to the non-code-reading user.
>> Add some headers:
>>
>> # xfs_db -c "freesp -d" /dev/sdb1
>>      agno    agbno      len
>>         0        4        1
>>         0        5        1
>>         0        6        1
>>         0        7        1
>>         0       12   174772
>> ...
>>
>> so there's at least some context.
>>
>> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
>> ---
>>
>> p.s. - If folks want different strings, I'm game.
> 
> 
> Seems like just yesterday, some reviewer was concerned about the verbosity of table headers... wait it was yesterday! Gawd, I love irony.
> :)

I'd submit that this case is a bit different - there is no context whatsoever to the table of numbers, and there will almost certainly be a very high data::header ratio.  :)

> Geoffrey comment len -> length is fine too.
> 
> Reviewed-by: Mark Tinguely <tinguely@sgi.com>

Thanks for the review,

-Eric

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
