Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D4DCC00A8F
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Oct 2023 00:44:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbjJXAoV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Oct 2023 20:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbjJXAoU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Oct 2023 20:44:20 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83BD0A6
        for <linux-xfs@vger.kernel.org>; Mon, 23 Oct 2023 17:44:18 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-6be1bc5aa1cso3801781b3a.3
        for <linux-xfs@vger.kernel.org>; Mon, 23 Oct 2023 17:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698108258; x=1698713058; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=F0U5pGPQ62oscUUbIrM8NGIAF+5fGkmeROTXCHiYwgw=;
        b=fo5gmFEZVbeFJKUGmJHYSIB+aQACI3uIqpzo8xAK36ri7sJZK2cmPbMnsc9GLdYS2V
         mQ1qZFgLEvzUSA6rolpBhAAVjZ8j+qvgM6IO0jPeICbfz2S+F2BLMYt3wUn+ihO7JF89
         1Td7A24cWFQE7l+3HF3zDwI6ruOTHdD2EpdGIkIv/ubpSkKR6KzTSp1odtVg58j+Qk6J
         f5pYOHZTow2wZyVZk0fQ97Gs/FDuHN/GzuR444NtbgfQNd7MKVAEfvjG+WulLfd2R4Xp
         owiomW7PQX5dyjVX7RkxQCNzw+aUEvl8WsezLYSzxbswpVeB3lUfAramRU57OPrywrZ4
         wMEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698108258; x=1698713058;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F0U5pGPQ62oscUUbIrM8NGIAF+5fGkmeROTXCHiYwgw=;
        b=tiWKwB0iSuQZaoz1sD4jqcRAWtVS6tQzkM9Plsn6X/ODbR58QTqUw6lW6KefA3O7/n
         6R96ELLZ9ya5G5IOjdry7HMmBAtJRkUoo+hNZxgaCNOKpKwt25hKelta3nYLxEGREyy9
         AQr+QkDkWv/Hnwl33/2uzVm30aC1b13TizI9La4m0A4OOTwqBQPeynhexPauJRedeV4g
         1N6q9QTJ+E3wB2j9qvnAxImOKp6b2cjZ4fGf69qfdPyH+Iez9tcSRzBJIhYSpwJzXUoK
         XzBCO5qE00WS9njUBh0dwFQR6wc2ItO7lLOq9SxkY9ik4C8w9rYy58WZq0fWwxryf2GZ
         ZUrw==
X-Gm-Message-State: AOJu0Yz1tcT0vTL0PaaSj6DaX+Hl8FX9wui3cCXiG+AZhaKxbjW7mQOU
        VHjerAS3iEoXNLyByDzb8E43y2zdEpk=
X-Google-Smtp-Source: AGHT+IG94ybaaQQvecmRcJYa2uO0J12doF6ikEh9ASwYg8mIxOK8VJWvFM4YIpfxn6zKgEHiRm+98Q==
X-Received: by 2002:a05:6a00:b4f:b0:6be:2081:f66d with SMTP id p15-20020a056a000b4f00b006be2081f66dmr12790443pfo.27.1698108257695;
        Mon, 23 Oct 2023 17:44:17 -0700 (PDT)
Received: from google.com ([2601:647:4701:18d0:f2d8:27c4:da5a:4e3d])
        by smtp.gmail.com with ESMTPSA id h185-20020a6253c2000000b00692cb1224casm7044285pfb.183.2023.10.23.17.44.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 17:44:17 -0700 (PDT)
Date:   Mon, 23 Oct 2023 17:44:14 -0700
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: up(ic_sema) if flushing data device fails
Message-ID: <ZTcTXnVVTX747zqP@google.com>
References: <20231023181410.844000-1-leah.rumancik@gmail.com>
 <20231023212221.GV3195650@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231023212221.GV3195650@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 23, 2023 at 02:22:21PM -0700, Darrick J. Wong wrote:
> On Mon, Oct 23, 2023 at 11:14:10AM -0700, Leah Rumancik wrote:
> > We flush the data device cache before we issue external log IO. Since
> > 7d839e325af2, we check the return value of the flush, and if the flush
> > failed, we shut down the log immediately and return. However, the
> > iclog->ic_sema is left in a decremented state so let's add an up().
> > Prior to this patch, xfs/438 would fail consistently when running with
> > an external log device:
> > 
> > sync
> >   -> xfs_log_force
> >   -> xlog_write_iclog
> >       -> down(&iclog->ic_sema)
> >       -> blkdev_issue_flush (fail causes us to intiate shutdown)
> >           -> xlog_force_shutdown
> >           -> return
> > 
> > unmount
> >   -> xfs_log_umount
> >       -> xlog_wait_iclog_completion
> >           -> down(&iclog->ic_sema) --------> HANG
> > 
> > There is a second early return / shutdown. Add an up() there as well.
> 
> Ow.  Yes, I think it's correct that both of those error returns need to
> drop ic_sema since we don't submit_bio, so there is no xlog_ioend_work
> to do it for us.
> 
> > Fixes: 7d839e325af2 ("xfs: check return codes when flushing block devices")
> 
> Hmm.  This bug was introduced in b5d721eaae47e ("xfs: external logs need
> to flush data device"), not 7d839.  That said, this patch only applies
> cleanly to 7d839e325af2.
> 
> b5d721 was introduced in 5.14 and 7d839 came in via 6.0, so ... this is
> where I would have spat out:
> 
> Fixes: 7d839e325af2 ("xfs: check return codes when flushing block devices")
> Actually-Fixes: b5d721eaae47e ("xfs: external logs need to flush data device")

I'm not sure I follow. Before 7d839e325af2, we didn't return if there
was an issue with the flush so there wasn't an issue with ic_sema. 7d839e325af2
was a fix for eef983ffeae7 though. Do you try to keep fixes tags
associated with the original commit as opposed to fixes of fixes?

> 
> > Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
> > ---
> > 
> > Notes:
> >     Tested auto group for xfs/4k and xfs/logdev configs with no regressions
> >     seen.
> > 
> >  fs/xfs/xfs_log.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index 51c100c86177..b4a8105299c2 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -1926,6 +1926,7 @@ xlog_write_iclog(
> >  		 */
> >  		if (log->l_targ != log->l_mp->m_ddev_targp &&
> >  		    blkdev_issue_flush(log->l_mp->m_ddev_targp->bt_bdev)) {
> > +			up(&iclog->ic_sema);
> >  			xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
> >  			return;
> >  		}
> > @@ -1936,6 +1937,7 @@ xlog_write_iclog(
> >  	iclog->ic_flags &= ~(XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FUA);
> >  
> >  	if (xlog_map_iclog_data(&iclog->ic_bio, iclog->ic_data, count)) {
> > +		up(&iclog->ic_sema);
> >  		xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
> 
> I wonder if these two should both become a cleanup clause at the end?

Sure, that sounds good, I'll create a new version.

Thanks for the review! :)
- Leah
> 
> 		if (log->l_targ != log->l_mp->m_ddev_targp &&
> 		    blkdev_issue_flush(log->l_mp->m_ddev_targp->bt_bdev))
> 			goto shutdown;
> 
> ...
> 
> 	if (xlog_map_iclog_data(&iclog->ic_bio, iclog->ic_data, count))
> 		goto shutdown;
> 
> ...
> 
> 	submit_bio(&iclog->ic_bio);
> 	return;
> 
> shutdown:
> 	up(&iclog->ic_sema);
> 	xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
> }
> 
> Seeing as we've screwed this up twice now and not a whole lot of people
> actually use external logs, and somehow I've never seen this on my test
> fleet.
> 
> Anyway the code change looks correct so modulo the stylistic thing,
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
> --D
> 
> >  		return;
> >  	}
> > -- 
> > 2.42.0.758.gaed0368e0e-goog
> > 
