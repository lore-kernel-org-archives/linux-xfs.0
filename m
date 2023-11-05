Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78670C4332F
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Nov 2023 22:51:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbjKEWvL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 5 Nov 2023 17:51:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjKEWvK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 5 Nov 2023 17:51:10 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1A05CF
        for <linux-xfs@vger.kernel.org>; Sun,  5 Nov 2023 14:51:07 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-6c311ca94b4so3252432b3a.3
        for <linux-xfs@vger.kernel.org>; Sun, 05 Nov 2023 14:51:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1699224667; x=1699829467; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7vNXoox4uqbay8CKNkRYquduf3SgzTPT/+RF4OQWlUM=;
        b=NkOesvzJmY0/fIzujl/0Ts4hP0sQPGMnSn7tixOwbZtZvu1A/gtvU4pQhOzkr0WOEc
         mruDN6pev102hebXaCj0/bbjNIMVtvka+phlwrA0oZf5mtQv6yEIgx5TKrqm5Zy49mxf
         GRpn9IahknZ+RI3E44JuuZOk32H19MZk3+O+9Yam7unMpvBaQqSDKIKZkrulwnwIUOs7
         iYBHgugI0MyyXEz0Hq/iJIIFReeYuO+54fcRbfR2VBWwcfg0iENxHydMpPMTMTWsjhV4
         XPrWBssJ91BIK5RO2RnQTCsjxEZ5na9U1Edh1J2toDfO74ehq6//Wn01uclLBUb9dvX3
         8wSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699224667; x=1699829467;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7vNXoox4uqbay8CKNkRYquduf3SgzTPT/+RF4OQWlUM=;
        b=pAmzaGVzv/WfGRkzAYh2rsi5xn/emFx7B1hNQtXuZAIBdoqkWeOASnI52wTla5g6H2
         kFP7lRVFMTToaj4cUU0YNGYF53QVxJoX7eKvEFeZgOdOF/m3EElh7gX+0PQmaQpP0OtT
         m6fjH3dE5M2Z5njFLT524k9dThg3r0WvfTJ5qPoR5J7dffQMw3gFDQmJoY0bMLqY+zMW
         9niBo+5mJVvTSwoqpsZhqIVs0Z5Im93ldEJKJSfr09OkYJQTXLK1/vCCP4q37cVmAKbo
         hbldt6BLo9C6CgIQ/zZpyi6CAc7GaTMQ3XLc8HCAUGDNjuHDVD9r1DiKTsq4SttrYQZM
         MQGQ==
X-Gm-Message-State: AOJu0YywBv+SRObZJi4zXstb0qxl4bFKbm8fT+PA9u6x/he90FxHGhFD
        UxDD6r2i1n9bkhvkVo/s7tQhOW9L0s0lftghYD4=
X-Google-Smtp-Source: AGHT+IEa6P5WtgVOD+eHWjJBZzSHvs/BjrY+P7Cxn4jKOEIojWOLZ/ME329BslzbRh8Jh9nL4gq9cg==
X-Received: by 2002:a05:6a20:12c4:b0:154:bfaf:a710 with SMTP id v4-20020a056a2012c400b00154bfafa710mr26971403pzg.41.1699224667460;
        Sun, 05 Nov 2023 14:51:07 -0800 (PST)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id t13-20020a170902e84d00b001bb3beb2bc6sm4578326plg.65.2023.11.05.14.51.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Nov 2023 14:51:06 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qzlxQ-008jJ1-1w;
        Mon, 06 Nov 2023 09:51:04 +1100
Date:   Mon, 6 Nov 2023 09:51:04 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Anthony Iliopoulos <ailiop@suse.com>
Cc:     linux-xfs@vger.kernel.org,
        Holger =?iso-8859-1?Q?Hoffst=E4tte?= 
        <holger@applied-asynchrony.com>
Subject: Re: [PATCH] xfs: fix again select in kconfig XFS_ONLINE_SCRUB_STATS
Message-ID: <ZUgcWM5q06w4l+/X@dread.disaster.area>
References: <20231105192318.121783-1-ailiop@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231105192318.121783-1-ailiop@suse.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Nov 05, 2023 at 08:23:18PM +0100, Anthony Iliopoulos wrote:
> Commit 57c0f4a8ea3a attempted to fix the select in the kconfig entry
> XFS_ONLINE_SCRUB_STATS by selecting XFS_DEBUG, but the original
> intention was to select DEBUG_FS, since the feature relies on debugfs to
> export the related scrub statistics.
> 
> Fixes: 57c0f4a8ea3a ("xfs: fix select in config XFS_ONLINE_SCRUB_STATS")
> 
> Reported-by: Holger Hoffstätte <holger@applied-asynchrony.com>
> Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>

Please add cc: <stable@kernel.org> so that it gets picked up for the
6.6 stable kernel.

Otherwise, looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
