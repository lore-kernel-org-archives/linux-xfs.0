Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826721B85F7
	for <linux-xfs@vger.kernel.org>; Fri,  6 Sep 2024 21:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725657133; cv=fail; b=aQITTyY6P9KLqyUw6e2M9wuMlhU2bNQG2+/qoa1iMsxrbJOt+NoOJ/MGKOJPraLn3OxQBKEoXN66NAokhsb0gHP3mLpJsSDhVlfY3qvYhP+F3aJpRbwpj4ABjwWybE7GzyqQX7ZTgxANe8RSIzX4D7i/lvfmBlLxZoRSHd3Z3nA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725657133; c=relaxed/simple;
	bh=SL6+Msyz+8nviJDDpxeh0RA6u71TsjB5MgQWo2b/poc=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ar0T9nUcC5DOVuzixOzihPg7sgsKnbyOkHkS2Z6nEE5LRDSqObgaUEvCXuGyLHAYgPTbY44r08iIuMmsbWliKb6qrV2T3Sk71iTWNI6YBDmmHD9KCTDPxGIgL0fPS2o9utl7RxbU92VVo2s9c0SnWYJYxlwC7VZ839EcMq3tVts=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Joq/TL7n; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=UKf80qPI; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Joq/TL7n";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="UKf80qPI"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 486KXtQt024757
	for <linux-xfs@vger.kernel.org>; Fri, 6 Sep 2024 21:12:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=YkE3aVU1/jQ33Anan1qMlYt8quah4VIArtEQh2d4/50=; b=
	Joq/TL7ntH6+3csQFHyttBE1QvWFY/IC+/FPUyweSE7vL0lUcZpl53H8jA9PqEx5
	Zuc/twUN/Dm6yoctsb+9kiRFA2fV4UfwgVJ6OZxGw74fHoNf3NX+HPo1uSTx462u
	P9sx/kP7H/nT7jWYZGtFW1vHEVQu0NLT+RElfsX7sZ69Zq1R53QQ9q+1NtIrSvDq
	vGmM4u9wCscxo8etIfl0PmM7DuQF5kvnwYxNbLlxkSXldygTI/yI2h3OltHTTzhX
	XgdVFCzh8p5AsdWCKMciUi5b727E5NPijcnsNmhFBmXQla/2Cd7s+IHuA5cOHGW6
	+UlSxn0Hf2XGb/O0VlW/CQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41fhwkak37-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 06 Sep 2024 21:12:10 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 486KxM1C003353
	for <linux-xfs@vger.kernel.org>; Fri, 6 Sep 2024 21:12:09 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41fhybs7e2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 06 Sep 2024 21:12:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lPL3wFE+czPs0WOhoq7FVft6JIxrtLvLZUZ+ID8+uyMqqVjy+Z2qqcVSQvfctbbPpoh5sFlmP2/wLqDplruRDGjVWruwWtEoMzj7c0/o75CF3+E/6cank6bTxJXQiLTBARYAOsKLaMpUyx+PWC9mBdn0HVPWFFfnqovD2ze7MT9/6ham4y7YlbO1WYb1mWwHFpiUQn49kqyhqwKNDU8HG21FTXqtgFiUyJSK2iA3zINmBcicHI/TS6BSVzJb8Bkb3hUK6hDdhpgqsrGxkRlzkftXGwfbj3J1CndUHUJ4DcB8w4SEFPbaLDiuGUsaTIViFx1RIBweiTuk5CQIvHOh8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YkE3aVU1/jQ33Anan1qMlYt8quah4VIArtEQh2d4/50=;
 b=GAtS2MTjBOmZuRi97gEx8Y5TEN2zJrlREQc/HSa0l9YmX6l8Bcvglk+olQvENzpP/G9B/9MHyG0g3z/BGlFTfDFMiNFjZGAOLq7OsEySAXp3iPKay9tV/yk7xm1U98KARHCK9VWr6XA99ZZXuLXPP7n3BsOGi2leI3ZVNU7DIE9dJGCHlQVDDlqhCSY+AxQdWdHBTUKjpMqZht7G4ho+rmU7yavxvo3Pk6TQ7LBVWQl5zaXNbxZ1clIKNvfrDIvdqKGEZ8gJY7AfB+Vfq7R+7nCJatgdpxSz1vRqdKmR4dgWVhsuEYajL1iVgYbBIX5EKWeU81xDu9uw/MCALEXA1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YkE3aVU1/jQ33Anan1qMlYt8quah4VIArtEQh2d4/50=;
 b=UKf80qPIFS6a6Mf0XJqoUEuuh2kPJyElh9gljxftCLVh4LHUByWUMkCXIHKI57HjwKo12qaVjd7OZHn/8eQV3aEXp0MMizy8dXErqFkGqW4qH923kdtZojLUK/NsR7RHryJNS3Tr1HYKFjAgE4vB8JBbOQPABSDi25lUD5APuqM=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CO6PR10MB5587.namprd10.prod.outlook.com (2603:10b6:303:146::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.9; Fri, 6 Sep
 2024 21:12:07 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.7939.010; Fri, 6 Sep 2024
 21:12:07 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 13/22] xfs: match lock mode in xfs_buffered_write_iomap_begin()
Date: Fri,  6 Sep 2024 14:11:27 -0700
Message-Id: <20240906211136.70391-14-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20240906211136.70391-1-catherine.hoang@oracle.com>
References: <20240906211136.70391-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0108.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::23) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CO6PR10MB5587:EE_
X-MS-Office365-Filtering-Correlation-Id: 49aa274b-baaf-476f-405d-08dcceb8906b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ir25Mqzm3GLCDf09O55mq2MRi1e1AnIh8KvUY+E8p49v0s97ivdQwKd6TbuM?=
 =?us-ascii?Q?aYXqx7D7wbI53GH/AvVG1uge8AwfuY7Nl+yFgkDkjy51u61B2OW2dDdB6fSO?=
 =?us-ascii?Q?FiEENIcqK70pgqANbqgfOpxRl8NyhtBORi1YOBVHaWpMKg3H2kqihvkhGgoR?=
 =?us-ascii?Q?9UzSMtvNmAh/r8F5s/4Y6StI4WjBR/iCJWu+UbDyJVfL+P4KsnrE1p/G9Rlg?=
 =?us-ascii?Q?CG4fmfGCFCgWweQWJ5Znr0WC7wtZKtahof/nw5C4WHQsA59tnhMBt/k+VJh0?=
 =?us-ascii?Q?4vzcyhjWMUedDoCNsig2EFw9ZDpnTQZSfk2QWholXx+PI0A3QXe4RFtpyzXq?=
 =?us-ascii?Q?uiG3k8pjs7eG7wJkHoMP4EaFi7c0g4ekRQeC4njvvtY49SWx+es6F44vZU7z?=
 =?us-ascii?Q?qyquo/UrKszTo2w2EXE7t+VZMMNss7BvbxeHKjH1i1kHFJcJhWzye4YML/U3?=
 =?us-ascii?Q?QFfulQdtPIvUjdMoxQg2LOOMZblDfPHQVRaw/X6ZzrnW0cXO4xAfKCEhflfV?=
 =?us-ascii?Q?Syc8SPSjfdh4qymJ28VI6QBIKCxlgzGQaPFoUaSFeW7aEfiKBcqxY4c6J/uD?=
 =?us-ascii?Q?xljyjF9iuEM7LeguW0XOTqTTKzxLXGuJWDmERp1p1eGjXGEjpEvX+Lnxmd7/?=
 =?us-ascii?Q?ivbwsAVX1QaPSvWCGqMVCQHKDNwjXjZ+cZxEFVL8k6mteJ3/VEAL7hSmjQVp?=
 =?us-ascii?Q?WTaoRkpnrVmHigdGKKM/CKHbOfDYVdk4hjVShusYqM7Qg863T5UXp2Liwvqh?=
 =?us-ascii?Q?+cysW0QmKc5LApDKB8RXVAr3Ma65DMmC8TaTmXfCFqdh+xRFcqZ8usBCvILh?=
 =?us-ascii?Q?aYZ1hTEOKIvBvQpCyG75mwwGAOML4qFZUD1hvvgaCINMHRFfPuywETu3tiyf?=
 =?us-ascii?Q?+6IotwilNTF4ZoLUGMvj9tc6+tVYSIu2qoMAJOhJxUqudvgc6MNb6r+f1/wb?=
 =?us-ascii?Q?q9yaHTGNLY9PRcF2hl17Obr8we1iDiA2HUBaC99JGpwtf6Wbd16P8NegfOQ0?=
 =?us-ascii?Q?JiUZLPhQx0f1DQ/HFLDUxmyblFQCO6RvtQwMyjiqRSc2hjBwMgaJ5mUe+Wt5?=
 =?us-ascii?Q?BT9II7kx5F8ldCO12ihC3oW2thoLQJ/KN4+wfk/NP8T97cJ3lLuXWKQmKrPq?=
 =?us-ascii?Q?au8Dtht/arcZYRSsM4nl4pOWF/Uw5eA63NH+pAOdCtuCeSpCwpr5NF7C+V3G?=
 =?us-ascii?Q?ASLRn/8S3Q3vIGDs8fcOTPJEikE5fTG/+NUhivgJ9uOtW6MEqVqa6KYZxMc5?=
 =?us-ascii?Q?bGFw/FnFflU1005zstvH0PcrgV8BBMbjQytUrB+1gj0sDJbJYcR/O1VQ9Cpd?=
 =?us-ascii?Q?dhYHtg1+exaq7NuOaM+vC9cJn8AmS+TQcL4/QeMoSVGtjw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WHPfhztfyjv0ugINtaaWsUKs579OBNqzTGQXsT52gfFWnXg6k6AzE9MWql4X?=
 =?us-ascii?Q?vgSsX7iLHwMM4FC+cHcHl5LhUJCm7/0nbpH97I1JQUy7vYUVxsIc4/+fXBoD?=
 =?us-ascii?Q?L0HkhJv+qa8Fqk5GcH/LgOwMokV+VSXNalkFKxsCiuHvvpBaCsfDR0H/F+lu?=
 =?us-ascii?Q?coryAQBQfV764gBVyUqUDseGCRoxL5sqzo4Sewhws6MHD8gDEFkN6ycfYru2?=
 =?us-ascii?Q?zayKq7IJjUKB9bvUnRuzaoJ1eXq8XgvRGdpySQx35/eBV2cIOaRcoIaheUOj?=
 =?us-ascii?Q?wkutXG09iHD9YELgaWpW78BuesN4GCn+qgShQsXY+sIYRvjdSKGvQurfL4Dr?=
 =?us-ascii?Q?ttfV+sPrCCfOFIoVc/F1ORc5E5PXXXKK+PCRsrUtTIkCNiu2yBk2V+EWwqwy?=
 =?us-ascii?Q?5JlMvLmYaT/dWu3pfjbNBMu8xGoppM5lrjUzA0Qzcs9i1L9mWlMm7tZzMOMW?=
 =?us-ascii?Q?1YAEjnlPbDuFX5S6cbGKZlWQf3SQ+/MbRGXl0WmcpCfDogZJ6kd1mBv5vsFr?=
 =?us-ascii?Q?ohehOp/uvXvuX9odyxtFDcXaVJ9UEqvOgV4OZHx3tqVdyCYhDsOYykZ+0aul?=
 =?us-ascii?Q?/0/F0+LlM/X86FSV2mehsFcnXjm5bDOXBKEXLCZg7CE7iyqEK8PL40a/URoj?=
 =?us-ascii?Q?723gyx3ePFU4IY7z8KFcJs4V9t5YynuPEK8NtUYdfK2LmXqWZISIrzE6nQYw?=
 =?us-ascii?Q?m/dfrFRfoEW7D0D57NN/ABPkAJ4ppt86C6xqnLx2T3dldij/lDEpncqDx7LI?=
 =?us-ascii?Q?H8Yf5z7R8uRWeJtpHpaOi3jmnCJg+jSBBY5pshh/hcIYLX6qZZ9Hlw6mLTb3?=
 =?us-ascii?Q?AhcFAnipRxUoHBAIyYNN6dsVN/7fTOYP/tS2FnUnc0ZcSLMGMMo4O89Xqcmg?=
 =?us-ascii?Q?Jerzjtlcfyf28s/KbgETUstq5cEboFMQo50u/0GEg7ippq5/QAGFi7ndcyrV?=
 =?us-ascii?Q?0+7YZb+t0l1e+wRWrNPSy+a+2aNt5G6ibIXW7SE7LsR05EBrFPfvBQA2gm2M?=
 =?us-ascii?Q?Ot8pDIggwtBYrX04pS5z+tjfgv9/lLLm+x/G9d5POLUYhBBH97GlK872XdeA?=
 =?us-ascii?Q?aPdnw6PFp1E4rTsFhzY3Rp/aaQpSPAgahI/E8WuARmd4kAF9r8b13T3Ke0mq?=
 =?us-ascii?Q?GrcdWoaYKWCd1UTf1iWygtF8ttdZM2GxILcqF29iXz+izXG6toZfL9WVb6Pc?=
 =?us-ascii?Q?afRA+eljiTFWa9k0osIeDvrK/HhRVjKlG21NFqw4kl+jU2nK8Ps1k7IuxvNy?=
 =?us-ascii?Q?t5uL2JKnFujd3xG0BDU1uGCkQQRYfUg0q9k+yaC/2/ieXY0Ew9lyPBkUE414?=
 =?us-ascii?Q?rA0NgclJrgvzgnQv+MkAiSDFeTUG6N4/SpHiD9nu8G2JN5+XTEupTqKwSXbw?=
 =?us-ascii?Q?wN1d/fiGmpUKra820Fg8HXFgUbm4o9FOpAZH3gxm1/z3rK1h5arQADs8Lw/Y?=
 =?us-ascii?Q?H9U4qctNNIYZ0g18B5N6BACtWMgIEwC8Fg3mhQBzwAbMMnHFM0S/Myjj00+k?=
 =?us-ascii?Q?XCTc8q/WcVaVbikJAfdDMRI5+cG50sbGZir4JuL5cZY+lw278QM03yQ3SLwB?=
 =?us-ascii?Q?/LXAVtEhFfPvNA/q0xMnLdcVfHULkE2kIraAw1rJ4h33SenKNtxsGacWxWWI?=
 =?us-ascii?Q?yA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3lH6VR2hE9L9F+IgSCa7shoInueJZUXVL2DKVKuUaOF2K6qj+Qevo2V3KBA0u0FTYliI2fyXcb2FIT7MZEBM8m31yrbWvHJjtVzdscff8xjYZCnpiU0gT5cs+L8Gpr/SX6hioy058vAqrXfXSkAI69eCbvZi0ZGKpokm3uLloAAjDR8RuqAqNO0MYLeCsX1YSUSZlTqky0ts5YRCkrrzvqR9ZDRNIIKrjefCZHnpKrLRwflqvIFEhgdq5tOkiHAANMDvRgi9NGAhWlq9d7UceWai2h5hO9Y9KC45/g0kr6Qc1E4wwMAf/I2rwP1z3YaTWVr5eynjRSuNmJXO8sgjP1EsnYswixrE97N7EH9rxL1jqoRY/kAAY/22wtuKAyU7lzaRRG4vRk0nNsfd1rFcYlOBIbF/iMAEFRzWlRiS8OgbwV7HlFNG3m5Rq4NBMpccWBSSay5bXPJYy0hIBn3q2oB2TBuixkn044KPk0we99paOtS0VpjMiaDpRlKE3KTryFI2KhGXg842+1nPrVmn5il0420+iaOCg8wwCw7GuXWXk/k73pdJA7JPrm/5Rur39SScbS91EbrKpEHcH9UdLzgdoGFjLiLjfT2Ne36ENng=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49aa274b-baaf-476f-405d-08dcceb8906b
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2024 21:12:07.3366
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SSzDjTeBPJVOQ7aCGDuJMiq1eNBGozKUZhs1NNRRxCBqdgz7rBBcGS8X3TmCgSGlBsV+yGg6DSjPejXHZr27S2NofeAJIbbTigDFpliEy8o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5587
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_06,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 suspectscore=0 spamscore=0 malwarescore=0 bulkscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409060157
X-Proofpoint-GUID: cW5Keq23OCCDzgyeu0UW-d4DnrR6u1xM
X-Proofpoint-ORIG-GUID: cW5Keq23OCCDzgyeu0UW-d4DnrR6u1xM

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

