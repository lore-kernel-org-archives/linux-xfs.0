Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0KDMF2U088613 for <xfs@oss.sgi.com>; Thu, 20 Jan 2011 07:22:16 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A00921624674
	for <xfs@oss.sgi.com>; Thu, 20 Jan 2011 05:24:35 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Z9Xp8BOCUkStEulB for
	<xfs@oss.sgi.com>; Thu, 20 Jan 2011 05:24:35 -0800 (PST)
Date: Thu, 20 Jan 2011 08:24:31 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfssyncd and disk spin down
Message-ID: <20110120132431.GA306@infradead.org>
References: <20101223165532.GA23813@peter.simplex.ro>
	<20101227021904.GA24828@dastard>
	<20101227061629.GA2275@pandora.simplex.ro>
	<20101227140750.GB24828@dastard>
	<20101227171939.GA7759@pandora.simplex.ro>
	<20101231001323.GD15179@dastard>
	<20110120100143.GA2007@peter.simplex.ro>
	<20110120110605.GU16267@dastard>
	<20110120120700.GA5449@peter.simplex.ro>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110120120700.GA5449@peter.simplex.ro>
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
To: Petre Rodan <petre.rodan@simplex.ro>
Cc: xfs@oss.sgi.com

On Thu, Jan 20, 2011 at 02:07:00PM +0200, Petre Rodan wrote:
> thanks for the tip. looks like I'm using xfsprogs 3.0.3 (latest version in the gentoo stable tree) to mkfs these filesystems. can the antique version be somehow the root of the problem?

Yes, lazy-count has been the default since xfsprogs 3.1.0.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
