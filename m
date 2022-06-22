Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2856ACCA47D
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jun 2022 17:10:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347022AbiFVRKT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Jun 2022 13:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377178AbiFVRKG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Jun 2022 13:10:06 -0400
Received: from mail-vk1-xa33.google.com (mail-vk1-xa33.google.com [IPv6:2607:f8b0:4864:20::a33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 253DE3FDA3;
        Wed, 22 Jun 2022 10:09:32 -0700 (PDT)
Received: by mail-vk1-xa33.google.com with SMTP id 15so4983512vko.13;
        Wed, 22 Jun 2022 10:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5+MlBiSJnRmQo3qNED63eGdMk3fiiwXt1uzWfNTV6k4=;
        b=JyumZg9sWEcqQDwaKpMUYnsthohVzKstGhofsBIpVBjrLrz0VUyMVd6oiP7a0XWwyb
         /6Pw815Q7FyvzVMcNGfWQEKLqHfLsC1mhwQQp34AA9s9QAbpUV9UpQ2DY1BHB9Afpi2I
         mxlW0hmDnCEFKq1nu7BhpgBiLpi5bfBRgFF7QZkwpWo+3KePbXQjStu+6yxRMzQNSYik
         3kujJnQMrW2HhOLqHlSf5xWkqPUADNRokilHDPS2oJvOu7SPWxanKQJSJ1wMHHzwUpfI
         uruzWvQlzylt2Pqcw/i8QuXHORR6w8dOu6O/VK3bCDnlUko0YEQFuYUP56PuQOefF70B
         k+Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5+MlBiSJnRmQo3qNED63eGdMk3fiiwXt1uzWfNTV6k4=;
        b=LCvRKMJuA7pYqfMMKcjtjErVZsZkpATvR7W93sVS6UaRHAwBJIA/1R+xPm9cJiIN9L
         bgSdhwvtWIFbg89okY1X6K2JfmMJfr7J8aRwq9RzYxhmqvZEMNysGMnXgF78AesAobTP
         izdmfUeSFwjwYRm6BQOK27V+miWI/VyhWRM2nbQRkWqprOKKDkDRjNWTqTcn5uJXMqlz
         gd+yKfVCCHFxMW4o/rcIzmwM+IKsJ2Bqz207I0vZntTxUfa2rtFs9jHCxaHJ71AnkneM
         iUS0RssIy+rbRCN0QVWC5Zn9wzgDUd3aZhSrGOp/MuuBAprnFJ+wDRDrsi8s/29wKCY7
         8KZA==
X-Gm-Message-State: AJIora+pyOyBAvVXrpYymBFAFTbS28Fp/ebJQVEYDRl6vZdZtnpr3OVX
        XgotpoWcHQlyORvkCyOpx2de9VMsjtHHJOb+bEY=
X-Google-Smtp-Source: AGRyM1vGzbJb6BAnsHu/myrKdHBfelQ4om1p0ZtgmvFHpBrFfoTIeNcrZ6lwKqvqB+DnNqVrRdG2Hs9npTYng1xdTYs=
X-Received: by 2002:a05:6122:2205:b0:321:230a:53e1 with SMTP id
 bb5-20020a056122220500b00321230a53e1mr15047689vkb.25.1655917771169; Wed, 22
 Jun 2022 10:09:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220617100641.1653164-1-amir73il@gmail.com> <20220617100641.1653164-8-amir73il@gmail.com>
 <YrNHQ9IAIceAx/wU@magnolia>
In-Reply-To: <YrNHQ9IAIceAx/wU@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 22 Jun 2022 20:09:19 +0300
Message-ID: <CAOQ4uxjj=12X7tZr6tgtaWVVtw9T7h7m6POXFg51J3s89b=42g@mail.gmail.com>
Subject: Re: [PATCH 5.10 CANDIDATE 07/11] xfs: xfs_log_force_lsn isn't passed
 a LSN
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>,
        Allison Henderson <allison.henderson@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 22, 2022 at 7:45 PM Darrick J. Wong <djwong@kernel.org> wrote:
>
> On Fri, Jun 17, 2022 at 01:06:37PM +0300, Amir Goldstein wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> >
> > commit 5f9b4b0de8dc2fb8eb655463b438001c111570fe upstream.
> >
> > [backported from CIL scalability series for dependency]
> >
> > In doing an investigation into AIL push stalls, I was looking at the
> > log force code to see if an async CIL push could be done instead.
> > This lead me to xfs_log_force_lsn() and looking at how it works.
> >
> > xfs_log_force_lsn() is only called from inode synchronisation
> > contexts such as fsync(), and it takes the ip->i_itemp->ili_last_lsn
> > value as the LSN to sync the log to. This gets passed to
> > xlog_cil_force_lsn() via xfs_log_force_lsn() to flush the CIL to the
> > journal, and then used by xfs_log_force_lsn() to flush the iclogs to
> > the journal.
> >
> > The problem is that ip->i_itemp->ili_last_lsn does not store a
> > log sequence number. What it stores is passed to it from the
> > ->iop_committing method, which is called by xfs_log_commit_cil().
> > The value this passes to the iop_committing method is the CIL
> > context sequence number that the item was committed to.
> >
> > As it turns out, xlog_cil_force_lsn() converts the sequence to an
> > actual commit LSN for the related context and returns that to
> > xfs_log_force_lsn(). xfs_log_force_lsn() overwrites it's "lsn"
> > variable that contained a sequence with an actual LSN and then uses
> > that to sync the iclogs.
> >
> > This caused me some confusion for a while, even though I originally
> > wrote all this code a decade ago. ->iop_committing is only used by
> > a couple of log item types, and only inode items use the sequence
> > number it is passed.
> >
> > Let's clean up the API, CIL structures and inode log item to call it
> > a sequence number, and make it clear that the high level code is
> > using CIL sequence numbers and not on-disk LSNs for integrity
> > synchronisation purposes.
> >
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Reviewed-by: Brian Foster <bfoster@redhat.com>
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>
> This /looks/ right, but given the invasiveness of this patch, I'm
> curious how much you had to change from upstream to get here?

IIRC, it wasn't so bad, there may have been a lot of conflicts, but
most of them were resolved by doing search&replace on the 5.10
code and it was also pretty clean and the compiler will catch errors
if something that needed to be replaced wasn't in a conflicting hunk.

>
> Also, did you look at the other log fixes in 5.14 and decide none of
> them were needed/worth the risk, or is that merely pending for the next
> round?

There are other log fixes pending, which look like they fix scary bugs.
I just promoted this one to accommodate the joint 5.10/5.15 series.
Here are the fixes pending in xfs-5.10.y-4:

* 6e0d4f5c1a0f - (xfs-5.10.y-4) xfs: Enforce attr3 buffer recovery order
* 610edc215903 - xfs: logging the on disk inode LSN can make it go backwards
* da28279083ee - xfs: reset child dir '..' entry when unlinking child
* 35efb2d1e3a7 - xfs: remove dead stale buf unpin handling code
* fa7ae3691e6f - xfs: hold buffer across unpin and potential shutdown processing
* 0f6d6b3e8da3 - xfs: force the log offline when log intent item recovery fails
* 1883c074e795 - xfs: fix log intent recovery ENOSPC shutdowns when
inactivating inodes

I would be happy to get to post these.
If you have time to ACK the 5.13 selection [1], I will start testing
xfs-5.10.y-4.

Thanks!
Amir.

[1] https://lore.kernel.org/linux-xfs/20220606160537.689915-1-amir73il@gmail.com/
