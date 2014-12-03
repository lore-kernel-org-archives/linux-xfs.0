Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0C37B7F3F
	for <xfs@oss.sgi.com>; Wed,  3 Dec 2014 08:09:53 -0600 (CST)
Message-ID: <547F19AE.6050808@sgi.com>
Date: Wed, 03 Dec 2014 08:09:50 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: lobotomise xfs_trans_read_buf_map()
References: <1417473290-17544-1-git-send-email-david@fromorbit.com>
	<20141202165930.GA28571@infradead.org>
	<20141202224518.GG18131@dastard>
	<20141203105122.GA3727@infradead.org>
In-Reply-To: <20141203105122.GA3727@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 12/03/14 04:51, Christoph Hellwig wrote:
> On Wed, Dec 03, 2014 at 09:45:18AM +1100, Dave Chinner wrote:
>>> Can you fix the inconsistent return for the trylock case in a follow on
>>> patch?  This difference doesn't look intentional to me, and I would
>>> be surprised if it's correctly handled in the callers.
>>
>> Ok, I'll do an audit and make this common in a follow up patch. Just
>> to confirm:
>>
>> 		if (!(flags & XBF_TRYLOCK))
>> 			return -ENOMEM;
>> 		return -EAGAIN;
>>
>> is what you want to see, right?
>
> Yes.

Even ENOMEM / EAGAIN could be wrong if _xfs_buf_find() was given an 
illegal block number - then it would be EFSCORRUPT.

I think we need to push the error message from _xfs_buf_find(). I played 
with it once and seemed to have lost it and can do it again if no one 
else has the time.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
