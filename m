Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDEA5153817
	for <linux-xfs@vger.kernel.org>; Fri,  3 May 2024 14:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714745046; cv=fail; b=YmOrGzQgpHqq7gKEsZBvU0igBhKuHUBQo79gY2Q/3iz5JocYlERU8qOclmJY3+5l/isE3d7VEtbd5K/JyIRYq32g/FgLitbKgxAT70NIzhgOHxD2ZiN+W1BdG3tO2MLEwpw8mzNR0S7CLvO+rLmf6FJ6/Pqc0dUJD8YjaBB0wkA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714745046; c=relaxed/simple;
	bh=UyE68oX8cy5MR9VCRIymK/5Y6SN7PUU93Vx0h1w+i1c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=P/LvyvbEK1D7MdheDXcqzRB20v6XgyWanJGW15aW8EMKlhaQMvSTqy5UXKu6/BU8nbzNFj/CZbbtU7kmLqv0j0ywQNymAyoOEgGeEQLjkxkzQzv70iFjHtF63cv/BxEl08jaUybJ4Ly6ypOsno2xBINBco6ejoq9f3ElZZQWpcI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bZVTqeZ8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ZMYfsNiD; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bZVTqeZ8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ZMYfsNiD"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 443C2R8P018595;
	Fri, 3 May 2024 14:03:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=cVygmGx4J7x/Y83h5Xydhhb9Fiu8T6Y+AZ0c/CiyfdE=;
 b=bZVTqeZ8rDud4VNslLAzhMy8IrA0p6Gho1beNMIbDt9mGtiKeDQ/ckL4ZaHvB8UjgKPk
 2xVJZWBe6rJKL2wML55y11M6/c2ngHp9VNO0ceDIv3zGz1F8rg4m31af9rKrWOUcqLde
 +UZ1m9OBNHuI7QylmgRFFBR7+xju9ldh+xv8eCStJRnCP6IWDPu/AbffpT+gq6sMbuRr
 2COgBkGpSC1T044YOdevumrtc5LZw3V2KctuX5nFXS7f/T0pd50tpRsMa+V9+kDFGehF
 ECTG0odWU/q1/xIuCG9TPmvSj/guWXoxsZpEatGoCmiLkCKXuF0q4yJ+KBUbMlvMCLwv Ew== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xrsww0c68-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 May 2024 14:03:54 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 443CvQAY002142;
	Fri, 3 May 2024 14:03:53 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xrqtjckg3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 May 2024 14:03:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Trs5tk1eJFHOtk5zgRHzEV0ansnMaAFSSgxJGTUgi3ZgI1TgQdpgaGNjz8CAk1V35OmGIrg24zWigfqDqc+3L0dT4oNNO02BAsQxJ9IQ1hASAG4u2i3rMzvZpmBcyybz+rbnwdoiUEtLpnITWJY6Rgy6pZfPRzMfWglOsNzasVk8UdCVGVVeN8q2420vn7wMxK7dbxDx3VYXUoxE/GAwSffhjPfBp+7DE3Cz39E1FAyTAWXXgS87hJ20KsYu1t32z0l3UDwU2nwIdCiiouQdPulT2Qd2Zp9IdS/n4dQwtjdQYanQuWYF3UjQ41zZSC/p+E6KZmNpD6fxX7xGimpVAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cVygmGx4J7x/Y83h5Xydhhb9Fiu8T6Y+AZ0c/CiyfdE=;
 b=hWlJNOBACmPrPPR9rnmE7zh5A2YPfqmOa60/95uo9ejlr1nvbUz2OQxh4DwK6DjybcpBtOyJ1Sexb9FatUFfH5//8MaGvKN+8nM9vvkV+kJVVgcNT4WQwmltYKabWzcySGJjZQJ7nWNMr6vi6ano6vSWUSkckYIYGTarqtLhvO43FpM0G/aPy0QJPfeb/jelNE9yztr3OKoEnN1rcLKhXWu3lG3WgINxLZE10ZDiO465e7ZLQxpJvE4H7hgm2gK2SHthHkUJJ5M8M3LubDL865UDiXWiYUBy6hSJuTRZaoXSUXOkQq6apWSqt94BFh0rWxKNzALoMac/i5qnZ/Bv3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cVygmGx4J7x/Y83h5Xydhhb9Fiu8T6Y+AZ0c/CiyfdE=;
 b=ZMYfsNiDyMeNUoPMWymXJqZa7ySUVNWLQqLokkkWD9wJaE2KBNuREs1UdTsq92+Bl1ziaBqlKGH7o3RLKnQfjXcqI1vlryUn9QLWZAPmwgLO9IkjR3xeoNaw7kMVorEbIohjSH2/DmPIS8u9ExtW9+whLDK96nBoXch/iHBjLko=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BLAPR10MB5074.namprd10.prod.outlook.com (2603:10b6:208:30d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.34; Fri, 3 May
 2024 14:03:50 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.7544.029; Fri, 3 May 2024
 14:03:50 +0000
From: John Garry <john.g.garry@oracle.com>
To: chandan.babu@oracle.com, dchinner@redhat.com, djwong@kernel.org,
        hch@lst.de
Cc: linux-xfs@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH RFC 1/2] xfs: Fix xfs_flush_unmap_range() range for RT
Date: Fri,  3 May 2024 14:03:36 +0000
Message-Id: <20240503140337.3426159-2-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240503140337.3426159-1-john.g.garry@oracle.com>
References: <20240503140337.3426159-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0023.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::36) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BLAPR10MB5074:EE_
X-MS-Office365-Filtering-Correlation-Id: f932d20a-7b4c-4a96-d061-08dc6b79dbeb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?MoaUI9IaoxWxWkams+/4/JtQ/wl2ZAS2haIX6hHi75tzSwT4bNigZtt+ce0m?=
 =?us-ascii?Q?IoyNIMkqYsvHHnfOYU+gflRnImYsjIBZYAWfnfvkf9fFYx5GucvAT6SWgN4A?=
 =?us-ascii?Q?G9IreRXKCAJpDTlamvElWnihoipb8XRHRJq2C/h1heDb23iNnRrnuuHje98Q?=
 =?us-ascii?Q?yCbUSBDnaGD9EvuVjF2GSrEB97y2OoUH/pCI/szaYyk5sbvSeTYG60UcvIuQ?=
 =?us-ascii?Q?aI6G69OSrz/Y1xk3nDIm3wxge9J6uX3SzY9sX3+Czlo5VP6X1DVn2/S2qWpk?=
 =?us-ascii?Q?sqH1sQmLvM16IsrEw9D2NSKW9AHyA8QQlgw7QxPjR/D2JEuhZfBnzQuL0sjK?=
 =?us-ascii?Q?xR/mhz2Y/kdttWgIu95pBZrsD1zH+vyCt3NtNPqcNFzKRLEpC0TOgCHlzJ5+?=
 =?us-ascii?Q?+LUyqmYHyCZVFTO5p0oJAH8en7hDbhMfEXpq9pnyKYNhxfDwnAyCQqH+55/b?=
 =?us-ascii?Q?fJcQEUS0QosAEu3S43bd7VmwF2EUxdaqKttUNAGDEpDWesK+s2RofYtWHvoq?=
 =?us-ascii?Q?3++hfmAtBOxs30gwf4bNAwqCcv6uAbAyx92vEBKscTEC0z16HQJ8iwCOiRQJ?=
 =?us-ascii?Q?guWgFdoH8L5J8egtloHUdzJ1qC5XGvjTy9HoN8n9e4C71qjqq8ljLjbAYPw3?=
 =?us-ascii?Q?cMR9qNab+XE/iob4TxV+EVTKlpEaU6i/DvOQ0XviZCbl8QI3XgWZkqVNREYE?=
 =?us-ascii?Q?B7MA+r4Dj0dHma3MWgOY8B8idwVvu8Yl0Y4zB182UB21iKKEYFoOLY3hLeyf?=
 =?us-ascii?Q?cwNrBlmNw0ZbvPEWgp28ef+m8MgYpI/54aU/BTi+63Wv+yKCBjo82BXxBB+/?=
 =?us-ascii?Q?jyq7npKb+RiMHo2tEyNbRc1bS+1O4VFgk0oKBThuh3m6E5pawxhOEHFGquXe?=
 =?us-ascii?Q?T907P8H5QVYl8tIeT6dcgCXOxyRDDyt+qtTHpcoa58QURgVujPIylNNuiayI?=
 =?us-ascii?Q?t1lioBd5lacgRtH5fPDImYXZ9L3TKuikoD1rXy0mSGPzWbk+nlHDP+orX5Ur?=
 =?us-ascii?Q?nXTSyrGYNcH6lqii2MqROTT3O1++VCNBylGs+ymmfa1AWsrSpycYpFxYYlTT?=
 =?us-ascii?Q?MxZ4AV6KmRebL5tJ9TEfmMs09NfuANMH2VOyNma3sys/F/ZznnfXul+udx0v?=
 =?us-ascii?Q?pNu6pgOw0wJNldPyFlTrMbmN0jl29Spjyq+RIXmuI+fT1ADvTUbak7mXSHQv?=
 =?us-ascii?Q?xFji21dVp9ojrD1M+GIZaKMYWjXh6uoy/6PgROQZjdQ+OJY7OmPCVKL0qMrC?=
 =?us-ascii?Q?GPT7hJLVwqqSgbniV4sOZOYDXfWXGFCLybCsmClAQw=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?taqn9Rq1qVetlPFfGZY2ArF/WsTDMn213aATC7CV7ZABVhlfGGVPDx6zNMs1?=
 =?us-ascii?Q?orROJUyLfd/fphwif3mRiSZockFtAOVW33xH8bVFkEu0dP1hgrtFO/5/ahuB?=
 =?us-ascii?Q?Dkce82UUkd7KA1t2LnoMsAU7lAtFtJYXVetYIH2M9qyigw4vp/9WjQ/CjSwb?=
 =?us-ascii?Q?nv4wdrC/19NB+uiaauEqSvcxGm4idnI1MVYy2MFDHHU1lWgOFcAOuhIPnD1w?=
 =?us-ascii?Q?FDf9j+7C1vQEkyKB2k3KmRzM7lly39EWE0V6QkR5N70f/pwlMEORZe4ivHvi?=
 =?us-ascii?Q?OdYwHS73WEGhc26wfeH9LAI2tRI4iEDPKe21/dL8PN0THvy/ln0A8dv7maXa?=
 =?us-ascii?Q?d20yX735tanbAAAB1LCqVHDKrHucmPFXz+tkO8kKapo6nxabGqpODtoCi28q?=
 =?us-ascii?Q?Qfv7n2QNXUgLwZLHY/839oJUk39D/gzxusgRsm21lkFrgKRXvxSnz587hCjF?=
 =?us-ascii?Q?odpNHIuo8XFOIa7xEYgCpBiZxoXRdU0wi3sQd7HxeFNgDHHUflnbxhRSlPd+?=
 =?us-ascii?Q?sxIIU9ZuqWl3aQRq0pKdVCuwkbbRpjcjhB9AZNtMrj9mnQHJyY1mDoWdcrlH?=
 =?us-ascii?Q?BAIaJYjUy0Jqa/OBXLAXThFhaPbzRsIE6pr4KtfZrEvvj9R9AKSEDdbHP7XQ?=
 =?us-ascii?Q?Q7siGmCwXlbUWr2tR3ibze72RMRE6jwLga75/4GXOVr2EWJ1f+vV7Tc10Euh?=
 =?us-ascii?Q?5ayBGBZMrJL41R6gnPVo+1s57UKaOg/rzHgY32BMBKXNv+bRNryDpXcr0WMl?=
 =?us-ascii?Q?YiT+wq0YH68PtVUbZeZZys5dfyiEycmi86s3gAhVg5767t4HwwVjzUTfg0FZ?=
 =?us-ascii?Q?6SYBnz0wNqXmnTora5yBZg0jvZXcxUSqPYwPUXdhWVeRdWeEkUtKxhcVwZgK?=
 =?us-ascii?Q?ZxdSPaiI3SswLeRw9hueCS0Talv3sOOmHG7xHajMDXCgs/5/VFzGzJG7gVnJ?=
 =?us-ascii?Q?xahANzqekOhYt2t729mt4TN9wbZ5HrSRz6FYsQrvNqxqr1BcrxVSzURGI0Of?=
 =?us-ascii?Q?kxZLhBnf+MEX0ukvWlaFDHG35orEfi/pOebhrLLvzDDobPQO/nT05Kl3Ji3U?=
 =?us-ascii?Q?VKJoUp9DgMjxFI6xXbINuEGf+pbuMVzCIU9ioCJvmwP3dNZojLhzlyK7dRIX?=
 =?us-ascii?Q?33vEDrBeGYfd4K7O+V2schZdXZHS5iRxClJ/g4pPKg0OTL9hrS9JugDSMnul?=
 =?us-ascii?Q?ycJ0YZzLJ+waRl4LuitIcmmIOz5QK0Sb8i8ykDuNLMQy9ZDY2/BtXBMkautx?=
 =?us-ascii?Q?CDRkWTlLbs+BFhe3Fry6PyPXwlj0QeYFGWxzC5a3Ht6QKpTWZ4ER3qV2xG7r?=
 =?us-ascii?Q?/1T6Ak2Aoc/4/zRu9Efw6a1XitVK9iN/ByNHil/rPKaJxQGQ89vIkBzdL/0k?=
 =?us-ascii?Q?mJUd1t5fhQWpyj/apNYpD9Qji6iFxAcxsZdHedn1R3Mweuz2OP5q6VeQmyLo?=
 =?us-ascii?Q?pEoQtApSHeuuFoDQyziFwI+Ohz6kaQDrzSiTLmKXWDyjUiRluD2Kzhgvk/t2?=
 =?us-ascii?Q?lASiZzRWhdaOAVksiMxzxadgrmE7wuFjmUiOrup6omAlmR2QCTb1RSNZpEtY?=
 =?us-ascii?Q?BFAL7A7eeNdVWv6cTdvkknjau7JRNtTS2px/pyf6mF28qYoSTSUpA4Pdb2Yh?=
 =?us-ascii?Q?sQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	goR42bntdoGCInifDfUNdOOBYOcOP8XtLp43Yid4NTqcVLYpTowaXJK0z4JFfoQNh4W6QNvpk/mqoAc0qPU4nvrA1wtM6QX3YCViBCoO13pUT/q7q7cjQup7Igl6o9HWmrOtWggVqB0yFXyAkXVTmtFe0LCm67nB/LxxHUAJ6SlPdiMK+vVHZyB/fbZNSoFTLKLbqNgknS3HwJmljT6Zn8B0O7pHjbHq5zAx/DQnD9XVPcF3h4AtkBgoI6FOd8skOVWX8Q3OhlwpxRdTqZO/Bk3k+1vY8NdvKbQzxMpaFSKS+fPIByHAqw0BsmtP07iCbo62BG+edDd21n8hbJLoFQGAwyGUpFVBY97b4cGKeZnrDTzT3BAZ6J1FG+QDXhr3+VlJqYbe/hSadoaWvxiiWZ5Q/qFLPu52Y2pwFE2RPy91S359KDqk2+9C+i3lzxj+qwQ2g6SugzpPmMBCMSPhL7tQNXKBWxTUrC7fHEWdeX5pJ4wm2OqE4us/+ppzbJ4/HO4IPaOpmncGiU5TIWq1lD0PAFyMjVNzry5CoaVhTSsBN5zr4SYm53ddgKMFlpqekIMrT+P2sM9eCncbcaMp5IzAT2qlIdUY1o2q34qhrw8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f932d20a-7b4c-4a96-d061-08dc6b79dbeb
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2024 14:03:50.7250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yzVSoB4mMgizkES5CHnSNP2Hw0CEE50uDi95imTqAGJesn3FOCb/Dbme1JH0QKAdEVsfgwi99gU1fY64zQyVng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5074
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-03_09,2024-05-03_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 phishscore=0 spamscore=0 bulkscore=0 suspectscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2405030101
X-Proofpoint-GUID: yO3H0izJDx122G4tYWJOdbdM1g-KDikd
X-Proofpoint-ORIG-GUID: yO3H0izJDx122G4tYWJOdbdM1g-KDikd

Currently xfs_flush_unmap_range() does a flush for full FS blocks. Extend
this to cover full RT extents so that any range overlap with start/end of
the modification are clean and idle. 

This code change is originally from Dave Chinner.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 fs/xfs/xfs_bmap_util.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 2e6f08198c07..da67c52d5f94 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -802,12 +802,16 @@ xfs_flush_unmap_range(
 	xfs_off_t		offset,
 	xfs_off_t		len)
 {
-	struct xfs_mount	*mp = ip->i_mount;
 	struct inode		*inode = VFS_I(ip);
 	xfs_off_t		rounding, start, end;
 	int			error;
 
-	rounding = max_t(xfs_off_t, mp->m_sb.sb_blocksize, PAGE_SIZE);
+	/*
+	 * Make sure we extend the flush out to extent alignment
+	 * boundaries so any extent range overlapping the start/end
+	 * of the modification we are about to do is clean and idle.
+	 */
+	rounding = max_t(xfs_off_t, xfs_inode_alloc_unitsize(ip), PAGE_SIZE);
 	start = round_down(offset, rounding);
 	end = round_up(offset + len, rounding) - 1;
 
-- 
2.31.1

