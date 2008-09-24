Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 23 Sep 2008 20:06:25 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8O36NVd030843
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2008 20:06:23 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E46A496341B
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2008 20:07:57 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id RM162WOX0Ws2XT95 for <xfs@oss.sgi.com>; Tue, 23 Sep 2008 20:07:57 -0700 (PDT)
Message-ID: <48D9AF0C.3050404@sandeen.net>
Date: Tue, 23 Sep 2008 22:07:56 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] XFS: Check for valid transaction headers in recovery
References: <1222218974-5161-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1222218974-5161-1-git-send-email-david@fromorbit.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Dave Chinner wrote:
> When we are about to add a new item to a transaction in recovery,
> we need to check that it is valid first. Current we just assert
> that header magic number matches, but in production systems
> that is not done add a corrupted transaction to the list to be
> processed. This results in a kernel oops later when processing the
> corrupted transaction.
> 
> Instead, if we detect a corrupted transaction, abort recovery and
> leave the user to clean up the mess that has occurred.
> 
> Signed-off-by: Dave Chinner <david@fromorbit.com>

Seems fine to me (I guess you tried the provided corrupt image?) but the
commit message could be made a bit more ... English ;)

-Eric

> ---
>  fs/xfs/xfs_log_recover.c |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 37c2bf9..1ccc80d 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -1420,7 +1420,13 @@ xlog_recover_add_to_trans(
>  		return 0;
>  	item = trans->r_itemq;
>  	if (item == NULL) {
> -		ASSERT(*(uint *)dp == XFS_TRANS_HEADER_MAGIC);
> +		/* we need to catch log corruptions here */
> +		if (*(uint *)dp != XFS_TRANS_HEADER_MAGIC) {
> +			xlog_warn("XFS: xlog_recover_add_to_trans: "
> +				  "bad header magic number");
> +			ASSERT(0);
> +			return XFS_ERROR(EIO);
> +		}
>  		if (len == sizeof(xfs_trans_header_t))
>  			xlog_recover_add_item(&trans->r_itemq);
>  		memcpy(&trans->r_theader, dp, len); /* d, s, l */
