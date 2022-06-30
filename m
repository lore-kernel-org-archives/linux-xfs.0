Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAE2AC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jun 2022 01:30:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbiF3BaU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 21:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbiF3BaT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 21:30:19 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 999CB2E9CA
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 18:30:18 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25TM4Bb8014124;
        Thu, 30 Jun 2022 01:30:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=sAF8FW0ouuTiz1brE2UvuwKiZ/5Pzu5V3/0vVf8cyVM=;
 b=rdElODfUD+xXhC2E8JpX9I1WzbEQe2CJsGcrL69SHqgFKupFlPluj5SMIdiCZlIkGhbV
 V0rU4gNtxvYOmTo9qC7uGYmbDWqanKc/1qGaFlqghnaKF1DcQIeXlGhxKV63IVQuAGam
 RljjzO/Bqw8qHPEt4Pxpw7+ZV11dhJW3tmbhi/hyVSsy+9SULws31E8nwQTDBYbgLs4n
 VnR0WsnBTpDbDR4etlEBA+U2b08OV3fZwH2ydiTwnj8trq7csulExJWYXmz/49bA00nb
 C2+u8cUbGKIAnwUbUgaU0ZfLjmW465dIeEu8/Ib/kSlqKSt0bjDfJ/Tj4IJ/W9ChslIh cg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gwsysjnyw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jun 2022 01:30:13 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25U1L0nO001742;
        Thu, 30 Jun 2022 01:30:12 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2177.outbound.protection.outlook.com [104.47.73.177])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gwrt407yd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jun 2022 01:30:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mGNpIPFfm47KykwQGBqVF9TTRmuWlMzzIFVrQML6HKS7YS81KwKeAYUOu6Lzu4T9S7DS2gDbhvYD0FNuYdisiNYq6RECxTdJ59Y+/zXaU/OYvmzlg83rceMuvCpMP+I9R8SYCRHv183Oa2S+Dzu0JwoK+ZopqcBxGYQbEA8Dg0zM2ig2P13dRcrpjy99Gg4npTkhKDN0vgayD60ZQPyhmWAIkslRdevEgNw2zjWHmAork8iJohCWGfHnurXDSq1EbVS5wmr9EG9s74mFWCGzdkNT5l0wsgZ3CmltIUDhrdGHZpughNoKVqa6dUU0zlgfu8JSVlLAcJC6YQOEMeRwPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sAF8FW0ouuTiz1brE2UvuwKiZ/5Pzu5V3/0vVf8cyVM=;
 b=LVsrqzZ68Fyh6t3JKeyOqQ89rF0U/oPnWbVCFHLlD7C9cM0h9RXhDxywXdJMciDT9K9oXkH1tpvMvA7xr8fNbkrYLLEE/AxDiD52ABmiYFdRv+qk7CKOk/ry9Crttww6MihnGF0fesSWsA1jY86FG1rMpY/1rQ65kO1R9L6GYYxG809t7tJg9DlvC7H3Pzl0d59bSQwzoKRNrRTk3GmGQa1akHWOA+qXcdeda9yB9XTacC3fkBunESBxR5dp8OMRf9dr7MqKSwULc21SDvlanDtNhAIFriFDv6G3AnvZG0uXhajZENtQ8FqQKK8CMCj5KWzMTXPyzCj7Hr6ECOqzsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sAF8FW0ouuTiz1brE2UvuwKiZ/5Pzu5V3/0vVf8cyVM=;
 b=V3tCXFc8WW4bVNsqLtJqB57DKyPsGIHkF6qqUqcdk3jw9ShRJAqaTeYLp35gc1mDCACjUE35aH82kvbrHlueuDRJhn/isS6NYph+s2C1W7I0lIjiPWxP4at1axRgqz354MVpi9Z1tNdLOmNM9yozaJbS+P5QtoakqL05WGfKltg=
Received: from CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9)
 by BN0PR10MB5502.namprd10.prod.outlook.com (2603:10b6:408:149::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Thu, 30 Jun
 2022 01:30:10 +0000
Received: from CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::3402:abab:e2f5:33bc]) by CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::3402:abab:e2f5:33bc%9]) with mapi id 15.20.5373.018; Thu, 30 Jun 2022
 01:30:10 +0000
Message-ID: <6950ed777656b35b3d635cd5fab45edfd2b2eb3f.camel@oracle.com>
Subject: Re: [PATCH v1 16/17] xfs: Increase  XFS_DEFER_OPS_NR_INODES to 4
From:   Alli <allison.henderson@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Wed, 29 Jun 2022 18:30:08 -0700
In-Reply-To: <YrydU/1ePnAmzUWm@magnolia>
References: <20220611094200.129502-1-allison.henderson@oracle.com>
         <20220611094200.129502-17-allison.henderson@oracle.com>
         <20220616215437.GF227878@dread.disaster.area>
         <a3b5a1eac6287e6faf8ec253f903bcfdd554e9b3.camel@oracle.com>
         <YrydU/1ePnAmzUWm@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0015.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::28) To CH2PR10MB4312.namprd10.prod.outlook.com
 (2603:10b6:610:7b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e12e66ff-12e4-4867-c49e-08da5a3812a2
X-MS-TrafficTypeDiagnostic: BN0PR10MB5502:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WMawZ8Z4EImq4PKwO+g945IEBph8Lnhe6AktcklCSN3Y9bIMwr5/s0Lyh6Lc8qwfrHQe0UbYvfqZZgFfaX5vl+m2NZe1AI0cIuZjSlJKf/ESAmJM6+wi4knGX3bVObLHJVgO/yHzx0K7FDJ3w3HqecYPRJPqcDUqNFzvKkaBifZfhM7X6KG87Fi4I+cGnej9OQKr+oEjNhjSehwLqXSHHHtanepw2Mc3/0gpsyzHpfgC6PKlRun5sOr+de5bkVNhS6pYdJLLxzPY436PHVmqpBphIN7wiag4lePFpGrSCkHiS2wp+MMUAornCnr3X2lBoWHO0cbRLU8m7GWcPU1DXwa08OIhAvxGYw2vcHm+NGwxR/cXQ7Q4M4jahorGY9UsQxi2RprFoHRcg/Y6G4K8t6uYP7B02f3rELsseIXe4KfHh1i9oVPGkU5MZvsKljQBKE2Bav2z3Qc5LVwJnWXZD2bycIEhtUdi4t7z14RBwy7h9+ysIQ99GzSVEGndWFMjRm3V0mfS3QHD+OuN8+wM8hH1JGXQufK+SlVzQJUsDWHtHjVtV36RdiTASJ80uQ3Y2fsFeBUvNsIYowVTpggrM5O/gs3dFWMl3lO+TFjv0uy/v0nqJEI2rcTnc/hGPNqtSmndqkPY0facFd8YazHM+rskWarog76FAxavi0EBcw7anM85XuqwSeGRXCelvVowpls4ThJ+AFX3LSiIXt60vRNROx4wiPiM0yDAQJnp8aCX3iCWUICfGUx7KdnUNNO4TmRLVTJYVGGeD6k69qz/rSnUa9KBf0IrKw9xw2mcgAU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4312.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(376002)(346002)(39860400002)(136003)(396003)(38350700002)(6486002)(86362001)(38100700002)(2906002)(8936002)(5660300002)(41300700001)(316002)(478600001)(8676002)(4326008)(66946007)(66556008)(66476007)(186003)(83380400001)(6506007)(52116002)(2616005)(26005)(6512007)(6916009)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U0U4OU41Ti9DaEw0TkQxblpuUzVEcVdYR0J3YXNtb2s5c3Y1cDBpWUVWeHdp?=
 =?utf-8?B?bFZXa216RERpUndOWUNZWDVsdEJVbENmK0tIdjQvc1FldWFzcFhsbnJZajRl?=
 =?utf-8?B?M1hpUVl0alFiai9LS2doMzhCTmM5KzhiMlIyS0h6cnB5a1c3Tms0QzQ0S2Uy?=
 =?utf-8?B?WkFyM21yNUtKaS9OazByR1BoTVZ3U3RBZVZxYkpvTUhkeDVSVS95MlRnUWlI?=
 =?utf-8?B?aDl5SlhTUjdFR0RYMjFCYzZuUVZid2YveWI3bnFUck8vMmtsRWY4R0E1VC9k?=
 =?utf-8?B?bnZaZ3cycGZsTkdOZEJTU0J2eVhRZE5JT2grVytuNnhSVjRIa0hqWE16cE9t?=
 =?utf-8?B?U2V0dDNiL1czQVg2bTgwRmorY29OTUlYellsQkx3eGxTcWdoUmFKS2VkQmxU?=
 =?utf-8?B?VmlLUXlwV1NNZjFhVW8zVWJsMzhHZjVtdjAxNDdJb2VyemhqZHg1eThBNWNG?=
 =?utf-8?B?QjdxbTZuZWN1ZHlTald3cnUzUndZcFBQeVkvSXp4bm5HVzJMUzFxRzlGRVl6?=
 =?utf-8?B?QUFPUUl5b0ZmT1M3K3F2Z0RqblFncWNGcEZKbWRGcmJFZkJxcUVSdWR0K1RT?=
 =?utf-8?B?cDR5Zk9OUGdOcnRhQStWV2IyWXk4QjI0ekpNd1h2UkFFS3NJbE5vQkhCczhh?=
 =?utf-8?B?blZXSUZFclFDeVM0cUJGZWwra05UOUxUQlNOYWJndGdGK1Y3ZUVMM3JoaGI5?=
 =?utf-8?B?V1V4UXAzNFZYVUxGV1hkMUdPbkU4eHRzVVE5RlAxRG45SzR1UDZET0xoQXhu?=
 =?utf-8?B?eUJ5a25tY2ZkQzJHK3BEWTN0WlhZMkFyajhrUkcxMmxRclUvbzJzSldzLzlN?=
 =?utf-8?B?cUZ4eDY0a09oeERVMjVycHREU0xRWFlvS2g2T3E2V0x2LytaV0FuK01hUEsw?=
 =?utf-8?B?TE1vc082SUJjTmtqVkgrRTExYnRyYjNXQzRSbUpEVzBqc1gzL3FjbUVnbmVo?=
 =?utf-8?B?OTNTRnFLWnQ1NWViNVhxYWZVcmJxaGJzc1hWV0o4M2FWUFBINjQveTBjR0gr?=
 =?utf-8?B?TWNUdVlZOWhpUmFlVjF6QXlnV2kvN0s0c3BObXFoczIvZzJUQzl0MWlLVkpw?=
 =?utf-8?B?SE5MRTJMS2pzcy85N1kxMSs1WkVqWHZORHkxUjNqZjVKVkh2S3FYcTRrWll5?=
 =?utf-8?B?SzNTUUFhTDUwbGR0QjRkZjZhTVJkOXNDbFJjOFdLTGJNMDBpTGprdm83Ulht?=
 =?utf-8?B?STRFaXFCMGZMSFVZS3VpYTloaHIzMEtUekNKdWR3Z0VqYjJQekxsKzZxNWJM?=
 =?utf-8?B?RlkxYU9DOEFyQThNUHlDNW9NTDJXN01DM1RiZGNPeFI0RDNHa3FLZEE3RmJq?=
 =?utf-8?B?V1BldUtnd0F0ZS9Ia2VxVDYwWnB6Zy80VjJ1YUQ3L1pzZDF4Vjl0Sm4yenN6?=
 =?utf-8?B?T1RqRkN5OVZERTRqYjlaMFlvOEg5enB2RnEzL1dSZlBZQnAvUXdKS3A2R0Jl?=
 =?utf-8?B?WloreFlKQXZFVHMxNjUxcFFmRDVaUjl0Z2JIaUlkOFdHUGtFMGp4MXU1M09O?=
 =?utf-8?B?VGRjVThIUXNnV21yY1lMSTBpZFpnZVpiU1BUUWRGOUpreFFDZysrS2g1VWxw?=
 =?utf-8?B?dXJIRjZNSTFzQjlmMWoxS3FVdlRFOCs2MWpieTVJOFlqWGtxNkI1UmVKTktV?=
 =?utf-8?B?b3Y4N3Jid0VtR3VDWVU5emJtK05EelBLTXdMeGlSd1NFS3cyMndVcXltWkNT?=
 =?utf-8?B?WFFGVDAzdVYrQzY1Rk1sKzVxRVduRC9sL3YrR1k1NVI2aDgyMmowNVFpcFRF?=
 =?utf-8?B?SFFxUHJxZXpJdFdleSttQ0VQdjkrTjdwYnpMUk4rZkNKV0JWb1VZK2tLUE16?=
 =?utf-8?B?QlI5WmFOWCt1MFJvcVIvK0ZFWG1VTU5DQU1QL3ZpL1FXeXZDUzRzU1NzRzlS?=
 =?utf-8?B?NnQ0VkdQN3dTOHRORFZIeDlIN1B1YlRjbGh0OU9rSzNLZ3JiY1FTdVJmZWY5?=
 =?utf-8?B?SStQVHQvanpleTFWNkF6cTFDTnVTM1djNVJBMjVyRVhVWncyTGd3WFpIVUI4?=
 =?utf-8?B?eHhEUGd5SzQ2NEkrcVBGdlYvTTV3NHZOV0Nxb0dILzh4Wnl6K3krcjgrTG5t?=
 =?utf-8?B?TkxVK2hZVlM3UlZzQ0dMYU5OU3dHMUlkOXFwRXlkY2ZKM3VJVVF2M0ZOVGk0?=
 =?utf-8?B?akVPTXBXOTQvc0xEelI2TUI2QmVjNnZxaVBKMXlBK09lem9PSzdhOTBoc2t2?=
 =?utf-8?B?K3c9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e12e66ff-12e4-4867-c49e-08da5a3812a2
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4312.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 01:30:10.4921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B4clWskYrOdEsX7mvkorv6mUhjhaRWxO82neKacQBZWyj/Ed+kI5WeaSmZr8v59skoKyZu4c/a5nH8dEp9ZndEZ+zLsaTnES/01UBq2fjSo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5502
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-29_24:2022-06-28,2022-06-29 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 phishscore=0 adultscore=0 malwarescore=0 bulkscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206300003
X-Proofpoint-ORIG-GUID: 8h5TaqBX8JmDezViShLpwjpSyCdn-M2C
X-Proofpoint-GUID: 8h5TaqBX8JmDezViShLpwjpSyCdn-M2C
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 2022-06-29 at 11:43 -0700, Darrick J. Wong wrote:
> On Fri, Jun 17, 2022 at 05:32:45PM -0700, Alli wrote:
> > On Fri, 2022-06-17 at 07:54 +1000, Dave Chinner wrote:
> > > On Sat, Jun 11, 2022 at 02:41:59AM -0700, Allison Henderson
> > > wrote:
> > > > Renames that generate parent pointer updates will need to 2
> > > > extra
> > > > defer
> > > > operations. One for the rmap update and another for the parent
> > > > pointer
> > > > update
> > > 
> > > Not sure I follow this - defer operation counts are something
> > > tracked in the transaction reservations, whilst this is changing
> > > the
> > > number of inodes that are joined and held across defer
> > > operations.
> > > 
> > > These rmap updates already occur on the directory inodes in a
> > > rename
> > > (when the dir update changes the dir shape), so I'm guessing that
> > > you are now talking about changing parent attrs for the child
> > > inodes
> > > may require attr fork shape changes (hence rmap updates) due to
> > > the
> > > deferred parent pointer xattr update?
> > > 
> > > If so, this should be placed in the series before the
> > > modifications
> > > to the rename operation is modified to join 4 ops to it,
> > > preferably
> > > at the start of the series....
> > 
> > I see, sure, I can move this patch down to the beginning of the set
> > > > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > > > ---
> > > >  fs/xfs/libxfs/xfs_defer.h | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > 
> > > > diff --git a/fs/xfs/libxfs/xfs_defer.h
> > > > b/fs/xfs/libxfs/xfs_defer.h
> > > > index 114a3a4930a3..0c2a6e537016 100644
> > > > --- a/fs/xfs/libxfs/xfs_defer.h
> > > > +++ b/fs/xfs/libxfs/xfs_defer.h
> > > > @@ -70,7 +70,7 @@ extern const struct xfs_defer_op_type
> > > > xfs_attr_defer_type;
> > > >  /*
> > > >   * Deferred operation item relogging limits.
> > > >   */
> > > > -#define XFS_DEFER_OPS_NR_INODES	2	/* join up to
> > > > two inodes */
> > > > +#define XFS_DEFER_OPS_NR_INODES	4	/* join up to
> > > > four inodes
> > > > */
> > > 
> > > The comment is not useful  - it should desvribe what operation
> > > requires 4 inodes to be joined. e.g.
> > > 
> > > /*
> > >  * Rename w/ parent pointers requires 4 indoes with defered ops
> > > to
> > >  * be joined to the transaction.
> > >  */
> > Sure, will update
> > 
> > > Then, if we are changing the maximum number of inodes that are
> > > joined to a deferred operation, then we need to also update the
> > > locking code such as in xfs_defer_ops_continue() that has to
> > > order
> > > locking of multiple inodes correctly.
> > Ok, I see it, I will take a look at updating that
> > 
> > > Also, rename can lock and modify 5 inodes, not 4, so the 4 inodes
> > > that get joined here need to be clearly documented somewhere. 
> > Ok, I think its src dir, target dir, src inode, target inode, and
> > then
> > wip.  Do we want the documenting in xfs_defer_ops_continue?  Or
> > just
> > the commit description?
> > 
> > > Also,
> > > xfs_sort_for_rename() that orders all the inodes in rename into
> > > correct locking order in an array, and xfs_lock_inodes() that
> > > does
> > > the locking of the inodes in the array.
> > Yes, I see it.  You want a comment in xfs_defer_ops_continue
> > referring
> > to the order?
> 
> I wouldn't mind one somewhere, though it could probably live with the
> parent pointer helper functions or buried in xfs_rename somewhere.
Alrighty, sounds good then

Allison
> 
> --D
> 
> > Thanks!
> > Allison
> > 
> > > Cheers,
> > > 
> > > Dave.

