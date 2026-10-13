Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D3148820B;
	Tue, 13 Oct 2026 09:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791884420; cv=fail; b=QXKrP3c8hRqUWIwRwdsieO9mvwVT8+Id1mzVF62iYlqvGppjnZ2IvTau8Pd8kYiNKB9uwtrA+sLxqDBrLTLCT/9Gy01h8xT+Lmj7FRClLEneHu1gsMnoUzpDMkJd6ri9qeSWEh4hhONuS/gQU2PlQ/UbvlrDGN+HAoHnMbKS9NI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791884420; c=relaxed/simple;
	bh=z8aHxSDwEttOXWdAdjD3gOnEhrAj36zTNfGkn60B3qs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QIgonIMdSME/gOSY8isTFvSYN2HW/51ytL9yWkgJyD9AQd/B5ep3bAvMLg8eABSWNEHwW8TYndvKDfE0yks7DUt6OBR05ZynAH+sCqhe95UaEEsH2IGSn9q24GLgMUT1PgZlM+GvHR7qAcE1KiNscermfbb9meKsXACW8Tq4W7Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WPEWTj+d; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=mwL7vyGl; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WPEWTj+d";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="mwL7vyGl"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2C4Nc1440146;
	Tue, 13 Oct 2026 09:40:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=A8jiv1xOvTlKjZs3CWsewBp8jIWBfcptJshjU8eO40I=; b=
	WPEWTj+dkiyVcvnPNLHpZUjG2qQAIVHp51Rqah5Iw6F/jfNlMyMf0nlN/7QC2RYE
	ifoF+xev3d0KUWyNdJZMn5mZrQXALEHgJW4trYHHEx7/SkhdkGMByhJIt3NfsI63
	BIO5K38qBDPFmW1HWnvnCrIvBBaNuJUV2aTLJYzGBpBR9z1sG2qce2VbPyX9jCu5
	9Pp33oNBh9KHMw3WhHJtZbyBg5wJNoNHtR8IPSxCmJCHSC3kSFu0sNzGVmzhNNav
	xvFls8x0BHqSv7+dBwosjnazML1UkvrjWYRMFm2IdWmiB5SiZTBpFxmE3W0F5lEo
	HYhLDAwoPCZiskkxxKmhlw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7df7uppa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 09:40:12 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D9afmI016065;
	Tue, 13 Oct 2026 09:40:11 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012064.outbound.protection.outlook.com [40.107.209.64])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4h7btp1749-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 09:40:11 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mcBGM+KxC99ki1Mwkruz+6+Tal5o4LNE7i322vSxu8wj7hghDcBpIejI/Ul6WgLvq/jTRVvsvF9KMJimTpHVoyE/8aMsAF0GaUKi31VAlluINBp6B27tOSdUcAg3wcaviByPv7TzEYCr0A3ispQNbMOtE6ap80WhZfDXDlCYX+aDUiE25KFjFHRW/ZDT+u4IeHLkz0wqQxafs7n7JNgH+Baat+Nlfi3Ds/WVdt2HR+QO+fk/zntMc/r4Osx3q7ThnS92+ClP1P72wP6LeZ8/efLzZEh+853NOEFT429PKkjPqZFRZnza0DIWyVjQJgK7YfkXicWXtWQUdDVYCHcwlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A8jiv1xOvTlKjZs3CWsewBp8jIWBfcptJshjU8eO40I=;
 b=HR1WRI0tWsfRBKsUXN1NC7ZqEtIQGIp6TZdeYr0WwoWtOFQmgdBQSGy9j2DRsikWm0tRH4AcYwtgXaW8hI2pDTd/AkZruJmS5xhVCHW9AC6Gy5UxjwIt5Pf/wERcY0Zz/1/R7CIZbmWrijrasTPRNZTx9Esbc/7FioO/h/5hBskjIfY9ZsFcebr7L78yMHd45JKMFgjvbZZw8gfBNnEDKqTL8xgCWCb0daMM31znBYwglairY/O/qgEGbTsOE9ZALG0hJ1+mrGLyxLzCDqXv9e6tPTZy7/H6T9ECLGMBQy6x+gC7ZSTjzDzk0LMK2Q/MbGTVVG3KZCmlF7RRLgOcPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A8jiv1xOvTlKjZs3CWsewBp8jIWBfcptJshjU8eO40I=;
 b=mwL7vyGlg1NzhvhRLRZzzryupRg4tgaR4WHEZ+GR4de5Gdl3IGpOM6/KUHl7I9N1cymEk0wTKJTczZvn+OGtF+hR8iJLwBoJh0KdwuCVt9OR5v/8KYqYhNN2Jb8AuaFJkfHezIbmx4OCfN0Ey4ThGh2fbZKixhTV2MIjBDKv4x0=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 MN2PR10MB4207.namprd10.prod.outlook.com (2603:10b6:208:198::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Tue, 13 Oct
 2026 09:40:08 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 09:40:08 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>,
        Mark Tinguely <mark.tinguely@oracle.com>
Subject: [PATCH RESEND 5.10 v2 03/19] xfs: hoist recovered rmap intent checks out of xfs_rui_item_recover
Date: Tue, 13 Oct 2026 15:09:32 +0530
Message-ID: <d2ff467512de99344122cdac20d4f2732e67daf6.1791883301.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791883301.git.siddh.raman.pant@oracle.com>
References: <cover.1791883301.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PN2PR01CA0186.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:e8::13) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|MN2PR10MB4207:EE_
X-MS-Office365-Filtering-Correlation-Id: 52cb58df-21c2-49d1-14cc-08df290df7ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|23010399003|376014|366016|10067099003|261009223027099003|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	HEkB57w94sckz0R5dSZY81NT9SMgrf/NsVsOhbPzu74vh6MPulM7OkvAougGabRCCHTiwtabRjjDh0zOVRjkZW47l+b3L/kANmrmu98LWMYvZWvkijVSI8GiDJLtIPqhBdD74jbOyZx7jBDm/kGCJlvsiU0smp8VHjMuGxHUDdTylssowEqJJNcbz7VDK2YdVuZH6MknqR8j/OgUi+oTgCVUUP7+pMU5ZPMASDRpryiDbyEHUcjxy8kd+9lJE48QGdU+lTExoogGwFTdzRuGwh1WVAVfqV6mSPbmRB8DxN7QlI5iSP2lsnxaC/Mk6hJLAYdT9gmN0VrnMP4ZDfMqPzSXNp8WJWULCu/7mfwFO9wk/vli9V6YVF+gXHw5ssfRStezRaaQbhTvT/qIxDLDfpnpe7qpbYniMMUHWo8c1HR+CBi8yJKkq8KqTwrm+WiM7lu2iYQjOuJIRT8qBaKAr+XH3evVSinFkNIO09RzKvASMnt5Z8o8HPXnW00iDovH8mbQNDY9PDVUYaWc1fVmvgYe9rI1pmEvJWhRQR8d2wr2PK+0+VKDMx69PG1P1T3x/NEuh+Izb6Zq7QsX4gfcQ+V/sybsIwq3La8U8Q37TXFg/ODCAdi94745tTnco3zk7FfrbX+6EXTNlVV3TbY4woNaPHglcYc7mG5UFZYnLzw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(23010399003)(376014)(366016)(10067099003)(261009223027099003)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ijLNDifJtPfbZbpgDL7eamlRpoaNccKfYUNajIn32NPAkOGkt/xetKSgFD2c?=
 =?us-ascii?Q?d/s9xzd/iO/1fbIcF9/X2zi18V0l5MgU1B8tmpGWOogTawjwHUduMpWVPJM9?=
 =?us-ascii?Q?9+t86EgO1MfWDRC4+4SR73bzdNtXFZBZrKzGvhvGyx5BoAR5aOWI/sDZ74QP?=
 =?us-ascii?Q?IM+Gp8iC0FShoLU8YFQpYdINUjSAQuwqnwQgYo5pbibvkNMeEQ0djcrUcuoM?=
 =?us-ascii?Q?P5LhV+kEbifatpEbqy6zA9YBCvlS2NcYCCgC68G4iFjL5yx5nXsFGfSIZicE?=
 =?us-ascii?Q?4nO944X+/8WNR3GYjlQtXnS22uImO3IA6aN1Ulaa0sPWZkol/jFoXIiiYKpV?=
 =?us-ascii?Q?LX7rvAze52gJwl0ALa9q1hyIaQyddmJykT6bKMHGuNeIDFs9mNYG7ENGkXkI?=
 =?us-ascii?Q?nr4WXf4y+8aJqWAULb8fE/XrL5SVhPyPFTm1EUas02qTFBsUI2dQSbSqooht?=
 =?us-ascii?Q?Ws2cIiZxfPE5MnhrNxSsYyXr1o9MW8weFMB0t7lTaQM7VXNuMU5iLhqcpkEC?=
 =?us-ascii?Q?MIRpfyvXOs0AWwl1vRubpm/0I5ix6lZcy0BIxDVLW5afHwLhaGZgRUk8H0sg?=
 =?us-ascii?Q?jZP9l7XyL2GLqGo0Mz3lc1knuaz2VhihN3/Gw/pxviTd262Pl5hLlihKNcZ7?=
 =?us-ascii?Q?x8QYlGq4ldu90pWt435hYIaBeZFTUdmofD/qYo9wyUPf/FXsf5mNMHjxGo/h?=
 =?us-ascii?Q?xHhycnyU4VWgK9yLQYnOI+fazw4kzru0TaGlR0fDES8L5IqLGOf0AT9+oyIZ?=
 =?us-ascii?Q?7bQHI01sRJndoZ/lxIelWqmtQtBivpGgQUzWbnRDsWB+pvhhPfThLgxZwlEg?=
 =?us-ascii?Q?j3k22Bq+3iikprmEBAcge9OIWyr+Zbcz31nWFRzZozQSzdpBmwPBngXPWiGl?=
 =?us-ascii?Q?aVWapx3V6kUF6To0swmFc7CzbUeBQNBzRCVRZjEVIa7bmHySOlRfhR78ZD7g?=
 =?us-ascii?Q?yunsshHWr+qLLuhuQgTwRExNaj5wUWdt4t9XSgTPgxYon13Exh0w4oPDkS9z?=
 =?us-ascii?Q?R64Xl6IXk6wxFGuFyOgaAMxNB/j2zfg/NY533W8jQRJ98/8UjHTRKDVIhM5W?=
 =?us-ascii?Q?lt9WmjVvAqYXUWpaurr3Ofm8OSp788ubmciGSwYtFLRDvkgDbZo/TI+g3B8/?=
 =?us-ascii?Q?+lq9y68mj8miGuXu4KXzcRnGESlPrwJNg3sT8pEdp4FO293Tr61OTPgwUcCb?=
 =?us-ascii?Q?uu/1f9CUcxfgFqzFJAzl5eyrfhKqHLagh9e5tD6y4qc5kL+9xxchC5pKvQTD?=
 =?us-ascii?Q?3G/wWakcxofa81pPPQ5ovVtfugLxqvHeKL7bD1/hjsiStMXkDeX75CH0UT4L?=
 =?us-ascii?Q?K6LOfkF3JlsAi2HQ57A7DKLfQdq6EiB8op+pJN6PA2JdDpYaFRltwp2T83Xq?=
 =?us-ascii?Q?B9zzNxmMkWmTqMjL5qwLoGusDqanokG1sZLwqIKwLupkXkTcB6cNdNEJOkld?=
 =?us-ascii?Q?S5cKpzVWNxuMMwtbs+QpvfxOic6J0/mL9WgW33k+u4sIc/Z3Nlpj1NHIVRXw?=
 =?us-ascii?Q?GCA5OAOiYFNnKDpqTx9mbPPf37/+rC2bj/o+976Uf6p32TfQMMvYO/F5X6XE?=
 =?us-ascii?Q?c/0H4iXO9WBdUQQjWNjC7rgZIuWPEOM53/WAy8LY7fpmH5Zora3IXVnrMIDk?=
 =?us-ascii?Q?cDTlWRBaSrWJOGQV2c3NFpKT5B58QJ9XJk2T4+Q8tEPmVg01tlhes6oWO5RC?=
 =?us-ascii?Q?glVrchTal3ZBnjsUk89trK+c3SmcjhGDYPjbvCrhdcgygIuIeDALhorZXduz?=
 =?us-ascii?Q?rHRHq0vFhAkdYRhHznWI0ibEp3OYWiw6jFKOl82x32FAQevhWRkQQVPt+LZ9?=
X-MS-Exchange-AntiSpam-MessageData-1: UNLq7RHdx+/ceOMsRYEDEnKVfL8MC+AltgQ=
X-Exchange-RoutingPolicyChecked:
	xCQTh+CeVg/RRt9wkDUsh43w79KlPMwFGbLM+xe8CVHvEhNL3g/EM2JCeHwSRB0tHNGsfiIYCwzr8gGDAucm2RiB3kqRlKYcM13nKj+O19+M1Nt6gq+/uTTfp0aYulePLgsf7JAfVF7Xi7jGdrtUjyTeEMWISj1UtfD2mZDcil0jejmMQSZJtP+V7PoQw7vzWfXnpY/SyhTwb6eXP9dblo8SC1jjVwOi1g7qEvcVB59rKAGGHJmc06pd9agqM0rSBKjW15LjixeMRbBiy28x/2NlASmIgE7nNrjoAaxzfKaTwvoTHCSaizSYRgYXNvxmGPfpBOT0UcPzYXspqJmssA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fvEXUOrIQ8fa5gCwRqn5OPphaDIGOKTjvl8nZxdJkKX2TXlaT2wDwFW4uL/6ILxkPd7NIZNv7B1i/2HoLunoruuR4OwlGEBHiV1+FlJV+z7qKjGu4C8+WemsoMLHrtJPkq/Z1vP+bnDuL+l8/wtfNg39ciTzgzPmCGtvJdjEb9JdfYwpUinxgsrIVWngI+vT3twPePQ7JBNND1/+DSLLL5nb1G/dKC81ANU370xMxKEkkMh0pyVS/h9jGxbuCxm2YLyIDIOWUGA5zV+JSvV7Mm7UI4ufCM5ud9D+5iohTTeXj6uulelhZWBmwnSH7kwx4TDzNHHbAfMJ1kIahnFNyS/yenxShV8StP6AEC3yotOnjwUVJPqsb7JilmHmmAW3LmCNIMBHoft4C3Qfx6Yn/e915Axam5PY6rZswGrDKfbJl1sp2G7SRCrZ7xqhXNKW774O4e8PEVVLwA2CcRVADNK12Uo/tLy2rwAaati08FGfDM/0e02L1MKLvOvxJt6/MZlrQoPMLYuvYoWQ22P07mJTPpayy9c1wEzL6svARSy04UlZimr09cJziHs4r+JfjCLM+VX8iMPP0pK0GAze+r8orBzW/UG87FNVE3HcQSo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52cb58df-21c2-49d1-14cc-08df290df7ed
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 09:40:08.4936
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WoeNGKhiIXmoGEazCBQg3FjpfADgrjUMmWoYZgzJCa/rxNakNXZBwVcuyE+I0+TRW5bBIvldq2ns/5tk8hADIduEUF4NxZMidoRX1ZoFa2g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4207
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 lowpriorityscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 phishscore=0 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130038
X-Authority-Analysis: v=2.4 cv=N+a8hG9B c=1 sm=1 tr=0 ts=6acdfc7c b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8
 a=XUHDQfcMxKEf4e_NL1gA:9 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:13537
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX1lmfz/aW5dDP
 oO0NsfTBYiXQ6bpDP3tH5GneP5MRBIvdz1x2U6VYPNDdZ4jUViHvffSYcN9NU9GgDKaC7KP6yVY
 s9eRN6qfQIOKcjM4awNDjW/rr/S3UMDf66ZH0Rl1IVtOlzSiDVq9xAugvSmbYKehLStgXSjYDuH
 TiJ6xwogoz91mglQFmWbcsBdgdL2av0XY4FJtih8CYB0tMrPm2i7KEOi6g0O7B5t+HFTGGqzSRe
 KGShoakHd3l/FIUN2L5QBr/IagUZeeRQzwsQ8O8UUf8nI3yE4PbFdG9pEjB2VS7RwOcB1MFOto3
 xRuNFIhioDmfTcf7MCDbB4KAHktCe9g8+v2bO+KqkmjLC2xsKehLYF5aJX2yB5bSDAuP7kf+mdL
 JtLqNfNJ+p5BYJF1heeASFKHidq/w5c7k2gUP3WM/jVY7cdJVKgM7GZZk5DebBjpzQ0I6FuYU/D
 6Y1t+cU/cI7ihF0mdgAiauo/4xNin4k00tAU4sRs=
X-Proofpoint-ORIG-GUID: OzySQ73igkwJQed52EHfu8uMpk1Vr0e0
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX6on5Q+BBkzyQ
 EpALV+wXDOPbh57UVN9ejYVDVfrlWk1ww/CplAA+wutcOMTFnh1fQMgnKhNGfCV2I2Rwz7QRs4k
 at7WSMQt5y84OfEt6rkiCZC6uBXLT1dZCZ+BNwyVkbupFWdk1Lri
X-Proofpoint-GUID: OzySQ73igkwJQed52EHfu8uMpk1Vr0e0

From: "Darrick J. Wong" <darrick.wong@oracle.com>

When we recover a rmap intent from the log, we need to validate its
contents before we try to replay them.  Hoist the checking code into a
separate function in preparation to refactor this code to use validation
helpers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
(cherry picked from commit dda7ba65bf03b6f3a7502b9f85c2524a5ae5aa2e)
Stable-dep-of: 7b5f775be14a ("xfs: fix unmount hang with unflushable inodes stuck in the AIL")
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_rmap_item.c | 67 ++++++++++++++++++++++++++----------------
 1 file changed, 42 insertions(+), 25 deletions(-)

diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 20905953fe76..31cfd734962f 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -460,6 +460,42 @@ const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
 	.cancel_item	= xfs_rmap_update_cancel_item,
 };
 
+/* Is this recovered RUI ok? */
+static inline bool
+xfs_rui_validate_map(
+	struct xfs_mount		*mp,
+	struct xfs_map_extent		*rmap)
+{
+	xfs_fsblock_t			startblock_fsb;
+	bool				op_ok;
+
+	startblock_fsb = XFS_BB_TO_FSB(mp,
+			   XFS_FSB_TO_DADDR(mp, rmap->me_startblock));
+	switch (rmap->me_flags & XFS_RMAP_EXTENT_TYPE_MASK) {
+	case XFS_RMAP_EXTENT_MAP:
+	case XFS_RMAP_EXTENT_MAP_SHARED:
+	case XFS_RMAP_EXTENT_UNMAP:
+	case XFS_RMAP_EXTENT_UNMAP_SHARED:
+	case XFS_RMAP_EXTENT_CONVERT:
+	case XFS_RMAP_EXTENT_CONVERT_SHARED:
+	case XFS_RMAP_EXTENT_ALLOC:
+	case XFS_RMAP_EXTENT_FREE:
+		op_ok = true;
+		break;
+	default:
+		op_ok = false;
+		break;
+	}
+	if (!op_ok || startblock_fsb == 0 ||
+	    rmap->me_len == 0 ||
+	    startblock_fsb >= mp->m_sb.sb_dblocks ||
+	    rmap->me_len >= mp->m_sb.sb_agblocks ||
+	    (rmap->me_flags & ~XFS_RMAP_EXTENT_FLAGS))
+		return false;
+
+	return true;
+}
+
 /*
  * Process an rmap update intent item that was recovered from the log.
  * We need to update the rmapbt.
@@ -475,10 +511,8 @@ xfs_rui_item_recover(
 	struct xfs_trans		*tp;
 	struct xfs_btree_cur		*rcur = NULL;
 	struct xfs_mount		*mp = lip->li_mountp;
-	xfs_fsblock_t			startblock_fsb;
 	enum xfs_rmap_intent_type	type;
 	xfs_exntst_t			state;
-	bool				op_ok;
 	int				i;
 	int				whichfork;
 	int				error = 0;
@@ -489,30 +523,13 @@ xfs_rui_item_recover(
 	 * just toss the RUI.
 	 */
 	for (i = 0; i < ruip->rui_format.rui_nextents; i++) {
-		rmap = &ruip->rui_format.rui_extents[i];
-		startblock_fsb = XFS_BB_TO_FSB(mp,
-				   XFS_FSB_TO_DADDR(mp, rmap->me_startblock));
-		switch (rmap->me_flags & XFS_RMAP_EXTENT_TYPE_MASK) {
-		case XFS_RMAP_EXTENT_MAP:
-		case XFS_RMAP_EXTENT_MAP_SHARED:
-		case XFS_RMAP_EXTENT_UNMAP:
-		case XFS_RMAP_EXTENT_UNMAP_SHARED:
-		case XFS_RMAP_EXTENT_CONVERT:
-		case XFS_RMAP_EXTENT_CONVERT_SHARED:
-		case XFS_RMAP_EXTENT_ALLOC:
-		case XFS_RMAP_EXTENT_FREE:
-			op_ok = true;
-			break;
-		default:
-			op_ok = false;
-			break;
-		}
-		if (!op_ok || startblock_fsb == 0 ||
-		    rmap->me_len == 0 ||
-		    startblock_fsb >= mp->m_sb.sb_dblocks ||
-		    rmap->me_len >= mp->m_sb.sb_agblocks ||
-		    (rmap->me_flags & ~XFS_RMAP_EXTENT_FLAGS))
+		if (!xfs_rui_validate_map(mp,
+					&ruip->rui_format.rui_extents[i])) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					&ruip->rui_format,
+					sizeof(ruip->rui_format));
 			return -EFSCORRUPTED;
+		}
 	}
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
-- 
2.53.0

