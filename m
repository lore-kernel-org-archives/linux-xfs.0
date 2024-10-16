Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A54791FB3;
	Wed, 16 Oct 2024 00:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729037553; cv=fail; b=JuWZmCbe1frvj8PquFLT2ASoXPivsxmawANxwS3lhDbEZ7eIU96NZ3xlrJ1eQMTtabcYAC8dmksjwEvFFa6fYkigif+rhmB0JBM6so2VGuQHh1HvQKXSl43cMAOqHArpHBHm6ksoYkV3J5HXw/0H057Xxb6YupnJXONLwPTWcXE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729037553; c=relaxed/simple;
	bh=d0ggKECF99AgCaY9bUcxBwcJzx6Jp9uCOItOrgd4/7g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hi/KD38Cq+FwRXdK4PxPE+GirfjV9gfpUHwbLISO/7Lj6SR9Rx4UNvq+9q9F+mxKGYIQoL27LcCLZPqYK0A4DNiw3ZlwvMjjwvlnvCjzO3oB87Tgfme2jyCUiordp7FlY37KKLLKqtY7lDky5hqhW4qGpKbmRx3AqD4s7jE5/Ao=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XczIjTI4; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=AsgsCcyP; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XczIjTI4";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="AsgsCcyP"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49FHtguG029134;
	Wed, 16 Oct 2024 00:12:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=dbCmQhVOFmJZyundu4Fp8tTbhMSMAExhM7lu7PXEz9s=; b=
	XczIjTI4gt2b4hYImcRknMmvcwSVbb27ndFDUAt5jR9ZwmahmMnIVzWMGpqItKZI
	+bHV9VseWrbi/byCJu4slsrwpNwZgYmJgqNpLCY7mNZy5QUkNWvplkeJ1yd8coaC
	VFLLkuBSXgWO2WJruBXRtD7F3TAA8YFzPgrXptWKkag8W3jGOMDMV6VACYhPlxYZ
	o2TiiAnHHku1W7s/UiZ//oUb49uOCqn80FxBP12USC/nlzXuXQ5oDsw4BJCFYuwk
	R3KNPaCqv8zYKP+4AZxW9eJ8qqa0PLybqulOi/P8ailBhLpDk9caISbBj6LnLYoI
	zp8YNqnm5HSlXFKAKnzlzw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 427fw2jk3w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 00:12:29 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49FLkLw9026369;
	Wed, 16 Oct 2024 00:12:27 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 427fj85aps-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 00:12:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M+z3njoh+vEESlLE6mBDIlcoiqkY4O1EJyZsHK27Sqfd7V4DuYXPVFE/SCCoOU6sHXVx0N2zun7YPWOgS3lgFJdR9YENsBMqJ1rJNpbeAQ3DEf6Somc68KgqtiLtQUBhbFrAoQaZaWYcpyRVEBFPpEGGDWg0wR3WwSu72lgmntd0foSeT4VYOkVa1g3wbtrNtd6zRfM1K8JJEhI+C0U0HqmtbIZAXU3L6m5Dvsu6P8K+DueF/8ARIsW7+02A3eWQE+JxLej/kjyql8TP7xTI0TJRs9EToWRHyhqwl2/cHWxUPrZ3F0ApUgZ8VDjp29Qi7w3S3w57ks6COCSPds7stg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dbCmQhVOFmJZyundu4Fp8tTbhMSMAExhM7lu7PXEz9s=;
 b=wLibElH6FvJyJ0+IthV3WS9ZWcfWZ3X6ttF/9HSnYLbACErTRhxOaZvFvXFgMUn9LAeq7xzVzyqxhYMAMtcrX1MjV2B0N4W9WOSVMS207Zlwb16/6pRRHPoardit+Oqnx65bQtHpZzQrPfDFBhjQABpDqnF2SakhdLxMrvsyXuzhKjvouQ7rQSB0li1tGKg/folzzimaiVlHgIQqLcmo/uFv2wrTdhtWs45AySSWMAuY+AQWl6pctsBAhZsI2D1B0/lGvy9lU79plSSpDowtNCDqdAtXbLYZG3VPir/dpvpdq2+JVDmbuxv5Ztd3dqP18+odMqnhZ0+5RHdd/lrTNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dbCmQhVOFmJZyundu4Fp8tTbhMSMAExhM7lu7PXEz9s=;
 b=AsgsCcyPqZkW4JYjWm6NaGF+Oh2jjyARlEVLa4v+/gP3UF7lTCuO/Klp1J+O9Oiem2+JNBDaXzfObgRXJG4LLpciKEmA1NeB3SUUDZfL1Sb8AFu5MgPXc/r6gx/dJMrG8tU97rzck0XRK/lEZNqjfbL8B9i5D9oTmoJlCoyBv50=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH0PR10MB4727.namprd10.prod.outlook.com (2603:10b6:510:3f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.27; Wed, 16 Oct
 2024 00:12:00 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.8069.016; Wed, 16 Oct 2024
 00:12:00 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 16/21] xfs: allow symlinks with short remote targets
Date: Tue, 15 Oct 2024 17:11:21 -0700
Message-Id: <20241016001126.3256-17-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241016001126.3256-1-catherine.hoang@oracle.com>
References: <20241016001126.3256-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0196.namprd05.prod.outlook.com
 (2603:10b6:a03:330::21) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|PH0PR10MB4727:EE_
X-MS-Office365-Filtering-Correlation-Id: 5150fc14-5d0a-42ca-9047-08dced7727b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|10070799003|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?F1FQfIuVCA9evuXzq+1aX351WtM1/Vaf6CX3FvY54xiEgKhhgVVE1yntsZXd?=
 =?us-ascii?Q?X6Vk8TJF7aRAwFy1QjY0ylewkeTfjF1Ra+1TT/EfaIcxR0Gso5MgtdLCN+gS?=
 =?us-ascii?Q?9QGij50Y2fAKLmTLRaxxQOneJRypYaovxTYwr8w/w/F3ibz13UX/mH4qvZbi?=
 =?us-ascii?Q?NHFkdTI6JT8WDhJ1gCyK98OXnoUk9FjE96G4suXW2IYSNM+e2IckJhaFezZH?=
 =?us-ascii?Q?mjF4FOkQIbWWmS4WFlAEVX0gLyisDvUKTRrf+xk9FxtKL1K8uCPUKL+wy1f9?=
 =?us-ascii?Q?B9k5A1MEcX2n5ROLZ+FpYoLDL2ADcDvdQwDzoSQwuKWDWvvLIGd+RYEGuxUq?=
 =?us-ascii?Q?jRnccDfeFACICCRxgEp5BBs43PhashtbvOySDcr7GAFDryI7pQnAEM8uYGsx?=
 =?us-ascii?Q?aNv3YElDEOPFfUdqqlBo9D0vAAxbHNwKDy+UdnCBblFUd7eASCMJLF4aizjn?=
 =?us-ascii?Q?wqUpOae3MWpG5rf3D4QTDIetjoAWnV3ZA5ue0nUQ49Xf8Po45PmPc7Tx2BNf?=
 =?us-ascii?Q?QTrlrfHCeqOIc/YRRazDi8su5iqVzeASNrAhst8wbDeoZCyy1X41HYdebmkW?=
 =?us-ascii?Q?GMoXGJFBJcLLwqWn59eIl0NBzhRbyD4eiOZ1wUTAEbU4zfI9jUBHcmMyRGZ9?=
 =?us-ascii?Q?ZTHV7YR3wWcvLDZfmxffZezyMDkZxsZP0odiNRLo76oXXJBJTsRDJ3sQa/SN?=
 =?us-ascii?Q?reLcelc5t//n+U45S71OaWHfvaco0BmkTMI6dbZBaEhv3epBl4m+PxdgCQft?=
 =?us-ascii?Q?Z4qPW56AgLJciTHmukGZm6vPlMVSnOn37MnJb8LlXzQpoSwJkw+Z23Fklw6x?=
 =?us-ascii?Q?xVh7tOptV8Suq5cHuUXhdeeRGa3aipUXqCiQVfIMskWGZzpmFQTYWGV3MK08?=
 =?us-ascii?Q?kbxxUM9GNV0eWJRH4xnuRSi/ANympYqEGvHu0FlbLEDCzmQoYg+4uGsJRVpa?=
 =?us-ascii?Q?FBN3nerO7a8xq6h0XcpcdRCTlJNBX61XG/KEIfF7grG+D82uABioOtzsDK4G?=
 =?us-ascii?Q?iW6lzA/k6zLJTIh3f3h62ZvwulkxYce5FfRHlrHDh5UdhsoWjM1+FLwgBK58?=
 =?us-ascii?Q?rKS8WtxBlztzWbNBS2XDoxkW2yMuhy3q9AQN2eShZNNKY8RjjEeQtzYEOVGe?=
 =?us-ascii?Q?oCocw2mFvTniESZAhhgCXlNQvTCgZDA6kh22ypn2jusQ2C2BypmXmUxG2PhD?=
 =?us-ascii?Q?qis8z5XZHp8p8K66GRZ1MJxl7+DRUIYB5O5ujsJLNP6nPe4e7Qqmq6NJy2Dx?=
 =?us-ascii?Q?og2Un9/sRdm/Y8UhGOjWehOsHrPXJ4aHs4Nm3lYT6g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?moZLrq7nIw4i5TgA43IG/eHE6GBNI8SJcaPEwzbkliYdawS/Ew3ptI4ktgpV?=
 =?us-ascii?Q?VCD75CbS8WYgCjW6J3JOqHuV9YgfJBT+PzQLjg8Mp7PT4wJk6q8kMf4wNA5o?=
 =?us-ascii?Q?hmwAXOjWVbP92JCh2or/EnFi9C6V9mBtVbrSTLTT3VZxHeWMMeIT7DTWZfGq?=
 =?us-ascii?Q?Paom2WepCJNSgdL1ZfN2KLROAkPc5U+vZA7zpCHhCfH4Ez5SLOQPCCTMdJHd?=
 =?us-ascii?Q?YC1kj1uUwwHmc7zbQR0Z0zP99jmhfsTV1ULEsQ636qJlgNHLcsx1GwPU+sWK?=
 =?us-ascii?Q?QlAcUg8Qzbsu/Fgj9L+Wki80sSQnQ2zYyiAcAPzAfYbp6I5wdAhbhkbi4n9E?=
 =?us-ascii?Q?e6jijl7/j6m9BHA8UF1aEkDYDGHvvZDPHEaaC7e/9OcYMj0obCCzr+6v9XuS?=
 =?us-ascii?Q?jUDURZcDQ3h2CECQyLjPS2/Jkku3Z/TNClgX69gBZoRBFLgGmpm2P05TCeMF?=
 =?us-ascii?Q?tjstyQJcNP0xN26twkLSFkM+/7QIgYWLgGkT4kKqcor8dPEdOQcB3z4mzbLc?=
 =?us-ascii?Q?nwXqPlzHkCIL/0ZFQo2rW0o8WxHBhGGuvls8HqyhbEA8F4KlEMNeMOQqorV8?=
 =?us-ascii?Q?Unv/pGFQiWS0FlDpQY9dTJujtXZoz8T4RvBaTP8ptEkfPy3oFhCiuUYFWGz8?=
 =?us-ascii?Q?ChEM7w6AIX5631BtZwpwy8yr7fPeQZF3Tn8hdVuqjePOy/g3h21N4mn7EStN?=
 =?us-ascii?Q?ShKSRUXAeCIJD3vkIpIKehjaW7rrBdpAvTILhF3pdQWbat7xbhrRvZW+CNW+?=
 =?us-ascii?Q?MG5HskO3W1bpcqfGwerQKGj/TzPB2P4F4ampD+lbwj9l2KjhW8wvqZwy4s9E?=
 =?us-ascii?Q?V9aarMalxq54urpDaRNzo9z9L611WHmA5vlweWLPFJi0RKG62gKRBK3LoIQ4?=
 =?us-ascii?Q?haUlFiARUZZG5MRCAvrkqz06Hkc5OA66AS95rTMoeRdeIX05VYpv1GKdHGOx?=
 =?us-ascii?Q?Nh5n1GK2/qyLM42JEgZvWzJU61uvzZDYKuFOtRHphWax2wloc+8HVbMxqgKs?=
 =?us-ascii?Q?Hdj+nPX0tCjYXeyiamG1rzyb7CT30JIQ/YrU/+tPtlz47oE3m+ZdFCb5PIb2?=
 =?us-ascii?Q?Atlu5uOH98gu5QgzM5qolPUHSyi/aeObpP/5qW9S+8+xRw569dIcRUkiWMtc?=
 =?us-ascii?Q?TYEY3mQwHGUB66oONYiNI47N9v5uDHi/fqfrnnC0j7E7N6h6MtHlzF9mnwZc?=
 =?us-ascii?Q?g+QG/LhG5j9QJ684uf2SbXx9IlOsGPxFE/3Wm9ddvZSt3d/ctZPvym4AJf3M?=
 =?us-ascii?Q?KRJhfryCOskLb1gpKLEbky/9+nKoHAc0L5MY32ClQkKD38LJ02C7cWdZujyf?=
 =?us-ascii?Q?ZRG7YOjp9vpO80XrvicSIGnH5oVNseJCBE9qQkg70hazzgXucL/h6NiHzG1/?=
 =?us-ascii?Q?cSrxmS9JWiu6WOmp3aMWIfYsNftYowktVtptCtcUoBAfGYZFLQpSOsz7oj7v?=
 =?us-ascii?Q?zgUjWf9DylxnJ1yQmrkjcMoo+CMeoQfySlcOQw+Tdzch0zNAuGfyJS9WMkrt?=
 =?us-ascii?Q?Ie0pUGGg4wPjHWl1tgnuy9z7t79+NBTCEv3cYcEnsztYjR7zY1U9gOHJwiPI?=
 =?us-ascii?Q?U8ylGaRDC7OcSkTrPX3JE1Y7ZA9CuPIC34GnLUhtXxCqfFXG2ONJSkvWXnkw?=
 =?us-ascii?Q?KDshjvbEDtADuO7+yJ1dVNpLg0kN9i62PAUJMOqgC3ku8BnjEENCuhXZZwzP?=
 =?us-ascii?Q?hCqHBw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZZW7p8Q2x9rTNHgGeCigd7u0BLJOt8/t3wcyLB+N6TIbm3Av/OBHW/PKAbh9hkxv65eGu5exNdo8iNLj+PkpMwPESk6AkgH6aQVDmjzl8ofxruqJvRzXyGGxs9FmjOyxylqwZlM/95x91VH8ByiJ6e1h9CWgwimFEKOnFiP7ipFeSGtciyy1VJ53895Bl6qZa5D+IJ70JLdhvTW2UoUs6aEVGveQYT2woqQ6xVcvCNr0yLraaPgXKclOtPLC4+W4AoeaRMaGV2i/ouI/bjJk4gF/GVPYUIvZqzGLuRFy9gMi3s8rU3ow2M+4fhZDSYxU62zBLfKkGwWY80LD1QvnlQrl0RhWdrVFXhnxXGyqGI94HP2nv8hibQupknWP/gV343+ctKvvt+tbwqLevb3qz8SECAKG09ldlj4Yt/dCWDORLtRioiU66zlxr+oGZ7utXemoDPXLLctG4dWH28OwP4E2uNgYvD661fVq/eyoNvm8oil74lYCqdYYpbm/XcRZnVAtu+otni54ef0YP7shOwc7MJnWLB3UNoTfwdbsqxtlYKLl5HDp7wuXNeIYZxoRUsDILnDR4/r0/ksGorDhVENA2ER3j90sWYgcyrcyAp0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5150fc14-5d0a-42ca-9047-08dced7727b6
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 00:12:00.4354
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E4FHqZfc40dOURIxjJpjlnEB2f5gyMGUowltMtNwDKq2z1UZkgQnoqUUdSxN3ytEmlixmYBMvL2YuZgUlSin2zXirzYarp4KxxlNrJ5MVwo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4727
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_19,2024-10-15_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 bulkscore=0 spamscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410160000
X-Proofpoint-GUID: fCDjEi73FFPsMrZtTukL0n-8VBO7522w
X-Proofpoint-ORIG-GUID: fCDjEi73FFPsMrZtTukL0n-8VBO7522w

From: "Darrick J. Wong" <djwong@kernel.org>

commit 38de567906d95c397d87f292b892686b7ec6fbc3 upstream.

An internal user complained about log recovery failing on a symlink
("Bad dinode after recovery") with the following (excerpted) format:

core.magic = 0x494e
core.mode = 0120777
core.version = 3
core.format = 2 (extents)
core.nlinkv2 = 1
core.nextents = 1
core.size = 297
core.nblocks = 1
core.naextents = 0
core.forkoff = 0
core.aformat = 2 (extents)
u3.bmx[0] = [startoff,startblock,blockcount,extentflag]
0:[0,12,1,0]

This is a symbolic link with a 297-byte target stored in a disk block,
which is to say this is a symlink with a remote target.  The forkoff is
0, which is to say that there's 512 - 176 == 336 bytes in the inode core
to store the data fork.

Eventually, testing of generic/388 failed with the same inode corruption
message during inode recovery.  In writing a debugging patch to call
xfs_dinode_verify on dirty inode log items when we're committing
transactions, I observed that xfs/298 can reproduce the problem quite
quickly.

xfs/298 creates a symbolic link, adds some extended attributes, then
deletes them all.  The test failure occurs when the final removexattr
also deletes the attr fork because that does not convert the remote
symlink back into a shortform symlink.  That is how we trip this test.
The only reason why xfs/298 only triggers with the debug patch added is
that it deletes the symlink, so the final iflush shows the inode as
free.

I wrote a quick fstest to emulate the behavior of xfs/298, except that
it leaves the symlinks on the filesystem after inducing the "corrupt"
state.  Kernels going back at least as far as 4.18 have written out
symlink inodes in this manner and prior to 1eb70f54c445f they did not
object to reading them back in.

Because we've been writing out inodes this way for quite some time, the
only way to fix this is to relax the check for symbolic links.
Directories don't have this problem because di_size is bumped to
blocksize during the sf->data conversion.

Fixes: 1eb70f54c445f ("xfs: validate inode fork size against fork format")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_inode_buf.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 0f970a0b3382..51fdd29c4ddc 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -366,17 +366,37 @@ xfs_dinode_verify_fork(
 	/*
 	 * For fork types that can contain local data, check that the fork
 	 * format matches the size of local data contained within the fork.
-	 *
-	 * For all types, check that when the size says the should be in extent
-	 * or btree format, the inode isn't claiming it is in local format.
 	 */
 	if (whichfork == XFS_DATA_FORK) {
-		if (S_ISDIR(mode) || S_ISLNK(mode)) {
+		/*
+		 * A directory small enough to fit in the inode must be stored
+		 * in local format.  The directory sf <-> extents conversion
+		 * code updates the directory size accordingly.
+		 */
+		if (S_ISDIR(mode)) {
+			if (be64_to_cpu(dip->di_size) <= fork_size &&
+			    fork_format != XFS_DINODE_FMT_LOCAL)
+				return __this_address;
+		}
+
+		/*
+		 * A symlink with a target small enough to fit in the inode can
+		 * be stored in extents format if xattrs were added (thus
+		 * converting the data fork from shortform to remote format)
+		 * and then removed.
+		 */
+		if (S_ISLNK(mode)) {
 			if (be64_to_cpu(dip->di_size) <= fork_size &&
+			    fork_format != XFS_DINODE_FMT_EXTENTS &&
 			    fork_format != XFS_DINODE_FMT_LOCAL)
 				return __this_address;
 		}
 
+		/*
+		 * For all types, check that when the size says the fork should
+		 * be in extent or btree format, the inode isn't claiming to be
+		 * in local format.
+		 */
 		if (be64_to_cpu(dip->di_size) > fork_size &&
 		    fork_format == XFS_DINODE_FMT_LOCAL)
 			return __this_address;
-- 
2.39.3

