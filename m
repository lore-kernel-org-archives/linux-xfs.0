Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F0E5CDB465
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Oct 2023 17:19:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbjJPRTx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Oct 2023 13:19:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232570AbjJPRTw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Oct 2023 13:19:52 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 110C183
        for <linux-xfs@vger.kernel.org>; Mon, 16 Oct 2023 10:19:50 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id 41be03b00d2f7-517ab9a4a13so3551312a12.1
        for <linux-xfs@vger.kernel.org>; Mon, 16 Oct 2023 10:19:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20230601.gappssmtp.com; s=20230601; t=1697476789; x=1698081589; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rQrFuxaIw8iRMp1TIq+xfxrfOhw3vg/1KFWpdDCWf5o=;
        b=jtC11j2H6GxWWCZi3MEDYcuxg3P6GxAhzsSjrBrrqDzxXUy5dlq872r7SHxL8GaJpo
         MEb1zufioI9e53TWkDkMtIqz5nv8eYY/Tt5mVh1Pgm5lOPhv9QcB735jX+h/D15IaM2X
         IO2uTZKLJdzRYX0hmnDE37Rl9aGsZh4nme9l75xebXSu6prAHv/sb03QzQWlU9YC/emk
         fHyF6WnCKQU45RrJtupIZzvoUYtoM4ZI9k1rKdX9/n5xqRs6PKfLbkldkbL3nKEwuB0+
         vvCFh/BAnpFAkspujCslU7hK0zPhdwvW+WzjfMAR/lumC3OKAmYrSqFDfj836CMwkIdm
         Vqfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697476789; x=1698081589;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rQrFuxaIw8iRMp1TIq+xfxrfOhw3vg/1KFWpdDCWf5o=;
        b=IcvnfAIsKpAjhfqA7bXgMmpJUjwssBxZkvS9fVoN1YxyGgZA60mjyFtpJ7ba3Mjtip
         pXqZOez8zA43XPqhpYB8CDevQ48XaMrO7dAkLddn6pR+eO+FCsFQb6HtYcLR7gk2YIOM
         bemWUiFSf8aia3/G96XiO4SpZvX/MG5yt6GVeRx3BzU5pEVrZ61CopBj+BY6VJE5axZ1
         KWMAdzWA+QHUV0lmvX9iLzG6TNXM6dvx7+lmsWZ+PM5Jsw0IS3W5/v7zpQnzsVPrVAtc
         t6TWj85noHLz2JuWrM+CMDnBPq2CQYIEDyBE6UQtMeCymjPjsPe+YKcryqmtaj8CkHIw
         LF+w==
X-Gm-Message-State: AOJu0YzmfuHSaYvEx1JsPgFSNV80uxZ+S/YNb2xjX+sNvxyNVimo8ebS
        PpGut1q1j6CfPjMzMNIwwOx4Kg==
X-Google-Smtp-Source: AGHT+IGC6RdK50glETjk9KHmiK5zTcDEJmnnOmpaD4F8oBj2akKkxj4nEANzWU9cKS0Oayh4IaDxQQ==
X-Received: by 2002:a05:6a20:d403:b0:15e:ab6:6e24 with SMTP id il3-20020a056a20d40300b0015e0ab66e24mr31623369pzb.27.1697476789469;
        Mon, 16 Oct 2023 10:19:49 -0700 (PDT)
Received: from telecaster ([2620:10d:c090:500::5:6282])
        by smtp.gmail.com with ESMTPSA id m9-20020a654c89000000b005af69a358ccsm4139684pgt.77.2023.10.16.10.19.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Oct 2023 10:19:49 -0700 (PDT)
Date:   Mon, 16 Oct 2023 10:19:47 -0700
From:   Omar Sandoval <osandov@osandov.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs: use shifting and masking when converting rt
 extents, if possible
Message-ID: <ZS1ws+S+R9anbrdg@telecaster>
References: <169704721170.1773611.12311239321983752854.stgit@frogsfrogsfrogs>
 <169704721284.1773611.1915589661676489.stgit@frogsfrogsfrogs>
 <20231012052511.GF2184@lst.de>
 <20231012181908.GK21298@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231012181908.GK21298@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 12, 2023 at 11:19:08AM -0700, Darrick J. Wong wrote:
> On Thu, Oct 12, 2023 at 07:25:11AM +0200, Christoph Hellwig wrote:
> > On Wed, Oct 11, 2023 at 11:06:14AM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Avoid the costs of integer division (32-bit and 64-bit) if the realtime
> > > extent size is a power of two.
> > 
> > Looks good:
> > 
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > 
> > Do you have any data on how common non-power of two rtext sizes are?
> > Might it be worth to add unlikely annotations?
> 
> I don't really know about the historical uses.  There might be old
> filesystems out there with a non-power-of-2 raid stripe size that are
> set up for full stripe allocations for speed.
> 
> We (oracle) are interested in using rt for PMD allocations on pmem/cxl
> devices and atomic writes on scsi/nvme devices.  Both of those cases
> will only ever use powers of 2.
> 
> I'll add some if-test annotations and we'll see if anyone notices. ;)
> 
> --D

We are using 1044KB realtime extents (blocksize = 4096, rextsize = 261)
for our blob storage system. It's a goofy number, but IIRC it was chosen
because their most common blob sizes were single-digit multiples of a
megabyte, and they wanted a large-ish (~1MB) realtime extent size to
reduce external fragmentation, but they also wanted to store a bit of
extra metadata without requiring an extra realtime extent and blowing up
internal fragmentation.
