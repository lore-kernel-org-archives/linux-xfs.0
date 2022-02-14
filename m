Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A132AC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Feb 2022 14:43:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355276AbiBNOni (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Feb 2022 09:43:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355272AbiBNOne (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Feb 2022 09:43:34 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B39B64A907
        for <linux-xfs@vger.kernel.org>; Mon, 14 Feb 2022 06:43:24 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id k1so27233781wrd.8
        for <linux-xfs@vger.kernel.org>; Mon, 14 Feb 2022 06:43:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=8k2aplyYI1OYSbtp/sgTQSaIuXBRyilQhTxzdkcz5oM=;
        b=Kc2NhjEECM3Ike+mng8fkAJ0mNxNc5SBRyB1PT/O3H3V73wWQu3kwBEGUi5ElHSAO6
         q/catBw7mYZcPXvpUSNGnDCmFkfOprjpwGMz6wSXWiaoqXAACWp7PtLen87Y+bonxIN1
         43L0PWcSripPNaWQR0fPqEBkHOT6yEI9uerxrKLq7QvgKav7FpvSEmgITr/+K7GNiY7B
         iGv1xfjWwKDDpaeAFwxKWhda453SESLLxjeVVCBBsqVXsGNJhNOf5ctlwJ+geYh8BJzm
         +M1D4w1q9VU+f7mXbY+O6oCCD3RJ0jSdWtuGak4JKBjXo3YRHbJI8Le+vdXU7RVyZi3f
         3Vdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=8k2aplyYI1OYSbtp/sgTQSaIuXBRyilQhTxzdkcz5oM=;
        b=JKEhbRGv14VSieUe9jAme+Q3LK8zuONC0swn/dIKCNnfYJZPsKXWpSusxBeMDTwP7W
         o8m3WmOvBkC9i/ZT8P57ml+6LbGqfsOp+7RK3NGAbq0ydON73kqQufrMPbHVJt9ZeB3/
         52zZjpZor3tpgh0NWnidBcC73gyvC2Qn1YbO1hLCFOsWeZeGKTt9GzpRbX98qX0hpWMb
         7Icdpjq/6rXVTDDafs6bZC4rQXr2e/fyQplxvioAxyK9Yo4hm0SjyXB5vZD3hjVbCaH7
         Xrstxp+j+5/oMbX+8UesaADw+8W07rQ+cMJuX1mwHqxrmNaG5fDECnnKl1F5FvpsTSpK
         Ouaw==
X-Gm-Message-State: AOAM530S9UsR23rLlwUZ6mFWxKmElUibakVu9KGuYrphV6uSXZpU+M42
        gsmOgrBVIu7GWSC1rKw82Kl9Qg==
X-Google-Smtp-Source: ABdhPJw7yRUYoEyGu9ey4dIfTWZqAtG97B1/NFiN85MQVuWJ6su5QCeF3PBi//ZfG99hTeOE+wDSOA==
X-Received: by 2002:a5d:52c9:: with SMTP id r9mr11422010wrv.449.1644849803276;
        Mon, 14 Feb 2022 06:43:23 -0800 (PST)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id o16sm12358972wmc.25.2022.02.14.06.43.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Feb 2022 06:43:22 -0800 (PST)
Date:   Mon, 14 Feb 2022 14:43:20 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>,
        linux-kernel@vger.kernel.org, Stable <stable@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Bob Peterson <rpeterso@redhat.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Johannes Thumshirn <jth@kernel.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        cluster-devel@redhat.com,
        syzbot+0ed9f769264276638893@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/1] Revert "iomap: fall back to buffered writes for
 invalidation failures"
Message-ID: <YgpqiG7fvX7pHEHO@google.com>
References: <20220209085243.3136536-1-lee.jones@linaro.org>
 <20220210045911.GF8338@magnolia>
 <YgTl2Lm9Vk50WNSj@google.com>
 <YgZ0lyr91jw6JaHg@casper.infradead.org>
 <YgowAl01rq5A8Sil@google.com>
 <20220214134206.GA29930@lst.de>
 <YgpjIustbUeRqvR2@google.com>
 <YgpmN/R7jAf97PBU@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YgpmN/R7jAf97PBU@casper.infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, 14 Feb 2022, Matthew Wilcox wrote:
> On Mon, Feb 14, 2022 at 02:11:46PM +0000, Lee Jones wrote:
> > On Mon, 14 Feb 2022, Christoph Hellwig wrote:
> > 
> > > Let me repeat myself:  Please send a proper bug report to the linux-ext4
> > > list.  Thanks!
> > 
> > Okay, so it is valid.  Question answered, thanks.
> > 
> > I still believe that I am unqualified to attempt to debug this myself.
> 
> Nobody's asking you to debug it yourself.

Not meaning to drag this out any longer than is absolutely necessary,
but that's exactly what I was asked to do.

I fully appreciate how complex this subsystem is and am aware of my
inadequacy in the area.

> instead of wasting everybody's time.

That was never the intention.

> We're asking you to file a clear bug report

No problem.  Will comply.

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
