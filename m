Return-Path: <SRS0=53rf=CL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AB6DC433E2
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Sep 2020 22:47:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29F3220767
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Sep 2020 22:47:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SLiUYw9x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726625AbgIBWrm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Sep 2020 18:47:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57476 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726298AbgIBWrl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Sep 2020 18:47:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599086859;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JQyrfwVezw5qbFXXodPyBm6VOICfanjolxRfyO3VFAk=;
        b=SLiUYw9x+U7WVcchBAdCpEEIOS5ZvLtPeh6O5TcuaYU155sjfTHE9c9hblMriG209UEwru
        b3HhLHGbm06KwEk/5vJDLPDeIG/yQf7pHxnIhslqKcXxvOhdyK7tFuAA9bAUsys6l9jNtW
        iknUeMHAfz8S2v1giVBs5+CpiZaCmqw=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-566-Kwi-MR6sPq2m2pEe7QDsug-1; Wed, 02 Sep 2020 18:47:37 -0400
X-MC-Unique: Kwi-MR6sPq2m2pEe7QDsug-1
Received: by mail-pj1-f72.google.com with SMTP id n19so441409pjt.1
        for <linux-xfs@vger.kernel.org>; Wed, 02 Sep 2020 15:47:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=JQyrfwVezw5qbFXXodPyBm6VOICfanjolxRfyO3VFAk=;
        b=au9nBGJcKHAUf1mlHQf330sruYUkdzkVHlAVFemhLrTgtNi7jHLpMk0aQerQnD1rTO
         gvQ5jiJoysp97rFyNSTEDn7jkItQtQK5ZH9EwDwzhR/Cz+VkWHVCMICQltIXS0y55Lob
         IBDTTEANVvj64+g9JR5c7Ou02dnATE1Aiqyan7fmi4l8/o/9HqQJZ+IiAenSTI5WIXHS
         1ylS+W4FZ0sVLKhj4pFHjaQCK40vHseIR5va9OP9jIVch+5defyf60o+Tp9tz6LmT/O4
         Unk42g3X87V0iKgMtOPmgiqywVODHFqNRbqIFyBDuCtX+WIayIutXArutck01FH3cF7U
         vNvQ==
X-Gm-Message-State: AOAM530p2vd0gdaT03by9CGikw+GbOXg+1kVEsZmwd7rigZYpiTI5bxA
        i5vqdKV2wzIZZjYgFWTPQ5Y+WvZXiDf6XAr5ABekoV5tLXtZSj2RKp/BJLM2dm8P+za3cfbUNWu
        dEFj4vdedNk5EffRI00+c
X-Received: by 2002:a17:90a:fe07:: with SMTP id ck7mr28538pjb.20.1599086856390;
        Wed, 02 Sep 2020 15:47:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy4glD/+HYi3XONrlxLcq/Dqk+2nqrn4N1KVGDtFqqGOX6xwZ2jjS/kCYErYf7K7la8zGmLdQ==
X-Received: by 2002:a17:90a:fe07:: with SMTP id ck7mr28512pjb.20.1599086856002;
        Wed, 02 Sep 2020 15:47:36 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f18sm589049pfj.35.2020.09.02.15.47.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 15:47:35 -0700 (PDT)
Date:   Thu, 3 Sep 2020 06:47:26 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: avoid LR buffer overrun due to crafted h_len
Message-ID: <20200902224726.GB4671@xiangao.remote.csb>
References: <20200902141012.24605-1-hsiangkao@redhat.com>
 <20200902141923.26422-1-hsiangkao@redhat.com>
 <20200902173859.GD289426@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200902173859.GD289426@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Brian,

On Wed, Sep 02, 2020 at 01:38:59PM -0400, Brian Foster wrote:
> On Wed, Sep 02, 2020 at 10:19:23PM +0800, Gao Xiang wrote:

...

> > However, each log record could still have crafted
> > h_len and cause log record buffer overrun. So let's
> > check h_len for each log record as well instead.
> > 
> 
> Is this something you've observed or attempted to reproduce, or is this
> based on code inspection?

Thanks for your review.

based on code inspection, the logic seems straight-forward

in xlog_do_recovery_pass()
	...

	dbp = xlog_alloc_buffer(log, BTOBB(h_size));
					^ here uses h_size from the tail block
	if (!dbp) {
		kmem_free(hbp);
		return -ENOMEM;
	}

	if (tail_blk > head_blk) {
		while (blk_no < log->l_logBBsize) {
			xlog_bread
			xlog_valid_rec_header
			xlog_recover_process
		}
	}

	while (blk_no < head_blk) {
		xlog_bread
		xlog_valid_rec_header
		xlog_recover_process
	}


in xlog_recover_process()
	crc = xlog_cksum(log, rhead, dp, be32_to_cpu(rhead->h_len));
							^here
	...

and also xlog_recover_process_data()
	end = dp + be32_to_cpu(rhead->h_len);
	...
	while ((dp < end) && num_logops) {
		ohead = (struct xlog_op_header *)dp;
		(all things around dp/ohead if num_logops is crafted as well. 
		...
	}


> 
> > -	if (XFS_IS_CORRUPT(log->l_mp, hlen <= 0 || hlen > INT_MAX))
> > +	if (XFS_IS_CORRUPT(log->l_mp, hlen <= 0))
> 
> Why is the second part of the check removed?

if hlen <= hsize (hsize > 0) then hlen will be <= INT_MAX

> 
> >  		return -EFSCORRUPTED;
> > +
> > +	if (hsize && XFS_IS_CORRUPT(log->l_mp,
> > +				    hsize < be32_to_cpu(rhead->h_size)))
> > +		return -EFSCORRUPTED;
> > +	hsize = be32_to_cpu(rhead->h_size);
> 
> I'm a little confused why we take hsize as a parameter as well as read
> it from the record header. If we're validating a particular record,
> shouldn't we use the size as specified by that record?
> 
> Also FWIW I think pulling bits of logic out of the XFS_IS_CORRUPT()
> check makes this a little harder to read than just putting the entire
> logic statement within the macro.

It seems that is partially self-answered in the last part of the email.
So move the response to the last of the email...

> 
> > +
> > +	if (unlikely(hlen > hsize)) {
> 
> I think we've made a point to avoid the [un]likely() modifiers in XFS as
> they don't usually have a noticeable impact. I certainly wouldn't expect
> it to in log recovery.

Honestly, I really don't want to work on some topic about [un]likely,
I did a long discussion with Dan Carpenter and a couple of other people
last year, but *shrug*

For this case just simply bacause XFS_IS_CORRUPT() has this annotation,
and it seems xlog_valid_rec_header() logic will be changed in v3
if we leave the mkfs workaround logic as is.

> 
> > +		if (XFS_IS_CORRUPT(log->l_mp, hlen > log->l_mp->m_logbsize ||
> > +				   rhead->h_num_logops != cpu_to_be32(1)))
> > +			return -EFSCORRUPTED;
> > +
> > +		xfs_warn(log->l_mp,
> > +		"invalid iclog size (%d bytes), using lsunit (%d bytes)",
> > +			 hsize, log->l_mp->m_logbsize);
> > +		rhead->h_size = cpu_to_be32(log->l_mp->m_logbsize);
> 
> I also find updating the header structure as such down in a "validation
> helper" a bit obscured.

also the same words at the last of the email...

> 
> > +	}
> > +
> >  	if (XFS_IS_CORRUPT(log->l_mp,
> >  			   blkno > log->l_logBBsize || blkno > INT_MAX))
> >  		return -EFSCORRUPTED;
> ...
> > @@ -3096,7 +3100,7 @@ xlog_do_recovery_pass(
> >  			}
> >  			rhead = (xlog_rec_header_t *)offset;
> >  			error = xlog_valid_rec_header(log, rhead,
> > -						split_hblks ? blk_no : 0);
> > +					split_hblks ? blk_no : 0, h_size);
> >  			if (error)
> >  				goto bread_err2;
> >  
> > @@ -3177,7 +3181,7 @@ xlog_do_recovery_pass(
> >  			goto bread_err2;
> >  
> >  		rhead = (xlog_rec_header_t *)offset;
> > -		error = xlog_valid_rec_header(log, rhead, blk_no);
> > +		error = xlog_valid_rec_header(log, rhead, blk_no, h_size);
> >  		if (error)
> >  			goto bread_err2;
> 
> In these two cases we've already allocated the record header and data
> buffers and we're walking through the log records doing recovery. Given
> that, it seems like the purpose of the parameter is more to check the
> subsequent records against the size of the current record buffer. That
> seems like a reasonable check to incorporate, but I think the mkfs

Yes

> workaround logic is misplaced in a generic record validation helper.
> IIUC that is a very special case that should only apply to the first
> record in the log and only impacts the size of the buffer we allocate to
> read in the remaining records.
> 
> Can we rework this to leave the mkfs workaround logic as is and update
> the validation helper to check that each record length fits in the size
> of the buffer we've decided to allocate? I'd also suggest to rename the
> new parameter to something like 'bufsize' instead of 'h_size' to clarify
> what it actually means in the context of xlog_valid_rec_header().

Ok, that is fine. I will leave the mkfs workaround logic as is and rename
to bufsize.

Thanks,
Gao Xiang


> 
> Brian
> 
> >  
> > -- 
> > 2.18.1
> > 
> 

