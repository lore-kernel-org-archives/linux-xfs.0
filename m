Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAADBC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 17 May 2022 22:19:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbiEQWT0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 May 2022 18:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiEQWTZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 May 2022 18:19:25 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2918C3D1E8
        for <linux-xfs@vger.kernel.org>; Tue, 17 May 2022 15:19:24 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HKTWLu029120;
        Tue, 17 May 2022 22:19:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=7WViijYbmaf/W9bWrzVUTw6f3gXTq6mgfqs7WARdotE=;
 b=E9FnaYJ0pA3BteB8n5kTx46STiG09V31XSVxI1Rri2qcCekqBs3+77tP0i3W9/Nrx7V4
 bl13icBiiJHoTd8Clb6f0giStD+2MOwg1gZlw9Lsh+MIJ/sGwdl2wplEG3u8ZVuHEetY
 VkEKJQd9wTIEcjSIczNt0ZnLiERLPuqllO1HP6aLxRyhT/R5JN0Mwe8JO93vvtojhEwH
 YoFRdhD0VBLuxXYqNtSbExp+mHRFXO5f2vDnHsOAL52EZ4nr6gOB9AoQyOP25wBjY1DV
 vjeVnynNlLkPm/qb/k7bDZPUR5rpb7bPVDUq5aJHTUHwwSauGiC0egF9MOqjb4mq9hvS EQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g2310qrc7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 22:19:17 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24HMA0A9034408;
        Tue, 17 May 2022 22:19:16 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2176.outbound.protection.outlook.com [104.47.73.176])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g22v3jwva-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 22:19:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nkVdDJ/Q9Um/+HnBjsLv7ASEvnmipkdcCWjJ8roI5N6OPjF+lt5m7T/L4KlVo6W4dsmgItjgC6Wx3bqzdOzGfmwjVVq/jP87KcC/aXttHbDL3XYCMYxksdHL3zwZTptNxSzUsrL74r5jD9DMbriWJ1KNyDz+KOjGI+6jgNqE6plXEvJMD6Mxxdg+CqS4E6sNFY9rtwNKkxtMzjjC0H/yBtfe8oGMdkpL735zfw245YqgjHIl0VIBNiB65Tc+vNSOrfaKKeeSjAekfzAfYTmeq2qggTfpkFP1UXzecDHnFmiFxJfcYVXouKz3ToJbAljPmoXNmTHB6UwQ+VTFbKfjTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7WViijYbmaf/W9bWrzVUTw6f3gXTq6mgfqs7WARdotE=;
 b=L4RoUCBzl4gE2ZZuXH08QpS7Ld8GWHmH3L0mKc1XZY3GIjzrpfNukzR+7IXFmWvrZK6MUzrgAtl5UR247EM6CaS69V8Wd56y375Mv7RMCnSl9LKu0NVPmF8E8UpLm5aWs+xCOD5NVRHU5p/0BkOtp/UYJAkM25JjPpFwMpHyBRt540IPPtbs1n5qvdj2bz7JmoezstyVibR7vKM9d73dWWtbyXS+NdQ7V2S5QzdpXeBSpFgjuyl4as1K7R61PrC+3PjBoa8lz8eAnPtRYsn510vINTTmHA6+1eBCfHyrKPuDDGsAESKDp9oqjp0BKu77LjdBG89L0IMnUTRwhzmJZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7WViijYbmaf/W9bWrzVUTw6f3gXTq6mgfqs7WARdotE=;
 b=r/D34ph/z2pBeHBGtN2m7KXIbZVlzGQu3C94EV2iWOY/80uEPsHcuY/e7iUSliqNLZ5LfvuZvE/B3Hia+qy6Nvn73WFOEABgw3Pb7gLcsSFeNX0jN+JcdKNrq6RPOc/y9XhJh7N+NHJNZVtBRabhlagNES2UoSY4iz/930HRTLU=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by MN2PR10MB4096.namprd10.prod.outlook.com (2603:10b6:208:115::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Tue, 17 May
 2022 22:19:14 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311%4]) with mapi id 15.20.5273.014; Tue, 17 May 2022
 22:19:14 +0000
Message-ID: <607394fcc54e93b15920ae57dccae33bfcdc5815.camel@oracle.com>
Subject: Re: [PATCH 5/6] xfs: put attr[id] log item cache init with the
 others
From:   Alli <allison.henderson@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Tue, 17 May 2022 15:19:11 -0700
In-Reply-To: <165267196653.626272.13274217857897145109.stgit@magnolia>
References: <165267193834.626272.10112290406449975166.stgit@magnolia>
         <165267196653.626272.13274217857897145109.stgit@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH0PR07CA0026.namprd07.prod.outlook.com
 (2603:10b6:510:5::31) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f9b080c3-8869-4d90-1c7c-08da3853465d
X-MS-TrafficTypeDiagnostic: MN2PR10MB4096:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB4096F4C3ED504B4848082C2895CE9@MN2PR10MB4096.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e9dFCTSrV+5ufu2Lxy3BCIsRNIW79PBsVON9dq0XWdN6zgTwtsW+ME6Cu9Va+gCR7hGAX81mogPjBCvfdqUwE+0Z9t2USNt2SRlAUvD3muM73+A258U73V8sZRaMQbYJHMQS8o2xEnf5mlaFZBKUws98OP+Q3qXtVMYoDP7ACxIDIz1fTtaFEhnxqGIftfbr8ozSyxRty3Uf1Oa/bt0tnOS7AsLWlGfZL5gEH7KeYsqrRCSF3tIrtMXkB3/hxRiYbT2BVqQrDSkFMb9ZJpEurc2qVyvY5P98PaNKUZxtWyvW5nGt5Kiw6dUUxom/255/Rp/8r+h5ShoSPng9NOp7HiuYtNrb+qOw4YqazfS24HXxsiQeRiKUDim1fWEISGwq/BPJp8MUcsm6x/fw6GDjXZvSwGA2YPpkhE7UeuoDceEorOODpCEtl0W2NsUTmxEbzpoCTU/CM0NGBzp+qBXEGNZbsCKy2MUJBo8EAdiy4ufsLc0orq8XN4RwDosvhX4s/dEnOG3v82BsnbYOYljkBi2HrP8V3wuFQOGMEeduCQ2aEGB/v4J+ERZBtJ2rpxnpZi+eo78hJPY5KLGLjbAoioWp3R8IW2VjaYArR0F3eT4LEeZcJFSt3PhyRUkbAFHVWWjQ54pAJ21LKwneY6e2L7ERsVKqJN4OwlaY2i+rTac4jFhI99kg1A8UakI9ThNPxLld/+n+BiXw053dNno2JA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(6512007)(6486002)(83380400001)(6506007)(52116002)(6666004)(38100700002)(26005)(8936002)(316002)(86362001)(38350700002)(36756003)(4326008)(2906002)(8676002)(2616005)(66476007)(66946007)(66556008)(5660300002)(6916009)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cmR6aTRUaUYvNHAzd0dadW9nMHVFRXNsSTN6TGxVUmpSbVpzc3cyOUpzcTRp?=
 =?utf-8?B?dWg1dXlQelhNUjV5dVNBcHVQNXhnWVhLSEFIdTU4cjlWd25RdCswTFNUWm1j?=
 =?utf-8?B?YTRubEtoM05McTZ0QjlJUGhERkxRRjAvdnJNRE5obGJEUHlKUk5nR2NVZHVr?=
 =?utf-8?B?RlA5K1B0c1NJbTlPQ3pJRUFBbmxCR3N2cGV1Y3Vxd3NWRnI0cXVTZlljUGpG?=
 =?utf-8?B?WUhwMDJOTjNRT2g0OTFnMFpJcFc2UlFSdVhYb1dWRlRtcHU0c3Fwa0ZNaytQ?=
 =?utf-8?B?bkE0RnpkNGF5cWVIWnZvRi9iSXdaRWRHb1drUldwWUFCNHkwcFo1M1NJbitP?=
 =?utf-8?B?c0E1T25SRk5NQzJsbkd1THZkTE5KREhQVjFVRnVrQTd1Mzh6ZktwVTQyWTJS?=
 =?utf-8?B?bkxOeHlPeUpURzY1d21rOU04VE44UVY4b1pHaUJEcEcyMGZaN014QjBkVmtZ?=
 =?utf-8?B?cElhVHNRemxSWVlvYmowTUVkb3F5MjNTWnk5RFJycndEd1NKekZXcnF5RWZz?=
 =?utf-8?B?OUwzei9icWZBRmVOVE1tUUVOWG5vZXBxcHRlZysycXV3V1VhRmh0NUxraG9v?=
 =?utf-8?B?NlZmS1VrOEZObGQxUkRRU2MzWFh1clZIVzVQUzd2anUrMzVHdzZSL1l0aTBQ?=
 =?utf-8?B?ZFByN09YRVY4NHdScHNBSGlWbmRGRGp3OHlDMGdNKzhWNTQ0RFZrM0JrejA5?=
 =?utf-8?B?R3BjcVBSWXk3b1pZNGs0WHE5NUZaWkZtR3pERklQN0J2ZkdGT1lTajVtalBl?=
 =?utf-8?B?eDBCOVJEQW5YVGRZNEh5Umx1RlJWNCtZcit5QWdIOFJaZ0E1RW9COWluSm41?=
 =?utf-8?B?UmRyUkUzcm5IZXl0YUhXTnQyNU83aGRuMXZQbmtML2hsSzZJMkJmcUtoZFI0?=
 =?utf-8?B?VXdyL25rWUxWSjV0TnR1UWJOVjZXTXJhWk54dDBlTkZ3U0VkU2VrVDRMdnhW?=
 =?utf-8?B?bEFZNmZBS0Y4ODVVdDJjM2RCZlEvdzlQUWtFeVJMb2d6bTdnYmVqTitrZzFI?=
 =?utf-8?B?L0QySXZac3JSb3JqOElocVA4cjFjck5MaVZPTWZEUHQ0RTlhR0xSeWFKaWFS?=
 =?utf-8?B?VmNjOUNnUW5rSFNyRzJXQkhOemN0NnVtQlR1d3BGdng5eDluMkx1UzNZTEdG?=
 =?utf-8?B?UGhueGo0UzJSREdLVXJoMWdtRVN1ajJNTzU0NjB4Y0o5TFVQNCtvU01oSWZn?=
 =?utf-8?B?ZzQwWVBNYzAyaEFHVWlLRUtRU2JhOW9mVTNoNEtOeDAzazRpSnZtRnlRY1dH?=
 =?utf-8?B?NmdWRFVKSWoyaXFEY2lVQStWeHFkT09Jek92V2lCUFlmc3lKZVphNGJBeGpw?=
 =?utf-8?B?aHZrKzR3MUEwWmpLbkYyK3N0K1FGUFpLWVZqRXpFczYrL0dFU05yU0xsTHk4?=
 =?utf-8?B?RmhNdmxHR2NXc1ZpbFhaYWYzUEV6YVg4ZVNnUzgwUk56TkR6LzV4NVcrYkRo?=
 =?utf-8?B?TFNPaWk1L3QwS1VhdHdWazJ0aUlzWEs1MHozbnVrUEdxSTl4VGNocDBXbU1L?=
 =?utf-8?B?ZTdBNmVUUVh2ZVRGVFlMZzM3eTVWaURqbCtZVUtrMlZVVHhmcnhHZDZHTmJQ?=
 =?utf-8?B?eVlKaEhFZ1lPcHRkVnBFMGV5aStMTElLemx0Z3dtVThIRXRmd202NTA2OGtq?=
 =?utf-8?B?Tm55enhpWkJoMjdvT3lrTGRGeC82eEg4NWNGd3RhT1RQV3VGaU5pckZqTWRL?=
 =?utf-8?B?SW54TERTNC9pS0h0Umhqd0VTdzd4czZ4cE56RFpSbllpdVRTZGs0ZTFxblVi?=
 =?utf-8?B?eTBWWHhDcFJHeXhFUUMwWGJZZ3p1YUxOaHlZZUg2dDU3bVFxUElmZ2hWc3Bt?=
 =?utf-8?B?MnY4aWFPNmJud3BHeVhMR2dtSXFvSmxmdysrN3VnZkJqQ2dmNXc3RG16VllV?=
 =?utf-8?B?dkxmNm0wWmtadkp6ZlRaUERUUTA4RTc0cDlVWEJpcUtVMFZpY094QU5lV2pp?=
 =?utf-8?B?THRkL0h4Rm5wQVNyUTVRR2Z2ZTBWalByK2d6RE8xMUxHNkdUaHZnZWlTMUY5?=
 =?utf-8?B?R3ExOC9ibjExSDhDbzJNekt4S1RWZWx0bmJwaUNSYU1lMzRjSDNLbjRmTzdB?=
 =?utf-8?B?SXk3Zm5HUTVyeHhBRzhSN1Y2cjdkVVJvTXRmZE01TzJXVzMwMFFJcEpqeEp3?=
 =?utf-8?B?Y2tNWjhaSlNicmZhRDVYQ1htQ0JSOFY0VUtvM1MyTVdraEZmUkVhZThCOXZv?=
 =?utf-8?B?UVBuREtPLzlHcXo2aEx2M3RvUEpIV2JLeE94TTBHVXFiUlRhRkx6OVhKU3pn?=
 =?utf-8?B?YWVoczVXeEo5Ulc2TXVYdjUxMlRXNUxYaVZnaDdYaStrbzVmMGI3MkVwdUk4?=
 =?utf-8?B?WUF4NWN2Tk5qUEd1elAwSU4yNndlYTZ0K0g4ZU5ncVhEUzdzblRoVmRDWVdp?=
 =?utf-8?Q?Wt3aIEU8okvpf/Dc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9b080c3-8869-4d90-1c7c-08da3853465d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 22:19:14.2481
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HlHTMy/DE6ln7Hn0KzenFzjlR0W1tmszDrMQJb5gmV2OYz1BDMLHEqV3SYKMaLKS9aUC/Bv+AGdslB7+N7FWxOiDwiu0E+DEfL7/LNbhL1k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4096
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-17_03:2022-05-17,2022-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 malwarescore=0 adultscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205170128
X-Proofpoint-ORIG-GUID: 4SxlmfUAQS3gORZxW-pnZv-RPOsdrteO
X-Proofpoint-GUID: 4SxlmfUAQS3gORZxW-pnZv-RPOsdrteO
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, 2022-05-15 at 20:32 -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Initialize and destroy the xattr log item caches in the same places
> that
> we do all the other log item caches.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Ok, looks good
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c  |   36 ---------------------------------
> ---
>  fs/xfs/libxfs/xfs_attr.h  |    8 --------
>  fs/xfs/libxfs/xfs_defer.c |    8 --------
>  fs/xfs/xfs_attr_item.c    |    3 +++
>  fs/xfs/xfs_attr_item.h    |    3 +++
>  fs/xfs/xfs_super.c        |   19 +++++++++++++++++++
>  6 files changed, 25 insertions(+), 52 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 687e1b0c49f9..4056edf9f06e 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -27,8 +27,6 @@
>  #include "xfs_attr_item.h"
>  #include "xfs_log.h"
>  
> -struct kmem_cache		*xfs_attri_cache;
> -struct kmem_cache		*xfs_attrd_cache;
>  struct kmem_cache		*xfs_attr_intent_cache;
>  
>  /*
> @@ -1113,40 +1111,6 @@ xfs_attr_set(
>  	goto out_unlock;
>  }
>  
> -int __init
> -xfs_attri_init_cache(void)
> -{
> -	xfs_attri_cache = kmem_cache_create("xfs_attri",
> -					    sizeof(struct
> xfs_attri_log_item),
> -					    0, 0, NULL);
> -
> -	return xfs_attri_cache != NULL ? 0 : -ENOMEM;
> -}
> -
> -void
> -xfs_attri_destroy_cache(void)
> -{
> -	kmem_cache_destroy(xfs_attri_cache);
> -	xfs_attri_cache = NULL;
> -}
> -
> -int __init
> -xfs_attrd_init_cache(void)
> -{
> -	xfs_attrd_cache = kmem_cache_create("xfs_attrd",
> -					    sizeof(struct
> xfs_attrd_log_item),
> -					    0, 0, NULL);
> -
> -	return xfs_attrd_cache != NULL ? 0 : -ENOMEM;
> -}
> -
> -void
> -xfs_attrd_destroy_cache(void)
> -{
> -	kmem_cache_destroy(xfs_attrd_cache);
> -	xfs_attrd_cache = NULL;
> -}
> -
>  /*==================================================================
> ======
>   * External routines when attribute list is inside the inode
>  
> *====================================================================
> ====*/
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index f0b93515c1e8..22a2f288c1c0 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -558,14 +558,6 @@ int xfs_attr_calc_size(struct xfs_da_args *args,
> int *local);
>  void xfs_init_attr_trans(struct xfs_da_args *args, struct
> xfs_trans_res *tres,
>  			 unsigned int *total);
>  
> -extern struct kmem_cache	*xfs_attri_cache;
> -extern struct kmem_cache	*xfs_attrd_cache;
> -
> -int __init xfs_attri_init_cache(void);
> -void xfs_attri_destroy_cache(void);
> -int __init xfs_attrd_init_cache(void);
> -void xfs_attrd_destroy_cache(void);
> -
>  /*
>   * Check to see if the attr should be upgraded from non-existent or
> shortform to
>   * single-leaf-block attribute list.
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index ed65f7e5a9c7..ace229c1d251 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -871,12 +871,6 @@ xfs_defer_init_item_caches(void)
>  	if (error)
>  		goto err;
>  	error = xfs_extfree_intent_init_cache();
> -	if (error)
> -		goto err;
> -	error = xfs_attri_init_cache();
> -	if (error)
> -		goto err;
> -	error = xfs_attrd_init_cache();
>  	if (error)
>  		goto err;
>  	error = xfs_attr_intent_init_cache();
> @@ -893,8 +887,6 @@ void
>  xfs_defer_destroy_item_caches(void)
>  {
>  	xfs_attr_intent_destroy_cache();
> -	xfs_attri_destroy_cache();
> -	xfs_attrd_destroy_cache();
>  	xfs_extfree_intent_destroy_cache();
>  	xfs_bmap_intent_destroy_cache();
>  	xfs_refcount_intent_destroy_cache();
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index 89cabd792b7d..1747127434b8 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -29,6 +29,9 @@
>  #include "xfs_log_priv.h"
>  #include "xfs_log_recover.h"
>  
> +struct kmem_cache		*xfs_attri_cache;
> +struct kmem_cache		*xfs_attrd_cache;
> +
>  static const struct xfs_item_ops xfs_attri_item_ops;
>  static const struct xfs_item_ops xfs_attrd_item_ops;
>  static struct xfs_attrd_log_item *xfs_trans_get_attrd(struct
> xfs_trans *tp,
> diff --git a/fs/xfs/xfs_attr_item.h b/fs/xfs/xfs_attr_item.h
> index c3b779f82adb..cc2fbc9d58a7 100644
> --- a/fs/xfs/xfs_attr_item.h
> +++ b/fs/xfs/xfs_attr_item.h
> @@ -43,4 +43,7 @@ struct xfs_attrd_log_item {
>  	struct xfs_attrd_log_format	attrd_format;
>  };
>  
> +extern struct kmem_cache	*xfs_attri_cache;
> +extern struct kmem_cache	*xfs_attrd_cache;
> +
>  #endif	/* __XFS_ATTR_ITEM_H__ */
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 93e43e1a2863..51ce127a0cc6 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -38,6 +38,7 @@
>  #include "xfs_pwork.h"
>  #include "xfs_ag.h"
>  #include "xfs_defer.h"
> +#include "xfs_attr_item.h"
>  
>  #include <linux/magic.h>
>  #include <linux/fs_context.h>
> @@ -2083,8 +2084,24 @@ xfs_init_caches(void)
>  	if (!xfs_bui_cache)
>  		goto out_destroy_bud_cache;
>  
> +	xfs_attrd_cache = kmem_cache_create("xfs_attrd_item",
> +					    sizeof(struct
> xfs_attrd_log_item),
> +					    0, 0, NULL);
> +	if (!xfs_attrd_cache)
> +		goto out_destroy_bui_cache;
> +
> +	xfs_attri_cache = kmem_cache_create("xfs_attri_item",
> +					    sizeof(struct
> xfs_attri_log_item),
> +					    0, 0, NULL);
> +	if (!xfs_attri_cache)
> +		goto out_destroy_attrd_cache;
> +
>  	return 0;
>  
> + out_destroy_attrd_cache:
> +	kmem_cache_destroy(xfs_attrd_cache);
> + out_destroy_bui_cache:
> +	kmem_cache_destroy(xfs_bui_cache);
>   out_destroy_bud_cache:
>  	kmem_cache_destroy(xfs_bud_cache);
>   out_destroy_cui_cache:
> @@ -2131,6 +2148,8 @@ xfs_destroy_caches(void)
>  	 * destroy caches.
>  	 */
>  	rcu_barrier();
> +	kmem_cache_destroy(xfs_attri_cache);
> +	kmem_cache_destroy(xfs_attrd_cache);
>  	kmem_cache_destroy(xfs_bui_cache);
>  	kmem_cache_destroy(xfs_bud_cache);
>  	kmem_cache_destroy(xfs_cui_cache);
> 

