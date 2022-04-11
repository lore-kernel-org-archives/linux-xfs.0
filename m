Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 590F3C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Apr 2022 05:22:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244412AbiDKFY2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Apr 2022 01:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230426AbiDKFY1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Apr 2022 01:24:27 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F9E82BEA
        for <linux-xfs@vger.kernel.org>; Sun, 10 Apr 2022 22:22:14 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23B2wEo6008564;
        Mon, 11 Apr 2022 05:22:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=brSLP/gwu78VDpdTnWhxHEAAY1I2AcU9EPeATW0CRuI=;
 b=HDzq2msyvROhtQBGavd7KDMD4UIsn9Sq7nwen8lX4Uh+YkN4a39XFizFLOH8BdPaKeOQ
 Fi73gMaLYQWU7Od5Sw26wDG+Gj1ZxHtr+FpaoCYjDoDIItxYCmdnVFO+Q8cCbVOinsFH
 VNrxsL5J+bAQPPRNG4twt64d3Oqh137etGXkqDtFSPorBZwdixy63YXik97QJPXYLVcQ
 Se2tYMP9fgvKANUiEGNAnx9gxRAhI/nE45Y3ZV23a9V8fT5KDJZKg5j3TLGHs9Ljak0d
 GWwrsT5wXl/W+rSAaSB3vnPMcq1zLPwGiF/AO6Wgx8xk0km/ke3x75nCgsF8ieLBNRs0 vQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb0x2acbv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 05:22:12 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23B5H1i9016287;
        Mon, 11 Apr 2022 05:22:12 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fb0k1cbcp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 05:22:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jMewNxnvrj6b4WEn4PD0pxqznS2JuIrZujvnYVjfCB19i8k9Hdde6Oehh8P+KhNI2nS0JqSp+6zXuYxWywxaD876jVJHmv3LPpEJWtUZ87isMiJ+TVGQONYgDyjfEFRIvObenkyKyNoRWv0Yq2vt23fDBVzpQdMXOOjxgGjWx/JiBXthSWGAHRCUsVLlSTFRU3RtdqR3a1YKxQRRVh59JeuCs5iW3EFQ8t8uC7XlpHfP7Ak5Ntyp18zf0q4gWZbHNdr0Eb4dp8ZmjMc3F1vqkwR1DGcrhopvOiKgk4StB/l2XUeZ0nVNuwwBa+zhgLK2M66/x2G4aBUauAc6CQAkyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=brSLP/gwu78VDpdTnWhxHEAAY1I2AcU9EPeATW0CRuI=;
 b=KDwTskxDg9Y341CJRKDELRr7mc2W/meg5B4dkkdeZ5BPBep+dfKdslwMkFMwHHYDqe8iiBOkhaFeiSeu3y2xtvS13//YpY+COIh03J9AlUwhBGtxmieCh9ASN8l88zLsrPwuDMDcT7Xo/ddsDE9XCJGvIrukPL990rPpewVrSMJ8dLW6LDABtDFN808jK2Za+c/XJeFAFx6D5fLJ/Q0f9HeDxat8pBRYYGx9vEaWJSo++epDbOOQT+iUwB/6xjAcJMUQ7sb8HOGvbYA1Hjczk/jOPYFNetxaXjn4SeLiP0FNCOazkdFQc3LN2jK91XTRUnSp0SjXvh7Zej5urp3UmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=brSLP/gwu78VDpdTnWhxHEAAY1I2AcU9EPeATW0CRuI=;
 b=U7eAuMrlrEEthqO22i+xYHCOpXUW+gYkdbb5UhZkbLPyFFiNXmBTZSYp0omreoXJmRYuUr9STwgFX7PdcS/sABOcRcN0WVWTZmQPMUaYBtaUCd9TGdpn9n/u8gDGPbwrtCPx4HOT6DsqwuDlNplX9LVCOqrOD7gVvLqF3dGbubw=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BLAPR10MB4948.namprd10.prod.outlook.com (2603:10b6:208:307::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Mon, 11 Apr
 2022 05:22:10 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::4cac:3ab1:a828:34ca]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::4cac:3ab1:a828:34ca%4]) with mapi id 15.20.5144.029; Mon, 11 Apr 2022
 05:22:10 +0000
Message-ID: <bb20d2cd0be129f9591febe2570a6b7016d269a2.camel@oracle.com>
Subject: Re: [PATCH 0/8 v3] xfs: intent whiteouts
From:   Alli <allison.henderson@oracle.com>
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Sun, 10 Apr 2022 22:22:07 -0700
In-Reply-To: <20220314220631.3093283-1-david@fromorbit.com>
References: <20220314220631.3093283-1-david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR08CA0059.namprd08.prod.outlook.com
 (2603:10b6:a03:117::36) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a542a7a-14f0-46c7-57a1-08da1b7b3a3d
X-MS-TrafficTypeDiagnostic: BLAPR10MB4948:EE_
X-Microsoft-Antispam-PRVS: <BLAPR10MB4948EB872079482DB9227B2095EA9@BLAPR10MB4948.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G3jrsrPfINVgVO7xGMZj39NbWY/EkY2bGPYvNDJI29+eiuLYvVGqJHiJflkRokXgeLcbnvJq5EpOI6gM7uU0Z/Xfb+c8f5RkzC1pxKvvpxF5AQSaMtDpznH83JhcThQdexzatW3Us3uPLGIgvZD7//FFOoUg6sSxuBLPoshe0JEXWLmPQcEZ/LgB3EPtTsMm8F8g+K4BqR4oSA50oz9hXExVTvR6+QZNsGhIUsKVPq/DRr8jV0c8dVLp3D0NKGJY+a5h4f1WkTED/NSUgBZngCoA4dgdu3R6hGVnfDgunZUqpsYVPDt/u5+5iK5UsGL5+A5PEQiob1+1OF4TPpgs+NimTczjYpFkAheyXfAxHXxqGZSgICo7rtUFdY0xl6tBDQOF6VjT5ZfmVhyZAJDUulsWmN0MHD78fLvrglcir6y13U+Gd0l3Jee+JsBo7wLSUR8y6RvJq6lnM9E5DbSjFGmavxK7wnSNvwyDGXmAg7iWW9xypq1EwIrZ5PDyC6TPkl7Rnpl9WlesPRV7lJawAXCvtTKOUznpEHiLSWYUHaQv0mdLOjAEFXp7jtkyCNBPPop6eIMy/wot1Y+tP5tO4B/rwL24GvKVTj95L1jrgW6lMAtmeavYwT6T+261DImbk6V5qCpk+E90ridSLQeDkc3vSIDyXkmAcMPq/DpR66lANSecJsD0IwnjNWRBZsfIgGeVeJT0e9zkVKEz4BDOY2xzuMuXPcX7BPTf1rhfV4wLprPFYcHbR/2Gt4sXMGpePsGc8xoLoJgLxpXClQGWgycLzkRs4IL9V8MwfeLEqD0JOjVIao+h9wEPi5NCdK9k+Ngjz+Z96w4NBG353TxIuA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(86362001)(38350700002)(38100700002)(2906002)(316002)(5660300002)(6512007)(66476007)(26005)(52116002)(6506007)(966005)(6666004)(2616005)(186003)(36756003)(508600001)(6486002)(66556008)(66946007)(8676002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Tkh0U3pMUFY2YXRISjhRbXJDMko1TGI5ay93cHhQV0wzejM1aFE0d2dCMkNG?=
 =?utf-8?B?ZnNWRFRJWHE3THhUZ2k0WXBGVHhJcWlySXJXVEoyTVJhTlNaRXZ3UWdCZ3ZP?=
 =?utf-8?B?T2szaUpMb3M4UWF5ZUNQNnZOVTRleWpkWHJ5UmJqek5JQzBYQk1wOHRDYWVG?=
 =?utf-8?B?d3ZMdzBCNGdYSFhabElkVHo5bXcxbThVNUdHb1htM0E2SCtBM0VLcWMyajdi?=
 =?utf-8?B?a2dWZXVhYUJwQkVVNnF0YXJYdHRicWR2WHFldC9ta1FTVlJCc2JjUVpqWmU5?=
 =?utf-8?B?aGJJUTN5c3Z3Vk5NWEJkY1pRV0tYVXdvTkFabGI3a3JURVA3T0xpUUpyWUY0?=
 =?utf-8?B?b2VDZjVVeE9IWW1Ob2RTb0FnZHhFd2thTkhQTFZESjJjeVA5Z3ZKSEFza3A1?=
 =?utf-8?B?QXM3MlIyeGF2TzZpdklYZVZBa1Rra1JJcFkwMG1xRlF0UEFTbGt1OVF6Uy9y?=
 =?utf-8?B?dTViTnFuS1FJMExIRVVyd3FQcWlGMk1Rb1Bja2pzdDkzRVkvdEhCVGVvNmhV?=
 =?utf-8?B?NmJuRUdZRmF2VEpvQ1FJT0xOdDRKWVJzQTBKUy9VM0EyM2FaV2ZGS09IV3A1?=
 =?utf-8?B?M001enVyWi94c0N6dXlEci8xV25mN1o3SkhGa1M4a2svS3V4K1I0enRBSHVY?=
 =?utf-8?B?Y1FoQ0xYdkY5REp3VG8xQ01Ga2pmVUZuMHB3bWRFSExRQXcwWUM2YUdRMFA1?=
 =?utf-8?B?N1VGbUdURXdkRmNiUXAxMzZsZWFQMkVOVFNOR0RiYTVCYjhEZk1CWkErZzVz?=
 =?utf-8?B?YS9lcXdseXBRNzVwU2EzcDJGSFRTNGo5TDhieGljbnJWNHAvR2dWdWVRc201?=
 =?utf-8?B?emI5ZVlHT0lqVmw4T2xMWmxVNEdVbnFqdHA4L1lVQlZmdjVLSGNUUVlaUERN?=
 =?utf-8?B?SXZ0Vm0yY3YrdXFSUzg4bDFLS2NNUFc3RTBFN09EbllGbEk1Y09FZnZ0RUli?=
 =?utf-8?B?bzZZRTVVR2VKNnU4cUl1OXBjRzVyRS9LaWh0MDdqZ0JobHFnWXl3cUN4SkF1?=
 =?utf-8?B?MzEzSWU1enJhSDk5ZHVabDB1OHEyTXZXMjFmdGwraFdLcCtuVVdJamhCUUpZ?=
 =?utf-8?B?VFhGa2lwYnNHeWRweHNJRHExc1RPUnRiSkRtT0kzbllyZGd5UzZsWkYvTU93?=
 =?utf-8?B?eEsrSEl3RjQ0cmNqTkpsbTQzTGkzVTdpY3liVmhzZVpyaENPd29ad0FVc2h4?=
 =?utf-8?B?ZUtvTDV3VWJNSEtnZ2pNWHBDNi8zV2hmSEFTNStuVTdyVS9xL1YwajU0eXBD?=
 =?utf-8?B?NzRhSmlESDRwR3lXNXB5b0dFd3dKd01SMVhkQ1VBRjdWdUFIQ2ZzbzU1T1ZR?=
 =?utf-8?B?UVFxT2pQWXF0YkhSZm9EdmRVQjZ1aklNMytGSEYvSmNXeXg1dW5LUVFzZENj?=
 =?utf-8?B?anp1aWIrekhlSVdFYXArdGpwQTQ5NXdCWlZIU1ljaW5MbEQ2MkRlR2JkanFk?=
 =?utf-8?B?ckY2VVFmc1UwREc0b3NrZGNRcEVSb0FQUmd6U090b0kyNTQ0bDNDTngyaFJt?=
 =?utf-8?B?Tm5yQkF3TXdCWFhuaEZjTEJrWDBpUDZ4VEJEWlZ4M0g0Y2ZadklqRUhWZUtM?=
 =?utf-8?B?Z2FqbmYxamxvS1ByT2svVWNrdG5zQTlybVVlRk1JU1dtUlU5UVcyK1M0RnZa?=
 =?utf-8?B?U0FxUzRMNU56Z2RwZXB1TWdWWFZzTlpVeGJTd3hsRkRkTjFoNnpLVWRGcklL?=
 =?utf-8?B?WGNCWlZjZ2l5QTQzTktlN2FUV3VlbG01SjJhVmxPSmkwNGFIekpXVmxKdnRy?=
 =?utf-8?B?Tm5ESU13SWNVZUV5bWtVNFlLQ3RVT3F6cG1kcS91VDgyNFBEeE1FZS9XUTFY?=
 =?utf-8?B?SUhUSy9kbERWV1NwTzhLalF3UE9ub2lxTDJqUXdsTVg3L1U3ZmRaaG1QODdq?=
 =?utf-8?B?ZVRKQjJOTkp6NE9tUXdsSkNSc0xlU0hETWJnRm1tTkYyVTRYMDhkV09ybllz?=
 =?utf-8?B?OWcvTHU5eGRBeEthY0VWdjlTOEM3V2d2UkJ3L3dndy9sY2dINmFYdWpHSFgr?=
 =?utf-8?B?WHhNbW51M2VyTzdCOHkzblZGSUY1YmpOMmlGZVZZaFFDN3NyZFhCUkcyWVNZ?=
 =?utf-8?B?cGdTc2o1VzlPL1RGUEhLZksrdTJJMUZRSHh1cHhYT2g4SDJya1ViZDF3VStR?=
 =?utf-8?B?OHRKZHdDZERQTzFhQ1UrQUF1dCtjcFJFeGtIenRkcDNsSnA5R2JGTGhXdXZh?=
 =?utf-8?B?cE5INjJTeEQrTDN1VFBFaEYxYW50YkhVZ1lCdUY3U2VRUS81SzRic054TldE?=
 =?utf-8?B?dnJwWGxTbWR4UjZFRzVGbW1UL3RFTG5JMm1IaG80TFBseEdYUEdDd0cvb1ZG?=
 =?utf-8?B?WUovMlc4WWlTK2NodzF6SmJIMjBwYTB4TTdIZ2xtclFkWkVlaTY5cjIzeVBQ?=
 =?utf-8?Q?MEEfEDWxs8oJ2Meo=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a542a7a-14f0-46c7-57a1-08da1b7b3a3d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2022 05:22:09.9790
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jfI9fK6iYf1LBHpQJya5gH9I68HwjboyYw3bzzypvjWIZvRxdqdfCE10EkkBrxhUy++FsaSx8ezUB3ySu85xcgctvkA7+cKzoE9hVBmrth4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4948
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-11_01:2022-04-08,2022-04-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204110030
X-Proofpoint-ORIG-GUID: _fCMCmc86CWe33fmm3mMHcgntK39fXH9
X-Proofpoint-GUID: _fCMCmc86CWe33fmm3mMHcgntK39fXH9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 2022-03-15 at 09:06 +1100, Dave Chinner wrote:
> This is a patchset inspired by the performance regressions that were
> seen from logging 64k xattrs with Allison's delayed attribute
> patchset and trying to work out how to minimise the impact of
> logging xattrs. Most of that is explained in the "xfs: intent item
> whiteouts" patch, so I won't repeat it here.
> 
> The whiteouts massively reduce the journal write overhead of logging
> xattrs - with this patchset I've reduced 2.5GB/s of log traffic (16
> way file create w/64k xattr workload) down to approximately 220MB of
> log traffic, and performance has increased from 9k creates/s to 36k
> creates/s. The workload still writes to disk at 2.5GB/s, but that's
> what writing 35k x 64k xattrs to disk does.
> 
> This is still short of the non-logged attribute mechanism, which
> runs at 40-45k creates a second and 3.5-4GB/s to disk, but it brings
> logged attrs to within roughly 5-15% of non-logged attrs across the
> full range of attribute sizes.
> 
> So, while this patchset was clearly insired and has major positive
> impact on Allison's delayed attribute work, it also applies
> generically to all other intent/intent done pairs that already
> exist. Hence I've created this patchset as a stand-alone patchset
> that isn't dependent on the delayed attributes being committed, nor
> does the delayed attribute patchset need this to function properly.
> IOWs, they can be merged in parallel and then the attribute log item
> implementation be updated to support whiteouts after the fact.
> 
> This patchset is separate to the attr code, though, because
> intent whiteouts are not specific to the attr code. They are a
> generic mechanism that can be applied to all the intent/intent done
> item pairs we already have. This patch set modifies all those
> intents to use whiteouts, and so there is benefits from the patch
> set for all operations that use these intents.
> 
> With respect to the delayed attribute patchset, it can be merged
> without whiteout support and still work correctly with/without this
> patchset in place. Once both intent whiteouts and delayed attrs are
> merged, we can add whiteout support to delayed attributes with only
> a few lines of extra code.
> 
I applied this set to the for-next tag:
01728b44ef1b (tag: xfs-5.18-merge-2), and ran into a few merge
conflicts.  I just went through and fixed them to try and get things
working, but I'm getting some failed assert checks on generic/466:

[  155.219780] XFS: Assertion failed: reg->i_len % sizeof(int32_t) ==
0, file: fs/xfs/xfs_log.c, line: 2536

So maybe still some bugglies to work out.  I'll go over the conflicts
in the review.  Also, I'll push out the branch I have so far. Since
I've already gone through the rebase effort, I may as well share it:
https://github.com/allisonhenderson/xfs_work/tree/whiteouts

Allison

> Changelog:
> 
> Version 3:
> - rebased on 5.17-rc4 + xlog-write-rework
> - no longer dependent on xfs-cil-scalability, so there's some porting
> changes
>   that was needed to remove all the per-cpu CIL dependencies.
> 
> Version 2:
> - not published
> - rebased on 5.15-rc2 + xfs-cil-scalability
> - dropped the kvmalloc changes for CIL shadow buffers as that's a
>   separate perf problem and not something related to intent
>   whiteouts.
> - dropped all the delayed attribute modifications so that the
>   patchset is not dependent on Allison's dev tree.
> - Thanks to Allison for an initial quick review pass - I haven't
>   included those RVB tags because every patch in the series has
>   changed since the original RFC posting.
> 
> RFC:
> - 
> https://lore.kernel.org/linux-xfs/20210909212133.GE2361455@dread.disaster.area/
> 

