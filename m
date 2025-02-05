Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56BEF21325D;
	Wed,  5 Feb 2025 03:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738724900; cv=fail; b=AWWaQ0SVjxM/jlanac8EbLsxb3WJ5bI3E+p+1GOUj6qjkitxd6OOFaFYwRXqb0LzA4fyxYaGNjTFB0JBtWMu/jPFxWrkKOYnVg6Bx16tf3W6TBf/N5+4foLpfVp9qnd4jEM3nOBy9SMqWH3EOz+U0tI3JE4/Bj2OgMFd0LH+DzE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738724900; c=relaxed/simple;
	bh=KbnfkWfq7HC/IxnrSwd9mvi7qYWWgRfh1OBUaAN+dzc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=K84oEn89G/c6sl8e1qgkpAc+HXCd8BzG3YHMmEJ7C3sC/Tf6tXTEdSiyZa06LaeG/SpdhV/h2TynlimxLFxf6YNngNrtlpLRbr1uDfbb7W/dnrZMx9Hfzi0GsQt9cB50AwrhBK+k0q5zwoTSbT7z/Z35yS+T8bApAGVjYbAOGis=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XS0zk4bl; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=XzxbTZOs; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XS0zk4bl";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="XzxbTZOs"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 514NBr5W027134;
	Wed, 5 Feb 2025 03:08:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=EEe4LbZETlTxF9APeBC2ZfTe8Wpu5dNW76/oNjirIgA=; b=
	XS0zk4blfkjG2MVnw5s/ZHcUqSjwdBgjT+8XBWaUGenfmhRCq9a92/wpmGnDeXsV
	NSG74fBj27Dw6BoHLbS6m5nVQKtfZcpSIsyol0e1Fq/mCttAts7CwnSbSpEsNgmQ
	HlLIuuaoS/IgD9Y2uAsN9cgMdsHCWqwYYd7pjckC8yQiWzSsXhIZlKYIc8pg0q3Q
	OvHNyYKflfYxP0feiCIN7aS9GY6/oyDB22l5UGboVvQ6NN0fyJd5l+U7SfDN8GDI
	n7pWQFy6UGkH+2QK4M9BKu8J155M0WPA/ymP6/feqil27UkG55cYs43UmmIxsH5c
	VR+qzjaHjFsW9g/ejab5xQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44hhjtx66j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 03:08:16 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51518Zsa037739;
	Wed, 5 Feb 2025 03:08:15 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44j8ghsn1b-7
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 03:08:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NsjzAl3IuiYFt70utgcsduvmtSps+lkSjafj9xkgKNPoqnWmRpBazBsBs2FHBHLd2kGBmDBSIT9kjmaz7IfNZeBha4EYJ7SjWChQ3fzXqX68JAXwwFmeiCM8CLnOrrHh8f9B5aWRezdHevBnv+bEcHo+3zU30y7JDWXmD+PrWK2IFhOhONHLounUotPTYJrJGctBsaH5C3zs/yV55X66DsK+BOtp1EJEuhuJsWwhT6lgzm6JO2rzkSvs5bPaaGWtU+Zqq6EivIdcOWRHGQQtZ1aKWtsUgR9hIWAy2Mb9DDLnn6x2VS/QVNabvfq/1xkL15qCa7MT5moGJvIwYnalCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EEe4LbZETlTxF9APeBC2ZfTe8Wpu5dNW76/oNjirIgA=;
 b=hB2c8EjayBB1/IpvxiBUFawKSUOCzbkVUhB+0xZhg0mNP/BZl6u4lsRZ6PrL694aJAB9TtVuu69+KkBmmbN202gE8mLVErriFohoeX1v/a1SDJBsVGbmhyhf65PybtD0XXUawZoQO5nmWFRTGdy8v430ufeuuiuSqEetuXrnSvj4IJ6qSmmNPgfSgQ+h0GjxzzcB1nWI7chrQ8SiiWyloZpUxTttRqXt16JmY63gGT8LsBZWZHUasMShSaVTzJczEeMpskRZkGWs24TpnveM7NnsLdP4G00Ie/AhscYA4MkZULabt9ll9vSCYsnFQVcrObHgdQm8s5t4SHR1M+IxFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EEe4LbZETlTxF9APeBC2ZfTe8Wpu5dNW76/oNjirIgA=;
 b=XzxbTZOsOXhKL8euh/8kV4bF5BrN56DjySErUjTAKJHnycwgmw7Z/ii+CZ/JWtO03pGnwJI+eeU2CAV7SEb7LILVHbZ4zP/MS3NJ5OOQ7As0fv89Z/Bhwq9Ixy2pibImCsDDwdpPGPNGs/nZrwF/n+NqH6h9F+/TPNwQvWfCeic=
Received: from DS7PR10MB5327.namprd10.prod.outlook.com (2603:10b6:5:3b1::15)
 by MW5PR10MB5689.namprd10.prod.outlook.com (2603:10b6:303:19a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.25; Wed, 5 Feb
 2025 03:07:55 +0000
Received: from DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::43e7:5b82:9069:b402]) by DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::43e7:5b82:9069:b402%7]) with mapi id 15.20.8398.021; Wed, 5 Feb 2025
 03:07:55 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: xfs-stable@lists.linux.dev
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 13/24] xfs: call xfs_bmap_exact_minlen_extent_alloc from xfs_bmap_btalloc
Date: Tue,  4 Feb 2025 19:07:21 -0800
Message-Id: <20250205030732.29546-14-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20250205030732.29546-1-catherine.hoang@oracle.com>
References: <20250205030732.29546-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0092.namprd03.prod.outlook.com
 (2603:10b6:a03:333::7) To DS7PR10MB5327.namprd10.prod.outlook.com
 (2603:10b6:5:3b1::15)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5327:EE_|MW5PR10MB5689:EE_
X-MS-Office365-Filtering-Correlation-Id: 33839b39-f5bd-45e9-dec0-08dd45924971
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|10070799003|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kjII7d/VjATSMg7H58hlGMrIZYF47Zk4aQC+bb9tbCpfoDNO1Sihbti7tMUx?=
 =?us-ascii?Q?jPWqGnv1TW+nivVHnLJ+7Z0wc4BlkSfCZq9AXpU9y44XYkoovdu96uuhyz6A?=
 =?us-ascii?Q?N8+wJIxRisg2+iqw11ATSc5d1U6O8t9fzdyoqX+t6vET9F6AiPY0OFCGzpE9?=
 =?us-ascii?Q?F+EdI1CAXZp71kmZVnXY4bs73dKOIzMH1bE4XRO5l+LCKnk4/YK5Z0ADvOJF?=
 =?us-ascii?Q?yCvvqgbJa6wVEBjJaGrPDhyM/gt5yTYuXF2wP6LR1uTIyc9EKzJYQpkbn/k3?=
 =?us-ascii?Q?aRgQLIMMMHJIL4L+xFCFHeTVdtKxadSN4f8bh++PQV3AF/3ZYAg8cq7z9I53?=
 =?us-ascii?Q?MpKdtppHMMkS1D+lFdn5wl0EzHDuScCrk1iOGbo1w9qzpMT8+8ttKpl86fJ1?=
 =?us-ascii?Q?f/rTATDBwNmN34zMvOto3NBYRip+SgzGuwEtes5pKAUxMbujl8dcVdUDjUUx?=
 =?us-ascii?Q?EfFIkiJQVkzoTzWrZ0oArv/bbP+GAPfq6D8/ndxnRkvrxEnQu0vRrocZYn87?=
 =?us-ascii?Q?g+6GVl02T/pg8UngAnAva43RXDMx4PAR/hT9Qcd3TdKHkQyG7qYJLC5YXh5+?=
 =?us-ascii?Q?TeSHlPEfuCTJLdIimTIXvmQbAruyG+YavP9aNK3mg4UiUglLv9W6zQ5CcpJw?=
 =?us-ascii?Q?XCJtU7Vuaod4z1to0lNA1f2z8MPoq6M4jgfEUHzfveey/Aq0xEv61jF3litL?=
 =?us-ascii?Q?3VU1WGO2vMYKRU9IaJE2cOp7gDvGDdhjAGXLUc1iy3GmHUh/Gs9AhWKWPpvM?=
 =?us-ascii?Q?JrToheu4DKcWfU/mMjbA8ovjbzFtf//xy4/EM5eBIn0RuAGTDITYPjIx9EdV?=
 =?us-ascii?Q?cNA80r5qnxLqFkvzz8qmg5X//CXUYu9E0Xnd49IttW10ZtMGD7BGNAc4Yfei?=
 =?us-ascii?Q?F7npFwcGsQvn94cqi8d6Uxlug+CXChMgWcMxmBzjvuxYveNv/ywNThJxHxE7?=
 =?us-ascii?Q?MRVtN1Nj6TaHHEILn0dh6MPL9UuuvVzZ3FIimwwc4MdWAqNkMZCZsc2fDrqQ?=
 =?us-ascii?Q?qJeUdn290o0oTTcAwx8xTU9cmY2zaCyIQ0y7rqNMsXjbelk2ACQwHcPPXuzx?=
 =?us-ascii?Q?12ac6K+mv56fGQAuJ0DBmE/lkSNKscHBoZkfSkbMWltDMyQQkENObKP7bo+N?=
 =?us-ascii?Q?GTPYCrVy+VsjHLOPm3CkgoD1OGhscuXudkWO9LcTsiMDbnH31DKjllfq1ZPj?=
 =?us-ascii?Q?/ny0a0eXth97aVTx0A9gpJHUhLqNipHHUOrW48l3FzJCjaLj+4JxWQ0TZa0C?=
 =?us-ascii?Q?0B2q/9WZeJfVRQ+s5TBeYvK6y05aiY4S490vq+zgg0zA3zKlgNqBfCfuMSmj?=
 =?us-ascii?Q?194TE65po+9c7VAzhB6nuzJTKrMI16YUztaRLLf2fsTn43aemQF0esRyzLJR?=
 =?us-ascii?Q?O45qLWlTFjNrNgF8eFB6oYvJ3JHv?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5327.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PsAkNDhjxtnrEMJVADZceYIN+JhbcyMHqUS2fZphvZwSxRUCANR0BOypQRPh?=
 =?us-ascii?Q?dN1ZhgNc0nAYXnEehPlUWEN3dHpKlVEjerYnf9ZrffiGZgxL/MhFskV5UVwA?=
 =?us-ascii?Q?BkAQRj88LE0yWCKJiWtP6oZyZ0f+HQuu+RIfwp03miI4YnNaKTgxhuB3+ZkJ?=
 =?us-ascii?Q?2veGfENjQZ41LT6xteLwbpEwNQe0NuJvFOS/qWy5SGO24P3zA0X2UQBTN4Gm?=
 =?us-ascii?Q?61kZ+Fv7HWyRDOPFZfJrvOIUBN7fHqrElMtNHlQKQYbr9lvvjCF5rmPeQHvJ?=
 =?us-ascii?Q?H7tSMMLaMeEDj3e/MAtebBTaeTPLwWiL68z2AxuKrzlhPg4S2Wl99da9QEkj?=
 =?us-ascii?Q?pAFzR9bhjaRcrHX+btYckmmSyFgKCFq5eLpxy47L97LvbXEkFgARb6wVlIb7?=
 =?us-ascii?Q?lhPqGDa2wCaIFVfpUPpyNOVCl0o2RxgY1FtOu7d4b00dV4/RdAnv+xpGlPm3?=
 =?us-ascii?Q?xbiX4kQ8d84UMy2j05kuW1VMXZwIYtznU0/R09/Sn4gjgExJAUKWARpEd4Ju?=
 =?us-ascii?Q?DntuuLLLq0IZpyiMbZt+XE2dVnS4SFzi3jFZvKceOhIaG7nKgMCSZY9Q+pfi?=
 =?us-ascii?Q?rLoKSPZ6fCyJSCELpWjqWGI9+kP3wIPZ0MW9I4MFvpSHl9mPub5YzptS+XjD?=
 =?us-ascii?Q?Vm8zPy+kxGLllmvm0Z6i5zm2GwN8cDtCTYfpRYqkFmYKIFHpJ7fnW6b2IYIl?=
 =?us-ascii?Q?djgUL+srpQSxU02iUyqJZMpCkpbSZNDHEMbWfcR0TGVutdVzs0tOf6QQo0fc?=
 =?us-ascii?Q?OGa6k3CROESWucnZ1Ke48fFJvEhuHpGJp1ZordF+dOMDdyVTpY+OC9GET37C?=
 =?us-ascii?Q?pGPPKsFEGP5Mm1qf+Zncu8oeUw38VUH3FUi9auvRx20QarDqBcLK2e3wgkdf?=
 =?us-ascii?Q?U+ZgtWBaIGxSraKOkQ0NsgKJrdsE6tzLhRazMrKjCpf7Dmr0jptXT1T4gdlz?=
 =?us-ascii?Q?HuIcv6eLHYBzxRQfxChEoEmN5BaT6S1F3fjCjWpgbd9CXIZ9Qtgymst8CmJc?=
 =?us-ascii?Q?6RnHrMf9+FEl7d58WZCgyHnNI96XY6dfciHLWQO4GclTdmj0+rj4nzuFEoK0?=
 =?us-ascii?Q?3XQSrDorV0S2angc+MzJxKoudifj03YGhPet6z/h2QZcsYSlziwN1DTjdPQv?=
 =?us-ascii?Q?pkPV+tfIz83v0kOGyWIejoYW/qERbBlkRA3Pu1qPH3fvBMGLneFXbSbtlsoP?=
 =?us-ascii?Q?eSnmKw8cg0nAV2RUpT11xR1kKfuikrwf2k4wCYR4LyN3vTzyve3xAqitS/Fq?=
 =?us-ascii?Q?JOXRuGpjAxKr5vV1BrUiQD6uQ7Vhovb8Sb1j/r+bIqsnChWb7h2zvWl1faA3?=
 =?us-ascii?Q?UCUwtfOfzUZxApkWVapISFIKRLP98aed0N5FonLlSaoKiyDx1bwMddVD+e7M?=
 =?us-ascii?Q?25Sk3cDd9FOOlkHKOOE+mqRq2fXR6tTbAHIZ2v0e0tcJqI7fLpuFbnYuSCTJ?=
 =?us-ascii?Q?lIH4YZ/dT6B+F4cbk+Dp91CerGRIJpwxQbQFy1gRX/MriZr+2cvBqcG74h8E?=
 =?us-ascii?Q?CQ52sBi6mGQoDGiPoHuKKK+mK4Kdr80apsYukMM1sgHhgOOSKfcEUX8lIByz?=
 =?us-ascii?Q?0O8Hp+zR9N6rS+Vz8OE5+GA8JtvEFLpXrsNuZagf6MtoSclH6X8IoscovYEi?=
 =?us-ascii?Q?HmEMit6PpqtgnXwZWrzMbO96W3k4bdYU7nn9hC5Pu+/AcQcTm67YJIfVy9Kh?=
 =?us-ascii?Q?w/ULIQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3ofWDJCLQosJ7uGmw7hysVW4or1vglxMffs8xvmnwwP1wf4UB9QTfsDgtvS/CCQfzdDRYEc/nTmpG59sjCXxtVEnkRNekOiuP/KBYlJX1FbXup2kQVIW1AgWHymYFzSUa8z7KRdn0j0vprN5GwzAQpNWf00H/Xudb6qGXmijcVpqwOuxLmQAj3ylrw52e55cH90xfbEe/VVhBYd4PH9UUm76ByYLfY82zFRrQ3bWZ4fXFMPCfFB7MHUQ1oFcmXKrkvmxHgSxbTRQ3Gjv72kPzFujwN8mEOrexDtRU64DyF6Ajo+5A+ok83d3pGtUE1ubTsIjMrhakNlttMugjWNff2NqjA1VYZdSJJRDp//lW2WH+Ar/W6BTsFLnve2OkR5OaH6c6zZJSWam4c6WocrSfq8NLDKPDCQTn/k+zUTyNPQW/CO2tcS7jZ8KgzFH58ryrcPSYRJgHz5zOC0gP68qiUJhPsf4yoohug2/PybjrM8bFQj0s0Zgkm4NXeOY5CyhR4eie9ab9jHSXRnjom8EWfLaRz9mBtWkA+RHpDCoroJbGHcve5OFZOy94YDEPGa9+ftOgzWRf2LzRtfglQoq7n1WPjQwgCuLLBUTJfU/HRE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33839b39-f5bd-45e9-dec0-08dd45924971
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5327.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2025 03:07:55.7680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hpKruao39LQRZuzAP6YWqupaSvNl+4q3AxazeC0NmHfkyxL76cOPuZi8qK3CBfNZfF1RbC7fX96P9gs0GM8964Wsk7psN4wmVkkmteuj5W8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5689
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-05_01,2025-02-04_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502050020
X-Proofpoint-GUID: bccVmrnM6Gylhdau2ckh3icwMjuFdQp0
X-Proofpoint-ORIG-GUID: bccVmrnM6Gylhdau2ckh3icwMjuFdQp0

From: Christoph Hellwig <hch@lst.de>

commit 405ee87c6938f67e6ab62a3f8f85b3c60a093886 upstream.

[backport: dependency of 6aac770]

xfs_bmap_exact_minlen_extent_alloc duplicates the args setup in
xfs_bmap_btalloc.  Switch to call it from xfs_bmap_btalloc after
doing the basic setup.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 61 +++++++++-------------------------------
 1 file changed, 13 insertions(+), 48 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 38b45a63f74e..8224cf2760c9 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3390,28 +3390,17 @@ xfs_bmap_process_allocated_extent(
 
 static int
 xfs_bmap_exact_minlen_extent_alloc(
-	struct xfs_bmalloca	*ap)
+	struct xfs_bmalloca	*ap,
+	struct xfs_alloc_arg	*args)
 {
-	struct xfs_mount	*mp = ap->ip->i_mount;
-	struct xfs_alloc_arg	args = { .tp = ap->tp, .mp = mp };
-	xfs_fileoff_t		orig_offset;
-	xfs_extlen_t		orig_length;
-	int			error;
-
-	ASSERT(ap->length);
-
 	if (ap->minlen != 1) {
-		ap->blkno = NULLFSBLOCK;
-		ap->length = 0;
+		args->fsbno = NULLFSBLOCK;
 		return 0;
 	}
 
-	orig_offset = ap->offset;
-	orig_length = ap->length;
-
-	args.alloc_minlen_only = 1;
-
-	xfs_bmap_compute_alignments(ap, &args);
+	args->alloc_minlen_only = 1;
+	args->minlen = args->maxlen = ap->minlen;
+	args->total = ap->total;
 
 	/*
 	 * Unlike the longest extent available in an AG, we don't track
@@ -3421,33 +3410,9 @@ xfs_bmap_exact_minlen_extent_alloc(
 	 * we need not be concerned about a drop in performance in
 	 * "debug only" code paths.
 	 */
-	ap->blkno = XFS_AGB_TO_FSB(mp, 0, 0);
+	ap->blkno = XFS_AGB_TO_FSB(ap->ip->i_mount, 0, 0);
 
-	args.oinfo = XFS_RMAP_OINFO_SKIP_UPDATE;
-	args.minlen = args.maxlen = ap->minlen;
-	args.total = ap->total;
-
-	args.alignment = 1;
-	args.minalignslop = 0;
-
-	args.minleft = ap->minleft;
-	args.wasdel = ap->wasdel;
-	args.resv = XFS_AG_RESV_NONE;
-	args.datatype = ap->datatype;
-
-	error = xfs_alloc_vextent_first_ag(&args, ap->blkno);
-	if (error)
-		return error;
-
-	if (args.fsbno != NULLFSBLOCK) {
-		xfs_bmap_process_allocated_extent(ap, &args, orig_offset,
-			orig_length);
-	} else {
-		ap->blkno = NULLFSBLOCK;
-		ap->length = 0;
-	}
-
-	return 0;
+	return xfs_alloc_vextent_first_ag(args, ap->blkno);
 }
 
 /*
@@ -3706,8 +3671,11 @@ xfs_bmap_btalloc(
 	/* Trim the allocation back to the maximum an AG can fit. */
 	args.maxlen = min(ap->length, mp->m_ag_max_usable);
 
-	if ((ap->datatype & XFS_ALLOC_USERDATA) &&
-	    xfs_inode_is_filestream(ap->ip))
+	if (unlikely(XFS_TEST_ERROR(false, mp,
+			XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT)))
+		error = xfs_bmap_exact_minlen_extent_alloc(ap, &args);
+	else if ((ap->datatype & XFS_ALLOC_USERDATA) &&
+			xfs_inode_is_filestream(ap->ip))
 		error = xfs_bmap_btalloc_filestreams(ap, &args, stripe_align);
 	else
 		error = xfs_bmap_btalloc_best_length(ap, &args, stripe_align);
@@ -4128,9 +4096,6 @@ xfs_bmapi_allocate(
 	if ((bma->datatype & XFS_ALLOC_USERDATA) &&
 	    XFS_IS_REALTIME_INODE(bma->ip))
 		error = xfs_bmap_rtalloc(bma);
-	else if (unlikely(XFS_TEST_ERROR(false, mp,
-			XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT)))
-		error = xfs_bmap_exact_minlen_extent_alloc(bma);
 	else
 		error = xfs_bmap_btalloc(bma);
 	if (error)
-- 
2.39.3

