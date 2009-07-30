Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6UJ2P4m095507 for <xfs@oss.sgi.com>; Thu, 30 Jul 2009 14:02:27 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CE58F10ECDFF
	for <xfs@oss.sgi.com>; Thu, 30 Jul 2009 12:12:10 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Ss79o9fpBKMzVXtw for
	<xfs@oss.sgi.com>; Thu, 30 Jul 2009 12:12:10 -0700 (PDT)
Date: Thu, 30 Jul 2009 15:03:12 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/9] fixes for memory allocator recursions into the
	filesystem
Message-ID: <20090730190312.GA19593@infradead.org>
References: <20090718221452.594956000@bombadil.infradead.org>
	<Pine.LNX.4.64.0907301143510.14757@cobra.newdream.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0907301143510.14757@cobra.newdream.net>
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
To: Sage Weil <sage@newdream.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Jul 30, 2009 at 11:56:58AM -0700, Sage Weil wrote:
> Hi Christoph,
> 
> I just noticed another warning (the same as the second one I sent 
> before) with your patchset applied to 2.6.30.  This is the unresolved 
> iolock issue you mentioned?  Just FYI.

Yes, that's the iolock one.  Patch will follow soon.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
