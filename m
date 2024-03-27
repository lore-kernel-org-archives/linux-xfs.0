Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D8211FDA;
	Wed, 27 Mar 2024 00:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711498407; cv=fail; b=DBvq8D/E7ffq/QKzLvrSi0xsjq9VAewLv2avN/oSg1E6PDo8Bc6t1PL6qYh6C1AyIGoedexL6A3SnGivVOEG2Fdxx/XOlLHOCJguKQl960Z5yjHAiLaib5ujX/ryFGfxqihCoURWqmfDD3Ft0Vb+1My1yHHPLtpuBPanhM29A0g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711498407; c=relaxed/simple;
	bh=HSU7HkyTVfAOcVIJr2863NlNJKuOe6bZrhr1LOqg7/I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JIeyT+0Kqt91IZcPdE4K+l37WHLMQlvmjVGIjmt7SZhEmxPASuO2c+PBPIz5jZr025dGqs7gmX8pEjFNuT+noEMG7MqGeIFnjkwtv2af0Ta06PasWaiW2LxTPEFheS75HXkcnen3F7zv4BJlMKqIV/EQpvnCBA8Hmzx+/e6RQ5k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UXqOAtQj; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jOzhnqWS; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UXqOAtQj";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jOzhnqWS"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42QLiWHb026015;
	Wed, 27 Mar 2024 00:13:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=tovxCgrsxy9/t2Tn2Fv5+TYf5Ipg/jFugxg2ITjM6lE=;
 b=UXqOAtQj+2HZ5+fSMSD5XvXmvYGccg6bL77DFfEXq9ln/WDtoysaco+4fiKt1hhDprTM
 Ri7ZbkhXHxRouKD4Qg9VysPu2deS8zwpF+u6L7BatIO0jON91gP4X/omSMejUIVLCujn
 Q4OUqqEvdH8ukpOorDVgY/OHVYuTWfhlC+aSUMPgKC7Ll+MXP1o2mlAsZTg9Eld9iKj/
 4kRKmHLXZHsP9FL1m3n0hb8xdbh12vFEoWxI7mVeApaCcY0e1WjynRmctLY+hxyLaUwC
 AL5nmxb6seLAl0195Cf+ScgMlLtZeYtgqMdf32mZS4n8MAuhjlFrPIotV/hXyT+CpVUb qw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x2s9gvsd3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 00:13:24 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42R05MAm020824;
	Wed, 27 Mar 2024 00:13:22 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2041.outbound.protection.outlook.com [104.47.51.41])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nhe1akw-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 00:13:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HYbgdghcDoeLgtto9hkB+SgyXMrdKhBY7h3Wdsmq6uCcaImuQt2xEY/qEyU9T9HFquqbc9U0bBP9ak2Otqi3XhP2NIdHsQsuibtcNQN8giGkzslAeN2lLMAXGaWY0PVjfusUHXvsQOuRS1xpYO9DohwmrfIVVQuWsTxk4RRZ/Qifh780lJY1YmwmVvTraUtfN8y9hLhk+j2ZpSFEz80iONE4VNmi7oBKl5D//f7174KiT+LBePYDBcO6WeQ5zklV42FcYT5W9OWwj7OHxcX+5DRQrbHVj1kScrhISMCGpClKn8u3l0g74hw/aGgLoO+29JKRsVEABm1R5toK+dRq1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tovxCgrsxy9/t2Tn2Fv5+TYf5Ipg/jFugxg2ITjM6lE=;
 b=flWinUw41IgvXWIacKDXJlINl+Fn7NPkQ/le69ralTMOV1hUPOIEuD8aFqHb+Oxvxh/L/VgtkMMpUqec4GJFRNrCdJ6SJ1qmdd8zSeHUwv11UoMyVayEhn7YIjXGwpSnJt8IWEVTD71nFNoxMElqm4gBFi1C/D/00zJfEa/tH54tjqNudwba8vefc0UmmB/1l/Jt/PuEf0l1hn1Bj4Bs6wTuTnc1q8C5NRngyVrl+OnvMUZHfCxECpWSG9wB9l2Y1+GC+81RwNujEciFG/ZDG2OAJ4QZh4TvQSa/5Y/MWxlcxYsGc0dvfraRivaQ1u1fr2BeKprgXARSHACCkBG3vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tovxCgrsxy9/t2Tn2Fv5+TYf5Ipg/jFugxg2ITjM6lE=;
 b=jOzhnqWSpXP1Y5DLmf3zG5YwIJH2yUQwdgAJ6q+nT7dNCjARqxI/6g3G0QcbCQxPhJqeThQ7SNtDX1v5EgT6/s0QX0yMA1djHnOq7x5JHe49QnRnIldlKtSRvx0KfVIjErNHrQqB2JTRgHGSnpdF8qUr9X/TZn8wJkbtVOkQJXo=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BLAPR10MB4897.namprd10.prod.outlook.com (2603:10b6:208:30f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Wed, 27 Mar
 2024 00:13:18 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a%4]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 00:13:18 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 17/24] xfs: initialise di_crc in xfs_log_dinode
Date: Tue, 26 Mar 2024 17:12:26 -0700
Message-Id: <20240327001233.51675-18-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240327001233.51675-1-catherine.hoang@oracle.com>
References: <20240327001233.51675-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR16CA0035.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::48) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|BLAPR10MB4897:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	gn1oICuzvKi5lY7oHqwKEj2SmefoZWvw7q/EZP3OnLfrp1MPoMpsLXcvfs8K01HkS11KLDF2EHXWXjEqGhmPJqgBlybrQUT3V4RVQc8kAk8HzKyvB8wdDV9XgN5WUw5jzPJXBu7KbIgzeLoC4G1IpBpUNvrdGtLXoBBNcFs2vKrPVcq70yPPqwYDipKqsBCD8d4vbIC45j4540kKI/vi0BClhjdZY3duhzJCc7rNh8jhtB/3tNtq8FLgO6jH7m3GGQOTivfypaqbcRA7MhbU3RnAyv0C1CFA57I2h++kzdzlh8xrLCPrLjgYcKLaYTaf9DflnB3qKhan6rZqmLpgDrsScWJ/HDgtXKJYLoRxWCISxON/cgtvNZoMDz6seXPfsm99pBdPb5YqYPIANXnRkNWxR7ixmf7X48WkNOpatDc2HQY14IM368Y8YnJNPs6fq0lzJGp7NcKOdbQTmN38hpXv4nK1BCRjNUr+mbki9VZN2I01rwMb3zrxJggnprUUGx0k5dgcAtyQshhp4cJnU6ibZdpWVfvToc1yLCYRohBInT6nXLnvlVKlZv7uF8+HuVoOWS7P2kgrSXmLeYO5SObLslLE6TnhF6BkcW6ptsz7s6W4zPpaweaLezCbMmx2SIV7EksJZh1PAqgSFyBI1+NJJCyIy9q8FND5plnnsRM=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?2mQZXQnIkN7g2JnMaOmipzJKy8TAixCWFTSp5PNdujDl884+MeKkzJgch5Nt?=
 =?us-ascii?Q?TfEm/ZfpAxH3NvPd8DbWRpjSVqjZ/tvwgWuUHYOWhi0BW91uagkCOcO8cS2u?=
 =?us-ascii?Q?RbvKMVpt440na1sB5WppW0FHtClSBMccCBF37BSiWgdY283EXuiODOxnPShu?=
 =?us-ascii?Q?8DFhSHzLC8t4MUrwYIeR1GziU1GZVnHH6U21o/eoAdFIbIGeEINi2iejoxbh?=
 =?us-ascii?Q?2Gc4m+Grgiia+Zmn9r4QlXBxXgSNuucpSWPjMP8ZsnuHcX3LVkZoGSgFszBD?=
 =?us-ascii?Q?dbtL42oqHjmyQJ4k+nzKkTKZTImeCg35pxPZgFlpXoLTU2Q7djcSdqno3TM/?=
 =?us-ascii?Q?yqxjKu/v9/5BfH7E0W/e9KUhp6+Z18w2wMw/zV5mrjAeHtaNnJq7LhszgjBJ?=
 =?us-ascii?Q?i5pZtxgjqH5WTAIV38wIdPn2dvrIbpC2aMq7EYcL2IO3RTLvOJetgOxtUqqF?=
 =?us-ascii?Q?5dZTnDnwLFNrWuWuv6fPhazIWNEWEMR/+UyPJGRyE9UR4Mxy9l3fo3n2AWx4?=
 =?us-ascii?Q?pg9Py4tHtMXCAY/hByIfA6L6xUvntys4TTvHuC9AJKT+F1a3Il4tE5xWKQxK?=
 =?us-ascii?Q?XQqPdIkslFF7Kknw+6LlhQfrZL965w1w5LXQXnm3z9U/wpCydS91xUMMEmGb?=
 =?us-ascii?Q?F9wdgNn5rR3zq2DREPEfKkThWaOAbkVTwFR/ei+tJcyy1R7uY/Ct05w7ATLJ?=
 =?us-ascii?Q?3Jb/lku01UDw2vL93lfQz32PpKE0GDTD5PhnUtz78cMkMNPI1kj++W0TjrQD?=
 =?us-ascii?Q?MEUPQyXliJwY8PZURffprCJtg0/u0Vy4gAyFitUjBl2HuUe6WuTsioQIgLzj?=
 =?us-ascii?Q?GhvWai+iC4852vKBfLhevAaiEKzMyDvGRopD+CKFgVEUDQIzOjg3dlUkMSzn?=
 =?us-ascii?Q?doqqTJRHQXYHuKQk6PDCkGU8O0yLRTJpyOiRvSmNlnq6xQHGZqRyubt8lsbb?=
 =?us-ascii?Q?iQBeC7/syoh9qv4Td956t3ZHrTFjk2r4VrRFuBjZVEsS7GD7jriY3eG8nX7M?=
 =?us-ascii?Q?BrYsmjNP2KUETkiOkEKVY05LWOUSZ6R9baawqEnNZMrTQJrRYsKGTAEnnv7c?=
 =?us-ascii?Q?oZA6vsWy+HHLQLeYRcuTPDRpcZTwy3L3UkHZ6fdJ6HuydXPRLzy+wU+4R9+Q?=
 =?us-ascii?Q?rc4iVF0D1GdVkI1eibHGTR0UT3/vOTADddLy2e569gVhAZfrhX0nQA8Z3qkH?=
 =?us-ascii?Q?SIQ7T9G8hNqRLeIXQYIYZJhoLCw+p0jkRyb8B8H6ss2+AStsuCXxgXHuO3iu?=
 =?us-ascii?Q?1izBxcOD3sv5igievVul3ZvUWRbuUN3kt8eDequIY8xmT/29z0w/s88nEkV1?=
 =?us-ascii?Q?iRgz32HMXzhv3IvY+NAfz9tHHxJ67s0FL3b4Co8ovDHZGrRR+25QrI78q+ja?=
 =?us-ascii?Q?eyYVL2YEqsEc2bYe0ALu7vEur5VkPMVOd7OLpQDyVKwmBpc8QJSk1pWBaKHj?=
 =?us-ascii?Q?CDk4NcXpCC0J7RprGSoiyTQuKxHNTYJd2M/KwQ2B+qmA4ywRtRTTv65j6MIH?=
 =?us-ascii?Q?+CYF36MqlGxxJpr3Se0igdtIZHlt+t8baFjedaovmsnmnv9A7kP36JlttxnK?=
 =?us-ascii?Q?W7gQ/tgWCg/NLDgP3qTvlorACBU8YSgrj41c1ry7w5U5sIH5ZJsfuObQj0gE?=
 =?us-ascii?Q?nfO++AST/gg8x/4eiE+B1CBovPvrkVn71NQRLgAnA4dlAEDl7090VZw+/F1G?=
 =?us-ascii?Q?Q70KEQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	cz9lY+aLdq7MMyjBkYbMwU8Qf3yo/Ta9KJPIkSVZ+03Labdybb+X+NGdLM+B7C1qZC2BSIKGVDdseq/MvZsaHg064G92Wk4XPwZC3OKDucZTNt1kF3bHtqc0aPlVXVZ0ytdGGD4lK1E4LRPPraCOgVHDg/122qBgtToe8BuiJOhbUI7zeoznNcMSf0f+nt80kGiGPDVznYnSQ9DLNX86tphByk9RyFzdJT0HXl8yxLv2N/WNGNBzfCnPGQblC2gRi02GO8gfFrfu/cNXShM6K7UOIxlIbhJuqc1D3spVJnYzSGpS5iub8dpLnnEWx+xgp2cx8gnNG+e00nWOx7b2Fos0YzrQy4n9cNNFmX8DxCDIj7ZKvaXAlDeLCSSGt08U/FKlGYbk7fH95c8dgeZE25GikVKb0KuioMYLrMvIv9iytwrdZ4ovZ4WvQY7b1K6cb+5H7Qhc4ApEnt6xSijX0PJSRsUp/uyL96Vrr9ueOQdaIt6M+n/PYqYn9yVWHvLTDWHsnWx9NpanRXmnhXOElk004E1n5TWChWJtkN8KmlXkU0/+xtwjz2lKN8vb484E+FX80ukkeDsaWXwXZkiWBbGXaxTU4MRz3DfIYh23r7k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b34aedf-1200-4115-df55-08dc4df2b45f
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 00:13:18.5063
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ncRcS8P/UjX623eQNFw7DnIYjhNTAZlndwW7kaDsSfwGhsOKYzqebGrG4fgy8sFbRDRLgBbuJ7zPl32MOTvXvpMATSzi3JZafvpkx6MlyuE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4897
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-26_10,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2403210000
 definitions=main-2403270000
X-Proofpoint-GUID: 3ulnwcFwV3GQZWbxVMcdZ2oCKADMkhJw
X-Proofpoint-ORIG-GUID: 3ulnwcFwV3GQZWbxVMcdZ2oCKADMkhJw

From: Dave Chinner <dchinner@redhat.com>

commit 0573676fdde7ce3829ee6a42a8e5a56355234712 upstream.

Alexander Potapenko report that KMSAN was issuing these warnings:

kmalloc-ed xlog buffer of size 512 : ffff88802fc26200
kmalloc-ed xlog buffer of size 368 : ffff88802fc24a00
kmalloc-ed xlog buffer of size 648 : ffff88802b631000
kmalloc-ed xlog buffer of size 648 : ffff88802b632800
kmalloc-ed xlog buffer of size 648 : ffff88802b631c00
xlog_write_iovec: copying 12 bytes from ffff888017ddbbd8 to ffff88802c300400
xlog_write_iovec: copying 28 bytes from ffff888017ddbbe4 to ffff88802c30040c
xlog_write_iovec: copying 68 bytes from ffff88802fc26274 to ffff88802c300428
xlog_write_iovec: copying 188 bytes from ffff88802fc262bc to ffff88802c30046c
=====================================================
BUG: KMSAN: uninit-value in xlog_write_iovec fs/xfs/xfs_log.c:2227
BUG: KMSAN: uninit-value in xlog_write_full fs/xfs/xfs_log.c:2263
BUG: KMSAN: uninit-value in xlog_write+0x1fac/0x2600 fs/xfs/xfs_log.c:2532
 xlog_write_iovec fs/xfs/xfs_log.c:2227
 xlog_write_full fs/xfs/xfs_log.c:2263
 xlog_write+0x1fac/0x2600 fs/xfs/xfs_log.c:2532
 xlog_cil_write_chain fs/xfs/xfs_log_cil.c:918
 xlog_cil_push_work+0x30f2/0x44e0 fs/xfs/xfs_log_cil.c:1263
 process_one_work kernel/workqueue.c:2630
 process_scheduled_works+0x1188/0x1e30 kernel/workqueue.c:2703
 worker_thread+0xee5/0x14f0 kernel/workqueue.c:2784
 kthread+0x391/0x500 kernel/kthread.c:388
 ret_from_fork+0x66/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x11/0x20 arch/x86/entry/entry_64.S:242

Uninit was created at:
 slab_post_alloc_hook+0x101/0xac0 mm/slab.h:768
 slab_alloc_node mm/slub.c:3482
 __kmem_cache_alloc_node+0x612/0xae0 mm/slub.c:3521
 __do_kmalloc_node mm/slab_common.c:1006
 __kmalloc+0x11a/0x410 mm/slab_common.c:1020
 kmalloc ./include/linux/slab.h:604
 xlog_kvmalloc fs/xfs/xfs_log_priv.h:704
 xlog_cil_alloc_shadow_bufs fs/xfs/xfs_log_cil.c:343
 xlog_cil_commit+0x487/0x4dc0 fs/xfs/xfs_log_cil.c:1574
 __xfs_trans_commit+0x8df/0x1930 fs/xfs/xfs_trans.c:1017
 xfs_trans_commit+0x30/0x40 fs/xfs/xfs_trans.c:1061
 xfs_create+0x15af/0x2150 fs/xfs/xfs_inode.c:1076
 xfs_generic_create+0x4cd/0x1550 fs/xfs/xfs_iops.c:199
 xfs_vn_create+0x4a/0x60 fs/xfs/xfs_iops.c:275
 lookup_open fs/namei.c:3477
 open_last_lookups fs/namei.c:3546
 path_openat+0x29ac/0x6180 fs/namei.c:3776
 do_filp_open+0x24d/0x680 fs/namei.c:3809
 do_sys_openat2+0x1bc/0x330 fs/open.c:1440
 do_sys_open fs/open.c:1455
 __do_sys_openat fs/open.c:1471
 __se_sys_openat fs/open.c:1466
 __x64_sys_openat+0x253/0x330 fs/open.c:1466
 do_syscall_x64 arch/x86/entry/common.c:51
 do_syscall_64+0x4f/0x140 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x63/0x6b arch/x86/entry/entry_64.S:120

Bytes 112-115 of 188 are uninitialized
Memory access of size 188 starts at ffff88802fc262bc

This is caused by the struct xfs_log_dinode not having the di_crc
field initialised. Log recovery never uses this field (it is only
present these days for on-disk format compatibility reasons) and so
it's value is never checked so nothing in XFS has caught this.

Further, none of the uninitialised memory access warning tools have
caught this (despite catching other uninit memory accesses in the
struct xfs_log_dinode back in 2017!) until recently. Alexander
annotated the XFS code to get the dump of the actual bytes that were
detected as uninitialised, and from that report it took me about 30s
to realise what the issue was.

The issue was introduced back in 2016 and every inode that is logged
fails to initialise this field. This is no actual bad behaviour
caused by this issue - I find it hard to even classify it as a
bug...

Reported-and-tested-by: Alexander Potapenko <glider@google.com>
Fixes: f8d55aa0523a ("xfs: introduce inode log format object")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode_item.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 127b2410eb20..155a8b312875 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -556,6 +556,9 @@ xfs_inode_to_log_dinode(
 		memset(to->di_pad2, 0, sizeof(to->di_pad2));
 		uuid_copy(&to->di_uuid, &ip->i_mount->m_sb.sb_meta_uuid);
 		to->di_v3_pad = 0;
+
+		/* dummy value for initialisation */
+		to->di_crc = 0;
 	} else {
 		to->di_version = 2;
 		to->di_flushiter = ip->i_flushiter;
-- 
2.39.3

