Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 559FC7CA0
	for <xfs@oss.sgi.com>; Mon, 21 Mar 2016 07:17:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 16C12304048
	for <xfs@oss.sgi.com>; Mon, 21 Mar 2016 05:17:32 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id e6jyWY81YXTVEJb0 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 21 Mar 2016 05:17:31 -0700 (PDT)
Date: Mon, 21 Mar 2016 13:17:26 +0100
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [RFC PATCH 2/9] dm: add methods to set and get reserved space
Message-ID: <20160321121726.GC25476@redhat.com>
References: <1458225037-24155-1-git-send-email-bfoster@redhat.com>
	<1458225037-24155-3-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1458225037-24155-3-git-send-email-bfoster@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

> +static int dm_blk_reserve_space(struct block_device *bdev, sector_t nr_sects)
> +{
> +
> +static int dm_blk_get_reserved_space(struct block_device *bdev,
> +				     sector_t *nr_sects)
> +{

These two functions are almost identical, what about refactoring it to a single
function like dm_blk_reserved_space(), and maybe adding a flags argument, for
choosing between set/get reserved space? Or maybe just add the common parts of
these two functions inside a helper function or a macro?!

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
