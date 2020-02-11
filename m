Return-Path: <SRS0=3qtu=37=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3093C35242
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Feb 2020 20:59:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E6B120842
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Feb 2020 20:59:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="I1xwH6By"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731931AbgBKU7w (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Feb 2020 15:59:52 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:39495 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728624AbgBKU7w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Feb 2020 15:59:52 -0500
Received: by mail-oi1-f195.google.com with SMTP id z2so14209380oih.6
        for <linux-xfs@vger.kernel.org>; Tue, 11 Feb 2020 12:59:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=extxsRRjmkIJZEh/sTfq/VSUaht64zLviDFgNerAR0E=;
        b=I1xwH6Byix/62gQ54cfQkAhK3Jz6DZUnPEusCbQQ20skEH7t7q1ersOxFM2h8eTjFq
         W7bs4biU+p5p2rBb8nacmQ+AyuU973vMUnU/taHRlqpu4s2LfDLV9nh68R67/9IHN54V
         Zh1uALOWVcrlvsNNTZj0JZWfKbx+OG02U4MDSQGMPZxKTRuUDEWL3k7FpR4YqEPKNedQ
         mbTRld4FShJFNSCJLfhgOHJtcCGpyJIJ05CACfqm36E8Iq18xxlsLL5OWXDS1sXJ/AEq
         eWX5eMKrKADz9NYuNYEImIqQzMkm5dSAeKK6nzyOMYNcJHbAsQb7Ua1pJrY91i0sa1G7
         ooQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=extxsRRjmkIJZEh/sTfq/VSUaht64zLviDFgNerAR0E=;
        b=uZJK+qRBl5kUERo6vB1hy4dyhNc0nBBnF59FZA/mMPzqzFEi5CUhgw17b/8x76di5O
         Rn6tWbAdZ0JD/+jbAFqsUitumSjNzGo8oBvWlQqJn21ND7VTTF34ifOxQbKrnYGgP3Ui
         3buuQXfeTwYG5ysa+CI1/JQIzF5PkFQvEGfCasqJYv3r3IaSnG1+OqQ6XewRRfEOkaVK
         281FV3joF3kqwYThHpoNZM5LogpEGPiqBqM+QrbVMedlrYEsb+wvFr3gDKeJqTjRcmGz
         URhQUjIkdeQ7V0HuM/3+XpTDqE/Gsa+tn3qTrVdQUW/G1BfU97CMJ1RHounQy9W2M7yS
         CXLA==
X-Gm-Message-State: APjAAAUKkhQweQgS0b/oVn5h1G0cP2AbSzVZYSLt8XvPXm1Nq9x57vl8
        N7g5DypFUbf1xrDz3c1L0pDwWKrD1tiFqzus4pUEJQ==
X-Google-Smtp-Source: APXvYqy2e6QuQme8tks+nFn6MGTK47SXBGcqgqEabGAFW6zHHoWaB1wrKQLyHPWb+JU7T/jGznd8vWOuaKeaLDE7Ygk=
X-Received: by 2002:aca:3f54:: with SMTP id m81mr3957419oia.73.1581454791852;
 Tue, 11 Feb 2020 12:59:51 -0800 (PST)
MIME-Version: 1.0
References: <20200208193445.27421-1-ira.weiny@intel.com> <20200208193445.27421-8-ira.weiny@intel.com>
 <20200211080035.GI10776@dread.disaster.area> <20200211201430.GE12866@iweiny-DESK2.sc.intel.com>
In-Reply-To: <20200211201430.GE12866@iweiny-DESK2.sc.intel.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Tue, 11 Feb 2020 12:59:40 -0800
Message-ID: <CAPcyv4hLTg+1dx2bE2S7sLRK17EP_gT5kutwhyUfVB7Ad8khgw@mail.gmail.com>
Subject: Re: [PATCH v3 07/12] fs: Add locking for a dynamic DAX state
To:     Ira Weiny <ira.weiny@intel.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        "Theodore Y. Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 11, 2020 at 12:14 PM Ira Weiny <ira.weiny@intel.com> wrote:
>
> On Tue, Feb 11, 2020 at 07:00:35PM +1100, Dave Chinner wrote:
> > On Sat, Feb 08, 2020 at 11:34:40AM -0800, ira.weiny@intel.com wrote:
> > > From: Ira Weiny <ira.weiny@intel.com>
> > >
> > > DAX requires special address space operations but many other functions
> > > check the IS_DAX() state.
> > >
> > > While DAX is a property of the inode we perfer a lock at the super block
> > > level because of the overhead of a rwsem within the inode.
> > >
> > > Define a vfs per superblock percpu rs semaphore to lock the DAX state
> >
> > ????
>
> oops...  I must have forgotten to update the commit message when I did the
> global RW sem.  I implemented the per-SB, percpu rwsem first but it was
> suggested that the percpu nature of the lock combined with the anticipated
> infrequent use of the write side made using a global easier.
>
> But before I proceed on V4 I'd like to get consensus on which of the 2 locking
> models to go with.
>
>         1) percpu per superblock lock
>         2) per inode rwsem
>
> Depending on my mood I can convince myself of both being performant but the
> percpu is very attractive because I don't anticipate many changes of state
> during run time.  OTOH concurrent threads accessing the same file at run time
> may also be low so there is likely to be little read contention across CPU's on
> the per-inode lock?
>
> Opinions?

As one who thought a global lock would be reasonable relative to how
often dax address_space_operations are swapped out (on the order of
taking cgroup_threadgroup_rwsem for write), I think a per-superblock
lock is also an ok starting point. We can always go to finer grained
locking in the future if we see evidence that the benefits of percpu
are lost to stopping the world at the superblock level.
