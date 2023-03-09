Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79D84C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Mar 2023 23:59:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbjCIX7w (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Mar 2023 18:59:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231350AbjCIX7g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Mar 2023 18:59:36 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F0F4E4C68
        for <linux-xfs@vger.kernel.org>; Thu,  9 Mar 2023 15:59:32 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id ay18so2628890pfb.2
        for <linux-xfs@vger.kernel.org>; Thu, 09 Mar 2023 15:59:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112; t=1678406372;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bZVvjfo6uU2hR80RdY2enLWnm5TDtS6rK5HNYnwsp4M=;
        b=2d3MdEbVx5GpIXtCckuik5+bqlvp6o3aqJunDGgE3IKrgJkMgVQiTzp+eZ22iuBihF
         rGmpMOOwhZnT77wYQ6DfC6VJOahsfIeTGDsrOpp8BM3boIV9AhMLFZh47GN+sQyJl7O7
         e4rS1BXMxPsf7KIZIySkgJBW+/wj0Qcv+Fsp/ujv8L2KUs/N5IQbJi4rCxBruzlcl2g/
         Rn3Kl6At5rTPEgEwLPRqR+FdRfHJaypl2OqOdkHQFsqW6zLuzqlai6cpc3FQJ+HOEAvl
         Fk8Zm5PA/ZLRF8AWFfQSJ8eWdX5fiK1kES5xCigowzL7HR8dvqCwSJ99OF4nKW9is7aL
         8Zcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678406372;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bZVvjfo6uU2hR80RdY2enLWnm5TDtS6rK5HNYnwsp4M=;
        b=TDeM9Yg+ISDDU+49o/yNdUoBUWKy/7Xx4TFFroOLqbu/E8h2TZG28oq4Zi9Eoahi/g
         SlT8tM2a573S4j1CGCV8Wk63ihDQfJRjaTsqEV37sVRKdEzZR9ThzNYk0Y3mt7K+g+BX
         6xi8JiRoct8r4I+B18t4OGN8L0GzUHKJpRn5KH8hbXUBjH4AXsnifSDzvAsOBjYUkV1W
         PwJJ+OPi27cXEJ6vk8eT1nUt1J21ncRlMCOMhvASVKtT/SNXwlaKt5Xu6W9gsQD+39yU
         GecivFHmJ6PwyWazmNIUCK1ZJn94koePK8AftQIjoQblz7DAup/b2afUbwGToHFv81b3
         y9PQ==
X-Gm-Message-State: AO0yUKU8m026cmYPi+ZbDlwrf5yTAUGt/0AJ/Gs8obOzQ3OTveG/u7kG
        2nkvOomaKpOsSEz+tYHAYAVL0x2N7slNdjQLrlQ=
X-Google-Smtp-Source: AK7set976H0oXvHcXJFmxN4i9xqgaUTvGYnYtyZixPvYFYtykQs25575MBp1Ipy9RvKJWuk8wM/qgw==
X-Received: by 2002:aa7:9f1a:0:b0:5dc:2de8:f500 with SMTP id g26-20020aa79f1a000000b005dc2de8f500mr16773545pfr.22.1678406372016;
        Thu, 09 Mar 2023 15:59:32 -0800 (PST)
Received: from dread.disaster.area (pa49-186-4-237.pa.vic.optusnet.com.au. [49.186.4.237])
        by smtp.gmail.com with ESMTPSA id a16-20020aa78650000000b005a8b4dcd21asm150745pfo.15.2023.03.09.15.59.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 15:59:31 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1paQAS-006sLX-B9; Fri, 10 Mar 2023 10:59:28 +1100
Date:   Fri, 10 Mar 2023 10:59:28 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: try to idiot-proof the allocators
Message-ID: <20230309235928.GN360264@dread.disaster.area>
References: <20230309201430.GE1637786@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230309201430.GE1637786@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 09, 2023 at 12:14:30PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> In porting his development branch to 6.3-rc1, yours truly has
> repeatedly screwed up the args->pag being fed to the xfs_alloc_vextent*
> functions.  Add some debugging assertions to test the preconditions
> required of the callers.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_alloc.c |   13 +++++++++++++
>  1 file changed, 13 insertions(+)

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
