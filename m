Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB6FHe1s233495
	for <linux-xfs@oss.sgi.com>; Tue, 6 Dec 2011 09:17:40 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9DF0716EB760
	for <linux-xfs@oss.sgi.com>; Tue,  6 Dec 2011 07:17:39 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	pujCYeDdXr1n6LZS for <linux-xfs@oss.sgi.com>;
	Tue, 06 Dec 2011 07:17:39 -0800 (PST)
Date: Tue, 6 Dec 2011 10:17:38 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs: validate inode numbers in file handles correctly
Message-ID: <20111206151738.GC11874@infradead.org>
References: <1276846374-23916-1-git-send-email-david@fromorbit.com>
	<loom.20111123T134243-580@post.gmane.org>
	<20111123143045.GA20892@infradead.org>
	<20111128111947.GA26454@infradead.org>
	<CAJNJY8RSOX2XsbM+0riNNPGxaLGm+OWkHexTVM4v5+rhkchuAw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAJNJY8RSOX2XsbM+0riNNPGxaLGm+OWkHexTVM4v5+rhkchuAw@mail.gmail.com>
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
To: hank peng <pengxihan@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@oss.sgi.com, Guoquan Yang <ygq51@hotmail.com>

On Sat, Dec 03, 2011 at 04:27:39PM +0800, hank peng wrote:
> I haven't tested this patch, but I have a question now: although I use
> inode64 option when mounting, my filesystem did not exceed 2T limit,
> so, 32-bit inode would be no problem, right?

In the normal configuration > 32bit inode numbers kick in at 1TB
filesystem sizes.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
