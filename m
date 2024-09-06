Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85FB5158D7B
	for <linux-xfs@vger.kernel.org>; Fri,  6 Sep 2024 21:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725657149; cv=fail; b=i0oV5/uN0xdncSwKGdgtOxcWpxj+g8jlxkHxwcj4m/bVhxk3y8pgIGU684N/9qsWFTlvUNEv3e7tU6Lm3j67fwZyOxoumfK6HVipNx/70JaOI3AFipcQFoy1UYZuX5Nx5xhCEU6IcwynvHa1njNvpJxAfuo5Vae0KmHzfUINOnE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725657149; c=relaxed/simple;
	bh=AE6wEh+v9e73Y8djekuwFsrp3sa49969EM0ozv8FRXU=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qGFUMeuDFdt+u4G9aLsiHkNj0fxRHiWB11ItxQHaDic0uPRohZZ7b4VihKcJQWnY6VBNB3W16kZwS5quJ2TefcdxkRRKh9tNuolP+SR88o2XPnaMYeEnxB/ZMy7vdnlplnpOP2BgNKfyBPV4RHoIt7UZ6onyiYQdb5DKdBaVqA8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AObzJj9T; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=oKYR2Vf3; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AObzJj9T";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="oKYR2Vf3"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 486KXU2g024511
	for <linux-xfs@vger.kernel.org>; Fri, 6 Sep 2024 21:12:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=YEUG3n119LVEMUwUVMBQ5v3OPk4cqTIGB3GuhKOQq5c=; b=
	AObzJj9THYcJyJUwgKW4/kyB+lV/xF3/D79f/byEAuTQwrXIJ6azy589b8/Alkvx
	1Hao3MtkqPoHJ3LrPDWitxEhxNH49XZhXS596L4lXj6Apw7ddw3wP2koQcgj0muJ
	xHyK9Y/TzLmy86ZL+YbIAmrOjzahmN8pli+v1r969Wtrxgy9giK+AhLUt5yKcv8+
	6/RcChRC/JQgUcaUOMuVAvYwocpRUtqFrevHBfjwLZK4zv+10w6LDC9sMd1dFszf
	ivV3o0nChZQ7y5X/ZZAcdukAvTBQoNWeL91ldFlG2L7f3vy0Zlw9pLkmUJLmIw6/
	8gAW8bPpfC5FigYTGIrcng==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41fhwkak3s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 06 Sep 2024 21:12:26 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 486K2FuB036933
	for <linux-xfs@vger.kernel.org>; Fri, 6 Sep 2024 21:12:25 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41fhygea64-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 06 Sep 2024 21:12:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v3fEUC2xHmXoAzolpWzYeD2kh3qoUy1r1sOqVmxjXHPGs/sy6IlpgcOmqtnGk9Z3m7ailQ9K2vSpXSOr05P0AIOxExsT7aBEBrYK/8FubF5LIIBbkDSSUkFMXIeI6gfBeYn1fhhfizFrhxcfcoSezk2ccJBENLB5HqI2RkJlV8umTkQ2uINkZ0ykwmEeZOde8ZQi5CDE0xaaH2Wz7vSB4Pj2AD/jsx1xIsfwtTQvQbsR5CUTrHSHsI4PGAWmrx5pfmsHT3aZ6h1a4WfInSJU0RWmLO2Q+OCXaUbKOHlcKnMDWqL4DQ1Q1jX3ZrX4S1XuZZ/1UBK6/qmP9KK6LeCPzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YEUG3n119LVEMUwUVMBQ5v3OPk4cqTIGB3GuhKOQq5c=;
 b=k2Xz9MEfZKz3VBL1fitrbYb/wkicMoz+YQeBu2c2HQNWpDBMgRURVL6I8jnZMR73EuTdNvr9DvpIb/hA6SFCKuwILSRKNoCBqNjS0ngvEMTAb49doexuPqS6RTzS4m38ABYAbVs572tmJceI+vx4hTCoM+I273HwLYEw4bva8VixAcB4V6qFt07VxAiCQgz6YggEWA7bVRM8XciDeP24aeFKx7z1U/c2ywpHi9yNKz5J+GHULJsIpiJVgAgAyxIxrpY0r8cdWVPrLv4nNRK+7ggshdSe/IBw5RP/Z+WUX3yr6OkAWDVjVb7Np6/fFmQER5SeiRThg1KPMbnzQAkVKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YEUG3n119LVEMUwUVMBQ5v3OPk4cqTIGB3GuhKOQq5c=;
 b=oKYR2Vf3eRrAw+aeFnQ2CHk1smGhLUn2oefykU9oC/NfMK5Zq58I0cPW0SClAesuzSqg3fNfM/wKGPPYSerwmFV7uxeOJaREh9qfth1y/G0XUeIab47Q8Lli7OSUPZqyy+1PXOOtO7fM67MI7EgvpPZPk7fFvz3th50gFNXyae4=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CO6PR10MB5587.namprd10.prod.outlook.com (2603:10b6:303:146::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.9; Fri, 6 Sep
 2024 21:12:23 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.7939.010; Fri, 6 Sep 2024
 21:12:23 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 21/22] xfs: restrict when we try to align cow fork delalloc to cowextsz hints
Date: Fri,  6 Sep 2024 14:11:35 -0700
Message-Id: <20240906211136.70391-22-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20240906211136.70391-1-catherine.hoang@oracle.com>
References: <20240906211136.70391-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0007.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::12) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CO6PR10MB5587:EE_
X-MS-Office365-Filtering-Correlation-Id: e93bd36c-e173-4b12-ff3f-08dcceb8997e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ao+a95RjfEgda4uNeghYNDOSebe/JkXQRru5QVgF+jpBGG0ZZNR9PNKLbP4z?=
 =?us-ascii?Q?awAu0ONLJW6fr6gVLwggTa6GImlonClk+1ZLLHUWPDb5vtSLJUwZBNCKh8P3?=
 =?us-ascii?Q?y5Au2GWlK6U8O77tkb5dPgj9BMgloX4Nh9Yz+IiH2s15uLoCefS4aRXDUHDX?=
 =?us-ascii?Q?xC5rUpGLBnF2XsirZXaPLIWCSGqaLihZ6hvf50VgQJ/iH616T3xjBt7MNiqY?=
 =?us-ascii?Q?UWeTnmdAnBxKLuVGpDPwA/mI5CEeAuZMv4qlGc9F24IG/FKpbFiBt/wOzPSy?=
 =?us-ascii?Q?piLZf6oXt4MhakeuuxoJ/dRv66Hj0uGsv8m7W0yy4mqDc+3AKFK2tNG1eOEl?=
 =?us-ascii?Q?2EyRt+WmSFHPpYPVKg9+GlE8u60DN5bGOBrPCNxawvFo0TcJxKAat1ZITkFZ?=
 =?us-ascii?Q?s2qCjwfa5q5tfXZoOr6Ibfqsi6EwIduBlnyYse9xfiE3SjveNy3k7quxfwoC?=
 =?us-ascii?Q?D4S3yKA/q5zkf/U+o8yjyHz8g8pFD9M3xqpJh6LQorQBXfRDDXKVwVAYlkB+?=
 =?us-ascii?Q?oQYCRgKizAyWWW6v3jgwOHwaQiye8RgmIlWscr/spQn9KX9Tl8inssbyXvcW?=
 =?us-ascii?Q?/z1I5S2G+1fr2DpQY+7ddeba1QUAPxqqetiHpL8GKqpkCqM2vZz0669ARgv4?=
 =?us-ascii?Q?9dHbIKBLj5kQepUj1xqyY1oqW7aH0jzYit770tnhDe7mOnmPR7jvrEolkpWp?=
 =?us-ascii?Q?qDGVYspMzKX6dDEhWZVKgsf5xjbS/wd1rzFOJdItDV4z6l9kg43p5QjK3zBO?=
 =?us-ascii?Q?H1zWPGGzW3j4nGO/dIqdqbU5JHLQAhHXVlGBH8cdx2oiWyjLRY2zFfxjQ3mm?=
 =?us-ascii?Q?JzqvdGMOAlhM4hIfDF+KwWGVahJLAf5RvzkDNxJjyG2cB5P7l5cOw4dwrsx0?=
 =?us-ascii?Q?+W/0u/Zp4bNi2wOlRQBLBMgLH7ehMl73NfVi1WAQn0qUVwbb1rGv3v5xbGO5?=
 =?us-ascii?Q?CI7F8kr2h0RGS5ETmLYehzRiz/IGVMM9XUr8MrbtVFkc8Iru+cHLWuLG68J7?=
 =?us-ascii?Q?NEXBkrZWJRdsxByEzWmO0QqGWKElto1BSKIGMYDJpILjgT2hDV+OFeWksjn5?=
 =?us-ascii?Q?rcKWfjJlgZ2ZEHvzNltWOMg5uyvAA4VfEGs8Srm3XWn0X0q41jNHrHIweQL8?=
 =?us-ascii?Q?te67rezqzMm1Uq+WNXq8D8Rp7i9H94cCJwOR2WSx5318Fl8to7QQA2YR4z/W?=
 =?us-ascii?Q?BA0++AGKkDtUoSR2Pbm4ld6mSg2Pt8ZPA17xi60nVKBuhTQncrcd7QIdHoen?=
 =?us-ascii?Q?20SKBNipgH1pBc2xvGmUibvCLKFp/fq9rKIUz7Z+blKe8N33oWBLZbS8n41+?=
 =?us-ascii?Q?59irbgxK8f1FnFc9RA9a3/LPPgG7b49ZxMJsH3F1puW2Mg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Uc6A8X+fMhyvwMSi0RQE3zqg89gklKIpsJjP7SkL4GzOGTdxiGoSH1PuIfQa?=
 =?us-ascii?Q?0uaif81A+VrIwBVY4eE2m8MU75XuRiJYhOY236RyF+L7A8I5mnBeJsNmh8fW?=
 =?us-ascii?Q?j2awH4hWHKU279OBeQd1P4XIsOQ0QtGJWlV8gE6QhwAaFPR266hmg47gPo4V?=
 =?us-ascii?Q?AnJnqx40Igwrt84953XbO6JVlX046TTSACIyMA9AXkhWkucFdho5UFUotBWP?=
 =?us-ascii?Q?N+CX3UaF22qJsxK/yzUo6QmPVj7AP4HoCellqikgmD+isWwxvdmwkiZ7W6/j?=
 =?us-ascii?Q?pxJP4+yt3zgiWDe1j5amZKLwsmRc8q8hxoQLkpCcEyuXrWsd1+doVzma1crc?=
 =?us-ascii?Q?fWzcQDUHW2857gv9BCoPU1uPxzx46L0dZyGmT562Q+cS5bU3TXCLHsYMjxH0?=
 =?us-ascii?Q?Xu1pzopQSRyiralXvSQqyrZoD87KaoUvl22m2wDYWTtuEJ1bJgmFvGEsDe8b?=
 =?us-ascii?Q?0HHFJqANq16P510lFyZ7OudiE2TKnOCkwZi6v89Tbm0MCgFvEwXw0tzsWKB9?=
 =?us-ascii?Q?7AmYzBd3CvgwewoQ6a0V3h0ewaIboTsgkUCQ2yAakhHl5RZmwSAh9Z2nZnDk?=
 =?us-ascii?Q?nwblga4qI4813dzYS2QTh5cEX4oaiBHZOCKNMeRJMVoDU4+DxcSag0I2YZ2u?=
 =?us-ascii?Q?EgigYkRNwdZi+/qSv/meXXqv0AQCrEwP5vIBPj4fIAMcWisULOoMELe7L4y0?=
 =?us-ascii?Q?rphy8PMtfY1m6yiqCL/CCRcf8nZ1wQ6Mr5MlqHXHKw+8/WfVwrD4Pvv+V73n?=
 =?us-ascii?Q?UR40cX2Z6//Jd5pj403CwNcIy8LqcMEnz0eJs3EI0FXyS7wsVWAvMEyxEBLM?=
 =?us-ascii?Q?9QAl+YjuXezcZ2PFc6jV/T9FccokCEh99qwOgXayi6/JQcYpYPvEyhpFhbN8?=
 =?us-ascii?Q?zI4ay+pL/Mg0KfRQE8NliyX2HvBm6umYeDIRDgGcbLL93C6MOQmDzqOidgkA?=
 =?us-ascii?Q?HNkuiiGDcZtAKuBOxKNQOTb/e6pMXzQ1lOxfakzNwXeoKyVLTeTzsforVCFD?=
 =?us-ascii?Q?+J4R8BMdaQOH+Gw0gF93pLrxmCYR3P+zBcg6217FQNqSdPdzDOs7uufMoyAq?=
 =?us-ascii?Q?r+xY0CmLqufJldA/M5gk9ixBRbjzefTl3Sl325jeIGCsZUcPUbdgcvBhUNto?=
 =?us-ascii?Q?Z5GhavRO3fMCr7Gb2xqKe2eZ6WHxZsrXE38Tdfw2kxZrgnYZYfUHsPznOmLU?=
 =?us-ascii?Q?m/5ajaN/vhqza8BEeZyq2ZcRQ5EF4I14rrO5IXZgKH1WuB+lY8KnPpXBR/mx?=
 =?us-ascii?Q?N0U0y2kQXYcUjm9IxL/3bzh9mIF8svUMJnoEpaJyVOcT2xnuHWbra1N+/XkR?=
 =?us-ascii?Q?h0cIFN8bchdYidwDb9eNgu+L6cEKJkGIZBCvSuwS3yMDIN0dw+5CaYzc1zfy?=
 =?us-ascii?Q?Ej89W9IZqz52WAvRCvdvy5ORj99V0xSOxsrwDF8oXmDf93mVfLlelfCzTNoP?=
 =?us-ascii?Q?4xNY/3TDi3WtoZD19JxnXzSH9188ngDhsROnG2ToqM/Y91q0z1xsSxf1Ewq5?=
 =?us-ascii?Q?hroGYi5XQVVsIkM+uw6Kyp7G522Lx/9JYDVJliv9lgISJqXMBuwQCOmHiEXW?=
 =?us-ascii?Q?1J4Di0axGXzuquF7JDr9EuWG8eImCLDti9TfjQdnRULnhVhx3eukzyPVJHLh?=
 =?us-ascii?Q?rw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	brQwrgOyQ5chjg3b2/qzmz/AO7WKc8Ak6o0EiHJMBA95o6mXtRxgJsmbYoFmJoD9xnLdeR68t4evRhdKJ856stPcEbRS1ybyS8rJ7hhY/dHHoQgEhpU/R5I6ZrsOZhQBu/yHTLmlXdLUidVNTmAoe49XPl0t2hnxvuMUoRsnsiEPnDSGM5J6yZSVE/XR08bGZ+tsJOn69XFqhoSgUGO7A3cDy8a7m/Ocm/N019sJF35+JrYkqp9X1PyydNN58xAU4/oUaIzJ4KJzDoDTBAsCCLjnekCZhd1cS8pZe8fCvXAz0I7k4ojr1aNkYll12zRhYe/+guS0O2PCPawVYM4k4qqq7SmGq37fqIh1KpzIivs3W0qi/pq+1Bv2sSdc9PYrThyrN+cW29mmaRShYLINt3v7KhnNa0AfPO9tcX6LhE/twpsC/niSQtFJAFPN2CgWP5whvbGezKE/oj7PWhAcJaWOovcO3leGDYWbi5QgoEDDJN5xuHRD+T0gWNFHs67EKvSMZIIH3ckfCD+cH2JAyL8AbZBrkpqQrlmNP2jzOaRoV6ogfzjdqdQMZvzjmRROlaijL6khKWR7dG8ASAZO8N8kN2gCG2vanw9uvEsdoe8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e93bd36c-e173-4b12-ff3f-08dcceb8997e
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2024 21:12:23.0837
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AeFaTPVeEE5y6akwbAiAf+G2llslfRDn3SI41Ncp6DvgnkA1zlVCp8bzo2cGxMh0WnsO84CWROTyahObyEH6jqL4CBLOvl/+0kvzw5kH25M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5587
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_06,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2409060157
X-Proofpoint-GUID: TNNz1sbBi9qr3Rlx6F4afmfAHZkme51j
X-Proofpoint-ORIG-GUID: TNNz1sbBi9qr3Rlx6F4afmfAHZkme51j

From: "Darrick J. Wong" <djwong@kernel.org>

commit 288e1f693f04e66be99f27e7cbe4a45936a66745 upstream.

xfs/205 produces the following failure when always_cow is enabled:

  --- a/tests/xfs/205.out	2024-02-28 16:20:24.437887970 -0800
  +++ b/tests/xfs/205.out.bad	2024-06-03 21:13:40.584000000 -0700
  @@ -1,4 +1,5 @@
   QA output created by 205
   *** one file
  +   !!! disk full (expected)
   *** one file, a few bytes at a time
   *** done

This is the result of overly aggressive attempts to align cow fork
delalloc reservations to the CoW extent size hint.  Looking at the trace
data, we're trying to append a single fsblock to the "fred" file.
Trying to create a speculative post-eof reservation fails because
there's not enough space.

We then set @prealloc_blocks to zero and try again, but the cowextsz
alignment code triggers, which expands our request for a 1-fsblock
reservation into a 39-block reservation.  There's not enough space for
that, so the whole write fails with ENOSPC even though there's
sufficient space in the filesystem to allocate the single block that we
need to land the write.

There are two things wrong here -- first, we shouldn't be attempting
speculative preallocations beyond what was requested when we're low on
space.  Second, if we've already computed a posteof preallocation, we
shouldn't bother trying to align that to the cowextsize hint.

Fix both of these problems by adding a flag that only enables the
expansion of the delalloc reservation to the cowextsize if we're doing a
non-extending write, and only if we're not doing an ENOSPC retry.  This
requires us to move the ENOSPC retry logic to xfs_bmapi_reserve_delalloc.

I probably should have caught this six years ago when 6ca30729c206d was
being reviewed, but oh well.  Update the comments to reflect what the
code does now.

Fixes: 6ca30729c206d ("xfs: bmap code cleanup")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 31 +++++++++++++++++++++++++++----
 fs/xfs/xfs_iomap.c       | 34 ++++++++++++----------------------
 2 files changed, 39 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index f63e7365b320..164160529159 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3974,20 +3974,32 @@ xfs_bmapi_reserve_delalloc(
 	xfs_extlen_t		alen;
 	xfs_extlen_t		indlen;
 	int			error;
-	xfs_fileoff_t		aoff = off;
+	xfs_fileoff_t		aoff;
+	bool			use_cowextszhint =
+					whichfork == XFS_COW_FORK && !prealloc;
 
+retry:
 	/*
 	 * Cap the alloc length. Keep track of prealloc so we know whether to
 	 * tag the inode before we return.
 	 */
+	aoff = off;
 	alen = XFS_FILBLKS_MIN(len + prealloc, XFS_MAX_BMBT_EXTLEN);
 	if (!eof)
 		alen = XFS_FILBLKS_MIN(alen, got->br_startoff - aoff);
 	if (prealloc && alen >= len)
 		prealloc = alen - len;
 
-	/* Figure out the extent size, adjust alen */
-	if (whichfork == XFS_COW_FORK) {
+	/*
+	 * If we're targetting the COW fork but aren't creating a speculative
+	 * posteof preallocation, try to expand the reservation to align with
+	 * the COW extent size hint if there's sufficient free space.
+	 *
+	 * Unlike the data fork, the CoW cancellation functions will free all
+	 * the reservations at inactivation, so we don't require that every
+	 * delalloc reservation have a dirty pagecache.
+	 */
+	if (use_cowextszhint) {
 		struct xfs_bmbt_irec	prev;
 		xfs_extlen_t		extsz = xfs_get_cowextsz_hint(ip);
 
@@ -4006,7 +4018,7 @@ xfs_bmapi_reserve_delalloc(
 	 */
 	error = xfs_quota_reserve_blkres(ip, alen);
 	if (error)
-		return error;
+		goto out;
 
 	/*
 	 * Split changing sb for alen and indlen since they could be coming
@@ -4051,6 +4063,17 @@ xfs_bmapi_reserve_delalloc(
 out_unreserve_quota:
 	if (XFS_IS_QUOTA_ON(mp))
 		xfs_quota_unreserve_blkres(ip, alen);
+out:
+	if (error == -ENOSPC || error == -EDQUOT) {
+		trace_xfs_delalloc_enospc(ip, off, len);
+
+		if (prealloc || use_cowextszhint) {
+			/* retry without any preallocation */
+			use_cowextszhint = false;
+			prealloc = 0;
+			goto retry;
+		}
+	}
 	return error;
 }
 
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 1a150ecbd2b7..9ce2f48b4ebc 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1127,33 +1127,23 @@ xfs_buffered_write_iomap_begin(
 		}
 	}
 
-retry:
-	error = xfs_bmapi_reserve_delalloc(ip, allocfork, offset_fsb,
-			end_fsb - offset_fsb, prealloc_blocks,
-			allocfork == XFS_DATA_FORK ? &imap : &cmap,
-			allocfork == XFS_DATA_FORK ? &icur : &ccur,
-			allocfork == XFS_DATA_FORK ? eof : cow_eof);
-	switch (error) {
-	case 0:
-		break;
-	case -ENOSPC:
-	case -EDQUOT:
-		/* retry without any preallocation */
-		trace_xfs_delalloc_enospc(ip, offset, count);
-		if (prealloc_blocks) {
-			prealloc_blocks = 0;
-			goto retry;
-		}
-		fallthrough;
-	default:
-		goto out_unlock;
-	}
-
 	if (allocfork == XFS_COW_FORK) {
+		error = xfs_bmapi_reserve_delalloc(ip, allocfork, offset_fsb,
+				end_fsb - offset_fsb, prealloc_blocks, &cmap,
+				&ccur, cow_eof);
+		if (error)
+			goto out_unlock;
+
 		trace_xfs_iomap_alloc(ip, offset, count, allocfork, &cmap);
 		goto found_cow;
 	}
 
+	error = xfs_bmapi_reserve_delalloc(ip, allocfork, offset_fsb,
+			end_fsb - offset_fsb, prealloc_blocks, &imap, &icur,
+			eof);
+	if (error)
+		goto out_unlock;
+
 	/*
 	 * Flag newly allocated delalloc blocks with IOMAP_F_NEW so we punch
 	 * them out if the write happens to fail.
-- 
2.39.3

