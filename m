Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39A6DC433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Jan 2021 20:34:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DED94233FC
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Jan 2021 20:34:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387713AbhATUdr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Jan 2021 15:33:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43346 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732463AbhATUdY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Jan 2021 15:33:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611174715;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1GWthdZatALpyTz1BSbnIXNaPQ6L6SfSsZZd+pi+w3Q=;
        b=AAJJgCwbSo/sWyjMCUPsHAHbVDLzEHIHGpeZVW+GGst2hZbyFyeG56NVh+V7kaT4PUV5DU
        Fd6esM022d5K8oTXRjAdiZTb8ICjdy5/b5FTDgrSKuGCS8KnMgjbjC/BXsjmpyNPrwEu19
        T/smLh9M7Z1qAYKugzGMc+ZnPjqUwQQ=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-536-vh_O66pTN72lICqLhAYBng-1; Wed, 20 Jan 2021 15:31:53 -0500
X-MC-Unique: vh_O66pTN72lICqLhAYBng-1
Received: by mail-pg1-f198.google.com with SMTP id 1so19344511pgu.17
        for <linux-xfs@vger.kernel.org>; Wed, 20 Jan 2021 12:31:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1GWthdZatALpyTz1BSbnIXNaPQ6L6SfSsZZd+pi+w3Q=;
        b=o7hcWy8JeQzjEZUC+d6ubDl8NJ4tW1PZnXDdwKusetA6CGVE1/DyiUelpc/vaIwRMM
         Baq63EY7nBB/5tteUTsNCbobeTvL3xRvmY+mvlGYuRXmOao0/2i3Li1J1bi9wpTkEbTY
         3xGvt3V7CyzR06qqKlcPLO2mCCP1lxH99648AeqVutoki/xc2qE1QcWCibc8RHhH1n+h
         FEKEFqVwk1jF6szddf9G3SyGqO+xKIuLSxb+nDYr55yw5pH90bhIrOOLmJwKXqlQv4uc
         cQ1422+Go/HBeanCV/qTcG3CouPS67Z3bMFHwwSHklBvmLmYciNWFWptNnAIRFffuPpz
         ty+Q==
X-Gm-Message-State: AOAM5337pRMmvuJC/a29jclxc0CCqBzP27GfLbVAdHN5uDc9yoyE2kyc
        yusQhXgZPUH9AWY4NfTQ08EdJyXOaboZoJULeTTjPzWchlRtISJb6w82li8KLElxv8pcezqXwOX
        yoEBpL71MTfDqpziaEMDU
X-Received: by 2002:a17:90a:414d:: with SMTP id m13mr7618116pjg.229.1611174712812;
        Wed, 20 Jan 2021 12:31:52 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxhV1MoRn8IYKqz508Xdbb4/DiKn/5aeqc2EdeonG5SOB5gaGVys0c3kY2CPcdk0PvVRynFig==
X-Received: by 2002:a17:90a:414d:: with SMTP id m13mr7618093pjg.229.1611174712535;
        Wed, 20 Jan 2021 12:31:52 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y1sm3104901pff.17.2021.01.20.12.31.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 12:31:52 -0800 (PST)
Date:   Thu, 21 Jan 2021 04:31:40 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v5 4/5] xfs: support shrinking unused space in the last AG
Message-ID: <20210120203140.GA2802723@xiangao.remote.csb>
References: <20210118083700.2384277-1-hsiangkao@redhat.com>
 <20210118083700.2384277-5-hsiangkao@redhat.com>
 <20210120192506.GL3134581@magnolia>
 <20210120202259.GA2800037@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210120202259.GA2800037@xiangao.remote.csb>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 21, 2021 at 04:22:59AM +0800, Gao Xiang wrote:

... (cont..)

> 
> > 
> > > +		err2 = xfs_ag_resv_init(agibp->b_pag, tp);
> > > +		if (err2)
> > > +			goto resv_err;
> > > +		return error;
> > > +	}
> > > +
> > > +	/*
> > > +	 * if successfully deleted from freespace btrees, need to confirm
> > > +	 * per-AG reservation works as expected.
> > > +	 */
> > > +	be32_add_cpu(&agi->agi_length, -len);
> > > +	be32_add_cpu(&agf->agf_length, -len);
> > > +
> > > +	err2 = xfs_ag_resv_init(agibp->b_pag, tp);
> > > +	if (err2) {
> > > +		be32_add_cpu(&agi->agi_length, len);
> > > +		be32_add_cpu(&agf->agf_length, len);
> > > +		if (err2 != -ENOSPC)
> > > +			goto resv_err;
> > 
> > If we've just undone reducing ag[if]_length, don't we need to call
> > xfs_ag_resv_init here to (try to) recreate the former per-ag
> > reservations?
> 
> If my understanding is correct, xfs_fs_reserve_ag_blocks() in
> xfs_growfs_data_private() would do that for all AGs... Do we
> need to xfs_ag_resv_init() in advance here?
> 
> I thought xfs_ag_resv_init() here is mainly used to guarantee the
> per-AG reservation for resized size is fine... if ag{i,f}_length
> don't change, leave such normal reservation to
> xfs_fs_reserve_ag_blocks() would be okay?
>

Although When xfs_fs_reserve_ag_blocks(), the transaction has already
been  commited, the last AG is unlocked. So there might be some race
window here... So I will update it, thanks for this!

Thanks,
Gao Xiang

