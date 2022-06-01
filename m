Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DE02C433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jun 2022 01:39:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348913AbiFABjX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 May 2022 21:39:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231584AbiFABjW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 May 2022 21:39:22 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E621719C4
        for <linux-xfs@vger.kernel.org>; Tue, 31 May 2022 18:39:21 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25100Ble002621;
        Wed, 1 Jun 2022 01:39:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=qp59tPFzmWrcPr4BvkUikDiqNnSLUKoyuko6mvfkY8U=;
 b=lRy84SU2Y/Gvi20I6SLqmSnuO0VlZsBZhx8Hahhuxrbqqe5BL3hCH5/HgVMVWSzCZsbc
 0y3YI8ARzPfdVEwaOq3kutm/kbrdpU43hezDIlDJaDBxspRcivUMi/y4GNRype81KVG5
 29x5cX/aOteeS2tmSQ7wQOavPsBr8G+qnhHh1chcJQqSWSQk2amV+8RJEWmRzLXvrFZk
 YHaV+wZoOvO21SLfQOX9aYDwwaFOAMo6bNvFwYsW3RzAYRIVQb2DWDewseWun0gDWxgp
 o5yN383yFN9Ca6bhFy3l0GgDiF/QyQErwNlOZFK+66m6UjY5PBNAfAo9QIRDhUkZlChB kw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gbgwm6730-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Jun 2022 01:39:19 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2511aDQ5004390;
        Wed, 1 Jun 2022 01:39:13 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2047.outbound.protection.outlook.com [104.47.51.47])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gc8hwbtn3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Jun 2022 01:39:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iEPTG3TOV2OXST3h+UG+QIlNDcHDa7PUL746WV4KNF6YnEQvmSBW2iemnga0iW8U+0x0nFfHixcey/xWEhi8+H9lruCRg8HyyqzEdhrDWfaAAP4zAxxqhSfAiDI4C8tPYKsteAs1F/fhVoUWg0Hx0s8DqQrTd4eMNsfOvhPv0JgtMOR4lBGQj70PZetzDpueRTjXv0XLtPGdGsct4oO+nMccP8AIM16hDCpu+mmng6q1782ySfNy76/LN+7F/a6txa9Epr4gg4URa4bRB6uy6hoHlVb5rn0ArZrvxxQqwOYAJuxJAkQUCkeEbrU/WrVbLqvTlLQ7p9vqwYFG8L7VZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qp59tPFzmWrcPr4BvkUikDiqNnSLUKoyuko6mvfkY8U=;
 b=CMHu89efohl95q3oBT4Pfy9QGxoBTaIuuDLbyzp5dtqGjpfupCKypbLxTjxK/9BIbp7G54AbEoNmkNEzTPOQfo9Q0pyvY4BHAluFRK69v4exMzXlmj2+pZtSxwwN3cWq3jaQpwqO0zfFJzqWZVXBoiMJ/wiGOV3tw+PSM+H5ZLWmWHUybAr3elEMrV/rBl7LBIPwa73XldtHVGs5FNMENh1oQ1z7BLMh6F5sIFGLN6UENwW3BZ9P8lqaMDc6rOP5d3onkVHtU8OybcJ0CaBfgjXVLbQS45hhZD8jKhPFXm7cEXf7pnIIray+evB6ckdARwAlOWY4AULTJBCpiAMD+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qp59tPFzmWrcPr4BvkUikDiqNnSLUKoyuko6mvfkY8U=;
 b=YHiDu/3SV1Fl4JKtGXMYEVlKsbuUnGbFF4JbJHMaWIBIrB8tHllZFJzVD8Lpdr3XKGhYfEFYArzPOHIFhrz19XuJYLEum12KsYRQ3VII3uln09uAFkbX7MWY9IVOoepK3T6EodlQezrrDD5naQ94TegN3eUNPZficRQbLQIPEUc=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SA1PR10MB5685.namprd10.prod.outlook.com (2603:10b6:806:23d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.19; Wed, 1 Jun
 2022 01:39:11 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::9de0:3300:d4c9:ec14]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::9de0:3300:d4c9:ec14%4]) with mapi id 15.20.5314.012; Wed, 1 Jun 2022
 01:39:11 +0000
Message-ID: <764c5e859d2875c1799c0fcc852f85ac705bfeee.camel@oracle.com>
Subject: Re: [PATCH v2 18/18] xfs_logprint: Add log item printing for ATTRI
 and ATTRD
From:   Alli <allison.henderson@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 May 2022 18:39:10 -0700
In-Reply-To: <20220531060321.GB1098723@dread.disaster.area>
References: <20220520190031.2198236-1-allison.henderson@oracle.com>
         <20220520190031.2198236-19-allison.henderson@oracle.com>
         <20220531060321.GB1098723@dread.disaster.area>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0338.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::13) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3cbbd65a-fcab-4a6c-f0fb-08da436f8703
X-MS-TrafficTypeDiagnostic: SA1PR10MB5685:EE_
X-Microsoft-Antispam-PRVS: <SA1PR10MB5685B7DAF87C19FBF2CF32BE95DF9@SA1PR10MB5685.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DrJlqHwGN/W7x4wf8n0r/YS1aKfPwj1Z0z+ZRq5qCM6z9r8WvPfQGV9NO1LS/1PJRODWfykOCXxJRoF0Rs+AxXwAa0QIXHJvoMzcuJHux+ZnayQX8iVxMKi1KfLha+E2/DAJMHy8GMsgMOxdy5ox52q7WG5Or2Fem0D7q3Sgdxxx8dJ5OeGPxBrZBT38GM4ZNhLBecteNKv1S7rRhr6SsGv0LnFVBBE+AdXKaKajDmwdCI8aIuemalZD8RSTA13X5xyBX7mo4NhbBqByeqspMgaoEbR3Z1Dd6wO/bGYWg9Wor1GIbZUuLf/nsOUqXfzafHVsb/b1YgqruRD8fgftE4HnrBblOJ90gjyCpZNqLFNv8aOoYvHjpcgh/RPiR6lu0aK7t/P7l5E/8CZQ6fd8/1MLmCp7UkT7+sN/ovWk40NRKd6gBG6nyGhqzHEUm1RemGfUVFZmvRjbi6w0Xs5sVkHMX3XyUmnLtVZnnQSZnGeXOJTr6mHMB4NzqATOH4YEBDpkWaUxZOMKUcf8QZfNDA88dWFzd8+H3beETGtb40uRJW9yugz5pp76Gs2xziAkmfT++EdScYPOstW9Jc69hS3e9p91kkSAiZPJ9J1qaDiDB9iCuc0qMLhRg3yYKiDYLF4orV/QXvC3CPdprxhlcsDoDqTX1daXOP8zjkD0metfJteI9NxaS/RQGbBcLi7M39K1qUZvyv7hSbrZudH8fA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8676002)(5660300002)(83380400001)(6506007)(66476007)(66556008)(38100700002)(4326008)(36756003)(66946007)(2616005)(8936002)(186003)(38350700002)(316002)(2906002)(52116002)(86362001)(6916009)(26005)(6486002)(6512007)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QkcyR2dvTDgrWUYvOFZabnYwTmNUclNOZEtueW9qV3k2dG9SK203MXBENVZp?=
 =?utf-8?B?QitrWGlCWEE1WUNFWDd0QVRJQTRTWmJ1alBqOGZvcXZqVjJhSHhCNjc2QzZr?=
 =?utf-8?B?Y2I0QWdIdUY3WVNxWDVUb2ZBeVhmMlpudXFLdWRIdHB5MnB1WHpwV0Vhem1Y?=
 =?utf-8?B?RXZYRUpaNjZ5M2NkZFR5bmgyT01wc2swbndBSW5IMUVoNlZDRTRFMzNGdHBW?=
 =?utf-8?B?SUhteU9BdmdGWVNRMU1iQ0MzV2M5MWpxUFNIVHMrc0xLU0V5a1VSc1lONGZr?=
 =?utf-8?B?VUp4WFc0VTR6T0kvVlBXSTFCT2JPU1VEQjc2TmRBK1FTaW9VWXFaYm56Q3dv?=
 =?utf-8?B?VnVRdjROQ2ZMMTBGZGZuSXEwN3BRcGdOMVludy9MV0xxMWhWME9sQUVyaXBE?=
 =?utf-8?B?bDhndDFwZVpwWHFjRStwUlIwQWRvZkgzN1E5Tys0VHRrMjhUU3lpakFQaHpL?=
 =?utf-8?B?TTB4WGxSZEI5cTZsTnhXcktiaWtxTjQwR0dBMVFxVFRlZXFRMUM0VGdhNUZv?=
 =?utf-8?B?NVNJbVdHb0orK0xBcktQdS9wTy9seTc4dFRXSkVma3JzT2VDdjZkWEs2c3dW?=
 =?utf-8?B?YURURUE1R0NsTWVaWDdVWHF0RU12clR5TDVCWldINllTVkhQZm5taEtkTHpn?=
 =?utf-8?B?bkh4K1c4Um5mYTZTeTZJNkhyK01wYXBTK0JWeHlzRFQ5RFI2UHltTTJUWkh4?=
 =?utf-8?B?ajhFUmVNQ21FcW5jLytlUEgrbVVCaHlqK0psVzV5eXYxb0xvK0JRSDh3ZVly?=
 =?utf-8?B?cUNHU0JQUkJ3YmQ1NHVTRnNYWFdsNTBua3Ewdk83QXQ5NEpGb1ZOK1kydVFv?=
 =?utf-8?B?SEJ0TnBSOTRVUWM3VVl5clFDTlRTa2dkRCtWSkxtdlhJeGpob2xKb0wwMUY5?=
 =?utf-8?B?d1BYSjZJNTB4V0p2S1NxTTdyVjJXS1Z2UW85RE9DVDlCcVRhaFpmd3lSekpQ?=
 =?utf-8?B?SkhSK2xQQW1FcWVwcFFiU1JyRHFtVHhGNXJCbDRSMkFJbTVaR05lRXlEWkU1?=
 =?utf-8?B?cG5nQ2k0aEY4Ym9oaVRmTVNOZ3ZKS1dQUWRZT1EveFl6NkJMaDZSbDUvbGpJ?=
 =?utf-8?B?MEZjaVpOWHB2aUZLOHMzNThFMWxnem0yYUpudFpCTkhlK1BqNG9vdHBNbG9F?=
 =?utf-8?B?S1F5NEtKd1I1d1ZqdmhSdDkxUTQwbHJGaVlVN2tVcUtEZWs5RDVFZ0hlWnF5?=
 =?utf-8?B?Rjg1YzlpSldkb2VDQ0ZYUFR1eHZSbVVXL2pOR3hJeXFWVHdmakZreFNzWlhq?=
 =?utf-8?B?NjF5TnAyK2pDUndCaElWMEVDUng5MFNZbUxWZHZ0Y0t1ell5Q0hrZWZLS2Mz?=
 =?utf-8?B?S1NnMUZDdjdST2I5Qjg3b3lpWkdqMk9vQXpsUnpwWFdhVWpIbU9SL3NZU0Mr?=
 =?utf-8?B?dUhGNlVBcHR4THZoNHEwUWs0UThaR2dPMVZTRFFKNUNGaE45TnRJSTRTN2RU?=
 =?utf-8?B?dEJhUmtDRzFKY3l4MzBNZGJQWU15SnJ1cDN4UDlaVytQZkpORWEvWklLR3lh?=
 =?utf-8?B?bGQwdmVabnh1Uno2dDdFbDd0WDBTV2JJMlFrWGZMdXBKeXBqdTVkcHhvQ3RG?=
 =?utf-8?B?VXpPc3ZScThzRGdiRGJIckZ6dXlyN09CZE1GUis2cmpUQ1BJeElJcmFvbi9j?=
 =?utf-8?B?a0lkZHZ4MzZUSm5BNjhFc1hFZklGemc2KzArK0V2VWNoazBaVUg0cTZMUVBq?=
 =?utf-8?B?YVBuYVNIeWk4NGxnVGNVQWFva3IyZzFoRitnenp0YnZTYWg3TCtXcUM3TVht?=
 =?utf-8?B?WG9XWjQ1Y2thUnpZb2Z0NG9FbGlNWGFBMjRqS0hmbGQxNG41TVM0Zm5hWUV2?=
 =?utf-8?B?WE1OZklCTVFWUkhCZENGYVJXYlF0WE5YUDBhdFo4c29KQW1JWlIrYU1Td3pS?=
 =?utf-8?B?NVhXZTRlSFpMVjRzWVBLN294RFFzbGJOak5STU5Xc2tYc3ZlYVprU2R6THFl?=
 =?utf-8?B?Q2U2TlExRTlKQmZjcnAxa1JmRzUxeFR6T2c1ZTBoQjc2Mmcyc0pMSndpRVlR?=
 =?utf-8?B?dDZ1MDM3blhpdTk1WmtFN2luUEtOTUJrNWFxaXlQcWV4WEFKWTBCZ21YNUVU?=
 =?utf-8?B?MmdKcVlmajE2YWEvRlZBVzdGY3FlZmtGcDV5bGJodEpNZHhIRjI3Q096NG5V?=
 =?utf-8?B?TGV2N0VhbDZDY2pMR2ZybTR0NzMvUGR3Q1k5Tmc3dVVMODhFUjFLV21ra2Nh?=
 =?utf-8?B?SGxSMVFqRGVuYVZWOG1YOStUY2JpQU1qZzdGdGtINUlxSmltOXkySmpKUDUy?=
 =?utf-8?B?dFRYVzBnYklMYW9XblREUnVhNnJFOXNmYlNHSXEyRG9hSFE0N2cxVURPNXo5?=
 =?utf-8?B?SlE3RkpVazlJbDkwQ2lKQU9HY1p1UkJxR2NvMWhuUFZ5RWsveGV4TCtBT0hJ?=
 =?utf-8?Q?gAU36LjZcmT16ME8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cbbd65a-fcab-4a6c-f0fb-08da436f8703
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2022 01:39:11.3041
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GUy2EprG+blXyfDEJj5SkZh7kmUgTxlkv2xrGK1QogaA6z+iP8Ig7CWadbfeVAgaoQMTK3wFU2NYZZ3TNW5tEVJPuuC43qG4uxv1Eesc6GI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5685
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-05-31_08:2022-05-30,2022-05-31 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206010005
X-Proofpoint-GUID: 8PAnKxw4jczgmZ9uAYHJGSueowj7QyyP
X-Proofpoint-ORIG-GUID: 8PAnKxw4jczgmZ9uAYHJGSueowj7QyyP
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 2022-05-31 at 16:03 +1000, Dave Chinner wrote:
> On Fri, May 20, 2022 at 12:00:31PM -0700, Allison Henderson wrote:
> > This patch implements a new set of log printing functions to print
> > the
> > ATTRI and ATTRD items and vectors in the log.  These will be used
> > during
> > log dump and log recover operations.
> > 
> > Though most attributes are strings, the attribute operations accept
> > any binary payload, so we should not assume them printable.  This
> > was
> > done intentionally in preparation for parent pointers.  Until
> > parent
> > pointers get here, attributes have no discernible format.  So the
> > print
> > routines are just a simple print or hex dump for now.
> > 
> > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> 
> Oh, this reminds me how much I dislike logprint, having multiple,
> very subtly different ways to print the same information in slightly
> different formats.
I did notice that, but I thought I should try and be as consistent as
possible at least for now. 

> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
Thank you!

> But this is a bug I needed to fix...
> 
> .....
> > +	if (src_f->alfi_value_len > 0) {
> > +		printf(_("\n"));
> > +		(*i)++;
> > +		head = (xlog_op_header_t *)*ptr;
> > +		xlog_print_op_header(head, *i, ptr);
> > +		error = xlog_print_trans_attri_value(ptr,
> > be32_to_cpu(head->oh_len),
> > +				src_f->alfi_value_len);
> > +	}
> 
> So this passes the length of the region and the length of the
> value. They are not the same, the value can be split across multiple
> regions as the value is split across multiple log writes. so....
> 
> > +int
> > +xlog_print_trans_attri_value(
> > +	char				**ptr,
> > +	uint				src_len,
> > +	int				value_len)
> > +{
> > +	int len = max(value_len, MAX_ATTR_VAL_PRINT);
> > +
> > +	printf(_("ATTRI:  value len:%u\n"), value_len);
> > +	print_or_dump(*ptr, len);
> 
> This dumps the value length from a buffer of src_len, overruns the
> end of the buffer and Bad Things Happen. (i.e. logprint segv's)
> 
> This should be:
> 
> 	int len = min(value_len, src_len);
> 
> So that the dump doesn't overrun the region buffer....
> 
> I'll fix it directly in my stack, I think this is the only remaining
> failure I'm seeing with my current libxfs 5.19 sync branch....

Ah, alrighty then thanks for the catch, I will wait for your updates
then.  Thx!

Allison

> 
> Cheers,
> 
> Dave.

