Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 409BC7CBF
	for <xfs@oss.sgi.com>; Wed, 24 Jul 2013 19:23:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EE210304039
	for <xfs@oss.sgi.com>; Wed, 24 Jul 2013 17:23:54 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	2Tg8teFNeoSMd1iU for <xfs@oss.sgi.com>;
	Wed, 24 Jul 2013 17:23:53 -0700 (PDT)
Date: Thu, 25 Jul 2013 10:23:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 46/49] xfs: Combine CIL insert and prepare passes
Message-ID: <20130725002330.GB11222@dastard>
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
	<1374215120-7271-47-git-send-email-david@fromorbit.com>
	<51EEF3D4.2000201@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51EEF3D4.2000201@sgi.com>
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

On Tue, Jul 23, 2013 at 04:21:24PM -0500, Mark Tinguely wrote:
> On 07/19/13 01:25, Dave Chinner wrote:
> >From: Dave Chinner<dchinner@redhat.com>
> >
> >Now that all the log item preparation and formatting is done under
> >the CIL lock, we can get rid of the intermediate log vector chain
> >used to track items to be inserted into the CIL.
> >
> >We can already find all the items to be committed from the
> >transaction handle, so as long as we attach the log vectors to the
> >item before we insert the items into the CIL, we don't need to
> >create a log vector chain to pass around.
> >
> >This means we can move all the item insertion code into and optimise
> >it into a pair of simple passes across all the items in the
> >transaction. The first pass does the formatting and accounting, the
> >second inserts them all into the CIL.
> >
> >We keep this two pass split so that we can separate the CIL
> >insertion - which must be done under the CIL spinlock - from the
> >formatting. We could insert each item into the CIL with a single
> >pass, but that massively increases the number of times we have to
> >grab the CIL spinlock. It is much more efficient (and hence
> >scalable) to do a batch operation and insert all objects in a single
> >lock grab.
> >
> >Signed-off-by: Dave Chinner<dchinner@redhat.com>
> 
> ...
> 
> >@@ -357,10 +341,8 @@ xlog_cil_insert_items(
> >  	 * during the transaction commit.
> >  	 */
> >  	if (ctx->ticket->t_curr_res == 0) {
> >-		/* first commit in checkpoint, steal the header reservation */
> >-		ASSERT(ticket->t_curr_res>= ctx->ticket->t_unit_res + len);
> 
> ^^ is the ctx ticket overflow caught somewhere else? ^^^^

Of course. It's caught in same check that catches all other
transaction overruns - in the caller after this function returns.
And it prints the ticket now, too, which means it's a far more
functional check that the current one...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
