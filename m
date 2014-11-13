Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4FDED7F37
	for <xfs@oss.sgi.com>; Thu, 13 Nov 2014 13:23:23 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2CCF98F8059
	for <xfs@oss.sgi.com>; Thu, 13 Nov 2014 11:23:23 -0800 (PST)
Message-ID: <54650527.1@redhat.com>
Date: Thu, 13 Nov 2014 13:23:19 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 9/9] xfsdump: fix uninit ackstr in
	content_mediachange_query()
References: <1415818638-32700-1-git-send-email-sandeen@redhat.com>
	<1415818638-32700-10-git-send-email-sandeen@redhat.com>
	<5464F3F9.10305@sgi.com>
In-Reply-To: <5464F3F9.10305@sgi.com>
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
Cc: xfs@oss.sgi.com

On 11/13/14 12:10 PM, Mark Tinguely wrote:
> On 11/12/14 12:57, Eric Sandeen wrote:
>> Today, this sends an uninitialized ackstr[0] to be mlog'd -
>> who knows what we get out of it.  Other places follow this
>> "count = 0, string = "\n"" pattern which seemsa bit odd, but
>> better than printing uninitialized memory.
>>
>> To be completely honest, I have no test for this.
>>
>> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
>> ---
>>   restore/content.c |    1 +
>>   1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/restore/content.c b/restore/content.c
>> index c99aed7..bc5b398 100644
>> --- a/restore/content.c
>> +++ b/restore/content.c
>> @@ -2915,6 +2915,7 @@ content_mediachange_query( void )
>>               bagp = 0;
>>           }
>>           ackcnt = 0;
>> +        ackstr[ ackcnt++ ] = "\n";
>>           dlog_multi_ack( ackstr,
>>                   ackcnt );
>>           querycnt = 0;
> 
> dlog_multi_ack() with count of 0 will exit without doing anything.

Oh, yeah, I misread it.  Sorry.  I saw stuff like this in sigint_dialog()

                ackcnt = 0;
                ackstr[ ackcnt++ ] = "\n";
                dlog_multi_ack( ackstr,
                                ackcnt );


and got carried away.

> Looks like some conditional code that filled the ackstr array (like
> the other callers) was removed. I vote to pull ackstr, ackcnt and the
> dlog_multi_ack() from this function.

I wondered about that, but didn't want to go changing things I wasn't
able to test or trivially understand.

However, I guess I'm challenged even in the latter this week.  ;)

Anyway, yeah, just drop this patch, sorry.

Thanks for the review,
-Eric


> --Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
