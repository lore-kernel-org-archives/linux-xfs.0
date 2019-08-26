Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BF37C3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 10:24:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDE382070B
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 10:24:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KIW4NnVK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729813AbfHZKX7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 06:23:59 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35319 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729713AbfHZKX7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 06:23:59 -0400
Received: by mail-pf1-f193.google.com with SMTP id d85so11534924pfd.2
        for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2019 03:23:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=f7BpKMzYiwVLYbz1/seN/OFx2QZ12+MnpHVjgj+/bSw=;
        b=KIW4NnVKAmc+nPoHhhRSTl3nsY2cbnbjod6jLjwuBGTF6axLB5kNr3NTKt2IBY8KQa
         m0/GGPDT7OK5nYiyRsPDvHrS4/Sd0Xc4EDwZaMrxUnJP+LE7nwbNZ0ZUYmOU2ixQVZSn
         fg37hgDMx0vPk7MNO19MkuM6I2oJiHagoKH1rBOvAvjmstI+UC7HAac+P2EnOIrBWKvo
         MxpiR1EB7sqgt+cmleHxRwO9aa027knNr+YzRu6TmrZvg6U9f/kIWUS2JOXLo1VHFLWW
         RU7q7PkGo+Yj8XZ7WyOzoC1wGOPXODknthvLXw5eYfBXNgh6gB8YCQdvrKgloAe8W6bE
         ZHgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=f7BpKMzYiwVLYbz1/seN/OFx2QZ12+MnpHVjgj+/bSw=;
        b=cAtx7n3U75QVNjnJLtmqIif2nsLc85+BFGzI+IzUXKf1byQ5VNtPGSXl5kQMc4B6Az
         GuqlwPr3ZHAhcETtPqRmE4rJGnzPAf0SSu9z/Iq2JFHWtJLRSE1wjlEEM0GF/jxAUevh
         vMBu9KtL0Fnox7vEaEC1u2GPM3QOVswRN83ZPr8J8N7zdXtgs+7zCZ+TdIF4EMQQ13Ph
         +MWkLjUMidvc+KDvscbnKUfRc2oLasSa59Ozo84pXqXdWnXPgJ/4kZ7s2D8MGz0jNHCs
         +HOj579OwQR69zEGjT9vXMzCwWtC5MP1zmbv39p7bsm5q2ZpW3HoL63IbxUswmjo/YRU
         M+Rg==
X-Gm-Message-State: APjAAAXOyFKThuPS0Oc4fBxcCSpoyFPURkc5BqPku09RyXN8hoC3ZN0F
        PaJceH9yPXcbU32/pV+AbrsMO8zD
X-Google-Smtp-Source: APXvYqxKJDDmCXs+kHf9MC1wf6AWHfxC9uafSwv/R+bqhUUvvcQP5cQ5bxf0fPAZiOx05u6fppdroA==
X-Received: by 2002:a62:5207:: with SMTP id g7mr19682180pfb.152.1566815038755;
        Mon, 26 Aug 2019 03:23:58 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w2sm11617416pjr.27.2019.08.26.03.23.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Aug 2019 03:23:58 -0700 (PDT)
Date:   Mon, 26 Aug 2019 18:23:50 +0800
From:   Murphy Zhou <jencce.kernel@gmail.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Murphy Zhou <jencce.kernel@gmail.com>, linux-xfs@vger.kernel.org,
        darrick.wong@oracle.com
Subject: Re: [PATCH] xfsdump: fix compiling errors due to typedef removal in
 xfsprogs
Message-ID: <20190826102350.h3rbysb63ojslkb5@XZHOUW.usersys.redhat.com>
References: <20190826050130.eqzxbotjlblckmgu@XZHOUW.usersys.redhat.com>
 <20190826095253.GA1260@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190826095253.GA1260@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 26, 2019 at 02:52:53AM -0700, Christoph Hellwig wrote:
> On Mon, Aug 26, 2019 at 01:01:30PM +0800, Murphy Zhou wrote:
> > Since xfsprogs commit
> >   32dd7d9c xfs: remove various bulk request typedef usage
> > 
> > Some typedef _t types have been removed, so did in header files.
> 
> I wonder if we need to add them back to xfsprogs to not break other
> tools using the header.  But independent of that I think killing
> them in xfsdump is good.
> 
> >  typedef char *(*gwbfp_t)(void *contextp, size_t wantedsz, size_t *szp);
> >  typedef int (*wfp_t)(void *contextp, char *bufp, size_t bufsz);
> > +typedef struct xfs_bstat xfs_bstat_t;
> > +typedef struct xfs_inogrp xfs_inogrp_t;
> > +typedef struct xfs_fsop_bulkreq xfs_fsop_bulkreq_t;
> 
> I think we just need to stop using the typedefs, as this would break
> a compile with the old xfsprogs headers.

So we need to add typedefs back to xfsprogs to not breaking others.
And kill it in xfsdump.

Are there tools using xfsdump's libs and headers ? Breaking them?

Thanks,
m
