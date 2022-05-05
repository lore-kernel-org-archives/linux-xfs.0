Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2A7AC433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 17:45:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344818AbiEERst (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 May 2022 13:48:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351207AbiEERsn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 May 2022 13:48:43 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E86E3D1FB
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 10:45:02 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 245GGqt6024988
        for <linux-xfs@vger.kernel.org>; Thu, 5 May 2022 17:45:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=NL9NVu8eiEyt81kRXeDzNehl3SmO7EXqCQzmcoqQcco=;
 b=n1Htd1QTawY9YL6jl1r8o3662GGo50IortaqttQ2z3XFcchT/jWX16QnsF/Zo7H64vDq
 8XNkxS3ye8ZzgOKVeaT5jnIZb1WgAxNUNfxrahomk9t77FH8tdxT/U0GyGrKlEfhvwhf
 5vK3Q+JI0RV4Ww4nlmsKRdBKAbYryDV/RQbrlgzoO75gjH8Va2lKB3xkySRFSmQcIwEZ
 2lVBV31O39CUuRZGs7uIhG8u5ipHydMvEW1Z+y+GRQ1glnAzQ/e7mJKj5SzUsBh/mwsP
 Koy73L1gJvpDJboUI+vVDkvXCxFixULF9mXOZB/yzn0JpGE7Xj8DSg6PTNWT3AWBhEUN Zw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fruw2m3eu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 May 2022 17:45:00 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 245HeYt8007643
        for <linux-xfs@vger.kernel.org>; Thu, 5 May 2022 17:45:00 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2046.outbound.protection.outlook.com [104.47.51.46])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fus8ycy8x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 May 2022 17:45:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AtQKOC5LIg0vNkyn5iuGmlw3AgMS9YfZxuOC4KKFGWsIOf1RE/0Pd2sLBAIKxCYd5nn76K2OKHM4XE96mdh/AsuOqOwJPK76JC7RIysvOY4wyJ+TjVqMDE0jwsWdGg7idDKOQSjMwBHRZKEO+RM7RWrNYTiG5Wy6ohVoiZbsc2URxGsTUykEn3HMcTl7k2uxMqTRvCirvQ7heUrbHW0wyC65GjNBtqxh6bKsQOtywaYsJaQCRk25tihkSFYWrusZXO3UsBpb1kHqAT2ljNF+EqnWzX8n4N7/Zysr3beSfbf+LLsBDeCdRb7YzFbSAR905CuijIZJ+1/2aGSfU75uBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NL9NVu8eiEyt81kRXeDzNehl3SmO7EXqCQzmcoqQcco=;
 b=DFSnDdfArDp0ncEla4fWFaaARMnhxxh5zKPPNVId9h1ma+WlDOYGy/8d/Pm5exAjUJ4a7ZHRWuOoK7Pd90SAAiw42gsxvitWstkZrkuldIgL7rWIp/NpTmgI6/3farWCd7WzYWVh9WMbYhAGF5OHypDuRl50BX99++/P02HAZYZOvwNfa3isgjpCV3n+uS8yK5V08IQErzrVPlFMhb3JciqJ3QLTRB4Kn3TaAyss3SlUNH+XW7zzit0TFO5r8p/QcVAVQJbDnovU19EISbqjNXwqi5JnqiXWqc3WsE0Bvq+6SPQLZS2nPvCrD5bosPg5iSnKj7GJ2NlLaVFUf6xUIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NL9NVu8eiEyt81kRXeDzNehl3SmO7EXqCQzmcoqQcco=;
 b=qVJzMPg8E+i+LpKaJ0wuCOAyzs/HTLB7QN+DLZjChL2viaNzMllW1j8HsVdy4t9lXxbcaYsMPadwLPuH3HBwptp4SwU2oxc68a25DQDE8qi0JqJiqEQ2zv4Ok53miNGx77KtuQUho5LDEKuBake8FCmpWt60A69dLuB6AM0IgLc=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CY5PR10MB5938.namprd10.prod.outlook.com (2603:10b6:930:2d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Thu, 5 May
 2022 17:44:59 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f%8]) with mapi id 15.20.5206.027; Thu, 5 May 2022
 17:44:59 +0000
Message-ID: <55a17031b8266f3e9e26180dfad6fbb3e8dddb6d.camel@oracle.com>
Subject: Re: [PATCH v2 3/3] xfs: don't set warns on dquots
From:   Alli <allison.henderson@oracle.com>
To:     Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org
Date:   Thu, 05 May 2022 10:44:56 -0700
In-Reply-To: <20220505011815.20075-4-catherine.hoang@oracle.com>
References: <20220505011815.20075-1-catherine.hoang@oracle.com>
         <20220505011815.20075-4-catherine.hoang@oracle.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH0PR07CA0001.namprd07.prod.outlook.com
 (2603:10b6:510:5::6) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 62c97ef5-03b9-49cd-2b6d-08da2ebef954
X-MS-TrafficTypeDiagnostic: CY5PR10MB5938:EE_
X-Microsoft-Antispam-PRVS: <CY5PR10MB5938B0DA6A7723C9F9113E3395C29@CY5PR10MB5938.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SytjPWKaX7WODWNbMVIvMegYoFC4qIpSUHxIaSuIpxTPcE+3FoSS7W+PMGj8QETztvSWl4lXMWPjJnW2gRwXjKrU5IMGMLBdaojRhwlGOc4s/S/lAWDYGXKGO852KYa2WqmMNB250Luh+5v+tqPK6tnj3V/4foe+4gIG5mxtCglQVazaLv+c0A2Fp4HbfCWgl1s3oVxN5+t7rZW3+s2saPQoTlv8jfCDsHdJ6invPrPIUo2Qbx6SVUT0Ly46Yj3k3WisYW7YRB5JAQyCdfB0yDvAEYsEczCFm+GgZNeEC1ocRk71spxRmBvzoQt3y4P10HsCfjFBhVa1aWWnNKha2jwks+fgIrpZ2wVaBKeCpGH6LlIfu1kwAePk5BHHOIC08zyv9wTBXHsnXqlC2Si4BEhxsedML57G9eEmx84rjz8S6d9AOFn0XcZHg7IMjQ35qylhxP7pqJCvqp0+SuQK0To2zFeZnHj0yiPEQUcA9oYOqMruISE6EreHwAhXuOoz1GUh2qHSfKFt7kA0x4eKeJelJjD/2jugqwx95wXV1ut1Zo7OSerFMsBMHuV0c/s4y+B8USqkoXUKWMeb7kui3O/DlzSOAg70GXplDgDFzSd6b1ab8h+CT+D7HNK8dWtI9uyUKr3QJXQMY9oDzxeKwZ/eBee8BXnaKlkH43zmNaOCk/sLJTfq0oZJfgQAISb6nB2EZAjEIzcsKZIc3edPVA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6512007)(4744005)(26005)(38350700002)(8936002)(5660300002)(6506007)(83380400001)(38100700002)(66556008)(66946007)(52116002)(66476007)(86362001)(8676002)(6666004)(2906002)(36756003)(316002)(508600001)(186003)(6486002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N0M0WDlpN2Q5bVZ5eVZnTFJ1a3hramFUL2M4UW04dm1Rb00wNmExdG1IUkNx?=
 =?utf-8?B?Q3hTZHVNOGhvNkxsNXZqWUxNTC9zSEl6MDcrWFYxc3B0bWcxdDIwUGdxdEJD?=
 =?utf-8?B?TTdxUzRMVm4ycHkyU0N5NTFPak1ic3JCUUdoclhFNTdTSUVQY0x4YTVDYmt0?=
 =?utf-8?B?dE80VUNka0FkL2luTXZvdTMwNE0rSjJTa1NkWE5TS1NOYytyOEVLaGUrVWhD?=
 =?utf-8?B?RVhvZHdHVG1NWGROWUxhaVFPdElrV3pIMFMwdnFIQWhIVWN5VHkvWnBWbE1z?=
 =?utf-8?B?OTFYSk1nK3ppc283SzNEdzJHZWNHVlYwR3dmNXJUYTlMUGFGRTljTVJsWklC?=
 =?utf-8?B?dDJJTExvd3JYMGxOcjd0a0MrSENLeDZ6OUtTaWtSNHZMVERXMDdPTGgwdFZE?=
 =?utf-8?B?RVlrQ1JJRllyOFNsSWpLUGZDdG1ORmdwM3RrT3VZeDVwenRaaHluOGw3dFY0?=
 =?utf-8?B?UlIyRm5OMVlEUTdrMTBpWnNRTTNyeDVidlNqUUdUY3RUdTBNeWxzWW0vSzhG?=
 =?utf-8?B?cjFjQUIzcEV5bGJBSDlkOGJMeThFVWRiMm9kdXlHQUFJeUErdHBZWHdSTzZS?=
 =?utf-8?B?MStpZzFFTXJYbEs0UG04TmJ0alE0NFhGNDhZOUZXNk5FbUNQNEdCV3hnNFdq?=
 =?utf-8?B?YXFWZzdxSysrM1I4Zk5OQWVoaUFmQUlFWFNMS1R2ZVRqWXJIUFgzdGlvVWxS?=
 =?utf-8?B?VmcxQnl2Q2lRNDhNdTJXbE9pT1RtelRBcEQyeExLMm01eERPak5IdTBpa3dj?=
 =?utf-8?B?NWp3by9sd25zNHpXK1dpU0tET3BHYzdxRWFTZG4vOWNzVWVyWnJrYnR3RUx1?=
 =?utf-8?B?YklHU25tSVg3M0dJUU82LzNna0ZsM2hYbWhnQ0V3QzlJN2lFcHhwbVM4bldh?=
 =?utf-8?B?OERnbVREQjNMS1hqa0VmdVFiaURpckVpVTdlWmVRVmE5WDhBYVdJdGo3OGw4?=
 =?utf-8?B?d29hdXdIN08waEdTc0w3RHZFeTIvM0xDTFcyWTNyc2tpdlNneU1WVkFVVGVP?=
 =?utf-8?B?WVZKYXgwUWh0eXQyRUZqWDlIL253RlA4YmZDOXYxT1dobTBEM1RkdDRuaHl4?=
 =?utf-8?B?ZWQzM092MjVmWnk1b0RQUHlybWhTNUE5TmJDY2pia3VxNlZqWWJGU25aWnhh?=
 =?utf-8?B?ZGhrQ09pRHlkSGR2S3dDWDZpT1JDMlZGOW9hWU5zS0J0bWlSZ0tGdG10dy9z?=
 =?utf-8?B?ZXczTkFjMGlRYnZtZ1pRMW1kUmM0MFhuTFhycGJJTTlOeHVTcFIvR1loNEsz?=
 =?utf-8?B?S3ltUWViamZQVmhrQ3lxVjgrVDE2U000azlxWFh0WVl0VWNoMzVwMWVMcTdN?=
 =?utf-8?B?L3RqaTJ6NmdKNUZxaE43ZTh0amZiSEhscnphQ1E0RUllU0oxTEpoaUp6ais2?=
 =?utf-8?B?djUxNGl3R1pYaTJQNlBGUFFwYjNuNldyeUMyTHRJR0xWTk92blhVbk4rTUZv?=
 =?utf-8?B?RzdSeUFaU0NQQnhuS3N2TGZxRm52S1FpdC9mb0Z3WjJYMHV2d0h0end1T00y?=
 =?utf-8?B?ck1GMlZWRitnTmcyRjhoU3BtbGxidGZtQVU1dmRDR2JWWEJpQWh4ZTZNMDJy?=
 =?utf-8?B?c05uV2U0b3pIektGWWlEV1JGRFJ5UHl6MkJjL0haL1RtOHRkWTdtSHFySGhG?=
 =?utf-8?B?V2ZDMzdtWW50QUN2bEJ5bzNyTjNERXlXOUxBVFBWUlJ0QWg5WWxLNVNxQ3BH?=
 =?utf-8?B?VXdpSlltY01CcW1nUStpK3l4dFVVaWhuMnRoL3RndWR1TzhjKzYySmpUY2Vv?=
 =?utf-8?B?cXE3MXVhMUZDWGM5NUFzOERYbjBFSWp1UDZNbEwyTmtwdmpjZXM1SzRvZm51?=
 =?utf-8?B?V1ZHM2dkNG9ydkxtR2ZFYVZHQ0xJUFRNRXZzU3RYcHlLbXlMTkQ0c1IyTzBj?=
 =?utf-8?B?emQ1Q1NCdUl6NVV5dDNjSjY2bGsyakU5K3R1USt4NkZpd3ZNckt5TlUwcEVY?=
 =?utf-8?B?cDNKNmlVS0E5aUZSUFdQQnczWXpncHhmVndWUEZmWjNEUDVIV2xqcFc5REFz?=
 =?utf-8?B?dFJ3N0FqQndXSk94TnhKaFRYZkM1U09rejZnandRNFFDYmRCN1l0SmxqNWxl?=
 =?utf-8?B?ZHpKOWNOM01Nd3cxNXBybWhDTnBGa3l1UkJTNGw3MEw4OENCVjk1b1Ezb2lR?=
 =?utf-8?B?a0MzV25scTY0MWU5MGI1MCtQUDcvN1k3WWtCUkMrUDk1MlpqTzkzM0d3VXlO?=
 =?utf-8?B?cEQ4UzBwM052cnhCVkh2WjN6RExTMkl6WVQ3ak1LUHFwdUJtL2xKaDhVM0Z2?=
 =?utf-8?B?RHdvYzJ3Y1d3eFdFMnZESkx2NjVFakt4WFU2SW43Z2FnSnhFWXpKcVF2NTUz?=
 =?utf-8?B?Uk1JRVpuSXV0cDNMZUpSZm1pMjVhSmNZUW5RTTNDbWxTZkhqWHFyakZWWUlw?=
 =?utf-8?Q?U9HMYd9tWsyuG8oI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62c97ef5-03b9-49cd-2b6d-08da2ebef954
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 17:44:59.0552
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8ZkeLoeX0RXREvPxoH4PXa5203MnoM5MelIDfCt0N26uRHEeY4DDEXhNn1MuJvXDe3Qp7rpMmRuvU9176ycNCCvDJK7aWMVqyHf69ZiUeM8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB5938
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-05_06:2022-05-05,2022-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 mlxscore=0 spamscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205050120
X-Proofpoint-GUID: Ij6RnN2K3qMFIucvSB63AMdxU-ri33NX
X-Proofpoint-ORIG-GUID: Ij6RnN2K3qMFIucvSB63AMdxU-ri33NX
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 2022-05-04 at 18:18 -0700, Catherine Hoang wrote:
> Having just dropped support for quota warning limits and warning
> counters,
> the warning fields no longer have any meaning. Return -EINVAL if the
> fieldmask has any of the QC_*_WARNS set.
> 
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

I think it's a move in the right direction.  Thanks Catherine!
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>  fs/xfs/xfs_qm_syscalls.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index 2149c203b1d0..188e1fed2eba 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -290,6 +290,8 @@ xfs_qm_scall_setqlim(
>  		return -EINVAL;
>  	if ((newlim->d_fieldmask & XFS_QC_MASK) == 0)
>  		return 0;
> +	if (newlim->d_fieldmask & QC_WARNS_MASK)
> +		return -EINVAL;
>  
>  	/*
>  	 * Get the dquot (locked) before we start, as we need to do a

