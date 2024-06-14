Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 267721773D
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 01:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718329805; cv=fail; b=OrKdXW6Y99q7Bc7luyt3eUQmE32Z9pKq5FW/adyevRiTYYgS1prM8CCZg8fNCSugTCG/pMTIxZaFzuYZLws0fByZz623j7bQFw/jepEv2hWT8MAbCyMxD4UFOeU7kLQXqSoCT32hgsmVv+Mj2h/j+RHld0OCAI5otMC5FJpXeL4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718329805; c=relaxed/simple;
	bh=EIyLHTTVsg20gj5f2xR274eE5lpaU9ef5pGsfpfAl7Q=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=p5VRhDDi9xyulmQuLw9Vz773qhKEuFHpa3G3mSaWmnTOFCx5HmMELm+vuN9sTSO7kmkdu/TP4T09WEIhu3aqbfIXZ0XsxquN/q2JUeLusN8MWmXOwT9tLv9FvkOoCabq0+OcSYrJ51QJcUq1omB69r3Jmw0TnChhUDuSXT9q6I0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Km5a1eEy; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wyOubES4; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Km5a1eEy";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wyOubES4"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45E1fn5Y022929
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 01:50:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=nZmP4JtkHnQuBRaeyfkpiryiRXqHLtjBFJBVEAi+KPY=; b=
	Km5a1eEy+TH0oyKfrOA5qkAYeiYebnE92g5UzPejWgjcC/D6nzTO4uTG94eUghZ6
	4BO+qjyu5RkDuYXk8WTAbVRtkxKyq5pR6fHWfr8/Dev9Qa6m1u555dzjihUessul
	U7YTBMHVhlAIWWafIQW6QBFEk3yc1RsTWyGc9ItDw2UYWa8UxpNuHc09FvnnxYWU
	gWdRE3de+BMnoMNAOBnNypxOGFzUbYR3rmWnvIg5IbpEaVj7DOnJHhX0QoBxWnrK
	80oVFp3J0nnOX4XenQ8Qy8prO0UXiXaiVGa67EX2fDRhI+xt4p37QQTNW3Z1Vd5c
	ysOvSuIHkw7rPd83Wj8aMg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ymh1mjs7c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 01:50:02 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45DMsKU5021135
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 01:50:02 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2173.outbound.protection.outlook.com [104.47.58.173])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3yncayaukk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 01:50:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DTcwdL1jP4G0wakpdVPPMUFWbUNzrr+QSTIyD/+sLnXr8T4ZeRgGXJkd2qj+wZPCOX43XPq8X9Zt2pNze1CHTBXyeSBymDDwuvmm8kvm7+tNSYXNkNO9CPZD5uGltBMjHj6bhz7d59wcLDyJnQGqAkB51RjPqall6jqFVbQOeo9S47TnJyeBjBJbSl4xAG2TGM7WgZ/kZVmn5HiWYFIMYG67MY9+RRrvtExIk8YlLtzpFgzTBsOa8OkuHGKdzCX/y0T95hCUBcddiezVs4um48TnbQ6JFZmxrtWoDSyf1pBX2d6JrVBHPjWMiO9PwPtHimYvrjxKagaeVWOExlxsKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nZmP4JtkHnQuBRaeyfkpiryiRXqHLtjBFJBVEAi+KPY=;
 b=HZ18gVKlEjH1BCn1UqhDPl3fMRaZn+93DWyXJ/cqfq2as5QJXmT+jiR4gsOQNbnGFrIAsEYe7El0hGhvnE5sbOLDfBtvpM1sSLioe5Jke4OrA2SyXik6PQIztVCCDRI9o9BQ8CZltWlJpV6ZKjXEe1/n0Hwct563IGwdhMBGrm/sFw92dN1xOhPwePAM+vEuGSy0FovOqUqU5wT6YxxeNgyvCkH2KoeYGwQ8NS6gmgAgOwS01YJ3LNiK8T5WMHuI/tPgmJ3o7dDCvRxO85JykvOGgoQqnRzrUxkykX5zTU3d9GAI6pxnAtRVB13grU/exleeHmgzCvTESzXHMqDWqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nZmP4JtkHnQuBRaeyfkpiryiRXqHLtjBFJBVEAi+KPY=;
 b=wyOubES4ALsVhFOQ8NPWWGPDlTBDbmaKjaEOHsnjLwUmSrudFxD4Z7RsYZxK1nJt1ulXJ+pte41UMoavq96CpyKlYWjjeqq24cGfFDQtkudqfGF7FifKtp1zgcnMJY0yhNqi2Ah/l9Z+l6q7UjO/cWzmaeo6uJ1srq1+/1QzIqk=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DM4PR10MB7475.namprd10.prod.outlook.com (2603:10b6:8:187::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.20; Fri, 14 Jun
 2024 01:50:00 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%5]) with mapi id 15.20.7677.024; Fri, 14 Jun 2024
 01:49:59 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 4/8] xfs: shrink failure needs to hold AGI buffer
Date: Thu, 13 Jun 2024 18:49:42 -0700
Message-Id: <20240614014946.43237-5-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20240614014946.43237-1-catherine.hoang@oracle.com>
References: <20240614014946.43237-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0029.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::34) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|DM4PR10MB7475:EE_
X-MS-Office365-Filtering-Correlation-Id: e4258572-4978-41d5-b899-08dc8c144ca7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230035|1800799019|366011|376009;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?QjSSD0Sfxh0achQyyrj1k09eQKSY+G8atLBaT4Tkn8tPHJjiGEO3fvzD9rp7?=
 =?us-ascii?Q?nPAmyOzimOmEWiUGfGOxJI0XBmwc/I3huS2sO29Rk4BFta8NieboCIO7DybZ?=
 =?us-ascii?Q?y9S35ZCEMxNJgo99y8kfPFuOQCpa5QhkGYLi+FP7xwxmIJVujjSWnHeubztB?=
 =?us-ascii?Q?FbQXwwyzlNA3CfDhQQlDSEol9d3alkKQeMsTqYJXcHB/m9IiKF+KXg2UZRn/?=
 =?us-ascii?Q?/ZLDsujOJe5ucQ3XLqU5NO98+cI5CYtfpCzHNNswu/Q3vcOKaLqKqjDRicyg?=
 =?us-ascii?Q?jYXKgARPk7EXB1cxs8Rd0MMV3eaPJiXgZgb7d3KoaFaPSe65WXP4mbBSECct?=
 =?us-ascii?Q?shuJyKots7zkU4cGgbEpFUV5FWxmnF9k4F5pHOxEQ9sbr9Zms1ZjILOL08wk?=
 =?us-ascii?Q?DFtB7aUhTa0je8NpEpAXKMhK1rSKs/UgMJUjfKZTro9c+87fkjldMZM1zhxf?=
 =?us-ascii?Q?AjM4Eu3N0z+kThE7tzEctknSyrX3vY+n8FT3l/S/haxBThwgpDVfVhbcLABW?=
 =?us-ascii?Q?XkRbOukl9ZogzbAK0P+Gb8sQzY0inNjjglIq5Uv0la1owdaAxC4Cs2Fxk8f3?=
 =?us-ascii?Q?X6zbH1SIbJx1C5Ww3FwFO1szQIVKf4UntX7GZUkhkBdf6wS0EZxxQnJViK8g?=
 =?us-ascii?Q?FTUizJmMfnFEj+MolrcBnxjK4KK/0fPHJDlynOLYMA+GaoTn21/M6sC3tRUk?=
 =?us-ascii?Q?eGyT3WYMF1DJpKGv7YDnJdG/8GR57eblPOOCTGQVCXD3z2HM5M+TdJJK9Pw9?=
 =?us-ascii?Q?McypR2J/Xhe3Kcl4W/W0az4skStWNCZUB2yc966WFkitxJ9JsOvL7vJlo8nj?=
 =?us-ascii?Q?1W5uTFcxjX0XXTm/b5uQmB2M5ma3obEck7BztsEnbqgAyPOi6L7s+yu1rkAo?=
 =?us-ascii?Q?9Dh+kOCOtk2yN45Rw4KAAp9NwcTgmdAM4m7jPFgjRTw/mZoyznUJ4/BMSO77?=
 =?us-ascii?Q?juiayqXtKrIX8FYmkwS9gEAgXuRiThlCCfIWL5kVu39Odwco9o8291YbAM4U?=
 =?us-ascii?Q?c/OgWwmsgXaSlO02XH3AED/vs+SPR4/wWA5LD+DsMDxzGAECq3OFltb35aWo?=
 =?us-ascii?Q?wC7szgzMcfNI0JgWDo7uYub1VoLS7lvUy+fFiPENRIKaYBPdwHibnS6+Cosa?=
 =?us-ascii?Q?yd6r9KmPq0qLRnjVGYR33Uik0V+6NXUtxJYtYTVxVk+EgKbmbPNoXAMdd63H?=
 =?us-ascii?Q?iJNEzAebrAlBJQvUsnQBb86L6EbHmBA0ul0LkvXrMacAKU34mMyzmrTjELYM?=
 =?us-ascii?Q?rNwK54nk13IhOTD4jmY21LD/PCxs597sxqls/dkOns/dXdpAor7pYLCGebvC?=
 =?us-ascii?Q?EXtqnmuwslHDCXIIBoHr1rC7?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230035)(1800799019)(366011)(376009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?YRNz77nVIac0uf5/D44FDft8V3TtnRAuM8zwgioN12dnlQcuk1i5yxSiFYfj?=
 =?us-ascii?Q?t/dM76IvFqPSk3xT12IRRnH5EZQaxlOZJvYLO8hkuftOHG8blqs8MhSbn6D1?=
 =?us-ascii?Q?5Bb9DT04qdRP9B6A4RUV9ksdnAvJr28PDWRtNRx7iRPWECHM4Zwgk2yjOTw2?=
 =?us-ascii?Q?pmDhHf8suCX6x86+GjQ1efjdt9nqlzjFMTo+8pW7S2bnSFAL2t/qzpV9rdAe?=
 =?us-ascii?Q?KLuB+/3/RDOynog1uOdZNwQEVgx4prgLy3L3tXjj0yBE3I58bA9fu+zezuMJ?=
 =?us-ascii?Q?QibU6TCTK/Vg5g7rAFcMq2UIlBZlYH4SUKx8jwlJty5O7YsZPkRBLm+JAr4w?=
 =?us-ascii?Q?WpAjGrdJToCScwqMLnLFZdr6m6KrsHV1iyQMxzFBA+QgDIu+NpOxc5KnJJ0x?=
 =?us-ascii?Q?PoU8HbOe8frvFaB3wFr9j1HS0GHX+TVWNPSkf4rLvIM7k/UT+Wz6Asd+piJP?=
 =?us-ascii?Q?oDN2sqL8TTLgO4yDh1KHWF0mYH62xDkA5mjVrqtcBvGvKRkudJPF3acbKnil?=
 =?us-ascii?Q?5NfMmaj1PreIXTgpWAOGmeOb6pNrMlTTeVfFfD4duhBh8gsr9gEsKkvv28A1?=
 =?us-ascii?Q?qDDU5wzDPHwInsHjB8sTESpqoMT8BiNriBC2jA6wPRpVJ0yaNR+8vv3FUEFm?=
 =?us-ascii?Q?98E6wmUj+nvza1gJcEU8F1MrRxsdtNXJx06mm3FJWkgi+RJQ7mSr8QErWIQg?=
 =?us-ascii?Q?Jflhc0PCckdxXWsqH2R1sKiM1iYu6I8B+Akc61rKkA72Ao7yXjsmsNj4o6rZ?=
 =?us-ascii?Q?3Y0TehmKlYUT9FwmgEuR2X9Itu3j0ruyFNdSt03jMqt3HvynW1FBM2DRJBZ2?=
 =?us-ascii?Q?SuQjVpeLP7wRTAv/vlCAXgC1YPvYfR7G6HuPmiuBZHDHZtVNvgEj2JBUa6RD?=
 =?us-ascii?Q?xemJ+oxo1JWDkDyroRIKjO5nbKLN9KhyexYON9RS2DkE9Xj6hWLpwNWcJrV1?=
 =?us-ascii?Q?QnQ3tGFiDTK48dIeBaX3lWJ6a7LSXtJZqeiFrVVITN9oqBmxxYVoTy7ATky4?=
 =?us-ascii?Q?pw15e7kbZgqQKsZjuf2qHMZYLJtCLJDFNFppy0wKM2S9dbd35X+UPqC42Wtz?=
 =?us-ascii?Q?Lnu+UqJhUxTHpDqdY24v/Xln3IF+8DERt8PCMo05Z1wCxXS6n60JYh+y3fWi?=
 =?us-ascii?Q?mibuID9+6j6b15jYO0zdSPXyW7RlZwBH/80FBlj6pbaAulxN3IJVQhk0fjtF?=
 =?us-ascii?Q?lrvJORUPDbAHo2arKGDaq8D1wNbbT5vJs/6ekKkRz92F3RWP5CyNzLrlQ6Aa?=
 =?us-ascii?Q?kQLuIow7ksLSGHKwrpMpji3u1UYZip8UbxTrHr+Kub3h/8hy+lh+4xi4xSMo?=
 =?us-ascii?Q?I1JxNPqTz6Cf7OMnfXuY6q/4AWM2V5F4XK3DL3/lvBKUu5U5TJfZAuE+Sg8x?=
 =?us-ascii?Q?UhUAsK8OL2ojCbKnFHsJmD+gkF8vxIsiWzkTYCcYNa+W05ukiZ5EVofiklWv?=
 =?us-ascii?Q?5BPxg2MNrXFoVdstm8Reg8805inXeSPiPuYr8Z0nI+ARnKMcaM6uqjmna0Eg?=
 =?us-ascii?Q?nzPIwWtqJEqYY8WdLcKcUZ0/DMDGoagb9/4jfoUrcYhxBKfd/CX3YsnYRyOP?=
 =?us-ascii?Q?e9KCE0yPfDBtk6VRz6IdSDaxPvQTPxTSgtRrozVvobzQIUbN1GuvL1ZgDy/c?=
 =?us-ascii?Q?Kqmh6c5KSf9gLxTho8dCRfUVCcZatj5UEupeOL+C5uUPaHFITD3DxqtcSJen?=
 =?us-ascii?Q?BUvttA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	CZI7IEshpTgJE/u1ZCe3dplCcOq/4u8xFKtQ1PAGCp/y6MUHfKcyTQLGL9HxyiRoyjPLT3X9srv4GnMLftKXchYPpxdOLwmgcatli/Yx1vdCPVDcwcJM8HMobIsCr4SIsmFPuhiwMdzdc3q0BT9DPzGFxVUG+/c/eBab1l+Sqc2DTTnRL8JFOSBKlh7h5ohoVWarFH48APgjWYqxNP4SKdYG3YzxjrMMgMTpZzln9RZR4Q1pGJdyuUaPLv7Np/vdO+/MKp5ORTaPzsF4JyIuUn065rKGQug2ha3zyE15PD4+uuyF9UjTe8Dh5uOcfHk0tJ4O72dpPOZm3Sn/ixLhcV0rc/dJ2mVGD6ohVPWYiB/LNCgBKBXc2DeRdZZAXVfzKHhtE4QrA1PEPLN+sQ2omUqC47K3kaPr7mDeVpaIGulZ7c6MflkyWSDV2Cqx/R2HDeF3sXPJvK5OfbU9KewpOSAsiXQ9JSgrpHBNR3E1GQejj4q0W80m6jRzVsF5pK63lO9sEaCdjZyN4El7D05wtqC8Kn3644EdkDpx8XLjJNtuhB14ESBCqA6yQag5DOSKLnNniTwItKOROd5l79tWyn3q7BTxqTxNYJW1ru1rdNY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4258572-4978-41d5-b899-08dc8c144ca7
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2024 01:49:59.4615
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zSWgUFE6psV5+9Xn8b1dAlL6Fo0NppSJDog6XB/2WVp6Ec59MklMyCsh3i/lbDFO8b2x1cHfl2bLKvStHSl/r41ZHe2pfGzI0RpYYDcvOTY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7475
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-13_15,2024-06-13_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 spamscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406140009
X-Proofpoint-ORIG-GUID: CISWJPzvBWPYZcsiOqH8BRHpRsPo8gR0
X-Proofpoint-GUID: CISWJPzvBWPYZcsiOqH8BRHpRsPo8gR0

From: Dave Chinner <dchinner@redhat.com>

commit 75bcffbb9e7563259b7aed0fa77459d6a3a35627 upstream.

Chandan reported a AGI/AGF lock order hang on xfs/168 during recent
testing. The cause of the problem was the task running xfs_growfs
to shrink the filesystem. A failure occurred trying to remove the
free space from the btrees that the shrink would make disappear,
and that meant it ran the error handling for a partial failure.

This error path involves restoring the per-ag block reservations,
and that requires calculating the amount of space needed to be
reserved for the free inode btree. The growfs operation hung here:

[18679.536829]  down+0x71/0xa0
[18679.537657]  xfs_buf_lock+0xa4/0x290 [xfs]
[18679.538731]  xfs_buf_find_lock+0xf7/0x4d0 [xfs]
[18679.539920]  xfs_buf_lookup.constprop.0+0x289/0x500 [xfs]
[18679.542628]  xfs_buf_get_map+0x2b3/0xe40 [xfs]
[18679.547076]  xfs_buf_read_map+0xbb/0x900 [xfs]
[18679.562616]  xfs_trans_read_buf_map+0x449/0xb10 [xfs]
[18679.569778]  xfs_read_agi+0x1cd/0x500 [xfs]
[18679.573126]  xfs_ialloc_read_agi+0xc2/0x5b0 [xfs]
[18679.578708]  xfs_finobt_calc_reserves+0xe7/0x4d0 [xfs]
[18679.582480]  xfs_ag_resv_init+0x2c5/0x490 [xfs]
[18679.586023]  xfs_ag_shrink_space+0x736/0xd30 [xfs]
[18679.590730]  xfs_growfs_data_private.isra.0+0x55e/0x990 [xfs]
[18679.599764]  xfs_growfs_data+0x2f1/0x410 [xfs]
[18679.602212]  xfs_file_ioctl+0xd1e/0x1370 [xfs]

trying to get the AGI lock. The AGI lock was held by a fstress task
trying to do an inode allocation, and it was waiting on the AGF
lock to allocate a new inode chunk on disk. Hence deadlock.

The fix for this is for the growfs code to hold the AGI over the
transaction roll it does in the error path. It already holds the AGF
locked across this, and that is what causes the lock order inversion
in the xfs_ag_resv_init() call.

Reported-by: Chandan Babu R <chandanbabu@kernel.org>
Fixes: 46141dc891f7 ("xfs: introduce xfs_ag_shrink_space()")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_ag.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 18d9bb2ebe8e..1531bd0ee359 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -979,14 +979,23 @@ xfs_ag_shrink_space(
 
 	if (error) {
 		/*
-		 * if extent allocation fails, need to roll the transaction to
+		 * If extent allocation fails, need to roll the transaction to
 		 * ensure that the AGFL fixup has been committed anyway.
+		 *
+		 * We need to hold the AGF across the roll to ensure nothing can
+		 * access the AG for allocation until the shrink is fully
+		 * cleaned up. And due to the resetting of the AG block
+		 * reservation space needing to lock the AGI, we also have to
+		 * hold that so we don't get AGI/AGF lock order inversions in
+		 * the error handling path.
 		 */
 		xfs_trans_bhold(*tpp, agfbp);
+		xfs_trans_bhold(*tpp, agibp);
 		err2 = xfs_trans_roll(tpp);
 		if (err2)
 			return err2;
 		xfs_trans_bjoin(*tpp, agfbp);
+		xfs_trans_bjoin(*tpp, agibp);
 		goto resv_init_out;
 	}
 
-- 
2.39.3

