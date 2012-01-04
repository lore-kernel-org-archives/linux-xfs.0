Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q04Igih5163563 for <xfs@oss.sgi.com>; Wed, 4 Jan 2012 12:42:44 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	jcSxgpKBaJPXSNbZ for <xfs@oss.sgi.com>;
	Wed, 04 Jan 2012 10:42:43 -0800 (PST)
Date: Wed, 4 Jan 2012 13:42:42 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 276: fix up various issues
Message-ID: <20120104184242.GD8131@infradead.org>
References: <1325699686-21851-1-git-send-email-list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1325699686-21851-1-git-send-email-list.btrfs@jan-o-sch.net>
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
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: hch@infradead.org, sandeen@sandeen.net, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Wed, Jan 04, 2012 at 06:54:46PM +0100, Jan Schmidt wrote:
> This commit fixes bd8ee45c. Changes:
> - added a _require_btrfs helper function
> - check for filefrag with _require_command
> - always use _fail in case of errors
> - added some comments
> - removed $fresh code
> - don't set FSTYP
> 
> Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>

Thanks, applied.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
