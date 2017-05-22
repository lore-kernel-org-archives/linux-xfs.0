Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:30199 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761033AbdEVSwc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 May 2017 14:52:32 -0400
Message-ID: <1495479147.6967.70.camel@linux.intel.com>
Subject: Re: [PATCH 13/23] md: namespace private helper names
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Mon, 22 May 2017 21:52:27 +0300
In-Reply-To: <20170518062705.25902-14-hch@lst.de>
References: <20170518062705.25902-1-hch@lst.de>
         <20170518062705.25902-14-hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>, David Howells <dhowells@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org

On Thu, 2017-05-18 at 08:26 +0200, Christoph Hellwig wrote:
> From: Amir Goldstein <amir73il@gmail.com>
> 
> The md private helper uuid_equal() collides with a generic helper
> of the same name.
> 
> Rename the md private helper to md_uuid_equal() and do the same for
> md_sb_equal().
> 

While patch is good, shouldn't it go before we introduce those helpers?

> Cc: Shaohua Li <shli@kernel.org>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/md/md.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 82f798be964f..65795cc4cb7d 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -825,7 +825,7 @@ static int read_disk_sb(struct md_rdev *rdev, int
> size)
>  	return -EINVAL;
>  }
>  
> -static int uuid_equal(mdp_super_t *sb1, mdp_super_t *sb2)
> +static int md_uuid_equal(mdp_super_t *sb1, mdp_super_t *sb2)
>  {
>  	return	sb1->set_uuid0 == sb2->set_uuid0 &&
>  		sb1->set_uuid1 == sb2->set_uuid1 &&
> @@ -833,7 +833,7 @@ static int uuid_equal(mdp_super_t *sb1,
> mdp_super_t *sb2)
>  		sb1->set_uuid3 == sb2->set_uuid3;
>  }
>  
> -static int sb_equal(mdp_super_t *sb1, mdp_super_t *sb2)
> +static int md_sb_equal(mdp_super_t *sb1, mdp_super_t *sb2)
>  {
>  	int ret;
>  	mdp_super_t *tmp1, *tmp2;
> @@ -1025,12 +1025,12 @@ static int super_90_load(struct md_rdev *rdev,
> struct md_rdev *refdev, int minor
>  	} else {
>  		__u64 ev1, ev2;
>  		mdp_super_t *refsb = page_address(refdev->sb_page);
> -		if (!uuid_equal(refsb, sb)) {
> +		if (!md_uuid_equal(refsb, sb)) {
>  			pr_warn("md: %s has different UUID to %s\n",
>  				b, bdevname(refdev->bdev,b2));
>  			goto abort;
>  		}
> -		if (!sb_equal(refsb, sb)) {
> +		if (!md_sb_equal(refsb, sb)) {
>  			pr_warn("md: %s has same UUID but different
> superblock to %s\n",
>  				b, bdevname(refdev->bdev, b2));
>  			goto abort;

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
