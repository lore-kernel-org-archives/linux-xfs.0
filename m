Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB3AqjFc010927 for <xfs@oss.sgi.com>; Wed, 3 Dec 2008 04:52:45 -0600
Date: Wed, 3 Dec 2008 05:52:44 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 11/22] cleanup xfs_sb.h feature flag helpers
Message-ID: <20081203105244.GI15485@infradead.org>
References: <20081202160430.775774000@bombadil.infradead.org>
	<20081202160651.115809000@bombadil.infradead.org>
	<49362688.4030200@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49362688.4030200@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Donald Douwsma <donaldd@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Dec 03, 2008 at 05:26:16PM +1100, Donald Douwsma wrote:
> Christoph Hellwig wrote:
> 
> Looks ok, I think all these used to be macros, but when they got cleaned up
> a lot of grogens were left in place. I wish we could get all this kind of thing
> cleaned up right first time...

I think this was Nathan's big sweap to kill xfs_macros.[ch] for the ugly
marcros turning into macros calling functions calling the original macro
crap.  He did this in some sort of scripted way and a lot of things like
this were left in place.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
