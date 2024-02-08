Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1EB54BE1;
	Thu,  8 Feb 2024 23:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707434490; cv=fail; b=sqYxHrnsrkKh+ZW/X8qpV0/XebLX/A85ydFKrAOrKOx5Kmk2XFe/UGd+wHk2xMQjMhOE8Dm3r/Jqz2DV78SK+yJ3JVhwJWL+RAjybC9Dl0giC0cTsWyRmfwJxJo0N79NzRbpdXuX/r++df/5mGl7VhAKPKwZp77C5Qu4NwctpUU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707434490; c=relaxed/simple;
	bh=K7480zyIUvTFq857bESSFjmxbowxQgMdF28rXzi5DSs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NsM47zn9RPlZGlsYeEic8APOC0RN6Ns2dijQf50stMy444C0V/fmTk0hUFhE34FgiDbZQ2TMAXcYrqxKbTTKJBiUHSvZelQlUUon3g9SPa46C8tWjX16SCrPXYi4YpBvdHUk/6LTxvhZ1Fyds5bgM48/SzLlnJJmBjItoPZFhKE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bLwBQyNv; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=WoCrmYXp; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bLwBQyNv";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="WoCrmYXp"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 418LT1qk017576;
	Thu, 8 Feb 2024 23:21:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=GD1Vd7TAh7B5VOGpOjfpVM2ILQ+UgfdT57xjtYsJizQ=;
 b=bLwBQyNvwddGYYx6Lk8mvOuXBYf2vj0uoNZthclWsprqVg+jCodrk4GxuGdrdwstxx5Q
 UygNSkKsBoN6yVYlwfJMHWo9H9GcJgFt3sulS674GAO9boQ3LQBqnJaGGuXWSOnXLvv7
 Aye/nf1v5ogP8zArrPUoljEa32AUzZLETmWodNR3fE3c0yAHTLig/cWFv+K/+Oo/uJta
 ikTkF+E57M+hK9FvWgg6kBcdO+MXVOCarZBolam72FXUxVyM9b3uZpDUO4Yy5fIozy2A
 4Yhip2YpLJhAurTPxqhCYliPgjUMR3pmLZSeSJzFgBoLqYQKf7CopGAZknqvLquJTCyQ HA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w1c32x7dt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Feb 2024 23:21:28 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 418LO1I4039468;
	Thu, 8 Feb 2024 23:21:27 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3w1bxb4y3f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Feb 2024 23:21:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FnT5EcnttjFdJZLindc4oIpzQ4IWkURAHm+ksAh100GakMOWAHJuqplMoCZRCvVxeh8eUMOub9rUsRKMjecVUPmjO6EtZcCitkyReP8dX4DvwfE9CZ4b7e4jIAM1CZyEUhqD4scV9XyHKcaVXY50jkOm4EjQr8yVX93ZQ3w7CHPs6XaJV1TV/HnWCVNlf2V8liP7WSyBaxwyYDCPPYx95vq9dGrXvUjxcXpzO6ChByf//kYbBntBu9wEa27EDY5hSM0X/aX56Hrp0LpMzvgN7D/PaKQQvyCNveDx/tdqkf68xh27m63mXB92juLqlqDlNQCHBEyLCfObz2CPKcReUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GD1Vd7TAh7B5VOGpOjfpVM2ILQ+UgfdT57xjtYsJizQ=;
 b=c4lBs4sTMKUwhQTlpBEvlWf8HgsPryAeSNLxEuNNxGkuT1fMX+gyUaDBvqCtpKM3/YAQVUFPj0mfklQJmoxVItISJl4REswR2+hpTGQOlVAOVIMfKxZec5H5vbdJkGNRaQ/jGQjtAoOtoVsUssik0D1gao92XpCre5jvvGbFccHswp1A7gUQ3bjdOPs3aLx6/ZWdfFfZ4Wu0yTu5Q9JZUpBinKGk+L/OSfjcWxSAIsWcRxiJKc9zXZ6QYLfKF8mfAfHTP3ffuAr8RaH3ApcxCx1BQ3XsC/7x6CFLCytAIQocLHmsW62SRZeu7RQQl7y6onl4qfKqVTfBJu9iCCNlyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GD1Vd7TAh7B5VOGpOjfpVM2ILQ+UgfdT57xjtYsJizQ=;
 b=WoCrmYXp/Aq62VgwgRHySaDYAbp5MWqYA0Dl9yuYWMh3O/MalbZVBCTXXhVF2sHFeP2cszrvblrPlttsnz1E62X1DTPZc7HeidR4CISBYAs8Cqpl9KrO0NLd4e21jFtXB8UGb7wdyL5JmQ8prE4q6cHYifd3ers/0tT+CAZNf9U=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DM4PR10MB6014.namprd10.prod.outlook.com (2603:10b6:8:ad::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.37; Thu, 8 Feb
 2024 23:21:25 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::abec:4916:93a1:2f72]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::abec:4916:93a1:2f72%6]) with mapi id 15.20.7270.024; Thu, 8 Feb 2024
 23:21:25 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 14/21] xfs: up(ic_sema) if flushing data device fails
Date: Thu,  8 Feb 2024 15:20:47 -0800
Message-Id: <20240208232054.15778-15-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240208232054.15778-1-catherine.hoang@oracle.com>
References: <20240208232054.15778-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR04CA0035.namprd04.prod.outlook.com
 (2603:10b6:a03:40::48) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|DM4PR10MB6014:EE_
X-MS-Office365-Filtering-Correlation-Id: 6650b141-aedb-40c0-5e1b-08dc28fcab88
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	0NxfIg7xx5L5bT8BZJgUj/coWuhA98h7an/AxA2vRO+giSt0GP0mDF/ZJPApbHGXhsWHVEdDsVVV/y/LQueZFnufKGMRF8DO+DkPFZs1yoDKAUaywx39LSlgea/oz9kjFLI8t29T02etM/ABmUl0BDa+cplklEQ+LYdVpehU3jCkPXnZL3Wj/vUvKidIB01EfbbElxGC3LDlLEUwxsj5nwnnmGA1Xnea8we5mX2nTiDlQfiX6HgrPhUO2o3f3TXbRKZ2tpDpIVV7JLeaZNkOFauAoqCO8w4njlmkefprRO8h6qbJXTShl23IYNb5WOwPTuwRAAq2+cBhe+q7zqQZYKzD0qkn+07xUTOI1xGxmcA3gpBe2h+Bj3nSbe/yLM1pkO1jeQOcrb0FxmPfBbsq11dk2d1DDowNPfW35DZJNGBnSrNL3AEJyE2mwYO+f5xAxngYFFltKHAmYmVYxf+v2oJ90Lhj+g258AuizxhTBNYkO2B+ZS2vFqpm1nMebvM5gfeZXJITzRSiXWPqO9ee5ZhGBbxtdTPvg6iAX1B21csSjSBCdmNp4lqNFVNE20Xn
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(136003)(396003)(366004)(39860400002)(230273577357003)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(86362001)(38100700002)(41300700001)(83380400001)(2906002)(66946007)(2616005)(66476007)(66556008)(6916009)(316002)(6666004)(36756003)(8936002)(1076003)(44832011)(4326008)(8676002)(450100002)(478600001)(6486002)(6506007)(5660300002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?Vr8v24VAn8YxnM2uj6KHe1peJ9KHR/JfLH3wSRNG5PCscoYUEMW/o/b2MgLf?=
 =?us-ascii?Q?6um+6+pyoVnVtoxsm6A/AwUD1ZN79l7SyCJ7td3T161ATXka5EKhNVP8vwxs?=
 =?us-ascii?Q?21qXXRdWh1BZZip4uNtELbk5/Ji6lhRxdLUCWuxbhp5btynO8p1zp7mrJCE7?=
 =?us-ascii?Q?Fk+DmrvSHZlOukcHbxc2wWiGUlwpfri/LwoclOOaijdMruTv5ZHdWA8AfYzG?=
 =?us-ascii?Q?4tGnmo9bY3PVXe18Oc8ROWzbZ6hd/fobZ2anYbA9BLyWuM1YRFq3p+QveDPC?=
 =?us-ascii?Q?Naj79A4JcgKbk+44xjXbkGTke4IzH/Z5MmbBOtr4gIUGmLR9KIUs7HXtYUo5?=
 =?us-ascii?Q?lY8WCkNuDNkjH2Pcp2W1bOX1YGc5zoa8kRJtRRH9xh0OWmOaQOu3217UKcCB?=
 =?us-ascii?Q?xqkNDKuFnDLwCZOYvnv0ZhAXUjfPu3MWe/QszA2NPVf17pcEFhTubVJT0qXL?=
 =?us-ascii?Q?p09aaVtHn+sAndOowhmPkK/P1MrbQSzTD0+x0cRpQbJ32UoL1Ix83/lHlyee?=
 =?us-ascii?Q?oG3+Dxew61Ar4a2lTe9M/RtYl2aL4qbFiGomtxPeFUWWgqP7h5nPYTq40GbL?=
 =?us-ascii?Q?2sJqXqZEEjDewe1Ae7xubWfbeyI/67qSTWWVm/IpKgQQGPNSrBI2uu0wD/Xo?=
 =?us-ascii?Q?XPnjWWu1wzUmGwO6fcpqyLvIc6tUW220vH3c4oQ+fS9MEXxG7tf7tpwUgxBG?=
 =?us-ascii?Q?NV63SBdrFsC/CGaFTw/IguAmfO2d67k5iAgPCTUlEAJTIz3aX8bq8d9jIg9C?=
 =?us-ascii?Q?Wi1ArTLIICtUa/7s+m3syTLddbj/3tBAJtpkpWJZ6NU6hzpKj0IeyG4dxWpe?=
 =?us-ascii?Q?vetPdiq7Reahd3aetoAoN6KxteJes8ugQNGa+lLsJ+b9ffj5vhb2HU9cykmW?=
 =?us-ascii?Q?yX+nA1ouLiAylw0MRXQnvtqOeKTDzFnUUYYJnvFEFBLfzx9c0sSla1E8kXmf?=
 =?us-ascii?Q?gARYa1WD/QteciW0sbtm0IQ+uA/bhXRw1dGZN6fl82oM1jjCRwtwCMyiOafy?=
 =?us-ascii?Q?FdGNl/ZRtBzcKyTnpD9rffPXkRPWiXT3Jeu8405+pj0e8Tzpow1BHj1Z8hDp?=
 =?us-ascii?Q?0+3419ZJ/ssrpDpzqDPuB6HEYgquN6PiKQebnWkBPoKKgoEPCmUZwdFojoxR?=
 =?us-ascii?Q?ZPuHivE4UsYwhboyrDO+WWo6Jh43up3qpntT4X2vE1uGV04d2pA7hbUxdbP3?=
 =?us-ascii?Q?enDYAsB3+XKSdu9PpRdAzq+77tuoga+m370+0qfPLiAT7vT7ubbe3I5Ickdk?=
 =?us-ascii?Q?aQK21cxyG7GrSB6nLtZCYlRSrbjX0t1ifze8y9XvZF72aAtGskiLuaE6STSp?=
 =?us-ascii?Q?2NsNzMsSCSZ1pqezNESX+Y6GXh+lbkwnSWJ/U+sQm6cWbtIAbJvCbrzkX0Fl?=
 =?us-ascii?Q?tfmpFK7G5uDJ/zTON+wszqGXJkNTNyrOkE52w1QYm2smBu5WaXbvAK8+qifz?=
 =?us-ascii?Q?6t+GTgBI9GGRD/aR8Z85nte+xop2iu4g2GVKJLr7ycnOG1eC4HdZMPYBwInn?=
 =?us-ascii?Q?cx0cp2aD5wzLMB+1SCQecG44btqV6Yuhz7ZOwIHPwZDem6NiXAf/Owsh2sVH?=
 =?us-ascii?Q?ZRbsm38X3ubRVkl+hLfmWjkk8gfVG5eP7Zrl0rBmXGLtrce4+mNWWUl9bKWm?=
 =?us-ascii?Q?rxrZPeOE+ymbM0I8KmVmvvyfL+bmn3e1nlfWwGuWI75Q6SbTNk0LZiedo97Z?=
 =?us-ascii?Q?PH6f3A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	UhHtqrsjldFkmrtJugt9w8EarZB9e3SvRkN/TWFwMJbL77ulutDjvqTCKprnxmZKvm/8Jf8ttrKiUFZgBx8YTI3fsyz/fnBGpUSdfVolonHmTN1i0chBAo4urUX+Lqr5WfeNNuNzH1hp+3hHWprApQohPZYsy2jpQwDx91385kfqWZlQJtwdpeapkwuZh25YU7LjNRvgfryrX2rvrvhbaqZ8SuR7yQk60kTKuO8tjQ/7f0qFN2Dh4ahWAemm0IKiEWCEheC6EDO5PPJH2MnEETW1QWjY6ApNQ1oC9K+DD+Xy8k0akfegpI3esaqdnjUThygLRsyutpF47WjYmYJxyTYQYUgOavxsU/wbQZPSYIOLKzsHki6Ikic2olEfmGTjQlIZ4YqlqrgBKbcirVH3XClZbdJKF5Sht+Ypx4XRrP1/FrxulGWd8ama57OMkPDoWZcdZo/0Z2p9WJqsd/yYvFV3z4a3xjc+Eqo8C6WqSrZkDQny5bfJz3S7f/NdG1ClsxI8FwegCgzOERFJHllZrFufeqs/8hRTczrEjYkGs97R8tl+7jGX72X53v1yTcrgurMOAeaZXl3dU42m/0O2BFnoEBP7ZPJWNchge8XDPFo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6650b141-aedb-40c0-5e1b-08dc28fcab88
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2024 23:21:25.5874
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PzF8SYmBRbkvB1KAl6oHNZcKhILu/Mdo0J+gM7GhxOCl0g9cYIW3Tt//xDK1V2K5kdM15HnFYq7/wR4pC7/xzJwonQ5rI27PWpri6ubeCqI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6014
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-08_11,2024-02-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 phishscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402080132
X-Proofpoint-GUID: KV_5oQWgpyQOZWvFmqxgis_1Ncr2Y-JI
X-Proofpoint-ORIG-GUID: KV_5oQWgpyQOZWvFmqxgis_1Ncr2Y-JI

From: Leah Rumancik <leah.rumancik@gmail.com>

commit 471de20303dda0b67981e06d59cc6c4a83fd2a3c upstream.

We flush the data device cache before we issue external log IO. If
the flush fails, we shut down the log immediately and return. However,
the iclog->ic_sema is left in a decremented state so let's add an up().
Prior to this patch, xfs/438 would fail consistently when running with
an external log device:

sync
  -> xfs_log_force
  -> xlog_write_iclog
      -> down(&iclog->ic_sema)
      -> blkdev_issue_flush (fail causes us to intiate shutdown)
          -> xlog_force_shutdown
          -> return

unmount
  -> xfs_log_umount
      -> xlog_wait_iclog_completion
          -> down(&iclog->ic_sema) --------> HANG

There is a second early return / shutdown. Make sure the up() happens
for it as well. Also make sure we cleanup the iclog state,
xlog_state_done_syncing, before dropping the iclog lock.

Fixes: b5d721eaae47 ("xfs: external logs need to flush data device")
Fixes: 842a42d126b4 ("xfs: shutdown on failure to add page to log bio")
Fixes: 7d839e325af2 ("xfs: check return codes when flushing block devices")
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
---
 fs/xfs/xfs_log.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 51c100c86177..ee206facf0dc 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1893,9 +1893,7 @@ xlog_write_iclog(
 		 * the buffer manually, the code needs to be kept in sync
 		 * with the I/O completion path.
 		 */
-		xlog_state_done_syncing(iclog);
-		up(&iclog->ic_sema);
-		return;
+		goto sync;
 	}
 
 	/*
@@ -1925,20 +1923,17 @@ xlog_write_iclog(
 		 * avoid shutdown re-entering this path and erroring out again.
 		 */
 		if (log->l_targ != log->l_mp->m_ddev_targp &&
-		    blkdev_issue_flush(log->l_mp->m_ddev_targp->bt_bdev)) {
-			xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
-			return;
-		}
+		    blkdev_issue_flush(log->l_mp->m_ddev_targp->bt_bdev))
+			goto shutdown;
 	}
 	if (iclog->ic_flags & XLOG_ICL_NEED_FUA)
 		iclog->ic_bio.bi_opf |= REQ_FUA;
 
 	iclog->ic_flags &= ~(XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FUA);
 
-	if (xlog_map_iclog_data(&iclog->ic_bio, iclog->ic_data, count)) {
-		xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
-		return;
-	}
+	if (xlog_map_iclog_data(&iclog->ic_bio, iclog->ic_data, count))
+		goto shutdown;
+
 	if (is_vmalloc_addr(iclog->ic_data))
 		flush_kernel_vmap_range(iclog->ic_data, count);
 
@@ -1959,6 +1954,12 @@ xlog_write_iclog(
 	}
 
 	submit_bio(&iclog->ic_bio);
+	return;
+shutdown:
+	xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
+sync:
+	xlog_state_done_syncing(iclog);
+	up(&iclog->ic_sema);
 }
 
 /*
-- 
2.39.3

