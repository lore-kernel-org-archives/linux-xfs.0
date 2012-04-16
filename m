Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3GInQWY237640 for <xfs@oss.sgi.com>; Mon, 16 Apr 2012 13:49:26 -0500
Message-ID: <4F8C69B3.9050303@sgi.com>
Date: Mon, 16 Apr 2012 13:49:23 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 02/18 V2] xfs: pass shutdown method into
	xfs_trans_ail_delete_bulk
References: <1334319061-12968-1-git-send-email-david@fromorbit.com>
	<1334319061-12968-3-git-send-email-david@fromorbit.com>
	<4F88651E.2030908@sgi.com> <20120413230451.GS6734@dastard>
	<20120413233825.GT6734@dastard>
In-Reply-To: <20120413233825.GT6734@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 04/13/12 18:38, Dave Chinner wrote:
> On Sat, Apr 14, 2012 at 09:04:51AM +1000, Dave Chinner wrote:
>> On Fri, Apr 13, 2012 at 12:40:46PM -0500, Mark Tinguely wrote:
>>> On 04/13/12 07:10, Dave Chinner wrote:
>>>> From: Dave Chinner<dchinner@redhat.com>
>>>>
>>>> xfs_trans_ail_delete_bulk() can be called from different contexts so
>>>> if the item is not in the AIL we need different shutdown for each
>>>> context.  Pass in the shutdown method needed so the correct action
>>>> can be taken.
>>>>
>>>> Signed-off-by: Dave Chinner<dchinner@redhat.com>
>>>> Reviewed-by: Christoph Hellwig<hch@lst.de>
>>>> Reviewed-by: Mark Tinguely<tinguely@sgi.com>
>>>
>>>
>>>
>>> These items in my copy of Christoph's xfsbufd series are not
>>> resolved in this patch:
>>
>> Ah, oh, that's my fault. I re-ordered the series so that all my
>> patches were after christoph's, and when reapplying christophs
>> patches from my series there were a few merge conflicts I obviously
>> didn't resolve correctly.
>>
>> I'll fix my tree up and repost this patch.
>
> Updated patch below.
>

Applies cleanly. Thanks.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
