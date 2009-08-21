Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7LHRGPp184155 for <xfs@oss.sgi.com>; Fri, 21 Aug 2009 12:27:31 -0500
Date: Fri, 21 Aug 2009 19:28:01 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 13/17] xfs: Convert sync_page_range() to simple
	fdatawrite_range()
Message-ID: <20090821172801.GA30254@lst.de>
References: <1250875447-15622-1-git-send-email-jack@suse.cz>
	<1250875447-15622-14-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1250875447-15622-14-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, LKML <linux-kernel@vger.kernel.org>, hch@lst.de

On Fri, Aug 21, 2009 at 07:24:03PM +0200, Jan Kara wrote:
> +		error2 = filemap_fdatawrite_range(mapping, pos, pos + ret - 1);

I think this should be a filemap_write_and_wait_range

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
