Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26597C7EE23
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 09:01:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242881AbjEZJBQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 May 2023 05:01:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242880AbjEZJBK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 May 2023 05:01:10 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FABE189
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:01:09 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34Q8srjE016485;
        Fri, 26 May 2023 09:01:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2023-03-30;
 bh=jdF6c9EbA+MnUwWsQxH7n4FFBiavv4CMgENTOvaGhvI=;
 b=hSDqXM+RCuq+yhrNcDTHEvGQWHKnpKY9DG+O7tmfgMNgyINrUozPsYqPb2GRUleGG53A
 pd748gfeGmqzycD7SPWlO+rCqoXXleyz2wk9tntzjI7ikGQ+yRIPKlYOX9Akm2NjbvCO
 ZTLwpfhXn8cAAv64Ak9tVafLqGmsZargeTzr5oARVoD3XIQx7cR2DPOz67RUXan3/dEj
 YUICVnTj3xhld3h7UEx5ClDZYcrbk8wori2uceu9KWZIxRHsH44hBBlbe1xz4BJWGnHR
 mFN/fdj+5f6g36nQOA+6EJkbbQg0IpzHao7WdJZgT0ySJCcKQ7/6DS4NNy8s7ja+9MiV zQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qtsp400jg-14
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 May 2023 09:01:07 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34Q6uFH4028937;
        Fri, 26 May 2023 08:51:03 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qqk2eqh4d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 May 2023 08:51:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mE6LIauR1L4yD02Z8KCSAXzczc5Y3ku8Q462yUcvrxfS2mFqydUqmVuLoje7Ts/iVNgTsXgkoXtv2+cHYyGoqgXV/iUQfLT82MxmVI6igqh5/1u1XeAZ8T/gKanoNTLe/1Md387UXK/7l2tI9Ov/tj462k3JGckX7/eFrS03V77a22CDlfUbz8/8vTGqboJYfpa4M1+YlW+DXEJAC5KagA/4KYCWX33Cd7Bs1siY+na439BVXfNqyToPMOX56JT2ELrJGj0UzHyJotV6u6tmfeLn5UtK59jckXIKtB80VkQ4hcqTCX/+iNWHKnNAgh1cki+p0jWzGCIbMy7kf/JdKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jdF6c9EbA+MnUwWsQxH7n4FFBiavv4CMgENTOvaGhvI=;
 b=bZCfchATNmac34FsXEyXzWeRRj+LVUz5uGdFHoROSEx5AYWX3KiJkI53JoJK13nd6kSnSrwrfyyBzIYmYWPKcLCE//sTCWUUrFsv/5PUhC2EJebUF8cAf09rJPyZIbfoFzEHi4lkazadQYf0gAJ2ZCPgaLqmY2ppXUqKoxGFqhzFkOKSOvsETWdRIQcWiptBetapgVj+6sPuKNe1cXm+/JxFEPZTlXLo3xslWgy8A0idTepUKD92EIwDnqX6nW97Dth/t/Qptarx3xeh/lme0ZWxMv6Dc6hkbBNo2q8nr8BNIDC4UIyKbSBp/bO9m1ZJlaCM6B3eF0/pRlbQGPUX7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jdF6c9EbA+MnUwWsQxH7n4FFBiavv4CMgENTOvaGhvI=;
 b=zQRYixFRChqo6IWhK2m0fc/VQxXHOl6r+sy9lVVRPxMw5vK+xb8jVYUaD1KzNq2y45YdshHCox/xFjLTZXP8aah9g1y/oUIY2N+vPmHFXpTzrYoaBu1WhAWPXdYxvVYmmV6h9L4wClMWD5hr36ykCzPWtFaXFnkNGIptKbbd8WU=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by PH0PR10MB4439.namprd10.prod.outlook.com (2603:10b6:510:41::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.17; Fri, 26 May
 2023 08:51:01 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1%6]) with mapi id 15.20.6433.017; Fri, 26 May 2023
 08:51:01 +0000
References: <20230523090050.373545-1-chandan.babu@oracle.com>
 <20230523090050.373545-12-chandan.babu@oracle.com>
 <20230523173435.GR11620@frogsfrogsfrogs>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/24] metadump: Define metadump v2 ondisk format
 structures and macros
Date:   Thu, 25 May 2023 14:56:38 +0530
In-reply-to: <20230523173435.GR11620@frogsfrogsfrogs>
Message-ID: <87h6rzjx1v.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0042.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::23) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH0PR10MB4439:EE_
X-MS-Office365-Filtering-Correlation-Id: 4582805a-8fbb-41dc-49e2-08db5dc6549d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lLD1PPnapOw9NdZUxcKJ0pby2BTInf3qhj6GhiyV5riprnfEa+0zcWVGbaVqiwWKNJUgABG03OjFEPT5739YX5dHGxkFQb72E6QgqdjNrlmaZfYOrWm/gmwLex2/IK7zjcbU2Iuq8IV39GDCDh+9aGcKTVaxJBUKdyuZdnbW7w4fTZCz/HDd/J7mEiCEj+nTxktS1mxkUM5ESnKKyDjhn9aGEohPaYdlMkbE1EVsYrVVrDvH15lBx+AQX84LePioBrD1ox64UOuWTZI6QlYeHZwZa+XigqowM1ZfI2AdLnBJLAkO+Xv6kJsyLMvgWQ/9kC9/oBZ6PSO2VqQHSi41CPRX4Qyl4i8C5EsyV686q6QL+B5660AxF8WsTL3Q8L4zCpJY1DQXqOtSmdKGm8uiICAFjUadL0NC8M4r13TkQ5vsTt9jBGZ219hW8QcHs8f+oDGJ9UFo3RaWjsDIB2UzIy+lrI7hf5Ytz/GOzcG4lI2cKNawAc1K4I2+cNEdFOMoQvGEIFPJA67D8DHELJSyO8owZnDerwrg8bGvrKT6+87C8M3ANkhfSbLPhmh66Tr5GWWosTmMFaxj+u9MmLgIokfA/S9H5EBIBLX3MrEHWp1tEfJNyx5z10HFSiQn1hc8jrtcBwLbosiK+M0UgNjHng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(346002)(396003)(136003)(366004)(39860400002)(376002)(451199021)(83380400001)(2906002)(186003)(33716001)(86362001)(38100700002)(66476007)(5660300002)(66556008)(66946007)(316002)(6486002)(6666004)(41300700001)(8676002)(8936002)(4326008)(6916009)(478600001)(26005)(53546011)(6506007)(6512007)(9686003)(473944003)(414714003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ORTMPM2QV81Hq1hXEP4VUhfANnh3m8fw8vQlw2e2dh/AqHCdw3a/RkErY7r4?=
 =?us-ascii?Q?3oJhqdZJQqCV81YQCwgk+gsSnE4t9EyUreTUYLjTumEnDSe9gWBvWX2UL01D?=
 =?us-ascii?Q?N3UVMf2cYtR7enjRhDNHDzx9tGhFkHrRLRrlXVNvTAYBO0n+H5YFZIxIX9Tf?=
 =?us-ascii?Q?cIaL1WOvBCuTWLv5c/Fid9bv54+PMrjYCgp3OI4wP9anToo27lQOHuUxs7A+?=
 =?us-ascii?Q?e4W/newZy4+jTxv0zCtj+cFqNGD76yAcuK4ADsbvmCDvh7nuVzITA5aH1qMs?=
 =?us-ascii?Q?0ByKW/3yYJoePM2DsP4CsHw6/Kf30hb59pchjwbmNYb7Aw4nBhnY11DA6YhH?=
 =?us-ascii?Q?lnkGGD3f32aqn4bU5C3SOpHavtHBBSOin7LAg/xa+w74fhbue2RKk6AtaXrl?=
 =?us-ascii?Q?Z0t6iXOwQcEUQDqp6vZ8V/sQ3KiqNbmlZz9ksBC7h4IiRCJJREf6ZwDEvsoR?=
 =?us-ascii?Q?bhBN4DcjByAzmjg33EMNWoU+hIuRfi9btKwwlPMmQqhRFa8wTnw6woG5zYdU?=
 =?us-ascii?Q?wNKA4+CTgX47d/my/RYVyr86W89N0bNJgg0/6ULOYA22ofPnQJjyd1XaokbV?=
 =?us-ascii?Q?Oac1Fx9nTmP/HbnF8/tmu8GwM7YrC4mtFSZj/KLZqXT0kjpf7lJD7M87Rpdq?=
 =?us-ascii?Q?oynJLK6RMlCeOfKQPN8C3CjdggvQK22MT7dcKfTrDqqdZCFwDCD0owSw8DeT?=
 =?us-ascii?Q?l4aNmwpAN6yPkcEcs7gZxfeYUVDh87JnMZ/sbTHtTqkgF+42AnhUb/Ehhyj9?=
 =?us-ascii?Q?OlirE3sNrhM9QlK/3MrnRgh3qWxh0BdASFRpTeLikiGeeuizPcwGmSWNdE+B?=
 =?us-ascii?Q?RW0MtfljkEKy/JvtM+Kz2v1q8aXzvMMUezLT6/z1LO33/I87XkSBcRqgEasQ?=
 =?us-ascii?Q?QUVkuQqEk83m804JuVsrP7jC/AQewu9J3Vo+NkqR/Gu+SaMVkqikXuQxKBFm?=
 =?us-ascii?Q?411jw7pcFa3qmn7MYMD/6i63BZiwmaN82HV046kE8Rl3jI6T+JVm4XK9mIC6?=
 =?us-ascii?Q?AsFF/Wfvx47HkPBiA9lxqcNSvENzRrTByn3M9xoAPTOCC/+md2Znxeoswtxl?=
 =?us-ascii?Q?Hhv/zjQCqV2P+ugChM7ZRUNWa65ysuSeClhpBZVrS7icw27I/fdDvP3cWF2b?=
 =?us-ascii?Q?DMl8HsgEdFBmVPKycuVMxdE5Di2xe/jgWAD587sLcN1sqZrfbg++YnYnjF/P?=
 =?us-ascii?Q?THf+vjfXIk6nHJEoMRCJlROMhAYEGtTFAHDT5DqlSziAlBwiXSADAvYb/zsh?=
 =?us-ascii?Q?CmN7D5V6LNJlpVd7oq4pJxl6KsYU2Whgivt2vlbFThNet5vqHtGp9m4Xg2Qq?=
 =?us-ascii?Q?V+ojNABKRG8pKvzkYYMYSgmuPJ6/jl25CR/HxOcLZCI6FitY63IXXXGYX8va?=
 =?us-ascii?Q?dWVQGnI4umemUWkyS0DNzGq68wxdcV0dfXXmR3VPE+hzCpmXsU5s5PPFAK1J?=
 =?us-ascii?Q?sV/Gicw0ZzxnoyUmWZxS/O6wzrRd3j0bmhvH+JAZzQ0CFmoopfMIkBb70D3g?=
 =?us-ascii?Q?zceaailQ5I7s8sdenMfsBdhys+SiYGTOL1FfwwHeCERBRlTQxB2M48BDv4pr?=
 =?us-ascii?Q?jnhi13P3tojxxO4kIrsPkXr6GDy3L0dW2L2Afcnx?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 1j1VgTSltheywj6Aj1JqCCuKH01NW8i3tCNEUf5Xf5NIj2JUob5Z+r9IhBGXY4XwbCZALT60W8fmTqyQsTbFBSDnddCu7D7yrwS7MSZSDQRPGnpg/hvzy5oQzXvzWEPcQ4smLRIcRj9fr/hLCr/fwEZ9OmlxXgXC6KIF6T9FJvWdXW5cEhSkXy9dzBrlEWpuQSvSuFEFPumBIadjANOQoUGaZSXHHsFpK6HtJqXmtJx7GAX3hJ1n26PXslXfmzV1K8oiqylxAKdNFvfMThoxsfD1Uqe+9FXHuKS9ymJ0vkB4n1b16yDMARLh6aW1eOiJ9/dEvECqVQRWMlkS9SM9dnmkOGsMQwupncOAcVOn5R0iwOalRW7b1HoLZ7I3jfcv2uSVB4IdqzerSaas3AdsGQl0OEhE+xC8lox1QdyISJNf8PObql/Sk9WGB4CnpBOd1pJUPuZ9libxUnlLf5nyVHNEveOYBca5Ehjy0Vao4e3WFrMTGDRZCxb9tWM1xjw+RI9MesPAR6nWRvlByLKC+ghnIpXyMVBENP20LKupJJOPbQVuw9yoEY9wxxizrdMJdXCHUqpbD87S14Z4TyK6pXezNJejrsB+DuUnvPtn/61PMFzCGlRs0ohwqLEo8YahMj3amT/ZCn0C2htLiYCG1r3XRzUVXQtoM6VWVo+1bmHRqmFLsIN2eYEMDws4e+jCxpkKGuANbxaC2KY+EhCEZ93QknVIGDhv4Db7Jrv1OC8c77gKP77KZ3AHjpCq82a+PvbCvUaTV3VswFLKG/24m4w076F6/azEPK8LiahzoIQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4582805a-8fbb-41dc-49e2-08db5dc6549d
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2023 08:51:01.0920
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sX1H/zm/AMYn2zl2l7ec9DcxKJ7cyqL71Usb0a9wpSpi8YXkXpiwXICIhb8uch32diV2CjonxRclh+lRf+m5Dw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4439
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-26_01,2023-05-25_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 suspectscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305260075
X-Proofpoint-ORIG-GUID: ArCXq2E5HuKi8SxnAKmnyHll5L-yUM4c
X-Proofpoint-GUID: ArCXq2E5HuKi8SxnAKmnyHll5L-yUM4c
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 23, 2023 at 10:34:35 AM -0700, Darrick J. Wong wrote:
> On Tue, May 23, 2023 at 02:30:37PM +0530, Chandan Babu R wrote:
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> ---
>>  include/xfs_metadump.h | 32 ++++++++++++++++++++++++++++++++
>>  1 file changed, 32 insertions(+)
>> 
>> diff --git a/include/xfs_metadump.h b/include/xfs_metadump.h
>> index a4dca25cb..1d8d7008c 100644
>> --- a/include/xfs_metadump.h
>> +++ b/include/xfs_metadump.h
>> @@ -8,7 +8,9 @@
>>  #define _XFS_METADUMP_H_
>>  
>>  #define	XFS_MD_MAGIC_V1		0x5846534d	/* 'XFSM' */
>> +#define	XFS_MD_MAGIC_V2		0x584D4432	/* 'XMD2' */
>>  
>> +/* Metadump v1 */
>>  typedef struct xfs_metablock {
>>  	__be32		mb_magic;
>>  	__be16		mb_count;
>> @@ -23,4 +25,34 @@ typedef struct xfs_metablock {
>>  #define XFS_METADUMP_FULLBLOCKS	(1 << 2)
>>  #define XFS_METADUMP_DIRTYLOG	(1 << 3)
>>  
>> +/* Metadump v2 */
>> +struct xfs_metadump_header {
>> +	__be32 xmh_magic;
>> +	__be32 xmh_version;
>> +	__be32 xmh_compat_flags;
>> +	__be32 xmh_incompat_flags;
>> +	__be64 xmh_reserved;
>
> __be32 xmh_crc; ?
>
> Otherwise there's nothing to check for bitflips in the index blocks
> themselves.

The user could generate a sha1sum of the metadump file and share it with the
receiver for verifying the integrity of the metadump file right?

>
>> +} __packed;
>
> Does an array of xfs_meta_extent come immediately after
> xfs_metadump_header, or do they go in a separate block after the header?
> How big is the index block supposed to be?
>

A metadump file in V2 format is structured as shown below,

     |------------------------------|
     | struct xfs_metadump_header   |
     |------------------------------|
     | struct xfs_meta_extent 0     |
     | Extent 0's data              |
     | struct xfs_meta_extent 1     |
     | Extent 1's data              |
     | ...                          |
     | struct xfs_meta_extent (n-1) |
     | Extent (n-1)'s data          |
     |------------------------------|

If there are no objections, I will add the above diagram to
include/xfs_metadump.h.

>> +
>> +#define XFS_MD2_INCOMPAT_OBFUSCATED	(1 << 0)
>> +#define XFS_MD2_INCOMPAT_FULLBLOCKS	(1 << 1)
>> +#define XFS_MD2_INCOMPAT_DIRTYLOG	(1 << 2)
>
> Should the header declare when some of the xfs_meta_extents will have
> XME_ADDR_LOG_DEVICE set?
>

I will add a comment describing that extents captured from an external log
device will have XME_ADDR_LOG_DEVICE set.

>> +
>> +struct xfs_meta_extent {
>> +        /*
>
> Tabs not spaces.
>

>> +	 * Lowest 54 bits are used to store 512 byte addresses.
>> +	 * Next 2 bits is used for indicating the device.
>> +	 * 00 - Data device
>> +	 * 01 - External log
>
> So if you were to (say) add the realtime device, would that be bit 56,
> or would you define 0xC0000000000000 (aka DATA|LOG) to mean realtime?
>

I am sorry, the comment I have written above is incorrect. I forgot to update it
before posting the patchset. Realtime device has to be (1ULL << 56).

But, Your comments on "[PATCH 22/24] mdrestore: Define mdrestore ops for v2
format" has convinced me that we could use the 2 bits at bit posistions 54 and
55 as a counter. i.e 00 maps to XME_ADDR_DATA_DEVICE and 01 maps to
XME_ADDR_LOG_DEVICE.

>> +	 */
>> +        __be64 xme_addr;
>> +        /* In units of 512 byte blocks */
>> +        __be32 xme_len;
>> +} __packed;
>> +
>> +#define XME_ADDR_DATA_DEVICE	(1UL << 54)
>> +#define XME_ADDR_LOG_DEVICE	(1UL << 55)
>
> 1ULL, because "UL" means unsigned long, which is 32-bits on i386.

Ok. I will fix that.

-- 
chandan
