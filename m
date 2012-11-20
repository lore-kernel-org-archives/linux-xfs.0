Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAK3djAA095086 for <xfs@oss.sgi.com>; Mon, 19 Nov 2012 21:39:45 -0600
Message-ID: <50AAFBFF.10900@sgi.com>
Date: Mon, 19 Nov 2012 21:41:51 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_quota: correctly initialise the default path
References: <1353028488-24436-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1353028488-24436-1-git-send-email-david@fromorbit.com>
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

On 11/15/12 19:14, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>

> +	if (argc != optind)
> +		fs_path = fs_table_lookup(argv[optind], FS_MOUNT_POINT);

If specified device is not in the table, then the program will give an 
error before getting here, so this cannot return a NULL as I previously 
was concerned about. So this does in fact look good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
