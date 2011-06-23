Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5NB3Jrc178690 for <xfs@oss.sgi.com>; Thu, 23 Jun 2011 06:03:20 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D250215E70EF
	for <xfs@oss.sgi.com>; Thu, 23 Jun 2011 04:03:18 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	bj3QjxPh3SZ0h08A for <xfs@oss.sgi.com>;
	Thu, 23 Jun 2011 04:03:18 -0700 (PDT)
Date: Thu, 23 Jun 2011 07:03:18 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: duplicate code in dir2
Message-ID: <20110623110317.GA21174@infradead.org>
References: <4E020912.9020106@sandeen.net>
 <4E020977.9080000@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E020977.9080000@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Wed, Jun 22, 2011 at 10:25:43AM -0500, Eric Sandeen wrote:
> Another interesting chunk elsewhere:
> 
> /src/git/linux-2.6/fs/xfs/xfs_da_btree.c(782)
> /src/git/linux-2.6/fs/xfs/xfs_attr_leaf.c(1542)
>                 *action = 0;
>                 return(0);
>         if (count == 0) {

The da_btree code is a big mess with things duplicated all over.
There's a third copy of this in the dir2 code as well.  I have started
consolidating some of this code a while ago in prepation of adding
checksumming to the dir and attr code, but it has bit rotted a bit since
and I've not managed to get back to it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
