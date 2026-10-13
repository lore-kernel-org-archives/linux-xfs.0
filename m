Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA58749B5DE;
	Tue, 13 Oct 2026 09:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791884331; cv=fail; b=UeFWHMqkHpY84fAaP4W+v/CwK9LrzFYAGJIDOmOijh8grqazg63YzM4//IDFrdWMOQNZ3vn3MV9OOR95OHQZYx5CBCnodEyVK+2+19CJieqZE39RUO5ZfSbUvl/Yc3ma+RV68Yq4mTb4E0LmWWfX/qodXXINs7GCkrgPChe1Mbo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791884331; c=relaxed/simple;
	bh=T8cO4hypA02piRj3GENJuXzYbRbj2Vc9MN5QefU/4H8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tBt+oMJngod6t2G4Q8H3Nn5vbF9g1mjxtDj0ZfCRWOMzn3ME7uAopjROrnMCbAufks5ETYclH5mzYcx+3qoifZajGHTr8cgjtD+C7dhfbNjBHb06SuatYqscEKY6F1E7M4Jz/wS3SgUxiE2mzPmgYOGTTSdpeFQwVFD7mTMsZRs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Ou3ZidrG; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Tyn4fRF5; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ou3ZidrG";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Tyn4fRF5"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2BtYw678283;
	Tue, 13 Oct 2026 09:38:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=yKSU+vFm57ly7jqu8dfGvrvf0W7RpnMapLxfJ0eN20U=; b=
	Ou3ZidrG/Bt1Zl5adP3ZvS5ERca8BFtjkYsR6t+B8/U0HjrxauuUu+1P3I4RhOIm
	nil5XyXLJH1carkbEZtT6SOceVZXRWApqCQf26T9a2JIe6vUo1Su+s4JQ+Jhl58h
	nve13JODIoHh3EkosUDs+bGAfAJp3JK7i6YlypPQO4+INkFBhEzsAD2HX72dnRnA
	IVGV4NJ1xQUFfwTlFRPM50YBB4ZSTdzdiOaYE5hZLPcsyYJRz7COApywK64UYEYQ
	bROsxiFa7cb2RCmr70OjWBp/sGIoKzDht4sXdhQD1OsPwtiOvI8S/b3lj85KUjG/
	u/83tNKeVK092xDe669drQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7dddusaj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 09:38:45 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D9aTSe010906;
	Tue, 13 Oct 2026 09:38:45 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012023.outbound.protection.outlook.com [52.101.48.23])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7bt9d45y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 09:38:44 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NpmPrClhNy82jn1ajI3ew1Cj+44eGHLeBjeVUrHsR6tvIS/heFh9cqHvgsgw9cRhKPH1j0FUDzVhIwsiyb7EBqBtRfNO3jEeVjVqoBAfFDKHW2egjqQlr8IeLryuyBq2UJj3vQsfX2WWYccycZBe583vBV4rPw5/tgmlBZcxjbm3SNcsWCgWlQ5E4dZBf9rAuFLTebkO8l0fPQfe64NfiFD9uRZMsgyjiKJB8YI/0y2NjDRv0uI8gtSP4kt9jbmPqqthiwU2Ty6sCQkyQeTNHZjBVUipmAp+/hKrafp2H6r1JtiVZp+F/j5UGXcrnrGIlJYqBGkKN8jufi92AyueCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yKSU+vFm57ly7jqu8dfGvrvf0W7RpnMapLxfJ0eN20U=;
 b=vzXxgGBT84zEfEvhm8PsdnlQI9yo5lJYeBSOm7QtCXj2MdfeHV34ZCgdLt+MP3Xq5ahrzDX3T4eDG7qg3BN+e/J2pnlvDqmZiTURoC2QhLQtPdmXkE4RdzmtuBUoHrWwq4qi3pQeK6YBzvhUUS+YRfb4DCa/f0RSte0ZGSOsVjTf/3oYh4l69c3Ow9Xi14EKs8zyOF7oZKwJMmx0+l4OnfOgZ0sQ8Cxo8hoP2CN9rwXYaBqltPaJ4t7NOFYHyRAyKjiujb8DuNwOAMAfOSi9JUXSTXHovUqT74dRyw3RTyJa7bs8Cj4Za9UnBj9FVJOPt6LGX35oj9t5ehl48LYcqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yKSU+vFm57ly7jqu8dfGvrvf0W7RpnMapLxfJ0eN20U=;
 b=Tyn4fRF5oVgUIwWkKvL8yX16A3BckXmvQm3SsOu8E0nYo2S5rvd/EmeXHWU2g68fMxxaeh71WBBLaNYUajtg/E3YDBiBDfV/uBRP7LIGYUabjZ6/fxTsBiwuRwo/+iF4Snp8CD9RDnh59uDaQUiq4HSSkrz/J+IW8oVtIdIoWQs=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 DS4PR10MB075839.namprd10.prod.outlook.com (2603:10b6:8:3ec::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Tue, 13 Oct
 2026 09:38:41 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 09:38:41 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>,
        Mark Tinguely <mark.tinguely@oracle.com>
Subject: [PATCH RESEND 6.1 v2 1/5] xfs: xfs_ifree_cluster vs xfs_iflush_shutdown_abort deadlock
Date: Tue, 13 Oct 2026 15:08:28 +0530
Message-ID: <b114923a5caa85f20a82659bde200d0dad39350f.1791883290.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791883290.git.siddh.raman.pant@oracle.com>
References: <cover.1791883290.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR06CA0002.apcprd06.prod.outlook.com
 (2603:1096:4:186::10) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|DS4PR10MB075839:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ae87c56-6048-4641-f5be-08df290dc3f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|23010399003|376014|366016|10067099003|261009223027099003|3023799007|6133799003|18002099003|56012099006|22082099003;
X-Microsoft-Antispam-Message-Info:
	D3HYWOmEt0s6AcEuFddY7JYU7/XGnNHndB41DVLxW6ob3sum85H6C3KTEJpDyiyEYyubjIo6tDRqwdP29SRLrQa9tyEbgMQ8l4l85SleSdz+pQOdUbI7RcW13y0PgGAxKnHGJmpsBgC+XYYClipSCZxKXZbGyLkJUDBt4bwQllhAbhyhULf25aahk93VSjCxTR+ePJfIAraCmpkEz/pWMSPE5sMej1hmgYzBc9EgO/9GiXOJBnepFI797Bne/MnUIpZ+PpY6/zObrfR57adA5fysk5a5vh/1H3RuXlF2ok6jFxGrHONlxFo3632J3ESLvGWSa4n22h5FrrCtdMe1mYbCeB+aaJ9F9Y8wL1LGTp8MfszhXlJxP56DQ8AipWloAekObQDvm/sqBD9RMcgrbgXII9yALcjXGn+Zs4E2/YIGsvimMC/yaMth/2r+nGZhbkV0769CFy+rrI8NZZCSsQ0yhgjMuWCWtyPJEC0NQZbvk7DAifvarvKbtry6oJSyst/pZixaWWbYVeR1vwObZ6YRut6eHRPc54bU+vVuFES72cK/rC6zKeJZtsyB19kgmX4YVcckoE258kmZxLslLP7u6z9G3+6UxqybXO3i7QoAGWKZDRw3NYc391CcUQpyRAgN7D2YS2JhYxOrLLJKAmLPlsZW0UhQNj2mAXTyvDw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(23010399003)(376014)(366016)(10067099003)(261009223027099003)(3023799007)(6133799003)(18002099003)(56012099006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ksp8q5lp8eERV/zVTXZSIxPuJy+tcX0oDr0XtP+qPdkNr6U4/Jz1cFIv67fy?=
 =?us-ascii?Q?fQOigF74KDdN0fB0LeYP208K1XQ4quSfHUeQbIG06F2NLis4EkE4NRtF74Zt?=
 =?us-ascii?Q?m01pmeSLTKIRM5goJopp1p4rd8oRAwc27ijndD5M0xEeVBqo3MLxpOzf/gD+?=
 =?us-ascii?Q?Hi+6PHZa6VCG+s2S/mGCtpPSOb9zFQz7+qzGhmiiLklNqJdTuKGZj1FD9Fk6?=
 =?us-ascii?Q?NNBbm15cul9+vwUC9MTNkfy1hr9shQFY4dThyrHnWy7SNHJ6bDyJmJOqeHsQ?=
 =?us-ascii?Q?dR2JFXPFsCEh0Cn5UYWUqYgFOAey458HUs8qjiSDfT42gPsj5HQgrztQqAm0?=
 =?us-ascii?Q?nULqdGzr/fHOb8J+pIV5arEZ/00uNOSyQpHmuwYMVzXj1B+7XE6MPDx78Uks?=
 =?us-ascii?Q?wgKaXhJdwbXGcxmvoXBNAijzgIg/PBQEwTaRKm+TobYEgPLcGb+CJw5b3gZH?=
 =?us-ascii?Q?NbqV54XTMbh6uf84PrNo6IKWz/G0ONp7rVdgKHOi8xyiw03pMR57kZ8CAo6v?=
 =?us-ascii?Q?YV2ivcxfZJwDqXG2qqC5rzz+QKUysPQComvfVF0N4ahgecVgZOVktj3LiJLB?=
 =?us-ascii?Q?2fMIr6gvLb84HaV5PFlOAlfaDFw5hgUvfSzUDUOhWllKJuuV9iDVFkNCdgZq?=
 =?us-ascii?Q?qpIZEEP0hwfHstdZ19rKDY4rkbuxtaXaN1V06zXhsYaMrLyJJHfhVZE4oidU?=
 =?us-ascii?Q?62piWR4Ff10wnRLhqFzpvUrpfu8nfrkIt3TatqzZE2/bKmo15L+kVMc3S7iX?=
 =?us-ascii?Q?yTsrIeOyiKtMSYxwt0IY4TaEbo8Ova8AlUm1T/6doVX1SzslnSFQ/KvhiLsA?=
 =?us-ascii?Q?rnEc1rfdavfojSw4n0fbyjSZhY18TGl9TLuB7gcxKHy7QPydvD2jbrvlo2pY?=
 =?us-ascii?Q?9Gy4hCaNpUmC/0JZnKAwLkKCDr2lOg6BMQJBriJX1uYleqIml95hVI32Gxin?=
 =?us-ascii?Q?1RLEy4B8LHB9dSUxdKZkXOUIATUG4684SxFxdEV61ePEvAYG9w/tT9qsrIE9?=
 =?us-ascii?Q?m8dI2BiXlFX1CGfUGiRRRIUZdHi21bwVa32OnYAz9u0yGgrCSs/j54/3g8iw?=
 =?us-ascii?Q?FBouwQileWDGgnz6RGGCJMsZjQlm8sKqICw0O637TPgDkc9KI6vyZ/ZMFkvs?=
 =?us-ascii?Q?Gv5gv4AHFEmRBCB4R8ZIBdpDqEq1jX0dl8fFiWioAtazlx99TPo88eatQ8ft?=
 =?us-ascii?Q?3d4MaIYbSNkfM1rG/q71/ECiNDJRiYlg/ZRGEJRXBf7lDuPVl6ITD5PUSafq?=
 =?us-ascii?Q?K7in28cXA/5lSqJ/hUGJ3vOYxXsufjoQpRTM1m9L08MMRcZmM3gEFmAgcJOq?=
 =?us-ascii?Q?CwNEsbFMfMymAfevXNQXe8c0IC9vy+2zJ9Qt5j9NttSaeZdyTrpsb4KA7Fjo?=
 =?us-ascii?Q?hASItjZLP9RBihO45RihacLTUAA3rNTQKqx2CtP23ZOs7hj3Ys9/lPVrPsR6?=
 =?us-ascii?Q?xCJBac1PlAyez39WD/5WQo1Pm4UCUM//Mm2qspmIRwzhhksxVPM2hgn12rdu?=
 =?us-ascii?Q?QOwlyaQ1vkv+cbscNduX6A7ZFckARGS9p8q9OR4Hk82UK3EWleJjgfUnA+NP?=
 =?us-ascii?Q?2C5/WWyuRLF3D7WlOLzRYaMgR2zJJVdcA0aNxVK7uR5yKf5gfOemQ3MnVnaf?=
 =?us-ascii?Q?q3iw2JTQTE6XkO/KeNNM0CMEnbz8a819OgZX1/+DxShNUEZPd7MifcKkpZnW?=
 =?us-ascii?Q?4BljbDpVrUiZYB9M+XFju+ylm222u9BuQv2db4GRFHB1eDsOj0wBOfRQGATC?=
 =?us-ascii?Q?gZvQQciEgklPgPnZ5lTinetzsyX1P9sVPK18bpzu3XtnLjq8eKUQyHZ4Y2sz?=
X-MS-Exchange-AntiSpam-MessageData-1: Azi9kbmEsosgYCoQy3fqpnJMmE78LE13xGM=
X-Exchange-RoutingPolicyChecked:
	MLFv5y7MsgQ8y3yMgquuKDDEvedO6J19Os5TQyc/CjizI+6D2sHgqjT10L4lDsfCjT3SGQbkD816weL4qD/j6noWzUQHKDN/MoCVAIcBKZIhSN192X9AsbuZ1itiNL/t/G712bt4Z1UVju/gUeR4KE0XWd/+lngmzdC971Txgq0KMMmGjCJ4MWWDe/YK3A8p/jUXA7/uAVjqMjmeZdbiSc5sKwntTWatCGKFhb3ueOX7o641oggd3jSD6zAzj0/PDjBrXG4Qh2brVCXirOX2KQNPzeDTCu5iq1SWvfA9k/bb09TxTt3L3gIgUHDewewbjT1vCvsQ2an/NnicXSsSyg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1sY30a/6/5Nm5Q6B6DwkiMcbD8Gv767lJWAILYwzjMzn+tBKYF4OTPRm4Z3VGxJ20+pX70SjcAnQ0hhnmEtm8V5y6vZCh9eBiZzPoGkJ/WBRxnZszhm/TMJRDNwqhTsJ9iE3f5B9B0pBDRhlqcK7t4H3dLty7reAE/nIwc3MqHpY4QgQ7q0tU75Pt75A7miQUNjS3YwbjG5/kCCGMJe8M6xKEbS4do0PGEWwpNIYLrVGpvRbUz1bswPwe/ChxVcQ5ImrNR+O+PFxyreQwVTXVzRfmBY5y4dPij6eaEWZ6NZ5Ob0bXt40IVmAsvHMc77NXBBesIeNRTl5tZb7r0DPyulmSPvO51G3x6qXzUzxCvcisvrGRL0zLroHTXX2xy+IPyvkZht65j4HCEOl9LiPK0jkpqsQhBIY2oEOgGuT/WwxhR0zBaT5+sukFi/j/XDAORKdPj++hfviJVGnh3vutXBPganfK+nSZ8vOOXPchoiJqduKZnAI8P8om30uasTsP+YcpHBJgbTyDQAI4s6EoTapHF3PZM5kE0n5UGU1Etvo6EcNYOkQuA1OLmpTTSHzBPnp0U9m0IJ45w+9ZmqBIz6RIQKhy/6zw6MgAMguh0w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ae87c56-6048-4641-f5be-08df290dc3f3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 09:38:41.1943
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5BYf8g8Dk+4SGa3SreFlMd2LJIAsmnqfqIRxmbPscHUV+6WFMrvLvnjZyNNpkBxkrbfqQwKxKa8bDYYZmGxXEjQvRT/bi3X5fcvLjHJ6BQQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR10MB075839
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 phishscore=0 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130038
X-Proofpoint-GUID: crRLuFAQKpmYWPD0I2gGkmFJQjtVDKI8
X-Proofpoint-ORIG-GUID: crRLuFAQKpmYWPD0I2gGkmFJQjtVDKI8
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX0kWKAgyetLbk
 APRB2OCRrq95xejIOcZnxT/1QN9OflJyZjZ77FLvczEzotznWqJQuI19Je5A/MdgbZ87Dib9oVf
 DU6TYHpVs/19PmpOguwZCibrFK+jyWg8VHNspbbRTi33aqxLXq2u
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX8Dyml2aW5OvP
 Txx0/PuGGgbAwAFCkFqnU9IyUqs6SB/G6kVZ2DSKsuhEzmNGQaGkrAl77widpYNGxxUzucim/bq
 xT4S5gNi+qxMKFvFrDGusqA1TInxWHAVQf/kGykifVWMeOPunP4eu/awvNQM6hmHapCWkOEBeAT
 yMwIqgOcq+p0f6NHb+pORrcpf81FlnFPDsZhXnKUdyTQpvqzM5uT/PS4qydck+vHwknTPZPKPkz
 cep5JygprLSGeeiL4K+PQ92IAmSiYwh2NCDT4iwUDfgWFpN4Jd2J+fuzLNm0gyqZqBhgaYNUs9j
 R3dPwwWdW0jCRIhsaSsi6rtWx1dJBlAkfPSz7+dgH3+Kq5IE+vOIaOy52PPz7T/EeMVy6KjGFwP
 o4qOnf7AP1S4QsPlHwFQeLpy9Lxr6u+fC6PxgY22Bz7zoYlguFCdLkIGtZGcunFUa7z9wVATkO7
 M9qsIPYqr2Ixq0VZ6fQ==
X-Authority-Analysis: v=2.4 cv=J/8/fwnS c=1 sm=1 tr=0 ts=6acdfc26 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=-BFCJ2bJgao7vN__fc8A:9 a=WmVTiCyuxqgg3mnwYu6p:22

From: Dave Chinner <dchinner@redhat.com>

Lock order of xfs_ifree_cluster() is cluster buffer -> try ILOCK
-> IFLUSHING, except for the last inode in the cluster that is
triggering the free. In that case, the lock order is ILOCK ->
cluster buffer -> IFLUSHING.

xfs_iflush_cluster() uses cluster buffer -> try ILOCK -> IFLUSHING,
so this can safely run concurrently with xfs_ifree_cluster().

xfs_inode_item_precommit() uses ILOCK -> cluster buffer, but this
cannot race with xfs_ifree_cluster() so being in a different order
will not trigger a deadlock.

xfs_reclaim_inode() during a filesystem shutdown uses ILOCK ->
IFLUSHING -> cluster buffer via xfs_iflush_shutdown_abort(), and
this deadlocks against xfs_ifree_cluster() like so:

 sysrq: Show Blocked State
 task:kworker/10:37   state:D stack:12560 pid:276182 tgid:276182 ppid:2      flags:0x00004000
 Workqueue: xfs-inodegc/dm-3 xfs_inodegc_worker
 Call Trace:
  <TASK>
  __schedule+0x650/0xb10
  schedule+0x6d/0xf0
  schedule_timeout+0x8b/0x180
  schedule_timeout_uninterruptible+0x1e/0x30
  xfs_ifree+0x326/0x730
  xfs_inactive_ifree+0xcb/0x230
  xfs_inactive+0x2c8/0x380
  xfs_inodegc_worker+0xaa/0x180
  process_scheduled_works+0x1d4/0x400
  worker_thread+0x234/0x2e0
  kthread+0x147/0x170
  ret_from_fork+0x3e/0x50
  ret_from_fork_asm+0x1a/0x30
  </TASK>
 task:fsync-tester    state:D stack:12160 pid:2255943 tgid:2255943 ppid:3988702 flags:0x00004006
 Call Trace:
  <TASK>
  __schedule+0x650/0xb10
  schedule+0x6d/0xf0
  schedule_timeout+0x31/0x180
  __down_common+0xbe/0x1f0
  __down+0x1d/0x30
  down+0x48/0x50
  xfs_buf_lock+0x3d/0xe0
  xfs_iflush_shutdown_abort+0x51/0x1e0
  xfs_icwalk_ag+0x386/0x690
  xfs_reclaim_inodes_nr+0x114/0x160
  xfs_fs_free_cached_objects+0x19/0x20
  super_cache_scan+0x17b/0x1a0
  do_shrink_slab+0x180/0x350
  shrink_slab+0xf8/0x430
  drop_slab+0x97/0xf0
  drop_caches_sysctl_handler+0x59/0xc0
  proc_sys_call_handler+0x189/0x280
  proc_sys_write+0x13/0x20
  vfs_write+0x33d/0x3f0
  ksys_write+0x7c/0xf0
  __x64_sys_write+0x1b/0x30
  x64_sys_call+0x271d/0x2ee0
  do_syscall_64+0x68/0x130
  entry_SYSCALL_64_after_hwframe+0x76/0x7e

We can't change the lock order of xfs_ifree_cluster() - XFS_ISTALE
and XFS_IFLUSHING are serialised through to journal IO completion
by the cluster buffer lock being held.

There's quite a few asserts in the code that check that XFS_ISTALE
does not occur out of sync with buffer locking (e.g. in
xfs_iflush_cluster). There's also a dependency on the inode log item
being removed from the buffer before XFS_IFLUSHING is cleared, also
with asserts that trigger on this.

Further, we don't have a requirement for the inode to be locked when
completing or aborting inode flushing because all the inode state
updates are serialised by holding the cluster buffer lock across the
IO to completion.

We can't check for XFS_IRECLAIM in xfs_ifree_mark_inode_stale() and
skip the inode, because there is no guarantee that the inode will be
reclaimed. Hence it *must* be marked XFS_ISTALE regardless of
whether reclaim is preparing to free that inode. Similarly, we can't
check for IFLUSHING before locking the inode because that would
result in dirty inodes not being marked with ISTALE in the event of
racing with XFS_IRECLAIM.

Hence we have to address this issue from the xfs_reclaim_inode()
side. It is clear that we cannot hold the inode locked here when
calling xfs_iflush_shutdown_abort() because it is the inode->buffer
lock order that causes the deadlock against xfs_ifree_cluster().

Hence we need to drop the ILOCK before aborting the inode in the
shutdown case. Once we've aborted the inode, we can grab the ILOCK
again and then immediately reclaim it as it is now guaranteed to be
clean.

Note that dropping the ILOCK in xfs_reclaim_inode() means that it
can now be locked by xfs_ifree_mark_inode_stale() and seen whilst in
this state. This is safe because we have left the XFS_IFLUSHING flag
on the inode and so xfs_ifree_mark_inode_stale() will simply set
XFS_ISTALE and move to the next inode. An ASSERT check in this path
needs to be tweaked to take into account this new shutdown
interaction.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
(cherry picked from commit 09234a632be42573d9743ac5ff6773622d233ad0)
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_icache.c | 8 ++++++++
 fs/xfs/xfs_inode.c  | 2 +-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 5f6c2a1f3299..d4eb83e7934d 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -916,7 +916,15 @@ xfs_reclaim_inode(
 	 */
 	if (xlog_is_shutdown(ip->i_mount->m_log)) {
 		xfs_iunpin_wait(ip);
+		/*
+		 * Avoid a ABBA deadlock on the inode cluster buffer vs
+		 * concurrent xfs_ifree_cluster() trying to mark the inode
+		 * stale. We don't need the inode locked to run the flush abort
+		 * code, but the flush abort needs to lock the cluster buffer.
+		 */
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		xfs_iflush_shutdown_abort(ip);
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
 		goto reclaim;
 	}
 	if (xfs_ipincount(ip))
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 3ccbc31767b3..3139363d892b 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2225,7 +2225,7 @@ xfs_ifree_mark_inode_stale(
 	iip = ip->i_itemp;
 	if (__xfs_iflags_test(ip, XFS_IFLUSHING)) {
 		ASSERT(!list_empty(&iip->ili_item.li_bio_list));
-		ASSERT(iip->ili_last_fields);
+		ASSERT(iip->ili_last_fields || xlog_is_shutdown(mp->m_log));
 		goto out_iunlock;
 	}
 
-- 
2.53.0

