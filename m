Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35401 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753333AbdERXQY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 May 2017 19:16:24 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v4IN8qtB008929
        for <linux-xfs@vger.kernel.org>; Thu, 18 May 2017 19:16:24 -0400
Received: from e23smtp07.au.ibm.com (e23smtp07.au.ibm.com [202.81.31.140])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ahjca691d-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Thu, 18 May 2017 19:16:23 -0400
Received: from localhost
        by e23smtp07.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
        Fri, 19 May 2017 09:16:20 +1000
Subject: Re: [PATCH 15/23] block: remove blk_part_pack_uuid
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Date: Thu, 18 May 2017 19:15:15 -0400
In-Reply-To: <20170518062705.25902-16-hch@lst.de>
References: <20170518062705.25902-1-hch@lst.de>
         <20170518062705.25902-16-hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <1495149315.3404.2.camel@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>, David Howells <dhowells@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org

On Thu, 2017-05-18 at 08:26 +0200, Christoph Hellwig wrote:
> This helper was only used by IMA of all things, which would get spurious
> errors if CONFIG_BLOCK is disabled.  Just opencode the call there.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Mimi Zohar <zohar@linux.vnet.ibm.com>

> ---
>  include/linux/genhd.h               | 11 -----------
>  security/integrity/ima/ima_policy.c |  3 +--
>  2 files changed, 1 insertion(+), 13 deletions(-)
> 
> diff --git a/include/linux/genhd.h b/include/linux/genhd.h
> index acff9437e5c3..e619fae2f037 100644
> --- a/include/linux/genhd.h
> +++ b/include/linux/genhd.h
> @@ -219,12 +219,6 @@ static inline struct gendisk *part_to_disk(struct hd_struct *part)
>  	return NULL;
>  }
> 
> -static inline int blk_part_pack_uuid(const u8 *uuid_str, u8 *to)
> -{
> -	uuid_be_to_bin(uuid_str, (uuid_be *)to);
> -	return 0;
> -}
> -
>  static inline int disk_max_parts(struct gendisk *disk)
>  {
>  	if (disk->flags & GENHD_FL_EXT_DEVT)
> @@ -736,11 +730,6 @@ static inline dev_t blk_lookup_devt(const char *name, int partno)
>  	dev_t devt = MKDEV(0, 0);
>  	return devt;
>  }
> -
> -static inline int blk_part_pack_uuid(const u8 *uuid_str, u8 *to)
> -{
> -	return -EINVAL;
> -}
>  #endif /* CONFIG_BLOCK */
> 
>  #endif /* _LINUX_GENHD_H */
> diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
> index 3ab1067db624..49fbc3e8f012 100644
> --- a/security/integrity/ima/ima_policy.c
> +++ b/security/integrity/ima/ima_policy.c
> @@ -717,8 +717,7 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
>  				break;
>  			}
> 
> -			result = blk_part_pack_uuid(args[0].from,
> -						    entry->fsuuid);
> +			result = uuid_to_bin(args[0].from, (uuid_t *)&entry->fsuuid);
>  			if (!result)
>  				entry->flags |= IMA_FSUUID;
>  			break;

