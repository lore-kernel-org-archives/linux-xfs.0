Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1900FC4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Dec 2022 23:10:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbiLNXKw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Dec 2022 18:10:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiLNXKv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Dec 2022 18:10:51 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 842FA2607
        for <linux-xfs@vger.kernel.org>; Wed, 14 Dec 2022 15:10:50 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id fy4so8643921pjb.0
        for <linux-xfs@vger.kernel.org>; Wed, 14 Dec 2022 15:10:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sfUK4j3uPSy8USYGH1WaBKFFv+FcT9DPrt0X+dJMTPs=;
        b=cGHJXZ7+kyvGSVT2OxZJ+Jak0y2wfSb6LWPex+ngGJ8Tu3SIAg7xRRWfX1C2WHhhGL
         7Ry8iM8UO7Clz11UW7kHc5i2VR3RNt/SOyAXzXn9qWcmuRGRz3pSwbDeNUVToTat8oo6
         EJNqgHPLfZcPylGQ8uYwR5SamH1F51HUyj0mOwIWHc8yUc/a/usMejiDPfPBvvpe2gOc
         /B4BTGH6TJhwb+JOs6UXtePadcmVKAocK94oAl9pBXh5bdIAY6VkTorkgeOy4eIudSYp
         o0jMzhNkhgRAjCA+6PjoIIraN4O1TW0oNJ4bqsBzlyaQdWs0nU8lfoL5pasMX84NTPRF
         UWRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sfUK4j3uPSy8USYGH1WaBKFFv+FcT9DPrt0X+dJMTPs=;
        b=Q4TOXkFF0iRWLyxfDVNfZypZEDUApCXFHFo+tiqgT2QGLX2gmTBhDm12bLqKmPiS9W
         vIHqgReF/wn4PXdyD6q1z7CeHeXJz7Tk2F0C/CPP16WqWqFajYLUNYkywkkurIpc0xjR
         E9dFNSCdrE0cVZCG56jSJ3cPBQ/wjmf3W+pqmJOtLZEruGeTLZEoc6NNwUJmbUinwAZs
         yousByYr79YTVjOZJ79sFj6eWaesiLuhDiuY9pN22v4YS6svUx27oJ+2PoM0nTf87sKg
         5ClL0HyLb8krYjzzNAGAZ1eaE+4aiP0t5Xiahplw0w4vNfEbj3UgbCUNeSBH+o/k1k9j
         svZg==
X-Gm-Message-State: ANoB5plkfsfbMCXLowKD4eTvudAE3d1zZ1KmU7Nt2i+Qr3udU+N2MYJ8
        dHRt5WTI0g8WFzyiXMBmijmiJQ==
X-Google-Smtp-Source: AA0mqf7404FQ+x51OsOEaz7mEzZOPK6J+OFvmRUDGC16ye2topm2HL7s7i7K+EGGKyoECUiGW5VY+Q==
X-Received: by 2002:a05:6a20:3b01:b0:ac:2559:35f6 with SMTP id c1-20020a056a203b0100b000ac255935f6mr30989367pzh.28.1671059450001;
        Wed, 14 Dec 2022 15:10:50 -0800 (PST)
Received: from dread.disaster.area (pa49-181-138-158.pa.nsw.optusnet.com.au. [49.181.138.158])
        by smtp.gmail.com with ESMTPSA id rm10-20020a17090b3eca00b00218fba260e2sm1870310pjb.43.2022.12.14.15.10.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 15:10:49 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1p5ati-008W7d-Nw; Thu, 15 Dec 2022 10:10:46 +1100
Date:   Thu, 15 Dec 2022 10:10:46 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/4] fsverity cleanups
Message-ID: <20221214231046.GB1971568@dread.disaster.area>
References: <20221214224304.145712-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221214224304.145712-1-ebiggers@kernel.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 14, 2022 at 02:43:00PM -0800, Eric Biggers wrote:
> This series implements a few cleanups that have been suggested 
> in the thread "[RFC PATCH 00/11] fs-verity support for XFS"
> (https://lore.kernel.org/linux-fsdevel/20221213172935.680971-1-aalbersh@redhat.com/T/#u).
> 
> This applies to mainline (commit 93761c93e9da).
> 
> Eric Biggers (4):
>   fsverity: optimize fsverity_file_open() on non-verity files
>   fsverity: optimize fsverity_prepare_setattr() on non-verity files
>   fsverity: optimize fsverity_cleanup_inode() on non-verity files
>   fsverity: pass pos and size to ->write_merkle_tree_block
> 
>  fs/btrfs/verity.c        | 19 ++++-------
>  fs/ext4/verity.c         |  6 ++--
>  fs/f2fs/verity.c         |  6 ++--
>  fs/verity/enable.c       |  4 +--
>  fs/verity/open.c         | 46 ++++---------------------
>  include/linux/fsverity.h | 74 +++++++++++++++++++++++++++++++++-------
>  6 files changed, 84 insertions(+), 71 deletions(-)

The whole series looks fairly sane to me.

Acked-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
