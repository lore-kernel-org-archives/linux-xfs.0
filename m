Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6309D7F91
	for <xfs@oss.sgi.com>; Fri, 15 Nov 2013 10:39:16 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 551D78F8052
	for <xfs@oss.sgi.com>; Fri, 15 Nov 2013 08:39:13 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id QExVKkfPJIKXTIox for
	<xfs@oss.sgi.com>; Fri, 15 Nov 2013 08:39:09 -0800 (PST)
Date: Fri, 15 Nov 2013 17:39:57 +0100
From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 3/6] gfs2: simplify current_tail() via
	list_last_entry_or_null()
Message-ID: <20131115163957.GA28467@redhat.com>
References: <5285A3F4.4040000@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5285A3F4.4040000@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: jfs-discussion@lists.sourceforge.net, jiri@resnulli.us, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, cluster-devel@redhat.com, linux-mtd@lists.infradead.org, akpm@linux-foundation.org

On 11/15, Jeff Liu wrote:
>
> @@ -441,13 +441,9 @@ static unsigned int current_tail(struct gfs2_sbd *sdp)
>  
>  	spin_lock(&sdp->sd_ail_lock);
>  
> -	if (list_empty(&sdp->sd_ail1_list)) {
> -		tail = sdp->sd_log_head;
> -	} else {
> -		tr = list_entry(sdp->sd_ail1_list.prev, struct gfs2_trans,
> -				tr_list);
> -		tail = tr->tr_first;
> -	}
> +	tr = list_last_entry_or_null(&sdp->sd_ail1_list, struct gfs2_trans,
> +				     tr_list);
> +	tail = tr ? tr->tr_first : sdp->sd_log_head;
>  

Personally I agree with Steven. At least in this case
list_last_entry_or_null() doesn't really help to simplify the code.

But probably list_last_entry() makes sense in the "else" branch,
athough this is minor.


Off-topic. Not sure this really makes sense, but I was thinking about

	list_get_first(pos, head, member)	\
		((pos) = list_first_entry(head, typeof(*pos), member))

and list_get_first() last of course. The obvious advantage is that
compared to

	tr = list_last_entry(sdp->sd_ail1_list, struct gfs2_trans, tr_list);

above you do not need to type "struct gfs2_trans",

	list_get_last(tr, sdp->sd_ail1_list, tr_list);

looks a bit better.

Oleg.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
