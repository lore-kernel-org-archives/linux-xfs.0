Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4FECC7EE2D
	for <linux-xfs@archiver.kernel.org>; Sun, 26 Feb 2023 23:12:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbjBZXM5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 26 Feb 2023 18:12:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjBZXM4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Feb 2023 18:12:56 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CAA77AB7
        for <linux-xfs@vger.kernel.org>; Sun, 26 Feb 2023 15:12:55 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id oj5so323862pjb.5
        for <linux-xfs@vger.kernel.org>; Sun, 26 Feb 2023 15:12:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TwZNoR51p1x2zsuL9SYO3/6YS2NiEz18nrjCQsyjfus=;
        b=UHaq4QsVi+98zPnNaF7nYMsDyPfg3dScUaBqTzoJ0D09H3tlN5ysRzFz69YCXQFfft
         NDIcmx5Zk4xalTcbWIOWnWYQFU8/4rQDlZJr8z5qOPfi0nnSZSXAEo5U/3Nfa4sPj7Tb
         9sc8434DitETWXOTwnYjCicCKOsF+fOIiRJbKu27/mY/ab7VEwC4kUqjqH2fRrpWZlcq
         aPOhgqbuH/xdVXddiZANY4S+4U3Ksa43ihUSwbhxfVCnw955pCq6gutZowbMly92LBZv
         cmZVkmVeYb/8S6Nm2/a92TWY1IUhnMPT3G/GZr+WZUIl64hRf5vo90fACa/tASPg/0P6
         v5sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TwZNoR51p1x2zsuL9SYO3/6YS2NiEz18nrjCQsyjfus=;
        b=Zl0PjmnACuTH6FRWRgaUh/gIhtRcH4dy61M1nm/gxl9h9fmSmZ3RDCQCrPSGzdet+L
         TZKM3bMvM0b06uIzopq/IHNpVPr7Zn7e/Ok9Hb1pwMi17c+OGwQ1SmpsHLkUUsGJ/kPo
         XuNp14a+v8sW4f3cI7kZRBqsB0CfqYWCEJExuPXtmc8/3D/gw1/SHmxXGXRdG4yc3v3J
         9ADB0d3wni9pDot8OqDZTaz3/fMwoMF3cfV7B52Zzz4l/8ioyR0TfZ+gh+G5pE8J6j7S
         26B3fEm20fGLtK0+eKABH1rAUqmbWv1QFgbalIGdTgqC6hmzCQRaeRr5hBoNoQ44ShxE
         p2Rw==
X-Gm-Message-State: AO0yUKVRPo350PioXVsn+ICC+uXFvEnXOooVugHlw7lT/Zjsp61YVYfF
        MkCRyOrsc30vywhDGe8D0jlGLQ==
X-Google-Smtp-Source: AK7set/JHxQegoPFrPfFn77k3xg9iEJjQbP3Q2lQJI1KDI8z18S3wmO+ZEZ1dBYXe0sO3barGhJTQg==
X-Received: by 2002:a17:902:dacf:b0:19c:d32a:befc with SMTP id q15-20020a170902dacf00b0019cd32abefcmr12023843plx.15.1677453174840;
        Sun, 26 Feb 2023 15:12:54 -0800 (PST)
Received: from dread.disaster.area (pa49-186-4-237.pa.vic.optusnet.com.au. [49.186.4.237])
        by smtp.gmail.com with ESMTPSA id e19-20020a170902ed9300b0019949fd956bsm3137549plj.178.2023.02.26.15.12.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Feb 2023 15:12:54 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pWQCJ-002Vyy-Ef; Mon, 27 Feb 2023 10:12:51 +1100
Date:   Mon, 27 Feb 2023 10:12:51 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFCv3 2/3] iomap: Change uptodate variable name to state
Message-ID: <20230226231251.GW360264@dread.disaster.area>
References: <cover.1677428794.git.ritesh.list@gmail.com>
 <457680a57d7c581aae81def50773ed96034af420.1677428794.git.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <457680a57d7c581aae81def50773ed96034af420.1677428794.git.ritesh.list@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 27, 2023 at 01:13:31AM +0530, Ritesh Harjani (IBM) wrote:
> This patch changes the struct iomap_page uptodate & uptodate_lock
> member names to state and state_lock to better reflect their purpose
> for the upcoming patch. It also introduces the accessor functions for
> updating uptodate state bits in iop->state bitmap. This makes the code
> easy to understand on when different bitmap types are getting referred
> in different code paths.
> 
> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> ---
>  fs/iomap/buffered-io.c | 65 ++++++++++++++++++++++++++++++++----------
>  1 file changed, 50 insertions(+), 15 deletions(-)
....

The mechanical change itself looks fine, so from that perspective:

Reviewed-by: Dave Chinner <dchinner@redhat.com>

However, I'm wondering about the efficiency of these bit searches.

> @@ -110,7 +143,7 @@ static void iomap_adjust_read_range(struct inode *inode, struct folio *folio,
>  
>  		/* move forward for each leading block marked uptodate */
>  		for (i = first; i <= last; i++) {
> -			if (!test_bit(i, iop->uptodate))
> +			if (!iop_test_uptodate(iop, i, nr_blocks))
>  				break;
>  			*pos += block_size;
>  			poff += block_size;

Looking at this code, it could have been written to use
find_first_zero_bit() rather than testing each bit individually...

> @@ -120,7 +153,7 @@ static void iomap_adjust_read_range(struct inode *inode, struct folio *folio,
>  
>  		/* truncate len if we find any trailing uptodate block(s) */
>  		for ( ; i <= last; i++) {
> -			if (test_bit(i, iop->uptodate)) {
> +			if (iop_test_uptodate(iop, i, nr_blocks)) {
>  				plen -= (last - i + 1) * block_size;
>  				last = i - 1;
>  				break;

And this is find_first_bit()...

>  static void iomap_set_range_uptodate(struct folio *folio,
> @@ -439,6 +473,7 @@ bool iomap_is_partially_uptodate(struct folio *folio, size_t from, size_t count)
>  	struct iomap_page *iop = to_iomap_page(folio);
>  	struct inode *inode = folio->mapping->host;
>  	unsigned first, last, i;
> +	unsigned int nr_blocks = i_blocks_per_folio(inode, folio);
>  
>  	if (!iop)
>  		return false;
> @@ -451,7 +486,7 @@ bool iomap_is_partially_uptodate(struct folio *folio, size_t from, size_t count)
>  	last = (from + count - 1) >> inode->i_blkbits;
>  
>  	for (i = first; i <= last; i++)
> -		if (!test_bit(i, iop->uptodate))
> +		if (!iop_test_uptodate(iop, i, nr_blocks))
>  			return false;

Again, find_first_zero_bit().

These seem like worthwhile optimisations in light of the heavier use
these bitmaps will get with sub-folio dirty tracking, especially
considering large folios will now use these paths. Do these
interface changes preclude the use of efficient bitmap searching
functions?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
