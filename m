Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7FC8C761A6
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Apr 2023 15:26:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237804AbjDEP0t (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Apr 2023 11:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231953AbjDEP0s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Apr 2023 11:26:48 -0400
X-Greylist: delayed 509 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 05 Apr 2023 08:26:47 PDT
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 928AF8F;
        Wed,  5 Apr 2023 08:26:47 -0700 (PDT)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id D4AD84DCA1C;
        Wed,  5 Apr 2023 10:18:17 -0500 (CDT)
Message-ID: <fb3c14f3-00b7-2a5e-3c76-bd90705224b8@sandeen.net>
Date:   Wed, 5 Apr 2023 10:18:16 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.1
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Andrey Albershteyn <aalbersh@redhat.com>
Cc:     dchinner@redhat.com, ebiggers@kernel.org, hch@infradead.org,
        linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
        rpeterso@redhat.com, agruenba@redhat.com, xiang@kernel.org,
        chao@kernel.org, damien.lemoal@opensource.wdc.com, jth@kernel.org,
        linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        cluster-devel@redhat.com
References: <20230404145319.2057051-1-aalbersh@redhat.com>
 <20230404145319.2057051-21-aalbersh@redhat.com>
 <20230404162730.GB109974@frogsfrogsfrogs>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v2 20/23] xfs: add fs-verity support
In-Reply-To: <20230404162730.GB109974@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 4/4/23 11:27 AM, Darrick J. Wong wrote:
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index d40de32362b1..b6e99ed3b187 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -30,6 +30,7 @@
>  #include "xfs_filestream.h"
>  #include "xfs_quota.h"
>  #include "xfs_sysfs.h"
> +#include "xfs_verity.h"
>  #include "xfs_ondisk.h"
>  #include "xfs_rmap_item.h"
>  #include "xfs_refcount_item.h"
> @@ -1489,6 +1490,9 @@ xfs_fs_fill_super(
>  	sb->s_quota_types = QTYPE_MASK_USR | QTYPE_MASK_GRP | QTYPE_MASK_PRJ;
>  #endif
>  	sb->s_op = &xfs_super_operations;
> +#ifdef CONFIG_FS_VERITY
> +	sb->s_vop = &xfs_verity_ops;
> +#endif
>  

Hi Andrey - it might be nicer to just do:

        fsverity_set_ops(sb, &xfs_verity_ops);

here and use the (existing) helper to avoid the #ifdef.  (the #ifdef is handled by the helper)

(ext4 & btrfs could use this too ...)

Thanks!

-Eric
