Return-Path: <SRS0=UV4a=4J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 560A5C35669
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 23:26:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 279D62072C
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 23:26:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="TbwlC6/O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729100AbgBUX05 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Feb 2020 18:26:57 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:43994 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728656AbgBUX05 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Feb 2020 18:26:57 -0500
Received: by mail-oi1-f194.google.com with SMTP id p125so3291828oif.10
        for <linux-xfs@vger.kernel.org>; Fri, 21 Feb 2020 15:26:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0Qjb28JuFNd9gOL/WSqmB2kriWyv5u53CrYdkf6Wy1Y=;
        b=TbwlC6/OrsWHxLiHo7OXqsvf/ROPkSFjJO1MBYg1yRPYgiKYPSofcItFNCaMiRPqUg
         ekVKNLY9y1PeCxEUWaSDpZ27kasvrGCcmLmTlo26XYh0b/2TauVoNpEh5kth8ND8N5Ha
         WooPz1Nm1JTzfThjUvTHDj61iIKbc2/48vx9sJnbA3uOgV0hFKgJ1Nh32QSV9HnXuzR9
         bp5UUR33XZYEueszk5XSdy5dxhzlDPlnoyesaSyx7IXU5Iopv4iymYu2RXAjDyvIqgPT
         LJF3lNwhgVAvbffRoFHg+eiJEAG6brTEsvGZFVYpbMG15bUtHaA1J0W4U/s+7/aq3YiG
         GuBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0Qjb28JuFNd9gOL/WSqmB2kriWyv5u53CrYdkf6Wy1Y=;
        b=KpVt37MkvQWzN5N+sFWExQNos1Uqzo7hj/9xWBR6vpMLdhP5K3JfrZaTgv55swRJ1x
         22G6MVZcJjonxJcYTH4DqdmeQ7Y8alCcaLAyJtGBGJdAOGRMpkeSknR3a1MB/t5s7PUb
         FmGZgEt6PBJu0WGlUZYoXQJvdDhFlsnns03cXQO7tkhzAbGvS+S6fbpK/JEGkgDLW3AO
         okOS1WZ8YvHfx+MbdvozqtYPP0I+Avy9pNaT9pQxpYozHx3BvFawqHirXq2ZMT3rGYVA
         +5ouPI04yTPgxIDZQa24ALFzpDrImAgi17CrG+MWsgxcwjEnERWbtUqvAHBj2A46L5r9
         MUMg==
X-Gm-Message-State: APjAAAW1feglmoyclF0FS5uGSMSmbTYBK46JIe4QhFcoPIqBUU4wbQoG
        Zj35U8Wx3Iwau4itct+kCi8Ww9r4IS0sR1F+qbblTw==
X-Google-Smtp-Source: APXvYqy2rdUEqZ3R4aMaqDNTBL6bwDfhIb/6cZCDZKDfBRXKgwgp6CIVU2tXnuzooMcwkImhJrj6TbiItSwmVWFD3ug=
X-Received: by 2002:a05:6808:a83:: with SMTP id q3mr4285182oij.0.1582327616863;
 Fri, 21 Feb 2020 15:26:56 -0800 (PST)
MIME-Version: 1.0
References: <20200221004134.30599-1-ira.weiny@intel.com> <20200221004134.30599-8-ira.weiny@intel.com>
 <20200221174449.GB11378@lst.de> <20200221224419.GW10776@dread.disaster.area>
In-Reply-To: <20200221224419.GW10776@dread.disaster.area>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Fri, 21 Feb 2020 15:26:45 -0800
Message-ID: <CAPcyv4gueN4BsE94CGeO_rDad+MBs==5a+m7SKymJ_RywNCW3w@mail.gmail.com>
Subject: Re: [PATCH V4 07/13] fs: Add locking for a dynamic address space
 operations state
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@lst.de>, "Weiny, Ira" <ira.weiny@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        "Theodore Y. Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 21, 2020 at 2:44 PM Dave Chinner <david@fromorbit.com> wrote:
>
> On Fri, Feb 21, 2020 at 06:44:49PM +0100, Christoph Hellwig wrote:
> > On Thu, Feb 20, 2020 at 04:41:28PM -0800, ira.weiny@intel.com wrote:
> > > From: Ira Weiny <ira.weiny@intel.com>
> > >
> > > DAX requires special address space operations (aops).  Changing DAX
> > > state therefore requires changing those aops.
> > >
> > > However, many functions require aops to remain consistent through a deep
> > > call stack.
> > >
> > > Define a vfs level inode rwsem to protect aops throughout call stacks
> > > which require them.
> > >
> > > Finally, define calls to be used in subsequent patches when aops usage
> > > needs to be quiesced by the file system.
> >
> > I am very much against this.  There is a reason why we don't support
> > changes of ops vectors at runtime anywhere else, because it is
> > horribly complicated and impossible to get right.  IFF we ever want
> > to change the DAX vs non-DAX mode (which I'm still not sold on) the
> > right way is to just add a few simple conditionals and merge the
> > aops, which is much easier to reason about, and less costly in overall
> > overhead.
>
> *cough*
>
> That's exactly what the original code did. And it was broken
> because page faults call multiple aops that are dependent on the
> result of the previous aop calls setting up the state correctly for
> the latter calls. And when S_DAX changes between those calls, shit
> breaks.
>
> It's exactly the same problem as switching aops between two
> dependent aops method calls - we don't solve anything by merging
> aops and checking IS_DAX in each method because the race condition
> is still there.
>
> /me throws his hands in the air and walks away

Please come back, because I think it's also clear that the "we don't
support changes of ops vectors at runtime" assertion is already being
violated by ext4 [1]. So that leaves "IFF we ever want to change the
dax vs non-dax mode" which I thought was already consensus given the
lingering hopes about having some future where the kernel is able to
dynamically optimize for dax vs non-dax based on memory media
performance characteristics. I thought the only thing missing from the
conclusion of the last conversation [2] was the "physical" vs
"effective" split that we identified at LSF'19 [3]. Christoph, that
split allows for for your concern about application intent to be
considered / overridden by kernel policy, and it allows for
communication of the effective state which applications need for
resource planning [4] independent of MAP_SYNC and other dax semantics.

The status quo of globally enabling dax for all files is empirically
the wrong choice for page-cache friendly workloads running on
slower-than-DRAM pmem media.

I am struggling to see how we address the above items without first
having a dynamic / less than global-filesystem scope facility to
control dax.

[1]: https://lore.kernel.org/linux-fsdevel/20191108131238.GK20863@quack2.suse.cz
[2]: https://lore.kernel.org/linux-fsdevel/20170927064001.GA27601@infradead.org
[3]: https://lwn.net/Articles/787973/
[4]: https://lwn.net/Articles/787233/
