Return-Path: <SRS0=zZKn=X3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1EB7C35280
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Oct 2019 13:07:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97D3421D80
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Oct 2019 13:07:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="OcATdm0f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbfJBNHp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Oct 2019 09:07:45 -0400
Received: from mail-oi1-f181.google.com ([209.85.167.181]:38274 "EHLO
        mail-oi1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727194AbfJBNHk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Oct 2019 09:07:40 -0400
Received: by mail-oi1-f181.google.com with SMTP id m16so17560877oic.5
        for <linux-xfs@vger.kernel.org>; Wed, 02 Oct 2019 06:07:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=50mE1GFOx2IDL8fOUBOO94SxADHosM9SfQ7pyxbnHTg=;
        b=OcATdm0fU0HGv1IIhubCuFeqR/P2N37o7xtR/ZD4irFYeHZyY/QMlcxb9A3jVo1gr4
         chbxvSvR7VV0Qigg5Ap4In4xkHjYBGjW81DG45OK+R+st0eaUOvKFdRsNtBGfdXXso+G
         CRT9yAg3GyQINBZ5KBDazaDUYmqZ9vColyWrmK7zf2b7qw3LLSuXB22GA91dRzkb/DN3
         hVBuovDyfmx09Yu6vWFC0lVHAXaZdX+8e6xTLeBTs8iVaP9DmUzHXZJ5SuCoYXwZ14L3
         3WdQyTtyBcH2b1o1IoJ8dDqWwniK/IYku412BJ6lj3HdaGvf3lcdbJk/pu8WTervpUsH
         BKcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=50mE1GFOx2IDL8fOUBOO94SxADHosM9SfQ7pyxbnHTg=;
        b=OJ8AMN7JkndoZbx3zRXoLfmrRBOtcKvb2TDSQaw9ajCmxZzBY61Zo6LmaJbsLekSiT
         oKKuySDoyMR10taGmKs0oF4/+ZuMCyNfftBXUZQdWCwTod+hdcfMCtHuUcr6BmzM6PL2
         KJmt1uWt9fW+Nrivivzc9BQZLIR7feCHP1hOeVh9OwWI6Syp21BzUZyKG198luNR9eUm
         Q93vmiLc8xDXlBFSa6lZypJ1nTP6r1blEx1xA6KVsiThMO/POhkezghVGciFdBsEkEEx
         Tlm7PlgqChhOhnO4ei1uCBAK2ysD/280SLRjQQjYavhOy1oE5Iv1zoicrl6luR/9vbQF
         tOag==
X-Gm-Message-State: APjAAAUBPYINHAt5T5MkuHUD3kjyHFJDLPc1HFWLXc6bUAakySRUf4LO
        T1KHiZUablNil2a8rlvtz0gnvcc26I6TVNuDI+Wbxg==
X-Google-Smtp-Source: APXvYqxGQ01cpMCqhyT0OZic4du6ntHizaukJRygkeedHLWkQjdo8fNGeQWk8deAiGsRuCSgwYPjlJGf+Xhg9J875/c=
X-Received: by 2002:aca:eb09:: with SMTP id j9mr2925590oih.105.1570021659582;
 Wed, 02 Oct 2019 06:07:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190923190853.GA3781@iweiny-DESK2.sc.intel.com>
 <20190923222620.GC16973@dread.disaster.area> <20190925234602.GB12748@iweiny-DESK2.sc.intel.com>
 <20190930084233.GO16973@dread.disaster.area> <20191001210156.GB5500@iweiny-DESK2.sc.intel.com>
In-Reply-To: <20191001210156.GB5500@iweiny-DESK2.sc.intel.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 2 Oct 2019 06:07:27 -0700
Message-ID: <CAPcyv4jpLYUcqA6D_qfGF4FQCu-SuH67FHLcH0fCQTQ-D+hWzQ@mail.gmail.com>
Subject: Re: Lease semantic proposal
To:     Ira Weiny <ira.weiny@intel.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        Linux MM <linux-mm@kvack.org>,
        Jeff Layton <jlayton@kernel.org>, Jan Kara <jack@suse.cz>,
        "Theodore Ts'o" <tytso@mit.edu>,
        John Hubbard <jhubbard@nvidia.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 1, 2019 at 2:02 PM Ira Weiny <ira.weiny@intel.com> wrote:
>
> On Mon, Sep 30, 2019 at 06:42:33PM +1000, Dave Chinner wrote:
> > On Wed, Sep 25, 2019 at 04:46:03PM -0700, Ira Weiny wrote:
> > > On Tue, Sep 24, 2019 at 08:26:20AM +1000, Dave Chinner wrote:
> > > > Hence, AFIACT, the above definition of a F_RDLCK|F_LAYOUT lease
> > > > doesn't appear to be compatible with the semantics required by
> > > > existing users of layout leases.
> > >
> > > I disagree.  Other than the addition of F_UNBREAK, I think this is consistent
> > > with what is currently implemented.  Also, by exporting all this to user space
> > > we can now write tests for it independent of the RDMA pinning.
> >
> > The current usage of F_RDLCK | F_LAYOUT by the pNFS code allows
> > layout changes to occur to the file while the layout lease is held.
>
> This was not my understanding.

I think you guys are talking past each other. F_RDLCK | F_LAYOUT can
be broken to allow writes to the file / layout. The new unbreakable
case would require explicit SIGKILL as "revocation method of last
resort", but that's the new incremental extension being proposed. No
changes to the current behavior of F_RDLCK | F_LAYOUT.

Dave, the question at hand is whether this new layout lease mode being
proposed is going to respond to BREAK_WRITE, or just BREAK_UNMAP. It
seems longterm page pinning conflicts really only care about
BREAK_UNMAP where pages that were part of the file are being removed
from the file. The unbreakable case can tolerate layout changes that
keep pinned pages mapped / allocated to the file.
