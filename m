Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E77DFECAAA1
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Oct 2022 21:25:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236280AbiJ0VZd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Oct 2022 17:25:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236692AbiJ0VZ3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Oct 2022 17:25:29 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACABB5282B
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 14:25:28 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id r18so2860514pgr.12
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 14:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lTIQtiuiW0Tt0yyZSXxJVs+tloc8f1xIr08z2cEf2qE=;
        b=GM9I2ydc7po0a58znO/vsPycgqLTcvrwMmaYp8HuUL10kgN0xNMuqunpPCetxmt9au
         yUL5N4A9DWHCMOxnhWO4wSnNsbyOWStKTmQgZ219I/ZvF4dOucKEr1KqSAT4R2gwvlRU
         7HpO10lQBp8+jdiSTtDa5CgIRJAM12GtJoPWaOgxy6syfCcbwulSnXgw2gmyOJsLdFv3
         7lmK32ZnzzaM/1yJGmiBKEWROjoO1O3Y0AHXmaNLmOWWKq3zg0VI9qvo7G53C+KuTqjx
         qkaSb6o3BZBsgaFEluDd5b4mQJ6hj/NjiryUWw9/g+iff9WSesTES+b8pwP7bTvG3J1M
         031Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lTIQtiuiW0Tt0yyZSXxJVs+tloc8f1xIr08z2cEf2qE=;
        b=dBgWVjJSd05MGVItEX/XSAihcti2Mg4Y1i/wQUAfynqUSN+JG0yjouio+sErN5JQIq
         9i+Nv7HMJ7g0j2+Df8ZbrJsAxrFiWozY7CGWexET50dAax2vktfw1pI/Tsp4hBCKDvkA
         zcuqmAAX2Xbt0+n7XfWenBSiM6utpX/MhPaK2ErTr9xb8bqizFFLvk9uLPcy+UM8n6nO
         En8ZNg+EUU52iriyMmdt6Oq3a4NvWsLCGGEGd9M9yye0vNOOrjnf8asZBPiyceQNalqN
         OE6goktB5t1sIdQQwLvr2GTLOLnv+tV23vSoVdTit/kFLTI158rx0j62ujEG0HUOK9K8
         3/IQ==
X-Gm-Message-State: ACrzQf1YZOVVy2STER1/nqX/aF8nIKWWdXvS4EHs1FI5Y20ZEMl3WOqi
        H2KP8Kz8pNEl/ycUxJMyD88TPsw3c49IpA==
X-Google-Smtp-Source: AMsMyM6+Eih9TPfDgoKwnM0gUg7aGvQeFgR+7jAmkUjsxcNdG2yduRDWAvOIz1C6n/pqF/g3PryHRA==
X-Received: by 2002:a63:fa17:0:b0:43c:3f26:48e3 with SMTP id y23-20020a63fa17000000b0043c3f2648e3mr43852830pgh.66.1666905928299;
        Thu, 27 Oct 2022 14:25:28 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id g4-20020a63dd44000000b0045913a96837sm1457720pgj.24.2022.10.27.14.25.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 14:25:27 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ooANR-0079zH-I3; Fri, 28 Oct 2022 08:25:25 +1100
Date:   Fri, 28 Oct 2022 08:25:25 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/12] xfs: rename XFS_REFC_COW_START to _COWFLAG
Message-ID: <20221027212525.GZ3600936@dread.disaster.area>
References: <166689084304.3788582.15155501738043912776.stgit@magnolia>
 <166689091062.3788582.5745982343341644557.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166689091062.3788582.5745982343341644557.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 27, 2022 at 10:15:10AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> We've been (ab)using XFS_REFC_COW_START as both an integer quantity and
> a bit flag, even though it's *only* a bit flag.  Rename the variable to
> reflect its nature and update the cast target since we're not supposed
> to be comparing it to xfs_agblock_t now.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Yay!

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
