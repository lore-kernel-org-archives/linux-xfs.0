Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3EC0C7EE23
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Feb 2023 00:08:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbjB0AIG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 26 Feb 2023 19:08:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjB0AIF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Feb 2023 19:08:05 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 156136E83
        for <linux-xfs@vger.kernel.org>; Sun, 26 Feb 2023 16:08:03 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id nw10-20020a17090b254a00b00233d7314c1cso8335136pjb.5
        for <linux-xfs@vger.kernel.org>; Sun, 26 Feb 2023 16:08:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2MTXMIlz/dV0iBnAtnBofs7P8vQ/S8XF/YLaf2+qt2M=;
        b=d+9lTc6+OUhmOYiqKJRCk50VavmXC3N+7KWcPckDoUDZ7l9ArueFObChf7lgiN4W3O
         rDBuiNPw/HIcX57OdOLNhgHiFmcGwnD79/SOOGcwtymHix3+X/XzEHRyw3zpv0z/P5WG
         Ram63RCw70PMOGgNfVW9Nq497QRvJV8T+VLX001rXCzg1c+MucbcNx8ml1LkUFnLgjvg
         OOfwSep0SdFwhfpoXtZVUgN+wUlAK8I5FqdhYfyiD6d5Gnsv/nPEDYExpqdBilqAWdV1
         r0eDZGj71Ek7FH3jpx5YtBCAt9f6S1gMLqTLvzMjt5HnIeL1DnKVwIb1SpLvDiD/Cm35
         XC/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2MTXMIlz/dV0iBnAtnBofs7P8vQ/S8XF/YLaf2+qt2M=;
        b=lyLSnPfhxSJau/DF7Xff3IIKrYn3gvipP/a5k8xIgmX4EoM4G8gaYwOYfgID7FaGWl
         5Pqw84YcT4orSrGGlPFI8zT3rkKQe6C1j8UPSw7av6yh80cgK6w6otBEaAMpBtIVeDhC
         NvezDhPobng+GcIuSBV4g7ms1/LFoXyur1jODsh2XBHuGdT7Ai7WsLg2RPr0Tge2sP4r
         TSgNlKF2BEMaXgCfOUUBBgoSEsBnIpjG0D0PeANi2iBuiMqCcU045KnzKQmNiGivtbHs
         KdQawdasSKyOW9R4VPETUPLX5ijgwTUMU5vP4XoDdNw2N0Ob6oaz3QDq3YC/CaU2YtSB
         ygGw==
X-Gm-Message-State: AO0yUKURnU4V3GIr11rFvjtbGd3cnGOIh4KQf+p3YkjKQsmpa3JVvyul
        9oy1b6rDUTXz2Gqntp78XBQwBg==
X-Google-Smtp-Source: AK7set8+PnfY2B8V9G4CP2Lj8RDaQp+dmHVQXgLREsohum+UH1nqFrxnkjraneEwoMXVj1dLQJOeqw==
X-Received: by 2002:a05:6a20:3ca6:b0:cc:8e18:420f with SMTP id b38-20020a056a203ca600b000cc8e18420fmr10210968pzj.35.1677456482521;
        Sun, 26 Feb 2023 16:08:02 -0800 (PST)
Received: from dread.disaster.area (pa49-186-4-237.pa.vic.optusnet.com.au. [49.186.4.237])
        by smtp.gmail.com with ESMTPSA id k26-20020aa790da000000b005d6dff9bbecsm2979685pfk.62.2023.02.26.16.08.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Feb 2023 16:08:02 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pWR3f-002Wx8-CQ; Mon, 27 Feb 2023 11:07:59 +1100
Date:   Mon, 27 Feb 2023 11:07:59 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc:     linux-xfs@vger.kernel.org, nvdimm@lists.linux.dev,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        djwong@kernel.org, dan.j.williams@intel.com, hch@infradead.org,
        jane.chu@oracle.com, akpm@linux-foundation.org, willy@infradead.org
Subject: Re: [PATCH v10 3/3] mm, pmem, xfs: Introduce MF_MEM_REMOVE for unbind
Message-ID: <20230227000759.GZ360264@dread.disaster.area>
References: <1676645312-13-1-git-send-email-ruansy.fnst@fujitsu.com>
 <1676645312-13-4-git-send-email-ruansy.fnst@fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1676645312-13-4-git-send-email-ruansy.fnst@fujitsu.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 17, 2023 at 02:48:32PM +0000, Shiyang Ruan wrote:
> This patch is inspired by Dan's "mm, dax, pmem: Introduce
> dev_pagemap_failure()"[1].  With the help of dax_holder and
> ->notify_failure() mechanism, the pmem driver is able to ask filesystem
> (or mapped device) on it to unmap all files in use and notify processes
> who are using those files.
> 
> Call trace:
> trigger unbind
>  -> unbind_store()
>   -> ... (skip)
>    -> devres_release_all()   # was pmem driver ->remove() in v1
>     -> kill_dax()
>      -> dax_holder_notify_failure(dax_dev, 0, U64_MAX, MF_MEM_PRE_REMOVE)
>       -> xfs_dax_notify_failure()
> 
> Introduce MF_MEM_PRE_REMOVE to let filesystem know this is a remove
> event.  So do not shutdown filesystem directly if something not
> supported, or if failure range includes metadata area.  Make sure all
> files and processes are handled correctly.
> 
> [1]: https://lore.kernel.org/linux-mm/161604050314.1463742.14151665140035795571.stgit@dwillia2-desk3.amr.corp.intel.com/
> 
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>

.....

> ---
> @@ -225,6 +242,15 @@ xfs_dax_notify_failure(
>  	if (offset + len - 1 > ddev_end)
>  		len = ddev_end - offset + 1;
>  
> +	if (mf_flags & MF_MEM_PRE_REMOVE) {
> +		xfs_info(mp, "device is about to be removed!");
> +		error = freeze_super(mp->m_super);
> +		if (error)
> +			return error;
> +		/* invalidate_inode_pages2() invalidates dax mapping */
> +		super_drop_pagecache(mp->m_super, invalidate_inode_pages2);
> +	}

Why do you still need to drop the pagecache here? My suggestion was
to replace it with freezing the filesystem at this point is to stop
it being dirtied further before the device remove actually occurs.
The userspace processes will be killed, their DAX mappings reclaimed
and the filesystem shut down before device removal occurs, so
super_drop_pagecache() is largely superfluous as it doesn't actually
provide any protection against racing with new mappings or dirtying
of existing/newly created mappings.

Freezing doesn't stop the creation of new mappings, either, it just
cleans all the dirty mappings and halts anything that is trying to
dirty existing clean mappings. It's not until we kill the userspace
processes that new mappings will be stopped, and it's not until we
shut the filesystem down that the filesystem itself will stop
accessing the storage.

Hence I don't see why you retained super_drop_pagecache() here at
all. Can you explain why it is still needed?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
