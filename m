Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAE33D2FB;
	Mon, 16 Jun 2025 21:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750110745; cv=fail; b=Imop993X/72b0be9mOqWVEmFbun2QpnotBtKt4nON8CeI3dDHGEAuTFdMwVjzjPdz4812+lo7E5IxT6WRX6+c6sIxrRqtomR3QY0D3/FeAdrGBzJsa93V5kvl/P44ISaIVmcnl+THYOTH4NJiDFxvWfEJD4T+olJFxld5oM0a2A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750110745; c=relaxed/simple;
	bh=yLz5A0B1Ge94/iVVvmjJwMj+hOocsOCRKivyUpr2TDw=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=q7ImB9D4calNZRDuWfl2EHrNfblX/ND/6xbkudDYOJGg8rzfqawSbtGxtEKMnk5bVLKAW4LmJuGpZTyNP9ZrEl3yCCUbL2Wc0/Tb65Ovb0sIux8yX1i8H+l5ndRQtIpdxVH72DTMKekEKu0MdDPam3yutMlxzclN/9nOX+pCdVw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=E2pNPQgM; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=M5cVKYcZ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="E2pNPQgM";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="M5cVKYcZ"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55GHuUYj017647;
	Mon, 16 Jun 2025 21:52:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=l/LzAhxZ91WSb4zg
	JYp9ntELCpMmVzeJnbQNTy7jAKY=; b=E2pNPQgMJwAKT549Ao8KBAo9i3ZTukeU
	7Gpg2iw33ytdtXC6halfv2mPYGkEhVOkbR4xXqW+6yzHRd9HcR6IGCjDpXwPbGNs
	TqDCuSBR4KgxS+7+QJNleCDQxdUertbO+wO9FqM4iwmzXkebiwRcyBUyfJWseEBe
	bnbRIeMYPJflZfFSodgSqOMH5UxrA5OJJ1blePGPeVXPqUWfDRb7w/wDez2FLuwQ
	7SNsCsn7I6a1tQjDVZ0EbX+Ue1eWLR+m8jLuCXGOTeGlWHxX3Jk+Gw/SCKxGoLuC
	8M7eMTu6yLffHAi5ZiFbHNk2ab7PcodCIL7oXyzXBtfxguT/rwq45g==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 478yp4m4ef-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Jun 2025 21:52:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55GLTE0L031109;
	Mon, 16 Jun 2025 21:52:18 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2087.outbound.protection.outlook.com [40.107.243.87])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 478yh8fqd4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Jun 2025 21:52:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b8HYnOUV0s7jBToxBmoT2v6KIhIK5rchINtiK1ncxgt7zVJnl7DLJp5JCHMdir9/tUpeBM4bpiy0B+wFcMPHshe+G0MNj3knb2VdpmEU+3+MX2nzQDZS79tGVqcrrT/HGbFboR1HVNGJOLon2LqiGjrf1/OJrRloQRcEtY9UWwRYVU9ZsWMcL++T7nrwAQaFKfGFAic7JVaONKwvfv0iHLmlL0WiXTYKt1q/eVpc434Zjg/3XmNM+BEhg9v9akiz5mCdZWWEOptkoV5Jl81H569ONnFqPZZKNE89dfXu+PKamzOGD2a5QrT7cBagWz+kOPTmi4/yGe0KC7GXdMZNqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l/LzAhxZ91WSb4zgJYp9ntELCpMmVzeJnbQNTy7jAKY=;
 b=xf614p/b6cGWoTJYARHXTV+dZhHjRdXKkiVNAwbKf5DMIhpXrGRYC/u7GnVbDLX5M5l1+YvrvWprDuzHcyPaCKDbpM/C3EEB9O3Td5GeEIwlTHEkw0tilZZccY6LFeVC1o4kSZ1IrvL9XnaQLfctLzns+StZ0llXyTmmsBKTwW0ugt5uFNksufPIEDBzEi1xEzC55gKgZepxXakhDg6Z3+39rwUF6teTsk1qB6Z9DPDm5F3CHL2Xl9dB4P9bJmA1hIzlV0DXdbptAM+gcM9gsdbooXvesEEVlDjLq3mlXHO8pJEOR5SU+rq4DwssexyMwjgIYAkltmOcfoJrbpSybA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l/LzAhxZ91WSb4zgJYp9ntELCpMmVzeJnbQNTy7jAKY=;
 b=M5cVKYcZazF676pU9DNWKwkc0pqpMZl+Ujfm+kdDBwqnmK/kHuJlamJF8WLdgxj+2EV23/U+3rSgOiOdgbjMpBBUzFfq/5fP1IeqKDZxok0kaKKI5MwbA929qee+1ztfknABb5F0y2R2l+5O9XrfXb4Ld89ZfND9U75wA8rhLhw=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH3PPF55F79EE4E.namprd10.prod.outlook.com (2603:10b6:518:1::7a3) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.25; Mon, 16 Jun
 2025 21:52:15 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%7]) with mapi id 15.20.8835.027; Mon, 16 Jun 2025
 21:52:15 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc: djwong@kernel.org, john.g.garry@oracle.com, ritesh.list@gmail.com,
        ojaswin@linux.ibm.com
Subject: [PATCH v5 0/3] atomic writes tests (part 2)
Date: Mon, 16 Jun 2025 14:52:10 -0700
Message-Id: <20250616215213.36260-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0296.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::31) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|PH3PPF55F79EE4E:EE_
X-MS-Office365-Filtering-Correlation-Id: 3cd5282b-f839-4444-9506-08ddad200eb3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|10070799003|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?A8Ai+/ycwrUTrUbUbRgQZLut2B38yI2ALRa/vvYaT/rtmc21sfKMerfLqbfK?=
 =?us-ascii?Q?lkS1oQsT7lf+LisTXQ2UwCa200B6gTzfRgUNugSBJKIoJmE2VE4AT1mQkWVj?=
 =?us-ascii?Q?AVKmS4xpL5PxRgUhWhEGUcfM95RDOc0Wu5VxbWKwA++0CNgHHoClLOwj12YG?=
 =?us-ascii?Q?CDwD/GhLI54CNwUhiZYCNXWwpVDOKgojX50WxfwBl3U8Un57tjzh2Dl4AcrU?=
 =?us-ascii?Q?fYRqP2rciSj+34/X0eDEqUY4t4PB1+uq1MxbnFNDJZ1RjMhczgjQybrHeQnk?=
 =?us-ascii?Q?pP7xh1HU+8CnP+Uck/XjY7O3b9k+NQbhsga3xCthh8fr6VE+j4fKQVaJnjJX?=
 =?us-ascii?Q?3F18jr01he8B3ae9vToZwLEyLShslMdq8Rlmur8k25Jo2+VeXJc/AF/CHRFj?=
 =?us-ascii?Q?mdXX/q86bJeUPMvKK2+JQ5PCNV/PVx7QwQYIMNYqq/UBxV5+9+c8SyjYpcCc?=
 =?us-ascii?Q?8uUGf/QTbVI0Uu0nVHhwuBBJRRKZ0/87InajW9gBFmOlw/EhELwytFBF66r4?=
 =?us-ascii?Q?FBw9pvbPh8nyHtA3bh7J121tYAXV4yGfMgDD0P31jUZfO0QkMzJaFMG9D89a?=
 =?us-ascii?Q?NGWiaI7m243im84lFoK5/m7iDNmTx6b/wt9eU0haFbN+25oh0M7n6/hXDQb1?=
 =?us-ascii?Q?9ZsE5Bz3OCEE9pJGVGY/0NEzaR/MUeJREcA+il3bqYIeL08QXOT6LsSVXWCN?=
 =?us-ascii?Q?+nffl87bA1kDvjYwlFg/loyfIpn2E/USrSLgf+3Rcg/WsnW0pcO+fw/kCT3C?=
 =?us-ascii?Q?SnSHoKofA0bkgLINuvcVoVZbXeA6HkXsMHHDubYUZ6YAVwSg44mgmltLtqe9?=
 =?us-ascii?Q?9Zwnx3TaEdXQ9N6NEGS3RJarl5CjiMtQxXC2kb0VAy8VBTTMQstve4elGmqH?=
 =?us-ascii?Q?rkPK5m5JTJNPZWA1/pvJZtgoVMFGMbnBzmjnO23xUeDi6V+rfOVvFtyeR1p3?=
 =?us-ascii?Q?JCu8VwiyEgXVXnEnoe4bybnPMWbEkttXSkwWJvB4Xxgrv+ezUNAeF8vh+IZA?=
 =?us-ascii?Q?TQ8R6mI+nHOVL2zIYNI+GJ6rDVNbAAeLiKlO0pp9nrbU6cB9Nm3vtXmy4BFd?=
 =?us-ascii?Q?AQSPASaxW/UjbKHMZUwsKkZrrecuojK+igmZWHmpi4oaMv8pSDau+rtblyeX?=
 =?us-ascii?Q?fKcPeUkFyhgVDZ4TV1XwGB8IFtoESwfs33aZfpNGZ3udfLEhsDrN8AlyJSpo?=
 =?us-ascii?Q?BFnMWqgW4hICxae53YLnSngNXIumFsDgvl6xavEacuMJ7g6vMSS6KZk7w14r?=
 =?us-ascii?Q?677KL1aOzoKYzKbpsgEYUWx2i6QCytcmLPfYlWhZ6j++PGMSo4crPMPezFtx?=
 =?us-ascii?Q?x/V/lOD22OfH3KC2TD1LoQv/uMsjrPDtPHdOaIhlJ5KWOrJZZzehYZOrEZCs?=
 =?us-ascii?Q?zP+kn+jVRbz8ci94isNvSbdajUzrM9111zWAleObxNU4/F9SgAYkWY5S7iaF?=
 =?us-ascii?Q?o0EXDUYMy7o=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?X4aX0hUhlFM08P+0+iu2G502NibEal6GiRMgxXSyjxH7/QEUZFtC05HwPxML?=
 =?us-ascii?Q?ulCWnAJqk2yui2BUKMnkY8GVhArCJdM1OORTGU3Jo2OVnufS/Qt/NV1eLwsQ?=
 =?us-ascii?Q?FywOmHCJZ2Kn3WLGZS2LaUxA0x7yDG/jvxYuOBtMB1vfseF0bzYKzuYqr7+q?=
 =?us-ascii?Q?vuqCNPctsptA11ARtM8z16YgG6aeULyv2jnRx4wmaH/abLGoFyBE550oULO2?=
 =?us-ascii?Q?XcZ3bSVXBWxureVnBavqhuEDbqLcryErMF0Xh0oj4nr7BskCpeQLCaPaP3iv?=
 =?us-ascii?Q?5pIoV5H1azI3Jdg2v4ykbKsgE/HRrDO6P2yemXiWRXQJ0fxAq+sO6rCcEvRN?=
 =?us-ascii?Q?qpY3BRJ3cPz3BtBR5hhomj7z1OS8TUAkINnmcG9hGEYt7hqpOWexDgACimbT?=
 =?us-ascii?Q?JxqsSZc8g5J8SrsOCmuXbsvGhn9JqzMVZEDD7DQrhV35yb7hFuCSsaWYjyJI?=
 =?us-ascii?Q?/QEw01z0qIfuxU4szhq69a+2VvVDm4Bl4YZASzYu5oSYZ3L5DZYwCwv7Hyir?=
 =?us-ascii?Q?Yzq8vrtVnpvYWtVMgVss91MO8H1G5oGKU9QL7Ws19DqMRI8no3zHfqraZOLe?=
 =?us-ascii?Q?ZxzjpnWVydxXob4X/kJiUZKVt8eN9kTf2lFSGnsrV8j2iarKLsi/aMhGJo02?=
 =?us-ascii?Q?yApRsw0xU2khN1FB+tVLPiHkVIn0fM51wZ+6vdT1+V0EeDlU3RfkcYG0xpMb?=
 =?us-ascii?Q?1uVmtJCUoEPhDGVZpkHeONPNRLZiIdixMfZpKAMxVXQm77S8zeXyW7uA2+7G?=
 =?us-ascii?Q?rLqlBGZJMwu4cQGEMOb9IifJy2S+Eq5FayNf1/MioWHAWmlji/YTCl0jAqug?=
 =?us-ascii?Q?YdUU39MOeo/NRo+ElWRDM6urSdVClvgYVkMouajSO9B1PUqooMTXFwAYpZy5?=
 =?us-ascii?Q?BjFldlcVx0rmvl/ZksVO6jQ4xsnBnIOyElK5AGPCwVt1nrD3YBo4F9z4E6BX?=
 =?us-ascii?Q?Ztm+rxgrFPehiEmNHStLX6SGM9MNaYjmO6FJwmpojSiOHr70TdYx76tF8nxv?=
 =?us-ascii?Q?D1C+XEnI9kepIfJdQZbaEsSuXP89RrwYC1KStSjUUo3FY8ElSCimH+y3K8gV?=
 =?us-ascii?Q?sQwRmQoNxAKVhJZUQbX/ZJIiUes5PFnPfJXRIu07Tyd4IbeF7du+zZIFYLNC?=
 =?us-ascii?Q?MZcB/Ts5c4AsIhCm/CcatMcc2CILumPU8D/dVU0IPVDIlC5gseehj9dRmDif?=
 =?us-ascii?Q?vlEr1I8FpdtH2yhZzEJwcECffdesepMliN3aKY2sb4gAHrBc54A3CJJ7z2oY?=
 =?us-ascii?Q?tiROR7HMFMbCUkLgfwRRmZwVR6p0d67XTUC+TW02UYoujrdHgK/vmwUdRNaw?=
 =?us-ascii?Q?wlC2Xq9/QwAF+aD6yXXAMtugBqD3dj9edD8TdqAGHFojxuRlq25Rn6aie6GG?=
 =?us-ascii?Q?mJsw6n47GTBwCLZYUyKOOQbZicVycU2RMAucdQbjpHpcxdlVITINyKnkmenm?=
 =?us-ascii?Q?w5WPenfPttrkqKD+YAaItLbfTJOt647MIyNb8hFaDBw6u077LQwmOkNd2lUs?=
 =?us-ascii?Q?mp6SxB6googL6oGWh2LQWC/k5Yn0G6KaAE6Es2PXNLpi8g/cdTLIFPzmaiTJ?=
 =?us-ascii?Q?2PNWeX9Bsm49hqqbS3ER/5o5dGCgGZPnncORfpUWKgVngS2MDRq58PLQZ6u1?=
 =?us-ascii?Q?Y0dWARXSHtP3/yyKnHLJ2i+mkceWpZIGZ4lWz7CfknCWk/7a6GyoKyU5TYFG?=
 =?us-ascii?Q?rnOPnQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1hyaUH33eg391z7ZgmD2fWswh6mDBJ2uqhvWg6p2ISe19sGbWC8oOrgs1N2yQYesXhVmH3xXGaTNy6AXtRdjXCsyfGpJj+aphnOJomZYL7N9+Mnf1IVgxerxP39HGtAjrLKWNsAxeC33ezSiJv/68VllqU+LMfdeDr2R8V+7BGBF6V14mpAdHLIFvMEqQGeBKe/a4rXoeZZfBRPA4iryaCgUuwx0HVzMu1svTDeNO6FsYLIdyLdzMnZD6aj5j69QXW9Kr2zF+OwAKvZnfginL6Gjierzk/BbpZMOCml+LQ01umq3uD1fzTIljgxJX7ohrOQbA07YyaxI5rmhVOuEMj+9EO4iF2z9j5QqcZEl4nlJxoP21spWZ65w4XIHwzEGXydhlImaUew9zsvsxTqpOp9i32ntuq6a4japQb7/6sLZ7uewu4pV3dYs2eOysZavucNVaLNoCQkGORH+DI3sO4EEZNbgiAlmzOlcK2o3zIfsU+VPkeS951iuwBeGkliTiqqsgpcrAXEm6qepmt+kCd0LFK1SfSfGCtdJlaYo5yhVNoeBv25hYXdajVPOH4R2W6vaeKXdFGH1Qcf7RkQTHfdD2OTwiFnemGHQBCMSGSg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cd5282b-f839-4444-9506-08ddad200eb3
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2025 21:52:15.6412
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F2d2bpBCo952gGx2FVQa79leRb4XozYp1L92xam46YwnmcQtF9qVGTc28ydgm5avrH3IXj7au+V7PCgSCB39uz6HkoLgdTCN9DDNMtR2dr0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF55F79EE4E
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-16_10,2025-06-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=937 mlxscore=0
 spamscore=0 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506160154
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE2MDE1NCBTYWx0ZWRfX5wSakvBWA6cA qF+1AXi/JUuRRwZ4P0AY6ErX98AM1eyKItzbrRKcjiM8rDk1RKNBL9Za2hIE4EGojMZNMxRmJhk AbQhjxVgZ7YEBBwJf2s9DsklTyfJq3LWkVjfmj2rYYgDrvoTO44rZ9BUfJKZzAeJ63H52jE56/w
 JhEeROWAWerz+v+B6AhEt/CnVrg++Yhp+VQpvg7210LN0Imoh3k4mYKlM45kiNkaPmIPxN3Lrh7 LCS+Ddr+8mzx2+aSf+Qbj7Q8XBx/8NebtWMXTRnuCeeZ6tKJDxiQOPLqzUxWaXJZXjAohAFltIv NMPVG0BVp3IbPehw0CPqU8Q9Nbd2kRGMcmcjz89gbMWhEfb7sLLpY0DdBn9U7QtUcC84j6J/eRa
 5far73PjyvTtMDgRy4/cq7bD2ochrORCXFJej1AtmGrmLsYqw9FnSFwq6AQc3CQoS8JzubV3
X-Authority-Analysis: v=2.4 cv=K5EiHzWI c=1 sm=1 tr=0 ts=68509213 b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=FbqQLDlPobig9FxYbcgA:9
X-Proofpoint-GUID: j0LRgxVzKrw6S3NPwsfE_t__BVBDnmLf
X-Proofpoint-ORIG-GUID: j0LRgxVzKrw6S3NPwsfE_t__BVBDnmLf

Hi all,

This series contains the tests from patch 6 of the previous atomic writes test series.
https://lore.kernel.org/linux-xfs/20250520013400.36830-1-catherine.hoang@oracle.com/

v5 includes minor updates to generic tests and picking up rvb tags. 
This series is based on for-next at the time of sending.

Catherine Hoang (1):
  common/atomicwrites: add helper for multi block atomic writes

Darrick J. Wong (2):
  generic: various atomic write tests with hardware and scsi_debug
  xfs: more multi-block atomic writes tests

 common/atomicwrites    |  31 ++++++++++
 tests/generic/1222     |  88 ++++++++++++++++++++++++++++
 tests/generic/1222.out |  10 ++++
 tests/generic/1223     |  66 +++++++++++++++++++++
 tests/generic/1223.out |   9 +++
 tests/generic/1224     |  86 ++++++++++++++++++++++++++++
 tests/generic/1224.out |  16 ++++++
 tests/generic/1225     | 127 +++++++++++++++++++++++++++++++++++++++++
 tests/generic/1225.out |  21 +++++++
 tests/xfs/1216         |  68 ++++++++++++++++++++++
 tests/xfs/1216.out     |   9 +++
 tests/xfs/1217         |  71 +++++++++++++++++++++++
 tests/xfs/1217.out     |   3 +
 tests/xfs/1218         |  60 +++++++++++++++++++
 tests/xfs/1218.out     |  15 +++++
 15 files changed, 680 insertions(+)
 create mode 100755 tests/generic/1222
 create mode 100644 tests/generic/1222.out
 create mode 100755 tests/generic/1223
 create mode 100644 tests/generic/1223.out
 create mode 100755 tests/generic/1224
 create mode 100644 tests/generic/1224.out
 create mode 100755 tests/generic/1225
 create mode 100644 tests/generic/1225.out
 create mode 100755 tests/xfs/1216
 create mode 100644 tests/xfs/1216.out
 create mode 100755 tests/xfs/1217
 create mode 100644 tests/xfs/1217.out
 create mode 100755 tests/xfs/1218
 create mode 100644 tests/xfs/1218.out

-- 
2.34.1

