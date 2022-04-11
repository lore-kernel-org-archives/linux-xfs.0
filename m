Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 549ACC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Apr 2022 05:24:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244721AbiDKF0U (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Apr 2022 01:26:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230426AbiDKF0P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Apr 2022 01:26:15 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 471DEF0A
        for <linux-xfs@vger.kernel.org>; Sun, 10 Apr 2022 22:24:02 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23B2ZdBn018439;
        Mon, 11 Apr 2022 05:24:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=a7x76VUr81ERQFnT3mJlCH0rYqb2NQZvEMgr4ktO1fg=;
 b=T5swE7tlDTamPq/EV+BQxf6dNM38Ojgr+6WH+U0Of5o15tdvQP8bgEs69sQrt9QVwFfm
 Gh6UUHJjIEI4aL7Ge1/OY5PIHq33s7uxMFA78YTJEJvxIdavQ91QT/iBfpKRxlPugzaT
 POqjnQbuW7oZUUaJP5xSkG1nWzG5M5oFbfhZciv0CQv5ULyR7xsiOA3lBpG0W9ughwMo
 U97OImvx4Cn6Msw2eZ+Zk2gc5C+VmU2ixc5GP4hVE8/0kVW4OiERVsYrs2+HlWL0lzlt
 AfAPK6mlZ+ivSg9i1BMwtwgu1DchHR59tgaTv8lKujQ30NX9rhIXgWrGkGSJlKB3pDTj ug== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb0r1acnh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 05:24:00 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23B5H6Ix030192;
        Mon, 11 Apr 2022 05:23:59 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fb0k13mms-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 05:23:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q1vRe4zjlGbXYQK8t6VLULS4IztSkK4GRMnTi6tIyxgB88LNJWLME9CaQXRyZBwijxKc7q4pw4Jl8GF2U+nvJoAUUjlOgvB5HdH4Dc9eMUhjMWORUcXfcT4vHD5F1TS/WYoOy8sVmLNhmZJeEVksmRaPnkZsHt70jMa6TFwA8Mz/vl84EqT338lzAN5vE+JNJbBUOFJb61uU9JCCDXVBR+bFFLhjjNb8KxJALNwJ1CWXIgk9xgE3h5NpCggZt9+LVujuYj+/QIskTDx7Xt1fg4bSBry3WktGzBXkbW/M9Fi6a86LVN+rJYlul7AIBL1MsJEUDjxojBVX4h8VUcmwfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a7x76VUr81ERQFnT3mJlCH0rYqb2NQZvEMgr4ktO1fg=;
 b=ACBLV04E4s4F8bJQu3GIzws1rKzKsaRsky9ug8ZEX5Qw3Z3CZahpBjt3w+2cQ6971YjlbUk8ElNOv68ctbDXW1RlddY2jAWilVaHW/OvYc2yyoonCtFwpT3QZ/R73GAs6OSsg4Y7ssOpz/4nuZcgh3q4K/TNNbHwuD9SY9L0wWDtOks/cMVcgQSX3YhAuF56vySe/zm2lqrHKcB0TYpqlPxvV7LHf4CajLD8UQGK/1D1IYEj8xesAqxesPgArXHg+5e++/eUTkm4GKiHtMHbRBjRF1gjvg15BeaeKSeAhVgk0bxfBDNG85YNy7WDRos0xYOup7wgAK6scA39DCbQIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a7x76VUr81ERQFnT3mJlCH0rYqb2NQZvEMgr4ktO1fg=;
 b=K/JUArcTDTUr3hR8dyHM5rTW/pEpEwYXUgrXVzChb0Hl8M370sd46Xy37mu9RAOAyayj8a0tz9uL/q4KVSIWhsAHB7Xigmbv+eoNz6pbrhZs8l0PeT+qVTCB3LmmXd9Zqrctpd/AxJJWSJrxXa7ehtdooC2NeOALqDrB9Y2UHH8=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BLAPR10MB4948.namprd10.prod.outlook.com (2603:10b6:208:307::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Mon, 11 Apr
 2022 05:23:56 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::4cac:3ab1:a828:34ca]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::4cac:3ab1:a828:34ca%4]) with mapi id 15.20.5144.029; Mon, 11 Apr 2022
 05:23:56 +0000
Message-ID: <6c9a6f0358503c28e0b63a778b15c1daba8898e5.camel@oracle.com>
Subject: Re: [PATCH 4/8] xfs: tag transactions that contain intent done items
From:   Alli <allison.henderson@oracle.com>
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Sun, 10 Apr 2022 22:23:55 -0700
In-Reply-To: <20220314220631.3093283-5-david@fromorbit.com>
References: <20220314220631.3093283-1-david@fromorbit.com>
         <20220314220631.3093283-5-david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0152.namprd05.prod.outlook.com
 (2603:10b6:a03:339::7) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9dcf9327-dcb0-4514-fce3-08da1b7b79b6
X-MS-TrafficTypeDiagnostic: BLAPR10MB4948:EE_
X-Microsoft-Antispam-PRVS: <BLAPR10MB4948210AC82AF2C22FB107BE95EA9@BLAPR10MB4948.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KQppHafvouU0UhdZqJeAHpGM20+kdUgjeiDCd3petohFxSOyfM1YYBtYe0eh+BoHsNVRRjAKxhR5332yCYxN+YbnRNJpUDFgL9rPlxwglX631Rg6/ZQp2cTrx97S+oFff7tvdneqvAkVOThs5/7r+0FgxXSePmM/ik6pRUSZ8x+fBTNZT8MDJqGRN8VPc5cDDY4jxltMsCp0UI0qvjbm7PdlZkTRGixs7SGbaNU+bi13tp9k3/REjxXR2XO7g9Le+AFI65m/YiyG3QRGRbNFfCtH/nwHd6vzPZ0qkbYMWjekamrwqcoTpPQ0vAxXLdtgw/JVv7nRX0KRY8DswcOLIUnmP1Lmc6hCn1J/6ta9ZuBEiyVB9lm5iQ5+HFMtESD/g7ptutyIaumWDYkGnnhrwkxNnzumA9NMBDtWfUmGMWEZhc7WIRweao58qy0aG6A+uWUCY0SxojFe0D10fZi8oZriSzyQYPoJcg+Ivcwo/Dp7RQvvIZPfdFs4KB0gpYaym9h8e9qCvMxy/44h5+kCOx5j8igrsOQ2+gbrvI5YkiB8SJkRnkQ1l9S+CGjN78wI0CEBKpUs271TCICB9kjSCo6h0S2YHK44nbL69AaQ8y93oIUuj9HxtEqeaOm0Uy1s+zh5Hx92TxufGWf93sJKbG5Y6oEBOAVdZvLiEPx/Hx6KzlRzAMZKcWWDB57cwP2MmrNkAg5yyYVyjbQJy+d3eg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(86362001)(38350700002)(38100700002)(2906002)(316002)(5660300002)(6512007)(66476007)(26005)(52116002)(6506007)(2616005)(186003)(36756003)(508600001)(6486002)(66556008)(66946007)(8676002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MzQvZEpMRmJudzVUN3dLTC83c2VMQlYyWVVZeEs2Rk56NFkwK1BsS2ZXTDJq?=
 =?utf-8?B?QmVvbE5WTUN2eXFlT0QwNzZxVEJETmdrSDI0QnBrNGYwV2JxcE02Uk9XQ3p1?=
 =?utf-8?B?cGFwSFJLaFFaLzlOb0NFZEkzTEVaNFIraVBIdXY0REJCQzdRc0phRTYxdS9W?=
 =?utf-8?B?bDl5QVNGRCtGR2xEK2hJeWkvb2dKMHkzc2ZoNlFzZjhPL3VNU09zanNXUzBC?=
 =?utf-8?B?OE52RjUxTzdVeG1GRkRYOVpvbFN4N1RyZU5uUkl4N2pwMlQ1bHdicG1NMDNy?=
 =?utf-8?B?OXpqQ1VxVG0xWjVaZU04bVljRzNORmtWY1NZVUJZU2lBMWhvR0VOc1laZnRj?=
 =?utf-8?B?UGZUdUxweGh5OHhMTDlwaFB3cDFPbHFhU2YzQ1ljYUtZYzNnZjBtTDl4K2NC?=
 =?utf-8?B?ZXpHc25LS1JqVy96dk0rT3IzNHFMbkcyUUVZcE91Si9BRzdpTFI1R2hwcUFr?=
 =?utf-8?B?OEF0M240M0hoR3lxRVMrZHVKMVVEOEhVMFFwTk9tc1BtQ3h3dG9MR1ozZlU4?=
 =?utf-8?B?R091YU8xVHJvSTlTWWw0SWZadXJ2R2Q5dWE5K0tSemhyQ0MySXNZTW8zTklS?=
 =?utf-8?B?emtyTnAxZTFMT29Ob2o3TGFRdFliME9EWU9raW5MVzgwSFFQRW5NaUw1cUxt?=
 =?utf-8?B?NGhNanhuaTRPTjRiSE9tcTZUNVNRM0dGdEQyVlVRd2ZCa2dJK1BYdWsvaEYv?=
 =?utf-8?B?ZXBYZmJ5THQ5UXV6VHB6WW4vaytMNkdZMzM4QUJFdWxidURscHFIVnpyc0hJ?=
 =?utf-8?B?UGd5NXFudEo2SUpxSDc0QlFYTWVHNWNxYldPOGdlZGhVKy9ZWUNlcklFNWxE?=
 =?utf-8?B?Uzc3dFBxeGNNTUJjelNaL241bDBOQnlIdGpLemIvUXUyN1JiUStSSCt5eFc1?=
 =?utf-8?B?SXF6SmRRbDJ0M05jV2VsUDd6YTFJYVZCYjRGN2hJVEZ5aHMxall6cW13U1JW?=
 =?utf-8?B?SFhRbVM5YWlkMTNsNDU2dTdhaXF0T2VxOFhFbkdOSFBKQTgvRXpWN0RMS04z?=
 =?utf-8?B?REw0Zk40SlJRUFFDa0VmR1Q2c0xsdnFpVVZrWS9VZDVMa2lzZHlKOGJ3NHlD?=
 =?utf-8?B?RTgyVkRrU2k4b2JIYzU0QjJ3N1dSR1NhdkZSVzVqdzNMQm45ZFN6S1pNMGN3?=
 =?utf-8?B?UVVTODBzTXRyQ0hkbjlybWdOcVlFMjlUZEpmc1F3NjEvZHM1OTRTSUxVenNC?=
 =?utf-8?B?VC9NMFFybGtxMFNaWW1vZ0xrTzJ3RXBmTVpwSHNGdE54bThRcW1DRXJjdmRB?=
 =?utf-8?B?YmNvV2VDS1p0L3lHQ0QyNWZuRFdhVWpLV2JSVGM1NVJ4YVFZV1Z5NkdKRHFR?=
 =?utf-8?B?eU42WXo0WHQvYTVmVEVXM1puVzhRODZKeGZBSmQ1dEFqUDZZbnNVWWREOHpR?=
 =?utf-8?B?VXBjNnVyS3cwZWovVXpuTzk5cUpsOHEvdjJhWDNYdnh2TDRMZm4xd3Y3MFYw?=
 =?utf-8?B?cnFabC9XTFo1b3VzVm5GVmY4YlJzSDZ6VGhMcGNaU04wZ2Nkb2NtNU1iSCtO?=
 =?utf-8?B?M1hoZk10bm9JOTZxZzI4M1ljdW44WWN6aVpLcldNOEhtRC9KeUN1cENyd2Y3?=
 =?utf-8?B?QkQ5NUNkZ3N4TnBMZ0NkVHR3R1lYM0F0cHh2cTJHd05oTXlaRnlLT1QzSHF0?=
 =?utf-8?B?TG9BWW1BbTFNNElyRjB6c21TdU5naXdpUngyV0tJSzBwcnVqV01RUlRTaHEy?=
 =?utf-8?B?VTF0MGptSXk4dFF0T281ZkhQN0NMS3lwNHoydEtuNjFGT09Dc2RGUmxTbzlS?=
 =?utf-8?B?YWJOSGYxRlUwRThWL1BlbHJCMEJja1lKTWdDRUhhSzFwY3VkUXczOFloVlY1?=
 =?utf-8?B?ajVwcThNT0Q5M1ZOeDJHM3IxdXY1YUFpenkvbkFvYkhSTi9mVXVPK3hSRWdM?=
 =?utf-8?B?VW5qR2g0V3djMjI5bU1YMEU4TVpZK1hxdzgwQmttdEIwZ2IzWXM3aGNyQ3Fu?=
 =?utf-8?B?T05HVTFoYnNCTTQvK25rVW4xM2Ywc1o0UEhaSGk0VVZSOXVQYkRBN0pXQzNy?=
 =?utf-8?B?VzV2cFdtZ1JNRytaRXYva2tmbUNGZWdHenZhUmhWY2dBMnRIaWJSbjMxQUJr?=
 =?utf-8?B?SHA1K0Nvd21rcWl0MW5LUHp6cVJYK2FMREcrdXZTNnNoaG1mbFFpalJmMFZ4?=
 =?utf-8?B?aWprdTA3VEhoSjVCTWZhRWxLU0NuaDZxa0xZY1dJbDlTKzdGcE9IcElSUWYv?=
 =?utf-8?B?SmNpQVU2QXI3Z0Q2dUQ3Ry91Sng4eS9HcWJVWUVvaXgxQWtCa0R1b29PU1JW?=
 =?utf-8?B?Tzg0UU42d2l5WUZ4dXdGbWUrSGVRdllJWmhrZGp3aGYxZm5NNE1MQXBNRzBa?=
 =?utf-8?B?bXQwNVZEanRScU9tTW1SSHo2eUpZRlpqWHRSYW43YUFNTzVrMVdCTXk3aHVY?=
 =?utf-8?Q?Zx8J8CS2s5MJ8sCg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dcf9327-dcb0-4514-fce3-08da1b7b79b6
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2022 05:23:56.4246
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 18/kr8nGMAaeXhhu0jeVmyQgAkt1si9/EjKZKF5lYEh4UKE8JT24keVeXvLeHg8ZoLbTZSaKdyPDPpUMvMxDiPrq1de1hjRVQDa9pxnYQ1c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4948
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-11_01:2022-04-08,2022-04-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 mlxscore=0
 bulkscore=0 phishscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204110030
X-Proofpoint-GUID: lRoHd6UAazromLPo8z1qtTguL-AB033W
X-Proofpoint-ORIG-GUID: lRoHd6UAazromLPo8z1qtTguL-AB033W
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 2022-03-15 at 09:06 +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Intent whiteouts will require extra work to be done during
> transaction commit if the transaction contains an intent done item.
> 
> To determine if a transaction contains an intent done item, we want
> to avoid having to walk all the items in the transaction to check if
> they are intent done items. Hence when we add an intent done item to
> a transaction, tag the transaction to indicate that it contains such
> an item.
> 
> We don't tag the transaction when the defer ops is relogging an
> intent to move it forward in the log. Whiteouts will never apply to
> these cases, so we don't need to bother looking for them.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
Ok, makes sense:
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_shared.h | 24 +++++++++++++++++-------
>  fs/xfs/xfs_bmap_item.c     |  2 +-
>  fs/xfs/xfs_extfree_item.c  |  2 +-
>  fs/xfs/xfs_refcount_item.c |  2 +-
>  fs/xfs/xfs_rmap_item.c     |  2 +-
>  5 files changed, 21 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
> index 25c4cab58851..e96618dbde29 100644
> --- a/fs/xfs/libxfs/xfs_shared.h
> +++ b/fs/xfs/libxfs/xfs_shared.h
> @@ -54,13 +54,23 @@ void	xfs_log_get_max_trans_res(struct
> xfs_mount *mp,
>  /*
>   * Values for t_flags.
>   */
> -#define	XFS_TRANS_DIRTY		0x01	/* something needs to
> be logged */
> -#define	XFS_TRANS_SB_DIRTY	0x02	/* superblock is
> modified */
> -#define	XFS_TRANS_PERM_LOG_RES	0x04	/* xact took a
> permanent log res */
> -#define	XFS_TRANS_SYNC		0x08	/* make commit
> synchronous */
> -#define XFS_TRANS_RESERVE	0x20    /* OK to use reserved data
> blocks */
> -#define XFS_TRANS_NO_WRITECOUNT 0x40	/* do not elevate SB writecount
> */
> -#define XFS_TRANS_RES_FDBLKS	0x80	/* reserve newly freed blocks
> */
> +/* Transaction needs to be logged */
> +#define XFS_TRANS_DIRTY			(1 << 0)
> +/* Superblock is dirty and needs to be logged */
> +#define XFS_TRANS_SB_DIRTY		(1 << 1)
> +/* Transaction took a permanent log reservation */
> +#define XFS_TRANS_PERM_LOG_RES		(1 << 2)
> +/* Synchronous transaction commit needed */
> +#define XFS_TRANS_SYNC			(1 << 3)
> +/* Transaction can use reserve block pool */
> +#define XFS_TRANS_RESERVE		(1 << 4)
> +/* Transaction should avoid VFS level superblock write accounting */
> +#define XFS_TRANS_NO_WRITECOUNT		(1 << 5)
> +/* Transaction has freed blocks returned to it's reservation */
> +#define XFS_TRANS_RES_FDBLKS		(1 << 6)
> +/* Transaction contains an intent done log item */
> +#define XFS_TRANS_HAS_INTENT_DONE	(1 << 7)
> +
>  /*
>   * LOWMODE is used by the allocator to activate the lowspace
> algorithm - when
>   * free space is running low the extent allocator may choose to
> allocate an
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index ead27d40ef78..45dd03272e5d 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -255,7 +255,7 @@ xfs_trans_log_finish_bmap_update(
>  	 * 1.) releases the BUI and frees the BUD
>  	 * 2.) shuts down the filesystem
>  	 */
> -	tp->t_flags |= XFS_TRANS_DIRTY;
> +	tp->t_flags |= XFS_TRANS_DIRTY | XFS_TRANS_HAS_INTENT_DONE;
>  	set_bit(XFS_LI_DIRTY, &budp->bud_item.li_flags);
>  
>  	return error;
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index 6913db61d770..ed1229cb6807 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -381,7 +381,7 @@ xfs_trans_free_extent(
>  	 * 1.) releases the EFI and frees the EFD
>  	 * 2.) shuts down the filesystem
>  	 */
> -	tp->t_flags |= XFS_TRANS_DIRTY;
> +	tp->t_flags |= XFS_TRANS_DIRTY | XFS_TRANS_HAS_INTENT_DONE;
>  	set_bit(XFS_LI_DIRTY, &efdp->efd_item.li_flags);
>  
>  	next_extent = efdp->efd_next_extent;
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index bffde82b109c..642bcff72a71 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -260,7 +260,7 @@ xfs_trans_log_finish_refcount_update(
>  	 * 1.) releases the CUI and frees the CUD
>  	 * 2.) shuts down the filesystem
>  	 */
> -	tp->t_flags |= XFS_TRANS_DIRTY;
> +	tp->t_flags |= XFS_TRANS_DIRTY | XFS_TRANS_HAS_INTENT_DONE;
>  	set_bit(XFS_LI_DIRTY, &cudp->cud_item.li_flags);
>  
>  	return error;
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index c78e31bc84e1..4285b94465d2 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -328,7 +328,7 @@ xfs_trans_log_finish_rmap_update(
>  	 * 1.) releases the RUI and frees the RUD
>  	 * 2.) shuts down the filesystem
>  	 */
> -	tp->t_flags |= XFS_TRANS_DIRTY;
> +	tp->t_flags |= XFS_TRANS_DIRTY | XFS_TRANS_HAS_INTENT_DONE;
>  	set_bit(XFS_LI_DIRTY, &rudp->rud_item.li_flags);
>  
>  	return error;

