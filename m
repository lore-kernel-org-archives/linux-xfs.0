Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6AC3C01;
	Wed,  9 Jul 2025 10:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752055481; cv=fail; b=KKRI1moKF6Rf742oi2tEtqQB7sBkGyk+RHq1Gls3dGBcNP0y6OpES8Ai+DMfVfmNCClXrKPbD9nKXzxN8N65VjGbpMZVXM02XhfBZ3nc5XbGI3JlpeFOjakGIEhF9uuEPHKUbOd/5pYKDxzdS2RIhH8Xb5n71zyXBBwXrjfgArc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752055481; c=relaxed/simple;
	bh=XeXM6krCUwTjUL2/IP1cbYje7Na8woqQgPDRoQjtPF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=B2DEWJZHSLLoCmv6wNBCKLtIKu6Z4NCUnJNkFlfeZPSZGUxadcAKH6KizQX/criFv3aa8ZV4PVMOjWarG9/jzikBP/xTgPPwY/vTwGBw28BmubhLUJ7cJTJkaNeNceIjCVUjrT9TVxwWFyU8Gi/IrlKaJuMxeG8ESIwEgpe6n24=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=M7E6HHu3; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=lK58ipnF; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="M7E6HHu3";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="lK58ipnF"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5699YtCa009154;
	Wed, 9 Jul 2025 10:03:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Vja5hkj0qDRQ20ea1RE5uMgdUV4Eiaq3BIBUT4gZnfM=; b=
	M7E6HHu3c+zWbo6ZzKzbxEdO8KZr1Zij/gGKUQaURecgCaT8rS3ru9HLwrMDaO85
	VPp9jVLyN3EthK7uU3HmRNznjweu3WGt95AFtXg40EXBD+fnK0hNOWZxHISD0AqJ
	4Exgr3igwLcI5tcVQT44BkUbkRpbv4QZgWAUecF25/RYOBwL8hsTkm8eirNRc2f8
	HbUsHHcJvT4R2cDuag54anzxlS6OUQea3PA94JGqYq5dAdFEOKmkAq4fm4I9wuu6
	Mq1whYcGLSiodFa7hVfj7LD216nZ1yca1hK3JrxC1cP8V5+Q3KyTgSDicYyUF3jK
	nMb7XmUT3LTU8GOKqTOPtw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47sm6d88wh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Jul 2025 10:03:27 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5699d9Di014001;
	Wed, 9 Jul 2025 10:03:26 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2068.outbound.protection.outlook.com [40.107.220.68])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47ptgashdy-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Jul 2025 10:03:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R5YhA81qa1RbWf/1gYrJhbjieKleQVqgy4Y8uXFLKwugjt2PNswMvc9LWpbnTwe00IP+btJ+YGmS+p6Os0EIkfsN7h0szLodvmcHgfZ84f7Vu3n/gq/bJHSLGNkYykj11U4NlJpDtNA8b2Ei9sBpg1+M0f0X3oPclQOFYI0F8LsqU7wyBUzbpRFeDq5F9Lnsk/DCMbInv3D88hiCtph/icfNYCzrYtFqDUk6sYsjJGYD3qynL2Y3dHy50rR+E0+HUINL8UgYxaLmq2SK7pnu8CcdcA0kzw3Tj7NQmFmhaS0tQJN+3xCFhqqdp2PS+DwzR/JYP4PAB3ZXtXxmGOd9ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vja5hkj0qDRQ20ea1RE5uMgdUV4Eiaq3BIBUT4gZnfM=;
 b=rO0wWJ0uYRZkHs6kzPojdRN6T/c/azU1ymZ1Q+ciu4JLAWcmZiG172jZye6sDtfFlbL6MFqPOA1DpTqYOlQ8LhQYr3fAiq8/QjePWtT9vVW0ZJQ5ERCeWlBIo6Z90HIZ1+t/F0MvgY57O+wg/WzzEktfTt5IfnmcpZ6YeLM/IImTJJx6ItXj7l8mOFncU9kGzIMo5g3+3ywzZEkyAAG7DjhQ87ZsrTF4h+YylU0fkG6XCjbZjX7lJEyKOXxd+eH1dA+FJJDbGMd3OUMJcLO2qg9nfUHGf0+gqu1Ayj8S5hhDorAGmMBcpML2KwqmzkC6lPC6TGzLTgCqzcnn+wCtDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vja5hkj0qDRQ20ea1RE5uMgdUV4Eiaq3BIBUT4gZnfM=;
 b=lK58ipnFo3aNFti1vjyAT9lLJl4AzXxAjqC6cyXJS8ZtKWDWBj4QIJ1LWMbRYK0rr9W6MjaCZBehEdB8hAiG5jHrSeEG/G3+aFrrI9C8PMZtlIoum/EGWcogGdAAoUNJ//fUO9pnmi2Thd0Z+iASsX7fzEGW5wK9P6BUKEAbcnI=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by PH0PR10MB4744.namprd10.prod.outlook.com (2603:10b6:510:3c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.27; Wed, 9 Jul
 2025 10:03:04 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8901.024; Wed, 9 Jul 2025
 10:03:04 +0000
From: John Garry <john.g.garry@oracle.com>
To: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
        yukuai3@huawei.com, hch@lst.de, nilay@linux.ibm.com, axboe@kernel.dk,
        cem@kernel.org
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com,
        akpm@linux-foundation.org, linux-xfs@vger.kernel.org,
        djwong@kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v5 5/6] dm-stripe: limit chunk_sectors to the stripe size
Date: Wed,  9 Jul 2025 10:02:37 +0000
Message-ID: <20250709100238.2295112-6-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250709100238.2295112-1-john.g.garry@oracle.com>
References: <20250709100238.2295112-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0085.namprd07.prod.outlook.com
 (2603:10b6:510:f::30) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|PH0PR10MB4744:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ef4f278-ea10-40b7-57fe-08ddbecfcb8d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cXTumwqL78N0GYgn80WEgbQoQ5kkQNQ8Q1Ezk4jyKOUWTeGDbqkvwSF0OLYz?=
 =?us-ascii?Q?Kk0wWrI8yJpFmyU0r8n6xEkqb6AEtVR5WoJQzu6e/LUyA4AIDe1xV2JJ1Zf0?=
 =?us-ascii?Q?I4mNY08qpihkczZQmaz04eYInbbFIPlFs/AJgkZOVEaqyBIyX/HWUKZU5DnZ?=
 =?us-ascii?Q?ttvu3230PgNcsi1+vLHA0faSosE3U76eoIec6GVRu8FgBWnNvakMPv9fKwXl?=
 =?us-ascii?Q?hDQ3cH1ofEszm/qLUWvTcLTXo613CPdHt6UhMfd4gw+ljFNMszuycQtIhDLH?=
 =?us-ascii?Q?s1SerYitW7xZez6xFTVXV3i6Nx3XLXNx7JINQbbMkj7v+V80CBHf8UkLMtli?=
 =?us-ascii?Q?rsesxP1En31tpEwfzayuwFvu+TwggWVuVmC7mKJA+CEnwqgGXBkDE9Er/SCe?=
 =?us-ascii?Q?lukr05uC1MYw+8hKnpr8tiVznNQOhYIrFdjKZT8x0zMM8e3MuSHcQsOb1HO5?=
 =?us-ascii?Q?NJgw38abvdQUcvlZ0Xwhk6ZleUpS73Vq9MT2xo9jx2kfIJm0JkOgFYPs4WKI?=
 =?us-ascii?Q?w7uMTiV5MuTiChPUuTya4o9PxUwwLo6p8uFyWjQNXSfwFrnEXjNEB7CihdoJ?=
 =?us-ascii?Q?0A39jCagWGLwag0tETtUoXP97/4Baaq+o2HEpgzS1wHRBs9wynaAXXGb7hAW?=
 =?us-ascii?Q?H7LHpmuSpbSAO91MHAnoFpPKsn5tYovIprNpK4qBtKRUALzt37gVyGRe1dfC?=
 =?us-ascii?Q?r8SF74j2MnnEjXMHGQfq1A4nq1W7Dvm8RaVgb1VvQmOwco8LoFAVhRMYTFV/?=
 =?us-ascii?Q?S4TMFMzXIn4yD+Ia6gh/enP7Oe693xCIYOIdq/uWnWyen5fgF3Dpa4ROoJlr?=
 =?us-ascii?Q?FKyDgtE+T+lib0f+hlSYLVNMFr5o0PYmex9j9HIpk4WxHBJ+Yv0qzKI7yjJd?=
 =?us-ascii?Q?D+wkRubSL+VPghGTkvJ/8VI3FIkJ5CUvopzQh68lpdFt86SGC5+As4fklhfE?=
 =?us-ascii?Q?Z1b02KA5PYoPY21DaBdEyCokiFKSgyYVjWwkRCmK9vrjXdz/OeUDpjNEmUS7?=
 =?us-ascii?Q?kGBXaLbTWJShM1r+ntWfRqeLxap1TKBRQksvJBBno/9qB7/OrV8W9eYusH+V?=
 =?us-ascii?Q?EU29GknvuoMoU1H0RTgDgYFxQDZPcz3Ksi8JXvaIEj5/cQWIL1HaJbtOoh83?=
 =?us-ascii?Q?PRKa9Q7eV87o04C/1uMOAHyWI5CDYpIFkWMcCHY8vC8kNeExcgtg5gRa01P0?=
 =?us-ascii?Q?m/k1hyS1ljoNoEirhk4KiO6rxUVyuJzMQs+F1r60LTg9W5j8m8yNvu9wgAYF?=
 =?us-ascii?Q?L8Ei81LfdVWIsygAzU2YXoQFkQ2YBiyM5OUWe5DvWwk9vXq5tQ/gfUy+sYOE?=
 =?us-ascii?Q?FDxG8mxjWJaqvDSUgbyGC2P4i/VY5xhf96N6/cNHdgUAprZDzw5WHedIypK2?=
 =?us-ascii?Q?PfAf1gnOu6VjhFA3A121WgpAGVopaUXJm6Z13KhTPPL3qCuOJTPqeNpsHWoq?=
 =?us-ascii?Q?b6xU8JIqnpQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3thc1oU4GvepBfX3/PsgW4+BGLbNTT7EOtvxDi2pMsOBcNWNkIhK2fIDS5PQ?=
 =?us-ascii?Q?k/58RCACpQQshaflOiQkM22YUKJG8MaW05/BmUlu+lZggzhiV0QCxKyuUqRH?=
 =?us-ascii?Q?SdDW2xPZmXJBvNnW558mlEc2OG/5/z+F+V+FwrDKTumhRZLFDOiFM8VzuZfe?=
 =?us-ascii?Q?6EeLcmfi4N2+2+ljIaFw9izFERPT/l7FeKsDm3/n8UR3RW3gecyB1MpGud17?=
 =?us-ascii?Q?SKumqx6bdGBiSrV3k2aH5l021zWEuX+Y6/8k3A/Xbcf31bnAGQB8xWUxgU6M?=
 =?us-ascii?Q?1DpAOZ21YVZq+cbqSs/4loVStOe3WK/cZ9htm/KJBu+O25v7Tu/PwBBQ94P2?=
 =?us-ascii?Q?ZXV8Cv5FkhMOi0ttin6gA1WlNQCinA0Ng5xrIxleLKlvr5+rar4/eTn+g/MZ?=
 =?us-ascii?Q?GHGu6ncWj0JU4SH74xKyTOEW5W3ycuscy4cK5gQJaLqRAqWi6fMykCntZ1pM?=
 =?us-ascii?Q?ZWuSc5iQKi30HOzMt4w9DzEMq+iwNQ+QV0MrGjpDvI6ly3EOaAAPqpdz8LpN?=
 =?us-ascii?Q?5pj840ShjACQIJU3cgr4fFfo8gfShsJH07t01iHZDDbnGOnYBHMT3nMurHoe?=
 =?us-ascii?Q?FvTMsEuAOc3lCnhTLqV/7lPzDNWMyphJVKka8Jsz8tM1fszrEBzZNY2LmkKd?=
 =?us-ascii?Q?XggrqQse1HRBhLsB95oRWGu9N9wT2Y4bQcmbw2HJqtvjzEyjSUlCNV2gJvxo?=
 =?us-ascii?Q?jT7HcE5uiUf/ib8PtJzptbNwaF6fP7PZHJV8ET/Um/oaKO9YRgVDVGgWN6Pw?=
 =?us-ascii?Q?CsJj65nzMVFWb/BSBmx6SzSSF5MPIVlTJYcK3FzKUfHnACrx/EsoXBmFPQq/?=
 =?us-ascii?Q?gBWi9+pHLmNmqS/8sPkBMZ0AKKZ9e8cZMab3NEiafujZwvfKRSMhRynU268h?=
 =?us-ascii?Q?dlNn5hmt93fXPOJRvUZp3y1RP5Bz8x7VCTnpEWPrvXm/WmxvhMB5LVfLOQVv?=
 =?us-ascii?Q?nB9aQY3bVUkDN7r2/643d2rjbQIT/BoMP/TfVAiLhZHHPDKS1Pi8IpA4YGC2?=
 =?us-ascii?Q?PMKpuH/abOHSE5Hwc5LD/DBgtImZHMR0d2k3pVEkpgHYn5mM2AhZ3W9N5aP8?=
 =?us-ascii?Q?KlZGOjuY9tNW/5xtUyV/EN/QNm2iLgPNtZjPXhUuOwl6aMRTDzx6y3MSJ/td?=
 =?us-ascii?Q?YwG6B009W/D/Ouew7hsq+Vr31cWy6eKkiWWluN4utnvbVQ2QnqwT4ou7PN0y?=
 =?us-ascii?Q?atVJfDfiqpBCkKTTLUuy/kiFS5XKm8vAmrIKZEStz/3njKxqDoMs5kL5Uxef?=
 =?us-ascii?Q?QTJGeq798z+1AhrDdx3yRuJrpis3IP3XkxFLFce38xNNDHN/fpPSvsk80L/m?=
 =?us-ascii?Q?87oWVuFnamsHdi3wYPwu6XcH+hK24WNskGJoi1o1F5+S6IKJ5esaluFdE4pn?=
 =?us-ascii?Q?wbI+qovovv557O4jPRntxSjB+dojoj1mwzb2qGg6n5PfRJ3bXNnN775W8cTR?=
 =?us-ascii?Q?mRyt4Qob09TXwvIuocDO5feB++bHYfvURW+xFUQJA2ik96arLq0mqx4lJg+s?=
 =?us-ascii?Q?wALmUIrc8CIs17/crrVx4i63ArWiefY/jN/M7HVfgRW186pslrrNF8a2Bh4V?=
 =?us-ascii?Q?EZ9wnTNlpxLEBlwYsxlWzg43Nh1m83TvJEm7TPQj5BtTwqosOnhqy0dAos9M?=
 =?us-ascii?Q?6w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+8J8A/NOTLD6alvrDWLyo7TNr6NLOR8KTfyr3RLc7el/aT/++iayr8iiDgtTtFT5j+rqFFFpD1KfO/3BtQ6XKy9/Q3TulzoXHngErYE584EjknLlS8PbGX3s16IP3q1dNJ6px+STxsuCIbWXqGY8ETkd3ow0h8SO0eZSGg3ed/xieh91LbVlp90BANEAoJTOjmAFpAte3N/QXSIb5CbVT9pUD6dNuiFrR90rbrlL9FiMMt9e1fVFzIXk1MlTbvnmXFxjPgb/25/9Zc8NgMNiX7s0T2tyAuxDfhNPqJQ22kmBTQsLaQgjsq8NMexXoUHhxrMBtF6IjsoY1QhBH0YTLR9zDhtcfeIF48Phf7fznhJ9AQjLGYgWEFzQGZ2UPi30AIquAV3cFDOKbuhQbZZ7kyIShs+ElLghLb3sOwlUkFVgywY1FolLCRIKdc0UN5x17viCOpSjrzrL4FVOQoocO0lwib2ENeAChs9yOHku+YpdM8IF5HWK5Nnk5UQQvLuRKhTF3DAgh1QF8U7lDliS8hGc7B6Av39+oBbwVAZyYvkbTnYckYXxG/K4faVuGDf0EXaz/Jk5bwCrs/xSd0mKcOnGfME8A7DUIB8uzHArjQk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ef4f278-ea10-40b7-57fe-08ddbecfcb8d
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 10:03:04.1423
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k2mjNyzjlzniW4s4+EY6bSCg7tg2nIrLvQ7HkTRyQ9DAbPxizee4hsFy0z6jn9825EFchshZriLGUfCu1SmG2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4744
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-09_02,2025-07-08_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507090090
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzA5MDA5MCBTYWx0ZWRfX4/D1SOgQilCN WUO6cNOnIWp4SXAi1kbmZahqmr3qZLcQZAuCuvd2rbHEfF/wq6bTuWWl0H5JKUHN0AEceDCIfLe RJPUsdVCvJeqQQrxt6TTIvuLlyX0PyTM/TRo9I6hGFBOsrc/vwxp2D5YODr3Dd92IzGCf/wtnaR
 WKqqhF7HCTbpwqJLU7BOPKOLIS0U40h+4ssTipFIY4trDws2gZKdCQeVvvhcv3rSPHOR9RWOMdW fxNHRgBxfZErMzDBFadygaWW1hgSuqg9TBSDRfUidjbUUZSJTlMvRMLubhcNRgJ7lUSQkGRALle MQZbtcYtWEtwU/VdiHhCNiUxwED8BBsTWNmyI1Ph4zqpQSxx129eGPkFm3ttYF4bzRzZeyemwxs
 QlLw5Pmxhwu/BHDypYsz0R/+sFMCUb4rfSnqlRvVgvFAI9yh2o5i378rj7/wXU/eZyC/aWro
X-Proofpoint-ORIG-GUID: oHI6PCbi5DqWjTa8pfxZJl5tGhL3C82M
X-Proofpoint-GUID: oHI6PCbi5DqWjTa8pfxZJl5tGhL3C82M
X-Authority-Analysis: v=2.4 cv=UPTdHDfy c=1 sm=1 tr=0 ts=686e3e6f b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=RkmrOqiwSQOQut1nclgA:9 cc=ntf awl=host:12058

Same as done for raid0, set chunk_sectors limit to appropriately set the
atomic write size limit.

Setting chunk_sectors limit in this way overrides the stacked limit
already calculated based on the bottom device limits. This is ok, as
when any bios are sent to the bottom devices, the block layer will still
respect the bottom device chunk_sectors.

Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/md/dm-stripe.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index a7dc04bd55e5..5bbbdf8fc1bd 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -458,6 +458,7 @@ static void stripe_io_hints(struct dm_target *ti,
 	struct stripe_c *sc = ti->private;
 	unsigned int chunk_size = sc->chunk_size << SECTOR_SHIFT;
 
+	limits->chunk_sectors = sc->chunk_size;
 	limits->io_min = chunk_size;
 	limits->io_opt = chunk_size * sc->stripes;
 }
-- 
2.43.5

