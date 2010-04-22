Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3MGLRXF214065 for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 11:21:28 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0D7321302E13
	for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 09:23:26 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id ooobIt6BdfigzPE6 for
	<xfs@oss.sgi.com>; Thu, 22 Apr 2010 09:23:26 -0700 (PDT)
Date: Thu, 22 Apr 2010 12:23:26 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: is realtime device supported?
Message-ID: <20100422162325.GA29668@infradead.org>
References: <20100422144939.GA3822@laptop.oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100422144939.GA3822@laptop.oracle.com>
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
To: Wengang Wang <wen.gang.wang@oracle.com>
Cc: greg.marsden@oracle.com, joe.jin@oracle.com, xfs@oss.sgi.com

On Thu, Apr 22, 2010 at 10:49:39PM +0800, Wengang Wang wrote:
> Do we support realtime device?
> 
> I got the following error:

It sounds like you do not have CONFIG_XFS_RT enable in your kernel
configuration.  But to answer your original question the realtime
device is not supported in the sense of actively maintained.  The
code is still there, but more or less for legacy reasons.  I would
not recommend it for new installations.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
