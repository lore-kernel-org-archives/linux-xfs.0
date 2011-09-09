Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p89KNVlp058339 for <xfs@oss.sgi.com>; Fri, 9 Sep 2011 15:23:31 -0500
Subject: Re: [PATCH 11/25] xfs: factor unwritten extent map manipulations
	out of xfs_bmapi
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110824060642.672916365@bombadil.infradead.org>
References: <20110824060428.789245205@bombadil.infradead.org>
	<20110824060642.672916365@bombadil.infradead.org>
Date: Fri, 9 Sep 2011 15:23:27 -0500
Message-ID: <1315599807.1999.55.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
Cc: Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

On Wed, 2011-08-24 at 02:04 -0400, Christoph Hellwig wrote:
> To further improve the readability of xfs_bmapi(), factor the unwritten
> extent conversion out into a separate function. This removes
> large block of logic from the xfs_bmapi() code loop and makes it
> easier to see the operational logic flow for xfs_bmapi().
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
