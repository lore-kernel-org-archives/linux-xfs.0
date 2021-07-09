Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F352C07E9C
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Jul 2021 23:39:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2637F613C8
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Jul 2021 23:39:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbhGIXmE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Jul 2021 19:42:04 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:18132 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230082AbhGIXmE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Jul 2021 19:42:04 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 169NUiuF005804;
        Fri, 9 Jul 2021 23:39:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=FV7dJqizvgvj3dIfRNxXBPCtM8NZa9aoYMW8drbMg7M=;
 b=kqlj0yNS4Zb9o0Ts5q+yo7wyxEZqE12aM89MtT3ujbvHRxf+S2IgyGxgIflkdHyZtAvw
 9SAY7sqVNCmJVSlvvQIJCcAsP3i9T4tjlnXcmWLq1e3qNJQipqskrUetdNkr70jwdht4
 F78dT4YiZBWWJ438Zkl+G94HHWOCOfsGgkHinL6sj+IUBvSkpJhQA/zunPLID8HXchb6
 MJ4PEHQTjRoqnWqEm4n3KXm2ai3l0yNVmAhqiV0kSFxQ6gqL2h1AqEWBXWfcI1EbUaAP
 Q9uWHz6TpcAXQcIZQ2nOuTHYV9igiR7ec6jEtbRgIH93n1l7TyRwTzMYVWL910oPV54C Nw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 39pte5ght0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Jul 2021 23:39:16 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 169NUhuK099824;
        Fri, 9 Jul 2021 23:39:15 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by aserp3030.oracle.com with ESMTP id 39nbgar6hb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Jul 2021 23:39:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=asaZJOYoqLXKzYq+zGgPb4Jp6Y/SqIE7J4gghERwOZVDKCzTRWKrD6D0ZgP2Um0LMODdKbmSEYhY8DNJiNkFrLo3Bv9g8Zo5986mU25VDe8Gk6VLkEEQ3fqsCpUNT2jMpKH2tQLU1sMi9sRgmvhtgETF3j1vG8fvT4QxAF15J355OXL4SeDe6OazaNDBLXVHINSD9AGTytg9tpOwNkwjRGAuFR/6NDZLIfUkkH35r805R0h9YLQW56aql9Pr6/X1OVr62akPT6QCgqx6b5Y4sjK7ntcpt0Zr9L7dvL+z8qxMyMdCjmctPVQ3+O9dabWcEzcTi3cGzzMPLyQtjs5x4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FV7dJqizvgvj3dIfRNxXBPCtM8NZa9aoYMW8drbMg7M=;
 b=exC+IjF/9nSFV+BPnGaqVB0dnOig1ygzQ55kYpd/ihOciGUkIIM5N/5ucif1fsxzM6SkC8Fa6v4x76PbMVU0qiXwck2Nyv0OIXBIG+ccSkutX6IgI74nuXcv/lcO0YWtz6MS41EnzVHLiZY6QhbLC741szxLNVhrdN3O55zcgTnf4GSJzf7ls39E96yBQYjpNESOGYwYwPg09ZqCrGikxlidN5J1g1m/+1e5+lzZAAbBDNaaiV/dIj0Z0WedM2nBsAtYXdjjhyBzX2uSe+F7JidtaxA4/Kb1HNJPVxvpOHYa6ul6m4N/jkDuajd4B1y1udGv4XBF4Eu2ttp/7ydVrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FV7dJqizvgvj3dIfRNxXBPCtM8NZa9aoYMW8drbMg7M=;
 b=VtIBh93W+YG4PGiP9w22tqSDPjwqm/t2bCyzvkPMAOIRFcBWarU+kf+EiO8vjX/tDoQxAB0hhnkHXbNObZYyaAvmBIc2Th3oYBe5DbDqQUSXKuSbjHvUiALAzTEffjAo2gMVi3w9xjoRHnfjY5ZBlRA9x1/ULTAb0JlM/mY1aVA=
Authentication-Results: eryu.me; dkim=none (message not signed)
 header.d=none;eryu.me; dmarc=none action=none header.from=oracle.com;
Received: from CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9)
 by CH0PR10MB5100.namprd10.prod.outlook.com (2603:10b6:610:df::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.22; Fri, 9 Jul
 2021 23:39:14 +0000
Received: from CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::807e:3386:573c:ad06]) by CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::807e:3386:573c:ad06%5]) with mapi id 15.20.4308.023; Fri, 9 Jul 2021
 23:39:14 +0000
Subject: Re: [PATCH 4/8] dmthin: erase the metadata device properly before
 starting
To:     "Darrick J. Wong" <djwong@kernel.org>, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
References: <162561726690.543423.15033740972304281407.stgit@locust>
 <162561728893.543423.5093723938379703860.stgit@locust>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <39ea112f-7565-e3e2-d101-1bbe85eaa96f@oracle.com>
Date:   Fri, 9 Jul 2021 16:39:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <162561728893.543423.5093723938379703860.stgit@locust>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR16CA0025.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::38) To CH2PR10MB4312.namprd10.prod.outlook.com
 (2603:10b6:610:7b::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.167] (67.1.112.125) by BY5PR16CA0025.namprd16.prod.outlook.com (2603:10b6:a03:1a0::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.19 via Frontend Transport; Fri, 9 Jul 2021 23:39:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d05e8c0c-c4f8-40d6-510b-08d94332c27a
X-MS-TrafficTypeDiagnostic: CH0PR10MB5100:
X-Microsoft-Antispam-PRVS: <CH0PR10MB51002B728CD4D663A91ACA4395189@CH0PR10MB5100.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9Z7x70QCi2P6LnncQj5YiI1G/iBJPma+LSNXOpTz0OApJ1dBckxyEH+WFL8NF86UbiByJb3AjjENvOLiQJwZiqXCBg92yI0NWOle6mjtm++NeUsDdu61XX9Vdk7l81jKs5qIVZDPK8L6UCL+9L8k9Lse7mBnxLJTRuWrXQQBbRtfK7dcPdus7nuFLjDsi7PI5WhpQzuxw7nPJPuNxU507xaQ77DUEalCgOoeTN/V7KS0QNTieIqAqSzLEOUxy5YcPEIXFq6I4uWMPfYR8vbcfhZH5LRSO6qtVkMsrCvAjTgRSaLh7jeOYxtWmz3MeE3p0mBbjlcMPnOqMtUaG3arnJxg/slhreOFc5ABlDeU381u+P7vYpYl71k2bNcawlCpIjEVW2PwGD2f9XeXPt0BkYDgCFCNvDmyxv3d3b6ufDDuoujntcFDkNP+gZ7V8CtiL5vR1BMXmiVNIuJvu4Q79Dui8OIJIaCH4VuVRgaetrODKXR176SorhTp+4Hc9IBMZxgBZy/C498mywKSRB1A9RVT2vy+YoCmp12X3qGABfA9M0cjFNamUXOUye9AHvcGSY4GzNM7vzgWJqgtB+eMbDtzX772t5ZoJp9HaGSRHgkoCa7/hRhFt2I2PRAwqhk3z/h8SaaeKHfkRDkMhh0gF98i0GQnzr2H0UV5NE5cW23f3cjiyf1HJVtfhbPt/SOUvzjYQzDYDn+aLQmf7vlj3tYhXO7MWGIGoJ3kqC3Etkal+cRmG3NH6p5WRMthWphPFv+qiALLH5xNNnUWLwQK4w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4312.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(346002)(39860400002)(376002)(396003)(83380400001)(316002)(31696002)(8676002)(44832011)(26005)(186003)(86362001)(16576012)(31686004)(36756003)(52116002)(478600001)(66476007)(66556008)(4326008)(956004)(53546011)(6486002)(2616005)(66946007)(38100700002)(38350700002)(5660300002)(2906002)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?emQ5QkZwV3FmcDJ0Zkl1YmlGMjMvNy9SWUhjOUlDUUYrVm5hQkp0a25FMEF5?=
 =?utf-8?B?UFZNMXlSUnVTN2kreXg2Rm5TQ0Y0RXAvQTZ5L0YzNDJISE5tR2pqTFk4YTVW?=
 =?utf-8?B?aTgzNHFaRGNqclhUV05vcitjdGhXMkxNRjB6d2wzN2lRT2pQZHcrZXZSMGVm?=
 =?utf-8?B?SmJKQUpmT29PL0pHZkJkVUcvTG1Td0FkeXN4NUpKeXV5TWl6VTQrUG5jM1NX?=
 =?utf-8?B?Y1hCbjVpMnltNmJPNDhFeklvRG16eE1seURYQ1BvYTlJd29lenRMYnJRSkc4?=
 =?utf-8?B?aFhMWFU4MUZ4K2RudVBnTUNUa1JucXJodkdHaWtHTHlGZlhEVnhKZFgvQ2NM?=
 =?utf-8?B?WG1oUWtFUHViTVcwUklHYUh4YStTVzdGWmgrT1kwL0RGQVBSaUFGZ2IvV2Mv?=
 =?utf-8?B?a1g5amJpbW5DN3RXRTRRbWpKMnJNcmhTaWJXWDBnUzllc0liNkRUY3JmTlBZ?=
 =?utf-8?B?NHF3dkVOZkY5RW9xcGJLek9WdHFHWTJUbzZUNnBQMXJpUDVvbXlFNmFpUEhj?=
 =?utf-8?B?QlhWVFdtZTFhUTZyTGtKcU1SMVZNNWhHNFExMTlYVy85U1FhOGMzZ3ZEVkVy?=
 =?utf-8?B?eXpaSHJ6OHhWcHFmZHM3Szk4QXNWQkwzTkZLSm51S1JscUFTbWl1SEVEMDBq?=
 =?utf-8?B?cGY3WU5wYVlBTk94eEkzYTNXSjFUdDNvVVJtSU9oRzVHMGtRdk9xZVFFMTF2?=
 =?utf-8?B?RVlnNVo5azQzOVEzcGxwNWtBbEt1Z0ZKbFRYcmhoRXU1MFgxUURVT1hmTWZL?=
 =?utf-8?B?L3pBZDdjai9EOXROSkNFRyswYzgwSEhYTHZmc09mdks5YkFSaWR0c29yeVZD?=
 =?utf-8?B?aUI4RTN2enpPRm5ZT3Q2Q3NLNG9RYXpQNWt2Uy9rbSt0dm4vTmVKVGtZT3c4?=
 =?utf-8?B?aURyclk4WDhUckx0Uk5HSktOdTArVVA4cHc5R2dXRW5KcURidkMwUXNlcXVG?=
 =?utf-8?B?WlFpWmhnY1NUT1lnL2tiUXZMbjRwZXdGZElIUFlHS2xaa29ZUml3d2prUVRa?=
 =?utf-8?B?cG16d1I4eDBGRURRSThsK2VZQmUzZW5jRE1FclNSQ1RkVFREdVNjYW9Mc1Zk?=
 =?utf-8?B?Z2ZwZy92cVhYcWlSVm1HeWlEY2dOcUdBeVMydlhyZzdJUzFnVmhpYmpCMzlI?=
 =?utf-8?B?Nm5Ec1o5aGxqRFlyZVEveTJIMVI3UnJWMEx0aTU5cEJjbGRPM1hLelhhK0Nl?=
 =?utf-8?B?ekJNN0J1eGlwdW5rR2VpTUxtTHlPeVBZSGVkdkNLUHRqSTkvaXFRZGFTdVZv?=
 =?utf-8?B?WFRjYVU5UjlOK2p4L29STEVIUnVPaVQ3ZTlLcWt0RTE4bm1BSTV2VTBQUCs1?=
 =?utf-8?B?Y3lmalBhcDI5UGJ5VVg1d0pxTE15MEJzU2RQN0hvZy8xVkx1eXUrU09mSVps?=
 =?utf-8?B?WkMwQS94UVRkMzFpdjZYT3h4ODFNOE1lTXhlV1I0WjExT2JzWGZOaXF4WHhp?=
 =?utf-8?B?N3JMRW81d0YraHp2N3VvTlplWXBXL3EwRjNPOURxdEwrU3VjV3BVbjI4YzNO?=
 =?utf-8?B?R2xQc3pkelk2QUtwc29Rd3RBUHkyZnBMQ2VHQUd2bHIrL2drNHIwQ1JEelVi?=
 =?utf-8?B?UkNrck5KcytWZXlpYzVHUUN2VURja1FHVXVWc2VDNTFPSERHQi93T1ZOQ0F3?=
 =?utf-8?B?bUpySGhzeFRPMFRCVjVIdXRhWHI2K2w2Y3JuS1pCcEV0UzIxR3dOQXBzRExW?=
 =?utf-8?B?Qkk4Y25qSTdJUE5zc0dTOWY0blNQZ0hHVnIyaUQxQ3p3L3V0SXBabUl0eUZX?=
 =?utf-8?Q?fn2bB3qoTzlS6APkTS4E1EvmlyYJtNIvD7FPKpA?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d05e8c0c-c4f8-40d6-510b-08d94332c27a
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4312.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2021 23:39:14.2356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5OThmyK/3fupx2ZGuDgHxxHGY5eNVxaSQ39H/pD+8RDIB9u2opgakcqupl+lqVNPtu/EFwkPmjViLixruyccuU0CYbW48sk8ctZw/r5uATY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5100
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10040 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 suspectscore=0 spamscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107090122
X-Proofpoint-GUID: B0zqoBa9eG5r7Ug3V24p0pJBrgQoi6yi
X-Proofpoint-ORIG-GUID: B0zqoBa9eG5r7Ug3V24p0pJBrgQoi6yi
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 7/6/21 5:21 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Every now and then I see the following failure when running generic/347:
> 
> --- generic/347.out
> +++ generic/347.out.bad
> @@ -1,2 +1,2 @@
>   QA output created by 347
> -=== completed
> +failed to create dm thin pool device
> 
> Accompanied by the following dmesg spew:
> 
> device-mapper: thin metadata: sb_check failed: blocknr 7016996765293437281: wanted 0
> device-mapper: block manager: superblock validator check failed for block 0
> device-mapper: thin metadata: couldn't read superblock
> device-mapper: table: 253:2: thin-pool: Error creating metadata object
> device-mapper: ioctl: error adding target to table
> 
> 7016996765293437281 is of course the magic number 0x6161616161616161,
> which are stale ondisk contents left behind by previous tests that wrote
> known tests patterns to files on the scratch device.  This is a bit
> surprising, since _dmthin_init supposedly zeroes the first 4k of the
> thin pool metadata device before initializing the pool.  Or does it?
> 
> dd if=/dev/zero of=$DMTHIN_META_DEV bs=4096 count=1 &>/dev/null
> 
> Herein lies the problem: the dd process writes zeroes into the page
> cache and exits.  Normally the block layer will flush the page cache
> after the last file descriptor is closed, but once in a while the
> terminating dd process won't be the only process in the system with an
> open file descriptor!
> 
> That process is of course udev.  The write() call from dd triggers a
> kernel uevent, which starts udev.  If udev is running particularly
> slowly, it'll still be running an instant later when dd terminates,
> thereby preventing the page cache flush.  If udev is still running a
> moment later when we call dmsetup to set up the thin pool, the pool
> creation will issue a bio to read the ondisk superblock.  This read
> isn't coherent with the page cache, so it sees old disk contents and the
> test fails even though we supposedly formatted the metadata device.
> 
> Fix this by explicitly flushing the page cache after writing the zeroes.
> 
> Fixes: 4b52fffb ("dm-thinp helpers in common/dmthin")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Ok, makes sense.  Good catch!
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   common/dmthin |    8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/common/dmthin b/common/dmthin
> index 3b1c7d45..91147e47 100644
> --- a/common/dmthin
> +++ b/common/dmthin
> @@ -113,8 +113,12 @@ _dmthin_init()
>   	_dmsetup_create $DMTHIN_DATA_NAME --table "$DMTHIN_DATA_TABLE" || \
>   		_fatal "failed to create dm thin data device"
>   
> -	# Zap the pool metadata dev
> -	dd if=/dev/zero of=$DMTHIN_META_DEV bs=4096 count=1 &>/dev/null
> +	# Zap the pool metadata dev.  Explicitly fsync the zeroes to disk
> +	# because a slow-running udev running concurrently with dd can maintain
> +	# an open file descriptor.  The block layer only flushes the page cache
> +	# on last close, which means that the thin pool creation below will
> +	# see the (stale) ondisk contents and fail.
> +	dd if=/dev/zero of=$DMTHIN_META_DEV bs=4096 count=1 conv=fsync &>/dev/null
>   
>   	# Thin pool
>   	# "start length thin-pool metadata_dev data_dev data_block_size low_water_mark"
> 
