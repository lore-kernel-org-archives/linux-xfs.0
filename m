Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9D7357F6F
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 17:35:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3CE19AC003
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 15:35:12 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Tgf7zrWU0uD22otW for <xfs@oss.sgi.com>;
	Wed, 01 Oct 2014 15:35:10 -0700 (PDT)
Date: Thu, 2 Oct 2014 08:34:56 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix the xfs_iflush_done callback search
Message-ID: <20141001223456.GV4758@dastard>
References: <20141001191803.153063401@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141001191803.153063401@sgi.com>
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

On Wed, Oct 01, 2014 at 04:18:02PM -0500, Mark Tinguely wrote:
> Commit "xfs: remove all the inodes on a buffer from the AIL in bulk"
> made the xfs inode flush callback more efficient by combining all
> the inode writes on the buffer and the deletions of the inode log
> item from AIL.
> 
> The initial loop in this patch should be looping through all
> the log items on the buffer to see which items have
> xfs_iflush_done as their callback function. But currently,
> only the log item passed to the function has its callback
> compared to xfs_iflush_done. If the log item pointer passed to
> the function does have the xfs_iflush_done callback function,
> then all the log items on the buffer are removed from the
> li_bio_list on the buffer b_fspriv and could be removed from
> the AIL eventhough they may have not been written yet.

Looks like a bug, but what I don't know from this description is
the symptoms and impact of this bug being hit? Is there a risk of
filesystem corruption on crash or power loss? Perhaps it's a data
loss issue? I can't tell, and for anyone scanning the commit logs to
determine if they need to backport the fix will be asking the same
questions.

Also, is there a reproducable test case for it?

> Signed-off-by: Mark Tinguely <tinguely@sgi.com>
> ---
>  fs/xfs/xfs_inode_item.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: b/fs/xfs/xfs_inode_item.c
> ===================================================================
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -615,7 +615,7 @@ xfs_iflush_done(
>  	blip = bp->b_fspriv;
>  	prev = NULL;
>  	while (blip != NULL) {
> -		if (lip->li_cb != xfs_iflush_done) {
> +		if (blip->li_cb != xfs_iflush_done) {

Looks correct, but more info needed...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
