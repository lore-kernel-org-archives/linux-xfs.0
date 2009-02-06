Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n167Hvk6006515 for <xfs@oss.sgi.com>; Fri, 6 Feb 2009 01:18:00 -0600
Date: Fri, 6 Feb 2009 02:17:17 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 09/17] xfs: cleanup xfs_find_handle
Message-ID: <20090206071717.GA3295@infradead.org>
References: <20090126073136.384490000@bombadil.infradead.org>
	<20090126073202.277472000@bombadil.infradead.org>
	<F4717E19-7A7F-40CD-BAEB-7AE519E797D0@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <F4717E19-7A7F-40CD-BAEB-7AE519E797D0@sgi.com>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Feb 05, 2009 at 11:20:22PM -0600, Felix Blyakher wrote:
> Do we want to verify here that cmd is either XFS_IOC_PATH_TO_FSHANDLE
> or XFS_IOC_PATH_TO_HANDLE ...

It's called in a single place for just these three subcases, so having
another verification here doesn't seem juseful.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
