Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q12I7Adm068001 for <xfs@oss.sgi.com>; Thu, 2 Feb 2012 12:07:10 -0600
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 8AvnvzZALWIb6RRK (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 02 Feb 2012 10:07:09 -0800 (PST)
Date: Thu, 2 Feb 2012 19:07:07 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/3] include reservations in quota reporting
Message-ID: <20120202180707.GB7494@quack.suse.cz>
References: <20120202161409.303465214@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120202161409.303465214@bombadil.infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: jack@suse.cz, xfs@oss.sgi.com

On Thu 02-02-12 11:14:09, Christoph Hellwig wrote:
> This series makes sure quota reporting through quotactl, or in case of
> project quotas, statfs includes quota reservation in addition to the
> on-disk values.  This fixes xfstests 270, which has been failing on XFS
> since it was added, and makes the Q_XQUOTASYNC quotactl command that
> xfs_quota uses to flush delalloc space redundant.
> 
> Jan, the last patch touches common quota code, but it's only relevant
> to XFS - I'd like to put it in through the XFS tree if possible.
  Sure. The patch is trivial so conflicts are unlikely.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
