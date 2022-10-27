Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96FEEECAAA1
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Oct 2022 21:10:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237121AbiJ0VKO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Oct 2022 17:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237127AbiJ0VJx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Oct 2022 17:09:53 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F2F1B1DF8
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 14:05:51 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id pb15so2801986pjb.5
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 14:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=b5SzcHu4HAHbighgeaOvG8KbM9qu4XsSRA9LZGC0t+s=;
        b=GFV7FAypuptDlDz23S6gcB0rdfEDeZPqO+opCwohDt6duICSIDVWtKyRjhvsG91zhq
         OiZZnNuWgrhGOtaHeQHfCdE6god+YV8thIw29p+BKXyZctXDlCkli5uieE+OyGj8c5ck
         T1XgvqOiWjCp8dBWz49DgF2FS61I7f4O6U2FoZWVyagbq99CuQ90W+wCEOxDJM4tNipP
         SL8hKGL0hTpADfTopj6xtG4o+d8Z3aIQo8x0CR7gHfHv/4EVK4oZyEHEW7tPwmjCPVnv
         2vNfDrRgxlUZn7T0NacnYUch3w5yw6Kbxl6u9Qlqp1f82fn3HK5re3syDt1bqJbBcQuM
         PHzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b5SzcHu4HAHbighgeaOvG8KbM9qu4XsSRA9LZGC0t+s=;
        b=DL3BeXT6sHZcP6/nDMWFAGQ/BIZEXhKgWAUpHfr6BYerg59VSuuOnkpHXHDZxsKEQW
         2rqdcOCr1lHH8/toHQjtpDBw1e31+Y/ixOczWkRjDBN1XMA/kH46R0fFx5MZR1XHGejM
         keI40oSLjOypgsFzMJE8ywCt5xApBwGfHyaZcW80px1TQxd1f+grUJ8suWyzOUQcbYeh
         nZUVT0i/iqlWXHFn+t2ds5VftHf/caaPb/cW9zkDys9u0CURIkHPC23aFyXmLOxiNVnW
         j9gqYWcsHmaThjYXUrAEyVaaxKVVRKaZunBgLFfWIavoQjGrAH3yspUiL3/aq8z+DXvb
         5WDQ==
X-Gm-Message-State: ACrzQf1JIWMVIyJ873UB+Dzqe/k/xyxJXwvJsXfT7qX6mlP2Qx6oZ65T
        rZyEm9uB0Z5imXuE4M8fzLTiMP8sqgZJxQ==
X-Google-Smtp-Source: AMsMyM7DWZf1eOaCC3FC0fcHYF9q85DNQlbT4JdJZquxIyq5lVL3ykZmrd3Pr+nPIfY1rxBRTQ50+w==
X-Received: by 2002:a17:902:a713:b0:183:e2a9:6409 with SMTP id w19-20020a170902a71300b00183e2a96409mr50411202plq.149.1666904710789;
        Thu, 27 Oct 2022 14:05:10 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id t8-20020a63eb08000000b0046b1dabf9a8sm1446334pgh.70.2022.10.27.14.05.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 14:05:10 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ooA3n-0079cP-8w; Fri, 28 Oct 2022 08:05:07 +1100
Date:   Fri, 28 Oct 2022 08:05:07 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/12] xfs: report refcount domain in tracepoints
Message-ID: <20221027210507.GT3600936@dread.disaster.area>
References: <166689084304.3788582.15155501738043912776.stgit@magnolia>
 <166689087703.3788582.4765638597071821270.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166689087703.3788582.4765638597071821270.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 27, 2022 at 10:14:37AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that we've broken out the startblock and shared/cow domain in the
> incore refcount extent record structure, update the tracepoints to
> report the domain.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_types.h |    4 ++++
>  fs/xfs/xfs_trace.h        |   48 +++++++++++++++++++++++++++++++++++++--------
>  2 files changed, 43 insertions(+), 9 deletions(-)

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
