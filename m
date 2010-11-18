Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAI8PtA2135413 for <xfs@oss.sgi.com>; Thu, 18 Nov 2010 02:25:55 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 11CE91C531AA
	for <xfs@oss.sgi.com>; Thu, 18 Nov 2010 00:27:29 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id pGrXMl06iEzn2b5p for
	<xfs@oss.sgi.com>; Thu, 18 Nov 2010 00:27:29 -0800 (PST)
Date: Thu, 18 Nov 2010 03:26:49 -0500
From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] [RFC] xfsprogs: add -p for hole punching to falloc command
Message-ID: <20101118082649.GL5618@dhcp231-156.rdu.redhat.com>
References: <1289598905-18614-1-git-send-email-josef@redhat.com>
	<20101118051444.GS13830@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101118051444.GS13830@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Josef Bacik <josef@redhat.com>, xfs@oss.sgi.com

On Thu, Nov 18, 2010 at 04:14:44PM +1100, Dave Chinner wrote:
> On Fri, Nov 12, 2010 at 04:55:05PM -0500, Josef Bacik wrote:
> > Obviously this is highly dependant upon my current implementation of hole
> > punching via fallocate going in, but this is the support code for falloc to deal
> > with hole punching.  This is necessary to run the xfstest I have to make sure
> > the punching stuff is working properly.  Thanks,
> > 
> > Signed-off-by: Josef Bacik <josef@redhat.com>
> > ---
> >  io/prealloc.c |   17 ++++++++++++++++-
> >  1 files changed, 16 insertions(+), 1 deletions(-)
> > 
> > diff --git a/io/prealloc.c b/io/prealloc.c
> > index c8b7df6..4b14da7 100644
> > --- a/io/prealloc.c
> > +++ b/io/prealloc.c
> > @@ -153,12 +153,23 @@ fallocate_f(
> >  	xfs_flock64_t	segment;
> >  	int		mode = 0;
> >  	int		c;
> > +	const char	*opts;
> >  
> > -	while ((c = getopt(argc, argv, "k")) != EOF) {
> > +#if defined (FALLOC_FL_PUNCH_HOLE)
> > +	opts = "kp";
> > +#else
> > +	opts = "k";
> > +#endif
> > +	while ((c = getopt(argc, argv, opts)) != EOF) {
> >  		switch (c) {
> >  		case 'k':
> >  			mode = FALLOC_FL_KEEP_SIZE;
> >  			break;
> > +#if defined (FALLOC_FL_PUNCH_HOLE)
> > +		case 'p':
> > +			mode = FALLOC_FL_PUNCH_HOLE;
> > +			break;
> > +#endif
> >  		default:
> >  			command_usage(&falloc_cmd);
> >  		}
> > @@ -236,7 +247,11 @@ prealloc_init(void)
> >  	falloc_cmd.argmin = 2;
> >  	falloc_cmd.argmax = -1;
> >  	falloc_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
> > +#if defined (FALLOC_FL_PUNCH_HOLE)
> > +	falloc_cmd.args = _("[-k] [-p] off len");
> > +#else
> >  	falloc_cmd.args = _("[-k] off len");
> > +#endif
> >  	falloc_cmd.oneline =
> >  		_("allocates space associated with part of a file via fallocate");
> 
> I'd prefer that there is a separate command for FALLOC_FL_PUNCH_HOLE
> rather than a flag that changed the behaviour of the falloc command
> completely. This is the way we've done resvsp/unresvsp, so I think
> it makes sense to follow this command structure e.g. falloc/fpunch.
>

Fair enough, I can do that.  Thanks,

Josef 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
