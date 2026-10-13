Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C211341F5D7;
	Tue, 13 Oct 2026 09:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791884349; cv=fail; b=dbe6KS6SA5Mmzz6Gh+YalXLDxOHjtoI7m91GRivnXxIxlQPMhR8lznM4nhFEbuXL7/zXaW/RYsiGPu5jz1qlHJxGSjgF7MofbfXcNLKbTEvlYFJDl4TGCMWQWHZRQczrI+TP8TmLgvr6MRFxvZuXxP4THQRZintKrGcXfA9MRc4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791884349; c=relaxed/simple;
	bh=G8LYIQwIf35zcCyXfy8Jkwp9L4phUuIpyvkzwx495bs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kRfqgFnEO0GC1LzOfY9VwKZemqbJJDf/7D5mARMuvR3G8KOyu3unPs8TG/DlZegW3gci+4zr3vh+jMOY+f4OnI1M9uvwepz3gBCBQjQyNBm8wy48rIz4ihq2ZtaLJJnMMAJuT1p9LkAdQNf3eoVqI4RcZDuam1gzBDpvUeC7DO8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Hy15AEK8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=vSxEgtye; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Hy15AEK8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="vSxEgtye"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2CXvU3434603;
	Tue, 13 Oct 2026 09:39:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=q45FVh/H/qUI6Fc0J0+qVJhr/t3mIu3FWueF+8gwJB8=; b=
	Hy15AEK8o9L6M5kz4Vi/VLd5ODJFADUQABy3r5FNu8hjIRZq2fGNRZGbemSC6Bav
	TOu7qlPDYrqbNTLxuBIpCtvnBBLYK0PLTJAnxEQpAXYX+Af7Hxj0R748E1MXGYDa
	MW7iiwFpy4aDEdtKJntNLKi/ZTPtajDBiKb52Ggkb1qSbYwr+UCtxX4Bq1Qj2wxx
	X4eDKZacc2OrKLV+GwGbHZo3sj/xSMW+ewEQ0ZxTaVYisbzXsL8tocn0PyEnhaUB
	jJcwV8C6RAu+6kuF6B63kBdtp3iqK0R+N7qdCQJVDnSM1TWFch/JBQdwmiYY2wB/
	OF+8bLfRasH9h7B3LksQ8A==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7de1kp4d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 09:39:02 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D9aTSk010906;
	Tue, 13 Oct 2026 09:39:02 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011043.outbound.protection.outlook.com [52.101.62.43])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7bt9d4e4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 09:39:02 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yCoFUxL0xulTj9eZRlFM6j9pTe4fymS2hhZgA/OboRfz9lrUfxCc6ZBiyN65E6rFFS4yN2YFMdoMuWGOTUAUGbfbPQmgi/sX55b8tvnfhESdWrDUWiHQyhF1WC0piUuF1aB10qsolIMkM0IGGhaS0WiZUPhBrf/NW2yGHfBKRo4dr3eNZroTUUwFI6DoJxqJwhl+wVsCUE2a9XB77qjGqKD14pxzowRpi1k4nV8F9NSfXg7OC/nvP+rvPIuA2cJzQ8vnlOUoomtz0kAfqS4pEDXVyhUxsbjlWaQAKw0aMel0Pdn0/xB9noLyD6UcboWmV21JMZLF5iO7ZtS8m48e0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q45FVh/H/qUI6Fc0J0+qVJhr/t3mIu3FWueF+8gwJB8=;
 b=C20U1kcm+X++RQlAo8YB6xVAC4mapyKKdEsXLidBMKxPE3yrqqUYNgyjfmUgGz7s84q8Ap4L0z3tPtFzSDXkUwOklQ9WqSHdD7Le4fXp4Bj4mkwyGhwXc/REipjd4ZfCXH1Hhfz6rJwfua+oNoIyA/OcMUhAb39WLZKS5VhwHIskxWL2Tf0jt78oT8GkWVl+ivAiod33aQvlWXohTKCu30wYFEkSEYHhFcXGCm4bQqAeIKjZ1ctOhUtFRdTx/mz/udU+9rAgjpRrtZ7VWcBllRHp0jzetXJg0WUwUole8tGIm5gvIwKcRWmYyEPpxzXZzjWWaWdIRhYMVyTIxlR+Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q45FVh/H/qUI6Fc0J0+qVJhr/t3mIu3FWueF+8gwJB8=;
 b=vSxEgtyegYPGeoF9KhVYN8IDQ3KbYJ7Nf2D2ZauhjZgQDQxxGNicfNbkbb8MJciTvmMXsx5Q2jbJFHL0x21zUcK23kfhwDiecwGkvw3dGDvT3a7n90oy91cKNjln4tgB+RNigUJoeSlN2CZNSQBe1yZb4UufWcZjQaeFy/3+0fw=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 DS3PR10MB997725.namprd10.prod.outlook.com (2603:10b6:8:347::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Tue, 13 Oct
 2026 09:38:59 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 09:38:59 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>,
        Mark Tinguely <mark.tinguely@oracle.com>
Subject: [PATCH RESEND 6.1 v2 5/5] xfs: fix unmount hang with unflushable inodes stuck in the AIL
Date: Tue, 13 Oct 2026 15:08:32 +0530
Message-ID: <4d6cbbf72e257e9eddb41aa6083d0a69eec9aec5.1791883290.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791883290.git.siddh.raman.pant@oracle.com>
References: <cover.1791883290.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0056.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::7) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|DS3PR10MB997725:EE_
X-MS-Office365-Filtering-Correlation-Id: 1714afd8-40da-4ed2-c54a-08df290dcede
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|10070799003|366016|376014|6133799003|22082099003|10067099003|18002099003|5023799004|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	HGN3RVSyXqMD9ImMFeN46TH2Jju4tBO7TFgQE6ZIwd2UcKKGl8+vj9m/xlyNRl1rDS0MGwLNep6EpHgXGZE16AlyTcy/1m9mRLQ6c4mrvGbauOBGVkYfUjI4zvuUf2M84OJ/TanwgNjpSwiZcZSb16/7X0Rck/f5R3zbAQD8fNZt4SURsUsLTzWaUiU5A+k4nxFpJ8Q8vBAXiWTvF7g2uQ00EajARCjES4jKmz8EUyeOfQiRmPaRje2t4FXcNeo2DYMo0FXApXI7mB4ZCEocemYDdMF8nMYHXA6RElQUc+Ib3ropBVxSZcsfi0aCl6iXSG/8kybqNJoI96CTYwTnra9mam4CyNePFHbr/hoTEwPZ9E7zBryTzVlQwhI5o6Qz1t3crG6izmShOOQPuoDjAkQZ1nk+i+UAcQYIARKynnPJqFoqmAV3bjHxnEowPY9+k89LTL7u8N8QAKYobzce5nRbAowtDlVyjMuNGh0VeP+4z+qVh1xYCUJ0H56wkiWOYo0La2jl0DihZLWprfp0WvuqLpw6UYtcv7h68NLSmN9KGdEhjG0jDsx1XuuqtQfnUrcgKoKLAj/f8PhK/mw75Ir2nrpdBMIGk9yMK6/kUWkdQi0FYPgQ5FgdAM92oZfZ9FUmwd079wNgqd8scFLvilUmGqbGwbBoRfRZEZ1sUiI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(10070799003)(366016)(376014)(6133799003)(22082099003)(10067099003)(18002099003)(5023799004)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SHiDMYUNO9/meCLbAYWee8s21qHdM2uWlvhyI/kafdqhEtrmDlxCIMMq+XVc?=
 =?us-ascii?Q?vzduo7OBdp6bt/QBMurBP61+QLiZTMgI6Bm6so86fbH00b9uF8IpVzICP+el?=
 =?us-ascii?Q?J2IgT9QeUFAi+4zwzFS1RqSXe3ilpeIOjbOm/fV66CJEynSDmpLYnZDRvLf9?=
 =?us-ascii?Q?BijfM78u+Gsnx0TFpaF+gcM/9oeU+h8DyXxKXjLmnVGiHRrAXZYXFGka9HAY?=
 =?us-ascii?Q?qjuyTPwOZ/FxSRZCtnMffT0N0O3KJEU2ewEL1rIERh4UoQ2neuKNnr24gcxb?=
 =?us-ascii?Q?iFmeNc4PBN0cPNExySXSm663DosXVXmbaiQmZFROz0nPRIfpdEIuxA6Wji4w?=
 =?us-ascii?Q?0srjMFJStNaP+H8Tr3cDXGOMPtavnPpAStvpOGL0JRTb7k9VshU/Ar9Bdd2l?=
 =?us-ascii?Q?nX5vmGtQZ/Mufn8MsfZFiKURP1CEBOhXuvkyyusp83NNmqYov0TobsxMe7iP?=
 =?us-ascii?Q?1KaI03FSe/sj6bP7q3256C8KEJDT/AeEv/AwABMLjPJHNALZC2BP0ZmK5/kg?=
 =?us-ascii?Q?hz0Rs8e4LxE2UO7vF18K3h/T1iDHYgNwNhblwdS5IumKQg/WwT+7aRPe7UNQ?=
 =?us-ascii?Q?9htX3RwQHTLEPOqvS/Ed2bmWQ0Px/QINM29VfGy8+OZiDlkKDx21oii5OtfE?=
 =?us-ascii?Q?Bvv600GnUaYCZVNaN7hlquhYDbteXGJWaG+fzKdF3M58kChMlbreMof5+jAs?=
 =?us-ascii?Q?pu2O1Zer4KfJkQdcm3+VpvGXzEIdX4qDngaCuhnWAlfFAsScmQhm53prkMJn?=
 =?us-ascii?Q?WmkPRQJUZWIWParqGrIiTOhCzmLBJPjSBizlExZD0jiwL2ikhTYiMlUJTWOf?=
 =?us-ascii?Q?ZZssyfSgy9s7unsGXvd/fFwBYwb1HcKmjPsad81lymnmfMZSrbGzVDvpLMR5?=
 =?us-ascii?Q?J1Nvr+CVHTtHBF/dzGGQuFxyWkIu2tjRdwVKDVbYqaPVyUIDkVbymACWTi1I?=
 =?us-ascii?Q?jtzOhv4doGWruwzn5CN+ztS8BvZY7Zio9OsFTn71ZCKnFHZU0WDGm1aYszes?=
 =?us-ascii?Q?RGg7IK+ceR8zMXMZJP5N10gmkabmM8wqfKSAhLTds6tc7MImp107SVRBXafo?=
 =?us-ascii?Q?E6Bz+I45FE2eeecJ8KJ7jQnOb4sNNsRj8tEp1lz0ECy2gb+3AUx3dLfXU5A3?=
 =?us-ascii?Q?1h3PwiDl0WBYLkBhPSuZKx2h//Iv78k10wFzSdAYUbVwoLdo6Ncn4F/R1yD1?=
 =?us-ascii?Q?nFOT9orqjJ27m+Cu+PwjuqnsqAePe1TX7ZikqrpPArKKt+csVwKI8oK3mMvF?=
 =?us-ascii?Q?cu0J7mPzGhLfEHG6FLSTpH3KCbs4j5lViB+oT9IDHMNYMaVl1kNsuGCh79o3?=
 =?us-ascii?Q?WbEZT+gsKFJLWF57NC7i0u+9GXpuE1CF8GkXs4cUH3WZu24WaxhtAiRrOw3X?=
 =?us-ascii?Q?ALYIFDPg4YFq/wIcYY61oCNoep1G3LYQylcpcsdeKR3WdOrkveKJddTQlALr?=
 =?us-ascii?Q?MrX9SGX5D6dQn47XLZYFO1g9J4vRCaiXd4k9aS0AQ9nBJg3uNvyL7LzoWd1l?=
 =?us-ascii?Q?J8N7tlbPmRUJ7ug58ezAwnT3y3Gu8O4mUlradnQXRJkGoNnW+ydLEwOJrajQ?=
 =?us-ascii?Q?cirDEgTnePq1yfNVOounjtazOqblWZQDUwIOazUVcR7G2BFA7g1T1l8MHbJD?=
 =?us-ascii?Q?wEpglolUODs6mICYsaNDKn5fBZj9HKN30PlnH0UKbH9JZlU0+E2h50K1/utq?=
 =?us-ascii?Q?ALUgLs8Y3EZPFuOUrOzL9g2aEwEOkaZGAMJfMHupVYNyIFerSJDnr0RR5WHW?=
 =?us-ascii?Q?4g9GRUY7En6UIr2WSeOPDjNrdmpleUBpaFTIi5kvJtWQHRAc22uAbluX4piK?=
X-MS-Exchange-AntiSpam-MessageData-1: h2luDol9nLx8pAGa29Av55llrMw7pvguTF0=
X-Exchange-RoutingPolicyChecked:
	Qn0i/3d3b9LlTvdFNj0BPC0akEANluI756SZ6WtvbFQjYnIor8x6Dk+jQCuara9cUVdUhOVbNPhuovRSCrWwz+5yzGjsB1S7ehfEMeSWI40Xv2dHzkAOF+BFrcao+ULWkelLa6GSQO8mjN8GoKHumI0Aa0a7SZsky2t+W64m6OV4DzQGnCcGt/WSnzIO+tg+KrwK8cK/UB8cDTiMZRzExt63BLjGNs10aHwi1wTGkUxYvmkYGr0wLjhoc8fuU6/Juz8k5NBl/F/E3cT/jDmvSWvpcdsZg5UC9WkyzjmRDdiYE74X/ogNNZnkJ+7PAAp8CJnptZRY+MH9Mm+JbgiUWQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	R/RGLwyZ4mAfBXJnIOLKOINxCeTm5V+cFfLY8hPiQ2JVKLzKn5L7ZiVNFdyUAUMwNQeCp/R3jFlrNwWc5gfYHEFIrvXPXeUxLwSsVj2FYkryvQYJCldzMnmusOWemGcC4aRvXBCVxgLS4NzjoOrl/bQD0y/5nsFtsGWF8RTlxRbwznN046XRjXPK9HuP8/fNHC0ZRWQuc2Zae6zTKEQz1yXavX/56yFga9IbBfteUvJMj/5UVgeaiwfh0xsUUiFRIs5MGWtorL18oNl+MBm7XTH2Om8iz0H8v721K1hlYWh7d/4Ns9xNuw69Nnf4Af4tymKCvb8Ywz2D4a07i+lzyzTeXfc62TNC4Xhe7CNVvGxvyIcmnMHh4CMNisvGDPIoyJbX7WIwc9rMs4AGkQsnKVQeI6rh0W5kLPzlH+w4ejDtKahWRFVedfWOimdFMgdGnvFqLckXavmgBFJ55bYvyfLsHTEGbREDhKzcHfMAkAHGlI5BBoHdjBgKQUPg0N4qDqDMoRknIHC0P1C+88sLN5OCUseQPEQS8eotgwnodSMe1V/25YOWH85y0qdddQD2R/FZomRltf7hpuuBWv8etrWaR0bI5LiVXawo1Up5G2Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1714afd8-40da-4ed2-c54a-08df290dcede
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 09:38:59.5067
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GH6WdRZGk5cAHsQEIUQ4fJci/ls7t206TbNsBeZrdyuRFwHz6vq3iDPiRsm/DA8oDGegHyruXHOeygkHQ1wFTwiRQ+PfFeUg2QY2+LAW4wY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS3PR10MB997725
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 phishscore=0 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130038
X-Authority-Analysis: v=2.4 cv=O9SsLx9W c=1 sm=1 tr=0 ts=6acdfc37 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=kGPDooFuvBrjL3bSUbYA:9 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX6y/5lFA+uV4g
 S+zxUzmmZNVRANMQ4vK+M4rk8oGkxvb7IQYy/aOZr2uHQjPIlEAUICpmupJ21alIjux2iT8D/TP
 a1W4FXDocZr2sBIgPP7nWoBT+2w0LJoQJ9Nm63s9CBG1eReQ6gpV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfXwsGYaaSOyQ1N
 M3qimR682/hoCjCx6P/Uk8S22hvcoDGc66aCNSRm2zar71CUGfTSA7i211YU2KByVWOa9YzlQpu
 OUiqBk2BxCC8dFMAEh5OgAhc6PWdkKwt+R9hR8b9r8zUutcr2k+m4mXWAWn3Dcee6n4qkMfVglz
 4SamRBSn3E/AKhui42LkrtBxZr1xg+0P04cmndgGxHFBpTN1W7mU6I4ArT7muwzD/lW+4phwcg6
 AldTW4JO0h7JgF6oDcx/KYNb0WPj0wCwd4nuHLFlCC+RXz4KolTg77cVZiDf+rv1PzCfyxnsosb
 KMGSK2Jm3rBW6x+2PVWocwsHVJOIg7ISaoDPZW42j7JjlLRurz6Wba4VC/t3Aucqq067DRukczY
 wgu44IdYFY8tVv2tkl9YkDuSLinreV8hKgudD3Akd9T6pNX+bUnsDmj8VVQD9xZxTbjiSRxBzWy
 cWZl0jJRAXQgIuf4hzA==
X-Proofpoint-GUID: xHoO15ngQcylnnwFAuejC9Fg_ymytVJo
X-Proofpoint-ORIG-GUID: xHoO15ngQcylnnwFAuejC9Fg_ymytVJo

From: Dave Chinner <dchinner@redhat.com>

Unmount of a shutdown filesystem can hang with stale inode cluster
buffers in the AIL like so:

[95964.140623] Call Trace:
[95964.144641]  __schedule+0x699/0xb70
[95964.154003]  schedule+0x64/0xd0
[95964.156851]  xfs_ail_push_all_sync+0x9b/0xf0
[95964.164816]  xfs_unmount_flush_inodes+0x41/0x70
[95964.168698]  xfs_unmountfs+0x7f/0x170
[95964.171846]  xfs_fs_put_super+0x3b/0x90
[95964.175216]  generic_shutdown_super+0x77/0x160
[95964.178060]  kill_block_super+0x1b/0x40
[95964.180553]  xfs_kill_sb+0x12/0x30
[95964.182796]  deactivate_locked_super+0x38/0x100
[95964.185735]  deactivate_super+0x41/0x50
[95964.188245]  cleanup_mnt+0x9f/0x160
[95964.190519]  __cleanup_mnt+0x12/0x20
[95964.192899]  task_work_run+0x89/0xb0
[95964.195221]  resume_user_mode_work+0x4f/0x60
[95964.197931]  syscall_exit_to_user_mode+0x76/0xb0
[95964.201003]  do_syscall_64+0x74/0x130

$ pstree -N mnt |grep umount
	     |-check-parallel---nsexec---run_test.sh---753---umount

It always seems to be generic/753 that triggers this, and repeating
a quick group test run triggers it every 10-15 iterations. Hence it
generally triggers once up every 30-40 minutes of test time. just
running generic/753 by itself or concurrently with a limited group
of tests doesn't reproduce this issue at all.

Tracing on a hung system shows the AIL repeating every 50ms a log
force followed by an attempt to push pinned, aborted inodes from the
AIL (trimmed for brevity):

 xfs_log_force:   lsn 0x1c caller xfsaild+0x18e
 xfs_log_force:   lsn 0x0 caller xlog_cil_flush+0xbd
 xfs_log_force:   lsn 0x1c caller xfs_log_force+0x77
 xfs_ail_pinned:  lip 0xffff88826014afa0 lsn 1/37472 type XFS_LI_INODE flags IN_AIL|ABORTED
 xfs_ail_pinned:  lip 0xffff88814000a708 lsn 1/37472 type XFS_LI_INODE flags IN_AIL|ABORTED
 xfs_ail_pinned:  lip 0xffff88810b850c80 lsn 1/37472 type XFS_LI_INODE flags IN_AIL|ABORTED
 xfs_ail_pinned:  lip 0xffff88810b850af0 lsn 1/37472 type XFS_LI_INODE flags IN_AIL|ABORTED
 xfs_ail_pinned:  lip 0xffff888165cf0a28 lsn 1/37472 type XFS_LI_INODE flags IN_AIL|ABORTED
 xfs_ail_pinned:  lip 0xffff88810b850bb8 lsn 1/37472 type XFS_LI_INODE flags IN_AIL|ABORTED
 ....

The inode log items are marked as aborted, which means that either:

a) a transaction commit has occurred, seen an error or shutdown, and
called xfs_trans_free_items() to abort the items. This should happen
before any pinning of log items occurs.

or

b) a dirty transaction has been cancelled. This should also happen
before any pinning of log items occurs.

or

c) AIL insertion at journal IO completion is marked as aborted. In
this case, the log item is pinned by the CIL until journal IO
completes and hence needs to be unpinned. This is then done after
the ->iop_committed() callback is run, so the pin count should be
balanced correctly.

Yet none of these seemed to be occurring. Further tracing indicated
this:

d) Shutdown during CIL pushing resulting in log item completion
being called from checkpoint abort processing. Items are unpinned
and released without serialisation against each other, journal IO
completion or transaction commit completion.

In this case, we may still have a transaction commit in flight that
holds a reference to a xfs_buf_log_item (BLI) after CIL insertion.
e.g. a synchronous transaction will flush the CIL before the
transaction is torn down.  The concurrent CIL push then aborts
insertion it and drops the commit/AIL reference to the BLI. This can
leave the transaction commit context with the last reference to the
BLI which is dropped here:

xfs_trans_free_items()
  ->iop_release
    xfs_buf_item_release
      xfs_buf_item_put
        if (XFS_LI_ABORTED)
	  xfs_trans_ail_delete
	xfs_buf_item_relse()

Unlike the journal completion ->iop_unpin path, this path does not
run stale buffer completion process when it drops the last
reference, hence leaving the stale inodes attached to the buffer
sitting the AIL. There are no other references to those inodes, so
there is no other mechanism to remove them from the AIL. Hence
unmount hangs.

The buffer lock context for stale buffers is passed to the last BLI
reference. This is normally the last BLI unpin on journal IO
completion. The unpin then processes the stale buffer completion and
releases the buffer lock.  However, if the final unpin from journal
IO completion (or CIL push abort) does not hold the last reference
to the BLI, there -must- still be a transaction context that
references the BLI, and so that context must perform the stale
buffer completion processing before the buffer is unlocked and the
BLI torn down.

The fix for this is to rework the xfs_buf_item_relse() path to run
stale buffer completion processing if it drops the last reference to
the BLI. We still hold the buffer locked, so the buffer owner and
lock context is the same as if we passed the BLI and buffer to the
->iop_unpin() context to finish stale process on journal commit.

However, we have to be careful here. In a shutdown state, we can be
freeing dirty BLIs from xfs_buf_item_put() via xfs_trans_brelse()
and xfs_trans_bdetach().  The existing code handles this case by
considering shutdown state as "aborted", but in doing so
largely masks the failure to clean up stale BLI state from the
xfs_buf_item_relse() path. i.e  regardless of the shutdown state and
whether the item is in the AIL, we must finish the stale buffer
cleanup if we are are dropping the last BLI reference from the
->iop_relse path in transaction commit context.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
(cherry picked from commit 7b5f775be14ac1532c049022feadcfe44769566d)
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_buf_item.c | 123 +++++++++++++++++++++++++++++-------------
 fs/xfs/xfs_buf_item.h |   2 +-
 2 files changed, 87 insertions(+), 38 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index ade89a233e68..a5f3408e213d 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -709,43 +709,42 @@ xfs_buf_item_push(
  * Drop the buffer log item refcount and take appropriate action. This helper
  * determines whether the bli must be freed or not, since a decrement to zero
  * does not necessarily mean the bli is unused.
- *
- * Return true if the bli is freed, false otherwise.
  */
-bool
+void
 xfs_buf_item_put(
 	struct xfs_buf_log_item	*bip)
 {
-	struct xfs_log_item	*lip = &bip->bli_item;
-	bool			aborted;
-	bool			dirty;
+
+	ASSERT(xfs_buf_islocked(bip->bli_buf));
 
 	/* drop the bli ref and return if it wasn't the last one */
 	if (!atomic_dec_and_test(&bip->bli_refcount))
-		return false;
+		return;
+
+	/* If the BLI is in the AIL, then it is still dirty and in use */
+	if (test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags)) {
+		ASSERT(bip->bli_flags & XFS_BLI_DIRTY);
+		return;
+	}
 
 	/*
-	 * We dropped the last ref and must free the item if clean or aborted.
-	 * If the bli is dirty and non-aborted, the buffer was clean in the
-	 * transaction but still awaiting writeback from previous changes. In
-	 * that case, the bli is freed on buffer writeback completion.
+	 * In shutdown conditions, we can be asked to free a dirty BLI that
+	 * isn't in the AIL. This can occur due to a checkpoint aborting a BLI
+	 * instead of inserting it into the AIL at checkpoint IO completion. If
+	 * there's another bli reference (e.g. a btree cursor holds a clean
+	 * reference) and it is released via xfs_trans_brelse(), we can get here
+	 * with that aborted, dirty BLI. In this case, it is safe to free the
+	 * dirty BLI immediately, as it is not in the AIL and there are no
+	 * other references to it.
+	 *
+	 * We should never get here with a stale BLI via that path as
+	 * xfs_trans_brelse() specifically holds onto stale buffers rather than
+	 * releasing them.
 	 */
-	aborted = test_bit(XFS_LI_ABORTED, &lip->li_flags) ||
-			xlog_is_shutdown(lip->li_log);
-	dirty = bip->bli_flags & XFS_BLI_DIRTY;
-	if (dirty && !aborted)
-		return false;
-
-	/*
-	 * The bli is aborted or clean. An aborted item may be in the AIL
-	 * regardless of dirty state.  For example, consider an aborted
-	 * transaction that invalidated a dirty bli and cleared the dirty
-	 * state.
-	 */
-	if (aborted)
-		xfs_trans_ail_delete(lip, 0);
+	ASSERT(!(bip->bli_flags & XFS_BLI_DIRTY) ||
+			test_bit(XFS_LI_ABORTED, &bip->bli_item.li_flags));
+	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
 	xfs_buf_item_relse(bip);
-	return true;
 }
 
 /*
@@ -766,6 +765,15 @@ xfs_buf_item_put(
  * if necessary but do not unlock the buffer.  This is for support of
  * xfs_trans_bhold(). Make sure the XFS_BLI_HOLD field is cleared if we don't
  * free the item.
+ *
+ * If the XFS_BLI_STALE flag is set, the last reference to the BLI *must*
+ * perform a completion abort of any objects attached to the buffer for IO
+ * tracking purposes. This generally only happens in shutdown situations,
+ * normally xfs_buf_item_unpin() will drop the last BLI reference and perform
+ * completion processing. However, because transaction completion can race with
+ * checkpoint completion during a shutdown, this release context may end up
+ * being the last active reference to the BLI and so needs to perform this
+ * cleanup.
  */
 STATIC void
 xfs_buf_item_release(
@@ -773,18 +781,19 @@ xfs_buf_item_release(
 {
 	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
 	struct xfs_buf		*bp = bip->bli_buf;
-	bool			released;
 	bool			hold = bip->bli_flags & XFS_BLI_HOLD;
 	bool			stale = bip->bli_flags & XFS_BLI_STALE;
-#if defined(DEBUG) || defined(XFS_WARN)
-	bool			ordered = bip->bli_flags & XFS_BLI_ORDERED;
-	bool			dirty = bip->bli_flags & XFS_BLI_DIRTY;
 	bool			aborted = test_bit(XFS_LI_ABORTED,
 						   &lip->li_flags);
+	bool			dirty = bip->bli_flags & XFS_BLI_DIRTY;
+#if defined(DEBUG) || defined(XFS_WARN)
+	bool			ordered = bip->bli_flags & XFS_BLI_ORDERED;
 #endif
 
 	trace_xfs_buf_item_release(bip);
 
+	ASSERT(xfs_buf_islocked(bp));
+
 	/*
 	 * The bli dirty state should match whether the blf has logged segments
 	 * except for ordered buffers, where only the bli should be dirty.
@@ -800,16 +809,56 @@ xfs_buf_item_release(
 	bp->b_transp = NULL;
 	bip->bli_flags &= ~(XFS_BLI_LOGGED | XFS_BLI_HOLD | XFS_BLI_ORDERED);
 
+	/* If there are other references, then we have nothing to do. */
+	if (!atomic_dec_and_test(&bip->bli_refcount))
+		goto out_release;
+
 	/*
-	 * Unref the item and unlock the buffer unless held or stale. Stale
-	 * buffers remain locked until final unpin unless the bli is freed by
-	 * the unref call. The latter implies shutdown because buffer
-	 * invalidation dirties the bli and transaction.
+	 * Stale buffer completion frees the BLI, unlocks and releases the
+	 * buffer. Neither the BLI or buffer are safe to reference after this
+	 * call, so there's nothing more we need to do here.
+	 *
+	 * If we get here with a stale buffer and references to the BLI remain,
+	 * we must not unlock the buffer as the last BLI reference owns lock
+	 * context, not us.
 	 */
-	released = xfs_buf_item_put(bip);
-	if (hold || (stale && !released))
+	if (stale) {
+		xfs_buf_item_finish_stale(bip);
+		xfs_buf_relse(bp);
+		ASSERT(!hold);
+		return;
+	}
+
+	/*
+	 * Dirty or clean, aborted items are done and need to be removed from
+	 * the AIL and released. This frees the BLI, but leaves the buffer
+	 * locked and referenced.
+	 */
+	if (aborted || xlog_is_shutdown(lip->li_log)) {
+		ASSERT(list_empty(&bip->bli_buf->b_li_list));
+		xfs_buf_item_done(bp);
+		goto out_release;
+	}
+
+	/*
+	 * Clean, unreferenced BLIs can be immediately freed, leaving the buffer
+	 * locked and referenced.
+	 *
+	 * Dirty, unreferenced BLIs *must* be in the AIL awaiting writeback.
+	 */
+	if (!dirty)
+		xfs_buf_item_relse(bip);
+	else
+		ASSERT(test_bit(XFS_LI_IN_AIL, &lip->li_flags));
+
+	/* Not safe to reference the BLI from here */
+out_release:
+	/*
+	 * If we get here with a stale buffer, we must not unlock the
+	 * buffer as the last BLI reference owns lock context, not us.
+	 */
+	if (stale || hold)
 		return;
-	ASSERT(!stale || aborted);
 	xfs_buf_relse(bp);
 }
 
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index 8a8a46e698be..141c3780a36b 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -49,7 +49,7 @@ struct xfs_buf_log_item {
 
 int	xfs_buf_item_init(struct xfs_buf *, struct xfs_mount *);
 void	xfs_buf_item_done(struct xfs_buf *bp);
-bool	xfs_buf_item_put(struct xfs_buf_log_item *);
+void	xfs_buf_item_put(struct xfs_buf_log_item *bip);
 void	xfs_buf_item_log(struct xfs_buf_log_item *, uint, uint);
 bool	xfs_buf_item_dirty_format(struct xfs_buf_log_item *);
 void	xfs_buf_inode_iodone(struct xfs_buf *);
-- 
2.53.0

