Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF9F4C00528
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Aug 2023 13:20:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232504AbjHBNUs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Aug 2023 09:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbjHBNUr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Aug 2023 09:20:47 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 711D58F
        for <linux-xfs@vger.kernel.org>; Wed,  2 Aug 2023 06:20:46 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 372D0GBb022286;
        Wed, 2 Aug 2023 13:20:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2023-03-30;
 bh=nH08LhOt3yw1LDjQA0UjH3vKtvEwPuFvlS0LavTInTs=;
 b=o7IZdkpLIbukS6LEfkpeJlxIkhOFF6FEmQ1k7kKuQ17iArOM78KOIVIepmtJR8yefqGQ
 pwhY68RLz3Oc+JlM2VYnN7Yf+OaBn9/ToMfjEEySzA6Mx6r0HyxrlLvkRsUjO3pLbnTa
 nH0J2mzfWN1X6cL3kZ9w1l7RJJfozUmxfEgEer/MBOfb8sLR7u8TVXBvIh/EFJ5oDteB
 XIXc4JucfosPkbVPN7UfjzG9vPRvKPMsNysJd3cz+Ie+rFsiR3V3/1F1Y0nwZoKobOuQ
 qgGUAmnfMzH0bL93OtVN2+xaQuETmlDvu6rcIDBdY7SLJ3tIVUbU7rn9gcf3lUtZTonF yg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s4uauy6x7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Aug 2023 13:20:41 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 372BmJuq020501;
        Wed, 2 Aug 2023 13:20:40 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s4s785svh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Aug 2023 13:20:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=byUx0tb59smy+uMaJgbi1yRlv4saKCEyUTEnD7k5ouM0BAw9WMmLaImmSIK/8DIEkqXYDdTQtw5M5VgLjtOTvq/g2IDDJP+Q9v7ngbngOTXk6MIR1ko5xsYbIAbfsjqtC2O27MUzMbls5HaB5kjwfnhbgMIwcOPnuJ+SMjcAXo9L2nrmrkFEhXm42DE7VlHbEoeIYSl1JvN59wnvOc+SfVGz+uwptXGrcCDmhcnqMYNREhxt5tXLvVl3G8K0cbUnPm8AjfljXaTw9fV+zDaLdwp8w75vp4AHb/xwRXVXDlB6dRR0bQT+QQ330/MWe0NshRsCnqSMNiSnDJRvJ/nUHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nH08LhOt3yw1LDjQA0UjH3vKtvEwPuFvlS0LavTInTs=;
 b=f1n88OdBycOg5fhbNSwC9mXUTyRpvZs041W0p688zs8eBJJlVzLIgqZXZhDtxEvEeQ0KBWvg9qa81ZmuewLSfLYS3F6Hoj7/LPKR8kFKnHJmYDo81PjJjLuaQIzylwKlaSVj/jOJifGkbEnAFxZyYo3eUMEyCUffx3K+ck4Mt7c6KPdM3bnDzHcc5j6HIqDizIZpZBM8cGA7uD2CQtPeJs8bt5DH0s+HhCYJ0HN0VqkSrQeIa3KXRq7hXyWUW4UaIr9STl+KLI8J7O2T5IFJexi+XBpEDd6i3Ao9rDdnbCZu8w6tXZdPe0FGOunxEAqh4wNLxhylLxtPHYkYFsD6OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nH08LhOt3yw1LDjQA0UjH3vKtvEwPuFvlS0LavTInTs=;
 b=Mdw2XqFNXORm2r7XnL0dFKyWX/TY1A70ReEF43loRd9MkPc8fBcq4fqojSItubqP67rkiTbPMd/4AAgc0v9YmQZkbk+N/VPBUbHalWx1V/qyU/5YVDw1oGk7nVi0xr+gFdLR98YKWUB4E3K/GZTAfRMWTDCpWOiHu6RKfgVQRUY=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by DM4PR10MB7389.namprd10.prod.outlook.com (2603:10b6:8:10f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.45; Wed, 2 Aug
 2023 13:20:39 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0%3]) with mapi id 15.20.6631.045; Wed, 2 Aug 2023
 13:20:38 +0000
References: <20230724043527.238600-1-chandan.babu@oracle.com>
 <20230724043527.238600-12-chandan.babu@oracle.com>
 <20230801234919.GS11352@frogsfrogsfrogs>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH V3 11/23] metadump: Define metadump ops for v2 format
Date:   Wed, 02 Aug 2023 18:38:54 +0530
In-reply-to: <20230801234919.GS11352@frogsfrogsfrogs>
Message-ID: <87pm45r36p.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0005.jpnprd01.prod.outlook.com (2603:1096:405::17)
 To SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DM4PR10MB7389:EE_
X-MS-Office365-Filtering-Correlation-Id: 465b375e-0d04-49b0-1280-08db935b435b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GL+ruri9Jp9npMYyZi9vMwsEc236fQ4BSfFBv+lX7Xk5e8KI9eQ8Aij3/lk817NnQVRrnWSnHtHMSyFATmzCGVhUiAVffNKQZzD5LJgyWImjbJrN6uATUAx3cFaNewuUUCtqA2Hpf87uohXHAB/BS1/JnAUJvgA/DkV9WqSbBFfuTumnpP9FzE20eXzp+cQozmwbciaNFkMpg2c6E0P4nwJ7VSjDpm8heD6a92r+Pf0WXAXkg2J94aNcBYwoopQU9TpRzsaGJFI/rwNvervtFV25qVtQ6mymzbGTBeLRno/hxqWTQ25IsWq/UySJxkfbnmhvIWpGB8FCPHlw96fvNLHcSeXaNwekORDJd/PP0iW64ZQrsIgakXh708GppJkIG37LttQKPj0TnLL2gztqEmx63D5e8bMtD070Mj1DLHL01KuheQ36Q7NELeY8+0IZDJVmC382xLWcRKawMtSCQYoPUe0/4toW1m3phM3iMHhuDhuQVgzdba42wYBcilDHnc6OpJ3H7FOcE/a4ehTjO87DH36W2DDDaelwHWzbG8aBc6im5S41W5XEO1KIy0AP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(346002)(39860400002)(366004)(136003)(396003)(376002)(451199021)(8676002)(5660300002)(33716001)(83380400001)(41300700001)(38100700002)(316002)(186003)(8936002)(53546011)(6506007)(26005)(4326008)(6916009)(86362001)(66946007)(66556008)(66476007)(6512007)(9686003)(2906002)(6486002)(6666004)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nOyEYpatmTseZpGSy2IB7Qh/qmjco5NsFka90TzJilra/WTOO3eJ5bLYi7OH?=
 =?us-ascii?Q?syEg78MzMsHJfxO3OkEQ1SpNSyyTlv/0bfyWVuEaRzQ6u1KG1KXIxZAXPdUu?=
 =?us-ascii?Q?SeHbKHhEKsTjU5Zpa00gPYZpqlyi+6fymii5rlMsubTpXlAluMRhbAQBF7VE?=
 =?us-ascii?Q?w1Fiaq46gcUqthemAO6y53m+WdqyVaIx7Of6y5sIKYGp+H20yYEG6iS3eJ9y?=
 =?us-ascii?Q?H84VQBnSF4CUZx9dzYV/GZNHd27Nxbwf/sl7oX0cP8+kSpX1X74K0Y3WztU3?=
 =?us-ascii?Q?AbfSRXmFyCHSdxL5QFjzDH8cAYS5lgY56q2pwcbNZPWsYq1rHdUKMiQdkCi8?=
 =?us-ascii?Q?LSLd3679YVDnMOeYIVSR8N0H4M3vS2M318S7I+x2H4nKED1U8mb3sltyjIr3?=
 =?us-ascii?Q?6i5p5as1aae1uRMLlUKcbn68FhI0GJoAwvhqOO/yrkJNnf80dKR341USz3eF?=
 =?us-ascii?Q?fiFFtks2VcK1BALhZivTYgZjtl/ECCXvnBSlcU+tFvrFKNxWnn3aTBW6+R2u?=
 =?us-ascii?Q?ShwsrCursPdyy0xT2GPHBDBEniVVh9tjObGvGxw8NtPCdTjWQ/q8bS2xMzqO?=
 =?us-ascii?Q?Iiaryu9jmmAwMEPv458mOzOEmARjlTVQFUqdrl1hveLTPCXiWM9xvPyIPRCk?=
 =?us-ascii?Q?rN59iAt0WkXtlu4lfXTtb5yNItWWffUWpHOycoZvAIZEyBymvTnmEwATy0nd?=
 =?us-ascii?Q?WqyIdzLqRKPGagtKQHYEo1mXA09LPD0BdVbLkNq2rUlaDu1EPD8M2uTA4tAF?=
 =?us-ascii?Q?xClYbDiQZGY/NHLL9VYPDn7nVn4lyemvF6bN6DD413iIcF0gdGX1sgEHMwnX?=
 =?us-ascii?Q?mSMlrwURCDWJrXaFod4TCwMdxwHYIfYmCQKBSc6vyeWLWSf664cFTdgYZWRV?=
 =?us-ascii?Q?dPEhALY1xGZ67OTgW1e2DuT3SBCm0jrORnYYUuAkdldkvKTkQqJ9ZUx+7T+s?=
 =?us-ascii?Q?iHSwowUhLwU8JvvR3WeHrmGGK3fhhFNaxsmGSOqpY2P6S53u+RbgenmwEqNK?=
 =?us-ascii?Q?ksg1+ITKZc63qFD953X+EtvD8N99E5TXXkKhWftKkyPLztPFPh2Z5ulQd6I7?=
 =?us-ascii?Q?DnHw3Uw3unTHdo2tpwIDBlk2vfmADaroUgAw1DAgvPF4cDSeQFu6VsLTQMG4?=
 =?us-ascii?Q?kA5P0ceMC4+UufcIVAkU2OL9XVFM0ETaPUZpLVFY2jabUcxRwiIdIwVF2AsR?=
 =?us-ascii?Q?b2sxo+/u9cm+hG1c+cMp0Q8hu2DBwbkQtXZwhhMwthbrqeOTXJFo9kjwQy8s?=
 =?us-ascii?Q?nhXMsAHwNKS6anws9AbDJe1biBq2917xIxlc4mvtuWd7NLoIeu85E7n1OvjJ?=
 =?us-ascii?Q?gSsk1HEnMZ/Vw1YEqoBeD3bCRo2QC/xw3fDVPosSPZ0NuSffDo8aFlXX01Uc?=
 =?us-ascii?Q?PQFpNe+zArW6whNksoj6eyifKgJhjNeMI4iKrqZR/sCFDi1KCy+6K5/QXZlr?=
 =?us-ascii?Q?Xi+t3ReDWVGT6LGO3D6LW6s24H/qP9vkRaWVwb2y9rQla2xAIjHkJuSnm89U?=
 =?us-ascii?Q?q4QgjBotOX50SnJLzR8DMND3e75SuG0gquAtF3j0YH04HTFI6B0OpVBkDFXY?=
 =?us-ascii?Q?dYiSqvgqbNdF8eSP4dW/5TAXoLY5G2aYY4rBTyxAmbLRAObi63h0KbNGia3f?=
 =?us-ascii?Q?Cw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: P9o7tu/mUGFxW2jAkILvFFVH8y7vXE2bzhyPxAUL8vtf2l+L0eSJcGjHFfp5a5PTGAZdA+YEvCHnMvbS+4JH8xTy9MQyb9g+BXXA3/4BwvBAC6pbMuz+LQljs0C4y7H6h01VyAJb1kugL5ET7Tvh/3tZ5AWnPGRuAwzNEBtLqkQsLq+7TZ1SzG3EIDXJJFt9dm4LVoFNHKgUWT1Wq2mPWq0megXnvebymCX2x+ue++sfOt2OvMBZRppA05mNRhL+1ESuJWhyu9CF+rfKwOA8tZhOPLxxketIxBURr02qWPKmR3Qkrn7X4MRUFLuD27R45Ae8ZUlBfKKEF3GgZEq/k1nFGw2Jh+7q98oQ/agN3Lr5UStS98lIOLgr4UL4RpJGqpQK/bqIRXSZCEazZyciZzXjvctSbc5d0VapUz9y03m7Ai0ZP5gCqW1jce7V4t1GVgmuaz5+GgWzBmwxORcoFVdmCLZex+47/yLPmnroEG8KMn46rsKza5cPYVXZ9hLyycaKidybsEsShmEBhWY3DitTGte9APKM3DqoryZG0ITeEz7/mFx+gkE+9gEfO+hCTm54OadHSNXy2IWIkPHiMk5dI1O9zD49z4CeoFcNcaNVpFqzZTrG6m1ZMmb6AkLomng+XCAxn/YPAcJG8Qe29b+mHxlA+NSIVtPMi+benkoZHcAiT4h0uCPAwRQYZh/VULWdOaj5mUq9rA5x3ezoohcgi5dRQWw3jMjd9CIo7PijWnmBdWzCvC6RSeaXQZu77fMI9SGISs8fJxEkEPrTaHV9tU6ddgSHivwbZhVVDMg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 465b375e-0d04-49b0-1280-08db935b435b
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2023 13:20:38.6990
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XOcCJF8deqyF8IM1KuAwHZYQJR/tLPr9p9RGmfGcvvKBKMG5cN5OgrTpHsqIONgJQYZHrNFU/Ua6VJx1qkvkcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7389
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-02_09,2023-08-01_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308020119
X-Proofpoint-ORIG-GUID: fGdAia-qtub-eg9Tqizglh4b0hhtzaXb
X-Proofpoint-GUID: fGdAia-qtub-eg9Tqizglh4b0hhtzaXb
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 01, 2023 at 04:49:19 PM -0700, Darrick J. Wong wrote:
> On Mon, Jul 24, 2023 at 10:05:15AM +0530, Chandan Babu R wrote:
>> This commit adds functionality to dump metadata from an XFS filesystem in
>> newly introduced v2 format.
>> 
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> ---
>>  db/metadump.c | 74 ++++++++++++++++++++++++++++++++++++++++++++++++---
>>  1 file changed, 71 insertions(+), 3 deletions(-)
>> 
>> diff --git a/db/metadump.c b/db/metadump.c
>> index 7f4f0f07..9b4ed70d 100644
>> --- a/db/metadump.c
>> +++ b/db/metadump.c
>> @@ -3056,6 +3056,70 @@ static struct metadump_ops metadump1_ops = {
>>  	.release	= release_metadump_v1,
>>  };
>>  
>> +static int
>> +init_metadump_v2(void)
>> +{
>> +	struct xfs_metadump_header xmh = {0};
>> +	uint32_t compat_flags = 0;
>
> Indentation     ^ of the local variables should be tabs, not a space.
>
>> +
>> +	xmh.xmh_magic = cpu_to_be32(XFS_MD_MAGIC_V2);
>> +	xmh.xmh_version = cpu_to_be32(2);
>> +
>> +	if (metadump.obfuscate)
>> +		compat_flags |= XFS_MD2_INCOMPAT_OBFUSCATED;
>> +	if (!metadump.zero_stale_data)
>> +		compat_flags |= XFS_MD2_INCOMPAT_FULLBLOCKS;
>> +	if (metadump.dirty_log)
>> +		compat_flags |= XFS_MD2_INCOMPAT_DIRTYLOG;
>> +
>> +	xmh.xmh_compat_flags = cpu_to_be32(compat_flags);
>> +
>> +	if (fwrite(&xmh, sizeof(xmh), 1, metadump.outf) != 1) {
>> +		print_warning("error writing to target file");
>> +		return -1;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int
>> +write_metadump_v2(
>> +	enum typnm	type,
>> +	const char	*data,
>> +	xfs_daddr_t	off,
>> +	int		len)
>> +{
>> +	struct xfs_meta_extent	xme;
>> +	uint64_t		addr;
>
> Please line up the      ^       ^ columns.
>

Sorry, I missed those. I will fix them.

> With that fixed,
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>

-- 
chandan
