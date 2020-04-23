Return-Path: <SRS0=GxFA=6H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E1A4C2BA19
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Apr 2020 06:46:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 653B1214AF
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Apr 2020 06:46:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bb/E5nXa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726169AbgDWGqy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Apr 2020 02:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726032AbgDWGqy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Apr 2020 02:46:54 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87DB3C03C1AB
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 23:46:54 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id z2so5237939iol.11
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 23:46:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bEB8xIvgn2u7DgP/VErQEEwsLZjyBiB7wq8rLX3DthQ=;
        b=Bb/E5nXaSGTK2x/8+r+9k/gYcziLp2NNRuyJLuz5o3rtPbukB8SZNbc+AMEDOnyKU+
         el0Tuxo+OQSfaHKms91v575ylP98mJ3pgy5tga/MzyMlPpIxwGyew3HX0XGl6VGO8ZhU
         FdYXCKEM9duOjHA6OlUwgH/SKF7NI1u58fHQYMsg+PCCUs7/lJ+aFRSwGm/a0p6ZTCRF
         pYQRIhQ61yPn9TjGpHzY353aBX8WRV4Vwrd8C6tvV1qFkgp//lmjt/whLFuSSrY9w3aj
         6cbSiuDblIxL3cNL7mJ2jWOvNiwhXo1DB+GvDp2o5MFOW6jUqvATqlVEAuK2cYzrUf9e
         ERew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bEB8xIvgn2u7DgP/VErQEEwsLZjyBiB7wq8rLX3DthQ=;
        b=gNmWARaV6zCgTo1VTgQ8CM0SHXUDtqHUxulE38pQ/5Kqh0BrL1MYGZP9FVlJa21ldr
         Wt/9aXcZg4nL83SFefWSb9ubuqxNJ3JsrWVBNGsVcrtezjX6OjAk4NQ2ycKpzch3OQsz
         NlL9v0etYi6EDlD5UxxzsyX7H+B1hk73XibkbihbhkNcv6T9eks/VqTt8Y0lRD8GWtJo
         39fTCUTZKbpZw7Ap704QpaJig/8CYoWLPcxqGfat7XnkSiJ8BWyKGCFl7B2X2kjwyMVL
         BVD47GsufKV+yq3kIAEksMHAjA/+N4wJF4WbyRwBe9YcaZVuXdmSArokMunfB4uwI5PQ
         B3mg==
X-Gm-Message-State: AGi0PubOjMaTw1eatK0cjTCjMIQHXt6MTYPpMlRJrVDiSJMGUsGvk4Go
        JbdCdPc6NgS2tF54oAmROX+aXtKmE73JOF90LRXp5Dq9
X-Google-Smtp-Source: APiQypIG7581FvDbL81ymWOscgiImuo9KiRmzBXIJOzIW2+M0T5Mf4aRJt4PpHOzoImSETdaiEGZ3wbjwlOR99aUSx0=
X-Received: by 2002:a02:c9cb:: with SMTP id c11mr1811865jap.93.1587624413768;
 Wed, 22 Apr 2020 23:46:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200422225851.GG6742@magnolia> <20200422230504.GI6742@magnolia>
In-Reply-To: <20200422230504.GI6742@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 23 Apr 2020 09:46:42 +0300
Message-ID: <CAOQ4uxhL+OnmbnLPQoSGkQczCJ5jWMipT20oi3uwm9Hk7xmNvg@mail.gmail.com>
Subject: Re: [XFS SUMMIT] Deferred inode inactivation and nonblocking inode reclaim
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>, Chris Mason <clm@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 23, 2020 at 2:05 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> Heh, only after I sent this did I think about tagging the subject line
> and sending links to git branches when applicable.
>
> On Wed, Apr 22, 2020 at 03:58:51PM -0700, Darrick J. Wong wrote:
> > Hi everyone,
> >
> > Here's a jumping-off point for a discussion about my patchset that
> > implements deferred inode inactivation and Dave's patchset that moves
> > inode buffer flushing out of reclaim.
> >
> > The inactivation series moves the transactional updates that happen
>
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=deferred-inactivation
>
> > after a file loses its last reference (truncating attr/data forks,
> > freeing the inode) out of drop_inode and reclaim by moving all that work
> > to an intermediate workqueue.  This all can be done internally to XFS.
> >
> > The reclaim series (Dave) removes inode flushing from reclaim, which
>
> https://lore.kernel.org/linux-xfs/20191031234618.15403-1-david@fromorbit.com/
>
> --D
>
> > means that xfs stop holding up memory reclaim on IO.  It also contains a
> > fair amount of surgery to the memory shrinker code, which is an added
> > impediment to getting this series reviewed and upstream.
> >

+CC: Chris Mason

And here is a link to one of the famous bug reports:
https://lore.kernel.org/linux-xfs/06aade22-b29e-f55e-7f00-39154f220aa6@fb.com/
which also includes a reference to Chris's simoop reproducer.

How about bringing in some FB engineers to the task force to help with
reviewing the memory shrinker changes and with testing?
I believe it is in the best interest of the wider filesystem community to
expedite development of this solution.

Thanks,
Amir.
