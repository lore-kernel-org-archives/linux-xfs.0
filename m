Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7896D7F5A
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 16:43:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 11891AC004
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 14:43:02 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id wet5CmyR52kMwWAz for <xfs@oss.sgi.com>;
	Mon, 03 Aug 2015 14:43:00 -0700 (PDT)
Message-ID: <55BFE062.8020704@sandeen.net>
Date: Mon, 03 Aug 2015 14:42:58 -0700
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 3/4] xfs: log recovery needs to validate against
	sb_meta_uuid
References: <1438587625-31437-1-git-send-email-david@fromorbit.com>	<1438587625-31437-4-git-send-email-david@fromorbit.com>
	<55BF99AD.2090103@sandeen.net>
In-Reply-To: <55BF99AD.2090103@sandeen.net>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

On 8/3/15 9:41 AM, Eric Sandeen wrote:
> On 8/3/15 12:40 AM, Dave Chinner wrote:
>> From: Dave Chinner <dchinner@redhat.com>
>>
>> Now that sb_uuid can be changed by the user, we cannot use this to
>> validate the metadata blocks being recovered belong to this
>> filesystem. We must check against the sb_meta_uuid as that will
>> remain unchanged.
>>
>> There is a complication in this code - the superblock itself. We can
>> not check the sb_meta_uuid unconditionally, as that may not be set
>> on disk. Hence we must verify the superblock sb_uuid matches between
>> the log record and the in-core superblock.
>>
>> Found by inspection after the previous two problems were found.
> 
> So, I also had this in my older patchset, I think it's needed for
> proper log recovery as well.  I'm not sure why I didn't hit the
> xlog_recover_get_buf_lsn problem, though:

Oh god, all this is is a difference in unlikely's upstream.  Kill me now!

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
