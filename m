Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30A2AC38A2D
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Oct 2022 23:06:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiJZXGo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Oct 2022 19:06:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiJZXGn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Oct 2022 19:06:43 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8911874CE6
        for <linux-xfs@vger.kernel.org>; Wed, 26 Oct 2022 16:06:42 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id d13-20020a17090a3b0d00b00213519dfe4aso3662284pjc.2
        for <linux-xfs@vger.kernel.org>; Wed, 26 Oct 2022 16:06:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=slPrTWmbCCpkQbSEVuT9gLW7+xDgzlFEXYTH9lviVao=;
        b=7SHMGaKPL5vTFDh056P0lyKciB337Ex18axK3Zlpp+dWDR4GDBcp7FM6lNxZ+DsK0Q
         0olxvbl4JUPVxmYjMp61qG9DiapngSos9av8kY1KhrJbpR9JCby540C0d23QKJDIaRMs
         LAnwIj2xL5cS0O6t5frFj3yoMyGAu/7RAkFQEIonB6kpzxdG5SFFbPlnn89jvrRrZDFd
         2RIF70R2Ha387mKOEazieU8Pc2+EakyipJXNr2bPoCRqmN6MIvhHe87yFwCHsRCJDqYD
         XyLugmVxqGg/LXbw7wn4+wDBhdOzhY53mJbwL5o30AiSTSvDKoNojj+Vg9F/klPC8LaT
         ELCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=slPrTWmbCCpkQbSEVuT9gLW7+xDgzlFEXYTH9lviVao=;
        b=S530k/UuRY2fJhW8VtwrRuC5XN2cA/cVq4P/ZMzUUF68uhTiJpmcL60yF1kdYReE87
         MezHZAj1baRRYVrwlhWCpQ68kIK5KaVQkDy6ZdhlTsJ5s+KqpD2I7ITnwOpvKtvzqCG+
         aZV1wJ9n53LJ1HXv9GiiT24V9wjbrHaL6/c50+EhMoURbkDSQc6zjHdAvytp6DXyCAXf
         Z/loG1gi/Jsw5J2l3erZbc8poI8n6d9KGHeO8Bd2CewkCvMZUJvdVP38MsrRTlhiRMlS
         e5YZKm+DNVuQgYuo6dvdlvDHFVaCkkZvsAkHBssd3BEZiEA55PqFYbwkRSTbZ6E5Ncie
         BymQ==
X-Gm-Message-State: ACrzQf26y2xkUnEV+MCoN/8WVvmnMy3m0+TkKJp3uWQC1NtSXXT2XerS
        9xcJ0NL9buOCGHDkfe8ia/XkyV1uDISg3A==
X-Google-Smtp-Source: AMsMyM6NBFkUw4/naXVeCOm/2GXKVnpXYba9go6EMU3OT53m+iMEvlsI9Eac8UEcd5hTAhkyru5vTA==
X-Received: by 2002:a17:902:a606:b0:178:57e4:a0c1 with SMTP id u6-20020a170902a60600b0017857e4a0c1mr45867975plq.83.1666825602088;
        Wed, 26 Oct 2022 16:06:42 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id nv10-20020a17090b1b4a00b0020ad86f4c54sm1607555pjb.16.2022.10.26.16.06.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 16:06:41 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1onpTq-006nB9-5o; Thu, 27 Oct 2022 10:06:38 +1100
Date:   Thu, 27 Oct 2022 10:06:38 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Subject: Re: [PATCH 8/8] xfs: dump corrupt recovered log intent items to
 dmesg consistently
Message-ID: <20221026230638.GP3600936@dread.disaster.area>
References: <166681485271.3447519.6520343630713202644.stgit@magnolia>
 <166681489778.3447519.2620356479140584610.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166681489778.3447519.2620356479140584610.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 26, 2022 at 01:08:17PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If log recovery decides that an intent item is corrupt and wants to
> abort the mount, capture a hexdump of the corrupt log item in the kernel
> log for further analysis.  Some of the log item code already did this,
> so we're fixing the rest to do it consistently.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
