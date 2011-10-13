Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9DB6hNK167983 for <xfs@oss.sgi.com>; Thu, 13 Oct 2011 06:06:43 -0500
Subject: Re: [PATCH 1/3] xfstests: fix 122 for recent xfsprogs
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20111010182156.GA1323@infradead.org>
References: <20111010182156.GA1323@infradead.org>
Date: Thu, 13 Oct 2011 06:06:39 -0500
Message-ID: <1318503999.3172.27.camel@doink>
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
Cc: xfs@oss.sgi.com

On Mon, 2011-10-10 at 14:21 -0400, Christoph Hellwig wrote:
> - filter out xfs_alloctype_t, this was an internal emum that got removed
>  - filter out xfs_bmbt_rec_32_t, this is a variant of the xfs_bmbt_rec_t
>    that had almost no users and was removed
>  - filter out xfs_dinode_core_t, the separate dinode core is gone, and just
>    checking the size of the full dinode is enough
>  - accept xfs_bmbt_rec_t as the new canonical name for xfs_bmbt_rec_64_t,
>    and replace the old name with the new one in the output stream.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
