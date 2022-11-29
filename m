Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91721C43217
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Nov 2022 01:37:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234663AbiK2Bht (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Nov 2022 20:37:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234652AbiK2Bhs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Nov 2022 20:37:48 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 470D76350
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2022 17:37:48 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id 140so12274909pfz.6
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2022 17:37:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9hwYJmo88IBZZEvj8mXF/0I11UwksQNJX5xkLBkjDU8=;
        b=AnfbiLN7xR3/GZjMV0uhgr5gu/e3NfLfkw2rZo1fJDOCFUQOnFY1xapvJmiyFPbFRm
         St9CEKN4Z/rpnFVdXj4d9N6puN2kKmZuUu1peGzmIgTbGeXF+1f3fI1og4OMEqiImMm0
         yPe/Yqtj4ckn+cc2IfmKcGd9T0LJyzCEHCSw3IdJzZj5oxUbDTGoUMiby4yy+Y4qpuRK
         NIxfe7Siz1YNh8vN2sWMHH0IWpXBy4B6BrPlyh+Xs286Je3v8j97XQ3+5CI4kIxlF6TL
         vhtWyG3r6WGjTyMmUyP+85cbhAbfpVL9BQDdTCMuoqm1BDJvhyPSexeQIXH9raqTv4i7
         nPCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9hwYJmo88IBZZEvj8mXF/0I11UwksQNJX5xkLBkjDU8=;
        b=fnD/HAd1E3mmgE1IUL+UN8aJERMCzMcx+Fx/uCBO5pu1DhKpEOMlxiRjbon+NAczVX
         R+ffCv7DuOkngwNVe4sBwETemjdDk+fdDxu2WIFm4pcpVPEKEhBdL4JZNVhW6d8NmtOo
         TNBGkVpiTGBUhhnXEtVNTKT1rD4fz0tctBlqXrjkZYibxo06yCb+heXY8fUHAuBT0F4A
         k69CCDHvF8BW247WysfuHyxas8ZNm2/Nb0abB5s2dgn/VVCxAZddGFKK1rQoaoiQH6sS
         DihxcjvFbqyh8BkQc5H/eqkFo/oPMArdhZl3eypuC8cbYgrrCOoCdFPaODNSY0HseYy0
         Y+pw==
X-Gm-Message-State: ANoB5pkjGvveFO00kaHL8sLpO1+g0pyuqv/0cDDL/hPFJcEPCIMtiR6z
        N4ugU3meSfZMg9tAS5lTenqpyg==
X-Google-Smtp-Source: AA0mqf52yWf09g6//BZNdN+q+Xm6N2wkCRZ7/Hv1TUwLnAdnsBUZGEQLBDW8mxB0sfBZLP8a7o9XXw==
X-Received: by 2002:a63:d21:0:b0:438:c2f0:c2cf with SMTP id c33-20020a630d21000000b00438c2f0c2cfmr15236566pgl.116.1669685867794;
        Mon, 28 Nov 2022 17:37:47 -0800 (PST)
Received: from dread.disaster.area (pa49-186-65-106.pa.vic.optusnet.com.au. [49.186.65.106])
        by smtp.gmail.com with ESMTPSA id q100-20020a17090a1b6d00b00218ddc8048bsm106025pjq.34.2022.11.28.17.37.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 17:37:47 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ozpZA-002FYx-S2; Tue, 29 Nov 2022 12:37:44 +1100
Date:   Tue, 29 Nov 2022 12:37:44 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 11/9] xfs: add debug knob to slow down write for fun
Message-ID: <20221129013744.GZ3600936@dread.disaster.area>
References: <20221123055812.747923-1-david@fromorbit.com>
 <Y4U3dj5qvpKSQuNM@magnolia>
 <Y4VeuqfVBU4/x9aB@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4VeuqfVBU4/x9aB@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 28, 2022 at 05:22:02PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add a new error injection knob so that we can arbitrarily slow down
> pagecahe writes to test for race conditions and aberrant reclaim

pagecache

> behavior if the writeback mechanisms are slow to issue writeback.  This
> will enable functional testing for the ifork sequence counters
> introduced in commit XXXXXXXXXXXX that fixes write racing with reclaim
> writeback.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
> v2: this time with tracepoints
> ---

Looks OK to me.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
