Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1HHXpw4099345 for <xfs@oss.sgi.com>; Fri, 17 Feb 2012 11:33:51 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	5sUz8di7eS85dXpH (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 17 Feb 2012 09:33:50 -0800 (PST)
Date: Fri, 17 Feb 2012 12:33:48 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/9] xfs: use per-filesystem dquot LRU lists
Message-ID: <20120217173348.GB21796@infradead.org>
References: <20120215022926.577682146@bombadil.infradead.org>
	<20120215023146.847910539@bombadil.infradead.org>
	<20120215221045.GM14132@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120215221045.GM14132@dastard>
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

On Thu, Feb 16, 2012 at 09:10:45AM +1100, Dave Chinner wrote:
> Might be nice to add a
> 
> +	struct xfs_quotainfo	*qi = dqp->q_mount->m_quotainfo;
> 
> here  to make the code a little easier to read and consistent with
> all the other functions.
> 
> Regardless, change looks good.

Makes sense.  I've done that and actually split the real final put
into a separate xfs_qm_dqput_final function, and replaced the tail
recursion with a real recursive call to xfs_qm_dqput for the group
quota.  Given that this is a fairly large amount of changes I didn't
bother to add your reviewed by tag until it's getting re-reviewed.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
