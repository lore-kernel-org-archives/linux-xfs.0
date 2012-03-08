Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q28K8n5f060854 for <xfs@oss.sgi.com>; Thu, 8 Mar 2012 14:08:49 -0600
Date: Thu, 8 Mar 2012 14:08:55 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 0/8] log all inode updates V3
Message-ID: <20120308200855.GY7762@sgi.com>
References: <20120229095347.009884687@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120229095347.009884687@bombadil.infradead.org>
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
Cc: xfs@oss.sgi.com

On Wed, Feb 29, 2012 at 04:53:47AM -0500, Christoph Hellwig wrote:
> Changes since V2:
>   - address more review feedback
> 
> Changes since V1:
>   - address all review feedback
>   - reimplement an optimized fdatasync

I believe this series is ready to go except for my concern about
xfs_ioend_is_append, which needs to go over all of the ioends in order
to determine whether an append is possible, not just the first.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
