Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p96JnFY3198288 for <xfs@oss.sgi.com>; Thu, 6 Oct 2011 14:49:15 -0500
Date: Thu, 6 Oct 2011 15:49:13 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: 261: test failures caused by bogus mtab entries
Message-ID: <20111006194913.GF13434@infradead.org>
References: <201110032301.p93N1ISR023771@stout.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201110032301.p93N1ISR023771@stout.americas.sgi.com>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

> +mtab=/proc/self/mounts
> +if [ ! -r "${mtab}" ]; then
> +    mtab=/etc/mtab
> +    if [ ! -r "${mtab}" ]; then
> +	echo "warning: proceeding without use of mount table" >&2
> +    fi
> +fi

Just use /proc/self/mounts unconditionally, it's been there for a long
time.

Otherwise looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
