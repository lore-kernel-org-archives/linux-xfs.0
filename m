Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37872 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755375AbdERXRY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 May 2017 19:17:24 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v4IN8qCT008967
        for <linux-xfs@vger.kernel.org>; Thu, 18 May 2017 19:17:24 -0400
Received: from e23smtp06.au.ibm.com (e23smtp06.au.ibm.com [202.81.31.148])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ahjca6a0y-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Thu, 18 May 2017 19:17:23 -0400
Received: from localhost
        by e23smtp06.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
        Fri, 19 May 2017 09:17:20 +1000
Subject: Re: [PATCH 16/23] ima/policy: switch to use uuid_t
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Date: Thu, 18 May 2017 19:16:14 -0400
In-Reply-To: <20170518062705.25902-17-hch@lst.de>
References: <20170518062705.25902-1-hch@lst.de>
         <20170518062705.25902-17-hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <1495149374.3404.3.camel@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>, David Howells <dhowells@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org

On Thu, 2017-05-18 at 08:26 +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Thanks!
Acked-by: Mimi Zohar <zohar@linux.vnet.ibm.com>

> ---
>  security/integrity/ima/ima_policy.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
> index 49fbc3e8f012..da3e7d50e0d7 100644
> --- a/security/integrity/ima/ima_policy.c
> +++ b/security/integrity/ima/ima_policy.c
> @@ -61,7 +61,7 @@ struct ima_rule_entry {
>  	enum ima_hooks func;
>  	int mask;
>  	unsigned long fsmagic;
> -	u8 fsuuid[16];
> +	uuid_t fsuuid;
>  	kuid_t uid;
>  	kuid_t fowner;
>  	bool (*uid_op)(kuid_t, kuid_t);    /* Handlers for operators       */
> @@ -244,7 +244,7 @@ static bool ima_match_rules(struct ima_rule_entry *rule, struct inode *inode,
>  	    && rule->fsmagic != inode->i_sb->s_magic)
>  		return false;
>  	if ((rule->flags & IMA_FSUUID) &&
> -	    memcmp(rule->fsuuid, inode->i_sb->s_uuid, sizeof(rule->fsuuid)))
> +	    memcmp(&rule->fsuuid, inode->i_sb->s_uuid, sizeof(rule->fsuuid)))
>  		return false;
>  	if ((rule->flags & IMA_UID) && !rule->uid_op(cred->uid, rule->uid))
>  		return false;
> @@ -711,13 +711,12 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
>  		case Opt_fsuuid:
>  			ima_log_string(ab, "fsuuid", args[0].from);
> 
> -			if (memchr_inv(entry->fsuuid, 0x00,
> -				       sizeof(entry->fsuuid))) {
> +			if (uuid_is_null(&entry->fsuuid)) {
>  				result = -EINVAL;
>  				break;
>  			}
> 
> -			result = uuid_to_bin(args[0].from, (uuid_t *)&entry->fsuuid);
> +			result = uuid_to_bin(args[0].from, &entry->fsuuid);
>  			if (!result)
>  				entry->flags |= IMA_FSUUID;
>  			break;
> @@ -1086,7 +1085,7 @@ int ima_policy_show(struct seq_file *m, void *v)
>  	}
> 
>  	if (entry->flags & IMA_FSUUID) {
> -		seq_printf(m, "fsuuid=%pU", entry->fsuuid);
> +		seq_printf(m, "fsuuid=%pU", &entry->fsuuid);
>  		seq_puts(m, " ");
>  	}
> 

