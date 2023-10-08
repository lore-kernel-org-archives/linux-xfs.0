Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A0D2E95A8E
	for <linux-xfs@archiver.kernel.org>; Sun,  8 Oct 2023 22:17:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344759AbjJHWR0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 8 Oct 2023 18:17:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344757AbjJHWRZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 Oct 2023 18:17:25 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE2A6AC
        for <linux-xfs@vger.kernel.org>; Sun,  8 Oct 2023 15:17:23 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-690d8fb3b7eso3546970b3a.1
        for <linux-xfs@vger.kernel.org>; Sun, 08 Oct 2023 15:17:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1696803443; x=1697408243; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XuMhaoUrb8fYypPyU1C5/BlvN3yIac9qvvOq3KXUHNo=;
        b=cJ32DtL8rX3jl6OITyioJQ+6lf5YB09hOHqBjIcG8Tys86Iq6TkiA2Av7Nr0NgeKGt
         2q6yIGhSajPNqd4lXoiYgYr8vpElzQZAWuDXnh9hR3aqT8vkxitRZIsvwET6RVQ4xzwW
         7YH+gIECJmciYuNEcZnF08fFuuBwadV2QVAu28iY0UB5QGhV/wd3tkRIqoOUsdmxW2Iq
         tRzzZ59nUx/2ulv9S0T4iVqfRnu8YNTpvz6L4TsD+k124HrenAWufZb2Bd0JzvmdpRH/
         2tMjVY5g3YziG2yE6xK3z53xXNv/mp7wpo3FjpVF341lp6Iqt4OjHZtI7esJAaqUTm6u
         1X/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696803443; x=1697408243;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XuMhaoUrb8fYypPyU1C5/BlvN3yIac9qvvOq3KXUHNo=;
        b=DAZmcLa0aHrPziAs/LL5EQCy6pH2bKaJZ+oozVgdzSeZT1eEPhy78cHtc0wJzc/F/d
         c405J534UTBO9zkOKoM7Aoxwsln4Weye9XTo6zTmaBuTIOmTmECtuD5XS64CCoUB5zCe
         h05aep22iVA4K7Yh9zQbWCowW5h38J0uPW1qU6YTuqhQZT2OzTuvHXSjuYGYadLK/b5a
         FL2EeYplZoGaR5tckzg7JF1Sk9xPVumQgH2kXBLgp4SzB0D3V8Zi3ZFaDquiDI5akYb9
         c1cfKZrzqFeiAWw0yeKXJWfq2VNEd7zmmx8RH2tucojbdgQgkfR26QBDKx7QqSdGnF7V
         MdGQ==
X-Gm-Message-State: AOJu0YxIU6hB9q+g8/lv3vBvREqBCO4+z6YAXmHFsbw663dL98+4izMj
        06mGctOtbptVcXrDPyTfxDevqQ==
X-Google-Smtp-Source: AGHT+IFpYWNNF7lhghKXd89cNbLnO1b3yGGYgoerjmBJ/CE2yCqc6X/QyLT7+/JjVYeScKQF4hFJFw==
X-Received: by 2002:a05:6a20:394a:b0:154:e887:f581 with SMTP id r10-20020a056a20394a00b00154e887f581mr16324879pzg.58.1696803443275;
        Sun, 08 Oct 2023 15:17:23 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id z5-20020a633305000000b0057cb5a780ebsm6920676pgz.76.2023.10.08.15.17.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Oct 2023 15:17:22 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qpc5P-00BGU3-1i;
        Mon, 09 Oct 2023 09:17:19 +1100
Date:   Mon, 9 Oct 2023 09:17:19 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Chandan Babu R <chandan.babu@oracle.com>,
        "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        Mateusz Guzik <mjguzik@gmail.com>
Subject: Re: [PATCH v2 4/5] xfs: Remove mrlock wrapper
Message-ID: <ZSMqb70f8mHCEaNl@dread.disaster.area>
References: <20231007203543.1377452-1-willy@infradead.org>
 <20231007203543.1377452-5-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231007203543.1377452-5-willy@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Oct 07, 2023 at 09:35:42PM +0100, Matthew Wilcox (Oracle) wrote:
> mrlock was an rwsem wrapper that also recorded whether the lock was
> held for read or write.  Now that we can ask the generic code whether
> the lock is held for read or write, we can remove this wrapper and use
> an rwsem directly.
> 
> As the comment says, we can't use lockdep to assert that the ILOCK is
> held for write, because we might be in a workqueue, and we aren't able
> to tell lockdep that we do in fact own the lock.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

.....

> @@ -338,10 +338,14 @@ xfs_assert_ilocked(
>  	struct xfs_inode	*ip,
>  	uint			lock_flags)
>  {
> +	/*
> +	 * Sometimes we assert the ILOCK is held exclusively, but we're in
> +	 * a workqueue, so lockdep doesn't know we're the owner.
> +	 */
>  	if (lock_flags & XFS_ILOCK_SHARED)
> -		rwsem_assert_held(&ip->i_lock.mr_lock);
> +		rwsem_assert_held(&ip->i_lock);
>  	else if (lock_flags & XFS_ILOCK_EXCL)
> -		BUG_ON(!ip->i_lock.mr_writer);
> +		__rwsem_assert_held_write(&ip->i_lock);

It took me ages to work out that the comment related to the "__"
variant of rwsem_assert_held_write() function. I really dislike the
use of "__" prefixes for a function with slightly different,
non-obvious semantics to the parent - it's way too subtle for it to
be clear that this is what the comment is refering to.

In this case, we effectively have rwsem_assert_held_write() that
does lockdep checks, and __rwsem_assert_held_write() that does not
do lockdep checks. Either the former needs to say "lockdep" or the
latter needs "nolockdep" in the name to indicate to the reader the
intent of the code calling the checking function....

Otherwise the code looks fine.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
