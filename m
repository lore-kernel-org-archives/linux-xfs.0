Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1A0FC433FE
	for <linux-xfs@archiver.kernel.org>; Fri,  6 May 2022 09:59:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390754AbiEFKDM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 May 2022 06:03:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390565AbiEFKDK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 May 2022 06:03:10 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22EF957996
        for <linux-xfs@vger.kernel.org>; Fri,  6 May 2022 02:59:28 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2468LUho026258;
        Fri, 6 May 2022 09:59:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=1Fpt0RexWavVzL9vU1dViS78PBkEPv6YylIDGGZh8UE=;
 b=DJmWFsEZujB4ox0jMHrvEK2nvzyE8QxllLZ03zgCCC6+AEKnxVCYBtlpBGKSu6plerJh
 9FYn1gbv+trx/ROe5BCZELScyCbCgxa115tJtKKC0cjMscg3CAmTYNQcpcgWrwqMqihD
 5c/iYaU+tZCOok0fWiQkWst/YG2YcY0ReVYKii6KXLOyLo0kKB5FkVQqOzssOY8EcpqZ
 qkhhCarNP3z+M31lx00VCxERsFHXPD2TfFrY+ZmAS7ppjJ9Pk73cCarHu+w9xKyhS7hR
 8ri8VKYFaNHCpJhsXdZWdh9vlavA7idCnYEyOg5sBj6NM3UPVZMbOydxoDBGgiyVnRxY XA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fruhcddpu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 May 2022 09:59:16 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2469vJbh014941;
        Fri, 6 May 2022 09:59:16 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3frujbu61h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 May 2022 09:59:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hyr/1Pb+OzLDeN/+oALbI0BHdL2CgbLZpxGzZufjzYd8YsoDaZpV794LE7H8yI7YOlcCnF31CrQl6atgNUTFkeiwg68OcYvjWhK5f007mQ+8Ah27pAoFb7MciK02c50kamt/+vENM/SvpFjvG92Yol23VaV0eNd1RVoAE3C3rNSDCuRIRqp6OIdo7dO6+Y1Wmspmu6BK4eTJray2SA3XByufI0XoNECemch1ybaiUgrj9iYaUzAG+m/C6D3Xeiwtx6M7zRA4oukwRlIy2dNP+xHMKcYc2puE1dA5a5ZeCrsEMRZPdBaFj/vxRUWwGkt4EBgPVNIk0/hxkaHyj36pkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Fpt0RexWavVzL9vU1dViS78PBkEPv6YylIDGGZh8UE=;
 b=nRiThTOqZ1Bd3dS3tC/So2Cvc7Z5psDZGzaVdiALJ+ROddsH7myKfNgsZDRZ9/xXLmf9DziL/pXQ5pe9ipOqzzCUOj0yy7kUf+U8J+Q1kDxIaaJq6Cbhl3dnaa0HmYjTQW/yKvOElQ+XAy7lx11mQwMj9rHeb7dXU/+yd5yF5GiInbpiFfMMtW3UkIFCAfafsGiSQ09lHboeGIqYLNMGq/MgqTsWCkg6K7Sqjweg+D3QqhQWVuWbQjWqc/SDJc57i9vULSDs7dVNA5qvDyKjPpcGkM8FasKRWdBI2TTX6AC7iRjUrsY1BOOAIXRSA56JfHHUYiDh8sekLqg/E+KyDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Fpt0RexWavVzL9vU1dViS78PBkEPv6YylIDGGZh8UE=;
 b=fBjLQLAftRZlGqtZmWjT4BtjQcZpK9darY+Gasoe6buYD46JqRxx0nztKF4vRd7BlQqX/maJjarFbyzlq/fy877OQlCKiBON1vaGDS4kRjiy+yyDO9h9wDU4Uwr76BscWmW5/2XrFP9kxxFnmnnZ7nXvg9wjJVSV77H5lP9Td9c=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BLAPR10MB4995.namprd10.prod.outlook.com (2603:10b6:208:333::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.20; Fri, 6 May
 2022 09:59:14 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::7d41:aa0f:80cf:ea15]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::7d41:aa0f:80cf:ea15%6]) with mapi id 15.20.5206.026; Fri, 6 May 2022
 09:59:14 +0000
References: <165176666861.247073.17043246723787772129.stgit@magnolia>
 <165176667420.247073.10421518802460549832.stgit@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs_db: support computing btheight for all cursor
 types
In-reply-to: <165176667420.247073.10421518802460549832.stgit@magnolia>
Message-ID: <87zgjvouc4.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Fri, 06 May 2022 15:29:07 +0530
Content-Type: text/plain
X-ClientProxiedBy: TYAPR04CA0001.apcprd04.prod.outlook.com
 (2603:1096:404:15::13) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6d70a1ca-e567-4492-381a-08da2f4713a9
X-MS-TrafficTypeDiagnostic: BLAPR10MB4995:EE_
X-Microsoft-Antispam-PRVS: <BLAPR10MB4995891B5A5425920827A6E4F6C59@BLAPR10MB4995.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lPsml0n30RZgwZZOzK/NU/ZQ6d7yEyqe9TUacP05TqK7f7N7ZVMUQuzr2NTI5NXvQ0YRZlGCIHIjx+d9Yb67oDS+8cGYrcXotXJ/ztM97poczioWW6S9e/4YKMeeWB2GE2wKUvpFbgkasQhR3YaP7IDOMzATOtoScitDeU5f80wYjHSaddPz7wx8yO7hFb1bVxDnFkwRXH3TctfnsD74LoRbwxq1bLuQlQ58pIjHw12IGS98L8oSMXfQiQadQA/q5+vFnb3Bjn8C4hb7hL6ep4B2DTfroiAdHllMWzJaFW/74h7q0wZITYI1A1PGEj+PTew2mpPU0jEAHqWpoZZFJWrAr6DVN3MxlBBT4AtdygdqM9PI1ifETIOAVsR89eZXRf4XUJ/ku49N1gN/SYxW1JW6lMvwynEHqSvpVQEIuKwuo8E4NzRSx8DGZqDVM746I2cB47AGrpE8UivXJSEDa5LwuNy4M6fPoigMLZKI//p62VblAy6A9bkF7uCqD05DjgMAeEHSDpKxLdy2xlW3hIvJnJ1/Us9Auog/T7HPL9SB+XhTkJ0IkEX2rJsW8ayHbz3o6ieN+GoZ3j0mOixtHlfO+5VQa2au1cWo5xTWnHLye4HkuCapR0HKxDGvNf7yYxlefU3oLqXtN3pZuxQJTxopsPHHdAABi8eWfqzbccDAxWsWh2Agi5JmJgz9fzy80fhC1pAdOvp0bD5qOh7QvA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(6506007)(83380400001)(66946007)(66556008)(66476007)(8936002)(86362001)(53546011)(8676002)(4326008)(6486002)(5660300002)(508600001)(38100700002)(38350700002)(6666004)(2906002)(52116002)(33716001)(316002)(6916009)(186003)(9686003)(26005)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pYdyp2uEM8HGT0c3lJ5No3g2ZoDeTcENiR9X24irFZwiT8auhn5ogToNS/oW?=
 =?us-ascii?Q?e4dAkI32da3uVFOioscTW0ZqYkNwA4rAVZv8mk53n1xFqHarOx68r/bNWINE?=
 =?us-ascii?Q?x890E1Q+IHiXeSjimgKH0vm6qDX+SFoa0nTya9lZgQ9VxQbULHP7wF9ZuIBx?=
 =?us-ascii?Q?NvpJXviabDT+bZcEh3Sor284ftPgNElYjGp+9iWS3u4ackGjVOWGbB3rgzda?=
 =?us-ascii?Q?B/twZ+bK7axreEtscRhOpjA3FGhBautvp4aA9uzdPeuZg0h3epOu+ceOjb2V?=
 =?us-ascii?Q?XGtkj37EZcOI2vm8im/WxUeZOS/eLQYQqaeEUyDk2LzlH0Y9g0I/ZXqBP9Cw?=
 =?us-ascii?Q?rbCaZXhNE7r8UwV8PVr292co7zGCqlc//bkci1JiWknwZWCSPImMCaDHBEdG?=
 =?us-ascii?Q?7iFNEphreQo2l8E+d1EAveHKQtH/e1mdbsqCFtEAPJjy7hMmexKKpmXhPpFW?=
 =?us-ascii?Q?jTKjxYOzOXpwm0frQEx0HFbor6yImNWgjCofXoeN83TFqJk0IA61HcnTXVSZ?=
 =?us-ascii?Q?IeRaWCXZ6IkCNOZ0k1NWmvdtzBAEBMR/N+DdgAHm2qk16i1KfuVuBFmeJsHa?=
 =?us-ascii?Q?sFTr5VmUwbOsXbmd/ovp4ekhyD32krHXujslub0/k9QBOCdkWn1ARASyk13+?=
 =?us-ascii?Q?NijLS21oUwZ/tAo6PClMlFePXawhnUfVtixrq3+My7rOtcAvW2RjRoUemZx3?=
 =?us-ascii?Q?6D0ribZ4PUvuSubpODFd6RE/XJ1yMJEvuYP7GRxpp7AYNNCfRwOpxIJaaiGH?=
 =?us-ascii?Q?iBiAAmCjn06UkbdEVUXZorrx4B1SxGTpn8vW1BtMYQDmAVz5W7mJuFhWAO1m?=
 =?us-ascii?Q?eybbeAQvR/SGPxxAIi4/mkIajWs01nnP4hv8C+Ib3TnjetWck+dV6m2+As1t?=
 =?us-ascii?Q?Wh8N1aMeHLJhO1xB+HX6LW1TiAWpxvZKNL6O3tvO2BERPUQE8vkMU4hKIJPa?=
 =?us-ascii?Q?HzdSx0yCcTFQqUaubY8HgTaQ4h9gUq2iQjuEYrTj+YUvjCCVrFTvLfRLtP/q?=
 =?us-ascii?Q?hYgVo72PPxC267QKNZu6PICVx26CPUiWOtVFbH96JD5ASgMYNsxWLCJwhQs8?=
 =?us-ascii?Q?O1x3auZVdZ0r6zwMU44E5oj/VZ0rCKUVCOpXvJE4GzJNKrhSSyr+hdTDYaVM?=
 =?us-ascii?Q?ZD7Lou9ta9VjXahGeYnHq4kL/KswDUczC7y63pNeWRj4SJsXpFfMEqOu4kxh?=
 =?us-ascii?Q?gHbg4zJqD3UoWG77x+iBrONFfWM4c/rfCO7DTPT0LMx/c8BncDonMMOZZCoV?=
 =?us-ascii?Q?Yerx3TsC0E3ATIIOx5VEIaJHZ4EgSGpGzTBH2bVpASiQrVsr2hdAppMhHKNd?=
 =?us-ascii?Q?pIhmABp19zZDTPATfpJsL7Gou/ASVAOIWZXoiO+1wZjpdIWZU1RXHul2x/Ve?=
 =?us-ascii?Q?ElYBSpNoc9dFF5hpnCAZC9cc7rwk30wfPaAI0LblyuL6Pst+njbxDomijc57?=
 =?us-ascii?Q?MeDBKBKOso1lz98I4Z+TLA6p3V3XqZFPQ30LB2j6kW2FKqRvkDSPNp/rExVp?=
 =?us-ascii?Q?AI6dqsldljA0A3w3UctINfwRE6jCPigSyqxnxCHrUur5Slusi2E8Fqdj2rzi?=
 =?us-ascii?Q?s5S7GSkYZhKpyd1+Ifr/XOFltfrh0+Ic6M5qe+5NTWDHx4t0Qgcof+HSj/ZY?=
 =?us-ascii?Q?Mv/Pbpwdyui0YDvsiiZUbHD3P/GuDJlaBXSt+zuwRs4oKOHYJ5joCZBMnNDW?=
 =?us-ascii?Q?tPnJyPUgwhjR/Prz6ZfkJArhVFuKeE+q0bRLtavJcr1gcPRPelBLVs3A+Rc1?=
 =?us-ascii?Q?9rtuPjtI+k+o4l7oDQ1yh8Zpfeh1qbk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d70a1ca-e567-4492-381a-08da2f4713a9
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2022 09:59:14.7273
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fcJhvfcBEAJH1zki5G/c8LZhI2J6wcEjuSFGMgawsDG3yMWvMUZG0kURd8C67IUFiiVXUe3gunGwpa9y9i7W4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4995
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-06_03:2022-05-05,2022-05-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 bulkscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205060055
X-Proofpoint-GUID: vLyiVSFOXt3dycPmtAaU0HxmcyfpsHRS
X-Proofpoint-ORIG-GUID: vLyiVSFOXt3dycPmtAaU0HxmcyfpsHRS
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 05 May 2022 at 21:34, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Add the special magic btree type value 'all' to the btheight command so
> that we can display information about all known btree types at once.
>

Looks good.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  db/btheight.c     |   26 +++++++++++++++++++++++---
>  man/man8/xfs_db.8 |    3 +++
>  2 files changed, 26 insertions(+), 3 deletions(-)
>
>
> diff --git a/db/btheight.c b/db/btheight.c
> index 8aa17c89..e4cd4eda 100644
> --- a/db/btheight.c
> +++ b/db/btheight.c
> @@ -57,7 +57,7 @@ btheight_help(void)
>  "   -w min -- Show only the worst case scenario.\n"
>  "\n"
>  " Supported btree types:\n"
> -"   "
> +"   all "
>  ));
>  	for (i = 0, m = maps; i < ARRAY_SIZE(maps); i++, m++)
>  		printf("%s ", m->tag);
> @@ -107,7 +107,7 @@ calc_height(
>  
>  static int
>  construct_records_per_block(
> -	char		*tag,
> +	const char	*tag,
>  	int		blocksize,
>  	unsigned int	*records_per_block)
>  {
> @@ -235,7 +235,7 @@ _("%s: pointer size must be less than selected block size (%u bytes).\n"),
>  
>  static void
>  report(
> -	char			*tag,
> +	const char		*tag,
>  	unsigned int		report_what,
>  	unsigned long long	nr_records,
>  	unsigned int		blocksize)
> @@ -297,6 +297,19 @@ _("%s: worst case per %u-byte block: %u records (leaf) / %u keyptrs (node)\n"),
>  	}
>  }
>  
> +static void
> +report_all(
> +	unsigned int		report_what,
> +	unsigned long long	nr_records,
> +	unsigned int		blocksize)
> +{
> +	struct btmap		*m;
> +	int			i;
> +
> +	for (i = 0, m = maps; i < ARRAY_SIZE(maps); i++, m++)
> +		report(m->tag, report_what, nr_records, blocksize);
> +}
> +
>  static int
>  btheight_f(
>  	int		argc,
> @@ -366,6 +379,13 @@ _("The smallest block size this command will consider is 128 bytes.\n"));
>  		return 0;
>  	}
>  
> +	for (i = optind; i < argc; i++) {
> +		if (!strcmp(argv[i], "all")) {
> +			report_all(report_what, nr_records, blocksize);
> +			return 0;
> +		}
> +	}
> +
>  	for (i = optind; i < argc; i++)
>  		report(argv[i], report_what, nr_records, blocksize);
>  
> diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
> index 58727495..55ac3487 100644
> --- a/man/man8/xfs_db.8
> +++ b/man/man8/xfs_db.8
> @@ -420,6 +420,9 @@ The supported btree types are:
>  .IR refcountbt ,
>  and
>  .IR rmapbt .
> +The magic value
> +.I all
> +can be used to walk through all btree types.
>  
>  Options are as follows:
>  .RS 1.0i


-- 
chandan
