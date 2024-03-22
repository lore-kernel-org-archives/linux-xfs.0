Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B0246FA7
	for <linux-xfs@vger.kernel.org>; Fri, 22 Mar 2024 03:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711079806; cv=fail; b=VsHIOpwevC9FJODiFyiPIJPnWm4vbFyH4MPhxpGvJ7ooEJdzU7jl6mKwzcptME/YarRYDPjcl3vQGy3lkO+CEJwIW6lqiHYOwywYZ4DCRIxyHWRZOgGQQXbHCCx3t0fC2t8vkeu8cTu921JTvMchJL1DwhFrBM9zs3rVX4Vfyzs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711079806; c=relaxed/simple;
	bh=6/35bWwtbi8haw57h4kfvrJOXHu+VjaGAWIIERGA9jg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=l0Cms6kIUWzzltQ+eGW1Ow7HTw0yCTZRpHb6v9EGEq9ecId7m+vjluZagYN5vzZs/hBvDnziOFSYo4++JSRIwQ5mfIWTgpaoh/1Sbjv8bAD8l60TSgbB8L14ReibfwTFDmzxbcj/8kKfhqRe2bpsIieefkXKbQ9QVb0aB83TQS0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ByNSlp6I; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=eQRJm6bJ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ByNSlp6I";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="eQRJm6bJ"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42M2TNup032174;
	Fri, 22 Mar 2024 03:56:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=vecL/n+9fTscsY5tL25KjSd9p92klvoT79lHm+pS2fU=;
 b=ByNSlp6IF4LUpjv9Kz1Ar6ztTvnBOWpusCXMnJVCw1XB/IIlRjgwQlgIkGwpTSBPKn/E
 UNNA3HSTe8HN3QofvPyCPUXpQsx/80OU9CysPA2WEjfHakJfWqIGWBI4fyPCZ+pZnzPC
 6Y3+GffmKeknSQoCvlPeWZUvIwuo14qyTC4lBf+6TPq0FcDVInQRdwdtj/RfqX2NLHNH
 naPMVOftQcsG0SPJ4hsjx+LWMDaAqcDsJhlLvdbtpcnXtocQC2SfhzUr9rXZ7asyXNxR
 FpuzHxTfIEXaKB5loV9rHNohg0E9WvZm3Z5qMiMpdUu9aXT20JNSFOWFitwP5NmQNuVA Gg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x0wvqr8b9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Mar 2024 03:56:39 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42M1URQ6014876;
	Fri, 22 Mar 2024 03:56:38 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x0wvjq7k3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Mar 2024 03:56:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WkXPtzRcWoKqonzG9Sfa0ZEFDcSwodTeHdjx2E6e3kyL7NVuo4dFgbpO5h+nuHY/Q0u9zLEiUvMuqPROePJZ2Cqw1/HbhXeBD71tWREULjweWajyusfJs/CIXwoVVxpLOGqb+aQcf05Lp1y4s9CbEB2Eei0Q5WCYrl54toiHCbazT3NrGNPDZOS/v+UpWsa9zdOVY2mblt/dLyAXelKm4yUrpwwV0KBN0ZSCNi4LT0eZmvqoH16ME9i0sd7PiVol3jAszii3o7Qph9wqHn4+McIJF61wfAaveIJA9lRs7Si57R1leC+1rof+5KXYr860zEfkv4hAtzim7wcxc/j5YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vecL/n+9fTscsY5tL25KjSd9p92klvoT79lHm+pS2fU=;
 b=NvsTEgrvBUGMfoBokgH3J62XdtpYN1fx2LSzGukBqMGk3SiBmmrjX3ldjUuVOMbKNG9UCIUD23A7sg43Kv22ZWJgpkY3m21Z/te/hx3vnbaDj78MxOCu/0xLo1BJLHi92FGt8js4RIfmYvvWJs/DjINJisRsFKhXq6yntUTikqjodgFUeSNFX9ONsVjsWWXTzOSGrlwetkr7Y0UAXy1HPsuY8bFNs8xJ6uvyXRryziIwXnKDNOSmKGZ2BtKcrYcdX0xqFPFpDq5g0QvpWy8o2W/NvJxEs+fQi6feL06Q8UHN4otlaN43fI0dvobavklSXM63B+Q6cW/8tJDNSMsXxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vecL/n+9fTscsY5tL25KjSd9p92klvoT79lHm+pS2fU=;
 b=eQRJm6bJRmnot32ngVAEvDt7jw7jd+J68VhlP8r+gQTnwDbttQ3EOMXTjLklcYVmorW1AYKamKBXjpmCJ8VaEFE/NUkSSclZjw2PW5vMp9fE9d0/TeHkb8yL/wPMXSlwbhrRZ5HbKN2rhe6K/tYL0r76n8371bAaL7Oa5CPITF4=
Received: from CY8PR10MB7241.namprd10.prod.outlook.com (2603:10b6:930:72::15)
 by SJ1PR10MB5905.namprd10.prod.outlook.com (2603:10b6:a03:48c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.34; Fri, 22 Mar
 2024 03:56:36 +0000
Received: from CY8PR10MB7241.namprd10.prod.outlook.com
 ([fe80::88a2:eeea:4e1a:5f41]) by CY8PR10MB7241.namprd10.prod.outlook.com
 ([fe80::88a2:eeea:4e1a:5f41%5]) with mapi id 15.20.7409.022; Fri, 22 Mar 2024
 03:56:36 +0000
From: Srikanth C S <srikanth.c.s@oracle.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "cem@kernel.org"
	<cem@kernel.org>,
        Rajesh Sivaramasubramaniom
	<rajesh.sivaramasubramaniom@oracle.com>
Subject: RE: [External] : Re: [PATCH RFC] xfs_repair: Dump both inode details
 in Phase 6 duplicate file check
Thread-Topic: [External] : Re: [PATCH RFC] xfs_repair: Dump both inode details
 in Phase 6 duplicate file check
Thread-Index: AQHae25BgTX0x7M+WUq/SKpK8sQg3LFCRZWAgADc0AA=
Date: Fri, 22 Mar 2024 03:56:36 +0000
Message-ID: 
 <CY8PR10MB7241788644A9ADE032D02566A3312@CY8PR10MB7241.namprd10.prod.outlook.com>
References: <20240321090005.2234459-1-srikanth.c.s@oracle.com>
 <20240321144405.GC1927156@frogsfrogsfrogs>
In-Reply-To: <20240321144405.GC1927156@frogsfrogsfrogs>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CY8PR10MB7241:EE_|SJ1PR10MB5905:EE_
x-ms-office365-filtering-correlation-id: 8a84d632-e837-40f9-bb8d-08dc4a241204
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 hsVwCVHDlBUcaQhKIYElQersDulutrPD90Qeo8/Z5+StXaSyLiZcqok6JVR4nNLkNflu/XyGzAMrnueAXMWsF4iTRimJSEw4qS1HukOXOoe3u2IknGtNU6sdAHV5648fM+N3qX5xKunfge0Kry70CIczmF2cPRa0fJv+4Xy1K0dO+Zsqplgmu1hQDN+CyH/8KsLYQpPHMz7aUyf5RG9uwvay+dTPAoTd8kxjHy46lPN10glWNyK1ZNXA9kWLtcXpjQ9FEWyVh6Jldtfuz+9jh14qH6hwxNDNAnwDhrzXiwMLaR0HGgEKOEcmAMWqrDSRYNHN2FFar8w3x8nbEYBhEzffHFRWIR0Az0XDB13S2WUKiOnVHvM3z/nE8OF1YTl2Y/12LE3fcjnlcrQhZN8LrWPHGqsntnwQvUl1ji0R7N+giAliuBNoalgoZVRLUe54WOFMksEpf4jn1MJLLw1RWhRHmI6u9UCd5/Tjb0h2ZCN3z7bxHBq6SssjKHfgPBKlGrCRodybNkz+rPbVKJL6ttkTHV8CLuGynrMByw00RK/zKhfW5xevBm5/MXMa7y1LKXJn+QI/Yy50VEJ4J4agLskOW31D1ifGmarlUYrp/vV+ypzECvjOdHADnRvJx3S9BVD6zxr4wUWaglyi27Jknw4b48Acvnr7+VJy90mDwnpF2l1qQtyZ7uTX5TWywvLSgJNdHAMfaGiHzUUE9+ID+8iyHl/hdbBgBsirXb7tI4A=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7241.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?ueK5IeYKyO6QMJ66c3oQZTwdt7xv8UNXtu+kxsnIeUZPnVVo/YD2S8fnnvYq?=
 =?us-ascii?Q?VCGOnywV4HDtl7jmURoEln0+lsuWBxhbPQqleT2oI90Msy9EET3kZZk38mqw?=
 =?us-ascii?Q?YOTDkMLUfS2+3JrkuVFpWoyN3pL/8PkYGjb+AiKLiL2n4qRKR7obIQssvvKU?=
 =?us-ascii?Q?/Ue8xm9Cj7pixd0yEWAHwqYanFSCpuMPAqokoJ22AFHuGJL/eW16A3C08/BT?=
 =?us-ascii?Q?nPKp9Xp46i/RYXU4RWxciKaxqZUgyhN0sND+NRQa2/mgzjtPW8olHdMC+xeE?=
 =?us-ascii?Q?QQcqnYm+sNSrOA8DsTXssdmlNxV3vKY0J1m7KSEesv23wRMDDqzVjo/Ft52F?=
 =?us-ascii?Q?2xuNg/KQ2o6STgRkrcGLDJwxshuvI6lUedejkP6fliQc9UrF8BaMDxkfD6X9?=
 =?us-ascii?Q?Dt8jyDs/oIqcxK1jZbWq0Uyb+N53rhNo7m8mq/7nMHqrL/W5qc4VHYJpqyPl?=
 =?us-ascii?Q?QzB/iBQIHQ4a3CRwzfMIXbCGc6/+naXg4G4Hc/ITkUaCYyAhbqpWH/fI9U74?=
 =?us-ascii?Q?zF8T04+Kq7MGPpq2dIdEIuSlDUYjV/FqoOkqyLEySmvRmVRUw0JPY/pr9/0Y?=
 =?us-ascii?Q?C/lJppaIeICS8+7K44rVPvHjJROvvhmhVNbCnD2xo/s30K1YtlBLEKe2A3EJ?=
 =?us-ascii?Q?KBLGb3diI2o3xXM+kqnxEaPuUfm5Wt8s9FeyPNW9mK98gaVAM18jyGvMk6Ee?=
 =?us-ascii?Q?uttKLGXBwa1ZDePzha6hH/0UeMF2fhY2GfIRlCU5GE1VbXuilRZiZ6BrWXdb?=
 =?us-ascii?Q?bZPnW9vWtdV3ySpLzxmgmctga6w21CiZQp35R7DpOdJXPAc+d8WuWegD3ysQ?=
 =?us-ascii?Q?Cf5jxnt7Aj/pzjKGITwUp3MAvtQlSNg+80sycVmY0M2y2FWvXlR280jd3XXL?=
 =?us-ascii?Q?hQJ8RfssRE1my7vLcpSh6hrgt/bYvK63Y0vP4i0YBhzsIcBOpbJ0S23AQjJ9?=
 =?us-ascii?Q?5UrmdmzEmz3pImhiUEZutTTfILcFClPweT9FTUHbKa3UvYumg4SfDmKUs6zv?=
 =?us-ascii?Q?W/c7LGCVZMhnDze0IC85zvad6GB+zAvMscg2UdnCQQZn3orT6iutHBw/gKHd?=
 =?us-ascii?Q?6bBsh4byT1v1RKH2bJ2UYQNFIHSQWlhTDcb+Tct/26ASM9aCbKPoYbRtnsXD?=
 =?us-ascii?Q?IPhMauLx03qsVpM3DZOfKvDRiyx5QYT0a4yw1ClBHOtwUKQj7+y4KrwcW+lQ?=
 =?us-ascii?Q?OR7qyFo0Wb4ZW+1lHJtNs9qDfqqZRKV5IZU9tLOQQZcSOkLHJOrqiu97yPKU?=
 =?us-ascii?Q?mBuprxBOHgmI32aia6uUet57Ngzk6jqn2f0XwtKqa1H2TCwzUaTx+MHegKVs?=
 =?us-ascii?Q?CO9FPfIGJGZaTSc0I0nDs3jBAaqKZBuHgMGvnVNN+ZxF0AR4KlDEqGMXv97N?=
 =?us-ascii?Q?DSCPOYGNZhF53rxSiO8P4NFO8iE5/ZoV9l06ZKi1wGE4vZ6GT0UkdHTzWkiP?=
 =?us-ascii?Q?b/9QbgLkl+rQ2PO6xqN8KXD3fWFAN6OYTPCsc5reNBhIilLEcpJ6DvRUqGNW?=
 =?us-ascii?Q?38G22pF0frNUXaQAkLFRu5aAMLmuQM+oTMqlnP/ol3hNp3Ijn3EDvh3Y8FR6?=
 =?us-ascii?Q?GCjP9zAExB3nSi/Y0NPjY3YbOhO42s93uT3Z45I3?=
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
	TC/nFHNVK8Ucaa8gcc0jTClfwGF032McG3qTV3Fn9Ea8axY6RY6bC7m3xgyjuKDrEWzvAdoIR/oGFG9c+8fFUtqxlx3Rs6jrTkdKb75jEqbCgx4eKS50mJlSzhOUcFe7S2Y5rydVRKSktrL96rmcOJ6NFjWHmNnYWHqtH7gZ/TvJi4gIAxRcSO+03llyRlqW8D1h9crkB9P3wdOe2gaynrWiEA5G4fkHIHpIq8n03TmUMGjBZXn2XkC9WL80cZY98EC9J8AumiFIdLXph+Lcn9ZT6o2lNMh2ukN678wjMcXA/dEizSvPhgtCLFTlj+0nq1bu6EuRO1L0wLBj4qXX0LJWKDfNZiOUBTgde7QksewKe/vSj7otojU1loEzqkZG08/nNUoSM3fGNn8JDFphAg0FA7MB5QW/2DQLIwYJDxbnYo14HDL2SmubHQIAsKTuI+nTcM/Nd02sPh4UnqyWsSe1q52KmAdz2OKPWkLtiZI4VEv3DNm1SJnC7MuByJ0J8zaA7xIPFfeiNUWi2ZSBobPvduUWTdYXBmVxyRZuuJwQgt8P+2x82WtiZZqVdDlXdmoyOpkFBPxy1B70h/PWzIQ9DJiMRu1o89+Pm06pLPU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7241.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a84d632-e837-40f9-bb8d-08dc4a241204
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2024 03:56:36.0836
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /PUOoBaqHKYUiLTD+BB4p8sx5YrWIj0M/g0yEASBMvp4AKIGqqCu94xhbG8X5qNxmBoIvD5mA0d4UApd+Hnpfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR10MB5905
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-21_14,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2403210000
 definitions=main-2403220026
X-Proofpoint-ORIG-GUID: cloxHRWmkFVnMhj6ZvzdCUIN8SX3XE6j
X-Proofpoint-GUID: cloxHRWmkFVnMhj6ZvzdCUIN8SX3XE6j



> -----Original Message-----
> From: Darrick J. Wong <djwong@kernel.org>
> Sent: 21 March 2024 08:14 PM
> To: Srikanth C S <srikanth.c.s@oracle.com>
> Cc: linux-xfs@vger.kernel.org; cem@kernel.org; Rajesh
> Sivaramasubramaniom <rajesh.sivaramasubramaniom@oracle.com>
> Subject: [External] : Re: [PATCH RFC] xfs_repair: Dump both inode details=
 in
> Phase 6 duplicate file check
>=20
> On Thu, Mar 21, 2024 at 09:00:05AM +0000, Srikanth C S wrote:
> > The current check for duplicate names only dumps the inode number of
> > the parent directory and the inode number of the actual inode in questi=
on.
> > But, the inode number of original inode is not dumped. This patch
> > dumps the original inode too which can be helpful for diagnosis.
> >
> > xfs_repair output
> > Phase 6 - check inode connectivity...
> >         - traversing filesystem ...
> > entry "dup-name1" (ino 132) in dir 128 is a duplicate name, would junk
> > entry entry "dup-name1" (ino 133) in dir 128 is a duplicate name,
> > would junk entry
> >
> > After this change
> > Phase 6 - check inode connectivity...
> >         - traversing filesystem ...
> > entry "dup-name1" (ino 132) in dir 128 is a duplicate name (ino 131),
> > would junk entry entry "dup-name1" (ino 133) in dir 128 is a duplicate
> > name (ino 131), would junk entry
>=20
> I suggest massaging the wording here a bit:
>=20
> entry "dup-name1" (ino 132) in dir 128 already points to ino 131, would j=
unk
> entry
>=20
> Otherwise this seems reasonable.
>=20
> --D

Thanks, the wording change is better. Will send out the updated patch witho=
ut=20
the RFC in header.

--Srikanth

>=20
> >
> > The entry_junked() function takes in only 4 arguments. In order to
> > print the original inode number, modifying the function to take 5
> parameters.
> >
> > Signed-off-by: Srikanth C S <srikanth.c.s@oracle.com>
> > ---
> >  repair/phase6.c | 51
> > +++++++++++++++++++++++++++++--------------------
> >  1 file changed, 30 insertions(+), 21 deletions(-)
> >
> > diff --git a/repair/phase6.c b/repair/phase6.c index
> > 3870c5c9..7e17ed75 100644
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
> > +	_("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate
> name (ino %" PRIu64 "), "),
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
> > +_("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate na=
me
> (ino %" PRIu64 "), "),
> > +				fname, lino, ino, dup_inum);
> >  			next_sfep =3D shortform_dir2_junk(mp, sfp, sfep, lino,
> >  						&max_size, &i,
> &bytes_deleted,
> >  						ino_dirty);
> > --
> > 2.25.1
> >
> >
