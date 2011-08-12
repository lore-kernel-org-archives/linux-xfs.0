Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7CKln2N086414
	for <linux-xfs@oss.sgi.com>; Fri, 12 Aug 2011 15:47:49 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D90AD18B90C2
	for <linux-xfs@oss.sgi.com>; Fri, 12 Aug 2011 13:47:48 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	sH49sV7orq7BuT18 for <linux-xfs@oss.sgi.com>;
	Fri, 12 Aug 2011 13:47:48 -0700 (PDT)
Date: Fri, 12 Aug 2011 16:47:46 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Deleting files with extended attributes is dead slow
Message-ID: <20110812204746.GB30615@infradead.org>
References: <j23qs9$1c3$1@dough.gmane.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <j23qs9$1c3$1@dough.gmane.org>
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
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Cc: linux-xfs@oss.sgi.com

On Fri, Aug 12, 2011 at 08:19:53PM +0200, Bernd Schubert wrote:
> Hi there,
> 
> with FhGFS we may use extended attributes to store file meta data
> and with ext3/ext4 that also works very well and the rate to create
> files and to write those EAs (create() + fsetxattr()  is about 2.5
> to 3 times faster than with a create() + write(). Size of those EA
> data is about 256 bytes depending on the number of storage stripes.
> However, with XFS using extended attributes is *extremely* slow.
> Here are some numbers with ext4 and xfs using a patched [1] bonnie++

Currently XFS uses synchronous transactions when retiring inodes with
xattrs on them.  So far I've not actually found a good reason for that,
so I suspect we can remove it.  I'll do another audit of it, and will
send you a patch for it after doing basic QA.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
