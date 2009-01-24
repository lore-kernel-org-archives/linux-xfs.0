Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0O3idfQ245389 for <xfs@oss.sgi.com>; Fri, 23 Jan 2009 21:44:39 -0600
Date: Fri, 23 Jan 2009 22:43:55 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] [XFS] Warn on transaction in flight on read-only remount
Message-ID: <20090124034355.GA22302@infradead.org>
References: <1232691270-3826-1-git-send-email-felixb@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1232691270-3826-1-git-send-email-felixb@sgi.com>
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
To: Felix Blyakher <felixb@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Jan 23, 2009 at 12:14:30AM -0600, Felix Blyakher wrote:
> Till VFS can correctly support read-only remount without racing,
> use WARN_ON instead of BUG_ON on detecting transaction in flight
> after quiescing filesystem.
> 
> Signed-off-by: Felix Blyakher <felixb@sgi.com>

Looks good to me.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
