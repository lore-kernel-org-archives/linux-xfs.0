Return-Path: <SRS0=chL6=C7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47A30C4363D
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Sep 2020 15:28:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 011BF2399A
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Sep 2020 15:28:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BBKCQiPK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbgIVP2i (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Sep 2020 11:28:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36942 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726566AbgIVP2i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Sep 2020 11:28:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600788516;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=C47HSU0z3iUrCs/WE2wtgCTPVox4MmjJ3LfdDy2HclI=;
        b=BBKCQiPKoadUjCN9MyOP4r4RZHbeCMKbVFfuHpTgITrx0kL6t2DF4YulLvOiDWNnkwEjtc
        enbRVsQ/FS4mZ371Mi9yvhP3GRbxRxgVPWfHKvuU/a5wU19hQgA31ZzDRO0I/1WFljrV76
        jnqgt9aoOb4QAjcURs0BZRLpzKiKogA=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-pA3gtj7INCiiA8El1I1v3A-1; Tue, 22 Sep 2020 11:28:33 -0400
X-MC-Unique: pA3gtj7INCiiA8El1I1v3A-1
Received: by mail-pf1-f199.google.com with SMTP id h15so11598392pfr.3
        for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2020 08:28:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=C47HSU0z3iUrCs/WE2wtgCTPVox4MmjJ3LfdDy2HclI=;
        b=n/tEEb5XY9fitHcoDR2ywE5VJ4YPu6yvfzDG4ycc924aTFT2+tOfUXM1jkjulb0GC5
         XNW5/JEiU/w5K/vKICTTq6gUDzxO+Iaqa3n4iYqdpZPAuh1w8N2T+0y7vaR50h3pg0wc
         7cld1pUvRDF4YZyzTIhSnf86+eM5kznLpZIXawAUBvFuOgt/qefhmbmZ9awyLMMPaA4p
         DLzSDjW1i0L3HrmB8vbapwlRcwSxpfjvEslMURHDGX/k1gj6ynYQjRBs3AckCpbjxJ+k
         tLVCbiEZTBL3tOM6q3SbdTSI826GiSPytCyDNVq10r18JsMyBjjivfYLIPv159Iy/tWi
         fGvg==
X-Gm-Message-State: AOAM531IiWt1wl9wyxvGWXH4/zidSrEwoPY6Rfs0AsspHAuVmobZ6kFR
        F0VRdBAbpbASKffatjTZFzhuBNWpQffKaomRrHeCwAWEAud0M4YKRYTBMEcWZkfKa35y+tr41M9
        Rqn97S3y+zseeAX8eLTaz
X-Received: by 2002:a05:6a00:22d4:b029:150:bd5d:ce11 with SMTP id f20-20020a056a0022d4b0290150bd5dce11mr4598181pfj.38.1600788512340;
        Tue, 22 Sep 2020 08:28:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxcGI4yhU+GaT8pBIZVt778lMFOv9LTGTiI7yeDZxUfTSt7lnVVukJpt6Ju3AxujntemjaznA==
X-Received: by 2002:a05:6a00:22d4:b029:150:bd5d:ce11 with SMTP id f20-20020a056a0022d4b0290150bd5dce11mr4598153pfj.38.1600788511873;
        Tue, 22 Sep 2020 08:28:31 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id gj16sm2685755pjb.13.2020.09.22.08.28.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 08:28:31 -0700 (PDT)
Date:   Tue, 22 Sep 2020 23:28:21 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4 1/2] xfs: avoid LR buffer overrun due to crafted h_len
Message-ID: <20200922152821.GA25645@xiangao.remote.csb>
References: <20200917051341.9811-1-hsiangkao@redhat.com>
 <20200917051341.9811-2-hsiangkao@redhat.com>
 <20200922152212.GB2175303@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200922152212.GB2175303@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Brian,

On Tue, Sep 22, 2020 at 11:22:12AM -0400, Brian Foster wrote:
> On Thu, Sep 17, 2020 at 01:13:40PM +0800, Gao Xiang wrote:
> > Currently, crafted h_len has been blocked for the log
> > header of the tail block in commit a70f9fe52daa ("xfs:
> > detect and handle invalid iclog size set by mkfs").
> > 
> > However, each log record could still have crafted h_len
> > and cause log record buffer overrun. So let's check
> > h_len vs buffer size for each log record as well.
> > 
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > ---
> > v3: https://lore.kernel.org/r/20200904082516.31205-2-hsiangkao@redhat.com
> > 
> > changes since v3:
> >  - drop exception comment to avoid confusion (Brian);
> >  - check rhead->hlen vs buffer size to address
> >    the harmful overflow (Brian);
> > 
> > And as Brian requested previously, "Also, please test the workaround
> > case to make sure it still works as expected (if you haven't already)."
> > 
> > So I tested the vanilla/after upstream kernels with compiled xfsprogs-v4.3.0,
> > which was before mkfs fix 20fbd4593ff2 ("libxfs: format the log with
> > valid log record headers") got merged, and I generated a questionable
> > image followed by the instruction described in the related commit
> > messages with "mkfs.xfs -dsunit=512,swidth=4096 -f test.img" and
> > logprint says
> > 
> > cycle: 1        version: 2              lsn: 1,0        tail_lsn: 1,0
> > length of Log Record: 261632    prev offset: -1         num ops: 1
> > uuid: 7b84cd80-7855-4dc8-91ce-542c7d65ba99   format: little endian linux
> > h_size: 32768
> > 
> > so "length of Log Record" is overrun obviously, but I cannot reproduce
> > the described workaround case for vanilla/after kernels anymore.
> > 
> > I think the reason is due to commit 7f6aff3a29b0 ("xfs: only run torn
> > log write detection on dirty logs"), which changes the behavior
> > described in commit a70f9fe52daa8 ("xfs: detect and handle invalid
> > iclog size set by mkfs") from "all records at the head of the log
> > are verified for CRC errors" to "we can only run CRC verification
> > when the log is dirty because there's no guarantee that the log
> > data behind an unmount record is compatible with the current
> > architecture).", more details see codediff of a70f9fe52daa8.
> > 
> 
> If I follow correctly, you're saying that prior to commit 7f6aff3a29b0,
> log recovery would run a CRC pass on a clean log (with an unmount
> record) and this is where the old workaround code would kick in if the
> filesystem happened to be misformatted by mkfs. After said commit, the
> CRC pass is no longer run unless the log is dirty (for arch
> compatibility reasons), so we fall into the xlog_check_unmount_rec()
> path that does some careful (presumably arch agnostic) detection of a
> clean/dirty log based on whether the record just behind the head has a
> single unmount transaction. This function already uses h_len properly
> and only reads a single log block to determine whether the target is an
> unmount record, so doesn't have the same overflow risk as a full
> recovery pass.
> 
> Am I following that correctly? If so, the patch otherwise looks
> reasonable to me:

Yeah, that is what I was trying to say. Thanks for the review!

Thanks,
Gao Xiang

> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> > The timeline seems to be:
> >  https://lore.kernel.org/r/1447342648-40012-1-git-send-email-bfoster@redhat.com
> >  a70f9fe52daa [PATCH v2 1/8] xfs: detect and handle invalid iclog size set by mkfs
> >  7088c4136fa1 [PATCH v2 7/8] xfs: detect and trim torn writes during log recovery
> >  https://lore.kernel.org/r/1457008798-58734-5-git-send-email-bfoster@redhat.com
> >  7f6aff3a29b0 [PATCH 4/4] xfs: only run torn log write detection on dirty logs
> > 
> > so IMHO, the workaround a70f9fe52daa would only be useful between
> > 7088c4136fa1 ~ 7f6aff3a29b0.
> > 
> > Yeah, it relates to several old kernel commits/versions, my technical
> > analysis is as above. This patch doesn't actually change the real
> > original workaround logic. Even if the workground can be removed now,
> > that should be addressed with another patch and that is quite another
> > story.
> > 
> > Kindly correct me if I'm wrong :-)
> > 
> > Thanks,
> > Gao Xiang

