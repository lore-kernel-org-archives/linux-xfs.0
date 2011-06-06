Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p56F1Wq9236547 for <xfs@oss.sgi.com>; Mon, 6 Jun 2011 10:01:32 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DAEB04A1CE0
	for <xfs@oss.sgi.com>; Mon,  6 Jun 2011 08:01:26 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	rhhIObdySeHLuQgO for <xfs@oss.sgi.com>;
	Mon, 06 Jun 2011 08:01:26 -0700 (PDT)
Date: Mon, 6 Jun 2011 11:01:25 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] fix ->mknod() return value on xfs_get_acl() failure
Message-ID: <20110606150125.GA22236@infradead.org>
References: <20110605111231.GD11521@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110605111231.GD11521@ZenIV.linux.org.uk>
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
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Sun, Jun 05, 2011 at 12:12:31PM +0100, Al Viro wrote:
> 	->mknod() should return negative on errors and PTR_ERR() gives
> already negative value...

Indeed.  Thanks for the patch.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
