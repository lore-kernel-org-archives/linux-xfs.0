Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EE4320E316;
	Wed,  5 Feb 2025 03:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738724916; cv=fail; b=Nhg8EO8kyvErNBSYa5TLhF2kgykbSGnAP6C2IWesorThLdfh45as+AzhmG4ZCjhJ6eXLq4irvND3ZRwWv+Q3YAkhWP9eiyOJ+IssG9zlWme0WDC7YEENFSd/eFp96evtzBrK3XrtZncK0gvUwxZTEHBbiVJrnWucFG+U3fCyaj4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738724916; c=relaxed/simple;
	bh=N3c+oveD5QNlhKxsoSdIv893QRH6vhIYCn/n2yKdxTo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ht1J8ICfo9A3kNtFDUUWej4ypZSeC4Ew2qbrMPJV0lggJJFs7Z7HDL7wG9rXiOHq3GGghcG6H2sldIFpxZwMTqQ4B5StfO+C7BgGhbUcrSCxZ6o371M6DWRe8iPlGmNw8LoRMWR2fvcYJJy9IpzHt5FesiRaE/wYjlipc1QbF2I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cQ1v1TUj; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=UbgmuZO5; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cQ1v1TUj";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="UbgmuZO5"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 514NBotM031267;
	Wed, 5 Feb 2025 03:08:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=C28klUhfi7BlWLUnS+Gvu4IYvOiSp243/FnWM1mbwLg=; b=
	cQ1v1TUjgTQHiKvLVmEHEr0lP3FJQj1e0Qtd8JdyFyEtxgS8q7nv1h5WU4cqUJ+j
	FRUBkPRF1AFn1/PW9hmXJSBhOKnmWQK1j+Pf5N/GW6MbITmbgR0Slv3MQo0bp4Mk
	B+xLhuRivge3S9/rXFcsoLybl45BwD4/IptXvVb5enPO9RDsOpjyO3MrAmHlOkic
	mOEmhKHOmnqXQePWOeLqedXzJnbGcql167Usyl9wYShvxe2HTHpy5ym1Lm4VCRcn
	1dy+UamnSg/vicIUlW/TE/bi4HqUl6woYCzoF/AamFrwAkqB6axic683BZMCl1kZ
	G/jZu/+wXiKnSnsCn23hNg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44kckxj3re-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 03:08:33 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51513YxB037839;
	Wed, 5 Feb 2025 03:08:32 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44j8ghsnev-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 03:08:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nj9N64X6WsXPLEO+29Q/sKZzacT/o45XZ4VKbheGnfR/zQRPH0yaiNmT9KDx4tS35hpOJQb0Asjs1TTwrYegyHCqs/i66ZbhAbZog/cRzywzM5l3nYvxUn0zMPaxe6OSIJP3E7jXY8I2JXoTHIQpsGMfAIgAgGK50uet/MJ+y469PLmTHzS1ZlexnFasCa0FgqLzdaMnpb0jkYNMN84cMoHJe6/Os+RYUS6fv5snX56eVYxz4BiPHwlysb3E31c5JADj5S9zqm/DjxgdOu1yEYSvZDjJVrLZZRYtSsKWInuZfHnvrAlk4Ex/i0JJt88ZgxQW7dvrGYoCZfN6PWipjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C28klUhfi7BlWLUnS+Gvu4IYvOiSp243/FnWM1mbwLg=;
 b=psJFZxYIPWdRh1uxSMWWoKGIYgoW6XZLGMpjWFmaZogUU/u+ziLfn2/IkiwqxEzxfWYbv5l2ydQb0SEBN0ECgFdKj+7nG+wviNPgjj7/qbo27in/onZuHZO95lJTJPoJ6+rn4AFoqwkP3HNf8wdWdUMJqRU9iX95mh/Gz2NXYcdA9eJAccvVlFPXO9fOd2TePXwHX6a1b1WppfyDCmA4IRsTyTxelfTZglyQpeuPSmH1ClvQU0YkJ8ciPFG11AR39rxl3uSPalbjidVKES9sfvuGNC0BwCE7CILO89V0LCO1Uj7ncgRYMVfSZLzzBDwQv1oq01Gutt/TnImmf3G8lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C28klUhfi7BlWLUnS+Gvu4IYvOiSp243/FnWM1mbwLg=;
 b=UbgmuZO51QExzuc5YvAu3jNqtU/X+znv0tHJXX8JIzQvUDZZ1otkloVgVqs0aAFVaze1gr7SUclgoN9GmBtf11wjuNpukrZELIOJt6M8iVHLUIMJDisXw0nAOt8+NW5hoq6ImBVnNMEfCB4orD8A5KANFGjAtuEL/C2eX0h5ip0=
Received: from DS7PR10MB5327.namprd10.prod.outlook.com (2603:10b6:5:3b1::15)
 by MW5PR10MB5689.namprd10.prod.outlook.com (2603:10b6:303:19a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.25; Wed, 5 Feb
 2025 03:08:31 +0000
Received: from DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::43e7:5b82:9069:b402]) by DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::43e7:5b82:9069:b402%7]) with mapi id 15.20.8398.021; Wed, 5 Feb 2025
 03:08:31 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: xfs-stable@lists.linux.dev
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 20/24] xfs: don't use __GFP_RETRY_MAYFAIL in xfs_initialize_perag
Date: Tue,  4 Feb 2025 19:07:28 -0800
Message-Id: <20250205030732.29546-21-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20250205030732.29546-1-catherine.hoang@oracle.com>
References: <20250205030732.29546-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0020.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::25) To DS7PR10MB5327.namprd10.prod.outlook.com
 (2603:10b6:5:3b1::15)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5327:EE_|MW5PR10MB5689:EE_
X-MS-Office365-Filtering-Correlation-Id: 704f840d-d1d1-48f0-5b38-08dd45925ec0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|10070799003|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oFtnc3L8Q4l+4OlE29N4X0pfUFNbc88xOZQgkxy1xKL4LLBcAqBhYgD7QErG?=
 =?us-ascii?Q?F7CTcEBFqvV24fF8zgP672eu059c3uCljBMnK3CI87ZOJ3GEfiTpWH/8LlSJ?=
 =?us-ascii?Q?GU9hRz9A35mgIGARZK8QxvDxABJkK4FOOkv/V/1bwp5vxvgkp6aX55+xfdE6?=
 =?us-ascii?Q?4iHl7RnFmnDqZ/s85J1CO6PjX/gliykG3W4f12rF7stB59CYWs4LRZrNzpv8?=
 =?us-ascii?Q?Q/lNyalTc1kHR9PjuXi5uuK3Y0g6E9ziB3iN8azNfNUcuxnpuk6zpx2nngIb?=
 =?us-ascii?Q?Kl0755UMiBMdpN7pQA2A+9JT42suidmPzTCH/BoRUL2mj6l0gzJg22hT3i2n?=
 =?us-ascii?Q?E4EpXTBaM5SLQCptetWb07K5ygdxPCodKDbmA7ZHTlS4CHUeb+x0qs1mI/K8?=
 =?us-ascii?Q?H6iWKvTAqXs1ueYYkdAEXkNdPRMKCe2KzJnVKs3mF33nbn6jn3liINyucM6o?=
 =?us-ascii?Q?z6hiUnRY+mrDbFMC0LWp7xRCKTsw4MjA2YgbLhu13lxFPombRyLpYVbgmpDY?=
 =?us-ascii?Q?M3UmrE7F9Q2O8kHDECOLH0FMuyPpXK4d23pIoVvUDHW0EZ+hn4jz9NVI4fcD?=
 =?us-ascii?Q?W3VIecOn3BNpX5YMB+4xKK3HZZUe1Kg6cim5mpS2gASQTwvrcLm/wf7ozGnZ?=
 =?us-ascii?Q?f2GVpkEFb5yC5LsZbsZm4P7WzQNGKwfG14QWIo9IhCXknG2DwduwgevR/5iF?=
 =?us-ascii?Q?7Q67bkJnZRL0wvV+LQdSvvzgBVsJAgBq2JL+wJYk/dy4c40OeFhxM9BazyLY?=
 =?us-ascii?Q?dtEO1Np2Ruik0cWLWHPs7DZuJVUqhhdnq8yEIn55Ravlu5qyjpY1JCnoAkD3?=
 =?us-ascii?Q?hD5ecBHeglvnQm/4tAo+xbHnOjOsBuTmhhUO9Y1QMp5F+90vJCRUzLycYIcT?=
 =?us-ascii?Q?TLY8MuBexNeIlQJnb96Q10ujvt6Xh6GmGyj081aCQHmi5QfQohoMXVfZSwrg?=
 =?us-ascii?Q?nLpUlpyQlYIID/9ejL6YCEkeG7FFOMsAdjIfkpvwnX5Mu3ME/q0U9uB8YXM+?=
 =?us-ascii?Q?yy+PnygMfEKUQMq4S0BKs12q47AxI4EQpUEW6PTu1k8bYbyECZb9Aaz4Gti5?=
 =?us-ascii?Q?1P0Qlr5oLKgU0fEo0Uqt4RFloU3hJlHpz/KdMA3MnYSxC4yq/X92Iy4u6dvY?=
 =?us-ascii?Q?zBANp48Afhvi0LcZirMp3vVuReHsVU0cpLhAwXaGxuihfxUVF7YGIwauH4Ac?=
 =?us-ascii?Q?T+wKgtiVZxc9PCDSQNLt+73C0tOanc/3Og4UT5UTR7gwzEW5Rn6ct8T8VrXf?=
 =?us-ascii?Q?NjgFnyTG3l7aM94MbggK7Ohv/DlhddhZqUTK2XRcDRQVZD+qOnvrvA7Cp+yK?=
 =?us-ascii?Q?E5KEqTgPOgo8N6z4QAs/7FgrP6s92sq6K5pMYX3D451FJdzr90QUL+5jBP07?=
 =?us-ascii?Q?kFrdvnfTOb8+GZeX0s5ekRwS4wHt?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5327.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XDfLuM+DvnuBCyh7iy7d7SZt54FA0sRRka/VIbnQilMIsXBebbjyQu2ZpnAP?=
 =?us-ascii?Q?K2B2TPMuf43ijuJWqGniGh67MY39wOEQMsSTJ/Trwvgt8x6g7UeUmLaH4mpQ?=
 =?us-ascii?Q?a+qLhGT0qv1mk97BpWngyzb2rK/IsrI6qgMAxgJPUgD1l+qYHn0vvaDtX3fc?=
 =?us-ascii?Q?VtV6s1LT+YBev8yEAiJBMRrE8XZc1sINWinCT6fr1KZNEOjBVYKNsc6ZzYQk?=
 =?us-ascii?Q?B5ztBFXtKdlcc2O8VykSknd70l+By9s/pcRCn4MbjM0Apk8x9Oiv4Shtb9RA?=
 =?us-ascii?Q?f4RCuzD+oxVJ3NXMzDSINF+UAB7CKst0FdoNJ+P8FfIgp4s4m7+2LMlg1sMX?=
 =?us-ascii?Q?mQHc7lVGPSIszLi/tv05wlNyCIkoIv6VyiG2IRwVlfA+Rn2EuZsIvx9Unb6M?=
 =?us-ascii?Q?tBt65EveNT+lM7Y5i51qkWnF1uRh+RiSTysa3QkElVjMlW1NRBiNC+phOy+L?=
 =?us-ascii?Q?LtR5c8KbvDTF1gT7vz9R/xCth27j40UsDJQY/1gmE5Qsrii6WLjrmd4/PGAy?=
 =?us-ascii?Q?XfrXYjcYZZ8zI0RKrR8+plpY7KushzmXVXjrr2uDdcKjkATHL2cjfu8kLi7j?=
 =?us-ascii?Q?fXv1/X7FQnuKg2mNGvMHR2cxaBjtY1MhxVuIUPkT5e3AixEPGMfVacbnWmue?=
 =?us-ascii?Q?BAUzOCLwqrEWKCOgbcsAJzC6kGalrKjMRiIo4Yl8Skan/WoJaXiTz+ChUXXt?=
 =?us-ascii?Q?FJdiOEiSFLFwxT+q7/HM2InALcEMUXN/zFV2nI4ArqADl3JGaeoLOIHXjuDU?=
 =?us-ascii?Q?POGsre21ZcbH6eGK4Brq7ENeLNlW/eXc0rpCApyKLwUn+qRkhbQZEmA1GRVS?=
 =?us-ascii?Q?w0dotVwcsUnJq8jDhr1+E3m7j55mP05GUhJz3MNFxuvNNjKzmdgjL/UQDFn7?=
 =?us-ascii?Q?rI7PEThVfBZnHsjB3EcVWyNc21AYeDyVxEcuXISCfrfI3ZKNMI/RI6shI2p6?=
 =?us-ascii?Q?23O6/7cvAgIi8C+vXBnPZdr2wPob9eZ8htbkol1jNstIIA+93R2jdNUK+xS+?=
 =?us-ascii?Q?o8+5pKF2yV3ZOSWiJubOOiItEj5Ibtvt+FMkN2P9Xo/ZpCa7QcogWLCPYIsw?=
 =?us-ascii?Q?+fK/I5wCJ95GXgtsLMa8pYOU5KLqI+5ME/XqDAfVUDBeDWU5VQCHjRMx4oyM?=
 =?us-ascii?Q?jvmxNMoKsdPrCoe0lwWk2A4nZzglxwZndi+sjwzlRyNW7zO/LiEO80SI7nNZ?=
 =?us-ascii?Q?yA0B0eNVh7P29IFjQMMBCmAvLE2ZZr5C6ONy+p5ouFvYTGfAFdpr+ZRwzEbK?=
 =?us-ascii?Q?QSR+lZPTE3jX4zpg+LlX+gbu2uvBtdufBncUWuWXgMZnQlsl/8cIl7gJDtIN?=
 =?us-ascii?Q?bgYFssNegtA3rqDVwmXwGiygrrwZuJLmXA67Y5OrKGwf1/CDo/ZXDGAQgeHq?=
 =?us-ascii?Q?FxKg0jv2yuLzRH60R8p/MQkKuDS98elPCLkBmxM4/MsFK7NhHKJrQ8JkWYiS?=
 =?us-ascii?Q?B6tGqRkXJ1IaR0v8O4iaWIA9+3Un81F+JAOUKiTv4W8kwQ4y7EEWiMXtQ00H?=
 =?us-ascii?Q?vkR0ANCfjpMm0w3cX2VeMumlVdD9mpyM1ra70IwsPkI57krISbWMQLLWxLs5?=
 =?us-ascii?Q?L7fdPcFdZ/ABs3pEl7/8GCCW7oy1+wYCj9aQvnnEnONIZOYRuzTEiKtckwj/?=
 =?us-ascii?Q?fAynx903KeiNknZ4iyIBuBP0hfwWrSOSuqGkEQl2QwBAdMvwoNpOCK2oKMPG?=
 =?us-ascii?Q?scFs4Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VxYhA7XojYbySrBmNKVC/dorxqzHGnHoZcRuchhtCt6FAaPwQ2kqpm24feYmgVZAZ+34rvBsInG2TrtoHzBL4RSAj2xA2VtoqeLZeZYBDCmYpvsRy/wuMkRb3UEMZvQfxQgScq/SEcvljqEFdQqhL2T6xFB7Rkeog4B1Ig6FPKucfbzRy5TGxldsjxX+AKA7WUrWtTwDC4uiZAG6kMUxoidAlQ1jMwevMLKmu18HusNluJ1F+FQeuzpZUeNySkKtYB7RnKGbUv7KoFfkXob9urHqJVYf1kp/6pwCbmAWZMZR7Cxl0m7I4C0A+qeJ1GxgtWkWqUlShLZmpI7/W/Wuw2dE3gPH6Fi3vYsfYp4SVfEJwqZrCIFTLiLb6zs61/TfHopGS4W3gjHX467c/UbE4VlBxCV198a4z6Vsqet+JWzT3XDcEC2D8kIySiegGVKnh8TdMTNY5QOsisMCXNvTjuL31xXsqryCW/d8xY60u8QbYmLuARYtc8wKV/2ohS6Kqun3+5A4OzVWi2ajxwBiuU++6XhuF/A/u7Y0MI9B6kDQekNd69v3tFAlWh0Hdx9GxaqMXZgjcW13yWxrMfrNp4wU+WMWAG3EfiE3Pos/YCY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 704f840d-d1d1-48f0-5b38-08dd45925ec0
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5327.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2025 03:08:31.4745
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E2DDXLPTL46ofO8SDgZzyk6G8aCcsLBcq/wWxeDiTOlFg9ry4mslzyhu8Gm3Qz4FLhq1QrrBcFTy8vHZh5gRA9auL3w/23woW7+EBIrLRFU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5689
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-05_01,2025-02-04_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502050020
X-Proofpoint-GUID: 3o-wv2942Nfb5Q2b9zMoXCkEQohvBqHv
X-Proofpoint-ORIG-GUID: 3o-wv2942Nfb5Q2b9zMoXCkEQohvBqHv

From: Christoph Hellwig <hch@lst.de>

commit 069cf5e32b700f94c6ac60f6171662bdfb04f325 upstream.

[backport: uses kmem_zalloc instead of kzalloc]

__GFP_RETRY_MAYFAIL increases the likelyhood of allocations to fail,
which isn't really helpful during log recovery.  Remove the flag and
stick to the default GFP_KERNEL policies.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_ag.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index b75928dc1866..ec875409818d 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -370,7 +370,7 @@ xfs_initialize_perag(
 	int			error;
 
 	for (index = old_agcount; index < new_agcount; index++) {
-		pag = kmem_zalloc(sizeof(*pag), KM_MAYFAIL);
+		pag = kmem_zalloc(sizeof(*pag), 0);
 		if (!pag) {
 			error = -ENOMEM;
 			goto out_unwind_new_pags;
-- 
2.39.3

