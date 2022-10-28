Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1312FA373D
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Oct 2022 01:54:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234665AbiJ1ByQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Oct 2022 21:54:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234030AbiJ1ByO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Oct 2022 21:54:14 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC430AD98B
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 18:54:13 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29RMO7Xf025038
        for <linux-xfs@vger.kernel.org>; Fri, 28 Oct 2022 01:54:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=g0xFOyjYZqd5noz5iaMeTZwubhM4IXXOrUDaeJavmQw=;
 b=p9Zvqxpg56ws9RB5KuUEBmZYC3dQ9pdP26SyD/PuyYmt6V1rbODC/XwG9W1pZqin7Pos
 +kf/aesoR+pOUkVz5QVMOXKmLpljIcqudpCVD9i6+iAhE4fSSDaPE0U+GOQi3yJH/n5Z
 BKTxzkNcHms3Kx5Oc0pR7Lv0bpz67EvAjD2+1CkzbQCNhQrxM8sLoOZ7/HJOU0BH+fqb
 dY7FlNUQ6PzDB14QfZbY7S6dAbFskaPf3eHejDtD+EVlD2aquyRBrQJhVuLupbj+yl0b
 DWOJvDFzYclCMJspxRFHxpkEX6C2xAvVy4xMgQwyXYl8qIjq3K0YeV89EBo8PUROwcfj 2g== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfagv3xhq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 28 Oct 2022 01:54:13 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29RMRQ88017553
        for <linux-xfs@vger.kernel.org>; Fri, 28 Oct 2022 01:54:12 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2044.outbound.protection.outlook.com [104.47.74.44])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kfagh36ad-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 28 Oct 2022 01:54:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KR7cM3TroCE8a2gEM61vnt1nYeYgOOUMJfk3hfBbs3e/5PgnImRSmvZ84JTR2xDhvaH58w2Q0+EIaVA08JCh/u9BdCQcFPmM4oZc0OeVKokJY/K9sT/bnanI0d+xdqhaGM9QiszewDlebAibMJrr6eYqXgHVCFc8XbLWlANyqZOnK/KvooHWpRvIOuDIQ29xRrhW1d6prsEq25oPhdXF0If6NxiUyRb+9grPCmz6z+4Ks9a5/M4uFIhCyztLvrVpBB/VqOY8E3ZSXvamecl0LFRT65EHDnqAF8PZRWigC9IQtCNOFnQulSiwFUH0Mk2GzKoeiAkmh5zNCMsED7NBiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g0xFOyjYZqd5noz5iaMeTZwubhM4IXXOrUDaeJavmQw=;
 b=O8DTOvNjnXYlsQuZHzGvfqmdUCbmaMbXDWW60aaXurQEFLqEDTxGK9NRBK/mfx8VzOJhflut7g/T6kosKVyuVZblTM7StQUG6ksIWM3DyVtWhm5Bq6OU73qA7DO1sBU5EWzkQwyZYUwcu8bLRzW+TUysyEHjvEa7IjzwTJ0nVuUEUw+8ModEh1D1XQX+0DIU32SABDBLHonjWD6LofvP2L6HAkU7dF8xUCvi9o2yW0TfbfrLMitIW1AoaF404FxkMyvYXmejFCb3Dv9pfLz0zC5kgOhka5fAbTBXpQahVUPF53f3uMrTxhR6d+M0hiMRhgDLdyKRIZtr6z8EPPkZ2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g0xFOyjYZqd5noz5iaMeTZwubhM4IXXOrUDaeJavmQw=;
 b=csfv3P17YMFxyOtDlSgeFg8dQHujSHJS5QoYlwhpe0WSjMJuvprWLE3YAzLQWL1BkcsbtnFDZZkZ4b/8Cp/HsIcdE0xv6ewtDhdGBc4vt2/tcMj71K+kswfTOfD6GaKpJ1cFpu3HMXU4tHF9f2vyCUPum35Y4wNLq//QRlyJ0oU=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by MW5PR10MB5875.namprd10.prod.outlook.com (2603:10b6:303:191::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Fri, 28 Oct
 2022 01:54:09 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::17e5:a392:97fb:39e9]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::17e5:a392:97fb:39e9%6]) with mapi id 15.20.5746.028; Fri, 28 Oct 2022
 01:54:09 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     Allison Henderson <allison.henderson@oracle.com>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v4 03/27] xfs: Hold inode locks in xfs_ialloc
Thread-Topic: [PATCH v4 03/27] xfs: Hold inode locks in xfs_ialloc
Thread-Index: AQHY5ZyptSxk8n964EC9jeuOnseNVa4jFR2A
Date:   Fri, 28 Oct 2022 01:54:09 +0000
Message-ID: <6402A28F-02C2-493A-8AD8-BDBBC9B6ADD6@oracle.com>
References: <20221021222936.934426-1-allison.henderson@oracle.com>
 <20221021222936.934426-4-allison.henderson@oracle.com>
In-Reply-To: <20221021222936.934426-4-allison.henderson@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BLAPR10MB5316:EE_|MW5PR10MB5875:EE_
x-ms-office365-filtering-correlation-id: 2cf08eef-c0ef-45b0-28a5-08dab8874e0a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EMBH4JvT7IGyhfhoq2DD3YQohz/BbKD3LjlNmufHzpYcYXBMId8aqSyMoQnewnpmQ6igVc/2iZtE1kvGOcI/uw/1SW/j+V4oCR4/WoevE/D7bfteisAb1lLKqeOZ+qkQLZLeVprSYNqpktnYq/rGi3eoN4YphOM0xtEqZawAB790WfsIYOts1tUcdWeYoK+aeoalidm+90gkD2OfEz8y9mKPcrwnflMF+ijDdErOTMC4kS5WTbVuQzN10P+QUNtL46GU7sLt2H2brZ9V7Y9iEZ6xddSh/l64koLAgcN8EDtGyKHQ3JWyZvuph6K7q1W2P//4SqvKb7QGqwHzvZjL2Syk3FzRuZQlk9He5SI4esaGg90eqyVm7JTodBYT7Wwe1QQCBLRmsw5FvgdYX8qTqEhe4y8ixPCFfHFXhGA03XD1GCcDQePR1yfO5hXRBW8VJIkC6SCPH2BCruHDBbueCHR8SF+GM12Lpokb5jXqSjXVaWgYx5P9eE0NXoj0kMqfBaege5xEr1AadwiX19SB/6BzoOTT4k/L1wp5WS0i+KCfvzaW5W2GMHn0pMo3j9HiI8WLUdFI8kjG2VNHxsU28QjPQdSqFC7qSHfaedonMhMIYEykCYsZYc4T/BnkbOZ1INh8MSgHj/5oExnLy0mbs+wtvankbSg2FYYUfcNQWwm0BXXJOFKIwUT4+hH2rDtexSBV9SMFuN1CjZLV7f1anmpxO0uUNVYCpbsaL0onqylcqLESA+9dMdsQZnQurEi29j2polKCpAV6m6scLuayVJwQSkLE08jY7wjvbI9oN68=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(39860400002)(346002)(376002)(396003)(451199015)(36756003)(2616005)(2906002)(66446008)(44832011)(76116006)(66476007)(66946007)(66556008)(6862004)(91956017)(8676002)(6486002)(41300700001)(71200400001)(33656002)(64756008)(37006003)(8936002)(4326008)(6636002)(122000001)(38100700002)(38070700005)(86362001)(478600001)(53546011)(316002)(186003)(5660300002)(6506007)(6512007)(83380400001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QPFVZ817+yZGugfAjYss4YRIkj/u1gWOIlN/bpGqomylMoZDOw25cYwETgUh?=
 =?us-ascii?Q?aVQzACiwY+xHa+EK0qAgRGkygHWxh3IJ3KaeWM+0vu1uWuprGtEviDzwww1L?=
 =?us-ascii?Q?MgK7SeTLpZuWrjQAsfKWJpSemgcl160MVlk5CTeLEA1WEMG3zwSTmeaeiqeg?=
 =?us-ascii?Q?xrD3azksl/PMPI1k15IqghX+B073qV2JGZgipysMdMPqakziH9yTZu0ltwsE?=
 =?us-ascii?Q?12cnPeDUDaKkd06NwXbz0lGJkhDZ3gUx603L6Q8qnKgXtLTOFQZhEyMTfdGP?=
 =?us-ascii?Q?tTl+SSiZf+JB029pKEJbIFO+3B2/NDIVgz2KAWY8j/lTsU2UQhKp1YKUz36H?=
 =?us-ascii?Q?E52UvYZbYOBxzAMIhXbD1VyIiF7Ty3c9OPOdStjNQJ2XbdR3giCElD4k3/Qx?=
 =?us-ascii?Q?iAcCsHRh8Ebb/xnUiq6qpbAZM6ocKAYm4wMpmnxWeDTvrBuSQ2KtY+1kkSGc?=
 =?us-ascii?Q?rOsqV+CJyJtP/Vq3Gy490WwgtJJtNULmZmj6Dkd+9TvVaGT6+sTWJeeGsghW?=
 =?us-ascii?Q?RyfO8EVE+EIIXEVVPPBBbAZx231L4i4BPyJJ2OC9Ll2Oh1QV9M+UzGzJlfG3?=
 =?us-ascii?Q?2L0xcQT7qf1iubUnI4W0lAguBtSJIzS5S9QOkS2o8agSdv2bv6qjeF+fdArn?=
 =?us-ascii?Q?EetqDepDryqk61TPGcJ0l5xyY3mrkHnhv/zxExhZEL5O4nfWXx5HC9u7iGz6?=
 =?us-ascii?Q?ZCLBDRWcLfAFCNamZDgABzKWMhHXx0jnp95IFDRcOkI4HL5BzM3M8+z4UmD4?=
 =?us-ascii?Q?lvic3N4JuKzgM81kJ3xx2x6443pvkllI6uPAiCgWHjht39RusBnHZDI6rtij?=
 =?us-ascii?Q?NtCMYEkJpPwdhsLD0wkjapPxHt0SOyJi8kHVUndRR3AzSB2f4NKElOe7X3Ar?=
 =?us-ascii?Q?05mpDDYqGwqjiVCY4OMG0feVoA6i4Bp+jQ1uoaKM2UrxpTQoWciMyQhps7ir?=
 =?us-ascii?Q?XX2oZSrqOjnGxylWY0BQWfFsVjcfwyqkDrFYXE7pDptesvicIWPyksYnjvk8?=
 =?us-ascii?Q?ez75lQTDDcolcujri6RtaIB8D6LQed9t49soDiZF6HPNir9TdevzHHXDUg2u?=
 =?us-ascii?Q?DoIrnceVmW6d2xQL+ktqIrii1PTaqTYetITm5zYEnYQeag+udZ/+L0PISglO?=
 =?us-ascii?Q?4Ctmu5ghN3+0Y2OrKZ+5YRjaQPTSXx6s4WipWQVFEh6TQwQZcIDS2goYpBED?=
 =?us-ascii?Q?Q7ZGiGOhcXcEfNZPuvqsRfHN8q+DRqu8o8KXViSH/I5VlyHKCUg9fSWBGIue?=
 =?us-ascii?Q?U+iiHDxAdzSglXll2KiTy8oV6kFYM7qpdP19REH9uGmkdlD/F6LpyhM2Z3i8?=
 =?us-ascii?Q?O+Kma3HVRo3GL/ffcVK3oRSpm6NmGG5rva1e4DnuhXOcBh+rmGxQgalNH15w?=
 =?us-ascii?Q?xgxml+Tjses+dZZYk7BJuQtnG9FL9wKZMaEpaLYszfdnptpZj1mt1j+WUnQZ?=
 =?us-ascii?Q?RS1FwCj6iu8HljOOVvTCNxI2DN3eaLjoNGGJCcfpxZkpu/5gT+Z4GPeLfQkh?=
 =?us-ascii?Q?KFZlP0YJxbs9t5D2yA+x31H6m1Dl0ZIszxJHeLnfnCMZeMsUsmEEjySO7Hzb?=
 =?us-ascii?Q?quJEj8Rhy35dcMvnfzqzH3ajzvVuXoVTD7HDa5EiuVyt2fHI1FNmhxbC6tjA?=
 =?us-ascii?Q?FnV2h+K7qrxyqD7ALeLMD1GOXxeQTmImcyKcLQM91/717n4ONCNZMnTxdHrp?=
 =?us-ascii?Q?CIQR31WY7BDyrXTGKmHPhMek9iE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8924AD2651260A48A68D099A48A11880@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cf08eef-c0ef-45b0-28a5-08dab8874e0a
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2022 01:54:09.5574
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AZzHVchhCWrk/q2lRdJPRSuBPi1VL2ZLzLpOFWilqIaWAT1L+hqeOxlvP9uQUlXhg7pZ0C0ntqTqNL/9c8hfBnWBrCE3BK+CMtNbXfc5UTU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5875
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-27_07,2022-10-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2210280010
X-Proofpoint-ORIG-GUID: r8BahzrXUUg3B-TR2dD92pIqVTMSiCXT
X-Proofpoint-GUID: r8BahzrXUUg3B-TR2dD92pIqVTMSiCXT
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> On Oct 21, 2022, at 3:29 PM, allison.henderson@oracle.com wrote:
>=20
> From: Allison Henderson <allison.henderson@oracle.com>
>=20
> Modify xfs_ialloc to hold locks after return.  Caller will be
> responsible for manual unlock.  We will need this later to hold locks
> across parent pointer operations
>=20
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Looks good
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
> ---
> fs/xfs/xfs_inode.c   | 6 +++++-
> fs/xfs/xfs_qm.c      | 4 +++-
> fs/xfs/xfs_symlink.c | 3 +++
> 3 files changed, 11 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 5ebbfceb1ada..f21f625b428e 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -774,6 +774,8 @@ xfs_inode_inherit_flags2(
> /*
>  * Initialise a newly allocated inode and return the in-core inode to the
>  * caller locked exclusively.
> + *
> + * Caller is responsible for unlocking the inode manually upon return
>  */
> int
> xfs_init_new_inode(
> @@ -899,7 +901,7 @@ xfs_init_new_inode(
> 	/*
> 	 * Log the new values stuffed into the inode.
> 	 */
> -	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> +	xfs_trans_ijoin(tp, ip, 0);
> 	xfs_trans_log_inode(tp, ip, flags);
>=20
> 	/* now that we have an i_mode we can setup the inode structure */
> @@ -1076,6 +1078,7 @@ xfs_create(
> 	xfs_qm_dqrele(pdqp);
>=20
> 	*ipp =3D ip;
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> 	return 0;
>=20
>  out_trans_cancel:
> @@ -1172,6 +1175,7 @@ xfs_create_tmpfile(
> 	xfs_qm_dqrele(pdqp);
>=20
> 	*ipp =3D ip;
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> 	return 0;
>=20
>  out_trans_cancel:
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 18bb4ec4d7c9..96e7b4959721 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -818,8 +818,10 @@ xfs_qm_qino_alloc(
> 		ASSERT(xfs_is_shutdown(mp));
> 		xfs_alert(mp, "%s failed (error %d)!", __func__, error);
> 	}
> -	if (need_alloc)
> +	if (need_alloc) {
> 		xfs_finish_inode_setup(*ipp);
> +		xfs_iunlock(*ipp, XFS_ILOCK_EXCL);
> +	}
> 	return error;
> }
>=20
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index 8389f3ef88ef..d8e120913036 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -337,6 +337,7 @@ xfs_symlink(
> 	xfs_qm_dqrele(pdqp);
>=20
> 	*ipp =3D ip;
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> 	return 0;
>=20
> out_trans_cancel:
> @@ -358,6 +359,8 @@ xfs_symlink(
>=20
> 	if (unlock_dp_on_error)
> 		xfs_iunlock(dp, XFS_ILOCK_EXCL);
> +	if (ip)
> +		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> 	return error;
> }
>=20
> --=20
> 2.25.1
>=20

