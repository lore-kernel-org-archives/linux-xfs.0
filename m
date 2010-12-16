Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBGBs7xG046924 for <xfs@oss.sgi.com>; Thu, 16 Dec 2010 05:54:09 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2505E1CD1F9A
	for <xfs@oss.sgi.com>; Thu, 16 Dec 2010 03:56:02 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id zfLxfPmgEVtu9tTS for
	<xfs@oss.sgi.com>; Thu, 16 Dec 2010 03:56:02 -0800 (PST)
Date: Thu, 16 Dec 2010 06:56:01 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfstests: filter spaces in xfs_quota output in test case 108
Message-ID: <20101216115601.GA20445@infradead.org>
References: <1292425538.3220.14.camel@dhcp-31-190.brq.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1292425538.3220.14.camel@dhcp-31-190.brq.redhat.com>
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
To: Boris Ranto <branto@redhat.com>
Cc: xfs <xfs@oss.sgi.com>

On Wed, Dec 15, 2010 at 04:05:38PM +0100, Boris Ranto wrote:
> Program xfs_quota can output different amounts of spaces when it is trying to align its output.
> This can cause output mismatch on several systems when testing test case 108.
> 
> Attached patch will filter all the consecutive spaces in xfs_quota output to just one space making the test case independent of the alignment.
> 

Thanks, applied.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
