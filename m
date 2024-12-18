Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B9D270831
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734488074; cv=fail; b=DnjCqF4aqyPggMpgWtDzv12m3aySPnQvh+FHTD1AymhFpzUabDNYTHCTK3MbUu4iUK1luWzYJwJrxtKYDEqVSYonRs6+EsENEhfdLhC7o7x3jSbHwUyVdaO/UdO0NR7mGldaQKvAqfqliHW9IV2LcZjjxFb7Rq15+F6v3SquN8Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734488074; c=relaxed/simple;
	bh=ENQB/EQ2v9hoLydf81Qy/JFDl2s2V31l0ZPNreUAxx0=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=AGVMgKud2jnzAQKMSgnQ+JDgj4VWihUrw8Inj8NkO7GnK7TfK2xVA9SMooIxTygww8rHkgyIfKb0hxhYgMzjjVMx82XU4zAxjzf+RBfxk9SK4nrSA9lUbgJ8Kyd4yezvQDiqvs9LHG1kb5pM0HtaVeD8wB6Ld1ywuX9w2slfYyE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=caQk+AQA; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Fcl+56xc; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="caQk+AQA";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Fcl+56xc"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BI2Bpj9016216
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=z9E0RklIgoLnFku1YFWklEley2VgMWTR1w8x9rsugIE=; b=
	caQk+AQAWAJ2HYHGJ8RJB+FbrEcKzuk/s7j7tRGJiRr1tWyWCvBJ8CVYCwiTjLM1
	hoLPdXQDM67L7HG63JyoUi+lEyTsZMZ+e2chEd5ZKkOiF+msDX5lMTVF7K/E/UUX
	tXVFSWE5PknZCV44OSIdNH0W/jT0/WlNYSi0zr32cKmlc19H2sZlaIIgrj3m3MWk
	3sOFr+r+sHuCEgAcJ4sveJgiEhUPDSWVXCrY9tQlodmgyes0/7pqFVq2x3Vjca5c
	EsYC6ZTTwAMpX1Ki/PqcuQoHrBkwlBXE7qEZErs90RFFhbKiSbVS4hUquNMRWI+Z
	Kd/i5cWaQz94iS6hsLx3ng==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43h22cqhdt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:31 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BHNe8VX011078
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:30 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43h0f945u5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Bhp69mdU3GM1j27/NcmUPi67Ou/DQqigRWMsj+OFWOkj2s9CriIQaz2BJVdrxbPIc2kUNjNZo9fpthlZp82IsnplIUQpm8HB2J7N5jVpnwPrTTpLhjVDdeYPHOP2D3EtmAs1BbQFhq54/tDYVJGfqubsFYXN7KeFRfCIyqNt1/jhT2aB2gL0wMQn8J4Ih9ksd5GUKCUfM3vI6EBsSV5hfl30SsMINF8J2tC8+aXOEeEyee0K4hDvzYmyYLLKG41pwjUiVkJ6cAuCMvKCW0Np5nhkYmvMoJNySHO7ffKeOg8wgXZ38K2C1uAYm/xxHJjP5x7rRFnJuHVCdkr9I3Uuew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z9E0RklIgoLnFku1YFWklEley2VgMWTR1w8x9rsugIE=;
 b=MIAiSWOzh1QgR7mcZWEif04KeSez5EOLbkorYotA9ujTjYWFiolE6LF2mRk8QHqzOMzFKk/GNDOXUellMVTyUq1oGjRaXarLLhWiJTAnE8bTG8dPeg2SIWfIaUgWBZWEhFm1wTzkDMky+rObTgntfqQ6Y7CAxJye43/OgLW93gGdxaGp90yX15NG4Hnp2vTBZNcDMtDvo5g+sdw1vr1bVkKzbdxe+GPczSI66Z4S04Dn+ChhfGjGOkjNmt5BIcBd/t81tBhok0Al13455gPj4pEsmQtIy3kdJRbZ1whojQQqRnBlPxBgt8FhBO0tdfysGA4dNhHNcYOAXC9VeYXEhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z9E0RklIgoLnFku1YFWklEley2VgMWTR1w8x9rsugIE=;
 b=Fcl+56xcDaGTEHUXLAAWkM27qiREAmpeGFt8vHkN3J8L81hWFdgeSKXLPzhAl40BKrlchH3Ob2yeMY9ZCFBrmmg8aPLisOY6/5z8VzWMz8kQEVOESNpqf9AKBPQ9YvQdDaHmAKQklf1iDPCNUpRq40tVvXMX6XF/9Prqhuv4qcM=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH0PR10MB6959.namprd10.prod.outlook.com (2603:10b6:510:28f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.21; Wed, 18 Dec
 2024 02:14:27 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8272.005; Wed, 18 Dec 2024
 02:14:27 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 08/18] xfs: don't walk off the end of a directory data block
Date: Tue, 17 Dec 2024 18:14:01 -0800
Message-Id: <20241218021411.42144-9-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241218021411.42144-1-catherine.hoang@oracle.com>
References: <20241218021411.42144-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0038.namprd11.prod.outlook.com
 (2603:10b6:a03:80::15) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|PH0PR10MB6959:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c8b2476-e4a1-4301-fd31-08dd1f09b2f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|10070799003|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LA8DwB8uey2HA+LkrPmEaSYKypMQzN8vnDcbDhr0fnQ1T03+/HOXMsayabbR?=
 =?us-ascii?Q?FI06kgd1IQ0tiV/bNm9Y4Mfnec48AY8IWDGXlcxb8VpJp1T5Fe5IRhAiQFjQ?=
 =?us-ascii?Q?SybrflARV51SqcliA8D2o3CaY+1cc/SpCYqQ2eMro47mEfn+0S/tywoyLFLi?=
 =?us-ascii?Q?r93eFdDMsYhkJw+mQE4lO3Qp46RngVAed48fMuNKFcQHNUQJBD5LO4Euahd7?=
 =?us-ascii?Q?ZCy9fUpyrAYcX5+XItJNYy10EbQ6itg8JcXWKjfktnj4yhlT0xTC596VFqaI?=
 =?us-ascii?Q?b2c7bIIPXkDSbOfO0xT3bKRW+hhcGP0Ubh1Hsf9vM0EcuS499ZOa/wwp1iBo?=
 =?us-ascii?Q?/A/82zwkegJYu6dnbf9cF1qHUq1q7ziBw2bkZ3LkPX9rB+4+3t0XfNAx+vtC?=
 =?us-ascii?Q?i52/SO5pYCK+j+Az9zZvQeQpNQ4VRONQn0x2uqz7QZXrn5NW5VK1jK1DaoIM?=
 =?us-ascii?Q?Nt4UclQptLv9iaWLpnSEItfP1w3XrkAVm/hPMXvsRXIl2YCCYi7nuEjjnIcu?=
 =?us-ascii?Q?8RXgisSrD8ISQ/+Axl96MTrYpLYMawSkxCGmwYu14sfoHGFm4vZmuinQm8qd?=
 =?us-ascii?Q?3UwD3JMiJvOGTJ2/yDdufPVbTy6KiaOtFtpOvQWV8uN8eLe3pcL4+krf6Xzh?=
 =?us-ascii?Q?+9yK6Gg/iBiT77T0QEJQCgNtxA34ZFlC2w7gn8/Xk6y1uDAtXLgcb7Sgkapi?=
 =?us-ascii?Q?cC+cTxHxwEPG3KncbUn+xtNNvHmgaUvQTOvLGigitxhFm9SAAV8Vkq1TriNZ?=
 =?us-ascii?Q?GVJzQLD1YPqDYe3lAXopcdI8HgG78t9wGXmLL9GmmBhZnRe9gtC8wdFKJU3r?=
 =?us-ascii?Q?Hl2uHHW0+pLHKIRwcMpIDpnrGxlNMyUW6AOtrxqaKq73aoheIs3WKbngtysW?=
 =?us-ascii?Q?HZyE4H9xIGYVLsxtcQwmEA4HRl34oj60EivulwpseG/ggrZACOHfATXEpFjC?=
 =?us-ascii?Q?KcZRu/SbwPUbHx4mDiuVWl9LqpT+E7+lQzxHnn6tY4hkC8mfXAvp4lW2LGIM?=
 =?us-ascii?Q?pHHrbVAHyMxYfWrBQVmC9DpAX89a7EEANlXngkjefk7NZyFfv1+ITK5X3qyA?=
 =?us-ascii?Q?XqjQQdpcjSVzXgqJ78g7eBcRCabswGYqipOs8jgHOW/6MXJg8+ZZ3HNmN2dh?=
 =?us-ascii?Q?9eosekS7xIAFH4VCpCsnRS52+JMxneX7WzWs2BBPytoYA9KXNM65vggrm2KW?=
 =?us-ascii?Q?p6z2DERFefJXTpmskM9RFY+Ryp22TIrQIxWPdGUHzCtC+uHBAVdidqnmUevJ?=
 =?us-ascii?Q?3TdABOVQmO6M+PfosnWc3uqKKEu+g/Td21VyOIZjqhQy3h4CTRHVoCY62srk?=
 =?us-ascii?Q?Xk454WVnzQSFbjjLb0XIBhhCvXHDOen1YOiWtFwj/J0ylB7fZJX9TMiEbqCK?=
 =?us-ascii?Q?jvKKHnIjsSYMPyejNsLWKvVvwvqY?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?I1wKZzBgBLgkWT4yRE5Er9levogpAQqWcKqFC79AVCNcQem7U5WvN2eThrr9?=
 =?us-ascii?Q?35JYXoFB4Rs7CdYNS3ifJEq+ic8EzYQE9pbj67uVUeomNqesg9POvSPDmVux?=
 =?us-ascii?Q?l/O6bn9Vw4+4z+k8bJJTrKeoPoCoNVXfKyHoC/KffFB37ahdzC2Y1cum2zJF?=
 =?us-ascii?Q?DXexXzvivFUVi6opGGew5XH4X1MG6nYRERCFFBLpTpwmTexDmSCPvDJynxeO?=
 =?us-ascii?Q?Gz+eo386yxLMiaQ9wAFr0ny3dzNym5jyaZTj/0NqGnfqkzPBFFTtmtfPT80d?=
 =?us-ascii?Q?DZ2QQSPUaqGFx2ji4Yc9HEfqn0s1gHgQsi6OKKGhAOxWETTS7RnVTICtAeM7?=
 =?us-ascii?Q?2bFVrR5iETmRvjPoAoc/lrvpP6/1eDlELhTd8QElyVPFl2mSpUplf6Zadnk2?=
 =?us-ascii?Q?IfBTzY3bsWzxx7C5GcngPUquuRZJjkG6tqiQEfOfe4vzmLEyBixziKaEN8U1?=
 =?us-ascii?Q?NsMfedKbD+5PvsXKjfSycOnDWNA5YAjws3W3yJ+FgcwJRaBAJwPiSIeEWvs0?=
 =?us-ascii?Q?X7uSsJ3uV5l0AaxV61jHDcHWUfWQJBAJwV8OBOTqfPTCmeJ01kePvwK589xu?=
 =?us-ascii?Q?ZLuyA1Y4rdPmpw15mPglXoHFvBQQB1NIGnH3gOeeGRSjdTaxAWCchDvzvFjn?=
 =?us-ascii?Q?TX1esJsvQLURrwoZ/Wej5+Eboxkd5IxONmv+mhd6/7l8XVp1fehzs6aCLD8Y?=
 =?us-ascii?Q?4zvzw1/YeUE88MEDzMBEIt5RrWwvfRbCkKoqqnYqte18WX0C7wOEpWl9mU+3?=
 =?us-ascii?Q?KaIznRotDpMh91NKupGkjVH6I2JCY23Z4XEEqy4GfRtb820AJhFQAQfXCJwC?=
 =?us-ascii?Q?yGzoSGwa2RDIW8hlC9msZi5x9JH9t9mxGig+lKaoQ6+tPzOzTljcq9vUp2bA?=
 =?us-ascii?Q?WFM5VSq4A3ab0jzxVzs0QByL0m9Nabl/wHb5tAwwB67KxKOTR6TMj6pGQ0fU?=
 =?us-ascii?Q?yLgxVicRFFHviawn8XbzgaFDK36obEfajoHor5ofvee3oEh1ltDElB1JPNA3?=
 =?us-ascii?Q?XoFdlbBBOBfcm3McRENJjo3eAfmvIaDKWIB/CeCnPTH+fILMpH0vmcsyzRpu?=
 =?us-ascii?Q?yRBndtnvQPm9Jv44TH6UHQXsPtnmEGXAn62UV0lZs2yZwJTDsingdvjJJptx?=
 =?us-ascii?Q?x9fWjl7KPoGEjBUF/DSP1rl92uTVzxbJoDa0j72O4YFPdceuDlIrEUB5JiAk?=
 =?us-ascii?Q?DrWE4Oya6KTUNXr9XatwsNks0W7BZUCjoSkDYlHE2geg3qvogVpWfWiOUj3n?=
 =?us-ascii?Q?UKEv1ByDKeugkLjUv+CXQkvwPzApO8MXda5JORkTh3ja0etWrsk8O7LmA68O?=
 =?us-ascii?Q?6Dlnsowqjzjghj23u2FmiY4mP4ksNnoWdVXquQCvmQvdg+Qbg0AdCuCkRmT0?=
 =?us-ascii?Q?NQDBXjQhrAZKteAAuEvi+rlWlXWUFbLsb/Myv4ALNNwS4u8fjOMXP8q94asv?=
 =?us-ascii?Q?4MfoxGsJo9x7//A+rQzXembX04TNjeZ89n/0X4QLkEoB3ZZxzjU9XCjqLwh9?=
 =?us-ascii?Q?kfi9yC7SZWhehAAHsgHeTLA8uuvZjEvBTO3dl4ikbCNXwPYyWBrDzshDTan/?=
 =?us-ascii?Q?zLp43qYRr4ZZQQisCq900yj6cUF5ga1hr31ePJZoZSlQ3ZDxoNO+sw46LA2K?=
 =?us-ascii?Q?wOc+2gMrG0vcPtC5hcugQiqwb9For1xdpMSgqCGlZrQZJf39K/IzM7yIRWbb?=
 =?us-ascii?Q?v8sqhQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JldzHt3DR/aSFmPZ+bGivy7aSV/jaoY097ykMJagXihjBCnWJ/gB9m3Dqy1D/RoLOUvTu+tw+Cv2I5pAz3gLNPLzfDvSxu4ZEUNILI1orW4ffJ8HQDDo51VHe2Hc/ZmuX9sULPtY85DNIp4Q/G1BV2xVXTp3ij0Hk4uhUlWzvIw/iIpY1zCpt3OdmkrmPD4QqoWHOy1YXZtae8cbAdasROnpHhxQFVh1lMHvVwsLqOq7ggnI3n6Lp4r5F4QcSlk/L6w43X3uQgFcVJ04vpAG6HgSw8KxhfRQN6Ag96k1SLL0jU+fK15LF0GhU9USCM4OnOqTzUs63sBJuBp5IU3aNK2DMkjyX4ZUlJr1NSnQPiuVlqowQJyS1aabBuxgso3q5JTifClmKyF5nHiTmKBYO/JRrDXbeKAtGN03wmqOXvHw/vQ3ahACX2gpNn9QDjbN08BkdldbJcW+ygYtHnhbt+HavhEs1UdGPr3ULRok36Mho9FszQGV/pPH/xiW+WnjEXaUl27jVMZkymmop7DkoRv6prgOjMLNV1McQ7vDmyzRzb8dKAe4Smc80UVCs9qR9OgFhU3S3xBBcqn1NupB7rwbal7V+IcY0BFu9t60kyE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c8b2476-e4a1-4301-fd31-08dd1f09b2f9
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2024 02:14:27.6114
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YOPl+MmAHuDc+Ld8YhTVaIZ0e0Tec5mNyvqzdKXra2ZqP4ez+EprOe+/EYWs6nyD/u3PObvCRbremI0TjcE5U02bQ3ze1KlrCIfW+dMtph0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB6959
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-18_01,2024-12-17_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2412180015
X-Proofpoint-GUID: PvuChrskBWmAy7dgVRKY9py2S4WOt_n1
X-Proofpoint-ORIG-GUID: PvuChrskBWmAy7dgVRKY9py2S4WOt_n1

From: lei lu <llfamsec@gmail.com>

commit 0c7fcdb6d06cdf8b19b57c17605215b06afa864a upstream.

This adds sanity checks for xfs_dir2_data_unused and xfs_dir2_data_entry
to make sure don't stray beyond valid memory region. Before patching, the
loop simply checks that the start offset of the dup and dep is within the
range. So in a crafted image, if last entry is xfs_dir2_data_unused, we
can change dup->length to dup->length-1 and leave 1 byte of space. In the
next traversal, this space will be considered as dup or dep. We may
encounter an out of bound read when accessing the fixed members.

In the patch, we make sure that the remaining bytes large enough to hold
an unused entry before accessing xfs_dir2_data_unused and
xfs_dir2_data_unused is XFS_DIR2_DATA_ALIGN byte aligned. We also make
sure that the remaining bytes large enough to hold a dirent with a
single-byte name before accessing xfs_dir2_data_entry.

Signed-off-by: lei lu <llfamsec@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2_data.c | 31 ++++++++++++++++++++++++++-----
 fs/xfs/libxfs/xfs_dir2_priv.h |  7 +++++++
 2 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index dbcf58979a59..e1d5da6d8d4a 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -177,6 +177,14 @@ __xfs_dir3_data_check(
 	while (offset < end) {
 		struct xfs_dir2_data_unused	*dup = bp->b_addr + offset;
 		struct xfs_dir2_data_entry	*dep = bp->b_addr + offset;
+		unsigned int	reclen;
+
+		/*
+		 * Are the remaining bytes large enough to hold an
+		 * unused entry?
+		 */
+		if (offset > end - xfs_dir2_data_unusedsize(1))
+			return __this_address;
 
 		/*
 		 * If it's unused, look for the space in the bestfree table.
@@ -186,9 +194,13 @@ __xfs_dir3_data_check(
 		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
 			xfs_failaddr_t	fa;
 
+			reclen = xfs_dir2_data_unusedsize(
+					be16_to_cpu(dup->length));
 			if (lastfree != 0)
 				return __this_address;
-			if (offset + be16_to_cpu(dup->length) > end)
+			if (be16_to_cpu(dup->length) != reclen)
+				return __this_address;
+			if (offset + reclen > end)
 				return __this_address;
 			if (be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup)) !=
 			    offset)
@@ -206,10 +218,18 @@ __xfs_dir3_data_check(
 				    be16_to_cpu(bf[2].length))
 					return __this_address;
 			}
-			offset += be16_to_cpu(dup->length);
+			offset += reclen;
 			lastfree = 1;
 			continue;
 		}
+
+		/*
+		 * This is not an unused entry. Are the remaining bytes
+		 * large enough for a dirent with a single-byte name?
+		 */
+		if (offset > end - xfs_dir2_data_entsize(mp, 1))
+			return __this_address;
+
 		/*
 		 * It's a real entry.  Validate the fields.
 		 * If this is a block directory then make sure it's
@@ -218,9 +238,10 @@ __xfs_dir3_data_check(
 		 */
 		if (dep->namelen == 0)
 			return __this_address;
-		if (!xfs_verify_dir_ino(mp, be64_to_cpu(dep->inumber)))
+		reclen = xfs_dir2_data_entsize(mp, dep->namelen);
+		if (offset + reclen > end)
 			return __this_address;
-		if (offset + xfs_dir2_data_entsize(mp, dep->namelen) > end)
+		if (!xfs_verify_dir_ino(mp, be64_to_cpu(dep->inumber)))
 			return __this_address;
 		if (be16_to_cpu(*xfs_dir2_data_entry_tag_p(mp, dep)) != offset)
 			return __this_address;
@@ -244,7 +265,7 @@ __xfs_dir3_data_check(
 			if (i >= be32_to_cpu(btp->count))
 				return __this_address;
 		}
-		offset += xfs_dir2_data_entsize(mp, dep->namelen);
+		offset += reclen;
 	}
 	/*
 	 * Need to have seen all the entries and all the bestfree slots.
diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
index 7404a9ff1a92..9046d08554e9 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -187,6 +187,13 @@ void xfs_dir2_sf_put_ftype(struct xfs_mount *mp,
 extern int xfs_readdir(struct xfs_trans *tp, struct xfs_inode *dp,
 		       struct dir_context *ctx, size_t bufsize);
 
+static inline unsigned int
+xfs_dir2_data_unusedsize(
+	unsigned int	len)
+{
+	return round_up(len, XFS_DIR2_DATA_ALIGN);
+}
+
 static inline unsigned int
 xfs_dir2_data_entsize(
 	struct xfs_mount	*mp,
-- 
2.39.3

