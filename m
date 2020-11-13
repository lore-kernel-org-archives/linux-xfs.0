Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 562CDC388F9
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Nov 2020 03:55:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E129A22243
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Nov 2020 03:55:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dfjyrSif"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbgKMDzB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Nov 2020 22:55:01 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:33450 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726156AbgKMDzB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Nov 2020 22:55:01 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AD3rUrR100506
        for <linux-xfs@vger.kernel.org>; Fri, 13 Nov 2020 03:55:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=XF3CfjWNB1EPMlgYXfoj3Hdkp9InSCTK2/Spp8M48cA=;
 b=dfjyrSifUvlDFzHoS3OwihsYdeeaFrbGEsJcHbrNkqXRpp6u2wn2jTt4TlJNzQj+HAvx
 +hZ9UAnZSDwb9BT7OZtUyOno7eFfYHLvES980Izi7GkGfUW80KOw+BIPtAfa0CsdVuQz
 3U4UNsbc5FELXl7icu0X7rjdA21xfihlc+hdSnHKksQzj9uDG3rYlp57PPwuMjGmVY97
 +/R/34i2ZL857Hk+SJWJeS49PJ9jLO+23hSEVQoyCPbJinj/oeHKPMXZddbhjx+O0HS5
 rFDTZ+sGQbsQ+HcyWiiPA0SQhTrGuhdfnKKuFwYgeNi1DaQX92wy/R43M7IXWWYM5ISr +g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 34p72exucr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 13 Nov 2020 03:55:00 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AD3pCl1192732
        for <linux-xfs@vger.kernel.org>; Fri, 13 Nov 2020 03:52:59 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 34rt575bry-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 13 Nov 2020 03:52:59 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AD3qxpH015068
        for <linux-xfs@vger.kernel.org>; Fri, 13 Nov 2020 03:52:59 GMT
Received: from [192.168.1.223] (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Nov 2020 19:52:58 -0800
Subject: Re: [PATCH v13 14/14] xfsprogs: Add delayed attribute flag to cmd
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20201023063306.7441-1-allison.henderson@oracle.com>
 <20201023063306.7441-15-allison.henderson@oracle.com>
 <20201110234834.GM9695@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <6c04237c-e8d1-5b53-329d-735a8407b555@oracle.com>
Date:   Thu, 12 Nov 2020 20:52:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201110234834.GM9695@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9803 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011130020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9803 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 suspectscore=0 lowpriorityscore=0 adultscore=0 phishscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011130020
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 11/10/20 4:48 PM, Darrick J. Wong wrote:
> On Thu, Oct 22, 2020 at 11:33:06PM -0700, Allison Henderson wrote:
>> From: Allison Collins <allison.henderson@oracle.com>
>>
>> mkfs: enable feature bit in mkfs via the '-n delattr' parameter.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> 
> I think it's sufficient to have one signoff here.
Sorry, still cleaning those out

> 
>> ---
>>   mkfs/xfs_mkfs.c | 24 +++++++++++++++++++++++-
>>   1 file changed, 23 insertions(+), 1 deletion(-)
>>
>> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
>> index 8fe149d..e18fb3a 100644
>> --- a/mkfs/xfs_mkfs.c
>> +++ b/mkfs/xfs_mkfs.c
>> @@ -94,6 +94,7 @@ enum {
>>   	N_SIZE = 0,
>>   	N_VERSION,
>>   	N_FTYPE,
>> +	N_DELATTR,
>>   	N_MAX_OPTS,
>>   };
>>   
>> @@ -547,6 +548,7 @@ static struct opt_params nopts = {
>>   		[N_SIZE] = "size",
>>   		[N_VERSION] = "version",
>>   		[N_FTYPE] = "ftype",
>> +		[N_DELATTR] = "delattr",
>>   	},
>>   	.subopt_params = {
>>   		{ .index = N_SIZE,
>> @@ -569,6 +571,12 @@ static struct opt_params nopts = {
>>   		  .maxval = 1,
>>   		  .defaultval = 1,
>>   		},
>> +		{ .index = N_DELATTR,
>> +		  .conflicts = { { NULL, LAST_CONFLICT } },
>> +		  .minval = 0,
>> +		  .maxval = 1,
>> +		  .defaultval = 1,
>> +		},
>>   	},
>>   };
>>   
>> @@ -742,6 +750,7 @@ struct sb_feat_args {
>>   	bool	reflink;		/* XFS_SB_FEAT_RO_COMPAT_REFLINK */
>>   	bool	nodalign;
>>   	bool	nortalign;
>> +	bool	delattr;		/* XFS_SB_FEAT_INCOMPAT_LOG_DELATTR */
>>   };
>>   
>>   struct cli_params {
>> @@ -873,7 +882,7 @@ usage( void )
>>   /* log subvol */	[-l agnum=n,internal,size=num,logdev=xxx,version=n\n\
>>   			    sunit=value|su=num,sectsize=num,lazy-count=0|1]\n\
>>   /* label */		[-L label (maximum 12 characters)]\n\
>> -/* naming */		[-n size=num,version=2|ci,ftype=0|1]\n\
>> +/* naming */		[-n size=num,version=2|ci,ftype=0|1,delattr=0|1]\n\
>>   /* no-op info only */	[-N]\n\
>>   /* prototype file */	[-p fname]\n\
>>   /* quiet */		[-q]\n\
>> @@ -1592,6 +1601,9 @@ naming_opts_parser(
>>   	case N_FTYPE:
>>   		cli->sb_feat.dirftype = getnum(value, opts, subopt);
>>   		break;
>> +	case N_DELATTR:
>> +		cli->sb_feat.delattr = getnum(value, &nopts, N_DELATTR);
>> +		break;
>>   	default:
>>   		return -EINVAL;
>>   	}
>> @@ -1988,6 +2000,14 @@ _("reflink not supported without CRC support\n"));
>>   		cli->sb_feat.reflink = false;
>>   	}
>>   
>> +	if ((cli->sb_feat.delattr) &&
>> +	    cli->sb_feat.dir_version == 4) {
>> +		fprintf(stderr,
>> +_("delayed attributes not supported on v4 filesystems\n"));
> 
> I think this should move a few lines up to the big batch of code that
> turns off all the V5 features if crcs aren't enabled.
> 
> TBH this should silently turn off delattrs unless the admin explicitly
> enabled them, because one day this will be enabled by default.
Ok, I see it.  Will do.

> 
> --D
> 
>> +		usage();
>> +		cli->sb_feat.delattr = false;
>> +	}
>> +
>>   	if ((cli->fsx.fsx_xflags & FS_XFLAG_COWEXTSIZE) &&
>>   	    !cli->sb_feat.reflink) {
>>   		fprintf(stderr,
>> @@ -2953,6 +2973,8 @@ sb_set_features(
>>   		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_RMAPBT;
>>   	if (fp->reflink)
>>   		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_REFLINK;
>> +	if (fp->delattr)
>> +		sbp->sb_features_log_incompat |= XFS_SB_FEAT_INCOMPAT_LOG_DELATTR;
>>   
>>   	/*
>>   	 * Sparse inode chunk support has two main inode alignment requirements.
>> -- 
>> 2.7.4
>>
