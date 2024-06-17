Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D213B176AB9;
	Mon, 17 Jun 2024 23:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718665446; cv=fail; b=IPhVR0O95sqlIutoKZngW8KCUCTIpLKVp8p/tDzuT3nGzsOXs6nSgWYz0RvoPgyYVrTZLKhU4V/qdinNROBZzNkdQXm7oTUy/vD0yB54R2bT0Gak7F32Sz+wnfDGM4DHpRC2U/q0yi3LsAgvw/KBURqFtT8/vlbY0QqUFQkRCSo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718665446; c=relaxed/simple;
	bh=4NypV6vQTcfaBg0v6sjr/ENzVRmgXvXyau8nOeNmef8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=V9Ep+vhzQZNsPERxL1xLdvRNpHlU4nS/V0xCWII4rrf6oQT9Bql03RxdcaDq3bFW595SroHqeT4oHZKt6KsbqRjMjfOEq22kjBTcDck7X2iOLiO8CEE7hSAkX2fRhitqZ98bJlessoDbz4V1QtBTOIyopFcOJdwoQejaBINNZog=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IoTCUU1/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=hiP3HtEK; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IoTCUU1/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hiP3HtEK"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45HMY2q1010689;
	Mon, 17 Jun 2024 23:04:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=S46iQvJdllqfPwDoRxNgNCm274X+LIaeZ9fZn/Jj9wQ=; b=
	IoTCUU1/2qgzcibz6gZ9Ettyp/IlQreP60trE9IXOJswa2s/lORjVxMKFLeexMzE
	8rRGQH8arcOiZdM/aHqXsPxrU2eRKkjg32GBjHHQ4jMcPfZTdM/LfkmmCjp5+03T
	4n15h+11k3FZI16nNi5KwGdj4pdomRaLPQL7Dkfl0EstyXAZHe8WlQ9Q074YZWyN
	p634SjnEJzog9hwCYQ3q0z/gm06YLuHniIvwkqzYAogevisOGK/QP74m8cauD4bZ
	jJXczEJddefEklzBuZD0CCcv7RkBHeGempg1DZIxKnmOHFD5f3Hr3eFTzX4z/DyY
	CH04Wc/2EFDYSGMGuyOC9Q==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ys2u8kpyk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Jun 2024 23:04:04 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45HMFgo4031869;
	Mon, 17 Jun 2024 23:04:03 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ys1d73jy0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Jun 2024 23:04:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kr4Njur2LI0otGjawuHtHk04O4yFHXwXhkHa2Ii1qF2dltUgQolkcm82BcvNJRWwKjpuRaMTaKlOPxCeq5yMaNp8/ZcGVZpR1E0HEfioQ9o+lwBBVUI3FCLD5I9Pra2nLnc0l47hEb8wTER4n0u+bMcvnAT7M6WfAjTXRS1t8pvgEoxOkijJSAkKiHhvcQjUeaEVqVhvwlXBPtufXICTbTGOuEr7nM22PihWVdBHYbHv7ArflbqVEv8Sz40zYEVuZktukHNFj8BVlyVohfckC4DDPdbflIjKUPSlBW1IaL+Bhq6bnRZqvdH36p9HhiatHCqnKmbK3DiGA27mi8r8BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S46iQvJdllqfPwDoRxNgNCm274X+LIaeZ9fZn/Jj9wQ=;
 b=cxKCZgn+MKEpwNW08BZPpxjP0bZX0Jdd9EeOSXLrQ/LhG8x3Tbp24q1xqiiQIf4QIOmigK8utWgAOGakFW2QII28Fys0Nj5pOeqVRqD4vPux/HlvB4Fcwoj3JYiLLMCRHLeyp2mySOSxEkxnG8zutmj1HjQgBJRIOschBvZopsZqQz/X49ZHzOhNuKW2lVO5hkBcSoHszxb3BMwn3xah9AETYhE8EuCiPEM6BvwOQjVvUkupDDAZpgzq/p6UL7YNHZXN9OvwFmG94wha25IdThx2XnexxsH3LX3j+iXV7alJA1g3NQHVn29zEEZlOQnE/pCf8zVW4Oex6l/WtkVzvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S46iQvJdllqfPwDoRxNgNCm274X+LIaeZ9fZn/Jj9wQ=;
 b=hiP3HtEK3mm+xvqNHlWl6XH+UeEND2CrdKSpsU/9hFNlT+R+W1Xkbc/XyUET0G1E4ycNxwT6fjgEuQ25k7+RMFq07350yRtHUXybamtgdHqaCJMt+TQsTV89YPXDOXjM5GSXGJsKL0APCwaRFZEVBvUXv/ke4e5svqp1b2NO3tQ=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DS0PR10MB7398.namprd10.prod.outlook.com (2603:10b6:8:135::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.30; Mon, 17 Jun
 2024 23:04:01 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%5]) with mapi id 15.20.7677.030; Mon, 17 Jun 2024
 23:04:01 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 2/8] xfs: fix scrub stats file permissions
Date: Mon, 17 Jun 2024 16:03:49 -0700
Message-Id: <20240617230355.77091-3-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20240617230355.77091-1-catherine.hoang@oracle.com>
References: <20240617230355.77091-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0355.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::30) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|DS0PR10MB7398:EE_
X-MS-Office365-Filtering-Correlation-Id: 7414d64b-af2c-49ed-a14a-08dc8f21c6dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|366013|1800799021|376011;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?+tDWtWtCR7ZIR7JEspfaWFIGcNpRFnU2RF1qxypJbOxHcHTbhWbLcQM5Zh1t?=
 =?us-ascii?Q?tR9QuWCgy8/JryucRuMAOZ6hX3mkf77K/MNVfpz/tl2CFm0V/FV+kQwhuSD8?=
 =?us-ascii?Q?VzhWrEERMSS8H1VdApzxoAB1VyXd0ZdN13b3WTF8ns4nMm/RGo8hB8FNMOTq?=
 =?us-ascii?Q?h/aX8QB5mZ1ElcswKeastmS8pdgcRGCEEZ2dtsiDMmE76b9fkhNfdjwPSgHo?=
 =?us-ascii?Q?Bakqj3v7ZPSpOkChj7SqcEDqIw6RVBtBFIDcM9WbWfqSc0e9Mk+QeZL9AGef?=
 =?us-ascii?Q?B0dPpHeD/mjpyGYOjJacoLUOUI3ztXtgnr0HYAA1Nl9YdsfMXyAZWR8J3/jY?=
 =?us-ascii?Q?xIu4qLNFaWLXFNt/luNPUeiR7j0vyvklS/i5ZksUilmwsLkq4geQ0xFvoszm?=
 =?us-ascii?Q?hZZbA5/hAR2iqmXTM4sep1jypP0wsraCkf5cKMAmpI7II9/0BhtfHPoZ8a2D?=
 =?us-ascii?Q?XAFhR922zfIvqQgZANKhFKXpePnarCf1Tg5pW34mSyEHjD8i96Ww97poedyf?=
 =?us-ascii?Q?8ucgGcHwdXTFwM498UjHd9QN4U5n9hLH7CX12J1vBi+s/iuvwGOLNBumo/50?=
 =?us-ascii?Q?+MKCRDrqnGkLgGmQR/TduK20kn1hjDwzPJlFqKWJEqZFPFxepkRHHOh092t2?=
 =?us-ascii?Q?RmrpDsli4D/tnwBHVU0b6ibhirK8z5rWd0gce3eXKwAGuHNC0ExCXzgUriOn?=
 =?us-ascii?Q?XCJd7fBgm5yxFBNOJw6JcRbWgBO+yqpl5KvEAVQQBV12jcUYCpI7fGVJHf0e?=
 =?us-ascii?Q?aJFuwSA82Jie5bt73giNf7iLZf58rlfYpdweIWmvfFNnAPqZWTnibokleYEX?=
 =?us-ascii?Q?lTzpGeYISdbKIWYLZPZSyqGqWvgFwzymNsxwEuq6ldhoK7zH2ZAFYpC0Zn8O?=
 =?us-ascii?Q?vOuNUqWtl5DWRu1UcofQRvCTpvYXc4pyrOZBoZVNHejgDoWiX+Ep9i/sz+lP?=
 =?us-ascii?Q?KdrRXqr7YQ/Mm8XtPaTHVyPZCneNAxpKwywTSAU6d3m3OwMar6RNakTxWptv?=
 =?us-ascii?Q?vb6pp7ZbGX3X4+w7Yrbsr02FWqXr27Ug4VuuOnuPWfDTyeJXOo7hGoA1FEoB?=
 =?us-ascii?Q?W6q7LAaWGEeJTmsQcd8wekkxBM0/ERclYon1BG5hjZ9pIS+KC3lyamDiiMxm?=
 =?us-ascii?Q?oHs/RXb9guOQOwajzacgkdBaWrR22CewtdfT/gPacB26QhiRiUyC52QFloM7?=
 =?us-ascii?Q?GCJyBHRVFNSVc8TnbPNndGeonNEHHnmKNnLmV78cFB+RuSPXc/p736kcqe9F?=
 =?us-ascii?Q?TABt6AXvIbEz6zjf1ma4zcWwXW5iZ2hE/V+JDoZm5dTbT8LGGnhEDzl/+6Uo?=
 =?us-ascii?Q?0gAoUOdFeydqJZ4ZQ4XKbkqw?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(1800799021)(376011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?C8UWFohBldwxVnO9b1fwQ4purTtNeM7hW3M1qkhb8QIfepn7gdPfvSJY3TIF?=
 =?us-ascii?Q?9UsqdoDt4NJjdJR7FdrAQQJ8eMldSlhcqkrO2H50Vr5PGJ8M8spy0XoRlao2?=
 =?us-ascii?Q?Xe9IdQ53t+R4Db99HML1z3fwA3fjTL77UwhA8TAcd2XKx/IOpI4b/nw+j0Q8?=
 =?us-ascii?Q?rJ+4IkMAshEIeoX6caFpRVwp3O6T1Y2ffSz2nOncCkp7mnIsqWkSbwMXUmTu?=
 =?us-ascii?Q?WfKNgE+Mw9dcwXSisTGLu4hvOX6SRAUEZhRRluECPqwO9CNLS4rq6s7Y66qO?=
 =?us-ascii?Q?yD8Fqq/Q17jEyyXudiTMFoZEBxLtCKLq1+U+cSx81PjFIcHbRF+MwSOIRDGm?=
 =?us-ascii?Q?gGYV2jktySjZQWttn+Rcjuw8l5XjAzZ/A5mDG50QbZfQXWzM7uQC5xxkRpax?=
 =?us-ascii?Q?1T6KQk5oiQt7dUwJMtXHcT98frDCOWUkX4RnO5EI61o0I2t3UIMQ8wqDUdCA?=
 =?us-ascii?Q?B/smPa6vm67G/VOMlhCPjkjUbREQ51Hn85u9G5HvyxVk4sNaCUSXRHMikKm2?=
 =?us-ascii?Q?kk4U6Jyl2wntemFBSBD0Q+RESRYeeNEqm43WQxxEWVgQh1xYzNT8WFS6QSN+?=
 =?us-ascii?Q?9rhsZE4mWyXeAbMEEF/cR2Fo/4DSK/eSXDIc0MeZrpAZUvWlyYo9Ynb13srE?=
 =?us-ascii?Q?zxZlfUJvVVGpopVmoMdS9O1uSZmIiFvm46qshhxq/d+VmHrv4E7xJZpi3uAZ?=
 =?us-ascii?Q?fGLJmgegOEF2eGIVzqVFTouTulxrkBfXzkhK8yOpv2qY/TN49WK7RRETKzCL?=
 =?us-ascii?Q?x9vN9qMZXRjfL/91bF0ID7rKtssaIlsXnjg8DkLJstSbqEfUwe6xbWhU8KM1?=
 =?us-ascii?Q?74yuYZp3X/Ey+r/HoI/3EaMMZ8yVKQHXx7qqtwCFFY1AsnVbLSDPcQ7juCQJ?=
 =?us-ascii?Q?PofB6TLA1LaXkTcVuOHwd5g2UaiC828X866u8iUEiTjIZ8/lFKGe6Gf3hleQ?=
 =?us-ascii?Q?Hun3TW+N2n5MbHh4uaWRKdT3WiyWHb6Gu1UZLvDKJRWRJaYERN+o95/aG7Oh?=
 =?us-ascii?Q?zLhbzpS5aaF3I86b+EHPqcyTVX1a9JGVp43dfp8eX88EAf0UByi/CwyzORZw?=
 =?us-ascii?Q?gWfwOhFjA7eWq3/KMBm2Np0GNEmZpNzCVF5HHbtngMjydvHAVmKqVinRMWOC?=
 =?us-ascii?Q?mmkxMB114Fne+nyA/yLz2xCc2NpvErapD+jQoZyNBCKxMZVB/JERoeL+jfpv?=
 =?us-ascii?Q?/+YH4Xcu2WbYGQjQXW94XiZ5e3Tc/Eza4KY/ukp8hhmXTzcK+0cfs3XXSgBI?=
 =?us-ascii?Q?Z29yoLRaEWyHJSBJW9A4tLKV3df9r6O0usIa+WXFlzz5OfkIucl9KQtjdpKt?=
 =?us-ascii?Q?iL/TbpHX7W2IqNuzUN+Ozqs6jdApMiS6vGym3DeRLFcLPF/4kXPedI5+p85D?=
 =?us-ascii?Q?XEuskLm+L+6ZLGQ8nI8d1/52Ap6MJme87PgNif+8NbI83/EHgEOdHznNtXqE?=
 =?us-ascii?Q?V/e4JyWaI1rhLqRPMGMyO9mNqjy/JSddWMzm5weQ5Ja9fUyYW09ZC/4Lbnxf?=
 =?us-ascii?Q?6Fpz4HYKBbFFZTfNYmoKgw2lSYldFGoEdyzGZEM2pkSAJ7SjpOh68zQzaPHc?=
 =?us-ascii?Q?b+uphUO4kKkW1LEJg2vcWS23bYoVG8NLJaROdzK2bdA+Et5y1y3UFstE6wZh?=
 =?us-ascii?Q?pyRIPOnmvduSOe70k6kFs7oCHuoEKns3ZFLQoCJQGwuqmoNe6EfFyNZR7FBV?=
 =?us-ascii?Q?0gpupw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	nEvQSXUy3LjA2m9dd8eV95TDQbsdaZqxYYxe8hHAltwIHI/cQfzVR97fg5bMcNIaKn44bTk2ycbKc+d5PyAwmskOusOz8rtufLiL0YHHfwLj1gR2ye50cxjvKoDvCqCz76G6YhQScD+s72bPs2JAB9zVl7sMjJmyu01DeCzIfj2cEhXy3mTeV5TnVEqZjz5JpxJS9J2zJMXFinvcNBwuraHRK+PXZOh18zle0SUcWZWra+bSOHulPH3FMOxYUHm6Ys5JvNZO6P5ZsBSB5qecKphnxvlKTAlJvldhuWxtddTr2Ip9SMvXqx0f56E2cdZCmXEJB5+e79aEZ1legf3GSj31cRFG060871W6Faa5wuenmEz+RkGw786/kq6AkGljyW6jUEgmWpq+zUJRPZ9rXac/v3JLE90032Hwe9R4FlV475llHt3+gAAXNiEmdTuveFl/ZbeWzTnGfTg4CjwUqML5vvZAsoFhV1kxMzheSnA11s3e0CTbCNrzhpjGw2GzAcGLW8UepagtWz0sDVkft5r9Xq9Z1PTh3mwD0gKKpyzgKzVJnZBXe8zW9B+vKlOOG0ceb2hMOus86j9/QJPWrOnuXWmpd0AvaXiRpYY4JXc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7414d64b-af2c-49ed-a14a-08dc8f21c6dd
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2024 23:04:01.4431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 11l5+QIuLRnhudXPf0j7VBbxlVS/L68nMtnbX57EW4+qZmkITnOl+nZ5Gp685b4rFATFO8feuYtTSjco1kRyjPlG1V5mh5nn+TZVc5k2jx8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7398
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-17_14,2024-06-17_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406170179
X-Proofpoint-GUID: yPWXas82jIlmx2LlbsEfdlt_9QIF5Pnk
X-Proofpoint-ORIG-GUID: yPWXas82jIlmx2LlbsEfdlt_9QIF5Pnk

From: "Darrick J. Wong" <djwong@kernel.org>

commit e610e856b938a1fc86e7ee83ad2f39716082bca7 upstream.

When the kernel is in lockdown mode, debugfs will only show files that
are world-readable and cannot be written, mmaped, or used with ioctl.
That more or less describes the scrub stats file, except that the
permissions are wrong -- they should be 0444, not 0644.  You can't write
the stats file, so the 0200 makes no sense.

Meanwhile, the clear_stats file is only writable, but it got mode 0400
instead of 0200, which would make more sense.

Fix both files so that they make sense.

Fixes: d7a74cad8f451 ("xfs: track usage statistics of online fsck")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/stats.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/scrub/stats.c b/fs/xfs/scrub/stats.c
index cd91db4a5548..82499270e20b 100644
--- a/fs/xfs/scrub/stats.c
+++ b/fs/xfs/scrub/stats.c
@@ -329,9 +329,9 @@ xchk_stats_register(
 	if (!cs->cs_debugfs)
 		return;
 
-	debugfs_create_file("stats", 0644, cs->cs_debugfs, cs,
+	debugfs_create_file("stats", 0444, cs->cs_debugfs, cs,
 			&scrub_stats_fops);
-	debugfs_create_file("clear_stats", 0400, cs->cs_debugfs, cs,
+	debugfs_create_file("clear_stats", 0200, cs->cs_debugfs, cs,
 			&clear_scrub_stats_fops);
 }
 
-- 
2.39.3

