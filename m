Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AF7737CA0
	for <xfs@oss.sgi.com>; Thu, 12 May 2016 18:31:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 704B08F8037
	for <xfs@oss.sgi.com>; Thu, 12 May 2016 16:31:09 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id kJGWnQrAYOOsDMUa for <xfs@oss.sgi.com>;
	Thu, 12 May 2016 16:31:04 -0700 (PDT)
Subject: Re: [PATCH] xfs_db: allow recalculating CRCs on invalid metadata
References: <1463092513-5462-1-git-send-email-david@fromorbit.com>
	<ee586739-e804-8174-8497-cc8a992b9752@sandeen.net>
	<20160512232804.GC18496@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <367454d8-56fe-6dda-7cc3-485b964fe8af@sandeen.net>
Date: Thu, 12 May 2016 18:31:03 -0500
MIME-Version: 1.0
In-Reply-To: <20160512232804.GC18496@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com



On 5/12/16 6:28 PM, Dave Chinner wrote:
>>> +
>>> > > +	if (corrupt) {
>>> > >  		nowrite_ops.verify_write = xfs_dummy_verify;
>>> > > -		iocur_top->bp->b_ops = &nowrite_ops;
>>> > > -		dbprintf(_("Allowing write of corrupted data\n"));
>>> > > +		dbprintf(_("Allowing write of corrupted data and bad CRC\n"));
>>> > > +	} else {
>> > 
>> > Maybe a helpful/redundant comment about /* invalid_data */ alongside } else { ?
> I though the dbprintf() documented it well enough? maybe move that
> to the top of each branch?

Oh, I suppose it does.  By the time we returned early on !corrupt & ! invalid_data,
then tested explicitly for (corrupt), it requires a decent brain-stack to 
remember what the } else { clause is for, IMHO.

But like I said, just a thought.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
