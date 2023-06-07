Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97C04C7EE29
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jun 2023 02:21:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240748AbjFGCVU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 22:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240739AbjFGCVO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jun 2023 22:21:14 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6FF61732
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 19:21:13 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id 46e09a7af769-6af93a6166fso6316205a34.3
        for <linux-xfs@vger.kernel.org>; Tue, 06 Jun 2023 19:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1686104470; x=1688696470;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=C4iBVR0i8Bu4cQNfPBIFelVQWQVCZcr/7TcZoBGNzkQ=;
        b=4HPRV6kTLFDjL7jvT1mxv6rgzPNMbQmfgaY+cAOizYisKPmnYs+kgfGkGhZEYmdxQ6
         Q3o4iYTE8B00LBTYT/rw6cq1yDsD/xzit0TccrkcsWF0U3cwFD58r9L31vcijNHKU1p8
         +zvE8xwpw/KRk7nh7vvtA5HkN5AySzAQlJNCedgreMfxmD8UOAICI0N1F6gpSJjokdRu
         mlRGMIVke2Z3IK0w0L04jwNqLGaiuXRUcf6bulSgbIeKVii25ZFQkMKC/z91xqaqRoup
         xJt+HjiogWs4ZCqFUIitnfUWEN984F9q/AyUqwo4MWb7w22JaZqnDIKYi7Rzr7nX/OKX
         /aUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686104470; x=1688696470;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C4iBVR0i8Bu4cQNfPBIFelVQWQVCZcr/7TcZoBGNzkQ=;
        b=Py+TO/cSVsZu/RB5z9LrTMclPCe8Ixzzf+pUVgxVp0tqLjDB9mCoRh+FTtSx+yqEZh
         i1e11EkY7H3KO6bY5IqSnaD9nw+0IGcRdOZWj8DOlIdjFrwuN3bOF3lRUiY1dVzdDCCY
         aAZpTyegioBWaIYiyXBeFDq0ppc4+fvfGgWfZc6K8Bsl5OWToq+gWuWFYzUJ/BYbBxRv
         r6hy6Gmt5ZLzbArRfmohOseo4dG2aJh0QeISmDoh3PRsFyTENfYY78lthgplRY1q6FTr
         842dmL+Kj2BMFATgcQxn8eezIBmwN4MKjY5n2NqLQreTBXEd8DVGBg5wKjBVEKi8rrB9
         NsgA==
X-Gm-Message-State: AC+VfDzixsOnyLgBUvM7LxYl/q0EEwEp3dwaAUXys++mV4Wl9BlUpg4C
        s1j7HTHmdbMnG5N1d0kAVEMBblTEVlbOvQcO3wA=
X-Google-Smtp-Source: ACHHUZ5FvwhUet8VVDuvZ4e8ssLawHzROUAW/m0eK57RByNweCdQzJ7p1c9rbSzJ5uGfNqZnN2Imcw==
X-Received: by 2002:a9d:7312:0:b0:6b1:6583:dfd9 with SMTP id e18-20020a9d7312000000b006b16583dfd9mr4318808otk.29.1686104470550;
        Tue, 06 Jun 2023 19:21:10 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-79-151.pa.nsw.optusnet.com.au. [49.179.79.151])
        by smtp.gmail.com with ESMTPSA id s19-20020aa78293000000b0063f0068cf6csm7290601pfm.198.2023.06.06.19.21.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 19:21:09 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1q6inL-008iic-14;
        Wed, 07 Jun 2023 12:21:07 +1000
Date:   Wed, 7 Jun 2023 12:21:07 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Jianan Wang <wangjianan.zju@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Question on the xfs inode slab memory
Message-ID: <ZH/pk1UYR7BrT78b@dread.disaster.area>
References: <CAMj1M42L6hH9weqroQNaWu_SG+Yg8NrAuzgNO1b8jiWPJ2M-5A@mail.gmail.com>
 <ZHfhYsqln68N1HyO@dread.disaster.area>
 <7572072d-8132-d918-285c-3391cb041cff@gmail.com>
 <ZHkRHW9Fd19du0Zv@dread.disaster.area>
 <b9c528fd-9556-12c5-4628-4163c070e45d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9c528fd-9556-12c5-4628-4163c070e45d@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 06, 2023 at 04:00:56PM -0700, Jianan Wang wrote:
> Hi Dave,
> 
> Just to follow up on this. We have performed the testing using the
> Ubuntu 20.04 with 5.15 kernel as well as our custom built xfs 5.9,
> but we still see significant slab memory build-up during the
> process.

That's to be expected. Nothing has changed with respect to inode
cache size management. All the changes were to how the XFS inode
cache gets reclaimed.  Are you getting OOM killer reports when under
memory pressure on 5.15 like you originally reported for the 5.4
kernel you were running?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
