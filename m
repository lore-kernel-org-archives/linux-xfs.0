Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 438A3ECAAA1
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Oct 2022 02:02:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234884AbiJ1CCg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Oct 2022 22:02:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234667AbiJ1CCf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Oct 2022 22:02:35 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15D375509F
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 19:02:34 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29RMO7Sd005927
        for <linux-xfs@vger.kernel.org>; Fri, 28 Oct 2022 02:02:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=2pvCnBRmLy762jpOMJ/GtkHIJ0f2uZ4hL0wsNSR/GS8=;
 b=htOccndQc8LhWgDY3hKHlLd4Uyc1viVhINNLtTgWbnF05uFQlngHaJBMBTw80kc2eEGw
 My7YIeEfJ0DynnvkRhVQeEe+vtMpxxc3Ymdj4aGRQwwkOqMfhWIVovJuxzV/Yrl6HjL9
 ej7fvim5FefCegH5SQzH9TfIxL5ZqZOq431Cq6AOM+MOczt+Kz/j2RigM4DWTkL0HpRS
 L8k/caGmT0roJoPD+v2RC6BB57C74QOe23Ao5T9xeiv7gHa/a9snV4VxxmPM12SNIkeC
 24MAr7pe2YVn0Q1pL/HuQDu3ZQIbNQEO8xpw9iCRuhXrtPGF7+2Oeeha1AWT9if8nYIw Jg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfax7uncc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 28 Oct 2022 02:02:33 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29S0BJ8w017495
        for <linux-xfs@vger.kernel.org>; Fri, 28 Oct 2022 02:02:32 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kfagh3bhe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 28 Oct 2022 02:02:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nTwZHLPVB7JUdZb640w6bfLG+I+MeuiKUX8lbC67xAsMRMm8wdqoMeutpXf2x1AIk5mQXUR4HpiGQBI7hQfwrvq1wypjGVVKVrJSu8rMLRR+sN0NE/qQIU4x455T4SMbHQuD2Xob+UDm5XDeKDMbNuV8kWFpP4zu545Nwzr0igVJgBjG65iRwULuHQNRyoAvDPsYP4E+Tbh9bnettkNKMjGq1Z3hn9b8RGti6Z7pXZoHrDAcmAmWs/oOoYTGCZJ8KZbmEbvaydrnAeGQ1WebuqobznITMw/cskoY0UIsZrcTs+OqqRtzyiI6osgkCEanKc/4TmVWftlRig1XtVb8hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2pvCnBRmLy762jpOMJ/GtkHIJ0f2uZ4hL0wsNSR/GS8=;
 b=oSI62w6sCQk4FJuOQTK3mHAgJCLRj9vB4KH5YfSjhhLBE824lnyzkvbtLmMzb6uVTQ4wV4QYky6QH27h6vR408o0BRqZ8SreE/LaTHrx4cPBu+urFzjNh/XOve4uAYsBVEw340wQ9uHC2x6i9XPixtVdLLpAznEMGyt9X9suFLfi4dqgxuHkLGC2mtnZvoj514qUmPF/kLk0z8lWXlz3s0Zkrp6LtmSr9eu4RLnw0UFzqV1hPxpQLs5sdMbL1rW/E5Fo4mlhX0Ct8+k65WTb9ydBTUMvPu6j3RB5XZXk0rqdpH1aOh7rqVvmouWZ0slwuY5SS7vkkOj9jjOHV+3p/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2pvCnBRmLy762jpOMJ/GtkHIJ0f2uZ4hL0wsNSR/GS8=;
 b=p8IdbLBk5Z575orXHnwNBsJM0UbItidFITc27M6WbV/NWyWuuTzcnddwMuGRoy4efR9ORgznYMUdZL0Dpxapr4EyuEWrSXJQeUk3f+ZJselVScej3qEXjdQbMYHEO0z+87AOvYFrEHb0iS+troA+8DhWk9zTxTlwTnQc3AKh4tU=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CH2PR10MB4296.namprd10.prod.outlook.com (2603:10b6:610:7a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Fri, 28 Oct
 2022 02:02:25 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::17e5:a392:97fb:39e9]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::17e5:a392:97fb:39e9%6]) with mapi id 15.20.5746.028; Fri, 28 Oct 2022
 02:02:25 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     Allison Henderson <allison.henderson@oracle.com>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v4 07/27] xfs: get directory offset when adding directory
 name
Thread-Topic: [PATCH v4 07/27] xfs: get directory offset when adding directory
 name
Thread-Index: AQHY5Zytclzabog9RkKQbsRkeAQh2K4jF2sA
Date:   Fri, 28 Oct 2022 02:02:24 +0000
Message-ID: <A3AE31BE-6FA8-47F9-A42B-C73CB19B4484@oracle.com>
References: <20221021222936.934426-1-allison.henderson@oracle.com>
 <20221021222936.934426-8-allison.henderson@oracle.com>
In-Reply-To: <20221021222936.934426-8-allison.henderson@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BLAPR10MB5316:EE_|CH2PR10MB4296:EE_
x-ms-office365-filtering-correlation-id: 11a78b26-c326-4173-4342-08dab888754f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: f4nNVTXWduTGqDzct8u6xI/VwTba1HLH9MQUfFHjVRbAmdAqHs4B83v6x8nsGK/bLLTaL7g78ThJHa24FxVul4rhZr0Wm6ehscPOimygrdga/YZ9cTY0X4szG0Wwx7XmE+VUzXHiczjTlkmCSNucE2EK0qlE/OnsXOoCXX9XRxq0qDx2Fb4aovuKlXGx33O6hLgFT1BKFLiTMGe+fQVnLEp4BlPoZyIkYyNmmWhSASKlZs4GuVaA2LLwknx92jaV7it18jb37u6Ilxv1KCrUBVim987hgYkEbMkZVnghH1Nh5+5GO50OlCmhsARN7GOwrep44aR6geCpJYd+z0QNJsMD3YWzyxpnSJ+pN5q0vz4SZYKJoW+KlWEQ84+xNWsexhIwbGwFpWd87KU56qG2FcUMBg+/WQkRQXrnJ7oBQAhLpRL4CDNhcpqPa4M+aD9xYBOv2M9qUQaQer81dcJcsq4F4y6GXI/jaIbs/I/bWsmVLvurBO2c2JMDN287mVFuyeYjexOIlcQxggBoDiG/jTi94jAWVoVDNlA90SzskvQa9Yq9+nJVJ63OT+YBk5lM8VbRga9hmpYu8Ud5qOD58Z8Z+Ng8qw1/Ske2G01DkwEoE0Mw+E2aFtt9aFXtfBZTVArPWO3JSbOPknK/GsdNiFI3Uxc087wkikDV8fi0ZND0d2VmY4gfOvdzUIW2OgZoex/9pmlOd/wSwFFLVvsqK30ZHG+K7FRIkZauejdT06ObSb4yzft4RQlvDkreMNpGF+7EFIbtlnCD33NAuexW6Kohi0lCzZE4QOsVn/UlJB0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(136003)(396003)(366004)(39860400002)(451199015)(6486002)(71200400001)(64756008)(478600001)(6636002)(66556008)(316002)(86362001)(37006003)(53546011)(66476007)(4326008)(8676002)(33656002)(76116006)(91956017)(6506007)(66446008)(66946007)(41300700001)(8936002)(2906002)(38070700005)(6512007)(6862004)(122000001)(186003)(38100700002)(2616005)(44832011)(83380400001)(5660300002)(36756003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?tWnlitMaKHZF4r0W8v9iB4sRVVmpzzjvG/gSJN5Vk/0aTfSSHNlSf+VlTQcn?=
 =?us-ascii?Q?HiH+ddTXoRVQqcSZ3oxnqXfz3yQt2TyTaMifB4NCI6fzZxFlOAN4VABFZr6v?=
 =?us-ascii?Q?556gMIf2XVOx2I0WiJ9w2VyGiQbnR7zE6Y9EPSVNaWBLAgUXCnV5dXmf8Ez+?=
 =?us-ascii?Q?QEhNPbGfWWXmpfx+mS9DZcc3w7HfggJtNvzTpa5FxxU/uvdpowFQQNjmwl95?=
 =?us-ascii?Q?VxGDhot5pJFD0k0mXg2jy3m5zpakUxKL8FXoxHi/9qg2FAy+AnXzQJriHcbG?=
 =?us-ascii?Q?ONcIx6620JDIPMeSAetCbvMxtRyipjbabQj7OrngA16BU6Sxi4qQprxi0o/Q?=
 =?us-ascii?Q?zHRC47iVcyefmddVZmTkMP1qiXVmzHtXDMZ8lKSGtpuU8yJxJdeKnT44VxPH?=
 =?us-ascii?Q?mbbMYAy6yqWYZ/HofpHyj/aSTsC9XZjGeYk06j3gmDq1NIyMLXSxJUgD+F4p?=
 =?us-ascii?Q?GaJkj0fKw+WCaOniZ9dKpqFOvdMRuj6rlcyHIjslnJHA++oEBZoEnWPKHjfo?=
 =?us-ascii?Q?w7ghMelk4wDNe0TIYW0dpojpMPxsqTj6xwv4ZS99yTsGiIas32U71QivRaBl?=
 =?us-ascii?Q?ro+uo90vhCxapJTCpPcDsICoaBl9feentfuu6b3Nb/DVxGbjRsYojdmgQzTU?=
 =?us-ascii?Q?NL20VUD8/AOUb7U99+JmYc78F4Dd9I2c30h7p7OEtUGNkqY4BhsjuUkeFV5Y?=
 =?us-ascii?Q?vLi43JrsdvJdtC5l/3whKhF+n87vb2o30V+FU4Pv3CB35lJJV40BAUvyiigr?=
 =?us-ascii?Q?OC9g+3qhsbHj8new5znSC7CvZfHQvvY5WyKjKjJJhGHwUS+ZHRstOZV44Xdn?=
 =?us-ascii?Q?ENJG3sug3kb2o5LkouhyVpyYBG+gmrIdDfpCgLEpNY4g9+DgrVqJWgH0qbdN?=
 =?us-ascii?Q?c+OISFvaBSJ/NsE3cedwwO3K7Ry4mqLHOK6SlHJkya3ltMDnigcD1q3j+w+c?=
 =?us-ascii?Q?J17q6ak7GS8FUlFvJ9qeQVIGmoerc/R/zjIZR4Tx5G9ci/Iup2gKwDz/Yiax?=
 =?us-ascii?Q?i4VJYv+2uoO/PSLUM9i7t5lsWmERxYOhmXN7d00fZPJk2S7MGqMACyAcgpp5?=
 =?us-ascii?Q?Pd0T4PVDKXlYGFrQWGWKxHg3RzZA55RjTD7FbJkQnDZrIhDdxkW+jZzL/NcZ?=
 =?us-ascii?Q?+Gxv9fmB0pAr3Vff6vbGyhOAyG2fIS2qR/6UI+3bEuQ6sSgk37XRbG4zE3Sq?=
 =?us-ascii?Q?+bInIddor7griU1dJ/20WFnljfMXUe2u9yuNQ/f9S0HAEUcgILg7IBslZ/dP?=
 =?us-ascii?Q?ZjJOWMyi5BFrProuYhwVuYT9BWSiXeARzZrC/dNIPZ7KuAM/zqsWlxgPNfAU?=
 =?us-ascii?Q?ca0Ln22mwFjrg/JgR832OxEz8J6mattu1hQ7OrWGiuFDQMwkmg1APxSUtbAU?=
 =?us-ascii?Q?82V+0Oe0kqb9w1GHSBjMyU5H1hMvlMuYivomPzZlsTInXShy+N/a6QYhtLCp?=
 =?us-ascii?Q?ynqwBHrPG4ei5HHtXk/8sC7qe0PU2wE1AGInsO7Ru2Vop5sktuTcSIPcRh7B?=
 =?us-ascii?Q?KDajxezcV6rKHSg6z5vAWYaPIptkTyPLc5MNG0Aq3pMM1pbu3nRNyzBcwIPn?=
 =?us-ascii?Q?U0WrFC8UdA5ogF53cjuZ0UQccLWB9Z05ndF9IdpK3ctoEWdGQIvanM7QpDft?=
 =?us-ascii?Q?ggG9vXXzQLDeFYvQ0oPvZXHKnwfxNVUrWyMcTs+9XBkcKh/dcoFZqB6FPygo?=
 =?us-ascii?Q?SG+oVlsRxj5d1/x1FwWzGDwjETg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B029A61E8CA8B34B8ADF2D1E4311875C@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11a78b26-c326-4173-4342-08dab888754f
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2022 02:02:24.9382
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qFMJyhSdUBECdA7Tx1l3svgigzBhn2ERCYsde75J9rJaHxJfhib3bMGr9kqbRmruUNO8ypWAv+WY3BA1z+ZYOMALzKpqOJdrGZvBMiX5Kas=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4296
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-27_07,2022-10-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2210280011
X-Proofpoint-GUID: L7sjPqZahdYr5-IxDx2y94On1dgYabQS
X-Proofpoint-ORIG-GUID: L7sjPqZahdYr5-IxDx2y94On1dgYabQS
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> On Oct 21, 2022, at 3:29 PM, allison.henderson@oracle.com wrote:
>=20
> From: Allison Henderson <allison.henderson@oracle.com>
>=20
> Return the directory offset information when adding an entry to the
> directory.
>=20
> This offset will be used as the parent pointer offset in xfs_create,
> xfs_symlink, xfs_link and xfs_rename.
>=20
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Looks good
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
> ---
> fs/xfs/libxfs/xfs_da_btree.h   | 1 +
> fs/xfs/libxfs/xfs_dir2.c       | 9 +++++++--
> fs/xfs/libxfs/xfs_dir2.h       | 2 +-
> fs/xfs/libxfs/xfs_dir2_block.c | 1 +
> fs/xfs/libxfs/xfs_dir2_leaf.c  | 2 ++
> fs/xfs/libxfs/xfs_dir2_node.c  | 2 ++
> fs/xfs/libxfs/xfs_dir2_sf.c    | 2 ++
> fs/xfs/xfs_inode.c             | 6 +++---
> fs/xfs/xfs_symlink.c           | 3 ++-
> 9 files changed, 21 insertions(+), 7 deletions(-)
>=20
> diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
> index a4b29827603f..90b86d00258f 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.h
> +++ b/fs/xfs/libxfs/xfs_da_btree.h
> @@ -81,6 +81,7 @@ typedef struct xfs_da_args {
> 	int		rmtvaluelen2;	/* remote attr value length in bytes */
> 	uint32_t	op_flags;	/* operation flags */
> 	enum xfs_dacmp	cmpresult;	/* name compare result for lookups */
> +	xfs_dir2_dataptr_t offset;	/* OUT: offset in directory */
> } xfs_da_args_t;
>=20
> /*
> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
> index 92bac3373f1f..69a6561c22cc 100644
> --- a/fs/xfs/libxfs/xfs_dir2.c
> +++ b/fs/xfs/libxfs/xfs_dir2.c
> @@ -257,7 +257,8 @@ xfs_dir_createname(
> 	struct xfs_inode	*dp,
> 	const struct xfs_name	*name,
> 	xfs_ino_t		inum,		/* new entry inode number */
> -	xfs_extlen_t		total)		/* bmap's total block count */
> +	xfs_extlen_t		total,		/* bmap's total block count */
> +	xfs_dir2_dataptr_t	*offset)	/* OUT entry's dir offset */
> {
> 	struct xfs_da_args	*args;
> 	int			rval;
> @@ -312,6 +313,10 @@ xfs_dir_createname(
> 		rval =3D xfs_dir2_node_addname(args);
>=20
> out_free:
> +	/* return the location that this entry was place in the parent inode */
> +	if (offset)
> +		*offset =3D args->offset;
> +
> 	kmem_free(args);
> 	return rval;
> }
> @@ -550,7 +555,7 @@ xfs_dir_canenter(
> 	xfs_inode_t	*dp,
> 	struct xfs_name	*name)		/* name of entry to add */
> {
> -	return xfs_dir_createname(tp, dp, name, 0, 0);
> +	return xfs_dir_createname(tp, dp, name, 0, 0, NULL);
> }
>=20
> /*
> diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
> index dd39f17dd9a9..d96954478696 100644
> --- a/fs/xfs/libxfs/xfs_dir2.h
> +++ b/fs/xfs/libxfs/xfs_dir2.h
> @@ -40,7 +40,7 @@ extern int xfs_dir_init(struct xfs_trans *tp, struct xf=
s_inode *dp,
> 				struct xfs_inode *pdp);
> extern int xfs_dir_createname(struct xfs_trans *tp, struct xfs_inode *dp,
> 				const struct xfs_name *name, xfs_ino_t inum,
> -				xfs_extlen_t tot);
> +				xfs_extlen_t tot, xfs_dir2_dataptr_t *offset);
> extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
> 				const struct xfs_name *name, xfs_ino_t *inum,
> 				struct xfs_name *ci_name);
> diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_bloc=
k.c
> index 00f960a703b2..70aeab9d2a12 100644
> --- a/fs/xfs/libxfs/xfs_dir2_block.c
> +++ b/fs/xfs/libxfs/xfs_dir2_block.c
> @@ -573,6 +573,7 @@ xfs_dir2_block_addname(
> 	xfs_dir2_data_put_ftype(dp->i_mount, dep, args->filetype);
> 	tagp =3D xfs_dir2_data_entry_tag_p(dp->i_mount, dep);
> 	*tagp =3D cpu_to_be16((char *)dep - (char *)hdr);
> +	args->offset =3D xfs_dir2_byte_to_dataptr((char *)dep - (char *)hdr);
> 	/*
> 	 * Clean up the bestfree array and log the header, tail, and entry.
> 	 */
> diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.=
c
> index cb9e950a911d..9ab520b66547 100644
> --- a/fs/xfs/libxfs/xfs_dir2_leaf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
> @@ -870,6 +870,8 @@ xfs_dir2_leaf_addname(
> 	xfs_dir2_data_put_ftype(dp->i_mount, dep, args->filetype);
> 	tagp =3D xfs_dir2_data_entry_tag_p(dp->i_mount, dep);
> 	*tagp =3D cpu_to_be16((char *)dep - (char *)hdr);
> +	args->offset =3D xfs_dir2_db_off_to_dataptr(args->geo, use_block,
> +						(char *)dep - (char *)hdr);
> 	/*
> 	 * Need to scan fix up the bestfree table.
> 	 */
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.=
c
> index 7a03aeb9f4c9..5a9513c036b8 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -1974,6 +1974,8 @@ xfs_dir2_node_addname_int(
> 	xfs_dir2_data_put_ftype(dp->i_mount, dep, args->filetype);
> 	tagp =3D xfs_dir2_data_entry_tag_p(dp->i_mount, dep);
> 	*tagp =3D cpu_to_be16((char *)dep - (char *)hdr);
> +	args->offset =3D xfs_dir2_db_off_to_dataptr(args->geo, dbno,
> +						  (char *)dep - (char *)hdr);
> 	xfs_dir2_data_log_entry(args, dbp, dep);
>=20
> 	/* Rescan the freespace and log the data block if needed. */
> diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
> index 8cd37e6e9d38..44bc4ba3da8a 100644
> --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
> @@ -485,6 +485,7 @@ xfs_dir2_sf_addname_easy(
> 	memcpy(sfep->name, args->name, sfep->namelen);
> 	xfs_dir2_sf_put_ino(mp, sfp, sfep, args->inumber);
> 	xfs_dir2_sf_put_ftype(mp, sfep, args->filetype);
> +	args->offset =3D xfs_dir2_byte_to_dataptr(offset);
>=20
> 	/*
> 	 * Update the header and inode.
> @@ -575,6 +576,7 @@ xfs_dir2_sf_addname_hard(
> 	memcpy(sfep->name, args->name, sfep->namelen);
> 	xfs_dir2_sf_put_ino(mp, sfp, sfep, args->inumber);
> 	xfs_dir2_sf_put_ftype(mp, sfep, args->filetype);
> +	args->offset =3D xfs_dir2_byte_to_dataptr(offset);
> 	sfp->count++;
> 	if (args->inumber > XFS_DIR2_MAX_SHORT_INUM && !objchange)
> 		sfp->i8count++;
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 8b3aefd146a2..229bc126b7c8 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1038,7 +1038,7 @@ xfs_create(
> 	unlock_dp_on_error =3D false;
>=20
> 	error =3D xfs_dir_createname(tp, dp, name, ip->i_ino,
> -					resblks - XFS_IALLOC_SPACE_RES(mp));
> +				   resblks - XFS_IALLOC_SPACE_RES(mp), NULL);
> 	if (error) {
> 		ASSERT(error !=3D -ENOSPC);
> 		goto out_trans_cancel;
> @@ -1262,7 +1262,7 @@ xfs_link(
> 	}
>=20
> 	error =3D xfs_dir_createname(tp, tdp, target_name, sip->i_ino,
> -				   resblks);
> +				   resblks, NULL);
> 	if (error)
> 		goto error_return;
> 	xfs_trans_ichgtime(tp, tdp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
> @@ -2998,7 +2998,7 @@ xfs_rename(
> 		 * to account for the ".." reference from the new entry.
> 		 */
> 		error =3D xfs_dir_createname(tp, target_dp, target_name,
> -					   src_ip->i_ino, spaceres);
> +					   src_ip->i_ino, spaceres, NULL);
> 		if (error)
> 			goto out_trans_cancel;
>=20
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index d8e120913036..27a7d7c57015 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -314,7 +314,8 @@ xfs_symlink(
> 	/*
> 	 * Create the directory entry for the symlink.
> 	 */
> -	error =3D xfs_dir_createname(tp, dp, link_name, ip->i_ino, resblks);
> +	error =3D xfs_dir_createname(tp, dp, link_name,
> +			ip->i_ino, resblks, NULL);
> 	if (error)
> 		goto out_trans_cancel;
> 	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
> --=20
> 2.25.1
>=20

