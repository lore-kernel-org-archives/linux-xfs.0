Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6342DF68;
	Wed, 14 May 2025 00:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747182571; cv=fail; b=HT/lvgObnRZqQ7wVUHxnt/lLyqfkPm/5Cx5AzkzZlqcf+TSKgJrZBL7PP4F21dM8zDr3X7VrezoG1JSs0AXznyx1+y00cBYIpgluG+nje7IW3qNQA2uAz5FYQfMczNI0rZxNJh89uKv4gkteYKO6juRLBQXp/aysHPk+jjG26IY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747182571; c=relaxed/simple;
	bh=/uxicEKZR0n2LrrPG5hsAl1UdY4GxYLc0pP8x0ZO7IY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Q7VR9wu66Ky8pRXMn0IH4OOGiXvRRym4H8d/ngh4AlACZxv7uCN+N+i9wDsxTSS36xc3AvJRDXqQB3eyzU65btjy0BXwjB4TCLaTJjKJSeR2FycnM8bT8heyci+dq3DtZgGdiUQ7UTaOrMqPTNXsvpGopa/rK9GptWNzNNeEiic=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=A6OtqXyO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fQWvICAW; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="A6OtqXyO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fQWvICAW"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54DL0kmu027400;
	Wed, 14 May 2025 00:29:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=kuLX9VEf7AiKPqbd10HhyNrmc0gPYvLwfSoWURC1d50=; b=
	A6OtqXyO4GW2CWbpqG9jLxfyIJZl4N4xLjbXlg7l8aLjZ53SBjgQdkkZn3BSNdb1
	w4Ao9iT1ELZ5XcRFa+1lRdtAqOCt57tbXzA9OLwuol6ohfqLQUanL1Q6cKs3yc4S
	wzZWEjCPRVcA5dQdTNtKicS5dQSOMQ4ZvnaOVZOXXYB0S++ecHexFxyKm5eZRtAp
	qHZVgr9ObpMBS9y8NMsIrvl8Iiqmya/V92V7aGILQ9iOI2WRxbLlrj6Z9CqG3JSX
	FtS0THJX87acwhhUojlBURiER1jRLEzK6RzU0khHRnoyq1dSptOO/F4goSV0JorD
	q8d4Mt8ik9MioYCC0pMKtQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46mbcm0g92-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 00:29:26 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54DNDciX026181;
	Wed, 14 May 2025 00:29:25 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazlp17011027.outbound.protection.outlook.com [40.93.13.27])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46mbt79xe6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 00:29:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QtvjeDlo4O2r9vfVx/1w/Ts7nKk1sHJLPQvY06SXXULduqt/AFwEACxVC6OyPWzNY/gcNjgpHOtWWC4ZfUDkiFuDDCW0zPg7Z4BwqjYtpdiP60pKiNBqdH9vLDVorij5xt0WLhmqVWeb08yASQEB2G3SdMfXWGaVb0aUktrZ7jVXuskotpiQvwMt7iaqmJCTUXHPstPKJB/hntxWWHE1upc7Xb2uJUfErYVxfVC+rXZfF+y9xEXQqzJqHKly3uZTLaUPPwfyGatvqkU8oiFVdUsLV+h5kT8ud72N15vMHUC6FTmBzLjxxDA2FCY0+H3aS5zjun6CtbXEHuljr2aDJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kuLX9VEf7AiKPqbd10HhyNrmc0gPYvLwfSoWURC1d50=;
 b=VACbiWqi0Zp/mE59kij0BILinI8qtp4n6h+7WU7mKb+b0k+A7PxZe/AI6Wtx9eR9P/0CNgDIQja5IfT0YCo2oMuti9JTvmXSZkVeS+TAfOlbzjgJXX7+M//9fVE1GbyFXbLZmayonu2Eb9WkkOK/j10x/g2i/t/uEt+vik+lYOnj0VNAhipW7eFZpLYpe3vbMTxCKQhiOStFrJSJ12oWzQRps9gBQLEacP62Jq3pwixtbiNmE5jlTpRRjn/dSuDZYx4rI5SAwePOXQ2DSngoH21TPZD+kWtJIlc5y2ePZZUDGtmC40laWeAnBwAawOV+nHzPgwUR7227woiy3CQzsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kuLX9VEf7AiKPqbd10HhyNrmc0gPYvLwfSoWURC1d50=;
 b=fQWvICAWKdSxx57u0R5BOwvvX+jF0CVQwjfuGMiEvTPISQiEZGZFqrQNB+VC53LlbXpe9mDtESTBtuqWNqQBN9Kcq9Q4cNJbUGNJamD5nG8cJA2yiFZDcslqfhnTzU7vqChMdNyfz/VKC5xTEEhYW3OXOk+M0bGsffOd5iKkO0c=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BLAPR10MB5204.namprd10.prod.outlook.com (2603:10b6:208:328::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.30; Wed, 14 May
 2025 00:29:22 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8699.019; Wed, 14 May 2025
 00:29:22 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc: djwong@kernel.org, john.g.garry@oracle.com
Subject: [PATCH 3/6] generic/765: move common atomic write code to a library file
Date: Tue, 13 May 2025 17:29:12 -0700
Message-Id: <20250514002915.13794-4-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250514002915.13794-1-catherine.hoang@oracle.com>
References: <20250514002915.13794-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0365.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::10) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|BLAPR10MB5204:EE_
X-MS-Office365-Filtering-Correlation-Id: 58659e6a-ee80-4ed8-768c-08dd927e5fc4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|10070799003|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dxrPSWQMYynClHRX8c5TPk8clw5EpnBQYZeSBS4s3bwM+D3qsWg8Lknh3lqA?=
 =?us-ascii?Q?T00zLQ2lrRyl5exWMRHhEj4FIOXosof65NbVmIwI1Dpj/SmNkfzYoPUNlX9b?=
 =?us-ascii?Q?Z4l4V0VkF2761n9k0/bjsGnFen42vMsxo/aq1AjJ1DlfAzM6CCRAmU2zNBsh?=
 =?us-ascii?Q?cdIQOlLqmK/VCQym9n7zUzgPdegcOTMCPq+knZ9RyHtxhXG5Fk0qFD6SvOIm?=
 =?us-ascii?Q?EGy2GHxs8Ir4Ck/loe2zBovWTQHXLyMil8upWw9M8o00m00lT3yl4X7SZQBt?=
 =?us-ascii?Q?Wx85iaV0Kb5Oii8vGQKBpSH1+NimUofIsvAz9qthhg22/beMupxpjb0OJBwz?=
 =?us-ascii?Q?oFkKD8EbyiNH6UV4ILz1sHKcue0Nj3FrIL2H1uzDQeB3ltcj4X2DxkXvhjGR?=
 =?us-ascii?Q?XQ/IxohpcR+ZSudjptm0CQhcWig3yvaGn4n6n1zY+ot6nw6MNqhIjN7dr2pf?=
 =?us-ascii?Q?7VlK36pOndRj38FVG+WJOWoGiwmIO6Uo4LGyMfrlo117+7hKxNHImQbJbTSU?=
 =?us-ascii?Q?QaHl4Zz5UcfoIYRkr8Npks8XVuFIcI1yjOt0RGxl69PfUzWDum8xxxbBt52M?=
 =?us-ascii?Q?hAaVGmeIBaTxLilwnU3nA0/0GhswGDNwBuUI4kCUV7ngtbZYLAF6sWVHw82s?=
 =?us-ascii?Q?kCYL1fIbSF4N/xBm+hBdB+iT03IvuoLUJqBGKRhPcrEDTDFZtJNwNiThwIBI?=
 =?us-ascii?Q?EJmTnLwrIj5dHSWEAnB2oI1RcPmBmIDUL9yaG7HqTChI3fWPDN9VWOwveAcD?=
 =?us-ascii?Q?V5yMk5Cb9B4ALL3q38CdWUOHGzo65JJ0BicuEaipgIGRB6PjNyY2thIhoGI7?=
 =?us-ascii?Q?IaRiNXMzsMc6GCJ9tEiDZ9LmoaXYzYp6FScYJKG1lf6vUZ3aZJkHvv+Wt0Q/?=
 =?us-ascii?Q?ltxYawCbydoa9EEs0bvf1oo1yRK/2WSw1dZuxNZs8bgBAOrF33WTSRRrct4l?=
 =?us-ascii?Q?L0Y6NK9mFpWYAditFQtKS3maWK7cdKBaWMrjnjLtOStdCOnJiTCDjCv8E8Ge?=
 =?us-ascii?Q?hJhq7p4CkDsOHKutWOeOx5UuwjiADrq9blfOkktFKYFm6qjGX1al5+RtcOkS?=
 =?us-ascii?Q?kP/w2dHEGG2HrH6c3W887lGRUwx4DYOxZW3J+ZzZRbh6Z0etBor4wMzcNkPM?=
 =?us-ascii?Q?48N2QmqlCcBWtEB2MxSsypuTlltVgQTURzC0QCjenQhLF2Ozytdb6e1GNtZ6?=
 =?us-ascii?Q?WqrHD1dG4YBZkUTMoHl1wHElY2LoV7Bxx1HNGl8U6lxkVwECwb3CrwPxeZe7?=
 =?us-ascii?Q?ikJfLpdknhAOt7fCG2ajUuOW548VL4SyxZe/qUfxqnCoHtzCUZK7G/lfG8OS?=
 =?us-ascii?Q?N0BlcA+1BtPdfP8L+rwUMcp12YSShekW5h+F7yiMlTO0GCNQq/iUx6yHnIIH?=
 =?us-ascii?Q?ghnfoOxoWDyuY3s/mZn1CELbfshmLiCNU/t4UFaaIS78lKJJjDNkwsTuhdBR?=
 =?us-ascii?Q?ncTAdVY0Jeg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IsaU7nAZu3eV9krodF1wqC0oycNo9f5IYCJexCNiBLJ7CF2swFCaaQCtxorw?=
 =?us-ascii?Q?6Q3zBlZWJKzYfqn07Tq2k/FKDMN2waISJu4CbM7mWs2nrBDeSNBuuq1kad8r?=
 =?us-ascii?Q?vJ/PA782nBuQbAkYrPwAfPijkjhUjfB/bkZLya09CdD8bgQeqq6aALPsMx56?=
 =?us-ascii?Q?6z/RF2ZqmN2YyWEa1O+PU0wsWtAAiIZpNg+bE9BumsuYAz/1j4oIy8N86std?=
 =?us-ascii?Q?/ckuEvcslqB9mdDZ/L5zzVQ3meAHyWNGbTo0cfJa+0vqdgzn9RSwpeW2sbn4?=
 =?us-ascii?Q?Nr/V0Vp0bhh5i0wZXR3WY0xS5gH+kNZcG04SyyX0I5XOeT1s9IVuwDZnKLnI?=
 =?us-ascii?Q?Nk7IVVNr8A2Z3nKwlsnhOmqO8w4N757VebDHUqxEoliZHGj5B7HiFB3I5FgO?=
 =?us-ascii?Q?nGHbKq9vw1wSQ7G8gpnguIXUxykPa56bqnl1XvB7I0ZTo1XLUe74HLhY2lTZ?=
 =?us-ascii?Q?uyMAMhjIZZkGakAU5uPNv43RMmNCF2H8a4Np+dcGAfom8nHtlXzc+CO9+dWV?=
 =?us-ascii?Q?DO2CxBzj0kKC1XzQXipjnUXaCRz21myCNXb3r1RycvZ3iIhabaLxTcbX8DUg?=
 =?us-ascii?Q?tpMiGLqgpWyQdtJFX+SMJ8oEhlpQ4xs+MuJCOih8zfABZZhCn6BeDH4pGTxn?=
 =?us-ascii?Q?w/dWYZKIZYnKe0grz5edZXPeOYzHXLjQvsw4FkPMlB2qGw15g6WXuRtLdwHA?=
 =?us-ascii?Q?ypCCXLr/OBZ3L4ixlZftYFonKAR8/V2liIOCV2NCAqSfkfkSMKFsoVI9ImSl?=
 =?us-ascii?Q?Ys0LMxHVRtguOMXwEqzJn+/kK+ix5aqJkzoUNJIKIIDtP5KvI6v7idfT2crv?=
 =?us-ascii?Q?eas+RQKbPuCr61x4IWtpcQCcas000o2iIkhaQ0UmcAeoNbYiK3N190UvDK1k?=
 =?us-ascii?Q?9VQP/Xv8JND61r0zOgG0rqoF7AR+bkNjlvKSp3DcLbnNTnzsuScXdJjnu+tk?=
 =?us-ascii?Q?ooGquPjMhd0d3DSLs63gvdwghLNI5/GkYOIL2TcUtJHyaqiU0CAlKI4eLUWp?=
 =?us-ascii?Q?WBc1NzxZINso9tvD52wc6XoqCyZ3evcLXRoapGdww3oyM7fJwCTBPlvV0TiP?=
 =?us-ascii?Q?yG0xbmtQ015Oy9+QuKxLJ23sYL85qFZNLDR4glI5SX/4wTeduDlSs/ArSid5?=
 =?us-ascii?Q?KbRqEUMEOh1eUvYq6UmeOketlcpBjYq+hus6DLbOjiyYc27txPhsu3GovGtV?=
 =?us-ascii?Q?/uvzWe+up/TIY4izK+/L45MoobYi9fso8u6jmmmrD+8mr/cX9a7wXv/C1++X?=
 =?us-ascii?Q?WAdq0GtSRssvBwhAB9eUM9o0RK6OSl4FjoDdkZRKW2Zq6hDGQUhyoZZTkm0+?=
 =?us-ascii?Q?CZ8xU3hgKlysK6lQRSObrCUsczVLvaAbEC3pu6YQZKoHErdwYAyHz7KqEqIL?=
 =?us-ascii?Q?4EWvHCsOKH+fh1Q9sdW4WTG1BrK4D4KywOhx0RnKCLTebdVBIPKN+jRgmSV5?=
 =?us-ascii?Q?slUp/8tsbd8LMElINN2MxLnRgfrVM84vN6GvXed28A6li2evWeIQDpuWBklh?=
 =?us-ascii?Q?TdY1Nwy8jktALuOEjik/6aO7rFpEvg+1TDoMLW9gpwsruy0kLAMaAEONAYRp?=
 =?us-ascii?Q?0/GOduPoA+VD07mJlxZPwgVWyHEhg+1ivaMyC6dIwpm/SGJwMOtMpaWQ0hHf?=
 =?us-ascii?Q?OU/zsD085ZzPRQbTJo+RtvHcyQjpaFEG9Y8Jdzb2IpelATWmTd75HE69ncqy?=
 =?us-ascii?Q?w/qdsw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	iX/EvuOjB2u8TeqVGK7RVAHSG5D/jAeBgCK3ElMQR0sqXdgMOUMjtgQZ2mXmzo8jPMOvHmqDUSenofGqBnDs/tVsIDsJv/LwL6N4ejHXgDRl76RP8WByCc4kCkOnDs0AFpsU8D2Yy05h0z1eK4Uq5lorBzSv3/FOZscdtEZ40MNQGIQlamDedykN3QGP9D9ovo9UsB+CO4uBQJRQNywA2WpmHDG3S1u6fqDQ2U1KQRHbqMEqB4GU2Vl/eUC9i7Sa1VnQ3Ojv4Ug0u6Q8kgGeGyVerbU9VY+VvTZBex1iRmJCyNazhCQtokUcOEnYtrAhlozBy5urI99QvHBETgrD0Taj+6/4D13/MjnkFDapculh1t3BVn0crfDD9fVT14FWRbZXwlw4cfr27IWydviIgC6QeTRZCajCLWGxJerp0svHH48vkaf+AN3Av/UI2OqSBi5T1gZdDYUjgQbzQQlxcBaHzT2hix24DQPAPlXvfmczcFPpaSDf0HyJ7E9RMJ5KoTx8iqE5k9H9H9NVtpJAIekMjoTJ/KgKerfNw0Kq6YAlLS8NOTTn5uKy9GSJPddkD9+0/5COYk7OS9k3aqCiUsk6FRcGAxCE6bVWI5rT/1o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58659e6a-ee80-4ed8-768c-08dd927e5fc4
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 00:29:22.8805
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jM2q7rPxotORsudN+a9hmvgwlZpyUOgitbyvEXVCblpxk+HIJ5L4/RUoIDaUZrUBXBq7ZXSWQfeTwcPAZoAJbJdTxrLm2UyH3pnLjMC4EQ8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5204
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-13_03,2025-05-09_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 mlxscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505070000 definitions=main-2505140002
X-Authority-Analysis: v=2.4 cv=DZAXqutW c=1 sm=1 tr=0 ts=6823e3e6 b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=XlWU-9mzee8Wawx2FPYA:9 cc=ntf awl=host:14694
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE0MDAwMSBTYWx0ZWRfXyMgg/TEZdNCr Tg8/5l8maJ4I9IKJgFTZyMgk7W3kfl4qrtI1af2jrYaTxDMSZXeLIfIh4vsedPibBkj2uK1ImIp H3PPGdS8R/GuHU66YoT0fjF7wMTLMuou43HbAbOHHnyMBRAyzGVb7K2T9Rkq1dWJBdem1SjFmB+
 O5QI7d61WZFfkK+jOgfOE6gbYPXjsKDgcgOA+rvKpy4rUjg4mXYZf7n5NmhYq5+mXzzfXG6+HYx 8/OfzshYI7pEPLmp55/aCk/lS6qRXnanfRQZUXvB/f59CuR6C5W3dqwIAln1QY2oAjGqcNeAm29 ANK8iL8qGJ+mbty5+i7CyGPN4EWT56JtVtRzchC69yp1HN4wMx4cpdSQjfumWL2pty+vtK71PLf
 qetljgtKFjyo6ciX7UjR/u/SJGCuRUMINT54+bEZcjcOR1w24A9mA32wSRXvNc8kBU11DN4w
X-Proofpoint-GUID: uS94QOMDfJyrPZqNHFi4U6yaIeMGXqv3
X-Proofpoint-ORIG-GUID: uS94QOMDfJyrPZqNHFi4U6yaIeMGXqv3

From: "Darrick J. Wong" <djwong@kernel.org>

Move the common atomic writes code to common/atomic so we can share
them.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 common/atomicwrites | 111 ++++++++++++++++++++++++++++++++++++++++++++
 common/rc           |  47 -------------------
 tests/generic/765   |  53 ++-------------------
 3 files changed, 114 insertions(+), 97 deletions(-)
 create mode 100644 common/atomicwrites

diff --git a/common/atomicwrites b/common/atomicwrites
new file mode 100644
index 00000000..fd3a9b71
--- /dev/null
+++ b/common/atomicwrites
@@ -0,0 +1,111 @@
+##/bin/bash
+# SPDX-License-Identifier: GPL-2.0+
+# Copyright (c) 2025 Oracle.  All Rights Reserved.
+#
+# Routines for testing atomic writes.
+
+_get_atomic_write_unit_min()
+{
+	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
+        grep atomic_write_unit_min | grep -o '[0-9]\+'
+}
+
+_get_atomic_write_unit_max()
+{
+	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
+        grep -w atomic_write_unit_max | grep -o '[0-9]\+'
+}
+
+_get_atomic_write_segments_max()
+{
+	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
+        grep -w atomic_write_segments_max | grep -o '[0-9]\+'
+}
+
+_require_scratch_write_atomic()
+{
+	_require_scratch
+
+	export STATX_WRITE_ATOMIC=0x10000
+
+	awu_min_bdev=$(_get_atomic_write_unit_min $SCRATCH_DEV)
+	awu_max_bdev=$(_get_atomic_write_unit_max $SCRATCH_DEV)
+
+	if [ $awu_min_bdev -eq 0 ] && [ $awu_max_bdev -eq 0 ]; then
+		_notrun "write atomic not supported by this block device"
+	fi
+
+	_scratch_mkfs > /dev/null 2>&1
+	_scratch_mount
+
+	testfile=$SCRATCH_MNT/testfile
+	touch $testfile
+
+	awu_min_fs=$(_get_atomic_write_unit_min $testfile)
+	awu_max_fs=$(_get_atomic_write_unit_max $testfile)
+
+	_scratch_unmount
+
+	if [ $awu_min_fs -eq 0 ] && [ $awu_max_fs -eq 0 ]; then
+		_notrun "write atomic not supported by this filesystem"
+	fi
+}
+
+_test_atomic_file_writes()
+{
+    local bsize="$1"
+    local testfile="$2"
+    local bytes_written
+    local testfile_cp="$testfile.copy"
+
+    # Check that we can perform an atomic write of len = FS block size
+    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile | \
+        grep wrote | awk -F'[/ ]' '{print $2}')
+    test $bytes_written -eq $bsize || echo "atomic write len=$bsize failed"
+
+    # Check that we can perform an atomic single-block cow write
+    if [ "$FSTYP" == "xfs" ]; then
+        testfile_cp=$SCRATCH_MNT/testfile_copy
+        if _xfs_has_feature $SCRATCH_MNT reflink; then
+            cp --reflink $testfile $testfile_cp
+        fi
+        bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile_cp | \
+            grep wrote | awk -F'[/ ]' '{print $2}')
+        test $bytes_written -eq $bsize || echo "atomic write on reflinked file failed"
+    fi
+
+    # Check that we can perform an atomic write on an unwritten block
+    $XFS_IO_PROG -c "falloc $bsize $bsize" $testfile
+    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize $bsize $bsize" $testfile | \
+        grep wrote | awk -F'[/ ]' '{print $2}')
+    test $bytes_written -eq $bsize || echo "atomic write to unwritten block failed"
+
+    # Check that we can perform an atomic write on a sparse hole
+    $XFS_IO_PROG -c "fpunch 0 $bsize" $testfile
+    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile | \
+        grep wrote | awk -F'[/ ]' '{print $2}')
+    test $bytes_written -eq $bsize || echo "atomic write to sparse hole failed"
+
+    # Check that we can perform an atomic write on a fully mapped block
+    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile | \
+        grep wrote | awk -F'[/ ]' '{print $2}')
+    test $bytes_written -eq $bsize || echo "atomic write to mapped block failed"
+
+    # Reject atomic write if len is out of bounds
+    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $((bsize - 1))" $testfile 2>> $seqres.full && \
+        echo "atomic write len=$((bsize - 1)) should fail"
+    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $((bsize + 1))" $testfile 2>> $seqres.full && \
+        echo "atomic write len=$((bsize + 1)) should fail"
+
+    # Reject atomic write when iovecs > 1
+    $XFS_IO_PROG -dc "pwrite -A -D -V2 -b $bsize 0 $bsize" $testfile 2>> $seqres.full && \
+        echo "atomic write only supports iovec count of 1"
+
+    # Reject atomic write when not using direct I/O
+    $XFS_IO_PROG -c "pwrite -A -V1 -b $bsize 0 $bsize" $testfile 2>> $seqres.full && \
+        echo "atomic write requires direct I/O"
+
+    # Reject atomic write when offset % bsize != 0
+    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 1 $bsize" $testfile 2>> $seqres.full && \
+        echo "atomic write requires offset to be aligned to bsize"
+}
diff --git a/common/rc b/common/rc
index 3a70c707..781fc9ba 100644
--- a/common/rc
+++ b/common/rc
@@ -5433,53 +5433,6 @@ _require_scratch_btime()
 	_scratch_unmount
 }
 
-_get_atomic_write_unit_min()
-{
-	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
-        grep atomic_write_unit_min | grep -o '[0-9]\+'
-}
-
-_get_atomic_write_unit_max()
-{
-	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
-        grep -w atomic_write_unit_max | grep -o '[0-9]\+'
-}
-
-_get_atomic_write_segments_max()
-{
-	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
-        grep -w atomic_write_segments_max | grep -o '[0-9]\+'
-}
-
-_require_scratch_write_atomic()
-{
-	_require_scratch
-
-	export STATX_WRITE_ATOMIC=0x10000
-
-	awu_min_bdev=$(_get_atomic_write_unit_min $SCRATCH_DEV)
-	awu_max_bdev=$(_get_atomic_write_unit_max $SCRATCH_DEV)
-
-	if [ $awu_min_bdev -eq 0 ] && [ $awu_max_bdev -eq 0 ]; then
-		_notrun "write atomic not supported by this block device"
-	fi
-
-	_scratch_mkfs > /dev/null 2>&1
-	_scratch_mount
-
-	testfile=$SCRATCH_MNT/testfile
-	touch $testfile
-
-	awu_min_fs=$(_get_atomic_write_unit_min $testfile)
-	awu_max_fs=$(_get_atomic_write_unit_max $testfile)
-
-	_scratch_unmount
-
-	if [ $awu_min_fs -eq 0 ] && [ $awu_max_fs -eq 0 ]; then
-		_notrun "write atomic not supported by this filesystem"
-	fi
-}
-
 _require_inode_limits()
 {
 	if [ $(_get_free_inode $TEST_DIR) -eq 0 ]; then
diff --git a/tests/generic/765 b/tests/generic/765
index 84381730..09e9fa38 100755
--- a/tests/generic/765
+++ b/tests/generic/765
@@ -9,6 +9,8 @@
 . ./common/preamble
 _begin_fstest auto quick rw atomicwrites
 
+. ./common/atomicwrites
+
 _require_scratch_write_atomic
 _require_xfs_io_command pwrite -A
 
@@ -87,56 +89,7 @@ test_atomic_writes()
     test $file_max_segments -eq 1 || \
         echo "atomic write max segments $file_max_segments, should be 1"
 
-    # Check that we can perform an atomic write of len = FS block size
-    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile | \
-        grep wrote | awk -F'[/ ]' '{print $2}')
-    test $bytes_written -eq $bsize || echo "atomic write len=$bsize failed"
-
-    # Check that we can perform an atomic single-block cow write
-    if [ "$FSTYP" == "xfs" ]; then
-        testfile_cp=$SCRATCH_MNT/testfile_copy
-        if _xfs_has_feature $SCRATCH_MNT reflink; then
-            cp --reflink $testfile $testfile_cp
-        fi
-        bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile_cp | \
-            grep wrote | awk -F'[/ ]' '{print $2}')
-        test $bytes_written -eq $bsize || echo "atomic write on reflinked file failed"
-    fi
-
-    # Check that we can perform an atomic write on an unwritten block
-    $XFS_IO_PROG -c "falloc $bsize $bsize" $testfile
-    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize $bsize $bsize" $testfile | \
-        grep wrote | awk -F'[/ ]' '{print $2}')
-    test $bytes_written -eq $bsize || echo "atomic write to unwritten block failed"
-
-    # Check that we can perform an atomic write on a sparse hole
-    $XFS_IO_PROG -c "fpunch 0 $bsize" $testfile
-    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile | \
-        grep wrote | awk -F'[/ ]' '{print $2}')
-    test $bytes_written -eq $bsize || echo "atomic write to sparse hole failed"
-
-    # Check that we can perform an atomic write on a fully mapped block
-    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile | \
-        grep wrote | awk -F'[/ ]' '{print $2}')
-    test $bytes_written -eq $bsize || echo "atomic write to mapped block failed"
-
-    # Reject atomic write if len is out of bounds
-    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $((bsize - 1))" $testfile 2>> $seqres.full && \
-        echo "atomic write len=$((bsize - 1)) should fail"
-    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $((bsize + 1))" $testfile 2>> $seqres.full && \
-        echo "atomic write len=$((bsize + 1)) should fail"
-
-    # Reject atomic write when iovecs > 1
-    $XFS_IO_PROG -dc "pwrite -A -D -V2 -b $bsize 0 $bsize" $testfile 2>> $seqres.full && \
-        echo "atomic write only supports iovec count of 1"
-
-    # Reject atomic write when not using direct I/O
-    $XFS_IO_PROG -c "pwrite -A -V1 -b $bsize 0 $bsize" $testfile 2>> $seqres.full && \
-        echo "atomic write requires direct I/O"
-
-    # Reject atomic write when offset % bsize != 0
-    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 1 $bsize" $testfile 2>> $seqres.full && \
-        echo "atomic write requires offset to be aligned to bsize"
+    _test_atomic_file_writes "$bsize" "$testfile"
 
     _scratch_unmount
 }
-- 
2.34.1

