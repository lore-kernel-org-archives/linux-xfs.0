Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5KI0qYm129520 for <xfs@oss.sgi.com>; Sat, 20 Jun 2009 13:00:52 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C327E12A844B
	for <xfs@oss.sgi.com>; Sat, 20 Jun 2009 11:01:18 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id UunfXNxJFBbvNdgz for
	<xfs@oss.sgi.com>; Sat, 20 Jun 2009 11:01:18 -0700 (PDT)
Date: Sat, 20 Jun 2009 14:01:16 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.30-06725: xfs_fsr: Assertion failed: ip->i_delayed_blks ==
	0,  file: fs/xfs/xfs_bmap.c, line: 5991
Message-ID: <20090620180116.GD3984@infradead.org>
References: <941396568.292261245481145500.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
	<961884583.292281245481464174.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <961884583.292281245481464174.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
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
To: Lachlan McIlroy <lmcilroy@redhat.com>
Cc: Alexander Beregalov <a.beregalov@gmail.com>, xfs@oss.sgi.com

On Sat, Jun 20, 2009 at 03:04:24AM -0400, Lachlan McIlroy wrote:
> Hi Alexander,
> 
> I've seen this assertion before and if it's the problem I think it
> is then it should be fixed with this patch:
> 
> http://oss.sgi.com/archives/xfs/2009-02/msg00176.html
> 
> It shouldn't be difficult to test this too - If you run about 1024
> dd writers to separate 100MB files and then run xfs_bmap on each
> file afterwards it should assert.

Thas is in a filesystem not big enough to actually fit those files,
right?  Might be worth adding a testcase like this..

Alex, can you give that patch a try?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
