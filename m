Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A82288C04;
	Fri, 11 Jul 2025 10:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752231236; cv=fail; b=bGp/ezMy7Mgrup+XkYhpolpEsW5/3ly4tySvzBcLMUhqK+8P/IWmyyf4wrtbOjwwGuRaudxXoX+5+wx8I2np5Kj3UZNxnO57TZ3IjCY3Zo2rTJmzof+Rg+PQThA2Imz4buukB9U7npThXGMWJ/N9OFTdpMONUVeKA8MbIaDPv3s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752231236; c=relaxed/simple;
	bh=FFEkFytAwJCL983YdoAKRVbTQcDegjQMmpw2SBckzsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fE74IXDgKcBAlnxTIo1p/1ZpPaWfTaQAtTsf24++HzMzEL9icxFMon+w8XxzRq1xh6dZhL8BE9ya85NHuolLadXQJxL7t7SJPx6KhTzqFHZm5Hl/2RKKjzHw28hc6E39o+PRq9nanP6oA0J3iClNzkS6fFePSIqfQVKK3qrPodo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=rYnPQxNV; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=iZ02FpTB; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rYnPQxNV";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="iZ02FpTB"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56BAMJLa009556;
	Fri, 11 Jul 2025 10:53:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=7xZ8ffo7OtMNYxkDBkMyWOX9jCVr5IhEJcUpqOBLJfA=; b=
	rYnPQxNVlrfELAIQNMdOr5rjbW9ir1/3SdzIsaKGIjUhWss16nNzW8zWBYVP38l0
	Ggf2YmECySvxQNtM/4FaF/qBxO+EaeW2k9fhxKEij/dZvnPq8+7LzHo0zTvIMrfJ
	aUAvVjTRXeafyiqKTkf1Ozf/HXwVoJK1W9klKKjCRZjGNEeXEoJIgxJSVxKMqAQe
	eS3yJoJNn2pD6Mps6kKlOF/lNC41+RwM0uEwNNF0Jv3yUslPZ9KSogVzBVcz2vne
	cWyYgqTfNam8Q2lItrLaUwWzlwJiqRNbO9s8qZVC5iFuzGFYCkVPT6PjWAcZ//eQ
	oQZmg6qwKHLTTNoSWojjrw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47u0svr1n3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Jul 2025 10:53:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56BAok6b021358;
	Fri, 11 Jul 2025 10:53:36 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2087.outbound.protection.outlook.com [40.107.236.87])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ptgdd1bv-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Jul 2025 10:53:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w7lqC15/sSWEtR/t+lf1qpq1Yfyn/boTFIGnlM1iA6LeSR/9vtH5BAAA4FPcUSSH1igRbsNdvDO3/bURs2fEmJyms3E6zi1V4P2jL5QkAihuyaHTYILAiKvD5Vkg9VtSmn4o6gG/5DBcwdfcYmSR6Vbw4OFxGZ4sBjByp6XUqrTMHtNn8eEp0WHDS0ZHcEZKf1vV6QelFc7JVClq65Zwkd9mEwqiH+h3rDENRKNMkhpoqmxpIhREzVzoAenhlmNbmEFkGGGMapuVOy2S2lQ87U597dNE3wB2K4UFA64mahQnSGRXJA4u7mnEgXGfk+DdpppYMBLsukHFPxmSc3Ca1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7xZ8ffo7OtMNYxkDBkMyWOX9jCVr5IhEJcUpqOBLJfA=;
 b=xj4rSN1VVZFj/fyaVwK86HBSZqxi/HICkW88H1bwgqu1+pCLGumF/Z48+0DwoRCCo9d53ZwaYC6Vz8DZkppaXS7u7kgu7J1JVXFngUI45JKDcAHNsE12OdTTT4mMJU0XCZwlYFSGm/N7T417vn8IVu+SQpTLRy2L1QUcRjoQF3DVjsFxSIg4U4vVGMoRHW78Mcj414xRx2NZ5UVbm6V23edSfo2VjEzQRxDajIMQTvAcdFxFXJ80SIGC0blb1vtQvvymr4Ubq4LGqxscXDqMEcfacT1NsM5RTHm8t4gtXGesVmy8WDBa8kDE9FAVqKE1zdk38miLDHNBkY8eRZsOdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7xZ8ffo7OtMNYxkDBkMyWOX9jCVr5IhEJcUpqOBLJfA=;
 b=iZ02FpTBOS0FBNra3CagLZJVTGtz/8Ewz008XsEZkQbZXIIa5YGAzGj6JRws+OUhuBzv5+bufqF3TkljAEwuZeuGPb5yiYrw9ANBadzNtz5Ih16ztpvcj/glvrN94cHMEU1dVA3W9kuI8esDYgzUYgUhHZU1bIScVFBHmVL7aCc=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by PH3PPF079E800A3.namprd10.prod.outlook.com (2603:10b6:518:1::786) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.24; Fri, 11 Jul
 2025 10:53:08 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8922.023; Fri, 11 Jul 2025
 10:53:08 +0000
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
Subject: [PATCH v7 2/6] block: sanitize chunk_sectors for atomic write limits
Date: Fri, 11 Jul 2025 10:52:54 +0000
Message-ID: <20250711105258.3135198-3-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250711105258.3135198-1-john.g.garry@oracle.com>
References: <20250711105258.3135198-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0237.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::32) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|PH3PPF079E800A3:EE_
X-MS-Office365-Filtering-Correlation-Id: a7b3393b-b053-4fa7-8c59-08ddc0691f3d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
 =?us-ascii?Q?www7nPhcwlyLHXrN+W60zhubiFEms2APGsAKkepUjciLSOSVa/OM0oROxNO5?=
 =?us-ascii?Q?Id30gwrbq4WyCxWBfECjFcKlE7/pUr/i2BV+Ei+teddl5whm7SlG3Oi26N7G?=
 =?us-ascii?Q?hZCsN+QI0xFnIIm1ueOMTo0sUbnNsWNcUlm2f0VSmTAvsTV+trc8M5Ql6hws?=
 =?us-ascii?Q?oJ2+Iy5WLQfhKcFiDQKWKJquY71vriznfxG353l9nUYuRt3euRAjdiQ0bIgp?=
 =?us-ascii?Q?29vi+R50uKUH7AUI9GONSlKII6HWrtakJ6QvqZZjH2Mkb/QvId/5SL4PdMQ0?=
 =?us-ascii?Q?lKdZFoO3A1goI2+pN5G9SAu5K7czATLAOqsBO2lDzjneCPx0NZheijrpD5zZ?=
 =?us-ascii?Q?tpTkYbX5fd2lBbhtaw/wcKbmjsRmPl+meMxfXxjGCGQL6s0ibalWK+gzOcgC?=
 =?us-ascii?Q?8oh7iySbBGdWZtO+lZyy9OCpTLX+34SfdglrDb+c7q8oity/tlJFTqffFT4w?=
 =?us-ascii?Q?eYT8FCb90ihRbUOwT9UNnZZbywTE8Q9jRi7wGyQZbCIJGpkEnhrkT00jfM75?=
 =?us-ascii?Q?hRDlUIWWoTGfVryPc67OYmv2W/zil6dmNNh524M3aKm/xWt2793G7nOWDkJu?=
 =?us-ascii?Q?naWQph39cmNd+QU+L2cNq2F72zpWbPS+RfgTgxeKKkmGPqltuLzF/+BQdThu?=
 =?us-ascii?Q?QYKPJevAznAeEKnBPE69EiyW4WdYLRZdhu0MWKK7mw9fcKD7iQ7Sx49be0Up?=
 =?us-ascii?Q?UEVmJK/Xe6NG9LxLrw751ToYhi2UiIHW3Boix279HkOcKo9dkNvkVZd7N24g?=
 =?us-ascii?Q?r/kYnjqLszCdREGS3lZSf65mXO0Rh10/I5nA6WeJOcZ10UBz/PlGoBio1w14?=
 =?us-ascii?Q?JHLBqvr05oCUyThBPqQXcMttmXolGwi32Ep6noZkLCL3eJQxrEv7HBM0ppBg?=
 =?us-ascii?Q?zem2yieEmAIJNM9mabN5eTEmhRYmVoLDr3557ozbhSzbFixe+ZfCPAHZAt6T?=
 =?us-ascii?Q?9STzdErA+xLgDQjoMZ+B2xPkIOg9cwoDrl4qdQshkH+7A5NYB8+YjiY6Qbi6?=
 =?us-ascii?Q?PPSSZtv8nXXLZlC+k68c2e+OT6nRIfcMUPoLQpj7fdXOm2AlPnJTmTLjcGMX?=
 =?us-ascii?Q?Z2XdKfPt1NLrzTKPYb4CfYCphqfLR4UdWovXb1WQMOK4h3/kgx0ul3yB9j/g?=
 =?us-ascii?Q?r3NbEkDHH1jaUfeb+L8FbTxHx5L90hrUG0+2cXppRd8CkLr8Sw2dt6pjNNnO?=
 =?us-ascii?Q?qtp2U5l3YiE1c6kHCBb8L3AtOmPNwVkUAuMI4BOGo50gbkZUlMBFtHPAoSlm?=
 =?us-ascii?Q?lCTLnFqeQM02Rwx5scWdrOCmlN6Tza0SgjxJSreAGzNZdJM+HbqMbaLrKXai?=
 =?us-ascii?Q?PQnwOl19tPzmUM173sDd2EidWEWd2mARWTijNxHKWasFJqzjDt9ot6QEwB4T?=
 =?us-ascii?Q?0c114lLhLKW4qkh7x97ZQ1KTFz7kfzrDe6zHHULNYQD56OmK0PzRGPdM3+9k?=
 =?us-ascii?Q?nH6MSgjlarw=3D?=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?MKAsI6I21mNAxRoOtRyUoaluj7EJ+j+MLnLPxIpdaX/kX/W9x9yCO3mUlBtZ?=
 =?us-ascii?Q?r+6oEPCFmAbGElCkE4j2GHfZ6YDlPbKD++/eui4+F/JjVcxRCLj7txeB/KU3?=
 =?us-ascii?Q?DouJmjF6ZxXVzK2yJLRn5nI65T9blKiPuenj3O+q53vFNxARmwDhjLFf/M69?=
 =?us-ascii?Q?kbLuga9eZuxAW3bdUMAYdBb+xZowZMR4QkLMyyI78qyQRu6VfGCXaUOdKl1p?=
 =?us-ascii?Q?lMRf6XnJuu6xSiXpcD4esn/0zandCmb+mZ2Q40ODVWSc0VEasynsTDSxkqJv?=
 =?us-ascii?Q?u4iDwtGJEH2WM4Exx03tkDCFPfv440lm9DHV+PfZg4obm6X13VcpXn1J7xxC?=
 =?us-ascii?Q?/UmmJeVeIdrBNN/Um4Bc0JIxeUbGH3WwI1LlQc0tlnFyFQ2YelMlz8Wagg9d?=
 =?us-ascii?Q?vN8D5pthiuNkbyTPo0Xycnw1IyrOPxpLptYlksn5z08FXX1+ieuDpVGZFk8b?=
 =?us-ascii?Q?BKRtVJ5PUf0lSb+5XXhSx6H+ukfHAJ6kduy2giqYNYuRmQhchIZrdaor9AYH?=
 =?us-ascii?Q?DVEez3Q7pCuHKCLJboQGkCzayWuYA+ZxIpT3NtJ4POc5Qcy9nTe8rXWoQMbv?=
 =?us-ascii?Q?y71PpnMXJSq/1EPFQ4oB4nDBmyBQBfHbqm0GQiUDLT5FW/r20mQWHz2vTugS?=
 =?us-ascii?Q?vO+SltFNOLjxAxaB+4N/ONrH7SrYjALF52L9JuhsYbrRwOdKp51Q27hdO8Yp?=
 =?us-ascii?Q?1GXMXkZlXLfJ6Cv0Q7Lwxh3nfgZaAelZ0VTwR0tkVlcx6OLx45+oCfS0mFnb?=
 =?us-ascii?Q?wq3i1UESVaSSOjVraI/Zqb6sRxsbkW4+32qmKJLfhmNOJ0mN0Y6pexjCzfWh?=
 =?us-ascii?Q?ZmhJwDeZrM+NuEmtdM0s+Ug70kiLn4Oq++agMDY5vS4f/K9hkfqc627ifXMv?=
 =?us-ascii?Q?1RfrJirlJR2h1qyitaJQYAZQTvu7CDNK8TSTOXHrQNv7m1eymcvwr9+lOJDf?=
 =?us-ascii?Q?Yhpm8LENOUYKmZHMbiXm2OHXTNF5ZJkAM6q+SpIofq7nJOSEScxYaydrXieF?=
 =?us-ascii?Q?3ibHBXdIbLmV7KNG1a49aPN+1mPIK8Emdop0A8MpvppAt4j6RJOVnWe247Xc?=
 =?us-ascii?Q?G+SCvRU0UO1UJ7T1cr7MxPAzlBp+mJSBMBElZDU0MOMq3Dcb8EReOlhRWoJx?=
 =?us-ascii?Q?dOiF1bBrnM76dGmEHZRpLTEFsYfDRxPoI2hIvsRyFq/vigNVbhmdLFUJopYf?=
 =?us-ascii?Q?PQosAsbY9FAkh8CUFLZMfGOkWnG0bTLdzy/WBv1BXZcwZKsS+fzKS5qO41v1?=
 =?us-ascii?Q?t+682teD7dbDn3/ZSNUD6M+YzAe1/SxtgFLbkGQrMa8LJJxcrJbInC6HaHQZ?=
 =?us-ascii?Q?kro4S5asRoLAq4+hhtCBjO9nyojWM+p1oB3CnvjvXF3LqwQzeHZSM2yJPr4s?=
 =?us-ascii?Q?+2nmHJczp2B/kfi1YOdfVadg/xfEKuXfZoKsUCGnqMHMyXTyonWs09XiUCkv?=
 =?us-ascii?Q?YDXAvbnLuJ8yTPy+WUtoGIn8l6wuZgBk81m65hX/yVc937gLbDnSxdfnXRah?=
 =?us-ascii?Q?N3/qyAaICXoqnEIfJPDNpXU1Albhr9OG/JGeUEok77qhkG629vs43Fp8Qcbg?=
 =?us-ascii?Q?Ky2eNQ+R3d4Zak94hmYNR9N9xc9/FXgEZMADJfVVlqc2gR5tNoCs0tcfhG40?=
 =?us-ascii?Q?sQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
 gJHWmomeyY5SEZDiwfN/Bvfrz2MBq9PHhQaEpd0jjBoS66WLYYxY2zRAAQq0bN7Zb8gBxqnRFyjKF4q5cdrAgcopY8nusNb0Ff8HpqZt01MndYXOFvOjQxwZcUA4moN7qmZ1WEoS5sBBa9NraDOVpE9Cni0Zhpe1oUjpgxsUYcLPgaxGoc6ET+zG/v8yQ1dyD9wh0EoIZiFQgb9dOEyBUoOdl0IEKLVNp3sr2cUgoyF1CCtBPZl0bpuEAM52rBVLtb6IF/eJUdyqyVEXUzOklE4lLrQRggfaL+tofkcjdaaR4hWCwqNy6UwtYaUl7WPcC7A/61ebJRJpaPQem6Q/PzRqlsOwtoxB/no6zPMyXFiIgUnuh2FVaCB41LFun2jFt25JZ4pIQvCFYivsIJVR0pZ4jQvU7KWBl0qQ6FDJKW7M7g+UmCpSK20o6rWuGpbo+u4GSrjw5adpEZjkUJUtWMxQjMXnjT/zoLPRUgYNBy0rilewizuYqb5t+78xMFE4WHB2+e1KxqckigIHz/7UqFdzpJO943nnFLqbu4M7l1dgSiVdAcuobuegy+WBgS2KcnsTYCQy1e7qOqooAdiEILK2f2TfV/vGyYfCYYf8Q5g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7b3393b-b053-4fa7-8c59-08ddc0691f3d
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2025 10:53:08.6591
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0auSthGVYfDbwU6ZgRxv3JnGVCm63HkAwOAQw1R9nVRMcQ6XB8y3OwyMVvtFXAgBLDm/viz0tcJBqXVSD+pGVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF079E800A3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-11_03,2025-07-09_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507110077
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzExMDA3NiBTYWx0ZWRfX9q4GwwZQSdV+ UioLZuXq39mMpIJFOVi1LZvgdVRIU+BwzeGzVLLxAx24ZFql0SzAqiRvWW0JF3IQOzbiDxp6pfj NWn1PxhaElgRkCZhVydIUJW5ygi2AlBFAc7obRJxLqyYaHq+ApRducG/kSezpNSjQiajv7xoI2S
 8UEdbfoRvnH88qqx8FtVhd+oLdimzFCxl7yrg0mLMIvsipwpTuuN1mouGnalIi6lIrm1hT8TJn1 NbFj7xEqPFWSKjefHv9K4+yFGlfxM+UzLdKy/LI7yfbTIIA9mmi1Nqzh7LWnUXnqNYkZE5YI83l UIhQSzBmI/MKZW4sD0oMlS3qjxWuMBkjmPKqJ5dzeVuKQVVoilYVCYE5AWEn0B05lGGWOstuVu4
 5jjgskYhJkJk3DflivTMIEzOtGGWZcwUqSDIWo3lEIEDLUoV3NlmiBh0XxPWVY/W6NBD7dtS
X-Proofpoint-GUID: DfJsuH8gVJJjS35oNdvH6K-5iejWhvl3
X-Proofpoint-ORIG-GUID: DfJsuH8gVJJjS35oNdvH6K-5iejWhvl3
X-Authority-Analysis: v=2.4 cv=PpyTbxM3 c=1 sm=1 tr=0 ts=6870ed31 cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=VnNF1IyMAAAA:8 a=yPCof4ZbAAAA:8 a=nnU1Q3cZT5At5It9dlYA:9

Currently we just ensure that a non-zero value in chunk_sectors aligns
with any atomic write boundary, as the blk boundary functionality uses
both these values.

However it is also improper to have atomic write unit max > chunk_sectors
(for non-zero chunk_sectors), as this would lead to splitting of atomic
write bios (which is disallowed).

Sanitize atomic write unit max against chunk_sectors to avoid any
potential problems.

Fixes: d00eea91deaf3 ("block: Add extra checks in blk_validate_atomic_write_limits()")
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 block/blk-settings.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index a000daafbfb48..3425ae1b1f014 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -181,6 +181,8 @@ static void blk_atomic_writes_update_limits(struct queue_limits *lim)
 static void blk_validate_atomic_write_limits(struct queue_limits *lim)
 {
 	unsigned int boundary_sectors;
+	unsigned int atomic_write_hw_max_sectors =
+			lim->atomic_write_hw_max >> SECTOR_SHIFT;
 
 	if (!(lim->features & BLK_FEAT_ATOMIC_WRITES))
 		goto unsupported;
@@ -202,6 +204,10 @@ static void blk_validate_atomic_write_limits(struct queue_limits *lim)
 			 lim->atomic_write_hw_max))
 		goto unsupported;
 
+	if (WARN_ON_ONCE(lim->chunk_sectors &&
+			atomic_write_hw_max_sectors > lim->chunk_sectors))
+		goto unsupported;
+
 	boundary_sectors = lim->atomic_write_hw_boundary >> SECTOR_SHIFT;
 
 	if (boundary_sectors) {
-- 
2.43.5

