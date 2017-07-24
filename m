Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([45.249.212.187]:10253 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751254AbdGXGeh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jul 2017 02:34:37 -0400
Subject: Re: [PATCH 2/2 V6] xfs: Properly retry failed inode items in case of
 error during buffer writeback
References: <20170720131508.13582-1-cmaiolino@redhat.com>
 <20170720131508.13582-3-cmaiolino@redhat.com>
From: Hou Tao <houtao1@huawei.com>
Message-ID: <6fce7153-94a3-c2f6-70e4-92e70bca633b@huawei.com>
Date: Mon, 24 Jul 2017 14:34:27 +0800
MIME-Version: 1.0
In-Reply-To: <20170720131508.13582-3-cmaiolino@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org

Hi Carlos,

On 2017/7/20 21:15, Carlos Maiolino wrote:
> +	struct xfs_inode	*ip = INODE_ITEM(lip)->ili_inode;
> +
> +	ASSERT(xfs_isiflocked(ip));
Is it better to use "ASSERT(xfs_isiflocked(INODE_ITEM(lip)->ili_inode)) instead" ?
Otherwise there will be a gcc warning about the unused variable "ip" when
both CONFIG_XFS_DEBUG and CONFIG_XFS_WARN are turned off.


