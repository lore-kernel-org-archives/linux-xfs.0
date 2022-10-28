Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 936A4FA373D
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Oct 2022 02:06:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235017AbiJ1CGh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Oct 2022 22:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235291AbiJ1CGg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Oct 2022 22:06:36 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D8BC5B716
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 19:06:35 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29RMO56T005891
        for <linux-xfs@vger.kernel.org>; Fri, 28 Oct 2022 02:06:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=Pt6iclugcGRny7Pe21S7zUk/YxBzf/+9rjNz2dWQliE=;
 b=wchYTDo7C1thMoLObKZOuJy95t3yMSbK5T5fJbdI0zuM8CpRV3IHeoA4rB9PVA1HN7AP
 5aQVes/gPCJCRLcA4YuMb2hsotFQotAsrXptMcuiYrLxbfhPzOkuvyO2zvLnJeIYx3TA
 jDHjz65ZAsOE75pL2Z4sU2qzDBbB88J/7z0X2lj8EY+yzb4lpb5kbjZ9Ksr5CbbTxRYi
 kjjRZ+XR8L8v+sECvhZJgwZKHyXTBMrgHqVxKCHG8wASRjZjgnJZYOUkKGXuax6UWDKk
 GTvGzjbeDV5OrI3AzjZ5QRw5B9lPlkuuBenZNAjUOqH9VJq9Z8PGiPkVwnxmsIq1R//C LA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfax7ungn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 28 Oct 2022 02:06:34 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29RM0683026522
        for <linux-xfs@vger.kernel.org>; Fri, 28 Oct 2022 02:06:33 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kfagqm5sa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 28 Oct 2022 02:06:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A+JLYaZRUujVd7TL6v/upxdWYH6/5jJDOj8Xpwi6KNpmaCYM1Kj38tk8EbEAgVNrCLfNxor4jNivsAxdSaMDXXcuN6tDaomzBWpcf5pVbB8uzom7yqWyRY/UKKHl6Lc310h1KU2rP2BjDARxplpSmztaq/qzG/ziy75Fevk8hld1GiciO6Ik5LzqtY7bU/5lRDMWRmJHl4znwmzrKpT0U5wR2seUJCNTUZBdMbEHrKbwHHP9cZWCsYPUzw4B7w3PDUH0kf+ta5ld1Ihe9HDN8MXd0p3TRjwt9Lg7Kb9m+DmtM3gnmYnrD5hc1sW+kGQLXxUnCg3NngGn3tvRkYhLrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pt6iclugcGRny7Pe21S7zUk/YxBzf/+9rjNz2dWQliE=;
 b=XvPBBjeYpyx6J4Oa4c2p4pPjRV8sznoVmWp0hZluR4E9UXceHQuZMGRiaKjYX4f/px7DQ7BpuOd9h6OU+9hi51Hm0zxJbDfGNNFqXbn7Mxcw/iWobjSYdEk5bAk1/4Z9nXGCEtZbMwSOkq1IXNWeaV6201tCGJKWggIzlXerNNreZbVfiAFSqVmXdwIz4ygMO91je/9UYCpmrOnRzBrttxvcQKS93y3ylLTfb0NxfnpDSdqtM8ORdwRQScQ9NhvnkbW7TSgstEzuVvD5LjY0oTRm+FpLoKRzIAmLFcsUvc1ILqzP6zYZPJ5DGlzoqtBJpDQ98ILZmLSQLDh4evhY7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pt6iclugcGRny7Pe21S7zUk/YxBzf/+9rjNz2dWQliE=;
 b=mG3K/Btvk4xxp5WHZWsEp/x4f6lMCNeH7d/yArFBU8gfi75+Z7QN9bR2zpjEHK/rLAjd9gQPJlHIA36AbZcScZcRgUBniRI0QgkJcQKOGSZz8anp3Y29gqO/w70III+Bn67o6HavIKzmz1j6B+0DSja+wA1YwwbeM5o4gAi8gnQ=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DS7PR10MB4941.namprd10.prod.outlook.com (2603:10b6:5:38f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Fri, 28 Oct
 2022 02:06:32 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::17e5:a392:97fb:39e9]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::17e5:a392:97fb:39e9%6]) with mapi id 15.20.5746.028; Fri, 28 Oct 2022
 02:06:32 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     Allison Henderson <allison.henderson@oracle.com>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v4 08/27] xfs: get directory offset when removing
 directory name
Thread-Topic: [PATCH v4 08/27] xfs: get directory offset when removing
 directory name
Thread-Index: AQHY5ZytknoqTSXRDkmhzi+7Z80UFq4jGJGA
Date:   Fri, 28 Oct 2022 02:06:32 +0000
Message-ID: <860EA939-8EE6-4A5C-BFD7-A8FD9B65F5F4@oracle.com>
References: <20221021222936.934426-1-allison.henderson@oracle.com>
 <20221021222936.934426-9-allison.henderson@oracle.com>
In-Reply-To: <20221021222936.934426-9-allison.henderson@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BLAPR10MB5316:EE_|DS7PR10MB4941:EE_
x-ms-office365-filtering-correlation-id: cce8c394-958c-457e-1352-08dab88908b4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JR5D5yEjWGSn5C0SfIZmtGG7uyvqf1vhxtcyPmicYpOW2GVHrkymu5koTxK48HAfCN4X1icMxB2V9PTWTsZn90O5nAr6k5CWT/MTa21tgquOjwChvgpVje5og5fRRypx3TkZmUK9Epepy93J8udxN5Xy2ci8o4AqGxGSr06Xa+E1l0edGq8P7Mwpls8INsUMjeqtKq4ihQ9RPy9OfEeVHCfT64xIDeNZ7MIr8CcMSA53P+a9U3yO7d8HnOcGOLgdRbMR6jXU06he8ZX3C2hYqAQDXDlmrw0t/dlpbEoNFwFGFjff+sNqMjaceIDuZQMD/5NNsqbSN3t2+KJdTlkCVHgvA84+0N927dCZiOu/b3pyXnBx2qi780j4rzCtSRIAUfPKYf1y2RyC4WXYm9zgKtz/CAUj20JoqA2oU5IfTXTqlFkwMiR4lHs3MClWiZmr1BVkDutgFDh472ma9qP6qfarwbUiiwkTuDPu26NrGAWOiwCZo5w83o6qUhd8Cf15DWkCQLddVaViD6pfLzqBtfOb1HCAeRJtnyIdp2qEDKfkPSktHev6TEZVSDsKmxTh8hsE0zKB51qyFAbMPa/K68tKfnlBEArXnGBmY/JtMgj+IwTonc+HVCcnujj/h9FXC+wxFqQjHh6/zmq3WFqo2ZtDZ6POC/Sq29JFMbp1vuiHXMmBbPjkADJCzQoLnJhiiJaYPXoSx3JSIouekD96s/6q8VtyQE8LUCil8Uxz9xk1aJKm5nS/7nxBSTXOFTgSM9DgorYgYXJJ58ICh85HN7XIiXEusytHxgiHsB4CDy4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(136003)(376002)(396003)(366004)(451199015)(66556008)(37006003)(91956017)(478600001)(6636002)(66476007)(6506007)(71200400001)(8676002)(66446008)(53546011)(64756008)(76116006)(316002)(6486002)(8936002)(41300700001)(5660300002)(6512007)(6862004)(86362001)(122000001)(186003)(44832011)(2616005)(2906002)(4326008)(83380400001)(36756003)(66946007)(38070700005)(33656002)(38100700002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Am3Pfad24liG/hqcd1yKEts8/faBq+GClqgFM/FGEfWo1m27Ydt56tgjaTm3?=
 =?us-ascii?Q?FPyjdTB3PyBKmM64RfGtK6mh6wsXew/3yU5Fb4EDDRrT9f+yt2xXNIhSgmB9?=
 =?us-ascii?Q?dVi13FgGla0ijjBrPyiIqiAfvE1NHVsdWnsPxTsTL7oa2msVcPJuen7GATBa?=
 =?us-ascii?Q?RhRWenJqCiBjfRrjhQpGVKDWE9W0gGnf1taF5WqaAu0QlOTLbmB5UnaUrEX2?=
 =?us-ascii?Q?qb+lvfIs+6+WvUdHY7Nf9Bho1T5hQ4lErISyFY12yZOqG46fYYhueivKDjj1?=
 =?us-ascii?Q?jpXtCJfoS6q7eK3JGstZg683cbZIx7b1LaM1ykDgx8OTJiqH/gOqQtQ7hQx6?=
 =?us-ascii?Q?gJWrUTCFKXRCpDXkoCg6+umIcX8bU7s+M0m1ac7EVWLaYyQiuj1/jAN8Rwio?=
 =?us-ascii?Q?zsCBo8KqJAjAKDwTJp29PlvVKx8LcvZZNwSQz0Bc1beV0MQsaqKFCASu7lmz?=
 =?us-ascii?Q?sWyMWENQxl6s07Rd5hwoIdYibXIRGk5Glj6yoGLkLTrLXBsYdoJdVLquSkvW?=
 =?us-ascii?Q?tIXg7trn7/0/CECCpihJpaPfnaQxCvz4JE43qi78S7FgCSrS2oYIUIikFvGq?=
 =?us-ascii?Q?2xQcg3+lo+Pmn29PMXTbrv6FOl8Syn3Dl0ueNDkP7DX2p9/VmOamMM2krIK6?=
 =?us-ascii?Q?fxguO1wI1Ncj/po+zT0/i9krLvci7PvthfH+2e2vhsaVoQt6PNPc67aAH9IG?=
 =?us-ascii?Q?i9yfX9LULJNDk/AMbIdJrZIvea8F6mI7PVK/rov+Ly9QnlGdt+mfk/KAXzgL?=
 =?us-ascii?Q?3xbhdCiFpWMtmDrkDU/+GiGl95Pzip3i4fSgkk6krIYlfewKWctFCExuJASN?=
 =?us-ascii?Q?W+mt5O11E0yAEDYtt7c4rO+wohrtWW/g+iHvBH6/VZTf4f2J+3POtwaF62xE?=
 =?us-ascii?Q?CUXI2Iic8AIVYYt+iUDNIVpPzboIhsAJGFafoLw2E/mxS/dYEIQVYLH2Ouhc?=
 =?us-ascii?Q?poaUcPfYMEk3wLfFul+FhkkmbzEMfk5FBm0GdVGPmdC1aVSK+LPsnhat/u/y?=
 =?us-ascii?Q?A29ZdT7Iy78SqeCz1lfS1a88eaLSJ7ahqFsLX2VNrYQOXtY9clKK8V/kHtvI?=
 =?us-ascii?Q?goMCEMLShJdLaCKAJ+qNXTYb8aZZiXK5KMYFs1Edq9gwtSdYMwUZJutwn+qD?=
 =?us-ascii?Q?UhofPCm/67KMy8hjJ7zKTebfijDXALBhhPhpueYrqSSkS4ujMEg8TpN2CNYL?=
 =?us-ascii?Q?O8oClVpTpG5bIZnci1rPkp3C6Z7/iJCOk0r+Tg6JBaSAct83VLduv8fkChCp?=
 =?us-ascii?Q?FDrfI0RRovPAZc4MSfHTbtoA/I/amJJ+lW4ieadQ+tU30x/VoG9lQ+bSmAlA?=
 =?us-ascii?Q?Lelca0pSpUCBUl6egWsjqiiS34X+/T5PEeqDcWvCYaptMLh9urf1VYk/qFNN?=
 =?us-ascii?Q?QHkNHPQhxKhhBQ4u4SFJedR+WlqG3RoMOJ1GICW/FZ5bvSw6y9wJrni37fod?=
 =?us-ascii?Q?95N4WSbJPx+CNb4lh5pOY4XYIXDtkHtAk4nkicknRa1oF6kqKqWbcnK2AuHI?=
 =?us-ascii?Q?Peq8fN794edMGU3CMjSP8n9unNde3xVFbL6LRqYnYTgAJsU9jT3LK69uQPrm?=
 =?us-ascii?Q?AF+vk0tiomRXJbBehF0DcsSODrNz1NwV7Zpcp7numoedEWhgBNZfyQHtaLXr?=
 =?us-ascii?Q?K8ErqwbvJZIq/xLXM9AX20v1AB5lVZKjVKJDDUktg5mUodxjPp+cwDoFAPy1?=
 =?us-ascii?Q?0V+T06x4dwQCwiuvmM37eumJb+s=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <18FB9A96F2D24E41B2F93469406C1586@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cce8c394-958c-457e-1352-08dab88908b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2022 02:06:32.2083
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qYVJa85IE6GgusYyuT4lAS7DO+DklQCb4CnpFBfjEEUfE5BvXEonkMECpoYRCp1PuoN5sXeVPHWHYgMhkzqZMHABQhSy/1dPHS0AkjYslEI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4941
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-27_07,2022-10-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 spamscore=0 phishscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2210280011
X-Proofpoint-GUID: _bmeh8ANhPqi6um9MtrFE18ORjlPIEhd
X-Proofpoint-ORIG-GUID: _bmeh8ANhPqi6um9MtrFE18ORjlPIEhd
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> On Oct 21, 2022, at 3:29 PM, allison.henderson@oracle.com wrote:
>=20
> From: Allison Henderson <allison.henderson@oracle.com>
>=20
> Return the directory offset information when removing an entry to the
> directory.
>=20
> This offset will be used as the parent pointer offset in xfs_remove.
>=20
> Signed-off-by: Mark Tinguely <tinguely@sgi.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Looks good
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
> ---
> fs/xfs/libxfs/xfs_dir2.c       | 6 +++++-
> fs/xfs/libxfs/xfs_dir2.h       | 3 ++-
> fs/xfs/libxfs/xfs_dir2_block.c | 4 ++--
> fs/xfs/libxfs/xfs_dir2_leaf.c  | 5 +++--
> fs/xfs/libxfs/xfs_dir2_node.c  | 5 +++--
> fs/xfs/libxfs/xfs_dir2_sf.c    | 2 ++
> fs/xfs/xfs_inode.c             | 4 ++--
> 7 files changed, 19 insertions(+), 10 deletions(-)
>=20
> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
> index 69a6561c22cc..891c1f701f53 100644
> --- a/fs/xfs/libxfs/xfs_dir2.c
> +++ b/fs/xfs/libxfs/xfs_dir2.c
> @@ -436,7 +436,8 @@ xfs_dir_removename(
> 	struct xfs_inode	*dp,
> 	struct xfs_name		*name,
> 	xfs_ino_t		ino,
> -	xfs_extlen_t		total)		/* bmap's total block count */
> +	xfs_extlen_t		total,		/* bmap's total block count */
> +	xfs_dir2_dataptr_t	*offset)	/* OUT: offset in directory */
> {
> 	struct xfs_da_args	*args;
> 	int			rval;
> @@ -481,6 +482,9 @@ xfs_dir_removename(
> 	else
> 		rval =3D xfs_dir2_node_removename(args);
> out_free:
> +	if (offset)
> +		*offset =3D args->offset;
> +
> 	kmem_free(args);
> 	return rval;
> }
> diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
> index d96954478696..0c2d7c0af78f 100644
> --- a/fs/xfs/libxfs/xfs_dir2.h
> +++ b/fs/xfs/libxfs/xfs_dir2.h
> @@ -46,7 +46,8 @@ extern int xfs_dir_lookup(struct xfs_trans *tp, struct =
xfs_inode *dp,
> 				struct xfs_name *ci_name);
> extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
> 				struct xfs_name *name, xfs_ino_t ino,
> -				xfs_extlen_t tot);
> +				xfs_extlen_t tot,
> +				xfs_dir2_dataptr_t *offset);
> extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
> 				const struct xfs_name *name, xfs_ino_t inum,
> 				xfs_extlen_t tot);
> diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_bloc=
k.c
> index 70aeab9d2a12..d36f3f1491da 100644
> --- a/fs/xfs/libxfs/xfs_dir2_block.c
> +++ b/fs/xfs/libxfs/xfs_dir2_block.c
> @@ -810,9 +810,9 @@ xfs_dir2_block_removename(
> 	/*
> 	 * Point to the data entry using the leaf entry.
> 	 */
> +	args->offset =3D be32_to_cpu(blp[ent].address);
> 	dep =3D (xfs_dir2_data_entry_t *)((char *)hdr +
> -			xfs_dir2_dataptr_to_off(args->geo,
> -						be32_to_cpu(blp[ent].address)));
> +			xfs_dir2_dataptr_to_off(args->geo, args->offset));
> 	/*
> 	 * Mark the data entry's space free.
> 	 */
> diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.=
c
> index 9ab520b66547..b4a066259d97 100644
> --- a/fs/xfs/libxfs/xfs_dir2_leaf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
> @@ -1386,9 +1386,10 @@ xfs_dir2_leaf_removename(
> 	 * Point to the leaf entry, use that to point to the data entry.
> 	 */
> 	lep =3D &leafhdr.ents[index];
> -	db =3D xfs_dir2_dataptr_to_db(geo, be32_to_cpu(lep->address));
> +	args->offset =3D be32_to_cpu(lep->address);
> +	db =3D xfs_dir2_dataptr_to_db(args->geo, args->offset);
> 	dep =3D (xfs_dir2_data_entry_t *)((char *)hdr +
> -		xfs_dir2_dataptr_to_off(geo, be32_to_cpu(lep->address)));
> +		xfs_dir2_dataptr_to_off(args->geo, args->offset));
> 	needscan =3D needlog =3D 0;
> 	oldbest =3D be16_to_cpu(bf[0].length);
> 	ltp =3D xfs_dir2_leaf_tail_p(geo, leaf);
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.=
c
> index 5a9513c036b8..39cbdeafa0f6 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -1296,9 +1296,10 @@ xfs_dir2_leafn_remove(
> 	/*
> 	 * Extract the data block and offset from the entry.
> 	 */
> -	db =3D xfs_dir2_dataptr_to_db(geo, be32_to_cpu(lep->address));
> +	args->offset =3D be32_to_cpu(lep->address);
> +	db =3D xfs_dir2_dataptr_to_db(args->geo, args->offset);
> 	ASSERT(dblk->blkno =3D=3D db);
> -	off =3D xfs_dir2_dataptr_to_off(geo, be32_to_cpu(lep->address));
> +	off =3D xfs_dir2_dataptr_to_off(args->geo, args->offset);
> 	ASSERT(dblk->index =3D=3D off);
>=20
> 	/*
> diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
> index 44bc4ba3da8a..b49578a547b3 100644
> --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
> @@ -969,6 +969,8 @@ xfs_dir2_sf_removename(
> 								XFS_CMP_EXACT) {
> 			ASSERT(xfs_dir2_sf_get_ino(mp, sfp, sfep) =3D=3D
> 			       args->inumber);
> +			args->offset =3D xfs_dir2_byte_to_dataptr(
> +						xfs_dir2_sf_get_offset(sfep));
> 			break;
> 		}
> 	}
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 229bc126b7c8..a0d5761e1fee 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2506,7 +2506,7 @@ xfs_remove(
> 	if (error)
> 		goto out_trans_cancel;
>=20
> -	error =3D xfs_dir_removename(tp, dp, name, ip->i_ino, resblks);
> +	error =3D xfs_dir_removename(tp, dp, name, ip->i_ino, resblks, NULL);
> 	if (error) {
> 		ASSERT(error !=3D -ENOENT);
> 		goto out_trans_cancel;
> @@ -3095,7 +3095,7 @@ xfs_rename(
> 					spaceres);
> 	else
> 		error =3D xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
> -					   spaceres);
> +					   spaceres, NULL);
>=20
> 	if (error)
> 		goto out_trans_cancel;
> --=20
> 2.25.1
>=20

