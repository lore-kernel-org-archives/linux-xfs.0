Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38B9EFA373D
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Oct 2022 01:59:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234558AbiJ1B7T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Oct 2022 21:59:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235481AbiJ1B7M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Oct 2022 21:59:12 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24D33B2DA1
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 18:59:12 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29S1i2Kj018913
        for <linux-xfs@vger.kernel.org>; Fri, 28 Oct 2022 01:59:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=9C19Ne9NCr2J8z3QHcQ4gf6qnXjCkdpg2IapPG/h9IM=;
 b=3WJy8N9Tq0AAamT00cobYk1itkEnZD1DwUxHt0tXNK3X0qKzMuzJdDHojPF2koMaFfl5
 6GkhWIrA/HdsS5pwLqB14YvPxl4bk+QOwogrqZLmGly39M71fTjdIw8VGzydjVDVLiYO
 vZ/2Z4vTP4NP0/C8ky1gZZH9UjYy+X6eziMV9nq6EtZYYPM9+514nGI8x0pv2485zp37
 qWGtIN+LS0oxPeq1ovgP5118Xd2C4WETwMATKNFKJw31jwyxhQMIxMQLYcCASm5B6uHE
 tiarx1QtCMXhv7YxO81/6C4dlu6HZyBje24AQTpcO/xkMKNJuMW0Zk0Je5IyRNS0XfJO 9w== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfahec4ne-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 28 Oct 2022 01:59:11 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29RLZDpj017612
        for <linux-xfs@vger.kernel.org>; Fri, 28 Oct 2022 01:59:11 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kfagh38r6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 28 Oct 2022 01:59:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fH9Xd6QsNQO/9clzvmIbpYWHOK7voAeZ+7zJN8yaa/SsaKqLGKVf1yuvTWTSg/89sBR8fCxydeQX7ZJsjK+bjw1/nYvVRCqd7+DQlWi/dI+cNADdJcfuypu4+5Rm8jskYJwOcsuv/dNY2PGG+T4QTtNP7UqYRrPs0rPBEhRQlIOJ/J+3qhqXJg/JSFTa6zzPpEkBo2QPdgI5eyM9yTlKm00LFD0kYcpg9exILGvZJQ6ahe8jn6ZOi08GDfvTFYoZZgdpn+nOnpKTwgw7mZE5px9A6GxGUcyzOFqQODl6YHPjcc0ODp8BmC96Kz2cZKrzkXBS9DuyLOZBmUw9n3WqPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9C19Ne9NCr2J8z3QHcQ4gf6qnXjCkdpg2IapPG/h9IM=;
 b=KkoHCn+vw6aNeqAWePc9sFamzblzu3OPJME6WrQeV8n7bYOl8mpEK1rQ6HGKjAnZx8jNsSP4r8sH4QXy3m1KaFn/IcBrMrDNGyMNYQ6bCZNFZXxNINhgDhWEqPPKw5/MXUypv+wuIX/eTiwaSKjLlaR/wv6ZoBhQ4k/VvUZKqLjjz/Rw+UP0aP8EFlP7J3l+51LDhrzx/c3PoPZVh89atUKdNdou+2TTMq/WEWIX8dUDSLGiPx8vtxQ9lQ2I1rJZeN9klu/VygTQ8UTwzD7/ETIxFfLHim7l80SOmQY2rA9ldfPyK0RyP0WaUlEioD7Iz9cjdG6yHd8fu2LcoOHEUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9C19Ne9NCr2J8z3QHcQ4gf6qnXjCkdpg2IapPG/h9IM=;
 b=a5iW42gMRIWipIuRnErSH/B4Kxrw2JlhcWvyVpGjMQirXcuRN3cxupXkQzIibPk6BEgg0q+jc6/ipdM1IugIDowQiIPzQqYa4FnsRVJ49kXR1bPHzmD84a8IxSHTjA+MMN2ah6Paymb+HX0vhaokzfRHKZBYArUgZDt2Hb/bcJs=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BN0PR10MB5048.namprd10.prod.outlook.com (2603:10b6:408:117::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.14; Fri, 28 Oct
 2022 01:59:08 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::17e5:a392:97fb:39e9]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::17e5:a392:97fb:39e9%6]) with mapi id 15.20.5746.028; Fri, 28 Oct 2022
 01:59:08 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     Allison Henderson <allison.henderson@oracle.com>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v4 05/27] xfs: Hold inode locks in xfs_rename
Thread-Topic: [PATCH v4 05/27] xfs: Hold inode locks in xfs_rename
Thread-Index: AQHY5Zysx4Chfn2axECiV7OLcA8FEq4jFoEA
Date:   Fri, 28 Oct 2022 01:59:08 +0000
Message-ID: <DBA96878-A1C1-4602-839D-F8A0A7BB3A4F@oracle.com>
References: <20221021222936.934426-1-allison.henderson@oracle.com>
 <20221021222936.934426-6-allison.henderson@oracle.com>
In-Reply-To: <20221021222936.934426-6-allison.henderson@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BLAPR10MB5316:EE_|BN0PR10MB5048:EE_
x-ms-office365-filtering-correlation-id: 2a3a5b81-3f85-40cb-77f0-08dab888005c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bl3l0gBuhiv6ROy1mJ9JrJibOJDcEUXVxmisH5fWQJRHCSzWlhZR0orBI0G+jVi0IVJuHJyeXsjtPtIUpu3klo9Ccc4o3uQvjo1Hhf6fLXgVCFSqas148/soh+O5oezQTlnciDZjd2hH0n9ZINTQsDIPwtv3jvDg3qjweLWbu02rCKDoMlnxwk8YAnKRBxEpd8eXoEFUFe8r5ryIv8FTB1RWfmCbclu4lj2c+WVhus7al9Z/aYEO7MJkLtv291tJfYjY6b6FGvZNVzJWHcXwrYxqCoqVoMAWrZLo777Z071TJ2dfInxYkitT40gPD7yMpdzWwuF9m8llcKCqmFxrj3DOpPoS+s062szI6D1tiTfRxFnR4s0zHAXxSk/K0e00vrH3Q4KZLT+DS7KZcRejhdHrxFI8Uh/K4IXRZdLw5Ov+qiUp0JavNoMU0cI1xMtvRQRdG8aYVAN3ykmA1kAZIeej8kng/51l8xrqOAl5iQeYERyxhlcmNZfMtz6ZzETx532vD0Tu2I4xJrluFwfqRYlmhz6XuEVxe6E6X/CpStBgAVSWCJQrrFR1dggNWRKOXbyLljcPbeIq7GpiCLGKfjL2ld1rdggWYS6VDq/YXlH5CoOBaU8gMSTm7kP1zBZvTETZ4zeXypAJ8gMu9+jvE4Pn46ODo+OaVJdtaQpPlcz683D+1PfGbV04IhvzVZyfkZ+kZfrcHco/UgvDAuKmPVhlc1OzQcUGmjPeet+fp3pZp/dcbozKiRLJY/vvVXDyq4JDjsjTrx31olB7yn9PVyWcAY0SgH0Py4A5NIMekiM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(376002)(346002)(136003)(396003)(451199015)(83380400001)(8676002)(36756003)(33656002)(66556008)(6486002)(71200400001)(478600001)(6506007)(53546011)(5660300002)(76116006)(8936002)(4326008)(64756008)(66946007)(66446008)(66476007)(6862004)(37006003)(6636002)(41300700001)(44832011)(91956017)(316002)(38070700005)(122000001)(38100700002)(2616005)(186003)(6512007)(86362001)(2906002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6k9ea+rPidO675dDztSp8ZCXgNNSQZlB3nxf8KuvTy823Z79JrDHLPmnSrV0?=
 =?us-ascii?Q?3s+lRmRLZ1Cm/8y6Fmy/I7ZSUfjJaSSvHWU415VKh/Nq1s4+1TqU9bseM9Hy?=
 =?us-ascii?Q?lP38+Sxy4GDuwONtGWulJk74d66Bc7NxQ0VnAj+y8U9Qki2nWFGu3/z6eOVH?=
 =?us-ascii?Q?JqtyXpc3fb5gSwsjhwzyf+sYvbsYOPJ+FwdpApKCZqhUTWlp4AIU3ZZcd8tR?=
 =?us-ascii?Q?EbKqa/aRc9y/b2lrYC5Lc27m1IzNfP5FZTS3EkmeuWipLI+J8ULlPs0LsFKV?=
 =?us-ascii?Q?jk0zh4CbMF/PvmlQPTc93/Y4A7mRbcNdIb/G39JF7J6CKS1BM1Cx8Ve8WNgC?=
 =?us-ascii?Q?V4FnVZWmJWZ0c9s/8WCWp0fl4tWFx7Tuc+WQjJiAtkoULL6eGtLPHKa1GWDA?=
 =?us-ascii?Q?2ZZjt/NlGxlEDvrtxSZe4wcSgn3QK9QzQOXa6Rd4rhJ54EJO7B57n8Ywqk5r?=
 =?us-ascii?Q?zNdxy239vSXXolNMmq9VI3rKwpouY8eSm+w0CXdm94n6HSjYD60f0X/jUx6w?=
 =?us-ascii?Q?iJ37i27pU8uKx7BhTL+LI/X0NN6qVckll8sMS1eYqbsl3oOT4USFvaIt4LoH?=
 =?us-ascii?Q?ULlpEBijpW3pc1VDPxqllY8pW4UPE/3cjk3PMzQSZ0AH/ysHGSLDNQoF+iZ3?=
 =?us-ascii?Q?czKtGC+7XtWnT0h3ZgmCELbK7Y1KIbDRUC/GzcLMgMEmUhtmi928hyThFDNX?=
 =?us-ascii?Q?dlICN22MoSvHmWi0SqnJJhBtaSuIXsKnuhWfv/MLz1bWmIHy3A/GufVFfCmv?=
 =?us-ascii?Q?iXTpa/vfWbW8u+4yCTVp/v6K4vQUMixlo8uOt0wGiyLOf4mXBmCJVpl1tukB?=
 =?us-ascii?Q?30y6AE2ugbwYMFUVt1hLzEzheZl7E3IiIYer4cNkq3nEHi0kRx6Snf746kM6?=
 =?us-ascii?Q?2mfTyaDxMroyEgvn1dZqiH58dq0TwgOYgUtM4Q6iu8HLq+t+HrvMFe7FOvBK?=
 =?us-ascii?Q?m32uuA3u4gfQrtRNqqZiChfG7Oa34zbDR83UX/AqjEJCYVITeCruXY8096Jp?=
 =?us-ascii?Q?3xUqatolurQK2TQv0XXm/zOV1RZHQe4qQcFnUeN4OqntHHR9spAEU0owOpDV?=
 =?us-ascii?Q?KZxXMphLsOb6bDsFwq6XxHeHU7ElJHInuoDl1myCf1Mc0uj7jqX0zoRWlNAz?=
 =?us-ascii?Q?Dm4tWyPyQ2OVVJ5oRILNI9uofXPpHSXr7ujEwX8P8kx5HFStZ1nKVGjtI4MD?=
 =?us-ascii?Q?m5vbjPr47UU8HGdQ3GJ+KtijRAoAVIKx4YtkmfpHDhbQ6q6Xomk/8T0taUCT?=
 =?us-ascii?Q?oLTjENOJL/UqzN4K69YP7JK2LmQqnjuAagPkDEnuUcM5IttaUhByv5TYLFcW?=
 =?us-ascii?Q?ekptgXDfXbStrdT3v8lLQgUmnk6gcR7tCa+Chs4jIwurs+FcrVRykaIyFzwR?=
 =?us-ascii?Q?Ltdt0hWA91wbonA2twBo+nswQ08idOYo0Yu2BtnVg8hnan9bDu2MIZdPHYlu?=
 =?us-ascii?Q?TITHte50900FY+5s9lUQqcj46/9QFph0G842L7SZgNmnE3rKNeX1WrMroGey?=
 =?us-ascii?Q?OubV5tzue+q5ly2s96YDXDWveqXUPYa3q7iCsr+vbjl+9HSOFR4OuuZZrV+y?=
 =?us-ascii?Q?xR9fyAEEx4PztMI4/1HuegmKFa+XOGOSqrpq/Y14GivrYUJ/o0sxULsnt0NY?=
 =?us-ascii?Q?i7QB91v8CVjYsYdZnacaq4DKqZklNHJAdKWFeyeEAkIWTZJ+3M8QyWkp44Gr?=
 =?us-ascii?Q?63Z2TvrvPhlMgSwbqfyO3nsGxPI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5C1032BAA526934B930937A1340D5EED@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a3a5b81-3f85-40cb-77f0-08dab888005c
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2022 01:59:08.7000
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: skHu2WMm+viL9sDPOzY3qFg6GpQ5y29SZfdLogPqcblS3lZ41ggwTa1/ophpR2L5gm5C7ZmLIZmDl8cN/8MbBeRalz6/1uH4CGZq7KWhsgA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5048
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-27_07,2022-10-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2210280011
X-Proofpoint-GUID: HP_PpjLdrxg28SVu2uB8fDQVh1BGFqls
X-Proofpoint-ORIG-GUID: HP_PpjLdrxg28SVu2uB8fDQVh1BGFqls
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> On Oct 21, 2022, at 3:29 PM, allison.henderson@oracle.com wrote:
>=20
> From: Allison Henderson <allison.henderson@oracle.com>
>=20
> Modify xfs_rename to hold all inode locks across a rename operation
> We will need this later when we add parent pointers
>=20
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Looks good
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
> ---
> fs/xfs/xfs_inode.c | 42 +++++++++++++++++++++++++++++-------------
> 1 file changed, 29 insertions(+), 13 deletions(-)
>=20
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 9a3174a8f895..44b68fa53a72 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2539,6 +2539,21 @@ xfs_remove(
> 	return error;
> }
>=20
> +static inline void
> +xfs_iunlock_after_rename(
> +	struct xfs_inode	**i_tab,
> +	int			num_inodes)
> +{
> +	int			i;
> +
> +	for (i =3D num_inodes - 1; i >=3D 0; i--) {
> +		/* Skip duplicate inodes if src and target dps are the same */
> +		if (!i_tab[i] || (i > 0 && i_tab[i] =3D=3D i_tab[i - 1]))
> +			continue;
> +		xfs_iunlock(i_tab[i], XFS_ILOCK_EXCL);
> +	}
> +}
> +
> /*
>  * Enter all inodes for a rename transaction into a sorted array.
>  */
> @@ -2837,18 +2852,16 @@ xfs_rename(
> 	xfs_lock_inodes(inodes, num_inodes, XFS_ILOCK_EXCL);
>=20
> 	/*
> -	 * Join all the inodes to the transaction. From this point on,
> -	 * we can rely on either trans_commit or trans_cancel to unlock
> -	 * them.
> +	 * Join all the inodes to the transaction.
> 	 */
> -	xfs_trans_ijoin(tp, src_dp, XFS_ILOCK_EXCL);
> +	xfs_trans_ijoin(tp, src_dp, 0);
> 	if (new_parent)
> -		xfs_trans_ijoin(tp, target_dp, XFS_ILOCK_EXCL);
> -	xfs_trans_ijoin(tp, src_ip, XFS_ILOCK_EXCL);
> +		xfs_trans_ijoin(tp, target_dp, 0);
> +	xfs_trans_ijoin(tp, src_ip, 0);
> 	if (target_ip)
> -		xfs_trans_ijoin(tp, target_ip, XFS_ILOCK_EXCL);
> +		xfs_trans_ijoin(tp, target_ip, 0);
> 	if (wip)
> -		xfs_trans_ijoin(tp, wip, XFS_ILOCK_EXCL);
> +		xfs_trans_ijoin(tp, wip, 0);
>=20
> 	/*
> 	 * If we are using project inheritance, we only allow renames
> @@ -2862,10 +2875,12 @@ xfs_rename(
> 	}
>=20
> 	/* RENAME_EXCHANGE is unique from here on. */
> -	if (flags & RENAME_EXCHANGE)
> -		return xfs_cross_rename(tp, src_dp, src_name, src_ip,
> +	if (flags & RENAME_EXCHANGE) {
> +		error =3D xfs_cross_rename(tp, src_dp, src_name, src_ip,
> 					target_dp, target_name, target_ip,
> 					spaceres);
> +		goto out_unlock;
> +	}
>=20
> 	/*
> 	 * Try to reserve quota to handle an expansion of the target directory.
> @@ -3090,12 +3105,13 @@ xfs_rename(
> 		xfs_trans_log_inode(tp, target_dp, XFS_ILOG_CORE);
>=20
> 	error =3D xfs_finish_rename(tp);
> -	if (wip)
> -		xfs_irele(wip);
> -	return error;
> +
> +	goto out_unlock;
>=20
> out_trans_cancel:
> 	xfs_trans_cancel(tp);
> +out_unlock:
> +	xfs_iunlock_after_rename(inodes, num_inodes);
> out_release_wip:
> 	if (wip)
> 		xfs_irele(wip);
> --=20
> 2.25.1
>=20

