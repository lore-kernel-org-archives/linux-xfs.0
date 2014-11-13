Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 547A37F37
	for <xfs@oss.sgi.com>; Thu, 13 Nov 2014 11:47:29 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E485AAC00E
	for <xfs@oss.sgi.com>; Thu, 13 Nov 2014 09:47:28 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id rXQSM9IIBRAwQ5uT for <xfs@oss.sgi.com>;
	Thu, 13 Nov 2014 09:47:27 -0800 (PST)
Message-ID: <5464EEAD.3060500@sandeen.net>
Date: Thu, 13 Nov 2014 11:47:25 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 4/9] xfsdump: remove pointless if (dirty);
References: <1415818638-32700-1-git-send-email-sandeen@redhat.com>	<1415818638-32700-5-git-send-email-sandeen@redhat.com>
	<5464EBD6.3040107@sgi.com>
In-Reply-To: <5464EBD6.3040107@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>, Eric Sandeen <sandeen@redhat.com>
Cc: xfs@oss.sgi.com

On 11/13/14 11:35 AM, Mark Tinguely wrote:
> On 11/12/14 12:57, Eric Sandeen wrote:
>> "dirty" seems to be a remnant of unfinished code; other bits of
>> it are there but commented out, so comment out "if (dirty);" as
>> well, which is a no-op if statement which can't be true.
>>
>> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
>> ---
>>   inventory/inv_stobj.c |    2 ++
>>   1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/inventory/inv_stobj.c b/inventory/inv_stobj.c
>> index becac17..84b15d9 100644
>> --- a/inventory/inv_stobj.c
>> +++ b/inventory/inv_stobj.c
>> @@ -976,7 +976,9 @@ stobj_delete_mobj(int fd,
>>
>>           }
>>           free ( mfiles );
>> +/*
>>           if ( dirty );
>> +*/
>>       }
>>
>>       free ( strms );
> 
> Why not remove all the references to dirty in the function?
> Like you said, it doesn't do anything.

Somebody left this and the rest of the commented-out code there
for some documentation reason, it seems, so I figured...

It's not like the rest of the code is a thing
of beauty, and this wart is ruining its perfection.  ;)

I have no idea, honestly.  xfsdump is dropped in from some alien
world.  Somebody @ SGI might know, or could find out by looking
at long-lost history?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
