Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45396 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754336AbdGXLPY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 24 Jul 2017 07:15:24 -0400
Date: Mon, 24 Jul 2017 13:15:20 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 2/2 V6] xfs: Properly retry failed inode items in case of
 error during buffer writeback
Message-ID: <20170724111520.d46rsxvfqfrz5erv@eorzea.usersys.redhat.com>
References: <20170720131508.13582-1-cmaiolino@redhat.com>
 <20170720131508.13582-3-cmaiolino@redhat.com>
 <6fce7153-94a3-c2f6-70e4-92e70bca633b@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6fce7153-94a3-c2f6-70e4-92e70bca633b@huawei.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Hou Tao <houtao1@huawei.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jul 24, 2017 at 02:34:27PM +0800, Hou Tao wrote:
> Hi Carlos,
> 
> On 2017/7/20 21:15, Carlos Maiolino wrote:
> > +	struct xfs_inode	*ip = INODE_ITEM(lip)->ili_inode;
> > +
> > +	ASSERT(xfs_isiflocked(ip));
> Is it better to use "ASSERT(xfs_isiflocked(INODE_ITEM(lip)->ili_inode)) instead" ?
> Otherwise there will be a gcc warning about the unused variable "ip" when
> both CONFIG_XFS_DEBUG and CONFIG_XFS_WARN are turned off.
> 

Yup, you are right, I missed it during testing thanks to my Ignore stdout while
building :)

I'll fix it, thanks for catching it

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
