Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3RFXFAa167064 for <xfs@oss.sgi.com>; Tue, 27 Apr 2010 10:33:15 -0500
Received: from esri3.esri.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7D617154DC62
	for <xfs@oss.sgi.com>; Tue, 27 Apr 2010 08:35:18 -0700 (PDT)
Received: from esri3.esri.com (esrismtp2.esri.com [198.102.62.103]) by
	cuda.sgi.com with ESMTP id oUMu8LJBrw7Ml6u4 for
	<xfs@oss.sgi.com>; Tue, 27 Apr 2010 08:35:18 -0700 (PDT)
Date: Tue, 27 Apr 2010 08:35:04 -0700
From: Ray Van Dolson <rvandolson@esri.com>
Subject: Re: O_SYNC behavior?
Message-ID: <20100427153504.GA27787@esri.com>
References: <20100426225627.GA7106@esri.com>
	<537687191.239471272324343715.JavaMail.root@mail-au.aconex.com>
	<20100427093250.GA15182@citd.de>
	<20100427141205.GA557@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100427141205.GA557@infradead.org>
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
Cc: Nathan Scott <nathans@aconex.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, Apr 27, 2010 at 07:12:05AM -0700, Christoph Hellwig wrote:
> On Tue, Apr 27, 2010 at 11:32:50AM +0200, Matthias Schniedermeyer wrote:
> > I don't think that answers the intented question.
> > 
> > I guess the correct answer is:
> > It depends on the server-side configuration.
> > An "async" export gets the "done"-answer immediatly.
> > An "sync" export (only when also mounted "sync" AFAIU) waits at least 
> > until the write command is send down the stack, maybe even until the 
> > data actually hit the platters or silicon in the SSD-case.
> > 
> > man 5 exports:
> > - snip -
> > sync:	Reply to requests only after the changes have been committed to stable storage
> > - snip -
> > 
> > But i guess the performance will be horrible when both side are "sync".
> 
> The client side (that is mount-side) sync means implying O_SYNC for all
> I/O - no need for that.  And sync exports are the default for every sane
> server.
> 

Thanks guys.  I was asking this from the perspective of a ZFS type
setup with its intent log (ZIL) on SSD's or some battery backed NVRAM.

In this setup, with sync mode NFS, acknowledgement is sent to the
client as soon as the data is written to the ZIL -- before it actually
hits the underlying disks.

Just was trying to determine a way to mirror this setup with XFS.

Thanks,
Ray

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
