Return-Path: <SRS0=6LQP=Z3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91AB7C43603
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Dec 2019 19:23:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6560C206D9
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Dec 2019 19:23:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="XYRLUYih"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729594AbfLETXl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Dec 2019 14:23:41 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43298 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbfLETXk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Dec 2019 14:23:40 -0500
Received: by mail-pg1-f195.google.com with SMTP id b1so2033483pgq.10
        for <linux-xfs@vger.kernel.org>; Thu, 05 Dec 2019 11:23:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zdC5gAzCSfOtyHzf99Ulg/6lFps+h4gMB5ow8dqQ7KU=;
        b=XYRLUYihNPnHatI1VVXIXk1o0F9cTvWSzte3Xd7sKrB9J3ii7QaM6zZUmqPVr3C86s
         bNdm1UXdPz4Z7PV3/+wpyaJUgSegej18VAwJ+oIwnMnJqCL1fYHWwAe8ZNFKLR3z1dTv
         xiAKetwl7snMncZnMbYdh7VStpmhCFUGQoBBJ94sbIXxrwkefUQzyXUXg8QX0OMyv3Zi
         YjOuGJUj5z/6EWKVA2TBanYDfY7MROc0sRBAzLJWLpOcs0n70Z9Kc4HyEklAQ/e5hx7G
         lSjzJDGmxHk2EGc59b7af1lllA8NaVV1qeyfRk21UFl66MrVWyxuWyIHYkRmMrID1Fae
         BJeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zdC5gAzCSfOtyHzf99Ulg/6lFps+h4gMB5ow8dqQ7KU=;
        b=dYM6jAu79LrPxFFFD/FVYhhfv9nv8lVjJMNFYdc8TpcBgFNS3m/BfCDHDxBptOyJoU
         3+rLvv8raJr9Ae+X50jbh6DMbgUmypW95E4Ux1xyTdkmpzvoutFztCKlRlNi9uk/HkAn
         Azzz6XE5jwMbN6rMl7mf1aLdM9GYPrcy7MfGAZnctyWlBTi5Y93uuRp1ZUUemXD35TFX
         /iWRXd9GTGT6uUaKbpfVKPGX0B/YC7DoRv+BFjm/reTfJCedbUVW0I90qBll1hukaEGW
         9wb3hFFbWQ9YmD8v74ixWFWDU7koK+BRUBNzm6TMl+/PahLCHhZmdqdUFLgNR+yYBYUM
         OLyg==
X-Gm-Message-State: APjAAAU4U4u2e7OxKa7NLs2np0PYmM7DfVBk6FO5sA7vu8KOkV8GvSBO
        1HxxvOa1goYv8pP7t55dD9UZzg==
X-Google-Smtp-Source: APXvYqxtjnJVgtxn/D3I0cEW74V7zRpo3M3cE/NQLR4KEfZLaVh3oZkyxDHrNS7nLYSQKRFwLIqlAw==
X-Received: by 2002:aa7:9306:: with SMTP id 6mr10394274pfj.159.1575573818638;
        Thu, 05 Dec 2019 11:23:38 -0800 (PST)
Received: from vader ([2620:10d:c090:200::3:cb2])
        by smtp.gmail.com with ESMTPSA id a2sm14160047pfg.90.2019.12.05.11.23.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2019 11:23:38 -0800 (PST)
Date:   Thu, 5 Dec 2019 11:23:37 -0800
From:   Omar Sandoval <osandov@osandov.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix log reservation overflows when allocating large
 rt extents
Message-ID: <20191205192337.GC18377@vader>
References: <20191204163809.GP7335@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191204163809.GP7335@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 04, 2019 at 08:38:09AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Omar Sandoval reported that a 4G fallocate on the realtime device causes
> filesystem shutdowns due to a log reservation overflow that happens when
> we log the rtbitmap updates.  Factor rtbitmap/rtsummary updates into the
> the tr_write and tr_itruncate log reservation calculation.
> 
> "The following reproducer results in a transaction log overrun warning
> for me:
> 
>     mkfs.xfs -f -r rtdev=/dev/vdc -d rtinherit=1 -m reflink=0 /dev/vdb
>     mount -o rtdev=/dev/vdc /dev/vdb /mnt
>     fallocate -l 4G /mnt/foo
> 
> Reported-by: Omar Sandoval <osandov@osandov.com>

This one works, as well. Thanks!

Reported-and-tested-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_trans_resv.c |   96 ++++++++++++++++++++++++++++++++--------
>  1 file changed, 77 insertions(+), 19 deletions(-)
