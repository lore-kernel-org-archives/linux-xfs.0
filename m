Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0D3587F57
	for <xfs@oss.sgi.com>; Sun,  4 May 2014 16:52:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D69DC8F8035
	for <xfs@oss.sgi.com>; Sun,  4 May 2014 14:52:56 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	m6WM2CZ3PGPx7MpT for <xfs@oss.sgi.com>;
	Sun, 04 May 2014 14:52:54 -0700 (PDT)
Date: Mon, 5 May 2014 07:52:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: attr cleanups
Message-ID: <20140504215241.GQ26353@dastard>
References: <1399130415-5382-1-git-send-email-hch@lst.de>
	<53651375.9080305@sgi.com> <20140504101623.GA4947@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140504101623.GA4947@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On Sun, May 04, 2014 at 12:16:23PM +0200, Christoph Hellwig wrote:
> On Sat, May 03, 2014 at 11:04:05AM -0500, Mark Tinguely wrote:
> > Depends on how parent inode pointers are implemented, this folding the 
> > internal version of get and set attributes could be undone.
> 
> We might have to introduce _locked version at that point.  But I'd like
> to keep the xfs_name removal and other assorted cleanups.

*nod*

If we need to factor the code for new additions, then we should do
that appropriately for the new code when it arrives.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
