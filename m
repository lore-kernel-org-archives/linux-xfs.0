Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE146C7EE23
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 08:54:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242844AbjEZIyQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 May 2023 04:54:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242826AbjEZIyM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 May 2023 04:54:12 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0432B12A
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:54:08 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34Q84jYP008618;
        Fri, 26 May 2023 08:54:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2023-03-30;
 bh=Jq1ehaldWW9G37KLaAAXSgDHojZ9o52R6juzqM1tcsA=;
 b=4C9eO0/dME391BOeKZM3eJ3Fd2QoODS2CP2CKpMnX+zo0XkjOgU5pgEX2YmRgjuRtxKl
 eAVLfe7jnrxhnHdLXOF/bBx/TDFmdG58xD/LyX+GEQNfvH+tqsD1w/MqTqtoFndlrK69
 A6Rv3V5cseJ4Ur6WReEinVsuWTkUuheHEkRfbn7HWb5ut6AaZkKJGXbnCM9m6vGBxfjo
 APakC7JBwigBj7Wwtlpv/zvpDxLne1C8K1IYA3Bw5mFAJ6wwhfYKz+Y1EQ4EUiTcQYBv
 ZqSDopG8VsLOrh0HD+crzxi92we+UE55Y/ksUUDjVauYyBuPhZue7WAGiyCkf31JIIKs Ig== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qtrxfg49m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 May 2023 08:54:05 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34Q6iiBt028615;
        Fri, 26 May 2023 08:53:49 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qqk2uy4j1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 May 2023 08:53:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EKu4/qI5unNTThUojFYejWuNK8wIrXUU02MIGNDiDj5fAvs3zQBhALs7HbJsV1IGUz4YCNLc8TivCj2QymQZJQt3hGxFg5RFBnAslhOES/xFrac/qNG8szccVbzIv6brPoJbdTl69HkOfMbegCyvxLFrkgBMo6MzpQqtNxy5UbUNgD/run7vdO8HFeiZmrNPXWHlhEnRyfdBoHLyxUak8Q4prCVI/2qKOomRaqTx+kd+MP7vMl/7SObkP/BQWedwSY+s3CTbPRSqks1JHXfV3jxuMozhmPOyChzOji9xnED7jiiPeDKxWcwfxkWGwMLG8HEbyUU60llnB/os/o36dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jq1ehaldWW9G37KLaAAXSgDHojZ9o52R6juzqM1tcsA=;
 b=MwHaQDmBPxOrCzLP4H4EUbQuF+nx2fy9iYbUzMYUfn/uBcTQ5mQCjnS5wquU4m7JS2+ztcYpdWKfpnHYho3Wh5CKFbJlIS0saM7JrftYgZGkn7O+Plh2sL3xPJwopX118FlkfFdag6GLWewzadWOHt6VpKA8TYIb6GjA5IrxZQYWSBVJi06+6VwbMsNKiiN+Cc+LLANh317GLgJ8yabG6PEGA64WT9zCo1fR+3NTaOewQZO5YhH/qAVrMisYn/AGJdxX4gSz1NuVjVot0192ES55OaDNVjj62/Us6I4xobIKzlnVsG0CepDvfbmD6zFg+oArm0z5xrpiNLVylkPLOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jq1ehaldWW9G37KLaAAXSgDHojZ9o52R6juzqM1tcsA=;
 b=Z7tdm5Lb1DdmVVUuqPtDiF3pbZF4PijkNtv57ET3gvgKPT04Ux99+fhLOofgjHqjoAijfc3Vf/hJihw5cEk49B+exZSpsu6qw195K6tmSMU58xIQ7003BHC+d4Ktw6OSEhC5syRr1sTPYXmrF4Xw93rxHOVWWQhII+4msegYLNE=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by PH0PR10MB4439.namprd10.prod.outlook.com (2603:10b6:510:41::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.17; Fri, 26 May
 2023 08:53:47 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1%6]) with mapi id 15.20.6433.017; Fri, 26 May 2023
 08:53:47 +0000
References: <20230523090050.373545-1-chandan.babu@oracle.com>
 <20230523090050.373545-20-chandan.babu@oracle.com>
 <20230523174811.GZ11620@frogsfrogsfrogs>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 19/24] mdrestore: Introduce mdrestore v1 operations
Date:   Thu, 25 May 2023 16:09:15 +0530
In-reply-to: <20230523174811.GZ11620@frogsfrogsfrogs>
Message-ID: <87r0r3iicv.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: MA0PR01CA0096.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:af::12) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH0PR10MB4439:EE_
X-MS-Office365-Filtering-Correlation-Id: 533c7ca1-2307-4ab2-5e1f-08db5dc6b814
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cjARC1niv9bypPYejDluGpFqtdEyePCl4eBOttE2SqSyXOP1OvxIb//DA8e9rgh3xE4YhSU29IUeeksqbUuT3pmedQyd0UgHFxQo0tkP4xvYcSOwRP8cS/7aeAV8l1LEq+NHnEdjIZfFQLWRjA8sXo2ZH4nssRXATXK8ZbcJd2Yc6adAs49aO9ifmqSI3WjL/FXE/In6aNQ5wiahgEyfiauk7E8KifXPZFJhRrgnvfzjHTjMKTAgZ8t6BW9T0y5ASiRIs6dyTow++YQmJH04Rk50GFf+6lghpebLVNjzTwb8wcvmzDIuZdVCcYZUi7jtSx9UFP1BUMSl9HWBkypuFUr6rYJCs/Fzldpv7WssgVP3Q69lj4T4xkPiBQtJjdMTYf9YSU0v+Nn5jZ6tGBjhvKnxLWRVLALzU+TBFOo6HHMteL+290tUxeQeeqEMW8EPb4kqRdq3dXaNrjo9U1VpwU9kWjw6Uik80ciuEfQ2+DEhhk7XISQy2tzpOZLB8pMJmsjA+g1MtCRelwZxzyZE0zKV7dsbHlVYJs5qpFECYPfRk6cjX8u+gjQ5HAlzrxSw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(346002)(396003)(136003)(366004)(39860400002)(376002)(451199021)(83380400001)(2906002)(186003)(33716001)(86362001)(38100700002)(66476007)(5660300002)(66556008)(66946007)(316002)(6486002)(6666004)(41300700001)(8676002)(8936002)(4326008)(6916009)(478600001)(26005)(53546011)(6506007)(6512007)(9686003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ep8GPq+KwQNKP4VmIVK2ThWnkFX2Zdo+8pgd1uNruhS7leqylCmzPH2H+WLK?=
 =?us-ascii?Q?KM4ntVAqT+CZ+HXHtXIbUA097F6Y8SVWVJGUY8crdoBBEbeYT/Dt6IKhN4kB?=
 =?us-ascii?Q?o157IPorjrYRwvS8pW4FlgzhO89HUVi7kkqBYJFdVEKVEnCbpqOjzygecrez?=
 =?us-ascii?Q?agSF80pnUKb7roDX3YbhWfzF1oW6oCraJaFYqAubQ0ByIhGRBrcfzp3jjZOd?=
 =?us-ascii?Q?aPhM7hr6wKeaKn6ZB+gJQbalX8UuVNVWhgYlBL6fcHnkoxGgucuhyDShIBxz?=
 =?us-ascii?Q?ssBrGyVH9SGvv7O0GUN9P8i9xqCzyMatElUHJtB4At0JNMGUV3ahGxMyuCLk?=
 =?us-ascii?Q?pjnCEG9aClcs3j8opGSgYx6yiQrtvWuHWFqeCpfrrSpg8SM+/AOlOrRFN/40?=
 =?us-ascii?Q?SLNpVhLUdGF6rttIczEnk2qgBVYXYLHhT1x35xBG8MwAhGVmyuEXOUXhkSUd?=
 =?us-ascii?Q?YdMCmEQaxSWxHy4SjTXisGXYshV9XzbzF+hvf49WNV6ibNUq3WLLw/B90/im?=
 =?us-ascii?Q?KFeiXNWNF6hIit3BhJwZazHmCzoT08A869AP5Tn1rr2n0mIKUbK3FYq00I62?=
 =?us-ascii?Q?u58sQkN7C1LgMikriLykt0DU8YaMz2JeCHJNmj0Xssl1NhaIE/3kvUywnWTx?=
 =?us-ascii?Q?zkK77tFUjnXoyEfr9DyyOtoaOwd8/LmORf6NCpx0LaUeWXLWzf0PWJTUEQI7?=
 =?us-ascii?Q?iTg5Kvws9b+fxk25PDKNThfA5C+HWmqhD7sF4ex1eLekRqJpEwsmw7hn6owN?=
 =?us-ascii?Q?5QoQvdGoFdbm/fnuChNBgUyp0eFxt/d7tYxkryai6hD6EE0o14PzcR1RTEgf?=
 =?us-ascii?Q?zFh7kqqeEu4NduxWRjPuwWlaxJ+cUSJ9iHwQ4Cs2v+ONoBCkdrE7Wp9+v08G?=
 =?us-ascii?Q?sQXef9ExjV4CR+uPPAB0BC5xeMEH/x4OWAW5hOQ44zgXf3VWUCtHVAsXVz6t?=
 =?us-ascii?Q?IcmWkEf6PpxRFOmx19+c1gVwAOzXXRgneahDUZFn97/8iKLHG9JFWvPT/JU7?=
 =?us-ascii?Q?zc0AFx1SeOthEHPfNmKLpFW8udQl4hhj4JixGS6JYIKWMhMzEEmSNNYjWbh0?=
 =?us-ascii?Q?56RwXzfIO0PvuPHRSDAkc7GXHLos20JhFP3jmoKzZr4wfPICp+HJIST5/2pA?=
 =?us-ascii?Q?TbKB/zCTxKXjyrTOKqAuehkl/O1U/Ci8T3Su/7gy7S8EKde/5WNkG+MIfiqs?=
 =?us-ascii?Q?WyJcooelqCrShuq97lDFuiGuIfGaVSTJitgsZ1hykbEJ20emeC6tLiSlKfev?=
 =?us-ascii?Q?5vzQvgbUGSkUN2brjKahqD7ZQrjc20Ca2w8dJG8OQG3A2agHaoQNImuRY/1o?=
 =?us-ascii?Q?ndlAP9Yu/vC2x9FngpTRVaLYPJA8wyuJNMkv20Xlvpu6Bcj5dLiS5uPW4jw9?=
 =?us-ascii?Q?46JOLmXn8x6kYVnvCE37ACZ7+NreKvARmKEbt6BVb/9Tu/hscqWGWx8q+7u1?=
 =?us-ascii?Q?tjtXWwlwwNPW5kaUEl+zW0j02EJNmF61jG74AxD7a9jJN53iPOh+ReP69sOA?=
 =?us-ascii?Q?JZiDFdR1f6W26k01efge/ZOsyRU4ybdkPb4ox7aYLzBgj1MhdevjAO4lnZ4T?=
 =?us-ascii?Q?NhN7UTQ8WaicRqALIsbl5uIayjopUu7XypsCBFmiuWb+dq9lE1dcdJI4RCQj?=
 =?us-ascii?Q?OQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: zLdqxRUZZ0rsfwzwEatWrraJSN7UzB8phcBwWuxUD57rGRPIIYqnQgNnbx9mmvhqrQHdKBJrGZAtd5wOeBf7cw4VlR+ITkt+is58Levsw2rins15mmkebHJer9JzPMUoqkROK9oe6/0Sz8XvFBtzf/nY+RL14tLEwfxa1ZhUi6c5qjxFoslTtHdYH4QAjoChT50VjcogDukps6853fMKAyZ+TMgG3p31Qp32yVkRcmQcu4SoAac73PRz/msPXOWm/N1DzqolfuVdJiCAACWQHWxGwS8YC9eDj6SyuFIDPLbpT69Z2dh/RmRIFRFUjM230PGsnsyyZp+kLnWY3Lfrv6LhsWYSNss5OthlYcz+pFrj4t3qJRYkcKIbwEWjwcBZmcQkZa4KEsUWcnYCHOaZtLAApCSE5gtvwSqOGGXahlZbNMTRChxBRtY3unsdqQ2wGlHL+M69D5nnDRfkrTqleZj98jYq1NY41Y5x+YljB2OJWn7jRjnzPysq5WQyXu4KXYhoCtzyjGJYC0r2X73blDkfxMpUX6Da4kS3/+LQ3/xiWoZCQWz6EuC3/ArpEVlQi9SHjqww40/nvUTMDES+tpjPXVpd0An2UtPeLTItdnosOQU8MehztDcOiXWotXg39IMyCOB7rGkOfqsbw7v4w26UosIUTavWSpkHOlRty5E+7hVwC81DlXCrrStTDnS3c+6dg7p6UBJwQcTM0Zi2LQEe0kapThcKKTK6IycflCnFYQGHfa4W+S1+9wo2+Y35yMDHfSJh3bJD1D+PAzjNg+IpWb1AdT2r/76A/AUs9uY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 533c7ca1-2307-4ab2-5e1f-08db5dc6b814
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2023 08:53:47.7739
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OaZZkZp0vH0T3bjr71GSfDcwGFHTYt3LsPJGUlf5jXfC8Qcv2cQTVQE+xl5dwYfC2l3to0BkXeompBzhd+J/Og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4439
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-26_01,2023-05-25_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305260076
X-Proofpoint-GUID: -Iu7J8Snol37CjvPMHSweMm0u6-NLh39
X-Proofpoint-ORIG-GUID: -Iu7J8Snol37CjvPMHSweMm0u6-NLh39
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 23, 2023 at 10:48:11 AM -0700, Darrick J. Wong wrote:
> On Tue, May 23, 2023 at 02:30:45PM +0530, Chandan Babu R wrote:
>> In order to indicate the version of metadump files that they can work with,
>> this commit renames read_header(), show_info() and restore() functions to
>> read_header_v1(), show_info_v1() and restore_v1() respectively.
>> 
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> ---
>>  mdrestore/xfs_mdrestore.c | 76 ++++++++++++++++++++++-----------------
>>  1 file changed, 43 insertions(+), 33 deletions(-)
>> 
>> diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
>> index 895e5cdab..5ec1a47b0 100644
>> --- a/mdrestore/xfs_mdrestore.c
>> +++ b/mdrestore/xfs_mdrestore.c
>> @@ -86,16 +86,26 @@ open_device(
>>  	return fd;
>>  }
>>  
>> -static void read_header(struct xfs_metablock *mb, FILE *src_f)
>> +static void
>> +read_header_v1(
>> +	void			*header,
>> +	FILE			*mdfp)
>>  {
>> -	if (fread(mb, sizeof(*mb), 1, src_f) != 1)
>> +	struct xfs_metablock	*mb = header;
>> +
>> +	if (fread(mb, sizeof(*mb), 1, mdfp) != 1)
>>  		fatal("error reading from metadump file\n");
>>  	if (mb->mb_magic != cpu_to_be32(XFS_MD_MAGIC_V1))
>>  		fatal("specified file is not a metadata dump\n");
>>  }
>>  
>> -static void show_info(struct xfs_metablock *mb, const char *mdfile)
>> +static void
>> +show_info_v1(
>> +	void			*header,
>> +	const char		*mdfile)
>>  {
>> +	struct xfs_metablock	*mb = header;
>> +
>>  	if (mb->mb_info & XFS_METADUMP_INFO_FLAGS) {
>>  		printf("%s: %sobfuscated, %s log, %s metadata blocks\n",
>>  			mdfile,
>> @@ -107,24 +117,15 @@ static void show_info(struct xfs_metablock *mb, const char *mdfile)
>>  	}
>>  }
>>  
>> -/*
>> - * restore() -- do the actual work to restore the metadump
>> - *
>> - * @src_f: A FILE pointer to the source metadump
>> - * @dst_fd: the file descriptor for the target file
>> - * @is_target_file: designates whether the target is a regular file
>> - * @mbp: pointer to metadump's first xfs_metablock, read and verified by the caller
>> - *
>> - * src_f should be positioned just past a read the previously validated metablock
>> - */
>>  static void
>> -restore(
>> -	FILE			*src_f,
>> -	int			dst_fd,
>> -	int			is_target_file,
>> -	const struct xfs_metablock	*mbp)
>> +restore_v1(
>> +	void		*header,
>> +	FILE		*mdfp,
>> +	int		data_fd,
>
> Umm.  mdfp == "FILE * stream for reading the source" and "data_fd" == "fd
> pointing to data device for writing the filesystem"?
>
> I think I'd prefer md_fp and ddev_fd...
>

Ok. This is more readable that what I had written.

-- 
chandan
