Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20427450EE
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734488060; cv=fail; b=N0xB/wkrRNtsz0W7JZ8tVRBPBGnkMholHDqhqSgsELwqD3xhrtzof4BtmN8jENBen9z9S37z8l9u1VlzKyzVupnx/nWs18iqgt1aftfXRxvOtG+/0a+KGLOvFZj4pRSr5sqQx3nwy0pNyr5IqYWeGoSMaOFHr8NGPzL2H18h13o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734488060; c=relaxed/simple;
	bh=LX8bwtpCxHA7T7/rRFCkuGOjddPRcq9d0C4AbqayOfo=;
	h=From:To:Subject:Date:Message-Id:Content-Type:MIME-Version; b=MEMUJ68gCy0/dkXniwCU2R3XwX4N7ivoS63VkUaFh0xcG6nUpGGyipWLzKPZBRFDA4L/ylHGHEDwvmDkhJn8bvIU54DgQQgqeCx124sNtWulicMiXTMpTUo2JF6bogCPT6Y/99hgKQpgSlEtP64/VX6gC009okxnfxMAKJP+C0U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lyvMWZ/g; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fZos3GJX; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lyvMWZ/g";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fZos3GJX"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BI2Bs68001491
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2023-11-20; bh=PA9qTKy8tdiStkXE
	d+O4pDgc8MYs3uwnq095H7N8DGk=; b=lyvMWZ/g7nwOOT3JOHMPwUOEnZHmM7EI
	YhwPcmQOCC+5S5QxCH+gVhgt7zNLWrVkRcRR1MREeKHh+aNLpJpSNN5LTxLR3m0o
	U3H/Z7dA4YCOMlGX46uhrfDxMWzaLnVG0nSkW4QmmsT4p2+kNpApwH5btF1HOzH4
	6Smay0Hk3+M7co96ezqLkEt5kHI0zkk9+GY2eiGook1NN6Aq47cFOL7Wl6+dX1Iw
	KGi7FTniYD42n9fJHq7d6fyJBYC5YiCubWyWbKQWY7HiV/VDnldq3stRyjyA7ZvJ
	hQ3VghhK72CDzCxsP3ACK6G4pDwMOqOeMHD09qRdHmWTKZXm5Ul/mQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43h0xayk6w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:16 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BHNs0pU010864
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:15 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43h0f945pp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U7zjzlU6ckHm5CXeCRWydY1EcnY5e7Q7mXVoeyfF4GJNL1adKJWxpycVo42NTf7922zlwvT4rmwF4QIq3JCYXedXTRe1/bgagDx8/Je+PgyhJvz6hVoH7AJ2cy7zEbnVObgQL6dyZJ/rnlgeqXnCwu3C26CP8jWT4b+R3IJkNp65YQ0L/9bpvj2+t1hKTQcx0L8panIC37cEQAsxXpLRR3wx3Y6cLTawhgmI7p2TjCgaqIFdxuQta063HzzptstmiiR3p2YSe1Z9snoMtO/HBS2OQO1s/1+3qxFCwMDGZJW0eDc6PaS4IyIlFQaQmUsWx9NmW6w4Qklut9zaUsMAbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PA9qTKy8tdiStkXEd+O4pDgc8MYs3uwnq095H7N8DGk=;
 b=UBGDnHh1I6JTzU4ReiE+YmYgmI+VouJYrKSWMjIRtI1DU4Mdx1OTZk956xDsYF9uvRErho866bfEb/sR2+/OHmhmbKzObRxMskUOQpab6gGoKXajRgjv7zDEO5ZeXUvDsyqjY/LW1oNlMyL8gLHJvE9chDQ3W91LVSlVBKk3wtMSJXCPS+4uFVF+ZzEj7bW8zuRx/z59Sw/UFMiRjZ9MueXx3nuQgcpQHbZrKGseM575TpZwjUlJj5anabgUSjGfWr5hb3j9vM0PlZIPfM0XNFi6tADe6mNRn2pyHLNyQ4QRD0g1lzmQMq0ZoufsOIqYvxBmXULimPncc+tMjKZq5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PA9qTKy8tdiStkXEd+O4pDgc8MYs3uwnq095H7N8DGk=;
 b=fZos3GJXULVJlRvf8dM3FrfXeTlWPX6rb+tw1AuBb3t19REdvK5HmF0rUxdU0nTEYYDHqAampvxzIRsdXDgYEp59VXbY2XSBulSn/ApforkK0dQYZuiGZUC3zoUjJ+LaL377eFsskRcYi0KmnX0YPs37m+VaJs7i4YpMP1/5zyw=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH0PR10MB6959.namprd10.prod.outlook.com (2603:10b6:510:28f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.21; Wed, 18 Dec
 2024 02:14:13 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8272.005; Wed, 18 Dec 2024
 02:14:12 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 00/18] xfs backports for 6.6.y (from 6.11)
Date: Tue, 17 Dec 2024 18:13:53 -0800
Message-Id: <20241218021411.42144-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0045.namprd11.prod.outlook.com
 (2603:10b6:a03:80::22) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|PH0PR10MB6959:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ec4c4b2-5e3d-4c90-a782-08dd1f09aa32
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|10070799003|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?EUk30ikFzlGm2ZbFIfQWNQLQEFvtfMwnUT7GUzCkwCIRBue5q621DYT97RW6?=
 =?us-ascii?Q?/ed470lID8owKbLHr76H4uTaGkYsGwLrMw7PH55OhTY2/O3RSClzl7E5MeC4?=
 =?us-ascii?Q?AzIJ35SYHClJ4WnwEpdlcuhG9phZ95V2K6V9z47WSFX5dtaGatA3FSlZDNt7?=
 =?us-ascii?Q?ZvbV5dbaOd249Pf1GnxcXrdlVQ3LP5ICkfA74E0R2rGg8mHLsDcK+ppSJsiv?=
 =?us-ascii?Q?16tN3Ix5RS06kiYEDpq7LZpg+H/9iPHOyY+/h+r+3VqB+ekeV8Qd1pkJgS0U?=
 =?us-ascii?Q?OhSwHML5lZ/07q4STLYmnEBS686lqBy3SLN2xq6pF+7BPXqId8CMt0fEPGyc?=
 =?us-ascii?Q?5/JPHRGFydt7GRaWA/Ee7rA9SsI1vvROXn+1qL8fFIWOhHHItnCwx/yap7Ry?=
 =?us-ascii?Q?4Tn1gKRGd23DgbHfk6dFIgVyOUF/ikR1z1VGLE72RjCV2zevDqeCfgLFrGrr?=
 =?us-ascii?Q?v6NHuUJj5VSnVghpfm3iWxv44xEgA69b9zTumIOEYa9bdAicYNu++E6qeT5+?=
 =?us-ascii?Q?enik36U0PpvghGgIzDW9VGo46Lnh7T7/eYlWBM3BDTjVhuPT2Av0ClCfpsMt?=
 =?us-ascii?Q?s/Eb6e8hBSApnFGGojbPcMSlpV7uj5g7Ld3hZwtMRF4M8qCi7y5EUITO7CIF?=
 =?us-ascii?Q?jVHEhTuPnlbVdp06IkfjdMK+Sj961hH9V6VmXX2BTLv4Zhe2MMgY5DICxuX1?=
 =?us-ascii?Q?TnGM3WNcvKPVBhI2RRtX1BqlUpe77liSTeV4Km6fLywctzmcKn/Bu/h/rSql?=
 =?us-ascii?Q?KwJ/jtnbV0KtS26TC1mkozorqZvF5LE4nsRWwWAdoTz+5347lTbG9t/kCtUX?=
 =?us-ascii?Q?SJ3aM/EhWBCx4un4faAaXpvrnFp/5TspfhIJs9RH6tPngEE++JqwzQEhHShI?=
 =?us-ascii?Q?aE3aiqzh7exRw5hIFxGfI1b5sV2xbpVIqk23W3XuvYpJdjIYo0Z0rKJx26Fz?=
 =?us-ascii?Q?ohRhlGHJRSLFAjwNh+dK+q/N/R33yMoI3+2r00+99F1wtY8E4nYLBSh/evQ5?=
 =?us-ascii?Q?65v81Qb3jlVa+ojgvxhJTktpj1sOOzSaB7hCpPV5003bSfZJ5IUpFmTB0pWb?=
 =?us-ascii?Q?6dYhNFauFlXggQwioINJ19Yfd1GlvfkaE44Esp05lVg/3DEk/OdwvmyThCjh?=
 =?us-ascii?Q?hw+RaGqvcbKbfzshcEoNSPCVwrLCRBPSW6AoBFFUunK5mUkhDBC1jUqh5Ql1?=
 =?us-ascii?Q?+3s1RiABmcKIAQH5vluInYza0mZwl+6753CNpYdhPCOGk5+v15Rh5chC8J/m?=
 =?us-ascii?Q?RBThH8CNXrO59QJlWnzD1tdzEoXIs2uqkNdzVvmR3HMRxJwZJpMWlyImqG1T?=
 =?us-ascii?Q?zEonrQqYD9T2EJXnx01u1CykuudKAvr5+a63XfQ2Hu4UVgRsmBOFyF9anJCb?=
 =?us-ascii?Q?Uvs8+zaTbACfIrpf/OkIrYRB752L?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YEU8xNmnH92XmYS8Ww9vQn3O9Vhup1t1YXi3ftt9KwaVZae2QcY+qIrLMRVL?=
 =?us-ascii?Q?F2JHjtso+XFumlo3MTzsTSQYm4T27QaL4KTZL1vwFwwzm7JeOdTqVJ69I63r?=
 =?us-ascii?Q?cmv4f9quCIr1IX1UagNO0PkUZBRE4ZUmOs5VHcuACe5M9mRIR+9nxpQusBIh?=
 =?us-ascii?Q?f6a2iHvEjhOtO4YNKdjzdblIbDpnwul+XsTLORJhfz5w86ovp9zgz//ZQ3nn?=
 =?us-ascii?Q?W0lqQhkRXB/xC0p8N0dWAlu7VwgPt7KZ3x+Ba3CWt87bN0lY5ZhHWvKlA6wV?=
 =?us-ascii?Q?LKlvheTNEkut5CBE9zz8ScAaoiKSfz7L1bJECzAKndB1kcRTY+Gjp1AFLa5K?=
 =?us-ascii?Q?AHaubWppdvyB1+slH7I6mlgaBvTew13SQF5Y7cmSz15uIvr2K37wX08IdQqx?=
 =?us-ascii?Q?sokaW+Mzyq52bQhWrbapChj4HFrH8CQJc79Mbhj4aqnL0ptK3XCtr+2id20Q?=
 =?us-ascii?Q?fHkz1LLFsssI+rZghbx3VH8YxVWaoMuYbARUsSPLcXIOjYJyivlznI2Dysqq?=
 =?us-ascii?Q?xg9bu4zGNJ1KJIpw6QusQ/aSI/lNJsvF8Nv8gVuHZbv2okDzT67mJxBseEkT?=
 =?us-ascii?Q?pEGorcyrG1WymIY7JG8cSNz7cGZNG9uvkj3++HKl+5M471eEOvdzEyYgG8Y4?=
 =?us-ascii?Q?a8ju2bfZ6gMTAFxQaDHCrADeJH/k7ecDH8UIzvYaPTLPuNWDurOKY07clAeA?=
 =?us-ascii?Q?PBhA3Z05R9JIWPYBvU4Jng7Q9+8Adtv9qCgCVpdB28l5UrtskLxwN4bpheeP?=
 =?us-ascii?Q?MNmTI5yg/57L8EFO2aiJAOyr63t+Jest5bqHC3xA7gQPlNtwcPMaUkdVu71p?=
 =?us-ascii?Q?aUT79WiqD27MDQS4KDJO8Sj/7b//gfL8t5y9gJR8hXg8pCR5I9OsLvMgrP44?=
 =?us-ascii?Q?ULJKnKjtpsTsjPY4dBgZo1RHkWjRSvQEIUjhL/uucrFNIJ9FxLClug4ramgv?=
 =?us-ascii?Q?AzwfyupVQxJpxspO3DH4/piFBaoRJXsqeFhH4GWL40ZPO42a7K4X8BzQi8pE?=
 =?us-ascii?Q?7F7kza2B1ADyjWWXxM3aHteepZAeQvglv5H+mSChx5SLAdR5yGy9xx2dxBsE?=
 =?us-ascii?Q?B3+TZrNIAue0E/tTCqxr7lzA9qWWSrmGlVeEu4JdYl2hV2c2F+TtiXer2SHh?=
 =?us-ascii?Q?veM+aCr4AEbcuV6fNmELThHaVtZluiTBB79DVxB5uOVhe0VY5zKovcTUVJpy?=
 =?us-ascii?Q?OKjCQBnnE9ymqIYsyuNZHoeWOHBFb0dVE2ck+cIwJl5t0TPrcFO2XEuDSXkA?=
 =?us-ascii?Q?nNK5p5t8DeQMD2x4QIw/FKHLwk/oYSt/zIKSLpebm95kWiamvcZSylu731MJ?=
 =?us-ascii?Q?bCcH7KF/caLcwheDZQMNFuo9HHjSMW0FhrDcLLy9l9NqnLJC0H6cnSOSND2S?=
 =?us-ascii?Q?fOl4hFMT9hfpHaymXci6rczDzw7qWQRYkETXI4J0ufKmDI1ST9JyL2Pg1axm?=
 =?us-ascii?Q?cKPwNQVktcPqC/GLyCvFPvph1ebXYxiAlvBkrICtwH2ZhVFuz6opAezWE3vt?=
 =?us-ascii?Q?vWJ5dHoQ31pMYUU87vLVTj5TjQx1pRFgJTf3diALZ6cygdAYbb8FORRHTjPL?=
 =?us-ascii?Q?Lr1NJqOILnYXGAL8ChP7cZaIwUKFofsimVRpP3Dz9md8sFXq9eHhZJGAutAm?=
 =?us-ascii?Q?Xzl0GDdGuydhZHA0C78ZnU8v1dwQKpaArtL+FY/CJjn+tr0XV6g1VS5s6ZCD?=
 =?us-ascii?Q?a+0VDg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nIWVm72ZGO4X/mxQKXthaRE9dvl25B6ZDIBwkcBK5g2haFwu+pd2TKA37/qr+VbZND5gyEcJ8CNrjt5wO53unp8RI7+fB18KRXKTEtf73RZZXlwOooMiw/bkjXOoFIzltl/Y113KV2i1ir8F2Jxknrr0mgh5U7VosP9vh51vTZlygUcE3PLOgawgvyw2u8tWZgaNwqNv0lTNXCY8dIPKdv4b8McdDLFgRuUGWGnoeqV3bPRfT3s1stef8ihpDcbg2nyZxbOnaf7eyMxTGx/7qDdNfCwPEfMD2ldsaNuBcsej8iSxKYBPYmz+baYp0KkGANCn2tUh2TAipED2kI3pfLsBLiNUK8czivqHGw1Uo7us/sD73b5epGcWo8bY24xasvPslLlRFSksbjT3TFdX+OOS/FuCiElDHHaEptT2SczbG6Y8Nsf4oCIJU+WtKV3+bO+7evWdGMZrS2r8Jhr8eFClqH/GcT/EU2T0qlPg95nbUsgTJdI4VAqqXAsi8y0cwgiWF5pR6TJakKPXzdkKMJXlHEVhvsXCgwxlBc2FE/bCX8UTfT+pWCA1x+IfPKDz5VzKVGyfPNWAu2MZfx8+oIEPWXDdkvvqtGdb7nfp38w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ec4c4b2-5e3d-4c90-a782-08dd1f09aa32
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2024 02:14:12.8649
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qKUvqwAdT6qmd+PBgBwtxOvhYbjeTvleAz/nkQ0F38CIMvKkQ+EDCUIi1KSVW2VmxC/T7uteNULmex3Ok1SK3Ct6+EwMC7SKn7FRZBBN/ss=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB6959
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-18_01,2024-12-17_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2412180015
X-Proofpoint-GUID: F8v-FJaxhZbEwcZwnz3W4N-Rtxw9r5Jj
X-Proofpoint-ORIG-GUID: F8v-FJaxhZbEwcZwnz3W4N-Rtxw9r5Jj

Hi all,

This series contains backports for 6.6 from the 6.11 release. Tested on
30 runs of kdevops with the following configurations:

1. CRC
2. No CRC (512 and 4k block size)
3. Reflink (1K and 4k block size)
4. Reflink without rmapbt
5. External log device

Chen Ni (1):
  xfs: convert comma to semicolon

Christoph Hellwig (1):
  xfs: fix the contact address for the sysfs ABI documentation

Darrick J. Wong (10):
  xfs: verify buffer, inode, and dquot items every tx commit
  xfs: use consistent uid/gid when grabbing dquots for inodes
  xfs: declare xfs_file.c symbols in xfs_file.h
  xfs: create a new helper to return a file's allocation unit
  xfs: fix file_path handling in tracepoints
  xfs: attr forks require attr, not attr2
  xfs: conditionally allow FS_XFLAG_REALTIME changes if S_DAX is set
  xfs: use XFS_BUF_DADDR_NULL for daddrs in getfsmap code
  xfs: take m_growlock when running growfsrt
  xfs: reset rootdir extent size hint after growfsrt

John Garry (2):
  xfs: Fix xfs_flush_unmap_range() range for RT
  xfs: Fix xfs_prepare_shift() range for RT

Julian Sun (1):
  xfs: remove unused parameter in macro XFS_DQUOT_LOGRES

Zizhi Wo (2):
  xfs: Fix the owner setting issue for rmap query in xfs fsmap
  xfs: Fix missing interval for missing_owner in xfs fsmap

lei lu (1):
  xfs: don't walk off the end of a directory data block

 Documentation/ABI/testing/sysfs-fs-xfs |  8 +--
 fs/xfs/Kconfig                         | 12 ++++
 fs/xfs/libxfs/xfs_dir2_data.c          | 31 ++++++++--
 fs/xfs/libxfs/xfs_dir2_priv.h          |  7 +++
 fs/xfs/libxfs/xfs_quota_defs.h         |  2 +-
 fs/xfs/libxfs/xfs_trans_resv.c         | 28 ++++-----
 fs/xfs/scrub/agheader_repair.c         |  2 +-
 fs/xfs/scrub/bmap.c                    |  8 ++-
 fs/xfs/scrub/trace.h                   | 10 ++--
 fs/xfs/xfs.h                           |  4 ++
 fs/xfs/xfs_bmap_util.c                 | 22 +++++---
 fs/xfs/xfs_buf_item.c                  | 32 +++++++++++
 fs/xfs/xfs_dquot_item.c                | 31 ++++++++++
 fs/xfs/xfs_file.c                      | 33 +++++------
 fs/xfs/xfs_file.h                      | 15 +++++
 fs/xfs/xfs_fsmap.c                     | 30 ++++++++--
 fs/xfs/xfs_inode.c                     | 29 ++++++++--
 fs/xfs/xfs_inode.h                     |  2 +
 fs/xfs/xfs_inode_item.c                | 32 +++++++++++
 fs/xfs/xfs_ioctl.c                     | 12 ++++
 fs/xfs/xfs_iops.c                      |  1 +
 fs/xfs/xfs_iops.h                      |  3 -
 fs/xfs/xfs_rtalloc.c                   | 78 +++++++++++++++++++++-----
 fs/xfs/xfs_symlink.c                   |  8 ++-
 24 files changed, 351 insertions(+), 89 deletions(-)
 create mode 100644 fs/xfs/xfs_file.h

-- 
2.39.3

