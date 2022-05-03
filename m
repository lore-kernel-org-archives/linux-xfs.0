Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3C28C433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  3 May 2022 22:42:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243782AbiECWqP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 May 2022 18:46:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243790AbiECWqK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 May 2022 18:46:10 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACDBE427FD
        for <linux-xfs@vger.kernel.org>; Tue,  3 May 2022 15:42:36 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 243KvDYY027626;
        Tue, 3 May 2022 22:42:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=GhO9qA1TpUd+Fw9kRv8AdKwQuup/pggrurU9qe1EA0o=;
 b=ZZExildKzjwDvOm1SUNY3Hd7FHOdtAfJYdTuay5J6P0snBa7J/gm5d8uhwSQ+EWSe8qW
 uD2sR+/MbToNx7GKIMSChMyh7Zc/OySx+gwcVkYSCu15iCL1vrXNqQJ+FrrJaU3KJsWB
 7KLi851fxP1v1wmPT5Jo+MKWUHtun1rkqJhDUcUcseaBc+fK/fKKxk3NIARyqH7eci2N
 5rYu36zEPrAorffmwlrM6rtRR7quXUaq8EtR4e3TpU0bPPDdKcqCq+gQJx/b7zWVYtTZ
 v0D/lG7z1tay5PQSQkXM9j6qHNBEd7yhCO4+gSKdPfFQIwlP2JlXypYgs6G0+x5LaLwQ ZQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fruw2f13g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 May 2022 22:42:35 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 243MaSFf037510;
        Tue, 3 May 2022 22:42:34 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fruj2tynu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 May 2022 22:42:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZrcTyEAh5e+/08xIL4rII1mf9L/1JQeGaQiblgHWgXYtsf9ibIjfUQ+62AWHzCgJUq8hW8EeDeDSR5lQaHxVwa2KKXyrE3iYoNO5cc0Su+5G7YHTzsf3I5xxvic8DLZPmOx1pwcCzUcc/0/PnA2ktUn9LKkzW4IZOvxKiDr8/397FotReZveUh6TsHle3NtK+dDi0PvMdd5TzyH9JWfBC4Hu+D/R+OO9ft7xs21K3uRo1Yy6DiZ1zjJ1MssASwabE6xDX+5Yl0guPOT9Ny6YFxStu8zmuh2IvB1mbMm4NT1X6lgyrBMl/GWjftET2XtWXgoO8wOLM3+k/Iet9n4VXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GhO9qA1TpUd+Fw9kRv8AdKwQuup/pggrurU9qe1EA0o=;
 b=F3ODS1oxCJrZVEEUacbJbdHoGgDgviPm9QN48w3+uKMto1pRs13kMxQy9kHA3IyTKr627IqFF+pDd4L1Dukq4+/dxR/W7ATTMf9WCyOHyfzWYRjx8MR/sovIa/WS4pYzA9QPS/T8MU170vFDo1+VbKAaxgSjJs0uNARWroV8TmLaM+FiZ+BPNZKbZ08q8vBl9Arx2yJtF7cV+qVM7eMJ5Ox9l/vbTow+SND2Pw/bPus8DnI4vUGDmIsRfU4493vkPprE4uB6B8Ea0+DCPNFzWI9wdHg/tfy7+6Fv7q0699UcEx3TrJFt4ihBLguJVzKsROFzW29imAQqPlV6KO4+FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GhO9qA1TpUd+Fw9kRv8AdKwQuup/pggrurU9qe1EA0o=;
 b=w2XE0j5OTxoHDaICXgfDkSTdFqve8OUrpIifdF+TlXneFf2ld4j/x8XmzUzqvIbaRXw92ebFQT8AtuHCrL8Egcaiaex45S8n6CAonX3+ZiMw+49p9MGF+Jbi7rGD3O/xkDzhS+RXYoo/Vp7Kitr1Z5pL+9jsBEEOkoN7BN1FQ6c=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BN8PR10MB3361.namprd10.prod.outlook.com (2603:10b6:408:d1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Tue, 3 May
 2022 22:42:30 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f%8]) with mapi id 15.20.5206.024; Tue, 3 May 2022
 22:42:30 +0000
Message-ID: <082e576096397944b111fe1377b67c0136aa5998.camel@oracle.com>
Subject: Re: [PATCH 10/10] xfs: intent item whiteouts
From:   Alli <allison.henderson@oracle.com>
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Tue, 03 May 2022 15:42:28 -0700
In-Reply-To: <20220503221728.185449-11-david@fromorbit.com>
References: <20220503221728.185449-1-david@fromorbit.com>
         <20220503221728.185449-11-david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0158.namprd05.prod.outlook.com
 (2603:10b6:a03:339::13) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3d4a1da4-d825-4ae2-152e-08da2d5634c5
X-MS-TrafficTypeDiagnostic: BN8PR10MB3361:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB3361BE2A409DA3D6B0A2E67995C09@BN8PR10MB3361.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l1VTkkO2e84CavJAkhO6tbnvr05Gqn/spnUwoGHvxJb5oHfqkratfQe6CZWjdxhfaA9aOJmJkYfd2HKMTRvJu9lFDMGcv7EBFI0uZ/gnUyH1MQAf682CFS44XG/9GBzaVqbiJq46eugnOcx2I+KmcSDNzd50ycG801njAVnleX3kPogCNLOMdfQvfFqoKZaeNf72Mrv5R8zs6EZ5UI3nMCqw8V2zfcYEZI0dU3f75l9q23lmeOFuo4iVJOS3Uwfy/ngjL6mhdAa+sdyj2iUqI+nNo3nrujlJ2gaj7eWoL6una8JFmdGxKM8ZTRfc9HqcWQ8FkuDROqh1d6GRVVAGnRpgTz1Q06o1RTfqDnsFYaiqzn8kkULscpM2IDiIMfZXlPAWHUXaIKGPHNTgBflWXngTvZGmaPzLzd6mfeBwhlau49DptDgh4MQz2zkfgDnuVCXALFrkqoiVYjYLftzLdy7qkRmmZbPNGnDN0024TWh7+mDC6tyq477VQJE0GIZLq8M4QnpepoJ4CuLti7sDMMv+sBRGRPrSuoyyeImBHYVcN0fy++mCxH+MPEisl/5Eec4SfgRfRbCdFzX9TALjtZaR+ZTkr8MzFvvpZZkA/HfKfW/v7r5BnCAFsZLCZhIYWCMPuXOXuffc4rdkFyoothQusrxMdmX6oJfUb5UKNzKSGBIQKdGx8IbQxUhenvEY6WW2iEBKx/AoZR5wBZKaAQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(86362001)(508600001)(8936002)(5660300002)(6512007)(186003)(36756003)(316002)(83380400001)(8676002)(66476007)(2616005)(66556008)(66946007)(52116002)(26005)(38100700002)(30864003)(38350700002)(6506007)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TUthbi8yY3pCYlZYcGNXMWE1QUM1U3BtQThsWGR6YzMrVjNtekt3SG83Yzh5?=
 =?utf-8?B?RDhtOW5sayswNVN0NGZTV3VWOWVZejFweXlKeU5oM0p3NWJZTkZ1dXlJcWlZ?=
 =?utf-8?B?dVh6YlRRL3VwUWU4MDZZSWtYdXpFbDdJMXhkV2FGYmVxRlE1NUhUN2dmNGcx?=
 =?utf-8?B?TWNKRVV4ZVp1dFhuYVZvYnlITDc4Q2pNT3Q5OENjV2l3U3JVK2d2SCtJY2VK?=
 =?utf-8?B?Qy9BZUQ5dU1ZVDJzRWxBdUgrTWZVZThscHJXVGV6cUhJYk9IbW05TkV5WVd1?=
 =?utf-8?B?WVk5YjNaY3d2TlEvdHdjUVpBZk9uUmNaRjRxYkgxbXMrbWRKYkRzc3UyTVFr?=
 =?utf-8?B?dHpCbWF4THFJUnoxN1crVDgxTFdha3Z0QjlwWnp0ZkJ1bVNpLzZJS0ZjMXM3?=
 =?utf-8?B?UFB1enluNFJ3YjhZaTRpRUJ6eDNsY3p2aGlhZXpsbmFwaFJvaFdIS2FvRXZ0?=
 =?utf-8?B?RG44TTA3SEZ1VEMxMmtNcEE3SjFBeGpIVVBCRnMzWjlJanpzQWlldW5lWU16?=
 =?utf-8?B?WnJBQmRLZWhYR0ZQZlRuNUdYcE1Gb0NxaDB1NG1iM1QxQlMvMHM3M25oSDEr?=
 =?utf-8?B?T3l5UnhtcmhVVExEQU1ncGlpcG1ncTkyU0ZNVXo5NU96MG1JUW5OemJobWd2?=
 =?utf-8?B?VVZMUURwWGNUZEM1Mk96c2RCYnZmanRzTTlDY2Z5b1NlMmtrbFZkU1UxdEFm?=
 =?utf-8?B?TElYR1lzYVp4WnU2NmRQY1FjMEU5dmk2cS90MDhVenEzdUo3YnpTdUJQbXhL?=
 =?utf-8?B?dk9wU3pLd2tWaXFnVlJ1dnVQQU96SmFoL1FLb0QyOWw0VDhFR1VndUVWVWdT?=
 =?utf-8?B?WDBoVWxNWUlFMHVzMUhGMjlDcVpZOUliVy9zZGppek9OTjU5V05odzRUOHB2?=
 =?utf-8?B?UDZDTzRuM0c3WW9PeE9pTW9tWlhrbVMrOTI2cmJSZmRCRnB2OGpJUW5OOHJK?=
 =?utf-8?B?T1UybDZiN1FuL0Z4QkFzRU1sSm43aGE1aEorenNYR0FWZDhjU0xmc1BZWXZK?=
 =?utf-8?B?YnZGazhFSGpjQW1hNjFMTHJIQm0ySEExZ3EwemFoSEFnMTRJekxKTU1ucWp6?=
 =?utf-8?B?YkM3T3hYZTBrQ2Z6RmNuWXd3dTFtdXJUSkJWSFgrSjNyNUd3ZS9IbEx5aDdm?=
 =?utf-8?B?bGRDWVJMdkJuRUszZmYrM2U4cXdhaUo5K1lORTZVT3pIRTRydjViLzNscVZ6?=
 =?utf-8?B?bW9YSE9xTFp5WUhwQnVEWWdGaWJwYjNZYVczYXZHb2IwNVk1Y1FMWUxlV2Zh?=
 =?utf-8?B?a1hhaUtObmRuMVkzc2lBSDZGNzlQSnJIUHN5ZVhxd2IwdUdUdnlDdXlINFNP?=
 =?utf-8?B?ZnZJR2wzVUwyTzZGMyszOGU4dUg2ZUY5NHNhYUdZNjN5YXZRZUliWHlna2hJ?=
 =?utf-8?B?Nm80NmJBdlFIS3dNS0h6RHhnSE95UEJsNzJ5Nk5KSDJKMm92QkFERGFaZmMy?=
 =?utf-8?B?Q2ozYytyaSszNnlsUUpaTGhVSnU3cGlQRVlDb1hyY25McFcvQ21QMElWOEds?=
 =?utf-8?B?ZW1aa08wbnZ6M2ZjSGZ0QkdjZWl4THdvSm5kU3JYUWw5THJ0bTZzOVRGcFBw?=
 =?utf-8?B?enh1a1F1QzB2K2pWNGFEYUFac2owbDlJcGRZelVHRU0xNHZmRDdaem9nVjJY?=
 =?utf-8?B?bkJPaWUrNGdieTBLR2FVKzJkUFowWC9SQmRDdmxhZjEwc2o0WUJSc0FoVkxk?=
 =?utf-8?B?UFBXdmdNWlZSYmVyT3NJbGpoV0M5Q1E1TmVtaTFSN2oxR3ZhZVkxUzFSdUgz?=
 =?utf-8?B?MHAyMEhaQWkveGZaSUd1dmZzOTBZeEYxY2pDN3ZIRlVRcmpTdTNWamttbGtN?=
 =?utf-8?B?Q3o1ZzRqMXlUK29oLzhsbzAxc2xlNmJWbHJJR0Q0WEhWSnJYMXh1K2hmMTc0?=
 =?utf-8?B?cGtuTURWVmNrNXdLYTFqQlhYMGFVNCtnRW1YT3pPVXB3YjU1bUpFaGFEQ2Fx?=
 =?utf-8?B?SWFHVGlLWEJYT1dxeGJKczBlOEpMOW9Cb3RYUmN4T0xJZHRyNkVzbk5rVTJU?=
 =?utf-8?B?WVZOcVdaZXZKd2krL05tcHFkanJwWXdxMG1TQUxXYk9yTTl2UExNeEZYTVEw?=
 =?utf-8?B?WVJFSkVrb283UG85TXRXM2g4QXpucUhCdEZNR3dnMDZYU1VHSEUzd1pqSDZ4?=
 =?utf-8?B?bm54bmNieTVkYlZRQ3RhVjVwN2ZYdTZaMkNrTEFhVTg3a1dtZjRCeHB1Sjc4?=
 =?utf-8?B?TmpRTGwwR3dZVEFhMExTQ2lpeHNXa0ZxYnUrckN3V1B1Q2xXOVdXYmlFTGJj?=
 =?utf-8?B?YzlFUTJsZE9xL1lINGJMdUptVWY1M2V5bXk2ZUZ3bEloMThHVHdlbDJrUXZO?=
 =?utf-8?B?WTRPNFZVQ0VOUEJ2MElPNDZ2Zno0bGpKK2NsTHdhaFNndzVKRGx4eFNrUnQv?=
 =?utf-8?Q?MhoR/0Dk4SU5Xssg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d4a1da4-d825-4ae2-152e-08da2d5634c5
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 22:42:30.3219
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wzVdojySj9OXmXSPvCnG1iSg4kakkRKoSX2Eic8lijVx4RaLhi/euD55lrI8zchLSOrfXj/cc32PGrDU6tZZJvQuKrAttMr2Q9zk764Fl3k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3361
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-03_09:2022-05-02,2022-05-03 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 mlxscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205030137
X-Proofpoint-GUID: ohkIXCcIcfspqFhH9wGSZUFAp_Tz2e8E
X-Proofpoint-ORIG-GUID: ohkIXCcIcfspqFhH9wGSZUFAp_Tz2e8E
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 2022-05-04 at 08:17 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When we log modifications based on intents, we add both intent
> and intent done items to the modification being made. These get
> written to the log to ensure that the operation is re-run if the
> intent done is not found in the log.
> 
> However, for operations that complete wholly within a single
> checkpoint, the change in the checkpoint is atomic and will never
> need replay. In this case, we don't need to actually write the
> intent and intent done items to the journal because log recovery
> will never need to manually restart this modification.
> 
> Log recovery currently handles intent/intent done matching by
> inserting the intent into the AIL, then removing it when a matching
> intent done item is found. Hence for all the intent-based operations
> that complete within a checkpoint, we spend all that time parsing
> the intent/intent done items just to cancel them and do nothing with
> them.
> 
> Hence it follows that the only time we actually need intents in the
> log is when the modification crosses checkpoint boundaries in the
> log and so may only be partially complete in the journal. Hence if
> we commit and intent done item to the CIL and the intent item is in
> the same checkpoint, we don't actually have to write them to the
> journal because log recovery will always cancel the intents.
> 
> We've never really worried about the overhead of logging intents
> unnecessarily like this because the intents we log are generally
> very much smaller than the change being made. e.g. freeing an extent
> involves modifying at lease two freespace btree blocks and the AGF,
> so the EFI/EFD overhead is only a small increase in space and
> processing time compared to the overall cost of freeing an extent.
> 
> However, delayed attributes change this cost equation dramatically,
> especially for inline attributes. In the case of adding an inline
> attribute, we only log the inode core and attribute fork at present.
> With delayed attributes, we now log the attr intent which includes
> the name and value, the inode core adn attr fork, and finally the
> attr intent done item. We increase the number of items we log from 1
> to 3, and the number of log vectors (regions) goes up from 3 to 7.
> Hence we tripple the number of objects that the CIL has to process,
> and more than double the number of log vectors that need to be
> written to the journal.
> 
> At scale, this means delayed attributes cause a non-pipelined CIL to
> become CPU bound processing all the extra items, resulting in a > 40%
> performance degradation on 16-way file+xattr create worklaods.
> Pipelining the CIL (as per 5.15) reduces the performance degradation
> to 20%, but now the limitation is the rate at which the log items
> can be written to the iclogs and iclogs be dispatched for IO and
> completed.
> 
> Even log IO completion is slowed down by these intents, because it
> now has to process 3x the number of items in the checkpoint.
> Processing completed intents is especially inefficient here, because
> we first insert the intent into the AIL, then remove it from the AIL
> when the intent done is processed. IOWs, we are also doing expensive
> operations in log IO completion we could completely avoid if we
> didn't log completed intent/intent done pairs.
> 
> Enter log item whiteouts.
> 
> When an intent done is committed, we can check to see if the
> associated intent is in the same checkpoint as we are currently
> committing the intent done to. If so, we can mark the intent log
> item with a whiteout and immediately free the intent done item
> rather than committing it to the CIL. We can basically skip the
> entire formatting and CIL insertion steps for the intent done item.
> 
> However, we cannot remove the intent item from the CIL at this point
> because the unlocked per-cpu CIL item lists do not permit removal
> without holding the CIL context lock exclusively. Transaction commit
> only holds the context lock shared, hence the best we can do is mark
> the intent item with a whiteout so that the CIL push can release it
> rather than writing it to the log.
> 
> This means we never write the intent to the log if the intent done
> has also been committed to the same checkpoint, but we'll always
> write the intent if the intent done has not been committed or has
> been committed to a different checkpoint. This will result in
> correct log recovery behaviour in all cases, without the overhead of
> logging unnecessary intents.
> 
> This intent whiteout concept is generic - we can apply it to all
> intent/intent done pairs that have a direct 1:1 relationship. The
> way deferred ops iterate and relog intents mean that all intents
> currently have a 1:1 relationship with their done intent, and hence
> we can apply this cancellation to all existing intent/intent done
> implementations.
> 
> For delayed attributes with a 16-way 64kB xattr create workload,
> whiteouts reduce the amount of journalled metadata from ~2.5GB/s
> down to ~600MB/s and improve the creation rate from 9000/s to
> 14000/s.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
Ok, I think it looks good
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>  fs/xfs/xfs_log_cil.c | 78
> ++++++++++++++++++++++++++++++++++++++++++--
>  fs/xfs/xfs_trace.h   |  3 ++
>  fs/xfs/xfs_trans.h   |  6 ++--
>  3 files changed, 82 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 0d8d092447ad..fecd2ea3e935 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -476,7 +476,8 @@ xlog_cil_insert_format_items(
>  static void
>  xlog_cil_insert_items(
>  	struct xlog		*log,
> -	struct xfs_trans	*tp)
> +	struct xfs_trans	*tp,
> +	uint32_t		released_space)
>  {
>  	struct xfs_cil		*cil = log->l_cilp;
>  	struct xfs_cil_ctx	*ctx = cil->xc_ctx;
> @@ -525,7 +526,9 @@ xlog_cil_insert_items(
>  		ASSERT(tp->t_ticket->t_curr_res >= len);
>  	}
>  	tp->t_ticket->t_curr_res -= len;
> +	tp->t_ticket->t_curr_res += released_space;
>  	ctx->space_used += len;
> +	ctx->space_used -= released_space;
>  
>  	/*
>  	 * If we've overrun the reservation, dump the tx details before
> we move
> @@ -970,11 +973,16 @@ xlog_cil_build_trans_hdr(
>   * Pull all the log vectors off the items in the CIL, and remove the
> items from
>   * the CIL. We don't need the CIL lock here because it's only needed
> on the
>   * transaction commit side which is currently locked out by the
> flush lock.
> + *
> + * If a log item is marked with a whiteout, we do not need to write
> it to the
> + * journal and so we just move them to the whiteout list for the
> caller to
> + * dispose of appropriately.
>   */
>  static void
>  xlog_cil_build_lv_chain(
>  	struct xfs_cil		*cil,
>  	struct xfs_cil_ctx	*ctx,
> +	struct list_head	*whiteouts,
>  	uint32_t		*num_iovecs,
>  	uint32_t		*num_bytes)
>  {
> @@ -985,6 +993,13 @@ xlog_cil_build_lv_chain(
>  
>  		item = list_first_entry(&cil->xc_cil,
>  					struct xfs_log_item, li_cil);
> +
> +		if (test_bit(XFS_LI_WHITEOUT, &item->li_flags)) {
> +			list_move(&item->li_cil, whiteouts);
> +			trace_xfs_cil_whiteout_skip(item);
> +			continue;
> +		}
> +
>  		list_del_init(&item->li_cil);
>  		if (!ctx->lv_chain)
>  			ctx->lv_chain = item->li_lv;
> @@ -1000,6 +1015,19 @@ xlog_cil_build_lv_chain(
>  	}
>  }
>  
> +static void
> +xlog_cil_push_cleanup_whiteouts(
> +	struct list_head	*whiteouts)
> +{
> +	while (!list_empty(whiteouts)) {
> +		struct xfs_log_item *item = list_first_entry(whiteouts,
> +						struct xfs_log_item,
> li_cil);
> +		list_del_init(&item->li_cil);
> +		trace_xfs_cil_whiteout_unpin(item);
> +		item->li_ops->iop_unpin(item, 1);
> +	}
> +}
> +
>  /*
>   * Push the Committed Item List to the log.
>   *
> @@ -1030,6 +1058,7 @@ xlog_cil_push_work(
>  	struct xfs_log_vec	lvhdr = { NULL };
>  	xfs_csn_t		push_seq;
>  	bool			push_commit_stable;
> +	LIST_HEAD		(whiteouts);
>  
>  	new_ctx = xlog_cil_ctx_alloc();
>  	new_ctx->ticket = xlog_cil_ticket_alloc(log);
> @@ -1098,7 +1127,7 @@ xlog_cil_push_work(
>  	list_add(&ctx->committing, &cil->xc_committing);
>  	spin_unlock(&cil->xc_push_lock);
>  
> -	xlog_cil_build_lv_chain(cil, ctx, &num_iovecs, &num_bytes);
> +	xlog_cil_build_lv_chain(cil, ctx, &whiteouts, &num_iovecs,
> &num_bytes);
>  
>  	/*
>  	 * Switch the contexts so we can drop the context lock and move
> out
> @@ -1201,6 +1230,7 @@ xlog_cil_push_work(
>  	/* Not safe to reference ctx now! */
>  
>  	spin_unlock(&log->l_icloglock);
> +	xlog_cil_push_cleanup_whiteouts(&whiteouts);
>  	return;
>  
>  out_skip:
> @@ -1212,6 +1242,7 @@ xlog_cil_push_work(
>  out_abort_free_ticket:
>  	xfs_log_ticket_ungrant(log, ctx->ticket);
>  	ASSERT(xlog_is_shutdown(log));
> +	xlog_cil_push_cleanup_whiteouts(&whiteouts);
>  	if (!ctx->commit_iclog) {
>  		xlog_cil_committed(ctx);
>  		return;
> @@ -1360,6 +1391,43 @@ xlog_cil_empty(
>  	return empty;
>  }
>  
> +/*
> + * If there are intent done items in this transaction and the
> related intent was
> + * committed in the current (same) CIL checkpoint, we don't need to
> write either
> + * the intent or intent done item to the journal as the change will
> be
> + * journalled atomically within this checkpoint. As we cannot remove
> items from
> + * the CIL here, mark the related intent with a whiteout so that the
> CIL push
> + * can remove it rather than writing it to the journal. Then remove
> the intent
> + * done item from the current transaction and release it so it
> doesn't get put
> + * into the CIL at all.
> + */
> +static uint32_t
> +xlog_cil_process_intents(
> +	struct xfs_cil		*cil,
> +	struct xfs_trans	*tp)
> +{
> +	struct xfs_log_item	*lip, *ilip, *next;
> +	uint32_t		len = 0;
> +
> +	list_for_each_entry_safe(lip, next, &tp->t_items, li_trans) {
> +		if (!(lip->li_ops->flags & XFS_ITEM_INTENT_DONE))
> +			continue;
> +
> +		ilip = lip->li_ops->iop_intent(lip);
> +		if (!ilip || !xlog_item_in_current_chkpt(cil, ilip))
> +			continue;
> +		set_bit(XFS_LI_WHITEOUT, &ilip->li_flags);
> +		trace_xfs_cil_whiteout_mark(ilip);
> +		len += ilip->li_lv->lv_bytes;
> +		kmem_free(ilip->li_lv);
> +		ilip->li_lv = NULL;
> +
> +		xfs_trans_del_item(lip);
> +		lip->li_ops->iop_release(lip);
> +	}
> +	return len;
> +}
> +
>  /*
>   * Commit a transaction with the given vector to the Committed Item
> List.
>   *
> @@ -1382,6 +1450,7 @@ xlog_cil_commit(
>  {
>  	struct xfs_cil		*cil = log->l_cilp;
>  	struct xfs_log_item	*lip, *next;
> +	uint32_t		released_space = 0;
>  
>  	/*
>  	 * Do all necessary memory allocation before we lock the CIL.
> @@ -1393,7 +1462,10 @@ xlog_cil_commit(
>  	/* lock out background commit */
>  	down_read(&cil->xc_ctx_lock);
>  
> -	xlog_cil_insert_items(log, tp);
> +	if (tp->t_flags & XFS_TRANS_HAS_INTENT_DONE)
> +		released_space = xlog_cil_process_intents(cil, tp);
> +
> +	xlog_cil_insert_items(log, tp, released_space);
>  
>  	if (regrant && !xlog_is_shutdown(log))
>  		xfs_log_ticket_regrant(log, tp->t_ticket);
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index e1197f9ad97e..75934e3c3f55 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -1332,6 +1332,9 @@ DEFINE_LOG_ITEM_EVENT(xfs_ail_push);
>  DEFINE_LOG_ITEM_EVENT(xfs_ail_pinned);
>  DEFINE_LOG_ITEM_EVENT(xfs_ail_locked);
>  DEFINE_LOG_ITEM_EVENT(xfs_ail_flushing);
> +DEFINE_LOG_ITEM_EVENT(xfs_cil_whiteout_mark);
> +DEFINE_LOG_ITEM_EVENT(xfs_cil_whiteout_skip);
> +DEFINE_LOG_ITEM_EVENT(xfs_cil_whiteout_unpin);
>  
>  DECLARE_EVENT_CLASS(xfs_ail_class,
>  	TP_PROTO(struct xfs_log_item *lip, xfs_lsn_t old_lsn, xfs_lsn_t
> new_lsn),
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index d72a5995d33e..9561f193e7e1 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -55,13 +55,15 @@ struct xfs_log_item {
>  #define	XFS_LI_IN_AIL	0
>  #define	XFS_LI_ABORTED	1
>  #define	XFS_LI_FAILED	2
> -#define	XFS_LI_DIRTY	3	/* log item dirty in
> transaction */
> +#define	XFS_LI_DIRTY	3
> +#define	XFS_LI_WHITEOUT	4
>  
>  #define XFS_LI_FLAGS \
>  	{ (1u << XFS_LI_IN_AIL),	"IN_AIL" }, \
>  	{ (1u << XFS_LI_ABORTED),	"ABORTED" }, \
>  	{ (1u << XFS_LI_FAILED),	"FAILED" }, \
> -	{ (1u << XFS_LI_DIRTY),		"DIRTY" }
> +	{ (1u << XFS_LI_DIRTY),		"DIRTY" }, \
> +	{ (1u << XFS_LI_WHITEOUT),	"WHITEOUT" }
>  
>  struct xfs_item_ops {
>  	unsigned flags;

