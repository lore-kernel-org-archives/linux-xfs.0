Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84CEB409129;
	Tue, 13 Oct 2026 09:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791884325; cv=fail; b=BzJN0MjPSFIxXM7czeOgzjcktqSUcOSfEW+XQzSlQtMFK7LLIjBkLjqp3rBDM5osNwvyRGeE3HpErC1EluQUoEdqetUg8bnC94psxmSo8m0EjXyMVkxv/6c1X/Mu5xeABZudKxL4d9M7sHXAF1sXxely4iKMArtEcTKblIjjohE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791884325; c=relaxed/simple;
	bh=ovNzdCLyjOI1vKAxD3SR+VqG7tmjFzWY+NOQirvDrIc=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=KzOmykFh3hrgBhQ3bbeozRRxd6Ma9AX/CvqCNEo1w9/QFMRlPEVPj1y4LWiryAWagARDr0elBOwK3OFFWH2DIMAQATnhmFomytIiMWFyDqnlzaXgEqXd6pNueJXKwrSSWVR9/igtE9ynD8EvMjKg9bh8TkY1WKu90PShm8KzpHg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=B7lomPzf; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=JWY9PP7/; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="B7lomPzf";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="JWY9PP7/"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2D5bI3033679;
	Tue, 13 Oct 2026 09:38:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=QjqlkrmMmRNc8LN6
	P639Qn8Fzpn6V3eBuO/XqkA3bBg=; b=B7lomPzfF2nwnkIwZTox7Mi2OgHCKMIo
	jW6NXS7pfXzmZbxCzcUHdmGB9Z76mWE//AXKOpjdlzKOpIjUslJXgR6xLm1pTWhG
	RaAV+xwt427Xm9/hfPg8ER6Onlzm+t8JzJT0AlCLRQQIqwodJ2UbLDNuqVweO3j5
	/+p5+XM0XokVrMFAwachIoS7BzsKIsM/QSv/2DaMKPJMrkxWvQNTjY/bGMYGYfgM
	K3ZFW/GRAVOH7U1N6nCL6HomwdaA9v9+hb9KhEvavf5QuJxtuowUfy8d7JXwMF9R
	uKgrB/BJoBx/lm2FYw05NtBlPZx1SgayXK7uC3WjKOncA89G6/IpDw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7dwtbpa1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 09:38:41 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D9aWIL011124;
	Tue, 13 Oct 2026 09:38:40 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012067.outbound.protection.outlook.com [52.101.48.67])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7bt9d432-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 09:38:40 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JUQOa7boI9Z8dY+4B3Fk/4tJkZfHuiSC450ggtQ1pFBSnn99YZBtTFcepJdn+1hdC7UJtqpLh0J43U/OZVPApaGEtQ7E8eeaNSMffk3ayESOT5KWK+amgDKJsl8Zs81UNxtx9pWI8a4I6+1RWudfVUP1QJ3Dk6UN/eped3nDTRNZM8Bn0UMzmPUbxNiYDHNdYd1J06A7Vl9TR7R0A8BHbxcxSKuS94ww6ovjSqWIQ+45QFjyPMgk8qTuIBzwkgDFAbLK/yb++pbBIIIF5FUDhibHJtjqJLeOrYUpUZJs96nA9En699OsZANhGm5vbQ7o7lLZ9bMXbCimB7r4KL2/wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QjqlkrmMmRNc8LN6P639Qn8Fzpn6V3eBuO/XqkA3bBg=;
 b=cUAQvZnwDOK9USK5JToegAZXK3yyQplGTZiYB4jbDeHSIdFxWmbxnuMpFJiRUC5SAY5TLz0CtSQKDEoEhMKz7xtTpmFB6kjPkwPTb0wKPZmN951tOHyi9rx6eNFBP0SY1CIH6Yzdy2tKIMCVgwKekFDSZhOMc6uExpBWtziYgKdMRBtbBGD2RLtqKYKvGJ6gFCfw5hqtPTg4sJhS607/zCH2NbhDKDA75rm8OfIFzvMlYm+u4fKp9fa60/hGH8lhSfTV4tZ4wYnV+LvLbHtQzEfBsXjTeCLGbFo+URQf+AF7Ovpbpl+JQfUU0CTQ9dnjDnwwp3OAGtyOa0Wn5TIklg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QjqlkrmMmRNc8LN6P639Qn8Fzpn6V3eBuO/XqkA3bBg=;
 b=JWY9PP7/VfSwXrUcpb0lIjgPtHju4QfA/2VsZlbZHdpGvIBaRX7EsdL1i8PY+Su3JeZokzfDSouAQhS9kstYmkjvsXaUSbWbVncztqJxDMbQZVx47O0hM3Kah7UUayDchCSg38JONvLEYW1bxyXkuJTrC/87wtSwYhTLcAdOyIc=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 DS4PR10MB075839.namprd10.prod.outlook.com (2603:10b6:8:3ec::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Tue, 13 Oct
 2026 09:38:36 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 09:38:36 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>,
        Mark Tinguely <mark.tinguely@oracle.com>
Subject: [PATCH RESEND 6.1 v2 0/5] Backport of XFS umount hang fixes
Date: Tue, 13 Oct 2026 15:08:27 +0530
Message-ID: <cover.1791883290.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0011.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::6) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|DS4PR10MB075839:EE_
X-MS-Office365-Filtering-Correlation-Id: bdf0e34d-dd78-4bfa-934c-08df290dc12c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|23010399003|376014|366016|10067099003|261009223027099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	EHviu6rRJqkKC4Oy6mMqgCL9hvx967FD4TfTQ8mGRPogJIaSp9zGTYcJivu2J1XwmIpQcsESRTafIKtc3oLr+jai/8l6+PBgHfsoPoKh8ZNw/Zz/CpKZXoKDzZFH/XXf+q2mbVy75drDyr4vM2mmklorHxuZbJD5xUhAO/3ZUwnusHDpw9QGg8tnelRe2AyTLtCXIhmJMdjFpj/QjkTxQIuNALA641ac5xPxpRxIsqxSaoEJG15KF/eamZRCqKbr5nBXrETRhyTqtMnODcfMtutvVl1sYKPTfpUYXqcGpFcIbi8GS7JBP4zpxDeiNUZ3oiOJeBVNPvVA0KwpbJYgP8tmDyn+nEm/Cn5104pdGr7xlfePkZYmqWY6PyhypXCCZEdCLA9BC8UFq4jWsMkACKw9vOeT0nd1N4iNM7Zr6w+tA09vAHKQYCC3SaGx+iQOzBNQpkAvisa4yRNAEpY2bdxadNpzG3jSe1xVItqFQ0q5i5y629VQg9Zh9WdSX5CamxyeGLPuxdL167VDfTgisf5ZmnYNqGsVnwBXstXjlLuy3PMaUbY4LvXUJ/fg42Bk0lbTVOqqbYrYBeRrtFAY/FTAu85pgxGs/OVaHRPoZ7gCYJQxMDxZR6UtGFNXh077
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(23010399003)(376014)(366016)(10067099003)(261009223027099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?abYKgnMs9+Xp7LzthRj2uSc4v6jx95Tatjkof06qpCgjmE9d8S6D2OdlYZcB?=
 =?us-ascii?Q?guZo3hFJiuz+6hERdPDmxH+GlnXd4sSdIGzzGVGVArXe2d5RzNNmvSqHeYLS?=
 =?us-ascii?Q?FTDPzbHbnP1ilU9k8e+B8CC2BbFdPMY7lB6tEqWnETa19g4Fv2CRzTAkUJuX?=
 =?us-ascii?Q?mCpUuHIymuSRfx8FciCCmRH+ncOqRMadwNx0UwIbFZ8UnqoCdOsvkvq3bLIB?=
 =?us-ascii?Q?Nd5BwF8VJ9PeZDiLoWh3gTNWYGkYwWuCWv1eEkr6VX1F5MRqZ5/nS7JymNZd?=
 =?us-ascii?Q?sWClUTNmfHfLQRkChUPSaQGud8Pne0no7hRrEhYAFzefZjwRfmmmk4eHJJx5?=
 =?us-ascii?Q?nyRIm7kUrc8Cdurd2r8KsUjMELXmUg0jn9U5BEXb7Q3TRy7Qo0R87obKK0zE?=
 =?us-ascii?Q?sxyNToPMWtiipygi7vpWkESQAMZRUmLUIIOpgM3CV33GcaRrrk0dAU6VCfby?=
 =?us-ascii?Q?rPGZ/2sYvqOgwzN6C6bOO+L8mOwdIBqh5Wk5LF0wz7MwWpPdg+oStDHo3FA7?=
 =?us-ascii?Q?cMJrencNNNvixxUhxcNwVGPhpKICrf6Es1YXp0oA1U6R2hgYib8DrNcBy+LC?=
 =?us-ascii?Q?AnyybNafHBpPCJ+g3+dcIA+omsXYhlJW/3cU4sBDdv3gYRZo2EfPiJjp6lr6?=
 =?us-ascii?Q?uSIr+i59lrgqljfbs1DfjG3h2+mD+H9AUNqU3/QSGsz3yYS+8igoCVnjNO53?=
 =?us-ascii?Q?3Tyk8YMRMGzUR72Qeai7XAHmiW49vj832JnQq1Pekgo5HVb4UxZj3RxiSl4+?=
 =?us-ascii?Q?baTdDtU/EFFUosQMJGXn/pLExOCJQwjoaxN/+5zcu6bsaUM3OGUs7R8BfMc0?=
 =?us-ascii?Q?Qg1R6dfsT7z3GhC7xL8Tw9TfBe8+gsrDXYcRejlg+Q3Ob7R2z0JKhm1/UygQ?=
 =?us-ascii?Q?tWYyY1pEDSJ6zd0B+Ckbm7ibcvxwtUCvPA4IEaxHjk2ihtmZ1StyBn9uWl+Z?=
 =?us-ascii?Q?d1Ogc3KDmGrhnGBgnPQJWtxBnqpO+YDqjzX34zXHkrjtHT3gHLrLCpxL51Ga?=
 =?us-ascii?Q?lfQRsFlqvE5NTtdU9GfAboI5AAv8SsoIsk1i7/ynjvu4pufrZcKzN6RFSxF5?=
 =?us-ascii?Q?5K4UK2Q7VkszBI6BczC7TSaQu/ClJykX2k40+CAt4+PVUqyCNAweKYWHopuB?=
 =?us-ascii?Q?7W/RZLieZvo5RuNoBXsgs+lbaNE0shgl8LBdL1zbJQDEsgpb8+YGGt61nrzc?=
 =?us-ascii?Q?eUoisDljXUqnsR2+WPyJ+dw746EG+3Q+scvL4+/q0uPwHeihPCjruuptDCqJ?=
 =?us-ascii?Q?fH/oBCzTK5ewOv14Yz/BqDYwcx/YGfUqwCQqG4iqkUvkNpEPZNDNuDDRDlEL?=
 =?us-ascii?Q?zqMvZyU7sYc4Uc2PhkQT3VTiI7C847Yq1zPOKSix2oUBto8f4I4CXtHAFquu?=
 =?us-ascii?Q?u+7UrixXBdGFGlN4nVlFRPcS7iw8JUz+0Ub7qoer3kWpgSvsniGT5cP5t9P/?=
 =?us-ascii?Q?1H5sIeK6gAVck7x8VHW8eR3miEAI2JNDRzkMT94N0TZ80dgzTWv5oXkGcBCb?=
 =?us-ascii?Q?0nQtFFsD/ETgeQ8FQdBFWLez3guKK8LRfewiP4938bNlBR+fepH//Oz8ZNN+?=
 =?us-ascii?Q?7Nvr5h3EHnodpSHG3U02sf8CopWkEIclssFtoOs0VN7Aj5rYcWQkgL8Y8VaB?=
 =?us-ascii?Q?I63hWclgx6pekMB73+O0l3yrdXr89DGYH7xw0KG191FSFjQA+Tnw+RHyb/jN?=
 =?us-ascii?Q?xn6w0GUhH4cnSjJLAinN9Wv7O44+jE2V75n5PSUlW7ViXj0UZRHyUNSlUMJu?=
 =?us-ascii?Q?Pn9AKKIEDUKmb6BOGsz95bAQsjIRT6GK7pKVrTadSEAH2Ma+FrcWoSFbsKuu?=
X-MS-Exchange-AntiSpam-MessageData-1: 4W3P0WTaWZaichfgzfizFbe8Pol8JFRJsfc=
X-Exchange-RoutingPolicyChecked:
	Bwddh/fTHqRsxDysdsVZAE5RKYP8VO/eZwwzkrTokgRqRR+Twcu1VSll598EkETRizgY0Jx7JkMKr4VgmEktfIZn4LkOMNyqnEZFpA3gNVb6xE2HaL97zqXNPW2cufa2rXwXKMNbzBZnidLDrBmwlbIJa6QBKOlHQIdECSKiBeARypkGqJoEaUVmyvFCj+IuQAMcXq6VXjW2pKaq88aYb/ddLTGtdZcv0uQ8C2Ndt+SRKfH3BHG3ovMH7RWTw5RCcVorCtYeLA0QXlOMUKYQ2KPE7+3O6kNbkl9CwmpmhODEeF5pKD17iU718LDceTcuMcYdI2i5Km8iKPLf/bxURw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1v/flQlx0s/qy0spv7gmVUGyUt0noX0Tr38Dn6dApIKqd/jq2p/GRYoA6Y7yWWzybHcMf0hqQNMZT9rifvuOCG+jfEAe+r90tMK6Qng8VDHdp2+B0KpPY30hoek2H4M0EDgALDddD2mrVuWbVa5noGJMwroLYjUK+l7TkLAVoKyZqodceNfPVZmO+reOugWkK+ByZo2doL9Xai1jQFIg5I94gvp6frAfYuswsqJohW9PDccdEVBOEsiylIcdRIw9xfwlPh7+y316S3RSCVMdDUmYgpNpKB4GKE1mpx8sqYL3nau+ACKCJ0ofVTY9QE9GTZt1+rtGUBJ+5ZyH+t5PemDiSLLQmH5Z3YR+iq2RQD58S0bj/am+CYCtjkaTofjpJGP8DQM/PLf+uZRn/yT+eGgGVPGz7Qkw/yTx5dC4Sy0xD6zeI8ZXKu1tvY02GhxTzcUByThs0wniN7hDqfg9D77tFD2inYcpbWfCLk7Pqt7TDx2Pdrwb/ezPbBnwsoeshP0UE01Nu6TXVXkyUiG4aB/EiXz8yWLB+qHvl9QTZmcPY5hq4IBzV1zCuSzLMCvgzDDQ/nS3JRs4TyXLEO4s9FndgkVrQcnJPIwGme0BkGc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdf0e34d-dd78-4bfa-934c-08df290dc12c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 09:38:36.3489
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bTfnGWy795taGQBus/OvF8gmLBAEMPZTMe/F0khA/xk+G1PQSCjSV8L4OFxenrR3wMylza6qKhTGJqnZesICEI29dVExCDEYvKBlX6seHZc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR10MB075839
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 phishscore=0 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130038
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX7kQDVzGAc1Lp
 TrlS2BcZ5+4hY6WniZMhms2pK2rvokis6z9sinDXf1TlcfLf/cYUMIqC2mxW+9o0UHS8cm6jktF
 3/s7cQCEmzH0CXGTtXZNAdjqEWr5E1DPWndEbY6V8fH3a4A74b4cpiLxbt4vlmb2Qxx1YuhxhxW
 KDQgdoHV1dTQ/GDAy3S9zTYAawL6mCy4GFWBGyvmgW8llmNGd/CZ2tBsqDnFpMOkJZIWItbOUY0
 W8nWqCdjP8RlKZyo1Lq4oD0gmbtb/emfEZ/ppOw6yVatjtTYqfF5ddFLysJ4pzfr709zJdmWq4O
 ClrUIOREz+n9jn7cbTEky05n2SfFqHdA2HvpuTIpWTEHSrhMc0fwLd9vz1uBBE/3OfiYqKDREP1
 kKMvWyuRUpnMqJlGPY3hRqwxLGTLzl1EyjCspSBp4bSIcr8BgilOJEoMryEZVtF36cxfx6eRztE
 tQT8hJIDijvu2flbmOA==
X-Authority-Analysis: v=2.4 cv=Kp7YSmWN c=1 sm=1 tr=0 ts=6acdfc21 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
 a=3OcxSVRvUSqaRT7DloUA:9 a=WmVTiCyuxqgg3mnwYu6p:22 a=biEYGPWJfzWAr4FL6Ov7:22
X-Proofpoint-ORIG-GUID: bBiO5yw2kHCNIQCvP68u6T_C3kO-2j1G
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX9DNexJwe/AMP
 99AOLu++zy3WrYsPCQCqJMZxb5zdUS0HOvb1wQKWI+1p348abzGuyGIwOZlrMJI/FCxdDuMjIhm
 4CO2IIcMthfnkOOsrQC0L5GfrkE4Pf+7f1YSzyMbiyZpBoQ6ZZNb
X-Proofpoint-GUID: bBiO5yw2kHCNIQCvP68u6T_C3kO-2j1G

Backport of this series:
https://lore.kernel.org/all/20250625224957.1436116-1-david@fromorbit.com/

I have added information in commit message upon conflict resolutions.

v2: Address Sasha's comments to v1 in the below mail:
https://lore.kernel.org/stable/2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org/

xfstests_xfs testing results:
	Generic:
		Ran: 001 to 771 (672 tests; gaps)

		Failures before changes:
			Count: 15
			IDs: 075, 083, 091, 112, 127, 231, 263,
			     269, 270, 363, 365, 645, 753, 759,
			     760

		Failures after changes:
			Count: 13
			IDs: 075, 083, 091, 127, 263, 269, 270,
			     363, 365, 645, 753, 759, 760

		New successes after changes:
			Count: 2
			IDs: 112, 231

		No new failure after changes.

	XFS:
		Ran: 001 to 789 (311 tests; gaps)

		Failures before changes:
			Count: 7
			IDs: 104, 168, 300, 442, 597, 598, 609

		Failures after changes:
			Count: 7
			IDs: 104, 168, 300, 442, 597, 598, 609

		No new success or failure after changes.

Thanks,
Siddh

Dave Chinner (5):
  xfs: xfs_ifree_cluster vs xfs_iflush_shutdown_abort deadlock
  xfs: catch stale AGF/AGF metadata
  xfs: rearrange code in xfs_buf_item.c
  xfs: factor out stale buffer item completion
  xfs: fix unmount hang with unflushable inodes stuck in the AIL

 fs/xfs/libxfs/xfs_alloc.c  |  46 ++++--
 fs/xfs/libxfs/xfs_ialloc.c |  32 +++-
 fs/xfs/xfs_buf_item.c      | 299 ++++++++++++++++++++++---------------
 fs/xfs/xfs_buf_item.h      |   3 +-
 fs/xfs/xfs_icache.c        |   8 +
 fs/xfs/xfs_inode.c         |   2 +-
 6 files changed, 256 insertions(+), 134 deletions(-)

-- 
2.53.0

