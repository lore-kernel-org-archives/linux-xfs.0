Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p92Hx7xp141423 for <xfs@oss.sgi.com>; Sun, 2 Oct 2011 12:59:07 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DE97D558E3F
	for <xfs@oss.sgi.com>; Sun,  2 Oct 2011 10:59:03 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	be5UmQTple3v220X for <xfs@oss.sgi.com>;
	Sun, 02 Oct 2011 10:59:03 -0700 (PDT)
Date: Sun, 2 Oct 2011 13:59:02 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: SEEK_DATA/SEEK_HOLE support
Message-ID: <20111002175902.GA9420@infradead.org>
References: <4E887D7F.2010306@oracle.com>
	<20111002154259.GA14543@infradead.org>
	<4E888C0D.9060701@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E888C0D.9060701@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: xfs@oss.sgi.com

On Mon, Oct 03, 2011 at 12:06:37AM +0800, Jeff Liu wrote:
> IMHO, to avoid data loss in some user application like cp(1), for
> unwritten extents, we always need to check the pages status.  Just as
> you mentioned above, return the map offset if pages are dirty for
> SEEK_DATA, or a hole found.

I'd suggest to first implement the simple versions I schemed below,
which would treat unwritten extents as data.  That is sub-optimal,
but a) safe and b) easy to implement.  The second step would be to
add probing for unwritten extents, which is even something we could
do as a common helper routine shared by filesystems.

And the most important thing is of course adding QA for it.  Josef
already wrote an xfstests case that needs to be resurrected, compared
against the latest Posix draft and if nessecary updated.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
