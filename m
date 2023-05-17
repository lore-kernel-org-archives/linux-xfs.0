Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 051A3C77B75
	for <linux-xfs@archiver.kernel.org>; Wed, 17 May 2023 01:48:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231651AbjEQBsB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 May 2023 21:48:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231222AbjEQBsA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 May 2023 21:48:00 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A66EA0
        for <linux-xfs@vger.kernel.org>; Tue, 16 May 2023 18:47:59 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1ab1b79d3a7so2441755ad.3
        for <linux-xfs@vger.kernel.org>; Tue, 16 May 2023 18:47:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1684288079; x=1686880079;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Z4yMS0ebf3GLTctl7+6HdG4IlwS0Js4+UsqyPX2cdEM=;
        b=iOZlLG+fG30uelL0e4RPkFXrXI/6YivsBGncrB8wnHHcJm/Oyg4MkD+J1vFCDc6vQ+
         eihmjFkZjjKqu6jf5v+JIF/0DXrpMOT01XymwTqplJlzGN1JZOpv2VTeMW1hNI/8louZ
         8NmLVJ9d878D/V2QjeCqpllTumxjXdrN6hCORMAdHi+jQVFNur3xCBZWOMoTCabMfnHi
         3SNJE8qljqBbDp6PpDYLwnSWmdoyLpL0nG+DCqe3ZJ+r9sJQTsG+oEqY/7mzdze/lgJf
         8djb0T+6PuDTGU16ZCLFDXCG3JAzRzFg75wFJn+vTyr5CdY62pV6T1f+d5aSYxyfSCZs
         NiUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684288079; x=1686880079;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z4yMS0ebf3GLTctl7+6HdG4IlwS0Js4+UsqyPX2cdEM=;
        b=IzVcH9cj0qNlTbzqApul3qR0yK31+Fyl9lHwPH7Sgbs2f/BMRWvJiTKaN51E20UC8p
         qILW1aMLvW94sAbmyV3oyaFBxax16a1bopj2lU6yPOR1qsMkJ9g3NxkmLgVM9kMkEDDU
         c93eUlROfcNosoK9p2ONLE+7KoUiwb3r7MXunkCS642SYmtUxTu/+lT5TyKtzu5fK5JD
         QfE/Ud7TtenYXbRLBOU65ctroUKUQ8BXpzcI65R0xehrgw0FGYBoWP771kQyVMTpf2xd
         WM276GU6s9OPkAvA68pYopNSdlDk8vKjQM4F6u0YBLEQGqtL34Rpd0nBRrUIggc/ibMV
         5unA==
X-Gm-Message-State: AC+VfDz/ZBbeGpdf6OUTU1YiLQY5pKHz64LVvvh1hc7ZEilge6DK6fN+
        hMP8VZdQvFbSoSNufGz55cZc4g==
X-Google-Smtp-Source: ACHHUZ7MYKdyf4mheNP85DYDG2X3bHkZ5O1gc9taNY98jJWVtigj5aQLOcHJOpOCTnluhso1I0nVmg==
X-Received: by 2002:a17:902:ce8a:b0:1ad:ddf0:1311 with SMTP id f10-20020a170902ce8a00b001adddf01311mr24309178plg.50.1684288078824;
        Tue, 16 May 2023 18:47:58 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-188.pa.nsw.optusnet.com.au. [49.179.0.188])
        by smtp.gmail.com with ESMTPSA id c23-20020a170902b69700b001ae0b373382sm6174697pls.198.2023.05.16.18.47.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 18:47:58 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1pz6Gh-000NIx-2k;
        Wed, 17 May 2023 11:47:55 +1000
Date:   Wed, 17 May 2023 11:47:55 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: fix AGF vs inode cluster buffer deadlock
Message-ID: <ZGQySyiTJZzmB5N3@dread.disaster.area>
References: <20230517000449.3997582-1-david@fromorbit.com>
 <20230517000449.3997582-5-david@fromorbit.com>
 <20230517012629.GP858799@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230517012629.GP858799@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 16, 2023 at 06:26:29PM -0700, Darrick J. Wong wrote:
> On Wed, May 17, 2023 at 10:04:49AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Lock order in XFS is AGI -> AGF, hence for operations involving
> > inode unlinked list operations we always lock the AGI first. Inode
> > unlinked list operations operate on the inode cluster buffer,
> > so the lock order there is AGI -> inode cluster buffer.
> > 
> > For O_TMPFILE operations, this now means the lock order set down in
> > xfs_rename and xfs_link is AGI -> inode cluster buffer -> AGF as the
> > unlinked ops are done before the directory modifications that may
> > allocate space and lock the AGF.
> > 
> > Unfortunately, we also now lock the inode cluster buffer when
> > logging an inode so that we can attach the inode to the cluster
> > buffer and pin it in memory. This creates a lock order of AGF ->
> > inode cluster buffer in directory operations as we have to log the
> > inode after we've allocated new space for it.
> > 
> > This creates a lock inversion between the AGF and the inode cluster
> > buffer. Because the inode cluster buffer is shared across multiple
> > inodes, the inversion is not specific to individual inodes but can
> > occur when inodes in the same cluster buffer are accessed in
> > different orders.
> > 
> > To fix this we need move all the inode log item cluster buffer
> > interactions to the end of the current transaction. Unfortunately,
> > xfs_trans_log_inode() calls are littered throughout the transactions
> > with no thought to ordering against other items or locking. This
> > makes it difficult to do anything that involves changing the call
> > sites of xfs_trans_log_inode() to change locking orders.
> > 
> > However, we do now have a mechanism that allows is to postpone dirty
> > item processing to just before we commit the transaction: the
> > ->iop_precommit method. This will be called after all the
> > modifications are done and high level objects like AGI and AGF
> > buffers have been locked and modified, thereby providing a mechanism
> > that guarantees we don't lock the inode cluster buffer before those
> > high level objects are locked.
> > 
> > This change is largely moving the guts of xfs_trans_log_inode() to
> > xfs_inode_item_precommit() and providing an extra flag context in
> > the inode log item to track the dirty state of the inode in the
> > current transaction. This also means we do a lot less repeated work
> > in xfs_trans_log_inode() by only doing it once per transaction when
> > all the work is done.
> 
> Aha, and that's why you moved all the "opportunistically tweak inode
> metadata while we're already logging it" bits to the precommit hook.

Yes. It didn't make sense to move just some of the "only need to do
once per transaction while the inode is locked" stuff from one place
to the other. I figured it's better to have it all in one place and
do it all just once...

....
> > -	/*
> > -	 * Always OR in the bits from the ili_last_fields field.  This is to
> > -	 * coordinate with the xfs_iflush() and xfs_buf_inode_iodone() routines
> > -	 * in the eventual clearing of the ili_fields bits.  See the big comment
> > -	 * in xfs_iflush() for an explanation of this coordination mechanism.
> > -	 */
> > -	iip->ili_fields |= (flags | iip->ili_last_fields | iversion_flags);
> > -	spin_unlock(&iip->ili_lock);
> > +	iip->ili_dirty_flags |= flags;
> > +	trace_printk("ino 0x%llx, flags 0x%x, dflags 0x%x",
> > +		ip->i_ino, flags, iip->ili_dirty_flags);
> 
> Urk, leftover debugging info?

Yes, I just realised I'd left it there when writing the last email.
Ignoring those two trace-printk() statements, the rest of the code
should be ok to review...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
