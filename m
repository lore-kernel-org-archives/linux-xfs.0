Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 940EAC7EE23
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 09:05:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236768AbjEZJFG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 May 2023 05:05:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242573AbjEZJFE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 May 2023 05:05:04 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E195612F
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:05:02 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34Q8sr2e016481;
        Fri, 26 May 2023 09:04:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2023-03-30;
 bh=qHA3in6GLpDfGCegxoijbaCN7991pIf8MTCriykyngQ=;
 b=P5529GmCHp7sZsXD3Mg3hVV1aT236PCxEcLU2LH1cqHqP42blYoWN1wm2GU2iqqyhXsk
 Zn80ICRMb5ywpliifkj/k3EwcYOvxmR+NwasNr0ndBUuQDJWapMPwrKPcXLWAjEc8GgW
 mMHd0MlnAOZxoRUzUWkGpRi/88r1b5gnrXhJ+0M4wVSWXnnd5o4qdGLTa2TWAXWdHizA
 4gDB4wsf6qUvjJL4qlYcnJor/v7CZ+Z8ZhH/3hYRa1A7oskO/74hiv5ZL3vf2T381+Vt
 3vdwfQnfG/JaWafi6bwlGptXds1UiNvj9RwIG5BIP31BmGr5S4L5RV3VyzUEDUur5b/S HQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qtsp400x8-23
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 May 2023 09:04:59 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34Q82Ods015957;
        Fri, 26 May 2023 08:49:52 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qqk6p8mym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 May 2023 08:49:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mq7k/xZrNej1EM9OOEeMsMfc8OzvQkILaxHE+B3L3cyG8Wwgxmlk2K7QnIA1GuDkaKNZb+6Du/5JuJlGxLv/ZhmAQhupZdEv4JW2btOi6Q2ERwedBZFqTwUHYwmeBxRw5UvUEZiQjqHWJMHaawiV7HokI+pOPpchGAS92HgOLVIg0NBz95wQHC6P7DeUKS2LW/ntdWE2W5BgqvMouDLzZEJOOVOtJlbuYt+XxWe89aJtBE5ZoBbZq/6kH9GfN6y+ENHRz3s4xkrn3+4740Uzhgwko8ghjUURchSd6fAJTX6KowG0P5VZwk/+icu1VHIYBBipez/oWOdbSRE0xoZYdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qHA3in6GLpDfGCegxoijbaCN7991pIf8MTCriykyngQ=;
 b=muk15ue4MDXhYMpyQ+UbZMZ/5gFarwSyQTku/LtsutuKRfCW9z1lM5KrpKLuzIm3PWjkYHPPk1dSXCB28FDGlLQGlK+Qens4ki03s2/V6WlJ/IlWigHR/UYwSH9qnLXP+QeeI1zPBjyL1Z3/3Znw54HMAN8Au3w0pDOPLIwDmQ+94iIOiITJB1GKfaQnzi9JIVtRg2Nwl1KOROu9Z+8KNbi4gpzg3d+1bn+chntnkKL7/eh0+NZ59PM0RV6q8irC+aHauTiys6lI3lcA2nQZbhedFqydIj5pVpo9KjIWw/QqZZaVfDFdYQH5KJD0SxmvzV4qlRB8xkNsHgC8eomgdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qHA3in6GLpDfGCegxoijbaCN7991pIf8MTCriykyngQ=;
 b=bmYCK0tDeg+HrvB02XapY16I7Sp+xE4lGq4GVFnHs9GdlsIuNQ8hePivtae3ceEYSwqMS4aFhjTmGp2ghgDCLawScWtyC5HCvTW5UxMPVbWYb/1HQvTmYfN1Kv2CBc42cU3EiFrxPTNbtfHjQ/CsM0NGSxUZFKR5kIrAdIiOwq4=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by PH0PR10MB4439.namprd10.prod.outlook.com (2603:10b6:510:41::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.17; Fri, 26 May
 2023 08:49:50 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1%6]) with mapi id 15.20.6433.017; Fri, 26 May 2023
 08:49:50 +0000
References: <20230523090050.373545-1-chandan.babu@oracle.com>
 <20230523090050.373545-9-chandan.babu@oracle.com>
 <20230523171525.GO11620@frogsfrogsfrogs>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/24] metadump: Introduce struct metadump_ops
Date:   Thu, 25 May 2023 14:18:35 +0530
In-reply-to: <20230523171525.GO11620@frogsfrogsfrogs>
Message-ID: <87pm6njx3t.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: SGAP274CA0023.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::35)
 To SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH0PR10MB4439:EE_
X-MS-Office365-Filtering-Correlation-Id: f9fb114d-f14a-4409-bfb2-08db5dc62ab1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SU5ZuxHuLoMs0Ao1yCrRbdac2Eys4gDY5Djec0CSd3LnyLt4w60tBD7lcFZETuA8Gzhf+wnSJtN65Oy5CBJWk2w5BOjRmhA0QNeqF87R2CLwfnUHCOFk4w09F/K+mO2HaU8eYhiylq+yPhJwnz3V53O8XWBWtViRMXc14nwjd0K2UNYPiIyT8oEW5eT2kVEElNpUq7uGv+byT56EOQ7gUo890aQaD4qqSyHSu/8soMss6Olw3G0s6WbQzyFHYzeyXGI2b55PLR2itqjNb0CeSlk5rS8ngJ1ZAGsrWbFWa60GmPYRcQ/Y/kABwazqMnZb6KYXlT0HB10kKao8+FuHLZXF8KKtDyBsDpTCCMoIHjGNFeaikb2TD0HqCQy5Qz/QPRHmU96Xcu1chZJNeY7baVZnDejoCcYlo4dgARtPnUNzlQUh2EmfqNMokRdPw/muGpz54bx7DCcfykCThw6A5sD/oSafzdKrN4yFN1z/fSyTAVHUgOVrc0STLAy0x1eClXrUju3tayW6sQ4ktJ7eJT3r/+MfynbqNVGVQg8yGruvibUkgm2K/o6A8WAEGA4p
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(346002)(396003)(136003)(366004)(39860400002)(376002)(451199021)(83380400001)(2906002)(186003)(33716001)(86362001)(38100700002)(66476007)(5660300002)(66556008)(66946007)(316002)(6486002)(6666004)(41300700001)(8676002)(8936002)(4326008)(6916009)(478600001)(26005)(53546011)(6506007)(6512007)(9686003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sxdK1RMJGaGAssCcif+KbpzTBNGyXZ86l4j/WdyoAtJuu47maI/Co6ZigybE?=
 =?us-ascii?Q?LNOpN2iOHC7bHAsVIlz4s4xViod/9a5DUMeR5BIduxjt391ja7F4eCYxkl5c?=
 =?us-ascii?Q?+Vt9bvOLPUW2MI/7DPpdW57egNZ/hwHMxUEv771rmPXk9RFNtis4T9QDePrp?=
 =?us-ascii?Q?YgOLlbtt0l1VQfi2NXg7uIg+jAuNBwbjiozbEWRxsAx1hbFFm96/TXHEMFZt?=
 =?us-ascii?Q?a/2Y3tFPST1pUDsSkiqjzGzTMNOO6bPTCautUVaTPS6F/q5SFW9m/PRb9NxU?=
 =?us-ascii?Q?RCkG2LPUK3Jw/o4jCnFP50dH31o3wSekOPTdd0G69nrMiJTurwktW3CnkVul?=
 =?us-ascii?Q?ZtWlSNg9enbyXgq6P6MSLvb1/LYd/D9kwfacVzciNbch0b8aVPI06Ik32gxi?=
 =?us-ascii?Q?BnBEg5puNiBMmNBWql56CvgTRvV7DL4CwVY5GlbL1rcOLZppjykIw5csRIVU?=
 =?us-ascii?Q?fQEVziPLw5QaysnZhdUYmBhZXOWCHOfOfs1k0DtASrw/2tYqW4/oc0kg3Cps?=
 =?us-ascii?Q?pyK6diJVj/zK2yiD1RF+LF2nzRc62gCbGZH5qTqYWDKDhD7nAJ7sJa4vEOyE?=
 =?us-ascii?Q?lA9mWWOErLxkfT5qbhe/xTZNSmFdY/O8DT6n/mpdT5xhjSnYNWay9HV5nQu/?=
 =?us-ascii?Q?kGuIxpjkMfMBxLwpGlhKQ1jqojF9m1EE/V7z33RQkDzQ1rDtUT7TijaWQZ2/?=
 =?us-ascii?Q?H7RS16uokxu1oqqcIfmXOX9nh0BMwAL29nuz3wOYuVYnkueYXA50LXdbZj6d?=
 =?us-ascii?Q?REhYlIIFSJWgk4qYOVZT0SX+beF0WrK4m6D9eWIigxzq0JhZI0fqv2bNsZxk?=
 =?us-ascii?Q?1FaLAQZcoKUk9zKO82qTpmW2ixAZT0F/O4jlM6RTEMQ6ByH1XTuBkomx6XR9?=
 =?us-ascii?Q?Ejx7ypKWdfQNR64IIpqGF62kkHUia+eiHOyH1auuSryu+WAbiwN9RB+/rEvX?=
 =?us-ascii?Q?d3Bo4p+LrWZG6/AxF2FxodolNQ6TY3i3E6I61dmvEiwqJRGr++DwYXWzJC8L?=
 =?us-ascii?Q?mdsful8OD+jeECZQ6fquWXHMbPHeksMMQfFxpUNeexXkWf63wjJLxJqGBYgk?=
 =?us-ascii?Q?ssYoeCO4guvCH5bGzkmnRXG/zPGbjhf1ghU30lXKyCewNCGmZp6PeQZvIKiA?=
 =?us-ascii?Q?nKTS7BIcueNXTgaiVlLLDYqROR8UCPYaFsnz53PRTaoJWjg3jBmNYAc6aZSA?=
 =?us-ascii?Q?HdFRJKOm2AxfqyalhqB9wfE3n65M0CTgcGRqvgunsyB7P3+dTnMPpw1ZApav?=
 =?us-ascii?Q?B4EuSiEz/nmKSgeovyz23TaNTf8t8O3sZZZZpEwqdsmuRnefcJ8KU9PnkPeH?=
 =?us-ascii?Q?l3v0sZfEUfeDfZGzxCy5g2jzleqY+PYeCTthc/yOuh5P8iyMDmfFdeCRyU/4?=
 =?us-ascii?Q?jBNLJpjmC3OXOeJwEwodyyHx83TJW2FDvKUw7PTua8pqkavxjZqTLE+xatvH?=
 =?us-ascii?Q?yPCZVhn5OxG/WVAOtPaJC2qgxUlP6pA99T4x5ZTiLzQje0xLq3uHfLfXAIe7?=
 =?us-ascii?Q?WCummTPjjeHill0scn54BQ+7Eq6gFhO+nkAn96DaNcYe5SAGUsNecP/cDuIp?=
 =?us-ascii?Q?mVMLVjXG1MVwtw8GB7qidUU9heZ0ETJb4JQr4U9Z?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 9U44m6jeHU0Vs1KMPdWhvlJmrZ+V/W9UWJLPycB1kcH12a88S+sYsJ/HF0hWSpull/ikIf3wsGKs/b0zAS9ms1IruHv1kFq1DzGSDXQxAvDvwwUfgez74G9gZfoKgC1k6AEed4DquD0BYtvagiHZU8WpwThp+2UMq3olmucryNEaCqU3+y2wEub0MDPsKnTX4/gXaXSUZ4Mz7f/FCt6jdPhswK+Ex0nbdmxQqYEmI1lVbE0MWSwzt5Gin0g0k03nVwMXi1uzu4SivHOGFNFpr/Fo1zJUhozurtKp6UOamaf1iNGjvcuwffoMdzrU3zK9wppKAGuJ87f+PN5kWQzUzVp3xjA571USbxdM9Y3TvijAZLBg5a8jYyHuJScXoiTGwQgU3FelKnyNBjqtWK+VPYcn9pi89CGmYjl7/nquBrNln8c4+8okQWZxjwiT2SdbTrbpbB8kauFHKeqOYo0eXimCz+st3/RYx/K66HtmHfP6Y/gV5+chuPFAWjMjnucwjs1C0zyIQ8QnvtR/XEPlVil/b/1YBhvuJfmJJiJolPK02mSKjwX4TxYy5g7/KRjUz5BCdnfWX1sNQwlQraR3DCv5B27GV0feWArgTue6caDsd0F4fKKt/CjKZcCa2tH2fewOrU6/hyXsS9KvPQCn0TQqi1zMXw3hYVJcYvWDj+w+5HLtYqq6Y236gSqi6koce+mFWShT5O9uCnPaoXOhfOU3gpH/3w4oiUiAmeMLAXDW0yylSQjKxvGPtRHFfrsIiVpDyF6wUHY1cbAYcXchuMMoGv42elvnEkzlWkbKFvk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9fb114d-f14a-4409-bfb2-08db5dc62ab1
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2023 08:49:50.7620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +A8P6teOka9KSxRcbPM4fbUHDUjzMdQi6pjcKYFVsHLd73gWkqFK5lcy9Cz6zar6IMQNwzhtsodzMhsQMWVQIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4439
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-26_01,2023-05-25_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305260075
X-Proofpoint-ORIG-GUID: aIo1QKcJLm5UO-7Gk58wCAOP7YcwtmRW
X-Proofpoint-GUID: aIo1QKcJLm5UO-7Gk58wCAOP7YcwtmRW
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 23, 2023 at 10:15:25 AM -0700, Darrick J. Wong wrote:
> On Tue, May 23, 2023 at 02:30:34PM +0530, Chandan Babu R wrote:
>> We will need two sets of functions to implement two versions of metadump. This
>> commit adds the definition for 'struct metadump_ops' to hold pointers to
>> version specific metadump functions.
>> 
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> ---
>>  db/metadump.c | 9 +++++++++
>>  1 file changed, 9 insertions(+)
>> 
>> diff --git a/db/metadump.c b/db/metadump.c
>> index 212b484a2..56d8c3bdf 100644
>> --- a/db/metadump.c
>> +++ b/db/metadump.c
>> @@ -40,6 +40,14 @@ static const cmdinfo_t	metadump_cmd =
>>  		N_("[-a] [-e] [-g] [-m max_extent] [-w] [-o] filename"),
>>  		N_("dump metadata to a file"), metadump_help };
>>  
>> +struct metadump_ops {
>> +	int (*init_metadump)(void);
>> +	int (*write_metadump)(enum typnm type, char *data, int64_t off,
>> +		int len);
>> +	int (*end_write_metadump)(void);
>> +	void (*release_metadump)(void);
>
> Needs comments describing what each of these do.

Sure. I will add the comments to describe each function pointer.

> Does each ->write_metadump have to have a ->end_write_metadump?

No. The v1 format code collects metadata blocks in memory and writes them to
the disk after sufficient number of blocks have been collected. We might not
have reached this limit for the final set of 512 byte metadata blocks. Hence,
a write operation has to be explicitly issued for such metadata blocks.

>
> You could probably remove the _metadump suffix too.

Yes, I will remove them.

-- 
chandan
