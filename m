Return-Path: <SRS0=53rf=CL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84AADC43461
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Sep 2020 15:36:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D18920678
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Sep 2020 15:36:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="flKCIKKh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgIBPga (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Sep 2020 11:36:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50196 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726733AbgIBPfP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Sep 2020 11:35:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599060911;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=F5H7KUGwp0wPSRwbnhdR+kss/4zDTOk6pqBe9yxosJ8=;
        b=flKCIKKhUYIAXKoETtq8dxJuR85dUil3GkPr7uM3OK+7C9d4sePnv5WcOPn5mL91xPJjqV
        Lq2qc7/jNZ8xdE5c/mtiMaXiGpGKTudROw6xir+k6NoJ1PDIpVxoeOa+Ifmy4f1QqbY67H
        OqkM2xq2/ewttxNnWJVEO3Wj+G/QCMI=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-216-5SepLa2nPkq9haE_w1gKYg-1; Wed, 02 Sep 2020 11:35:09 -0400
X-MC-Unique: 5SepLa2nPkq9haE_w1gKYg-1
Received: by mail-pf1-f199.google.com with SMTP id c18so352700pfi.21
        for <linux-xfs@vger.kernel.org>; Wed, 02 Sep 2020 08:35:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=F5H7KUGwp0wPSRwbnhdR+kss/4zDTOk6pqBe9yxosJ8=;
        b=e8NYMVxvOQT/yOV61v33SDdQeMD3BUoxNL/imzo2u4dAC2l2aj1yODLQr/t50kDvh2
         8qFxGAJ/Ls8KBlN+1+ysl/XsttgN+GtZwY2oV9ZF3wAQg/R+wphi9oTDznQPlT+n4SJY
         4AypmczYm7fvL2/P8Mb0aCYPx2jZ7pdA6ZNWEN9AXfUbINunUsWqtzdEHyltsnIV1/nF
         lBqhX8QoSu2IGWtmTa3k9yr9Ra5j/UPkSpQ4GV0VnqpG8UGDIKRX/e3HEqxSyVY3Q1NY
         s6QJYL4sQFVxH5qW56aVp+9foiJO9j87LQDEYYAdLWS5P0idTDG4dhEefjhx1PEi3ZBW
         XPJw==
X-Gm-Message-State: AOAM530ZO9uNtuPay7YI3Cmy5Md1fFbfqVNhIOWInT7LjUrvdAKfPKHU
        G4wh7+wvTfDNEHzcckhbM7Job5aefJTrJHW8jtQTPgh9vYYbfTkobhpyc6gGORe5qpfd8nM77mH
        6PXYBjYZjgnXIslWLna9C
X-Received: by 2002:a63:d70f:: with SMTP id d15mr2358431pgg.354.1599060907892;
        Wed, 02 Sep 2020 08:35:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxCdhwfHI4mw0CKkiKRY+6q8ZKGBiG0LOFruPdFB1mFW8rkUYJyDF0hqh72hE78QWAziNRCVA==
X-Received: by 2002:a63:d70f:: with SMTP id d15mr2358421pgg.354.1599060907574;
        Wed, 02 Sep 2020 08:35:07 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x4sm6207131pfm.86.2020.09.02.08.35.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 08:35:07 -0700 (PDT)
Date:   Wed, 2 Sep 2020 23:34:58 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: clean up calculation of LR header blocks
Message-ID: <20200902153458.GA4671@xiangao.remote.csb>
References: <20200902140923.24392-1-hsiangkao@redhat.com>
 <20200902152656.GC289426@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200902152656.GC289426@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Brian,

On Wed, Sep 02, 2020 at 11:26:56AM -0400, Brian Foster wrote:
> On Wed, Sep 02, 2020 at 10:09:23PM +0800, Gao Xiang wrote:
> > Let's use DIV_ROUND_UP() to calculate log record header
> > blocks as what did in xlog_get_iclog_buffer_size() and
> > also wrap up a common helper for log recovery code.
> > 
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_log_format.h | 10 +++++++++
> >  fs/xfs/xfs_log.c               |  4 +---
> >  fs/xfs/xfs_log_recover.c       | 37 ++++++++--------------------------
> >  3 files changed, 19 insertions(+), 32 deletions(-)
> > 
> ...
> > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > index e2ec91b2d0f4..5fecc0c7aeb2 100644
> > --- a/fs/xfs/xfs_log_recover.c
> > +++ b/fs/xfs/xfs_log_recover.c
> > @@ -489,15 +489,10 @@ xlog_find_verify_log_record(
> >  	 * reset last_blk.  Only when last_blk points in the middle of a log
> >  	 * record do we update last_blk.
> >  	 */
> > -	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb)) {
> > -		uint	h_size = be32_to_cpu(head->h_size);
> > -
> > -		xhdrs = h_size / XLOG_HEADER_CYCLE_SIZE;
> > -		if (h_size % XLOG_HEADER_CYCLE_SIZE)
> > -			xhdrs++;
> > -	} else {
> > +	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb))
> > +		xhdrs = xlog_logv2_rec_hblks(head);
> > +	else
> >  		xhdrs = 1;
> > -	}
> 
> Can we fold the _haslogv2() check into the helper as well (then perhaps
> drop the 'v2' from the name)? Otherwise looks like a nice cleanup to
> me..

Thanks for your suggestion.

I would have done the same at the beginning, but the case
in xlog_do_recovery_pass() from the current codebase is a
bit complex for now.

I will try to simplify the logic in xlog_do_recovery_pass()
tomorrow, but if it makes more complex.. I'd suggest leave
it as-is...

Thanks,
Gao Xiang

> 
> Brian
> 
> >  
> >  	if (*last_blk - i + extra_bblks !=
> >  	    BTOBB(be32_to_cpu(head->h_len)) + xhdrs)
> > @@ -1184,21 +1179,10 @@ xlog_check_unmount_rec(
> >  	 * below. We won't want to clear the unmount record if there is one, so
> >  	 * we pass the lsn of the unmount record rather than the block after it.
> >  	 */
> > -	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb)) {
> > -		int	h_size = be32_to_cpu(rhead->h_size);
> > -		int	h_version = be32_to_cpu(rhead->h_version);
> > -
> > -		if ((h_version & XLOG_VERSION_2) &&
> > -		    (h_size > XLOG_HEADER_CYCLE_SIZE)) {
> > -			hblks = h_size / XLOG_HEADER_CYCLE_SIZE;
> > -			if (h_size % XLOG_HEADER_CYCLE_SIZE)
> > -				hblks++;
> > -		} else {
> > -			hblks = 1;
> > -		}
> > -	} else {
> > +	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb))
> > +		hblks = xlog_logv2_rec_hblks(rhead);
> > +	else
> >  		hblks = 1;
> > -	}
> >  
> >  	after_umount_blk = xlog_wrap_logbno(log,
> >  			rhead_blk + hblks + BTOBB(be32_to_cpu(rhead->h_len)));
> > @@ -3016,15 +3000,10 @@ xlog_do_recovery_pass(
> >  			}
> >  		}
> >  
> > -		if ((be32_to_cpu(rhead->h_version) & XLOG_VERSION_2) &&
> > -		    (h_size > XLOG_HEADER_CYCLE_SIZE)) {
> > -			hblks = h_size / XLOG_HEADER_CYCLE_SIZE;
> > -			if (h_size % XLOG_HEADER_CYCLE_SIZE)
> > -				hblks++;
> > +		hblks = xlog_logv2_rec_hblks(rhead);
> > +		if (hblks != 1) {
> >  			kmem_free(hbp);
> >  			hbp = xlog_alloc_buffer(log, hblks);
> > -		} else {
> > -			hblks = 1;
> >  		}
> >  	} else {
> >  		ASSERT(log->l_sectBBsize == 1);
> > -- 
> > 2.18.1
> > 
> 

