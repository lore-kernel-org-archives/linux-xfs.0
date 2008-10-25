Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 25 Oct 2008 13:22:39 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9PKMWuK029958
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 13:22:33 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 28021546ACF
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 13:22:32 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id nPlsgsFkJViG6Dzv for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 13:22:32 -0700 (PDT)
Date: Sat, 25 Oct 2008 16:22:32 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: fix nr of args in open calls
Message-ID: <20081025202232.GE28002@infradead.org>
References: <49036961.8070100@sandeen.net> <20081025201715.GA28002@infradead.org> <49037F3C.6030007@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49037F3C.6030007@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

On Sat, Oct 25, 2008 at 03:19:08PM -0500, Eric Sandeen wrote:
> Christoph Hellwig wrote:
> > On Sat, Oct 25, 2008 at 01:45:53PM -0500, Eric Sandeen wrote:
> >> --- xfstests.orig/ltp/iogen.c
> >> +++ xfstests/ltp/iogen.c
> >> @@ -1060,7 +1060,11 @@ int 	nbytes;
> >>  
> >>      Oflags |= O_CREAT | O_WRONLY;
> >>  
> >> +#ifdef CRAY
> >>      if ((fd = open(path, Oflags, 0666, Ocbits, Ocblks)) == -1) {
> >> +#else
> >> +    if ((fd = open(path, Oflags, 0666)) == -1) {
> >> +#endif
> > 
> > Do we really need that ifdef cray here?
> 
> Not sure; Ocbits etc are set under the same #ifdef, xfsqa runs on irix,
> and I'm not sure what all gets set on that build ...

#ifdef CRAY is for Unicos, and I don't think xfsqa near it's current
version can run there.  I'd rather see all this striped out, but at
least no new occurances added.
