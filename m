Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F11E86344;
	Mon,  2 Jun 2025 19:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748892156; cv=fail; b=uidj3EqUx1hVrgCFeFLLTujjphkSX+PzR0q0ZxSmcPbys3DRsUsDXvs09AYNLiY7QYzXAjk524cegJsbv+cmHfGtcDdemCZQ5LZ6fd/dmYlHRz4Yhq7thHt5io8crQKJizZjuyNq1Uhulz6aYNRh3+cPP8XiJN5kxdFABrjs1nU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748892156; c=relaxed/simple;
	bh=yW1EJVdaMlJXchfRFrdHAhMK0b1/UHjC2nWojPPwMNQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bBUy8Tyw9GDT//WEb+0RArW0L5BYD3+R81J+JCpbjr8Zg21SAZqdZZkjhn4S/c6F9TPaBlPihGfYiGdOT/U/IfKiURPYT/3wMVR9bi8dTiKdKCIYUTak1bx8uL64VXQvzM9ad/qYCfqocfcUtpBZXU7eNTSPnAfpaarM1aPDfTI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IBzfy74V; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=vkOMx51f; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IBzfy74V";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="vkOMx51f"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 552HJ4pn026105;
	Mon, 2 Jun 2025 19:22:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=qFRYBhwWA/rgaMVQ9pJzd2V2iG1pSUXgN9Yj68ruRLg=; b=
	IBzfy74V2lYgppKaHmInnpVrUlCBG5YX2UR0NMjJsQ1FSxHKnNDaeXyuG2McgkAJ
	JbEUfEm9RrD8X8k1YTuUjvPJac9Vr2CLv96pjVQv3d+QoDD7a7sRqloBCbu4/lnc
	7elaNMdSuzJBJhwCf+L4427ZprdB4hbrPa1GOLzHz5iB7chY3zWtJcM1GHe48eUb
	DfcWPTgvGcFSpZbgmM6bmUKWH3kjrjgfriYrFhLjnqe8LSJ2gA4avIopNHVl65fF
	JzcKn4li9VdVRv7FQQJM8tjca7OonB6fwWlMz37ZsDYc4h5KrtPMMsie/zU+y0Ar
	22cj6rSRm1VPzrY9Ny88tQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 471g8g87q6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Jun 2025 19:22:29 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 552J7rlv030739;
	Mon, 2 Jun 2025 19:22:29 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012011.outbound.protection.outlook.com [40.93.195.11])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46yr78d04w-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Jun 2025 19:22:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TFlJlGyp7J9Xg66nGk4WtqGMsCuUajU9PSCgqoTiB8yNrQZ1UhQKctTdkgDe+cyp8SWFCldJa+FR5aXa2pd5y730iK325HdEs0Ol0+BabRB4ymxD2Rv+8CptT5L7PCJeBOF/TWcEXCK+/CNfkQlsuh26kKPOCSxsaD3OUM4+eJMNTS9bHm3ys8FIeCJ9FQrh20sKG5xQeVTp+octm5GVv/lJjYQZwRjs21ersnTOB0bJWmW47Hl4Yccta9UZoqSBV2B0enP4cVRSGmaq0w3OUM386XdQGK8g9du2krjFvcb4C0LPD34qzdwkvBv9htAFv8HbS2TWHdVcgAia6gKRwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qFRYBhwWA/rgaMVQ9pJzd2V2iG1pSUXgN9Yj68ruRLg=;
 b=psIxWirzDgCelaBfkfPuYpgd516wvZFYTIjkwESiIM3Ns86p6wp3s9n3Ss3ujyJcZ6NL7XFmBG5p0TwUW3fJWdUeX25zdtUxf6u4M3ykdT6MwPUFsRKWTJz6kuIQ7nU6QtIzCi/Pj7wJWOF7pa768JBxNFdfE2GvabT3R3OpdPzITo+2+iLDP8NoxMJrozKu0H4rGuCB+vZzKDicyhKx/Di3sKjuWR5rOXRD1RUcJ1cuGRCtrYkpHNs0N2SD1hBoDz0Q4KGci3E5tqKqDfrP0L0OKRWp9fnDCbn4t0os/6LiVLvGmC2qIANz0f6L1eLAYkDt1FphVMHGrFhBiWiOxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qFRYBhwWA/rgaMVQ9pJzd2V2iG1pSUXgN9Yj68ruRLg=;
 b=vkOMx51fhbAbS0Sof/KL7j93GKeOtToqWG2fpW21YKog6DbDncwFQuFQ7icCsvLGd2Unud7zhu7YL6y1+p2dw0XiQy3oHUJ6UGbWcK5pI79jmRJxeKNs7pq2ODhdECdoV0UuSoibdMRCR1E9hHAIhLRCf8jyBRXYYO1St+994p4=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by IA0PR10MB7158.namprd10.prod.outlook.com (2603:10b6:208:403::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.41; Mon, 2 Jun
 2025 19:22:25 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8792.034; Mon, 2 Jun 2025
 19:22:25 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc: djwong@kernel.org, john.g.garry@oracle.com, ritesh.list@gmail.com,
        ojaswin@linux.ibm.com
Subject: [PATCH 5/5] common/atomicwrites: fix _require_scratch_write_atomic
Date: Mon,  2 Jun 2025 12:22:14 -0700
Message-Id: <20250602192214.60090-6-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250602192214.60090-1-catherine.hoang@oracle.com>
References: <20250602192214.60090-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0013.namprd21.prod.outlook.com
 (2603:10b6:a03:114::23) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|IA0PR10MB7158:EE_
X-MS-Office365-Filtering-Correlation-Id: 584af8e2-69ae-4315-82d1-08dda20acea6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?erkeeRRZXXXYnpf+tigykInEyqkNO2uYbEWLoz+b5bBMDdhroZeF1xmhVzVg?=
 =?us-ascii?Q?4oIDh9BFqAcv8O+TXC/VcBp54GeusfOL65YKArqM240y2azEEZwOTJrbj3LX?=
 =?us-ascii?Q?FPpTcswf6CjFde39VIQExr9an//ETvductGSMbz351WLls5wu217zYUu47Ps?=
 =?us-ascii?Q?yM8EiaCI0s3kcMhE3lw/K6XxdVsLAdGY8x5W1aFp4gbptibC6GDyeyg4ahZd?=
 =?us-ascii?Q?WC0MF+sv6PtugV+E1+awA+9OLTOM5+8mus/Mj0qpsCgkO8DkYJItLi4Wli3C?=
 =?us-ascii?Q?ntOrW4BARDOyWwZ2Mfl9JQjGHjU0VWWeVba16J7FthP5rTHck1KRzNDgz4x/?=
 =?us-ascii?Q?/A7pJzMwNXJOglh6fBcIaG3yg0lYH75CYi8/iBkKZCq2xS/Ehj/yWYT3q8A1?=
 =?us-ascii?Q?OkRxL2BTWdv90VNrYv0ir+9k7eFKSEfb7QwH35rv9rPOT1tVcpniRZC7Y/s6?=
 =?us-ascii?Q?u8vF1xin/1Lu9hXFZW/MnmfCxAgQwbVpS1wDqSXo4RKcyWORoQtUHVaT6pfe?=
 =?us-ascii?Q?Cx0HqyIQ8HEDVZSMJRhIWJ7YUQ+kFffXr0rcGWnpHxSagsL7XLt10/o+wC1b?=
 =?us-ascii?Q?6424nOkKodqfe2HZ+gVlUgQkvoSFGA7ld1PQvmzSPJXCk8cQubBLT8BJ3Rem?=
 =?us-ascii?Q?v90XxZt7a4lttVnuMAksKjbA6kt17dF2UoBkaVGtPwOEm8W8PjWxJeQXmmcz?=
 =?us-ascii?Q?Cr13dWrgJsMvuo0Ohkq0XkZVcs5D6/bFNFkfoa0pMqy1kEw9kue1RXjIDLnK?=
 =?us-ascii?Q?QBCCu9EWlEA/b9FKM+y/PVQ/goDnUfV/egDI2h7qmVnzWf1h9mF0tRpdjsXV?=
 =?us-ascii?Q?pmmUNUgcuiEoAxwhL14Cebp64Pyr5TVZU06tchRWviVMItlV5VHk2sdGxJkh?=
 =?us-ascii?Q?mpnEwiFlTDRoxy9u++IfJ8mgeo2suWCgj7Qeep6FfMx6VaRF1lyfJJDa51uW?=
 =?us-ascii?Q?0SemFI80a8uY1JurjuZG8BWwmMQLCG65W63Xns4ShwHnVa9oV8pC81NmJU4A?=
 =?us-ascii?Q?CJV/i674RBlqEO0+ZReRCBpRCzUCxHE1OLsabEDN827eBO7lUExQLa+/UK0B?=
 =?us-ascii?Q?+6F/58PZNKivN6Sob+sTyBVc9bNv4NfHbXTHSe9H/3C6qwi9ViOIQRLieNd5?=
 =?us-ascii?Q?qxSif9FlRgkynNd6qlxA4y3UncpKGDrgPD6aAiyjM5DVY1sx99qXhfeYTDAS?=
 =?us-ascii?Q?fyGRx+bez6ujyby/pgezCmcA0SmGhhaikUymjEpcR7NAujGl7V8aBDmBYONY?=
 =?us-ascii?Q?wTmLYybRVaq29Cb1C7eS8S+ifTr9oiS/iqJ89Rzyqm2031oXF9esPGSP9rbT?=
 =?us-ascii?Q?91SZSKt2hGlwYMXTIhfgqtduUW6XMkRcyYKFWIOZ5I2V0gk3SyHxFbAtri24?=
 =?us-ascii?Q?Yk8HxwTvGPn7+pEzIBkhFsF6jRNMfPp8i+9sjU2jStiRkLOTlfGqjpHsX1j+?=
 =?us-ascii?Q?Hj2xNqM4iNY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HoXZhxS5tVf8U/dJrrcSRGPW4KypjJHURujpToYYdh9vBxTLrP3u3YbsnsmO?=
 =?us-ascii?Q?wi4LxFd0w8LblDh50z6Bvdni5pCnLkjvLqsANpVIKCDZnf2iqL57UnfEZfZ2?=
 =?us-ascii?Q?NsWAohIEDQE34vORhIZJdI7SA0U4rJUudiFJT5ll2lWg5fE097+wWq+v40j3?=
 =?us-ascii?Q?/3ZPAy4UWBfpMuPOYs40rXLzdg44fsXar1Lo4fpaf74Qb8Y54iiYvjQZgIfq?=
 =?us-ascii?Q?floMCXSoqQxmlzWssyPCgMbA5j1nyUkqEwfiOdJAlKQTXJtcE017IhxtyH+r?=
 =?us-ascii?Q?mpftxWR0KqIJgCQgoizGkFHe1kSsRd8y65aW4ef4SifSKnqc/Nv8yrLT4HsE?=
 =?us-ascii?Q?i51wuvnvcG+eo7pzwZkQFDu3zy216CKUgB7XyBoHUeONo0lPTZT7J83Zqeo1?=
 =?us-ascii?Q?8sGsNh3SJSg7z4FrGVeJmrWCOWRlCZq2x7LERGVQySjDPlvy6uKfcT9DrBwZ?=
 =?us-ascii?Q?ArzCKGGN+iFQhzw8Nqdj7RZ9FCv+Q+LuM1Hj38KaJLkGYIdnYrGgrOPhrl8g?=
 =?us-ascii?Q?atVRl3Dr5LVWqBKVOPnoD+cy6X6EfKgS8pjdC26B1OLANAIXzHeGIVGDeFK2?=
 =?us-ascii?Q?JDCUs000N268zn75+mOKB/N2Xotnt+Is5lWoJ0CMBdrTo+0uvBDQGonJgEga?=
 =?us-ascii?Q?SJJt+2PwXRHEsN7OfrYiz2cNGgz6th5+GEROduScnOF6ZnrlUZz7a5bXUXxL?=
 =?us-ascii?Q?68Jp/kteXpmgq4yZLG8Ne5klyW6AtkFx0aeewdgHrKJ1PK4Lo/VLKyt3oh/Y?=
 =?us-ascii?Q?Km7kpSE/xjmFxpfNEiOSFkUZ8aVNY/uFdp8h7ZQ0NH3ei6DLY1qEmS+dyh3B?=
 =?us-ascii?Q?NBp+HoBuKlqZAR422jCUJWZcV/66JDvoa2Tfj7Hgdkz6b2IIiUanGHhir3sY?=
 =?us-ascii?Q?eylQf5GNzX2Sda087r8//QwJ1282gHN6yKni6uBJ9gxIQJYJMP1rRy93f5dD?=
 =?us-ascii?Q?pOK88ikRnXv0tQaUKweRehv6znZrC+2fNCXiyCbkJ6BhcxAIlCpON0A51vHa?=
 =?us-ascii?Q?MNBwQMKhOj24OWD/S0Qy9O71wT34/y8r/UqVbCIBngsuNtLsFjw7MRCdYhd3?=
 =?us-ascii?Q?+f7Qyge4bjSc15uJ6gX/dIZSEBCS8rwTbkDib0rpoNJsKpbTcdHtXzqk7MRR?=
 =?us-ascii?Q?TU1aFzWYruH8xkreUT+c/Abahb7x71gJpXCSkgjkkwby9eVtgbGbqsU+EIU2?=
 =?us-ascii?Q?SCFpHCqyw5SZwoTVtKa1UuU5kOyJCLSQebypVb2XHJa8VTlGNXXJLRWrTFdG?=
 =?us-ascii?Q?kolRS2R0CSyJDkZGNXfj32DDQbftl2iuiSsG6FSmC9Hot0ztZTbnTDUt+hr3?=
 =?us-ascii?Q?GPVtT776UfR7sTnLgnSbnJs824J+R78rROOSY/TNU9X/RmGnY/s0bxaMQ2q3?=
 =?us-ascii?Q?KoOOL/ewOizGZTE0U9clNDxxWAJfjHkhJB66iO9lxqcSKxtTieg36ZqD3APg?=
 =?us-ascii?Q?nsq+42H86uyRp9/FpNWW80peYrS9rw5EeasuPUp7odHx0+euXvtwihn+yFvb?=
 =?us-ascii?Q?6a+7dxJGkAKNzYDOLcpoQwEHxovSwFEo20YqvCUMD0Sv08VxhWYJ0SH2HOlH?=
 =?us-ascii?Q?HV/WMXNTHvYKTkjODtqcc6uJGblNnzFlYIa1qe7QZjptWH4tLf+ij61qX1w6?=
 =?us-ascii?Q?MZXHNz/I+d96HQLUgGeCxaJcs/sgqT9sMTUeMjFOl795gEZDdJrCafgAxGjK?=
 =?us-ascii?Q?N8e/7Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	A0qtfqaBe+ZYjqQLbbqfHHZFnI5oALvC5GT8d4AIvK/9S+X7Ka37sNf6W7rIfBxKk+Pu0y7q8dFa9HuYm/3HXO0vAHMypiAP5bAAUzEupfD3ZxrDd6BT6qAzdPrGNuG4R4sBc7m+5YG90IBwE/o5Rdv7P2w/gaNS+KV44xgHIV89TgsoS7cZsiV361Nv0xHQIXyMGfCLI1W5J6M5PzQ90TzsZ8GULx3JCETKaNJDGvrLMDXhZB5W7oRx21/BH9mR9WWSQjJdiPdP+86o9GJo0w/Nw9amDursxwGdNKXqLqhN2JeHOCFvYbYTdmJOFhvm8ceuE3sJQAswzo4SploQ0/obCllIZRGNAG3UPgwSel3XhBVGBRTYqHHytSJcnLjBwFI9t05w4BXjlocC9LdoMYb30vXBPJcCHZSzpglxLuSySjtYqLB0IS7JMU4zbT5HnvknPzsXTsekJLwXEtFsMlBZaLEZQ7VeU3MDxmox2JJfyMs8+jvwt801d0JIPsaFZWTD0WP7jnjCOAQ3vwF93hZMc5p38Dq5O0ZlTGUbb5z8pbDvUJKYVzl6vL1eils1VYaHM2+4wWfzj7MuXeu6xOpsh2jq7iKO9crwM7BmuLA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 584af8e2-69ae-4315-82d1-08dda20acea6
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2025 19:22:25.8571
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RkahMpLv/gTh254HdLlBEZzug7ERodb8c63spcQJPsU8TyOMC7bzh0En1oieslphWO2w5qJuT2o69hHGgoC5T/tsYzNZobPd/q7DEsJulXw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7158
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-02_07,2025-06-02_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 phishscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506020159
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjAyMDE1OSBTYWx0ZWRfX4C/nnsr9dKy+ MMCNCLEXjEoNfpbgV3LObkL4YZlJqKpZlovMS81hAIt6fGWS6GJ6QtDxcPETtqt9brQAPhh/wLI 3eZBI9RrJWJlMZ5kL9YI0VAFDMFSSoYgZNo7mMDm82wTirizzZ/SJHupQihjWQAXJBwoCi/n/aV
 wU3Wd4a+dbz4IL/kxiLl7t804xh6xDwhbJcVT3GUuzLcbit5DesZP2QXBWCqXrVsS8SW9rsdpWi S0AJn2SAyg+mHGdyyONxS4ZlwRKZWcRvOcbLdFmNurTeczPSjAIqPdr6Gqmf5lCqZErohHJb4TQ 1zVgNAsLfizwWfit85Q0hBFLDi9V+OlVu5Gv4dU645LlC+bHWfTofHYLACFuw0zM9lGpkjj5jue
 djq/DN5wngr6/mJpZPyHzqW1Su63k63aMgIlOJOzjZjU9Vbi/5lzgMzi/Iw/6euTKLMD2TXG
X-Proofpoint-GUID: CEwTyQfbh4-Khf7t3XGUTm_fKaDlC7Vr
X-Proofpoint-ORIG-GUID: CEwTyQfbh4-Khf7t3XGUTm_fKaDlC7Vr
X-Authority-Analysis: v=2.4 cv=H5Tbw/Yi c=1 sm=1 tr=0 ts=683df9f5 b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=pGLkceISAAAA:8 a=mx6Z5l6ODcrpD94SwjoA:9 cc=ntf awl=host:14714

From: "Darrick J. Wong" <djwong@kernel.org>

Fix this function to call _notrun whenever something fails.  If we can't
figure out the atomic write geometry, then we haven't satisfied the
preconditions for the test.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
---
 common/atomicwrites | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/common/atomicwrites b/common/atomicwrites
index 9ec1ca68..391bb6f6 100644
--- a/common/atomicwrites
+++ b/common/atomicwrites
@@ -28,21 +28,23 @@ _require_scratch_write_atomic()
 {
 	_require_scratch
 
-	awu_min_bdev=$(_get_atomic_write_unit_min $SCRATCH_DEV)
-	awu_max_bdev=$(_get_atomic_write_unit_max $SCRATCH_DEV)
+	local awu_min_bdev=$(_get_atomic_write_unit_min $SCRATCH_DEV)
+	local awu_max_bdev=$(_get_atomic_write_unit_max $SCRATCH_DEV)
 
 	if [ $awu_min_bdev -eq 0 ] && [ $awu_max_bdev -eq 0 ]; then
 		_notrun "write atomic not supported by this block device"
 	fi
 
-	_scratch_mkfs > /dev/null 2>&1
-	_scratch_mount
+	_scratch_mkfs > /dev/null 2>&1 || \
+		_notrun "cannot format scratch device for atomic write checks"
+	_try_scratch_mount || \
+		_notrun "cannot mount scratch device for atomic write checks"
 
-	testfile=$SCRATCH_MNT/testfile
+	local testfile=$SCRATCH_MNT/testfile
 	touch $testfile
 
-	awu_min_fs=$(_get_atomic_write_unit_min $testfile)
-	awu_max_fs=$(_get_atomic_write_unit_max $testfile)
+	local awu_min_fs=$(_get_atomic_write_unit_min $testfile)
+	local awu_max_fs=$(_get_atomic_write_unit_max $testfile)
 
 	_scratch_unmount
 
-- 
2.34.1

