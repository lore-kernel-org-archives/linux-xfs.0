Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBANEagH124696 for <xfs@oss.sgi.com>; Thu, 10 Dec 2009 17:14:37 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 054F71956217
	for <xfs@oss.sgi.com>; Thu, 10 Dec 2009 15:15:12 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id tqtOgzY8BdEfgTrq for
	<xfs@oss.sgi.com>; Thu, 10 Dec 2009 15:15:12 -0800 (PST)
Date: Thu, 10 Dec 2009 18:15:11 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/6] [XFS] rename xfs_get_perag
Message-ID: <20091210231511.GA6389@infradead.org>
References: <1259734299-20306-1-git-send-email-david@fromorbit.com>
	<1259734299-20306-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1259734299-20306-2-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, Dec 02, 2009 at 05:11:34PM +1100, Dave Chinner wrote:
> xfs_get_perag is really getting the perag that an inode
> belongs to based on it's inode number. Rename it appropriately
> so we can use xfs_perag_get() to get the perag from a
> provided ag number.

It does quite a bit more than the description suggests.  I also uses the
new xfs_get_perag in some places and passes the perag around a bit more.

Might be worth splitting or at least needs a better description.

Also I'm not sure the new xfs_perag_get_from_ino is actually all that useful,
opencoding it is more descriptive and barely longer.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
