Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9144F7F37
	for <xfs@oss.sgi.com>; Wed, 14 Aug 2013 00:35:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7D0D5304043
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 22:35:33 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	PbLU0rCRZn8lcDJb for <xfs@oss.sgi.com>;
	Tue, 13 Aug 2013 22:35:28 -0700 (PDT)
Date: Wed, 14 Aug 2013 15:35:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3] xfs: introduce object readahead to log recovery
Message-ID: <20130814053523.GY12779@dastard>
References: <1375260165-8773-1-git-send-email-zwu.kernel@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1375260165-8773-1-git-send-email-zwu.kernel@gmail.com>
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
To: zwu.kernel@gmail.com
Cc: linux-fsdevel@vger.kernel.org, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Wed, Jul 31, 2013 at 04:42:45PM +0800, zwu.kernel@gmail.com wrote:
> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> 
>   It can take a long time to run log recovery operation because it is
> single threaded and is bound by read latency. We can find that it took
> most of the time to wait for the read IO to occur, so if one object
> readahead is introduced to log recovery, it will obviously reduce the
> log recovery time.
> 
> Log recovery time stat:
> 
>           w/o this patch        w/ this patch
> 
> real:        0m15.023s             0m7.802s
> user:        0m0.001s              0m0.001s
> sys:         0m0.246s              0m0.107s

This version works as advertised as well.

> @@ -3216,6 +3351,18 @@ xlog_recover_commit_trans(
>  			goto out;
>  	}
>  
> +	if (!list_empty(&ra_list)) {
> +		error = xlog_recover_items_pass2(log, trans,
> +				&buffer_list, &ra_list);
> +		if (error)
> +			goto out;
> +
> +		list_splice_tail_init(&ra_list, &done_list);
> +	}
> +
> +	if (!list_empty(&done_list))
> +		list_splice_init(&done_list, &trans->r_itemq);
> +
>  	xlog_recover_free_trans(trans);

I think this still leaks the trans structure when an error occurs.
Indeed, I think this is a pre-existing leak, as the current code
will skip freeing the trans structure on item recovery failure and
nothing else frees it.  So it appears to me to be busted before this
patch is added.

Hence on a xlog_recover_items_pass2() error we need to splice the
ra-list to the done_list and free trans. i.e. the "if (error) goto
out;" lines in the above hunk do not need to be there, and the
"out:" label moved to above the call to xlog_recover_free_trans() so
the main loop does the right thing when an error occurs.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
