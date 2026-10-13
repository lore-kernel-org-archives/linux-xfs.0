Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 640F9418A28;
	Tue, 13 Oct 2026 08:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791879321; cv=fail; b=tgxcVfdWkQ6CXlmqz3Rv6kuvrgQU8ym4UPdlamkYtAaaR52qICIZG3RCeoa1EUrhwo3ItTDAcrLXSfO50yHiIMhUAgMQxLzS9AElUF4T+tHFDAiwwY0ICCvCHMyPQxKdDewccNW/Edzay22LcS2QEEDYwfiWG9rOMKxjSrTCUlk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791879321; c=relaxed/simple;
	bh=LRko4OWZ8NE4F5QjowLD9QKF7pQifMVCpc+nRbx+7XI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=g7CpiDbvXZJMFTCH9d62est+lRBaAuYurW7cvuyFr5/MABUuD1VCbLjRwMhMCKQTSYPysNaCpwPlPr1K22N4WnRUcIwX7fMd2yFZMicfDLrvMmvp31qN4mVYmq7+2dnfnUNq6vBEnJ4M/GY417HmzoTvhR5otgsvtY/tkaP+zl0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=pG0yWzCx; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Tkjad/5z; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pG0yWzCx";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Tkjad/5z"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2BrsB3200280;
	Tue, 13 Oct 2026 08:15:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=FK/UDjPzV2uVYRf7HkvSA+vIcF9eZazdQv6on16HSqU=; b=
	pG0yWzCxLhBO7tJRg2wqk30GaEoyGZV0VtLt1SbD1hhhqGpkzA27qMqZWCJ0P3Qw
	gKD3Bt3v21VQ8ITxe5s5rbRhdZjA2Zzdnx162rOBDVp2n+Ajzb8EbB8ojzbV+XZ5
	ocUZ3F5N1pb9j33hEfeKK+l94c4/hCSFljVU+GtvyXW9KW2QrHnLVe4ADbwPqOka
	4x2MrVfZtmY8k14vwqrs0hmBA5aPe21AagFeq1YO3Wkp7jFa+h+tQwui1yB5RBML
	dzjsPCelyBIxqwKNgROxwM1R4RLOo8BWB9ubbx8Fwz+kkKGjRgOl3+sBj0JvZUZ0
	OwiFXPaCdG66StDbLViHrQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7demkkdt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 08:15:16 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D86Pht024912;
	Tue, 13 Oct 2026 08:15:15 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012021.outbound.protection.outlook.com [40.93.195.21])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7bt9arqj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 08:15:15 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q0ohIU6ewv4osFRbgzO58Zv8K02PK2laiwG+suIvCpNXKfHM05HnZESTmjxl7L2Hov1uZ3AA4sahLm4x/q9byDDtXvTm7tw6ZTA6/WPIeqbf/Tblz0K1AKYvk4naVDYy6K/cdPBOdL5PeMXU4wt7ps5J34Kc+iW4NeJ2Mh3YcjG+hwhgJtyIeTi4U0XjPuD7kq6fK2Zugc3slr9Vf0DquXCZXj6OQOcXp6vU0gqh9aveIbWotaZv5QCpNoEBK+6TQKzYtOX7tERYooI7gHiETrv4JTgMu969M7VpFji10oxtte750tKcs1dCX12uhVRoejZ5MY/sJBSGdXh7aTcwYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FK/UDjPzV2uVYRf7HkvSA+vIcF9eZazdQv6on16HSqU=;
 b=ZZtSegs0Ni+Xyo7+YQB9Y05qM7N9GkBT0nZnMjd4am6dsnFUlwUKr4eeMmnX9CGWUDXaiSzITD77LqALU6UwFrWypbcY5XxpC9hhLchngKtYYEdqwMPQAnUJocicUWb1qEYlw3HcpLk8be4Hf9GqAh4h/OHlnJuN0k6NpGwA4BGANqd2Umz0HpYHsHsECFhOzaMyz/hE8u3LVYNOgqFung6xEyrHoXG/hlinIoIVqhW+RkiIOJMIjGdBp1LBDO1AhW/Mt5VnYKxA3tBkgbq8XhyDTt4ne+xah7kBKTIoal3D2JjxxBf26TH8z1w487O7CuJ1yDmpjWJh16E//rmtaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FK/UDjPzV2uVYRf7HkvSA+vIcF9eZazdQv6on16HSqU=;
 b=Tkjad/5z2gm0GvGHzEsdG3McD6UrYLTf/t12rJ3pXQJBdHkXBHFtNFHmnOs4M8v3+irQClpvu/99IRjDCWSSt/tk+yO5whFddLArN0y+3GoFAJ6iIXaTRxjG8QpUIKAK2Hbr6q8HSrdJPbKnEvtg3ll661WWDzgVlN9fwt6JSWE=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 LV8PR10MB7992.namprd10.prod.outlook.com (2603:10b6:408:1fd::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.7; Tue, 13 Oct
 2026 08:15:12 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 08:15:12 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 v2 01/19] xfs: hoist recovered bmap intent checks out of xfs_bui_item_recover
Date: Tue, 13 Oct 2026 13:44:45 +0530
Message-ID: <21ad47f85c51f0d204d764cd6ecdf3477a03c55b.1791877866.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791877866.git.siddh.raman.pant@oracle.com>
References: <2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org> <cover.1791877866.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0186.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::14) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|LV8PR10MB7992:EE_
X-MS-Office365-Filtering-Correlation-Id: 5536254a-c398-4446-ce09-08df29021a9b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|10070799003|366016|376014|56012099006|4143699003|261009223027099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	cQ/BWDjoEUndwlLT7qTfdRVBUhbm/Gox/C7Uq6fqOqcBpZlS8MwtmiUQyshGy30xh5VgHin3V4FUkpVfarVu/QjrAm8CEac/7/VbCe5wqYrxdUMuUn65Nh0y3nxrZXAJJA3OzmRq88G/vc+/tHiNjrY2Tn2SQlkEd+JyPgsDPrEQRtp/hVg23TmZduSRfvzWIzANAyRWRXELmUqO8NJMBOjeYOAq3fSQV5dkUV2kwRYwcp12Buwz7Q1Yp+cEosBw0OPcXVEzhvGSm5fXDXuj3yOdkRMcluHVtLrUBsix5nNjlIeeohT7HnBXQHDmNSvDTl2VMEoPWaq3MlMjFf/jQQj/t92H6KymZmIskBWz7Bs/fomOC5ID3BP+2nuDayOf8aEZYe59j2RBBlkGcQmnFrXZAf2osUriuH4nEmamvo/TQaYwYgvlNVBuK/hsOnotoD6qlUWE9W44Be60tC5He9acfV2IJvyy2Q8lSrCdLwKlVAhRrwvkM3JV+eAlrZO/d6FAje/4n6HOoN7nxHKHFGpuFJqwRvJ5ZqjYHh1U1J7ahnd4QuV/0MHXKIPO3tEjruXlrUEMKCEGNAI8vLQxiMrYQ7tH6DyUauYfc+0sPUw1G5c75R5AmChT02Nb3AoaBuf7ON4pyC4+p4+rV2VdygxpeUwmib1jTHumEJgaaDQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(10070799003)(366016)(376014)(56012099006)(4143699003)(261009223027099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/9cWyYTYCG+07kSqlbDpI+bLvMxvT3cavoMQr6EmluBEnuD6/Eg5i4Fn3KbK?=
 =?us-ascii?Q?XZpCqaWwQb3tYklAfPdZ7HpYijjm1/gPy3u1lq1iGuefCcYGVyhqsewO7YCv?=
 =?us-ascii?Q?eJ/tJiF17KdmJ8pY/4RxsPWl3UQTJDeM+PXuplb2w+amngSu+u/mH302R/ln?=
 =?us-ascii?Q?LwerVix3YVeT5/Bwmmo8ZVDQa0gsD+woU5SPr44g/FZbr+bflShPNtLmZkaI?=
 =?us-ascii?Q?YXTYM26YLbBoEDuz+dVoFT8sZa3Ur7bozGIPWQi0JeMcFGc4LF5YpFsXsdQo?=
 =?us-ascii?Q?QUOQb+xEzcokLh59AbtWhZzZ7KHDpRIoOyXy+s2EnVch/4K9dAOS9BMVvNyp?=
 =?us-ascii?Q?vxRzjT0JziBCOW6M7Ec2sjc9LgzYJAquIU7GGPnehXnR9RqWhDrabPgJou87?=
 =?us-ascii?Q?mkW2ZjRRLbeHku2g0hBOmNfGCABUszSZ/Swkd8UsC7HEAJ7tmG2CriClA/5Z?=
 =?us-ascii?Q?FLGV2vRQnrtyyT98ZprlWjtXACN/5s/lvQHogbIRWDRdbreq9/0PilSeiRPM?=
 =?us-ascii?Q?pv+ZBqVZogw83S0hn8TB3bi6b0pP3iAQa6e+wUigshT6y47IVRLCRq7jDvD3?=
 =?us-ascii?Q?LwrW0gZcR5PLtKv4Eiu8bo40wbnLT9ueGHequVCQ34PJX8B/iByiumRmgvIF?=
 =?us-ascii?Q?6/ssCtmVkpFa4JOJJdRBaTgqNpy765LeZCtraQBpi+ospZygxUi3VmJO4JMT?=
 =?us-ascii?Q?df12dt5fKsQ8Tm+s0JwPTCLmunV7FwMz761La/Q/jXlbVRyUCSGlSnlLjP9Z?=
 =?us-ascii?Q?HP7MVh/TZqn7ZbFqBwdQdH2iiWXj3739n5I3UdLlAtBnJ1OV48A94ZQo6DnK?=
 =?us-ascii?Q?hxXkedMimqO4XopHsztXub2l8EKxGupm3uQBSWBYobLJijHbuFNHPedlf/Q4?=
 =?us-ascii?Q?UYebod43t5var3dj6qSJ36X6rlcPNPFTNP+AAzQgJydHAMYSElic5ujA9/Ng?=
 =?us-ascii?Q?jHAEALsoiBTdYmQehuBnXxbfFWR7AB39+Xf2g6NAPYWrNVTqIuBMAqNijDKs?=
 =?us-ascii?Q?JUVpFYfqxvupCM96SMSbId5mmdUxx+D7XGcV/JoQY7d3qOLnpE250kVwmt5c?=
 =?us-ascii?Q?sLwY6p3fUlntHLASKGUD/DfEdqDXikwTq4lZCe76lHtWn750BYQwdbbQv9LC?=
 =?us-ascii?Q?HGSSSePPk3el0/Mm1NIOzVx3a3Zwzz1um1t79gZ19w6xpiv3C6+sW+Jl+9Dn?=
 =?us-ascii?Q?bBtOYqu/uRpBWW5pkewDmWuGFd1tvLJ+GjXCRVGjqoXnAdrRVneFOq62UOK8?=
 =?us-ascii?Q?I9XFhcd2Gpf4uzSgLm8Ql9mCkRVT2W5RCO/UaMdZ5BLfegtTGjKBvUNCTxbb?=
 =?us-ascii?Q?L0i8zEIMq08iyKBcf2HMT8UKhQkcJDvUhIiak+IVLVPnhrenU+rbbvSZpRQG?=
 =?us-ascii?Q?Inm87SN7XqPnVYLYaf/6egJXVHF013s6Vu+jiPRT+nRjByhuVCKWHZnVnntP?=
 =?us-ascii?Q?x6MhIh7d4Bo6rlh7wzaNF27qMis2huZTlWjSsK3YTwQl/PM4kL0pKOl/+soI?=
 =?us-ascii?Q?bl2nwgYOQo0MbdzgVD+HtNK2tJpU+JWUuhhqpepuGsCTxK7cpX8tyHijMOM8?=
 =?us-ascii?Q?byp3dYPK3YHQ647Lc7OITz9BEsKpP/Hi9xraHRULJnCjDyBFlJrO4h+9xvrQ?=
 =?us-ascii?Q?+qmeNdrTynF2+jt38EbnPjtAa+aS+dvW9ib4h/VK6ISykjFdDrvVrFnmNX8d?=
 =?us-ascii?Q?q/3HLt00tVkHuhV6uMVrq7+Wg0LJeZ/Y0VtXfqAfjX7hw9InY6FHh1D9MA8J?=
 =?us-ascii?Q?gd2+yl10Kt6wa9tq4ILaVPvGnA3mFLMFRmMwARiqhIMAuCIwMUGg91XvJ9PV?=
X-MS-Exchange-AntiSpam-MessageData-1: Ix/6sI7e3PZR8EVcDGat5w7FyLJO9brr5RY=
X-Exchange-RoutingPolicyChecked:
	BjxAGKwiK1YVkx6bsgX9pm6xtHqNhM8ZGOXT0kd4ZhTzupU/KrB8TMPGVfCs51Rdc7Wa3puv1j0ld/fGaCbnc5yqyljf1VLC2ftrkOBzpx7JneUmdFFGAGg9cwfXHfFuBqEdXPy86H9Z/Vnm3IZiYaVDXRz/mEyI6jebY6A2q1FmhD5gGDR5VW1wo6uxlpbyRCj2a+QsWELM+zkB7T7Rq39ZNQldRszf+0I5XyroxM6KAzfMmOJmc6Q1X6P2LqE3vJ2w+aABF9wfXKQ9TaSQLmXh1eM8+iLNK/JCpEO0ImXjrbk3hQQblZAliRwPrH8TMWYsTSDJwbH/0Is/rlDF5g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	I5iJcH8CSlsKAIBcon4QPbDZuZKezqbbejtFZqWJlEKHvxGrxmV1T7V9nipfnaODLO728qPotHxUYik3K+E4sEyLBbRdeBagpXLtfeyGCYlBZn4lrFQbvZKRc0ruKcpJb4mfJjlUv90a7rOYd0W9v3SXJ3gI9OV6fVsfjdIorI6kf6XLAeV52Luy3HceVCBrcBtOHTT4RwVu6PVVxMbxABiUG14RTVXPD0zVwXDEnaAYXo/TfMntyVwYjeml09GMxtt0M5ud1jAkVYxvf/Df/edOoVDQseg+QQrAnB2SfkLg7p3eqaXGQDbEobrZFAf0sC6Ag3vqQsFdN9x/MdcunEQvNEVO+2NGaJ32loJAOG/jM4cbSemPIH7Z7SVi8ZVHW5KG9tj246GSLbNsUZt4k1RG+Q97jhax2w65FXeRDtHfdZZ3Tyg3ya5AZg4fk+lbpwg0WgOAoQOtXd0O44JPLC8cv3qlSyu+s1Gh/HBHlPgKg/sdmKMTmxS+e+avEx+LzSDvfY1NYJKBfxGn5JEjyXRzxuBbOexW3QQaA8ggwCGQF0aO1xCImpnZVQSND0POL0qWSswOZSmXM9eXUlRO1822BCZDBYdHvcRZGtFSIVU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5536254a-c398-4446-ce09-08df29021a9b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 08:15:12.4892
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AphgJh1SSfjtT4nYtDOicMhbA0hGfkd0gNtmywf0gQPpryE+ooIJMnUajeAVAYCMVNX2zEVlnLRzgSJUUP4+La2zXpAICvL20Ftzitm152k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7992
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 phishscore=0 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130032
X-Authority-Analysis: v=2.4 cv=CoEq4X4D c=1 sm=1 tr=0 ts=6acde894 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8
 a=enrBDRFgs7ZS5x2qv6kA:9 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-GUID: ggn2rTj0dChKTjutC_sKfDp9Qh3xbEHC
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX1tIBh6WDW1Bq
 waMCWTiIeMGeLoZWLhxbOKvrHiSr0f11h7EbPreMdDh8Sb5BrE2mFPP6w4VP5i2Vxy2wCGuQluC
 yFWE1ISqpwRApIThJWBCFS1b7iVZmJbdmrmhR3LeDT037KAWVbYL
X-Proofpoint-ORIG-GUID: ggn2rTj0dChKTjutC_sKfDp9Qh3xbEHC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfXx5opTvomuAu/
 ErlLFNOOv8WYJlQfPopRGcjDJfhBBvViEDMua1RxbXxlIF9eif5IdHHo6KmTVZnQfe/0ZJXtyWZ
 C1NchaElVBDsgJAK2gmTc2iAH33aG+tsPIM5Ma1Xp3QYdx7ui43nHcXhsffvfilL0os3pG5yVgd
 JybErcNiYx91Uj2ld5mw2/1Ooau8kZCpO/XNVZqaNsc1k8pZSevY6hTdvhQZkkS9BWDJPlw7zdE
 ByswCufPDEt+SU3YF7L1GxR5Lc+V4NAW5NpoxQaSjvlxH5w+RT/To+B1P6Odn6/hoLqvRy+mjSB
 h+AQUiJDJYvwjsNclUEm6HDiFlsQTdn8v0zoUOrvKZTT81E+6y1veuoJhlsm8tbRgoBs0becwN4
 VaA4LbsRmbRgutVONarZC74hJGu0afL6Oxvrm2fhgSEnEq0+NnCSjUPhPXwNNqxsWql7HWg+OXZ
 J4OrZXWMMkLei+jbgzA==

From: "Darrick J. Wong" <darrick.wong@oracle.com>

When we recover a bmap intent from the log, we need to validate its
contents before we try to replay them.  Hoist the checking code into a
separate function in preparation to refactor this code to use validation
helpers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
(cherry picked from commit bc525cf455dac810d28f9edd379805dc249bc5a9)
Stable-dep-of: 7b5f775be14a ("xfs: fix unmount hang with unflushable inodes stuck in the AIL")
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_bmap_item.c | 74 +++++++++++++++++++++++++++---------------
 1 file changed, 47 insertions(+), 27 deletions(-)

diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index a3b350437db2..88d28a862f52 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -418,6 +418,49 @@ const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
 	.cancel_item	= xfs_bmap_update_cancel_item,
 };
 
+/* Is this recovered BUI ok? */
+static inline bool
+xfs_bui_validate(
+	struct xfs_mount		*mp,
+	struct xfs_bui_log_item		*buip)
+{
+	struct xfs_map_extent		*bmap;
+	xfs_fsblock_t			startblock_fsb;
+	xfs_fsblock_t			inode_fsb;
+
+	/* Only one mapping operation per BUI... */
+	if (buip->bui_format.bui_nextents != XFS_BUI_MAX_FAST_EXTENTS)
+		return false;
+
+	bmap = &buip->bui_format.bui_extents[0];
+	startblock_fsb = XFS_BB_TO_FSB(mp,
+			XFS_FSB_TO_DADDR(mp, bmap->me_startblock));
+	inode_fsb = XFS_BB_TO_FSB(mp, XFS_FSB_TO_DADDR(mp,
+			XFS_INO_TO_FSB(mp, bmap->me_owner)));
+
+	if (bmap->me_flags & ~XFS_BMAP_EXTENT_FLAGS)
+		return false;
+
+	switch (bmap->me_flags & XFS_BMAP_EXTENT_TYPE_MASK) {
+	case XFS_BMAP_MAP:
+	case XFS_BMAP_UNMAP:
+		break;
+	default:
+		return false;
+	}
+
+	if (startblock_fsb == 0 ||
+	    bmap->me_len == 0 ||
+	    inode_fsb == 0 ||
+	    startblock_fsb >= mp->m_sb.sb_dblocks ||
+	    bmap->me_len >= mp->m_sb.sb_agblocks ||
+	    inode_fsb >= mp->m_sb.sb_dblocks ||
+	    (bmap->me_flags & ~XFS_BMAP_EXTENT_FLAGS))
+		return false;
+
+	return true;
+}
+
 /*
  * Process a bmap update intent item that was recovered from the log.
  * We need to update some inode's bmbt.
@@ -434,47 +477,24 @@ xfs_bui_item_recover(
 	struct xfs_mount		*mp = lip->li_mountp;
 	struct xfs_map_extent		*bmap;
 	struct xfs_bud_log_item		*budp;
-	xfs_fsblock_t			startblock_fsb;
-	xfs_fsblock_t			inode_fsb;
 	xfs_filblks_t			count;
 	xfs_exntst_t			state;
 	unsigned int			bui_type;
 	int				whichfork;
 	int				error = 0;
 
-	/* Only one mapping operation per BUI... */
-	if (buip->bui_format.bui_nextents != XFS_BUI_MAX_FAST_EXTENTS)
+	if (!xfs_bui_validate(mp, buip)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				&buip->bui_format, sizeof(buip->bui_format));
 		return -EFSCORRUPTED;
+	}
 
-	/*
-	 * First check the validity of the extent described by the
-	 * BUI.  If anything is bad, then toss the BUI.
-	 */
 	bmap = &buip->bui_format.bui_extents[0];
-	startblock_fsb = XFS_BB_TO_FSB(mp,
-			   XFS_FSB_TO_DADDR(mp, bmap->me_startblock));
-	inode_fsb = XFS_BB_TO_FSB(mp, XFS_FSB_TO_DADDR(mp,
-			XFS_INO_TO_FSB(mp, bmap->me_owner)));
 	state = (bmap->me_flags & XFS_BMAP_EXTENT_UNWRITTEN) ?
 			XFS_EXT_UNWRITTEN : XFS_EXT_NORM;
 	whichfork = (bmap->me_flags & XFS_BMAP_EXTENT_ATTR_FORK) ?
 			XFS_ATTR_FORK : XFS_DATA_FORK;
 	bui_type = bmap->me_flags & XFS_BMAP_EXTENT_TYPE_MASK;
-	switch (bui_type) {
-	case XFS_BMAP_MAP:
-	case XFS_BMAP_UNMAP:
-		break;
-	default:
-		return -EFSCORRUPTED;
-	}
-	if (startblock_fsb == 0 ||
-	    bmap->me_len == 0 ||
-	    inode_fsb == 0 ||
-	    startblock_fsb >= mp->m_sb.sb_dblocks ||
-	    bmap->me_len >= mp->m_sb.sb_agblocks ||
-	    inode_fsb >= mp->m_sb.sb_dblocks ||
-	    (bmap->me_flags & ~XFS_BMAP_EXTENT_FLAGS))
-		return -EFSCORRUPTED;
 
 	/* Grab the inode. */
 	error = xfs_iget(mp, NULL, bmap->me_owner, 0, 0, &ip);
-- 
2.53.0

