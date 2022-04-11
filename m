Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47158C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Apr 2022 05:22:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244705AbiDKFZH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Apr 2022 01:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230426AbiDKFZG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Apr 2022 01:25:06 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A263A2BEA
        for <linux-xfs@vger.kernel.org>; Sun, 10 Apr 2022 22:22:53 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23B33BBg031973;
        Mon, 11 Apr 2022 05:22:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Aox9tGPdipx/7RlgeXLTw0yn0Y5ErKoHJoCZZdjrARk=;
 b=qXVYTmWBCxLxf2aoeOX3IYTUutf8Mjj1r+HQYVneTkeCq18xqqYCOsbvFFXQ7Vy+cq/w
 B+QwWEdg913DS8DVOIiHGOTgQLSb49IciHxPdX36vg07FqHij+lJNZpCJ59wSL+xecHe
 vGp8laessHAd2fPA5gnvLOwuM6nvMzCPlHV9KF3GBnNSL9ThFZyuR5waxveDqP4/nR7o
 /GgkB7NDayvHczR76rc3AjJj18jzZiicLoGniyX2EzlCuiV1GtIdwpba7P17tChmkIEB
 dAeeqkZBQN6VlGf0ADWfyyAnNphVFuHpYGOR+VG7hH999kLBgaVi6v0p1w6izYKBnXvJ Og== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb0jd2cbw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 05:22:52 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23B5H9dk009991;
        Mon, 11 Apr 2022 05:22:51 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fb0k1pwv6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 05:22:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TczhhocasG1Bq6+zQgiVzVDZb37enxGFlVgXxO0qKimSYKamGnei5RJDO7XPELorJQdwT6jbyYp3VMlWCPL292mqx0+XVOmJtK1kO6sB8qivTuI1bFRlHlqGuA85Jnim0mpz9gB5k3IME4PuAPh02jGsloZTK38ojaGyNuur2TmsIBxNSKYa1C8MNtWle2rs4uj41c7twAOwKYHcBMt6mMiqj5Ac5rKmmq3ElN67OVbKqoVSEPuz59Q7QXTnolNUgrndcoZ8grP7XekKVEbireh2bbsKeitQYsJvjnndhYNPQNy/pxSq2r6oBc94C/PGApY21RvTXeNMOM1fgirvSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Aox9tGPdipx/7RlgeXLTw0yn0Y5ErKoHJoCZZdjrARk=;
 b=Z+0jx0Veqb9nO1pgeoCCMlAGkSMcKvECoVNApjtkDDdGVhf2sdAjDm39chJKT/mXZnKlQB90jbbU/PM30s6lqhy/WragsbVsqkTax2CA/DDrjbS3pRyx482YAq1E1SAEtv9iHWrtfFurnC6/dUtjhXX+GrrxYvCMgn9vW9cpSDFoJYTtvfaa3oszb57i2QCUn466ghiN9ZB26fiZmw7efg33yn7kMDbAiQNiWyX4Qu4QQhVMRhPJyFdF8L/cH8kdoOF+vw0KBXjuE8qid99vF9ZXR0Is6X6lP1QtndxJhYjqs2tdJ9C2CSLrAetGp415aXZJea5Uo5NpHF/S3v/ZfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Aox9tGPdipx/7RlgeXLTw0yn0Y5ErKoHJoCZZdjrARk=;
 b=Nkhijoglm+TSeCQCCRei/bQTJXYNRzG9E5HK1JZA1QAKWBMEex5INFtlOyWnqNw2rXXkHdd2e6q+y40pXLs5nKKy2YW4yQnF1V/+yASd3WJGyr/XX3EMvN6lcExmkE1erUYXBzMX7D51Lcn0L0qKaFwsyygP4VT5eeg7Pf1m23M=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BLAPR10MB4948.namprd10.prod.outlook.com (2603:10b6:208:307::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Mon, 11 Apr
 2022 05:22:49 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::4cac:3ab1:a828:34ca]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::4cac:3ab1:a828:34ca%4]) with mapi id 15.20.5144.029; Mon, 11 Apr 2022
 05:22:49 +0000
Message-ID: <c703d920e920dc18b0125fdb488ab22f7ff8219f.camel@oracle.com>
Subject: Re: [PATCH 2/8] xfs: don't commit the first deferred transaction
 without intents
From:   Alli <allison.henderson@oracle.com>
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Sun, 10 Apr 2022 22:22:48 -0700
In-Reply-To: <20220314220631.3093283-3-david@fromorbit.com>
References: <20220314220631.3093283-1-david@fromorbit.com>
         <20220314220631.3093283-3-david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0207.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::32) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2fe60fdf-0c88-4a1a-a4b9-08da1b7b51c0
X-MS-TrafficTypeDiagnostic: BLAPR10MB4948:EE_
X-Microsoft-Antispam-PRVS: <BLAPR10MB494845AEC266EFFCC688CC0795EA9@BLAPR10MB4948.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NhFRxIsEyD9NO2K/+UtTMB0FG9JI76venEjQbtZjJc6UHb23rjZHrWzVQ7aAPYK9N55nTKW0R/4zVU9JvTMUrkpiPhn4X9sEX1+NVypSh0lpIiduzwiCp7df+NgNHcXS+JyVxZsrv4zNyMe9ORPquLP1tAum3eQY8zAVIKaCaj5aYCrGW1PzZ4who6UrBmpkdkpBXV+464dQEZQmL0eKD671lAB5U6aTErihKMJCP+BcO65SqM9ZzQ6wwBo5uWOaZP+k41O9Cdkd4jBLXf72xCC+fERXg+gifdkenXtFTlf16u3NdaeO+RfecSc/N/cF7lI+27b26M1CXKem4JQFq5J9F1AqcK+1b0DHJTIlyo/absgEKjqDcjPtAdbCYoe/sykFgrPRyUwOp07zVe2rsTfHlpUnWZVXIVfPhtUL+SqLhe1LsaMKtKEQr3d2BiSqA3NdE+lkaa5qQYxa3eCEtNBEeNUzTJYaaBl2C7UQY8xfnhkPLTQHm5aFlOVyjD8Equ/CMsjMDYXRJbPqOVEco3B2/0UTD1gdpuCPd5wefrrBMPMPnZLdiObhhNW9v2lDEJBtXZllcojKWXBzzfp9sidWuZxKEV2wFBjfinXNmGmuoN5e58WNntPwWrM48+9G5tlLnjVOT32L8gfCwIt2KNqd2wevOZgnICQTpqvNb3nDuQguypHnMsi8G7O4XTc9x/QFn3M8XF8+pXPRCD9dMTEHMDOpLoV27m+rPFvyi7BOfVyzuMObmBAU7rWKBtnMreaETHO9z5bN4Cj1fHpzDAo9aJk7jcmwYnJJovoWipi0sv32ECI3v51rEC+dq6cMnq1whB3WOgIOJK3FgKtd1A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(86362001)(38350700002)(38100700002)(2906002)(316002)(5660300002)(6512007)(66476007)(26005)(52116002)(6506007)(966005)(2616005)(186003)(36756003)(508600001)(6486002)(66556008)(66946007)(8676002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bDhtR1RzQll0UndYY2F3OUppaWFpRk9yaWpWODlWc0FtVjY1amVqNUpTU1E1?=
 =?utf-8?B?UTJlWHgyQnpsNEplUkU3VW45anhSYlZaOE1vQkJkK09ENE9UWTZCeUJKd04w?=
 =?utf-8?B?V3NJSzZ0OFdTditCQnpyTDF2ekhNMDRacmF4aWc5SlRObmt6QUJrcXdGTVY5?=
 =?utf-8?B?NTB6UWdZTTNjQ2I2a1dIVWVXRk40a2JnS2ZjUlhHckZKbUEzVHBCb0NYSTRq?=
 =?utf-8?B?VkUzdXh5UG1BRGsvUWd4QTJvYS81eFFNS1ZZdk1IZndqWVVrbS9OTTdWRGNX?=
 =?utf-8?B?VEVkckdkQU9jaUZoYWpvU2xVK0I0bXZrRzVBa2tmQmVyZ2FuR2FSSkpVS3Nn?=
 =?utf-8?B?bE9mQ2RCdTBtTDMxb1BkTWI4QlZTbmxuand2ZUJuQ3ZyMEh2Y1hJbTVrS0x6?=
 =?utf-8?B?OU9qZzdJZUt1QnZGRER2WW5JREg1dlF6UXkwd0drdFZBZVQwZUNFN0p1Nm5L?=
 =?utf-8?B?R3NCYzRJaTR5c1h1djZtK3hRcExFK1BiWjJ0Nk4rWmVibFNOM1Y1N2pNaTVj?=
 =?utf-8?B?cWZmcnZXRlFocVNGdE8wVnFDWkVZam9Ua2xmQzF2TmdoNnZBVHpqNGcvOFR2?=
 =?utf-8?B?aEpSWG5iZUl2Zk9DVVQ2bHdoMk42QTArNE4vaDhmWDdBbEs1WXRsSE5ua1Q0?=
 =?utf-8?B?YnE2OC9kWkNmb1RjRmZiTndXc0p1T1FpMVk4ekN3UVRRUWxJMlh0cjN6K2Zj?=
 =?utf-8?B?RGVMWnhjNGcvNDBrQU9GUEZOSUd6T09DOEg1WnhHa3ZNeTV1Qit6QkVXYksy?=
 =?utf-8?B?OURqMk9FT0ViMHdVWWdNNXVoWlFMWEdrdmh5VmhWNjZCYXNDTU1jUU13T2cw?=
 =?utf-8?B?N2lEWkNEQ1FzM3hHeWZlSDcyRDQvdWU0dXJTMmx4ZkVFbGtaS2IydldRdXRk?=
 =?utf-8?B?YzhIVEVrVitsMlpsRDhJRmZ2V2dHYWNYL3h5TkQ4dXVxSjVsNjYyMUdnVlJ0?=
 =?utf-8?B?UGJMTEtnaS9DaUpLSmprME9QREZkbm9XU3NGUjNUZUlZSjVURmtlWWFKbUtX?=
 =?utf-8?B?K2tUQWJyYzV4TXNQRVJpcTdUWldhOUxqWVMvN1lwcU1rTm1IbTlLQmU3aVlV?=
 =?utf-8?B?N2tOb25SYW9TZEcwWFk2RUovcmtDMHBjaVVVc3ZWaG4vMEFVck5jckR3c1JL?=
 =?utf-8?B?UDhCbWVrcUROZGNYVWJSbTZvSytpN3V0eU5LeFhuREZJQ2xqUFI2QzY5Y0x0?=
 =?utf-8?B?WUZZM01KcjlEOGlwRGNzcEc2MVBuUU5MRVpwZVlzZ1VXb1l2TkVvcmx5ekNl?=
 =?utf-8?B?VXgrNURBaGpJNkRxMmNzZE80TUdkcjczOE5KRTVqMGtUNThNWXFIS2QrLytN?=
 =?utf-8?B?bkk3UE5iOXpxOGI2aklvVmVOQ3ZqMDhKSS9HUGZjUjg2QWMyb0RYbGE4eldo?=
 =?utf-8?B?K1VlU1pnR3d4ZmhPT1NWdU1neG5IMTVBMjNJSDZSRHZpbEIwOFJYTXRGcXdl?=
 =?utf-8?B?Wm95elE4cDZ3OXNIQzRmMXhHaXVEbGdaaUtabkVkVEZoV2VneFNWSm15Z09T?=
 =?utf-8?B?VlU1VGNMb08wT09Ic2xiczBMa3ljZG13QzVic2RZeVFVamEybytqUkNCM2RD?=
 =?utf-8?B?OUozOGs5d3FrcnBkeDVOYjNvb2xMWm1hb2NSWnpxUWhpSzRsUUltcjIxTGY1?=
 =?utf-8?B?M2JqS3JkcThwVDhwYUdzeUkvdUpvRGFEbTBWUmROMnVhdWtnTk9vU0RPQUtH?=
 =?utf-8?B?Q3VsY2hRMC9ZVW1hem9TejRDQUxDdmJibzhFVXpGNkhkOU41TzF5TkJnSFpi?=
 =?utf-8?B?a3N6ZW1zTGJmTE9RVWxVQmVBUWhsVGE0YmF5SmdiSjVJKzBzZGZJdmxOTXpS?=
 =?utf-8?B?SVNSaktQdU9qVE1HbmFQSFZuVytrWFpkZmFWNlY5T2lvZVRPSlowQTRWdDB6?=
 =?utf-8?B?NjYyVjJ0c0lnYmdYeS9RQnFWRHRPOGJ0MlJzNzR4eWdhUXJTNGdmWnJRMUw1?=
 =?utf-8?B?bzlhakhLS1RtZCt1SnJzeis1UkhDUTUzMDBkd3YvQ1I2SzdZQ0w2U1pKYzZN?=
 =?utf-8?B?YjVlSlJJQW5WMFAxSUJjTGhGekFLLy9BUkhHZEgvV3YyK0tJOWViWGNNZ051?=
 =?utf-8?B?bUVyNHozMzBTeG1ZaFYyYzNRd0NuWlhmcnZkd0h6U08ybFlGd3duQUdMaEVX?=
 =?utf-8?B?bVg0SUltRkJSQ1kyZjJpQ0VuTjNybk9RSExiTndYUXUwOUFkR2orcnhGSG8y?=
 =?utf-8?B?aWJ3bEhLMkl6RUV4VXgwVVNsdEVpdjVvYWVLdWhyam5QeThWMWtlSWd1MGYv?=
 =?utf-8?B?TGRzeUN0cUNUUlVCTUwwOE9sejdGbTRBT3Y5cjM4b3o2TjdOV2d5dmFkdU1I?=
 =?utf-8?B?V3BDS3kyTU5DeS9IUUhOaGkrVDhzbGo2eVlEL1hrY2kvYitrdjU2UHcwSFhw?=
 =?utf-8?Q?TV4/eXvpTi1Nn2bY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fe60fdf-0c88-4a1a-a4b9-08da1b7b51c0
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2022 05:22:49.4103
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0CMFnMj9JXQ8pPaXSfRC7lzXHZVdFSWhtjsEUKudYcqDqzW5/nx2WPj6y84li7q2KHpx+j7tl+TRJMjWFufwhLBUr8U8/g9xXjl83+1hcUA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4948
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-11_01:2022-04-08,2022-04-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 adultscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204110030
X-Proofpoint-ORIG-GUID: NfibqIj4Cwwwaeae8M8GrCS0IfVtYblv
X-Proofpoint-GUID: NfibqIj4Cwwwaeae8M8GrCS0IfVtYblv
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 2022-03-15 at 09:06 +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> If the first operation in a string of defer ops has no intents,
> then there is no reason to commit it before running the first call
> to xfs_defer_finish_one(). This allows the defer ops to be used
> effectively for non-intent based operations without requiring an
> unnecessary extra transaction commit when first called.
> 
> This fixes a regression in per-attribute modification transaction
> count when delayed attributes are not being used.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

I recall some time ago, you had given me this patch, and I added it to
the delayed attribute series series.  The reviews created a slightly
more simplified version of this, so if you are ok with how that one
turned out, you can just omit this patch from the white out series.  Or
if you prefer to keep it with this set, you can just adopt the second
patch of the larp series, and I can omit it from there.  Either was
should be fine I think?

Here are the reviews for this patch:
v25
https://lore.kernel.org/all/20211117041343.3050202-3-allison.henderson@oracle.com/
v26
https://lore.kernel.org/all/20220124052708.580016-3-allison.henderson@oracle.com/
v27
https://lore.kernel.org/all/20220216013713.1191082-3-allison.henderson@oracle.com/
v28
https://lore.kernel.org/all/20220228195147.1913281-3-allison.henderson@oracle.com/

Allison

> ---
>  fs/xfs/libxfs/xfs_defer.c | 29 +++++++++++++++++------------
>  1 file changed, 17 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 0805ade2d300..66b4555bda8e 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -186,7 +186,7 @@ static const struct xfs_defer_op_type
> *defer_op_types[] = {
>  	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	= &xfs_agfl_free_defer_type,
>  };
>  
> -static void
> +static bool
>  xfs_defer_create_intent(
>  	struct xfs_trans		*tp,
>  	struct xfs_defer_pending	*dfp,
> @@ -197,6 +197,7 @@ xfs_defer_create_intent(
>  	if (!dfp->dfp_intent)
>  		dfp->dfp_intent = ops->create_intent(tp, &dfp-
> >dfp_work,
>  						     dfp->dfp_count,
> sort);
> +	return dfp->dfp_intent;
>  }
>  
>  /*
> @@ -204,16 +205,18 @@ xfs_defer_create_intent(
>   * associated extents, then add the entire intake list to the end of
>   * the pending list.
>   */
> -STATIC void
> +static bool
>  xfs_defer_create_intents(
>  	struct xfs_trans		*tp)
>  {
>  	struct xfs_defer_pending	*dfp;
> +	bool				ret = false;
>  
>  	list_for_each_entry(dfp, &tp->t_dfops, dfp_list) {
>  		trace_xfs_defer_create_intent(tp->t_mountp, dfp);
> -		xfs_defer_create_intent(tp, dfp, true);
> +		ret |= xfs_defer_create_intent(tp, dfp, true);
>  	}
> +	return ret;
>  }
>  
>  /* Abort all the intents that were committed. */
> @@ -487,7 +490,7 @@ int
>  xfs_defer_finish_noroll(
>  	struct xfs_trans		**tp)
>  {
> -	struct xfs_defer_pending	*dfp;
> +	struct xfs_defer_pending	*dfp = NULL;
>  	int				error = 0;
>  	LIST_HEAD(dop_pending);
>  
> @@ -506,17 +509,19 @@ xfs_defer_finish_noroll(
>  		 * of time that any one intent item can stick around in
> memory,
>  		 * pinning the log tail.
>  		 */
> -		xfs_defer_create_intents(*tp);
> +		bool has_intents = xfs_defer_create_intents(*tp);
>  		list_splice_init(&(*tp)->t_dfops, &dop_pending);
>  
> -		error = xfs_defer_trans_roll(tp);
> -		if (error)
> -			goto out_shutdown;
> +		if (has_intents || dfp) {
> +			error = xfs_defer_trans_roll(tp);
> +			if (error)
> +				goto out_shutdown;
>  
> -		/* Possibly relog intent items to keep the log moving.
> */
> -		error = xfs_defer_relog(tp, &dop_pending);
> -		if (error)
> -			goto out_shutdown;
> +			/* Possibly relog intent items to keep the log
> moving. */
> +			error = xfs_defer_relog(tp, &dop_pending);
> +			if (error)
> +				goto out_shutdown;
> +		}
>  
>  		dfp = list_first_entry(&dop_pending, struct
> xfs_defer_pending,
>  				       dfp_list);

