Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBGLIp2x068921 for <xfs@oss.sgi.com>; Fri, 16 Dec 2011 15:18:52 -0600
Date: Fri, 16 Dec 2011 15:19:16 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: fix acl count validation in xfs_acl_from_disk()
Message-ID: <20111216211916.GO29840@sgi.com>
References: <1323726952-22963-1-git-send-email-xi.wang@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1323726952-22963-1-git-send-email-xi.wang@gmail.com>
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
To: Xi Wang <xi.wang@gmail.com>
Cc: xfs@oss.sgi.com, Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 04:55:52PM -0500, Xi Wang wrote:
> Commit fa8b18ed didn't prevent the integer overflow and possible
> memory corruption.  "count" can go negative and bypass the check.
> 
> Signed-off-by: Xi Wang <xi.wang@gmail.com>

Looks good.  Nice catch!
Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
