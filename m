Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3REA4g5163717 for <xfs@oss.sgi.com>; Tue, 27 Apr 2010 09:10:06 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 15BF58E4B2E
	for <xfs@oss.sgi.com>; Tue, 27 Apr 2010 07:12:08 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Jd9LPyVIBTRCx3Sm for
	<xfs@oss.sgi.com>; Tue, 27 Apr 2010 07:12:08 -0700 (PDT)
Date: Tue, 27 Apr 2010 10:12:05 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: O_SYNC behavior?
Message-ID: <20100427141205.GA557@infradead.org>
References: <20100426225627.GA7106@esri.com>
	<537687191.239471272324343715.JavaMail.root@mail-au.aconex.com>
	<20100427093250.GA15182@citd.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100427093250.GA15182@citd.de>
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
To: Matthias Schniedermeyer <ms@citd.de>
Cc: Ray Van Dolson <rvandolson@esri.com>, Nathan Scott <nathans@aconex.com>, xfs@oss.sgi.com

On Tue, Apr 27, 2010 at 11:32:50AM +0200, Matthias Schniedermeyer wrote:
> I don't think that answers the intented question.
> 
> I guess the correct answer is:
> It depends on the server-side configuration.
> An "async" export gets the "done"-answer immediatly.
> An "sync" export (only when also mounted "sync" AFAIU) waits at least 
> until the write command is send down the stack, maybe even until the 
> data actually hit the platters or silicon in the SSD-case.
> 
> man 5 exports:
> - snip -
> sync:	Reply to requests only after the changes have been committed to stable storage
> - snip -
> 
> But i guess the performance will be horrible when both side are "sync".

The client side (that is mount-side) sync means implying O_SYNC for all
I/O - no need for that.  And sync exports are the default for every sane
server.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
