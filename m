Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2QJgsJ2185088 for <xfs@oss.sgi.com>; Thu, 26 Mar 2009 14:43:04 -0500
Received: from josefsipek.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E8B8E1C9E74
	for <xfs@oss.sgi.com>; Thu, 26 Mar 2009 12:42:07 -0700 (PDT)
Received: from josefsipek.net (josefsipek.net [141.211.133.196]) by
	cuda.sgi.com with ESMTP id Ja3KxeWuKo3fAgrh for
	<xfs@oss.sgi.com>; Thu, 26 Mar 2009 12:42:07 -0700 (PDT)
Date: Thu, 26 Mar 2009 15:42:06 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [PATCH 5/5] xfs: remove m_attroffset
Message-ID: <20090326194206.GV27222@josefsipek.net>
References: <20090318094119.561416000@bombadil.infradead.org>
	<20090318094132.430583000@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090318094132.430583000@bombadil.infradead.org>
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

On Wed, Mar 18, 2009 at 05:41:24AM -0400, Christoph Hellwig wrote:
> With the upcoming v3 inodes the default attroffset needs to be calculated
> for each specific inode, so we can't cache it in the superblock anymore.
> 
> Also replace the assert for wrong inode sizes with a proper error check
> also included in non-debug builds.  Note that the ENOSYS retourn for
                                                           ^^^^^^^

Typo.

Otherwise it makes sense.

Josef 'Jeff' Sipek.

P.S. feel free to consider this an acked-by

-- 
The reasonable man adapts himself to the world; the unreasonable one
persists in trying to adapt the world to himself. Therefore all progress
depends on the unreasonable man.
		- George Bernard Shaw

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
