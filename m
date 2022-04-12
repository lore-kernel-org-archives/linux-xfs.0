Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8248BC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Apr 2022 17:29:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358156AbiDLRbv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Apr 2022 13:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356122AbiDLRbr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Apr 2022 13:31:47 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C289555494
        for <linux-xfs@vger.kernel.org>; Tue, 12 Apr 2022 10:28:46 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23CHQdqM031973;
        Tue, 12 Apr 2022 17:28:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=vm3XKlTHRq57Fj18ndNbuTWyFMc+T7ZL8nlqAwHoJJ4=;
 b=U/XKpFhgfi1A6FFRO1VdYP8LEPGd5uMvbCELoTnqi1QpA4JTBunQaWCaAOLKvLu7yABA
 2QU/sj9ZF7NRhS1EqXPMDWe3g0fAK/x1+mrv0DJ9ecZadPhSZwGHIDtub7l+cSh6DLri
 we0n4f+SMwHGooxU+huft69H0kJsN4K5lDxVG1+UP6qqgHC7bwZ9jQzPtGRU9wb/Vpc4
 DhhGtJVkjn+wlP4jXbeKTjZI3bxvkeAiPhnd49TOigoitH2gU8+VQ6yF0bh3QsqWzll+
 f9Zy2vRr3066OSOr0AM5pPsB5Fp1tcGXgavLvFXZvTdOcth2MxxgB7GcJlm/7NZWPCh2 Iw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb0jd7bem-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 17:28:45 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23CHHTDu030456;
        Tue, 12 Apr 2022 17:28:44 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fb0k2vf0c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 17:28:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ymz9ye8ne7jmkCYe7+o26S78+R3grmCbs6HbuviF33/wiwnhEMxQ4rDGBAE8aqycig1nOHKBXLBqTVQ/FJAxjYO0t4yZlxH0bDkhg2aITXw1s22bUqLqVoDdt+lXGnLTkuLu+AQKzAFXZqPAQiJSr9ph7EjjEXUGGg4k6Yo0UwTzvuwLHQf6ykKfUn5QeIybDC9yGy5gkFa+fTnr0cJbxFo3FSYcAJp8CVTYJipl5y5K8BhKHvDDTCSc29/5+E8JHwHFVJMxUNpftuk2yxfiu3E1mtpxPO1qKWHtO8BBEaBQUSXZ2cPm4Tu9zyKxiQJrhvWXGoKFsrSll02r/bVABg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vm3XKlTHRq57Fj18ndNbuTWyFMc+T7ZL8nlqAwHoJJ4=;
 b=PgAX93MLHgIqNENgDN91m8y5YwSxWSXouDpM8siHoHkx39+XRKDvFqU3Pw0Hf9CzxMFzfHMY+swl64/Ch/04Uddgso3K/LYr2z+N7Vzlvcb5pGet8DA+PHo6N9qUOpPU/3WONv6UJle9nhDSHtfDWog9DSnwPfHIJbTPHhGOMrQHCrU/kGEqJMd1c2ERQG2zs8cz/GtxphB9FB/jCd6BQgHJTy2Te9gMPNWpzl1BpFr2rc6M7N/dmuueYhyisA9UHTcDw/DjfR+jcYp7QMB4oyu8MN4RDpEzUoJlrbczmXkv8IZ+RBQFQGd6y2yID8wJ6OwtnOoNAzhYLXTkEkUsrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vm3XKlTHRq57Fj18ndNbuTWyFMc+T7ZL8nlqAwHoJJ4=;
 b=Qd/8lP77ym7qx36n7tGjHsDcdF6WM7M0Jlc9EPyP2MrsB9jbo6AAh3EUIe0ZH6hrPzcoh8fquPrvH0XKC0Z7H/A1j+f1HHcsNrMfAjI/gTvdFhxwYSAy6pjh22s8nw9+3CCdilCPL37cQwfN8rsgWgAgF882i51T5lbBurDaxnM=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SN6PR10MB2783.namprd10.prod.outlook.com (2603:10b6:805:db::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Tue, 12 Apr
 2022 17:28:43 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::4cac:3ab1:a828:34ca]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::4cac:3ab1:a828:34ca%4]) with mapi id 15.20.5144.030; Tue, 12 Apr 2022
 17:28:43 +0000
Message-ID: <376113df5617a3cf949454f9ae986dd397dd1ef3.camel@oracle.com>
Subject: Re: [PATCH 00/10] xfs: LARP - clean up xfs_attr_set_iter state
 machine
From:   Alli <allison.henderson@oracle.com>
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Tue, 12 Apr 2022 10:28:41 -0700
In-Reply-To: <20220412104210.GJ1544202@dread.disaster.area>
References: <20220412042543.2234866-1-david@fromorbit.com>
         <20220412104210.GJ1544202@dread.disaster.area>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH0PR07CA0058.namprd07.prod.outlook.com
 (2603:10b6:510:e::33) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1f346601-571f-45d8-245e-08da1ca9e420
X-MS-TrafficTypeDiagnostic: SN6PR10MB2783:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB278330D9452ED573CFB006A195ED9@SN6PR10MB2783.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 83TsYrFL+sWkCNCKBoi8ISVKHoDgapVE+UQIy9Yy7E1/LP4ZMfbv1GUkX+GDs+HKc4+4PLRA2OPO0zaz0ai5ve7v7luqeNB1wjsHGChJKd10MOnP6zmKl3KNieGewumnTYq6/oxvsjX5zKQYWNlj2MiFHDBi8VQCFWAINGgpimVVwyTjhCEuWgo4opUuVJtZUNmQ6vhpHTeuHmjeO/H1RLUcwxEnM2/0/4tvIJ96CoRt2sFDoW0Lm8StYnDzDNXee4azmSOGjmkjUDROX2Ky5kpGHnxTrc6q1/dxAwUk7GiBUhjccHEmYwqzyQxVQAMKDMFSgAJ9z6kqqYKLUkU8CIgBSLr2piUWmh6Vx9ZfJx3IYYQgwyOTsaVGiJ7wihXl855tbNJM/EW1odPBlgt3leXHVRfs+s2V03FbxnlTFFeVA99jcmweHnCXVzAFSKex7whTZ4V0CA9bantSJzRYBPpcjT7z2wyyi+S1P37XMWyUBwdVXwMKikFZWXiBEQxNjYXM9euIEmMqlwlFxNGahvj2GkadedPTSvoeUCM5WI7gPP/ucI1uWCDv9iHK7YsKmGkK+tClvjDnfi5Z83sVsId4HFJ6zZtHmXKwVZ37GspLr90Mq0P4oU7bPjZ/5tG+Hrue4xILKvZ0qi18aYA+KPbgGmCnkm6eg5G4bZxyQFBEFXqDnqPA08bWBRiNFNj/iQNvJIRsv6eoi717vSfbXA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(52116002)(2616005)(26005)(38350700002)(38100700002)(186003)(2906002)(66556008)(8676002)(66946007)(66476007)(6512007)(36756003)(8936002)(86362001)(83380400001)(6486002)(6506007)(5660300002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Mml2ck1KRmJmUEZWWFk0KzRsZE1YVzVod2RPRkR1QkpjejdyTXhza0xPaUZy?=
 =?utf-8?B?czhxKzliWkhQenRhK1ZUZytqcStDUkppMFBLVFNQMGxRZ1BLN0V1SzUwNHYw?=
 =?utf-8?B?SFhWYjkzYXY2anJmb3lKUFBpSk1zQ1JoWXR3WjFxVmIwVzBXckJSUy9wdk9w?=
 =?utf-8?B?eEwvdDVhNVEzQk0xdC9YNEZkYlprKzBjR1RPdXJ2bW9mcjV4WHFSbmZkMENL?=
 =?utf-8?B?U0wzd21JaHRtQjBQT09vNUczQUJsRk41SHNHY21ERlpKQlRxMVJaU2x6Y3JH?=
 =?utf-8?B?eDBNOWdqUElRS0tKTDVBR29vVjlzZGoxUmdEdStISFhEWk9SMi9XbEJWcUZP?=
 =?utf-8?B?QWZPanJwMVF4UDlqVTA0amJCalNneVhGNWZ0QWphOWx4cytrZFk1VDl5NDUy?=
 =?utf-8?B?MDBGZXplbnBhT2ZBMjVUbUZqeWVBN3RqdWtxVTF1ekQ2YW9kMXdQZUNkajZo?=
 =?utf-8?B?ak05ckJYNjRFQ0c3SjNWTkVjVTNueFhCeFB3RGtUZGpRYWErOTJZL1ZMeDlt?=
 =?utf-8?B?b1FCR005d0hQeFo1dTU2WlZLWmdGc0xqVi9ZYk5kQ1d3bUZ0aUJsS0VjVkh4?=
 =?utf-8?B?bW4yekFPaEtUc254SWJHZlFHeFM2RkRVMklCVG12WjdBd1FUZHNWbENRUDFI?=
 =?utf-8?B?ZDlUQ0x6dUNOODROaUpycUdKQjgvcjlrd0ZKdHBBMjJ4Um53dXlWMk9IZytn?=
 =?utf-8?B?VlpDMkJtVTBtWVcyRk9sd2xqSVlSRHJSb1VqWXNHS3RlR2lGM2twemRkYjJp?=
 =?utf-8?B?UTlVRENOYkc5MjEvajgvdG1MSy92NDRDbDBhZ2xNd3BJbjJEKzh6UjZDOU13?=
 =?utf-8?B?bjl0aXFNNWM4L0o0SDRXaURlSVQ2QUlSUDFaK3JIQmwyeVNxaG9uMU1YUFRo?=
 =?utf-8?B?dEFWTWNEOC93a3hUR3hIREF6YU0rWTkyRUY1QkMzT3JaOGRJTUFXSmg2SlM1?=
 =?utf-8?B?d0Rpb3pGNm1rand0cTl0NDVER1gwM210ZFRpREM1Q1lFeUE5ejJGNm5EYnFl?=
 =?utf-8?B?enE2MHVrSmtPNzVaVkV0ekZZU1AyTWR6SlZJdjUvUWxwcXI0QmJ5a3ZrV1kw?=
 =?utf-8?B?RXRrNCt5ZC9RL2JjT05kR21GcDE3TjhodjduV0FZQVBpY1hnQ0dxZVR3d202?=
 =?utf-8?B?bS9IQm1mSTZTSDQvTGZWaXFHbW5XMld4VUMyRjY0SnV5bkxYOTk0dkEzUWVo?=
 =?utf-8?B?aDRFbjZxV0p1OTlzU1B4dEhUbXdHcndLditSM2hiZHd0VVQwakVHTW90dS91?=
 =?utf-8?B?UGpBaCttdjdYVXh1eGpYSmxJWU41S2tYNXdCUmxtZUphRWw5NDBCNjhua21I?=
 =?utf-8?B?REpoTmRYSE5VdXFEZEoxWTNnZXgraXFGOFBGb0hrSEI4bUxKWHBvK2Nac0I1?=
 =?utf-8?B?Uk1KakVGV1hkdlFoUHhqeGhkc1FkblY0TSt6SWtYUGswTkdpQXd3UWlGMU9I?=
 =?utf-8?B?Q0JzOTA3ejAwalVXNzV2THl0bldVVlRkbTdwSXFWK2xkNHZlcmZnaU1vbkIy?=
 =?utf-8?B?NGtWNzVENVBuTERLMUtHWXE4WGUzQXVvVzJ2OW1ud1lXeTJubmI3a3ZSRUl4?=
 =?utf-8?B?SURCT1l4WS9VelU1bkRJbXZDeitqeVRqbmUrTUcrMW1yL0hxT0RLZGdlMWtm?=
 =?utf-8?B?Vk02dFhEZ0hkSDZvL3RVL1ZHRWRVaGxwL0h2VjByY204M1drS1pQUWdRVVgr?=
 =?utf-8?B?VW11c3hSM1E5b0RhamVleVFJOFNwak1sZ2pqYmsrUGFOSnNRRm9YakJJUjlQ?=
 =?utf-8?B?ZURsRDVCZGNDL0J6OXRuS1VTblM4WGNreEpoOGV2RTFHOXkydW1SQTRuOFRT?=
 =?utf-8?B?dzFNNnNVWkEzZ1pPN09xVjBTSlhjelRMMDQxK1g1bUpCbGtwWXltNS9VQkV4?=
 =?utf-8?B?UWxNN3pJVGtxNVNySHNZaHBmMXV0bzF6d3hCai93YTZmL1cxY1VubWtjblA0?=
 =?utf-8?B?azVxUHBMYUgvL3orbENWTzlYZ2FNbXNzSzZwaEtLOWhVaFBUdlQ5dE9ub1JY?=
 =?utf-8?B?RTcvUHpjVDdscGZ5cXEvY01HR2VEaXhmMW95Y2NrSjAxS2MvVUljR1ZDZXRs?=
 =?utf-8?B?b0pPQ252dGVyUGR5SURaa2NEdm9XLy9GVG1Uekx3Y3l3Sm1rMFFJbG8xbSti?=
 =?utf-8?B?bWZlSHVidTBhaXhVSnlNN2JCMTl3dFRqSEIvWk8wRjBIcVF0TDU3TXpMRUhG?=
 =?utf-8?B?YVczdzl0RnV4eTlrbzdJVE1lVlAxNkUzQ0VBS1dTbnJTeVhFdnFsOCt4VGdz?=
 =?utf-8?B?WmhWTjJiYjhXSWlKM0NEcmFTSGhYTmpWa0pFL1lCc3RkVDlxVlNYelU2YVB1?=
 =?utf-8?B?YkN6QUZraUR6RUlYaDNUTm0yNFQzYVR1cE1CcS9hMHlBUGttRm04TVdRZEd3?=
 =?utf-8?Q?2EnnDZO+IlhZOma8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f346601-571f-45d8-245e-08da1ca9e420
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 17:28:43.0271
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6njw54uJuW0OVw1CtWuKQSW06cSU9siFpWv/4zcITy6GKzmqapujLiMJnsBBM5hCmNgxQj9xUhZNHfY0CLWKQWfpER0UMvgfAKMIR5NyvF0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2783
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-12_06:2022-04-11,2022-04-12 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 mlxscore=0
 bulkscore=0 phishscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204120082
X-Proofpoint-ORIG-GUID: rvtP_9pJYa5uOLC1SlljJMe4_7Cn2hSC
X-Proofpoint-GUID: rvtP_9pJYa5uOLC1SlljJMe4_7Cn2hSC
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 2022-04-12 at 20:42 +1000, Dave Chinner wrote:
> On Tue, Apr 12, 2022 at 02:25:33PM +1000, Dave Chinner wrote:
> > Hi Allison,
> > 
> > This is first patchset for fixing up stuff in the LARP code. I've
> ....
> 
> > The patchset passes fstests '-g attr' running in a loop when
> > larp=0,
> > but I haven't tested it with larp=1 yet - I've done zero larp=1
> > testing so far so I don't even know whether it works in the base
> > 5.19 compose yet. I'll look at that when I finish the state machine
> > updates....
> 
> With patch 11, larp=1 passes all but generic/642 - I screwed up a
> state change that affects the larp=1 mode, so there's small changes
> to
> patch 7 and rebasing for 8-10 as a result. Overall the code
> structure doesn't change, just the transition to REPLACE/REMOVE_OLD
> states.
> 
> I'm testing the updated series now - it seems like it is working in
> both larp=0 and larp=1 mode. I'll let it run overnight and go from
> them.
> 
> Cheers,
> 
> Dave.

Alrighty, I'll take a look at what you have so far and will wait until
I hear from you on this. Then we can run it through the delayed attr
tests.  If I can get pptrs on it as well, it's pretty good about
finding any bugs in the underlying attribute mechanics too.

Thanks!
Allison

> 

