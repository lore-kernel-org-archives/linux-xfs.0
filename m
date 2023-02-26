Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0CDDC7EE2D
	for <linux-xfs@archiver.kernel.org>; Sun, 26 Feb 2023 22:02:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbjBZWCI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 26 Feb 2023 17:02:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjBZWCH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Feb 2023 17:02:07 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B42C61167E
        for <linux-xfs@vger.kernel.org>; Sun, 26 Feb 2023 14:02:05 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id i5so3166318pla.2
        for <linux-xfs@vger.kernel.org>; Sun, 26 Feb 2023 14:02:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cWbJPZU9R2mu0qvVud+b/9/0fp2jwsXrc4xc7PigaOc=;
        b=F2Y3oFDubuVtCd+apwQO7qFEDdZJ4nKU3VWWijfWOfnZVvHZdCPGc5oqa09X2hpNrl
         /Mt4VOVPS90ukjfUwsMgfM/jJFiNlx8EbSRMLuFpsnGufb0kevOb86OI9mu5t7GC7+vg
         zeDwQIVdjJ1CjtCAUiX5TLEigme+rvxeVGn8AzlZMR3R7NNY9cE8/L1AURJ7vArPC407
         jYTOBXiqwbrjlRzzBllyWFT59wsVZXC/TDt1F1ibL+NElIIHSnH2kk13Hobnniq7rznJ
         FuKhm1Ox6azVlLS1D3ov6w79n0vCdg7KSJzw1MJwVJnJy1m43JMmaEiC4O8DoOV8X7HB
         BpDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cWbJPZU9R2mu0qvVud+b/9/0fp2jwsXrc4xc7PigaOc=;
        b=Uzm7EHdeLihoiiBh5euFGjyz06D60fDG9CfmOFK2XJrwP4U+IR10ByEU+T8TC9HtT0
         TApPjWQ9NykP0OkfI/a3uvkDT20Rbju3y2lsa+TO4ZgGanm6M99Tuw/7y2A1ZDitfIz3
         ZvTBQ1fI6UsFKq8+jYKboS+wNWnuzXOCc/q7EOf2oUCyhaF4c6TwQ4a6511paBwWiBA+
         7xd1vt72iPU9AJoaX29jlLCFSlH6/lRH7godJ93j+WKlfvw1DBf0ABUhUWf7g7rTaNKw
         EGL8+qgQe4MQqUUAvZlgt4MOpC1yrvfo8fnxx43qEcQWM+tVmf7MKlnhh1tW1LehVNXg
         pNHA==
X-Gm-Message-State: AO0yUKXf9LEuL9jXV5g3rApWrWyr+ZtmQlBjdQqLY8gWq1LPVgajNKJq
        h4S2r83PmFor4qRXLLVyU9EVvzEALeV5ARyi
X-Google-Smtp-Source: AK7set9GQPnUGWk1LqJlB0xcCDR6m9L8lnBdk9DsJa7+dawjB/3Rg2I3cVlhOM4gJtCX/XrNOnZ8uA==
X-Received: by 2002:a17:903:2291:b0:19b:33c0:4092 with SMTP id b17-20020a170903229100b0019b33c04092mr26856771plh.24.1677448925179;
        Sun, 26 Feb 2023 14:02:05 -0800 (PST)
Received: from dread.disaster.area (pa49-186-4-237.pa.vic.optusnet.com.au. [49.186.4.237])
        by smtp.gmail.com with ESMTPSA id c4-20020a170902d90400b00196807b5189sm3075901plz.292.2023.02.26.14.02.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Feb 2023 14:02:04 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pWP5l-002Urs-J6; Mon, 27 Feb 2023 09:02:01 +1100
Date:   Mon, 27 Feb 2023 09:02:01 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: restore old agirotor behavior
Message-ID: <20230226220201.GT360264@dread.disaster.area>
References: <Y/WoHLYbp82Xj7H8@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/WoHLYbp82Xj7H8@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 21, 2023 at 09:29:00PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Prior to the removal of xfs_ialloc_next_ag, we would increment the agi
> rotor and return the *old* value.  atomic_inc_return returns the new
> value, which causes mkfs to allocate the root directory in AG 1.  Put
> back the old behavior (at least for mkfs) by subtracting 1 here.
> 
> Fixes: 20a5eab49d35 ("xfs: convert xfs_ialloc_next_ag() to an atomic")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_ialloc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 65832c74e86c..550c6351e9b6 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -1729,7 +1729,7 @@ xfs_dialloc(
>  	 * an AG has enough space for file creation.
>  	 */
>  	if (S_ISDIR(mode))
> -		start_agno = atomic_inc_return(&mp->m_agirotor) % mp->m_maxagi;
> +		start_agno = (atomic_inc_return(&mp->m_agirotor) - 1) % mp->m_maxagi;
>  	else {
>  		start_agno = XFS_INO_TO_AGNO(mp, parent);
>  		if (start_agno >= mp->m_maxagi)

Change is fine, but it pushes the code to 85 columns. If you clean
it up to:

	if (S_ISDIR(mode)) {
		start_agno = (atomic_inc_return(&mp->m_agirotor) - 1) %
				mp->m_maxagi;
	} else {
		....

Then you can add:

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
