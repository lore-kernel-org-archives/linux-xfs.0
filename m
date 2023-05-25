Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1B66C7EE2F
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 08:48:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242426AbjEZIs3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 May 2023 04:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242575AbjEZIsY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 May 2023 04:48:24 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A83401A4
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:48:23 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34Q8itnI017240;
        Fri, 26 May 2023 08:48:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2023-03-30;
 bh=XSBsgrktOe8Tu6JBZVRAGf/c/rFElbjNw1P5nHiU0Ho=;
 b=NuSM/pXgFXyme9YOiUDAkgWKXtx8E9+6QEZvEwf7i3BHrgiDREBGzCYGj/Wi+yvAfZG3
 niXDHvP2ZwY+0vuMYg4XNmIugBnLMyI4OFghMpo7zxPLhr08N4Nr7Mss+l17j7wkwNj0
 cdz/uM7wFm+mX22ykV/5wEj7Ox4h2an80Uct7tMYJsBH+rAjrZ3HkoMwY/SojiD8L2jR
 UjghomnZcuVkdQ0r3abGgRJ6MQP59shcj7TGmovEyh00lFj0d8O2ULM6oNe+C60FtENh
 OrBZ/HjyYcz/8GdnIZaEtTcuMz6cLUvEL7Pp4iPXQIRrtoRr0IVCyfxdzZ2nIzUEPn7S Pg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qtshb00g0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 May 2023 08:48:19 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34Q6fljl027327;
        Fri, 26 May 2023 08:48:19 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qqk2he5gw-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 May 2023 08:48:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kHV/ibojIFaWJ1Co1kvUcwLIA581oYMrFx1DcJpC1UCy9oeryuOtr6dWAJZLhwwF/mdkQJ0VdXR6vN1VYzSTEpnsMubV4/esJqQ+aFgBxSVCXWIDEXMTTFCQ8zXx6OAZloH8TG6WPhB5u8IjvspKdLPBCyLjDRAoUteGXPO2eWG6G4OFtyb2K5+hbvUoMKV/w1YS9VA6B/pza+zpWNJ/TWHN9Vy9p1fusgvxZte171AGXZ7t8NPlyddvhJ8UYJOwhCMmHf8II98MkFO39qbXwlycv6SjbLZx2lO4HxMyir/hRNhiUeK2DoXFa125wp9bayk22oPgCjSDtsdzfZLL1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XSBsgrktOe8Tu6JBZVRAGf/c/rFElbjNw1P5nHiU0Ho=;
 b=DDNGsy22vpmJNLjHcIAkiIvAavgc9YJ6rHwLMe4eNZ638DJB8ut9O/Kr6dSOE7xMBAFCHtgzqFL6QYwXSmdJp+LOBAgg8wUg6q3xY6vR/a/8yPS9aAw5FHQDOFE2JwgW8OLQXxjrPeLVHZS8z2KUhlhP0vwzhOiJ7wj9d/ghg/s4eXlCsA8hKPk+WogCxUfK4GQ9Q4Tnq+uXaH0M1PrTJKc/YjMeZ6heWkjzMqR31LH+B0ADxbsWGrrV8mk+DbzOqHYY6J/P5uIXh5PnYBVI3RMiYHngKgBjrkKu1FEIDG3+ub8DUp4lBnH5e4j9CQeRPyGKb8giOE91levFc0t3GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XSBsgrktOe8Tu6JBZVRAGf/c/rFElbjNw1P5nHiU0Ho=;
 b=LiKzxDG5nUW37J9tZjGsoDbhaFOzUbgx6sBpN8Ljai7kWAwD5ggO9qgjyVPCsQ1mjjvnedHodsi11d8FhxSjdB4al/OYuFHZq+mqO6o9emuL4+RP3OYcWjFI9YKWEy/vXzBM9pf3kHWJfb1SQi8A/021LuSOmNlW7azgCBnYmIg=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by MW5PR10MB5713.namprd10.prod.outlook.com (2603:10b6:303:19a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.15; Fri, 26 May
 2023 08:48:13 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1%6]) with mapi id 15.20.6433.017; Fri, 26 May 2023
 08:48:13 +0000
References: <20230523090050.373545-1-chandan.babu@oracle.com>
 <20230523090050.373545-6-chandan.babu@oracle.com>
 <20230523164807.GL11620@frogsfrogsfrogs>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/24] set_cur: Add support to read from external log
 device
Date:   Thu, 25 May 2023 13:57:59 +0530
In-reply-to: <20230523164807.GL11620@frogsfrogsfrogs>
Message-ID: <87353jlbqw.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0057.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:2b5::20) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|MW5PR10MB5713:EE_
X-MS-Office365-Filtering-Correlation-Id: 79860c5d-5ac9-4b26-6b05-08db5dc5f0dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: raS5nMGejordiOyv2dgATqfyzDPIdl4ISA6TbVZN0+AE9eRvB8qJ7glVQQhVvQLsVhuxIxxpZQ9+v3Oi2ynCWK0yFxdDaRuCui3geLXI4TV3dz0/dMCPUip0Z7qYLTZeCjkVyb9/OsQmzdvNvfNFcviNNmFqob56EPZbh8/gF03l+4tlK3x5cbz3rzJ7y3CoVJf9Hqr85g1+ZR4UNVoCD23s7g62vVq99/GmW5l99ncQPbTubv+6GsZMVI5+6+nzBrcrPsMsaZpnTMlR9mKiMg+aRWLQHkda2fudihdToUxbyhTLLhqq0oh5xNOGUIpIlPrKn1pJIrRviM48a1vcOdiBJ+kDIEDMvWX+NyiwLfNgU3Tu3fsvSINEh8hAC2FjdfTMR03zFY0LYMDhOcKblbIU1oJVyp5oAR542FlWMpQkgMZLFedWlVog/pLvMG5L21htMTCkxqQ8Do+PymA/J2DPke3UcBeUGAJ1PQhDw4pfnHTwa5rfMpgJWni94akQ2rZrDJ+EB1QVgL2E7CzOcLnA7U//6p+AXzoTDJAjrk/+whwxf/IZE7rFK8vtzGs4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(396003)(39860400002)(376002)(366004)(346002)(136003)(451199021)(5660300002)(478600001)(41300700001)(8936002)(8676002)(6486002)(6506007)(9686003)(6512007)(53546011)(26005)(66556008)(4326008)(66946007)(66476007)(6916009)(316002)(6666004)(186003)(2906002)(83380400001)(38100700002)(86362001)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+2cmCClsQ6M4Fd6MGK2C7fr68RtjOfOPaqSHKRGrt1bsCdJEGG7T1fNLonaI?=
 =?us-ascii?Q?45qg7h/tTqIa1YpW7tO7toHwKdiMQYlzutp955Z4b8C0tNdd0V2+RiQ3RgdE?=
 =?us-ascii?Q?s7Zqv5wzO64KLU5F7gZw03Z1qMyVAJWl27zWUxm9jTGvlxchk5O48FcLKO5X?=
 =?us-ascii?Q?TmqZpTai8Rb1KzQW0R4qbPEzCnPAdVFtpSp+qLnEVD4jtYKA41xVQoig8j9S?=
 =?us-ascii?Q?6fSVxedFkY+THt4+YajIwrAlxQTtXoHkSsg1GVNG5+SnvK/CDgaBloj/rYI8?=
 =?us-ascii?Q?uo39S72G1pZZ8Wghz/r4MIQkcPkisSFpPZs5VPG+YgOMkv1eq9VhkEwNUpJL?=
 =?us-ascii?Q?0E1NalhGuALAJKCkM787vCzSKRIaFTu3ZgUGsxs0Cssr6MPyDK1uUqJ/w8Vb?=
 =?us-ascii?Q?x+27OiW/iTZjvEWhs0AYwlTiMVZBUUZ3OVVG49y0YjFVra9W18IgJffN8OBq?=
 =?us-ascii?Q?kGPVdfNKf/Lca+23IAYBeSvx9HQAbnq/6anz6H8pDzlLFdsL8HfxVvu4CIjt?=
 =?us-ascii?Q?eiK8X+zTrt5j/A/imXFZdknIkNEmCUT2eZmvki/5j7uBAIKuyYk/z45ioz0y?=
 =?us-ascii?Q?cf+OKN0fWTewRykmKh9i/FFbLW1K8ZadhAtwNj0Lo9txlEddKxaxJf8jMmJf?=
 =?us-ascii?Q?m0+aeUR1nTEYJWls7Qs1G/u3coIZiMk/vtSpCXuLvzsQ0yy6Thy/SlG/JRbQ?=
 =?us-ascii?Q?d3iK8KiFwSXy//S7HmbY5LwoRTQVvdJIWyr5pX0NmuC+drh1O8G29tRB2jVp?=
 =?us-ascii?Q?1wabf23ONHu7CNGWZF6119QdmdkNYBFN2Ja13Qi0WqHx49RZjXOWbUgd2SRu?=
 =?us-ascii?Q?dyCFGsTblUgsEx4uoH+K6siyCbBNmRdrf1TwFN3LdqKZzTHUzx/q18pkAQPw?=
 =?us-ascii?Q?4+l6LEJomV12ZxhBB86rU55a+9ArUrKl5lToIVs2Z7BmXx3eyJE1Dy2U456j?=
 =?us-ascii?Q?1+Qx0FSkns1PEFfv+clKStq9u6xHX09x8jdRvbYYcZ7wjd4wVhV+GPzHRpdU?=
 =?us-ascii?Q?AMTMJUoDJxsjcbN14mmAROWvA4IynXFXnffZ1AQ0oO0WAYkqn5oNy0oZyvpk?=
 =?us-ascii?Q?NazYDO5OSnq79cG9QISx0qzgyv8kjVlhqUu7IWTsGOnXqJp+k4P/6m5eguI7?=
 =?us-ascii?Q?+ctaAYqeSucMjmcrilTQ09IaB/O5ql/FRwRbjrdGYbsWDYtGJtG0yegBdHtI?=
 =?us-ascii?Q?N4WiWFZ614IujEh8A1ownOdpru0dBNA00ECD1m8HjSEhMe6cFQ07awve8KSK?=
 =?us-ascii?Q?8NulmEIhFj4LANVgrfRmOFiwawEZhrBn2gppFW4DPAQx4GIqwpQM/mFXUxZO?=
 =?us-ascii?Q?uvMlfRBL/wGX4lUPqYA6P6ROEok63GddcVz/PIvb1WTEyZdg6WQspq8FCrWZ?=
 =?us-ascii?Q?kmaFCzCOFkx5jeTnGFEcFXM0Kebe1fxvgadXGM2LuckJuH4vVlhXWNRlhNU+?=
 =?us-ascii?Q?su+jthaP9vHF/wb9FqAWgj5uYYvUj5r0WMy/mdz4CWOK7jlaHwYie2NFpkVz?=
 =?us-ascii?Q?4q85OaBamnB0I24Ga9J1YOQXEunNdoYV/RL+KZNuX2KaVmZHpc+rxpCdfDvr?=
 =?us-ascii?Q?RVHbQ9qgITGrJ07ck8eeNV8oIvGvvkBqBkcC7/wq?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: CCex/jAd1EqPHM04e+96VsKS7/KxTMtAM6Q8YKWV/215RDawew+YOOqY6npU8YMuCH8b5VkrfHqjdYutPerO81aY/Q1ErDW7SDDYdmQCtINgEGZ/N9IxhO5cHajKLiguK/lGwvyxyL04HYebvVBx84Xf/oRegJWIp4iZfPhDqbBcv4iFVqLE6jR4Wi4kzgaiP724yl4iBGajI24PIpntB891y0NrzNtoSz0j53WFYViPhZ+1+JHTwMTQkYx30zuObDLneBQO0NAblggnLVtm75ALUpCEVui1X6vinoVU65w0LfG2ESc9UeV3dFbxLP7OHgA8+cFuMfII5PwnfwJNFfoUbX5HyL87xodngNHXSCRwidjfsRiwcr4bmkYa/BMXAY3hj9IhoHC5QNNMFAuiTjlaRd1Go9e4MyJ+UQ1+8xPC17n1g1VNQ9HpGgYUCiKqAqOhtHxo/TmIIS5Zomp0hfFuPqDVid9V5BGGVsuzNEPRLwodDsO7SQvq/J8k8zmsk5pRJuccuTxW+4kQUMk9oQ1Ig62YWiWqtqxte4mtUgy3fj84Hfg3OBuBb5WJBY2+MCk+ubvpoQagMfdr3rOEHC5Lvk34cSkpaJA9QVLqtP5bSpzOYgKS4wXi4gZhAhhLPhyvoITQ4SFaQWg2+hPayk1aNpGHH5U6Mil2BTYbXpl5QjIKR0pDuDKCVzWIzJh6kbJRyeDfW7VyeMS+Am5PtJ6bMax+BgeX+1cs5lZbp3CPDMO3PT4xVhYtKBoD4qmia5MZvo8+lRF7I5Mb1x0HuByk779c447Husr4KgKuA0I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79860c5d-5ac9-4b26-6b05-08db5dc5f0dc
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2023 08:48:13.6587
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MMWwbJup9YLvw28XwLmZp4ejNSHzvyObDoceLfRZo7zVpJXQcs6aMKk9s/whIPC0EUPS7f1HIWeteoeQJohQ9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5713
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-26_01,2023-05-25_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305260075
X-Proofpoint-GUID: E75UNwWC53UvNawrht938pj8CqY4rKp4
X-Proofpoint-ORIG-GUID: E75UNwWC53UvNawrht938pj8CqY4rKp4
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

You are right about the requirement to add two entries for each possible
operation related to the log. 
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

The above suggestion looks correct to me. I will include this change unless
others have any objections to it.

-- 
chandan
