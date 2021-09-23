Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9337BC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Sep 2021 08:47:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6983461152
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Sep 2021 08:47:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239986AbhIWItU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Sep 2021 04:49:20 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:31518 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239985AbhIWItU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Sep 2021 04:49:20 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18N8lNJa002809;
        Thu, 23 Sep 2021 08:47:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=MMpc80evOU72OSNHnTBP661z364bFEuo+2GfKykRIyA=;
 b=ft1vxFaqSJ6sJJ7TXbrK5TW7ZP4F3jD9apDqFx5lY90vkBgNznssf9Z2CVf4A43Kw7Ra
 fW05NiBFmUl4LQjena8hZSdu/H+Q310PpDvMEoWv0Hvdhme5vNjXL379d0Z9S1ebMi0Q
 l8mxxjPih1ZMwpPN/PSi3cGbaOhTNQkGX0jPtf6Y20Yea3RBLbNXkh3bN6lKPDAjlrPv
 Z7Ey2y8obUPc7xQ98K/YT/GGiifXuIdhqgkCQRjLb1fgsagFEnKv8rHZEBQySpnhlly5
 URW8owncAP0IjwWUy51qvqbKqhKQXogvlAmp8zmPGQZcczi3SU1XIpVv3KBDJegWRGJI Qg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b8n2v0exd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Sep 2021 08:47:47 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18N8esJe170791;
        Thu, 23 Sep 2021 08:47:46 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by aserp3020.oracle.com with ESMTP id 3b7q5bvuxx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Sep 2021 08:47:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yao3S0uavGsi5TLyqjbGIJb8/7KrbQKUjAN15SquHQfcDqs821kqP5GvrTpvmst0jktj2NT4Th0GMxbM0eMHWFataD7I+3k992eXRNWZIKwyvtHgsMw84H41rvZphDkotMd5LKY9nOQga0jmb6PNBWa8EbyanP4crCl9FUrNd4CnR7l+Vohbt9LVNWxUlnbz61EmX+V3ZnS49T7bfIf7idzWR0OnAm/sO6oZG02P14W0UbWVWRCtqmQvV1/dinVyx7I4osoGD1UAwyI9yv2ws7RNk8boEsM2nR7XIn0gdc8uQn4T84s+M1afqVS+OsY34/ybQ1eTmCEvw82v6TG78Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=MMpc80evOU72OSNHnTBP661z364bFEuo+2GfKykRIyA=;
 b=BKQGvNYkmP1VPLCWZRx3Ot6LSReQbD4JxRWWf9ZDdtVhRCXaibdvZW48vLiW7XV+Q/cC09vCkkPm5yPcP1Z5Sn386SRP4jzEjx7J8TfZo1GTfvcSiAoobJQgNicmV3Aft9ychkQP9Hz8m7SA1HPYAnZOz8UjbcuIZpgfQGSSOoxZIb1vuf9OuCabGro6Jur75oNu/LFG5xr8ekKhWRsXmzKN+R7TIv8ux1veHACU4TuQlW/BvKTIh8eTX/gMj49il08az9mtiiBgOKMMlBnR+OivVYw84s150T9+zwCqa7NVxZeXgsReAhoJE+1hSQ83xpU/mMsUK95QU+LbN9HLcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MMpc80evOU72OSNHnTBP661z364bFEuo+2GfKykRIyA=;
 b=fuKivMWBw+H11+5QI5gjpKmQr4wbRKosQ8oGadSmxlHe3OAjBNRSZ3+SqCAEm1KS1bjk9nc3A08KFm9aQSLDTtfackq/n8L42GUq4N7okqtMbK/KCb19HXqSHyOcuNqqKii2gir5u6W/gNZSF7yFBQfZ0Lt5pTF+Hkb11f3H9eo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN4PR10MB5656.namprd10.prod.outlook.com (2603:10b6:806:20f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Thu, 23 Sep
 2021 08:47:45 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%8]) with mapi id 15.20.4544.015; Thu, 23 Sep 2021
 08:47:44 +0000
References: <20210916013707.GQ2361455@dread.disaster.area>
 <20210916014649.1835564-1-david@fromorbit.com>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [External] : [PATCH 0/5] xfsprogs: generic serialisation
 primitives
In-reply-to: <20210916014649.1835564-1-david@fromorbit.com>
Message-ID: <875yurllui.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Thu, 23 Sep 2021 14:17:33 +0530
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0102.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:1::18) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from nandi (122.179.108.138) by MA1PR01CA0102.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:1::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Thu, 23 Sep 2021 08:47:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cc941f51-2c1a-4d94-d1d0-08d97e6ecf92
X-MS-TrafficTypeDiagnostic: SN4PR10MB5656:
X-Microsoft-Antispam-PRVS: <SN4PR10MB5656016778DFF27C55C0FFAAF6A39@SN4PR10MB5656.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: msTPsgGN2Llmle7iMFZ61u3Bv3dxVVkJSWOC7hIcbhV9TRtTfB0CAP2N7oR5a/5ZdZ9aGR+HtkETU/J3+LXVvfWx8ky6lMdAaw5F/TEV9VIM05QGge/BfOpAwz5TXP+RSj3fJz1eG4UOBphgs/0prgdmoxD6fvZUf6YA+uaR3V6FJ1mpQ1p59wxHPne8kvsrNocHMJ8+F8Qr8vRUXrWzmBJx3tloDeAD0MMspZ1XHLYMbsPhdNlBcR8sdEvGZXDoCLnma0F2o5c63A0c3Cco9XRbgIWtcuDFg6aKByMa4+w5GjWccFM04rr9TTFqxBcIx74SbElHVEQqjr34OZoNQ+jQH2v3Siyn1s1+/qBV2dc/ogkdPtr2z4/lmrspYYLwwFE5xEE/4BC3X+caE8axg+nu6xCLY9HsL23K/Ud1RdjQaHlfRT6AzJytdYZ8ax5KxVaZja3fPYByzL4toDoAVXUxHCJUbbrmSbxPP/fzXb58BpgOyk8aAk3i0ky9mJ0gSE/b4Go8cL71fsa/m+CTBkOs2BKG4dzRA7qeXniwudGp+aQPBv4Mb9vD40AdxhWLsR4Hu+s2jAzzwlX23qOsCHey5pitw8ZCCsY4O4ljNTa0ynm2cwdxwu0D3diGFBFcybdWlAzVdL4vBxJdDrZ2kWx3U80Naq9YiaU1LnAZY3i+5MO/pjxqoD0NliHIkcZqZftWHBs3YQtUk4c/7XxEHX1VuMxwzPZnP52MlCE4VwA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(86362001)(4326008)(52116002)(53546011)(4744005)(38350700002)(38100700002)(6486002)(9686003)(8936002)(956004)(186003)(6496006)(66556008)(6916009)(83380400001)(66476007)(66946007)(508600001)(5660300002)(2906002)(26005)(6666004)(316002)(33716001)(8676002)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sF5U/cGUI9/pFmZkIr9Abd3rxqhaoux9eJVYaWMXQ4VgmLpld/MdzkDtiRX7?=
 =?us-ascii?Q?wrunyI+0Lrb66TDyc10HP9/dnDBJW29mPzyTNuodQl1TAs6EO2RwwbJYrK2S?=
 =?us-ascii?Q?rQb5rPMPjRtf6f8jzEjH92d7+m6ElnuOSMfjrKkI7GgoNtqqo0mIJmKIcH6W?=
 =?us-ascii?Q?5XI4J//WllObDDjX7MCY6e+BZkIieswhj6R7HQ9J6c6kCiyNDi4Rczxn14fS?=
 =?us-ascii?Q?cCauRSJhPnAWRJnRYDKr5RGqylVBdnNz6SyB2PThzvZuTK02w99EX9ZXyRRg?=
 =?us-ascii?Q?BWfNyKWMHRPMgWR9epQEocfBFZWy3vTBOdaKetX1uxRwuvvLVgMHbzR7iIHB?=
 =?us-ascii?Q?0ycPkaqMRu0dlqCnXVciyx2eahm1eOQCO8VEI4HP9oTaidh1H6BeVgqtCxGB?=
 =?us-ascii?Q?Qdxi1XEKVVGQgHuHKlY3/k83hetwtu8ToS8Z+ZXx7hGQK1yGk8525+qV6Nq8?=
 =?us-ascii?Q?B515Uxj8xM+uWc7n4vRekfiNvssp46Dugbnozl7V+N5kuG58MLhIBnfNXswQ?=
 =?us-ascii?Q?5Q2LPSmNUl+BJvbjW6QQ+JjfvmNWmrvk1EH5/Q6MielkIpnT4Y0O8dWLfMdn?=
 =?us-ascii?Q?XypqCFRLn5RNkApL/khvP9gDethZKj9tqKMWmLXT5dJ8tzOoOSalzFs+ZJFf?=
 =?us-ascii?Q?p061D1qYOzOB0vzkom42+WlrNACgpT7GXLYZZC8WF44pTsWTuKPfcEcevDdr?=
 =?us-ascii?Q?Xlz33Xt9ryMUMwOmzmzNvFPw87NuWZDyf1ZBTpz2VWjl0V2xudXPexUI7iJ6?=
 =?us-ascii?Q?W0aLEnJu0AYrfHN9h/sQNhLnGxd2FxTC1TFvxWQK5sg/4bmbD9GdDEIPlWHT?=
 =?us-ascii?Q?NbhC0hC0+8i2Gf38bMvU20JO3rqtAxSkigOayvoH92Vf8V6VqonXqVMd+jZ6?=
 =?us-ascii?Q?682hFVHO6NdQJ2n6YBnCutRK2FmlkKWh9JFh32M3nqPLbAdjBp1n2zWVnnEq?=
 =?us-ascii?Q?2WNNcbTXot3q/8dvoEiddszZLB82zlkUy8MHTDvqSTJsQzqgynF7v/klMvlZ?=
 =?us-ascii?Q?VI1F4AIipYlk+tcXC0tu30Lcz4X+dUchYaMRbtZa0pYVccCdkRUuPRfkdeG4?=
 =?us-ascii?Q?kqfqqgUhQ7FxvlRhA2bB42Yrz8igD8uTft7wP7mQY/ZRlVMGEcEN7Gh7fOBH?=
 =?us-ascii?Q?aILmR3RDkPClSUi5211vJWdedz3m6Re+ZR6zhWb/wHIR6zYerI9z8fRZ5yli?=
 =?us-ascii?Q?tMjv2mOvbndsbj6JhiAZ5x+c9b0uL4wTQVUiDsY7cQyF+Hxa0ZXNU5TF+0M+?=
 =?us-ascii?Q?4i2+YPhFBtWmFBbJg2OM5s6BF3QwMZ61+Chgduq83bykCQ1cg8w5Vp94Uyxg?=
 =?us-ascii?Q?nmvTLp3BS66WzTyOCTGiXQYC?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc941f51-2c1a-4d94-d1d0-08d97e6ecf92
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2021 08:47:44.4838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vHAd7AF+TndLvfFKaHcmTtqPcehP+tVqTyZg4yAdEmWZH24IWmPznHsBpDX7q5yGxJRXibl+WArtJyhivawa6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5656
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10115 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=0 phishscore=0 mlxlogscore=908 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109200000 definitions=main-2109230053
X-Proofpoint-GUID: FCXYlmrlckefWTfCCAHlW2rxEC_vW_lm
X-Proofpoint-ORIG-GUID: FCXYlmrlckefWTfCCAHlW2rxEC_vW_lm
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On 16 Sep 2021 at 07:16, Dave Chinner wrote:
> Hi Darrick,
>
> This is where I think we should be going with spinlocks, atomics,
> and other primitives that the shared libxfs code depends on in the
> kernel...
>
> -Dave.

I will work on getting this cleanly applied on top of current xfsprogs code
base.

-- 
chandan
