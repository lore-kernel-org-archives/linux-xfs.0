Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6455AFA3740
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Oct 2022 20:41:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235717AbiJ0UlL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Oct 2022 16:41:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234377AbiJ0UlK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Oct 2022 16:41:10 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A26E35FDEF
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 13:41:08 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9so2830665pll.7
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 13:41:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kUgjOGylvwbDxK1iJYYBuJgI7zhH2dUSqSN16mKnNB8=;
        b=4Y6fFnE3B8ATnUt8coB9U/F0hUg0BnYJUeBEuRXPd4ZIhWg/EWs2dfxOJzs4YMO9K3
         49kqh4ribWmezKYua0FBpw8N3nkHjqosle4eeZkKgfzgj/aBoFBgqYZeshT8rctjOWGt
         M7vuPD77QthKXxOcKZ6Y0Awm7uEUazFnBnpYLsQsuKi8tUpVmxbpsNe/zNm5SfHw2h/G
         BGZqF6tToKB6/e1G+ZQ3rdLIBgjBJCQFjaqlbwXAGSXaC4wowMicTFffmSzkBOevjjvd
         BsEY2hXc+3v7/hyTTp37ALqPlW6mI689oReffmz5uHVgoa4i1KyyfypycdcIKBUDNA/9
         48pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kUgjOGylvwbDxK1iJYYBuJgI7zhH2dUSqSN16mKnNB8=;
        b=f4LsjPa2Tif/5fpMAhqGKtzPa9u8lm86KIRzcXwytDGNznXx00ILL4QocpjqI+ZWon
         cUFz33Ug4uFFulr1y5ZDDxckFtKSrrZbhb5OMuwRkxv2cT4egfufiTjpQTlO4H/10V27
         f3/KeV2GjJ3fZ0y83yQ4gr5cPtPQUKNdc7umWnQMgS8YBle0czqfhAOdTYG3pJMuAZkE
         ZSK3YGklToGj0+XwPJN1zuFA2bVYbyfUOs2lV0l3UPwFNvJdH5A8I+EEoKfiYUdbelib
         31IgBXIxTffzVPgqvV6CT6ODha3zFhGzqwjlC93sxvD1a8r5uwQJb1SN+02s3b4ls2Zs
         v5lw==
X-Gm-Message-State: ACrzQf3OstJMrpVlzM28RgspcKsu7OFZoqTpGA6s5lEV2EO9bGjd1ZR+
        Uj5pA6iMemR3crasMWLnhSFoypW1z4YpNQ==
X-Google-Smtp-Source: AMsMyM4GVuJS0jdFHRsPp3fr0S4nMNu5YbCtfiVyXJnsONAA9FSlOyvekw8x88O6c2VjSLQWSiw3NQ==
X-Received: by 2002:a17:903:41d0:b0:186:ceff:f80c with SMTP id u16-20020a17090341d000b00186cefff80cmr13335966ple.7.1666903268073;
        Thu, 27 Oct 2022 13:41:08 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id a15-20020aa795af000000b0056c08c87196sm1572271pfk.48.2022.10.27.13.41.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 13:41:07 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oo9gV-0079B2-0Y; Fri, 28 Oct 2022 07:41:03 +1100
Date:   Fri, 28 Oct 2022 07:41:03 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/12] xfs: make sure aglen never goes negative in
 xfs_refcount_adjust_extents
Message-ID: <20221027204103.GQ3600936@dread.disaster.area>
References: <166689084304.3788582.15155501738043912776.stgit@magnolia>
 <166689084901.3788582.2985638032925462213.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166689084901.3788582.2985638032925462213.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 27, 2022 at 10:14:09AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Prior to calling xfs_refcount_adjust_extents, we trimmed agbno/aglen
> such that the end of the range would not be in the middle of a refcount
> record.  If this is no longer the case, something is seriously wrong
> with the btree.  Bail out with a corruption error.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_refcount.c |   20 +++++++++++++++++---
>  1 file changed, 17 insertions(+), 3 deletions(-)

Looks reasonable - I can't see any reason why we'd want to look up
the next extent if we've already finished processing the current
range.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
