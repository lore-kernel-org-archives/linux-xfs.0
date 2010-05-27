Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4RGS0nO145410 for <xfs@oss.sgi.com>; Thu, 27 May 2010 11:28:00 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C499214542D5
	for <xfs@oss.sgi.com>; Thu, 27 May 2010 09:30:24 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id l5iIbko8wYHUSGwm for
	<xfs@oss.sgi.com>; Thu, 27 May 2010 09:30:24 -0700 (PDT)
Date: Thu, 27 May 2010 12:30:24 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/8] Test basic quota enforcement
Message-ID: <20100527163024.GA18771@infradead.org>
References: <1274710459-11446-1-git-send-email-jack@suse.cz>
	<1274710459-11446-4-git-send-email-jack@suse.cz>
	<20100525100635.GA21252@infradead.org>
	<20100525203914.GE3783@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100525203914.GE3783@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: xfs@oss.sgi.com

On Tue, May 25, 2010 at 10:39:15PM +0200, Jan Kara wrote:
> On Tue 25-05-10 06:06:35, Christoph Hellwig wrote:
> > On Mon, May 24, 2010 at 04:14:14PM +0200, Jan Kara wrote:
> > > Add a test which checks whether basic quota enforcement works.
> > 
> > This one fails for me when testing and xfs filesystem on latest Linus'
> > tree (with Debian -testing userspace):
>   OK, I've committed a fixed version of the test to the repository.

Thanks, I've pulled your updated tree.  Btw, your kernel.org xfstests
tree is not a bare repo which will increase the load in the kernel.org
servers needlessly.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
