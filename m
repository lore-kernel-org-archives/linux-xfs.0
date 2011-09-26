Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8QG29Hb181824 for <xfs@oss.sgi.com>; Mon, 26 Sep 2011 11:02:10 -0500
Message-ID: <4E80A1FD.8070400@redhat.com>
Date: Mon, 26 Sep 2011 11:02:05 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: test timestamps before the epoch
References: <4E778C51.7040100@redhat.com>
	<20110926112716.GA22382@infradead.org>
	<1317040069.3030.18.camel@doink>
In-Reply-To: <1317040069.3030.18.camel@doink>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: aelder@sgi.com
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

On 9/26/11 7:27 AM, Alex Elder wrote:
> On Mon, 2011-09-26 at 07:27 -0400, Christoph Hellwig wrote:
>> This one actually ends up failing on XFS for me:
>>
>> @@ -1,5 +1,5 @@
>>  QA output created by 258
>>  Creating file with timestamp of Jan 1, 1960
>>  -Stat of file yields: -315593940
>>  +Stat of file yields: -315615540
>>   Remounting to flush cache
>>  -Stat of file yields: -315593940
>>  +Stat of file yields: -315615540
>>
>> Note that we still get the same for both, it just seems XFS rounds it
>> a bit different.

Hrm.  Should we just test to be sure the timestamp is negative?
The sign extension is the real error, so as long as it's not
positive it's probably OK.

-Eric

> 
> I haven't seen this one fail.  Must have to do with
> some FS configuration options (like blocksize or
> something).
> 
> 					-Alex
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
