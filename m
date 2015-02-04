Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 213587FB9
	for <xfs@oss.sgi.com>; Wed,  4 Feb 2015 01:58:04 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 013B4304084
	for <xfs@oss.sgi.com>; Tue,  3 Feb 2015 23:58:00 -0800 (PST)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id A4vU1j2yzLeOapgS (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 03 Feb 2015 23:57:59 -0800 (PST)
Date: Wed, 4 Feb 2015 08:57:56 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 16/20] xfs: pass a 64-bit count argument to
	xfs_iomap_write_unwritten
Message-ID: <20150204075756.GA763@lst.de>
References: <1421925006-24231-1-git-send-email-hch@lst.de>
	<1421925006-24231-17-git-send-email-hch@lst.de>
	<20150129205232.GB11064@fieldses.org>
	<20150202073024.GA9399@lst.de> <20150202192404.GI6282@dastard>
	<20150202194300.GN6282@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150202194300.GN6282@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-nfs@vger.kernel.org, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@primarydata.com>, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Tue, Feb 03, 2015 at 06:43:00AM +1100, Dave Chinner wrote:
> As to the pNFSD specific changes, I haven't really looked them over
> in any great detail yet. My main concern is that there are no
> specific regression tests for this yet, I'm not sure how we go about
> verifying it actually works properly and we don't inadvertantly
> break it in the future. Christoph?

Any chance you could review them this week so we can get them
merged in time for 3.20?  In the worst case Bruce will have to pull
the xfs tree into the nfsd tree so that we have all the dependencies
available.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
