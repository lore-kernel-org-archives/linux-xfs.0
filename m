Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF149C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Jan 2022 17:20:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236246AbiAQRUe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Jan 2022 12:20:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243333AbiAQRTx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Jan 2022 12:19:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BFE8C061762;
        Mon, 17 Jan 2022 09:15:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34FC5B81055;
        Mon, 17 Jan 2022 17:15:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE730C36AE7;
        Mon, 17 Jan 2022 17:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642439716;
        bh=75yaY9Pq+ooKGV7+JWC4GaaZxOsupv8TErb7SGe5Be8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rOqpWlri+5u0q36NWqyagJf4U9uI1RAeKxX289WmRmKepyBrXZubbm2I7ihVZB/lH
         KtLFEyZp95T2fzjloGQMlhFnu80Zl2PjAoA+7VRwQl1BN98VLnRMCpwaccd/bXJaen
         TuLdYH7JNolEy9QjsJ+pXeTzxCYVrWlaH1yIvxKBTtetdCZpMGiipjyYqx5hnWNSps
         Z088CgXjLCNdZeDYR6BILuH6J/tNHz1RQdku5B31qity0z7qpFs51hXrtDMUH9D0Qw
         WdGHaedhhMGhka34XgMYpQ19WKt/DlEKb3RgAkOLPf5NkEXX7KEE3RFwyAAly91DJI
         C+s6HH/E0kxsQ==
Date:   Mon, 17 Jan 2022 09:15:16 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eryu Guan <guan@eryu.me>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 7/8] iogen: upgrade to fallocate
Message-ID: <20220117171516.GB13514@magnolia>
References: <164193780808.3008286.598879710489501860.stgit@magnolia>
 <164193784690.3008286.8689130816813600863.stgit@magnolia>
 <YePCz96eXSb66ppd@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YePCz96eXSb66ppd@desktop>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jan 16, 2022 at 03:01:35PM +0800, Eryu Guan wrote:
> On Tue, Jan 11, 2022 at 01:50:46PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Update this utility to use fallocate to preallocate/reserve space to a
> > file so that we're not so dependent on legacy XFS ioctls.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  ltp/iogen.c |   32 ++++++++++++++++++++++----------
> >  1 file changed, 22 insertions(+), 10 deletions(-)
> > 
> > 
> > diff --git a/ltp/iogen.c b/ltp/iogen.c
> > index 2b6644d5..6c2c1534 100644
> > --- a/ltp/iogen.c
> > +++ b/ltp/iogen.c
> > @@ -928,7 +928,15 @@ bozo!
> >  		   fd, f.l_whence, (long long)f.l_start, (long long)f.l_len);*/
> >  
> >  	    /* non-zeroing reservation */
> > -#ifdef XFS_IOC_RESVSP
> > +#if defined(HAVE_FALLOCATE)
> > +	    if (fallocate(fd, 0, 0, nbytes) == -1) {
> 
> Seems this is not a identical replacement for XFS_IOC_RESVSP (is that
> what we want here?), as fallocate(2) here zeros space and change i_size
> as well.

Doh, you're right, the second parameter should follow what the kernel
does and specify FALLOC_FL_KEEP_SIZE.  I'll fix that and resubmit.
Thanks for taking the rest of the series. :)

--D

> And from xfsctl(3), after XFS_IOC_RESVSP "The blocks are allocated, but
> not zeroed, and the file size does not change." And the comments above
> indicates "non-zeroing reservation" as well.
> 
> If identical replacement is not required, we could drop "non-zeroing"
> part, but add FALLOC_FL_KEEP_SIZE?
> 
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
> > +#if defined(HAVE_FALLOCATE)
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
