Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BF03ECAAA1
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Oct 2022 01:52:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbiJ1Bwn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Oct 2022 21:52:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234030AbiJ1Bwm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Oct 2022 21:52:42 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B604AD98B
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 18:52:40 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29S1iK37019059
        for <linux-xfs@vger.kernel.org>; Fri, 28 Oct 2022 01:52:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=strXWCUVJVE/ayHJMTCiYaJiD7xCWn1hnmF1HutWk1A=;
 b=MISHoNH6Yv1qT603ADVR3GbCu5lzgABB46rephrVuv3s6Albh1Ex6eFkju1a4WkzgkiE
 mYyTzku+G9RA13OdHYCbdo5oeqCqR8jVB27UOjShyyBL3W7+kIjUBb4Yjjt3k9vuXOZU
 hW7l7ef5sSIx7u6zk8YLLm+iOyM0UWmMHwCll3sP6VikEZJyNEGbNmur8NYTBX5RxXEV
 DArmEyo9hDinNXHNAi9HnExJcd1KPkfllYHKMOCopj5h056y8qdh9J75a+I+nz2OW+p2
 b+B/kUVCt+YBpKxJsOrgyWF+eTGG72GJwyb/UkXDjNrouK0TzGx6DgkFao9/OYHZlu0H Cw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfahec4ee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 28 Oct 2022 01:52:39 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29RNJKr9026493
        for <linux-xfs@vger.kernel.org>; Fri, 28 Oct 2022 01:52:38 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2044.outbound.protection.outlook.com [104.47.51.44])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kfagqkv61-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 28 Oct 2022 01:52:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QPC4I66tuX1WC/fyCvXMPBii6W4eBNGUYXB/L1UfvugYvDHy0wMTnCwb1LxEfJbcHkHyiV5TfMYlHKTYhhNhggcuZVvAsAJuimi/72JhNzTrLiGGRgX9MAYxAFZKSI0UtdGJNE5dfRQH/4FvzCfWWxoFz64Zu23cgvegHsaMiKu6XNUBw1xFY3kHxMk13V86eVc1V6ucjHMmgZZiOi+Fq/7sgKO5TynZpSq/qIYOq7fBq9kl2G/38+ZnpmSA5paNcz9XiLqmON/tU0WdjF+HJkcFdQJPNaqWWkmunuuB6aNqJ7fUr+dntXjTWiph2UA0RtB7ptfDCTuzbDrFlCdPWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=strXWCUVJVE/ayHJMTCiYaJiD7xCWn1hnmF1HutWk1A=;
 b=KSCHAfmktwE98Gru/vJvOv3ke9wbyxJz9vZuNr6xsFh4SbIRMbVM3ZjyIOs3M/By4pjRWEfFSg1ZV9SAcK5Q0xIrjUnK93VU1atzciJrk1IcxbXXzv6BSYvcvUzth5agV/k6I+Zu9APjqz1wxXv+sj74YLGFre9xlNDzJpGNSUn2yn0SnXCsYoLyQIKK8PNSGeJyVQ7x/Ipgm3Wy3ynLLfQrWCfNzxrWiuHE1gzeeLr1Q8GArm136hIH+Sb9absU4ebnNoo/2Skpo/sZkJCW73jKlyJbykwSl156/OBipmYm3QCDRTWCZjeWFF1iFfn8KwUt1mc5TRN1nRCyy5/WMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=strXWCUVJVE/ayHJMTCiYaJiD7xCWn1hnmF1HutWk1A=;
 b=wsONWcycn2O0zCcx0LcSDDD4Qs2s3o5foHmaGyYXlZo/If6L4Pw0zYoy9UajP8BgYzz5BQW8Kqx6c9zXdmizrAk9kl9gjC77lNLM9uiqfTrXv/TL5Pz79+mLCpsy4GH+deemBttWXUmK2NrOhW/xFkpLnKEYJl6IuL+U4CzvGWo=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by MW5PR10MB5875.namprd10.prod.outlook.com (2603:10b6:303:191::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Fri, 28 Oct
 2022 01:52:36 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::17e5:a392:97fb:39e9]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::17e5:a392:97fb:39e9%6]) with mapi id 15.20.5746.028; Fri, 28 Oct 2022
 01:52:36 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     Allison Henderson <allison.henderson@oracle.com>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v4 02/27] xfs: Increase XFS_DEFER_OPS_NR_INODES to 5
Thread-Topic: [PATCH v4 02/27] xfs: Increase XFS_DEFER_OPS_NR_INODES to 5
Thread-Index: AQHY5ZyqQIxrFu/wl0eJrN5zZ3xtWq4jFK2A
Date:   Fri, 28 Oct 2022 01:52:36 +0000
Message-ID: <0C64AE87-3272-49CC-859A-3EA2E6764788@oracle.com>
References: <20221021222936.934426-1-allison.henderson@oracle.com>
 <20221021222936.934426-3-allison.henderson@oracle.com>
In-Reply-To: <20221021222936.934426-3-allison.henderson@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BLAPR10MB5316:EE_|MW5PR10MB5875:EE_
x-ms-office365-filtering-correlation-id: 0aee6a7c-7d03-4d04-1559-08dab8871655
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9vAcpuftihfPEUr1L0Og2lRvog2xT+tFMXgbMBxNlxwC5QU0t+tL0vdHBo+VHDI+Z/H8dta/k5mBMQeYdGr8dzyOpwY/a8aEGWUbQcDMgXo2lBh4gGsFFTZJpqzbNpbcWCq7bkRB6m/zrAH7ln6+uTpdRwbd70UZQY1d884aFEfMmZBReqNbCcgqIvOfwRLSlTSlQAP+J7F3cqKRof9ju9WMiMz9AwrDSL5SERgHcABYVmOWHx+rvdIqsB1tgEIR8nlc4iqW9Z510u/KS9p3tvFTTaNm5tTCfEisg6YX5zIRhOMnRQloAVSUPujlX7Wz6B/rAApmhdH6d1flBz+v9X0FtY36y0ZJSPJIosYbqu2lgrAK8/pjI0NgIb+rjMxXYz63frdUsDsrhHrpSeowpPHjRRNkTSVUk2gKZx80i2EUQ1KbeG44Nt5MIFQzkTKN7BKr0bAIu58RFCZEuMELb9daGXgAMwJIu3xfK+wji4l60XUzevoS+LgTYahTWKhVlG717aIzis8sdqSEmdxG4YxX2nBAAIETTWLLbwx4Onp2l/E5bRxw73GLcNpyoiezKwgGOVH0iknNxKoK91HaB4cFBZhiURcD2ubaShyz4laZcYZ7Hs6a0rGyRi/FV21tLKrDzhNpNm7F74dMgfg4k/14CTg0XumPVjzVEmDJYj80jER3K6fWXjKoIDOrHDslHuySPD9Ssbb/3wsVwX+f2JgJC5JYH8oAYS+EbZHe8tnN5B5eYOPqpaAtYV6ibJUt1x4oNKEGaz43OyPkiJ6fMqd87hl/35w+qsx145ALB1M=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(39860400002)(346002)(376002)(396003)(451199015)(36756003)(2616005)(2906002)(66446008)(44832011)(76116006)(66476007)(66946007)(66556008)(6862004)(91956017)(8676002)(6486002)(41300700001)(71200400001)(33656002)(64756008)(37006003)(8936002)(4326008)(6636002)(122000001)(38100700002)(38070700005)(86362001)(478600001)(53546011)(316002)(186003)(5660300002)(6506007)(6512007)(83380400001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?isz72CgdZSK+7aAi2BUy8e0zqLWnLLJ2w2Om/gV7IkXwtITgVwmeT9/gLwu9?=
 =?us-ascii?Q?gTdYyfWaJBE0f2+GSdYtWB8P7EKttE3BLU+n/InAT9PpZuz4AdVnnWP8GUi9?=
 =?us-ascii?Q?QPibR+Hxup1ni12lOkSvp3At690GgTTizpS5zNfgl0GKWKsYqftz0v8Mk2Kj?=
 =?us-ascii?Q?ScM+YaMnfZj3QYICb7NsVu0WfC9FY5NCsSLDpKIFU64BhIHlnLS6pTpuspum?=
 =?us-ascii?Q?Az16GLTBB5vZ5q9K/FBvrvbbaGa8eIaOdnbykYW9dVyv6Aeu+LLQerZv172H?=
 =?us-ascii?Q?SRrIOE26MBkkR4PJYtGRUgLL6lnE5KzBautUK6CWuiHFgG759Z4KccUccwcx?=
 =?us-ascii?Q?I8Z+MEjLoy+vZFdqsdaE9mO5tdAld1ozZhDUeX07MgH6i7j2fdCoqf+eVXJq?=
 =?us-ascii?Q?ix6BYPS0J6OmLCP5xI81LW2pZUzK9gVlbW8vt+QMFNTLBjlpq8PA5ecPNPAW?=
 =?us-ascii?Q?lMlkApBKCJCVMRr9arbbkUmTV0HeNkfbCvz+2l4NFEnFcv+7/ghAjfkrH4D9?=
 =?us-ascii?Q?AZPAdUIKWbfAAf6BEm342qEvWJcozRfIqxcUd/6ceC59gcyWSiz932M8CGWb?=
 =?us-ascii?Q?LQqDt7HKIW+y4loY2NDA3NzFSVzHpqndgEfaYkPm97HOd/0REAWeKVL9nKQk?=
 =?us-ascii?Q?XwA+dZCKYMbt2JaRkYQ1WyOOCzx2P2V01oDBR7nkXoumbLKn190jBRt/q6FD?=
 =?us-ascii?Q?4+fj6S3dSfST59bijs05sjQIaWm1eeESfHPkxpKj8RnMbDKznZG+mbAccqys?=
 =?us-ascii?Q?IsiDC87zVTrYoXYh2z1s3563ekvqFW7T5lEwarzSblbiBheTVnwKT7/0TcGX?=
 =?us-ascii?Q?KfUGSxjJeng4/WzLGUyqIjJXzvy/qOhy4GAytZiQHVdWn0ClT5d5obc/rYh6?=
 =?us-ascii?Q?HgbVoVLrV2Nn0ZgD/OhQJfTIpeYm84RCETTwwCALigdDJF6UNPFekhm04byP?=
 =?us-ascii?Q?Gukh/Du+fTzJmG4fcryw0rQO6OSTeNdhzoD+F1sfZ7H2CN2x3I5HtY24mTfP?=
 =?us-ascii?Q?hvrVEVSnrE4ebrZIAoEDgYg51dw+e0bpiz4bZQX7cJFTTuEtjmRrnmruXIuL?=
 =?us-ascii?Q?u497M1kx4rESNckb1FvfB+z9BSLhoO3O6iQQoQ1SbVOSSSkiH38XSneW6Q+x?=
 =?us-ascii?Q?idbVVG0Ie/oTI53i1e4mBj7A4WeZpydtd55y8hnBd4EjqRrC49ugkbx5ga/g?=
 =?us-ascii?Q?+Ji3Ktwy4oWpfXuexpipmY7F202hKGRoF7xMD26idjLlPGCZaeOwPv26sEhw?=
 =?us-ascii?Q?qAmlBvTPoKxikXUEWPYrZ1baVD1RTCq3jreLIIyOkoIV4tvH0YeYRqYinS+3?=
 =?us-ascii?Q?UFC6t+ebLPG3UNQQrg5Z948IxBO15q7KJEwlio/mKvbcnm13VCI8mAaX+QW0?=
 =?us-ascii?Q?C4swSLKr+WidPlDVTgfO9zu/+xZ8JnxXy5dHHpmnu70cyE00MBNcG+SBcsMy?=
 =?us-ascii?Q?jHkoqQOk4zR/1ARvt8ztUzMzdaDW6tn09bxMeIp7zKVvoQumOgUswN4QbDHO?=
 =?us-ascii?Q?DceL1bSmm08a+K62tjI2wBWDQfyG1li6sFnoJoBitleplH+tC7WfPmt57iW8?=
 =?us-ascii?Q?kNdnflBQwjim6R4pIq4B3WuEmGDckZqHgS3eIunjsWi/VljOcsRFCxhV3ung?=
 =?us-ascii?Q?5Mi/FqjkW1QldypU5pXB8NyCbjbSucpzqNfFs4BrJFsWX2c1kGCGx6Od5ofm?=
 =?us-ascii?Q?pbJCdQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <489DF3DDFB5E204794926AEDF14EFE2B@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0aee6a7c-7d03-4d04-1559-08dab8871655
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2022 01:52:36.0492
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X0bLQo42Zj4nCFLZ0euro4UrsF6fEmxGPdv2z5XnKxU0PB8//yJfbdCI9OGkjppOIvEyPu7YgZ7+QULfvBose2yuNjmN0ISQpwJPU697YOU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5875
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-27_07,2022-10-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 spamscore=0 phishscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2210280009
X-Proofpoint-GUID: Nh3AQWBnAiXKugXtVHniNkfINwSHX0Tm
X-Proofpoint-ORIG-GUID: Nh3AQWBnAiXKugXtVHniNkfINwSHX0Tm
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> On Oct 21, 2022, at 3:29 PM, allison.henderson@oracle.com wrote:
>=20
> From: Allison Henderson <allison.henderson@oracle.com>
>=20
> Renames that generate parent pointer updates can join up to 5
> inodes locked in sorted order.  So we need to increase the
> number of defer ops inodes and relock them in the same way.
>=20
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Looks good
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
> ---
> fs/xfs/libxfs/xfs_defer.c | 28 ++++++++++++++++++++++++++--
> fs/xfs/libxfs/xfs_defer.h |  8 +++++++-
> fs/xfs/xfs_inode.c        |  2 +-
> fs/xfs/xfs_inode.h        |  1 +
> 4 files changed, 35 insertions(+), 4 deletions(-)
>=20
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 5a321b783398..c0279b57e51d 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -820,13 +820,37 @@ xfs_defer_ops_continue(
> 	struct xfs_trans		*tp,
> 	struct xfs_defer_resources	*dres)
> {
> -	unsigned int			i;
> +	unsigned int			i, j;
> +	struct xfs_inode		*sips[XFS_DEFER_OPS_NR_INODES];
> +	struct xfs_inode		*temp;
>=20
> 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
> 	ASSERT(!(tp->t_flags & XFS_TRANS_DIRTY));
>=20
> 	/* Lock the captured resources to the new transaction. */
> -	if (dfc->dfc_held.dr_inos =3D=3D 2)
> +	if (dfc->dfc_held.dr_inos > 2) {
> +		/*
> +		 * Renames with parent pointer updates can lock up to 5 inodes,
> +		 * sorted by their inode number.  So we need to make sure they
> +		 * are relocked in the same way.
> +		 */
> +		memset(sips, 0, sizeof(sips));
> +		for (i =3D 0; i < dfc->dfc_held.dr_inos; i++)
> +			sips[i] =3D dfc->dfc_held.dr_ip[i];
> +
> +		/* Bubble sort of at most 5 inodes */
> +		for (i =3D 0; i < dfc->dfc_held.dr_inos; i++) {
> +			for (j =3D 1; j < dfc->dfc_held.dr_inos; j++) {
> +				if (sips[j]->i_ino < sips[j-1]->i_ino) {
> +					temp =3D sips[j];
> +					sips[j] =3D sips[j-1];
> +					sips[j-1] =3D temp;
> +				}
> +			}
> +		}
> +
> +		xfs_lock_inodes(sips, dfc->dfc_held.dr_inos, XFS_ILOCK_EXCL);
> +	} else if (dfc->dfc_held.dr_inos =3D=3D 2)
> 		xfs_lock_two_inodes(dfc->dfc_held.dr_ip[0], XFS_ILOCK_EXCL,
> 				    dfc->dfc_held.dr_ip[1], XFS_ILOCK_EXCL);
> 	else if (dfc->dfc_held.dr_inos =3D=3D 1)
> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
> index 114a3a4930a3..fdf6941f8f4d 100644
> --- a/fs/xfs/libxfs/xfs_defer.h
> +++ b/fs/xfs/libxfs/xfs_defer.h
> @@ -70,7 +70,13 @@ extern const struct xfs_defer_op_type xfs_attr_defer_t=
ype;
> /*
>  * Deferred operation item relogging limits.
>  */
> -#define XFS_DEFER_OPS_NR_INODES	2	/* join up to two inodes */
> +
> +/*
> + * Rename w/ parent pointers can require up to 5 inodes with deferred op=
s to
> + * be joined to the transaction: src_dp, target_dp, src_ip, target_ip, a=
nd wip.
> + * These inodes are locked in sorted order by their inode numbers
> + */
> +#define XFS_DEFER_OPS_NR_INODES	5
> #define XFS_DEFER_OPS_NR_BUFS	2	/* join up to two buffers */
>=20
> /* Resources that must be held across a transaction roll. */
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index c000b74dd203..5ebbfceb1ada 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -447,7 +447,7 @@ xfs_lock_inumorder(
>  * lock more than one at a time, lockdep will report false positives sayi=
ng we
>  * have violated locking orders.
>  */
> -static void
> +void
> xfs_lock_inodes(
> 	struct xfs_inode	**ips,
> 	int			inodes,
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index fa780f08dc89..2eaed98af814 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -574,5 +574,6 @@ void xfs_end_io(struct work_struct *work);
>=20
> int xfs_ilock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
> void xfs_iunlock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
> +void xfs_lock_inodes(struct xfs_inode **ips, int inodes, uint lock_mode)=
;
>=20
> #endif	/* __XFS_INODE_H__ */
> --=20
> 2.25.1
>=20

