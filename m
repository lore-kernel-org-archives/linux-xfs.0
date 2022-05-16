Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 518E3C4332F
	for <linux-xfs@archiver.kernel.org>; Mon, 16 May 2022 23:56:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349429AbiEPX4X (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 May 2022 19:56:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350595AbiEPX4P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 May 2022 19:56:15 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD06727B3C
        for <linux-xfs@vger.kernel.org>; Mon, 16 May 2022 16:56:13 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24GKgP2S009394;
        Mon, 16 May 2022 23:56:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=HWLlXrSI+yAVTgxymgahv2sMXb65uO3pFH2WsooHM+I=;
 b=eWxgwzeqHeZ8HFNLrpR7BLwPbG21n2dW8p2F2FQZ4/UGh+JVe9wEty2iZeSxDMYu/N5y
 1V94Zec1NJn1hmDNadyciDiYHrfHWuTiUq6iDuhdqlEJpCHLEiHKZhvGFdAUg7dDv0OG
 w/bmELjtEAeg/Q2xdN/SiKs32fSD30St00cNMyWaRzB147T0551TlyEVw7fAjc2q8SeU
 aIoxH/tlNoujb229b1CIQ7r3DFi7oYN6OdEjUYEQmRVxj57sKU59UL6YLSe8FBeYSwfL
 WXwtUtidzuffZlB8/WToWHB+ereZb9LMiKYK81Q0L+DZiaSPdEdFLqkkhMvwXkdoWkL1 RQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g24ytmr4s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 May 2022 23:56:09 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24GNfUAj014060;
        Mon, 16 May 2022 23:56:08 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v27spc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 May 2022 23:56:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CwLKD6qgvCzWBcGvBhp+gBwF2rRf6TMCR1z0OYYN56+Ja6PcAVuQ9ql6b++rbW3/jwDbvtypybZwNpiyHLF4tAtXzwPM8UU8bMB0/vuDyfY+F0RQ/uKfuzUJl+Ms6Y2QMjSIyRt4cOVHgzV5siMcwqrqyuJX6zZ054Hj4womsIsYOXclzuhrLcjoEUdV4AqPUZ4QIlqOY8lKyokS69fZY6m2bdEuH184OwXA9lBEWS8y1oUPebof3rmWdAttUI9M8vjr8cKTP4Z0YmAZHRxLlCrRQEOVa23qL2tnFXQ28A+2114jhk1SWc8KJc/Pmq0Rl9SCbHdUb3sLY2VBa3ZYfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HWLlXrSI+yAVTgxymgahv2sMXb65uO3pFH2WsooHM+I=;
 b=fWJAhRRsEYFQYKW+H6X9sRz0klvnrG0SGNM3UBd5+rv2LQh9l1eZpRAnoQJQn6fAfZG8OvSJqDVI1RTH6M0cXX+kXuk0D5ypAjQHW6tNmYPnN98fAe2D8bgURCvGfjaiwpG4ks7OA3lYqLqZiM9vxqiuiyEpiyb0081EoVa+s8VNLgBN67NQOaoNELS4wyv8Wp0z8m6dbwvMGDc6xOkStyWm/Em25DsmxE2Ew1vIeahsXoDfChS/mXKbtImxUSurUQHv3OSqwb2Vv9K4YNLBjlEWH3lBduoPO5JjmFeSCxIQFhiVhbcfxApYTfzFNnNKDCr8YPIBheUSzjw8SbnWiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HWLlXrSI+yAVTgxymgahv2sMXb65uO3pFH2WsooHM+I=;
 b=MGhrnCfO83tym/WvCMrqBig3poRQ4jNUy9ioXc0n6LRH2eVvSrxTbJgx9TJvIPFt2cnhqI46LB/rKoyGKDTw4pFGTB5qwcYFjWMFm4+O7pXkqWeb9BObIf7mMl2WhYdHBKJXkVJM3sej3Z7rym4uxoz7VYXbNvVdsJ70h+km5QE=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SA1PR10MB5758.namprd10.prod.outlook.com (2603:10b6:806:23f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Mon, 16 May
 2022 23:56:06 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f%9]) with mapi id 15.20.5250.018; Mon, 16 May 2022
 23:56:06 +0000
Message-ID: <63dae8ffc6d0a59d904d9d14f3b0d02a3324e284.camel@oracle.com>
Subject: Re: [PATCH 2/4] xfs: don't leak the retained da state when doing a
 leaf to node conversion
From:   Alli <allison.henderson@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Mon, 16 May 2022 16:56:05 -0700
In-Reply-To: <165267192341.625255.6169607924858686457.stgit@magnolia>
References: <165267191199.625255.12173648515376165187.stgit@magnolia>
         <165267192341.625255.6169607924858686457.stgit@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR10CA0009.namprd10.prod.outlook.com
 (2603:10b6:a03:255::14) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 32440e83-1230-47ca-ab2a-08da3797a44a
X-MS-TrafficTypeDiagnostic: SA1PR10MB5758:EE_
X-Microsoft-Antispam-PRVS: <SA1PR10MB5758D5705FA417695085039A95CF9@SA1PR10MB5758.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: quZtYm23pdXs4zbQV5/aBehDx0AlQjSkr3s14AwStYdADcz3i+FuY7WkSEXNJWVP553Gv19ajA0xDV7o+SHTYigwkIsU0lLOSFfzJc+BHrBdEVBnHNzt0Qf8vsh148QB2mnamlMz7kHXcSTtiuZIsmmz5NK1uHqUiecaTVHUo1DGanzmtl7hV2qf8OiiWQq81UC64rvkCVU4Yum0LdJsYqiEahb9cehw9vp1UFMWkEt/zPqBc5xfTjvyjAQyD2ftSdJXivNxVMl4uXsYoQjf9gbAkD0wLh4hgksdmsi3i/uA7VoApCJy3vEGU+pZspunmeNxbHhxTw+W8aRr0X/r9jV9ibIJvcJaRfWjL4DL1Q1BA3oJSuV/3CK341nz2FRy8aX8lmL4zORM1h7tsKY4SueaC7QB4IiKltG94t6IS/1DERvczW8E4COrnviS2CyWr8qbO6aCHI7f88EpKi/sEumRrj5kl0AI0Mz6b5uMo4e1NDOx1xdtNLK1kUIoAXJvf2S95ibmw9sLNbHjYIZjS8Xr4+ICYXoLu5vBeykMR7mO5jwaHZfSX4X38seci2ShJdem/rlotAE7fyi8xEmYaoC1I5hgY6Kl8ePK7TwOvHIvJT7F/P6UvIOiDlJyIwUdwTVS6bGTSKuQDW98zfIu6G6+I0cqDy69p3xav5n0ePlFqn+PHujxsmhE0uHlFYeRiwTrRXUmXo3gaBU/3VJfiw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(38100700002)(6916009)(2616005)(86362001)(38350700002)(83380400001)(508600001)(6512007)(4326008)(26005)(6506007)(2906002)(8936002)(36756003)(66476007)(8676002)(66946007)(66556008)(6486002)(52116002)(316002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UFJEejIvY2s3UTNsMXgzeHNQUHpzcUw0ajhEcngzNXc4V0h5Ynltc0llNlMw?=
 =?utf-8?B?YWZuQkFvcXV2MlJCdFZMeVpFYzhzOEoycDBydjk4YXV6ZEpmb2NxcFB6NENp?=
 =?utf-8?B?bm5ZRmlseFB4Rm02ZmdRbGsvTFYwdW8rcUdzQmlPeUYydjhCZDRTVVlGSWh4?=
 =?utf-8?B?Ky9ZUVgxSkxrQTc5UGtsZGR1MnBobFJUSTRTN21INFVZU3AyVDZha1ZTelhE?=
 =?utf-8?B?dDYyWXZlOFc1cllKUitZSVVnQlA4bmVnSzlGNDhIRkFXeGhFeHdCOXorN2Qy?=
 =?utf-8?B?d2QvcXJrU2NoYVJqb2k2YjgvbTlzalpvYTZkNzMwajBsVEZzQ3M2TVdhYjE1?=
 =?utf-8?B?S3RwRGxBSFMwQ3AyUmx3TkYvSWtiMVkzYW5Jd05wZUhkQVArcEtHNGdvZTN2?=
 =?utf-8?B?Q0IrWW9VdTNFeFVEUkVBQmdLZlB3VEp3L3gzS0J5VlRwWnV2VXVaL3hBMnZy?=
 =?utf-8?B?alpCMk43WUtzZHlKOG5sUHpaT0RkcVZuZlNmblFJT2I3ak1zSUtLZ09DcHBG?=
 =?utf-8?B?ZjJxaWU1dDk0cmVPRlZRcGdvZ0FZUHBIcXpyQjNrNjY1bTlvcmhqMVFDVXpL?=
 =?utf-8?B?YmpVZWJSSzMwMlkrWkl1TWhTTGY2WU5vNEs1aW01ZzRta2NOWUtDUXNaem1P?=
 =?utf-8?B?K1Y3QWpaNWpUdmlBYmZLSm5hbmhmeW5GbDNyL3VaZzkzQmRXMm4wQ0h5T01r?=
 =?utf-8?B?b2x5YU5uQXZPcjlMdkN0ZUNuZVdmcmJ6blA5S1hQK1g0d2wrbk5GeFpIOXds?=
 =?utf-8?B?eWc5clBpejZaODRScm9GVTFTQXRlY3JiTGhNTHg5TFN1S29ZQ01ZbTJTakt5?=
 =?utf-8?B?VWtBKzN6cXJTSHpKdWJMSnhsOGNKeDBxMnJCemZhWmF4cytRb1F6NDhRNWFX?=
 =?utf-8?B?OW5DUEIwYUR5aXNIdDIveGhFaVFrMzZWbUIyUlNRRHlyVjlwVWdrazd5UWY1?=
 =?utf-8?B?Q0RIUEhBVms4YXpGemQyb2dDS2pLU3ZEL2dEeFI2djIyd1dZT1VpVitHRnEw?=
 =?utf-8?B?WjhwYVJsaHc0WlR0Y0NuZ0F3UkJacnZ5UHRXdjR3VmJRTzZrVnEramtraWor?=
 =?utf-8?B?UTdRLzkxdUdhWVc3UXJ6bm1iZERRUFEvZU0wWkNVRjc1N3pOMkQ0ZDVVU2hy?=
 =?utf-8?B?eWZIQkRNbkRlemtIeWQrT3RjSlE0WHBXbEFIZlUxeFNsMk0wQjkvN0YyRjc3?=
 =?utf-8?B?cnkxS0tiWTdINW00RXdaUlUrdFY2Y0pmVmJMNURpOXY2UC9Xem5yWDVBU1ls?=
 =?utf-8?B?dHpJZUZTc3ZmMks1V1ZXS05QQXNmMktqQk1uMlB0ZU1QSE0xb3NOUkVFdjhy?=
 =?utf-8?B?bGxibnZCZUVZOHVWYlU4UkgxOFY1RkZwd2gydmxZTDZFZWN3NVhoLzFUUE5E?=
 =?utf-8?B?ekQ2NFpuaktCalhsNmNQTzZ6SjJFRG93RCtMTHVDV3hpR3QyakRJTmlaejFW?=
 =?utf-8?B?WU8reW5tZW92MFdBbitUVFNUMHBrc1ppSnlURHFVdXFxdnZ6dXg2UGRUNEtI?=
 =?utf-8?B?MEZ2U3llZEpLVS9FU29wS016R2xZVFV1SXpnWEt2OGJmOVUreFRic00rZ3hi?=
 =?utf-8?B?OXc5L1ZUbzVrVzZsQU83M2p1Ri9mbzF3QUs4SnJwbTR3ZU56N1pQWTRBUUNC?=
 =?utf-8?B?RVNoWjFFa25HK1V6b1ppSGwvWFRERWV2aGRjcVJEOFA1eGRtQjF0QUprc09U?=
 =?utf-8?B?YVRtMXYyeEdiTzdoOC8wZmZIOFVJZEExN2xJTlVTWEJHcGJjOWRodzNwTk10?=
 =?utf-8?B?b2dMN2Z4eEY3cVU4RmFqL24xOUpZdy9MMVRIdVFLVWZrdXdTUXpCRXZEOEZa?=
 =?utf-8?B?SzF4ZERSNHdYMzVWck9ZQi84RHRPYXBTZHRTM3FSbmp4WWpkSHZJOTRRNmJn?=
 =?utf-8?B?elU5d0pJSG5ZMGd4ZzREV2lWZ2NxK1VicDJ1REFCbjdnWW1jTzBtYVRzTmVs?=
 =?utf-8?B?c29vTWRUa1ZhT3NoK2U1VkFWd3Y5cCs1N2xLa1JzUi9xZWlEdmV1bDZpUXg2?=
 =?utf-8?B?dTVoVEYwQ0RvZ0NjNHByRFZtOWxPQUxTZXpRVWg0bzlzR1FlNnFNN29sN09L?=
 =?utf-8?B?TlhYSUNZbFpJUmdYcGF4MStFMmxVVlhUM0w3cXFOaU9uNWtkZkRBUlVZLzdT?=
 =?utf-8?B?VDh6M3MrRlRhbTVaU0NTc2c5WnRjaGZLajUwMWdvOUQ4UmM0dmM0SGYyb0Vt?=
 =?utf-8?B?R3FrUSt4WnR2bFlUbUhEN2d0NzlPRWVMSVBqNGhKc2dXbkY1M1BoMHNJMFZ0?=
 =?utf-8?B?Mld2SlN3SkRtL1YySy81TGNBSmpBZzJRTktpdldNZXFRaXUvb21lTVg2VFds?=
 =?utf-8?B?WDM5UEtjeVg1MVdPaDNMR1Juelc5dzVpOThDbkptVTZ1ZVE0eVBXdFZmVUF4?=
 =?utf-8?Q?2VJiNWTk86U78wP8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32440e83-1230-47ca-ab2a-08da3797a44a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2022 23:56:06.3386
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XijM9cBtvHiElFFfgbXPlWCRgv+EZgkRDt0vmSA3o+WjRD1/v+qi6gcke7G/cd7JkyTiV+QZyV+8V7oAulnUprR0tBpwtlQzf1up7ruCU1o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5758
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-16_16:2022-05-16,2022-05-16 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 mlxlogscore=933 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205160131
X-Proofpoint-GUID: c1QzDBXcFHMBLhFF1KtrhGHOuyzAzuCd
X-Proofpoint-ORIG-GUID: c1QzDBXcFHMBLhFF1KtrhGHOuyzAzuCd
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, 2022-05-15 at 20:32 -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If a setxattr operation finds an xattr structure in leaf format,
> adding
> the attr can fail due to lack of space and hence requires an upgrade
> to
> node format.  After this happens, we'll roll the transaction and
> re-enter the state machine, at which time we need to perform a second
> lookup of the attribute name to find its new location.  This lookup
> attaches a new da state structure to the xfs_attr_item but doesn't
> free
> the old one (from the leaf lookup) and leaks it.  Fix that.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Ok, makes sense
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>  fs/xfs/libxfs/xfs_attr.c |   10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 2da24954b2d7..499a15480b57 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -1401,8 +1401,10 @@ xfs_attr_node_hasname(
>  	int			retval, error;
>  
>  	state = xfs_da_state_alloc(args);
> -	if (statep != NULL)
> +	if (statep != NULL) {
> +		ASSERT(*statep == NULL);
>  		*statep = state;
> +	}
>  
>  	/*
>  	 * Search to see if name exists, and get back a pointer to it.
> @@ -1428,6 +1430,10 @@ xfs_attr_node_addname_find_attr(
>  	struct xfs_da_args	*args = attr->xattri_da_args;
>  	int			error;
>  
> +	if (attr->xattri_da_state)
> +		xfs_da_state_free(attr->xattri_da_state);
> +	attr->xattri_da_state = NULL;
> +
>  	/*
>  	 * Search to see if name already exists, and get back a pointer
>  	 * to where it should go.
> @@ -1593,7 +1599,7 @@ STATIC int
>  xfs_attr_node_get(
>  	struct xfs_da_args	*args)
>  {
> -	struct xfs_da_state	*state;
> +	struct xfs_da_state	*state = NULL;
>  	struct xfs_da_state_blk	*blk;
>  	int			i;
>  	int			error;
> 

