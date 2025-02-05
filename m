Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D80221323E;
	Wed,  5 Feb 2025 03:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738724898; cv=fail; b=qOATBRV7qltLOei6kI2ncZvZGo1FuQ1RYv9qUSvey071vx2DvkADNriLiFKZYikbxYDO3IJ3V53IXq0OOdBls0RoYrPOFubAtOvZ/uIhkboeOjWgfLsLhDzEaAohAQDx08HoaGnAfaO0MGZtXGT8EmF6t4RCHxvKMRt1pqrH8zQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738724898; c=relaxed/simple;
	bh=AQpZklZ9XuJG3N/PD9sdLlPSuxD5Y9wV56biQKv5nQo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Eat6uweM5CGqSh8Hx/bmE0sRLbyxXIHI/T1q3qbc6Y7Aq3dRSOPavzWyUCOh90zHm6HJWJhThhBSrzB9dkK82ij9FqKtfn7jaRHLE3+eybdl4L+++T60ujpMrOUDDk9oxW5IjAE64krAzX0NP4398FsAufAca9KNaAnVMdhNezY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cDlyGcE9; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=VE+QupEb; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cDlyGcE9";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="VE+QupEb"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 514NBpMh003368;
	Wed, 5 Feb 2025 03:08:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=IQaC9o9XaDORRS4BwZe7WrHh6MbeomWF/mx9+VQGyMc=; b=
	cDlyGcE97EXqnZePLKkB8oMT6wFXi1+gd2EwXoRYPWZV15r+OTypII9CzgJorBJ9
	2HqRE1QR+BbJUje2p9FIZimip8h0rMsi6hA8mu+OiHacCJ1NlnPPzWrneL0DjcMS
	3wW1gV0StUav5/ooSN9TL337k1CFdEjBI0JkqtYaVCVdj/84nAn7D2yf61THRLm7
	w8Xn7O7ig7gpULT53s2mfXt1nlTCa8esRCqUxLStUTnT8CEUSVh2h2kK1uC4EQ51
	nAozwNYVB3KgKcRZkDJZk4swKzgz7P1B1iKiwW6y5J9yHxH/K5MmmoJQKSNwSJ/U
	gmSKmV+8l5h7quifsDl7QA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44kku4sdae-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 03:08:14 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51518ZsX037739;
	Wed, 5 Feb 2025 03:08:13 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44j8ghsn1b-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 03:08:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TiZLYoXF7CRYOoxcxhcsZhR8kXf7rjNTG7Th3yLCpCP7L/rsHDgAw5g7GyQyymGMpXksCnxjbpa3EnEc2ALX8i2zS78xzZ54ODt9PculLo0xyEBxnO3mBeP1N+aL3HeNvft+Gazg+eJkvnlZdvG6FbzHNA3nac7O7VhPDWalVAAFjTe2RwdQZZ9Wgg9a+e8b/81lTLrYuYDzFGYUAdDzrIl5g7+0rLenN2LlkSq/+K/wuyFfIEHIQHcQ1lzsjCLj6AiJNekYkxj3pJfMREe3rEiEAVbUM+oncCReN8JeRvAObYgQZAyrAC6bvsXQpEepnlMkJLEVOpZyrB/R8UO0vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IQaC9o9XaDORRS4BwZe7WrHh6MbeomWF/mx9+VQGyMc=;
 b=mQi5tcJ+tHYLJbL2dMvkB3w371FyhiahkfL7W5FBjAexuSVk4KvjM87AWma9vkqRgK2JFcR7CS9cfieQ6TNAuTWjMKwnYx1AUVG4oZCB+50nd5VIzKd3Vrr6hx+ZUGH+4CNYJ7cEGuaWkdWrStkB2eEkCUoj5TZaAjE8fhGF6duBzWx1sjntaazUyshqH87CrV2l63jlkrm6F92CJLdW0sxhRRRgbllJQWcivLUQ4mbKtSFrPllJ9cAKhiAwEtDXuoz9owowJOx1yiPEm8ieUXzGT/BYcZKW7kmR2z7wFyTVCaRXOgqyXIjmrAzyVEKVLIEr0B35vaYZHCR7Je+mGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IQaC9o9XaDORRS4BwZe7WrHh6MbeomWF/mx9+VQGyMc=;
 b=VE+QupEbIZ9nLEdZyYWPRuti0gIp4E97OjdVAu/J8ubNo1+tzgxcaPxaCrFMhM/8INrPxXRbdg92D2hGN2LlmdODyieBmFBAQFKcDRFHiTs88hmI+JIt6TR/mbKxganrsDMNkAkuON+B8RDfV43NhZXMBMse+JLCIAsYhJnZsVg=
Received: from DS7PR10MB5327.namprd10.prod.outlook.com (2603:10b6:5:3b1::15)
 by MW5PR10MB5689.namprd10.prod.outlook.com (2603:10b6:303:19a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.25; Wed, 5 Feb
 2025 03:07:51 +0000
Received: from DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::43e7:5b82:9069:b402]) by DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::43e7:5b82:9069:b402%7]) with mapi id 15.20.8398.021; Wed, 5 Feb 2025
 03:07:51 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: xfs-stable@lists.linux.dev
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 10/24] xfs: distinguish extra split from real ENOSPC from xfs_attr_node_try_addname
Date: Tue,  4 Feb 2025 19:07:18 -0800
Message-Id: <20250205030732.29546-11-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20250205030732.29546-1-catherine.hoang@oracle.com>
References: <20250205030732.29546-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0107.namprd03.prod.outlook.com
 (2603:10b6:a03:333::22) To DS7PR10MB5327.namprd10.prod.outlook.com
 (2603:10b6:5:3b1::15)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5327:EE_|MW5PR10MB5689:EE_
X-MS-Office365-Filtering-Correlation-Id: f3748679-1dc7-4d10-d218-08dd45924703
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|10070799003|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DqS3/+fLqDlIYJ5/n7XF492dE/rfzqbVpB35DXeSW9nYWPgBAAuMbOvLw6j/?=
 =?us-ascii?Q?4t5sH71xSKfuZfXBdPPivUlg0bbTCGiBcCRRUbpBIMuDMxrVZLAckGE3UZpL?=
 =?us-ascii?Q?e0fiMdWL7hsBs78hrvQq2yYsAXvRFmajK/R9/M4VpQZY9tjNtOuQgRe4j8HX?=
 =?us-ascii?Q?GVUIaeYtHav2iBUWwHJpGlKJALwv5wZznEvnAqP0h2J5QAsPUhfBv+K7KcQn?=
 =?us-ascii?Q?NoHrHNi35bSUt5mx3bYsB30MRXnHMcpzfl+mOlNarMEaF2rCvVIHgNVUeOmy?=
 =?us-ascii?Q?ZNlpeJIUNnHxAdHKKcoA1wEMEdfh27ULKjYmWyrIj4wP1vLcXFsWfDk1tWWW?=
 =?us-ascii?Q?LsFvqmqUpbDBPbYE2NAUvLD8ds2uzqlU9wofJ2LYftxzJ1vjvwapfw1LP2iK?=
 =?us-ascii?Q?3VMU5eRtiM1Pqi5htuQTX/EeM2IUAu7/0004RnSZxPQ3iBunAQB2t6HmR9bi?=
 =?us-ascii?Q?CTumw2mqrx/MEuu6DM0QWARNIjINbgVr7GRE5WwufAqxyyh7yTicbDwkpVGW?=
 =?us-ascii?Q?vuTCTQEiM/q0AVFLqmQVN4Hbf4QBnxb8GX3GqcSyk0Oea5hjOle5oZILcLap?=
 =?us-ascii?Q?sD/e25IiclmaPiwNH65Sh4S/06UhaVd5skK0K0KgWJccXtdjNzghlr6ZNp8y?=
 =?us-ascii?Q?PHSxIoT42ayZ1qPk4AaIHW82EWz/qmu3oRtTBBh+6MeXOSnfQWqJW45l89M8?=
 =?us-ascii?Q?mkhbPSpwpRL1RjGF6P1Hw7eol707bSaJV5zHAvR78Bijkbm/bYmo89DXe8pq?=
 =?us-ascii?Q?gIpCNuhgsEN3N+5/6HBNAwjIhvin0zTDfKakD3XBsFwZ80+bIAchNKVrNQFN?=
 =?us-ascii?Q?6p3G17VJsHmEqCKnQtQw+J01l91tWOrITJFUfq2x1OW0MAVruBwoIu9AG8TZ?=
 =?us-ascii?Q?axKa4iHhBkXsMNgsh/PwvL2cKHgjO1BHqywvaev9gQyqFHkCd40H6PpVp92W?=
 =?us-ascii?Q?/JedUnPKamADQEwEfPfEgWwEZTEJM/vIpvbeBpy9adxGiNZS35F0u9wGKeT7?=
 =?us-ascii?Q?Y7E3SzibXciQI4bZtB04Mc8Iuh/f3WfAtkIxNcRhj6zby2eW/IIgbq6kqFEd?=
 =?us-ascii?Q?ENQvS/6QiZMa6YL2u2ISKOtvd5u9F0fFUgo0H2xmxK0cTjWk77FiCh82ExB3?=
 =?us-ascii?Q?HNhsPiXR36eUgqBycY5xHAJ4gjBsYG2NROAbHg0GpPbFsdGBoYeGhTD//LAc?=
 =?us-ascii?Q?PuKt2ixf6KYt5+B1Z/eL1wMG9U/xl01EsLDksOLPXko5fDkBe5dm3m3NAUjj?=
 =?us-ascii?Q?TOPaTdoa1xWGc9wM3wvtrHntWhRaVKmMxvqMli23fZfXuecFJ3xUnnLImWoA?=
 =?us-ascii?Q?5Ikb/V+CglNEvEJuCVHHdfc9rUxJRUyd/mzgyhUfeAh4gMZFF0dFDZ+iseEb?=
 =?us-ascii?Q?MaOQQtopp+mfaDBVLaHfUrVqktxr?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5327.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?o8Hvj5AcyhUqgb8uCB/eJIQXTD/Hb6NZ1MDoRRxUJn5H/WBzRpAQDJNKkq7Y?=
 =?us-ascii?Q?9M2e6OW1iTAtZjQxxUYGjJcCas4YHdXxORL5bbcxFiXWAgFZyxEaH6sQL4GL?=
 =?us-ascii?Q?XlFYp8/Wks7HPXEX1F+lDYs29XRGzSxx1wBkutD518zUsEqAZSk1lbmI1XKP?=
 =?us-ascii?Q?YzEwj//x+exP5Fs/akoR0iwRlZCtaGg6uyLE5TYAgcfZEKuer/1SJV8iygFz?=
 =?us-ascii?Q?jq5R9EqjAsSFzJ67SaP1/OFV9QgFlQVFlE4BroRinr00pmgGCH9LXgdwLxNN?=
 =?us-ascii?Q?PP5GThyxM9+dDdWUz94L1j9hurCzFru3B502yQTvcMpmh/5wbQ5cS22BbGgT?=
 =?us-ascii?Q?Dg5Gn2W0R6Kofms22LnM8q0ad/h4rAY3flIBVWV/UpxrjT+T08dwfIsFnx1r?=
 =?us-ascii?Q?2w0a6gwJI6iOC0xOpiozOx+eaFGG1Q7J7HMxpb7VTvNnji1tYGUQ3srGybiO?=
 =?us-ascii?Q?n6z4bg+KTQELIihSrBc8JHSUSc35Qlyn5ixCFEe3JWas7zVGvZvWaHXuvLp4?=
 =?us-ascii?Q?L7roJ+SQtUixUY7v8cmK/8NeBR+nT5eJsM1urspW1jMJFfM40opmOzqhsfbl?=
 =?us-ascii?Q?tJLL32d8Fw3kZ95E5LORIVdak8jtckVa4fMG4s/lW/9zZPvWm/tx+6Ev/3t6?=
 =?us-ascii?Q?VPZpGsaIy2xk+KdrPy8md0zpYLMZTOrgKRXZsbiUtsofJrJh39C7yZcmhXNJ?=
 =?us-ascii?Q?I41AtThTMzfQ++FSoyEVv4eVmk4kElkF4sKq6AkfI2o1TPziWW/c22sdhKGz?=
 =?us-ascii?Q?0M2nL51MySimbLQwycNU1K/C60lNYE6umsSHSA8iLtDFFksoEO3bmo8tLtXM?=
 =?us-ascii?Q?N9zYy5IbQ91b5cx79CKbLmLB66VMNHIrmpcO4oopzowEqafbMB0aDZDRUAQT?=
 =?us-ascii?Q?9W7uXdccQiQcrbto1J6pETCx71rHn9Pf+rlAIOZ7zabs244cneMlG+5uzGIf?=
 =?us-ascii?Q?AwUMvXwThX8pZarxtZz1cm3rPiA2snH97yW1WAhonX8oRZZ812zs5asDJnxz?=
 =?us-ascii?Q?huxX9gfdWh2C9t3wki+0GakNiIbv79HM9JQMtqKUERiU7+yhAAJOvYdPN5K6?=
 =?us-ascii?Q?/vA/+zpxnY/Ut9S3onc7gsznWEJTAQiga3w4FU16Poj2DQuBfRJRXzs5+7fI?=
 =?us-ascii?Q?tX2snFulCa7HRgl5f9AiyTLIpTi4BDWYSm78K9SWfaCt5LJB71vBGTzWRrHT?=
 =?us-ascii?Q?2dZDJ3dkyatC1f0XqAImIPCQfFjpBM9DwDZkxc+g1V3+AaN/IRd3E4MC16sH?=
 =?us-ascii?Q?3P1yGFWwHh06CJNNDAz/X8dmu2lf723Dr6ifpL+j3mKkcJTJ9vvu73+SkFtD?=
 =?us-ascii?Q?QAk1DPqGwqhbO7k1Z8imR5it1dW3mC07S+LXvDl/nDBcaONZpB992b9tkK3J?=
 =?us-ascii?Q?NnhnRyinEQVgtFZWWeGgXs3pTrU+TAyWMjHETJs45oUZ3oZhtGouPUAmUCEF?=
 =?us-ascii?Q?rfc+k4DWsEvtJ3+d2sEk3zjntN8Z0rWJnQvb5ER2KflsXyPLXdyLJ+zZgJxe?=
 =?us-ascii?Q?xQRkhnOyAt13kirjBnx56Ld8VUJ7kZsMSzvWoLGigm7u042YDWalaS+uSzq1?=
 =?us-ascii?Q?bQXU3BxUAGphe8mi8M7AuuNLZBSFHN9EPqLz2ImFS5bonI8RxGIdwi9Y8xrd?=
 =?us-ascii?Q?MOb3ywob75j7/MPuTRYZ9yqZhB6D5w04MlERkTz9TbnxfL1q4fOQf06PxDPe?=
 =?us-ascii?Q?QK6FEw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	esDYWyJiXM+8iJitny+h4U+2lUOCxhE8fTd4xcPJjyTgwjr+mHriM1FxiZnK8/wtteiC1LHDRhty2w0ZMT/DvMSbdsGEnRVCeXX2Noo7uLk4SjCFUod96xJYr9pOSOCSDNtOIlVOrI3FLe/2rB8N7KvUuHzckdO9O+QZ2N5ExgdDERe/XpYPQKhu5fH0rxRKaEa5wA29JahiGkJsDtnTdz5TI0L4JikSmbj+u3KNU+sYVsRfrrcgGeCee0QPucloBexeFilOnmEaQyY+/Q06e+wgZNvnTvDP1cyaLSqV1+y2n4QJpcDYf88o+MfvykXCySnm+MgKkjLomR3ZZjy1aWm4s0S2Fv6NbTxwVHq/SaGXVB00EwmWmX1hJbbivad2PEFHzD0YIhycpwyM47zZf0V6rwlUEnbVGAbtga0hYzdyyPKhak1HpiGf+XCgxK+0JlRyiWyUHoFt/j0U31NqO9Mn8PQHV9Vb8TJFyS++lrOi6stvaSunqrsRYK/bwBZ/ofQLH+SPg+RhJtluXMGrIvX9bLJWh2kU/nmNxTYYenlGw+UTPsWHQcQSS1LoWGqDHY7sk1FKFORLIZ/usgvWP33CVcNobCcBJ0Li3fY4yac=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3748679-1dc7-4d10-d218-08dd45924703
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5327.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2025 03:07:51.7036
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RJIicT/FBcV+lFh/iPs1dqffrzmHlc+eZzp41FLM+QsRDBBZkp4uHpeuNoGYFY3ZQNdmv5Rkck0lRsSRLdzA7RoULOODFXrqmm3zLzFYs7I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5689
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-05_01,2025-02-04_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502050020
X-Proofpoint-GUID: WQBfkM0zsodCm_CHExcgF7zV681pXVvN
X-Proofpoint-ORIG-GUID: WQBfkM0zsodCm_CHExcgF7zV681pXVvN

From: Christoph Hellwig <hch@lst.de>

commit b3f4e84e2f438a119b7ca8684a25452b3e57c0f0 upstream.

Just like xfs_attr3_leaf_split, xfs_attr_node_try_addname can return
-ENOSPC both for an actual failure to allocate a disk block, but also
to signal the caller to convert the format of the attr fork.  Use magic
1 to ask for the conversion here as well.

Note that unlike the similar issue in xfs_attr3_leaf_split, this one was
only found by code review.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 1834ba1369c4..50172bb8026f 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -543,7 +543,7 @@ xfs_attr_node_addname(
 		return error;
 
 	error = xfs_attr_node_try_addname(attr);
-	if (error == -ENOSPC) {
+	if (error == 1) {
 		error = xfs_attr3_leaf_to_node(args);
 		if (error)
 			return error;
@@ -1380,9 +1380,12 @@ xfs_attr_node_addname_find_attr(
 /*
  * Add a name to a Btree-format attribute list.
  *
- * This will involve walking down the Btree, and may involve splitting
- * leaf nodes and even splitting intermediate nodes up to and including
- * the root node (a special case of an intermediate node).
+ * This will involve walking down the Btree, and may involve splitting leaf
+ * nodes and even splitting intermediate nodes up to and including the root
+ * node (a special case of an intermediate node).
+ *
+ * If the tree was still in single leaf format and needs to converted to
+ * real node format return 1 and let the caller handle that.
  */
 static int
 xfs_attr_node_try_addname(
@@ -1404,7 +1407,7 @@ xfs_attr_node_try_addname(
 			 * out-of-line values so it looked like it *might*
 			 * have been a b-tree. Let the caller deal with this.
 			 */
-			error = -ENOSPC;
+			error = 1;
 			goto out;
 		}
 
-- 
2.39.3

