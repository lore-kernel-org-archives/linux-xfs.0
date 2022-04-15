Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34B2EC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Apr 2022 05:11:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237399AbiDOFNg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 Apr 2022 01:13:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245386AbiDOFM5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Apr 2022 01:12:57 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A35515838E
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 22:10:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1649999401; x=1681535401;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=wC6/PVYH+J9es8aT7sK5ZaGwsGnDQHOFu7y4PW6r0NI=;
  b=eZb8o0JNmBMNASCM/maZQHLGt0P2AdJALcZpi9PDmdWLcW7I6T1UlrHC
   kYHyLxy2gs2m2X69YziKzIVT4epQqdYfJIFEwdpNUbPRVnIkdQkBjkzZx
   BU8F8KNGt0mMjYqfmnY4Smx/uEQdAErWCTrefEQEDOVqrZIVF9Z3DBv3F
   gbg/jmDfqLoYWRShHmZtjyZgciSLETZgT6b02NN6HUamwbXSVcEeHBHE9
   uysylRGtEKMDYsRkDkgZctOL11t8/Q0U1Qqt7ZFHhrrJaFNF5LdlC+zST
   gwM9mMUgtGG/k+TK9T1pkwDc9WXs7guzVB4E/jTw6iABnqCWUqM67ycDw
   w==;
X-IronPort-AV: E=Sophos;i="5.90,261,1643644800"; 
   d="scan'208";a="197970129"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 15 Apr 2022 13:09:48 +0800
IronPort-SDR: sQgFUdIULW6TMCOIb35thgRV/j4EBUTTFWyHDHMU7ZC6180UONMVkiBQbm2hgQtexohrlqTU5m
 hjKH5X9LBvJWzfvNEfTiDFXrW7SRD6zZKD3yXzvoFasF4gUBNaWOWBeSZA/E1iRaFMLkw/S31N
 NfJ+ahETL+/aenquXuYboKu5Jxg8uc5oOBbTWarhzf7I3IbIPasZ2ldtGbGNTLtp5V4d22kW1Q
 +97h3m/wBoadRl12355KQIvYGBUiRBILC+qhzIDIrR/zvjPW1111Sjm6cnLfSUV2c4XARWU7LI
 h9Di0mBBtOxWpWlfCDzYf66e
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Apr 2022 21:40:15 -0700
IronPort-SDR: 4dNglUSeX+vsOg+YiCVljjQw5Qm8l7yTWjmr/gTU6NtYKnnZbvJQv4UhdV7j0mQNF5rIcrh5IA
 2HoOPgn8y9E032HKX0W2v8cNPP1TomdEDUtiJbbnDDOWHzioY7/Evhpo9KCjvkcu0Ni8hTo4St
 QFMrJZ4NIpkm/ZtAghyX6VpCCmD0nkQXqgWk5I6WNNOmJ7Bw9jO7Nrl6cyfAp2WL+CBoe/nnNb
 O8tQXJDjZqucwy8T+QHXT6h5xXMXOYqn7Zwi08pHAr+CrERS5MONe2g8fcc8/xVcBE2g7R+kjx
 SFQ=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Apr 2022 22:09:50 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KfksT1wtyz1SVp3
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 22:09:49 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1649999388; x=1652591389; bh=wC6/PVYH+J9es8aT7sK5ZaGwsGnDQHOFu7y
        4PW6r0NI=; b=D8kdC3rz3pjqnugRL+G3XHXL6Ng78iZSZCza4fEMQpTN/xdgY6D
        ndgbPRv8Ii6RTniwYP01qFwFHzH91r1LoAWx6xGwWEN+Qsp3Ex2YpjoRKlcblFjc
        7yjQF4oBeK9egOucgCIrr2m+tKTIlJA0mcKIvKIgWCVnz5iEJtEs0vxeju2wZT96
        jtBkpdSzig+EY3uiGMCOqAfDYf4ob5UMdfn63Y/7o6floZGBngeQCZ8K+n+vY3d5
        lYsSP/0Lz/G5amM7P4+yygELabSZDZHGZG/YfdQpCLMrO4FBxFoQbF9pdD3HvN17
        o1OWdE4/X82Vq8Fyie48I/oIcM5G/NLyIZA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id D0Xf8_y7-Zyx for <linux-xfs@vger.kernel.org>;
        Thu, 14 Apr 2022 22:09:48 -0700 (PDT)
Received: from [10.225.163.9] (unknown [10.225.163.9])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KfksM3c9Fz1Rvlx;
        Thu, 14 Apr 2022 22:09:43 -0700 (PDT)
Message-ID: <62ebc311-e5ef-cea5-5236-0c83d1a3eb64@opensource.wdc.com>
Date:   Fri, 15 Apr 2022 14:09:42 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 10/27] mm: use bdev_is_zoned in claim_swapfile
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     dm-devel@redhat.com, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-um@lists.infradead.org,
        linux-block@vger.kernel.org, drbd-dev@lists.linbit.com,
        nbd@other.debian.org, ceph-devel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, linux-bcache@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org,
        linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        cluster-devel@redhat.com, jfs-discussion@lists.sourceforge.net,
        linux-nilfs@vger.kernel.org, ntfs3@lists.linux.dev,
        ocfs2-devel@oss.oracle.com, linux-mm@kvack.org
References: <20220415045258.199825-1-hch@lst.de>
 <20220415045258.199825-11-hch@lst.de>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220415045258.199825-11-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 4/15/22 13:52, Christoph Hellwig wrote:
> Use the bdev based helper instead of poking into the queue.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  mm/swapfile.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 63c61f8b26118..4c7537162af5e 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -2761,7 +2761,7 @@ static int claim_swapfile(struct swap_info_struct *p, struct inode *inode)
>  		 * write only restriction.  Hence zoned block devices are not
>  		 * suitable for swapping.  Disallow them here.
>  		 */
> -		if (blk_queue_is_zoned(p->bdev->bd_disk->queue))
> +		if (bdev_is_zoned(p->bdev))
>  			return -EINVAL;
>  		p->flags |= SWP_BLKDEV;
>  	} else if (S_ISREG(inode->i_mode)) {

Looks good.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research
