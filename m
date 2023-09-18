Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C12EC46CA1
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Sep 2023 05:08:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237269AbjIRFIW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Sep 2023 01:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231883AbjIRFHx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Sep 2023 01:07:53 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C81A811C
        for <linux-xfs@vger.kernel.org>; Sun, 17 Sep 2023 22:07:46 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1c3cbfa40d6so36836325ad.1
        for <linux-xfs@vger.kernel.org>; Sun, 17 Sep 2023 22:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1695013666; x=1695618466; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=M6z0XBRSxgiJriY+TPnWcbvaSWUhO2fbf3ilso8ZY+s=;
        b=YB3b/JSAWf2HsmkfVBSfQpwGFIOi+soaGNRuCdaPIk+iTUscwbTtedkhoNs5A6/94T
         cMm0HGKKohHZJVTtfkqnqqrPaolSMDmZQ5qYNDqX7K8qdFH0+4LqlS02WOZtY9R90Ur/
         +E6DLq7MODP4GnwkrBbX0wdEnVyKRPmnnm/ZXXAYQhaFBDwsyJjw0ntl00mCvKgU/uCK
         2rZS43jaejre8Dqw5nuAL5o8rRMsYPGdDAElKshxV71LLJ2LjE0Q22OoB+zNRFNyfA7g
         8Cp3DBAybnHvsFxbkEYsCWbyx2GYWTm+8IGkru3iu4JynxnFIfaEpvvMByutMhhYNd+E
         S4QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695013666; x=1695618466;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M6z0XBRSxgiJriY+TPnWcbvaSWUhO2fbf3ilso8ZY+s=;
        b=ROJkwU7XijEwF6hsc0Obef6Z48cUS6IEQEsC3qmTB235e0pPlUZWt1En6+xI6KOsEF
         kszSss86FpZ1ZhYy8GBM23i9hJ/2XjC0WfEp3hpQiiSo3S93jtUkfduQlbBk7cmgFVNp
         NPHKh5YhdJLuMyC/uYXxSc4MyTYqjidt76949FQAbXSLfp4kI2ehDyNUg4BamuLenrCz
         gnGM7mfFAedR+S5XplpA2ly645zkEpCpcyJlqJ/7sHEz9VkD3n3+lvRTNBwi54bDidct
         12XTJs/5dX0fU4TfE/TDdvRR7HXMde0UlUvNwWOPTog4yatQX5pJ7YPftYvR9y7x6j45
         FgKg==
X-Gm-Message-State: AOJu0Yxj7pRSEdWb+ePPdRQzbvskERPRxMSr3iSGxjbzVyiWAhQxTEGt
        cuzRPcCbmMaBcfdZ+eddIK/NpA==
X-Google-Smtp-Source: AGHT+IE8P1OEwOYx0scttNCXcS7VvsJAwL4czH20HKd4GAJinQSVG8BkRdzXGitYN9r1svmoTect/A==
X-Received: by 2002:a17:902:efc6:b0:1b8:76ce:9d91 with SMTP id ja6-20020a170902efc600b001b876ce9d91mr7789080plb.1.1695013666187;
        Sun, 17 Sep 2023 22:07:46 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id iz17-20020a170902ef9100b001b9de4fb749sm7494951plb.20.2023.09.17.22.07.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Sep 2023 22:07:45 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qi6U2-002DLu-32;
        Mon, 18 Sep 2023 15:07:42 +1000
Date:   Mon, 18 Sep 2023 15:07:42 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Pankaj Raghav <kernel@pankajraghav.com>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, p.raghav@samsung.com,
        da.gomez@samsung.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, willy@infradead.org,
        djwong@kernel.org, linux-mm@kvack.org, chandan.babu@oracle.com,
        gost.dev@samsung.com
Subject: Re: [RFC 00/23] Enable block size > page size in XFS
Message-ID: <ZQfbHloBUpDh+zCg@dread.disaster.area>
References: <20230915183848.1018717-1-kernel@pankajraghav.com>
 <ZQd4IPeVI+o6M38W@dread.disaster.area>
 <ZQewKIfRYcApEYXt@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZQewKIfRYcApEYXt@bombadil.infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Sep 17, 2023 at 07:04:24PM -0700, Luis Chamberlain wrote:
> On Mon, Sep 18, 2023 at 08:05:20AM +1000, Dave Chinner wrote:
> > On Fri, Sep 15, 2023 at 08:38:25PM +0200, Pankaj Raghav wrote:
> > > From: Pankaj Raghav <p.raghav@samsung.com>
> > > 
> > > There has been efforts over the last 16 years to enable enable Large
> > > Block Sizes (LBS), that is block sizes in filesystems where bs > page
> > > size [1] [2]. Through these efforts we have learned that one of the
> > > main blockers to supporting bs > ps in fiesystems has been a way to
> > > allocate pages that are at least the filesystem block size on the page
> > > cache where bs > ps [3]. Another blocker was changed in filesystems due to
> > > buffer-heads. Thanks to these previous efforts, the surgery by Matthew
> > > Willcox in the page cache for adopting xarray's multi-index support, and
> > > iomap support, it makes supporting bs > ps in XFS possible with only a few
> > > line change to XFS. Most of changes are to the page cache to support minimum
> > > order folio support for the target block size on the filesystem.
> > > 
> > > A new motivation for LBS today is to support high-capacity (large amount
> > > of Terabytes) QLC SSDs where the internal Indirection Unit (IU) are
> > > typically greater than 4k [4] to help reduce DRAM and so in turn cost
> > > and space. In practice this then allows different architectures to use a
> > > base page size of 4k while still enabling support for block sizes
> > > aligned to the larger IUs by relying on high order folios on the page
> > > cache when needed. It also enables to take advantage of these same
> > > drive's support for larger atomics than 4k with buffered IO support in
> > > Linux. As described this year at LSFMM, supporting large atomics greater
> > > than 4k enables databases to remove the need to rely on their own
> > > journaling, so they can disable double buffered writes [5], which is a
> > > feature different cloud providers are already innovating and enabling
> > > customers for through custom storage solutions.
> > > 
> > > This series still needs some polishing and fixing some crashes, but it is
> > > mainly targeted to get initial feedback from the community, enable initial
> > > experimentation, hence the RFC. It's being posted now given the results from
> > > our testing are proving much better results than expected and we hope to
> > > polish this up together with the community. After all, this has been a 16
> > > year old effort and none of this could have been possible without that effort.
> > > 
> > > Implementation:
> > > 
> > > This series only adds the notion of a minimum order of a folio in the
> > > page cache that was initially proposed by Willy. The minimum folio order
> > > requirement is set during inode creation. The minimum order will
> > > typically correspond to the filesystem block size. The page cache will
> > > in turn respect the minimum folio order requirement while allocating a
> > > folio. This series mainly changes the page cache's filemap, readahead, and
> > > truncation code to allocate and align the folios to the minimum order set for the
> > > filesystem's inode's respective address space mapping.
> > > 
> > > Only XFS was enabled and tested as a part of this series as it has
> > > supported block sizes up to 64k and sector sizes up to 32k for years.
> > > The only thing missing was the page cache magic to enable bs > ps. However any filesystem
> > > that doesn't depend on buffer-heads and support larger block sizes
> > > already should be able to leverage this effort to also support LBS,
> > > bs > ps.
> > > 
> > > This also paves the way for supporting block devices where their logical
> > > block size > page size in the future by leveraging iomap's address space
> > > operation added to the block device cache by Christoph Hellwig [6]. We
> > > have work to enable support for this, enabling LBAs > 4k on NVME,  and
> > > at the same time allow coexistence with buffer-heads on the same block
> > > device so to enable support allow for a drive to use filesystem's to
> > > switch between filesystem's which may depend on buffer-heads or need the
> > > iomap address space operations for the block device cache. Patches for
> > > this will be posted shortly after this patch series.
> > 
> > Do you have a git tree branch that I can pull this from
> > somewhere?
> > 
> > As it is, I'd really prefer stuff that adds significant XFS
> > functionality that we need to test to be based on a current Linus
> > TOT kernel so that we can test it without being impacted by all
> > the random unrelated breakages that regularly happen in linux-next
> > kernels....
> 
> That's understandable! I just rebased onto Linus' tree, this only
> has the bs > ps support on 4k sector size:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git/log/?h=v6.6-rc2-lbs-nobdev


> I just did a cursory build / boot / fsx with 16k block size / 4k sector size
> test with this tree only. I havne't ran fstests on it.

W/ 64k block size, generic/042 fails (maybe just a test block size
thing), generic/091 fails (data corruption on read after ~70 ops)
and then generic/095 hung with a crash in iomap_readpage_iter()
during readahead.

Looks like a null folio was passed to ifs_alloc(), which implies the
iomap_readpage_ctx didn't have a folio attached to it. Something
isn't working properly in the readahead code, which would also
explain the quick fsx failure...

> Just a heads up, using 512 byte sector size will fail for now, it's a
> regression we have to fix. Likewise using block sizes 1k, 2k will also
> regress on fsx right now. These are regressions we are aware of but
> haven't had time yet to bisect / fix.

I'm betting that the recently added sub-folio dirty tracking code
got broken by this patchset....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
