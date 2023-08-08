Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF250C001E0
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Aug 2023 21:57:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbjHHV5p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Aug 2023 17:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbjHHV5o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Aug 2023 17:57:44 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED3A9EE
        for <linux-xfs@vger.kernel.org>; Tue,  8 Aug 2023 14:57:43 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-686d8c8fc65so4354719b3a.0
        for <linux-xfs@vger.kernel.org>; Tue, 08 Aug 2023 14:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1691531863; x=1692136663;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YCh0gGgdu43BffhTHRpb87yXdgZgfUbq/I3U4XU0Bzo=;
        b=D//7qBa6JT4/W6MtNwEJBTisjWXoeIgorxn4WlicBdH9ldGPGAtvqVGzMMsvKUgGIS
         HC3/uBzpTSPL+otgqOzpAlQExDTM4TJrPJAz+MxvZDWWWEGXfiF9VuJAWTdFsi8u4MFi
         AO9lPxHX1QUGhjaZgfEVp7S4DBKYwVT+GLTnEQa1YWlVObwYe2N9H1e8ulWFisFgCFGE
         yH5YhgH2Ymp9yLTUlaaP4YYuoQnD91p4DZF+PcRaGMJoR2RQ15IbCj/eUE+wMZEYJRtD
         5TWZ9R0tM57ab+rEs3rx8pHA4Zze38yXIc2icMHOztg4PTM71GzIKzUwaecmX5M3JN0e
         VV8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691531863; x=1692136663;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YCh0gGgdu43BffhTHRpb87yXdgZgfUbq/I3U4XU0Bzo=;
        b=DxSCYq3FmhaGxvM5Ibcezs6O0N4Ba9RczDY+JSTcYQM1xIDBUWadOkGfV5S8keTVpG
         dpI/+FZP3ET0ln68oPmYatKW5C+PRggzRupxMCkF4JaHmBQVPTLHXBGjT8izhusrNNw3
         0S5A9d3+V+9LK00W3ZWOeI8zeh1muzFbBmZT4GO7khlHuHxi9xU00RP39JaFI33vLDwT
         YYQLj68feqkXGC8i6MDNqkSdWXTtC0pbdYmDEYAFP/hA/d0pMk/WDrKkj5R6gQH+tP5e
         Eyh88SLRZ8EnpQTHi1AGqP3r7HXkYiLFP3UTgDSTtonNhunC8V88RHSVUcGfaF6MCAc1
         vmFg==
X-Gm-Message-State: AOJu0YyjkdQFuwLSmEgjveT2rP1WTuAegN7IsGhSknksP9/NORZ/Pn+U
        K1VYNRMUq2ekYqdAsMLMRMLY8cYZR3dSwO6MjBg=
X-Google-Smtp-Source: AGHT+IFG4P7Z8V5q9B2l3lNYWObNNYQkrCjwQIp9IVNpTbNjmx8OlktuwiZEviJ0hlD9ByNVxtvGYg==
X-Received: by 2002:a05:6a00:3a05:b0:687:472f:5150 with SMTP id fj5-20020a056a003a0500b00687472f5150mr679821pfb.8.1691531863379;
        Tue, 08 Aug 2023 14:57:43 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-166-213.pa.nsw.optusnet.com.au. [49.180.166.213])
        by smtp.gmail.com with ESMTPSA id y7-20020aa78547000000b006661562429fsm8832882pfn.97.2023.08.08.14.57.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Aug 2023 14:57:42 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qTUhv-002suo-15;
        Wed, 09 Aug 2023 07:57:39 +1000
Date:   Wed, 9 Aug 2023 07:57:39 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix dqiterate thinko
Message-ID: <ZNK6U0T/olLZynaQ@dread.disaster.area>
References: <20230808024030.GP11352@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230808024030.GP11352@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 07, 2023 at 07:40:30PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> For some unknown reason, when I converted the incore dquot objects to
> store the dquot id in host endian order, I removed the increment here.
> This causes the scan to stop after retrieving the root dquot, which
> severely limits the usefulness of the quota scrubber.  Fix the lost
> increment, though it won't fix the problem that the quota iterator code
> filters out zeroed dquot records.
> 
> Fixes: c51df7334167e ("xfs: stop using q_core.d_id in the quota code")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_dquot.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 17c64b7b91d02..9e6dc5972ec68 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -1458,7 +1458,7 @@ xfs_qm_dqiterate(
>  			return error;
>  
>  		error = iter_fn(dq, type, priv);
> -		id = dq->q_id;
> +		id = dq->q_id + 1;
>  		xfs_qm_dqput(dq);
>  	} while (error == 0 && id != 0);

I see how this happened looking at the commit mentioned, and how it
would have easily been missed on review - there was a separate
"id++" line after the xfs_qm_dqput() call that was removed that
should have been left in place. This change obviously restores the
previous behaviour.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
