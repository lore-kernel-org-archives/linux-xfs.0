Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4A7CB7F3F
	for <xfs@oss.sgi.com>; Mon, 29 Jul 2013 16:07:28 -0500 (CDT)
Message-ID: <51F6D98C.4090300@sgi.com>
Date: Mon, 29 Jul 2013 16:07:24 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 46/49] xfs: Combine CIL insert and prepare passes
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
	<1374215120-7271-47-git-send-email-david@fromorbit.com>
In-Reply-To: <1374215120-7271-47-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 07/19/13 01:25, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> Now that all the log item preparation and formatting is done under
> the CIL lock, we can get rid of the intermediate log vector chain
> used to track items to be inserted into the CIL.
>
> We can already find all the items to be committed from the
> transaction handle, so as long as we attach the log vectors to the
> item before we insert the items into the CIL, we don't need to
> create a log vector chain to pass around.
>
> This means we can move all the item insertion code into and optimise
> it into a pair of simple passes across all the items in the
> transaction. The first pass does the formatting and accounting, the
> second inserts them all into the CIL.
>
> We keep this two pass split so that we can separate the CIL
> insertion - which must be done under the CIL spinlock - from the
> formatting. We could insert each item into the CIL with a single
> pass, but that massively increases the number of times we have to
> grab the CIL spinlock. It is much more efficient (and hence
> scalable) to do a batch operation and insert all objects in a single
> lock grab.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

Removed the old log commit vector chain interface.

Looks good. Still like the additional assert for cil space stealing.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
