Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44E57C4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Apr 2022 18:58:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbiD0TB2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Apr 2022 15:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232292AbiD0TBM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Apr 2022 15:01:12 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37C023B2B6
        for <linux-xfs@vger.kernel.org>; Wed, 27 Apr 2022 11:47:15 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23RHYbjY018590
        for <linux-xfs@vger.kernel.org>; Wed, 27 Apr 2022 18:47:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=pKqiMHtBSLKIcBS1hyIEhCWFXeP0JZZV6TJ6mRNodck=;
 b=EzoQZFFDPFsvsp2xRrqjlvwLPvkEwudK4w0jN5BdnWXPb2bmJQ2iUEIfxDTv/cxJ09mp
 iIjyu87sb1rAomGoiukMkAcBuT06Tct9Ap75rm/t0IotD78YPhp5cC5/6zz7SMdZTG1x
 icrY0H1iYEEek7EVO3KoyG7IAfZICK3O2yJBinKmj5tQ05B6Q81fbTrKHw7q8R7aQNDC
 eRS51wbhJajGSozyw5ercKu3VTS0eMt9Karf61O+eWjLITa+hV7LgWHt6IAJr9nkfHVp
 b05FH2FpLAErOa/0yhcGvK91gbXubCuN2tyFlZL+vB2M/bnqp6TojB/9p1L7ySqsauxr wg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb5k20pq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 27 Apr 2022 18:47:14 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23RIkaZF016813
        for <linux-xfs@vger.kernel.org>; Wed, 27 Apr 2022 18:47:13 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fp5ymgc76-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 27 Apr 2022 18:47:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V8OgYn/f4s6OAUkMm8hQ863sx7SLUh1gIKu1RNNfuBtaqe5zxj85KPS8GueOIxBfffsJ2o6efpemTs+JFdHNHzJK47KuBi9++RmThEdl94JvtEPcXWqsYYz+xplnReVfe+81sFX0grT8fBmFFuKGer0Fho+vnC3OH13bu83E7rDXC6DKqavg011zJz98JcqcA/k4pBwN8o/FY4o4yuXLT++ilGBlcxiBaa4ea00jgdL2YS1LViJap3UpBeV0p/Gu7nORqhbhTuazXsYUrP796v2Piymaary+/eo/JbpUwBwj3CFiqpFZIjc9xMluRokEhkVjKT+GlqHmvMSPlGDUHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pKqiMHtBSLKIcBS1hyIEhCWFXeP0JZZV6TJ6mRNodck=;
 b=OdJlgkI6f4R4oacJw0B7c/AB3/+xuKG6L8U82W0nPOm0dMLT4sEvEXmdKa8eHQxAg0mNXj0U0jCuVB6WxXCAN26GD//8N1qBG5yMb19cXdcDkhbvIAx12DncrEJQT3/CNbkXVV2ntav+NqtvbWzn0vd1enDmPLmGcDmBPAKaVRf9qCLwShUKF9vVX75nqKoeRaJDJYGjFkBXqCr7/pLlrghOUodaOwbamK68XN7JFCTYfOD+f3xRIXjzVWr1FPRp6zs1Rnnf9nLOcsV9eakerTY/tDHXDU+Y5cXCxC+OVokrBknQPW5h9b9MaiJ7+Lda8OvWFSGw5TCP2dXC+XL8lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pKqiMHtBSLKIcBS1hyIEhCWFXeP0JZZV6TJ6mRNodck=;
 b=AIR+kudPlDLEenLNIK4LynGF1K6FNvfZYdHESrIXRzK80eeO2HXPharCfGfrg4rMnvfIyTeXqnUi74W6oJSUiS8H0LZJf8HRyv2TivT10Co01mqIWvruPKCuW4im7pbQMKWOkBqfp/Tdf6KipYB25FQTbziAaT1+Us4Uctg+rLQ=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DM5PR1001MB2075.namprd10.prod.outlook.com (2603:10b6:4:2b::37) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Wed, 27 Apr
 2022 18:47:12 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f%9]) with mapi id 15.20.5186.021; Wed, 27 Apr 2022
 18:47:12 +0000
Message-ID: <f8ecd32553e8cc2eb67ea51f1ee5747f5a2312cc.camel@oracle.com>
Subject: Re: [PATCH v1 1/2] xfs: remove quota warning limit from struct
 xfs_quota_limits
From:   Alli <allison.henderson@oracle.com>
To:     Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org
Date:   Wed, 27 Apr 2022 11:47:10 -0700
In-Reply-To: <20220421165815.87837-2-catherine.hoang@oracle.com>
References: <20220421165815.87837-1-catherine.hoang@oracle.com>
         <20220421165815.87837-2-catherine.hoang@oracle.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0248.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::13) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 034ddb6c-ec81-4648-8213-08da287e5717
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2075:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1001MB2075176A39FC63305AAFB8D795FA9@DM5PR1001MB2075.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uSpWEOvuen+6tY7XdFz0jnnT1VqoMc2o6cKtnJ6qBPV+5WhIaS/o65tH5ZCng2xzzeMhZwvngmAApoEAcUgll7o93x3trFZ97V9Lg1LUMV/vOqrQMcVbjM4uJvjhcqJNIiE0lmNTstGkRGKOrAAI3W1V7byNq7fScFtpk83Bka9cksyOg00sdBCfARlCmds7xQO7s5S0vGzuadMx8w7G9TMtNamsR59qNeu6oTtuP97761K72nQ8z5QqeDmbltykcEJuM7rGBulFjim+423G1U/7oYUJpPO3VghyS0mIXzR6CxJWNvu4Tr+yAL2xeTnQ9nucyo5TKFBq+mh0KIwQjRrMoySIr71avbi6HSZG++2CQ4cdGsFt1qOLBI/ytOyBrVDwy7quYISV92NVX+w/zwwGi2gQrFxHQS5rLFbtYxAGWLa0WlgSgADkD8UWEQfOzK44JnEaqJL+Wo0Xhrq/MgmDekucblwkv1GMD6BzULgskEJeV6OUwIksfSCwAuMrxagLAXf+6D3fBD8vLOtp1PykTPr8ZhNTJO/1HbGClws3VZHQYmEFq4Snre60htInti4wheOEI5xKAzlr4KryA+d40MVt6f9Ne690g1xN0WWtkRb83+9DaYm9od5l9W7B8RSPwwKYlMpE0fJqNGwsUFxJjkhnGOr7HxSvxjcnDUoSw1u+vnV0g9Tg0+DlDDnFbnbIqy0bmYTf+svqpWq6/A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66946007)(186003)(26005)(2616005)(83380400001)(66556008)(8936002)(5660300002)(508600001)(6486002)(8676002)(52116002)(316002)(6512007)(6506007)(86362001)(38100700002)(38350700002)(2906002)(66476007)(36756003)(15650500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YlVVS0ZLU3NOc3VtNXNmSk8vOVBTRmpCRkZSSlB0RWNvbUxxRkJlZ0l6bzVU?=
 =?utf-8?B?TUF1U251SWlsdGlmVTByYzdzdnRoamd2anl6Yy9jWnZ3My9DNks1dGE4Vk1v?=
 =?utf-8?B?bXRNaXFMMERla0JHczBLM2FwMU0yVjZuN1o1L2hELzhBcXNwOTI4UXNpaWFM?=
 =?utf-8?B?b2Z2UGtjUkpVNEZYRmRlQkN2dnBaelNVZ1RQZ1JJZU9mVUVJSVB5a0pGTmZJ?=
 =?utf-8?B?UlBsQ0g5TEM3WG5acDFqTWE1b040bnZhcWxISFpVOXVERTBRdTZ4M2xPdTV0?=
 =?utf-8?B?RVZkQmZwMVdjNG8wL2k0OUpaQ0JWUkVPcEtRMEZBcWkrdlpZSEpJZU90TGoy?=
 =?utf-8?B?cCttcUIxZkI1K2tBamhKM0RQb20yVHRFcnJzYjBOTnNCTFRqYytxRFlKMWNT?=
 =?utf-8?B?WUVHRHBneUtXSzNPSnArRUtrNUFERDUwY0xLMkl0S0ZsL2YwUlF0dHM3M0ZE?=
 =?utf-8?B?N1VUd09Tc1pEbzJsY1dmdXZrTzc3S0VtOGlwUFBUY3E4MS9wOHczcWV1M0hy?=
 =?utf-8?B?Z0g4SW96bXB4bmVhcjFaTEh4d3o0aE9zb3puak1VQkNMZitXR2hmS1dycDNl?=
 =?utf-8?B?MHRTYzgxazF6VlFUTUVYeS8ybDV1N3M1RThhVHJLOEpWL1Q1YndOdkE0VDRI?=
 =?utf-8?B?YXhEYTNzNFF3cGozOTRpMTZEd0k4aEE0akpDc2N1Ni8rSDQ1c2pKbmlMUkJh?=
 =?utf-8?B?QWhkSEcrMEpWeVhQRlA4WFJoRkV0T2xuMlgxemJNR0prV2hOZUNUZ1NBZGl1?=
 =?utf-8?B?L1NzM1JEYTJrMTBBN29rN1JxV1ZFdUtUdkhPUnlzSnBBdFpubmdPdzlRdE91?=
 =?utf-8?B?UWRLNkZGSWtQV2gwZ1FZaXZEMFlwR0xudGtGZFFrR1lpbWViZnZaM1R4LzhS?=
 =?utf-8?B?bHRkSzh3dVdCUFUwM2RHNEZ5d1JRdC80aGd3c3BqdEVmNmV2UXRUWHpsRmJl?=
 =?utf-8?B?eXpUREozckwyRCtVTExnN0xTZUZacUhUMVByNjlMbUIwUXdyQkIrNXczcGZD?=
 =?utf-8?B?TDdycHFSbUhkT2xmak5Jamg1Ui9QSkxrK1FWQzRFREN6WTh3aUM3OEJUOVVE?=
 =?utf-8?B?RXVKWCsxenBTQkRodGZKSkxXUGtiYWlDTEJKN1pMSzc2TWtxMVZLVEZLZlEx?=
 =?utf-8?B?Zy8rcjc0bDNRSG5OQzEvTXRUTGxPSzlDUDJjaWt3blVSdEVxak8vZlhvN1ZN?=
 =?utf-8?B?ME96dmF0OTJNakE1RkFvR3BqK2RpSCtETTF2dzh6MG5ac2d4WnI2YUlEVG95?=
 =?utf-8?B?TExJemxhQzZUaDh4ZmhxN0lGSks0M1NnZ25RcXRBL04xeTJLSnBxWjE1ODJl?=
 =?utf-8?B?RUgrc3AxZWhjamttL3VmZGw2YWVVZm5LcGErZXk2K1hjVFd4VjBvZFhLN1Mx?=
 =?utf-8?B?UkxVenRseUIrNnVZNUc1TmJ3dGhhUHlGVlAycThOajd0aVdSVHBwVW9CUU10?=
 =?utf-8?B?dlhBa2pMaW8yQVY5QmpsV3dHRHdvU2k1S1R1VTVqcEQ1WTlhV2dkUC9jRWpn?=
 =?utf-8?B?dUdJRDlaZEkvZzRRN0xmTXlBMUhGWkw3cmovdEZyYlVFM2Y3eWlRL01UcnNz?=
 =?utf-8?B?S0cyNHN5VktDN0JxTUd5amZRSTRJeFpmei9SQ0U2b1NsTDh1YmhCclVjcG5E?=
 =?utf-8?B?ckppenpwYUg5WStDNmUwYmIyZmxqZUVpWFMvY0V3cXlsYnhUbUVBRkUxL2NR?=
 =?utf-8?B?aFo0UndkRHV6UU9HSXAwL29ESkovK2tHbDkwa1dyYUJoMTNEWXhxN0tPVE1w?=
 =?utf-8?B?bWRSRlROcEpHQXU4bk80SmREQjR2TlFjS0d3bGJSaERhWmI1SEFTUGJJMEhn?=
 =?utf-8?B?VWkwU1M0R0N6NUxGK2dWcHlnZkQvbEFnWlRRTjBxVFlBMHZobldPaWZuOUps?=
 =?utf-8?B?RWF5NGhNWGdlaWdzWFFub3VBdVNjeE9wNXViTnBjUE9JbnAyTWlHZWVvVSsy?=
 =?utf-8?B?a3hhUTFOamdwRmZISWdSYVBlTjAzTEpuc1BiVlN4S2JBL2k3TW5Cem5IcENE?=
 =?utf-8?B?bnZERm1LTEYvZjdTNlZqRSt3Z1RUWmlwOWlycFkyNjRHc0dvVDJENmxZZlB2?=
 =?utf-8?B?WGp5WDBSdk5CbFhrZ1IyMFc5Yjl5OUp2Z0pzSFJFck8zWSs2d3R0MHZCK1Av?=
 =?utf-8?B?MkJVSHA5Mnc3aXM1elBLOGd5MDg0dkpsUncvakVKQmZyS3lQWDFZZEkySVpu?=
 =?utf-8?B?Z09vTWV6d1pkb3Z0UGtBbDlTTU9udjNnRE1RM0NPK1VsTjZtRFJ3L3pyY3Zy?=
 =?utf-8?B?UTJYSmhYcUZUMDhvakcrQjNBWWNpVElzUlJmMGRQcTFhaHFUb1NpalJPdC9t?=
 =?utf-8?B?ZmEvM3JITUg2TUF4K21FYUNzQUVNdzQ0ZWs1dXN5WFRIVjlEQnk3UjliUU92?=
 =?utf-8?Q?hbchqd+R/EuGbbWY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 034ddb6c-ec81-4648-8213-08da287e5717
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2022 18:47:12.0213
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BhXesd5UkNoSWNXMADeH1+tyEf45VPWycHDtPyZT0/6Rrc1gws05ysJDZQbX6h+uK135wTFhfo/op2lg8GmsLDZcQ3XqGAeZAjU2WhNBTjU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2075
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-27_04:2022-04-27,2022-04-27 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204270117
X-Proofpoint-GUID: r2QQq5g7sx07ruDFe8G9GUx6fR9Rn44U
X-Proofpoint-ORIG-GUID: r2QQq5g7sx07ruDFe8G9GUx6fR9Rn44U
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, 2022-04-21 at 09:58 -0700, Catherine Hoang wrote:
> Warning limits in xfs quota is an unused feature that is currently
> documented as unimplemented, and it is unclear what the intended
> behavior
> of these limits are. Remove the ‘warn’ field from struct
> xfs_quota_limits
> and any other related code.
> 
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
From the previous quota discussions so far, I think most folks would
agree with this first patch.  You can add my review

Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/xfs_qm.c          |  9 ---------
>  fs/xfs/xfs_qm.h          |  5 -----
>  fs/xfs/xfs_qm_syscalls.c | 17 +++--------------
>  fs/xfs/xfs_quotaops.c    |  3 ---
>  fs/xfs/xfs_trans_dquot.c |  3 +--
>  5 files changed, 4 insertions(+), 33 deletions(-)
> 
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index f165d1a3de1d..8fc813cb6011 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -582,9 +582,6 @@ xfs_qm_init_timelimits(
>  	defq->blk.time = XFS_QM_BTIMELIMIT;
>  	defq->ino.time = XFS_QM_ITIMELIMIT;
>  	defq->rtb.time = XFS_QM_RTBTIMELIMIT;
> -	defq->blk.warn = XFS_QM_BWARNLIMIT;
> -	defq->ino.warn = XFS_QM_IWARNLIMIT;
> -	defq->rtb.warn = XFS_QM_RTBWARNLIMIT;
>  
>  	/*
>  	 * We try to get the limits from the superuser's limits fields.
> @@ -608,12 +605,6 @@ xfs_qm_init_timelimits(
>  		defq->ino.time = dqp->q_ino.timer;
>  	if (dqp->q_rtb.timer)
>  		defq->rtb.time = dqp->q_rtb.timer;
> -	if (dqp->q_blk.warnings)
> -		defq->blk.warn = dqp->q_blk.warnings;
> -	if (dqp->q_ino.warnings)
> -		defq->ino.warn = dqp->q_ino.warnings;
> -	if (dqp->q_rtb.warnings)
> -		defq->rtb.warn = dqp->q_rtb.warnings;
>  
>  	xfs_qm_dqdestroy(dqp);
>  }
> diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
> index 5bb12717ea28..9683f0457d19 100644
> --- a/fs/xfs/xfs_qm.h
> +++ b/fs/xfs/xfs_qm.h
> @@ -34,7 +34,6 @@ struct xfs_quota_limits {
>  	xfs_qcnt_t		hard;	/* default hard limit */
>  	xfs_qcnt_t		soft;	/* default soft limit */
>  	time64_t		time;	/* limit for timers */
> -	xfs_qwarncnt_t		warn;	/* limit for warnings */
>  };
>  
>  /* Defaults for each quota type: time limits, warn limits, usage
> limits */
> @@ -134,10 +133,6 @@ struct xfs_dquot_acct {
>  #define XFS_QM_RTBTIMELIMIT	(7 * 24*60*60)          /* 1 week */
>  #define XFS_QM_ITIMELIMIT	(7 * 24*60*60)          /* 1 week */
>  
> -#define XFS_QM_BWARNLIMIT	5
> -#define XFS_QM_IWARNLIMIT	5
> -#define XFS_QM_RTBWARNLIMIT	5
> -
>  extern void		xfs_qm_destroy_quotainfo(struct xfs_mount *);
>  
>  /* quota ops */
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index 7d5a31827681..e7f3ac60ebd9 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -250,17 +250,6 @@ xfs_setqlim_limits(
>  	return true;
>  }
>  
> -static inline void
> -xfs_setqlim_warns(
> -	struct xfs_dquot_res	*res,
> -	struct xfs_quota_limits	*qlim,
> -	int			warns)
> -{
> -	res->warnings = warns;
> -	if (qlim)
> -		qlim->warn = warns;
> -}
> -
>  static inline void
>  xfs_setqlim_timer(
>  	struct xfs_mount	*mp,
> @@ -355,7 +344,7 @@ xfs_qm_scall_setqlim(
>  	if (xfs_setqlim_limits(mp, res, qlim, hard, soft, "blk"))
>  		xfs_dquot_set_prealloc_limits(dqp);
>  	if (newlim->d_fieldmask & QC_SPC_WARNS)
> -		xfs_setqlim_warns(res, qlim, newlim->d_spc_warns);
> +		res->warnings = newlim->d_spc_warns;
>  	if (newlim->d_fieldmask & QC_SPC_TIMER)
>  		xfs_setqlim_timer(mp, res, qlim, newlim->d_spc_timer);
>  
> @@ -371,7 +360,7 @@ xfs_qm_scall_setqlim(
>  
>  	xfs_setqlim_limits(mp, res, qlim, hard, soft, "rtb");
>  	if (newlim->d_fieldmask & QC_RT_SPC_WARNS)
> -		xfs_setqlim_warns(res, qlim, newlim->d_rt_spc_warns);
> +		res->warnings = newlim->d_rt_spc_warns;
>  	if (newlim->d_fieldmask & QC_RT_SPC_TIMER)
>  		xfs_setqlim_timer(mp, res, qlim, newlim-
> >d_rt_spc_timer);
>  
> @@ -387,7 +376,7 @@ xfs_qm_scall_setqlim(
>  
>  	xfs_setqlim_limits(mp, res, qlim, hard, soft, "ino");
>  	if (newlim->d_fieldmask & QC_INO_WARNS)
> -		xfs_setqlim_warns(res, qlim, newlim->d_ino_warns);
> +		res->warnings = newlim->d_ino_warns;
>  	if (newlim->d_fieldmask & QC_INO_TIMER)
>  		xfs_setqlim_timer(mp, res, qlim, newlim->d_ino_timer);
>  
> diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
> index 07989bd67728..8b80cc43a6d1 100644
> --- a/fs/xfs/xfs_quotaops.c
> +++ b/fs/xfs/xfs_quotaops.c
> @@ -40,9 +40,6 @@ xfs_qm_fill_state(
>  	tstate->spc_timelimit = (u32)defq->blk.time;
>  	tstate->ino_timelimit = (u32)defq->ino.time;
>  	tstate->rt_spc_timelimit = (u32)defq->rtb.time;
> -	tstate->spc_warnlimit = defq->blk.warn;
> -	tstate->ino_warnlimit = defq->ino.warn;
> -	tstate->rt_spc_warnlimit = defq->rtb.warn;
>  	if (tempqip)
>  		xfs_irele(ip);
>  }
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index 9ba7e6b9bed3..7b8c24ede1fd 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -597,8 +597,7 @@ xfs_dqresv_check(
>  	if (softlimit && total_count > softlimit) {
>  		time64_t	now = ktime_get_real_seconds();
>  
> -		if ((res->timer != 0 && now > res->timer) ||
> -		    (res->warnings != 0 && res->warnings >= qlim-
> >warn)) {
> +		if (res->timer != 0 && now > res->timer) {
>  			*fatal = true;
>  			return QUOTA_NL_ISOFTLONGWARN;
>  		}

