Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76DB1C25B48
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Oct 2023 22:10:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232642AbjJ0WKr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 Oct 2023 18:10:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbjJ0WKq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Oct 2023 18:10:46 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23D3A1A6
        for <linux-xfs@vger.kernel.org>; Fri, 27 Oct 2023 15:10:44 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-6b3c2607d9bso2487981b3a.1
        for <linux-xfs@vger.kernel.org>; Fri, 27 Oct 2023 15:10:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1698444643; x=1699049443; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2gGWI9hiI8wgQuogxLeAYpmHgRP3GLhdkxT/rH7PRNE=;
        b=FwBsr3vp78eoyv3K0ksbwYy3169VuRqIoEyGBCYlkcBgfc4TEfDIzd4iqLub1srObf
         8DdJECk8QEHifDTHuWhazmS9CAVHuGxWm/v0CET5bWNz2J9J7LSNeDCU6zFk+/kytZvI
         xCHyg578sj09wQGKuCoQWf30syE3/hFTOlChjAKdFhiAlZHSeBPEQsFTFcD6TWjOwELX
         6FaJRXwMOywFJGECf8Dwy6510PrvDJ87BBHWk1jhhKWEtTNuPkY/Tvabo3NITXmRDKXO
         V6HCmtk2cUtWUfyWk88lgjiE7AlDRIR9KVOE4Tcw8Yg91vHlApGEdk5wrXorZusIbXyO
         QVng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698444643; x=1699049443;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2gGWI9hiI8wgQuogxLeAYpmHgRP3GLhdkxT/rH7PRNE=;
        b=kvBLKa75Y9swQLd4F3balRcc0zmSCUuCD8uNg+MgwQqKLWS755qK/barHUwij0BCnk
         LSi6JoEEiKFRBmltK2We9f3kDJ2QeJBOdwqa7PoKaouyP5nPWcmt2LDQxSUNMcvYmEwa
         D8plV/fMFNkImbvKNPZwgKLnshat4vcinrsSNy0cMhUH31WsPGDo1ClTGYFPS7NQ5/9i
         kUwJDL0h+VDh8kscJ6WNO6o5/j+fec6wKLmlIDH8T11iUCoQ6kbdJq/45EfDmWeRVPO/
         DnHaf1d6vqfs2My2CvYuhbmh8uP8BF0Mpy980GqQG84w516R6z7sAMxo+fnRVkxQP/de
         SFeA==
X-Gm-Message-State: AOJu0YzlB0gwMdFrNkv+OXpnym1yQTBJ2k0pgf1iCN4v0Jh8YtV9rjmX
        nvwAUc8ybdyT92NtaFT4l70X0w==
X-Google-Smtp-Source: AGHT+IG1IoxGOdlvIsbi6PiESNZk4zXqAR70hoxoWNSTSt//UbCeW8udyzVcIuBpsVlTsNxAKlZ/XA==
X-Received: by 2002:a05:6a00:244b:b0:693:3851:bd98 with SMTP id d11-20020a056a00244b00b006933851bd98mr4264853pfj.2.1698444643600;
        Fri, 27 Oct 2023 15:10:43 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id j8-20020aa783c8000000b00690b8961bf4sm1912884pfn.146.2023.10.27.15.10.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Oct 2023 15:10:42 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qwV2N-004n9d-1L;
        Sat, 28 Oct 2023 09:10:39 +1100
Date:   Sat, 28 Oct 2023 09:10:39 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Pankaj Raghav <kernel@pankajraghav.com>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        willy@infradead.org, djwong@kernel.org, mcgrof@kernel.org,
        hch@lst.de, da.gomez@samsung.com, gost.dev@samsung.com,
        Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [PATCH] iomap: fix iomap_dio_zero() for fs bs > system page size
Message-ID: <ZTw1X3YdOmBmM+hQ@dread.disaster.area>
References: <20231026140832.1089824-1-kernel@pankajraghav.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231026140832.1089824-1-kernel@pankajraghav.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 26, 2023 at 04:08:32PM +0200, Pankaj Raghav wrote:
> From: Pankaj Raghav <p.raghav@samsung.com>
> 
> iomap_dio_zero() will pad a fs block with zeroes if the direct IO size
> < fs block size. iomap_dio_zero() has an implicit assumption that fs block
> size < page_size. This is true for most filesystems at the moment.
> 
> If the block size > page size (Large block sizes)[1], this will send the
> contents of the page next to zero page(as len > PAGE_SIZE) to the
> underlying block device, causing FS corruption.
> 
> iomap is a generic infrastructure and it should not make any assumptions
> about the fs block size and the page size of the system.
> 
> Fixes: db074436f421 ("iomap: move the direct IO code into a separate file")

I forgot to mention - this fixes tag is completely bogus. That's
just a commit that moves the code from one file to another and
there's no actual functional change at all.

Further, this isn't a change that "fixes" a bug or regression - it
is a change to support new functionality that doesnt' yet exist
upstream, and so there is no bug in the existing kernels for it to
fix....

-Dave.

-- 
Dave Chinner
david@fromorbit.com
