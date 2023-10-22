Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED6A7CDB474
	for <linux-xfs@archiver.kernel.org>; Sun, 22 Oct 2023 22:20:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232817AbjJVWUg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 22 Oct 2023 18:20:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjJVWUg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 22 Oct 2023 18:20:36 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96D4899
        for <linux-xfs@vger.kernel.org>; Sun, 22 Oct 2023 15:20:34 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id 98e67ed59e1d1-27e0c1222d1so1601228a91.0
        for <linux-xfs@vger.kernel.org>; Sun, 22 Oct 2023 15:20:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1698013234; x=1698618034; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fq82fkzY9Ugv+oVtQWs3uIE1A3LjaqePvETUqg46TDs=;
        b=Xt8e2arWMW4VaXtb4ZT1um97AT3g/lF692y2mINYr++2lUyPh3yqipOtgFlk9MroFX
         FYEiHpl+1nqkpT/AecPMHGoGtvk/ybnibGkysUrW949SzJYXXD3U9iJoF8djyZE4XM9M
         y1TXtNBd+kF3inHDt+cNlvJIiiUQ+DtEzgw4lP9tN6cWMKEvP3/PhgV2Uoo3gC8tN4/B
         yeTJEfV6E9QqsMOJiQNoN0Un3M7j7BpmFQQXmwpvuvcrt6v1uKoz03s1o41sXg7aMyev
         KGHGYrsCaSbRX9u4hfL1t+skzUtNHZ1AkBSc66LO3M+h8jvd8dAve2b4hXYKpv/DcM7d
         HNQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698013234; x=1698618034;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fq82fkzY9Ugv+oVtQWs3uIE1A3LjaqePvETUqg46TDs=;
        b=MYY0JwMkp6cyafhZtZ7vpwUU1rZlYgxz4SMmym0Nl2iYtnVsg/Q7U6ls/od6graCxc
         btFq/5w/T60MVS9f2cUu2E/Hp7eWVh+iY5g+S1n0UxCi8RBkcJ++chMAMfLLRDLa6VyJ
         g/2I2Vt/Wli+ga5aIykKpWsJwVeQEeaBXvhWGUBMHbWAbmk7TlGfpM/DqMrELZ6SvP0P
         B91zUCrqsILuHJTlsN6WXbnGIcYGjVHg7d6qkXBLU4ogpWQhi8M503ntGc0bcqbx58F7
         p6rVeMzo2CWAzCsrR6/mCmyvpoUTqU3LqOomSyfGgIxCyeiuXRAOoqxuexwWKZrgtTPI
         5FPw==
X-Gm-Message-State: AOJu0YxVtNsG3jE1u8i2at/RsMTEy4yLaxIxkmySw+ychgNAWRfE4xoO
        AVMD/4VQg1Jny8pPYoETpKHdVfGgvwv2Dp6Pxow=
X-Google-Smtp-Source: AGHT+IHo4RIbEclbzN90/boejRVUiBnr2fUNx5KrWX3BfeHdRvLBvN6QaKOAxpvgDav2WJJLFPsVJg==
X-Received: by 2002:a17:90b:608:b0:27d:44ce:cf7a with SMTP id gb8-20020a17090b060800b0027d44cecf7amr5904802pjb.5.1698013234061;
        Sun, 22 Oct 2023 15:20:34 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id j11-20020a17090aeb0b00b00262ca945cecsm6296029pjz.54.2023.10.22.15.20.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Oct 2023 15:20:33 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qugoB-002cIr-0L;
        Mon, 23 Oct 2023 09:20:31 +1100
Date:   Mon, 23 Oct 2023 09:20:31 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH] generic: test reads racing with slow reflink
 operations
Message-ID: <ZTWgLzODbEIDHuKv@dread.disaster.area>
References: <20231019200913.GO3195650@frogsfrogsfrogs>
 <ZTIZrT7ZcWQHypEG@infradead.org>
 <20231020152248.GQ3195650@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231020152248.GQ3195650@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 20, 2023 at 08:22:48AM -0700, Darrick J. Wong wrote:
> On Thu, Oct 19, 2023 at 11:09:49PM -0700, Christoph Hellwig wrote:
> > On Thu, Oct 19, 2023 at 01:09:13PM -0700, Darrick J. Wong wrote:
> > > permit reads, since the source file contents do  not change.  This is a
> > 
> > duplicate white space before "not"
> 
> Fixed.
> 
> > > +#ifndef FICLONE
> > > +# define FICLONE	_IOW(0x94, 9, int)
> > > +#endif
> > 
> > Can't we assume system headers with FICLONE by now?
> 
> That depends on the long tail of RHEL7.  But you're right, it has been
> years now, I'll just kill this hunk and see who complains. :)

*cough*

Just add an autoconf rule, yes?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
