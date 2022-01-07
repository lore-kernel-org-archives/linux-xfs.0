Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6A13C433EF
	for <linux-xfs@archiver.kernel.org>; Fri,  7 Jan 2022 16:17:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348139AbiAGQRZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 7 Jan 2022 11:17:25 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:64162 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239828AbiAGQRY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Jan 2022 11:17:24 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 207Dj8dq011035;
        Fri, 7 Jan 2022 16:17:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=54UfoR6SeKhgZAI5M+ahi9O6edm64v3+SjVNTjwRzTs=;
 b=0PXSs8qQoxLstDNN+HSGQkJOiN1tlry2/sLyNoSHvJwWvc31zXUkvSeXiw6ocCEOPzBt
 zuPAoSngQAlhP9NV41xq6yEj2NODzTR5nOa2ZFtZVrOkXeXGPv/rdnMw6daQISVyUx2e
 mOYtFSWyIWfHTEdxMPAFtAGC04YEfdXsBoaHf7e0PUSHOkyCJj0MQzZoj9ajIgPPqHNv
 Gv6Y9ykXjSlm0D7zm3sLqOofMiHQGB29tipsjrz7jEoBYC+AesjIbwzhlrP5ffT+V3cV
 5RuSydLWEQnUlbXc+pGlQNF1SBmaTF4pUtmEKu+Y9M0hdFvTzBwqNOvG1FH+So9iDPeA 7g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3de4vbaf8q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Jan 2022 16:17:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 207GFkZZ140777;
        Fri, 7 Jan 2022 16:17:20 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by aserp3020.oracle.com with ESMTP id 3dej4sytn5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Jan 2022 16:17:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HSGBw+lQkubVhTnqwZyjFkPctktKje8hE/joClV6ZJ7AvcgYAAUBVOkQzhJvtk6Hnulkaw5T+O5sxvL6/uZPrOc3PWV3xPr1d+yslK1OdCf5T3M1C7N53pwN/FfW6M+EMNzvPCumlwB/IcflIpeeBgYa/hJq8J/fEMV9AclMhWeH6ATuBsUkct0ahX5ok7v7/gPVkFt+DMAuDsdHROWz/C6ELiz1Ee+HTt/BDBiNVsbG+LP0emtJfnlsYTLQNILS+ruZNP8PYbYzlm7HidokJzBUMzQ27T/xfq4j5PaGWW088Gcg2PSUSVn91pbRozUoZ5KNzhmj4kJ6i11cOCPKeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=54UfoR6SeKhgZAI5M+ahi9O6edm64v3+SjVNTjwRzTs=;
 b=nyoQChlbopgi0J4JbD8pB+Lk8KQHcTZ07XS8h9/flK5PLT5N1xuhhcbmS9msVcyMEwDMfQ6yl9s+wb1M/07Xx9qjVhyxg4E1YZCEEVU6HOe0QjrAwEoXiZlkYWEwnED28jnFKqZqAl77+Rbd+OiKezPVTXeiZgUlm7JGbDMsEZj8JiCR4dCIga9pg2KIiBBttyUzG6Gmj1LWE8nVvuonsILjRk1Ck1kplJVVvcHyhTEp9ou+TUcZlTQpvjqyOPEL3azArWyyYPk2NshNjUmfCZzrfh2YkQZomIaYBGmeTP3qKITtem4rqC/8ecD0xy9JH1DqgS+lXg6WRlZ9ynBh+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=54UfoR6SeKhgZAI5M+ahi9O6edm64v3+SjVNTjwRzTs=;
 b=PqJ0AX9c85ttwNeVnHLivK/zzbkFMFc0eleq7UNx3w7K5iyf0PihgQJqHBfEW4l525vBErjh71Oae2HtgZgpGBeZLZe3fZeVjf3oV0E77eNTMdAGmK543DjfrpK2VDFhFNvyoOIpzUiS/7h+Bf2auaSD89S+PszvZIUaBxi9aOE=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2656.namprd10.prod.outlook.com (2603:10b6:805:42::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Fri, 7 Jan
 2022 16:17:18 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d%7]) with mapi id 15.20.4867.011; Fri, 7 Jan 2022
 16:17:18 +0000
References: <20211214084811.764481-1-chandan.babu@oracle.com>
 <20211214084811.764481-20-chandan.babu@oracle.com>
 <20220105011731.GF656707@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V4 19/20] xfsprogs: Add support for upgrading to NREXT64
 feature
In-reply-to: <20220105011731.GF656707@magnolia>
Message-ID: <8735lzwmex.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Fri, 07 Jan 2022 21:47:10 +0530
Content-Type: text/plain
X-ClientProxiedBy: TY2PR0101CA0040.apcprd01.prod.exchangelabs.com
 (2603:1096:404:8000::26) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aea1e4bd-abdf-41e2-85f8-08d9d1f92cf5
X-MS-TrafficTypeDiagnostic: SN6PR10MB2656:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB2656745BA9C2E2C9FAB8EE08F64D9@SN6PR10MB2656.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:454;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mC3AR9PJLnO/u/FY6rqbxeufrznvwNUPlOliAgB6SPLYaDfhVH/2BSEzpHP12S0ajqNY9lCpryI04dUfhjyIK6mqSEOnh+mwLs9L+QxfxqAeLwhUw4D1mH0d4PS3swRrYDCaQ0pFUiKN/+kP7GK3om4uU22qtHl3vn1qL80CYdofHZPG9dBixLpymMVtAT0LIqtWQLtwvT1lodxjMT3IYnzkMwhQu0JE5DJnTKa89v+xtbJw7sxDUuO3jRuFhdPBVvNFZcJeuMKjVAE/zpOX+kuWX+WkjjVqfuNp0zv3/y1ghQefWNjPY9sZePlQXP7uRlif+OcTdzOHzgoEFsGVt5Xa0QR88dZzlj8QC3v+fBQNSiRcc4K82d5a0y7qOhyfrZyOWCKU5lA0a/xcOC+d1UNv3uig4boyGCbk6rJUY606fn30MWTSebGumMG7pdne8bOmi7jtWx9uSByVQsfCXKDzVCi0TUbuiD8bVpFrt9uAXlW+4FlmHLUX3YvV9+Q+mhRW4ljwoKXOXdUHBLBgE5rniQ2t5g6GU+X26Giy5jPbCn7UYhO1Fk2WVYx9pMj/udisNzq9pSLxKMR+vP/PddDMS61nGIVpjjEhbE9tleauxwmye32JhCSE+sjm+JO3k6QGZbpkAcz9iCaDzzEo0rIOwtDLdbMDc9iTJ1axcxYt+znl8boSDNlgwGn8ulwwOPJSRu77TwTKPNTnvDjUvQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(6506007)(6486002)(33716001)(53546011)(6512007)(8936002)(8676002)(9686003)(66476007)(66556008)(316002)(66946007)(6916009)(86362001)(38350700002)(83380400001)(5660300002)(26005)(508600001)(52116002)(38100700002)(186003)(4326008)(2906002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RDTbxQ3O+y5dXE5Ewei6QNBVZQytpltSK1FiEfjljzs3ShFmLECx7LFNhUhm?=
 =?us-ascii?Q?CT1HjidGyNoL2XyxodYXI0MM2dEoA41fFz8Y5PwfanHFx22npbji9c9OHXbB?=
 =?us-ascii?Q?hajc5ieZfdbJ9Wo3qUYXrofrtl+6prs27CAITEmTi15y361h9CYuDnLNye0j?=
 =?us-ascii?Q?hMa0clT6S3eISs5Azdr5FifvdcVDITlokRUJ77gX5cj2579jkmKU0z0AJosg?=
 =?us-ascii?Q?gHBZluV9qjV+zwvyVjUq3EphmJjtnZtnUTchF8/M5boISfLwnPD6m+MJbIc5?=
 =?us-ascii?Q?yeIlB3dpg9WSuD6tCn8y0kLRN425GgBdUdX2FemrLGE7S6nsOb+9zK613m1J?=
 =?us-ascii?Q?BhkTFL9g1ZnOxa6CT/9xmEegePsLB0L+d4Bivl6Ywm0oSAm5ZUYHW73pV5+L?=
 =?us-ascii?Q?8YmBUq1Wj5SXm1O6uzSuRMqcPrTzmL0HDHHejl98fjbohA8CZBlYbXstMSxO?=
 =?us-ascii?Q?NpMlYt3IvgEcBHpIuZV5Y/hZKtaJf7rZE4wQEnAhEyqdu/Z27UvZDEmez2GP?=
 =?us-ascii?Q?SWT1yjZGvczjSBeL4bL/j5Mn2rdRu2mAt9Z96fDNd6T96GgPr5/F9TR8dpba?=
 =?us-ascii?Q?cOIbQdKxYIWAseQ1v1P1Kxjf5JwWoqVX3wcbYY/ryjS/2rqrenXjVfubX893?=
 =?us-ascii?Q?+srCYuqtPt05K09E59lPYF0GlzvKpKzTVT7jSm8aI4nvM7zsrLiHSMl/lLWP?=
 =?us-ascii?Q?z6RuUg7G/YLtoEHsfa9JevBhTJtf3yz1vTlt8GhB2OD2eDrAUrd9re24zvQn?=
 =?us-ascii?Q?BBP9p5OlrHE9M9HG897dItkVEU3Jpb6jeWohnt59cYg0NHaZtlx/zIT1aE0f?=
 =?us-ascii?Q?Ue3jq94tgXkKxV8S212sXl4gtC2LDxyRuO3lIHh+NiFe1mFskHuPRIYKsnEE?=
 =?us-ascii?Q?xwtiZw3+zqByXtmTujX1xp2uXvKXME+iZ+NBGbsH9QSY/2pv7Rta3fCZuox+?=
 =?us-ascii?Q?b9RR6QNT7Vldw+/a8wAhaS2cpNKQOwOhWmH942mlOeDMSDjfOHHtFH7S+Xeo?=
 =?us-ascii?Q?+viQEdkaTNlpvVI8T31223n902JxeS69gVHH/eQ/fjqw9r3UMxJ1k/TEc/Sg?=
 =?us-ascii?Q?5TZ9GM7CAoIHyKCAni12UG0MG1ysisIa1bWnBw7deuAdBvRAUV5PJMH/h0JQ?=
 =?us-ascii?Q?PPmhFb1wcwSNMHaBw3+53/oraZTd4RPerbPKL2xyyb/LFGtlpIDYWfC1AD7A?=
 =?us-ascii?Q?VEJN+nCuanQ6UUbnOaoAEq0qYA1MOcJe93R3spvPrMb+vmt2aPTZBxzlo8T8?=
 =?us-ascii?Q?wihz4R6xhrbNaQwcwXQKgkkHaYrBN9oGli1M8w9zBZ3MO/xQeV1lakGT8rt5?=
 =?us-ascii?Q?VmZAmf67d8RH4obuDoWCuHJ69HMfCaW+mQFTIRHB1j7TQJOy6LMeWWp/vLQl?=
 =?us-ascii?Q?R+ZV+9W6WLENxWd44n7k4P46v7aSkfQzKKk2IoYc4Ga+fWZrncN8DNOIqPpq?=
 =?us-ascii?Q?cxglOwIbicxhJyvVqfmXt/aU6PGCn7BSq76nB0FwC01YDV/B8f5hDNkBkecE?=
 =?us-ascii?Q?vIz+AekjRyZ3KMjIShsiJVZYAhz0JqGhCuqCMjIvh1VrJwwEZhvI2+zzKdr1?=
 =?us-ascii?Q?M+UVLKle3qSsjz0+1Yhry1XIxvpz8rTpdD0n4o1xZCO6yKQf5mohNVDNVfrA?=
 =?us-ascii?Q?3lJhDO2e+9sN0OSNLGrhwko=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aea1e4bd-abdf-41e2-85f8-08d9d1f92cf5
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2022 16:17:18.3952
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DS0o2k9iJC+k1eUXaeWmc71kVDSOW6d7wL5HQ/0ggZp2FfKUVL+cJf03Z+53pYeXi8uXMn6cgE+DlY31io1NOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2656
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10219 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 phishscore=0 malwarescore=0 spamscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201070111
X-Proofpoint-ORIG-GUID: 0PYQF2lxniy84npGyCjpXIHbd5I_mzOl
X-Proofpoint-GUID: 0PYQF2lxniy84npGyCjpXIHbd5I_mzOl
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 05 Jan 2022 at 06:47, Darrick J. Wong wrote:
> On Tue, Dec 14, 2021 at 02:18:10PM +0530, Chandan Babu R wrote:
>> This commit adds support to xfs_repair to allow upgrading an existing
>> filesystem to support per-inode large extent counters.
>> 
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> ---
>>  repair/globals.c    |  1 +
>>  repair/globals.h    |  1 +
>>  repair/phase2.c     | 35 ++++++++++++++++++++++++++++++++++-
>>  repair/xfs_repair.c | 11 +++++++++++
>>  4 files changed, 47 insertions(+), 1 deletion(-)
>> 
>> diff --git a/repair/globals.c b/repair/globals.c
>> index d89507b1..2f29391a 100644
>> --- a/repair/globals.c
>> +++ b/repair/globals.c
>> @@ -53,6 +53,7 @@ bool	add_bigtime;		/* add support for timestamps up to 2486 */
>>  bool	add_finobt;		/* add free inode btrees */
>>  bool	add_reflink;		/* add reference count btrees */
>>  bool	add_rmapbt;		/* add reverse mapping btrees */
>> +bool	add_nrext64;
>>  
>>  /* misc status variables */
>>  
>> diff --git a/repair/globals.h b/repair/globals.h
>> index 53ff2532..af0bcb6b 100644
>> --- a/repair/globals.h
>> +++ b/repair/globals.h
>> @@ -94,6 +94,7 @@ extern bool	add_bigtime;		/* add support for timestamps up to 2486 */
>>  extern bool	add_finobt;		/* add free inode btrees */
>>  extern bool	add_reflink;		/* add reference count btrees */
>>  extern bool	add_rmapbt;		/* add reverse mapping btrees */
>> +extern bool	add_nrext64;
>>  
>>  /* misc status variables */
>>  
>> diff --git a/repair/phase2.c b/repair/phase2.c
>> index c811ed5d..c9db3281 100644
>> --- a/repair/phase2.c
>> +++ b/repair/phase2.c
>> @@ -191,6 +191,7 @@ check_new_v5_geometry(
>>  	struct xfs_perag	*pag;
>>  	xfs_agnumber_t		agno;
>>  	xfs_ino_t		rootino;
>> +	uint			old_bm_maxlevels[2];
>>  	int			min_logblocks;
>>  	int			error;
>>  
>> @@ -201,6 +202,12 @@ check_new_v5_geometry(
>>  	memcpy(&old_sb, &mp->m_sb, sizeof(struct xfs_sb));
>>  	memcpy(&mp->m_sb, new_sb, sizeof(struct xfs_sb));
>>  
>> +	old_bm_maxlevels[0] = mp->m_bm_maxlevels[0];
>> +	old_bm_maxlevels[1] = mp->m_bm_maxlevels[1];
>> +
>> +	xfs_bmap_compute_maxlevels(mp, XFS_DATA_FORK);
>> +	xfs_bmap_compute_maxlevels(mp, XFS_ATTR_FORK);
>
> Ahh... I see why you added my (evil) patch that allows upgrading a
> filesystem to reflink -- you need the check_new_v5_geometry function so
> that you can check if the log size is big enough to handle larger bmbt
> trees.
>
> Hmm, I guess I should work on separating this from the actual
> rmap/reflink/finobt upgrade code, since I have no idea if we /ever/ want
> to support that.
>

I can do that. I will include the trimmed down version of the patch before
posting the patchset once again.

> --D
>
>> +
>>  	/* Do we have a big enough log? */
>>  	min_logblocks = libxfs_log_calc_minimum_size(mp);
>>  	if (old_sb.sb_logblocks < min_logblocks) {
>> @@ -288,6 +295,9 @@ check_new_v5_geometry(
>>  		pag->pagi_init = 0;
>>  	}
>>  
>> +	mp->m_bm_maxlevels[0] = old_bm_maxlevels[0];
>> +	mp->m_bm_maxlevels[1] = old_bm_maxlevels[1];
>> +
>>  	/*
>>  	 * Put back the old superblock.
>>  	 */
>> @@ -366,6 +376,28 @@ set_rmapbt(
>>  	return true;
>>  }
>>  
>> +static bool
>> +set_nrext64(
>> +	struct xfs_mount	*mp,
>> +	struct xfs_sb		*new_sb)
>> +{
>> +	if (!xfs_sb_version_hascrc(&mp->m_sb)) {
>> +		printf(
>> +	_("Nrext64 only supported on V5 filesystems.\n"));
>> +		exit(0);
>> +	}
>> +
>> +	if (xfs_sb_version_hasnrext64(&mp->m_sb)) {
>> +		printf(_("Filesystem already supports nrext64.\n"));
>> +		exit(0);
>> +	}
>> +
>> +	printf(_("Adding nrext64 to filesystem.\n"));
>> +	new_sb->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NREXT64;
>> +	new_sb->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
>> +	return true;
>> +}
>> +
>>  /* Perform the user's requested upgrades on filesystem. */
>>  static void
>>  upgrade_filesystem(
>> @@ -388,7 +420,8 @@ upgrade_filesystem(
>>  		dirty |= set_reflink(mp, &new_sb);
>>  	if (add_rmapbt)
>>  		dirty |= set_rmapbt(mp, &new_sb);
>> -
>> +	if (add_nrext64)
>> +		dirty |= set_nrext64(mp, &new_sb);
>>  	if (!dirty)
>>  		return;
>>  
>> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
>> index e250a5bf..96c9bb56 100644
>> --- a/repair/xfs_repair.c
>> +++ b/repair/xfs_repair.c
>> @@ -70,6 +70,7 @@ enum c_opt_nums {
>>  	CONVERT_FINOBT,
>>  	CONVERT_REFLINK,
>>  	CONVERT_RMAPBT,
>> +	CONVERT_NREXT64,
>>  	C_MAX_OPTS,
>>  };
>>  
>> @@ -80,6 +81,7 @@ static char *c_opts[] = {
>>  	[CONVERT_FINOBT]	= "finobt",
>>  	[CONVERT_REFLINK]	= "reflink",
>>  	[CONVERT_RMAPBT]	= "rmapbt",
>> +	[CONVERT_NREXT64]	= "nrext64",
>>  	[C_MAX_OPTS]		= NULL,
>>  };
>>  
>> @@ -357,6 +359,15 @@ process_args(int argc, char **argv)
>>  		_("-c rmapbt only supports upgrades\n"));
>>  					add_rmapbt = true;
>>  					break;
>> +				case CONVERT_NREXT64:
>> +					if (!val)
>> +						do_abort(
>> +		_("-c nrext64 requires a parameter\n"));
>> +					if (strtol(val, NULL, 0) != 1)
>> +						do_abort(
>> +		_("-c nrext64 only supports upgrades\n"));
>> +					add_nrext64 = true;
>> +					break;
>>  				default:
>>  					unknown('c', val);
>>  					break;
>> -- 
>> 2.30.2
>> 


-- 
chandan
