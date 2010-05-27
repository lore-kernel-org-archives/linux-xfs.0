Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4RH62nC147529 for <xfs@oss.sgi.com>; Thu, 27 May 2010 12:06:02 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4D4B437D45B
	for <xfs@oss.sgi.com>; Thu, 27 May 2010 10:08:25 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id ToxQQBthPeCFFVBJ for <xfs@oss.sgi.com>;
	Thu, 27 May 2010 10:08:25 -0700 (PDT)
Date: Thu, 27 May 2010 19:08:11 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/8] Test basic quota enforcement
Message-ID: <20100527170810.GB3576@quack.suse.cz>
References: <1274710459-11446-1-git-send-email-jack@suse.cz>
	<1274710459-11446-4-git-send-email-jack@suse.cz>
	<20100525100635.GA21252@infradead.org>
	<20100525203914.GE3783@quack.suse.cz>
	<20100527163024.GA18771@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100527163024.GA18771@infradead.org>
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
Cc: Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On Thu 27-05-10 12:30:24, Christoph Hellwig wrote:
> On Tue, May 25, 2010 at 10:39:15PM +0200, Jan Kara wrote:
> > On Tue 25-05-10 06:06:35, Christoph Hellwig wrote:
> > > On Mon, May 24, 2010 at 04:14:14PM +0200, Jan Kara wrote:
> > > > Add a test which checks whether basic quota enforcement works.
> > > 
> > > This one fails for me when testing and xfs filesystem on latest Linus'
> > > tree (with Debian -testing userspace):
> >   OK, I've committed a fixed version of the test to the repository.
> 
> Thanks, I've pulled your updated tree.  Btw, your kernel.org xfstests
> tree is not a bare repo which will increase the load in the kernel.org
> servers needlessly.
  Thanks! I've now removed the repo and next time when I need it I will
create a proper bare repository.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
