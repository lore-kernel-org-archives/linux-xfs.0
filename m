Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB0F4ECAAA1
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Oct 2022 21:24:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236620AbiJ0VYd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Oct 2022 17:24:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236142AbiJ0VYc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Oct 2022 17:24:32 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E252DEA
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 14:24:29 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id h14so2855935pjv.4
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 14:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cit7NSDAWzGNARJsON0lSlFEhFhuyFmU5c48LsH7tNo=;
        b=38/UYMedG7nvvUSOdxWV/s3LUaXTT3prdbBH5uk3ogIqLUa+SQDsY7nS7pXeq1l1C2
         oJbuNfKX0cixHqBAq4OfxILSxBuphkoNwjXaXtGGVMcHNC4OsBMVLWfRmHC0IAPkSxa/
         4VQfoMzrcoLdKjTnuPX0qGzLDOl5UHAdT2HV/T5p3iUzl3AekZzH7JhCBZFfAKv4e19l
         NE4uaFHo9lZlgmPooJul6uHAE7bZDxq3BTuJ/PiUKN3wNH2hD0c3a/G6wT8g1VyhBDyX
         haVmf6ka8vP4O96+RtnK++rXY0lFZ+lSPstK4YC8yfPvVBkRB01ZE/z2d2sJaMHBfROj
         Y0PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cit7NSDAWzGNARJsON0lSlFEhFhuyFmU5c48LsH7tNo=;
        b=Q78Tid7sZuLvjo49t8hEwwYZfAnh5/wHMB/2u/eOS/tGtl5kap3NtfS+jTExfSLJ5+
         OjSLgwYNPfllpzZYN3mNGAq753bjvMHxS6UekuN1ZMqK1JohCszzWO4EXFGAm7aBp7la
         SBVKq7EuHhZ43gTaD0KZ4ufe8cjzwoqccFRO5CQsVeEcmx6w8OSuFGBHAdEV22ckAPTH
         vZabmwH7CfDK9irQK7A/p8i6x28OsoFmo2OKu/17Y5aoT8zS+Ogdus4G0fOUp1JZI4lQ
         RnhMjux0l1q0MZD//uCwdSBClEhcNzApS9TGXqeOz/2HfTivEpTUR/c6xZDbzjXbK/BZ
         RAng==
X-Gm-Message-State: ACrzQf37/AJSSjlfW45CUmWUXSDW2XI9jaJ1cpaP8WpVruJ3QslblaNV
        65c3ty8YZgeYuEWhoiJpLhIdb6Y+fL7nXA==
X-Google-Smtp-Source: AMsMyM4sT0472uC+l03zst+obwg8MaCo+sJ3Y9QXJbQdubm8ejd0yJUDEb6mdYB+OVY7tO8YtxFKvg==
X-Received: by 2002:a17:902:e74f:b0:186:a981:2334 with SMTP id p15-20020a170902e74f00b00186a9812334mr22875621plf.88.1666905868974;
        Thu, 27 Oct 2022 14:24:28 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id s17-20020a17090a881100b0020b7de675a4sm1375032pjn.41.2022.10.27.14.24.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 14:24:28 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ooAMT-0079on-Le; Fri, 28 Oct 2022 08:24:25 +1100
Date:   Fri, 28 Oct 2022 08:24:25 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/12] xfs: fix uninitialized list head in struct
 xfs_refcount_recovery
Message-ID: <20221027212425.GY3600936@dread.disaster.area>
References: <166689084304.3788582.15155501738043912776.stgit@magnolia>
 <166689090501.3788582.3070018636850468687.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166689090501.3788582.3070018636850468687.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 27, 2022 at 10:15:05AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> We're supposed to initialize the list head of an object before adding it
> to another list.  Fix that, and stop using the kmem_{alloc,free} calls
> from the Irix days.
> 
> Fixes: 174edb0e46e5 ("xfs: store in-progress CoW allocations in the refcount btree")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_refcount.c |   10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
