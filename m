Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9M8SxF2073634 for <xfs@oss.sgi.com>; Thu, 22 Oct 2009 03:29:00 -0500
Date: Thu, 22 Oct 2009 10:30:22 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [xfs-masters] Inconsistent {RECLAIM_FS-ON-R} -> {IN-RECLAIM_FS-W}
	usage in XFS
Message-ID: <20091022083022.GB27577@lst.de>
References: <4ACB3AC5.4010603@vlnb.net> <20091006131020.GA12343@infradead.org>
	<4ADF36E3.8080801@sandeen.net>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4ADF36E3.8080801@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-masters@oss.sgi.com, Vladislav Bolkhovitin <vst@vlnb.net>, xfs@oss.sgi.com

On Wed, Oct 21, 2009 at 11:29:23AM -0500, Eric Sandeen wrote:
> > The lockdep code to track this has been recently introduced.
> > 
> > I've sent some patches to fix it ages ago, but so far no one has
> > bothered to review them.
> 
> Christoph, remind me again which patch and I'll try to find time now
> that I'm getting Fedora bug reports.  :)

I've recentlhy sent out some even simpler patches to sort this out, see
here:

	http://oss.sgi.com/pipermail/xfs/2009-October/042857.html
	http://oss.sgi.com/pipermail/xfs/2009-October/042858.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
