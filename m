Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0ID7WMh129544 for <xfs@oss.sgi.com>; Tue, 18 Jan 2011 07:07:33 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D93511EA07D6
	for <xfs@oss.sgi.com>; Tue, 18 Jan 2011 05:09:50 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id xHir3vzfuBcbhHoB for
	<xfs@oss.sgi.com>; Tue, 18 Jan 2011 05:09:50 -0800 (PST)
Date: Tue, 18 Jan 2011 08:06:03 -0500
From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] xfsprogs: add fpunch command for hole punching via
	fallocate
Message-ID: <20110118130603.GA23491@dhcp231-156.rdu.redhat.com>
References: <1295009545-17839-1-git-send-email-josef@redhat.com>
	<20110118125112.GB21440@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110118125112.GB21440@infradead.org>
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
Cc: Josef Bacik <josef@redhat.com>, xfs@oss.sgi.com

On Tue, Jan 18, 2011 at 07:51:12AM -0500, Christoph Hellwig wrote:
> Looks mostly good, but I wonder what the point of a new command for this
> is.  It's just one new flag to fallocate, so I'd also implement it as
> a flag to the fallocate command.
>

:( thats what I did to begin with, and Dave said he'd rather have a seperate
command.
 
> > @@ -153,8 +156,10 @@ fallocate_f(
> >  	xfs_flock64_t	segment;
> >  	int		mode = 0;
> >  	int		c;
> > +	const char	*opts;
> >  
> > -	while ((c = getopt(argc, argv, "k")) != EOF) {
> > +	opts = "k";
> > +	while ((c = getopt(argc, argv, opts)) != EOF) {
> >  		switch (c) {
> >  		case 'k':
> >  			mode = FALLOC_FL_KEEP_SIZE;
> 
> Why do you change unrelated code?
> 

Crap sorry this is left over from my original patch.

> > +#if defined (FALLOC_FL_PUNCH_HOLE)
> 
> I'd rather have a
> 
> #ifndef FALLOC_FL_PUNCH_HOLE
> #define FALLOC_FL_PUNCH_HOLE	0x02
> #endif
> 
> to avoid requiring newest kernel headers.
>

Sounds good.  So which do we want, a new command or a new flag?  Thanks,

Josef 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
