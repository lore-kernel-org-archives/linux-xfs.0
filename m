Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n097Ufvw021066 for <xfs@oss.sgi.com>; Fri, 9 Jan 2009 01:30:43 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1284F17C3DA7
	for <xfs@oss.sgi.com>; Thu,  8 Jan 2009 23:20:32 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 15cypoc4yf5JBAwD for
	<xfs@oss.sgi.com>; Thu, 08 Jan 2009 23:20:32 -0800 (PST)
Date: Fri, 9 Jan 2009 02:20:01 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] attr: fix include/ symlink creation (again)
Message-ID: <20090109072001.GA9577@infradead.org>
References: <49664EF7.20707@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49664EF7.20707@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs mailing list <xfs@oss.sgi.com>

On Thu, Jan 08, 2009 at 01:07:35PM -0600, Eric Sandeen wrote:
> We need the "default" target first, otherwise a simple "make -C include"
> only ran the $(INCDIR) target, missing disk, and failures ensued.

Looks good, too.  I wonder why attr uses INCDIR instead of just spelling
out the name like all other packages..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
