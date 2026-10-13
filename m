Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60F4470135;
	Tue, 13 Oct 2026 09:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791884387; cv=fail; b=avP43KrjFUmxtm76UIsoD/vNp4PFasDksZWOwAB31jAL99uThlaIfoiYL3Waf5pVwjb4UW6kHoUOhwpgAoDKF9q0IK+DYKA1iZSpiXxN6y+nDSgkggIgtMFW7cZtEXNVsHH+71pJ7GNzpYWowpFOk91K7uzlVzG636Lt+xWXiyY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791884387; c=relaxed/simple;
	bh=OrDOklpMOxQRViQ0T14WTlWqUIK7HbK97870U+zjNPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sz/bUpWamvkRKqyCwJl3FJaaXhnt5YXtndk93OF/fpxROwijfpdE3sSV3lA9/Sa5/eiib/wQkaYWokWlAmcnMr61wmVUDQ93FxsSHcFBniFfOinsA+sHh4zMOZByJNkZM1JgQI2LPgmsN+VUktpcLftCGGG5sUMlKfzDLhDubGw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Sw/7BH99; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=g1z5XEYG; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Sw/7BH99";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="g1z5XEYG"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2Cf4F680865;
	Tue, 13 Oct 2026 09:39:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=B/NDq+ElZ0sta8AHNQYU5ZqPuQIOtgh5//R36FDf09I=; b=
	Sw/7BH99/tuEBs4wZ3mW5K8CZPOnv0BXC00LfRtcuHDyIma5z8KuJBJm7CejRL2Y
	auuYbuQYjJvkxDokT1AvfWaN1cpajMqPEuDDJtqADIwKbbZtab469uc0EWQiPNut
	glIgGRVSELNtgKj6bjoLX4MoAi7Ltafc/ThvWvi+dBVKLpf9GWKCtyTDkMTFPTw0
	JwKgIlAOlsM6d3JYCDgWtbyrqDdiKH7WBE7aKyhRLMbVkddcSvXyBneEiVKrKOeW
	IE+E563uIYIp5lAcrhloncmYGstRMykiJntjoFVrfNccTQr83+ungrGlVo6d8lg0
	ePgNQxboxlGo9X3e61IVvw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7dddusbh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 09:39:41 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D9agG2016144;
	Tue, 13 Oct 2026 09:39:40 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010043.outbound.protection.outlook.com [52.101.56.43])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4h7btp16dd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 09:39:40 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PbYwMZVhX1jcStXYDciT5LsRe6SKpSkpL9bCyKuHGfqPINsIhrJrtWskn8/P0rKEPkkLHAk0j7IMxhqU+zbv32SDryNXGMT5ssEiGK6muZzO29bcuddERQXI1d4OYlpf/057jbn2rH+mFGG8Gb/1h7uv8jKmoL9/0J2cK0QcSU+HT0Sj30VZrZwnMzxM1J6zM0H70mtc/LHDjgwYlsk/Kqvu/gK1HC6cIG294YQk2I71MUwYEi3ZYx1Kd2RYcUx/ZqPa9VjD2RlV7RZLeyhSVX6mB6IcL1N7GqSi8P6/iFuPpjZQX3YRFW8rVQpS/uAz/h4PvT741DdLYD+zVPI9ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B/NDq+ElZ0sta8AHNQYU5ZqPuQIOtgh5//R36FDf09I=;
 b=SJtDzl46sy9EIfK+rKjTc5I6/IP6YglG9XXTJiFj/VwayfappEM5eXxN0FG3dzK6DwkuetmrTt2Ri9gIisENqSr28dz72/F0VKhrdC+IvnnrkF4sBOG20KAg2WIQANfP9+8jpU2eS/8uE/F8omjy+5oHnHKRrEi+naeikhEVU7EfmomfQt2AToBDeWE3yVZmTVeQODLgSfY+dGy+K1/TX0oifX4eZ42F9CBwK5c1xqWz/ODQut7HnlN0YOaWMGJahI3uYlzkR0xpEMhWuS3uBJMap451AzKu/DXCWVXQ7R8ieGz0G2NbQ9zOaDoLcU8//GtxlpPMPVTmKmv9aAJUrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B/NDq+ElZ0sta8AHNQYU5ZqPuQIOtgh5//R36FDf09I=;
 b=g1z5XEYG1L8PV6PxDVD0RwK5o3NQIfjQWCllKaxUsrhvdoW7xqhNoTCYL2BuEwyP124HiHk2SzZBS7/OyrI1fo/AA1q4mObWv6NYXvVSrIUqh7Gfh9V9M5G0mDH1tYBmHcDaeTF8emtd5GAfKPSFxq5NSXEZUvUan3RNcEAPWS0=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 CH0PR10MB7498.namprd10.prod.outlook.com (2603:10b6:610:18e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.11; Tue, 13 Oct
 2026 09:39:38 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 09:39:37 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>,
        Mark Tinguely <mark.tinguely@oracle.com>
Subject: [PATCH RESEND 5.15 v2 7/9] xfs: rearrange code in xfs_buf_item.c
Date: Tue, 13 Oct 2026 15:08:58 +0530
Message-ID: <c3603d2856e91aa512d091eb64a4fdc37b05ce2a.1791883296.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791883295.git.siddh.raman.pant@oracle.com>
References: <cover.1791883295.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PN4P287CA0117.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:2b0::11) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|CH0PR10MB7498:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e2ff638-f8f9-44b1-565f-08df290de5ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|10070799003|376014|23010399003|56012099006|261009223027099003|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	rQ7rr4iOsyvDp+wt9XJb8Bj+F+uGSFhFQz9f8manuzE4rFAdnzf6HcqUbZnajaVYY7UqrWXRDFlGqTrNCWOV5gBPsgDejKIJ0h4L8X+6Aw2xrc545M+0hAGusdL30101t4RzgOreZULl+w7SoFOiEjpeF/jubFbCiFHt3ru9oPPdvFGNrHDXOu4ao24V7BABHhf4U3pO4up+iyZWqz4rlDKvDZGIWOHD9EoarbVMlSwKGJZ/PqUzjjuNXlftDLtxBBWUDgDDA6wU8BfAD0lptd55EaGVxZUKqM8wWtgucV3fEp28dOb1jllf/juuhwT7izk5J/UOLkM+30kDzrhF9hkh2DBfzIou6mN1EMfGDY0gldKYEdNEa1JDkL3uIAsYiwOHL8fCm5f81/IXua5Th5h4kzu1rqa4vGEtC84ecA3h3AfpWA4gHnjxGg/czHyncPCoTaXNpouGo0l42vFD+0M2TrzxDZ/0dW4a4/Rhl2vA6BZgSAQAPhMUdIldwnacEUDAi564bdCxzPJCh/xlz/81CHVQDOphUPdw8pVIQhiME0Yi7tY/ylB9bRaLHkErdxohwNrBLhcV/o9pgmi1uUXs31gacDQ0rxYMxu58ZCDdtqonwpA2IH5fpQ0ohwVn7rpku/bp1DuWl9pMJUk1BWk0uoX466MMcW+amJVqWQ0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(10070799003)(376014)(23010399003)(56012099006)(261009223027099003)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sMvNxZ5iL36MHE/iP+cggIFdAQS3XKoFAY9yR+QkYxaNenY5luUl2yngEjnW?=
 =?us-ascii?Q?z9U0nmf48bHyUOIb9EY1af++NDFji2R8qh+ypGg3+syJL0cHyBwCuIBs++en?=
 =?us-ascii?Q?+8FvZ6n8LWT8uq8zmVJRZSFpUNvl5xAqC6jYNTLbwFJk0uGZfrbAwDciHFxn?=
 =?us-ascii?Q?sOO6RwfGgLLupklFqe9+CL4fUtNlX1hB067qVRcI+O61q+IXinDAWkeJ5P3x?=
 =?us-ascii?Q?lN6r8FneHp99AYhxlmpSsw/5ttu+zGzYH6xX5ifVis5aXzNHBN7eqAMGtHI/?=
 =?us-ascii?Q?xeeuaDLq9Rj4yS5gvDG02vrBO2wqUYgrsw/xwbSU1aR6nSZiDMFLrWfPSYcp?=
 =?us-ascii?Q?As34fGEVC376f/gbSgBwgIiANZ89mKDAGmw4MeGqjGubPFVO7O1sL+4emJXs?=
 =?us-ascii?Q?ALyo5V4I8XfKKxw/P690y0SyfTuZxNlDyEzfTqJuT8dDjojg2FiQEcKysp+C?=
 =?us-ascii?Q?siE0atbcb90xtJ82uSoXqwamkHRGdswtIkA4yHsv3HkFCm2XXITu9tXWNveC?=
 =?us-ascii?Q?HA6aeTEQTTkQUbtVTh7WTFpMlcisfkkznz/bmGfX57s8WztTPSRD6OuLrs7T?=
 =?us-ascii?Q?uOcIzeW5wyEm6d7CB61LIxDjJp+NcH1GmMKoVeGwigFJN2+EwFPz80d+117P?=
 =?us-ascii?Q?DqEGgPJwxC61vyzYDebvGlBMM2dio98mV66rpy0T+26c8ZRGMjFNb9+bmVQF?=
 =?us-ascii?Q?3vFstekGuM6PdvS/BTE5dQgyqrv63E3WjNab+hWwDdOQHFpwDd8M766Pcdxn?=
 =?us-ascii?Q?QjZV9SzpO9d2n7kkGyJ4hSwtamYkXzSh3mlGfc25kONoCQfuTYeNT4U+oW7K?=
 =?us-ascii?Q?lYOQWNqVGI81QzMOa84moZ+aSwOjJ/yIWyndDh5LE4XuHXotIRpaK8Gm/zsa?=
 =?us-ascii?Q?UxIVSxbc5u67SP+H3tp3nHSoZrOGSEpF2NJ5nxhL2uPNfh3tFlY4K32/uiYT?=
 =?us-ascii?Q?yoy4ilDhsfz5DjTAGpyr09OXMknky4biMSEU1sAucino3URtTONqD8wCftU2?=
 =?us-ascii?Q?8J5FvSQcEZuYwWIVV+dHPx+wVJfj/1dBlgSbqvZrfNi0V6IlqVtSCBpLSHF4?=
 =?us-ascii?Q?qUyqlVz3s1LofY9Lgz+qODEX1vvlolqtJNrO/H+rNujQG0/Uovb6BWbjr1Uz?=
 =?us-ascii?Q?Px2hKyeSOmfY6G/SWB9HMQ6hfihmtdz5Lm45ypCJIpLEafo7PQ0T4yPCWqS0?=
 =?us-ascii?Q?kfOW5rqpXDGuHCoiYcGTzQarjDomVvlzJPNK6Aj50auoG5wXiQJnfGYFuYFy?=
 =?us-ascii?Q?XWV1Pe2AmxilLsu7v9rxQnsKqV7GJYhD8yObDv9Bi7RaucFlP8yTuVhisYfo?=
 =?us-ascii?Q?3gNLKjZxLYkFIpLMIR9l3gqDZwMqpCD3A3MCd8RIR8VkxqxAOkzKmvhW5ULe?=
 =?us-ascii?Q?iCz0kUcNdmJLB5vaMugJNeaMvWQLassy/ArizKAxfI6McdAU7ac6/IPG2PWG?=
 =?us-ascii?Q?8F2wcTRrMsJX7leGYtTpcQMy+7+VF7lw/pjMw16VwgAI2CFX9+32U6a3hyTl?=
 =?us-ascii?Q?QtXyc21ErxHVjggk9TD4SJhRcMoZuiRbc4Kwh/Ma/+PLXT+yYyGOamfNoHoQ?=
 =?us-ascii?Q?JPQFgZ0vYvF0mvFZfA5WlFZ0TloxHx/uywEfwMh76wPi+SR9Na3fm7YxiYi7?=
 =?us-ascii?Q?u1TZbxUca90LhSL2vj+R+9vwtK+K99rU0ONI79KHNokPRnVyvUxSP7j6Rg9g?=
 =?us-ascii?Q?DUXBalec2AS3jlRX4nfTrDtuw6jO7K7bcau4JtnZwr1cuwcVZNB3kT5wyO6N?=
 =?us-ascii?Q?7pSDszi7A6HIkWSa8z1YUCFrhYAlgDAdgn6KV/p+4DheL4pmp76gWW6E0QZY?=
X-MS-Exchange-AntiSpam-MessageData-1: nrbdPMOQH2omkkEEtiNyFmBV99GRPcdY1eE=
X-Exchange-RoutingPolicyChecked:
	nFyKBjPLNDw53RDAkGlSiiT9JVcQ6PEz6hLgUIoOzITV+CU7KU3V/wXdCw9AhB+DehMAv3GKmBs+OSav4QxFrKgBw118nlbaejjzL/BZZ1bJAEbj2VlYq5DoeiGTSXFQATa8ig2PUSpiXhRrCBjKX9/2VVfdGHpxQ2nKssIanO6LYsCQQE7iggo6nKWHYgNS6NfFLECOa+OvkeM42z7jcI940keUBCV87zTbsVqEcwJ4sp5vqOV5A+XAzE05yq5XgDbHtIyK686T8Hq6lvF6Fagt54KBcsu+2MvXTywycPxZfrKmKGsoPn4od/aMS1KEMTD/FOHy2qSzQFGgpzHY+Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	iFzGFQiEIsMUMqDzDcMjL/ccgJVGgJYZgZ1wL3P0LYbHC0j3VxkP4W0TNxGpKcpCj4GXbbfht9HBJxmt8ZzM0VTv87ceVfdGE7u8omnapsAD22vqDFR0kLGO1lbBKJ0Elpaz2PAD7Ykq3qqkYIEpU0Atk0R4WhoX0aJpKUGkI+8X5dM6MuvRJHkCa1N47JxU7Qyo35NuK8lumx9i5KFRx3pe/Ivf5KhCkKm8bD0gyYIdP7ZvA6zgIUT2V+nV7ChJKOs1uTTwsGHN9oIdZTbwIWH96at+wyuCmz8NsXG++Glw2vGMPgGE2L+Nuud1nnI7N7MHLZkzMPAGUAzsRcuz984b0jT1cPFz7CnDaKOQQF+gIrXiNTRhbyTjx4oL7YE5VXcT6T7esFi4N6PcPHnNx+Dav+HVX0wuCweJjiLa3edvxmloefTts5lPjT27FcJmhql+LKZHQb2uxPzlGCr0VSb4OEOEgStq6glTwbXhm1OzlLjNonK9oeaJvY9rQ0t1j9G9QF2hmt04aIFSvRhDOOyvunHRXuELC9dGF6LH+j9zKp2xHBCrD2Gze3ydv/nKC7tvRxRsbPSlkiZbCQuym6QfEr/J5tudyND7fzssrek=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e2ff638-f8f9-44b1-565f-08df290de5ac
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 09:39:37.8509
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MudOOW3F2keQtwlNFHVfO/ZdkaqztJWsJIlY1hvQ020XwlRJ/mxJWe1+PRH9C/kvKcbgGvZMZJlXW6IEnY/63JTCgnGroYfz4V50vCcCvVE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7498
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 lowpriorityscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 phishscore=0 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130038
X-Proofpoint-GUID: kUbqHUN5z2qTUxR4MK046HgTjhTq6qwe
X-Proofpoint-ORIG-GUID: kUbqHUN5z2qTUxR4MK046HgTjhTq6qwe
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX7fjikz9EjkwC
 yuE8V3v8qBaKBhHFdtLHxt5CYgzbSEFj8JzPMaerSbImZgZsXu3vL5IZeNZTkqI5xPaub6lwjLX
 rYmi8affPzKx/cWjA6rdTIEwR0qUWCbgZMQ0j/dbx+blAy+rxkjJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX+XkJQfGgCicq
 gtvVgd0Rltr0ypDY8DanSVkOcTVj8YR0q5X6DXdd0HXKrWhYDQi9/ut0kPmWMELJVM3amFVk0x6
 qaFmEr++Vql5NKuThRSS1VBNPiB7cRVnSOacej4UcLJBgi+iayDEnGl131qD9aU5VXForXSYIQu
 uqyIKjU3g9R1uK63svFXA30ctrj7vndFgZyEGWvvisClkZXf5mL5qXk+y0LuuKiZRXxAQpa5HrO
 nQs8kgbhn6L3dvXTakkiniEqkkyN0zoSpt2GFsurOOOqU5CnE9ouJ57FT+XDYJQCJz3g1ufUSe3
 HQapvTGYMFRJVUeVHbRZelJe6/1Zeq4ix5ssmit251GWt356xAIXQoMXma8tqaevYvlzVS/LKLq
 W6pBKruIZLWf7OuCJ6Iunzi7W4OVNQtjiuMhqFedC76P5utuVEbOb+K5Q5nQ0MEQ89V5KaY9Upo
 yNHLcYTHf1UcqXtT1skr5tCqeQgCs93g9dcIUYHQ=
X-Authority-Analysis: v=2.4 cv=J/8/fwnS c=1 sm=1 tr=0 ts=6acdfc5d b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=-BFCJ2bJgao7vN__fc8A:9 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:13537

From: Dave Chinner <dchinner@redhat.com>

The code to initialise, release and free items is all the way down
the bottom of the file. Upcoming fixes need to these functions
earlier in the file, so move them to the top.

There is one code change in this move - the parameter to
xfs_buf_item_relse() is changed from the xfs_buf to the
xfs_buf_log_item - the thing that the function is releasing.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
(cherry picked from commit d2fe5c4c8d25999862d615f616aea7befdd62799)

6.6:

Fixed conflict due to the following missing commits:
	[Continuous range: 10634530f7ba^..d4c75a1b40cd]
	d4c75a1b40cd ("xfs: convert remaining kmem_free() to kfree()")
	49292576136f ("xfs: convert kmem_free() for kvmalloc users to kvfree()")
	afdc115559c5 ("xfs: move kmem_to_page()")
	f078d4ea8276 ("xfs: convert kmem_alloc() to kmalloc()")
	10634530f7ba ("xfs: convert kmem_zalloc() to kzalloc()")

Removed ASSERT in favour of existing atomic_read-and-return in
xfs_buf_item_relse() due to the following missing commit:
	3762113b597f ("xfs: don't lose solo superblock counter update transactions")

5.15:

Fixed conflict due to the following missing commit:
	182696fb021f ("xfs: rename _zone variables to _cache")

Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_buf_item.c | 118 +++++++++++++++++++++---------------------
 fs/xfs/xfs_buf_item.h |   1 -
 2 files changed, 60 insertions(+), 59 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index e0c75aa3cca8..ebcaccc4ad66 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -31,6 +31,63 @@ static inline struct xfs_buf_log_item *BUF_ITEM(struct xfs_log_item *lip)
 	return container_of(lip, struct xfs_buf_log_item, bli_item);
 }
 
+static void
+xfs_buf_item_get_format(
+	struct xfs_buf_log_item	*bip,
+	int			count)
+{
+	ASSERT(bip->bli_formats == NULL);
+	bip->bli_format_count = count;
+
+	if (count == 1) {
+		bip->bli_formats = &bip->__bli_format;
+		return;
+	}
+
+	bip->bli_formats = kmem_zalloc(count * sizeof(struct xfs_buf_log_format),
+				0);
+}
+
+static void
+xfs_buf_item_free_format(
+	struct xfs_buf_log_item	*bip)
+{
+	if (bip->bli_formats != &bip->__bli_format) {
+		kmem_free(bip->bli_formats);
+		bip->bli_formats = NULL;
+	}
+}
+
+static void
+xfs_buf_item_free(
+	struct xfs_buf_log_item	*bip)
+{
+	xfs_buf_item_free_format(bip);
+	kmem_free(bip->bli_item.li_lv_shadow);
+	kmem_cache_free(xfs_buf_item_zone, bip);
+}
+
+/*
+ * xfs_buf_item_relse() is called when the buf log item is no longer needed.
+ */
+static void
+xfs_buf_item_relse(
+	struct xfs_buf_log_item	*bip)
+{
+	struct xfs_buf		*bp = bip->bli_buf;
+
+	trace_xfs_buf_item_relse(bp, _RET_IP_);
+
+	ASSERT(!test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags));
+
+	if (atomic_read(&bip->bli_refcount))
+		return;
+
+	bp->b_log_item = NULL;
+	xfs_buf_rele(bp);
+	xfs_buf_item_free(bip);
+}
+
 /* Is this log iovec plausibly large enough to contain the buffer log format? */
 bool
 xfs_buf_log_check_iovec(
@@ -562,7 +619,7 @@ xfs_buf_item_unpin(
 			ASSERT(list_empty(&bp->b_li_list));
 		} else {
 			xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
-			xfs_buf_item_relse(bp);
+			xfs_buf_item_relse(bip);
 			ASSERT(bp->b_log_item == NULL);
 		}
 		xfs_buf_relse(bp);
@@ -672,7 +729,7 @@ xfs_buf_item_put(
 	 */
 	if (aborted)
 		xfs_trans_ail_delete(lip, 0);
-	xfs_buf_item_relse(bip->bli_buf);
+	xfs_buf_item_relse(bip);
 	return true;
 }
 
@@ -792,33 +849,6 @@ static const struct xfs_item_ops xfs_buf_item_ops = {
 	.iop_push	= xfs_buf_item_push,
 };
 
-STATIC void
-xfs_buf_item_get_format(
-	struct xfs_buf_log_item	*bip,
-	int			count)
-{
-	ASSERT(bip->bli_formats == NULL);
-	bip->bli_format_count = count;
-
-	if (count == 1) {
-		bip->bli_formats = &bip->__bli_format;
-		return;
-	}
-
-	bip->bli_formats = kmem_zalloc(count * sizeof(struct xfs_buf_log_format),
-				0);
-}
-
-STATIC void
-xfs_buf_item_free_format(
-	struct xfs_buf_log_item	*bip)
-{
-	if (bip->bli_formats != &bip->__bli_format) {
-		kmem_free(bip->bli_formats);
-		bip->bli_formats = NULL;
-	}
-}
-
 /*
  * Allocate a new buf log item to go with the given buffer.
  * Set the buffer's b_log_item field to point to the new
@@ -1040,34 +1070,6 @@ xfs_buf_item_dirty_format(
 	return false;
 }
 
-STATIC void
-xfs_buf_item_free(
-	struct xfs_buf_log_item	*bip)
-{
-	xfs_buf_item_free_format(bip);
-	kmem_free(bip->bli_item.li_lv_shadow);
-	kmem_cache_free(xfs_buf_item_zone, bip);
-}
-
-/*
- * xfs_buf_item_relse() is called when the buf log item is no longer needed.
- */
-void
-xfs_buf_item_relse(
-	struct xfs_buf	*bp)
-{
-	struct xfs_buf_log_item	*bip = bp->b_log_item;
-
-	trace_xfs_buf_item_relse(bp, _RET_IP_);
-	ASSERT(!test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags));
-
-	if (atomic_read(&bip->bli_refcount))
-		return;
-	bp->b_log_item = NULL;
-	xfs_buf_rele(bp);
-	xfs_buf_item_free(bip);
-}
-
 void
 xfs_buf_item_done(
 	struct xfs_buf		*bp)
@@ -1087,5 +1089,5 @@ xfs_buf_item_done(
 	xfs_trans_ail_delete(&bp->b_log_item->bli_item,
 			     (bp->b_flags & _XBF_LOGRECOVERY) ? 0 :
 			     SHUTDOWN_CORRUPT_INCORE);
-	xfs_buf_item_relse(bp);
+	xfs_buf_item_relse(bp->b_log_item);
 }
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index 50aa0f5ef959..e3ccbf3ca801 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -51,7 +51,6 @@ struct xfs_buf_log_item {
 
 int	xfs_buf_item_init(struct xfs_buf *, struct xfs_mount *);
 void	xfs_buf_item_done(struct xfs_buf *bp);
-void	xfs_buf_item_relse(struct xfs_buf *);
 bool	xfs_buf_item_put(struct xfs_buf_log_item *);
 void	xfs_buf_item_log(struct xfs_buf_log_item *, uint, uint);
 bool	xfs_buf_item_dirty_format(struct xfs_buf_log_item *);
-- 
2.53.0

