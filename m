Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2T7opdC118483 for <xfs@oss.sgi.com>; Sun, 29 Mar 2009 02:51:07 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A6DF813D8349
	for <xfs@oss.sgi.com>; Sun, 29 Mar 2009 00:51:03 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id irszUBy3R9ABQld6 for
	<xfs@oss.sgi.com>; Sun, 29 Mar 2009 00:51:03 -0700 (PDT)
Date: Sun, 29 Mar 2009 03:50:26 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/5] xfs: remove m_attroffset
Message-ID: <20090329075026.GH16402@infradead.org>
References: <20090318094119.561416000@bombadil.infradead.org>
	<20090318094132.430583000@bombadil.infradead.org>
	<20090326194206.GV27222@josefsipek.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090326194206.GV27222@josefsipek.net>
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
To: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Mar 26, 2009 at 03:42:06PM -0400, Josef 'Jeff' Sipek wrote:
> On Wed, Mar 18, 2009 at 05:41:24AM -0400, Christoph Hellwig wrote:
> > With the upcoming v3 inodes the default attroffset needs to be calculated
> > for each specific inode, so we can't cache it in the superblock anymore.
> > 
> > Also replace the assert for wrong inode sizes with a proper error check
> > also included in non-debug builds.  Note that the ENOSYS retourn for
>                                                            ^^^^^^^
> 
> Typo.
> 
> Otherwise it makes sense.
> 
> Josef 'Jeff' Sipek.
> 
> P.S. feel free to consider this an acked-by

Acked or reviewed?  This matters as I still need a formal review for
this one..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
