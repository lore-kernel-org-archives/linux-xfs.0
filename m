Return-Path: <SRS0=3PXQ=AL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CC13C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 22:32:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1088920771
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 22:32:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XB7bzEmI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbgF3WcO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Jun 2020 18:32:14 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51466 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726065AbgF3WcO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jun 2020 18:32:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593556332;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uY5keVKgaEDsKqmTErd3aoqtWZOh5sba2N2Tl3xzsoc=;
        b=XB7bzEmIFpXznK7RQZ1hGTzqjBmAUHU0VO0Cnx1KOj9TM/OZiwNpGM5+W1ZG/+M2ISMXtR
        Ad7mOL5SdVp0m56r9ftupChru+iFkv8yJQYoBgjqLyIoe3LoAqQbxjvPuR2RAgiZ8qkJnS
        jQhJG5wFmrFO+RrCmwLSTkvAoXoJ5cw=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-8-6gxV1xQUP1mnArWq6AFOQw-1; Tue, 30 Jun 2020 18:32:11 -0400
X-MC-Unique: 6gxV1xQUP1mnArWq6AFOQw-1
Received: by mail-pg1-f197.google.com with SMTP id 75so12599162pga.20
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:32:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=uY5keVKgaEDsKqmTErd3aoqtWZOh5sba2N2Tl3xzsoc=;
        b=XTrwhEs1Yk1ylPYC+Pu0BZl3vDn5yP+mXgwiZDikPnVksPaXIDjWRWoMRgbDbvH4t6
         b8B9siHN1IQbpljWOxBaPhFILA1lGk+NWMRrWxOEZUOtGH7JdcS86fuoZaclOSFhSSqQ
         L5IL1GV+e1CvEmkAwZ77OLsa27x2bRheCo9s5vV05YMEdfi1i5y52JD/ISaa7V5E1I/u
         v1XzR7Os0Yg83E271MhctTsUshRY/zdrRAaBX7WmtjK75oo672JPEiXoZBhYsYk5NCEb
         wh/+r/SaluVukjyA97yD/4j2rHN/R7PZdbZFP+QEf8mJzyw7myrqomGp9eakSEixzZFP
         pN/Q==
X-Gm-Message-State: AOAM532qG7ZzU33bmfYe0qhN42ssZes127jkkGTzNTY6R3tZVRjUdpds
        eKhzEoqG1Agp6SlKjohBY7lXA+3n0wRO6JSZSb/8lyr838TFw5uEjicBJJ/JdYjb+mkDNQpGA2q
        fHz4WpgiG32k3FmBOwNN/
X-Received: by 2002:a63:7e55:: with SMTP id o21mr17282449pgn.263.1593556329903;
        Tue, 30 Jun 2020 15:32:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx2Lm2A1fOFzFm7ABeDETsnhdPNTcSCwl+RjKsDiOAR50FH2JZU9Nb566BJm0Zbdu1MYVE9tA==
X-Received: by 2002:a63:7e55:: with SMTP id o21mr17282430pgn.263.1593556329635;
        Tue, 30 Jun 2020 15:32:09 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 129sm3655581pfv.161.2020.06.30.15.32.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 15:32:09 -0700 (PDT)
Date:   Wed, 1 Jul 2020 06:31:59 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: introduce inode unlink log item
Message-ID: <20200630223159.GA10152@xiangao.remote.csb>
References: <20200623095015.1934171-1-david@fromorbit.com>
 <20200623095015.1934171-5-david@fromorbit.com>
 <20200630181942.GP7606@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200630181942.GP7606@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 30, 2020 at 11:19:42AM -0700, Darrick J. Wong wrote:
> On Tue, Jun 23, 2020 at 07:50:15PM +1000, Dave Chinner wrote:

...

> > +
> > +static uint64_t
> > +xfs_iunlink_item_sort(
> > +	struct xfs_log_item	*lip)
> > +{
> > +	return IUL_ITEM(lip)->iu_ino;
> > +}
> 
> Oh, I see, ->iop_sort is supposed to return a sorting key for each log
> item so that we can reorder the iunlink items to take locks in the
> correct order.

Yes, so I'm not sure the naming of ->iop_sort... When I first saw the name,
I thought it would be a compare function. (but after I read the code of
xfs_trans_precommit_sort(), I found I'm wrong...)

