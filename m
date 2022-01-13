Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AAD4C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Jan 2022 19:59:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbiAMT7F (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Jan 2022 14:59:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:32718 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229704AbiAMT7F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jan 2022 14:59:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642103944;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0arVVtKREhyhk8bz+/dLXrN+7X7byYYzxCy/Ql1V6dc=;
        b=ZuQ3wGezmFiuZPlnju9ifIfjxsXKAV3gpMEBjShRwU3X+9ObF7xcb/nkPG8trVt10llJJ/
        76KpaLXEIBQmNuVqIGTLuNqAeCVLOq5fCXYM8XnqC+I9bPozKwkbVopq24kzja4cIeRlpD
        ekvjN5X6WJvOGJa1lvaMIsBY1G3IlN4=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-131-0MbtiIrBO5KAJKD0ryfWdQ-1; Thu, 13 Jan 2022 14:59:03 -0500
X-MC-Unique: 0MbtiIrBO5KAJKD0ryfWdQ-1
Received: by mail-qk1-f200.google.com with SMTP id y21-20020a05620a09d500b004776ac05419so5488231qky.6
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jan 2022 11:59:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0arVVtKREhyhk8bz+/dLXrN+7X7byYYzxCy/Ql1V6dc=;
        b=dzQ5b+T9BjfRTizD0NN/gN5nC5MdPomI93Wjfnu3Oxrwzb973CdDZYE94W+sK/L6j5
         4k1fc7WcxRPeRXPGoCoa1RvgdToVzlQ/5qmkRNgpePB9juSzRBPefAKq7iRuOc/d6b0U
         yaqZkoyNpmcK/wI0Lbkm9e9GNGYvNB6vO1PGRy0v8va/4gdlpDgVmVL0f4F5i4EkiqoP
         anRfKq5fk2QHw6B3cXZn0ckbjcDd0/QUuAvv6TZUAthaMCkiH3SYK7bG/K/GG6s/JVR6
         d8AXbiwVwcx2b7CPqjBYJ7mJjB39aECd/xdTocfLAPAkozyqAJl3t4yYCwLa+2SzPmHE
         LEqQ==
X-Gm-Message-State: AOAM530ERVONWLP3c8hHNoI/A1dsNM9reapbK89WCEJqAIXN/18kn4q4
        OZcPI/kiU6Gp81rG3PLUehfgtazxE4ohgbbdqimriLLyyXSW0AN9j+Y/Wr1bwI6uwmxHN/My/I2
        AlaKiLNjpbvGJTHtKNmQw
X-Received: by 2002:ad4:5cef:: with SMTP id iv15mr5524402qvb.82.1642103942643;
        Thu, 13 Jan 2022 11:59:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwS8YsZhSq8otep7lQCJLkMODMiKt4uanOE+Yc26df7JlgnxTlJx/R0QO4wK0HNdiaPZ9IJiw==
X-Received: by 2002:ad4:5cef:: with SMTP id iv15mr5524390qvb.82.1642103942403;
        Thu, 13 Jan 2022 11:59:02 -0800 (PST)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id t11sm2231656qkm.77.2022.01.13.11.59.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 11:59:02 -0800 (PST)
Date:   Thu, 13 Jan 2022 14:58:59 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: run blockgc on freeze to avoid iget stalls
 after reclaim
Message-ID: <YeCEgzMtF7KMLKgh@bfoster>
References: <20220113133701.629593-1-bfoster@redhat.com>
 <20220113133701.629593-3-bfoster@redhat.com>
 <20220113171347.GD19198@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220113171347.GD19198@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 13, 2022 at 09:13:47AM -0800, Darrick J. Wong wrote:
> On Thu, Jan 13, 2022 at 08:37:01AM -0500, Brian Foster wrote:
> > We've had reports on distro (pre-deferred inactivation) kernels that
> > inode reclaim (i.e. via drop_caches) can deadlock on the s_umount
> > lock when invoked on a frozen XFS fs. This occurs because
> > drop_caches acquires the lock
> 
> Eww, I hadn't even noticed drop_caches as a way in to a s_umount
> deadlock.  Good catch!
> 
> > and then blocks in xfs_inactive() on
> > transaction alloc for an inode that requires an eofb trim. unfreeze
> > then blocks on the same lock and the fs is deadlocked.
> > 
> > With deferred inactivation, the deadlock problem is no longer
> > present because ->destroy_inode() no longer blocks whether the fs is
> > frozen or not. There is still unfortunate behavior in that lookups
> > of a pending inactive inode spin loop waiting for the pending
> > inactive state to clear, which won't happen until the fs is
> > unfrozen. This was always possible to some degree, but is
> > potentially amplified by the fact that reclaim no longer blocks on
> > the first inode that requires inactivation work. Instead, we
> > populate the inactivation queues indefinitely. The side effect can
> > be observed easily by invoking drop_caches on a frozen fs previously
> > populated with eofb and/or cowblocks inodes and then running
> > anything that relies on inode lookup (i.e., ls).
> > 
> > To mitigate this behavior, invoke internal blockgc reclaim during
> > the freeze sequence to guarantee that inode eviction doesn't lead to
> > this state due to eofb or cowblocks inodes. This is similar to
> > current behavior on read-only remount. Since the deadlock issue was
> > present for such a long time, also document the subtle
> > ->destroy_inode() constraint to avoid unintentional reintroduction
> > of the deadlock problem in the future.
> 
> Yay for improved documentation. :)
> 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/xfs_super.c | 19 +++++++++++++++++--
> >  1 file changed, 17 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index c7ac486ca5d3..1d0f87e47fa4 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -623,8 +623,13 @@ xfs_fs_alloc_inode(
> >  }
> >  
> >  /*
> > - * Now that the generic code is guaranteed not to be accessing
> > - * the linux inode, we can inactivate and reclaim the inode.
> > + * Now that the generic code is guaranteed not to be accessing the inode, we can
> > + * inactivate and reclaim it.
> > + *
> > + * NOTE: ->destroy_inode() can be called (with ->s_umount held) while the
> > + * filesystem is frozen. Therefore it is generally unsafe to attempt transaction
> > + * allocation in this context. A transaction alloc that blocks on frozen state
> > + * from a context with ->s_umount held will deadlock with unfreeze.
> >   */
> >  STATIC void
> >  xfs_fs_destroy_inode(
> > @@ -764,6 +769,16 @@ xfs_fs_sync_fs(
> >  	 * when the state is either SB_FREEZE_FS or SB_FREEZE_COMPLETE.
> >  	 */
> >  	if (sb->s_writers.frozen == SB_FREEZE_PAGEFAULT) {
> > +		struct xfs_icwalk	icw = {0};
> > +
> > +		/*
> > +		 * Clear out eofb and cowblocks inodes so eviction while frozen
> > +		 * doesn't leave them sitting in the inactivation queue where
> > +		 * they cannot be processed.
> 
> Would you mind adding an explicit link in the comment between needing to
> get /all/ the inodes and _FLAG_SYNC?
> 
> "We must process every cached inode, so this requires a synchronous
> cache scan."
> 

I changed it to the following to hopefully make it more descriptive
without making it longer:

                /*
                 * Run a sync blockgc scan to reclaim all eof and cow blocks so
                 * eviction while frozen doesn't leave inodes sitting in the
                 * inactivation queue where they cannot be processed.
                 */

> > +		 */
> > +		icw.icw_flags = XFS_ICWALK_FLAG_SYNC;
> > +		xfs_blockgc_free_space(mp, &icw);
> 
> This needs to check the return value, right?
> 

What do you want to do with the return value? It looks to me that
nothing actually checks the return value of ->sync_fs(). freeze_super()
calls sync_filesystem() and that doesn't, at least. That suggests the fs
is going to freeze regardless and so we probably don't want to bail out
of here early, at least. We could just warn on error or something and
then hand it up the stack anyways.. Hm?

Brian

> --D
> 
> > +
> >  		xfs_inodegc_stop(mp);
> >  		xfs_blockgc_stop(mp);
> >  	}
> > -- 
> > 2.31.1
> > 
> 

