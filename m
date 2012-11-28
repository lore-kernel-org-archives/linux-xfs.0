Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qASDQegt181770 for <xfs@oss.sgi.com>; Wed, 28 Nov 2012 07:26:40 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	ZC1CMQ7c6rvJlEaP (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 28 Nov 2012 05:28:57 -0800 (PST)
Date: Wed, 28 Nov 2012 08:28:56 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/4] xfs: fix stray dquot unlock when reclaiming dquots
Message-ID: <20121128132856.GB2765@infradead.org>
References: <1354068063-1692-1-git-send-email-david@fromorbit.com>
	<1354068063-1692-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1354068063-1692-4-git-send-email-david@fromorbit.com>
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

On Wed, Nov 28, 2012 at 01:01:02PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When we fail to get a dquot lock during reclaim, we jump to an error
> handler that unlocks the dquot. This is wrong as we didn't lock the
> dquot, and unlocking it means who-ever is holding the lock has had
> it silently taken away, and hence it results in a lock imbalance.
> 
> Found by inspection while modifying the code for the numa-lru
> patchset. This fixes a random hang I've been seeing on xfstest 232
> for the past several months.

Ooops. I'm kinda surprise the mutex code never cought the double unlock.
Beeing able to detect this was on of the sellings points for it vs the
old semaphores.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
