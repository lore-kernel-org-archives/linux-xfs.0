Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0QKWA0H162975 for <xfs@oss.sgi.com>; Wed, 26 Jan 2011 14:32:10 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E3C02154A059
	for <xfs@oss.sgi.com>; Wed, 26 Jan 2011 12:34:34 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id iVuBnkJzZydPuQPw for
	<xfs@oss.sgi.com>; Wed, 26 Jan 2011 12:34:34 -0800 (PST)
Date: Wed, 26 Jan 2011 15:34:33 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/4] xfstests: make 016 work with delaylog
Message-ID: <20110126203433.GC19159@infradead.org>
References: <1295927937-20634-1-git-send-email-david@fromorbit.com>
	<1295927937-20634-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1295927937-20634-4-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

> @@ -101,7 +101,9 @@ _log_traffic()
>      while [ $count -ge 0 ]
>      do
>          touch $out
> +	sync
>          rm $out
> +	sync
>          let "count = count - 1"
>      done

Looks good, although it might be good to make the indentation fit the
surrounding code.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
