Return-Path: <SRS0=Z/aa=WP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84D0BC3A5A0
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Aug 2019 12:38:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 555A42085A
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Aug 2019 12:38:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Kw5dYDPC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727524AbfHSMio (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Aug 2019 08:38:44 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:40126 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727445AbfHSMin (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Aug 2019 08:38:43 -0400
Received: by mail-qk1-f196.google.com with SMTP id s145so1211468qke.7
        for <linux-xfs@vger.kernel.org>; Mon, 19 Aug 2019 05:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=kcl2qjS+S92HqUsWy/tjB3qoqqgCsFoa4lNkLGm9eqU=;
        b=Kw5dYDPC3RCMymknBRy1kIe+iDY+gtMlsFiGqHh0HRHDdkA1mVDMtLhKZZ0CG2KFv3
         LVYv+T9FGmeylYTDi+kh5M9/Ntuhs1KUREG17679sHQhmPsIVOwRG2eQbHs3GIhuH2De
         teqAib33hkHc6gnoEGXxQH7ITS22Bxbhltn46+fBqORa9Jb9jv/kTbwn4XmLd12IuyM5
         /yPvmu7+YELsKojRcfZOMaNBoqJ1qtrNgLmHYKwBdl9/gdtpWh1vLo6xyTHwMVm7oA6I
         7K86YItRgHihPHUhSIgXXcp4Bm7RF41NJgLrAPGgKKR410ENEsEKjr9s9uuDjUGnheP5
         bsRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=kcl2qjS+S92HqUsWy/tjB3qoqqgCsFoa4lNkLGm9eqU=;
        b=c3i4CBKLYuvp8PdZBWi2DjJxDgcvj2bfqWMKwGnuG+xFZpSqIdxtQUIOwI+3usEgfw
         E3glYZ/DyEsn/Ecgsdzq4IuBPy+ERG0z70GxCkg/jAjLcOvjotrmH5qCXt645ywwfq2C
         n8tOEuGCmn3RJti8VyINJXZYC5646HxpVOCiz1ql1+qrR09KwWaHAMPDNtzWcpPDbZsN
         fdrpMRDhdtQoykHoozt9HfTfRUIlCL9DPoBdKUs/MQsj77ehi2NEVb8gveUtWyr8UtDb
         itCt2EilPaj4A5J9GXaOijI+1T+V0VeCWKFWiuwkcVRMLjjxs/PJTWOJszprvc78WdVa
         CEGQ==
X-Gm-Message-State: APjAAAXoo6Gta8DficLYqAjrpH3ZfZDbLy+B/FqntK2Tm35o+UATFq1z
        8nhZcgyrw2s/Mzc+9DX1Yxr3lA==
X-Google-Smtp-Source: APXvYqzbQNTYwMVTncdSqshKmZtcSi8KUDzyxSrbcJIuOywIrId5vXd75IqedVtc8bcWHqWRX6iGcQ==
X-Received: by 2002:a37:a14a:: with SMTP id k71mr20104946qke.281.1566218322367;
        Mon, 19 Aug 2019 05:38:42 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-55-100.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.55.100])
        by smtp.gmail.com with ESMTPSA id r15sm6916339qtp.94.2019.08.19.05.38.41
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 19 Aug 2019 05:38:41 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hzgvp-0001vJ-9J; Mon, 19 Aug 2019 09:38:41 -0300
Date:   Mon, 19 Aug 2019 09:38:41 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Jan Kara <jack@suse.cz>, Ira Weiny <ira.weiny@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Theodore Ts'o <tytso@mit.edu>,
        John Hubbard <jhubbard@nvidia.com>,
        Michal Hocko <mhocko@suse.com>, linux-xfs@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org,
        linux-ext4@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 00/19] RDMA/FS DAX truncate proposal V1,000,002 ;-)
Message-ID: <20190819123841.GC5058@ziepe.ca>
References: <20190809225833.6657-1-ira.weiny@intel.com>
 <20190814101714.GA26273@quack2.suse.cz>
 <20190814180848.GB31490@iweiny-DESK2.sc.intel.com>
 <20190815130558.GF14313@quack2.suse.cz>
 <20190816190528.GB371@iweiny-DESK2.sc.intel.com>
 <20190817022603.GW6129@dread.disaster.area>
 <20190819063412.GA20455@quack2.suse.cz>
 <20190819092409.GM7777@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190819092409.GM7777@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 19, 2019 at 07:24:09PM +1000, Dave Chinner wrote:

> So that leaves just the normal close() syscall exit case, where the
> application has full control of the order in which resources are
> released. We've already established that we can block in this
> context.  Blocking in an interruptible state will allow fatal signal
> delivery to wake us, and then we fall into the
> fatal_signal_pending() case if we get a SIGKILL while blocking.

The major problem with RDMA is that it doesn't always wait on close() for the
MR holding the page pins to be destoyed. This is done to avoid a
deadlock of the form:

   uverbs_destroy_ufile_hw()
      mutex_lock()
       [..]
        mmput()
         exit_mmap()
          remove_vma()
           fput();
            file_operations->release()
             ib_uverbs_close()
              uverbs_destroy_ufile_hw()
               mutex_lock()   <-- Deadlock

But, as I said to Ira earlier, I wonder if this is now impossible on
modern kernels and we can switch to making the whole thing
synchronous. That would resolve RDMA's main problem with this.

Jason
