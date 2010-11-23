Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oANDgr1o215798 for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 07:42:53 -0600
Date: Tue, 23 Nov 2010 08:44:30 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 9/9] xfsrestore: check for compatible xfsrestore
Message-ID: <20101123134430.GA30548@infradead.org>
References: <20101116150502.179825893@sgi.com>
	<20101116150705.423217632@sgi.com>
	<20101117093842.GI17317@infradead.org> <4CE3F55C.9080902@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4CE3F55C.9080902@sgi.com>
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
To: Bill Kendall <wkendall@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Nov 17, 2010 at 09:31:40AM -0600, Bill Kendall wrote:
> Just to be clear, the state information is used only for the life of
> a series of restores. You restore your level 0 dump, then run restore
> again on your level 1, and so on. After that the state information is not
> used and would be deleted.
> 
> Given how unlikely it is for someone to start a restore on one system
> and continue it on another (incompatible) system, and since your suggested
> change would ripple out into all the code that touches any of the on-disk
> structures, I'd prefer to simply detect a change in the size of types. I
> would think that recording/checking the size of a pointer would be
> sufficient, assuming your main concern is type size differences between
> 32-bit and 64-bit systems.

Ok, still not nice, but no reason to revamp all of xfsdump due to this.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
