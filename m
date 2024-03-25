Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F349A14EC6A
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 06:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711346429; cv=fail; b=BSye4DPcrQM5Hqwr9ndqQwV2eCcE9II32lVhZFmiauyDishxzKPh+pirvESqFnDEVXZY/hSDe+l8JSF9svtvIaLvaYBeJ6ETf/92Kc33uY7YkF0X0gWqwVOKHrqxOeqCMvQLQQDFcQGqt7ErMstr0cu1444KjF56F3wCwBajlrg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711346429; c=relaxed/simple;
	bh=j3q3RBahBdyANO/XV8kCbpFrcElS7R+ZkReVgii7ibg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZrMcDcaEudoJ/Vip3BGnctmBNo7uRmPI4Pf7Wi/rwtOHw2aqOu8ysVqpZZ7pNZolzyD0Ppdylv3OIu1GmyrBXxHMFrp7oG+2C2FAz5+r4Sa1KX4mU0az0vUi/ib4oK1Z1EEIdbZ5mINL4TfXf+xTlhtcIztYRod2VJwhYu2uXf0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GbznRj3c; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=BxmodwW3; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GbznRj3c";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="BxmodwW3"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42P47cK1031826;
	Mon, 25 Mar 2024 06:00:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=G1gO8I0UfWyOK7fNejg6e+t/gSx1ZqQq8wtLGBqdpL4=;
 b=GbznRj3ceqyLNslr9i3QW36LRPxNX0+VCyf0eJLLRQWx5Y53bFdit3Sm04kkNawbCTRw
 4UVAqpbrDBd7XAgbbiAWNvDAjuL7+UqmmHg5mZk+hirXnNlsjJvloTq9VVjsqCmLOTd2
 HC3v/5AtQkqUq98aHObD54B1LFWvizRscP00i/NRwTyCGa8fajGFA4plz6725zHWy4aU
 dbGEoQ2Nuc5/wMR7ePJCiw8tyHbiPNqMIsv1qi9aoaTutswLLZuEYU3kC7zF1MWSu2BA
 XNEjrebdGL2k+XFkNT4jnYx22NJsS/oYvlfueOs6eudH3OJtW7MrWjPlC27nFtpDDi5c Ig== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x1pybhwuf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Mar 2024 06:00:24 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42P5X4VL033045;
	Mon, 25 Mar 2024 06:00:23 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nhba4uj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Mar 2024 06:00:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LHLhhFnHqCLPrw5J0vxLDpI0w5vQ0sD9gMqTI1BXfqGQ3Fsb7otWBRvI+NfmFBFdMrHj28S35QVZpa4vX2SGdQkBH0X1kKBAvY5DrsoMhzTeO/TU8JXgw2mn2J/4i99i6mN6UC6HRuB8OSChS1O9dsFuTZVjtrHEyl/W/dihRnBtrY7ye0eTJaJxFWTZZZXnzJpoZN73NoiWJyzGPMYbZs5bjBG/pop7bCCQ7IHrJLMSV0EM7GEAK29U2iPPR7dRJJTX6y6MOggqDwCQHi69pWRfN5uBjGTuwVfzZ6WFUH4jLcyshZHuMkQoQrYm5xdz5DkVc0BbeInTl7cxen5Gdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G1gO8I0UfWyOK7fNejg6e+t/gSx1ZqQq8wtLGBqdpL4=;
 b=YUhv6DiTe3W2VcvD7nPQtfZ/z/m1MOtl1dQDJY31X4vIW700NFOkkOl8UkC4ezgS7xs3umNMLSQzJyiPSofX1tsXNnX67IpLPoPyZmBg1Jow6XE4PXaukBPv6WqdVXQarIfu9/PhCvc709AIvkAtOh6W8vS2KDB3LbkISVjpiWN4+mdXJEZ8aufVc3Ijli/yX9745tTq42STWpSnoX8sN1raNj/FAeQx42J1V9jqmhm1z8Y36zh4DpNEDmIgE2XDk0wDUPvLElu79iTCcJOdP5T1BgUldHgI2cych2cn6xmUphoyOrV/2n/MHHEzJX9lvdExoYzOlkCZwqQZ3a1gSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G1gO8I0UfWyOK7fNejg6e+t/gSx1ZqQq8wtLGBqdpL4=;
 b=BxmodwW3BnywnjTttMlvYRGtl6ESjQLnFNFyMmon45C0OQvvDifo0kpzJHjAbABUCL16RuRmI17OS2Bg2SJ1UGEuOCAXfjhZXWd+qWKzMW+JG2xgSqbfnE9bFmi3krfk/qiWpCUY0sPj1cq6zI2BDDCLjgz8MEjHhRYYzqJGuis=
Received: from CY8PR10MB7241.namprd10.prod.outlook.com (2603:10b6:930:72::15)
 by DM6PR10MB4331.namprd10.prod.outlook.com (2603:10b6:5:222::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Mon, 25 Mar
 2024 06:00:21 +0000
Received: from CY8PR10MB7241.namprd10.prod.outlook.com
 ([fe80::88a2:eeea:4e1a:5f41]) by CY8PR10MB7241.namprd10.prod.outlook.com
 ([fe80::88a2:eeea:4e1a:5f41%5]) with mapi id 15.20.7409.028; Mon, 25 Mar 2024
 06:00:21 +0000
From: Srikanth C S <srikanth.c.s@oracle.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "cem@kernel.org"
	<cem@kernel.org>,
        Rajesh Sivaramasubramaniom
	<rajesh.sivaramasubramaniom@oracle.com>
Subject: RE: [External] : Re: [PATCH] xfs_repair: Dump both inode details in
 Phase 6 duplicate file check
Thread-Topic: [External] : Re: [PATCH] xfs_repair: Dump both inode details in
 Phase 6 duplicate file check
Thread-Index: AQHafBPGRM+7fT9j5EKPTL+hLJFPBLFEIMQAgAPaChA=
Date: Mon, 25 Mar 2024 06:00:21 +0000
Message-ID: 
 <CY8PR10MB7241E8C11D6297388A164492A3362@CY8PR10MB7241.namprd10.prod.outlook.com>
References: <20240322044512.2268806-1-srikanth.c.s@oracle.com>
 <20240322190928.GA16399@frogsfrogsfrogs>
In-Reply-To: <20240322190928.GA16399@frogsfrogsfrogs>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CY8PR10MB7241:EE_|DM6PR10MB4331:EE_
x-ms-office365-filtering-correlation-id: 04e91abe-eaf6-4b5c-aa34-08dc4c90dadc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 dgfTjKlxScFxxNvqRGn0w0bctDau4Is5CIzUtnStVFXoAtb2MrH00XhsP20qklUjeRU5wf+aLqwXiIJJjS8KgBbV0ca/hoGFw1kWEBI0Mz/XGBKaa281LUoSO0fVer3JvJQBmeYMS9cyFiYKW0S9nf8rJt8T4e9hPr8k3MwUD8NAHqqJ1gPg9gT/nBITbSvGq2NCLwope4fuc3U7z0T65L9Qfwdr2pKtehLdnnQyUaI3aJZ1VmmG3bS9BBjXtFOb5EwzSChwJ9bMzp/P+dwd5VE+xJc2qGLNn9VztOjFP7SgSSIGNWSt9nYJyBHyXZhx4vbXwpkdK5dOwaFDxJqeaG41+UO6u4gwdbACteIKdJDlIt8kP9geN64TT1sEt/VINF57OeennaZRzquXrH9XcC7qeawOEJDEl6V4tDTnYaR0MUC/RZb1rzhEGovURfulopB/BVQ8PWjwJ4REZUx8uqiPglutW/WXejkBic4YI7EM0JMONyPJ28BTt3C/BTMnPMXHpipqkF0qn055UOFc7mWkjN5wNmQ1+rLAmoVMzJQ+umbqd71u83IyU11Yiy6VRc5lmX6rTVc9k5JwJ1ecXOorHq5sKWVPoGS61p12lQuDM4Dx4G9GQ/NJZtvrLUU4jIHbUxRa+Cgd+FkK9p3Ed3DsALlG0mA3Z22ewTn1Zfg7FjqWN8kQYtdhpoIHWls6JT46VOfAkDyMPzPamfnjsBtv6OyCJlY+ti15gBOUnD4=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7241.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?mtSgKH0Ax98TCsVtw00J6/P//hXEWfA2zqChhy8kbxzcuMAZW/dFE0CgxZw9?=
 =?us-ascii?Q?TZ0Tvsx+8YMpk+jrUqRmhqJNHfPVDmPdXKUyPHh8mMnFwTWOQWBqklBPaVAR?=
 =?us-ascii?Q?V5LBFINhkLE7uR+YsGoTGX1/tZ9IZA+DxpI24lZo1dkhJqvFtMV0i+Mf0GW1?=
 =?us-ascii?Q?te4JX4Uvn7SEUyyWehnqGbMvo0mf5ln2Ir9sahMclBik+02IC7K3mqL9TIhj?=
 =?us-ascii?Q?mySqVeDnk6+ha8MlmFIMs+EKimnSJpV9V0mXKJcy06p60gm4w1zkBWGWfdX0?=
 =?us-ascii?Q?EfbgXTOfk4oUCYzQv7X5c/GY99+KhpFGa3ZLfterYX0W/AnRV1jh1GMj0njF?=
 =?us-ascii?Q?fyIBQ6TbE+7IdlLjUdBoPV/yjQj/PHxKynetP9hAwrWHguKoa4tAmsQfAqnJ?=
 =?us-ascii?Q?4yi7YpZaKXova0abycuzcKFF5m0+cos+aUSgdBlMNVPj8BoAUhrqdXhk6Aep?=
 =?us-ascii?Q?aqae2XriKed0NBDoKaahAgC7Pl1Tr7SrAzmx3OeiDeiIhvQ5FA6niNVp9w/m?=
 =?us-ascii?Q?uJURduv99W2hgYG85vMbwrTEOPK4bBkhngXslfmv3pLeahoMtSIVWmMkkjBA?=
 =?us-ascii?Q?hU6a/lwMxmYdQRU92ktBbQUeVZj2fXJqsTuWap6ad9yq8cQdM8F3GXqREhdb?=
 =?us-ascii?Q?ZH7GyqaO/5rbAlAAJJwi9L1y/sSHKF9BY0ldseSEwrS5ZhWDAi0i9hnk1Pui?=
 =?us-ascii?Q?gvl3a5hBQyb6smVai/S0T6jZNkmDCNSa/wADEOTzpPhL0m14vuoEzb1YBp8i?=
 =?us-ascii?Q?bXaMgJbRwS4Bw4v3bv7qm/pTyKkUUgPq29WfFSp4Ody4WlGdgn1ewXEGPPpq?=
 =?us-ascii?Q?dQQ+L8AruM/duw8hRGj8ZiMEUzAYv/Fg4kfQTQwg3Hev0K1IB4slQF/Qq/EY?=
 =?us-ascii?Q?AxEyxVYeqoFzd2x3Y1PgcvU8ORrMZIGU2VPnu/FOG4nrR3UmyzbxsmEWUacv?=
 =?us-ascii?Q?h2D0EuxfNE6a1SCPnx9EVY166xCr04QPEVAvV+ip/a6V5JV1mgLu2JkfRHlD?=
 =?us-ascii?Q?fiAvGUmuBpReGkbJKw8OG9WBqg6OEHwq7fgQTksMWGfhCnD0PjbslI+XjEdU?=
 =?us-ascii?Q?Gun3Rece2kKubo1063e60hEj9uTSknta/qk+csV30cQ7kCMGt/s0Uf6W11A3?=
 =?us-ascii?Q?hJrDVQW4bNJaNrQPVRR2uATy9uO1T4wTpd7v3zq0Bsv7CXwfutnVvXR3pCfZ?=
 =?us-ascii?Q?4KX87L6w7CtZlKSSkJ60+dzAyOsmWvMds0B0i5i0fPzrAXcZDFBVjyCreh4T?=
 =?us-ascii?Q?J/nYnQml32W2+bEvauFL/JgT0j5tPiYgiLs3RclLaPQZha3eB5cL2xByHRil?=
 =?us-ascii?Q?omaVg9Gr3jR+dRgwUg7t9A3NWHZ+Z3wOVbtOh/dzRp9IsUTDFO7Hru+t412E?=
 =?us-ascii?Q?+FwLkt5gEebFDkMKR1Yn/5RNHsbn6dyYbvRiaBL3n3NcfE6EJ3tR5Yogja6n?=
 =?us-ascii?Q?TMFeZ1LRln0gHkoijKYLqEhXvcelTDko0dZXxPD+KTpyx+hheGtb9P/abodz?=
 =?us-ascii?Q?dKEL25rDUh8cqDEN7TpynESsrWinJomPJqYZRVrkZVf3rgItIAuBkrYyfgzt?=
 =?us-ascii?Q?f8+30ws16RL5IG8R4ESEWnkLaO1ecJR0DLOEfE8K?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	m/WvwCJ+0Y7qxEMKSKiaQPeQcbVwX/ty6/SrG9211w/uUyvV4doKbwJ21wZ0Pi5KXhK2uQjzzFbrdPR5AQEEJ98+ZwxBfBsI1QDs/8DoVmwLCkyMXBqIQOxXKO69xVvRXojaZ/8jL6Wh2mWetQS2hQ+zku/Jd0SSysCaGtzBB8r2I3eeH8MzMWKweP5pOMGEHCuIz0eaAAkMZxPZF23Ya91SgHMofX7TT+TeegJBRGPp3EsyAUjWv4YB/E0AWQad5uyt3v2AYSdpvnbWEpjqYk/SSUspLt7wm/v9sRhslCnWoZomyasJi2VXYeKyHYoi5H5ZTt9PrK3ABdnzupcai6QZQynLzMmYoiCiGsv36H7UOiy92HFQ1i788eJJnHzs2J4+5VrZU75tNyxBtnI+qEQlguD+G8hM5AG/ZhT4S3pEKH2fgyiFvaiNitvjAWVeUVB5gsvu0g9ilOE2lX4UzuTi4e2nePUV67Y/PZ1p1lTy607Rw8wgdmrbsQiODX36/OeXEzrwjQKM8jVV1mBHnpFLHCmmMyZ8mm1EaqtdCWfoWH4hRh6E1GgC0M3S4tnchoVJHxj9wq5iTdko7IRxzvdUUfZsjeBuh07f4PB0EEA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7241.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04e91abe-eaf6-4b5c-aa34-08dc4c90dadc
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2024 06:00:21.0518
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7Mgx2+v7nysr3vKpJ17gJBk456PCJCe6A7o79Hgmuu5BKjoGZeOuaXTx+xvgxpARqgwIutth9Bl292WGzrbXog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4331
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-25_03,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2403210000
 definitions=main-2403250031
X-Proofpoint-GUID: 3tDX5KE40cqfaXij0rrRyMPZaH_rUaV4
X-Proofpoint-ORIG-GUID: 3tDX5KE40cqfaXij0rrRyMPZaH_rUaV4



> -----Original Message-----
> From: Darrick J. Wong <djwong@kernel.org>
> Sent: 23 March 2024 12:39 AM
> To: Srikanth C S <srikanth.c.s@oracle.com>
> Cc: linux-xfs@vger.kernel.org; cem@kernel.org; Rajesh
> Sivaramasubramaniom <rajesh.sivaramasubramaniom@oracle.com>
> Subject: [External] : Re: [PATCH] xfs_repair: Dump both inode details in
> Phase 6 duplicate file check
>=20
> On Fri, Mar 22, 2024 at 04:45:12AM +0000, Srikanth C S wrote:
> > The current check for duplicate names only dumps the inode number of
> > the parent directory and the inode number of the actual inode in questi=
on.
> > But, the inode number of original inode is not dumped. This patch
> > dumps the original inode too.
> >
> > xfs_repair output before applying this patch Phase 6 - check inode
> > connectivity...
> >         - traversing filesystem ...
> > entry "dup-name1" (ino 132) in dir 128 is a duplicate name, would junk
> > entry entry "dup-name1" (ino 133) in dir 128 is a duplicate name,
> > would junk entry
> >
> > After this patch
> > Phase 6 - check inode connectivity...
> >         - traversing filesystem ...
> > entry "dup-name1" (ino 132) in dir 128 already points to ino 131,
> > would junk entry entry "dup-name1" (ino 133) in dir 128 already points
> > to ino 131, would junk entry
> >
> > The entry_junked() function takes in only 4 arguments. In order to
> > print the original inode number, modifying the function to take 5
> > parameters
> >
> > Signed-off-by: Srikanth C S <srikanth.c.s@oracle.com>
> > ---
> >  repair/phase6.c | 51
> > +++++++++++++++++++++++++++++--------------------
> >  1 file changed, 30 insertions(+), 21 deletions(-)
> >
> > diff --git a/repair/phase6.c b/repair/phase6.c index
> > 3870c5c9..148454d0 100644
> > --- a/repair/phase6.c
> > +++ b/repair/phase6.c
> > @@ -151,9 +151,10 @@ dir_read_buf(
> >  }
> >
> >  /*
> > - * Returns 0 if the name already exists (ie. a duplicate)
> > + * Returns inode number of original file if the name already exists
> > + * (ie. a duplicate)
> >   */
> > -static int
> > +static xfs_ino_t
> >  dir_hash_add(
> >  	struct xfs_mount	*mp,
> >  	struct dir_hash_tab	*hashtab,
> > @@ -166,7 +167,7 @@ dir_hash_add(
> >  	xfs_dahash_t		hash =3D 0;
> >  	int			byhash =3D 0;
> >  	struct dir_hash_ent	*p;
> > -	int			dup;
> > +	xfs_ino_t		dup_inum;
> >  	short			junk;
> >  	struct xfs_name		xname;
> >  	int			error;
> > @@ -176,7 +177,7 @@ dir_hash_add(
> >  	xname.type =3D ftype;
> >
> >  	junk =3D name[0] =3D=3D '/';
> > -	dup =3D 0;
> > +	dup_inum =3D 0;
> >
> >  	if (!junk) {
> >  		hash =3D libxfs_dir2_hashname(mp, &xname); @@ -188,7
> +189,7 @@
> > dir_hash_add(
> >  		for (p =3D hashtab->byhash[byhash]; p; p =3D p->nextbyhash) {
> >  			if (p->hashval =3D=3D hash && p->name.len =3D=3D namelen)
> {
> >  				if (memcmp(p->name.name, name,
> namelen) =3D=3D 0) {
> > -					dup =3D 1;
> > +					dup_inum =3D p->inum;
> >  					junk =3D 1;
> >  					break;
> >  				}
> > @@ -234,7 +235,7 @@ dir_hash_add(
> >  	p->name.name =3D p->namebuf;
> >  	p->name.len =3D namelen;
> >  	p->name.type =3D ftype;
> > -	return !dup;
> > +	return dup_inum;
> >  }
> >
> >  /* Mark an existing directory hashtable entry as junk. */ @@ -1173,9
> > +1174,13 @@ entry_junked(
> >  	const char 	*msg,
> >  	const char	*iname,
> >  	xfs_ino_t	ino1,
> > -	xfs_ino_t	ino2)
> > +	xfs_ino_t	ino2,
> > +	xfs_ino_t	ino3)
> >  {
> > -	do_warn(msg, iname, ino1, ino2);
> > +	if(ino3)
>=20
> Hmm.  Seeing as we have a symbol (NULLFSINO) for null values, perhaps thi=
s
> should be:
>=20
> 	if (ino3 !=3D NULLFSINO)
> 		do_warn(msg, iname, ino1, ino2, ino3);
>=20
> Otherwise looks fine to me....
>=20
> --D

Yes, using the symbol NULLFSINO makes more sense. Will send out a V2.

Thanks,
Srikanth

>=20
> > +		do_warn(msg, iname, ino1, ino2, ino3);
> > +	else
> > +		do_warn(msg, iname, ino1, ino2);
> >  	if (!no_modify)
> >  		do_warn(_("junking entry\n"));
> >  	else
> > @@ -1470,6 +1475,7 @@ longform_dir2_entry_check_data(
> >  	int			i;
> >  	int			ino_offset;
> >  	xfs_ino_t		inum;
> > +	xfs_ino_t		dup_inum;
> >  	ino_tree_node_t		*irec;
> >  	int			junkit;
> >  	int			lastfree;
> > @@ -1680,7 +1686,7 @@ longform_dir2_entry_check_data(
> >  			nbad++;
> >  			if (entry_junked(
> >  	_("entry \"%s\" in directory inode %" PRIu64 " points to non-existent
> inode %" PRIu64 ", "),
> > -					fname, ip->i_ino, inum)) {
> > +					fname, ip->i_ino, inum, 0)) {
> >  				dep->name[0] =3D '/';
> >  				libxfs_dir2_data_log_entry(&da, bp, dep);
> >  			}
> > @@ -1697,7 +1703,7 @@ longform_dir2_entry_check_data(
> >  			nbad++;
> >  			if (entry_junked(
> >  	_("entry \"%s\" in directory inode %" PRIu64 " points to free inode
> %" PRIu64 ", "),
> > -					fname, ip->i_ino, inum)) {
> > +					fname, ip->i_ino, inum, 0)) {
> >  				dep->name[0] =3D '/';
> >  				libxfs_dir2_data_log_entry(&da, bp, dep);
> >  			}
> > @@ -1715,7 +1721,7 @@ longform_dir2_entry_check_data(
> >  				nbad++;
> >  				if (entry_junked(
> >  	_("%s (ino %" PRIu64 ") in root (%" PRIu64 ") is not a directory, "),
> > -						ORPHANAGE, inum, ip-
> >i_ino)) {
> > +						ORPHANAGE, inum, ip-
> >i_ino, 0)) {
> >  					dep->name[0] =3D '/';
> >  					libxfs_dir2_data_log_entry(&da, bp,
> dep);
> >  				}
> > @@ -1732,12 +1738,13 @@ longform_dir2_entry_check_data(
> >  		/*
> >  		 * check for duplicate names in directory.
> >  		 */
> > -		if (!dir_hash_add(mp, hashtab, addr, inum, dep->namelen,
> > -				dep->name, libxfs_dir2_data_get_ftype(mp,
> dep))) {
> > +		dup_inum =3D dir_hash_add(mp, hashtab, addr, inum, dep-
> >namelen,
> > +				dep->name, libxfs_dir2_data_get_ftype(mp,
> dep));
> > +		if (dup_inum) {
> >  			nbad++;
> >  			if (entry_junked(
> > -	_("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate
> name, "),
> > -					fname, inum, ip->i_ino)) {
> > +	_("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " already points t=
o
> ino %" PRIu64 ", "),
> > +					fname, inum, ip->i_ino, dup_inum)) {
> >  				dep->name[0] =3D '/';
> >  				libxfs_dir2_data_log_entry(&da, bp, dep);
> >  			}
> > @@ -1768,7 +1775,7 @@ longform_dir2_entry_check_data(
> >  				nbad++;
> >  				if (entry_junked(
> >  	_("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is not in the th=
e
> first block, "), fname,
> > -						inum, ip->i_ino)) {
> > +						inum, ip->i_ino, 0)) {
> >  					dir_hash_junkit(hashtab, addr);
> >  					dep->name[0] =3D '/';
> >  					libxfs_dir2_data_log_entry(&da, bp,
> dep); @@ -1801,7 +1808,7 @@
> > longform_dir2_entry_check_data(
> >  				nbad++;
> >  				if (entry_junked(
> >  	_("entry \"%s\" in dir %" PRIu64 " is not the first entry, "),
> > -						fname, inum, ip->i_ino)) {
> > +						fname, inum, ip->i_ino, 0)) {
> >  					dir_hash_junkit(hashtab, addr);
> >  					dep->name[0] =3D '/';
> >  					libxfs_dir2_data_log_entry(&da, bp,
> dep); @@ -2456,6 +2463,7 @@
> > shortform_dir2_entry_check(  {
> >  	xfs_ino_t		lino;
> >  	xfs_ino_t		parent;
> > +	xfs_ino_t		dup_inum;
> >  	struct xfs_dir2_sf_hdr	*sfp;
> >  	struct xfs_dir2_sf_entry *sfep;
> >  	struct xfs_dir2_sf_entry *next_sfep; @@ -2639,13 +2647,14 @@
> > shortform_dir2_entry_check(
> >  		/*
> >  		 * check for duplicate names in directory.
> >  		 */
> > -		if (!dir_hash_add(mp, hashtab, (xfs_dir2_dataptr_t)
> > +		dup_inum =3D dir_hash_add(mp, hashtab, (xfs_dir2_dataptr_t)
> >  				(sfep - xfs_dir2_sf_firstentry(sfp)),
> >  				lino, sfep->namelen, sfep->name,
> > -				libxfs_dir2_sf_get_ftype(mp, sfep))) {
> > +				libxfs_dir2_sf_get_ftype(mp, sfep));
> > +		if (dup_inum) {
> >  			do_warn(
> > -_("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate na=
me, "),
> > -				fname, lino, ino);
> > +_("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " already points to=
 ino
> %" PRIu64 ", "),
> > +				fname, lino, ino, dup_inum);
> >  			next_sfep =3D shortform_dir2_junk(mp, sfp, sfep, lino,
> >  						&max_size, &i,
> &bytes_deleted,
> >  						ino_dirty);
> > --
> > 2.25.1
> >
> >
