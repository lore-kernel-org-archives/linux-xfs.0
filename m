Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBANOv0F125657 for <xfs@oss.sgi.com>; Thu, 10 Dec 2009 17:24:58 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B4D3DE969A
	for <xfs@oss.sgi.com>; Thu, 10 Dec 2009 15:25:32 -0800 (PST)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	iNodp7tCiWmoUcyS for <xfs@oss.sgi.com>;
	Thu, 10 Dec 2009 15:25:32 -0800 (PST)
Date: Fri, 11 Dec 2009 10:25:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/6] [XFS] rename xfs_get_perag
Message-ID: <20091210232529.GD30608@discord.disaster>
References: <1259734299-20306-1-git-send-email-david@fromorbit.com>
	<1259734299-20306-2-git-send-email-david@fromorbit.com>
	<20091210231511.GA6389@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20091210231511.GA6389@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, Dec 10, 2009 at 06:15:11PM -0500, Christoph Hellwig wrote:
> On Wed, Dec 02, 2009 at 05:11:34PM +1100, Dave Chinner wrote:
> > xfs_get_perag is really getting the perag that an inode
> > belongs to based on it's inode number. Rename it appropriately
> > so we can use xfs_perag_get() to get the perag from a
> > provided ag number.
> 
> It does quite a bit more than the description suggests.  I also uses the
> new xfs_get_perag in some places and passes the perag around a bit more.

True - the patch grew beyond it's initial description...

> Might be worth splitting or at least needs a better description.

Better description. ;)

> Also I'm not sure the new xfs_perag_get_from_ino is actually all that useful,
> opencoding it is more descriptive and barely longer.

Ok, I'll redo it and open code all these as well.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
