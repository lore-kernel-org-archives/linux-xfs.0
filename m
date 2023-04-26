Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F133C77B60
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Apr 2023 23:11:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233392AbjDZXLV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Apr 2023 19:11:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236056AbjDZXLT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Apr 2023 19:11:19 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF940358E
        for <linux-xfs@vger.kernel.org>; Wed, 26 Apr 2023 16:11:16 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-63b70ca0a84so9417505b3a.2
        for <linux-xfs@vger.kernel.org>; Wed, 26 Apr 2023 16:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1682550676; x=1685142676;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0VV8ee61yiod3w6fY1R9CmyDgTW0UwHG6IyxV93Kghc=;
        b=PDE/jk675D6bHZGGjJmJnUoTgrP0e0GOfJl6OEUmEcfbIQuWmTdKEpze+5i71xRBc/
         5cZW88H6AkhUTCNJnSHYwL6UnOiyQJcNlTgWTL/A3K9N4olrvpCx1axVx14p1M7mcw99
         H0D6z8srxF10FOqJCJPFSggx7DxtgJO+YlRWcEf7kew1R2QvooJRdO7QhoKr1eZleso9
         0hxqzJ0LJxB9aRuuT43y/ITA29iMm3sVHuyd6HZKVxQpCaL7vuxVHNu981Q9M7G8S1kV
         8QxhYptiqNc/82XngSeUYibN5STaeGFQPAbIO0NAFpdNHRbXrsn7zcUcxcODRqqxAfA4
         oZqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682550676; x=1685142676;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0VV8ee61yiod3w6fY1R9CmyDgTW0UwHG6IyxV93Kghc=;
        b=Nh9hrrNWCati0Ixe6MkSrNCA254T84ojv+N2QRF9F49sLJY3l17mQvaS6SiwNwdG43
         Pt7LtHuk+H5cSKw4Uo5lrOI6RO9vrmn56SoRaH4rh05On7rg0OhZHQx274QzbBc2ttBO
         m3mxpzimt4IEhN1r58XzF4YmJ3HJJIcPZ81S/lEbwp54V56XI9cgP+GiUIauj9KEWz55
         C6vXF/eskN+3DOzp4QHnIVL9/ZiiY+qciYtL+UOeaGF+Gy1SCdRS68LSNTFedulTpmtb
         N+6WiXPHWofCSE2XnxN/n1azRNt2ir+E0AQT2yef3Up/EWzSZ4J3oqWShVfs9GlVj7v3
         7cGQ==
X-Gm-Message-State: AAQBX9dV4+5ZRu/wK712dxmSApeZWuDZQ4B1D35VKSll7+AwdNojTTZv
        wLti5M5dFApkuqrjP2aTZJ1dp5kgsYyckcHYQQ0=
X-Google-Smtp-Source: AKy350Z5P/EPtOt1jwZc8AmBTtrLK2Rx6XGf0Acuz6r3VANwCR1vRD+pJkhhb8nAS4oNkXV3MYYwBw==
X-Received: by 2002:a05:6a00:2d88:b0:63d:2d99:2e7c with SMTP id fb8-20020a056a002d8800b0063d2d992e7cmr31447149pfb.0.1682550676111;
        Wed, 26 Apr 2023 16:11:16 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-88-204.pa.nsw.optusnet.com.au. [49.181.88.204])
        by smtp.gmail.com with ESMTPSA id fb11-20020a056a002d8b00b005a8de0f4c64sm11797364pfb.82.2023.04.26.16.11.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 16:11:15 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1proI4-008GPZ-E2; Thu, 27 Apr 2023 09:11:12 +1000
Date:   Thu, 27 Apr 2023 09:11:12 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     djwong@kernel.org
Subject: [ANNOUNCE] xfs: for-next updated to 9419092fb263
Message-ID: <20230426231112.GK3223426@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

I just merged the fix for the ENOSPC delayed allocation regression
into the for-next branch. I did this because I don't really want to
expose what appears to be (now that we know about it) an easily
triggered livelock as a result of stripe aligned allocation fallback
issues. I'll let this got through a linux-next cycle and then send a
pull request to Linus as the tree stands.

-Dave.

----------------------------------------------------------------

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next

  Head Commit: 9419092fb2630c30e4ffeb9ef61007ef0c61827a

  xfs: fix livelock in delayed allocation at ENOSPC (2023-04-27 09:02:11 +1000)

----------------------------------------------------------------
Dave Chinner (1):
      xfs: fix livelock in delayed allocation at ENOSPC

 fs/xfs/libxfs/xfs_bmap.c | 1 -
 1 file changed, 1 deletion(-)


-- 
Dave Chinner
david@fromorbit.com
