Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6QFAbwb131637 for <xfs@oss.sgi.com>; Tue, 26 Jul 2011 10:10:38 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4C9191684AFF
	for <xfs@oss.sgi.com>; Tue, 26 Jul 2011 08:10:41 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	AuOF5AAlAvF8w9C9 for <xfs@oss.sgi.com>;
	Tue, 26 Jul 2011 08:10:41 -0700 (PDT)
Date: Tue, 26 Jul 2011 11:10:33 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH XFSPROGS 2/3] Build without enabling DEBUG by default
Message-ID: <20110726151033.GA18311@infradead.org>
References: <1311292237-4155-1-git-send-email-tytso@mit.edu>
	<1311292237-4155-2-git-send-email-tytso@mit.edu>
	<20110722141753.GA19681@infradead.org>
	<20110722183048.GC25092@thunk.org>
	<20110722183830.GA21744@infradead.org>
	<20110722223458.GD25092@thunk.org>
	<20110723013214.GA22837@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110723013214.GA22837@infradead.org>
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
To: Ted Ts'o <tytso@mit.edu>
Cc: Christoph Hellwig <hch@infradead.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com

On Fri, Jul 22, 2011 at 09:32:14PM -0400, Christoph Hellwig wrote:
> > diff --git a/include/builddefs.in b/include/builddefs.in
> > index 4c8ec64..81ebfcd 100644
> > --- a/include/builddefs.in
> > +++ b/include/builddefs.in
> > @@ -25,6 +25,7 @@ OPTIMIZER = @opt_build@
> >  MALLOCLIB = @malloc_lib@
> >  LOADERFLAGS = @LDFLAGS@
> >  LTLDFLAGS = @LDFLAGS@
> > +CFLAGS = @CFLAGS@
> >  
> >  LIBRT = @librt@
> >  LIBUUID = @libuuid@
> > 
> > Then I don't have to set an environment variable when running make; I
> > just have to pass it to configure.
> 
> This looks much better, and is indeed similar to some other fixes we
> recently had to put in, probably due to changing make behaviour.
> 
> If you add a signoff and a proper description I'll put it into all the
> repositories.

Can you at least provide the signoff?  I can take care of the rest if
this means I can get it in ASAP.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
