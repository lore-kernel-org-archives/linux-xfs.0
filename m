Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 364A6C25B06
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Aug 2022 01:55:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234831AbiHLBzb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Aug 2022 21:55:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiHLBza (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Aug 2022 21:55:30 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4993F915DA
        for <linux-xfs@vger.kernel.org>; Thu, 11 Aug 2022 18:55:29 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27BN5gcZ019405;
        Fri, 12 Aug 2022 01:55:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=NnL/yU3TnOwYQaL5yvvDqFDwqgJMUY/haLpg4BUzVnI=;
 b=EHH07tYmJlAON+483JtDSdl0McC5i2HJBYpBvG+vFy+mk9heNznF0kmpFd7sPSnCO/V7
 0B5pMUOxoufUwf0E+lh6A3eyRafd0nUHScW1ej95ETuljc2hRqWLabPKXDkJwR53JNpc
 xaGGlQfa4lAR6k39fR9pwsbeP0bbAW8Iyj2aVaZhBmnS4ovDDZq2iKtTYkpaxlz/RAF7
 OP/rL5vtGKiM5q6ML67eFZbfhNAEKbcv2fLVhhHsA/OqeBlxEVCEQJjEGUvGwTYWFZ6L
 5aWJkGY4nNn19ONMxMeDzS6NJlhphfOb+M5Pagp8v2nsyw9OQLeYAdqNyDuWj8Zclr/F 3A== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3huwq9p4ey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Aug 2022 01:55:21 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27C0Aljg035232;
        Fri, 12 Aug 2022 01:55:21 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3huwqkqhag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Aug 2022 01:55:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vn7KJQunYVvo9XI1ArX2xjE+G9ZYEhQfmMPIYL6x2+eSpQPx0/MRyT90ATQihzDeY/edKshzQMBCW8pSzsREBIn+gfQmFwS/X/Z22PqTvMEMcKxx88m9a5y3JM/2D/Dbe6Cs+PAVsTIbpgk/R+BrPQF/W7q3MEEpx++oYEFfpEmTJG0ZUqAW7NQF/c9D3kHpiuO+ZkymfQDOHFRb5GKWmw6mZzI8SqVZXlXNNAflg124ur7KXB9mRP7wc5Jf2a1/YBsxA6eIFRONfa8fS3xlyCky76j+i2/3/01ZqgTF3+8fLjfNLyMqKhJOuxyfhW2TDwGNJhlVBnAGSe0UqQ8JOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NnL/yU3TnOwYQaL5yvvDqFDwqgJMUY/haLpg4BUzVnI=;
 b=SPQMvxhYjL8zqRK+/A1WHDx50jwYA88jC++gDd3zSW6K4lzSWsI9XH7QFMzYQb5Cge6K2RHkLsp0sq1FdaBlmJCwb3ecLTDD9AAhQXV32bzlJu23eMIjzVCV/bpimJMLZ9ONTULrWxxkDF2KtEu74aUo+19XY1I1PRW0gchjbJ0DL3SFB+hztXIB3k1YiEwSoY0hnWWpLdVfSMEP2699zLT8JXrrf0x5cYXIxvMkkqZlIlaUJGPbUNQiGv9oO33o6elxy9UUWBNkwE6zxrzQr8jrSMNknVpoMk7F1pIHcZ4jK9yYccgK7ObPZRWgtigrbXL7qK2NaF2SdO/Y7YoLuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NnL/yU3TnOwYQaL5yvvDqFDwqgJMUY/haLpg4BUzVnI=;
 b=JsD3IxlUUhAyAUr0dQSWkUj6A3ZJ0Nbd6MgzAtrbHHgPlmT5WMpsCWNY4F7ksMhu+jKHuaxhb18X5lX6VK5v1d56mrBVJ1x/HbXKC5e/p/qxQl5OQybx2ZArwPYrtTnHQQQFdxBd7UUwvMcGXZUGcgdYoDsiOHOp+Qfzp3F8oPo=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DM6PR10MB2489.namprd10.prod.outlook.com (2603:10b6:5:b4::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Fri, 12 Aug
 2022 01:55:18 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519%4]) with mapi id 15.20.5525.011; Fri, 12 Aug 2022
 01:55:18 +0000
Message-ID: <f85ae9d8425aaff455301b28af32ba0d813f733b.camel@oracle.com>
Subject: Re: [PATCH RESEND v2 01/18] xfs: Fix multi-transaction larp replay
From:   Alli <allison.henderson@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Date:   Thu, 11 Aug 2022 18:55:16 -0700
In-Reply-To: <20220810061258.GL3600936@dread.disaster.area>
References: <20220804194013.99237-1-allison.henderson@oracle.com>
         <20220804194013.99237-2-allison.henderson@oracle.com>
         <YvKQ5+XotiXFDpTA@magnolia> <20220810015809.GK3600936@dread.disaster.area>
         <373809e97f15e14d181fea6e170bfd8e37a9c9e4.camel@oracle.com>
         <20220810061258.GL3600936@dread.disaster.area>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0011.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::24) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cc016f35-ccdf-4d88-44e0-08da7c05b521
X-MS-TrafficTypeDiagnostic: DM6PR10MB2489:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0n6zT2I3hSToV3jXx1lp0O7VyNG8a8MQpfcjdRUGla7dvebTXplsrRnWp/mCpbqT+f2ub5NcFCK8ViQW5vF3LdDD6/jodoD9I3AEimSiBnUtW5e18oMAGEGmQNHjJM3dMqSKL0+pPap2Zy4xm6vU+ke6kkFhRYq8kKXNdwn9U4iT5C6PAuz0xdFWDKf+nOtDBjLuI+zpILigLWcwxSq9hXoFHIpsYsS9YR/1CctXb9V8vl5FFLtgtK+vlmjD2WPO6aGtn0Muj/ZU4g3zxXpPU7+MvcX8/ZbNrqMs5PUgdHolOo6AoHxJgPG/gvzqkUBPor/xayfRv17hOxCt1brtmt4Ymv9wgBzWSGxUkcsFgAN6qd8RoMU/24duXNu6hsM3RP3VqEdkwOtukFg+nOnzAq08ZLe8MG0AeV5ETcPw68dQ+RfB0daMXA4lFuSPkes4YVMqdcCIxUy6Viq4g/camXUVbGxjB62p1C1RXyG2D0/8pw2+CNK8YdYMxNjlAES7QOuF5A2wqAmGV73okSwFJ7s760Alx+imEtMjegvk4OgEfP4fomjk8bnAb2/Ro01pzEVQOm5xHxLuJA7C0f70FqRYI6vR3ucjqLgucDM50aLqaljPd1BKxRRWHir006z5wrJb9TLsmxWA2Nd75BuksX4RzkBvR3+csa45r+klvBdbg6Isv2PG17OW0WRwfTfpDHaLflIX3mGLGm0GB2PwC7/FA2pYSVzOVupUikUAewLRqyp2QjiSnO30OtOfr4IpoQVhSwNoh84EYzbxskA4nU9dHkmKTsyHRNS3R/3SIUA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(376002)(346002)(136003)(366004)(396003)(41300700001)(8676002)(316002)(8936002)(66946007)(4326008)(66476007)(6916009)(66556008)(5660300002)(186003)(86362001)(2616005)(6486002)(478600001)(36756003)(2906002)(38100700002)(38350700002)(26005)(83380400001)(6506007)(6512007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Yk9ZdDkrVEhObEdsTWxiMW9JT0ZlYk95TldOeHpCakxQQ1c1WGh0bzBMcnBP?=
 =?utf-8?B?TzNGRGZWQ3VCMVBFUnVEbXlKN01PUVZPTnduWktMUnJSNTZLMUY1U2IyNEps?=
 =?utf-8?B?U3Flb25HVzRZaWxwdDlWSm9QV2FqQmtZak1OWjUvV1FTaHh0U2U1ZGMzcUsw?=
 =?utf-8?B?a1hzMVUweVMrUGlKMEVNYUdWd3FEUW40bWF0c2VKamtydlZjcURCMDNMeEw4?=
 =?utf-8?B?ZlVDTDFuOUVSaFR2MmxaK0R3UUtsOXVpRzdtOTBveE16K3dFUG9HblU2TUUy?=
 =?utf-8?B?MXVlb2J6b1BuL2Fpc2Q4bEFZejdtQkVCZUNxU25hQVpEb3FaUmF5SUNmdTNR?=
 =?utf-8?B?dGxOU0llOWN2SHlsMndOOWc1RW8zbUo0U2hZVElmS1dFeFVTbzBrdkoxU2lG?=
 =?utf-8?B?ajVQMmVaN3A0ekFjaWNDV0VGWEtFbkxXU1lCZG9OWEJiOVBhSVdYYS9ndk9R?=
 =?utf-8?B?Q1pZL2xVSlB2Z3pFLzQyYXN4cHZ0SW56R2hHZFR6aG8vZURVTk9vVnRlakZs?=
 =?utf-8?B?RW8vQ3ZtV2ppbnFXYk5SWDdTZUI3b3phT3Y4Z2NsSWNYTU5mZTA4UjVCbWR5?=
 =?utf-8?B?bUVraU1iU1BFWFc2dUNmMmZMcyt6RTFvMVBLMW91Yi9USVlnbjhCZFliZUtZ?=
 =?utf-8?B?aU4wQm9oZGRMT3dYK0NTa1I2b25GUW5ybjdya3RlQWdaQUNWZTFkaVJMR1Rm?=
 =?utf-8?B?c2xoL1NwaXNYMWVJclpVT3hJWW1aMmpuTlpDZEdXRFQ0NEFNME80L09tRVh0?=
 =?utf-8?B?WVNlblZrVG0rM0tFTWZtQTd3MHpWM2FBekxPck1Cc2JFRTkyeHBwb1IyNTVr?=
 =?utf-8?B?eHdzd0ZzcHFxK2pRSkN3VHMwN1dpcmVPNHpkSkZBejRueGN0dm5Eb2xFZ01L?=
 =?utf-8?B?K09ZRTM3YjFsUUtrR3pKLytUamZ1cHJudEZldkQ3d080TFNkanREdnNTN2ZQ?=
 =?utf-8?B?WnJwZTBRV2hWbjI3MmR6bEJlc0xuM3l1UEZHWEpOcEU0aGtZUjlFdm5hVkpG?=
 =?utf-8?B?QXhkaVVQSUd2WG1RVW9VWU44QlBkRnNaQzhwazNzT0ZsYUVWeVFIK3dqTmpo?=
 =?utf-8?B?TEUrMEZvUFdDN2VOYTBoTXlvemRrS0tKQ3dKYTcwLzc3U2Zxbk8yT1ZKcnBK?=
 =?utf-8?B?UkpBeWdtcCtVS2RQYTU4THdKVFFuNnRBRWF2UHVkL2VFWlN0WXoxazBLWE56?=
 =?utf-8?B?NUtIekN1a1BpSkI5dVRMVEFJVTAxZEp3TVdJYkZtcXJtNjBOV0E4NnRnRFA3?=
 =?utf-8?B?RXpXbTlvcldWTjc3c1haM3JMNkU0N1FvWGk0aW5JTUxMa1Btai8xQi9oZmlp?=
 =?utf-8?B?ckwwRUlWN24vVlUyelZOaUwwMTNLSE5QdGZLZ2NwOVlPUXFzWFVPSzBCRFJt?=
 =?utf-8?B?ZTJGaHRqM1ozNk5OWnFMS0cvQ1dXRy9xOG9oY0JPbTM5ZDlBQ0pwQWhpYXVh?=
 =?utf-8?B?azE4TXB2d3AvTU9ZUkphSTZ6dEpPeThEcHAxWjZjYm1Pa2VZN1dSWEZxVGtq?=
 =?utf-8?B?czJYQUNnOFJ0QmRPaWZhQmlwcHZab2ZRZTFOYzFlNGFDTTJUMkNrN0FZNmEx?=
 =?utf-8?B?UkxOWklpeEw3NHNGd1pSa0ZLT0Y1MmR5eFVUSDVtUVZPZEdyZjk1OXNBUjF0?=
 =?utf-8?B?S2dzR3lzeWRqd1hkRDFUUThRV3o5MkZNQ25xYXNoT0VRM3BtSmUzNkdVWjly?=
 =?utf-8?B?eThmdkx3MXR3TkpocjNOZGx4S3BKOUh5R3VTOU9TUFhHNW12YW56M0pTYzBS?=
 =?utf-8?B?SllKYUlQcGMvZ0QrWlR1NzJyT0lXUEFzWk11L2tZNVk0OGlqaTdjV201VXBS?=
 =?utf-8?B?djhVdDJWOGM3dFVLbU1YMDdrN1BZNGtJVHBHNSs2bDBGYkF6dW5TZUhMQmJM?=
 =?utf-8?B?Njg3K1pUSldkeGpyamJrVnlHNEJnS1ZoazdhYTFUTi9vQ25NMzNlb25mUW01?=
 =?utf-8?B?VmJvdW9PaGlSU094b3Zac0phSmhtYk9KUGIzajNJU2Q0RVhaRENneGdtUDBL?=
 =?utf-8?B?QWpHQ2p5aUtzWmxxQTRmZHBGVVl1a0NEdHFhUEQvdmkyS1V6bkh4bVhLLzFK?=
 =?utf-8?B?UC9wcmVJRWltUmV1YkhaQW5kY2tWZjZWQ2RIb29CZjVpZ0JadW4wUVRuZXo1?=
 =?utf-8?B?a3dlRnNDMHg2Y0Mva2hLbVBLMVlaVmVHZEJiUDQvT3BtYmI4NmpzNW85VDky?=
 =?utf-8?B?a3c9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc016f35-ccdf-4d88-44e0-08da7c05b521
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2022 01:55:18.4851
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QMoyLmarwM5x2EBiHsdQ/l/gJ9i4GS6XC9QZ4iB4DU6WX075KU2oqR0W3tl3Dgw2aAY9WFvKQS/2uAGVDt6ejqm2DXP0OTczfHMl2BqMA2c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2489
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-12_01,2022-08-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 mlxscore=0
 adultscore=0 bulkscore=0 mlxlogscore=936 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208120004
X-Proofpoint-ORIG-GUID: sLSGcsXc3tinN62eXiZTRRDWEuyAceiA
X-Proofpoint-GUID: sLSGcsXc3tinN62eXiZTRRDWEuyAceiA
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 2022-08-10 at 16:12 +1000, Dave Chinner wrote:
> On Tue, Aug 09, 2022 at 10:01:49PM -0700, Alli wrote:
> > On Wed, 2022-08-10 at 11:58 +1000, Dave Chinner wrote:
> > > On Tue, Aug 09, 2022 at 09:52:55AM -0700, Darrick J. Wong wrote:
> > > > On Thu, Aug 04, 2022 at 12:39:56PM -0700, Allison Henderson
> > > > wrote:
> > > > > Recent parent pointer testing has exposed a bug in the
> > > > > underlying
> > > > > attr replay.  A multi transaction replay currently performs a
> > > > > single step of the replay, then deferrs the rest if there is
> > > > > more
> > > > > to do.
> > > 
> > > Yup.
> > > 
> > > > > This causes race conditions with other attr replays that
> > > > > might be recovered before the remaining deferred work has had
> > > > > a
> > > > > chance to finish.
> > > 
> > > What other attr replays are we racing against?  There can only be
> > > one incomplete attr item intent/done chain per inode present in
> > > log
> > > recovery, right?
> > No, a rename queues up a set and remove before committing the
> > transaction.  One for the new parent pointer, and another to remove
> > the
> > old one.
> 
> Ah. That really needs to be described in the commit message -
> changing from "single intent chain per object" to "multiple
> concurrent independent and unserialised intent chains per object" is
> a pretty important design rule change...
> 
> The whole point of intents is to allow complex, multi-stage
> operations on a single object to be sequenced in a tightly
> controlled manner. They weren't intended to be run as concurrent
> lines of modification on single items; if you need to do two
> modifications on an object, the intent chain ties the two
> modifications together into a single whole.
> 
> One of the reasons I rewrote the attr state machine for LARP was to
> enable new multiple attr operation chains to be easily build from
> the entry points the state machien provides. Parent attr rename
> needs a new intent chain to be built, not run multiple independent
> intent chains for each modification.
> 
> > It cant be an attr replace because technically the names are
> > different.
> 
> I disagree - we have all the pieces we need in the state machine
> already, we just need to define separate attr names for the
> remove and insert steps in the attr intent.
> 
> That is, the "replace" operation we execute when an attr set
> overwrites the value is "technically" a "replace value" operation,
> but we actually implement it as a "replace entire attribute"
> operation.
> 
> Without LARP, we do that overwrite in independent steps via an
> intermediate INCOMPLETE state to allow two xattrs of the same name
> to exist in the attr tree at the same time. IOWs, the attr value
> overwrite is effectively a "set-swap-remove" operation on two
> entirely independent xattrs, ensuring that if we crash we always
> have either the old or new xattr visible.
> 
> With LARP, we can remove the original attr first, thereby avoiding
> the need for two versions of the xattr to exist in the tree in the
> first place. However, we have to do these two operations as a pair
> of linked independent operations. The intent chain provides the
> linking, and requires us to log the name and the value of the attr
> that we are overwriting in the intent. Hence we can always recover
> the modification to completion no matter where in the operation we
> fail.
> 
> When it comes to a parent attr rename operation, we are effectively
> doing two linked operations - remove the old attr, set the new attr
> - on different attributes. Implementation wise, it is exactly the
> same sequence as a "replace value" operation, except for the fact
> that the new attr we add has a different name.
> 
> Hence the only real difference between the existing "attr replace"
> and the intent chain we need for "parent attr rename" is that we
> have to log two attr names instead of one. 

To be clear, this would imply expanding xfs_attri_log_format to have
another alfi_new_name_len feild and another iovec for the attr intent
right?  Does that cause issues to change the on disk log layout after
the original has merged?  Or is that ok for things that are still
experimental? Thanks!

Allison

> Basically, we have a new
> XFS_ATTRI_OP_FLAGS... type for this, and that's what tells us that
> we are operating on two different attributes instead of just one.
> 
> The recovery operation becomes slightly different - we have to run a
> remove on the old, then a replace on the new - so there a little bit
> of new code needed to manage that in the state machine.
> 
> These, however, are just small tweaks on the existing replace attr
> operation, and there should be little difference in performance or
> overhead between a "replace value" and a "replace entire xattr"
> operation as they are largely the same runtime operation for LARP.
> 
> > So the recovered set grows the leaf, and returns the egain, then
> > rest
> > gets capture committed.  Next up is the recovered remove which
> > pulls
> > out the fork, which causes problems when the rest of the set
> > operation
> > resumes as a deferred operation.
> 
> Yup, and all this goes away when we build the right intent chain for
> replacing a parent attr rename....
> 
> Cheers,
> 
> Dave.

