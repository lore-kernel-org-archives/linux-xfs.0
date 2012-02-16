Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1GKNuSH016442 for <xfs@oss.sgi.com>; Thu, 16 Feb 2012 14:23:56 -0600
Date: Thu, 16 Feb 2012 14:23:59 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [patch 06/12] xfs: add the xlog_grant_head structure
Message-ID: <20120216202359.GU7762@sgi.com>
References: <20111212141346.986825692@bombadil.infradead.org>
	<20111212141434.475114637@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111212141434.475114637@bombadil.infradead.org>
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

On Mon, Dec 12, 2011 at 09:13:53AM -0500, Christoph Hellwig wrote:
> Add a new data structure to allow sharing code between the log grant and
> regrant code.

Each xlog_grant_head structure contains the three related items
currently defined separately for each of the reserve and write grant
heads in the log. 

Looks good.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
