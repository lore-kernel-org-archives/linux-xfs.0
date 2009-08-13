Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7DDmXM7024412 for <xfs@oss.sgi.com>; Thu, 13 Aug 2009 08:48:48 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3F8DA3C7DDE
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2009 06:49:18 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id THLDd9KPK3LTK41I for
	<xfs@oss.sgi.com>; Thu, 13 Aug 2009 06:49:18 -0700 (PDT)
Date: Thu, 13 Aug 2009 09:49:18 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: fs change on read-only mount
Message-ID: <20090813134918.GA6464@infradead.org>
References: <4A84090A.6040601@bgs.hu> <20090813131407.GA1088@infradead.org>
	<4A84195C.8070002@bgs.hu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A84195C.8070002@bgs.hu>
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
To: Bgs <bgs@bgs.hu>
Cc: SGI Project XFS mailing list <xfs@oss.sgi.com>

On Thu, Aug 13, 2009 at 03:47:08PM +0200, Bgs wrote:
> 
>  Thanks for the fast answer.
> 
> So the following scenarios should be ok:
> 
> 1) Normal boot (no crash, previous mount was ro as well, journal empty)
> -> mount ro from the beginning => partition hash stays the same
> 
> 2) Mount rw at any point -> make changes -> remount ro -> sync -> create
>  new hash -> next boot with ro mount has this new hash.

Yes.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
