Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 104E528EA;
	Wed, 16 Oct 2024 00:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729037500; cv=fail; b=Vt6ArLA+4dclVdeGBBi/AtV+tcDYpywWOKAnaWfz0TUZdcpWqklcFVWKG9FCx3bZe4LpTAZ27CuBddfkoUNeQMAtajtaJHmWcedLv6Lt6Yj3u3Bqbr8UMabkk7jBUY25W27l/ut5G2igiEanqQNhNL4y5beIFHnx21FwikOAiNk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729037500; c=relaxed/simple;
	bh=uHLlTJw+ha16zQRFdlXVPV7YtE/SzYv+OX0cydsi8xM=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=BhnHHsRvp30DDnPmSAFScvugp9EjGqQtw1dRecfkOCqhohbJK/SvVfMGrC8+Vt6NeAjuzbkKCDYWt5CQNKq4Fsgav0vFGR/iD4vK0jk4+EOiEBPmebWll1szAz+adOoS8LnXpTxKuRB90qX2dDOxBF4iIsmuC+83/+HN/yhI0jM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lThs9oQA; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=rVg9AykN; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lThs9oQA";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="rVg9AykN"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49FHtfS5008248;
	Wed, 16 Oct 2024 00:11:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2023-11-20; bh=+4zqg+BidWmtovQK
	EeSqbL/+Xp7meqbw9lJnm4UhNCk=; b=lThs9oQAWckp+8CGbQ1GhJd7FL3BN1Nd
	YsV9mbIiPL5D8vNVEkhSlVVwEl4lMP+tuymqmkt4uSr2CkcoU/UM9r05csQ4vRno
	qOnaddAYYGeRD/qa4csgEJkkpxwGA3f0+HO02pj3x8NeW/u+E06/ipWjKC3GN7nW
	xrHLpqYtmmeI0hF3Uth18VjKC6jK2KezQWaalQp2htJlc9E3/IzOJPgNwqpA8baw
	EoptokEheA8CmQlYse61wipmTRxyH2Q+aeqV0m3zlVEb9xzVEefmwpfebMkWXDgp
	wllO+5ObOusMQUTVnkBzJIiIUNRgg4JLRoXnneSn7hfN6+NAQMNeAg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 427hntaj16-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 00:11:36 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49FLKOWR020102;
	Wed, 16 Oct 2024 00:11:36 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2043.outbound.protection.outlook.com [104.47.70.43])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 427fj85maa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 00:11:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q+g76CtHzdbnWixhOuKyr82ABLZG/P17dz5ADoLEEMSeeNSege1+MezKcaIjBtqr/KKBEfkKK5CWKWyrW9ooyPpL5ROStDg3HdnZbqNLK5dIvZcqYz2gYsxC9AxrmFMt4eH1Q19TjSenfxBJfudT/EqRqL9een7CgwTdkyhc9BSBF0iWVlOU+XjeikEtiy+R9/K/yit14loPjfhtrMmggYvy3uDDZkPowi7UkpAubLgkpgtt6z6CjA5u17HANGyEkEI65BkaA1+ca7tw2LOHcUcj52ijoYB5DYBVEByQ3soMQBTgJEtVg/nD/927Xjn/ROJhOv4uX7b9yQuf5GMXKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+4zqg+BidWmtovQKEeSqbL/+Xp7meqbw9lJnm4UhNCk=;
 b=NMsVygXF7uYwI5hb2p6SAO+FtwjhyVUPIipkZhAGCIxS39MXrQ/8pLvlGGLgAHjAI827dW8c1wuIkB/273gjxQjTXtBrpGvKVVqKk0KMcNJIpEQWj+jUHFoMknef8UM7YPOrAc5LVSk0HLd7673DTN3s2FD9Di3Rgx6/cveE1TVCXeHKb8cBvwxQJtQ6OUSC/7at+RVfdDdVhQQDoM1qq7Py83+V0FfL7Plb71rOyiq9R8RFdr7pwW1zXTFni2FgRn5Z2q9TVzrfamecEVGEFyRL8h3OzOItDN0MmSnQjgDKsps8jy3obm9nBZfKQBEMLNVgRxyqAdhsavx8gy0H0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+4zqg+BidWmtovQKEeSqbL/+Xp7meqbw9lJnm4UhNCk=;
 b=rVg9AykNW4oIoSxKrCJnPhcDlx12ugl9xs2k3ikGgdIlctN2iRTbT0g59FaiqwyYwXN8M54d8OjxUl3Zj4E2HMOBPLCvx2ecz3ybMVmsdIBKJF3YrtwRzODuOqATkdYiUg+pN1fHmmbVNGpaD289oR3V/v7PjB+8aJJXt99Qhgg=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by SN7PR10MB6977.namprd10.prod.outlook.com (2603:10b6:806:344::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.26; Wed, 16 Oct
 2024 00:11:33 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.8069.016; Wed, 16 Oct 2024
 00:11:31 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 00/21] xfs backports for 6.6.y (from 6.10)
Date: Tue, 15 Oct 2024 17:11:05 -0700
Message-Id: <20241016001126.3256-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR06CA0050.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::27) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|SN7PR10MB6977:EE_
X-MS-Office365-Filtering-Correlation-Id: 08d57e33-25ee-472a-8905-08dced771689
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MElHeVFYWE80ZWsyRk00NkxmNEo2SFFxVFcxQWU3aTZISlp2RDN1RFJ3MmJ1?=
 =?utf-8?B?MkQ5RUMrTUVXSzVubnFYbCtKb3N0dGZueTdvNEk2SGNqZHBESUFHdjVqQ1cv?=
 =?utf-8?B?SnQxRGFBdzZtejNLODhjRVpKK3ZSZW1sWUc3ME9KZ3NGcDYza2pLR2t1bFo2?=
 =?utf-8?B?T2EwbGswek16Z1UvOFhEYWtpeTZObmJiOThOcWZxa2RBQTJOUXpwTlJKTHM2?=
 =?utf-8?B?N1NBVllaODJHMmQvVFg4aFBtaWNwRXcrQms1Y1hzRHRJYUVGU2w2ejFZS2pD?=
 =?utf-8?B?TndSbUZkd0ZQdGRZNTBhckxzdEs4MzUyTXZxNG5rWFdCZm9PeWxXTFZLZXFY?=
 =?utf-8?B?TEViU2I5V2R1SWtiY05pWjBQaWs0eHdnajNNY1FIbENqWWd5RnFlODFndlZn?=
 =?utf-8?B?OEpPcUlZS2VSSCsvNXN2alR2My9pelVnL2QzdW44MXNVdllEVXppYTRSVXho?=
 =?utf-8?B?R29peStqTStOQzA2Q2g2R05BT25nSkFzbXRJdkdxbllqMWtndS9ieTc5R2NS?=
 =?utf-8?B?VDlWL3BFdmFlUVpvaThCeVhJb0JJYUpIbENsT1Z0bCtGdzNkMy9ZdHNNSUNy?=
 =?utf-8?B?dGJralBSOVpBVjBvSW9qdWxlRS9OSHNta3dFdWFZV2NsRlA3UitPU1AyVUN6?=
 =?utf-8?B?ZERlcUtHaFVEVTNUa3NaYzRmRVhOV2JQVXMvTGpJc25yT2hWUkl4TDljSDRt?=
 =?utf-8?B?OThzSFBKYmtPU05JTTR5RXdUdW1yTHdFWjg0QkFSY3c3N3IrdFZNUHhvb3hF?=
 =?utf-8?B?WGNZWGdBaHh1OFc3UitxcXhpVXlUS3g1b2N0cHY3Z1B0ZVhtYWRVWEpHdkZZ?=
 =?utf-8?B?SDFoTC9tdERHNktUeUxRc2h2ZUxlTEZ4WDBnZ1NaVFNmODlmditvcnZUSFZm?=
 =?utf-8?B?anFJSTZwMTNuUk4wQklZMWNlUStjK3lYcndraXJwaGxGNWJqZFVvQnQ0SUNq?=
 =?utf-8?B?WHZqVnQzc3RBQ1JqQ2dKYWNCWDJ4ZGk1N3FqMFppRkU1Mkp4SFRoZjJkVXR3?=
 =?utf-8?B?NnNsaVVHaHZsLzA0YnRQa2xNTXNjWDIrU1VSMzg1aDVkT3RQYWlpNjFMM1Ri?=
 =?utf-8?B?WjA2cnJOK1dxaWJDZ0djSEd5emtGNUNXOHZ0aC96VkxQSlRGdFhpZUpiZFg3?=
 =?utf-8?B?amI3SDgvdGw5ZmlzV29nSmVybU4wSk9GaGE0NlBINjBXWU9RQXlLcTh5U1px?=
 =?utf-8?B?OW1xLzN5NG50bTlmYkFoZHNHTElxY2Fqdk1HdkhOMFZ6ZnkzWElUZXBYbHNa?=
 =?utf-8?B?ZndTamEzMzgxOTJFMTZudFpQZmI4MkpzZEs3SGVVeE1SZnMwQWxWdTBjVkVk?=
 =?utf-8?B?QmdySU8vcmpXNHJ0SFN4ditFcGVaUnNWZXZOOFQrZ3p6YkZGbFRUYmJQQ0hV?=
 =?utf-8?B?QTZXVS9jdjM1L3dHdU5Hb0tHMkp3Y0tmWU01bm9nRG9adzNudEF3TFJmUUVa?=
 =?utf-8?B?VG15aW42bFRtei9zK2wwMVk2V215NDZZSjdGdUtKRUlOc2xzN3ZpTHZKV2c2?=
 =?utf-8?B?clIyT0U3T1FQb1U4WTBSNjMzQ0kyWmp0Tmt6Q01NcTNxeE1YQmFFemNETG1i?=
 =?utf-8?B?MW1wem8vb2gyT2NhRXhqU1FtTFd2NkMzNk1oN21lWFViZjhMMWRCUkdoL2pZ?=
 =?utf-8?B?UTJIdkhhcVlNZ2JkQ0dsQVZ1ZTlKbEtrL3ZZdzBPZ1RpZWtuVFFlcHROZzNk?=
 =?utf-8?B?Yjl5aUZ3c3VBVkZINUREZEVBU2c4NWIwbVpTZ2wzMGI5L3g4cnJOWHBBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?REZDbFV2eEtZLzA3K2IyeFZpdlQ5UzZLZXZDRGdxSTc5WlFHOTVhbXhORGto?=
 =?utf-8?B?b0FkN3lUMUdHS0VNMWlrMkpYMTV4YUZKUnNaZXdxTXdDTVNjTWt3azJXWjNE?=
 =?utf-8?B?NEZQRDFGcUcrNmhtMHY0NlZnNzlyYVZIZlVXTlVocHkyaEtkVzMyZDljZUo1?=
 =?utf-8?B?ZnJrbDNXaGtpVmMzbGZhRXNsU1NGdzB2OU9FWGdTU2h0M3puRnl3cHNQRE11?=
 =?utf-8?B?UnVCK1V0cUxZTWRlVkx6U0x6SC9GWU1HeU1ONHJsME84ZFUxUFBNN2ViZk1h?=
 =?utf-8?B?K05RTldQWnZyb1JNV0k4ZC9WdTArZnRFRHE0QTMvdVlPdWh3YVZqbjZSZjFP?=
 =?utf-8?B?YlJqSnZzRXE2YnBoUjR2eUIxMk1neHdubno5Yjk5MVZnREFGbXZxcVpHNE9h?=
 =?utf-8?B?YzlOM21GSzBFemZMMDdTQ2NLNUdJUXV2K0VaeGxwWUpHUHcxRUcvWkt1VENP?=
 =?utf-8?B?a0U1S3l1OVcwNnNUZ04rakVCWlJNVlN3dW13eUFCN3JnVTNsWUV0eXYvZTJl?=
 =?utf-8?B?QXhDR3NBNDhTRnBGbTZWSXA2ZlZua0ZBbnYzZTZQeHVhOXFINkRUcWQvbDlx?=
 =?utf-8?B?TWhLd1BTZS9MSHYxSzVpYi9FTmpDbW9GRkFJM1pZTWQ5YlcvZzBWVWlNb016?=
 =?utf-8?B?eFVIQXl4cnYwS0ZoZ0U3T01La2svbXJjL1N3a1dnSVZrV21YVGs3Z0JySTZx?=
 =?utf-8?B?VmtUSUZoL1lCaVg5RnZoQitXR0VsT21pek00c1huZDFTV25YZXVVdHRNZDVj?=
 =?utf-8?B?NzJUeG16Ylc5SmZwUmROUjJyZHZiUldROGYyRG1CWnJEdFdVY2diREljN3RC?=
 =?utf-8?B?L2UyWVdlcXRqdG9MdFVCR0pINmhkaUQxSWtIZmo1OHpJeE92S0kwUURhNHE3?=
 =?utf-8?B?N051RFNpNEVwU045TmZTcUR3R2Zvc3AyZFl5ejltNy95bDlkdEcwMGd0SlZv?=
 =?utf-8?B?Sjh3b0JONjFHa1lrTitRNHErM1pYYkxWbXRSdXorTk8va09hdlRwZDVpM3hB?=
 =?utf-8?B?RkE3QURoSlpydDU2SGZUN1I2cjE5Sm9yWXluL0llc3RKMFpBYzFHckZPNHlr?=
 =?utf-8?B?M1BvUHRDVUpvS1JMbDkyV1ozdURrNlV2S2ZiQ3VHVXRVbHlzUWxDZmpEaktt?=
 =?utf-8?B?NmR6SVhLVDVoYVg3Nnd0eGlkR3UzYXUzalpSQUtURVlOclI1VDlGVXh2K2JV?=
 =?utf-8?B?cXEzZDVMQUcxekpjUFY3ZWFaQ0VBejhrRWtaZ25rc2lXWXF4ZUVHV1VLTmVE?=
 =?utf-8?B?U1QyeFNxR2FMblM4Z3pqN3JBT2I0cFhlMCtJWmlpeCszeE1BbldmVG8wNU53?=
 =?utf-8?B?RDlubVpNanhkOGVnaE9FNGRSbTVwWWZIUEpTN090dUxWMkUwOXpXeVc5YnVj?=
 =?utf-8?B?WkVtN1FrMGJNeXNQandsSmhMenh2MnQwNW5vR1JuZDZmaGg1S25lTkI4NStT?=
 =?utf-8?B?S1RhT2hMRm1ZSWc2aGxxdEF3OHVUQXJGZEV2VmZoQzRUamZscUJOTlN4RGg3?=
 =?utf-8?B?dnRSd3JRTXplWWFrbGkvWFV6bjA3K1NLSWFYNnk1TkxHa0RyYjNtRWg3Mjk1?=
 =?utf-8?B?NUlMS1dYdXlEYU5ndG8yU1ZJQkl3dHhjekpSWDYzOEVDR0ZrTThIcThVdVpP?=
 =?utf-8?B?cEg1STVVcFFFbnlpWVZEUjEwd09rZTBHZTRDSjhqakpDVkxyTldLczIzM3Bx?=
 =?utf-8?B?VWpiK0RabXcvc250MkZyK2pQODdQRWdaWjM1U3NXcGEwaHNHdjVyenI2YmZx?=
 =?utf-8?B?VDd6NjJYZ2lZWlFMT1BDQUF5a2lJamQ5SHBDNFRHTi93Y3FMajUrVHhKQ2RS?=
 =?utf-8?B?b05STlQ4VTZpWWNlS1V4emhqbUlWTi9MM1Q1enpKYkROWmIvVUxMVGpPV0tR?=
 =?utf-8?B?YkVsMkhqMEpldm5SaXgwTEcyUms0cnBXWDZIVHFvVGNjNE5ZU0plWEI5UDBW?=
 =?utf-8?B?NnlNM1JYWWlwWVBPQjdsSEkzUmlEcnFsaUw2VjM3a0xpVDBraVlhYmZDN3Nz?=
 =?utf-8?B?cW5mOXdnaEF6YXRrWTZJRDVOWmljYzFacThqa0JjMkh5Tms3THBJdHB0Z2FN?=
 =?utf-8?B?NTU4SnZiQm85RmRvbWE4M0Ezb3FOdVZ3NUQyYU9NNkJQQm0xbER6b0tZTXly?=
 =?utf-8?B?TlZ5VGQ2UjB0cU5IMTZ0R1p0QzFBK1FKcCtxcnFUYjY0MFFFQS81a3VsSlB0?=
 =?utf-8?B?SCs3ejhyTmhMeDF1VkRsZHBneTJpZ2txMmxmanVSZUZ0VkxmTEZXVStPTW40?=
 =?utf-8?B?Y09ncHVoVTVjNWl1UDFSMGxKM0xBPT0=?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+Z9LxqAI7E7iTUF2Zm81svUtcuEubU94z5+GP4VbFO1fISyGrPFZOyf2L87j/J00U3Ow7ilsPWgeONN7aLSsc3bEks8/ylCXqSuw+PKJpmeY8W5sLaFQs5FXWF7V3VQ/2SOhuZVizsB0FeXZ7LjR4McDvnr6lq+17Yuw4Me88tAzHlIvZneN8NCu/EJezO86YyzapV3801AhGdZH1r4QKZlv7Wt0A8NexItF4amp9G7fLVOMElUFl19J5/GWenC1Dmq6FU9e9aFUwLT556p11NV6hA90Fi7OJhlztJD8RQW2Sz64sxwqXXnaVZgc6wfjb+4cqCDKZ6t05SjaHTerpP8zAOIwKySTVgOfLluMcdZDZqS2z5GFfcWAf9zmtO/G7//t27PRtdnqRVHWqi1tdt+GnVUWZcuvyxzpT2+aPREoYW/NU14+fXIGsA9HsQ8mD2lzMp4LAm3mZb32v5YNpauUW1zIM+xzVF+/EjH5ZFdgaXvXrHlWzfsdRfvTAOQr2hf7jw8CSLwqcnbALR2iGFbQnITjuA5Rr2qcVddt8xowKsXI6V44zZhFthIOf0XvQ2oQaZhNgus5MHTQ1cigXZcSx3l+DwHN8Fty95vo22w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08d57e33-25ee-472a-8905-08dced771689
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 00:11:31.6325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YQv7Im/mZDGf6dnrhcROCJDegUGeDqpmVNHFI/6TBO5QEcgpURzxN66ZZPa71PrOVUPlQCkdJa3UFWyYwifOmAlzMj8Dvk1N1ef+hbOajO0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6977
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_19,2024-10-15_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 phishscore=0
 adultscore=0 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410150158
X-Proofpoint-ORIG-GUID: 8IJIz5y4knmnknPgLEUPaNIQZY0O5STB
X-Proofpoint-GUID: 8IJIz5y4knmnknPgLEUPaNIQZY0O5STB

Hello,

This series contains backports for 6.6 from the 6.10 release. This patchset
has gone through xfs testing and review.

Christoph Hellwig (4):
  xfs: fix error returns from xfs_bmapi_write
  xfs: fix xfs_bmap_add_extent_delay_real for partial conversions
  xfs: remove a racy if_bytes check in xfs_reflink_end_cow_extent
  xfs: fix freeing speculative preallocations for preallocated files

Darrick J. Wong (11):
  xfs: require XFS_SB_FEAT_INCOMPAT_LOG_XATTRS for attr log intent item
    recovery
  xfs: check opcode and iovec count match in
    xlog_recover_attri_commit_pass2
  xfs: fix missing check for invalid attr flags
  xfs: check shortform attr entry flags specifically
  xfs: validate recovered name buffers when recovering xattr items
  xfs: enforce one namespace per attribute
  xfs: revert commit 44af6c7e59b12
  xfs: use dontcache for grabbing inodes during scrub
  xfs: allow symlinks with short remote targets
  xfs: restrict when we try to align cow fork delalloc to cowextsz hints
  xfs: allow unlinked symlinks and dirs with zero size

Dave Chinner (1):
  xfs: fix unlink vs cluster buffer instantiation race

Wengang Wang (1):
  xfs: make sure sb_fdblocks is non-negative

Zhang Yi (4):
  xfs: match lock mode in xfs_buffered_write_iomap_begin()
  xfs: make the seq argument to xfs_bmapi_convert_delalloc() optional
  xfs: make xfs_bmapi_convert_delalloc() to allocate the target offset
  xfs: convert delayed extents to unwritten when zeroing post eof blocks

 fs/xfs/libxfs/xfs_attr.c        |  11 +++
 fs/xfs/libxfs/xfs_attr.h        |   4 +-
 fs/xfs/libxfs/xfs_attr_leaf.c   |   6 +-
 fs/xfs/libxfs/xfs_attr_remote.c |   1 -
 fs/xfs/libxfs/xfs_bmap.c        | 130 ++++++++++++++++++++++++++------
 fs/xfs/libxfs/xfs_da_btree.c    |  20 ++---
 fs/xfs/libxfs/xfs_da_format.h   |   5 ++
 fs/xfs/libxfs/xfs_inode_buf.c   |  47 ++++++++++--
 fs/xfs/libxfs/xfs_sb.c          |   7 +-
 fs/xfs/scrub/attr.c             |  47 +++++++-----
 fs/xfs/scrub/common.c           |  12 +--
 fs/xfs/scrub/scrub.h            |   7 ++
 fs/xfs/xfs_aops.c               |  54 ++++---------
 fs/xfs/xfs_attr_item.c          |  98 ++++++++++++++++++++----
 fs/xfs/xfs_attr_list.c          |  11 ++-
 fs/xfs/xfs_bmap_util.c          |  61 +++++++++------
 fs/xfs/xfs_bmap_util.h          |   2 +-
 fs/xfs/xfs_dquot.c              |   1 -
 fs/xfs/xfs_icache.c             |   2 +-
 fs/xfs/xfs_inode.c              |  37 +++++----
 fs/xfs/xfs_iomap.c              |  81 +++++++++++---------
 fs/xfs/xfs_reflink.c            |  20 -----
 fs/xfs/xfs_rtalloc.c            |   2 -
 23 files changed, 433 insertions(+), 233 deletions(-)

-- 
2.39.3

