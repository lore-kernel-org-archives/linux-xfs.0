Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 268EBC4361B
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Dec 2020 11:15:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D88F723407
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Dec 2020 11:15:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727742AbgLILOr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Dec 2020 06:14:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33528 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727221AbgLILOr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Dec 2020 06:14:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607512400;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Hr4uerKv0PpxA5LK0GV/JRMmHnPWFYEQYXx6F0TZgM8=;
        b=Fwm1kkXhX78Hjp42+AOoqlgW6YLvQOoi9sp1XAq7kkMtGYIPWHewt+oh9NSLCAbYSOGzLp
        yJvnXihGYgCmUkk6hVfG7cgqTmCiDCT9+NeKXuSQfI0A8tlT5Y4m9n9uLGCDO9kvSX9AAD
        pO9MO5lTVZD6Xnjt+mSSgFCP+s+n9Ik=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-73-TJCiBdV0M3W81x77q1a3CA-1; Wed, 09 Dec 2020 06:13:17 -0500
X-MC-Unique: TJCiBdV0M3W81x77q1a3CA-1
Received: by mail-pl1-f199.google.com with SMTP id m9so627467plt.5
        for <linux-xfs@vger.kernel.org>; Wed, 09 Dec 2020 03:13:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Hr4uerKv0PpxA5LK0GV/JRMmHnPWFYEQYXx6F0TZgM8=;
        b=GHTGRaD7d76scf1tV/WWFPC7c7eK6BnRz+MOzmASOwpFtsWLVAancmC+MjH9HwcDCB
         hf/y/TJMB5poIGB4v1yEp67ArHjn/iGh0tjaZGHFa1udjgFkGT2Wlt62K6rP7sZ/ogQn
         LLjoDPQzhVepjgN0zMwU11b5ZpLtfBxRrQULtYVf8YJIPv0Gd8wKalfE/6o+1Sg0FuPO
         t7I4/4PlzgIiCdxx/Xv+P2Dk2z/YVEGim+hsMEmYlnHZAo9cuOmKShpStmpXpRFsQHUl
         WETluyKRQbp4hFnQu0yy0szBN0VKxxbLlf/N4CNU3AF31pJ/uuQLbFzmtjr8AO82lxKo
         RWnA==
X-Gm-Message-State: AOAM531oXF5HPv3XIboP9cMnwKiW4u6Bm1XpdU2uqaUr8er/PXfnXYXz
        64CLcJ/kFDBlgCpmpMstZX6jYnYvh3JD6YxojA968SXNK+h4KRUSAG2FcJ71JFRn79Ce0GJPDr4
        i2tdyebnTP7TSRTLde5Gq
X-Received: by 2002:a17:902:59d0:b029:da:69a8:11a8 with SMTP id d16-20020a17090259d0b02900da69a811a8mr1542379plj.63.1607512396330;
        Wed, 09 Dec 2020 03:13:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxRSSFR8ifiCAIhQGpMYDl7/CXYuNBLZnBQCnerSRj1SPwIM+AXd6Lz4AFYZBHZnm/zNSQ51A==
X-Received: by 2002:a17:902:59d0:b029:da:69a8:11a8 with SMTP id d16-20020a17090259d0b02900da69a811a8mr1542367plj.63.1607512396113;
        Wed, 09 Dec 2020 03:13:16 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j20sm2243905pfd.106.2020.12.09.03.13.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 03:13:15 -0800 (PST)
Date:   Wed, 9 Dec 2020 19:13:04 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH v4 3/6] xfs: move on-disk inode allocation out of
 xfs_ialloc()
Message-ID: <20201209111304.GA105731@xiangao.remote.csb>
References: <20201208122003.3158922-1-hsiangkao@redhat.com>
 <20201208122003.3158922-4-hsiangkao@redhat.com>
 <20201209075246.GA10645@lst.de>
 <20201209084342.GA83673@xiangao.remote.csb>
 <20201209102237.GA19388@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201209102237.GA19388@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 09, 2020 at 11:22:37AM +0100, Christoph Hellwig wrote:
> On Wed, Dec 09, 2020 at 04:43:42PM +0800, Gao Xiang wrote:
> > Yeah, so maybe I should revert back to the old code? not sure... Anyway,
> > I think codebase could be changed over time from a single change. Anyway,
> > I'm fine with either way. So I may hear your perference about this and send
> > out the next version (I think such cleanup can be fited in 5.11, so I can
> > base on this and do more work....)
> 
> Personally I'd prefer to just use the errno return and ipp by reference
> calling convention for the newly added helper as well.  But I'm ok with
> all variants, so maybe I should add my:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> here in case Darrick wants to pick this up.
> 
> Looking at idmapped mounts series it would really help to get this in
> ASAP to avoid conflicts.

Ok, let me send out a quick next version to get rid of that inlined
comment mentioned earlier.

Thanks,
Gao Xiang

> 

