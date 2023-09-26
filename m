Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28CB6E7F143
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Sep 2023 22:39:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbjIZWjz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Sep 2023 18:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230422AbjIZWhx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Sep 2023 18:37:53 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75E30A255
        for <linux-xfs@vger.kernel.org>; Tue, 26 Sep 2023 14:28:33 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1c5ff5f858dso44225125ad.2
        for <linux-xfs@vger.kernel.org>; Tue, 26 Sep 2023 14:28:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1695763713; x=1696368513; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WT/Wz7KEhFqiGhRjtGyxqtBTnwhlwqYgyhWA39+Lc7k=;
        b=iDZrdU9iXXq+p6aqu0+FakHTtHeuYY2O6Tp0OyWDGtvMd7qb3l4zHZLH6ZEKut2M/A
         uO/ffGzAMOgqlKSTMSNcEUUctyY5oIbSMKOxOJp2BE5jPbddu9n9Ocl1D+z+hB8ycVai
         8c+sw3KbGs33DbQlQGm9lM6bktOs7TbBQWPIAicFvcif47KKZKniiqbueCr0DmbA/a6R
         ELqC9tHamb5ZgG/7EtwWvtvl4fx6SI+qul99OMI7QdKetU8yXnL2nVjXV4oJWK/qEX3F
         fw+DPfZo3xp2e4n0T5PGu3pW3+RIPuDq160V9ag1CumzUVHS4sXdi+TNef8eJU19LRPQ
         WBXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695763713; x=1696368513;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WT/Wz7KEhFqiGhRjtGyxqtBTnwhlwqYgyhWA39+Lc7k=;
        b=USxpbP6zS/4sF4PkQ5413WYawo2MviueAQtog3T+L14WpmKJGDJGgR0FzTTkEsa+iu
         5t42CQ6rlbPqihc2eL/I1kS8ZOqoAdFks5VclO7csD8i3Yl1i/tFJqSGj8SB04ed5ClB
         Z6beHanFDVf/2iReWliedqZ9DQlLXUrxxhml8j2YuOxyJm/prWQ/eEGWQrCqCtUorcNq
         pGZilSXReBx8WMeYgZrhFF/Q4fJbDMVTVOtVBQMpDTrvti6Yk506zhrsFqXRvwDeEqYP
         JsKWw6FWirpI6/1H9iQ81RgalD6BPYlbJQ5ktV+CkxHH2So4pDMyhldqBWvS57qn9WSN
         YCeQ==
X-Gm-Message-State: AOJu0YwWD2KnSXNLiyMqDQhbf0D5u7fYt2Iwp4Lsoe6tJ+2GBDKVaZ2m
        IlB4Zz3mKL2wklK/UQXFvHIZAg==
X-Google-Smtp-Source: AGHT+IEnF6RlS53qmgOs7nTD6NvBuKvMH/2yQsF9tzbc4E6vH49HzkU+Tvw9z8pW9GjOH2j2DXmPxA==
X-Received: by 2002:a17:902:ee94:b0:1c3:eb95:2d27 with SMTP id a20-20020a170902ee9400b001c3eb952d27mr8417201pld.48.1695763712901;
        Tue, 26 Sep 2023 14:28:32 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id w12-20020a170902e88c00b001c55e13bf39sm11467175plg.275.2023.09.26.14.28.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Sep 2023 14:28:32 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qlFbZ-0060Bt-13;
        Wed, 27 Sep 2023 07:28:29 +1000
Date:   Wed, 27 Sep 2023 07:28:29 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Krzesimir Nowak <qdlacz@gmail.com>,
        Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
        Krzesimir Nowak <knowak@microsoft.com>
Subject: Re: [PATCH 1/1] libfrog: Fix cross-compilation issue with randbytes
Message-ID: <ZRNM/dd5rMv4gfZV@dread.disaster.area>
References: <20230926071432.51866-1-knowak@microsoft.com>
 <20230926071432.51866-2-knowak@microsoft.com>
 <20230926144100.GD11439@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230926144100.GD11439@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 26, 2023 at 07:41:00AM -0700, Darrick J. Wong wrote:
> On Tue, Sep 26, 2023 at 09:14:32AM +0200, Krzesimir Nowak wrote:
> > randbytes.c was mostly split off from crc32.c and, like crc32.c, is
> > used for selftests, which are run on the build host. As such it should
> > not include platform_defs.h which in turn includes urcu.h from
> > userspace-rcu library, because the build host might not have the
> > library installed.
> 
> Why not get rid of the build host crc32c selftest?  It's not that useful
> for cross-compiling and nowadays mkfs.xfs and xfs_repair have their own
> builtin selftests.  Anyone messing with xfsprogs should be running
> fstests (in addition to the maintainers) so I don't really see the point
> of running crc32cselftest on the *build* host.

Agreed. Running the test on the build-host served a purpose a decade
ago when we first added crc support to the on-disk format. I don't
think it is necessary to do this anymore...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
