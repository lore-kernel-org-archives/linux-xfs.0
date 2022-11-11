Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C3A7C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Nov 2022 21:05:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbiKKVFq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Nov 2022 16:05:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbiKKVFh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Nov 2022 16:05:37 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2341833AC
        for <linux-xfs@vger.kernel.org>; Fri, 11 Nov 2022 13:05:35 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id b21so5135337plc.9
        for <linux-xfs@vger.kernel.org>; Fri, 11 Nov 2022 13:05:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=shA/zgCe8ohvjmrnmjnVbnuzBFwMM7aQahgMkTH5loU=;
        b=AzwDjJh9upFb6xq1nghjvGS99ZLyfSRJRgB3MqOqLO1tWGG1ILLIhltDULYa9SzAVl
         JlR5OQgjCoHyp7W+UdgyCP4Riu3rmJGieyljBMDWh3gYJn8vc3MaqvANRuOtpY3tUaOd
         o20mrL2CZJDDfw8U1koQGEKlmLhKnaqnRMay5BJVEfF94L7c9s/ry6ZoEuwynM9ZUNDc
         w8wPEQnBmWNZxR4uYxqlcyeLh63A1/cUbd1lZEc3Xux0+FhZovATR9vqaxRbQab0oI8I
         7f0LrfjPi+JLv1eFKwOv9KG9REXkH2D4N0jDt+xkGRAoCIXcTwquhfNOU75cMwr4w4Fk
         Ph3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=shA/zgCe8ohvjmrnmjnVbnuzBFwMM7aQahgMkTH5loU=;
        b=LGYXVy3EF8cfyzs2LBaUlLt1hcbRaV36HhsSVJr1Fq8/el9cyKm+aR5jhVorAVCp08
         r40Oss7mjS0DAAJaPi20t8wTHkfCvs2yA5iucZ2I2UX9t3s9Ibs47KS9pFxD5zFaH4RN
         1UxMmUm88CeMcOtZ6evXay7IhLkbX/k34XLLrUR/rDbHVlYMk7kWZtSzrMe+xpNHBjN9
         TTJmpH0vbJUFGPV03dxFReqiKikKXzaWSdxyvp4ve80zWSSjrd2Hnbouz/h3c3kHytpT
         J5Z9TmMeZWzMgleQAlHdNdmEcs9BJmm2JEDbpLSnAqFFHD+O7jEDhZe0hG+9eCu595GQ
         pYCg==
X-Gm-Message-State: ANoB5pkW9mN94qcFVUV69Z6fyHGMoOyrF+lqBGa5lsFQJUmR2Cq+oOUw
        A6zFR7dWXawXfdijSuCQBKSZQYNHB8yehA==
X-Google-Smtp-Source: AA0mqf5zTFO2fnN1AVixjCIiSBypnYY1yr1EsCJ+98tMvGombpaFsWTzWkgL6m51QhE30oD9557TTA==
X-Received: by 2002:a17:90b:2650:b0:213:36b7:c6c0 with SMTP id pa16-20020a17090b265000b0021336b7c6c0mr3553720pjb.226.1668200735471;
        Fri, 11 Nov 2022 13:05:35 -0800 (PST)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id u190-20020a6260c7000000b0056b8b17f914sm1980284pfb.216.2022.11.11.13.05.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Nov 2022 13:05:35 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1otbDQ-00D4Zm-5m; Sat, 12 Nov 2022 08:05:32 +1100
Date:   Sat, 12 Nov 2022 08:05:32 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1] xfs_spaceman: add fsuuid command
Message-ID: <20221111210532.GP3600936@dread.disaster.area>
References: <20221109222335.84920-1-catherine.hoang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221109222335.84920-1-catherine.hoang@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 09, 2022 at 02:23:35PM -0800, Catherine Hoang wrote:
> Add support for the fsuuid command to retrieve the UUID of a mounted
> filesystem.
> 
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>

Not looking at the code, just the high level CLI interface issues.

That is, xfs_admin already has user interfaces to get/set the
filesystem UUID on XFS filesystems. Further, xfs_spaceman is for XFS
filesystem SPACE MANagement, not filesystem identification
operations.

xfs_admin is CLI interface that aggregates various admin utilities
such as identification (UUID and label) management.  If we need to
implement a generic VFS ioctl for online UUID retreival, xfs_io is
generally the place to put it because then it can be used by fstests
to run on other filesytems.

We can then wrap xfs_admin around the xfs_io command as needed. i.e.
use 'xfs_io -c fsuuid /mnt/pt' if the filesystem is mounted, 'xfs_db
-c uuid /path/to/device' if the filesystem is not mounted, and we
can make sure that both the xfs_db and xfs_io commands have the same
output....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
