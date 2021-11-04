Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EDA0C433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Nov 2021 18:10:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 446B96120F
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Nov 2021 18:10:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234090AbhKDSNJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Nov 2021 14:13:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234091AbhKDSNJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Nov 2021 14:13:09 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB612C061203
        for <linux-xfs@vger.kernel.org>; Thu,  4 Nov 2021 11:10:30 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id r5so8637302pls.1
        for <linux-xfs@vger.kernel.org>; Thu, 04 Nov 2021 11:10:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7mdrEIaynFJhMAYVbY2RCFSQ3xBs/5manpadoyeA8Jg=;
        b=0YEcomScst+1AzYcEtB+P3/DmeUM77501UDi4utLMr5xdKJlnd8UevBd12j9FnZ3vM
         pfReEE9Mys+ZVEwliSTF7urxA8Wo0+Hi1QGvdNyLT71G18SgBjzWHXiXc01F/GMcT30o
         4sj59niVU83geSVU+jTxOcRmF241hREk19CsoBH8kxr2RQdc6rHN1RFVCxVTxuFK53C5
         ubx4NqJpME+C1zDILd+MfHjSjbqUFn2nDpjUaVUu+wM8te1yVWJyRStj28nUJ7WDbMUk
         H2RDjE1nkFNI+5JNwfhWiSHo+ZLBnVukougjDJ/S9PImKe7sfLSLlzrr4uAIBYjBE48z
         eouQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7mdrEIaynFJhMAYVbY2RCFSQ3xBs/5manpadoyeA8Jg=;
        b=7l+xZNs4GrJtR8mUQYRAkaNzW5FAcHxCNeizHVsdsFOYuTCyqL0RdLCkXO9rmmBjRQ
         E2PIYEn0O03YdvlPpUgGxzCUONOphMEPrtV+g7U7vZPYM50y/qDwGuY7RCjtqGFpNf8P
         kW0GKpj7L0At1Mim/f52ijLvyJTA4rYOt2Wcf/rCnAF/peMFtgC1V+u7K9p2FiYAWci9
         hVTwPICp4okbKIRwejF7jdRZb2QuV+/hXVKy5RH7n4VFhtAciVEW2ADycqprlrEk9+8O
         Og/lcNdi5fTgBdzVS1GYXejhB76VPwgylDC+U8/kakpTksyuqT0bMDQwjmegIRbwg/18
         X7cQ==
X-Gm-Message-State: AOAM532AeLGjqQbv2gCH65B+7knA3Pw1ewTy3oDFfulQbpsK5KONE+mO
        1Df3egcBhNZzxjZbYhIL3d4FVcCdsLV7o/H5OXRdoQ==
X-Google-Smtp-Source: ABdhPJxpE7179nYWnBAffbsem/btoh3olrocKEPy5McMuIBWtGLmZ02iwXqFLVvSNceMnE3VXVk1wLsDAvNCq2GAmrQ=
X-Received: by 2002:a17:902:b697:b0:141:c7aa:e10f with SMTP id
 c23-20020a170902b69700b00141c7aae10fmr33445935pls.18.1636049430346; Thu, 04
 Nov 2021 11:10:30 -0700 (PDT)
MIME-Version: 1.0
References: <20211018044054.1779424-1-hch@lst.de> <21ff4333-e567-2819-3ae0-6a2e83ec7ce6@sandeen.net>
 <20211104081740.GA23111@lst.de> <20211104173417.GJ2237511@magnolia> <20211104173559.GB31740@lst.de>
In-Reply-To: <20211104173559.GB31740@lst.de>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 4 Nov 2021 11:10:19 -0700
Message-ID: <CAPcyv4jbjc+XtX5RX5OL3vPadsYZwoK1NG1qC5AcpySBu5tL4g@mail.gmail.com>
Subject: Re: futher decouple DAX from block devices
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>,
        Mike Snitzer <snitzer@redhat.com>,
        Ira Weiny <ira.weiny@intel.com>,
        device-mapper development <dm-devel@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        linux-s390 <linux-s390@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-erofs@lists.ozlabs.org,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 4, 2021 at 10:36 AM Christoph Hellwig <hch@lst.de> wrote:
>
> On Thu, Nov 04, 2021 at 10:34:17AM -0700, Darrick J. Wong wrote:
> > /me wonders, are block devices going away?  Will mkfs.xfs have to learn
> > how to talk to certain chardevs?  I guess jffs2 and others already do
> > that kind of thing... but I suppose I can wait for the real draft to
> > show up to ramble further. ;)
>
> Right now I've mostly been looking into the kernel side.  An no, I
> do not expect /dev/pmem* to go away as you'll still need it for a
> not DAX aware file system and/or application (such as mkfs initially).
>
> But yes, just pointing mkfs to the chardev should be doable with very
> little work.  We can point it to a regular file after all.

Note that I've avoided implementing read/write fops for dax devices
partly out of concern for not wanting to figure out shared-mmap vs
write coherence issues, but also because of a bet with Dave Hansen
that device-dax not grow features like what happened to hugetlbfs. So
it would seem mkfs would need to switch to mmap I/O, or bite the
bullet and implement read/write fops in the driver.
