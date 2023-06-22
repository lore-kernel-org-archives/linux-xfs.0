Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0670CEB64D8
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jun 2023 03:17:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbjFVDRi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Jun 2023 23:17:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjFVDRh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Jun 2023 23:17:37 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B188E10F6
        for <linux-xfs@vger.kernel.org>; Wed, 21 Jun 2023 20:17:36 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id 46e09a7af769-6b5915d0816so2529624a34.1
        for <linux-xfs@vger.kernel.org>; Wed, 21 Jun 2023 20:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1687403856; x=1689995856;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TWSGgOltI6NC/J9w1gQfeept9+o9HtE4hRq02VGl+yk=;
        b=0vwGxYTjzB0HCo9FGs4b8AEDKDZzeRoCihVQHRphO3+MzRZmqVZp+1AxKC9LmsiMwr
         yKLp01q3vfdcpgVHwIy2iOI1YQnUr19Vu63kuxII3BWKBQPHITQA/zII0YJvKCjIx5zX
         2z9s4EUU/S6W7/C3Vff0c02isTAgo5Noffr0xKYper9KvT8wKFinshv4kdJV/L2VAq7i
         I5cAlBfdBMeXnlO5aPOiuDTt6HdguaapOIPtoLY8Cy0MDb3XdFlk5JnjSpbUQx8BNKft
         Opcw9kFybj1dDgWkFzlW/Eoxqgx080HXFI9fC5+13jZzkYJlBTFY3KGK8rOgyKLXxF5p
         I4zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687403856; x=1689995856;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TWSGgOltI6NC/J9w1gQfeept9+o9HtE4hRq02VGl+yk=;
        b=LD0N5pZ/LKWlWTRFnIR+ZeY6xhwLtZT4chV8kZe+i0G8hiLJ/2qn8XSng9Irj1CPwj
         x0yD8sC9RHnXq5FORGFVbVcCOD936U03d8wxW0pudNeio1C8EurA4ltlIdiuoY3da57T
         XZm8JDQVAW3OSF5hmhjuFYyCIJIKdpMen1pIE5C7yuaHx2AZHWpX15gX0/zTdDeoGzGx
         gRB62xWMMThUvkqJsT7/SfVonKRyCplUJfij8sOaHrlvTJktG7vUOYrW2QGkPWcPi/w/
         AJdKD5M7tzWDcpJfuiM1Fgmqg/10c9U5LV/8rztgHXyisYTEmbWbUoCpWyH/sJ+aK/86
         8udg==
X-Gm-Message-State: AC+VfDzJJgWJQPgJjncI9n0i4Qenbhkwww/jEzNukVggFB/nVg4J7ADI
        0u3CZROO+ePjZb8JIysLY/AxHu1fWBfZXd+6Wro=
X-Google-Smtp-Source: ACHHUZ7MO++vITGw7wFvarZjxvP7CXxQWDm61nJeerHADiIdPUXxa/8lkV7fs0ceeB9yorKfryK/wA==
X-Received: by 2002:a05:6358:f0e:b0:12b:ed05:18bb with SMTP id b14-20020a0563580f0e00b0012bed0518bbmr12109238rwj.27.1687403855957;
        Wed, 21 Jun 2023 20:17:35 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-13-202.pa.nsw.optusnet.com.au. [49.180.13.202])
        by smtp.gmail.com with ESMTPSA id q24-20020a62e118000000b00666b7446219sm3527187pfh.45.2023.06.21.20.17.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jun 2023 20:17:34 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qCApA-00EgzC-1g;
        Thu, 22 Jun 2023 13:17:32 +1000
Date:   Thu, 22 Jun 2023 13:17:32 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: allow userspace to rebuild metadata structures
Message-ID: <ZJO9TA2f+ne6y7cT@dread.disaster.area>
References: <168506057570.3730125.9735079571472245559.stgit@frogsfrogsfrogs>
 <168506057600.3730125.4561906767586624097.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168506057600.3730125.4561906767586624097.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 25, 2023 at 05:50:47PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add a new (superuser-only) flag to the online metadata repair ioctl to
> force it to rebuild structures, even if they're not broken.  We will use
> this to move metadata structures out of the way during a free space
> defragmentation operation.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_fs.h |    6 +++++-
>  fs/xfs/scrub/scrub.c   |   11 ++++++++++-
>  fs/xfs/scrub/trace.h   |    3 ++-
>  3 files changed, 17 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index 1cfd5bc6520a..920fd4513fcb 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -741,7 +741,11 @@ struct xfs_scrub_metadata {
>   */
>  #define XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED (1u << 7)
>  
> -#define XFS_SCRUB_FLAGS_IN	(XFS_SCRUB_IFLAG_REPAIR)
> +/* i: Rebuild the data structure. */
> +#define XFS_SCRUB_IFLAG_FORCE_REBUILD	(1 << 31)

(1U << 31), otherwise a compiler somewhere will complain.

Also, why use the high bit here?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
