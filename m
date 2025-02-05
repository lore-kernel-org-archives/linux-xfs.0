Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B90213258;
	Wed,  5 Feb 2025 03:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738724900; cv=fail; b=AEng7ylyfnXeiDRD3PkispYtjVHCaAqSAWayk79Gg7NyCV8fZostegB8oam7Z4kGDvGR0/6EqJH+dtbpRVfyG7l8Bg57ujQfNq1O8rSs0bhosKP4iEIbwtiM2dZkdNK/UzVSGpOX/PFR+Hk+MccrvVld61T5V2JAaH5jcxtmY6M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738724900; c=relaxed/simple;
	bh=mFlRkLa199ILPSHgae8F0uXlpCpYmyBWxnYBSrYJH78=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hbQvuMTq+3eiH4+bY169PoLyBwscf3ul2quOLEAZ509RlAyjFWksXa3GVSK7N+Lhxnn02HclEdIm2EaHEmqNJupecLl5ag0bGGF3A77qT2znTxwj3xTShJDfMZosdLnlJ5J9Bj1/jav+rJz8BpXdVvEYuaxYCq/nM6cBYhWdNB0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FKqmNHRz; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=gWMtGj1C; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FKqmNHRz";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="gWMtGj1C"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 514NBpMi003368;
	Wed, 5 Feb 2025 03:08:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=MisXVYU5Is6SmturRUCNq5vtJkjqzG7ehBrwQ0DfTbw=; b=
	FKqmNHRzQ/70dC3U1T/iOLEQB96XtpjC3qS+gMTXu4+3/kE9IP0gXjJwhjTM73lv
	UjcTCFRyv9Pt/LzFarzSGZ4ERwwvLh7I6IfAUAd7oPLhcdZrBlnrC5ntIL+3OvPG
	dO0KQxS84sJVQbBFcH/BsBbvFDh+QBfWRa8KU7uNaOyq8fC1yYMikJ4gPGOeYBse
	EsPqX13gapX8jvZXkGHJe7CGYrhDI2N76ocikqGLgi1Z2xJKq9yYrA++qHvlLg7v
	Ri/4LQg1NlMGSH2F8Re+Ie6Ey+wMkTrjQ9NRSjuECVCq6qaClCMyGvozaWpLoTU6
	jrkN9QK5CmxHGHz4M+dy0w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44kku4sdak-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 03:08:16 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51512sb1037814;
	Wed, 5 Feb 2025 03:08:16 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44j8ghsn9j-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 03:08:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RNGAe/VDFuKTk6zJvtJadLo3CvKdJADG0qK+NsDryCQ5/LSQQgKTHokYP6buWzklme+zvl4xLDrkspIHTyjETuwuZ2mPo/IhTNSLlGNQ30y77X+4/04S9ZCnihmXEoUGCELoleiGqhvjYxjYRJ8ZikDcTT0VslQ1ff/GNPPx8xgU+xZOZ3GQXSacZWDZWAmDVZ6cOeYQLyWOu2djoWLs0dKXOlkpAvWvvhv06mxvFQ+AfZ1cEOZqs5lefBYcBP7/ifgTcsjoUqAAuu3wR4HqDrZ9ewl+UxBU55eVuSGzIkqRO/5vAHHEk/E1kj8hfuENADh2KfYbnH62f5KGebCj6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MisXVYU5Is6SmturRUCNq5vtJkjqzG7ehBrwQ0DfTbw=;
 b=q19gxGOUUzq3fBcpCvDVuvAmm6AIriDjdbUHJ047cWmr7rECSTz2oUeRZ/ulL4a3G10TqdEHJ/XL+yK3c9w4PMz+B5itwPmrYDob9av1F2N56SpoFTy9nOVQ94roosIlAXMFXBMfSdVJZ6Gmn+zrreh3DkOwP48u2cuFSYrlgWD07o4SfsI8uP0LJvcnqn5S9zV3IqQ/M5HhPYcc//gr2ksC27xXv1s2Wye//MZLgz2Dl/yJLma4WUG4QCV5uHo+k/lO82UWaMbTeukXKgC1hmKOhda+7ZUjKoSOCnAb54T3LvMH6HGn/VFCxks+8eUzKWjKmBpJGPFNLWTgp/rknA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MisXVYU5Is6SmturRUCNq5vtJkjqzG7ehBrwQ0DfTbw=;
 b=gWMtGj1CEux0dz0k0cFBFqS0ZhMcXy2x/SOPwoZIx2Fx9Tpoji/pJs/E70L/CErrH5WY3EFpQjO8igrRsQ7jS+kaiFEavM3fSpNT4GE96E388qNazguFAuTUtdV1+Jq+iEEWm73OMGBlfhFatbehYn8Pcsxa8/WKLOGci8VlFoU=
Received: from DS7PR10MB5327.namprd10.prod.outlook.com (2603:10b6:5:3b1::15)
 by MW5PR10MB5689.namprd10.prod.outlook.com (2603:10b6:303:19a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.25; Wed, 5 Feb
 2025 03:07:57 +0000
Received: from DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::43e7:5b82:9069:b402]) by DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::43e7:5b82:9069:b402%7]) with mapi id 15.20.8398.021; Wed, 5 Feb 2025
 03:07:57 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: xfs-stable@lists.linux.dev
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 14/24] xfs: support lowmode allocations in xfs_bmap_exact_minlen_extent_alloc
Date: Tue,  4 Feb 2025 19:07:22 -0800
Message-Id: <20250205030732.29546-15-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20250205030732.29546-1-catherine.hoang@oracle.com>
References: <20250205030732.29546-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0117.namprd03.prod.outlook.com
 (2603:10b6:a03:333::32) To DS7PR10MB5327.namprd10.prod.outlook.com
 (2603:10b6:5:3b1::15)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5327:EE_|MW5PR10MB5689:EE_
X-MS-Office365-Filtering-Correlation-Id: a2e6bb52-98bf-497c-b617-08dd45924a5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|10070799003|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?L37ZA3zH2gem/mYZ0KV0hVFCcBwrUTFiF0brUjg3N9eHUm2PQigRm6Rta85G?=
 =?us-ascii?Q?cL54zhIbXVaPM7lWsgV6zL8BMq3rNGZN813rSVbSr7ecBMMzLm7Bf9PwShuW?=
 =?us-ascii?Q?wo5vfe3QGUYbuDZHvSlrWwgXh2nKLCeFznpklHvVYjOdt6lz2rPITAxY8Oms?=
 =?us-ascii?Q?7dUxrgWVBhRWPjzZ06efJzbWJuCxcLpb0xoS4l5smXo8B+WBMBaQath5ZDRi?=
 =?us-ascii?Q?BNa3SovMgGWp32858t49aVclQ0wIvxudCHS0N/jzvd9DnAoVkFg3LlVZiISS?=
 =?us-ascii?Q?XTIZVo0RLsL6EGcuPExaYr61aC1wYNEx3fAFdG7y4RGcCd21zPTFbH31ueFL?=
 =?us-ascii?Q?JDg6xakl4d+0VQIzQhzYb6HOxabm2xQq7k1vd1J7JUSI3NidPNbnN5JStZzR?=
 =?us-ascii?Q?vfXw69+ag+OVNRudauy+hU6Ab5lxWhmmv2RbZ2PAGrx+RMWZ78+ZbesCn3O/?=
 =?us-ascii?Q?JpIi4y7NREpAkkkb6G24XNhjBqvRSrdw+RtUU0jmIrmVGxHLHszwpyisllKN?=
 =?us-ascii?Q?JyXNMXi9JHDHmBCPvREX4HjpwF828NTpP48AZrgQti4X2nesu+z1NiHNa1Ik?=
 =?us-ascii?Q?4iWuAhQRdune4ZLqKU3AJ7RMInLoitvqo8hBtCK0qimH2g4gMEj94coB1n69?=
 =?us-ascii?Q?4oSg7hCADyKbHNNEnZuwBD6eZ+FDQrbFQD6jqQ7PvwGUKb3xPFyij387xkUP?=
 =?us-ascii?Q?RtsOZHEBuNvOCND2uNimBJQeQ1q74gx7KFPOfNOKpjvYbEgSSbeI1q5crhD/?=
 =?us-ascii?Q?2tMHHaGO/RYEeN5p7xRnU6fH7wh64zXR/kzODBS4kYVzod8voOd86V18+eur?=
 =?us-ascii?Q?UYS40zhreRF2d2xkmzQfD7FqFf6U3w9JWb3V7Ob+J2I2VtdyKBpJQzs6nZtC?=
 =?us-ascii?Q?/ZlY4U5xR0zuCp6jdy/RGb1y5iS7Gx2dgrSVbD2C7PYxDZE1r7u9c0F87vrn?=
 =?us-ascii?Q?WCPZyFDT0ZzsCUsV2jmv6XVseKqdMN1AGZsv21NQ+P8Uhx5iy0yG1TKel9/g?=
 =?us-ascii?Q?TskGUM5F/bMXQ7hbyfggDeFH0/oEHxC32bU3VuVhSLb9lmzRs/U3kuKIU72H?=
 =?us-ascii?Q?yl1B2FbTWNOaLziSnwqpXItTxQ3o7n+skk+lkKQMKSBa/JDiUjtG1q6Ft9Gn?=
 =?us-ascii?Q?78SpPquZRc9rQW+Fmh0JjbgY4CCgBmnlvd8j05SPOqrtfQZtDzTje8j3YqGi?=
 =?us-ascii?Q?B9c5wjAV1vjRZy3PTq4yDiT59/kB7YLf+v/DG/ZH0+cDWnNCl5tUHcohPuNt?=
 =?us-ascii?Q?vT1DmMvouE34TRVDFPUXZXA3LtqszdRvqab9Zmd5JjjPyKDOgwSL3NlxV4V4?=
 =?us-ascii?Q?a/wCNEUycUviTYGDh2SKCY+ubaaSXU5t0A6scVB1PZJ9MxlxSM2kDj8VQb/S?=
 =?us-ascii?Q?yLfx3GVG5Y2pC4GIdRyKEuiTc8lI?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5327.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?T2kMoj74Lh/+4sBlgVqVq1G9uyAfdI8eqvoWz+7P6XeWQVutZMDFjuCpQmSX?=
 =?us-ascii?Q?zPxE8HX973LVUtbamoew4v2vom0KVWFX9AR9BkStw4qjXkqUb8nhw/OMngVY?=
 =?us-ascii?Q?yi1jLqzEdm9gP1BH3cyPGGOVMhfeY90YbJPndhM/27BIqlnTrIJDmRKjiqJG?=
 =?us-ascii?Q?qrdipYzBNfneaTGI7RR6tCwTg+TejyEmk4NE7LQcXNqzuG/h/7+uiYfcWVz5?=
 =?us-ascii?Q?STnMe7/kCSmWo6fiXc/yEWYY/Q4ia8BlCwwkDoMhq7objCQnSe6bgpXXdmPp?=
 =?us-ascii?Q?j7R3V5OlEX9zE4jHFJkfoisW65GeaZz64wx/ffKs3X6s/t8QNvwKgeEixlhh?=
 =?us-ascii?Q?ysR8mA0Tb9zRraUfoUKIh4NiExfqMEUk6UIKGMOs6H/4QmBthcqY3yabWSLY?=
 =?us-ascii?Q?izhpHANE4v18htXVxJc70R2UbSKuMhem6NvUWR6xjMnNvcGf/KQtAPb/tiM6?=
 =?us-ascii?Q?6i/GODwCJZR3Q30eAcrR3iOgOJvG2kiavL47qugU9HnW52rISn54FLp4nC/J?=
 =?us-ascii?Q?Cn1tu6cnP5+vENsH6ongNDdwuBf58DG0sUXwoNV7Uymioity1DWWZFALMsu0?=
 =?us-ascii?Q?pA9AV2AxyJy/o21RaPrakb1b0li9H4mlAUQt7+5+0MUW+dhqZlsdpJA5Rtkw?=
 =?us-ascii?Q?hRYgVsbH+x0EMZrTyXqQyTknYLPNDtnmEkpSiAsPcltYNn6uXftzrKoZwHI1?=
 =?us-ascii?Q?wIX6HjCc72Bds/topaeTUjV/DA/wT8ZHbE1VNRu+3PsFfwRWmBUWj8kuOehe?=
 =?us-ascii?Q?YRDL7N80gYVXVxy8/H9M7R2aXD67J0Y9800LxBfvh0b0yMHJOOpllOBI+uP3?=
 =?us-ascii?Q?++dhjt3O1zZIoTzNyexHYi41HhdzJ7HsNsyyYHliLmijAw/xBqDB3aCKBq3z?=
 =?us-ascii?Q?sB/M+MBs4rB+7C4HZsFeXVZ/9/eEwoHADkoZUk5gJeTfYZxbrRK7eQvTikuX?=
 =?us-ascii?Q?rvrNNBCps6eurn7OSVi+UlgzcQPcVJKl+nB/MjFMRNi3HkCVCLC/kw3Vmseq?=
 =?us-ascii?Q?Qfdbfx8zUpuSDg48KchVbQRi69wIn/8VYif3uQi/mya5OIZT6dL7NRa1Yskl?=
 =?us-ascii?Q?E6q5/aj7jxUWk5VcH+x4u/OsPU8cqkQ3QuZXsukMk7LNgdNEjachg63YXA+i?=
 =?us-ascii?Q?jMw74Tt8WoxKth0dKNZkmPsTuAiiFJ5dlas2c5PhEt+pRJBk/cDFWyqOkNqm?=
 =?us-ascii?Q?ySWlDtfchMcI3yvLZsSxM16/hhjKAN+9ArfnRlalV5ZrQh+q0C9kwIU3s4hR?=
 =?us-ascii?Q?CEzZs3gopVqADOVuD5p9olYvzi9mZn02cEs7G9VzEcjuEK8s2eSskpbLuTi8?=
 =?us-ascii?Q?Aw5be96MNrDsMy0rRynJRJff0yMPzg6X4rTzvGVcqm4Ux/4FSyErGBR0bIPI?=
 =?us-ascii?Q?5mDB1ypgxdZA8+cPAor+5enotvl6KcHPHQR7oIcaUGNKwj7EE2oc8/w2kk8w?=
 =?us-ascii?Q?YaFma9YaYlCf3g9abPTb8IN8E27eOM/6S8GzC0I+G0wRhp7oJ6elYRA+AqFE?=
 =?us-ascii?Q?tHswHgIyyRUBBclkgAUQB0MWNe0vLiCUC6Y4pwwoJrxf2x+HNDUyL8fjNG1m?=
 =?us-ascii?Q?YvUZF6XcyEqi4hesevVOSKzSGzfkiaqeuOrhTm55oRSDQjz3uTADf9nPm9C7?=
 =?us-ascii?Q?A8f9h7LVmjGp+RBJTT4NZquFLuZLSnLlkxfzVFwgYUVNkM5HdS4LbV/iu++7?=
 =?us-ascii?Q?BmA3WQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6HS2XFDhpwTa/x2z48vAGQZwc0UBf5J7lqMhBvp6ZggNZUnreYfRCszYH4AXnVH7Lt2WbAo8L6QSDmxuF8X8MQyWsXkr8ftTj5laecdDNGSPPd1qClPpHt72VX5JyebMJuI3HihIdIG1mQERDacWfOe7WQpr0asy2ZrIsyDF6xwi46MmhaZmlL4ELs+rm20i1tpcUqQOcGitfkzLGyoXEl3eIUKCO6jobiJl0RmvKWVUPqhBtpyTfcrColXekltwGIQ+hXhW+Hm+krzzAFSfytvJGhH2ApDj3xV++dfgCPHzj+4xyVSKORpeKTVGx9AvR7mSAoRZVVU4uDZddGZtGVmJ80lFGkLcV5nHc6p4tfhVK/9mZNcS74dvP22BRTdnAHTpZQHl34/rM9ym8rM328fyDpALfL+ovGBeRGccPKyrp6WtubeoL1Uq4nH9A1cMHuy6mtCZX2m0OIpdSe9QI2o/Rb8Lt27Bt9RXFJDl8E52MjkFzhpWJNeUWHNpIUTAr+zjSJwZmhhncSeH5J55T+A6nhRNbMimVZAZYnTc+wC9PsOK/fckJ7lDgrs0CEji8fG4YTiAvGZvS1VXhAWtQ4Dis8Rr91RVBYFciUt9w+A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2e6bb52-98bf-497c-b617-08dd45924a5c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5327.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2025 03:07:57.3141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BMb3aYhcrf2B69oIB4Vcs5uI3MNnlC74/NTM861sJJJy16nStIT4AjtAqwBW84zy9TDP8PKeTbBUkwvd8EpoXkW4S+PxV3NDVFAJhMcgaaU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5689
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-05_01,2025-02-04_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502050020
X-Proofpoint-GUID: pCTwPfPf2aWNaVII6auUBhLRtyF-Abw4
X-Proofpoint-ORIG-GUID: pCTwPfPf2aWNaVII6auUBhLRtyF-Abw4

From: Christoph Hellwig <hch@lst.de>

commit 6aac77059881e4419df499392c995bf02fb9630b upstream.

Currently the debug-only xfs_bmap_exact_minlen_extent_alloc allocation
variant fails to drop into the lowmode last resort allocator, and
thus can sometimes fail allocations for which the caller has a
transaction block reservation.

Fix this by using xfs_bmap_btalloc_low_space to do the actual allocation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 8224cf2760c9..c111f691ea51 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3412,7 +3412,13 @@ xfs_bmap_exact_minlen_extent_alloc(
 	 */
 	ap->blkno = XFS_AGB_TO_FSB(ap->ip->i_mount, 0, 0);
 
-	return xfs_alloc_vextent_first_ag(args, ap->blkno);
+	/*
+	 * Call xfs_bmap_btalloc_low_space here as it first does a "normal" AG
+	 * iteration and then drops args->total to args->minlen, which might be
+	 * required to find an allocation for the transaction reservation when
+	 * the file system is very full.
+	 */
+	return xfs_bmap_btalloc_low_space(ap, args);
 }
 
 /*
-- 
2.39.3

