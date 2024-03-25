Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C255D737
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711404504; cv=fail; b=tudL0x8j3Yx0MhWbOgaj91tKSzxAVYwigFui9n3kRyj2tCaq3UELSch0socQh3F20pOXjt3Zq/sWuUSvXW9ggM50X4l99saQySwdqv8YuQHdBppFmhiysXVImCeXM5QMiWntTy2p95A8LbLOMy2RyjfW5C11QBUV9OMElbzz5wA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711404504; c=relaxed/simple;
	bh=JPMCXlV8206KHdV3q3FC2lyQ1FTXFbeAbGNdMV1Ja8I=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Q2FYgaxxGi6oAP6O3RDCNX9ks8fvWJk82Y157l7PcGOdXq2W4ccBeaULhYwHNFkZ1uZyfvlAqCQ9wiP4JS2LVuYuBhJpvGv9H10GcgDQ3luh5mni+pO2a1c1H0wFw5mm5WVMhew/tMRbCItTSEpyNDk5oM3Pl4llKFrohL2zhqw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gYm1sXQH; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=drU/SpkR; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gYm1sXQH";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="drU/SpkR"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42PLFwwB019789
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=RdCapkp5Ewd/yu5KRIjI89apQOsXtVBasfPPPY5MzTs=;
 b=gYm1sXQHO5rQzSW9Sp3gEidFFGtg5LXqSAvdFjzHLdEkc8uKFqAcGyexOQEc5wOlLRyU
 Ma/z4Yuhy/4/NUUAKBxCoJB/AgJnGAHXrFXPhjX8xXJaTuLvpyiANDpXmOcA/sV7HaNP
 bk28vMeIu+AhAdCPNWU0RIEOdpPdMfXJ/PNCB00REaSAS+um1qUHI6rjC2tW9S8zGnq5
 n6bairRZy3NtEeLwBhBwUOd+fhsmK9sOjxatiQ+BnYNNwTET8vQ+gz5cT0uOKmP93dev
 N76QgYoz3Xypw0HXzuwcViaMWndHe0B3Wbko0yCOl85nctrjVBG5wJ0nvCxUUwrM1+WQ 6w== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x28ct32gr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:22 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42PKNtd4024519
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:21 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nh6ccn9-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IrpjZIAkTdEtDsF7cuZJ/AEfo+V+Mg3iauN2+UCt2DCaJvrsuaQk+Z4P5DhQNRU6B7nCdPCj2vwewgDeNy1XOPyIhfSHfIrp0VaFuOe9T6ScDrdzx2tJNplZmPGsXEUhLnhQVsSTHEFVYp15PCF1t8QSfxVxPmYZVQ6ypp6q6ruNBVI9fK9g8qsk/yih7Gi4tlwnUVmheAKY32y8Aw58jKVc6Tm9QSJu+dto37Ydg1b1oUCdnjR+woGDpv+6jZQVkhhOEb4nKBNrCfzTdoygikmYWXrLekDNqeGunZ7HH7LKLRMjXQ/GKH3gYjuxc+suz04KWpoUsJdFA/EpAhX9MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RdCapkp5Ewd/yu5KRIjI89apQOsXtVBasfPPPY5MzTs=;
 b=jiMCWFzbDPLCpVBBya1ZBOLmXr56RX25S4eetSWAWYfulGKjMb6exn0i346s5MJQxzjP0GiRw8r1CIaKWl2b3R9WKZY6mp3AMKDSSivdtl4dnW9ZI5qipkywikOq2eeX2zBm3LtCyZDL0W/oSr+3aV61/0FEUq/WaAETQHZZDhs/CPIrHyIPefyjjMllWYDP9iK8wm/SQMwQlen8N3yR8L6xmZoDETW17jvZij/R8OkTAwN+ishAXT89HBqIoGEKYFlEYt78WLbqvvn6IdDHLdYiW/UWfsFDlasgU01FBwQ1pib/D76oEtf4Q/VAOXCCMa05n5sx+BV2zfWh1ziHhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RdCapkp5Ewd/yu5KRIjI89apQOsXtVBasfPPPY5MzTs=;
 b=drU/SpkRZQhw2xvSyaL/iwUtJ5Ppyq0VoLKrqpEH3ZY8J0UlC9cn5ywcPWIdhspGIfKUnNg2Ba0vRdujlLEst23xzr0gU+X3rNA5p71qyVmfa55QjMWvjc03BhHzepx5Y78TZjEdZt84bAy9bm213nF3ZRxEquuzA1pFrEJYrUY=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DS7PR10MB5005.namprd10.prod.outlook.com (2603:10b6:5:3ac::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Mon, 25 Mar
 2024 22:08:03 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a%4]) with mapi id 15.20.7409.031; Mon, 25 Mar 2024
 22:08:03 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 15/24] xfs: force all buffers to be written during btree bulk load
Date: Mon, 25 Mar 2024 15:07:15 -0700
Message-Id: <20240325220724.42216-16-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240325220724.42216-1-catherine.hoang@oracle.com>
References: <20240325220724.42216-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR03CA0035.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::48) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|DS7PR10MB5005:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	91S33lIFUN+vDxgEbg0l33bPexSgw7r/NDbuu/TkGx1GHrS8Ff4hNJeJ9g7dris60ewUWSp9z8i2fyMpb0Piqjvr0CpgiF0oTGo82agAw/bQJYX32gerbmlTj1DiObXUmSIR6mKAslJPOKDA4vYTh4S+OQVMDqCfpJ8VkCUXCVzGsFFeyiBWInoTfG0IKs+pS6caaXr68QOK5eZ9eI2VfGsazobZFzWjy0z7JtKjPHb/VHLQXFkCnyQkUnceLegrHyVEUGQpzT70S+HKxj26tdhTs35qLW1F7f0cfUTVYzRsr39vqEuhh8euFi/aECzVoo/AHXpYoYT0JHL8up2NqX7rqxEErt28buOcSzm+uhli/ziWlqlFbs4tBcfzLbiRZB8s+6xYpp/JeMq4zcG8QQmI0/mBW34G+HdWTm1KUe3ynnNa4YItDxaZLI5aCgEr3PbEdspmPSXBMHPSS5rRMCCY8pit4IJ7exJPGXAxM1cirTCT5gMYhzAZ4ceaUXkGW8m9OjbIAn9yKxCkSyyqESoJN/dq/ZofuFWZABNFoUOA3pbjrIL7lLLB6ayAynlCinYN2aUsB3lMQLrQRciODAzt3AXyn7LYi32ZZGuzYy2Ukom/RN/R2PzbrzZw+aFlK/gtcmbJXz0WuNIsvYfBMLA2v6bTGkQIyu0THGrg0YQ=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?+Ir5VRiTEEDTgo0Pfs+fs8eDkV2A9CVv0wGJwyH9wf8S11uR8R7+mY+X9DYd?=
 =?us-ascii?Q?XSRj2EPphwp/kK8arO3sDFLrqPaIuk+RExsCIV0k1kgHO/pUe1eLUejgl1MN?=
 =?us-ascii?Q?yAL02i+UoWHWR+alO5IhV2xur6d4zE6e7LX0iYW5Ip/SUZpu3u86ht/OE81c?=
 =?us-ascii?Q?XjjiCjQzR4pKaPrsgY8PkZmVcs5NY2QsoDJfUfbw6iAWnX2opDuZ+BgAG9ma?=
 =?us-ascii?Q?hlxaR18Da8F6agX9ptgozfPedW4LItmKIHdsOD2UmyAL/+51zTq3y9l3ES9Z?=
 =?us-ascii?Q?ufJVbU0fStsNkQDwfoccfGtkQjl/p+GD7kePs/wd+zz/b1LmGdVTQ346zQRe?=
 =?us-ascii?Q?ZdBZDF4MGc0ua16zrnX6fctFZZiTOl8qUJvXoi32tkTePuLR3x3aRUci1OEn?=
 =?us-ascii?Q?bAxvrFlo/6lRoK2f6e7KICK5yDaDX8zEcgIbyLCKyBt21vPbEZUnnXPk9dE2?=
 =?us-ascii?Q?hO3fZ5fLi8BdOLJfL2Nnj42Z8j+9AwqVz0cFTJMnDuuTp0gqmX4VOQBvjo52?=
 =?us-ascii?Q?eBb0zzj9kW25M4m2UgNKTKzDyocVRL+i47Ie3oIgfo0aS5fPZxZcUrwBfwwb?=
 =?us-ascii?Q?PVaULtAuoGTJ8Q6w1l2Ev6XTFJeTKY5yia1WsYJLQaBm5Z/VUk17vqEwfG4p?=
 =?us-ascii?Q?EuH1shuQ67fTJHEOs0sRz0tJJkLZ+SspeB++pKMdP08ILw499K3U4V6UR7fX?=
 =?us-ascii?Q?c9s+WI5k1O91lvdnaISxXERvYiRAgNT0r0FWKVfBmmGxiMVYzXk0Iv4yBJGm?=
 =?us-ascii?Q?xPJ/wCT1JwI0fxyIOmA4aR81JieNqH+Uoutf0Eu9cPBbsshARDgjWXD3ljAm?=
 =?us-ascii?Q?6w+WsWFwALBWpasQoTCqlKP8rhG8LAMW2MOX2IXZtp0z8iSiS8v+/kz588t8?=
 =?us-ascii?Q?a2QqqlwKue1JMccvRMlPDROSuYNULQdkXPBi+7Bu3gwWffg7Z3q8MLoraD2e?=
 =?us-ascii?Q?V0Ii8rEVGrYP3bFlNiM3CfFCLWdAfKm0w9BWbD0iGqTh3w4HyRezM8JPB6nS?=
 =?us-ascii?Q?ENvo9CsqIw5iYhqp/qzufHx5HRUZF6OIJJZHTn8UhmMy/uUbRaPPLZuoKAps?=
 =?us-ascii?Q?HFMHFYxdcffj+5V0X/G2qThYqn8sig+HbvD8cEC2u8WpjpoVq0RvzAmIEFqr?=
 =?us-ascii?Q?f3X+lNIXng2PI/kuIM61OE0YSjOjZDzJDxpbU4AKxUYdJom9die3qzyf/jxm?=
 =?us-ascii?Q?jjClHfLLDlf/qd1TLZtAWCs66jX3gbKv2B0CtgRDEJf2xHk4sw6jK5oHdc/O?=
 =?us-ascii?Q?AXuAcRpVhe7IwnvACU9GIQ37YphpUG8mL5qM+KRIlkx6bZ5Owf+j5TllxYyL?=
 =?us-ascii?Q?fSD5PA5aZQ4k+nDYENOxJjD68IhlwvGwNpyzefJ24SwgxbGxwVH769R/p/0Q?=
 =?us-ascii?Q?qFFvmctfvDi8xpT8QQj09wq32iupRUnmJ6ZFYI91rpgC3ni/v0RzlEMO4To2?=
 =?us-ascii?Q?Ax36G4FYqwVfPD4ii0cRsabwY1sEqUTfUVbVCasX9ho6BKFJ9NvowgkMd2Kn?=
 =?us-ascii?Q?33o4BF6KqNLQlirpxhqUOkdhalDAcn7MmWsaTUD9isNnf+h7oypcrxyPYGbu?=
 =?us-ascii?Q?NL3k/GzBeHqUKGcl1L86olsni0aAna0vfKfH7M1O28MdCGIIGfYbbkpHOQ7F?=
 =?us-ascii?Q?yVcXtzDQiSdFRpBHBP68b/26Kx22Fq2XdVCe8A6/GDIYQdt1zfDrY9Q8hjSy?=
 =?us-ascii?Q?yB6PIA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	+xohphjo0BY7Jl3MZrwvJOiaduR6yNlcCV3KRZ84X3Eya22uprMQE7+0hNDpvBlm74iMziC42JI20TfopVsmLm0RiuaGBuGmBqhpnCYCRK+dpA4Q2/CPdIg4NMEqbNXUNv1/7NMTMH8gH+JAv8GPTf8L6tfnL3pbsTtNA5l6hWkPosuY4+MbTwTz5BNqK1XRip9QnxXtMXcb+C2s6qMO21gwrEp8WUAbKOyG9+u6EyKtYuq+a7imRUUJuHBUCF5D0wUQLqGzs7mc6bVSli5aJV2cy5pyg3tZOrSDTJquVbk57VKHjghRZ3HA7gPI2116M7j88e+W2Y7mI8R/w81uw7Il1p4KGILnq1jkeEqqqQOUCaFCQzrACB+qmvFIibb6qqWUtvOReOdXzM5udvpZIItSgSlokiFnTBs09JyaDei0TvgUQNBKMqgJRzihb4JkZcwWj9yJ4TbQt14rIfFLwj8D9BNHx/fNfr8SesA7pqL5XYKu115LOA01Ld2EFqptlPc6FT+180xWSH/UPXftTVOtHSSnd44yVhnyvnJwnw+CY8ExlnfdoJp1KVfDo3h8P8Cjtq+G/2P/02/iYwo2hL/EJ6sAYPBfD1+RokNO8CE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6eefca3a-bb57-4ad1-8af0-08dc4d180a81
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2024 22:08:03.1846
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8TDncN9bCG/ix6G+oUlxfVEQDutYZTAQwJ1PL/7u01FbSsJHN+XdffAdVJdDkZN+P80DTggWSolouC0boB+sGhI5aAbk/3MDeNGEf7HWpFg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5005
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-25_22,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403250138
X-Proofpoint-GUID: SBo5XQR_67stZS-DPtRDZ8DGhhL1p77p
X-Proofpoint-ORIG-GUID: SBo5XQR_67stZS-DPtRDZ8DGhhL1p77p

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

