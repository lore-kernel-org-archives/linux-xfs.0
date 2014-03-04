Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7803B7F4E
	for <xfs@oss.sgi.com>; Tue,  4 Mar 2014 10:49:35 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 15D64AC004
	for <xfs@oss.sgi.com>; Tue,  4 Mar 2014 08:49:31 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id G3chhXMMYWJSU4y3 for <xfs@oss.sgi.com>;
	Tue, 04 Mar 2014 08:49:29 -0800 (PST)
Message-ID: <53160419.50104@sandeen.net>
Date: Tue, 04 Mar 2014 10:49:29 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: memset proper length in resvtest.c
References: <531563D8.2070007@redhat.com>
	<20140304153655.GC51235@bfoster.bfoster>
In-Reply-To: <20140304153655.GC51235@bfoster.bfoster>
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

On 3/4/14, 9:36 AM, Brian Foster wrote:
> On Mon, Mar 03, 2014 at 11:25:44PM -0600, Eric Sandeen wrote:
>> sizeof(pointer) is not very relevant; sizeof(*pointer)
>> is a bit more so.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/src/resvtest.c b/src/resvtest.c
>> index 037d9ea..a07f503 100644
>> --- a/src/resvtest.c
>> +++ b/src/resvtest.c
>> @@ -73,7 +73,7 @@ main(int argc, char **argv)
>>  		perror("open");
>>  		exit(1);
>>  	}
>> -	memset(writebuffer, 'A', sizeof(writebuffer));
>> +	memset(writebuffer, 'A', sizeof(*writebuffer));
>>
> 
> It's not clear to me how much this is intending to write/read. If the
> entire buffer, we should probably use the buffer size.
> sizeof(*writebuffer) is a single byte, no?
> 
> Also, there are other instances of the same thing throughout this file.
> I think they need to be consistent, in any event, for the test to work.

yeah, sorry, I was in a bit too much of a rush; just disregard this
for now I guess.  too-quick reaction to a gcc compile warning.

-Eric


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
