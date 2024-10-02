Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8941D1E74
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 17:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727890903; cv=fail; b=DTpzCU/mtEfPvHap7ZwjNnxa1RJl7AaYZmPymWkQOqpgq2jnF4wxokt4Fig9XirqUIKMMUj8zJZlf0YP5MFYiddfTBBW+8uH1E8zE8N4B5dhYtWImk6UU8LUe7XGFK+UPN+JsUk/3e3a96uM8CTOs55AvQ8Knlc3bvXFzIRmh6s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727890903; c=relaxed/simple;
	bh=0pO8LRFYcs3eC1IL/tC92mfu1i0wgVsXqRQuvkdhc6o=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HIkYSy76m1bBkWKv0C1ZOBB9+nDdsMs/OpsL7HpdDdLsPpPsp66+syLoujrDOlU66rqzED7NYaz8icKBymX704W/PEIDYmZaYTdoRVq7PXV757VDq7+CNSRsrIyOzI2Rh9C3eFkYn6xc41CCm4ICZQ6QS72IFDmmjscKFmsm46w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=G014u3hp; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=giQhSD04; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="G014u3hp";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="giQhSD04"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 492HfcNZ025762
	for <linux-xfs@vger.kernel.org>; Wed, 2 Oct 2024 17:41:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=8vPeoGYpWBPk6nMZYHMDQuBtB+EYkoFtitP444h0jg0=; b=
	G014u3hptTcNX+XcZH5qh34sbkZyqWBtm3BYCKjr08ihdmBdm1brgntnNt2DADHi
	wgjgYgSNrtlILE9oPnRg4CSm6k9T5GmFyoDOh8+tQ4CKI2TmOjMbXLKs0tkAALX4
	84AgQji60vZVuSktUUv3i4AH1gMMqc6FTxQw5KzP7CMkDm7Oj2MeLV09hpDObid0
	l86dbQBz2aPwNWJ9wREOROIF9GtNEpT+nIyTmFuwdZ0fgizzUJwKe5ex3wQazyP/
	qkuxZ0mGIXjYvts2U1FvVFkcliIFURALDrbYMaf9h8RROVVyLae/mqPRF4d1uqDX
	dP3zkMVCNdSwC1Qy41w90Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41x8qba84f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 02 Oct 2024 17:41:40 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 492HKrad028403
	for <linux-xfs@vger.kernel.org>; Wed, 2 Oct 2024 17:41:40 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2046.outbound.protection.outlook.com [104.47.73.46])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41x889d48j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 02 Oct 2024 17:41:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B88NvnNPAWkw8JC3xhiB86yPoGK+c3qHXKSRVjPe7oo50qO4Z8JMfyTT171LqzPCqaDp1m4xBCB0tHu8MRVj3jmwLJNPa1Cl09d1b1omHboatdBVbnyHGtB+4l+uV7nq+YeHx+TkOPovh77/86B+bdAKf7PUY+ClNVy8Rcc5ZmtCMeyaFDM0puoQoLnzmds50xIQKHk/rNibWbYVztw7SO+u/hvyv+KZ/CpOMMjkS8eS2JMl0EHiYa7n5cCuy0nrTv5prUsXVe7M1DM0IrGXwdg6fJCA5VUON9KfkmsFEES1xsFqq9/uTUjZThU1pfddT2cSj5jaexpOe+z28/eUrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8vPeoGYpWBPk6nMZYHMDQuBtB+EYkoFtitP444h0jg0=;
 b=NafNnMatsAkFAWpCJdG4T62OD5drK2yLuXirDledRY0JkflSqSfQ3C646WgkgcQ/YlOULjd6GQHBkxBvftv79PafbbvAxmqk8QxM337hxI1bxjHfbuAUB9wbfjrwsMnm94WFHpbr4MgiJxAAhJ/qcu1sLNLgxvMcG1mi4DY0+BNObs1SHLbC6EEfdNiIhEMC0hy6SkiJCGTxwmm/JxpRfILoNRFlJbxy5MpMkuIJiJSOjNT8NqK2EAT2MhEeyJffmGQ/swzIditiVlnwMNV1vcIqq4JgDFupB0n1JbQiHGdYBYLAjaAbEmwCsJubXvrAZQwNEJB/zzCk3uVqz0wdiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8vPeoGYpWBPk6nMZYHMDQuBtB+EYkoFtitP444h0jg0=;
 b=giQhSD040Yx/q2yvteyS0pFR6viwRWlkF+kFKJfROUgn/3QkO6X9Cd+f8w/pXKRWjOL0ZSD0E0cQHNsPijOXO9Wjj/cpSf6w8hmWAUhU3QgpHgvheqrRKN9mGnuMZk6YtrySeLcNhqANKG57bNQW1uDfAmzkasICR5/QxNJU68U=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BLAPR10MB4995.namprd10.prod.outlook.com (2603:10b6:208:333::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.16; Wed, 2 Oct
 2024 17:41:37 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.8026.016; Wed, 2 Oct 2024
 17:41:37 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v2 14/21] xfs: make xfs_bmapi_convert_delalloc() to allocate the target offset
Date: Wed,  2 Oct 2024 10:41:01 -0700
Message-Id: <20241002174108.64615-15-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241002174108.64615-1-catherine.hoang@oracle.com>
References: <20241002174108.64615-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0028.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::33) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|BLAPR10MB4995:EE_
X-MS-Office365-Filtering-Correlation-Id: 204bba56-3fbd-4922-2085-08dce3097741
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|10070799003|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?AV15+I8YMPT0XG3irWxOXc2aWx8iVeR1Y/LYP+cST82gvdQf3+xWzZ8Thk5X?=
 =?us-ascii?Q?saT6PjlB+ryisLaPRPg1bnzO8rdJPEtfOTC52dmG7U9s4RDXP1vckY2fWnnn?=
 =?us-ascii?Q?eaWQJlu+fw6yLPqfIzHqnnEU24Rl7lVzMzgl/H0npjxGJ43HBA8+3tJvBLPT?=
 =?us-ascii?Q?KhcuT10y/XIFeuD0VbgP+1PhYSUYl8qaqTyj41A9R8E92GZt6bex+puU4Yx1?=
 =?us-ascii?Q?Nm4AKttxvoAC+PT0GOe+aZTfL8WdB4Bou9U/Tq0oDQ76nyZIACCa8SSiIAHX?=
 =?us-ascii?Q?gRDFHzA2Oy1q/LXSqN5uq+C667u4ZNZZwmhSahtK/zxYY+C/gseSXM83fIOq?=
 =?us-ascii?Q?DURQk766a2luRBcns6dsNnSr7E8vq0o1uBMwN1I5QXqHyiG1375WNd2rEpeR?=
 =?us-ascii?Q?rhXUUsgOQAmCcdgFIMjadCZT2GQBFVmWb6gyPl5jC+BDkiQD30mlHFbpSWqU?=
 =?us-ascii?Q?k4TjnkhzyQInr+HuKFkXxNhq0iUhoDPvcOnLOVsDWku/35eAz65GGJGrFOvZ?=
 =?us-ascii?Q?Y0alYnL9AK/lvd1XXfrDGJ1+DWVK9MnUxpRJCeXHdYzdp1S9SJQ8So01gYe7?=
 =?us-ascii?Q?Fd3EbAnSu2RJR3RHB+gF9paAZBxTOIMT7YItQia7wqWhB1/yF6Ku2lJfeOqF?=
 =?us-ascii?Q?SG9eEz8qziBbJZ8z8zu72h4G6MkI8S/gWPQUXbeDNRXtwlEYH4YAIloruEz7?=
 =?us-ascii?Q?bz/69k0z80VARxqV+4fZ8I8T61l8SOIDuWhlT89PTK3ghnNnxKE8HIoFEIRw?=
 =?us-ascii?Q?IXo88KJUho59U4Ja8snDC9JDqr9OxHk/jXmmVB7OnPPcesb5Lyz4quKYVuhZ?=
 =?us-ascii?Q?op0RD8u2gIwLcwtS4duDxAtzLZ0a8ZhZ4yEI6wdBogA8CkRV2Hd9ir/Jhbbg?=
 =?us-ascii?Q?4h2SSRXQLdLm3qK+XZJICF2N4HAJ6oHztxx0R+hntuKHtKJzcPU3pT9kLScC?=
 =?us-ascii?Q?XGFiYQ5UBfm9HD1fsRuDLGN8zWZ5+c3jF7kC7VR2jHIaNrlQ4glfLEJJrbnU?=
 =?us-ascii?Q?IAa8C1So22kTVVMHtLnaUDBklb+2B6WmfD7QCTQ4CkbBzDCmMRqIQPRSSS1y?=
 =?us-ascii?Q?omPKBfQdgc5U0+eqHHzXAUDwZnG3GStXiT5e2pTvVKrbI8K7lLnUaHpwLSvL?=
 =?us-ascii?Q?wVVbrPCa/cTmDfnILjChukb/lCriW62xCXmuwrGOVBPVF6/9s3Uc7Yg56NPz?=
 =?us-ascii?Q?MXaW0vXWVDMyfZIzmzQGQ7n369WWRdm2mf9BKosqOchAc/u3zLanrGseJean?=
 =?us-ascii?Q?To3sZ1ehssVX1I6pl26dB4j7w0MGBSXqOs+UzCAYfA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(10070799003)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KHMSeOe+0TtFraa3tqBj1r4Hpye1jhJYqUJqqM2R5Re9C4xShMSuji7prc2n?=
 =?us-ascii?Q?jOWclXmhVWHJc/4AYwUTzz9TLizJe6plTnTUdmvHspqiKs3bO++U1zZqi/IV?=
 =?us-ascii?Q?00Sjaa3IAqGgx3q2YAeej+jVNuBapmfm+lUAXPxIxMyiVCwxVil9bMumSL7i?=
 =?us-ascii?Q?O8H5EWxRpxIkHFYVtbnvsEKRTThoiPfj9IZ8HlrvDOX1BfwuKfuarrJ+L1RO?=
 =?us-ascii?Q?mdQqRdN+/U6LpBQbLfdyUq3aGCVSNjpf5PoXV2+7ROS8oMWJphkCIOC4TfEI?=
 =?us-ascii?Q?/zNduxeeeZJq5+yPeKBeM0I+o+tpBs9A8SidthpkkMS4EvuP32G/ORTvzwUL?=
 =?us-ascii?Q?Tj/kQwlzyGDZUyyg2HyZx1qBvxCz7TPlif7TVh1S38/3gQyFKyU8uF4I4gAe?=
 =?us-ascii?Q?Ho16TdbgNMGOxlfngEiYs9kp2j5njRjj+t9yw/xWRSW/zuPuj+Csc0roTEqQ?=
 =?us-ascii?Q?38kPEV6HlLqei9YmbraQJZNJON2mk44lkRvfhOOBI1nyK7Q+SJqk1FgTs0H5?=
 =?us-ascii?Q?sdXqmHZoRZ8q/pHnwVYx5D6JFR+iVwE5qrB+GuBc0qLO/PjnKysNA5O0Rqmk?=
 =?us-ascii?Q?PsXM/gL3xJ9Iz8xpLSAU7FabStkhV1Qto59cAnk0afLCkwd2ji8Vb/cnGO7B?=
 =?us-ascii?Q?igxfrZior/nJSxNF81gkXPm7Lv5vQdgiadQBgMMcvC+QB6lM3FgY+UhFb5IY?=
 =?us-ascii?Q?Ieiu3rljjKKIN65T3RCsk0z08wcFYmyoK4Q5uTmXnhAFQTJSsXlwTNc+3Phh?=
 =?us-ascii?Q?1uhCT+zYBbgSjYGE8hc1YJOziiwZYnoEapLNiPj6YdpUKtYXYdBbJuKlPaxN?=
 =?us-ascii?Q?G5aovXTThaNN3rT0Uaw/zYgdZVOmjex1Wudgg8jIW/0L50RL2n7KrhYQOqSA?=
 =?us-ascii?Q?gt8/QLFxwFuJMgf/I3kDXxXK/fhd6ke7tR2FS9NlpHK5VK0Y4fjoa+8rQM5T?=
 =?us-ascii?Q?9fQDaiiVjnnVQMG7+9BXlRTlTLQZPJOtdW5wbLdtfysA85KztE1kacR1Lbh3?=
 =?us-ascii?Q?6UKTGfAVZ5vetQKLimHS6aJUWclghtqxMzDJqXyTCaqsBYtZN3CXemw5clcU?=
 =?us-ascii?Q?5z4XFTAbJQ3DgDy6cgJln9Deez0xSFlmWhRnHy9MV/6SmWcU7sflBa5UlBMx?=
 =?us-ascii?Q?fEVV2ogKaWDE5hS+5rsGN10mfKM/0HTlYq8bAfK0boARf3948IQoT+PBXjkj?=
 =?us-ascii?Q?Xmk/iIRahLOCuCkLShEqbXmuO9VDpwJKHHjAHgwgy4PYyCqfHpVCQvUjpuzY?=
 =?us-ascii?Q?L7rC1khK3AURKNJE2Ol/o73om4m3BBBsbiLr+srboLwPZ+eVV4jFAqlSl7TA?=
 =?us-ascii?Q?IgK6z959PKF/CwCMCQrTgTZjToWNdeCsrceWYtr4AXybxQFKru0mQbW9uzth?=
 =?us-ascii?Q?6nCh8h4ZrgtncfhknjUnT5IcpA/zdOJEFIHeO0yVSetKwvRVCOni27T7PeYv?=
 =?us-ascii?Q?UNjYWeihTgzqgIkyPkGaIQQxsWF86uV7cNjwLj4t+qtTV0wpQAWv+vNJt/XW?=
 =?us-ascii?Q?umUYtUgqmpKnbSiz9NKC7vXXTbgWqp3WcWUzalbr5uk5vVm+Ig/4n+mrRks/?=
 =?us-ascii?Q?zAWz/H+uZfeG/VcUanKCKdOlyjPT7JcP5PMPF+ZjUVb9vSQu851/Xplg0pTf?=
 =?us-ascii?Q?WTzvhsjSDUbdn2O9aslVH+Dr6qEWChXpZtoHtrQXPlAGrz0X6pUFNtJsbFdC?=
 =?us-ascii?Q?4QVG/w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	l3gXwfXdI5PJHmmbRPOzRtgZcuFenEY05iZw6NwAiG40f5VbxJd+THWzAZGooaC3fS+aAuSB+GUbkYf08j6fDrv9BrCaK2Z1j1NdsnNGrMa/T3eRo/YRNsPsIsm0Dc5Cn7t5Xc+7sjKjAjm64Ml+bkSogFzcHmbYRr6eOl8bU5J0YwJ0ipVA8Sca9epcX3296Yr/GjxL+YCjB79FdTwwgjM6sGkTqHFYlelOvfOCvp7rdhjXRVzH+Npc+yveBgBF/xmu1TinQ1X0JkYlz0Yy5DdhTHvo2dS7lFeLKT1xdMNN9YSv/VAZJJA3YDJWaGitPDfiSbvRzLuXlzSpNBKp7p79P5Ilp3RdObKpLPBDslpaLiVcsOz/bknJmoCPeMllSw2BOifMYb4iyVEDpiSht8NT8Z9pEoW+H4qLQ6HatYLW+5QLt0pGmqyYUVKbSq6SpgN7ar/Cnpyj1fWna4t6IqvnKX4L89ixhD0TWPwvH3cP7IsmyAnJJb5vh0wu5eP5SdQgWMYODdDfe8NVMyg8GevzxVYCLtZdKowNManPajh3uroFkkxkyObFYF3HYB/Ruts0VByvdhzlFsL26kZ2VnpDPNmMj9ddAN6ru3H4YFU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 204bba56-3fbd-4922-2085-08dce3097741
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2024 17:41:37.6129
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S9FeiktBpFHN1RY3LfxerGSYHexXYZt9rKYIZRYWYoF8vIRB1xCeTeoeUs6e+5IQjNQCuqqptYEfHtnadBbJgkAafXmsRyNaCWPKnAg8VCc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4995
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-02_17,2024-09-30_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2410020127
X-Proofpoint-GUID: aljiIYu1mgwxsf30l6uZ2BPrhXQtkFBl
X-Proofpoint-ORIG-GUID: aljiIYu1mgwxsf30l6uZ2BPrhXQtkFBl

From: Zhang Yi <yi.zhang@huawei.com>

commit 2e08371a83f1c06fd85eea8cd37c87a224cc4cc4 upstream.

Since xfs_bmapi_convert_delalloc() only attempts to allocate the entire
delalloc extent and require multiple invocations to allocate the target
offset. So xfs_convert_blocks() add a loop to do this job and we call it
in the write back path, but xfs_convert_blocks() isn't a common helper.
Let's do it in xfs_bmapi_convert_delalloc() and drop
xfs_convert_blocks(), preparing for the post EOF delalloc blocks
converting in the buffered write begin path.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 34 +++++++++++++++++++++++--
 fs/xfs/xfs_aops.c        | 54 +++++++++++-----------------------------
 2 files changed, 46 insertions(+), 42 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 6ef2c2681248..05e36a745920 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4537,8 +4537,8 @@ xfs_bmapi_write(
  * invocations to allocate the target offset if a large enough physical extent
  * is not available.
  */
-int
-xfs_bmapi_convert_delalloc(
+static int
+xfs_bmapi_convert_one_delalloc(
 	struct xfs_inode	*ip,
 	int			whichfork,
 	xfs_off_t		offset,
@@ -4666,6 +4666,36 @@ xfs_bmapi_convert_delalloc(
 	return error;
 }
 
+/*
+ * Pass in a dellalloc extent and convert it to real extents, return the real
+ * extent that maps offset_fsb in iomap.
+ */
+int
+xfs_bmapi_convert_delalloc(
+	struct xfs_inode	*ip,
+	int			whichfork,
+	loff_t			offset,
+	struct iomap		*iomap,
+	unsigned int		*seq)
+{
+	int			error;
+
+	/*
+	 * Attempt to allocate whatever delalloc extent currently backs offset
+	 * and put the result into iomap.  Allocate in a loop because it may
+	 * take several attempts to allocate real blocks for a contiguous
+	 * delalloc extent if free space is sufficiently fragmented.
+	 */
+	do {
+		error = xfs_bmapi_convert_one_delalloc(ip, whichfork, offset,
+					iomap, seq);
+		if (error)
+			return error;
+	} while (iomap->offset + iomap->length <= offset);
+
+	return 0;
+}
+
 int
 xfs_bmapi_remap(
 	struct xfs_trans	*tp,
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index e74097e58097..688ac031d3a1 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -233,45 +233,6 @@ xfs_imap_valid(
 	return true;
 }
 
-/*
- * Pass in a dellalloc extent and convert it to real extents, return the real
- * extent that maps offset_fsb in wpc->iomap.
- *
- * The current page is held locked so nothing could have removed the block
- * backing offset_fsb, although it could have moved from the COW to the data
- * fork by another thread.
- */
-static int
-xfs_convert_blocks(
-	struct iomap_writepage_ctx *wpc,
-	struct xfs_inode	*ip,
-	int			whichfork,
-	loff_t			offset)
-{
-	int			error;
-	unsigned		*seq;
-
-	if (whichfork == XFS_COW_FORK)
-		seq = &XFS_WPC(wpc)->cow_seq;
-	else
-		seq = &XFS_WPC(wpc)->data_seq;
-
-	/*
-	 * Attempt to allocate whatever delalloc extent currently backs offset
-	 * and put the result into wpc->iomap.  Allocate in a loop because it
-	 * may take several attempts to allocate real blocks for a contiguous
-	 * delalloc extent if free space is sufficiently fragmented.
-	 */
-	do {
-		error = xfs_bmapi_convert_delalloc(ip, whichfork, offset,
-				&wpc->iomap, seq);
-		if (error)
-			return error;
-	} while (wpc->iomap.offset + wpc->iomap.length <= offset);
-
-	return 0;
-}
-
 static int
 xfs_map_blocks(
 	struct iomap_writepage_ctx *wpc,
@@ -289,6 +250,7 @@ xfs_map_blocks(
 	struct xfs_iext_cursor	icur;
 	int			retries = 0;
 	int			error = 0;
+	unsigned int		*seq;
 
 	if (xfs_is_shutdown(mp))
 		return -EIO;
@@ -386,7 +348,19 @@ xfs_map_blocks(
 	trace_xfs_map_blocks_found(ip, offset, count, whichfork, &imap);
 	return 0;
 allocate_blocks:
-	error = xfs_convert_blocks(wpc, ip, whichfork, offset);
+	/*
+	 * Convert a dellalloc extent to a real one. The current page is held
+	 * locked so nothing could have removed the block backing offset_fsb,
+	 * although it could have moved from the COW to the data fork by another
+	 * thread.
+	 */
+	if (whichfork == XFS_COW_FORK)
+		seq = &XFS_WPC(wpc)->cow_seq;
+	else
+		seq = &XFS_WPC(wpc)->data_seq;
+
+	error = xfs_bmapi_convert_delalloc(ip, whichfork, offset,
+				&wpc->iomap, seq);
 	if (error) {
 		/*
 		 * If we failed to find the extent in the COW fork we might have
-- 
2.39.3

