Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 791C5C61D85
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Nov 2023 21:25:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbjKUVZM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Nov 2023 16:25:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjKUVZK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Nov 2023 16:25:10 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0E67DD
        for <linux-xfs@vger.kernel.org>; Tue, 21 Nov 2023 13:25:05 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id 41be03b00d2f7-5a9bc2ec556so3768616a12.0
        for <linux-xfs@vger.kernel.org>; Tue, 21 Nov 2023 13:25:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1700601905; x=1701206705; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=J98HlUV5KlwcYiTod5JdOtOHbwusFVik73H7ba35F3c=;
        b=Jv7KI2y1zIlhEuY5RY+U6F3H4+NHawqAGIcoXiso2w32QKFFncuviuJrZQX2vp/drR
         kYFMCFHF8iTOlEi//++gsCt6idJgJejgd+ZwpfL+o6GAAL8q2RiYnjEuY5S4IQg6sLUe
         tds38UlCSMY98q/S3p+NATBflSW2yX0WAhzlejwy1wPv11VC+dCUVM3hsSoYYwAuMIwm
         aaDQy65iMIGxJ4c3rYRzE+9H37CSvPjLoTTPHBn7haLjvm019Hu+WbWWdxMUJlk2l50I
         6K1UWdyIaCxMu6+90FnecrDS2aZltu81gFBs+aY6QpV82AtRXvwDXCZlx1SdTK4ffSer
         YlyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700601905; x=1701206705;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J98HlUV5KlwcYiTod5JdOtOHbwusFVik73H7ba35F3c=;
        b=toCfe3j9MlCMGUmhiweV0b8BnT6m7iyU5YbjcOeSTvK1HeH2v4+JwJduflzBiE5374
         +wK+Y2fU7Ev++d8WnfZGS2/caXAYciaFkCUZQNhCA8yIVqiF5cnGURrZYJ4PgcsD0G+U
         5JQH6KK4jjMQ6sl1tLhfS+5BHLyfuU0PgZ3rrTImnzulSiAkyiKGZVEeRrDQpsM2n0zq
         J1Saw+OnevMPhIuIctN4shpw0TShXBgJ+Ir4eusKsdluzpppD6UkOCbObXm/cxjwmpLC
         0/b/28P3UYd9ygSeaGiCQUo6sneaxd/XZZmaNXsR8oF+JpPVDyglfiG8ehKbYxMl5HiN
         d9Eg==
X-Gm-Message-State: AOJu0Yy/BdK9Vwmtwdw88naak5HxfOLamoNPVmiNle7bIxjkqLQWlo0e
        4Vj2BelF4swtV61eQgK9VwIbNg==
X-Google-Smtp-Source: AGHT+IHBk/g75B8eyx0c4CzaMrvWvgwsxxKgnD9ai3+OBa8Z6nMH+ItINn0eRFs7fCm5uBkCVSXyJQ==
X-Received: by 2002:a17:903:228d:b0:1cf:591c:a8b1 with SMTP id b13-20020a170903228d00b001cf591ca8b1mr534848plh.15.1700601905187;
        Tue, 21 Nov 2023 13:25:05 -0800 (PST)
Received: from dread.disaster.area (pa49-180-125-5.pa.nsw.optusnet.com.au. [49.180.125.5])
        by smtp.gmail.com with ESMTPSA id t1-20020a1709028c8100b001c452f827casm8345954plo.257.2023.11.21.13.25.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Nov 2023 13:25:04 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1r5YEw-00FjB9-11;
        Wed, 22 Nov 2023 08:25:02 +1100
Date:   Wed, 22 Nov 2023 08:25:02 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     chandanbabu@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: dquot recovery does not validate the recovered
 dquot
Message-ID: <ZV0gLtyxrbIsqBZx@dread.disaster.area>
References: <170050509316.475996.582959032103929936.stgit@frogsfrogsfrogs>
 <170050510455.475996.9499832219704912265.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170050510455.475996.9499832219704912265.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 20, 2023 at 10:31:44AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> When we're recovering ondisk quota records from the log, we need to
> validate the recovered buffer contents before writing them to disk.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Yup, another verifier hole closed.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
