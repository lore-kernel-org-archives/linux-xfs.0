Return-Path: <SRS0=chL6=C7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9D89C4363D
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Sep 2020 15:32:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 683E72220D
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Sep 2020 15:32:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dPdQKJTF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbgIVPce (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Sep 2020 11:32:34 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:34938 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726566AbgIVPce (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Sep 2020 11:32:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600788753;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1G7MzGNgoXWGotPGyvIanVM3lqwWKEnx4NiKUJ+vDEY=;
        b=dPdQKJTFkpAzCN4DfcwUTZ+OKlhOAddhvqtSwL3DtsV/ouU1AXpn5L4LfFShm3J8sOMGPy
        zck/eTCWzy5Q3gOXclsmDUxkvi2MKVE0BcZW0n5Bk8T+QDEnsIx0HjpeItgXS4mYnBwyff
        410ORJraQ7vcjghui+PyXQ/2nagH8g0=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-332-gU1-oDdXOYSUGZLZsIrUyg-1; Tue, 22 Sep 2020 11:32:31 -0400
X-MC-Unique: gU1-oDdXOYSUGZLZsIrUyg-1
Received: by mail-pf1-f198.google.com with SMTP id q2so11498617pfc.17
        for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2020 08:32:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1G7MzGNgoXWGotPGyvIanVM3lqwWKEnx4NiKUJ+vDEY=;
        b=ZJ14lCIJjXQL0uYY/yKu5foA2WT/+nG3dWGSdPstiUW4WIqL17kYnYPL623tNIjWMC
         r7g11kgDMeMAcGtWBBcF74VCIjhYgglYyjVmhS734QGcg5IxbFMyn4Gzx7vmzp1jOKG1
         gENwj73zUOIG/Xm42SF+l7167vIsnQm5DiyglHKPlr4gKLak6IJCFtsfUJpvi6KUO9vd
         LjYqg79mxcfN4DupERt71kPwb5ICkLZg9OCcQxn5Zn+tl1WavmSCV1W0fl+ozm6SMJNc
         2ihnS16gRQ8r8r/8aAcuiz2dngmOm++UVf+plvTD2uVFCK5GKeqV9/CBXavFw2tfQTJW
         jbOw==
X-Gm-Message-State: AOAM531zYqv+yeEvAz74hYgvf+M5LVbCCMvRyL98acb1kzbDqHdsMuhU
        kvCARfFZVc3xgmKA21tCI0f1f6gnVzZeUP+4f2Am49iotOW2ZE6Aka+5vguMB2l9WZXVbDznVk0
        saogRk30jKt2oyUG09RnL
X-Received: by 2002:a17:90a:e016:: with SMTP id u22mr4522197pjy.178.1600788749683;
        Tue, 22 Sep 2020 08:32:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxzH6bgz57kAbBSNjctYuL20hXrM3PjhyDrjr7a++3d3CkgJuOcygCPV6Bznb2BcEvo7zNo9g==
X-Received: by 2002:a17:90a:e016:: with SMTP id u22mr4522181pjy.178.1600788749433;
        Tue, 22 Sep 2020 08:32:29 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a185sm5158460pgc.46.2020.09.22.08.32.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 08:32:29 -0700 (PDT)
Date:   Tue, 22 Sep 2020 23:32:19 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 2/2] xfs: clean up calculation of LR header blocks
Message-ID: <20200922153219.GB25645@xiangao.remote.csb>
References: <20200917051341.9811-1-hsiangkao@redhat.com>
 <20200917051341.9811-3-hsiangkao@redhat.com>
 <20200922152248.GC2175303@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200922152248.GC2175303@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Brian,

On Tue, Sep 22, 2020 at 11:22:48AM -0400, Brian Foster wrote:
> On Thu, Sep 17, 2020 at 01:13:41PM +0800, Gao Xiang wrote:
> > Let's use DIV_ROUND_UP() to calculate log record header
> > blocks as what did in xlog_get_iclog_buffer_size() and
> > wrap up a common helper for log recovery.
> > 
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > ---
> > v2: https://lore.kernel.org/r/20200904082516.31205-3-hsiangkao@redhat.com
> > 
> > changes since v2:
> >  - get rid of xlog_logrecv2_hblks() and use xlog_logrec_hblks()
> >    entirely (Brian).
> > 
> >  fs/xfs/xfs_log.c         |  4 +---
> >  fs/xfs/xfs_log_recover.c | 48 ++++++++++++++--------------------------
> >  2 files changed, 17 insertions(+), 35 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index ad0c69ee8947..7a4ba408a3a2 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -1604,9 +1604,7 @@ xlog_cksum(
> >  		int		i;
> >  		int		xheads;
> >  
> > -		xheads = size / XLOG_HEADER_CYCLE_SIZE;
> > -		if (size % XLOG_HEADER_CYCLE_SIZE)
> > -			xheads++;
> > +		xheads = DIV_ROUND_UP(size, XLOG_HEADER_CYCLE_SIZE);
> >  
> >  		for (i = 1; i < xheads; i++) {
> >  			crc = crc32c(crc, &xhdr[i].hic_xheader,
> > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > index 782ec3eeab4d..28dd98b5a703 100644
> > --- a/fs/xfs/xfs_log_recover.c
> > +++ b/fs/xfs/xfs_log_recover.c
> > @@ -371,6 +371,18 @@ xlog_find_verify_cycle(
> >  	return error;
> >  }
> >  
> > +static inline int xlog_logrec_hblks(struct xlog *log, xlog_rec_header_t *rh)
> > +{
> 
> We're trying to gradually eliminate various structure typedefs so it's
> frowned upon to introduce new instances. If you replace the above with
> 'struct xlog_rec_header,' the rest looks good to me:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Thanks for your review. Yeah, I noticed the eliminate movement
and I used xlog_rec_header_t by mistake.

I will resend a follow-up "in-reply-to" patch to fix that.

Thanks,
Gao Xiang

