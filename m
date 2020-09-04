Return-Path: <SRS0=m/8K=CN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D803C43461
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Sep 2020 15:02:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E79E52073B
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Sep 2020 15:02:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730237AbgIDPCP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Sep 2020 11:02:15 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:21064 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730220AbgIDPCP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Sep 2020 11:02:15 -0400
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-SQITro7uNLyZDVj_J_ebzQ-1; Fri, 04 Sep 2020 11:02:11 -0400
X-MC-Unique: SQITro7uNLyZDVj_J_ebzQ-1
Received: by mail-pg1-f200.google.com with SMTP id c3so3672878pgq.9
        for <linux-xfs@vger.kernel.org>; Fri, 04 Sep 2020 08:02:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2d9tiDaewSXZjY5a95oEdDLs+pb4DTYchoqMYQ2fJhM=;
        b=GPofru3ja2zeebLa99kfim2zMKveyTKRE8WFDM2JpyHDTQkaLeqBZUIIVJbi2EFIU+
         9RPunktWtIFTn/Frl2R+CzxQSpw14UC9Vq6yTMD+bfraoI+Tr2KfHuYJn88bCSKjktpE
         vn2xiUgIhvgavza22Ko0ewmlCqSgEkmA9GcSIFgC53IacolTJK03VSi3evanOWAR22UB
         d7boWWJ9+zmnxOGyG28qVf2aIWzWd/fGKVS6IX13gTJlQLb1ZjtIAn+7DvVg39IMo2UR
         a2sGQmUVxg9MWwvPCBPdX72FfQqonzp3wju5BVJ5SuswfLP8zaVRs7tUgQ5TIqqNMEd+
         bLVw==
X-Gm-Message-State: AOAM533alYWCny01ZOyY9bZDZD7UJ/RLQnx7DpHkNkY90yMYPTPWPSje
        AnAAAKuSATLYK8nwoprH88a/6zrA0uep1kW3bZ78Ciw5sPpW1EzX7SZQa0B+R4EFS2gww7IP2/y
        gZ1op+LcdmZOwz2gQM9vm
X-Received: by 2002:a17:902:c286:: with SMTP id i6mr8956518pld.63.1599231729165;
        Fri, 04 Sep 2020 08:02:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwMJVRNsCJ8nJUe5I8cQTDHSUrqodMyyIQ7W5w+XKMs9NK9H2cMFW2JV5ZFZspw06Zkj/J/3w==
X-Received: by 2002:a17:902:c286:: with SMTP id i6mr8956481pld.63.1599231728755;
        Fri, 04 Sep 2020 08:02:08 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t14sm5496445pjs.42.2020.09.04.08.02.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2020 08:02:08 -0700 (PDT)
Date:   Fri, 4 Sep 2020 23:01:59 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v3 1/2] xfs: avoid LR buffer overrun due to crafted
 h_{len,size}
Message-ID: <20200904150159.GA17378@xiangao.remote.csb>
References: <20200904082516.31205-1-hsiangkao@redhat.com>
 <20200904082516.31205-2-hsiangkao@redhat.com>
 <20200904112529.GB529978@bfoster>
 <20200904124634.GA28752@xiangao.remote.csb>
 <20200904133704.GD529978@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200904133704.GD529978@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 04, 2020 at 09:37:04AM -0400, Brian Foster wrote:
> On Fri, Sep 04, 2020 at 08:46:34PM +0800, Gao Xiang wrote:
...
> > > > @@ -3001,21 +3011,19 @@ xlog_do_recovery_pass(
> > > >  		 */
> > > >  		h_size = be32_to_cpu(rhead->h_size);
> > > >  		h_len = be32_to_cpu(rhead->h_len);
> > > > -		if (h_len > h_size) {
> > > > -			if (h_len <= log->l_mp->m_logbsize &&
> > > > -			    be32_to_cpu(rhead->h_num_logops) == 1) {
> > > > -				xfs_warn(log->l_mp,
> > > > +		if (h_len > h_size && h_len <= log->l_mp->m_logbsize &&
> > > > +		    rhead->h_num_logops == cpu_to_be32(1)) {
> > > > +			xfs_warn(log->l_mp,
> > > >  		"invalid iclog size (%d bytes), using lsunit (%d bytes)",
> > > > -					 h_size, log->l_mp->m_logbsize);
> > > > -				h_size = log->l_mp->m_logbsize;
> > > > -			} else {
> > > > -				XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
> > > > -						log->l_mp);
> > > > -				error = -EFSCORRUPTED;
> > > > -				goto bread_err1;
> > > > -			}
> > > > +				 h_size, log->l_mp->m_logbsize);
> > > > +			h_size = log->l_mp->m_logbsize;
> > > > +			rhead->h_size = cpu_to_be32(h_size);
> > > 
> > > I don't think we should update rhead like this, particularly in a rare
> > > and exclusive case. This structure should reflect what is on disk.
> > > 
> > > All in all, I think this patch should be much more focused:
> > > 
> > > 1.) Add the bufsize parameter and associated corruption check to
> > > xlog_valid_rec_header().
> > > 2.) Pass the related value from the existing calls.
> > > 3.) (Optional) If there's reason to revalidate after executing the mkfs
> > > workaround, add a second call within the branch that implements the
> > > h_size workaround.
> > > 
> > 
> > I moved workaround code to xlog_valid_rec_header() at first is
> > because in xlog_valid_rec_header() actually it has 2 individual
> > checks now:
> > 
> > 1) check rhead->h_len vs rhead->h_size for each individual log record;
> > 2) check rhead->h_size vs the unique allocated buffer size passed in
> >    for each record (since each log record has one stored h_size,
> >    even though there are not used later according to the current
> >    logic of xlog_do_recovery_pass).
> > 
> > if any of the conditions above is not satisfied, xlog_valid_rec_header()
> > will make fs corrupted immediately, so I tried 2 ways up to now:
> > 
> >  - (v1,v2) fold in workaround case into xlog_valid_rec_header()
> >  - (v3) rearrange workaround and xlog_valid_rec_header() order in
> >         xlog_do_recovery_pass() and modify rhead->h_size to the
> >         workaround h_size before xlog_valid_rec_header() validation
> >         so xlog_valid_rec_header() will work as expected since it
> >         has two individual checks as mentioned above.
> > 
> > If there is some better way, kindly let me know :) and I'd like to
> > hear other folks about this in advance as well.... so I can go
> > forward since this part is a bit tricky for now.
> > 
> 
> My suggestion is to, at minimum, separate the above two logic changes
> into separate patches. Item #2 above is a functional check in that it
> ensures each record fits into the record buffer size we've allocated
> (based on h_size) at the start of recovery. This item is what my
> feedback above was referring to and I think is a fairly straightforward
> change.

There are 3-value relationships now (rhead->h_len <= rhead->h_size <=
unique allocated buffer size [which is the same as rhead->h_size of
initial tail log record]).

The only buffer overrun case which could do harm runtimely is
rhead->h_len > bufsize as I mentioned in the previous email
https://lore.kernel.org/r/20200902224726.GB4671@xiangao.remote.csb

so I guess what you meant is

 - get h_size from the tail initial log record as buffer size (so
   workaround needs to be settled here as well);
 - call in xlog_valid_rec_header() to fail out rhead->h_len >
   buffer size.

as the 1st splited patch. Yet that's not the case of Item #2
(rhead->h_size <= buffer size), just to confirm if my understanding
is correct.

> 
> Item #1 is a bit more nebulous. h_size refers to the iclog size used by
> the kernel that wrote to the log. I think it should be uniform across
> all records and AFAICT it doesn't serve a functional purpose (validation
> notwithstanding) for recovery beyond establishing the size of the buffer
> we should allocate to process records. The mkfs workaround implements a
> case where we have to ignore the on-disk h_size and use the in-core
> iclog size, and that is currently isolated to a single place. I'm not
> fundamentally against more h_size verification beyond current usage, but
> if that means we have to consider the workaround for multiple records
> (which is confusing and incorrect) or make subtle runtime changes like
> quietly tweaking the in-core record header structure from what is on
> disk, then I don't think it's worth the complexity.
> 
> If we _really_ wanted to include such a change, I think a more
> appropriate validation check might be to similarly track the h_size from
> the initial record and simply verify that the values are uniform across
> all processed records. That way we don't conflict or impose the
> workaround logic on the underlying log format rules. It also catches the
> (unlikely) case that the mkfs workaround is applied on the first record
> incorrectly because h_size is corrupt and there are more records that
> conflict. Also note that v5 filesystems enforce record CRC checks
> anyways, so this still might be of limited value...

based on the words above, my understanding is that the 2nd spilted
patch is used to do such extra check in xlog_valid_rec_header() to

check buffer size == rhead->h_size all the time?

so the relationship would be rhead->h_len <= buffer size = rhead->h_size.

please correct me if I'm wrong since I'm a bit confusing about some
English expressions. Yeah, if my understanding is correct, I'd like
to hear if this 2nd spilted check patch is needed (it won't
cause any stability impact since rhead->h_size for log records
other than tail record isn't useful due to the current logic...)

Thanks,
Gao Xiang

> 
> Brian
> 
> > > Also, please test the workaround case to make sure it still works as
> > > expected (if you haven't already).
> > 
> > ok, will double confirm this, thanks!
> > 
> > Thanks,
> > Gao Xiang
> > 
> > > 
> > > Brian
> > >
> >  
> > 
> 

