Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3053428DB7E;
	Fri, 11 Jul 2025 10:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752231240; cv=fail; b=fUHrzaacacuK1f5as/VW0ipFmummdmVwmtBcJKPSmui7YbiN5DX33ZNnJd2nYUieZ6AChcsBTFzBP8yQ5zB/NstFu/00Q10hFPNjs2wS5ErYJzuHj2zL6QRNOq+iXcefBd8TSmlq6CEN7i+mTFs2R9hGQwNc8xgOtRFzEcmEa94=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752231240; c=relaxed/simple;
	bh=uptaq2QMJloe2tkDjQPSF5oSDzKIq+ofqc4jrqobMhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gbcKuiOv9rQrJoZ8y3OyvgxYM8NT5585wR6mnkt7dHQZPkcT/SkZApBcpfnLnplKmqadQzcKbb/blMOsO3l1iIACVGnutBc1Yd9+IyuFwwWeVsBTlaM5rHyZ7US4MqrZLHGXnEzSo6gsfZFGLGilZsHgdRHxZVMbACW87ZtKoJQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IH0jBzqJ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=PLhQLZGh; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IH0jBzqJ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="PLhQLZGh"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56BAgcrh002362;
	Fri, 11 Jul 2025 10:53:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=lqMqYNQd7dPRcd/CNDA0J5J0HWp126sTROKeLnnXgW4=; b=
	IH0jBzqJEIZW/uB8w7J2TvlYliVV82raLcoVmItn8+1cF1HRCmI3WtOCc/DWeDy1
	DHUdgSE5MDQnVRUWVxZ+E7az57aWdJ4XyNjXeewObTsaoU5m290fcYNe7mzzFAIp
	lKIZOfotXNxbYmlGUGttDIa3kagxswlf4djqGijA+ixigFJLW1pN/BQVokr+Km8q
	EZ6kPpf3tUUVX5k3wlkMkilmAfE9mleDaDPuTF3m0HX4kvNWyAVpLiCbfEBQp3TG
	w0Sx/eYtpoYQ4ELuFXBbq33MQKjVZYV13Uk7XkCn1W+bOxXJmRdzmQl+xM6YjaUT
	EKZjrXqhlJ6xoj1QIPUg+g==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47u13980hy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Jul 2025 10:53:40 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56BAok6f021358;
	Fri, 11 Jul 2025 10:53:39 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2087.outbound.protection.outlook.com [40.107.236.87])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ptgdd1bv-6
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Jul 2025 10:53:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iprs9JjtMAX1S91vcECtVUWlNeT8tZsHzpN2x0MGBtdJNHMsDULvvxMFvYv8n725rVQ4Mrxl6BjXEhv4uTpvmL69SycLdN1GFslHJAmnMOO40LG3WqgIUAgcxZBDMVwY1g5GoAQQNdebWF3AOCFpHz65wI0QlEIZxXhs4rh1t1+AvywJxezBnMWUy5zy2zi0CWdwZKhasyHFsxk84Lle3V1gqUOmDG3FY9n1d+aloVIQ+Qdk+ouH8w6ZceLJFT0PFbE1PNShq+LCs+iepK+jb40u57XuMJaco/1HoqoaDHoTbd73Z6c7hONN1zhdpFaaF2aljMWVpgLzzwve65CtgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lqMqYNQd7dPRcd/CNDA0J5J0HWp126sTROKeLnnXgW4=;
 b=YvkzlcvLycO4UlAITRXjvJHwzldtxg6BQe6dzSZVqXse2pjThdjlLADsn6KRjBmg8pINy4oN+rKNCZgbEgEeonB4o/nFzgN2tGCrh+nA/aSJH9077WzLp1QODvXo7ZfhfUJJMFgU4n0PbT/A59D8mp7o1XEFZhoQZRjDBwtxoHcmrYH4X5XeBWNM0MCkMB1Kqad+T1uhSwVMJ5bOZszJ46lnOW/L3XuJIb+lB+Qs4rttP3e+fNqzSq6kxO+tywb6G102+EGvk+CeXTFyVTWrgd6uZAVaxpHFtTnWKEsKTXwFASDiEIsZUfvz8abRcILKOPsV3jAC63g4t8IfsUxgaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lqMqYNQd7dPRcd/CNDA0J5J0HWp126sTROKeLnnXgW4=;
 b=PLhQLZGhtrCq1ugOYJ/Y6UKTW75lMI6/gIOQz34NboImaaJFcPObvnRiVIuXRXMZiFqjrvnnonKgdHSqS7HQUAjRw9QPm2hhAFsta00GNnFOJPmKTxYKnE/g9IhyYeNfi4/ouRx9QDCLpUEhAJbbKbSp3bl7VnD9ntAd8+j+Kqo=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by PH3PPF079E800A3.namprd10.prod.outlook.com (2603:10b6:518:1::786) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.24; Fri, 11 Jul
 2025 10:53:18 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8922.023; Fri, 11 Jul 2025
 10:53:18 +0000
From: John Garry <john.g.garry@oracle.com>
To: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
        yukuai3@huawei.com, hch@lst.de, nilay@linux.ibm.com, axboe@kernel.dk,
        cem@kernel.org
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com,
        akpm@linux-foundation.org, linux-xfs@vger.kernel.org,
        djwong@kernel.org, dlemoal@kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v7 6/6] block: use chunk_sectors when evaluating stacked atomic write limits
Date: Fri, 11 Jul 2025 10:52:58 +0000
Message-ID: <20250711105258.3135198-7-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250711105258.3135198-1-john.g.garry@oracle.com>
References: <20250711105258.3135198-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0080.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::25) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|PH3PPF079E800A3:EE_
X-MS-Office365-Filtering-Correlation-Id: 574f29e3-a88d-4735-0981-08ddc069254d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
 =?us-ascii?Q?RBTvczpgKtqyuh2lDv5LVGN2FoNz0fVqHSzrzWd7f8u0h8tygWMZ1fetPAwZ?=
 =?us-ascii?Q?x4EavLaAENF4GoXmFgnD6f9juFSa28lDOCTZ+UxiZwIavGDX6UAtefTZRkeR?=
 =?us-ascii?Q?HGxA0Q8UFFDKlroLJWUZiNJzVF1CSgC678watcZJOeYXNiEwBWx6ThLj63Mk?=
 =?us-ascii?Q?JB4KW12/wS5XhX3K1n6uXjcsYXcofm0mhsgBCGaaeK8ddEwZNdMR03OD8Vuk?=
 =?us-ascii?Q?yE4qrUx0PY4fVwV3SyHHIGMOrQyT7ZeOcdUfBxaoOAY64lkgMlhrfp0/fNT3?=
 =?us-ascii?Q?wpq035trHULZ3xrrrwI9rS5otmB/3pfd02wfFQboCCN+FF4x2Brgxl9uNqFI?=
 =?us-ascii?Q?Dg+6+iYHaG808xu9xxID4t8RLWJXGoDwhf1rjQYPQmk+I/qYivmciW6neyw1?=
 =?us-ascii?Q?i4liOZ8ZtIUk1mhppd/5eeGIEcbacVqUXFZz0ijr34kYxpl67V1N7v6G2nu4?=
 =?us-ascii?Q?b3ibkeX4OPncMYQMTrzRqan/e3PhFFcHZcl0TY81Jti7cBJ7V8bETT1EAqVI?=
 =?us-ascii?Q?oTlt1/GLkwfj0sdVtAUZCpq2gswgHIDBOYrGSqdlpsyzdXt9vwURR8sMl+XU?=
 =?us-ascii?Q?zYlKIN9Fu8NzXumoBry3CQyFSn5YyqoT9owsa9uPouXxTwkcwPwxOpeam5s8?=
 =?us-ascii?Q?0WkLlH9ek1Y+nnDENoXWy1S6uqmbsXL2OoDJgVZTx9WcCrCr0jgkJYIeNQ0R?=
 =?us-ascii?Q?+siI8W2m+nFJsFMWo9oeUxRbBghY2KK/mQMmImnViPKlVqzhYCkUiAfXTgiE?=
 =?us-ascii?Q?4YHbpTIpPBy1MgS6kolIvWdo5+UlNpC+/IId+fwEE2DVHQttEe2w1jAqQYNw?=
 =?us-ascii?Q?ILwyqLXQpwx9uSOSDJD+B7MtoEG+As/DAmGU4MBCEmgv9Zh+gExcr9k9DdXg?=
 =?us-ascii?Q?BEbLnQJr5Utlcod3+BhrIpiOv1dQDEIRIdzJn/uUOS5r3Fh/TwszHV/c0tjP?=
 =?us-ascii?Q?tC4Rm6uRDg7ctFLJJJ6VQ9jWI6kVg2MM2rHS4glA1pmslQBPVwqASj3X1DEx?=
 =?us-ascii?Q?QsmkhfXZDht9qw7WkR7WntVLyi6mzFTnMWHFnYt8+dYEHxXRLV1V4syQ8KhC?=
 =?us-ascii?Q?7WgGnVgqDjUd8xrIGFImw4x8X6ZwN7xpzzXeWBPSD0sCzOxyVf05u6p2cg1s?=
 =?us-ascii?Q?dMgKJRHQqtDSl4FlHpRtiVU98qAldwCzLnWvaswZLAAU3a+YI6nXvCp/moFK?=
 =?us-ascii?Q?Wd/tWLUXGHvEAVIo7qmHWODN1zHq+paWFg6Vz40UJ7INzCnEkHbBdefD0D9Q?=
 =?us-ascii?Q?i53bF424kPYz3Zklym8JJrLylhnyUUZHjvJSOubTagZGILnljtSilk1b7iyI?=
 =?us-ascii?Q?XR5l+rYdKSufXwr4Qz8teCD7orYsHVEnnfy0+wDwrxGl7/NbvEG2ItbypybA?=
 =?us-ascii?Q?kXPF6SUsPeaSNtvHhSs7a8KfBEo8?=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?mbAIgXk2XZPugUblluJs1RO8vLDkQLCqGXEDYCxvzOIm1Yww/jLXKDekNJy8?=
 =?us-ascii?Q?+H3SjRVuEh1p5PKBwBXpPEW5waXX+VFd0bQkHtLOcSfF/+tVZMjsb3hBV4mB?=
 =?us-ascii?Q?9F/JB+kn+1Ffcu3Susrnn4lJ/rF0C/7EAo+gPEeoxl9R+VTj4JvN6mlWWeFN?=
 =?us-ascii?Q?eOp8ldKbxogSvFtDQcCxb1asATsF5Tru8wrpe6zRHS/H1eJAoUJs/eHI2XFI?=
 =?us-ascii?Q?VXHoIDm6bbm8079USigkORVsYvUdQ55laph+SHffvbX3QzbFVvCLjT5BjD8n?=
 =?us-ascii?Q?LILheNtg9MGUUDE3xIdQ+TL9PGuu8jdn1S5zbBl3VHauAN/zowVa165oL+k8?=
 =?us-ascii?Q?F5GfWRUo4+C8ioHyr4r0+G9RighMH4HTONFq8HRSDd8VHfWuJK2Gmb+vBEmj?=
 =?us-ascii?Q?tHjVuriznd8Wt5K7pTTcKdzkdKBgtqJuMatN9uPrzcOqMjOvqtG4l9cZlZKT?=
 =?us-ascii?Q?TDRL9ouqafK5kT9VZYE8VYA9yfH4mMFbZujOPqSlYQsl8KupmII21/fc+84i?=
 =?us-ascii?Q?qgNr3tuS/axjggvbb1vSNVHd9ZiqCQoDTW5NVHIuVEu3j8DsnMvqvQW8JPHP?=
 =?us-ascii?Q?+7rQsGNl9iOwKvYYpH2zOLLPe75XwWHmqhcy7jJmb0XZryYD3cMsaWRdcD/H?=
 =?us-ascii?Q?WXnUGHKooO1uHIhBmvg3aiNbViz/nGyk27NukO2XwZz07SNYSLP2bM8fPe7T?=
 =?us-ascii?Q?mwi+S6Dmu3vtMqEW6j/wEFpEGpi+/DJquSDErTBswXnKQYzNE72JCMWnIK3i?=
 =?us-ascii?Q?8OP4Go50e9sgXrtChGFBv3TeG+fJ/cscSu5gLdJx0DHWJWexG6OpB6ZFrGEu?=
 =?us-ascii?Q?TDgeJ88gpL7NoUpe4w53mI6OIuRgZIvgcCvI64pd19KXCQoFXAG8Al8ZGv4j?=
 =?us-ascii?Q?YUGjjgrMp0NwssOkArieOIDZEquSwdwP5WMd3330PQWwKQwnqbIMYNinTVh+?=
 =?us-ascii?Q?Goy/ceALJ06GubNBzesByCRqz2eMeQCse8NHf93LOqmdGm/Ho5aY71ai8CVV?=
 =?us-ascii?Q?lZyzOo4c1sUBatzG7wZTPlwUzhkOBc5tBDuasSaLIST+XYfdmI1CzmRoY4pQ?=
 =?us-ascii?Q?GHh6FyZuVvyb6n4Z16b4dRC2kgkEw1k7W6AEGmRzt2uMsO6dAv8+8Zypum4w?=
 =?us-ascii?Q?YkUym1C79uVFmS00bP8+xxsfR4wArcA/dJyvt2HDLrbE2Jh0nHdTfDew/Ma4?=
 =?us-ascii?Q?VK96eYrD0AIysZ58tY2vnK4ZX90X1kI2qd4it2H8ZlCfitXIrov5IYDgdJ7m?=
 =?us-ascii?Q?j8Zf00/sFS4mgE/ShfiuIq3iHa9znyesUcjqKCttMXMKO5AQSJfml6eMO1x8?=
 =?us-ascii?Q?AaOlQDbNuW6izzjHY4k3cTgosxWXSiWoaIDxLCmy2uBqD6kx2MOJ1feQay2C?=
 =?us-ascii?Q?x4jyLyuWX0OJ/AI7Rx5uw7T0JiE4wR6Pyyrikkk7LcusfaEqjSkwxNJ7YTBX?=
 =?us-ascii?Q?Wp+G1a11g+8sAY/IkRncRXfZMz2w95dnMJ8L1ITX2gD733YSiNsjsVeIZfm6?=
 =?us-ascii?Q?gkoNg7NgGH6BcBUgI8xsolVwPJWpKofn6556y0pIffQKqAWsJ+r0ZyBkjiPu?=
 =?us-ascii?Q?ob9vMIxpxh8xw+XLBtkna2QAJ+x+7yNJQkora8EcgixC/AtldzxdIDiuoEF0?=
 =?us-ascii?Q?+Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
 OaWiugLPNAyIF8lDPfGtm2jxhnAtSaa4tZsdes5HEoubhb4gThJEVArm9yun9wwOGCmJCLmibkyiljb613YSPbFuZ+INqi5X8mPC2qJ7RfrNRgLI9vkJQEcOwhKDC+bYXCf3JRG9stBhJNh0rN2ApuR2hD8bMXu9GQy9xpr7hA7s4mCh2FPFhEtpWNLyfzdncc9nHXYrSFeElF/XI5FlNbpAYoTi9BFxiz3B1aQb2kkY+XnpYekufnXu261UUA6c06SyB1WXFCy6IFHLKZFEHBG7lPBejtrMvAz0ruFjFSYF4WP9EiBBZvHL7/Xm3KWdG/UwMtbhMnIJTYFrVmQq8wSgCNaOsA82wVxWtInHj8lw1uI5fPI6tK1pScujvczzeKXBac3rk1a85MF8jWFBu0BwH7SUrdnISrxemDu24SBaf9lfl9syer50pz0n64+ST5LilScD+UK/UzWx6ZDDqL9DcnljwtfhAcTrHaHOl3ZHQ5pW44sY11qYytJR4GPNMqcqrI1auCzUOh6mSfG5jNoT5e5Yq9SycOden4hcp3fBfOLD0Y6Uixpzpnxwf7A8DwEgXvfHywZ9tBv7VrRmDP3tp0CoX0tN7YUgrz+TwUI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 574f29e3-a88d-4735-0981-08ddc069254d
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2025 10:53:18.8129
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6ima0KAzveRy1jPcypBvP7V/KUtEoTN9S09K0lvogxmOyKFLREdVFTxro0sVTOPkHySqsaHz3lSnXOHfzNBVXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF079E800A3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-11_03,2025-07-09_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507110077
X-Proofpoint-GUID: o3e5BGJUFrq3Yl3EgFHlZ29O-YRP49qV
X-Proofpoint-ORIG-GUID: o3e5BGJUFrq3Yl3EgFHlZ29O-YRP49qV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzExMDA3NyBTYWx0ZWRfX/sm6tmI/U++P CNDWGFNTR2mkEMQjjfFWTwY3iq3LvIaimrB/IFL65l8ZyY0FjNqnKO8Jc480Vz3GMUQL7DZKFIp B1atG1xegP4A4I+QVRMyKP8sGFpWgHIRZk9j7yb3jKnvGJJYYjYPEQxVXpb8snIAJKb+N2/SnrB
 bqV8D7UB5NoI6PQowBWHeF/Ch87MoXln78v3n/MzDmWwC4IkmD9wtUoXKN2XPZpfvgkxIQZgFGM EzwIRoXwJ8+yUW849XkHadUX/n9UJmvLZGrylZ0szNayiR71/AV4HB96H9BzRlLdJQLEiH4iCPK 0O+rAxgrFLfC3x7PUcqUKCKOSCRKNQgqJiRQLLcU6mvuoUsVOh/4UuYDUkMFQ26XYiEYrrkWr5D
 n6LqZpqJl5cGiEfieYwdjyz1ETwHq7vZ7QNm+1VbEhQkDO2lhN11ZAmNF9/U4p7Qx72UoSgB
X-Authority-Analysis: v=2.4 cv=bPoWIO+Z c=1 sm=1 tr=0 ts=6870ed34 cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=yPCof4ZbAAAA:8 a=Vx6Y8ZnjGDVhUwe7cXkA:9

The atomic write unit max value is limited by any stacked device stripe
size.

It is required that the atomic write unit is a power-of-2 factor of the
stripe size.

Currently we use io_min limit to hold the stripe size, and check for a
io_min <= SECTOR_SIZE when deciding if we have a striped stacked device.

Nilay reports that this causes a problem when the physical block size is
greater than SECTOR_SIZE [0].

Furthermore, io_min may be mutated when stacking devices, and this makes
it a poor candidate to hold the stripe size. Such an example (of when
io_min may change) would be when the io_min is less than the physical
block size.

Use chunk_sectors to hold the stripe size, which is more appropriate.

[0] https://lore.kernel.org/linux-block/888f3b1d-7817-4007-b3b3-1a2ea04df771@linux.ibm.com/T/#mecca17129f72811137d3c2f1e477634e77f06781

Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Tested-by: Nilay Shroff <nilay@linux.ibm.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 block/blk-settings.c | 56 ++++++++++++++++++++++++++------------------
 1 file changed, 33 insertions(+), 23 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 3425ae1b1f014..a6ac293f47e34 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -595,41 +595,50 @@ static bool blk_stack_atomic_writes_boundary_head(struct queue_limits *t,
 	return true;
 }
 
-
-/* Check stacking of first bottom device */
-static bool blk_stack_atomic_writes_head(struct queue_limits *t,
-				struct queue_limits *b)
+static void blk_stack_atomic_writes_chunk_sectors(struct queue_limits *t)
 {
-	if (b->atomic_write_hw_boundary &&
-	    !blk_stack_atomic_writes_boundary_head(t, b))
-		return false;
+	unsigned int chunk_bytes;
 
-	if (t->io_min <= SECTOR_SIZE) {
-		/* No chunk sectors, so use bottom device values directly */
-		t->atomic_write_hw_unit_max = b->atomic_write_hw_unit_max;
-		t->atomic_write_hw_unit_min = b->atomic_write_hw_unit_min;
-		t->atomic_write_hw_max = b->atomic_write_hw_max;
-		return true;
-	}
+	if (!t->chunk_sectors)
+		return;
+
+	/*
+	 * If chunk sectors is so large that its value in bytes overflows
+	 * UINT_MAX, then just shift it down so it definitely will fit.
+	 * We don't support atomic writes of such a large size anyway.
+	 */
+	if (check_shl_overflow(t->chunk_sectors, SECTOR_SHIFT, &chunk_bytes))
+		chunk_bytes = t->chunk_sectors;
 
 	/*
 	 * Find values for limits which work for chunk size.
 	 * b->atomic_write_hw_unit_{min, max} may not be aligned with chunk
-	 * size (t->io_min), as chunk size is not restricted to a power-of-2.
+	 * size, as the chunk size is not restricted to a power-of-2.
 	 * So we need to find highest power-of-2 which works for the chunk
 	 * size.
-	 * As an example scenario, we could have b->unit_max = 16K and
-	 * t->io_min = 24K. For this case, reduce t->unit_max to a value
-	 * aligned with both limits, i.e. 8K in this example.
+	 * As an example scenario, we could have t->unit_max = 16K and
+	 * t->chunk_sectors = 24KB. For this case, reduce t->unit_max to a
+	 * value aligned with both limits, i.e. 8K in this example.
 	 */
-	t->atomic_write_hw_unit_max = b->atomic_write_hw_unit_max;
-	while (t->io_min % t->atomic_write_hw_unit_max)
-		t->atomic_write_hw_unit_max /= 2;
+	t->atomic_write_hw_unit_max = min(t->atomic_write_hw_unit_max,
+					max_pow_of_two_factor(chunk_bytes));
 
-	t->atomic_write_hw_unit_min = min(b->atomic_write_hw_unit_min,
+	t->atomic_write_hw_unit_min = min(t->atomic_write_hw_unit_min,
 					  t->atomic_write_hw_unit_max);
-	t->atomic_write_hw_max = min(b->atomic_write_hw_max, t->io_min);
+	t->atomic_write_hw_max = min(t->atomic_write_hw_max, chunk_bytes);
+}
+
+/* Check stacking of first bottom device */
+static bool blk_stack_atomic_writes_head(struct queue_limits *t,
+				struct queue_limits *b)
+{
+	if (b->atomic_write_hw_boundary &&
+	    !blk_stack_atomic_writes_boundary_head(t, b))
+		return false;
 
+	t->atomic_write_hw_unit_max = b->atomic_write_hw_unit_max;
+	t->atomic_write_hw_unit_min = b->atomic_write_hw_unit_min;
+	t->atomic_write_hw_max = b->atomic_write_hw_max;
 	return true;
 }
 
@@ -657,6 +666,7 @@ static void blk_stack_atomic_writes_limits(struct queue_limits *t,
 
 	if (!blk_stack_atomic_writes_head(t, b))
 		goto unsupported;
+	blk_stack_atomic_writes_chunk_sectors(t);
 	return;
 
 unsupported:
-- 
2.43.5

