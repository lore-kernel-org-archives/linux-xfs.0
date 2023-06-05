Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19E63C77B73
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jun 2023 09:22:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbjFEJWh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Jun 2023 05:22:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231157AbjFEJWf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jun 2023 05:22:35 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8F9711B
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jun 2023 02:22:26 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 354NKm0t005956;
        Mon, 5 Jun 2023 09:22:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2023-03-30;
 bh=72z6ABKKLvp7+tuv58rTjpf/suCV6ApqgGlDTVBHN4w=;
 b=FMFp7WvuXCaxcjgbAHNNLS4mfGPj5pLVlOeKhvSebXbt6S6T2H6QibtBEofO9ovXEYL4
 ELvM8SZ+SXNufhu4opayMUup120eZzWKKtMaQX+jvD9al148MLMtijZSZKCUoOLoLKUo
 wXktdO821f8YaUZVuvbLZTW7h/wHtn+pS22Tgzdu0IE+f+BogA7NzS+0/5FYWjCQrd/p
 KT1HtBLH22PbQAhLsdbs6qG+XPfKQK6L0clYsZkshxfpkmyYBlJ1qOHoxGCSUY7gtN1K
 /HPfh/78CVzhipTaDNrHoVMMB90XaE4q5hED3cyb+gf0Fk1I/ohIqOfCulCCaVo9aPuA ew== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qyx43tg8f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 05 Jun 2023 09:22:23 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 355848VX024013;
        Mon, 5 Jun 2023 09:22:22 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r0tkffe1g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 05 Jun 2023 09:22:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SEpeK0bwzEblpKJr4McPugVaIsAoUVBHJxPXdp16yh1cs9B9zOYVGBvUjlgCcphcUAT6NBv2e29MgTelUTB53lWJHXzoxMShUcf6fYrdugIe36hQxUiqePfJdlB0nlc9MMJiHgYTDbzaGtDLh1y7yVQ8GzM4dxHw3wA7fHBVmIcTnKtOx2UpuUZG40/+IZC0+gSIBobXPZDAjUNzb2ANZU+QLLOs49zAzZP8OE+UGGpbtHPBTkjLVDUhFDQvjtDLwis9P1z6H7leHTufQWDRUJEAMOIuRmmZXLR/xLnbRstDaZvJk8xQVPwlYrwK6WUubKimGd+M4azQUdPLF730Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=72z6ABKKLvp7+tuv58rTjpf/suCV6ApqgGlDTVBHN4w=;
 b=YAFHpanRK/JR+bPi4+mSqAMx/eQyE1ELp33X5dmOT96GhMFbGzkdjEh/0ayLlCjlmJLsw3zAibacUHOsWklgv6KbM/KmnXtJW/hJ8yeV7xvSf+vpHCwR16PKOFsLk6DhpKiXYgb4cJ7FQk1Bl77uTQPn+fhMaXmoP6eBwoqDTDZBTl/CwFQJFnw6yy0dPPXFIHuHkdODYcA3OB1n4Mtc2QFYJAtRNtG9EEHuHLj+91ugq94wOhu7Q9gnlvGQ/c9iem8cVkrOKxbj1Hwgh4JkkAMvhvc9xXfzxHaSnHVYSztfbiIe03PNPA/MeqUNR0zm/p0lPUahpWEzX19HGohzmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=72z6ABKKLvp7+tuv58rTjpf/suCV6ApqgGlDTVBHN4w=;
 b=kevby947hqrFeUQXvmYPkUn8KYvwC1IrUicHJsSQ5LWBfFe6PGhfmxRKh0Q7W/MBQRzu1zTMNl7K99lCdleqPTSdaGzj6nwu+nmOSw9C89yPxSndf3mASFoMSXT4vVXRo/QQqEljVsKJ39vfE8IMqpn7XG9TY5X0o8rB48D3+d8=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by SJ0PR10MB4638.namprd10.prod.outlook.com (2603:10b6:a03:2d8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Mon, 5 Jun
 2023 09:22:20 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1%7]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 09:22:20 +0000
References: <20230523090050.373545-1-chandan.babu@oracle.com>
 <20230523090050.373545-6-chandan.babu@oracle.com>
 <20230523164807.GL11620@frogsfrogsfrogs>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/24] set_cur: Add support to read from external log
 device
Date:   Mon, 05 Jun 2023 14:49:49 +0530
In-reply-to: <20230523164807.GL11620@frogsfrogsfrogs>
Message-ID: <87sfb6462k.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0001.APCP153.PROD.OUTLOOK.COM (2603:1096::11) To
 SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|SJ0PR10MB4638:EE_
X-MS-Office365-Filtering-Correlation-Id: 5323a464-97db-4615-2f47-08db65a65cc4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UVc/bi2SJvBfcQJLtHyZnAbmk9BSGLMraUq3W6quW75pMXI7wApIf8PHkPi9QIIx7VTSC++E91gOmcqXShAEUyLC16doCCuiscjOykrcBOGqAvnHGKEYDmL4N1SEW5huNxDCKA3pdcxTWfM6NTwGJOeVXiEM8W/QGIRh2SwEmCyW3g0Ohr/XM3twHvV6ICGVOa5LUfQgY97QsKnNabPndmHOP6+lMeIv/pIE6XmwRzP2NiNiVpR98A4/b03fqy7TwFW5QwjHL4JboC44x0oTQ0d/ZWuY0QTLv6Eq6Z1c224g3vaoi/pXAef28Fe1eHpC0n26pllKuCCTcBGr2xKN5f7sN2Patere8WJhDRBSs65SQM/CpESH/H6D2iO6NVy7RyK5SXsHkO/q1Adi34O5dOIBfYYsFsuyj1+YuZFATUPw/wVBB3Xm1kecYfXYEPg2IPn5qtAFLDbSJc3q4nPxRrE0AB4n+5nGMKsn9uIzN+N95p2irFCCSqJU5LeTcJN0Gu1KSW13gg7LbCELy+BWFKWByzDj7DQCjVM0lwAMmt7QsIoUch1YRXdw1zK02Nse
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(346002)(39860400002)(366004)(376002)(396003)(451199021)(33716001)(6506007)(9686003)(186003)(26005)(6512007)(53546011)(83380400001)(6486002)(6666004)(2906002)(8676002)(8936002)(478600001)(5660300002)(38100700002)(6916009)(86362001)(4326008)(316002)(41300700001)(66556008)(66476007)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S2n1WL2vKxsvS/VpmV74NoFSstb12ccI5wSYOWIIjCYg8pk4R2wm6DfaQT80?=
 =?us-ascii?Q?55Vzd1RU0PAUzeLckj6ShyRr4hzBi9xTvLYKI9LzsGya669rHVTu+8jyx5yz?=
 =?us-ascii?Q?Wj69AMTxBDp9aPzybJjUG+IDpyZSq/UzkPzqT9MlYkDmnPdFYLPLfamWd0bM?=
 =?us-ascii?Q?98CcSj1fJBv/ztl0jtFvOIYi3Py6liLWvUEkOZxmy9VmmxsRPYZGxlhe++5w?=
 =?us-ascii?Q?Djq9pFDKl4fm8HVv8w1aqAyopb3EmnfmjDcZ6tdO0pXNRec64df1A8uliHpm?=
 =?us-ascii?Q?FKwTO/0EELMQF31tyGbn7G3KUb4OB3J4IeYmSaEDqRJ2KNnFgrUfEZ5UjT+4?=
 =?us-ascii?Q?14PQ4P+TwvPZNdfin1YjCqxv+ue68RiyoUVTKXaDpw7NoxZALHXnjiv1/plI?=
 =?us-ascii?Q?fcCKy9BIpENUlnpcMjPoH3Ek+FYcnCYiqRGqBGng5Vf6ulSGGAU/mPJM2dxf?=
 =?us-ascii?Q?QLbJaCWee1XQhgHXEfdyhnbgOQKRSbTOsV5COU26ktBHsMuI28AYFD//Cfkb?=
 =?us-ascii?Q?0R7b0Q0vGFn3BhXFlcTpbId0hr+Wd0HpCaT8gctT0BmgOtCoJtu5qYeCM3MQ?=
 =?us-ascii?Q?WRoeCPTD8/cgz/edqXiZdSbxM5Y+FHIw0oUsrlGjcIHU2M5n945yBwBiKmTX?=
 =?us-ascii?Q?4t30MpjFNCle7sRim0ROmkQw3Bjg9E4M4EbSz6dtdzXdevhKp0QLjbEfTfMK?=
 =?us-ascii?Q?e0AMqxfC+XpHzkFHm5YwShM2Gc4z6Gr9VmZf/uCoJDZBcElWHVV68UG8pwpd?=
 =?us-ascii?Q?39PirYmfxyWQyyX+Kav9VPuzeaPj/aKyTI9UxDtmgKrN17Hb9InvZJOksaBY?=
 =?us-ascii?Q?5A8Dp1dXuVtLwhytf0YfDUBjBUrwcchIBreXKNi7NSMXQgBuIGz76OOv6Z31?=
 =?us-ascii?Q?FepYkPHaaWDtKAfKzSW6mxR8BfMVU0llTbEG7v0RSpGbwDYiTlAriANwz1rs?=
 =?us-ascii?Q?2ybiqNmWSNHs5ElRuvatY09KJXxKjh/0HguixisU25LSogrSxq8rJXlBu61b?=
 =?us-ascii?Q?C5hcPQ0YovSM8dZe1o66CanOF+nrTRYP9cbYfn+WeRIHH3ZfIYkC6JI73xZU?=
 =?us-ascii?Q?tzaHH+TSZOP5I2cUaRYbH6uGYUoR5PBq/ApuaZdQc9YQGuMlmP5TcwndWEPj?=
 =?us-ascii?Q?BRT0bFORMkraNvYdrRCFJOhgXQkXb2v9S7UVYR0EswykHEKK3ETFNl7qyID5?=
 =?us-ascii?Q?SBhODXuVdtnYPCFNPvEbvsGfYdKY2kAcLh+QPW6cnxKc3ZcrD5IKqQmiX3aG?=
 =?us-ascii?Q?mH2Xb9tngJ57TSGkqoMc2aQsTw6TLIIxyD7twlvs+N72RVDd8JHHpk/9ZUJS?=
 =?us-ascii?Q?3N6FKkN55FgkSWdDFoQAiQE9xxq7dDjrSJxuv4L4HqQF34dxQmnf/rop2yOz?=
 =?us-ascii?Q?p6Ant2S4PaL4lIT1oX2ysi5i3DeWMGnRHv8um9wVadfTT6NxSvcJEmdJo/hY?=
 =?us-ascii?Q?XKbOl9SipaDj/H5Wczh/Anx+S97w6moZT30GSG0nlYkRGPbeVFZ+rCKqHilE?=
 =?us-ascii?Q?mprYpVv9dtq6X0dD+A8xmkYqqDOvMBKesjtY3j4iBe6S1jgTOdPwtiMyfbuG?=
 =?us-ascii?Q?pgKkEQ/+Ao5+y1dHG58zgfU0u9SIU8GqxXspuz5U?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: U0tW0wGKWRKf5srltqSwQmVu448lQ/E/Q8J4oNRU/7ewirlfgXl61T7dUVezeB7gEbpklpj1NEmTHo+hz1+8WRO2vQSUMPdsXokO6Wkl5Ybh+ux8OqQuYnRu4p8PB4N+sM2NTfGQbSUjQJYWh1RyIu00tEj8/K2xeD4YvrwnDpQkZFDoZnEeNHGjcuAAlLecigCjSTp1iYpBfwZvJHCjA7JownqCw9IB03Yqp8/m1Gn9NRI4et86Sg+LKU38BD8oEk71hwtoTyENcrrRupPLy9mKLypKNoMU4g6b4aVQJqFiC+ERzo9+47vpqLsFBCOjuP5Fmf+oLkNsfI7YQK/VAIQphyB5gvVToK2a+ilR80MA/7jGhXv16AuzK92TjF8tv5+m2fA6OJyH86yGw/XKV7kfa7KMgHdmtp5ElFb8aj6iUAJ4FZiV76ODCdRP9pyV82Npjiwl25fjxRM7edEwOXcyebNRtwHKa1S3dNPwYkKQRn7SRSHGTB2Xd4SbOWUfhTi9MWWThbKhrKq0YwYKOlf9bROhGhFOKCFEDL05ukHxr3Wk/VYyd55voiYIuHZSlC/aZtj+w+6c70nqh33Tn+Yn+eQmdAcpkw1au4n1AznRwGps7uUja1g+QGjqiRb0bVnZKeTbW7YQHyESCHl+xPvv0bFVJdzUNj31M/1Ds3M8KoqlikSH5dRLth25FSCK7yQ1xUaxrrbm+FGKXfEUKEaBTWalOEiDw5ikjQoHNVqoump/gKDz9ExcYIMZYRNvNZzNvfo8CcgB9PNy43ky7CGxd+Nb4ZvG96D1nUXFerA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5323a464-97db-4615-2f47-08db65a65cc4
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 09:22:20.1523
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xj6IuB3XL/pd96Uvl8VPC7rco5g0pQSvGnSB5pJO3ePlPvr+acJUCoABzV0x6g/u9XApWALHv7bqToyzfDHDvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4638
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-03_08,2023-06-02_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 phishscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306050084
X-Proofpoint-ORIG-GUID: jA5gE2oU4rIaU732HjNhBRcfS6wHXKeL
X-Proofpoint-GUID: jA5gE2oU4rIaU732HjNhBRcfS6wHXKeL
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 23, 2023 at 09:48:07 AM -0700, Darrick J. Wong wrote:
> On Tue, May 23, 2023 at 02:30:31PM +0530, Chandan Babu R wrote:
>> This commit changes set_cur() to be able to read from external log
>> devices. This is required by a future commit which will add the ability to
>> dump metadata from external log devices.
>> 
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> ---
>>  db/io.c   | 22 +++++++++++++++-------
>>  db/type.c |  2 ++
>>  db/type.h |  2 +-
>>  3 files changed, 18 insertions(+), 8 deletions(-)
>> 
>> diff --git a/db/io.c b/db/io.c
>> index 3d2572364..e8c8f57e2 100644
>> --- a/db/io.c
>> +++ b/db/io.c
>> @@ -516,12 +516,13 @@ set_cur(
>>  	int		ring_flag,
>>  	bbmap_t		*bbmap)
>>  {
>> -	struct xfs_buf	*bp;
>> -	xfs_ino_t	dirino;
>> -	xfs_ino_t	ino;
>> -	uint16_t	mode;
>> +	struct xfs_buftarg	*btargp;
>> +	struct xfs_buf		*bp;
>> +	xfs_ino_t		dirino;
>> +	xfs_ino_t		ino;
>> +	uint16_t		mode;
>>  	const struct xfs_buf_ops *ops = type ? type->bops : NULL;
>> -	int		error;
>> +	int			error;
>>  
>>  	if (iocur_sp < 0) {
>>  		dbprintf(_("set_cur no stack element to set\n"));
>> @@ -534,7 +535,14 @@ set_cur(
>>  	pop_cur();
>>  	push_cur();
>>  
>> +	btargp = mp->m_ddev_targp;
>> +	if (type->typnm == TYP_ELOG) {
>
> This feels like a layering violation, see below...
>
>> +		ASSERT(mp->m_ddev_targp != mp->m_logdev_targp);
>> +		btargp = mp->m_logdev_targp;
>> +	}
>> +
>>  	if (bbmap) {
>> +		ASSERT(btargp == mp->m_ddev_targp);
>>  #ifdef DEBUG_BBMAP
>>  		int i;
>>  		printf(_("xfs_db got a bbmap for %lld\n"), (long long)blknum);
>> @@ -548,11 +556,11 @@ set_cur(
>>  		if (!iocur_top->bbmap)
>>  			return;
>>  		memcpy(iocur_top->bbmap, bbmap, sizeof(struct bbmap));
>> -		error = -libxfs_buf_read_map(mp->m_ddev_targp, bbmap->b,
>> +		error = -libxfs_buf_read_map(btargp, bbmap->b,
>>  				bbmap->nmaps, LIBXFS_READBUF_SALVAGE, &bp,
>>  				ops);
>>  	} else {
>> -		error = -libxfs_buf_read(mp->m_ddev_targp, blknum, len,
>> +		error = -libxfs_buf_read(btargp, blknum, len,
>>  				LIBXFS_READBUF_SALVAGE, &bp, ops);
>>  		iocur_top->bbmap = NULL;
>>  	}
>> diff --git a/db/type.c b/db/type.c
>> index efe704456..cc406ae4c 100644
>> --- a/db/type.c
>> +++ b/db/type.c
>> @@ -100,6 +100,7 @@ static const typ_t	__typtab_crc[] = {
>>  	{ TYP_INODE, "inode", handle_struct, inode_crc_hfld,
>>  		&xfs_inode_buf_ops, TYP_F_CRC_FUNC, xfs_inode_set_crc },
>>  	{ TYP_LOG, "log", NULL, NULL, NULL, TYP_F_NO_CRC_OFF },
>> +	{ TYP_ELOG, "elog", NULL, NULL, NULL, TYP_F_NO_CRC_OFF },
>
> It strikes me as a little odd to create a new /metadata type/ to
> reference the external log.  If we someday want to add a bunch of new
> types to xfs_db to allow us to decode/fuzz the log contents, wouldn't we
> have to add them twice -- once for decoding an internal log, and again
> to decode the external log?  And the only difference between the two
> would be the buftarg, right?  The set_cur caller needs to know the
> daddr already, so I don't think it's unreasonable for the caller to have
> to know which buftarg too.
>
> IOWs, I think set_cur ought to take the buftarg, the typ_t, and a daddr
> as explicit arguments.  But maybe others have opinions?
>
> e.g. rename set_cur to __set_cur and make it take a buftarg, and then:
>
> int
> set_log_cur(
> 	const typ_t	*type,
> 	xfs_daddr_t	blknum,
> 	int		len,
> 	int		ring_flag,
> 	bbmap_t		*bbmap)
> {
> 	if (!mp->m_logdev_targp->bt_bdev ||
> 	    mp->m_logdev_targp->bt_bdev == mp->m_ddev_targp->bt_bdev) {
> 		printf(_("external log device not loaded, use -l.\n"));
> 		return ENODEV;
> 	}
>
> 	__set_cur(mp->m_logdev_targp, type, blknum, len, ring_flag, bbmap);
> 	return 0;
> }
>
> and then metadump can do something like ....
>
> 	error = set_log_cur(&typtab[TYP_LOG], 0,
> 			mp->m_sb.sb_logblocks * blkbb, DB_RING_IGN, NULL);
>

Darrick, How about implementing the following instead,

static void
__set_cur(
	struct xfs_buftarg	*btargp,
	const typ_t		*type,
	xfs_daddr_t		 blknum,
	int			 len,
	int			 ring_flag,
	bbmap_t			*bbmap)
{
	struct xfs_buf		*bp;
	xfs_ino_t		dirino;
	xfs_ino_t		ino;
	uint16_t		mode;
	const struct xfs_buf_ops *ops = type ? type->bops : NULL;
	int		error;

	if (iocur_sp < 0) {
		dbprintf(_("set_cur no stack element to set\n"));
		return;
	}

	ino = iocur_top->ino;
	dirino = iocur_top->dirino;
	mode = iocur_top->mode;
	pop_cur();
	push_cur();

	if (bbmap) {
#ifdef DEBUG_BBMAP
		int i;
		printf(_("xfs_db got a bbmap for %lld\n"), (long long)blknum);
		printf(_("\tblock map"));
		for (i = 0; i < bbmap->nmaps; i++)
			printf(" %lld:%d", (long long)bbmap->b[i].bm_bn,
					   bbmap->b[i].bm_len);
		printf("\n");
#endif
		iocur_top->bbmap = malloc(sizeof(struct bbmap));
		if (!iocur_top->bbmap)
			return;
		memcpy(iocur_top->bbmap, bbmap, sizeof(struct bbmap));
		error = -libxfs_buf_read_map(btargp, bbmap->b,
				bbmap->nmaps, LIBXFS_READBUF_SALVAGE, &bp,
				ops);
	} else {
		error = -libxfs_buf_read(btargp, blknum, len,
				LIBXFS_READBUF_SALVAGE, &bp, ops);
		iocur_top->bbmap = NULL;
	}

	/*
	 * Salvage mode means that we still get a buffer even if the verifier
	 * says the metadata is corrupt.  Therefore, the only errors we should
	 * get are for IO errors or runtime errors.
	 */
	if (error)
		return;
	iocur_top->buf = bp->b_addr;
	iocur_top->bp = bp;
	if (!ops) {
		bp->b_ops = NULL;
		bp->b_flags |= LIBXFS_B_UNCHECKED;
	}

	iocur_top->bb = blknum;
	iocur_top->blen = len;
	iocur_top->boff = 0;
	iocur_top->data = iocur_top->buf;
	iocur_top->len = BBTOB(len);
	iocur_top->off = blknum << BBSHIFT;
	iocur_top->typ = cur_typ = type;
	iocur_top->ino = ino;
	iocur_top->dirino = dirino;
	iocur_top->mode = mode;
	iocur_top->ino_buf = 0;
	iocur_top->dquot_buf = 0;

	/* store location in ring */
	if (ring_flag)
		ring_add();
}

void
set_cur(
	const typ_t	*type,
	xfs_daddr_t	blknum,
	int		len,
	int		ring_flag,
	bbmap_t		*bbmap)
{
	struct xfs_buftarg	*btargp = mp->m_ddev_targp;

	if (type->typnm == TYP_LOG &&
		mp->m_logdev_targp->bt_bdev != mp->m_ddev_targp->bt_bdev) {
		ASSERT(mp->m_sb.sb_logstart == 0);
		btargp = mp->m_logdev_targp;
	}

	__set_cur(btargp, type, blknum, len, ring_flag, bbmap);
}

i.e. We continue to have just one type for the log and set_cur() will
internally decide which buftarg to pass to __set_cur(). Please let me know
your opinion on this approach.

-- 
chandan
