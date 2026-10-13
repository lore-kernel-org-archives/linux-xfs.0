Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84DF13B47F6;
	Tue, 13 Oct 2026 08:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791879256; cv=fail; b=dJKwbjWyEdH1np1IzBYdC0oTvaB3RYMStKh+ojWjAblj+AoCmvtwbgha26E03JqHHCcQDXaqJzr/aq3xmOe7/q6DMRQNu2Yo4W6ccZYzVhA5B2zRWrC6JMeRgSA9IxcEXAP0Y6CBsq89PbdVFB4C2iULXYqG8N847nERml5LLfI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791879256; c=relaxed/simple;
	bh=dU3I1frWa6GdSKQZ2FLb/qnGYWs0epBH8+83LEIgbW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rgRWblZ2HdH7yjy3gSUj3SXFxV3sgTHTYzmiLk6RKqU6pE3gXO8tPKBDx2eqtqGIs8ErroXqkngylP1fb3FffjjNrawYfZkVC9Bjqpck3ZJAqXw5Q/lyiUqf+50Ght6jDd4Ki198zZxyVDs8Nmw+jgXNy4ehGWYRMG1mJGLDr3I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JfG8ibMB; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=OohDPeCU; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JfG8ibMB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="OohDPeCU"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2D1jU4063533;
	Tue, 13 Oct 2026 08:14:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=JpZVTqKMj3ulw2FM9NomKk4QUnLYr81GF2q/OvqnsS8=; b=
	JfG8ibMBtvanF/DLO9yuKl6v1zKBpbkMyrpOlVjxX80T0KmfS/ggM3RnIwbeyYuJ
	XLyyMMHNiED9E1fCcQfod7Lm18xZQBNrs48UlB+IMOJwO6NlKgpDtT7l+pjd4A87
	AH4bOH/xDq5v/ml4dLfKsElD3577nU58k3Bs/UZnOXenwupTCk2AEoCuaX7ShjjY
	lYgOZ5XFa9SQLbzsWthnEmNqf+5ECHYbM3id/rve0juknrgNpuqwSTJsGX8SIcog
	MiCO2FL05J7qqkvRkMMcm9nHbxFXWqqkewBMfnChykm3eec4pbkPtxYqLnjdi4cP
	mvNdYW2wugxFBbH1Ce+3ww==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7dbkkks3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 08:14:10 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D86PF4024900;
	Tue, 13 Oct 2026 08:14:09 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013066.outbound.protection.outlook.com [40.107.201.66])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7bt9aqrx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 08:14:09 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gzmc4UUD4Cy66uv1GQPEeei2gJEpQ+/BzrAT6SwGr5y+q2l2dbgQrNLufHMqvrrWWWiOY5v1kz7+TPz2MZz+bCGc026fBdiTV+wWi7BQxcPJL/Hmn9ErRnfpfC36ennvSW0WsqIXGEqkRH3TNnXk7uonBDsDMfCeYbejLfUUMJOto1mf9awRCDKtU+Zcgl+J3rUn2ePNrCJhR8yDCKsNv6LeQvhHbR3l6JdXfCsh8GfiNunjPSYXk8BvkkvnVID/7txNQqOURR52Us/p95+pJZ3p0YIpVFn1EMOo8oMRo0Rt2NKsAxLFBXdy66ahsvoFY+naEYckW5CtqtR73GuO6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JpZVTqKMj3ulw2FM9NomKk4QUnLYr81GF2q/OvqnsS8=;
 b=l3Nwt4EbWBuKS79Y0yO4TzHdGAJKRoQ9EWxXuweYchz0lVlyuRX9t/9qLY4NQSKTQyDzSjLepei50yBpn2eOvp95C7neEQiQY+qhpWRZG5rfRREDDLbK/ivH838ohfPtcjN/XFpcyAzE1nvWWude3Vt8BG2KOmV1jpD8mo3457a+jn2m13D/JcFN8CGS4gAmLJtC0Jja9K+AeIoAa+eCc4lu+cWPmN5ZLRjKGzW6kchjmdZ4BznjojPFMpZsF4ineg4jIVYXDxPPRJiX93ddFwGjQ6n0j/B8Ht8epqjYhph9nNtwQ3eGjZTHXi5Mvwekg3IQIVO1Z1oR00OulYzCLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JpZVTqKMj3ulw2FM9NomKk4QUnLYr81GF2q/OvqnsS8=;
 b=OohDPeCU8N7hXvWjSqEIIqgq2QcfWvaYxjmoolAtMCjFSAFSYKqQJYeAxMI9TzOiimo1YUWpDIGEOAhn9aBgMiAjGCZP8Tmxl0WEDpppYXBTrCwfKULxRP825LFius32lRm++jeiGDMNNBdpHd+qWlffVWVhTu7DPIlJVh/GGH0=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 DM6PR10MB4138.namprd10.prod.outlook.com (2603:10b6:5:218::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.12; Tue, 13 Oct 2026 08:14:03 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 08:14:03 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 v2 2/5] xfs: catch stale AGF/AGF metadata
Date: Tue, 13 Oct 2026 13:43:46 +0530
Message-ID: <3331ac43922dc7462b6ec7fc56d7b8d1b0caa12c.1791877866.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791877866.git.siddh.raman.pant@oracle.com>
References: <2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org> <cover.1791877866.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI3PR01CA0001.apcprd01.prod.exchangelabs.com
 (2603:1096:4:296::17) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|DM6PR10MB4138:EE_
X-MS-Office365-Filtering-Correlation-Id: 901bde75-caf4-4fc5-e27d-08df2901f13c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|10070799003|1800799024|366016|5023799004|56012099006|4143699003|261009223027099003|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	qI7vO0NY6Fq2Rdk1KEVjco3WTqhrZ/TbHSmtUtGPm+tiGiHKMechqSwPwZVOdop+bjfyOpfXRzWlt0V+tprrA5xfM4pZzwVd7HjWRRXx/lklmGxPwm+AyzkyTLe9kw0Qv3u+lHQDDvoesMhG1u1j6N6DqTghcXlu/X+4gMzyLYV1QHR9dQ134MVOssMr69ECEF5g1mcpdyAI5ns3eLNllX3qIWQ7nQUrGXyRrdpZgMWd67Cv3fnO7dSZdrGXw22GJchIgHe8FRkC7Sc24vV35W0cP+7cUGgbmLGBESAS1PZgSzYoeK+gM3HaZ9+Vip8X7CyWmEV6sON4qThcSNEpytEVNEfCTU2Re9eqdKeQXbT9KaKlwaUsxtW8qWJ8HUDo6dOSadV6fhgz4+yL89l9KVXBVgjsqvVVb8Vm7gIYWVtcyfaT8uLdsTP7AiPJTAtV5c+VYsEz615sNEs5cbdCkCMyZawzD9ZS88QS3Ad/Kj7kVikjYLtji6UF+/ngpQNq2X1D9+DqTjJwpCvRZ8CSqutD211/Kf5TxLL13ybzXF3So+3fKvd2+DzUL4Lm5+KPM9H+sqBoBa+94RYyg9UP4M/d6vxCA/P2PdRpWGbelrHQV7+Zzs6p61echm0c+btbAp6rGxaOLiEj4YXzDphaEKB1rYMKP9GcUatS1KG1DWE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(10070799003)(1800799024)(366016)(5023799004)(56012099006)(4143699003)(261009223027099003)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/sIaZCMJ5uBc2HLRHrseEG2HLIl9hGviO+KWMuJzp9DL966R6w4MYfbIRws9?=
 =?us-ascii?Q?+ph+waslwNFcz17XRA9XcCYIvSieLb+VlQdDhx4cx9HfUl9YTNStRqQ3wOC2?=
 =?us-ascii?Q?gLLzIODY6rIO/S8S8WPLkEU5s/PIu+wnzvFjUju5GfwUWhT71OQKSe6N/RUd?=
 =?us-ascii?Q?+PLvvLl/YJl2bKB5jEFGWSe2wFONqBGOKmjQsfsA8LoIKRII3Pdw+UxZbOic?=
 =?us-ascii?Q?qWzXkn9UaKevQq7K6y63rmU+0EJPOXmx31eRoc5mQioB62GY7/G+ewPF5U/G?=
 =?us-ascii?Q?ePDMFqftCSUDCfCMqKcypfzGHL3eizf1e1bXd3sJ1p/gNSh/uzB+G3qnD1BX?=
 =?us-ascii?Q?C4PDUFvBGvzriyh+N1dv6bYmvf6xL2f5GExhGbNNkDdzI73AC6ucyxGtvYIW?=
 =?us-ascii?Q?yyVyE00BXGhDR1qDAgAV0izwXbiSDgJwCakCY8tKEAS00GjZa3aOgWTRtnZ5?=
 =?us-ascii?Q?H0Sg7t8eb0385r9I0FfFllx1iF09XY1DMuagaqid0zjg15cXx5RHKnT2kWJI?=
 =?us-ascii?Q?xH/hnzf6n9bpJXGbUquAsXD5GO5LT/s1bmuFRxH2cx1sftYjL5EZkiSDv0Zv?=
 =?us-ascii?Q?gcZOfmydE9Kho/z3R6vZtoGl3xqAGhoWEtR20G8gPiG8EJSO8UtpXd+lpn47?=
 =?us-ascii?Q?kbNcRhd95jTFNHlx45MUsM3szeqDoatXSW5VB8B+Qmo0fzU0hQTCdAqfXJMc?=
 =?us-ascii?Q?ZsSc3cIJddZRxGkTanLWpCRSFtUycGkjXHPtLUTSxL56IJk+klUUOaqTQ2xJ?=
 =?us-ascii?Q?+Ic2ZL1MN7+eHdzPYvmdHqC5OC7BSt/ISNW+b2rerQiBTB7ZpjW5iRwt4k7t?=
 =?us-ascii?Q?PePfn3oyo6AybcanEHGNMDOAqK024CSgXoD1xmkjMHsK7CntvaLCr09sgbgQ?=
 =?us-ascii?Q?hS6UpOpD0Ahi7ov4+PMoovQ3WqgFfWSZUAHXWoKea6Ew5xl7RggG6BUTm0fv?=
 =?us-ascii?Q?f/5PKbiNHH0o2k5xTpjqRTpHBADT0js6FGNpKC0T1zEmKLiL3TmgdJ4GOkF7?=
 =?us-ascii?Q?QPRaE+kOLex23mUkuhRmEFQu/S4BJCTkgW8IuHz5f3IvhgC9x8jhUUYzUPuF?=
 =?us-ascii?Q?7+SLajMIJHmeDtr5e+NT7O71K0XpVVbMS7lTwFGQfC4E0c4rO3/1DqBAwnFU?=
 =?us-ascii?Q?qTrcbW3fEox1BMmCK/nKDammTjwGaBVzzIGj+G9H5Ws6rVxuPRkmY0McYOeU?=
 =?us-ascii?Q?Baog+JaYxwz9GNe8gfdCyxNJcMLx3Kv9SbwpbomzCPsdfLIl0UFdl7rzs/5s?=
 =?us-ascii?Q?KWSJ5Pl4v2mz2rs1gm24rzZStjnjfO+BH0QdUoLrqJxdc+JLXPWVEBdOdAYm?=
 =?us-ascii?Q?JqOX87+f0oZQvKJE1aUAF05Us+nGzdLGQtU6YMjdBsLGIwVTDjIyt3bBiDhv?=
 =?us-ascii?Q?LiAkizvbxx+mawvTjN8bJ2tL270zM+I8oU/2r8tMVpcHD+7AQebIDeADQ3iQ?=
 =?us-ascii?Q?iZ+Vn5e5sSHcSn5zU0xrsGxYaP4pdh+eNjjVwUzyocgp1VQXCUtty0WO7AvL?=
 =?us-ascii?Q?KQmnmrTvZTKMmz/z+84Y8QJZge7rxvwuQ8Hkt95zG16uZYNRAjsEndsqDEgU?=
 =?us-ascii?Q?lY/xA1sXhzXR6Hcne+5ucPy41o/eu5oobLxF+A2j2j6AgCRsUiwdpB48xMcN?=
 =?us-ascii?Q?3nHRw1U6gwaE10rN7q1GLxuG3UpMGqwGPt9VnQp12JqOIShFXjjLrMBoOibi?=
 =?us-ascii?Q?7mGdaYqPnEc1L7Gx1MKIFz0lsBT8HGHmffaPlS6cKNTILV3r+PfaKjKnItko?=
 =?us-ascii?Q?bI8YHDT9iJHmKCqEPygtYEqmRAaLZ8LQivRIZUtk+yKZ5YRa2ztiQlbJ2NBI?=
X-MS-Exchange-AntiSpam-MessageData-1: NmSdS03Q3Xw4B2Aox/ZEHeqHCZHpINPbDHA=
X-Exchange-RoutingPolicyChecked:
	RaUAAsMgz0FSo4iSyF/WqIgoLVfOICO5bVzsYHSRAG37st0D9+XHVQYsaj+uJSg5HIyPIxiKGgzoNv3aYf1zYrpd9i0FsS5lpArpJKhPPKah5+8TruwfLhMVCzV4XmBUGETk6Y+vEGZDfTxwO7Xjtv4umpL+J7DMxemwOkYEdyfWeB20+crxICLuRQzRa+6XsBzBxKHNnNf/ysr9jORpewPxAOyRekH8pvZeTkEoN68L6Lnj8os+UB3l0kDR7eJnYF+fbPAh0bb0N6wVZvlTwZOKagueUA+SrQW8/UIVyiWYiXgUA+xOe84fKSGdJzPL4w6RBMat866QfVGLdq5ogg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XqMWE3y/ZGadXXCZg+syN2DoQLyAJM82GAw0oXq6zPecyw0N3jrJd83VFtGWjaha61POB+e5hbJwMLsj6HopGJnXV1Rb3eYG3cMKzQm13gP5raRuAbQjROJIx72Ii7dJbv23QPQK3A4DuUCbBqADl6Qy5Hb8LEeP2LnKazW9GyCiGbVkCjMg8Oj0GcFOM++udFUk+F1XQwKZnwblhAVHOiuz4+cKIl6FpbmZpa2hZg9gVKhpLJjsJaO7kcm+/hFN2DXAo8AjfLyld5BS3HZtbqr1GDoaTNoIBshd4Htou3dmyCrRclQkIUKY2klAmu4QqKAT7Lzhv7FJTqrq2As9p84y7s9dzuE83/hZ7DPTp/1j771ilqm7w7nCjiA2SWYBxW4p+REBEjoUgfT7NngC8lisfAdpCYKyhqXqRWzgQLvtl107JIFxTjfEzygIzVolv8dY9d7efBWnY5022W3Q5FPdknvJHrDLqIy7msvZlZdWIz/RPew3SGYCBZ90eb0bpmFBh4pPQDRr7qAxUTVBzCStsl3sMVMEBXHAi7YsyMofOsXOz3HejLcbYBegGvYNgxyQug5J8IWoqwat6LeccJXmZU8YuABqLd8z8njjWnA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 901bde75-caf4-4fc5-e27d-08df2901f13c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 08:14:03.1936
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tAG6V6sdFbYoczyYTc3QmSXiqkjHM/0Hj8sysCTuavO5Nk3/D3REKZqyfNe5RqF4lBLYK56vQEQmtXdptfZVOLo1p8l1Z/Wk6SLWhJE6wOw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4138
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 phishscore=0 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130032
X-Authority-Analysis: v=2.4 cv=Ra0FmFtv c=1 sm=1 tr=0 ts=6acde852 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=2l8DqRWQ2dbnbHYYE4MA:9 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-GUID: RGbDjrsithT9tel4jEP-cJ3i_NGmqfw5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX/5k5mB4e4gOu
 h52+nC688N8/zX95+yqKt/E1usZP14yvC+X41J9zY9o6XhtnhruVwfxTavxDQF0WdzstZiRSckQ
 tdRW6gtreD+QnQzGD1jvDCwZtaht1bHhELGqpmVXR7GFnAnM0sRFvgTrtBPNuFG2pXJRhbR9EhJ
 vMmcTpMncQaD8SNObywIa8jc7vsteLHpkv3ak1X158fjTVwdN1GNm6L6xUk8X42q7yu8gtVgKL2
 AU523DlP71paHshNDfdW1yUeQiYvdIE/0l2HFwUyKpPYePJwStx8ayD4lP4K8NreWl7p2bHxCnF
 Q5+laW9rFEiL/cL2pFp9nzhwFUii9JjGjXzc2VNJEDoRkUKHPCT+MB5dRJIxt4UmglVFMomGrX4
 YkYZ0BmKioj9uvmz+qKla7FcJKpWiJK1m6JFHUl2wNvpUl4WLcJqCgCQUIqeOwNGW0qPnjmUvE2
 EhBkwi4B/I0h/pGtgzw==
X-Proofpoint-ORIG-GUID: RGbDjrsithT9tel4jEP-cJ3i_NGmqfw5
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX9HpxSDrE91WZ
 dRCNWgXjtVKtv6JfQ3sDaJtZlL3pPnh4I9TexDKz92JlqGKMAM/PdXcrEqkQ0+ASySaoLjdw9+4
 RyCmvnN/bsFF6pCn7JTLgRiXj0wNcQSYnyv2inPlwyS/IkfPEUKX

From: Dave Chinner <dchinner@redhat.com>

There is a race condition that can trigger in dmflakey fstests that
can result in asserts in xfs_ialloc_read_agi() and
xfs_alloc_read_agf() firing. The asserts look like this:

 XFS: Assertion failed: pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks), file: fs/xfs/libxfs/xfs_alloc.c, line: 3440
.....
 Call Trace:
  <TASK>
  xfs_alloc_read_agf+0x2ad/0x3a0
  xfs_alloc_fix_freelist+0x280/0x720
  xfs_alloc_vextent_prepare_ag+0x42/0x120
  xfs_alloc_vextent_iterate_ags+0x67/0x260
  xfs_alloc_vextent_start_ag+0xe4/0x1c0
  xfs_bmapi_allocate+0x6fe/0xc90
  xfs_bmapi_convert_delalloc+0x338/0x560
  xfs_map_blocks+0x354/0x580
  iomap_writepages+0x52b/0xa70
  xfs_vm_writepages+0xd7/0x100
  do_writepages+0xe1/0x2c0
  __writeback_single_inode+0x44/0x340
  writeback_sb_inodes+0x2d0/0x570
  __writeback_inodes_wb+0x9c/0xf0
  wb_writeback+0x139/0x2d0
  wb_workfn+0x23e/0x4c0
  process_scheduled_works+0x1d4/0x400
  worker_thread+0x234/0x2e0
  kthread+0x147/0x170
  ret_from_fork+0x3e/0x50
  ret_from_fork_asm+0x1a/0x30

I've seen the AGI variant from scrub running on the filesysetm
after unmount failed due to systemd interference:

 XFS: Assertion failed: pag->pagi_freecount == be32_to_cpu(agi->agi_freecount) || xfs_is_shutdown(pag->pag_mount), file: fs/xfs/libxfs/xfs_ialloc.c, line: 2804
.....
 Call Trace:
  <TASK>
  xfs_ialloc_read_agi+0xee/0x150
  xchk_perag_drain_and_lock+0x7d/0x240
  xchk_ag_init+0x34/0x90
  xchk_inode_xref+0x7b/0x220
  xchk_inode+0x14d/0x180
  xfs_scrub_metadata+0x2e2/0x510
  xfs_ioc_scrub_metadata+0x62/0xb0
  xfs_file_ioctl+0x446/0xbf0
  __se_sys_ioctl+0x6f/0xc0
  __x64_sys_ioctl+0x1d/0x30
  x64_sys_call+0x1879/0x2ee0
  do_syscall_64+0x68/0x130
  ? exc_page_fault+0x62/0xc0
  entry_SYSCALL_64_after_hwframe+0x76/0x7e

Essentially, it is the same problem. When _flakey_drop_and_remount()
loads the drop-writes table, it makes all writes silently fail. Writes
are reported to the fs as completed successfully, but they are not
issued to the backing store. The filesystem sees the successful
write completion and marks the metadata buffer clean and removes it
from the AIL.

If this happens at the same time as memory pressure is occuring,
the now-clean AGF and/or AGI buffers can be reclaimed from memory.

Shortly afterwards, but before _flakey_drop_and_remount() runs
unmount, background writeback is kicked and it tries to allocate
blocks for the dirty pages in memory. This then tries to access the
AGF buffer we just turfed out of memory. It's not found, so it gets
read in from disk.

This is all fine, except for the fact that the last writeback of the
AGF did not actually reach disk. The AGF on disk is stale compared
to the in-memory state held by the perag, and so they don't match
and the assert fires.

Then other operations on that inode hang because the task was killed
whilst holding inode locks. e.g:

 Workqueue: xfs-conv/dm-12 xfs_end_io
 Call Trace:
  <TASK>
  __schedule+0x650/0xb10
  schedule+0x6d/0xf0
  schedule_preempt_disabled+0x15/0x30
  rwsem_down_write_slowpath+0x31a/0x5f0
  down_write+0x43/0x60
  xfs_ilock+0x1a8/0x210
  xfs_trans_alloc_inode+0x9c/0x240
  xfs_iomap_write_unwritten+0xe3/0x300
  xfs_end_ioend+0x90/0x130
  xfs_end_io+0xce/0x100
  process_scheduled_works+0x1d4/0x400
  worker_thread+0x234/0x2e0
  kthread+0x147/0x170
  ret_from_fork+0x3e/0x50
  ret_from_fork_asm+0x1a/0x30
  </TASK>

and it's all down hill from there.

Memory pressure is one way to trigger this, another is to run "echo
3 > /proc/sys/vm/drop_caches" randomly while tests are running.

Regardless of how it is triggered, this effectively takes down the
system once umount hangs because it's holding a sb->s_umount lock
exclusive and now every sync(1) call gets stuck on it.

Fix this by replacing the asserts with a corruption detection check
and a shutdown.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
(cherry picked from commit db6a2274162de615ff74b927d38942fe3134d298)

6.12:

Fixed conflict due to the following missing commit:
	e9c4d8bfb26c ("xfs: factor out a generic xfs_group structure")

6.6:

Fixed conflict due to the following missing commit:
	e45ea3645178 ("xfs: split the agf_roots and agf_levels arrays")

Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c  | 46 +++++++++++++++++++++++++++++---------
 fs/xfs/libxfs/xfs_ialloc.c | 32 ++++++++++++++++++++++----
 2 files changed, 64 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index cd5b197d7046..5bc37f984b00 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -26,6 +26,7 @@
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
 #include "xfs_bmap.h"
+#include "xfs_health.h"
 
 struct kmem_cache	*xfs_extfree_item_cache;
 
@@ -3167,18 +3168,43 @@ xfs_alloc_read_agf(
 			atomic64_add(allocbt_blks,
 					&pag->pag_mount->m_allocbt_blks);
 	}
+
 #ifdef DEBUG
-	else if (!xfs_is_shutdown(pag->pag_mount)) {
-		ASSERT(pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks));
-		ASSERT(pag->pagf_btreeblks == be32_to_cpu(agf->agf_btreeblks));
-		ASSERT(pag->pagf_flcount == be32_to_cpu(agf->agf_flcount));
-		ASSERT(pag->pagf_longest == be32_to_cpu(agf->agf_longest));
-		ASSERT(pag->pagf_levels[XFS_BTNUM_BNOi] ==
-		       be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNOi]));
-		ASSERT(pag->pagf_levels[XFS_BTNUM_CNTi] ==
-		       be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNTi]));
+	/*
+	 * It's possible for the AGF to be out of sync if the block device is
+	 * silently dropping writes. This can happen in fstests with dmflakey
+	 * enabled, which allows the buffer to be cleaned and reclaimed by
+	 * memory pressure and then re-read from disk here. We will get a
+	 * stale version of the AGF from disk, and nothing good can happen from
+	 * here. Hence if we detect this situation, immediately shut down the
+	 * filesystem.
+	 *
+	 * This can also happen if we are already in the middle of a forced
+	 * shutdown, so don't bother checking if we are already shut down.
+	 */
+	if (!xfs_is_shutdown(pag->pag_mount)) {
+		bool	ok = true;
+
+		ok &= pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks);
+		ok &= pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks);
+		ok &= pag->pagf_btreeblks == be32_to_cpu(agf->agf_btreeblks);
+		ok &= pag->pagf_flcount == be32_to_cpu(agf->agf_flcount);
+		ok &= pag->pagf_longest == be32_to_cpu(agf->agf_longest);
+		ok &= pag->pagf_levels[XFS_BTNUM_BNOi] ==
+		       be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNOi]);
+		ok &= pag->pagf_levels[XFS_BTNUM_CNTi] ==
+		       be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNTi]);
+
+		if (XFS_IS_CORRUPT(pag->pag_mount, !ok)) {
+			xfs_ag_mark_sick(pag, XFS_SICK_AG_AGF);
+			xfs_trans_brelse(tp, agfbp);
+			xfs_force_shutdown(pag->pag_mount,
+					SHUTDOWN_CORRUPT_ONDISK);
+			return -EFSCORRUPTED;
+		}
 	}
-#endif
+#endif /* DEBUG */
+
 	if (agfbpp)
 		*agfbpp = agfbp;
 	else
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 4b2894c85cea..1d3c07506c59 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -27,6 +27,7 @@
 #include "xfs_log.h"
 #include "xfs_rmap.h"
 #include "xfs_ag.h"
+#include "xfs_health.h"
 
 /*
  * Lookup a record by ino in the btree given by cur.
@@ -2645,12 +2646,35 @@ xfs_ialloc_read_agi(
 		pag->pagi_init = 1;
 	}
 
+#ifdef DEBUG
 	/*
-	 * It's possible for these to be out of sync if
-	 * we are in the middle of a forced shutdown.
+	 * It's possible for the AGF to be out of sync if the block device is
+	 * silently dropping writes. This can happen in fstests with dmflakey
+	 * enabled, which allows the buffer to be cleaned and reclaimed by
+	 * memory pressure and then re-read from disk here. We will get a
+	 * stale version of the AGF from disk, and nothing good can happen from
+	 * here. Hence if we detect this situation, immediately shut down the
+	 * filesystem.
+	 *
+	 * This can also happen if we are already in the middle of a forced
+	 * shutdown, so don't bother checking if we are already shut down.
 	 */
-	ASSERT(pag->pagi_freecount == be32_to_cpu(agi->agi_freecount) ||
-		xfs_is_shutdown(pag->pag_mount));
+	if (!xfs_is_shutdown(pag->pag_mount)) {
+		bool	ok = true;
+
+		ok &= pag->pagi_freecount == be32_to_cpu(agi->agi_freecount);
+		ok &= pag->pagi_count == be32_to_cpu(agi->agi_count);
+
+		if (XFS_IS_CORRUPT(pag->pag_mount, !ok)) {
+			xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
+			xfs_trans_brelse(tp, agibp);
+			xfs_force_shutdown(pag->pag_mount,
+					SHUTDOWN_CORRUPT_ONDISK);
+			return -EFSCORRUPTED;
+		}
+	}
+#endif /* DEBUG */
+
 	if (agibpp)
 		*agibpp = agibp;
 	else
-- 
2.53.0

