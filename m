Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 254EFC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Jul 2022 01:34:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237082AbiGTBey (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Jul 2022 21:34:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241837AbiGTBd7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jul 2022 21:33:59 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A526A81484;
        Tue, 19 Jul 2022 18:24:02 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26JKACx0002381;
        Wed, 20 Jul 2022 01:23:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=SXqhneKGFww7/wmx2gNfQ/zQU175yUF6MwEillKXqZ4=;
 b=tJRxWVqlEa1vX7j8rPgbNA/nee3D2b/8mokjjgRsOYgFZrNjgOWZ2UShIjjLPVKq1YQQ
 RsBhJdSTBNxgyohvjJA7+m4SLu5T+rOf70H55R6yWgF8hdS0Sah7GcUNHjduV3bgBiax
 TbxswIFBVGWmMg73Gg7umKwzJzzyesFmBqYP6Dg50/5GSqaXE9liOgF8RIjHmZ0SM/0V
 GlLWwiwOWNhhQ5Eq0wZ+5TP5NOqubeYeHi/r/QdNe1Z3bLY0AmIarGsmZtvwGEjLOT5w
 NDOG9fgV/SFBTBeOEurQFxOL2ruh2kdHnq7HdA1MRzhT82viGqFK8+4fqtx824Rmjc32 Pg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hbn7a7yh8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Jul 2022 01:23:35 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26K0v42A016396;
        Wed, 20 Jul 2022 01:23:34 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2169.outbound.protection.outlook.com [104.47.73.169])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hc1en29gh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Jul 2022 01:23:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O1IyJV5imCJKK5imh4OshggdeoR/rP1Y5UsJSHwJKAp48/Sxm+rLU53xoKMULMf65QszCYBvdoLjundDzXJr/rH+hzK5jlJqtoGeWFfRc6aYKP6lC3ZBkh1NyFECn4LDEE6E6bZt39IgcAv92Hgsfm+wd6no7PqA6JMNqUCTAbJDvNXG40na0xBcBpy7s/Nlf5Qkjfd3OPvL/u5RGcll5ekAXRCLuDnLdr21tuS/hVOlWVI4r4T5F88LvKDBVDAPUdAri7nETqWEk9iq0wW/VGe3KPCe4tWf5NdZtfnZsuY/fDqDbgZ3Zldmu7O/W1D1NfmQkjGMDT08BZAqPseMpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SXqhneKGFww7/wmx2gNfQ/zQU175yUF6MwEillKXqZ4=;
 b=A4+nDibCwBxwWLMF3O8s+7+SS6FYYpcnd0fdk+hWuj0Sv4ssHTpLqzZDlyVTo1dIGSuMBoGNgmSdDi8JpzoFkRYsMTtfnXAWBMsOo/YVkeRC/yrxqwLeDYFxWbw1h4G1sR2GXbDMJU3lTS7FabOV1/sVVRXIxxkNT3SZR3fDPXo1q1mIKhmHt3A9V4NF4G+GA4bqKqTV1W6xV8KuGTnAywJgHwi5KVYR+TJPqh/XEMs0159U+92Cz3mjt8x/4SsCgwlL1NvQMf8StjMrkr4xJK1EIArsIaT23FaQDYsyA5FtZ/vOOVf5WgCkiqnd/M4Mzl+6P6KhiOfs0BTvVpRMXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SXqhneKGFww7/wmx2gNfQ/zQU175yUF6MwEillKXqZ4=;
 b=WBV0OcI1MQNp3SqzgjSJdMAgmdZoSB3wYyFFHeSBCzZzICB2d4AIhilXEA649Rt5M9RNiwJNixYNNtovtD+5/ETHccQSiigmw1i31bYDAiQ23QSDyydb8ax4SRk1iJVaeyjF/6cXbNXu0VHtktIEFgfZtwJ9ZDID4Je4DLcjBFg=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4781.namprd10.prod.outlook.com (2603:10b6:a03:2d0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Wed, 20 Jul
 2022 01:23:32 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519%4]) with mapi id 15.20.5438.024; Wed, 20 Jul 2022
 01:23:32 +0000
Message-ID: <c13a9f6935db5696ef612079bdbdffd6d0ab18a8.camel@oracle.com>
Subject: Re: [PATCH v2] xfs/018: fix LARP testing for small block sizes
From:   Alli <allison.henderson@oracle.com>
To:     Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 19 Jul 2022 18:23:30 -0700
In-Reply-To: <20220719222520.15550-1-catherine.hoang@oracle.com>
References: <20220719222520.15550-1-catherine.hoang@oracle.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0003.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::8) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0afc987f-f753-45d2-2e12-08da69ee75a7
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4781:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8qqLiHlz6UnwHSwIQkn65c9KqHSo/XCWvHs36/ZRoJG1aYCR4ew3/7n9IsMnsL+VW5ppT69jRgO/wBApe4IA7C0UNimGY3R5aaFqG1dYENWTZahtwJDDB9jpab01zcVvqagpSvkkm+ZB7IsYv1hM0RJf9/FTkfwD4einkTiNgN9nNcC1JqexUL3HPJfuplcfz3Wl/kEbrGHglcpk9/08Z9yMRA7TFQU+1f6ZXquirt5kve74T3iYhdDCj/vTnguHHokGgjLpALXCqOZdQcCKFVJyurWTLJGneL7P29HFrM1cBkiH2ptnn3/EaRRt2nDhgTVgtQRgOFK9FOC/z2ahzH10B0mh5XUiR+tdJ2q90GV1Yu1n13IZI/5/Z8xC9800argpEoK35o2SHw3idVet6k3oFxwaIdVgVYtDeOIAGWhQEw+P2BhIQUWp3BDKlMJCBsF+W48XfkP9awfiAhsDQ7pP/GQd4vYHdlPfsMWqDk8i9XUD2KhZKq3DR+Q2gB2xX3Uowu9Ko3fNPe9FH2oUPTIJCALTXfm1sG84huQt6iw+ONE4qKl/QpwylE2ptrp7LjvM5Y5eKxOcLr1cX7a/++duA/Osuoyt4TG5wl1P8YEBiU+UxR/VQ8o/Ubnfrh/n6K+6mMZtQXTnpvC0YBgoa/yKd4dBPqvBeYbgolEBO2cPdX+aRYuVS7D/t6pjisxNvbR2P9RZxNsHXHMCOKsL3u3GffXsJjgcZRI0L3f+uyqKZhY7YzucRUAx8h0WnovEtpsruCD3J6cvIFqtTfh7bT+ER6II0DVAIaFdZwZdeaGwjxNOQ7QXeaZT5s31UNGw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(39860400002)(346002)(376002)(396003)(366004)(6486002)(38350700002)(478600001)(36756003)(186003)(86362001)(26005)(52116002)(38100700002)(6506007)(6512007)(41300700001)(316002)(450100002)(2616005)(66556008)(30864003)(66476007)(66946007)(5660300002)(8936002)(8676002)(83380400001)(2906002)(357404004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L1N0OS9RdVdueXp0VUJwWExpdTRMek1iVW1zYmNHOVNuVzAvamZYN2oxVGpV?=
 =?utf-8?B?VHhGMVRXVVBUckhOSi9ONWpFNXRpNG90bEUxYVg2Y2JZSXJTZzlOeWxyd0lw?=
 =?utf-8?B?OEpsZ3c3OXFoMmptb1R3eVNxM21TZVZTSVFWaE05bS9GL0dndzlaVzdUQjNP?=
 =?utf-8?B?VVgrZ2hhS3JjcTV5Z1hUNStVZnVlVnFIa2VkK1R1MERGdVBtWHVYRytrRnRt?=
 =?utf-8?B?WUpjK3ZJQVM4aVZ1dnZYeWVqenRwajZhYlJXTS9iUVRVbHhUZXFVck1Bc25x?=
 =?utf-8?B?NGJQT0N2MzZhUlZTdTlidFVuVEhENXQwNVMxNkJYbU9VeUlCUFVsM21OY2FR?=
 =?utf-8?B?aEIvU0gxRCtGWmJPdCsrencrOFhTTzY4b0g3TjNjVTYzZGVqWHNrM2lGS25O?=
 =?utf-8?B?KzkvL0RYMGsrakRrcWRaSDh1QlREYm54YUdycGxKSlYwNktXRFgvYnF0bHdQ?=
 =?utf-8?B?VWZybGdvWHBLWi9rTnJjTVpvdldTOXAvZWZJb2REem5IRHJPUHRTL0g5elhx?=
 =?utf-8?B?bGhwNHpxcWwrUVMyLzBQbWFlRmhicThwMGp2Q2JSMVlRclg0ZEtxSHlNMnhY?=
 =?utf-8?B?OEdwdnZjSGMzSVVhRUoxZUhlRDhUUyszQ1lpOVFaMnJCTUYxUS9JUlZKL3J3?=
 =?utf-8?B?cUN0clNKLzlDKzZueGxtcWtMa0wxL04waExLdXBtU2laUGpEME8vZmZVUHhR?=
 =?utf-8?B?T3FhZVo2cVlKU2E1Y1NqdDEvMUk3bkY3RWNsWE5wcnpSRUlrREppbGJPd3Jq?=
 =?utf-8?B?bHdCbFk1aWtNYjVRY1hEY2t3bTZzMlJmb0F0b3c0RDVjd3dXSExncHBGQWVz?=
 =?utf-8?B?MUxucUdYcjRUK0tvZXh0WWR5RFRXaUtabFMvUll4L2xpQ3pJVkVOdjFmWnJO?=
 =?utf-8?B?cnQ5TEhGMy9UeVlPQ09EV3g0TEhvNzdxaXQrSENhZFFLL2F0STgzZkFSbDFW?=
 =?utf-8?B?TFlhRmptZ2xFQ3pnY29KUUMwV3VURm1yejJxTkVwSk9Pc3lXVmJobUNYblJL?=
 =?utf-8?B?czBQOFJEcHVtUGFvai95Wmh1NmFMc2tjMjBNWDZiZnBLMlZUM1NwcC9Ec2Rv?=
 =?utf-8?B?VFJ6Vkl3bFlENjNrMVMwTDdkL1JTc1I5RkVkbkVLZkVOOVpuRVNKeGhoOHVM?=
 =?utf-8?B?dmZEWkt2SU85Mk83NkQ3OHltcGYyWGYycnpETVNrSUo0anREZHFuaFB4NDQw?=
 =?utf-8?B?L3pHUkljall4NFZNRGpGbE1pUmxsNSs3MVNNR0RJRy9lVGttMmdOdkdXbkRo?=
 =?utf-8?B?cGVORzlISmFLYy8zWlByYXRpZGlPcjFMUzBWbGdvRkJLUDJlSjNBT1gzQXlm?=
 =?utf-8?B?c0VkSDNKU3ByNUowcEU5L3ZBY2ZuRFZTNUhaNFBsTE8vbk0yQngyc2NTTk9Q?=
 =?utf-8?B?MGw4QlRtc0hiTFZLSUxTaTJ0ZHRRaEhLMmVyc3BtenBuR09yODVHSmtxVCs0?=
 =?utf-8?B?K2VjOHR4NFpTWDBnVHFMeG55eFBna05hdjZRRHVsYU95eXlDb0MrMHowaVRi?=
 =?utf-8?B?YWpwTWZOeVZFZFJGQjBCUFhCbklTa24wMXdBRWlrNjEzdGxjSWlONFRLcW45?=
 =?utf-8?B?c3U4TVNDZlRCa0Q4clVwVFNpa1M0US90bHMvcXVOWXo2d1hPR21VOVJjbTJm?=
 =?utf-8?B?MEZGeEdsNFZpaXRCQnUzNUs4b2RZZjdGVS9WVzBJYmZIYjFiV25aaUpaUnNC?=
 =?utf-8?B?VFBGeGc3MTVhdmhpMGR1UVFvRHFqZ3pTT21ha2lINXFYZGpRKzdjOTZFelE4?=
 =?utf-8?B?WTRNaGFWTTNtcytOUWpROUdUSXBtVmlLSExZakhpSEJnNm5tM0doTjR2QjE5?=
 =?utf-8?B?WVFuZHRUR1hoK3ZVUlRvYmxCVk43NkcxZ04vTDVleFd4WUwzZXp3SGdjbkJC?=
 =?utf-8?B?K205ZVFva0pndUZPbVJVV2lkWTlFWDI4bDQvendCWDFITVpSMFd5Q3hUcnh5?=
 =?utf-8?B?WWFiS0VkZkJOWDN3UzlxeFBWRlBpdDBGUUwrMFdiSjNQWEhpTkFmQVJLcUdH?=
 =?utf-8?B?TnZoTWNXWklSU2ZFTS9CbHdET2pPWWFiaGxWK3pSN2tHUHdkcEpodS92N2Ez?=
 =?utf-8?B?TnloY0xzeVN2a2tlTzBzYnNTQjR5K2pmcXI1RmdKTXRQNmZLWlk4NjZuNVpU?=
 =?utf-8?B?SmN6MjkxcFBHZDVmOXVzaVg4c2VJcnBKbDJVeXFzaWdjbDc0NG9wQjl3Um5o?=
 =?utf-8?B?NUE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0afc987f-f753-45d2-2e12-08da69ee75a7
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2022 01:23:32.5400
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VOYuX/d3/MRhBVEqNhlQGlch/SNZA80jUa0kI/dGcGkSLtOTVLAeN4Z3xvA9tTe0ump8dynCHl8rtPCpLLLlwQ13wY9S5co/07b8sI2QJhc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4781
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-19_10,2022-07-19_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 adultscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207200003
X-Proofpoint-ORIG-GUID: 4_A9B4heLtE96Ug75LInC6Dnwc2Xn_1i
X-Proofpoint-GUID: 4_A9B4heLtE96Ug75LInC6Dnwc2Xn_1i
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 2022-07-19 at 15:25 -0700, Catherine Hoang wrote:
> From: "Darrick J. Wong" <djwong@kernel.org>
> 
> Fix this test to work properly when the filesystem block size is less
> than 4k.  Tripping the error injection points on shape changes in the
> xattr structure must be done dynamically.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Looks good to me
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>  tests/xfs/018     | 14 +++++++++-----
>  tests/xfs/018.out | 47 ++++-----------------------------------------
> --
>  2 files changed, 13 insertions(+), 48 deletions(-)
> 
> diff --git a/tests/xfs/018 b/tests/xfs/018
> index 041a3b24..323279b5 100755
> --- a/tests/xfs/018
> +++ b/tests/xfs/018
> @@ -47,7 +47,8 @@ test_attr_replay()
>  	touch $testfile
>  
>  	# Verify attr recovery
> -	$ATTR_PROG -l $testfile | _filter_scratch
> +	$ATTR_PROG -l $testfile >> $seqres.full
> +	echo "Checking contents of $attr_name" >> $seqres.full
>  	echo -n "$attr_name: "
>  	$ATTR_PROG -q -g $attr_name $testfile 2> /dev/null | md5sum;
>  
> @@ -98,6 +99,9 @@ attr64k="$attr32k$attr32k"
>  echo "*** mkfs"
>  _scratch_mkfs >/dev/null
>  
> +blk_sz=$(_scratch_xfs_get_sb_field blocksize)
> +multiplier=$(( $blk_sz / 276 )) # 256 + 20 to account for attr name
> +
>  echo "*** mount FS"
>  _scratch_mount
>  
> @@ -140,12 +144,12 @@ test_attr_replay extent_file1 "attr_name2"
> $attr1k "s" "larp"
>  test_attr_replay extent_file1 "attr_name2" $attr1k "r" "larp"
>  
>  # extent, inject error on split
> -create_test_file extent_file2 3 $attr1k
> -test_attr_replay extent_file2 "attr_name4" $attr1k "s"
> "da_leaf_split"
> +create_test_file extent_file2 $multiplier $attr256
> +test_attr_replay extent_file2 "attr_nameXXXX" $attr256 "s"
> "da_leaf_split"
>  
>  # extent, inject error on fork transition
> -create_test_file extent_file3 3 $attr1k
> -test_attr_replay extent_file3 "attr_name4" $attr1k "s"
> "attr_leaf_to_node"
> +create_test_file extent_file3 $multiplier $attr256
> +test_attr_replay extent_file3 "attr_nameXXXX" $attr256 "s"
> "attr_leaf_to_node"
>  
>  # extent, remote
>  create_test_file extent_file4 1 $attr1k
> diff --git a/tests/xfs/018.out b/tests/xfs/018.out
> index 022b0ca3..57dc448a 100644
> --- a/tests/xfs/018.out
> +++ b/tests/xfs/018.out
> @@ -4,7 +4,6 @@ QA output created by 018
>  attr_set: Input/output error
>  Could not set "attr_name" for SCRATCH_MNT/testdir/empty_file1
>  touch: cannot touch 'SCRATCH_MNT/testdir/empty_file1': Input/output
> error
> -Attribute "attr_name" has a 65 byte value for
> SCRATCH_MNT/testdir/empty_file1
>  attr_name: cfbe2a33be4601d2b655d099a18378fc  -
>  
>  attr_remove: Input/output error
> @@ -15,7 +14,6 @@ attr_name: d41d8cd98f00b204e9800998ecf8427e  -
>  attr_set: Input/output error
>  Could not set "attr_name" for SCRATCH_MNT/testdir/empty_file2
>  touch: cannot touch 'SCRATCH_MNT/testdir/empty_file2': Input/output
> error
> -Attribute "attr_name" has a 1025 byte value for
> SCRATCH_MNT/testdir/empty_file2
>  attr_name: 9fd415c49d67afc4b78fad4055a3a376  -
>  
>  attr_remove: Input/output error
> @@ -26,7 +24,6 @@ attr_name: d41d8cd98f00b204e9800998ecf8427e  -
>  attr_set: Input/output error
>  Could not set "attr_name" for SCRATCH_MNT/testdir/empty_file3
>  touch: cannot touch 'SCRATCH_MNT/testdir/empty_file3': Input/output
> error
> -Attribute "attr_name" has a 65536 byte value for
> SCRATCH_MNT/testdir/empty_file3
>  attr_name: 7f6fd1b6d872108bd44bd143cbcdfa19  -
>  
>  attr_remove: Input/output error
> @@ -37,132 +34,96 @@ attr_name: d41d8cd98f00b204e9800998ecf8427e  -
>  attr_set: Input/output error
>  Could not set "attr_name2" for SCRATCH_MNT/testdir/inline_file1
>  touch: cannot touch 'SCRATCH_MNT/testdir/inline_file1': Input/output
> error
> -Attribute "attr_name1" has a 16 byte value for
> SCRATCH_MNT/testdir/inline_file1
> -Attribute "attr_name2" has a 65 byte value for
> SCRATCH_MNT/testdir/inline_file1
>  attr_name2: cfbe2a33be4601d2b655d099a18378fc  -
>  
>  attr_remove: Input/output error
>  Could not remove "attr_name2" for SCRATCH_MNT/testdir/inline_file1
>  touch: cannot touch 'SCRATCH_MNT/testdir/inline_file1': Input/output
> error
> -Attribute "attr_name1" has a 16 byte value for
> SCRATCH_MNT/testdir/inline_file1
>  attr_name2: d41d8cd98f00b204e9800998ecf8427e  -
>  
>  attr_set: Input/output error
>  Could not set "attr_name2" for SCRATCH_MNT/testdir/inline_file2
>  touch: cannot touch 'SCRATCH_MNT/testdir/inline_file2': Input/output
> error
> -Attribute "attr_name2" has a 1025 byte value for
> SCRATCH_MNT/testdir/inline_file2
> -Attribute "attr_name1" has a 16 byte value for
> SCRATCH_MNT/testdir/inline_file2
>  attr_name2: 9fd415c49d67afc4b78fad4055a3a376  -
>  
>  attr_remove: Input/output error
>  Could not remove "attr_name2" for SCRATCH_MNT/testdir/inline_file2
>  touch: cannot touch 'SCRATCH_MNT/testdir/inline_file2': Input/output
> error
> -Attribute "attr_name1" has a 16 byte value for
> SCRATCH_MNT/testdir/inline_file2
>  attr_name2: d41d8cd98f00b204e9800998ecf8427e  -
>  
>  attr_set: Input/output error
>  Could not set "attr_name2" for SCRATCH_MNT/testdir/inline_file3
>  touch: cannot touch 'SCRATCH_MNT/testdir/inline_file3': Input/output
> error
> -Attribute "attr_name2" has a 65536 byte value for
> SCRATCH_MNT/testdir/inline_file3
> -Attribute "attr_name1" has a 16 byte value for
> SCRATCH_MNT/testdir/inline_file3
>  attr_name2: 7f6fd1b6d872108bd44bd143cbcdfa19  -
>  
>  attr_remove: Input/output error
>  Could not remove "attr_name2" for SCRATCH_MNT/testdir/inline_file3
>  touch: cannot touch 'SCRATCH_MNT/testdir/inline_file3': Input/output
> error
> -Attribute "attr_name1" has a 16 byte value for
> SCRATCH_MNT/testdir/inline_file3
>  attr_name2: d41d8cd98f00b204e9800998ecf8427e  -
>  
>  attr_set: Input/output error
>  Could not set "attr_name2" for SCRATCH_MNT/testdir/extent_file1
>  touch: cannot touch 'SCRATCH_MNT/testdir/extent_file1': Input/output
> error
> -Attribute "attr_name2" has a 1025 byte value for
> SCRATCH_MNT/testdir/extent_file1
> -Attribute "attr_name1" has a 1024 byte value for
> SCRATCH_MNT/testdir/extent_file1
>  attr_name2: 9fd415c49d67afc4b78fad4055a3a376  -
>  
>  attr_remove: Input/output error
>  Could not remove "attr_name2" for SCRATCH_MNT/testdir/extent_file1
>  touch: cannot touch 'SCRATCH_MNT/testdir/extent_file1': Input/output
> error
> -Attribute "attr_name1" has a 1024 byte value for
> SCRATCH_MNT/testdir/extent_file1
>  attr_name2: d41d8cd98f00b204e9800998ecf8427e  -
>  
>  attr_set: Input/output error
> -Could not set "attr_name4" for SCRATCH_MNT/testdir/extent_file2
> +Could not set "attr_nameXXXX" for SCRATCH_MNT/testdir/extent_file2
>  touch: cannot touch 'SCRATCH_MNT/testdir/extent_file2': Input/output
> error
> -Attribute "attr_name4" has a 1025 byte value for
> SCRATCH_MNT/testdir/extent_file2
> -Attribute "attr_name2" has a 1024 byte value for
> SCRATCH_MNT/testdir/extent_file2
> -Attribute "attr_name3" has a 1024 byte value for
> SCRATCH_MNT/testdir/extent_file2
> -Attribute "attr_name1" has a 1024 byte value for
> SCRATCH_MNT/testdir/extent_file2
> -attr_name4: 9fd415c49d67afc4b78fad4055a3a376  -
> +attr_nameXXXX: f4ea5799d72a0a9bf2d56a685c9cba7a  -
>  
>  attr_set: Input/output error
> -Could not set "attr_name4" for SCRATCH_MNT/testdir/extent_file3
> +Could not set "attr_nameXXXX" for SCRATCH_MNT/testdir/extent_file3
>  touch: cannot touch 'SCRATCH_MNT/testdir/extent_file3': Input/output
> error
> -Attribute "attr_name4" has a 1025 byte value for
> SCRATCH_MNT/testdir/extent_file3
> -Attribute "attr_name2" has a 1024 byte value for
> SCRATCH_MNT/testdir/extent_file3
> -Attribute "attr_name3" has a 1024 byte value for
> SCRATCH_MNT/testdir/extent_file3
> -Attribute "attr_name1" has a 1024 byte value for
> SCRATCH_MNT/testdir/extent_file3
> -attr_name4: 9fd415c49d67afc4b78fad4055a3a376  -
> +attr_nameXXXX: f4ea5799d72a0a9bf2d56a685c9cba7a  -
>  
>  attr_set: Input/output error
>  Could not set "attr_name2" for SCRATCH_MNT/testdir/extent_file4
>  touch: cannot touch 'SCRATCH_MNT/testdir/extent_file4': Input/output
> error
> -Attribute "attr_name2" has a 65536 byte value for
> SCRATCH_MNT/testdir/extent_file4
> -Attribute "attr_name1" has a 1024 byte value for
> SCRATCH_MNT/testdir/extent_file4
>  attr_name2: 7f6fd1b6d872108bd44bd143cbcdfa19  -
>  
>  attr_remove: Input/output error
>  Could not remove "attr_name2" for SCRATCH_MNT/testdir/extent_file4
>  touch: cannot touch 'SCRATCH_MNT/testdir/extent_file4': Input/output
> error
> -Attribute "attr_name1" has a 1024 byte value for
> SCRATCH_MNT/testdir/extent_file4
>  attr_name2: d41d8cd98f00b204e9800998ecf8427e  -
>  
>  attr_set: Input/output error
>  Could not set "attr_name2" for SCRATCH_MNT/testdir/remote_file1
>  touch: cannot touch 'SCRATCH_MNT/testdir/remote_file1': Input/output
> error
> -Attribute "attr_name2" has a 1025 byte value for
> SCRATCH_MNT/testdir/remote_file1
> -Attribute "attr_name1" has a 65536 byte value for
> SCRATCH_MNT/testdir/remote_file1
>  attr_name2: 9fd415c49d67afc4b78fad4055a3a376  -
>  
>  attr_remove: Input/output error
>  Could not remove "attr_name2" for SCRATCH_MNT/testdir/remote_file1
>  touch: cannot touch 'SCRATCH_MNT/testdir/remote_file1': Input/output
> error
> -Attribute "attr_name1" has a 65536 byte value for
> SCRATCH_MNT/testdir/remote_file1
>  attr_name2: d41d8cd98f00b204e9800998ecf8427e  -
>  
>  attr_set: Input/output error
>  Could not set "attr_name2" for SCRATCH_MNT/testdir/remote_file2
>  touch: cannot touch 'SCRATCH_MNT/testdir/remote_file2': Input/output
> error
> -Attribute "attr_name2" has a 65536 byte value for
> SCRATCH_MNT/testdir/remote_file2
> -Attribute "attr_name1" has a 65536 byte value for
> SCRATCH_MNT/testdir/remote_file2
>  attr_name2: 7f6fd1b6d872108bd44bd143cbcdfa19  -
>  
>  attr_remove: Input/output error
>  Could not remove "attr_name2" for SCRATCH_MNT/testdir/remote_file2
>  touch: cannot touch 'SCRATCH_MNT/testdir/remote_file2': Input/output
> error
> -Attribute "attr_name1" has a 65536 byte value for
> SCRATCH_MNT/testdir/remote_file2
>  attr_name2: d41d8cd98f00b204e9800998ecf8427e  -
>  
>  attr_set: Input/output error
>  Could not set "attr_name2" for SCRATCH_MNT/testdir/sf_file
>  touch: cannot touch 'SCRATCH_MNT/testdir/sf_file': Input/output
> error
> -Attribute "attr_name1" has a 64 byte value for
> SCRATCH_MNT/testdir/sf_file
> -Attribute "attr_name2" has a 17 byte value for
> SCRATCH_MNT/testdir/sf_file
>  attr_name2: 9a6eb1bc9da3c66a9b495dfe2fe8a756  -
>  
>  attr_set: Input/output error
>  Could not set "attr_name2" for SCRATCH_MNT/testdir/leaf_file
>  touch: cannot touch 'SCRATCH_MNT/testdir/leaf_file': Input/output
> error
> -Attribute "attr_name2" has a 257 byte value for
> SCRATCH_MNT/testdir/leaf_file
> -Attribute "attr_name3" has a 1024 byte value for
> SCRATCH_MNT/testdir/leaf_file
> -Attribute "attr_name1" has a 1024 byte value for
> SCRATCH_MNT/testdir/leaf_file
>  attr_name2: f4ea5799d72a0a9bf2d56a685c9cba7a  -
>  
>  attr_set: Input/output error
>  Could not set "attr_name2" for SCRATCH_MNT/testdir/node_file
>  touch: cannot touch 'SCRATCH_MNT/testdir/node_file': Input/output
> error
> -Attribute "attr_name2" has a 257 byte value for
> SCRATCH_MNT/testdir/node_file
> -Attribute "attr_name1" has a 65536 byte value for
> SCRATCH_MNT/testdir/node_file
>  attr_name2: f4ea5799d72a0a9bf2d56a685c9cba7a  -
>  
>  *** done

