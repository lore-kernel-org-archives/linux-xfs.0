Return-Path: <SRS0=2RH+=XM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDF5FC4CECD
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Sep 2019 12:22:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB1FB21852
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Sep 2019 12:22:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbfIQMWp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Sep 2019 08:22:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43024 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725901AbfIQMWo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 17 Sep 2019 08:22:44 -0400
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8291C89AC0
        for <linux-xfs@vger.kernel.org>; Tue, 17 Sep 2019 12:22:44 +0000 (UTC)
Received: by mail-wr1-f69.google.com with SMTP id q10so1238148wro.22
        for <linux-xfs@vger.kernel.org>; Tue, 17 Sep 2019 05:22:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=ze2LzkLdFHyr0YaV8htidL+Ck6SqwB9SE4bUMwYhgqI=;
        b=umULTvdeXHGY+PuYwxFjZyoXI1KkF+b7BRBLWSo34K1+eKEvwkFw5neMn1TjWEUQe5
         LocqPuYWBfZfkn46vKmS/wDz2lzyX+xk8r0LnSo75fzpAWs42FiynI9CYVskTTZ0zd9f
         MSRKltQunbbYtpFulEDb4fQlq3e+/fnhRha8mTRAexl/Wo2jQtuPEwR0k/ynmVZ3qce8
         y5+LdL7fQvzxe/K1xDNqcLHRKrGjorGK7K5m+ELLGHiDcMEYPkUiXth9TpMcaAjdMnmb
         lpQ22EhPRF5faW8Uss35OxJrkbSZt3tIU1xIAsmkz0q5vdR7qMwRwkkvMjOdgcOokIde
         BLpw==
X-Gm-Message-State: APjAAAUOqWWmKg877LREtGRZk2VhObWCDTrACGonfbmKd7r/fC9P7u84
        25kDPoxxwRhdxrps+zy1G5U1GkXY7QL+B61cZaD/WIWysQxEeUJ+ZWHYHn2u0gaL/0u5tJEvIWm
        7cNRIaeBS4pHk73f4ZR2c
X-Received: by 2002:adf:ef44:: with SMTP id c4mr2926771wrp.216.1568722963232;
        Tue, 17 Sep 2019 05:22:43 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxfS/CkbeKd0OAe6BYqtKl1VOJbOjScJvIQji2DQELaKzNClIz9lKlmzTLywPgKr1gQb5XYig==
X-Received: by 2002:adf:ef44:: with SMTP id c4mr2926757wrp.216.1568722963045;
        Tue, 17 Sep 2019 05:22:43 -0700 (PDT)
Received: from orion.maiolino.org (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id a192sm2066121wma.1.2019.09.17.05.22.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Sep 2019 05:22:42 -0700 (PDT)
Date:   Tue, 17 Sep 2019 14:22:40 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH REPOST 1/2] xfs: drop minlen before tossing alignment on
 bmap allocs
Message-ID: <20190917122240.2wx4ubdaentl76v5@orion.maiolino.org>
Mail-Followup-To: Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
References: <20190912143223.24194-1-bfoster@redhat.com>
 <20190912143223.24194-2-bfoster@redhat.com>
 <20190912223519.GP16973@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190912223519.GP16973@dread.disaster.area>
User-Agent: NeoMutt/20180716
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave.

I've been playing a bit with it, and, based on our talk on IRC:

> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4286,6 +4286,20 @@ xfs_bmapi_write(
>  #endif
>  	whichfork = xfs_bmapi_whichfork(flags);
>  
> +	/*
> +	 * XXX: Hack!
> +	 *
> +	 * If the total blocks requested is larger than an AG, we can't allocate
> +	 * all the space atomically and within a single AG. This will be a
> +	 * "short" allocation. In this case, just ignore the total block count
> +	 * and rely on minleft calculations to ensure the allocation we do fits
> +	 * inside an AG properly.
> +	 *
> +	 * Based on a patch from Brian.
> +	 */
> +	if (bma.total > mp->m_ag_max_usable)
> +		bma.total = 0;

Instead zeroing bma.total here, can't we crop it to blen in xfs_bmap_btalloc()?

I did some tests here and looks like the result is the same, although I'm not
sure if it's a good approach.

Cheers

> +
>  	ASSERT(*nmap >= 1);
>  	ASSERT(*nmap <= XFS_BMAP_MAX_NMAP);
>  	ASSERT(tp != NULL);

-- 
Carlos
