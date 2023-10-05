Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25B8FE92703
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Oct 2023 14:22:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231950AbjJEOWI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Oct 2023 10:22:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233255AbjJEOUN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Oct 2023 10:20:13 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7939949E9
        for <linux-xfs@vger.kernel.org>; Wed,  4 Oct 2023 22:12:10 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1c63164a2b6so13536785ad.0
        for <linux-xfs@vger.kernel.org>; Wed, 04 Oct 2023 22:12:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1696482730; x=1697087530; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Db/v8Pw2M45tThNb8jDyJ0VeR6UbHVWEZcnaT+DJz0s=;
        b=Tfnj2xgKuWr7ZVFM0k+OBQYveAYqYtEh3kbwWKI5ODQ9uZ3mI8V/6+BCKiAgIvqIY5
         vxranaWirAK3ZZ9zX+iwVCV+zBwSoYtGtnB0FcCETwWh/Aa+RxrEhLtZc7uvrRmnuIBU
         1azlrUxIA9VbkS8ukZqThYtY3Vac8ZMV3IsxVaTkOLvn9TkUBgtTTyENRBXEsSJgb5c5
         Sglza82051dLsRxJrU+K6fFEmHJlvO9GoLEfZYem702bvNGxl39vVbwnJdc2gAnqajuO
         yURG5/ozMgWBI41n3ZauEnwLzF13Wnaw4o8T0rRgc55fOUXuEx2rsINKAqPh9U3XO+Ed
         A4lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696482730; x=1697087530;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Db/v8Pw2M45tThNb8jDyJ0VeR6UbHVWEZcnaT+DJz0s=;
        b=JUTddQK20p5Q9s/Z02oEprL1kBqGiQwmXTb4K+ZHPhFmB6AXcDYSdotOlbrjbuC54g
         DBseObEZ+dgChysKRsBtLFH8IL5Zv5maJVrWMv28KNak5OUHEINZo6Qk1HK5FXo6m4nG
         5F47lu9mFRyYN3w89+gJxRbR1ZePGsOoamebxYyxK62My+Hg8FVOS7+XpEWjKxr7jBHx
         QDUcGVSFM7merKsczCVLQPXugHoDGr7QmzWGoBocrf7cc59YYxxhsCCPzNECfsHnXr9+
         7BUKqyHfvJAsARy1FXIkpo/b3larDYFuUbbwoA7QDmK3Q2aWTN+5QY4z8gQP2lKaqHo9
         RUyA==
X-Gm-Message-State: AOJu0YzY4jNsxzBL1owIQpf+NVHJPeEjRJqY/e8IQ5brpBPP9OdiSoNd
        AnoIAUUHlRCufn621YnrL/GLQtKiq/CZquhrA3Y=
X-Google-Smtp-Source: AGHT+IG00vOWhZHzcd2O6mcRPp7pehoZu+a3NcK8zSIF4Oez+IkKpqwkgh86U8tjIHCnOZRQ9SJv/w==
X-Received: by 2002:a17:902:e80a:b0:1c3:9928:7b28 with SMTP id u10-20020a170902e80a00b001c399287b28mr530660plg.6.1696482729837;
        Wed, 04 Oct 2023 22:12:09 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id jk23-20020a170903331700b001b890b3bbb1sm534063plb.211.2023.10.04.22.12.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Oct 2023 22:12:09 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qoGec-009e7F-2Q;
        Thu, 05 Oct 2023 16:12:06 +1100
Date:   Thu, 5 Oct 2023 16:12:06 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/7] xfs: log EFIs for all btree blocks being used to
 stage a btree
Message-ID: <ZR5FppHyYbJJyfRj@dread.disaster.area>
References: <169577059140.3312911.17578000557997208473.stgit@frogsfrogsfrogs>
 <169577059238.3312911.11027644382774083646.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169577059238.3312911.11027644382774083646.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 26, 2023 at 04:32:41PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> We need to log EFIs for every extent that we allocate for the purpose of
> staging a new btree so that if we fail then the blocks will be freed
> during log recovery.  Use the autoreaping mechanism provided by the
> previous patch to attach paused freeing work to the scrub transaction.
> We can then mark the EFIs stale if we decide to commit the new btree, or
> we can unpause the EFIs if we decide to abort the repair.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/scrub/newbt.c |   34 ++++++++++++++++++++++++++--------
>  fs/xfs/scrub/newbt.h |    3 +++
>  2 files changed, 29 insertions(+), 8 deletions(-)

Looks ok.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
