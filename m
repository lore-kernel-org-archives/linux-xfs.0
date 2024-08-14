Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 746381B3F02;
	Wed, 14 Aug 2024 14:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723647146; cv=fail; b=YLswX6ftqXFFytMfxiEA49/KE+m5Q5TZGIckJUnHq8pyqzB8CNDO9loe7Lll9fCsQf59yC0f4W1XleyQ4/nyIfpBGNs4ojI/7ASzvSr2TN4+7LN1dafjafBOeo96MIsLP7F8p+e5E31NFzxHtoUJuXTzAstmrPIfBVZx4VNd1RA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723647146; c=relaxed/simple;
	bh=a+nNF5eiaRLe3gpU5lWt4iFYucUCFujhUA7IDYOyR0Y=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=S9vDBwU01RcD8bpsE3ixhUBSYwzP08Eu7svO016WJN8iEZk1rrT1ulcptW7cCiypGInnonB4GGnAsi8dC+O5s2d+jZFWKhb07N4ECsHNPl9fWv17ly/EC9Rx4LhDzRRTnFE0K/XZZuB0L9VjQaummbc4IMIF2RYqZrxIe1MgOIw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=j/+Yk13d; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=gSNXGULq; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="j/+Yk13d";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="gSNXGULq"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47EBtZQ9003682;
	Wed, 14 Aug 2024 14:52:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=vNMUiYHHKXnqJf
	3OG3q6RhM16NjKQpsDrrJxnX6o0CM=; b=j/+Yk13dI2gyC0b5GRZaA8hqy7X/b7
	cwlCNZNykY7YLlKbOkC12cs5LNYHgtG13OWRy9J2OuiGWoQ67aZGxwQXAYY6XCCx
	5zpGLDg6G2N2EnbQAgUN+aa+AKgtXcj216UlrdMX9heOatgVO4m1CDBl8eX6D78S
	fXhZKFE1a8qvAcBQRhvUCY9jAFrsbEU0mKJveWiQ1LEBEY6dGK8u4IylcJ5LmiJA
	Wa1eMChjUbPV92L6a81KM8PwgE84Clpag7cHJGYwR9A7VXOgToJ0cZGgr1+17Fz/
	pAYiQnKqcBu6FWZfcNogg6TdHecgtaeAk4IRKlDKppa5mYpL/rKyCHcg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40wxmd0dps-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Aug 2024 14:52:11 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 47EDbOQC020915;
	Wed, 14 Aug 2024 14:52:10 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2040.outbound.protection.outlook.com [104.47.74.40])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40wxnghffu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Aug 2024 14:52:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eAjHxh+yGe1cB7Z7OsMU405a1UrMC45RzgOtRuYbA34OCn1EUewP0f2+f+gWG8F4jsdOmd0RqBmhWw1BZczcrOw5gi/CdpD2oihJLt4IoxbgG2cncLbnn8pwAay/5XLlTQ2+vRfFx7v01QOvdQ3/nVi7PHtOHxA+GYRK5iq06DhZQ7GwNrG8lgHl5Oj9JgGSZyl2EIwC84iWz8N7Cl1ZtfoY+XEmYoNFnfec8LVZ0oqnx4JIUYUan1zFBso9XyA+NCfmftnRK9VkZJLWc1kvBqCQRPDKaXQ1qnezd5LfW3QZVUuLnGkwgmOyGXVPPHG2bvdDXFOIwKwBzqSeaJbplg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vNMUiYHHKXnqJf3OG3q6RhM16NjKQpsDrrJxnX6o0CM=;
 b=wtLAsCTKeEkVfpKSYq3nMEZ/6Nz1NqYm3N6MeLiKn4EyDu6hiiJnq2uLOWuJD2Ne7GjpzSgTij4wFYtTNVnKs1NUA2ElsUXOpoGxx/QHh2p+q6wewQ/aN/ZKfGrXVhVuo7E8grLEHmPnuSTyE/Zzsy2M/qguxp9mWz/jtCY53p8LVHxycQ4sGsCtqpAo2Reb7jr5NNdZCjC6At7THENx0YrHkc8obLBi7+xxykwsLMBLQVX0uIuPLgTCZh9vmb+xlC5G4ZOOkxOhG/KgCkNzVwYT+irgKajlY++GFjxGpinPIn858+ZKth/MgFomEYn3rc1sDC4pZIz2Kq41ikoaeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vNMUiYHHKXnqJf3OG3q6RhM16NjKQpsDrrJxnX6o0CM=;
 b=gSNXGULqE2lD3BSiz4G/aXfMKNPq+aV4rL+8jpTMhMQDzKY8Zu81+Kws93wZ1SOvF8XcAgU+NI8jOs8j6vz4SoHboehwAerqBY3gSKNsApNlWpK+aLBYYK5+nFhKkoUpIeRJlqIwPuEM4vcPbERonOVaR1XClIWJbFD7XvakHBc=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SN4PR10MB5557.namprd10.prod.outlook.com (2603:10b6:806:200::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.15; Wed, 14 Aug
 2024 14:52:08 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7875.016; Wed, 14 Aug 2024
 14:52:08 +0000
To: Keith Busch <kbusch@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>, linux-xfs@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-raid@vger.kernel.org, hch@lst.de, axboe@kernel.dk,
        martin.petersen@oracle.com
Subject: Re: [bug report] raid0 array mkfs.xfs hang
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <ZrzDP5c7bRyh7UnE@kbusch-mbp> (Keith Busch's message of "Wed, 14
	Aug 2024 08:46:23 -0600")
Organization: Oracle Corporation
Message-ID: <yq1wmkjtb1t.fsf@ca-mkp.ca.oracle.com>
References: <8292cfd7-eb9c-4ca7-8eec-321b3738857b@oracle.com>
	<4d31268f-310b-4220-88a2-e191c3932a82@oracle.com>
	<ea82050f-f5a4-457d-8603-2f279237c8be@oracle.com>
	<ZrzDP5c7bRyh7UnE@kbusch-mbp>
Date: Wed, 14 Aug 2024 10:52:05 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0073.namprd05.prod.outlook.com
 (2603:10b6:a03:332::18) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SN4PR10MB5557:EE_
X-MS-Office365-Filtering-Correlation-Id: c2309e63-393c-419e-8aaa-08dcbc70ab9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yXf7AGMSGX2EI7uoKhKkU6G7d30XUXD/prlksHQQXh9mGQhSymI2tSQBn1On?=
 =?us-ascii?Q?MZTxMzxyFuz+Q7/Z67DFnM7cjDpmMz68wn2D5OjlPYqUzVVA6tdvVQ1DhimX?=
 =?us-ascii?Q?a5g/zEAdQljwsUwDN70hY9XK/EgYAU1BFy8v68XVXNesbyDWdIwbGBQTjEcJ?=
 =?us-ascii?Q?ipYu+Zj6zCyrndAkA4gbXJ4raDt72jQgpQ0GmUFNtVUuaHzGBRUrIFXiu/Nr?=
 =?us-ascii?Q?uhqMe8T8YVwcA9MQGl9fG+UEnRoyvQYVr6c2ZCrwrkEgyK2v2lZtGBCJA4yO?=
 =?us-ascii?Q?8XdNDlM/pYxxDbsIbaS7viybjkxNnT5TBzOZrtiTwAfKkT40DQLAPrhJ4WWY?=
 =?us-ascii?Q?avl/tFoaRnpgFyLUmblCfK4+ewg4XqQc6HD+4og3mVMP5Fv6lGVkCPGJWssJ?=
 =?us-ascii?Q?JxqTuNR3kxPCh5tUpjjjAvP8K27u75zV9E7GovLy7uP0D2mcWHijWXwxy9v0?=
 =?us-ascii?Q?NLEPvnOW1zR85DSPNzwpzS3CleGzGIP4ioJFfKpno3pdgzxV2lPZ4zS02zs/?=
 =?us-ascii?Q?kvYlOVbqQz0vW/Aqd33XN+/OYRzq3c3bgZDAv02MyHDs76LE56UEYyufGa+1?=
 =?us-ascii?Q?pr8Bf3CxhapB4nisi9xiRTfwxCVrZxojeX401Ar4MX+77E4a2wph9gzcqbIg?=
 =?us-ascii?Q?DF0JFQntd0rmzb33eNx6MLprDtMOXn/BX0YrQYB0oB28t6gmoV5flCAGZPdu?=
 =?us-ascii?Q?fAwE4Uk9Ldksmw15usEeTJBxzAwo95q+tdqXjMk7nN0J9Cec16PfXBTjTaMs?=
 =?us-ascii?Q?W+FekDDSJAE9L1HuyrVF8ziHy1M1BGcsWQvXHZIPIQdDhWk6m/RHyOkUzVzg?=
 =?us-ascii?Q?jd7CFYFDwutaZrI2nckTAbVpsh9EUNrF4FAeJZ04cLdDD1Rwv4SSwL8EmNH4?=
 =?us-ascii?Q?WHQz9S5IEQfbl5MhHXQ30u9RbnpZhGbrw+LvF8KMqY16+dMWfW7muvn/Xztb?=
 =?us-ascii?Q?NExb8WBjwvEhlDv1uAtQJeJkwW0G0a6ZbnUHMn33eLZMuW8oQwYnnYC0MbLx?=
 =?us-ascii?Q?fd7P10jInmGkGbtBcXTql7Rtz2z7d4uq4oWWOwG8JqEIolBM+Jin710EI9+O?=
 =?us-ascii?Q?QNWjxy7/4EIyznZmuixprIv79JJC7VR0OXV+zvfXRte29UvU1FgqusZQzBP4?=
 =?us-ascii?Q?aD6N6NFn9fHq749XcOjD5qMU4/bwyHNEGO2tT5WdsBcB9RWt8GKJ24JX/JZU?=
 =?us-ascii?Q?ypSeKJTyXPT66skamQjMOaNGPN6QGe+l9v7G8DvWdFf9u/9bQ+XCemHtycS5?=
 =?us-ascii?Q?0z/pV97QPwLQMZhJKqgZ2KutT/7QepEcTPJOFq+VAUUhv+aroW8qnIJP9vJf?=
 =?us-ascii?Q?/tQ0VaW0NKArw9eEj2R/q8ERvBoaqYl1TBPG597BY0cmKw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8sIQAqKttjRIzHuFd1lWV8Q5KgmPfPtHZEyPvfcQ8v4M20T6+oih3+wW3oNl?=
 =?us-ascii?Q?241FVeOyHfsVfruIS9FJnJ8Zc8ZS/pHm7Drv0sWnnaO/i0vTiZP/aVwjp94C?=
 =?us-ascii?Q?kW6ZosveOGPbdEyKzmgoRj/HIyq2RkGMLByb73Z9C+1XP3Rq6snAaW1m1MTK?=
 =?us-ascii?Q?LlF+A0hSUKHIsud6bzkqQWNVD7rp7KpspW2D6NCGjsjBbyNh8rFC4/tsCvVf?=
 =?us-ascii?Q?gij1sDXel8coirnPzyGBXuS0dgpcDImSAlK2BrD2MaVmlJVHs+I5S+a5RoA8?=
 =?us-ascii?Q?hGHCo9bUO/UZaqZ+DEsB/bRZNP1s5JgtQHTTIBKH9Bpfsn8xOILTSxWtgXg4?=
 =?us-ascii?Q?NsIM73piFMFIlnb1LTCM0A8wUJ0XLL3PRpo5xWZ3k+Czq+3uiYojMkkb7nfu?=
 =?us-ascii?Q?WJeAmYSxmBvcNEH9Q/p84uTWQDycno2XjRmnlvJifnlPWIzsThgfRK/v3eI+?=
 =?us-ascii?Q?Zk3Zysf5ZZXfBJ+KT1g1VHHZ67MQipB9uXj2RJyRUVFWsTN/TaTh5+N2LnFs?=
 =?us-ascii?Q?+XsQFMRmL5ziDCxW44+oiHmRZoBmSFGFl8RMt9PAllOcFi/GWskXEG9KyM1A?=
 =?us-ascii?Q?kTeKH+xjAlv3PTnUCtHvd5vbBqu2ynza+YpoCTTfVvb8M2g3VXtViGiwie8b?=
 =?us-ascii?Q?TVDmR7TsDrX5YhJXXJyFlLGjUwYU5foTnpGM84FVeCi6fkiBbeyYH06uxqEr?=
 =?us-ascii?Q?evzFZMXlqF2Xh92LxPddLAN3Dub3/zcMGbX5EKspzB82YrsMtfnkyv8jmxpW?=
 =?us-ascii?Q?RGkx0diTCc8pjC9xyBVSjNa5kV5GhFukod6NzKPnq37ZKK79Tvjk+zHHLteM?=
 =?us-ascii?Q?QuPrUAq1wQQodRB4c7o8pPz4G5nzDghrdwhoHlElQ/jczVpJL/BYh1AARfI9?=
 =?us-ascii?Q?+Rg0052lL2WxjJtot9uVK9DhIBObsKmD9g+eyTdK+HjZ2w9G4t4OD5A6yoR9?=
 =?us-ascii?Q?Pjt5VcAQRrmtEL1+Qac+GTmkfqbrGnBknluyezqpKl0T1mCrHkL1+HUDB204?=
 =?us-ascii?Q?sHUKdWdmkNqMrIm95MqDxiyjSouARv88+PZLUrcX0AmYGsf6Ms/bkvUyGROh?=
 =?us-ascii?Q?tm59h+fxkfL6KtWD/38oqX3dsLP8z1CdYu2+Nd9upcoreO+haM42ESgbY4cV?=
 =?us-ascii?Q?mk81Z1bEX2eZsWBIEDO0EVNieETLmDAQmpZVmPpu1ra6ocXHPVNlMFLvHkWL?=
 =?us-ascii?Q?ZFeoxniDz0V5AxcNk906TqAobTwRpjGxb4yGK9YDuWfCCIKhRjVZNvbjT8r6?=
 =?us-ascii?Q?dQv95dIECIydiEM2t5BucuhGOVZARKLBa2wRB5t2UQBrO4srygZE1aJ9nn0C?=
 =?us-ascii?Q?6lvqfihsTTKPsAbPr1SPVLUl/DCFZ+AbNWQpQnGgk6hf4sokei5kVNEbg9+S?=
 =?us-ascii?Q?fUWMhupKUBpwvbUYHJn5xf9aOjoEWfKNGaB3ahKInFI15pqOGrGJO3oVSTDC?=
 =?us-ascii?Q?uxFuGwKAKOsZtuF+GVlxYOcE9MYzDIUyN5aYQwfCE4EiwiUXgCCdZaIKvtH7?=
 =?us-ascii?Q?KAgem+bBhoQtCmc1tZYeogIN9LfJxeG3dBMQzKoC5JSeOXuanpdWlUNLbupZ?=
 =?us-ascii?Q?7ZK4bjLsSSTmWccU8slGFDdqa9dHFraOMSw+g0EN+pW87GGVzvN1tBiTt7us?=
 =?us-ascii?Q?dA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	oN5o2HP0PfoGVNO17L3KOAyKzSsSJxD10whztzncSEey/RmkPOdwktTvjb3367olMD5KilbnuydSUQaj83TfIbzdkD0NVz6OW2YOBjzlDQ78XS5TT/thRNMhcGbDzZ+CkFKmkBZHguFmaWt/efDKMNjjyfz/qgIm5oUacfBHXMqRPQM5eKujnC8vO6NHkfbbgVsZb0x+TgUx3rJkSuLoyYHOizIeDAq08Aee9FVmytsYIP23JxH9mVX+qp5Q2I9Ms2wq7hh1Ugrfj67NgrK7ILfm5ikyQOO656q1f84vw+h+BCgaCH6+Gil/+fStVxvlWQrCw4EFt0ij4dd16cin0ZP1TFjRd1UzufKInePPFjX4KoC+PLNGn9J6YDiXVpbhAFnC/HOgnzxUzxOf+hjcvmAJXpVh8MumDH3OV1s10ImZMoWmrKBqLQvIcWWJ1KWdThGNtTW8/ydb733BP1T8rckQoK5LIRO3fUdUCgxM2xoJ1iyRATHYfbEld5COb231uVjl+OCzn2964OMLPbq861NB65d4t5S73mnTXwAz50BqoIcFni3dw9T5KLiLUAJVGcNtExn0XqzFKu+f5oLnHW1VeIQ2eiPg/dG3v7gQ4VM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2309e63-393c-419e-8aaa-08dcbc70ab9c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2024 14:52:08.2733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kILTKT9zyvWGRQAtxG0jvxuA9hZKATXloap6Hn7U2AA+0onlKyumE+b+nG+Zz1l3AmHSFqimZAKcCWBEsgKg3ZvCQWyCduRZk2m8xlD99eg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5557
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-14_10,2024-08-13_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 phishscore=0 malwarescore=0 suspectscore=0 spamscore=0 mlxlogscore=660
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408140104
X-Proofpoint-ORIG-GUID: gKL3xnd3YNEcp6JtayU3ekofR3vWz-qj
X-Proofpoint-GUID: gKL3xnd3YNEcp6JtayU3ekofR3vWz-qj


Keith,

> Your change looks fine, though it sounds odd that md raid is changing
> queue_limit values outside the limits_lock. The stacking limits should
> have set the md device to 0 if one of the member drives doesn't
> support write_zeroes, right?

SCSI can't reliably detect ahead of time whether a device supports WRITE
SAME. So we'll issue a WRITE SAME command and if that fails we'll set
the queue limit to 0. So it is "normal" that the limit changes at
runtime.

I'm debugging a couple of other regressions from the queue limits
shuffle so I haven't looked into this one yet. But I assume that's
what's happening.

-- 
Martin K. Petersen	Oracle Linux Engineering
