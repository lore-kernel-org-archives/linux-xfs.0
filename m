Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAEK5vpc235995 for <xfs@oss.sgi.com>; Mon, 14 Nov 2011 14:05:57 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 843D81E9BE22
	for <xfs@oss.sgi.com>; Mon, 14 Nov 2011 12:05:56 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	POnQcbxbRfgQiVad for <xfs@oss.sgi.com>;
	Mon, 14 Nov 2011 12:05:56 -0800 (PST)
Date: Mon, 14 Nov 2011 15:05:54 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs_getbmap assert
Message-ID: <20111114200554.GA21487@infradead.org>
References: <20111107103037.GA16213@infradead.org>
	<20111107201505.GE5534@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111107201505.GE5534@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Nov 08, 2011 at 07:15:05AM +1100, Dave Chinner wrote:
> Can you see if that is the case that is being triggered?

I've tried to reproduce the issue with additional debugging for almost
a week now, but I haven't been able to hit the assert again yet.  Which
is strange given how often I managed to hit it just before.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
