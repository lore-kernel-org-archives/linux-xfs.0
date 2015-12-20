Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 99A527F3F
	for <xfs@oss.sgi.com>; Sun, 20 Dec 2015 17:51:06 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 77B008F8033
	for <xfs@oss.sgi.com>; Sun, 20 Dec 2015 15:51:06 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	lhgNxrwmdDxOOuoW for <xfs@oss.sgi.com>;
	Sun, 20 Dec 2015 15:51:03 -0800 (PST)
Date: Mon, 21 Dec 2015 10:51:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 3/4] xfsprogs: mkfs: fix unintentional integer overflow
Message-ID: <20151220235101.GW26718@dastard>
References: <1449832143-26356-1-git-send-email-t.vivek@samsung.com>
	<1449832143-26356-4-git-send-email-t.vivek@samsung.com>
	<20151220153649.GE20135@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151220153649.GE20135@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: a.sahrawat@samsung.com, xfs@oss.sgi.com, Vivek Trivedi <t.vivek@samsung.com>, pankaj.m@samsung.com

On Sun, Dec 20, 2015 at 07:36:49AM -0800, Christoph Hellwig wrote:
> > +++ b/mkfs/xfs_mkfs.c
> > @@ -2022,7 +2022,7 @@ _("warning: sparse inodes not supported without CRC support, disabled.\n"));
> >  		 * and the underlying volume is striped, then set rtextblocks
> >  		 * to the stripe width.
> >  		 */
> > -		int		rswidth;
> > +		__uint64_t	rswidth;
> >  		__uint64_t	rtextbytes;
> 
> This looks odd.  We initiallize assigned ft.rtswidth (which is an int)
> or 0 to it.  I think you want a separate variable for the result of
> the  DTOBT(rswidth) statement to make this clear.

I don't see any point in doing that. It really doesn't matter that
the variable it is initialised from is only a 32 bit int, and having
yet another variable in mkfs is not going to make the code easier to
understand...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
