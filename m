Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0J9KXfp180231 for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 03:20:34 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D3A46F1EC96
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 01:21:33 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Ggjf2kZyAXLTE3Xy for
	<xfs@oss.sgi.com>; Tue, 19 Jan 2010 01:21:33 -0800 (PST)
Date: Tue, 19 Jan 2010 04:21:33 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/7] xfsprogs: fix some trivial warnings in xfs_db
Message-ID: <20100119092133.GB1784@infradead.org>
References: <1263861413-13729-1-git-send-email-david@fromorbit.com>
	<1263861413-13729-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1263861413-13729-4-git-send-email-david@fromorbit.com>
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

On Tue, Jan 19, 2010 at 11:36:49AM +1100, Dave Chinner wrote:
> -		xname.name = (char *)dep->name;
> +		xname.name = (uchar_t *)dep->name;

Aren't these both unsigned after the latest version of the signedness
patches are in?

Maybe just put the other one in for now.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
