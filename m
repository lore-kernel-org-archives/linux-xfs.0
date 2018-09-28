Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43220 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725972AbeI1H7n (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 28 Sep 2018 03:59:43 -0400
Date: Fri, 28 Sep 2018 09:39:22 +0800
From: Zorro Lang <zlang@redhat.com>
Subject: Re: [PATCH 3/3] xfsprogs: remove useless do_preadv and do_pwritev
 arguments
Message-ID: <20180928013922.GC6430@dhcp-12-117.nay.redhat.com>
References: <20171111172155.31941-1-zlang@redhat.com>
 <20171111172155.31941-3-zlang@redhat.com>
 <4bd7efb7-627a-ead5-083c-55a168631a72@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4bd7efb7-627a-ead5-083c-55a168631a72@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Thu, Sep 27, 2018 at 01:38:30PM -0500, Eric Sandeen wrote:
> On 11/11/17 11:21 AM, Zorro Lang wrote:
> > do_preadv and do_pwritev all have a 'buffer_size' argument, but they
> > never used it. Instead of it, they use global 'buffersize' variable,
> > which is initialized in alloc_buffer(). As the 'buffer_size' is
> > useless, so remove it for clear code.
> > 
> > Signed-off-by: Zorro Lang <zlang@redhat.com>
> 
> Hi Zorro, going through old patches and remembered that I never came
> back to this one, sorry.
> 
> I think that just removing it is ok.  do_preadv & do_pwritev
> both use iov and buffersize, each is a global variable; there is no
> need to pass in buffer size any more than there is a need to
> pass in the iov itself.  I'll go ahead & merge this as is.

Hi Eric,

Thanks so much, I already forgot this patch, I don't know if it can
be merged directly now, hope there's not conflict :-P

Feel free to tell me if you need a new version.

Thanks,
Zorro

> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> Thanks,
> -Eric
> 
> > ---
> >  io/pread.c  | 7 +++----
> >  io/pwrite.c | 5 ++---
> >  2 files changed, 5 insertions(+), 7 deletions(-)
> > 
> > diff --git a/io/pread.c b/io/pread.c
> > index 60650aa3..98e992b0 100644
> > --- a/io/pread.c
> > +++ b/io/pread.c
> > @@ -176,8 +176,7 @@ static ssize_t
> >  do_preadv(
> >  	int		fd,
> >  	off64_t		offset,
> > -	size_t		count,
> > -	size_t		buffer_size)
> > +	size_t		count)
> >  {
> >  	int		vecs = 0;
> >  	ssize_t		oldlen = 0;
> > @@ -205,7 +204,7 @@ do_preadv(
> >  	return bytes;
> >  }
> >  #else
> > -#define do_preadv(fd, offset, count, buffer_size) (0)
> > +#define do_preadv(fd, offset, count) (0)
> >  #endif
> >  
> >  static ssize_t
> > @@ -218,7 +217,7 @@ do_pread(
> >  	if (!vectors)
> >  		return pread(fd, buffer, min(count, buffer_size), offset);
> >  
> > -	return do_preadv(fd, offset, count, buffer_size);
> > +	return do_preadv(fd, offset, count);
> >  }
> >  
> >  static int
> > diff --git a/io/pwrite.c b/io/pwrite.c
> > index a89edfd0..f75c6164 100644
> > --- a/io/pwrite.c
> > +++ b/io/pwrite.c
> > @@ -66,7 +66,6 @@ do_pwritev(
> >  	int		fd,
> >  	off64_t		offset,
> >  	size_t		count,
> > -	size_t		buffer_size,
> >  	int 		pwritev2_flags)
> >  {
> >  	int vecs = 0;
> > @@ -102,7 +101,7 @@ do_pwritev(
> >  	return bytes;
> >  }
> >  #else
> > -#define do_pwritev(fd, offset, count, buffer_size, pwritev2_flags) (0)
> > +#define do_pwritev(fd, offset, count, pwritev2_flags) (0)
> >  #endif
> >  
> >  static ssize_t
> > @@ -116,7 +115,7 @@ do_pwrite(
> >  	if (!vectors)
> >  		return pwrite(fd, buffer, min(count, buffer_size), offset);
> >  
> > -	return do_pwritev(fd, offset, count, buffer_size, pwritev2_flags);
> > +	return do_pwritev(fd, offset, count, pwritev2_flags);
> >  }
> >  
> >  static int
> > 
