Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD7F7FF;
	Wed, 27 Mar 2024 00:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711498406; cv=fail; b=Ckaykued3PPk1WQSLb7wr8jMm4/RTW4fOnO995MaKifuVa84HuE4Ez5/a0IedBzOx9b2XWLm0TVyyZ9exS9WM9CExdrVXJwB9hYCSwy3XNBrrrT9VSjMva+/a4uP4HcE5cBWPUJX/kB3ninnwE808XgS3/iqPx9CnZbw6ezfRzs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711498406; c=relaxed/simple;
	bh=97YB/tKFbELBMJIlhJYUmAIMt/j8NViuaVizM7GGzTQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EcL2Pk4AxAx4nVOqGC3gUJy7UsP5v3VETBf6046p2bnw6u9IF6ktNVwca759X6eVLeVZRyqtLlVHXaGGZPMUK2J4m9Kf4T3PaYt6CwVkUR85kfL7OyFWKDfeVq3cqpG/AeIW0N+4ccE4edZV3TpYY6zH1jdfiPt/g2d981JxL9U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=a4ZXiD+H; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DSQHrkws; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="a4ZXiD+H";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DSQHrkws"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42QLjl1r019183;
	Wed, 27 Mar 2024 00:13:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=7r+X4fYp1b0oFbQB+2skYRg2iTmsBki/mmQiC6cQwaY=;
 b=a4ZXiD+HF9CkdL0XKWlYv36H+1GVMjKgAt3JHLAx+p0F+IqV3/6XrxA0zvBiq6fMWcjR
 EQt8EvNyrrDZA1wjzfgcx5x1YE9CfJI1ib17mzat6vm35vfAiEdfvjm/PurYcE1uSZmS
 il6daElsrRERoDcxCJx542tZ7rN92Hco5eZjZfrtBc35/1zH7jJcRKNtCb2NNQxuidp6
 TW0EQfpFJH75JkYNee/izNRkLQIc2jfDcUuhohoAOiwmQhsNMO5OY9zXyVNifXPbIC2I
 RiVOBGsK3edE8NCaz2BQ2Uhwj2kcu6iE7oprR6L/KhzpEt41CP1SVlUknTmWF21F5np1 mg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x1pybp8at-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 00:13:23 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42R05MAk020824;
	Wed, 27 Mar 2024 00:13:22 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2041.outbound.protection.outlook.com [104.47.51.41])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nhe1akw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 00:13:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aOLReXdjuncy+p9T7Y2JnGEB7akLoaAmgRZpKr6dzqCbJQmSSTPJqI3ndnXAcslvXNAEf9wE0xPWIwVFymRO1lq5++xoYYWr1rz0PHsS6i+faPcOfWcXE3LWt3kxmMlwHwGC5EqyPbgdFSO3ng857dPTmERc3gZGmOsqpRekBeZnchSaC/8lHYrocfuDIwcOCuQYRGDE4ivh1brOakN7h+S4L8jQqGxkcjsTVezmjx12KvPBLn8WdX+CTCKAMJVArTE4TjRuCJij1nnrcyGuBGVx+IrK3smGZqYhPidf/F9eQWRRL75xokD+0/cGSKXUdtDfrK79E5xUGF2rIyu0qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7r+X4fYp1b0oFbQB+2skYRg2iTmsBki/mmQiC6cQwaY=;
 b=UdtLXgGL/UZeWbCMVgYb0p2FqjZB0WmBCN1F6iQyMwrJntbLsSVF6QvhKyZ9A3D0qj06bRfoO7kP8jhmh5jPEZ61rAP10C0fip+OIGdkaOt3XXc1bEyM1kQeHdUgdnllTwfW7Gn3gdWgvNDBbPGvvPBJNopg6o+52N0a50S8LHMsFbqG7isrWtcFIIa5dTHx4qzlQtni58jaxKqHTtfjkU3nDsdRzFNJ8fTbsYPXjxSM3JXyCgwXb3eRCuw94htugGBI4vf4feMjfL3pS5n0DxmPSTQIy8wDDqwJ90VTU5f9m54DbZSjggbTjaDD2JJfkoLsUdbdLpU5ZTqhSvu4sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7r+X4fYp1b0oFbQB+2skYRg2iTmsBki/mmQiC6cQwaY=;
 b=DSQHrkwsE2yC2NzVPQWtRQ9IBtN1vrUqxaX/Nj6aUvWdlKhlKrMgA0AkN1dzXKfNH5nbmON9l9Z8E6SVPlTLqON+E8sGNKWWVrgwjC8OSktYnc+Y2jsv5PSKsmBL3glK7pjKO6ME9BzCyDl/LrS4h15LG/XjgMKfYu2aNXJEBYs=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BLAPR10MB4897.namprd10.prod.outlook.com (2603:10b6:208:30f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Wed, 27 Mar
 2024 00:13:14 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a%4]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 00:13:14 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 15/24] xfs: force all buffers to be written during btree bulk load
Date: Tue, 26 Mar 2024 17:12:24 -0700
Message-Id: <20240327001233.51675-16-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240327001233.51675-1-catherine.hoang@oracle.com>
References: <20240327001233.51675-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR13CA0029.namprd13.prod.outlook.com
 (2603:10b6:a03:180::42) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|BLAPR10MB4897:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	3xulnlQRU/DUG760Wd2yLUYZZrSQmJCaeaKuMDj4ruU3shkW7ehQU3heDdpZI4mOWSTA9BW9ZZTgbvPD7Uyi/fs0i9vxYzIoXhS0z2FRThud6cqWb04h/5ds3N/OCX0E0x0k3Fjzmd5vkB+Ye58Ks/1OldFq6kGD3v+j5fs9R+mVGoD+o9O8ohvZaQKPpehoa8IfdvteoqExMuVciMFc3p6KVNPEM+SeNwb9k2AC6Q989joYzfRTCZp99Jw77ci82bwkuAmjxmUvYtnLXm5APEe757BkSptUbwM0Z4Oi8ugbJUMuAxKaotQ7eyaXJKLfn2LQYwMFJAQh2CveTO2cev+tPY7iudQMp+yGznBAdY7jwf3ErsUzOKqRJy66W6MLuGZVp7ksx7K72vB4Wbnptbt3vXEXjPqAFnXi845VHbNNA5xbcHKDaaXHM2yJcN+gZwmkxLNQViNjxz6QUQ60VMjS3SxSlhjNJfnSpmHMF8je4c3+JXPnxCkWMBy56MRiDPx05dbYxOGPA1YRGrou+/3NaGR4w62NUZ/943Vk+8610uKXD/GDvBcgdD122eOC8BsRXBpByllGBL3GhEBb2gofTnrdiF8bfo7vLwAIf4zQBfFjIXwFpo0vnMNS7EjYeKz3eKzT97abNqzlHMNl24WgCj/qQwOsB4a45lWmB3A=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?9Vv5BZe889pLBcY1MXmgTc6+tezkUOYXRYk3Rcanme/HmP3JX3mb8+GC7dCX?=
 =?us-ascii?Q?t0RF6zRZN+y7SctLeEDx44QSelGCJuewDi/610lPd8WXpAE8wokBLlVih98q?=
 =?us-ascii?Q?NodOE8Mp85DNKNuU1Pr2uhbMEPFxltc3W+bXb+W8gob4l5pEHXLUH3/6fQjm?=
 =?us-ascii?Q?Vt4lJ1YO40fJwofExOgDUeU9qRwJLI8iBdDUNEckQG9V25TX99Aj4jjr7f3v?=
 =?us-ascii?Q?m9nQ6vDRKmNePS36Ubfimztm/Et4WZGwQl7o/bIUbX+n4H0xTYP4NQw1Mh1E?=
 =?us-ascii?Q?GjDm5D1Z2VGoF2ywjtM5iKCIWaUp5Hotp5OVwDs20oiBSNEYKj/gfRsgQkuI?=
 =?us-ascii?Q?UaMkGxqKkIwUoK0XtRO+/KdMh0/00/3VowRf1SdKo/wvq3JdLLgUB6AemUrb?=
 =?us-ascii?Q?+JHVH3qzG5a3wpksMWkRnCboA3y1QbpQf1tS7E0d0wfpC8S1iX1cHRALbagr?=
 =?us-ascii?Q?Q0/l5w1vpWOWc0dF6nLHy98cn8MYD4brh1HPAXURQdVw9bUTKv7OmMBoOBS6?=
 =?us-ascii?Q?aWejqvZJ7s3wvPWVeqoM/cbjaJsnhMA63GVFDEkTRHVpipCwHEmDJk5WCkIK?=
 =?us-ascii?Q?Jt/TtKUjV16ypKRCrFkGTMs0s6m8h5aM6na8cywviCVZieQkAxWyR552pnBF?=
 =?us-ascii?Q?Y834t5nxdp+KOVLKDR5MYCs2D1AWOCT5jA843ywl017ETlaZfutxZz9wXqgw?=
 =?us-ascii?Q?9Z6KEx3vlSSNj4ohU91sSSYRxMTJecI5r1x/loKfy8S3umdRYIzWlTfuSUWo?=
 =?us-ascii?Q?LPF+Vm/DWlvmFU5A0nhENgufxJZnxPGLLiyCHal/CPrmRQVlu9vz+z0qtDlV?=
 =?us-ascii?Q?fHPG/0F/v4Edf/1aXMCnjV+w5iQ8ChNzmWUzHpk00NTsdkBRfp36wbdkJIBl?=
 =?us-ascii?Q?+8A6Z1fJ5ogoaOcEBkolAlbgv4f4Nr9GtC3jgbNFDzHpPOUATBmLJMu+WcZV?=
 =?us-ascii?Q?KhWFK6SSrwpfQjAj8hbnVsAY5GX7YCNzQFdNcSPXY0WP4vjGW9pBvyUQUCFg?=
 =?us-ascii?Q?XZJJzn3pGTIDcUxxkRVGqkPCkWDdEMvhikKs4aJ2sGJP+0QZcpFFYWwTjBXm?=
 =?us-ascii?Q?ONp2hgt1WV9dWO5yvf63a3vGOirhE7hbVe1zxRhh5Q2sxBvMUuRMNnRv24Hf?=
 =?us-ascii?Q?NFJt193RtEnF4xE91bRuZWGZifbqL0R/1xJW9U6INCgVzk1pU7RMWF/3qOPA?=
 =?us-ascii?Q?bXY/+JsCkJdb8QVifUWRGLPq2saeFlIu1zOtecM2ef4s6iCEkMg0/vQ1C8xG?=
 =?us-ascii?Q?0EgmM5r5xxWe1lXekuJQp64954IbaYzhWwSpbQP31i/oljM6pSHRoHXdbOYx?=
 =?us-ascii?Q?JiLtuKhbhws8bVKX4tcWto1SLPWEEQkFot0Z2Gx0cAqjJofXJPnnoupRXxw4?=
 =?us-ascii?Q?KiW7Qpm3x3AWOcJaGLZcElLhDbM/bSPaPUhP6Te6Na9bnOuIs9FC1+sFdJxs?=
 =?us-ascii?Q?ULXGKP/i9exgizxXTmRWzLeVLrTJdWfxxs8YUrgQUTJEPht8uUHxBFnP7BOM?=
 =?us-ascii?Q?Dagzhl2F10bwslcMKgOtp7wltvMQ1hV++17XtA4GxpipocqAKg/LiWiVniGO?=
 =?us-ascii?Q?jrmwCbun5fPe1BYBeQVgTiw8JEpVQT5DRIQKnwP5n0sH73iN9Hi6J8Lb2118?=
 =?us-ascii?Q?N6ns0hCvoqaTi3eDqf80FtdWIr/4qLm0aS8h5/zNYWJFGBWr8kjgxfm20O1N?=
 =?us-ascii?Q?nzR0IQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	2Z+AKcAZqPUU0aK9n1dzi3MA3CxjpOQXER5L+DQYNMsebCqRfS10dyBRFlpqer6flGWHDAedaxdmrKrAoK5Llblg/Bo5t6gjAHqwzsEhrYv8PVqbX1SYQBKGlbLFMA02WjjbvxMD+Aw749UVUENb73GQnUMUmz8e6d0tZNQmGUBjIZOWWHxFOV6XdUssuM/WchjJLDjqpGnkeudBc42ZyezZN+5xKOhTzJfhbFBOctVcSWiZHRzrkHRRv+7V9Rnk9Q5shnyibUZNpmGDvspCcdHaw88T5EyAJuzghYBi3L9LQ212hD6tN4PnN6RqSzPUob0yDjmep2erQb2VaNcaiiDXEcO8+HNZLQ6zj6x/iqpwE5zuvIIrk9P6U1gUi2kI/JGFrNo/14VitY9yjElBlEeXP4YqbSY3PITHg3M6T2CilnVZrjYZ0q+CmDsrShG0YhWXSfVkGHlI7aIw8tBolF2iaVpExvaOLYSrXtqKmfTEUulRDhtDi+E/b27O+PSI+C/MnYOjwb8P3gC3SxIigDXwO1ByTSixPG0A9ySklViFJUhRh5/9CjiProRQ1ZmrF4EsJ1wI7cT9dNVHHouUdoXMOxWVLPZjx38E+sZUZUM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5a086de-cf4c-40b6-49f0-08dc4df2b1ca
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 00:13:14.1939
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I5Ex48L4XvX/tMrnOE0IaNOXTpRbk/MdnXOGqoicc1g7wfVLMFaJsi4Np4TSjNa9wazxuJItv/2chxMg5xzzRThlV3Cl2XCWiU5wChUNQlQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4897
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-26_10,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2403210000
 definitions=main-2403270000
X-Proofpoint-GUID: h5AI6QUesCbCQP1WMleP3HY4O9loWu4I
X-Proofpoint-ORIG-GUID: h5AI6QUesCbCQP1WMleP3HY4O9loWu4I

From: "Darrick J. Wong" <djwong@kernel.org>

commit 13ae04d8d45227c2ba51e188daf9fc13d08a1b12 upstream.

While stress-testing online repair of btrees, I noticed periodic
assertion failures from the buffer cache about buffers with incorrect
DELWRI_Q state.  Looking further, I observed this race between the AIL
trying to write out a btree block and repair zapping a btree block after
the fact:

AIL:    Repair0:

pin buffer X
delwri_queue:
set DELWRI_Q
add to delwri list

        stale buf X:
        clear DELWRI_Q
        does not clear b_list
        free space X
        commit

delwri_submit   # oops

Worse yet, I discovered that running the same repair over and over in a
tight loop can result in a second race that cause data integrity
problems with the repair:

AIL:    Repair0:        Repair1:

pin buffer X
delwri_queue:
set DELWRI_Q
add to delwri list

        stale buf X:
        clear DELWRI_Q
        does not clear b_list
        free space X
        commit

                        find free space X
                        get buffer
                        rewrite buffer
                        delwri_queue:
                        set DELWRI_Q
                        already on a list, do not add
                        commit

                        BAD: committed tree root before all blocks written

delwri_submit   # too late now

I traced this to my own misunderstanding of how the delwri lists work,
particularly with regards to the AIL's buffer list.  If a buffer is
logged and committed, the buffer can end up on that AIL buffer list.  If
btree repairs are run twice in rapid succession, it's possible that the
first repair will invalidate the buffer and free it before the next time
the AIL wakes up.  Marking the buffer stale clears DELWRI_Q from the
buffer state without removing the buffer from its delwri list.  The
buffer doesn't know which list it's on, so it cannot know which lock to
take to protect the list for a removal.

If the second repair allocates the same block, it will then recycle the
buffer to start writing the new btree block.  Meanwhile, if the AIL
wakes up and walks the buffer list, it will ignore the buffer because it
can't lock it, and go back to sleep.

When the second repair calls delwri_queue to put the buffer on the
list of buffers to write before committing the new btree, it will set
DELWRI_Q again, but since the buffer hasn't been removed from the AIL's
buffer list, it won't add it to the bulkload buffer's list.

This is incorrect, because the bulkload caller relies on delwri_submit
to ensure that all the buffers have been sent to disk /before/
committing the new btree root pointer.  This ordering requirement is
required for data consistency.

Worse, the AIL won't clear DELWRI_Q from the buffer when it does finally
drop it, so the next thread to walk through the btree will trip over a
debug assertion on that flag.

To fix this, create a new function that waits for the buffer to be
removed from any other delwri lists before adding the buffer to the
caller's delwri list.  By waiting for the buffer to clear both the
delwri list and any potential delwri wait list, we can be sure that
repair will initiate writes of all buffers and report all write errors
back to userspace instead of committing the new structure.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree_staging.c |  4 +--
 fs/xfs/xfs_buf.c                  | 44 ++++++++++++++++++++++++++++---
 fs/xfs/xfs_buf.h                  |  1 +
 3 files changed, 42 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree_staging.c b/fs/xfs/libxfs/xfs_btree_staging.c
index dd75e208b543..29e3f8ccb185 100644
--- a/fs/xfs/libxfs/xfs_btree_staging.c
+++ b/fs/xfs/libxfs/xfs_btree_staging.c
@@ -342,9 +342,7 @@ xfs_btree_bload_drop_buf(
 	if (*bpp == NULL)
 		return;
 
-	if (!xfs_buf_delwri_queue(*bpp, buffers_list))
-		ASSERT(0);
-
+	xfs_buf_delwri_queue_here(*bpp, buffers_list);
 	xfs_buf_relse(*bpp);
 	*bpp = NULL;
 }
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index c1ece4a08ff4..20c1d146af1d 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -2049,6 +2049,14 @@ xfs_alloc_buftarg(
 	return NULL;
 }
 
+static inline void
+xfs_buf_list_del(
+	struct xfs_buf		*bp)
+{
+	list_del_init(&bp->b_list);
+	wake_up_var(&bp->b_list);
+}
+
 /*
  * Cancel a delayed write list.
  *
@@ -2066,7 +2074,7 @@ xfs_buf_delwri_cancel(
 
 		xfs_buf_lock(bp);
 		bp->b_flags &= ~_XBF_DELWRI_Q;
-		list_del_init(&bp->b_list);
+		xfs_buf_list_del(bp);
 		xfs_buf_relse(bp);
 	}
 }
@@ -2119,6 +2127,34 @@ xfs_buf_delwri_queue(
 	return true;
 }
 
+/*
+ * Queue a buffer to this delwri list as part of a data integrity operation.
+ * If the buffer is on any other delwri list, we'll wait for that to clear
+ * so that the caller can submit the buffer for IO and wait for the result.
+ * Callers must ensure the buffer is not already on the list.
+ */
+void
+xfs_buf_delwri_queue_here(
+	struct xfs_buf		*bp,
+	struct list_head	*buffer_list)
+{
+	/*
+	 * We need this buffer to end up on the /caller's/ delwri list, not any
+	 * old list.  This can happen if the buffer is marked stale (which
+	 * clears DELWRI_Q) after the AIL queues the buffer to its list but
+	 * before the AIL has a chance to submit the list.
+	 */
+	while (!list_empty(&bp->b_list)) {
+		xfs_buf_unlock(bp);
+		wait_var_event(&bp->b_list, list_empty(&bp->b_list));
+		xfs_buf_lock(bp);
+	}
+
+	ASSERT(!(bp->b_flags & _XBF_DELWRI_Q));
+
+	xfs_buf_delwri_queue(bp, buffer_list);
+}
+
 /*
  * Compare function is more complex than it needs to be because
  * the return value is only 32 bits and we are doing comparisons
@@ -2181,7 +2217,7 @@ xfs_buf_delwri_submit_buffers(
 		 * reference and remove it from the list here.
 		 */
 		if (!(bp->b_flags & _XBF_DELWRI_Q)) {
-			list_del_init(&bp->b_list);
+			xfs_buf_list_del(bp);
 			xfs_buf_relse(bp);
 			continue;
 		}
@@ -2201,7 +2237,7 @@ xfs_buf_delwri_submit_buffers(
 			list_move_tail(&bp->b_list, wait_list);
 		} else {
 			bp->b_flags |= XBF_ASYNC;
-			list_del_init(&bp->b_list);
+			xfs_buf_list_del(bp);
 		}
 		__xfs_buf_submit(bp, false);
 	}
@@ -2255,7 +2291,7 @@ xfs_buf_delwri_submit(
 	while (!list_empty(&wait_list)) {
 		bp = list_first_entry(&wait_list, struct xfs_buf, b_list);
 
-		list_del_init(&bp->b_list);
+		xfs_buf_list_del(bp);
 
 		/*
 		 * Wait on the locked buffer, check for errors and unlock and
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index df8f47953bb4..5896b58c5f4d 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -318,6 +318,7 @@ extern void xfs_buf_stale(struct xfs_buf *bp);
 /* Delayed Write Buffer Routines */
 extern void xfs_buf_delwri_cancel(struct list_head *);
 extern bool xfs_buf_delwri_queue(struct xfs_buf *, struct list_head *);
+void xfs_buf_delwri_queue_here(struct xfs_buf *bp, struct list_head *bl);
 extern int xfs_buf_delwri_submit(struct list_head *);
 extern int xfs_buf_delwri_submit_nowait(struct list_head *);
 extern int xfs_buf_delwri_pushbuf(struct xfs_buf *, struct list_head *);
-- 
2.39.3

