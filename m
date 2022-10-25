Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53292C38A2D
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Oct 2022 21:36:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbiJYVgr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Oct 2022 17:36:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiJYVgp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2022 17:36:45 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAD5C74CCC
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 14:36:43 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id m14-20020a17090a3f8e00b00212dab39bcdso376225pjc.0
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 14:36:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5VP4EJCcql0owQM9k/YRCwFtgXLniT2E8YErcH0GZ4Y=;
        b=XzD4TV3+C1Aw5qPhg0yVMfT25Wc3gBOsEuOo5lxGA1+xQ48IYmZforqYRR3VBlFgGf
         FO7K+IgGc7+JvVAlkB973CYYbRaWzxNexYwuS7dPwdjxU1FpcmM4/yAa83fEJkfn51mo
         h2lT9iG1vDmiYn/qfJfC+CzFUpyGwKUjIUqPG3Kf8cFsMRDLRfYUsROtyPchhqTx9oIu
         8ccuzPN8eesS4irBXZBJqCVAXm+N/JJeH6Xzw8f5bjgzhHnloZKUXBz01eB2HnmF6Cuv
         IXxeALUgQu77a2weC+18vnd+S8PZtF+oO3d/0WaGscuITIfm6BKbvymhEbv53/Ip59/M
         OtyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5VP4EJCcql0owQM9k/YRCwFtgXLniT2E8YErcH0GZ4Y=;
        b=j2T1SR3chRbGF+8gUaSFd+cgy7XhgabvqHi6bWlj5R9gTK34Hw1N90VBncm/toQzk9
         3cU7dpPsDcK2tdmj8x2G5gWNByhnD6H8RJblVPeMCtEIyrCIeTpOkYwGXzZp2PoIXWnS
         teSWL4LqiZxOrPA8a1pz3ppF38GTWOZbmGrp033mUe7AfHRxHyo9Zg5O6kRo1+PDDU/9
         o/Y1n3RhmeLqEGBMV0LZKYM5ARDQmKWwPZN9ymjdczRzzu7EfPeGP1sXq6hvfZSw2pgd
         3DIGqpKO61Fw4VQAiwvnDCc5Js+apD4ZA7APiY3Hswl9nASJaPoXwZEl25qSxugvTTCa
         G/Ag==
X-Gm-Message-State: ACrzQf2mnVsoeGvHkPdw6vpS4N8Zkc5Rn3E0KsaZM4aT3MM14V1AqmGv
        Kryif0K6COHzddQTE1qjAqaiFw==
X-Google-Smtp-Source: AMsMyM7fDG6VqUgl7LfFWgxbE1EeTZGvhYvYuwByzYp4cycIZJWfFmzi2CCSflMqScgjnKFk6b88ug==
X-Received: by 2002:a17:902:f691:b0:186:b250:9763 with SMTP id l17-20020a170902f69100b00186b2509763mr9843912plg.62.1666733803225;
        Tue, 25 Oct 2022 14:36:43 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id r2-20020a17090a454200b0020dafceec65sm50611pjm.13.2022.10.25.14.36.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 14:36:42 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1onRbD-006N96-SW; Wed, 26 Oct 2022 08:36:39 +1100
Date:   Wed, 26 Oct 2022 08:36:39 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: fix memcpy fortify errors in CUI log format
 copying
Message-ID: <20221025213639.GD3600936@dread.disaster.area>
References: <166664715160.2688790.16712973829093762327.stgit@magnolia>
 <166664716856.2688790.1609211323933786255.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166664716856.2688790.1609211323933786255.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 24, 2022 at 02:32:48PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Starting in 6.1, CONFIG_FORTIFY_SOURCE checks the length parameter of
> memcpy.  Since we're already fixing problems with BUI item copying, we
> should fix it everything else.
> 
> Refactor the xfs_cui_copy_format function to handle the copying of the
> head and the flex array members separately.  While we're at it, fix a
> minor validation deficiency in the recovery function.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

LGTM.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
