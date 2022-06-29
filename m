Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B666EC43334
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 06:33:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232025AbiF2Gd6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 02:33:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230290AbiF2Gd5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 02:33:57 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFBA12B243
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 23:33:55 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25T4hx7m003672;
        Wed, 29 Jun 2022 06:33:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=FsQiYym5f5mIB5yYDfYG63eQwhXHvIYuj1i6+Pj3QN0=;
 b=M1geeVNd6Rs8zcSEc7uYOx7A9uBddaaE0dqZxmxplW8QspTE09Wpj/Y5jjUcQ/CSUDGA
 cjgYn7aGzAYS14iJ22yHj+oJwm2bsrmfVOtqnC0dMTv0Il/TEU2AICLuN5NdomaChoLU
 ABC75kv/7oDeyFcmrXVjSLPvbHBRlGnAIZKISAPqHcka19DfVUmhI8L4nwDK7r6wHnWQ
 /TeRMmQuOMKTpu747XwAW79hey7sbinx8b7PspkLNt6aNPDhMXpxbsniDdp9h/W8fbHx
 nP8qRUz9D5tfcEjCdbOQTyWpmbiSoWzKZu0FwZqTp5CHcRUE5cGLOqeiS8zNpAArKBsh ZA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gwrscg5ta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Jun 2022 06:33:54 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25T6UuBN025033;
        Wed, 29 Jun 2022 06:33:54 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gwrt8uats-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Jun 2022 06:33:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BbAi5KXfMAywHa6JlRYQfI0CyOOVcItCIt1n9+/O35qFmAtNRFKvlJ88qqeZH5nQ0XSQe/2rkUL+h293d1ujUrbRy6DBA457sJxDof+lflLe8Ziv5QiP45f/75VPQgrdM5Nf39/1p150aKmAeoTJZh/098OBQ+cQUkxlVjFMF3Rt9YQNyzsx8U1ucOt121hw47wPUy9kTUkwUlO9SpEZLV9S53elpbi2YgCG5C/YVa6zvMkFbF6lygb/X+SzRiwDFvTy3By0KQjSXqoKasJUbD0/TOCpJiGVg9HPMYBWlGtdiCXDNUqQJ45TTPCCK5F2Zf7EuRopyco2UOxExuqb4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FsQiYym5f5mIB5yYDfYG63eQwhXHvIYuj1i6+Pj3QN0=;
 b=Y/NlozJY2KuhjSraFlB9Tvezenj9zAhe4+6hpmZ4ClSXXOF9qQZjbPjaOlz0OXmh5GugOnQTgTgYiD8BcBX5JxvtPvihQ8w4lHc6S4RBQ6s6Yifi9sh4Ngq3nNFUoy2Fzr7a44HarZ31tlyjpRMuf+DhsF8Gp+4cKDEf0ji7pHiH7AiiLqtcLcL0gPnjic+f+7lPlguVChjFp5cgVGEC+uEaTIvWQAKJrI4hM+GTYRAGfs9udVlhsvUwiM0GDfS1qYLoIcj6cT+K/Jt2aqVEWxwWx+ZDZa9zhUG5Xvv6bO/QKYZixyj15oN1WccCumtlh0LzLRspUYuY1hASIwjpJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FsQiYym5f5mIB5yYDfYG63eQwhXHvIYuj1i6+Pj3QN0=;
 b=Cj72jw9BAhdqKmXnkrLINtonbeWoaohSPuTmEg/aaa54zCY0lTRutTWalqJyVX+AeW89nMXOp52Gi91dDWN2HXcanG8JhOO+Kbg6imxJgkewO5LKSA4qJp025RnKl1D55hZRyQCOEn4NhOHY51H6PfHLzJvSU5O+6c+88ntHR9Y=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by MN2PR10MB4302.namprd10.prod.outlook.com (2603:10b6:208:199::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.16; Wed, 29 Jun
 2022 06:33:51 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::30d4:9679:6a11:6f94]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::30d4:9679:6a11:6f94%9]) with mapi id 15.20.5373.018; Wed, 29 Jun 2022
 06:33:51 +0000
Message-ID: <362a6fa4525ec1c6229df729f9dc4eb5c5122c16.camel@oracle.com>
Subject: Re: [PATCH v1 01/17] xfs: Add larp state XFS_DAS_CREATE_FORK
From:   Alli <allison.henderson@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 28 Jun 2022 23:33:49 -0700
In-Reply-To: <20220616053246.GB227878@dread.disaster.area>
References: <20220611094200.129502-1-allison.henderson@oracle.com>
         <20220611094200.129502-2-allison.henderson@oracle.com>
         <20220615010932.GZ227878@dread.disaster.area>
         <fe4ec2a3959af674b29557d82dedd7924f36406c.camel@oracle.com>
         <20220616020843.GA227878@dread.disaster.area>
         <20220616053246.GB227878@dread.disaster.area>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR16CA0030.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::43) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 07ed7584-cd79-4b2f-f7c8-08da599954e1
X-MS-TrafficTypeDiagnostic: MN2PR10MB4302:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S9Ns9IveJZKP90G7jPFGecEV5rNaGNrO1tjeGBWwN7d4wbe6V6qajMraisy0JrFjuIguYsNecDeieOoQWLMtADi1I/N3AolEkRqMnnRcDbc9V/gG+1/8QFdkJQaKrs02OROVBU5ydDi2Uy7cqo0aV3rB575wvvT7g+/v30kmdjjO87gVPehfDMAnbikyDHFssStDCtpeCSm0um923Egws0ANQnXqL2IDx589vrz0QMRNxbQ+uI0BnW3zGKvCKxpvMiVsL9jjCgNEpjGnMgB7S26m5yWoiMJOvNKJDY5q1CV3e/O4bRaacw5vyBfwVhg28mfIAGDU12fhgwszBWQkwvRRnwgghrC70YriJpDIf1rKz17Gn4Fh0DShs8MgOSWKFzpLfRyjB8ssmdS/8N4HCqsZ7BRVNE5enrvwkgqsaOa0xBA9Xu3iKSuQjndArmZPwBg/nh6h7aqcq4xxV19WOmJ/wJ4hU8tlO3LsGszcKv8yIb9giqoz3vzsehCwDDPb+0Ew4zWRQyB8Rbr1ej/BZXOLEh6Zuyoz/3hDso8KBYDYdjAZ4b1VJaeL9ifNxce8OJ2hWGaSCZKGIxvZjXSscOpBQqu3DjVPugQbDAN8k+VN8sI8ygWBGhfamNgqaCWU9w8H7qLqeJcvbPnD90Be6TFJq2MWXcGCczWPxao6HX+hvgsidFyDNnoknHsGE2RZiVAcqxQ38vxHK7+f4ozgCdywajlaeHMQT+lVbdPWD7Rovx2crMUcDmchf/Mms6peGwJXIBY5IamVXTM/UFrsUYLLAqZuE41wpaA8QKF7a3ffEFGxxiDQEJ1hHa5mT18DrjUBmr5vSs6Lk7ztDvSUrgbFeZf+kZ0mQTgOuoU56Zc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(396003)(39860400002)(376002)(136003)(366004)(66476007)(966005)(8676002)(66556008)(4326008)(86362001)(5660300002)(6486002)(8936002)(186003)(83380400001)(38100700002)(66946007)(2616005)(478600001)(41300700001)(2906002)(36756003)(52116002)(30864003)(316002)(6512007)(38350700002)(6916009)(26005)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?enYyYWlLTU5iQlVPbitvNUFOcTVRd2Znbi9kQW1OTnVoc0Q0NWovZEVlWi9m?=
 =?utf-8?B?YWhSL245SWhCMnJNSVlUakl1MGxrdTVUT0JVMWx2aFRRUlM0YWNTT3V1TnJB?=
 =?utf-8?B?aFQ3d0lLOVZ1OEk2Y1Q0dk05UFVlUW52WXk1dXJ1TDlabjRzR3BOYnpoRHpw?=
 =?utf-8?B?YVhZSkEvdi94NE05UUdKejlqc3FwRWNJU0hXdjgzQ0lHdk5LTk4yRWltTHdC?=
 =?utf-8?B?ZlhQOGFGNEU3T2lxRkNkSVRRNVkzQjNIdUZtQjgwdm9lc0p6Wll4MHVsczIx?=
 =?utf-8?B?MUZFbWdvMEFDNjhGTk1tUXh5TnhyZWE3bWFYcHl3a0lYM2dnQVRkKzBUdTNs?=
 =?utf-8?B?ZlF5c2xhYzlQNHBFUEIrS09XZE8wTkpOdkJQK0FtTm1SSWt5QURlbXYrL0Za?=
 =?utf-8?B?alZjdGg2WkdvSTJWeFVtTStZNVZxTXZ2QnF5bUl5bUR5WmZ3ZGxoa0pMc1Fl?=
 =?utf-8?B?S1hnRUwrbVgxTzFvbHgvL3BHa0orbDR0YzhrOFFZVmRSb0FjT2pKRG5TUVlx?=
 =?utf-8?B?MFdDWmZCVGU3M3lYbE00cTRIOExiRW1pRk1UdmVrUVZOZnpPZ21pNWc4cXVV?=
 =?utf-8?B?SE5Sanl4VW10N0haNHBwbUtYamQvUGZUeGRzTUVwT1dyUmhiaktaNFRDK0Ji?=
 =?utf-8?B?SUEvMHJjbUcyYjNvOXNiekJCVnV1NmJsTW1PdlVOcHloQmJoUThqTVdMWlJU?=
 =?utf-8?B?Zm9pU3ArUXRoWCtuNHJ0cm9mUFRyWFJUUDhrR2xtQmpNeHdYNjVkeUkrRHhO?=
 =?utf-8?B?N0xkUE9CelV0dFdTNG4yUDMxY01FS2oydUZEUy92cjhEWWozWWgrMHpvaXpT?=
 =?utf-8?B?RE1Lc1dIZzhYRFRzbDYrNWNyWmlCOGpCK1g1ZmRsMDQ5MGNMbkVoZllNZG96?=
 =?utf-8?B?M1RSd2RDUGV2UGZIdGgxdi8xdloyS0J2SWU5VjNQaVltOTJUVm9wY284bWFW?=
 =?utf-8?B?eTU3cXk0M2JWSzFYR2NqbGxac210Sk11Vk1nN2lGd1VqNXpGbEJieTRSdmFZ?=
 =?utf-8?B?WXFzQm8vY1ZoRndBSWR6NzBxMlZxRXlqN2RMQ1E5Ri91UG1HcWRQU2s0SUdh?=
 =?utf-8?B?RmE2K0xJVXlhMzJ0TlVYczJuM1ZPOVUxMmdYZFA1UFMzTFE0bHArbGRRV3Ev?=
 =?utf-8?B?Nk1DNm9VR3ZoWGJRQ1NmaUFVdWpxd1lMMDFKLzVwQjk0OVhMYUZ6UVZPTldC?=
 =?utf-8?B?YjBYNGVBb0VrdVpxdlpmazQ2dmI4bnBzdkhPeHlZa0RzRVllemt6citXK2wv?=
 =?utf-8?B?cVA1emh0VTBsSDdFWHlaQ21vZCtUa3lCT05QYkVpS1lzU3ZIMXJwU1B1ZGlB?=
 =?utf-8?B?V1JmakJMcEl6cHltVUZHMHcvQ0U2Q3R3ZFdjNEZPbyswYkFTOGhHZUVyNUZv?=
 =?utf-8?B?TDZRRnVzVWRueitaNXlOTHptd1U5dFZDL25vUUM1THJJWUgwV3ZOTnJTUnBz?=
 =?utf-8?B?dDJNN0thbk9XMkJNS2ZOWlRReHl1TG1vb3JxWmxnbVBsMkorMVBzNS9mYTY4?=
 =?utf-8?B?Zjl1b2JCSTlwb2xnUUVtNDJVT3NhY3Y5RGt1RWx5YTRJeXJJSHJ2ZHpJcDY4?=
 =?utf-8?B?NU1OQ2xnZnZxSHAxaTBDcUdiSm5NWE1GRkJLQmxLdGxuRUZlbEkzZXpQcDBE?=
 =?utf-8?B?MFdvUVN0Nkp2c1doRk9UTDU4MWkrSmlDNnZQUUowaVBBSFozMjl6NnVzTmc0?=
 =?utf-8?B?a3l2WFAzRENtb2J5bFFLMmIwMGZhcENReU55NnpVTENOVmpXeTFQS0xUT2Jv?=
 =?utf-8?B?WW1ldTVYbC93RmJjZW90RHUvelNqbnJqY2RHVXRSK040TjZkMzFGUEluOXBI?=
 =?utf-8?B?QWdtQTBTalZpbFpmSTFTNm91TGF4Tytwd0dEaEUvTy9JUHorQktMV0c1aW5X?=
 =?utf-8?B?VWRJVTNmRnBnOExjNGV1dkNJUEpMZkJSTG0rMXNMTXVpVkdMK1gyZ0p3UDZh?=
 =?utf-8?B?WjU5MzI5aXFnd3NjUit3VWxjSjZMNlNrQ3RjNHZQaUJWUXFiZloyOHFpejlE?=
 =?utf-8?B?WHd5WTE2U0duTDVFZkNDWklreEUwVG9mWm5ySE9EdWdBbC9peGxYRGhPaC90?=
 =?utf-8?B?VTNic2dXVXNrTmw5ZzI3d1FLWmNvemExWHlKVFlLejZIRWdRdXFTcHV0TVJ5?=
 =?utf-8?B?SURETzF0ZU8ySEpsbDZreThhQllvakZCY3pOR1FtTzc4bFZqTjhXbUN6eGVK?=
 =?utf-8?B?SHc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07ed7584-cd79-4b2f-f7c8-08da599954e1
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2022 06:33:51.7757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 15XoXVr/1QeH4JpqZ7tRxb+hYSTVuoY7TWBLZIuFxfzU8QlF5MTYQLrqGEQgrE+mFsHAhCuhi99Q7vZzCuHcVekUxyOGEi+V99QgbbJrJY0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4302
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-28_11:2022-06-28,2022-06-28 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206290023
X-Proofpoint-ORIG-GUID: mhcTVfmsVAPf3IiD1aS_xSEtc9F_K7jD
X-Proofpoint-GUID: mhcTVfmsVAPf3IiD1aS_xSEtc9F_K7jD
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, 2022-06-16 at 15:32 +1000, Dave Chinner wrote:
> On Thu, Jun 16, 2022 at 12:08:43PM +1000, Dave Chinner wrote:
> > On Wed, Jun 15, 2022 at 04:40:07PM -0700, Alli wrote:
> > > On Wed, 2022-06-15 at 11:09 +1000, Dave Chinner wrote:
> > > > On Sat, Jun 11, 2022 at 02:41:44AM -0700, Allison Henderson
> > > > wrote:
> > > > > Recent parent pointer testing has exposed a bug in the
> > > > > underlying
> > > > > larp state machine.  A replace operation may remove an old
> > > > > attr
> > > > > before adding the new one, but if it is the only attr in the
> > > > > fork,
> > > > > then the fork is removed.  This later causes a null pointer
> > > > > in
> > > > > xfs_attr_try_sf_addname which expects the fork present.  This
> > > > > patch adds an extra state to create the fork.
> > > > 
> > > > Hmmmm.
> > > > 
> > > > I thought I fixed those problems - in xfs_attr_sf_removename()
> > > > there
> > > > is this code:
> > > > 
> > > >         if (totsize == sizeof(xfs_attr_sf_hdr_t) &&
> > > > xfs_has_attr2(mp)
> > > > &&
> > > >             (dp->i_df.if_format != XFS_DINODE_FMT_BTREE) &&
> > > >             !(args->op_flags & (XFS_DA_OP_ADDNAME |
> > > > XFS_DA_OP_REPLACE))) {
> > > >                 xfs_attr_fork_remove(dp, args->trans);
> > > Hmm, ok, let me shuffle in some traces around there to see where
> > > things
> > > fall off the rails
> > > 
> > > > A replace operation will have XFS_DA_OP_REPLACE set, and so the
> > > > final remove from a sf directory will not remove the attr fork
> > > > in
> > > > this case. There is equivalent checks in the leaf/node remove
> > > > name
> > > > paths to avoid removing the attr fork if the last attr is
> > > > removed
> > > > while the attr fork is in those formats.
> > > > 
> > > > How do you reproduce this issue?
> > > > 
> > > 
> > > Sure, you can apply this kernel set or download it here:
> > > https://urldefense.com/v3/__https://github.com/allisonhenderson/xfs/tree/xfs_new_pptrs__;!!ACWV5N9M2RV99hQ!O7bhq9bR_z2xjlhlwWb78ZXwzigOh6P8V3_EkeL9AHFOpdYdr_irAwUocygT_G8LI-lKDL5_01Df49lTy27a$ 
> > > 
> > > Next you'll need this xfsprogs that has the neccassary updates to
> > > run
> > > parent pointers
> > > https://urldefense.com/v3/__https://github.com/allisonhenderson/xfsprogs/tree/xfsprogs_new_pptrs__;!!ACWV5N9M2RV99hQ!O7bhq9bR_z2xjlhlwWb78ZXwzigOh6P8V3_EkeL9AHFOpdYdr_irAwUocygT_G8LI-lKDL5_01Df4w3Mct8F$ 
> > > 
> > > 
> > > To reproduce the bug, you'll need to apply a quick patch on the
> > > kernel
> > > side:
> > > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > > index b86188b63897..f279afd43462 100644
> > > --- a/fs/xfs/libxfs/xfs_attr.c
> > > +++ b/fs/xfs/libxfs/xfs_attr.c
> > > @@ -741,8 +741,8 @@ xfs_attr_set_iter(
> > >  		fallthrough;
> > >  	case XFS_DAS_SF_ADD:
> > >  		if (!args->dp->i_afp) {
> > > -			attr->xattri_dela_state = XFS_DAS_CREATE_FORK;
> > > -			goto next_state;
> > > +//			attr->xattri_dela_state =
> > > XFS_DAS_CREATE_FORK;
> > > +//			goto next_state;
> > >  		}
> > 
> > Ah, so it's recovery that trips this....
> > 
> > > [  365.290048]  xfs_attr_try_sf_addname+0x2a/0xd0 [xfs]
> > > [  365.290423]  xfs_attr_set_iter+0x2f9/0x1510 [xfs]
> > > [  365.291592]  xfs_xattri_finish_update+0x66/0xd0 [xfs]
> > > [  365.292008]  xfs_attr_finish_item+0x43/0x120 [xfs]
> > > [  365.292410]  xfs_defer_finish_noroll+0x3c2/0xcc0 [xfs]
> > > [  365.293196]  __xfs_trans_commit+0x333/0x610 [xfs]
> > > [  365.294401]  xfs_trans_commit+0x10/0x20 [xfs]
> > > [  365.294797]  xlog_finish_defer_ops+0x133/0x270 [xfs]
> > > [  365.296054]  xlog_recover_process_intents+0x1f7/0x3e0 [xfs]
> > 
> > ayup.
> > 
> > > > > Additionally the new state will be used by parent pointers
> > > > > which
> > > > > need to add attributes to newly created inodes that do not
> > > > > yet
> > > > > have a fork.
> > > > 
> > > > We already have the capability of doing that in
> > > > xfs_init_new_inode()
> > > > by passing in init_xattrs == true. So when we are creating a
> > > > new
> > > > inode with parent pointers enabled, we know that we are going
> > > > to be
> > > > creating an xattr on the inode and so we should always set
> > > > init_xattrs in that case.
> > > Hmm, ok.  I'll add some tracing around in there too, if I back
> > > out the
> > > entire first patch, we crash out earlier in recovery path because
> > > no
> > > state is set.  If we enter xfs_attri_item_recover with no fork,
> > > we end
> > > up in the following switch:
> > > 
> > > 
> > >         case XFS_ATTRI_OP_FLAGS_REPLACE:
> > >                 args->value = nv- >value.i_addr;
> > >                 args->valuelen = nv- >value.i_len;
> > >                 args->total = xfs_attr_calc_size(args, &local);
> > >                 if (xfs_inode_hasattr(args- >dp))
> > >                         attr->xattri_dela_state =
> > > xfs_attr_init_replace_state(args);
> > >                 else
> > >                         attr->xattri_dela_state =
> > > xfs_attr_init_add_state(args);
> > >                 break;
> > > 
> > > Which will leave the state unset if the fork is absent.
> > 
> > Yeah, OK, I think this is because we are combining attribute
> > creation with inode creation. When log recovery replays inode core
> > modifications, it replays the inode state into the cluster buffer
> > and writes it. Then when we go to replay the attr intent at the end
> > of recovery, the inode is read from disk via xlog_recover_iget(),
> > but we don't initialise the attr fork because ip->i_forkoff is
> > zero.
> > i.e. it has no attrs at this point.
> > 
> > I suspect that we could catch that in xlog_recover_iget() when it
> > is
> > called from attr recovery. i.e. we detect newly created inodes and
> > initialise the attr fork similar to what we do in
> > xfs_init_new_inode(). I was thinking something like this:
> > 
> > 	if (init_xattrs && xfs_has_attr(mp)) {
> > 		if (!ip->i_forkoff && !ip->i_nextents) {
> > 			ip->i_forkoff = xfs_default_attroffset(ip) >>
> > 3;
> > 			ip->i_afp =
> > xfs_ifork_alloc(XFS_DINODE_FMT_EXTENTS, 0);
> > 		} else {
> > 			ASSERT(ip->i_afp);
> > 		}
> > 	}
> > 
> > Would do the trick, but then I realised that the timing/ordering is
> > very different to runtime: we don't replay the attr intent until
> > the
> > end of log recovery and all the inode changes have been replayed
> > into the inode cluster buffer. That means we could have already
> > replayed a bunch of data fork extent modifications into the inode,
> > and so the default attr offset is almost certainly not a safe thing
> > to be using here. Indeed, there might not be space in the inode for
> > the attr we want to insert and so we might need to convert the data
> > fork to a different format before we run the attr intent replay.
> 
> Ok, so after further thought, I don't think this can happen. If we
> are replaying an attr intent, it means we crashed before the intent
> done was recorded in the log. At this point in time the inode was
> locked and so there could be no racing changes to the inode data
> fork in the log. i.e. because of log item ordering, if the intent
> done is not in the log, none of the future changes that occurred
> after the intent done will be in the log, either. The inode on disk
> will not contain them either because the intent done must be in the
> log before the inode gets unpinned and is able to be written to
> disk.
> 
> Hence if we've got an attr intent to replay, it must be the last
> active modification to that inode that must be replayed, and the
> state of the inode on disk at the time of recovering the attr intent
> should match the state of the inode in memory at the time the attr
> intent was started.
> 
> Hence there isn't a consistency model coherency problem here, and
> that means if there's no attr fork at the time the attr recovery is
> started, it *must* be a newly created inode. If the inode already
> existed and a transaction had to be run to create the attr fork
> (i.e. xfs_bmap_add_attrfork() had to be run) then that transaction
> would have been recovered from the log before attr replay started,
> and so xlog_recovery_iget() should see a non-zero ip->i_forkoff and
> initialise the attr fork correctly.
> 
> But this makes me wonder further. If the attr intent is logged in
> the same transaction as the inode is allocated, then the setting of
> ip->i_forkoff in xfs_init_new_inode() should also be logged in that
> transaction (because XFS_ILOG_CORE is used) and hence be replayed
> into the on-disk inode by recovery before the attr intent recovery
> starts. Hence xlog_recover_iget() should be initialising the attr
> fork through this path:
> 
> xlog_recover_iget
>   xfs_iget
>     xfs_iget_cache_miss
>       xfs_inode_from_disk
> 	if (ip->i_forkoff)
> 	  xfs_iformat_attr_fork()
> 
> This means the newly allocated inode would have an attr fork
> allocated to it, in extent format with zero extents. If we then look
> at xfs_inode_hasattr():
> 
> int
> xfs_inode_hasattr(
>         struct xfs_inode        *ip)
> {
>         if (!XFS_IFORK_Q(ip))
>                 return 0;
>         if (!ip->i_afp)
>                 return 0;
> > > > > >   if (ip->i_afp->if_format == XFS_DINODE_FMT_EXTENTS &&
> > > > > >       ip->i_afp->if_nextents == 0)
> > > > > >           return 0;
>         return 1;
> }
> 
> It would still say that it has no attrs even though the fork has
> been initialised and we go down the xfs_attr_init_add_state()
> branch.  This does:
> 
> static inline enum xfs_delattr_state
> xfs_attr_init_add_state(struct xfs_da_args *args)
> {
>         /*
>          * When called from the completion of a attr remove to
> determine the
>          * next state, the attribute fork may be null. This can occur
> only occur
>          * on a pure remove, but we grab the next state before we
> check if a
>          * replace operation is being performed. If we are called
> from any other
>          * context, i_afp is guaranteed to exist. Hence if the attr
> fork is
>          * null, we were called from a pure remove operation and so
> we are done.
>          */
> > > > >    if (!args->dp->i_afp)
> > > > >            return XFS_DAS_DONE;
> 
>         args->op_flags |= XFS_DA_OP_ADDNAME;
>         if (xfs_attr_is_shortform(args->dp))
>                 return XFS_DAS_SF_ADD;
>         if (xfs_attr_is_leaf(args->dp))
>                 return XFS_DAS_LEAF_ADD;
>         return XFS_DAS_NODE_ADD;
> }
> 
> Which would return XFS_DAS_DONE if there was no attr fork
> initialised and recovery would be skipped completely. Hence for this
> change to be required to trigger failures:
> 
> > > @@ -741,8 +741,8 @@ xfs_attr_set_iter(
> > >             fallthrough;
> > >     case XFS_DAS_SF_ADD:
> > >             if (!args->dp->i_afp) {
> > > -                   attr->xattri_dela_state =
> > > XFS_DAS_CREATE_FORK;
> > > -                   goto next_state;
> > > +//                 attr->xattri_dela_state =
> > > XFS_DAS_CREATE_FORK;
> > > +//                 goto next_state;
> > >             }
> 
> then it implies the only way we can get here is via a replace
> operation that has removed the attr fork during the remove and we
> hit this on the attr add. Yet, AFAICT, the attr fork does not get
> removed when a replace operation is in progress.
> 
> Maybe there's a new bug introduced in the PP patchset that triggers
> this - I'll do some more looking...
> 
> > > > This should avoid the need for parent pointers to ever need to
> > > > run
> > > > an extra transaction to create the attr fork. Hence, AFAICT,
> > > > this
> > > > new state to handle attr fork creation shouldn't ever be needed
> > > > for
> > > > parent pointers....
> > > > 
> > > > What am I missing?
> > > > 
> > > I hope the description helped?  I'll do some more poking around
> > > too and
> > > post back if I find anything else.
> > 
> > Yup, it most definitely helped. :)
> > 
> > You've pointed out something I had completely missed w.r.t. attr
> > intent replay ordering against replay of data fork modifications.
> > There's definitely an issue here, I think it might be a fundamental
> > issue with the recovery mechanism (and not parent pointers), and I
> > think we'll end up needing  something like this patch to fix it.
> > Let me bounce this around my head for a bit...
> 
> In summary, after further thought this turns out not to be an issue
> at all, so I'm back to "replace doesn't remove the attr fork, so
> how does this happen?"....
Just a follow up here...

So, I think what is happening is we are getting interleaved replays.
When a parent changes, the parent pointer attribute needs to be
updated.  But since this changes the attribute name, it cant be an attr
replace.  So we queue up an attr set and then a remove (in xfs_rename).
The test case sets the inject which starts a replay of a set and
remove.  The set expands the leaf, and bounces out the EAGAIN
into xfs_attri_item_recover.  We then fall into this error handling:

        ret = xfs_xattri_finish_update(attr,
done_item);                        
        if (ret == -EAGAIN)
{                                                   
                /* There's more work to do, so add it to this
transaction */    
                xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_ATTR, &attr-
>xattri_list);
        }

Which I think is queuing up the rest of the set operation, but on the
other side of the remove operation.  The remove operation removes the
fork, and we get the null pointer when the set operation resumes.

I havnt quite worked out a fix yet, but I'm pretty sure that's the
problem description....  I think what we're going to need is some sort
of defer_push operation or something similar.

Allison

> 
> Cheers,
> 
> Dave.
> 

