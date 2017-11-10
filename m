Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49192 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755501AbdKJCGr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 9 Nov 2017 21:06:47 -0500
Date: Fri, 10 Nov 2017 10:06:44 +0800
From: Zorro Lang <zlang@redhat.com>
Subject: Re: [PATCH] xfsprogs: fix wrong variable type in write_once function
Message-ID: <20171110020644.GW21475@dhcp12-143.nay.redhat.com>
References: <20171110011737.4089-1-zlang@redhat.com>
 <7ec102d7-a41f-7cef-07f7-3ebb548b8f22@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ec102d7-a41f-7cef-07f7-3ebb548b8f22@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Thu, Nov 09, 2017 at 07:47:14PM -0600, Eric Sandeen wrote:
> On 11/9/17 7:17 PM, Zorro Lang wrote:
> > The 'Coverity Scan' found a problem in new write_once() function:
> > 
> > 272             size_t bytes;
> > 273             bytes = do_pwrite(file->fd, offset, count, count, pwritev2_flags);
> >>>>     CID 1420710:  Control flow issues  (NO_EFFECT)
> >>>>     This less-than-zero comparison of an unsigned value is never true. "bytes < 0UL".
> > 274             if (bytes < 0)
> > 275                     return -1;
> > 
> > That's unreasonable. do_pwrite return 'ssize_t' type value,
> 
> An int, actually, right?

Yeah, I mean the pwrite manpage defines:

ssize_t pwrite(int fd, const void *buf, size_t count, off_t offset);

> 
> static int
> do_pwrite(
> ...
> 
> as does do_pwritev, which it calls:
> 
> static int
> do_pwritev(
> 
> ...
> 
> Can you chase through the types a bit more for consistency while you're
> in here?

Sure, I'll go through the do_pwrite().

Thanks,
Zorro

> 
> Thanks,
> -Eric
> 
> > which can
> > be less than zero, but we use a 'size_t' to get the return value. So
> > change the size_t to ssize_t for it can store the return value
> > correctly.
> > 
> > Signed-off-by: Zorro Lang <zlang@redhat.com>
> > ---
> >  io/pwrite.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/io/pwrite.c b/io/pwrite.c
> > index 26f79579..b28b6039 100644
> > --- a/io/pwrite.c
> > +++ b/io/pwrite.c
> > @@ -269,7 +269,7 @@ write_once(
> >  	long long	*total,
> >  	int		pwritev2_flags)
> >  {
> > -	size_t bytes;
> > +	ssize_t bytes;
> >  	bytes = do_pwrite(file->fd, offset, count, count, pwritev2_flags);
> >  	if (bytes < 0)
> >  		return -1;
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
