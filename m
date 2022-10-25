Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5E2CFA373E
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Oct 2022 21:35:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbiJYVfB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Oct 2022 17:35:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbiJYVfA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2022 17:35:00 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2A072ED7A
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 14:34:58 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id t10-20020a17090a4e4a00b0020af4bcae10so234097pjl.3
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 14:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/swDOW+CWUQXFyjk0kbLXa3Gq1basy+l12EwH795mFk=;
        b=se7ZOdBMemhmkAk5vClyBzPp61J1HyRqosm2AXmSHErDWieouxB1FbVHzLbVR9Z2LJ
         fCBLSqOy+MSF7crD5/fj5rirBe40wwGM6RVeLNRvqU0HKIY2xoCKd0C+nTD/5Bb6tXxm
         UzoWPH+FfNoMHCUck7uxmd8wU4s35pD7n+mlLP1WXQNe9gdT1UKTxUkLIrlZq1xY+Fe0
         FarKouXO+JUOyXdrjLt8YtOq7tE9mt4VCbEaJK6X18xQpDEnu3APHbjsBfuCh0/Qqpfz
         +rKJcUMZhqi2DezuH0sG6Qnuz89ZNvNHS1ptKzHHB9vhaj8VSQDF8uQO4qLADOk42mF1
         PzqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/swDOW+CWUQXFyjk0kbLXa3Gq1basy+l12EwH795mFk=;
        b=XbnOcx/ZtsXeMxUnw4kN257B6qkn9g57XFiMlOnKm3wgQZyezmobA4nO8zKmLpxrPi
         RE7QFPfiW1oX+4V8WF6LrxoPJluEeumezrcBkJTDF0S8fur9TlX0PDO0IyYi0Z/tOtCk
         /yULImu5T6z6s9Wp/w+uY4v00G0CuxidOY69/YJCE6wNnnosvqEwxRcUuL/r+O0Yuu/R
         Ree2BE9Q+XpJ2dM+c2IQeDozJNwMux8Z7FAKJvF1UUmB81XaLV2WFh9b54Nm1fp0qZqj
         fG8BN8qGoalAQTjws9BJO0oTaMF1ySMlGFm1+yfSl/euUftxYVvTBd/dPXBwpRWK4tn/
         qXPw==
X-Gm-Message-State: ACrzQf2nyrsl86/5jDJKxJZVqQlJkJN8A/FqSoN6YDQXzrBnXPjvPrCx
        cVkUP/syXrG6TnDc4UKJYwoeFg==
X-Google-Smtp-Source: AMsMyM4i/Hhsb/D7v8jmaFHzqm+RJU6+fF4kPLclvBBNpjCFBskytpqqU3eXVgtwWSdVlkkXm+8HGg==
X-Received: by 2002:a17:90b:2684:b0:213:8a8:b5df with SMTP id pl4-20020a17090b268400b0021308a8b5dfmr347249pjb.77.1666733698340;
        Tue, 25 Oct 2022 14:34:58 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id x19-20020aa79ad3000000b00545f5046372sm1793792pfp.208.2022.10.25.14.34.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 14:34:57 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1onRZX-006N7j-41; Wed, 26 Oct 2022 08:34:55 +1100
Date:   Wed, 26 Oct 2022 08:34:55 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] xfs: fix memcpy fortify errors in BUI log format
 copying
Message-ID: <20221025213455.GC3600936@dread.disaster.area>
References: <166664715160.2688790.16712973829093762327.stgit@magnolia>
 <166664716290.2688790.11246233896801948595.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166664716290.2688790.11246233896801948595.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 24, 2022 at 02:32:42PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Starting in 6.1, CONFIG_FORTIFY_SOURCE checks the length parameter of
> memcpy.  Unfortunately, it doesn't handle flex arrays correctly:
> 
> ------------[ cut here ]------------
> memcpy: detected field-spanning write (size 48) of single field "dst_bui_fmt" at fs/xfs/xfs_bmap_item.c:628 (size 16)
> 
> Fix this by refactoring the xfs_bui_copy_format function to handle the
> copying of the head and the flex array members separately.  While we're
> at it, fix a minor validation deficiency in the recovery function.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
