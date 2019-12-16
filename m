Return-Path: <SRS0=k6ZN=2G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDA5AC2D0CF
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Dec 2019 09:42:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92C21206D7
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Dec 2019 09:42:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c0k+W7s9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbfLPJmv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Dec 2019 04:42:51 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36537 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726960AbfLPJmu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Dec 2019 04:42:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576489369;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PLOJSgxmsG/vwmr/XKvFZuadZb/u0y1IL2k3SEvyKMo=;
        b=c0k+W7s9FTrCZ8/Jz9N3eowIzLjIil/th6Dk2iwGW/2iEQ5nO1U1NBss8VRM1BjHbtKS1m
        nlEBvFrd66Bzu3BTG2XiLftAueFBE7K7GdZ9DsahH429n/TWaJQWUE8EOumLq0fVfjKWtD
        YSxvQVddG0WuJ6FyCbw8DTaEYAK9aRA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-112-aCeHEZKJOxqmZFYD_iRR0w-1; Mon, 16 Dec 2019 04:42:46 -0500
X-MC-Unique: aCeHEZKJOxqmZFYD_iRR0w-1
Received: by mail-wr1-f70.google.com with SMTP id i9so3474610wru.1
        for <linux-xfs@vger.kernel.org>; Mon, 16 Dec 2019 01:42:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=PLOJSgxmsG/vwmr/XKvFZuadZb/u0y1IL2k3SEvyKMo=;
        b=qq/bfDfygg0ovcOj6frBEm8gldXvNaI+jELGpZXwt6YY4EKbWo+w+Zm1fEfHJbpuvQ
         FVzA/TQJILqjNVtbQWLKSlXHsmWRDszDvMXL4bsK0lZB54RoBo9SaDUp6MtUnt/fKeMI
         +YB/AwVWXrOqeyVU7YbS3L2RvdCA2U6z7naXZZPIT8oNBksSbj4AL3LbRf+3pYP02HnK
         /jM4/5oGOTxs8XU3BLQKHf102kOB7UTGUYN5/WuZ1LPuPbLRyl2mBLR5iycg9qYwGN7J
         Icxqm90L7jxF1hI5b1w892aG/8SGSZwYA7MGqBJQLyrE2NpZjt8PWqbxMd2NNZMJ5P+1
         6WZA==
X-Gm-Message-State: APjAAAXHtq++pAIIusWYQ3lm173Gf97BqotP5TLnSwVBSegWQmsvi+yD
        X37ZyCcMV9qtkTmV9xlI52Jr4AnBkOYlzJIH+aUF16a5Ol6r7aeDDmJ7ZxsbOKoxcDg56ptIGoA
        JRL5A5VLNlJNqb1dFBtzu
X-Received: by 2002:adf:dd51:: with SMTP id u17mr28111574wrm.290.1576489364708;
        Mon, 16 Dec 2019 01:42:44 -0800 (PST)
X-Google-Smtp-Source: APXvYqxBxzsNATZPWJc3uk0zp7X8ophdeSod0wFuhF1JWy4sxQpftv9ASjpAJ53OCFpT5DdEjlUB1Q==
X-Received: by 2002:adf:dd51:: with SMTP id u17mr28111561wrm.290.1576489364558;
        Mon, 16 Dec 2019 01:42:44 -0800 (PST)
Received: from orion.redhat.com (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id t190sm12026503wmt.44.2019.12.16.01.42.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 01:42:43 -0800 (PST)
Date:   Mon, 16 Dec 2019 10:42:41 +0100
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/2] New zonefs file system
Message-ID: <20191216094241.til4qae4ihzi7ors@orion.redhat.com>
Mail-Followup-To: "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
References: <20191212183816.102402-1-damien.lemoal@wdc.com>
 <29fb138e-e9e5-5905-5422-4454c956e685@metux.net>
 <20191216093557.2vackj7qakk2jngd@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191216093557.2vackj7qakk2jngd@orion>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Dec 16, 2019 at 10:36:00AM +0100, Carlos Maiolino wrote:
> On Mon, Dec 16, 2019 at 09:18:23AM +0100, Enrico Weigelt, metux IT consult wrote:
> > On 12.12.19 19:38, Damien Le Moal wrote:
> > 
> > Hi,
> > 
> > > zonefs is a very simple file system exposing each zone of a zoned block
> > > device as a file. Unlike a regular file system with zoned block device
> > > support (e.g. f2fs or the on-going btrfs effort), zonefs does not hide
> > > the sequential write constraint of zoned block devices to the user.
> > 
> > Just curious: what's the exact definition of "zoned" here ?
> > Something like partitions ?
> 
> Zones inside a SMR HDD.
> 

Btw, Zoned devices concept are not limited on HDDs only. I'm not sure now if the
patchset itself also targets SMR devices or is more focused on Zoned SDDs, but
well, the limitation where each zone can only be written sequentially still
applies.


-- 
Carlos

