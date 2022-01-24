Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35F18C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Jan 2022 18:40:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235857AbiAXSkT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jan 2022 13:40:19 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43332 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241835AbiAXSkO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jan 2022 13:40:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51E7E6144B;
        Mon, 24 Jan 2022 18:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC904C340E7;
        Mon, 24 Jan 2022 18:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643049613;
        bh=5xdX0qBxSS4Jiv+cQpUC2fEK/IrCm4Ar2TOQ3VanJD8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q8waNb6mAXBpvBRzPJTl5SGefuzqFq4apYkOHAK4AbZQx4Xx5iXaYYo8ylv9KILwv
         N4Pxv4WDVCH0ct6Zo6AI0Xa97qPtFbxm7p6gjjlqov5720XvHa5wwG0ABX0olrj2qr
         zFBUMQPP6VyqMYoS29S7oPmSk1u9UhCNlgW/3LHjS9ZPxX28u0W1yu2jCxryPEQd0D
         5OuqOWhvNrrQhfDgInhrFrZ6p7xlZ1mZzTqzAZGghFJwvrgR0x6MgYDMl8v5dtB8Vv
         9PgPwK3rHK413DapQ14akzYcyCP9LLaI8jKdU/g5K5wOC9REBg5cgflcwDlX3hMGTH
         GrWQffXscJXow==
Date:   Mon, 24 Jan 2022 10:40:13 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eryu Guan <guan@eryu.me>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH v2] iogen: upgrade to fallocate
Message-ID: <20220124184013.GU13540@magnolia>
References: <20220118182910.GC13514@magnolia>
 <Ye1VzD76z0K/oWOt@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ye1VzD76z0K/oWOt@desktop>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jan 23, 2022 at 09:19:08PM +0800, Eryu Guan wrote:
> On Tue, Jan 18, 2022 at 10:29:10AM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Update this utility to use fallocate to preallocate/reserve space to a
> > file so that we're not so dependent on legacy XFS ioctls.  Fix a minor
> > whitespace error while we're at it.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> > v2: fix the fallocate flags for the resvsp replacement code
> > ---
> >  ltp/iogen.c |   34 +++++++++++++++++++++++-----------
> >  1 file changed, 23 insertions(+), 11 deletions(-)
> > 
> > diff --git a/ltp/iogen.c b/ltp/iogen.c
> > index 2b6644d5..c43cc1d0 100644
> > --- a/ltp/iogen.c
> > +++ b/ltp/iogen.c
> > @@ -922,13 +922,21 @@ bozo!
> >  	    f.l_whence = SEEK_SET;
> >  	    f.l_start = 0;
> >  	    f.l_len = nbytes;
> > -	    
> > +
> >  	    /*fprintf(stderr,
> >  		    "create_file: xfsctl(%d, RESVSP, { %d, %lld, %lld })\n",
> >  		   fd, f.l_whence, (long long)f.l_start, (long long)f.l_len);*/
> >  
> >  	    /* non-zeroing reservation */
> > -#ifdef XFS_IOC_RESVSP
> > +#if defined(FALLOCATE)
> > +	    if (fallocate(fd, FALLOC_FL_KEEP_SIZE, 0, nbytes) == -1) {
> 
> gcc warns about
> 
> iogen.c: In function 'create_file':                   
> iogen.c:820:20: warning: variable 'f' set but not used [-Wunused-but-set-variable]
>   820 |     struct flock64 f;                           
>       |                    ^
> 
> So I replaced 'nbytes' with 'f.l_len' in above fallocate(2) call.

Oh, thank you for fixing that!

--D

> Thanks,
> Eryu
> 
> > +		fprintf(stderr,
> > +			"iogen%s:  Could not fallocate %d bytes in file %s: %s (%d)\n",
> > +			TagName, nbytes, path, SYSERR, errno);
> > +		close(fd);
> > +		return -1;
> > +	    }
> > +#elif defined(XFS_IOC_RESVSP)
> >  	    if( xfsctl( path, fd, XFS_IOC_RESVSP, &f ) == -1) {
> >  		fprintf(stderr,
> >  			"iogen%s:  Could not xfsctl(XFS_IOC_RESVSP) %d bytes in file %s: %s (%d)\n",
> > @@ -936,8 +944,7 @@ bozo!
> >  		close(fd);
> >  		return -1;
> >  	    }
> > -#else
> > -#ifdef F_RESVSP
> > +#elif defined(F_RESVSP)
> >  	    if( fcntl( fd, F_RESVSP, &f ) == -1) {
> >  		fprintf(stderr,
> >  			"iogen%s:  Could not fcntl(F_RESVSP) %d bytes in file %s: %s (%d)\n",
> > @@ -946,8 +953,7 @@ bozo!
> >  		return -1;
> >  	    }
> >  #else
> > -bozo!
> > -#endif
> > +# error Dont know how to reserve space!
> >  #endif
> >  	}
> >  
> > @@ -962,7 +968,15 @@ bozo!
> >  		    (long long)f.l_len);*/
> >  
> >  	    /* zeroing reservation */
> > -#ifdef XFS_IOC_ALLOCSP
> > +#if defined(FALLOCATE)
> > +	    if (fallocate(fd, 0, sbuf.st_size, nbytes - sbuf.st_size) == -1) {
> > +		fprintf(stderr,
> > +			"iogen%s:  Could not fallocate %d bytes in file %s: %s (%d)\n",
> > +			TagName, nbytes, path, SYSERR, errno);
> > +		close(fd);
> > +		return -1;
> > +	    }
> > +#elif defined(XFS_IOC_ALLOCSP)
> >  	    if( xfsctl( path, fd, XFS_IOC_ALLOCSP, &f ) == -1) {
> >  		fprintf(stderr,
> >  			"iogen%s:  Could not xfsctl(XFS_IOC_ALLOCSP) %d bytes in file %s: %s (%d)\n",
> > @@ -970,8 +984,7 @@ bozo!
> >  		close(fd);
> >  		return -1;
> >  	    }
> > -#else
> > -#ifdef F_ALLOCSP
> > +#elif defined(F_ALLOCSP)
> >  	    if ( fcntl(fd, F_ALLOCSP, &f) < 0) {
> >  		fprintf(stderr,
> >  			"iogen%s:  Could not fcntl(F_ALLOCSP) %d bytes in file %s: %s (%d)\n",
> > @@ -980,8 +993,7 @@ bozo!
> >  		return -1;
> >  	    }
> >  #else
> > -bozo!
> > -#endif
> > +# error Dont know how to (pre)allocate space!
> >  #endif
> >  	}
> >  #endif
