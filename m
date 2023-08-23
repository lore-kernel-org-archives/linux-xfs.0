Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B58C3C3DA66
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Aug 2023 22:12:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238555AbjHWWLz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Aug 2023 18:11:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238569AbjHWWLt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Aug 2023 18:11:49 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C666E6E
        for <linux-xfs@vger.kernel.org>; Wed, 23 Aug 2023 15:11:47 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id 98e67ed59e1d1-26d2b3860daso4206670a91.1
        for <linux-xfs@vger.kernel.org>; Wed, 23 Aug 2023 15:11:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1692828707; x=1693433507;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0qPi2kIJpQLy18xtMKuQe11lphbuzzuy2PsJ6Bvx8tM=;
        b=U1C/WGMO2F1nmtlZBhZXpRl2AY7TzDNzdifHVC4tPB3QkzlT9L/MpAZEz+15dRmc9J
         gagCXjvgLJNZUVWtWqQ3s2I0v+G+eNr2UiscvGG6mn0AyuPB5Qq5dgTFD2Qh3GZFH1aU
         lQ5h/w3EnSDgZWBHHhtHsG2nTznehvogAZH3q/aYH8WTrgR9KJYo2D8jH7nmrVMGt+LO
         XP15ZDScHh8ue/Kq42vzxm49MOjX013Pp6rqS9sArmJcEbMSN4hQMg5W/TJv8rstvZgV
         zDOSYcH+Dq2jRIbtSne3upoXuX9Bjt7z5S3gOsKMk3lD4kFqBN2J4kEzHhBTHL2UDeMo
         qtTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692828707; x=1693433507;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0qPi2kIJpQLy18xtMKuQe11lphbuzzuy2PsJ6Bvx8tM=;
        b=lmBZeMCL+yql26Z+odbX1mIEijSjVzeuzvRBbYhGAXwYYmepkq6xGLu39LcoBMzRW3
         9e37SrIj0yrqAum7W9/jLjUdZvMrpY223f5JiHRyTtnL7ggqtubNf3dTwqzZDDDd/BaA
         n9vYFfMLeZ/wm6uC8BI1IHLaNZ+MUjSMxCVy57+DvRmD1qgCy4Zri1wWN56RM9WvgD1y
         W/Y2K33M6OJ5+7N+D9/8rCGCoiq8jptPfEakeboRqd0RU3Zm6IjGZ9Dk2nDIM/UGDtkW
         RD/lsnBSJ2tJnkgwqGHXUPmjh/Km4hlzFHxDZXb6qvr5OU7GSedWuZ8pTpnOc8lafQug
         EQQQ==
X-Gm-Message-State: AOJu0YwIzkUMw4+eh/S5G7x/+DmzFuG5KIJ2xXIUi5QNUp3W1TMCO+Gx
        0ba0rRkIV4irnwkH7zPBeqgRkd2fo5j4emUGENY=
X-Google-Smtp-Source: AGHT+IEQSyQ7z4RVu0pb7MHFNML7PyOTepiSnhL+lT0CXZKJjO2dBDbdyqWxNYFC0vOecefPeybXwQ==
X-Received: by 2002:a17:90a:4dc6:b0:26d:2fe5:ff2a with SMTP id r6-20020a17090a4dc600b0026d2fe5ff2amr12320409pjl.29.1692828706796;
        Wed, 23 Aug 2023 15:11:46 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-66-88.pa.nsw.optusnet.com.au. [49.195.66.88])
        by smtp.gmail.com with ESMTPSA id 19-20020a17090a031300b00256799877ffsm269767pje.47.2023.08.23.15.11.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Aug 2023 15:11:46 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qYw4k-005czG-1R;
        Thu, 24 Aug 2023 08:11:42 +1000
Date:   Thu, 24 Aug 2023 08:11:42 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Jan Kara <jack@suse.cz>
Cc:     Christian Brauner <brauner@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 28/29] xfs: Convert to bdev_open_by_path()
Message-ID: <ZOaEHrkx1xS9bgk9@dread.disaster.area>
References: <20230818123232.2269-1-jack@suse.cz>
 <20230823104857.11437-28-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230823104857.11437-28-jack@suse.cz>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 23, 2023 at 12:48:39PM +0200, Jan Kara wrote:
> Convert xfs to use bdev_open_by_path() and pass the handle around.
....

> @@ -426,15 +427,15 @@ xfs_shutdown_devices(
>  	 * race, everyone loses.
>  	 */
>  	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp) {
> -		blkdev_issue_flush(mp->m_logdev_targp->bt_bdev);
> -		invalidate_bdev(mp->m_logdev_targp->bt_bdev);
> +		blkdev_issue_flush(mp->m_logdev_targp->bt_bdev_handle->bdev);
> +		invalidate_bdev(mp->m_logdev_targp->bt_bdev_handle->bdev);
>  	}
>  	if (mp->m_rtdev_targp) {
> -		blkdev_issue_flush(mp->m_rtdev_targp->bt_bdev);
> -		invalidate_bdev(mp->m_rtdev_targp->bt_bdev);
> +		blkdev_issue_flush(mp->m_rtdev_targp->bt_bdev_handle->bdev);
> +		invalidate_bdev(mp->m_rtdev_targp->bt_bdev_handle->bdev);
>  	}
> -	blkdev_issue_flush(mp->m_ddev_targp->bt_bdev);
> -	invalidate_bdev(mp->m_ddev_targp->bt_bdev);
> +	blkdev_issue_flush(mp->m_ddev_targp->bt_bdev_handle->bdev);
> +	invalidate_bdev(mp->m_ddev_targp->bt_bdev_handle->bdev);
>  }

Why do these need to be converted to run through bt_bdev_handle?  If
the buftarg is present and we've assigned targp->bt_bdev_handle
during the call to xfs_alloc_buftarg(), then we've assigned
targp->bt_bdev from the handle at the same time, yes?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
