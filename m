Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F20D6C77B7C
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 08:55:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242852AbjEZIzA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 May 2023 04:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242920AbjEZIyy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 May 2023 04:54:54 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E00C6194
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:54:50 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34Q84nKZ008677;
        Fri, 26 May 2023 08:54:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2023-03-30;
 bh=QprqPtTADS9RgYKhEnuV4qqYqJs9UuJ4CLeLJo5+iHo=;
 b=1fiOA28ziD+ZYMCcW1Yh+mnYqT+VyQJkqfd0++OlDgyFxyhJkP4EOTiXPBh/pET2mWlD
 i53CJRgYZRbsl/UhvyehHveiqV0YuuH15OX/LrKfJNyXco9pgueOwZCG3l1hmFLe+O3n
 b516vONCjSbKA4EZYvULkqtQc4C1/uIcWNAc1MZbfq7drhnJe3Fk6JaUODzVxNifVzQ8
 +Z0pxfx5j7zb2pKA9FJcYpXAsUY+HRqU8ufLNdQsjP0PN3XF4gxT4sl2PzPUsYZBvODA
 yZhzFhqAqaBAW9l8yTzopFUc+vMNLwlR6y5VAlF06Tg2OsQp/+N8FEEd3uPcaUuueJum wg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qtrxfg4qc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 May 2023 08:54:47 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34Q6VbTc027511;
        Fri, 26 May 2023 08:54:46 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qqk2heajn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 May 2023 08:54:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zm7SHUSbZIB85COjp+izJScSxgv/zwLxR37MUwYc5103b5dyUPWOPO2qRbS1ebm7cTxtbrdeit/Zxn25/jHYf5MZr/Mbjw8UIbX67LdWdfOzADZTEYVfckvZZIWu9JqoF8YR7D9utY74rq1WmDpw7VvxQEjlJ1dpGthu8ssWjwVNO0lXeiWjF7ADa++gAoI5IOjxMQkMynqo+2nM2c362SDH1dcQ0RiYMtT0UupEytxjBhgPgBGQ06TWijs9io33b0dx7jJ006z+EYhq3nZoq9UHJyl77PVSQlqisURNbUT4NBMrZZ+IohfDbPiBf+UybP76Vs42RMhhCW4N3RFBxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QprqPtTADS9RgYKhEnuV4qqYqJs9UuJ4CLeLJo5+iHo=;
 b=ikPJHAFQLH/ULwW/fYxKYXmwVmwTwb24d6rT2+h4opxjXXZJSlss6ULiOaJ3Rnn5YQE2G8R6u7nXZjkfEyhIioxTbScb+2fHk2K6Qcp8Ba0WSRg8Hf47w27zSxjiwascU43pGBo2wXtHIN+rY3Ln5Ysp+eWvgd+JSHrrgS8Guf9nM8MeSWzc9pYyLcd8tOdcNlxaQOvPhwpARPJIfpFNRRjVf9zcL97TKhb3tIYd7T57hA+fv48DcYltbX2ZAF+RAERqCz3ni9LC7u25RkuNKR22+50WT1V3goXTkXGuYCwDWZaupjrvOs+i3QXUqLIBfJ0XddB9/AiMxTRrcTAzNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QprqPtTADS9RgYKhEnuV4qqYqJs9UuJ4CLeLJo5+iHo=;
 b=n1UAsQg+fQuIy3USf2aLgAhrJFEbKqpEy3iLfO5hMN8VWUbNHL+BViexTOOxIZd5HkcDtQ4k2LzjlloEjfCKpdsaYZn8ktOAwNf0BCS0GzfTBxhpO1y61S0njwmuOunSt4yyiU5QNkUg6Lv3tQZmZl8Wpnud+k+sDyZSUPQ7i58=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by PH0PR10MB4439.namprd10.prod.outlook.com (2603:10b6:510:41::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.17; Fri, 26 May
 2023 08:54:44 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1%6]) with mapi id 15.20.6433.017; Fri, 26 May 2023
 08:54:44 +0000
References: <20230523090050.373545-1-chandan.babu@oracle.com>
 <20230523090050.373545-23-chandan.babu@oracle.com>
 <20230523180602.GA11620@frogsfrogsfrogs>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 22/24] mdrestore: Define mdrestore ops for v2 format
Date:   Thu, 25 May 2023 17:40:24 +0530
In-reply-to: <20230523180602.GA11620@frogsfrogsfrogs>
Message-ID: <87ilcfiib8.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0003.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::20) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH0PR10MB4439:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ebdca88-29d5-4d86-1176-08db5dc6d995
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m8l493eWJxKbx+D7o9LMKymQJGFQ7HSVV8d75G4Rw6Z/4MJkpHg+W9Hs/CWT5kUXUQ9s3aqgFhijYjrXVbhbfJz5R1WLIG5nM0sfU1Xk4N6wEGGM+QfV0gmeyWd2XVPiGBKZu1FH8mso2bv8nhfJMPRgXK9HC4VUycFk/zJPMSXfKrIfeYFvCACwX6YYTW5cLw3CrF3JhUGf+LrlLfK5Q/1u5DyCbC7Tp1/aXZfPNgVvTQHD54TLkBV7LomCN4yMZdM01ih7mesimqXKrh7vPdFt6op3snxgwvLHPk2R5i2XxdUEzLTs6N1nH+GIcgi3Uo1zGPHb26bzOHib+50UjPYz4/2MhND3ZmhlS1STjWNq4wSxk/UWLF8KJRvrzNmo1DBQLIhRk9pZ+xsIexryRLJXmOSMiJ9QWtSWO4+6TxeuqDIFM7D4ShNu1WYJiS8YDdDR6zfq0uRQqu+Iy9kzJVNzvMaFIIAeHOdGkAQ2GzXhchlFHS9/8A8HbDxbMnSIjBlEjuzD3TObqOA4Sg553CYQIEgcmEMkZj5h5x9radbD4Qphrm1rxHh3VlNGPRF4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(346002)(396003)(136003)(366004)(39860400002)(376002)(451199021)(83380400001)(2906002)(186003)(33716001)(86362001)(38100700002)(66476007)(5660300002)(66556008)(66946007)(316002)(6486002)(6666004)(41300700001)(8676002)(8936002)(4326008)(6916009)(478600001)(26005)(53546011)(6506007)(6512007)(9686003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gI787FMhdPG0CvPhzc54VF+ckBGhfCzaF/NcGefZBkLql1zLX2RNnFpepCz3?=
 =?us-ascii?Q?6gZrfUu1oZB7393O5fF3dXpK4r03Z4euZT8dlblrsdsRsHiReOqVrapMkEOL?=
 =?us-ascii?Q?UBvSa2RvogdYui4A0nYGhFWX6AB1k+snX1XmbTTJNX/jCgE33dP9PRQNk+sw?=
 =?us-ascii?Q?DAqWLT3FO8RS/7bAnkSMSI18b2lGHks6DHMzKkgmd9SsqmCexP5qNh6jlPwM?=
 =?us-ascii?Q?rBoK7/q3ZPZyg7tjmChbhkUvfd/rz9ADVxaVjhasltJNTKlemoRupOH70OSY?=
 =?us-ascii?Q?WTRzGDPtRdcF8DGi+I2DTt0cieuSUYYJ3iMq78tdVst0re8b31uEmj2SrUKN?=
 =?us-ascii?Q?LN/8yhBAMOtJhfwbtS0CBiNqlE9S2rmiLpACWUFxyhF7rGwGJpPzRQmKNUsl?=
 =?us-ascii?Q?uW0sLzbhEU4iK0sWrF4SI2ygNrymvWz9Mocf7K/wjKMSR1QwQYAxBhHG7QNw?=
 =?us-ascii?Q?cwyVGAe6JXD7rKUpi05vDd3s2CABeqxEAYgt+3Ip2If7zvvXUYfHoO9zl6ZI?=
 =?us-ascii?Q?5EWZixAfNPacLygvW8UWGsy3syO/5TzmuBSoLCsWTg0pEKPdvOBYL8PomOnV?=
 =?us-ascii?Q?ri+6ilEpx+nzqHfKM47p+8NTstpNqrx7w3Bth7NUoiMFyTqIK0pnTEyklrW+?=
 =?us-ascii?Q?Stq9A0jxpH1ULMa8MJQlzatc+Kgn6Go5u26iE+K1z+qYICct3ZNH43/+urV3?=
 =?us-ascii?Q?vcNnPw/EhLYw79H0MUbjTWhNaByU9pmOw1oD6h16fC2rB6WTnixLwsVQ9MMK?=
 =?us-ascii?Q?4wLgOPVyx4gG1r9N7O7rPQOYu79VBo2krtpWVW/LjhhvCWd97CU46QlivfDY?=
 =?us-ascii?Q?YiX7mEg8yV9er9NmdfSjW/MTXF/YzFVcTghPI5L8PgeNAliZgBc4GEMeeWPw?=
 =?us-ascii?Q?I4KUhLg2kF417V3Gu2UuLFTcl7UBA2XpZtN1M8Sf3yl6aghC3+nA1yQxL6YU?=
 =?us-ascii?Q?53UphgAkqeQEzIXAYol+4Pl+hCOr3to7oo0f7sKBkT1JucFz8/o6AiYT0tb6?=
 =?us-ascii?Q?PTwT7dVFq4IgYwYwvrs/Ga1axkoiUoLjbaQY4igrMG/1GRGseryOFzRGknoW?=
 =?us-ascii?Q?ZSX+54MPH3gWW8IMtmz7hMEoCDDdzy/S9oAXP+0+xN+C7yVjcle9sSKusnt9?=
 =?us-ascii?Q?J4FF8L5Lsvc0p3z4oGOdfTve92sS8Y2PeamtLg8e8BaPMkdnNemGaOYaQg+U?=
 =?us-ascii?Q?xSEY55hgvXRL/UziLlBSyHJwkmgat1NRNf7oVZEuY/f43u2hF4zgGTLwNRXS?=
 =?us-ascii?Q?Q9uhOZFv8IGO3Hlw3PunILBQQ5c7Tm12tBZ3vmDxup6vpgMJWxzm9MegewDZ?=
 =?us-ascii?Q?kRxEUFAZe4VXFzGoHw0Q4w9PKbBsFNQBX1EarS4vB2bEQQQwXu3S6dhTjzmR?=
 =?us-ascii?Q?p9Sm91Zrnk6nDYnbSPVqF22TaHyyo8oZVPPazGMyRrVGje6lKexsz5JC7zDu?=
 =?us-ascii?Q?YhPDX0eSESVX6DLh3zPwwrauBu0KS/0ln019L49KWKa3PcpHlpcjRDKEvLRu?=
 =?us-ascii?Q?PwoX0Gr7SO4Mo5iPkXfOLp0NUaU9g0tmsC02Vqtp7oCqQoT2q1PRpKEtw6Rf?=
 =?us-ascii?Q?f2ZcoIBET3WERA7UEbgn/i2EhkLVx2Tg1FBblFAYxKrIiJUhrS+hNCHLGK4q?=
 =?us-ascii?Q?qw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: iUkBYwsWCuXg4uN6BwC+vyv4y9XiwPq9WEn0wWvWnSUBNj61SAvVEixikdwajYLVL3XW3IloLajuWtsCsdbyEj5sG1nisUak3wad41cunp7Cdb2HCEuFVKH1+M/ZiJbDwcFwb1m7JOO0Ql8tRljz7uWFseSJvzF6ObVa9oARywxjFJMYRAYV5cYN4zgBqy1oH7fVzS9bHjhopxdq/rMpesaiANrB9T7hFAq0ZWvoKcw4HhdiocHZ3sDjpyIQwgx2DPB+KlioaWEbqUg/JACDb1MtG4FXHv/EqYoO7hOrGDNTzJzCV+Pi3+w3D48vpZcuuFlg3kmNCoVu7MMtZ8zpy4FsLyuyNpUUqesZfqbqiFXajBqJGXFZQGaG6tLr0zhhOiH2q0KwZUqYppkJvK2ijkxHP1g60/pevz1kVku1URXaZRjQRPvatoPj70HPiomBAwT8IYo4ni37E4L+KAfIj15oaHwIu0J/olTER3hqu7kYCOgxbJ6defpzaFJll2psUdOKHTPqziZYe6Pz9ajcHgy5marxOcEG1D2X97viilBDeeNpVni6pVXeDKdqKKLLw6mly2k2Sgn5OwWdF8wy9cBv/J4T4mwaR1QGKbrZ2wAWz+T+2KdlWyVNupDItkNG4ggOUZirLve9jd51qJg5MDNsbHCYwML4LPTqh1vnjlVQ06DPqjFWNf1AW7wWEuUr7dNtch6Y2z2nLkDu0Zk4pRFHuat8HLgLTTIuu5gorcYnIMiXkyWT7cihUOiG2ScVwN4jlD9ep25urNyVxQ+SOBzN8WA3AvXBgZ4nBX2S7b4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ebdca88-29d5-4d86-1176-08db5dc6d995
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2023 08:54:44.1866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eXHk90lR7TJGeGRlQzY4obwlc9+TisgySlq3j1ylxtiDydBIJ9OZMCyy+7trMFVriy9WUp1Aoui0InEGwZe7Pw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4439
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-26_01,2023-05-25_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305260076
X-Proofpoint-GUID: CTOuGy9p7TBFCTk70EXk5B_-hOpcYna4
X-Proofpoint-ORIG-GUID: CTOuGy9p7TBFCTk70EXk5B_-hOpcYna4
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 23, 2023 at 11:06:02 AM -0700, Darrick J. Wong wrote:
> On Tue, May 23, 2023 at 02:30:48PM +0530, Chandan Babu R wrote:
>> This commit adds functionality to restore metadump stored in v2 format.
>> 
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> ---
>>  mdrestore/xfs_mdrestore.c | 209 +++++++++++++++++++++++++++++++++++---
>>  1 file changed, 194 insertions(+), 15 deletions(-)
>> 
>> diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
>> index 615ecdc77..9e06d37dc 100644
>> --- a/mdrestore/xfs_mdrestore.c
>> +++ b/mdrestore/xfs_mdrestore.c
>> @@ -11,7 +11,8 @@ struct mdrestore_ops {
>>  	int (*read_header)(void *header, FILE *mdfp);
>>  	void (*show_info)(void *header, const char *mdfile);
>>  	void (*restore)(void *header, FILE *mdfp, int data_fd,
>> -			bool is_target_file);
>> +			bool is_data_target_file, int log_fd,
>> +			bool is_log_target_file);
>>  };
>>  
>>  static struct mdrestore {
>> @@ -148,7 +149,9 @@ restore_v1(
>>  	void		*header,
>>  	FILE		*mdfp,
>>  	int		data_fd,
>> -	bool		is_target_file)
>> +	bool		is_data_target_file,
>> +	int		log_fd,
>> +	bool		is_log_target_file)
>>  {
>>  	struct xfs_metablock	*mbp = header;
>>  	struct xfs_metablock	*metablock;
>> @@ -203,7 +206,7 @@ restore_v1(
>>  
>>  	((struct xfs_dsb*)block_buffer)->sb_inprogress = 1;
>>  
>> -	verify_device_size(data_fd, is_target_file, sb.sb_dblocks,
>> +	verify_device_size(data_fd, is_data_target_file, sb.sb_dblocks,
>>  			sb.sb_blocksize);
>>  
>>  	bytes_read = 0;
>> @@ -264,6 +267,163 @@ static struct mdrestore_ops mdrestore_ops_v1 = {
>>  	.restore = restore_v1,
>>  };
>>  
>> +static int
>> +read_header_v2(
>> +	void				*header,
>> +	FILE				*mdfp)
>> +{
>> +	struct xfs_metadump_header	*xmh = header;
>> +
>> +	rewind(mdfp);
>
> Does rewind() work if @mdfp is a pipe?
>
> I suspect the best you can do is read the first 4 bytes in main, pick
> the read_header function from that, and have the read_header_v[12] read
> in the rest of the header from there.  I use a lot of:
>
> xfs_metadump -ago /dev/sda - | gzip > foo.md.gz
> gzip -d < foo.md.gz | xfs_mdrestore -g - /dev/sdb
>
> to store compressed metadumps for future reference.
>
> (Well ok I use xz or zstd, but you get the point.)
>

Thanks for pointing out the bug and suggesting the fix.

>> +
>> +	if (fread(xmh, sizeof(*xmh), 1, mdfp) != 1)
>> +		fatal("error reading from metadump file\n");
>> +	if (xmh->xmh_magic != cpu_to_be32(XFS_MD_MAGIC_V2))
>> +		return -1;
>> +
>> +	return 0;
>> +}
>> +
>> +static void
>> +show_info_v2(
>> +	void				*header,
>> +	const char			*mdfile)
>> +{
>> +	struct xfs_metadump_header	*xmh;
>> +	uint32_t			incompat_flags;
>> +
>> +	xmh = header;
>> +	incompat_flags = be32_to_cpu(xmh->xmh_incompat_flags);
>> +
>> +	printf("%s: %sobfuscated, %s log, %s metadata blocks\n",
>> +		mdfile,
>> +		incompat_flags & XFS_MD2_INCOMPAT_OBFUSCATED ? "":"not ",
>> +		incompat_flags & XFS_MD2_INCOMPAT_DIRTYLOG ? "dirty":"clean",
>> +		incompat_flags & XFS_MD2_INCOMPAT_FULLBLOCKS ? "full":"zeroed");
>> +}
>> +
>> +static void
>> +restore_v2(
>> +	void			*header,
>> +	FILE			*mdfp,
>> +	int			data_fd,
>> +	bool			is_data_target_file,
>> +	int			log_fd,
>> +	bool			is_log_target_file)
>> +{
>> +	struct xfs_sb		sb;
>> +	struct xfs_meta_extent	xme;
>> +	char			*block_buffer;
>> +	int64_t			bytes_read;
>> +	uint64_t		offset;
>> +	int			prev_len;
>> +	int			len;
>> +
>> +	if (fread(&xme, sizeof(xme), 1, mdfp) != 1)
>> +		fatal("error reading from metadump file\n");
>> +
>> +	len = be32_to_cpu(xme.xme_len);
>> +	len <<= BBSHIFT;
>
> Do we need to validate xme_addr==0 and xme_len==1 here?
>

Yes, I will add the check.

>> +
>> +	block_buffer = calloc(1, len);
>> +	if (block_buffer == NULL)
>> +		fatal("memory allocation failure\n");
>> +
>> +	if (fread(block_buffer, len, 1, mdfp) != 1)
>> +		fatal("error reading from metadump file\n");
>> +
>> +	libxfs_sb_from_disk(&sb, (struct xfs_dsb *)block_buffer);
>> +
>> +	if (sb.sb_magicnum != XFS_SB_MAGIC)
>> +		fatal("bad magic number for primary superblock\n");
>> +
>> +	if (sb.sb_logstart == 0 && log_fd == -1)
>> +		fatal("External Log device is required\n");
>> +
>> +	((struct xfs_dsb *)block_buffer)->sb_inprogress = 1;
>> +
>> +	verify_device_size(data_fd, is_data_target_file, sb.sb_dblocks,
>> +			sb.sb_blocksize);
>> +
>> +	if (sb.sb_logstart == 0)
>> +		verify_device_size(log_fd, is_log_target_file, sb.sb_logblocks,
>> +				sb.sb_blocksize);
>> +
>> +	bytes_read = 0;
>> +
>> +	do {
>> +		int fd;
>> +
>> +		if (mdrestore.show_progress &&
>> +			(bytes_read & ((1 << 20) - 1)) == 0)
>> +			print_progress("%lld MB read", bytes_read >> 20);
>
> Doesn't this miss a progress report if a metadata extent bumps
> bytes_read across a MB boundary without actually landing on it?  Say
> you've written 1020K, and the next xfs_meta_extent is 8k long.
>
> 	if (metadump.show_progress) {
> 		static int64_t	mb_read;
> 		int64_t		mb_now = bytes_read >> 20;
>
> 		if (mb_now != mb_read) {
> 			print_progress("%lld MB read", mb_now);
> 			mb_read = mb_now;
> 		}
> 	}
>

I will include the above suggestion in the patchset.

>> +
>> +		offset = be64_to_cpu(xme.xme_addr) & XME_ADDR_DEVICE_MASK;
>> +		offset <<= BBSHIFT;
>
> offset = BBTOB(be64_to_cpu() ... ); ?

Yes, this is much better than what I had written.

>
> Also, I'd have thought that XME_ADDR_DEVICE_MASK is what you use to
> decode the device, not what you use to decode the address within a
> device.
>
>> +
>> +		if (be64_to_cpu(xme.xme_addr) & XME_ADDR_DATA_DEVICE)
>> +			fd = data_fd;
>> +		else if (be64_to_cpu(xme.xme_addr) & XME_ADDR_LOG_DEVICE)
>> +			fd = log_fd;
>> +		else
>> +			ASSERT(0);
>
> If you instead defined the constants like this:
>
> #define XME_ADDR_DEVICE_SHIFT	54
> #define XME_ADDR_DEVICE_MASK	((1ULL << XME_ADDR_DEVICE_SHIFT) - 1)

You probably meant to define XME_ADDR_DADDR_MASK.

> #define XME_ADDR_DATA_DEVICE	(0 << XME_ADDR_DEVICE_SHIFT)
> #define XME_ADDR_LOG_DEVICE	(1 << XME_ADDR_DEVICE_SHIFT)
> #define XME_ADDR_RT_DEVICE	(2 << XME_ADDR_DEVICE_SHIFT)
>
> #define XME_ADDR_DEVICE_MASK	(3 << XME_ADDR_DEVICE_SHIFT)
>
> Then the above becomes:
>
> 	offset = BBTOB(be64_to_cpu(xme.xme_addr) & XME_ADDR_DADDR_MASK);
>
> 	switch (be64_to_cpu(xme.xme_addr) & XME_ADDR_DEVICE_MASK) {
> 	case XME_ADDR_DATA_DEVICE:
> 		fd = data_fd;
> 		break;
> 	...
> 	}

Yes, this looks much better. Thanks for your suggestion.

>> +
>> +		if (pwrite(fd, block_buffer, len, offset) < 0)
>> +			fatal("error writing to %s device at offset %llu: %s\n",
>> +				fd == data_fd ? "data": "log", offset,
>> +				strerror(errno));
>> +
>> +                if (fread(&xme, sizeof(xme), 1, mdfp) != 1) {
>> +			if (feof(mdfp))
>> +				break;
>> +			fatal("error reading from metadump file\n");
>> +		}
>> +
>> +		prev_len = len;
>> +		len = be32_to_cpu(xme.xme_len);
>> +		len <<= BBSHIFT;
>> +		if (len > prev_len) {
>> +			void *p;
>> +			p = realloc(block_buffer, len);
>
> Would it be preferable to declare an 8MB buffer and only copy contents
> in that granularity?  Technically speaking, xme_len == -1U would require
> us to allocate a 2TB buffer, wouldn't it?
>

Yes, I agree. I will make the required changes.

>> +			if (p == NULL) {
>> +				free(block_buffer);
>> +				fatal("memory allocation failure\n");
>> +			}
>> +			block_buffer = p;
>> +		}
>> +
>> +		if (fread(block_buffer, len, 1, mdfp) != 1)
>> +			fatal("error reading from metadump file\n");
>> +
>> +		bytes_read += len;
>> +	} while (1);
>> +
>> +	if (mdrestore.progress_since_warning)
>> +		putchar('\n');
>> +
>> +        memset(block_buffer, 0, sb.sb_sectsize);
>
> Tabs not spaces.
>
>> +	sb.sb_inprogress = 0;
>> +	libxfs_sb_to_disk((struct xfs_dsb *)block_buffer, &sb);
>> +	if (xfs_sb_version_hascrc(&sb)) {
>> +		xfs_update_cksum(block_buffer, sb.sb_sectsize,
>> +				offsetof(struct xfs_sb, sb_crc));
>> +	}
>> +
>> +	if (pwrite(data_fd, block_buffer, sb.sb_sectsize, 0) < 0)
>> +		fatal("error writing primary superblock: %s\n",
>> +			strerror(errno));
>> +
>> +	free(block_buffer);
>> +
>> +	return;
>> +}
>> +
>> +static struct mdrestore_ops mdrestore_ops_v2 = {
>> +	.read_header = read_header_v2,
>> +	.show_info = show_info_v2,
>> +	.restore = restore_v2,
>> +};
>> +
>>  static void
>>  usage(void)
>>  {
>> @@ -276,11 +436,16 @@ main(
>>  	int 		argc,
>>  	char 		**argv)
>>  {
>> -	FILE		*src_f;
>> -	int		dst_fd;
>> -	int		c;
>> -	bool		is_target_file;
>> -	struct xfs_metablock	mb;
>> +	struct xfs_metadump_header	xmh;
>> +	struct xfs_metablock		mb;
>
> Hmm...
>
>> +	FILE				*src_f;
>> +	char				*logdev = NULL;
>> +	void				*header;
>> +	int				data_dev_fd;
>> +	int				log_dev_fd;
>> +	int				c;
>> +	bool				is_data_dev_file;
>> +	bool				is_log_dev_file;
>>  
>>  	mdrestore.show_progress = 0;
>>  	mdrestore.show_info = 0;
>> @@ -327,13 +492,18 @@ main(
>>  			fatal("cannot open source dump file\n");
>>  	}
>>  
>> -	if (mdrestore_ops_v1.read_header(&mb, src_f) == 0)
>> +	if (mdrestore_ops_v1.read_header(&mb, src_f) == 0) {
>>  		mdrestore.mdrops = &mdrestore_ops_v1;
>> -	else
>> +		header = &mb;
>> +	} else if (mdrestore_ops_v2.read_header(&xmh, src_f) == 0) {
>> +		mdrestore.mdrops = &mdrestore_ops_v2;
>> +		header = &xmh;
>
> Perhaps define a union of both header formats, then pass that to
> ->read_header, ->show_info, and ->restore?

Sure. I will do that.

-- 
chandan
