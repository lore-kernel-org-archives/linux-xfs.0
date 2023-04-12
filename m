Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6EE6C77B6C
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Apr 2023 21:38:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbjDLViV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Apr 2023 17:38:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230141AbjDLViU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Apr 2023 17:38:20 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB977D9B
        for <linux-xfs@vger.kernel.org>; Wed, 12 Apr 2023 14:37:56 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id 41be03b00d2f7-5144a9c11c7so1113084a12.2
        for <linux-xfs@vger.kernel.org>; Wed, 12 Apr 2023 14:37:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1681335476;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rZ4yx8V/TVK3IhiKBnDOzsIRtPUQCbMM+VbEDZ9KY/s=;
        b=YJKYnEjTQkyJ/A1YbI3GVB9JzNJy2vXp3xudRsi8Trt2vBFHO8tZiU/cSBoxZipYjb
         7OiJv58I7zYmo9fNHh2lfUICHaom6TkRcAvGOZXn/JJStdueJKudKKBWA0LDKI43tsEK
         sClan19VfDUMG+pMiKtYiwb/4/UvXJNr2bd/eGrVQkUr8PLBzvv/W+WKJMtwyhaLCj+v
         RmcMjj/I1eibqxt/h6+GsSX3BlrMovu85W24913xqQYwpeP6PUODEtoffDUdkHQ8GV/H
         BqJVytNM4ieNJNBgcmQfaxQ2yfPjMT6DaJb4IeiK8o1eCcjWFrFdkg3oFZEmabVcR+Bn
         C0fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681335476;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rZ4yx8V/TVK3IhiKBnDOzsIRtPUQCbMM+VbEDZ9KY/s=;
        b=der4llW9i/ppyfd5I5KQ/hpKQQiaxNJAHul3/EranUJAzBfBMzMPrLevvoOROtwRdd
         0xUEqY0LqAOULwsjr5DRGyPPtOf2c3I1xTxqgLprExAe4McG25HsrfpHyUsg0NHNzCmc
         dXiLGGdq10j6wywVNZfyMci4xLEvgsaS6lROxeuwhadvuCxPRufIKsT1tFLr3KAXxPtu
         QLLtEJv7kxxJuZNQ3LbGjpzR0t9hJ6GLZ7tqHLH1gWUpuXXhbWW3MWWC0h7f6ZYSbGDi
         9c343+4tPO5SxfJRnn6JHYwTSf2j5AS6sQJlMvXAduc1jtQUW/UIhkrhAIsS/Z54QNm+
         eA3Q==
X-Gm-Message-State: AAQBX9fypGvikVnR2P8MxCwscibVAtC37BM2npyMVc4MjsLp0aJts5uj
        HjkTPyao1ZeYFEkgAegxTdXIlMMbZLrXi2UEq7PZVw==
X-Google-Smtp-Source: AKy350aTizf556QVz56011ZszH1/gIef/gpFh9vh9HUyRv5pXMxWrpzosrUVnpGi2BmXIVXWkYJrlQ==
X-Received: by 2002:a05:6a00:1903:b0:635:6603:2534 with SMTP id y3-20020a056a00190300b0063566032534mr372714pfi.14.1681335476006;
        Wed, 12 Apr 2023 14:37:56 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-41-174.pa.nsw.optusnet.com.au. [49.180.41.174])
        by smtp.gmail.com with ESMTPSA id v7-20020a62a507000000b0058dbd7a5e0esm12112164pfm.89.2023.04.12.14.37.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 14:37:55 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pmiA4-002e6G-7g; Thu, 13 Apr 2023 07:37:52 +1000
Date:   Thu, 13 Apr 2023 07:37:52 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: don't consider future format versions valid
Message-ID: <20230412213752.GK3223426@dread.disaster.area>
References: <20230411232342.233433-1-david@fromorbit.com>
 <20230411232342.233433-3-david@fromorbit.com>
 <ZDagdV4uGpRyogxj@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZDagdV4uGpRyogxj@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 12, 2023 at 05:13:41AM -0700, Christoph Hellwig wrote:
> > @@ -86,16 +87,16 @@ xfs_sb_good_version(
> >  	if (xfs_sb_is_v5(sbp))
> >  		return xfs_sb_validate_v5_features(sbp);
> >  
> > +	/* versions prior to v4 are not supported */
> > +	if (XFS_SB_VERSION_NUM(sbp) != XFS_SB_VERSION_4)
> > +		return false;
> 
> The comment is a bit confusing now.  But maybe the v4 checks should
> move into a xfs_sb_validate_v4_features helper anyway, which
> would lead to a quite nice flow here:
> 
> 	if (xfs_sb_is_v5(sbp))
> 	 	return xfs_sb_validate_v5_features(sbp);
> 	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4)
> 	 	return xfs_sb_validate_v4_features(sbp);
> 	return false;

Sure. Care to send a patch that does that cleanup?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
