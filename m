Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4292213220;
	Wed,  5 Feb 2025 03:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738724865; cv=fail; b=SYvYE2XAo+sSZStPFYfos7G+7pzGk6qdns+25ifIxovYrRqUQxXWcPGOiFBz76wdizd5e8oZTBpu03/WHIq2vmZHqWl3Z7mGtTIM7Emo+8qrEnWnjGeaDz8mnxqQxOOY04Y1b1xnMA6XPf5rTUx27Y58VVvstT4tn2iBvjzUgp8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738724865; c=relaxed/simple;
	bh=XJrxO4o7geYNY9noaYWPGVABBpGkwsOid+lI9OZk6cQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Sur3G7aNAnpwC9oqNNJK6mwQ9lQMRF+aVfPyRHcVsFRoR7QHhGENzqT7er87KufS8sUBeif125FsfwmyH4nGmm2FRN1WUuoluuJmD7Myy9CggHKKgQ/5NkYVn6bMRFEpU7iXUd/6W6LcfV+R8IbmDm0YF+cearGJHdsKkdx8750=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=C/6Uhr2F; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=NDBgKyXT; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="C/6Uhr2F";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="NDBgKyXT"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 514NBotJ031267;
	Wed, 5 Feb 2025 03:07:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=D+PLb6ha1CybR98oBQ/yrYh+GGk/BH+p5ki9reIQ5m0=; b=
	C/6Uhr2FmYTNNNd7LLc/BeksGjwAGPHGXL2yL0rH7wLnzvlpc7QmIaieSGa4cqYv
	aou+sLg9pDVH5C8jjRPnezp9b6dIXvYVvm2rXAqa6dM7NyzROcs7xJK2TggOrv1W
	xTCkzO65Fc+ff2/TQ0pzmGwaSjuQ3oLRwYnIkMIZ/8FjxLQtuTlb3vcRjZeKGJgV
	yxVCHpw/J3TPXJqdbgcfqO0JXdhzS82JRia/YCUhfiP37CbWdwVlC9cyjXjOZakt
	GrVswIMjWiT06RPGY58xD2BWrj+qjjkhgmssTXSYQTUAyMuIZmPEBCa3AK9MRTlh
	1qqNpIfpr3uvvR+/xEx2sw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44kckxj3qk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 03:07:42 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51531u2m029816;
	Wed, 5 Feb 2025 03:07:41 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44j8p3uf4a-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 03:07:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CRSIwzjDaFbFwKH8LO4ExGotlkRcq3AZQkSWDDOqSJxIMuTumKFYKTHHGiC2x3G6aAD7cbZal3WofQIzKwL0iSHJlIvlw0hTtU9v6gaW4SX1gvS0WVKQi/wIn4wXLga446mofkP8PEGO1HuaX3OQ/AbVS5d+ZN1hUrVEuj9d+mv1i6hkQa51k3is08F4GqAUhiZDnnrx3QSOVrI/FpZwd1LJ0Zl0MwNJBB2pWngTQ0M5gNEGX9s4IfWJ5KtcLPzVj7b93LF+oIXqy5duN/DJRiSu179VkrY9R9cxV5vIJiZ8acuaQ5dTSI3WdJNdu7zbUjOcEnBSxotuudNgYk0+jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D+PLb6ha1CybR98oBQ/yrYh+GGk/BH+p5ki9reIQ5m0=;
 b=HVOk3c+YJPb8lc0DDvSiuaic9zNw2M9pSY50f+SVSX1sBvSx7uQKeslG1P1R2jOxWOTBTO+3eaXp6gYIRdwfGV1eaQ87IUGxm2kJjQ2FTosxyXck+13xjn5WWzBAtxKgGYL1amXTcmhTSDxWFF6gMZpXML6FeiVtCSWNY8ELybbweDmfho0HwxPxGrrv7qNZtBJp+tAesKrTaAZ3+O1JwoL+uxsgEhVMJfc8FMKNEsAUi8qKdfoZQMxCPo9QA1pG9DGLsp3x/0dJNVY9UxYv+SayBc/75KwKUQ69EayZ3wTeRVpH2XZ29K/LeqtSX0n8nHYKQv+DC0twfHZSMNddpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D+PLb6ha1CybR98oBQ/yrYh+GGk/BH+p5ki9reIQ5m0=;
 b=NDBgKyXTD69arn7qtRuRhNlff5aiY4D2DZJBEtfgclnoS7VklomEx4jR6LNkZbo9m4HrP5Azixj9iEEFK964YMlRikxTBr2ABsg7tei61QiqV3pNYM41W22odGaey/LaGGt4BP4KTx+/Iwp/TCPIpuz+R64x2sNlcnj2nYio5Hs=
Received: from DS7PR10MB5327.namprd10.prod.outlook.com (2603:10b6:5:3b1::15)
 by PH8PR10MB6477.namprd10.prod.outlook.com (2603:10b6:510:22f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.20; Wed, 5 Feb
 2025 03:07:39 +0000
Received: from DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::43e7:5b82:9069:b402]) by DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::43e7:5b82:9069:b402%7]) with mapi id 15.20.8398.021; Wed, 5 Feb 2025
 03:07:39 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: xfs-stable@lists.linux.dev
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 02/24] xfs: validate inumber in xfs_iget
Date: Tue,  4 Feb 2025 19:07:10 -0800
Message-Id: <20250205030732.29546-3-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20250205030732.29546-1-catherine.hoang@oracle.com>
References: <20250205030732.29546-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0105.namprd03.prod.outlook.com
 (2603:10b6:a03:333::20) To DS7PR10MB5327.namprd10.prod.outlook.com
 (2603:10b6:5:3b1::15)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5327:EE_|PH8PR10MB6477:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d8d6a72-8f39-4fce-08a6-08dd45923fed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WFfa59jX0YU6iuM7ERjNHjRXZ0Hsihh5g6vV2npQufgH176RkNzKuLgqOdrg?=
 =?us-ascii?Q?px4UcpscIjxyzdlKUJN7faLkCT3m+/g3xbcbIdfON55T0MB8AOyqGh97heHG?=
 =?us-ascii?Q?pWfkjm1PUIELJzuew1AwuGw1fQd+3MVO5iUctOT6QXOLQkbBK03bERtOf/ms?=
 =?us-ascii?Q?WXhI4InFeLEo1em76kqLseELbzBtBDU6579dLFr7YDV0h+C20IXAz30nJS+t?=
 =?us-ascii?Q?8LA0y1MWyV4ueZp4e31/h3BeMqgGbxmpXwtmhcsb21+3vT7aHcPVfFb8mN8n?=
 =?us-ascii?Q?E3Q6+kiFhIITbiOfVVVvp5A5cu2xB0FALXeasmTRB4qEahFM9b2DzQLTxKZY?=
 =?us-ascii?Q?2glEHTzacQgVJKxcMV7nMttaSmAWnK2RRVamw5fe8pEaZpAdu4roNMi851cp?=
 =?us-ascii?Q?CNF4V+/3qC2bKXV7mG7yTjLAbiHEFri33JnuqxQndOJT470lqotAAnR5bxSJ?=
 =?us-ascii?Q?ZIpHXpRLjAQwsIBSk9oYHfsmtXod1R+d8GntBxcRX4p4SDPp6+iFWJR4zVaG?=
 =?us-ascii?Q?b+/WmarTcWVVNk6PtWt1l+brpg4Ru+nOKsugoLRDX4sdbywVMBRFOqxFikse?=
 =?us-ascii?Q?PZWW+O8aq3wizU+vWbps5bxkSBIdfoOzAVXEh74lfMr2czU2UKU+8rmjrMYk?=
 =?us-ascii?Q?mFdnTfqxhj6WBsZdv/85mO8yI79WL9pmmVhO6PwHV/xTUrTY2PZ6G9SRSeie?=
 =?us-ascii?Q?hSd83C5qIVOAIsYXMZNYTXSS1GWCuFhHb3PmfLkrVCpNfibUwV74fx4eYLNG?=
 =?us-ascii?Q?T9ZrQx1LLvxFdLkn+fDfXXQ3638apP6OCNnDvo+jqFjCkVDTw0XARXgGFxc0?=
 =?us-ascii?Q?XLAUidy2JLWPawTVhGuAldJBhV1Pca3LZLYmbuBG4VExANVPM0olSBLOA8x2?=
 =?us-ascii?Q?vYNOT3b0EiHzPNEg2UvuYpKQgZ050YuKCRsnWWvylZra4DDnL2HdMa9XbdGb?=
 =?us-ascii?Q?mT1sWhaFu+8irb855P8xoqYDQ0BMbNLpMe8rltxVrenStC6A3ElJzxceRVmT?=
 =?us-ascii?Q?xCbDECs4Esl8PDhdQxbkoNqONyLyC+mYpirznpChJkotE8mm6Sc4rWI6AlGU?=
 =?us-ascii?Q?IZRvdLFYQH4q1BrtRIvzukOQhYKmxQQTos6/IfH1h9nECCAwNQOx1ywDUrRC?=
 =?us-ascii?Q?RP4AgItnnVIER7e86aM5YQSXnMlRubZRHHnNLjYe/G6YbhpGLxqJ4ih0/7SO?=
 =?us-ascii?Q?Cr3Pvcm59z5Pv8F3Ks4aemdfoX1KQFM4vrRKXFTQTP4aZBlfNlLxtLSShJXW?=
 =?us-ascii?Q?jS0pY5AGxGwUT6H5D49Cweebwzq2Q+9wxDk324qxSabo41J6T4P+0YeMDGzo?=
 =?us-ascii?Q?CKiolOvwqj+q2F1EOX5CdxRf91uMlWr3i83uIWEGd5YABLbgGyPal8zVdgzh?=
 =?us-ascii?Q?2h9Nf2WciJtyzEcLht9K7xoMsYDu?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5327.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?B4mOqAb8xJGdfxD8hyYbbumclC0mcr1yYVlVz59N1LIMXaIemAAf/9he0KPu?=
 =?us-ascii?Q?44RSq50CRVISHBxgRYCfZs/GBBmpeFARX0wz7gduz+V9CwzXAD3Ph/n7dMG4?=
 =?us-ascii?Q?zpVBmO9KfWHoUzUyhBi3y4ra8ADeoEmgvg49MHpnmVwpZFKOW9hSPSsA47v5?=
 =?us-ascii?Q?pK4khwvC65NScb5YhDUjWmAaN/YXT7WphH8ZT3zYYN6Ib+SoysI/AguqX/R/?=
 =?us-ascii?Q?bciOP488B/bU5Ng8bPG/B4DeBQAJr7HRM/pCt2XgIpe+Y0PVbeZqrnRnkNXB?=
 =?us-ascii?Q?SBreyA0EJNkUKC5ZtargqNDrauGxUSAum1nkcBxICmmGXThkvKaLGWXBZ7gq?=
 =?us-ascii?Q?mwjSs7cNt54gp3nchxR+rmtfVcKQniZt0FEzkxfwFVUnm2iFkeYFPH7RkNUO?=
 =?us-ascii?Q?Kltv0mziI7xCGf0YTq+9of6GN24nkgLk5QWTePA5DJscsIovtbvvEsxm+Qfq?=
 =?us-ascii?Q?vImZBeQpiapFo6AqWCpn8vXQBZSD2aOIbYAD9rlNb2qOs5w/k4iKLmsIUyje?=
 =?us-ascii?Q?gNDHWN1VFs4NO3ogW3bRlT+8vg1VSWPFJ20/PLInazSRSrVMC+8yl02EdSC1?=
 =?us-ascii?Q?zVOisNDPJDJ15GRHEaejolHqROD0+UrakmtgweUQdr1ZwjfXCPgzNq/HM4dS?=
 =?us-ascii?Q?hvLXAkCRHixv36ULWUUoYDS0kdlu69ilC4LDQuxZsZGzkweCZ/bBKFm60Lk1?=
 =?us-ascii?Q?sB5YqVSb4+RWNlYCWgJOnyAzHmwf/TL9YPk+z0GNqus1e4ZQqs/a4ZFCWGN9?=
 =?us-ascii?Q?KBBFr7JwHp4/F6f08NnTjaV1Hc/TM+vwa/vdCl4Z7NS8yKfVVsTlFGNOsxsw?=
 =?us-ascii?Q?WGCMmMKAxaPeUX4hWsOJFeBfrUSL2vZgavnl9tQbT+lPWhiPgURAB4bFuu9Q?=
 =?us-ascii?Q?WAZJPsALtgPDOBZJVkPLpyPB96a3nng9U9SPYMnoA0qJEQDVszIajwapfFTl?=
 =?us-ascii?Q?ckpkQv/lnWrXvCrOdVNugz8MJMpUu64BpgSYUTDBAOsYF8mpdP3wOxiF7lJS?=
 =?us-ascii?Q?LgkRwLi19kGRUDiTCj0eEA5lE+O0W8uh/rAon7qrV5BOzvfFZqIg+al05NVG?=
 =?us-ascii?Q?ZVgIVC6F2uZyLOFjR7oJnn224b01MiHfh5fnhYXqeWSV7urjhQfTAtzn8XO7?=
 =?us-ascii?Q?9Xis91EkZ+rG7orm5tdCIRfnDwtHx0pR1UcAKOupp8V+PQWsWD/n19Nt5GxN?=
 =?us-ascii?Q?8PahSpy0dwpahXw7wzPrWgzu2SLHUM3GBi2g4qM+wDu8tP8mRGYCMpO4vsMa?=
 =?us-ascii?Q?I1EnV/H5sFgKJwP1NsUJcoK8OtwC+shztuQKqGHC4jstTKo27Mwx5+mYe5FZ?=
 =?us-ascii?Q?5t8KBlF4sEpi1/FLpJ/zgMxw9QUnVtYR7PMGZ0rQuWsDEsYxhves0H5616pH?=
 =?us-ascii?Q?o83n/KNu9rnL8YvyfXROiA7JBSpkz3pLv/E9w+LbAmskqnC5Wp3iGi3xpi5u?=
 =?us-ascii?Q?JsAZ99hP+q9eugi3E8Azbv6+6HdPFhcKO2SuHXdlcDobiFzSTExuklNRHBqi?=
 =?us-ascii?Q?eIG4erpWlHQX8Kjgx1ylE1X6B3su99yUmQY8+NBQA4UKfYMIq3Ar9oFHMVKj?=
 =?us-ascii?Q?OzD+gui9ek2N5jubelRbyAi0Jmk3yXxJgeSOPBlPCybuPAS35tSpA87eWpJK?=
 =?us-ascii?Q?8nKd2rP5B5ww2vA2Vcak2HGXc3nZMOn4Tiw5nX10CU+DDcmm2v/z9lhaNzKN?=
 =?us-ascii?Q?qxgYaw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1NryCeTXTJiZxTT0Mw4KWrksSwnCf2Gl/bzz+COAHHoWAYy/ju+jPIZGAKZTy0yjoXONZxZL6Qv/Ob63q/icuwxt6Rcms7pU2fvZbKRmRoYV+8JxhEPHCVe5UbG3g8bKuo0pCyjlgU8QAHVELZjB8AMvOOGfyMPfnee7gbVNOArfaSdD6EcecpkoI1nLN2pWXfcAhek7GrZ/zeCX9YyKaxPzEPZ4cruFv2sJol6SFI/8S4EDq67uEdvFtCWDKIEqBix1t541XttcH7gly7wbSzgyoQi7CXW6cxaN/VBRxb4S5f3BR8aZu1fwYOcbmmgy9aMFUS0jPoTWYnmQgbgKVLMaJSF+WdrYxFOSJ6D3JXk8jBH4KBCQPnmEqb01kN3wRn2vrD8D+nNG/qvDImvIUa2N/ftO0VzGjw+0DgdOJ8RG+aB75GCUGLTEEpDbVYopBz1SOkGiclVPSvlZ/kLZJP7pJEqk9Ke4p1gPUwDgxsHIvPOETToemCX348Xf818/m78P0jB7IeBU08YFhqhgFpYzJDbPNZgfMWgjGLGDcEK2Cx1IACGJE/KeN9V9l7rOFuLMXmHyRC5u8zh90Xxp1gYzPVNEU2g2KLpL/zczo4Q=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d8d6a72-8f39-4fce-08a6-08dd45923fed
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5327.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2025 03:07:39.7469
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9amv1V5ciCp9j6uBXbL1lcWML8K5NPrMn/gCEBTl1b61qfmPkrgdQPcNv5BX62Y6wSyCXcDS5yTGUVJfVwfTNoV56alB6jL8oSwyWfiS2L8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6477
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-05_01,2025-02-04_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 adultscore=0 mlxscore=0 spamscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502050019
X-Proofpoint-GUID: Uf8yHZx-gfwNJf7TGADX_RAB9MBVTZ1o
X-Proofpoint-ORIG-GUID: Uf8yHZx-gfwNJf7TGADX_RAB9MBVTZ1o

From: "Darrick J. Wong" <djwong@kernel.org>

commit 05aba1953f4a6e2b48e13c610e8a4545ba4ef509 upstream.

Actually use the inumber validator to check the argument passed in here.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_icache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 57a9f2317525..86ce5709b8e3 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -748,7 +748,7 @@ xfs_iget(
 	ASSERT((lock_flags & (XFS_IOLOCK_EXCL | XFS_IOLOCK_SHARED)) == 0);
 
 	/* reject inode numbers outside existing AGs */
-	if (!ino || XFS_INO_TO_AGNO(mp, ino) >= mp->m_sb.sb_agcount)
+	if (!xfs_verify_ino(mp, ino))
 		return -EINVAL;
 
 	XFS_STATS_INC(mp, xs_ig_attempts);
-- 
2.39.3

