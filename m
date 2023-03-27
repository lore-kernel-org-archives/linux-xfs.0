Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80649C76195
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Mar 2023 22:57:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbjC0W5z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Mar 2023 18:57:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbjC0W5y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Mar 2023 18:57:54 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEA912D65
        for <linux-xfs@vger.kernel.org>; Mon, 27 Mar 2023 15:57:38 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id o11so9958654ple.1
        for <linux-xfs@vger.kernel.org>; Mon, 27 Mar 2023 15:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112; t=1679957858;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=82lYB0lL4CS5tmQd94rDNpT+aJMD6MYBqshPk8Qqj/0=;
        b=jpcqIXsNMu8I6iiqe8Iz+8wGJU/f0+9F87Jnrmlte5fQ6NhbUbhxPudAr+ZJ/iA/ux
         2qtNcVsjHrd2x+re6naJja5LwnoxLL1U0E7Fhmipi7oswBmnUduEC+2cBhCCr+uzw+FV
         kfSTGXPY1+fcSz9oS7knRfKKN+S0QAxvsRsku8/iy1a9BGaUGrdTQyx0RqTkJYavNa0l
         HtyTGCDr5tV8W6dPC7rsH9k5VlSKdThV9HLGiGT+oJzztmy8gv0u1XY6wWBMwFoID3Ur
         po6gwsrvXv5i1I2lbOiN5k+w66FYT9JQeEJMg8QJJ9AYZ4POkAD4m1KiDX8dvgJDKiEd
         oITA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679957858;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=82lYB0lL4CS5tmQd94rDNpT+aJMD6MYBqshPk8Qqj/0=;
        b=Yin6dDvkM9x07bc4pbXuAnz47CeW9Ld1Diby7LjKyMDENdW2JeRYpsZO/6my4HLL6i
         hR2ufOgU0eVqebvNQ+DDysAOsKvecjvkN1QbE15O/HN+0nVgqkow/kLBz/1Ak+z/V0oF
         /2+SOtMBWm8Wq40t1fmRJpfxtWrITv4yyIWr9Zycr9UxtvfQLVtbqFq25PK4bmAuJh3G
         FdB87DPQLBCNBF1IJeBdR38a48LBnAzcZvoB2oLqZ3QRTT5eNQi5qcUZgDNK7gVA0dNS
         6e9jVwxHfsp5KTfhnHMTqzMynJgBTzz4YAwJaZPgnKCbvPZMSbe73ueZklalqCI7ZTYq
         svKg==
X-Gm-Message-State: AAQBX9fibBNbk42kdnt0ecAbYPIwSqZFsz3aiYP3gDHxJispUrJWfAxI
        JDJmrEXNXgl1XE+lAyVktyAPsQ==
X-Google-Smtp-Source: AKy350awFcQ+e4+7yj7VCKplHwm7TW5pVIJRYciytY6OpPH6Dmej17dcFVDXOdqKwWtU+KtE2cU/6A==
X-Received: by 2002:a17:902:db0e:b0:1a1:bff4:49e9 with SMTP id m14-20020a170902db0e00b001a1bff449e9mr17033852plx.23.1679957858452;
        Mon, 27 Mar 2023 15:57:38 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-91-157.pa.nsw.optusnet.com.au. [49.181.91.157])
        by smtp.gmail.com with ESMTPSA id b17-20020a631b51000000b004e28be19d1csm18571013pgm.32.2023.03.27.15.57.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 15:57:38 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pgvmQ-00DwrY-Vf; Tue, 28 Mar 2023 09:57:34 +1100
Date:   Tue, 28 Mar 2023 09:57:34 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-xfs@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 1/3] xfs: Remove xfs_filemap_map_pages() wrapper
Message-ID: <20230327225734.GA3223426@dread.disaster.area>
References: <20230327174515.1811532-1-willy@infradead.org>
 <20230327174515.1811532-2-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230327174515.1811532-2-willy@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 27, 2023 at 06:45:13PM +0100, Matthew Wilcox (Oracle) wrote:
> XFS doesn't actually need to be holding the XFS_MMAPLOCK_SHARED to do
> this.  filemap_map_pages() cannot bring new folios into the page cache
> and the folio lock is taken during filemap_map_pages() which provides
> sufficient protection against a truncation or hole punch.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  fs/xfs/xfs_file.c | 17 +----------------
>  1 file changed, 1 insertion(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 863289aaa441..aede746541f8 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1389,25 +1389,10 @@ xfs_filemap_pfn_mkwrite(
>  	return __xfs_filemap_fault(vmf, PE_SIZE_PTE, true);
>  }
>  
> -static vm_fault_t
> -xfs_filemap_map_pages(
> -	struct vm_fault		*vmf,
> -	pgoff_t			start_pgoff,
> -	pgoff_t			end_pgoff)
> -{
> -	struct inode		*inode = file_inode(vmf->vma->vm_file);
> -	vm_fault_t ret;
> -
> -	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
> -	ret = filemap_map_pages(vmf, start_pgoff, end_pgoff);
> -	xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
> -	return ret;
> -}
> -
>  static const struct vm_operations_struct xfs_file_vm_ops = {
>  	.fault		= xfs_filemap_fault,
>  	.huge_fault	= xfs_filemap_huge_fault,
> -	.map_pages	= xfs_filemap_map_pages,
> +	.map_pages	= filemap_map_pages,
>  	.page_mkwrite	= xfs_filemap_page_mkwrite,
>  	.pfn_mkwrite	= xfs_filemap_pfn_mkwrite,
>  };
> -- 
> 2.39.2

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
