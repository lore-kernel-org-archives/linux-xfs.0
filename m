Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A85431D1739
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 17:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727890900; cv=fail; b=WbrcxBv4dsRotecyaAwMHn2Nin7pdwz3Vzp7233pX4W/wJWkvXuvf4WXu2h5AcDqovOhH/VCyVOYFJaalHSrQ56Kebbp1xBeoTJJzzCJgmaT/xd937R1IkWkc9gluRoOjgS0cAMgfOsnBkJCSvmyaz8l/eZvUw2X5Zl/H/JQ9sQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727890900; c=relaxed/simple;
	bh=SL6+Msyz+8nviJDDpxeh0RA6u71TsjB5MgQWo2b/poc=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dJ7auOHA+xNZ1bS/PwEiVDZcF66Fqo5HOHzm7cc1b8J1C/zxkxvecg+I9ssZ2R+yWR9QghMstM4TQScU1ymRPOKGBCUvoLJ80QaRoo5+Ul3lw3rKUJcKQrBLg/mLQ5VRZ3B0LFb+BbfH8kmLV1GewP3P7dtqQDc3+FTViFWDwG0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Z3VYR+Uc; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=cK7qXXlR; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Z3VYR+Uc";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="cK7qXXlR"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 492HfbFR007549
	for <linux-xfs@vger.kernel.org>; Wed, 2 Oct 2024 17:41:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=YkE3aVU1/jQ33Anan1qMlYt8quah4VIArtEQh2d4/50=; b=
	Z3VYR+UcGz67IDBEz75muNSxqR2JAfWnNoO9QsoZRhV3LUtXWuYsv/PRhQH3l73l
	du/XKayVanRiCHAYaObzIsv4Rne5cjg3yLVPYgGsTholx25STs65oHHg9YqkvR6s
	jW5ItJwyTVjb8qfqQK/X0Cl2cMqwB228c7y/AJDajuyNdbes9rZG9jYUshbINzvA
	ycUhTdpyxaOof+z2l3sbEGc5AugaqNtFbycuUGIjUMbXwi57suEl0s8nmoLkPyuC
	PK2q/4XXPnMJzTIiDGpu4Nfyz2aT0fHOxySU84LZQme4Vk6d/s0qqbPMMzCrQUEM
	F4jg3nEAZ6Uooe+rQ2nrMQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41xabtt6yx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 02 Oct 2024 17:41:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 492GtGhe017512
	for <linux-xfs@vger.kernel.org>; Wed, 2 Oct 2024 17:41:36 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2048.outbound.protection.outlook.com [104.47.73.48])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41x88951m5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 02 Oct 2024 17:41:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YZPDdtDoqJ0xmxk/f6LzG7gRej477CrzfsiVFQF24CfxGCXjKYXEVvClJLJnqfqsD/jNPNTQDwVmyVhCCzEycE6vgkcwCcxWmkeVH2HVQCC2NpFzWX7QS8I4nv2pDVDm1PM/eJ9dwOd5CYyLaKawCdrOLqBI2V4aFGqs7p1KXsPr2m40WuBHL9Zl364GMuZVZ8U5eM8sYstcEN37Tj5KxILjleGe/94aMjod7FmKjmiav0JRpt77M9pYaGwWSLVIgYdSgF0q+oju7LlG3vlHAs+Dzwfi/BSWCqszYZIiu7gO6FoWi7v9hj5dxxXNkWdkB1+S0r6IN6mX/gKRN8vF9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YkE3aVU1/jQ33Anan1qMlYt8quah4VIArtEQh2d4/50=;
 b=iJHkQTFTuJycadKlyvzhtV4KPiiSqWLLDNh/+jl3EkwQsg3vRzXJjGaLnJmWBaZg801bS8bSzI3T0T1TMJ/Klrcp3p/N8ns27ULas41dc7mtZZ9EFlVS9yBG0W3+HjHdSrpjUnxaCWLlHGkVaM63GJvcoDPXU7kdIqQYrpD7/f1SYhTWmzO35lMnQgEW9Gw1lIp5mTe5x4z6Z+bilZr5gGLphCE5njWwgat4ejtIR635IRcxYpPsl2aVlC0/tLt9bLbH7OuRu9lSEgqjlDtrqs/0d1iJiIttU7pIbfesu+m0pra1ANo1NZxcWQ0oGr0LKdS6pgDNcP5gPMTXhNg7Fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YkE3aVU1/jQ33Anan1qMlYt8quah4VIArtEQh2d4/50=;
 b=cK7qXXlR8BItzY6xIlvgQocqR7D8nA43eHgHLvWhAqog6wXNfFh+Nl3v8wxfUfToFSF/baw5lHJkDayJ228kg6zxkjAWueITzdMw6V+pmvTlNkm7YV2lU8z1HpGasW0CDGYS8JmWxNhq/RnMII19kCtfUXfmQ79jgZV7UV40MhQ=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BLAPR10MB4995.namprd10.prod.outlook.com (2603:10b6:208:333::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.16; Wed, 2 Oct
 2024 17:41:34 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.8026.016; Wed, 2 Oct 2024
 17:41:34 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v2 12/21] xfs: match lock mode in xfs_buffered_write_iomap_begin()
Date: Wed,  2 Oct 2024 10:40:59 -0700
Message-Id: <20241002174108.64615-13-catherine.hoang@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 838bde9d-78a0-4610-e1f6-08dce309752c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|10070799003|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?AzpjnNZzpBVz/02C+Y0noHoD5EJdSxcdDzYmy4pDfGaIW9LbOumR5+wbElZd?=
 =?us-ascii?Q?xKA4uasf/OwcHE6lwr39dZpMloowslzM5tObrCjwEYAkP0r2u8QD70tO9xWc?=
 =?us-ascii?Q?0QnDXXRuzjjbUCGw1zsycWr6bnY/RK+455dWjAkj2HI+rH9sMA1mpjdzLo4P?=
 =?us-ascii?Q?FeF+99XYCXgcTuXHa+k+BQnFpFiFQ3dvPzLMA54E2FatPFTeJKry8r4Mxxau?=
 =?us-ascii?Q?k8v4Q4aKpekOI1bXZehAKfLmjimmG6xmvKCDH0dJkODRN+LTBjgpNax1SqoF?=
 =?us-ascii?Q?Yyoiq5UQjLvx8YPcbMMvOtymh1Oi6YeNH4pQx/oB06g4pkjPjejZ/BNZ2AcD?=
 =?us-ascii?Q?WSk4kJojq4+4/MAST7i+XYmwkAUZNSajwkuUdimxLvSomp9TiVpiXaurbmj0?=
 =?us-ascii?Q?xo59rajshz7sgKyBj5/DO9dvEM2f8Bpv8+M1c3TCKeGm9p5w8KnR1KJATAI0?=
 =?us-ascii?Q?sXhVwvoSO/k2x72ul63BzV3AdTfQ2dHF6Xuay2AL4BzTrz3rYkN1VYzYp0Ht?=
 =?us-ascii?Q?6Y3p7fRoSbiq8x+wyaRNZjJL7IGsDS7T6GfMYcg3oh8x0HBch5fLL6xVszqC?=
 =?us-ascii?Q?yjw+SRI5cV29QabzE22apATHzLXJd9GKuakgGZ1aKcJQ85FCpuWcMZue2KYu?=
 =?us-ascii?Q?LDHT96KH7cUf9brB39vy9bOL8kIkmsmOQVjuKvLm8vh54sDZ+kDYvxJPj/pF?=
 =?us-ascii?Q?54ATlhhbf8j8/Q9hUquDQ6xuxPROdBIVl9RV09tXBwXPR8hCSuI9zHs41zfk?=
 =?us-ascii?Q?mRqalzyh+zBZk/KpefArOfIMqLYyVumajD7WUKgobqlhVxUwfTid0MbFTyOf?=
 =?us-ascii?Q?zQd6u52u/PxhKuJfDZM/LXsjOhbhDHimzilsKLd4/QH9GlR1hw7avAVOTgdd?=
 =?us-ascii?Q?1ShVPT+2wRvd4X5Z+C01VAjhjMINw88DwwIjy4vOf+XT8YdXOdSUai9Gme/U?=
 =?us-ascii?Q?NEuKIQ0GS1w5LdmU+gH0hxDKLLthaT03L9rJBR9s8cKu01kFwBV5NvUgQNm5?=
 =?us-ascii?Q?dMUMoqyhemeeA8ouGHod67oeQDiojVr5gO7zUfIMQc2bdvVGH3FsE3l4lt2q?=
 =?us-ascii?Q?Wdh5MROH3DunWUX0n/sbAh/uhQR2d4vgKbiR1ymJf8luCjOel35rakNGfWlE?=
 =?us-ascii?Q?BxBGa8iL6WhV9Z7Vjo/qBvUFfjxdpr9QMFfUvHM0yy0tW0w4Qs77qFAtlI3X?=
 =?us-ascii?Q?gJUSLkgE/goAqlb8G/1OQWYk9wJfXKJPMaZ1EktqGgpmErl1IV+HzL/bidt7?=
 =?us-ascii?Q?Q0UtGMtTVr4zj0mjsZ/u6HtmM9AQA+kMIZQMgoEM+A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(10070799003)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9GH8M0A7BA2tBbN8Q8ZdfRTxHMyENwrFsHH5+cOeF8sjwKuw9EwTeECbj9Hv?=
 =?us-ascii?Q?SMeoZioXnTG3ubZr8xzmAuAdGSAqixuzTAkAy7gWz8Zij86EXlbM6j+GT11p?=
 =?us-ascii?Q?N0/k/am3PCWoEmiQAmxXmIGNDq8+0WAxZ48m5KOacL2RXPF8BDhngQAQrrcG?=
 =?us-ascii?Q?aaDA5/zbBmFWUAez+noPWiJ5SR9dInKxIi04F3AEaoT3CFlvj4YUHkgiAfhd?=
 =?us-ascii?Q?2l8L4LfMbMA3BvGCthRMxi1m1/TzNKYSTlXlQX2IqW+4irIGfoEcBx5hWTN6?=
 =?us-ascii?Q?/BzHD13U9RFVgdJF7iwr6pxpxlGMvyoZK1fTfE5UFZpCbBspbZO2xqe63bXn?=
 =?us-ascii?Q?2RuPDiF2oPUO6w2Dxfa05K2P4rAEfun93tcPdW24i0ilWcFaVulWjQE80rW2?=
 =?us-ascii?Q?iPNHmSsT+tH+yVM6zK8oPd3hVtuGF3X4fLsVaDnA36XwP7oWiY+gJfQNtWA/?=
 =?us-ascii?Q?YLk2/TFQVmUlfZgViDLQO51LPtnickGBulGwHGZK7laJCMJghGAP/YUFHxyN?=
 =?us-ascii?Q?U5Dg5Bh5IBV77n1FNX2Mw+XebVzwFSY0/iQbMQoEsgjVaH4J/LZySjEQmDdk?=
 =?us-ascii?Q?siCUO/cwUdsbSeTuUufin2nJiiMlqVMHPS0P1tiPDLoUaZLDphbj8uZL7io9?=
 =?us-ascii?Q?4qSdDS9+RfmwQAKxPoFLMzsEyq4b30nRv/aCt8dxLWtOai8pcuPbgM2TA7kY?=
 =?us-ascii?Q?sb2BitVkg1U71EIlibJXJPxdxrlSt93ZHYLnKUnzTU0bS4sDvAERbwzBxa8S?=
 =?us-ascii?Q?AmHncp6c+tXFzUL8S3lz6zbmthljYmEBBxXNfmEsjIE0YHmciFSKJ43y5XxO?=
 =?us-ascii?Q?1RiQkOdWwIkAWcv2QRk4gfXMgrDRIY7d3QnuMPMW28TiYDYRlWTB485eWDsx?=
 =?us-ascii?Q?LSe64YNpfdfsVSpz+cZgLbd1uNAvmbk2f98/1/ot927wBNYJPGU2fKp+Gr0v?=
 =?us-ascii?Q?yg8tGfn27dvYq2ZyxxKphnq5wYkoQqmB1Q0vvtPnf+Sw6hee2NLCIewIsb1s?=
 =?us-ascii?Q?EC2rA448q/SDoBYGOFzAyrp54DQoCYIHwJZiRvpOsN1tcVwdh5yj6zeW9KT8?=
 =?us-ascii?Q?+xaaE6jYAadoOvxZks/Nne3YrH1ZCdIYJFWPLZ8D7PPxzRLo3EWvw9lBFhPi?=
 =?us-ascii?Q?RCb0K5pWVpGCoYtEpeCiPBt4CVW4qCn95DihWPOu8dm7/fNrBfhLsCnVNCCT?=
 =?us-ascii?Q?7WIxR7CgDw0Q58ApG12JK4Lne7ww3GDU+3nhIUW4Ym9NZzH2vV3qm8S+GW+f?=
 =?us-ascii?Q?EOizWFTRIqcHqpHGcZUvRjXWRbLuMKZ+oTVRQz9ZNoauvZ/SrZC0nS+XT0L3?=
 =?us-ascii?Q?3owI6BsKJgMaHes9GVycBBbK7y714lZ75c93Ia01n7NJZd2zsgL3EC0jIsgH?=
 =?us-ascii?Q?QRnJMxD8zCGV878GcVJ2qyRY+MZRUqHNBeDxBb8jUImaLn4+f754MDCGHEg+?=
 =?us-ascii?Q?fyrW8eTWVLlYi61sgkY53Td43yavh6Fqvp2HWCSE2Uu+49P8kZMhdEzhX2Sm?=
 =?us-ascii?Q?53Mp2CzO0/lzUaTkNcSapfWGBQqrKGcVtfmiZgmCcrqiqtojIOB/vFsfcMcD?=
 =?us-ascii?Q?SjbwnRrAEo3a2lpCncbnwaU+K6ENLsZbdAEJJf+QQXaTpH0l92Z5FFzyKrlN?=
 =?us-ascii?Q?clFO0PS/a38F1fZBseRw877kL7CSd2jLw9/Liruaigr82mmCd5cpu5VgJgUp?=
 =?us-ascii?Q?AzrWZQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kLXwkVOMkxKY7ZbpcWqiaGHjCA21uN2ZjTLpu8XihdOflQ8DHFu6AU4QIpb1v+aCI3yVLpV4pChS63kfBwjT1R+7xVpL0Q9r9qcapnG8qwcjBmg7qf1Re45jCc4WZQfT3EgZA8F2VU+Oa7tEMw8FPklq8KpPyIzMPap+ne0QLPtTcVea5ZAFrlKjvcAlyCOT9oARDhtyncxASeqDg0Uk0z7d1rtdkQzul/ae+PN8iN6HHtAY2GfWbVbbNBmyKl1IVvvCDjadR0mVj3994tiiwJ78FgYcVsq4p8RJ0rhwbTbmDjSlxlv+g70Tn1pJzusLN4dMFV4PFX3sDLACeRK57BAqcSLzRgaRZ2h66uQ7HbaGDEQoTudSu47uOgfB0uSBoWvGeVIW3MvTF7/ZZ+/vgFTi6q9K9McujpOlySK/vB3Opw9KDEneY5DAdgxeoplWVqBADRb5evOE/HGYWxZTCAly5dC+mher+59Yuq6wiEn1zAyXPyGt8dAOYlSqLnqR0CE5t6TLt0YiFEt1PWiLo6lFOBz4px/0bZNkhn1VNAxFWVvO85q3mJ8S/dH3Da3H8ANiXVnkAYCzG2x+P+roIbIqMD8ochpwBMjBixqNJy4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 838bde9d-78a0-4610-e1f6-08dce309752c
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2024 17:41:34.1250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3sFS+dVeENeenf9Wg3D+G+xkAvIst+icacTB8g41f6mqDwXQUp+hf8lTFTLj5BBa4Fudgud62YjYC7rs5eoeeyYO7OjMBL2752Jq+MdBJHs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4995
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-02_17,2024-09-30_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2410020127
X-Proofpoint-ORIG-GUID: sXCcO4QTGHcSxuyrM1o1u9Ut-tTHxnnz
X-Proofpoint-GUID: sXCcO4QTGHcSxuyrM1o1u9Ut-tTHxnnz

From: Zhang Yi <yi.zhang@huawei.com>

commit bb712842a85d595525e72f0e378c143e620b3ea2 upstream.

Commit 1aa91d9c9933 ("xfs: Add async buffered write support") replace
xfs_ilock(XFS_ILOCK_EXCL) with xfs_ilock_for_iomap() when locking the
writing inode, and a new variable lockmode is used to indicate the lock
mode. Although the lockmode should always be XFS_ILOCK_EXCL, it's still
better to use this variable instead of useing XFS_ILOCK_EXCL directly
when unlocking the inode.

Fixes: 1aa91d9c9933 ("xfs: Add async buffered write support")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_iomap.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 6e5ace7c9bc9..359aa4fc09b6 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1141,13 +1141,13 @@ xfs_buffered_write_iomap_begin(
 	 * them out if the write happens to fail.
 	 */
 	seq = xfs_iomap_inode_sequence(ip, IOMAP_F_NEW);
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(ip, lockmode);
 	trace_xfs_iomap_alloc(ip, offset, count, allocfork, &imap);
 	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags, IOMAP_F_NEW, seq);
 
 found_imap:
 	seq = xfs_iomap_inode_sequence(ip, 0);
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(ip, lockmode);
 	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags, 0, seq);
 
 found_cow:
@@ -1157,17 +1157,17 @@ xfs_buffered_write_iomap_begin(
 		if (error)
 			goto out_unlock;
 		seq = xfs_iomap_inode_sequence(ip, IOMAP_F_SHARED);
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+		xfs_iunlock(ip, lockmode);
 		return xfs_bmbt_to_iomap(ip, iomap, &cmap, flags,
 					 IOMAP_F_SHARED, seq);
 	}
 
 	xfs_trim_extent(&cmap, offset_fsb, imap.br_startoff - offset_fsb);
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(ip, lockmode);
 	return xfs_bmbt_to_iomap(ip, iomap, &cmap, flags, 0, seq);
 
 out_unlock:
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(ip, lockmode);
 	return error;
 }
 
-- 
2.39.3

