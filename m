Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5739FFA373E
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Oct 2022 21:47:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbiJYVrZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Oct 2022 17:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231351AbiJYVrX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2022 17:47:23 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D8EF7B1FB
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 14:47:22 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id m6-20020a17090a5a4600b00212f8dffec9so302312pji.0
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 14:47:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qpUkKJJ0afW7yL0wWRZp/GdCvl0Uijl3oPH0JOzXX00=;
        b=F0Ow3pAHuGwFtguplgcascCpRwmPPz+Gw8sYPekGfo05ukfqLanCblLbLnXa8dgD2R
         sRO5zNBdllbudwh/D7KGMqpDoy0XHkS/WFMY16gKvfOwjSPMl31NlKjUCWeR+YeCIzE6
         60Fn3MED/q8aOhZYAuuL6UFJnXEQUqVUOq40jYRU6ET8W0D6fnKXTL/2Vz283vfmP3Ie
         TWQUzRbCtKvFVruGJi8yjQKf3sx4xow1VhP6Luu/srKzYcWHloj/edZYPbWT84yvI7JE
         9d7ZCXPTUmBmeBolHha5R6Wy1CgJSLZmtVdbxKQG+drFHXs35rEUZ8oEQxRJsjBgsjtx
         wXrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qpUkKJJ0afW7yL0wWRZp/GdCvl0Uijl3oPH0JOzXX00=;
        b=fKlVsgHIwJ9QSmPpx5ciScZ+IUaxhn6IkaBxFD1eJheR2jvFOcV4r6UmL4p7mHpyXm
         Z8rhXGI8bT+wPVErvGgcUWVrzqSUBfKoCFZKVnhHjdGqnriWtaTRP4NuO00q8xbz3hTN
         CDUnLTDhT5CTNlZdJP4dYx7hlaettmuewvY8r5tHpzRQB0r5pJJoh22S2m54juHRSwQt
         NmVhlVf+F68LldRRfgAZ4eFvaA5hrtxkfmcb0rpO7aw0DlfBZ18n7mSbA0JzhZuPe90R
         vhTJ9ZwRdOQd1h7v8TvYQ1FE9g3LgpNQPhwQ2TaYdnowbA+9Yw31ZmGOWe47iNYUnQF7
         qVQg==
X-Gm-Message-State: ACrzQf2zC/zzPAluudUHmtQiM/IUObNn/T6TszgrBgYI0bV9pAixVJHH
        +jUZlDkv5+7vLuNCdrNG4iYkx88QRTLwFw==
X-Google-Smtp-Source: AMsMyM4gmcDnAuQTED8R1Qc4AuFk0P7aOYHXn0bgYcbjdeyUiyswCaCrs42h7uOwoOf6N+rY9gz1wA==
X-Received: by 2002:a17:902:ef4c:b0:186:6399:6b48 with SMTP id e12-20020a170902ef4c00b0018663996b48mr30538747plx.128.1666734442448;
        Tue, 25 Oct 2022 14:47:22 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id x75-20020a62864e000000b005624e9b3e10sm1801708pfd.210.2022.10.25.14.47.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 14:47:22 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1onRlX-006NGE-FH; Wed, 26 Oct 2022 08:47:19 +1100
Date:   Wed, 26 Oct 2022 08:47:19 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: fix memcpy fortify errors in EFI log format
 copying
Message-ID: <20221025214719.GF3600936@dread.disaster.area>
References: <166664715160.2688790.16712973829093762327.stgit@magnolia>
 <166664717980.2688790.14877643421674738495.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166664717980.2688790.14877643421674738495.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 24, 2022 at 02:32:59PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Starting in 6.1, CONFIG_FORTIFY_SOURCE checks the length parameter of
> memcpy.  Since we're already fixing problems with BUI item copying, we
> should fix it everything else.
> 
> An extra difficulty here is that the ef[id]_extents arrays are declared
> as single-element arrays.  This is not the convention for flex arrays in
> the modern kernel, and it causes all manner of problems with static
> checking tools, since they often cannot tell the difference between a
> single element array and a flex array.
> 
> So for starters, change those array[1] declarations to array[]
> declarations to signal that they are proper flex arrays and adjust all
> the "size-1" expressions to fit the new declaration style.
> 
> Next, refactor the xfs_efi_copy_format function to handle the copying of
> the head and the flex array members separately.  While we're at it, fix
> a minor validation deficiency in the recovery function.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Yes, it could be broken up into smaller changes.

Yes, this could all be reworked like Christoph previously proposed.

Yes, there are more cleanups that could be done.

Yes, there are other ways to get to the same point.

No, I don't think it is worth the effort to do it differently.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
