Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5M0Sii7192821 for <xfs@oss.sgi.com>; Sun, 21 Jun 2009 19:28:45 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 956379357E2
	for <xfs@oss.sgi.com>; Sun, 21 Jun 2009 17:37:22 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31]) by cuda.sgi.com
	with ESMTP id ZlUtAI9fGYde21PE for <xfs@oss.sgi.com>;
	Sun, 21 Jun 2009 17:37:22 -0700 (PDT)
Date: Sun, 21 Jun 2009 20:29:00 -0400 (EDT)
From: Lachlan McIlroy <lmcilroy@redhat.com>
Message-ID: <117412553.303831245630540511.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
In-Reply-To: <175383275.303721245629906853.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
Subject: Re: 2.6.30-06725: xfs_fsr: Assertion failed: ip->i_delayed_blks ==
	0,  file: fs/xfs/xfs_bmap.c, line: 5991
MIME-Version: 1.0
Reply-To: Lachlan McIlroy <lmcilroy@redhat.com>
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
Cc: Alexander Beregalov <a.beregalov@gmail.com>, xfs@oss.sgi.com


----- "Christoph Hellwig" <hch@infradead.org> wrote:

> On Sat, Jun 20, 2009 at 03:04:24AM -0400, Lachlan McIlroy wrote:
> > Hi Alexander,
> > 
> > I've seen this assertion before and if it's the problem I think it
> > is then it should be fixed with this patch:
> > 
> > http://oss.sgi.com/archives/xfs/2009-02/msg00176.html
> > 
> > It shouldn't be difficult to test this too - If you run about 1024
> > dd writers to separate 100MB files and then run xfs_bmap on each
> > file afterwards it should assert.
> 
> Thas is in a filesystem not big enough to actually fit those files,
> right?  Might be worth adding a testcase like this..
Smaller files might work too.  The trick will be to get enough threads
flushing files at the same time that we exhaust the reserved space pool
(ie xfs_trans_reserve() returns ENOSPC even when the XFS_TRANS_RESERVE
flag is used).

> 
> Alex, can you give that patch a try?
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
