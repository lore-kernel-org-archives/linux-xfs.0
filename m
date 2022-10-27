Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2887ECAAA1
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Oct 2022 21:12:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237340AbiJ0VM5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Oct 2022 17:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237290AbiJ0VM2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Oct 2022 17:12:28 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 072844DF33
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 14:11:15 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id c2so2905753plz.11
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 14:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8l7QS+nPfleLkbZej9UcvTrr9gDSswM+W/Cv5sGKSjg=;
        b=3DSoekdiofOOnHOxwEosfSA1FXqCBCovvy0PsCiXInRnQuTsr2i9fH4G0Dxt0chHnd
         m2pAwZUw33XC6oe2GQO89QmozER/eXDZJIT2z1lm9WMqQcF0mX3gsSH4KDqoNuHmzzvl
         XNBig6CWuzY1XWzCSntQmTBQ/5R5RH3Br2pvkdiV+9+obKM0+f0T4cUwIPJRvIECDTam
         3OdMNvN2yvQQLOHpOlYOfS22nFegBqi+TGxVzDFwbafvsQRI+uyTVUgyt1uya2gzOMEU
         TL3zExn7kXTHI79Vu/1wIFHanNoUB2drvizlOWlojQvgR5APfHYPb6A0xf3fiCY6OmIo
         kZbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8l7QS+nPfleLkbZej9UcvTrr9gDSswM+W/Cv5sGKSjg=;
        b=GXbcC/StwbtyoSVMIwYkvi6ycd0h7F2xVZ0260ijScMuQ5zX9eBlHZSCBgs1C7deB1
         682dzcaEL4pO4VdykcKmYC3rjAG6WWGJdLw2UrOhAFIPOUx5DK/f9wZfDXWM1aetrcZI
         I69qTzzMmGbjLo4ezlnkC4dTGhVqP3Sgup/pRH7tfKES+TKpc1fAb0G8VvEvyU//QGEq
         lXey2GMRotDP4vYaAc03mf7D/imw6iAnjAIkH8O8rENijvPYHVB9o3yEKiJumdiBz2i9
         /JWutaUmF47JLhfLSuLXf3bjzFjwAtb3gW8O+zz1PDCNJ0LqE4r5Gu2sIKLxuZlpLnNU
         SteQ==
X-Gm-Message-State: ACrzQf2Fup98tA0oY2M7ahnOwiENNNDoaWkjGr59QIJJVgGCCq3AqyTM
        yCIL8qQPAlInqZDcfPqmxJZ1P1G0C7F5Qw==
X-Google-Smtp-Source: AMsMyM7okjzIwaxi1PigHoQx1Agnp2MTBQh4j8VOEiS0R2+rRVtMQbMbhF1vbSXZAbzpfE+l+iuE0w==
X-Received: by 2002:a17:902:d592:b0:17a:582:4eb with SMTP id k18-20020a170902d59200b0017a058204ebmr291109plh.40.1666905074465;
        Thu, 27 Oct 2022 14:11:14 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id iw17-20020a170903045100b001788ccecbf5sm1632577plb.31.2022.10.27.14.11.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 14:11:14 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ooA9e-0079gK-Se; Fri, 28 Oct 2022 08:11:10 +1100
Date:   Fri, 28 Oct 2022 08:11:10 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/12] xfs: remove XFS_FIND_RCEXT_SHARED and _COW
Message-ID: <20221027211110.GV3600936@dread.disaster.area>
References: <166689084304.3788582.15155501738043912776.stgit@magnolia>
 <166689088821.3788582.17326076878286020666.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166689088821.3788582.17326076878286020666.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 27, 2022 at 10:14:48AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that we have an explicit enum for shared and CoW staging extents, we
> can get rid of the old FIND_RCEXT flags.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_refcount.c |   48 +++++++++++++++---------------------------
>  1 file changed, 17 insertions(+), 31 deletions(-)

Looks ok.

Minor thing below, otherwise

Reviewed-by: Dave Chinner <dchinner@redhat.com>

> @@ -761,9 +747,9 @@ xfs_refcount_find_right_extents(
>  
>  	if (tmp.rc_startblock != agbno + aglen)
>  		return 0;
> -	if ((flags & XFS_FIND_RCEXT_SHARED) && tmp.rc_refcount < 2)
> +	if (domain == XFS_REFC_DOMAIN_SHARED && tmp.rc_refcount < 2)
>  		return 0;
> -	if ((flags & XFS_FIND_RCEXT_COW) && tmp.rc_refcount > 1)
> +	if (domain == XFS_REFC_DOMAIN_COW && tmp.rc_refcount > 1)
>  		return 0;

Wouldn't this:

	if (!xfs_refcount_check_domain(domain, &tmp))
		return 0;

Do the same thing?

-Dave.

-- 
Dave Chinner
david@fromorbit.com
