Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846F7153817
	for <linux-xfs@vger.kernel.org>; Fri,  3 May 2024 14:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714745049; cv=fail; b=ZN7Be7InKQtonqr7USzjCa5ZzlAyXLhbw8/zMEnB5el+w+9AdNC5VWA9yI/42tUts/+fm8PzowcC33Z++W8WQEq+QPlYbC42cC52PDVu8SOc3lPT/0zlHXgGkSvuzXmnt3dgVNTe838Cg9mHzspP/vgGDNb78Q4WbZogvH6mkUo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714745049; c=relaxed/simple;
	bh=Fc2k24uCi+9FESQtdgzixlV+siWVzqyKOUKV5rYMSaw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QtCkjXPoYBUX/LqQDVk0whWGCuszuYozP+3BlAO1aoPtwkh4Av0pI5ECW/rjRNfuMxrZoNosDgs0mQuv9ElRZQMD0fC7LaG+EnfvBDHBxilsRm4DyAxEu6SKW1LKi7iqft9ES7w+Dfm+uzz26rwra/zmAmCDc1Cp502Vlc0N8Mg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Lc9x7Npk; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=FuOckiQl; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Lc9x7Npk";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FuOckiQl"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 443C2Sta018602;
	Fri, 3 May 2024 14:03:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=apjpXI1FNs+BPn5EjTwW51Bsu1tKXsf1KXRebrBmD7g=;
 b=Lc9x7NpkfFXXCiZCrax32cpszIMmzkCW1ffe9yNNcnkcYHURI6ICPCAGgQAWtLTYLdA5
 2zYbIykb36RgryE3MnjpPOJirPojT6qJRMY3th2qa7yKd/NAqXvMRaCyaCn2RyYruEu2
 Vq4zrC+OYEeah9bRugsNvBK333/ojD8ERyQPjdVEZVP0CKHwSU/wTEZpcPZSI93KoHBW
 js6OB+p1KA1H1B0peIGfE/mA/at02g7wzuhjfs+u/faMYxrvED4UND/sAgyvMqtENlyd
 HCbY1XJq8wxVIiIMqpZwGTyCb9McHLjj0MJyvqgB5uQ4/rhT/Y/cmC14KLZvCy2ewJHt Uw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xrsww0c6v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 May 2024 14:03:58 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 443DUiS0006062;
	Fri, 3 May 2024 14:03:57 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xrqtcbmeb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 May 2024 14:03:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IgPuMfNnA+6Snj6CBs3TnAztq+ym1kW3BrP2/qk/l/lgeSuVZG4OHI+Ttep3f2t9HvFUQYLMifLh2b5KDrKGnuXsoYhWl2jp1x7PPMoLnLmj9Oc8Z06KIC7cwpldSOhgl8sg1LDnC/aIeAo2ayQrXWXerwrJzG2/kKvRCxSWeJtAgiQoR90RqkU22jr9tfLLqU1NFVFOs0pO4raAIhEy9+2HhQJzUPUF7FpYKPvx0gTWS3plqAQp14VC2UmXS85MsERSOILIwigo5Nq829XPSANkZkFNJd4z+nEVMqrvPvtnmQ1FG0xucatGueJFa4BFwCM6mmNzimAzsQJojgHbBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=apjpXI1FNs+BPn5EjTwW51Bsu1tKXsf1KXRebrBmD7g=;
 b=bppfalm9HlnoJL/cJxcRf5MppJHwdF8+GOiyQ0PNeM8IRAOs4rW3Tqo7/MTwvYce9fS/teYhLpYFOLRtxnxzqEE/QxJVcXev0k531S5vW3wInXH+z5lSMHvuJyOpn0mpAQKSvKqIqOduGxI8KSBflURb/XWvhhS/+pfu3Q1Y7xqH/PqypG0B+uFxnCpB1oip2BVJ/alBYs65LuaoGK6TVCbVuviOVaQZmMz9YvN2x9eE09hsoTlMOqtD9IKG+5cjAKMZU1SLTkHw1SSIdTO8KSjMJHyjWNVFhrs29ouz/zrHK9/eZbvUybkocZeY/gNkuaRLdE1DyJ294F8G5VVcJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=apjpXI1FNs+BPn5EjTwW51Bsu1tKXsf1KXRebrBmD7g=;
 b=FuOckiQlfIv4LotG2nJunqOuesTAd+NufsErN+ctH3JfXKfg6Tr1OCc0UOIqLqTK20z6ue5t2rhBgKfGbI1+Wwp9xSqOshoX6MN3VO4SV3jnK2ttxlYnAZsPXwy0+HlHuwABRQM+oV1p5IpNZbxoxmFcGPkcW4zmfNAhx4LJuOU=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BLAPR10MB5074.namprd10.prod.outlook.com (2603:10b6:208:30d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.34; Fri, 3 May
 2024 14:03:53 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.7544.029; Fri, 3 May 2024
 14:03:53 +0000
From: John Garry <john.g.garry@oracle.com>
To: chandan.babu@oracle.com, dchinner@redhat.com, djwong@kernel.org,
        hch@lst.de
Cc: linux-xfs@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH RFC 2/2] xfs: Fix xfs_prepare_shift() range for RT
Date: Fri,  3 May 2024 14:03:37 +0000
Message-Id: <20240503140337.3426159-3-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240503140337.3426159-1-john.g.garry@oracle.com>
References: <20240503140337.3426159-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0041.namprd08.prod.outlook.com
 (2603:10b6:a03:117::18) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BLAPR10MB5074:EE_
X-MS-Office365-Filtering-Correlation-Id: b6fe66c7-7139-4e46-ca59-08dc6b79dd7d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?pnCXqyLXLwgCW7xAEzkBi/6ucSPG8ogF1HIhyT+NnUPgK8raaXD6c5n5lKgy?=
 =?us-ascii?Q?vZoJdA85tMDp1os7fud7S/r70/qIoYVf7gjnFmtsWDCKt6bdyIS2+bbGsHDY?=
 =?us-ascii?Q?yKhLEbxtkre4dKTNDJY/9wtTJAn7SMslGstA6TjeF4+Vr26pAeZeQGL4Cc0l?=
 =?us-ascii?Q?c4lTiqm8s1ksmFU7FpWPQFux+5kKCB9GabGtlUFVgpvtGH+dL5WtxSHFsP9p?=
 =?us-ascii?Q?u5HZRsj7FXVWp+9NhqPtFt8mzn+eWur1e7kVqZFxlny4q3KMahu2k2LG191Q?=
 =?us-ascii?Q?36hs8cuTw9Xykcu+nbNxQp8HogcmUZmx9Potrq16oHqTwFyNfnERGJp/1T9b?=
 =?us-ascii?Q?TxdRLLCYV2DCKsmzl+SG9A7XzUNYDBPZolgA3T54dj5ivqrEu0UWqPPvJRhI?=
 =?us-ascii?Q?xIokHM/oQKNo1uGCisKNacpgA6Z29o5RUKkxAVuMFPHuTbEBsxVAhZ82tH5O?=
 =?us-ascii?Q?sVhPipDM9dkWXSWDjyfai47w+nHt6c+Db3HiYadCfg/wbk/kwX5KRZVrT7o1?=
 =?us-ascii?Q?3BOpyY3522vcxG5Ka4TFGWp0DByGJgXuTWf9SNY9txTzCMWRh52dFbAWjCpr?=
 =?us-ascii?Q?KPWQei3/1L1VBoNKPzWm3SRmDsutGlYOjXAzJGR2bEhag8W17L47bQ7+f5pN?=
 =?us-ascii?Q?3T402AUvES/o2tDBAopiwJMJkWopVgsxlaeS6Sq1MuwkKKwe++Byqtr+fOCJ?=
 =?us-ascii?Q?/MA+kPKIWAXrqABmlf5XOsVIt/pk4hrsTYDsz/axhQZVuS9hjmotkB5PE9jW?=
 =?us-ascii?Q?OdQpyAsK2sItlEVKAckdma16920qkzTRJFGvSMDs8AGO8v6KLB83tsi7DMLa?=
 =?us-ascii?Q?zzrZvUTSLPOvwnn2Wicb1g6VAzDDAuVvWEszfECN2qi8x6vh6Ksg1bwKOaOy?=
 =?us-ascii?Q?Q9kmL1/tC4oL2MgJkHKqRzytQ3h/zbV+yEr+2C94QMTf+Bj9IZs2MqEajMFj?=
 =?us-ascii?Q?/aREbMbWUPwLgm7KMyud2fcBqM93lkQ6eIa70hpRhIJHWchmpn63gaHiSVq8?=
 =?us-ascii?Q?4D0c54qY1rNbDxDXcHrLtE8r10SwSts+r9cuUjpVFbZ02zNlNaRP5l33YxbW?=
 =?us-ascii?Q?ojftHuIaal1hHfz5BgzAu+0xwO8t2DCOUvjRSB9kXoUrlSRrPSgt/5jb3MXI?=
 =?us-ascii?Q?nzW8/sLe2cNqPrB5scXoGavN9w4KTtlxQ7sBf0lbzrPnmAM8yusKPcgvRnh6?=
 =?us-ascii?Q?UOukK+qS3nceYgE0sSKHWg3MnOzKLvi4zUZZmmLKZklQk+rKY1Gf1Pwx0NW3?=
 =?us-ascii?Q?C6v7fz9AnjuCOija27VENiJIcYDGsyjeZyCklIg0Eg=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?BfcAPvhNeCklXfpPEe/qDS43W9E88hDEJ7inDNi/Y87vooCxQmApMwpbSZ1s?=
 =?us-ascii?Q?zKDr2B08yTrR1ZsZwlWoAgIOXjPt3rpJzEOTyPY2KIOIBCtHj0PPyo2dgZAj?=
 =?us-ascii?Q?Dc5sclCyIYKoaURnxTk9z6UsksBU6IWqQKpUyaNfJCMQJFsLCMCjRUzD/bkF?=
 =?us-ascii?Q?Xu4e1WjXs6d4JdDhyoQ0ko5BHeUU/LVTCIWEx32heF1bk1rdYgL8qbSeNiCb?=
 =?us-ascii?Q?i/BjxG7H98/CueW83NpPP9b4e+y9Tuy24ApnaRcMhv1g4RMml7JkZtlIfzw1?=
 =?us-ascii?Q?MNiYYdUEjQvGA6eVz7N0IDlSb6TUrcSMOnRiT6OZpiBXNLcCw3becsfbuz0q?=
 =?us-ascii?Q?SxSX8dkCbLitqja2nTTNXekNotgXXEGo6CtdgQt1ZaTzss2OLPidE0xW0EDj?=
 =?us-ascii?Q?wj34EUu1aE8mtRHTNP6ZCyspeUUsJAXDpS+hzr4o4gqVWLO0Rl4626R0An+h?=
 =?us-ascii?Q?Opww1o2E2mxr02V6CGqbErmm8INNxqpSmaqaAiIqiQkqkeJ2H+HTc3hvxKC2?=
 =?us-ascii?Q?IRoBfxeWhDyIHNGCeAGyyHKS4lDW7kwzoYUKkCmnTgr/IjzejtMqC5xUXNwX?=
 =?us-ascii?Q?3L2tToZD64nmyws/jXUnm7/SYiuKBTrlbmfYJHWtetWpXvm0PrLB6F/Z36BT?=
 =?us-ascii?Q?j+bGUL/RPGFK/6pUNUVTbb26wlPpUILS1KZo2HJKQBT1l9+8vXpme+/Vd045?=
 =?us-ascii?Q?foVx2fpsVkBOSU8bV0WFoPcqrVixC7LiqzgxBLBQSXqRbV6tgRfCGTSWWvmk?=
 =?us-ascii?Q?EIuMpTHvourigTq1CIffJ4I8GF/N2fKX5K4ABwTgWsqtOjHV1rGXrjg6hNWn?=
 =?us-ascii?Q?5WAlwzviTLc7Y4hRYSwdJo90irl8iRAg3M4z9QepjLcS5BVTDVaIQgSWLkLq?=
 =?us-ascii?Q?RnoxfPJ2XWSummOhsDsAGdd6uyokS3JCUEgBbi41keR/U1FOhHEDDRJNdAb3?=
 =?us-ascii?Q?0RYf8AgBMfxWvTErkUEpJo5c0uccDplTLQCur43GNrGqke2PDO8CIjLbsL83?=
 =?us-ascii?Q?hgLeGQt9IV7DE89hprplEh5IIEgHWF423ha4gfEsq9aEscHWXXx/UcAg++lE?=
 =?us-ascii?Q?PhMJ8JEWIlXlcz6F7EfYOp2HzoT2YvxUVWVfvhkU5pgnw36lsdrZDbjcqsCz?=
 =?us-ascii?Q?mnQuvnCdtIcT2eJuD2D4yflOgOiQ1tTaPKAYWqKyvV9Lkp59wsm8Zr1u/VnT?=
 =?us-ascii?Q?15nOeTpVYnXqAkKPu4o+nuW7sRFYglO8PygBofCzJAJX/ZAGPOtdbawMfhxH?=
 =?us-ascii?Q?fEEKJzKELyB+5YqHCuoJjvxWRicjvX78RnGHljEprSiTss1ViQfUIdtfyVEr?=
 =?us-ascii?Q?NASs1TRJYocufF2el2fXu3nAhb3NOAqx3qPgSUvaV6hj92nmLGW+qL1WSgUQ?=
 =?us-ascii?Q?RwzrFraKDuhgvADnmfs82DReDrXqML2TsrfxjFHI2ogrRhS1T/Man+8KVWfI?=
 =?us-ascii?Q?7SokA9llhcbPiD45k1aChlPAheBTgMnSzcKpnUAwLOyUGZpw2n6MaD0K/KY8?=
 =?us-ascii?Q?iJIe2jC2Oe53AXdSndYWNXX8bq3U2LOXA/HRp17umm71wBUvMAFKbsJKkR4H?=
 =?us-ascii?Q?HL7oOeQ/AVVzgGCNJnzSdqpfXYO6QTCCdH02szg62Yi3HhzL6y2+PYWpAy3S?=
 =?us-ascii?Q?ig=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	cfo63ctQBvtU5EhVqRsvk5sDfxGtB1wBUIGyLrVdQY35wpj8WhLYVQp4mApmae3lCMsOmyi2ptuuflKBhpRcz/MZrUD//JgXrKleQ8hLoQe5JHchTWphdIkm7W0/gK355CorEr7td/UHLZFYqo1I92cjfT0ZS7J7YOVqSq3NCnFOD2Mdp4HpqNzjQOhMn6jFbQvjWFDiLS3k3nKQPg0qBeqjJ4rAQMqr7IcMcerLI5m3+WTZ0iAHGTBw1YPxrdUp0fjanergh5HhYvgSifo2s1vaLigCtmJ7bIInrvdkiafSgve1HAuCpSAnkiegqP+Bk/2Vw8876v9Tb+kHYO9tnJOuV6sZQldwwi93lq1rM0M61xdH2SlTi/2S7vZBdced01AFcr47lzWo2/+0An7o+QC7j6owO32RzNpZiGoRAag1HjEttzJAyXSk3Xyc35DXDTSBpr+EyGM8vhKw2OvUcvCr6O3zCg//gzwOMNN7fkALhrsGQ4sqYf56OunvIGFeXsOWCkNi+nBmVQ/1lc4bbp5Fy659e9pvvMVExWUbbVi/XEu7q8w+sqXuQd7kXmotKGqFoCVeJCviP7S7XQW2HwwWgLB9SedzMNMJziOIrSQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6fe66c7-7139-4e46-ca59-08dc6b79dd7d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2024 14:03:53.2275
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hBLeUENniLdqGT+yT88k8UczTa3MRuguCCpiQxx3h4SL1SmIFaWpgLCPMlToO1Z8LGNZ4SjNA9EGw8qY3bqHpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5074
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-03_09,2024-05-03_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 mlxscore=0 suspectscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2405030101
X-Proofpoint-GUID: BbzFOKmb_nI-HIZBG4PwGezZYNTKgk9z
X-Proofpoint-ORIG-GUID: BbzFOKmb_nI-HIZBG4PwGezZYNTKgk9z

The RT extent range must be considered in the xfs_flush_unmap_range() call
to stabilize the boundary.

This code change is originally from Dave Chinner.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 fs/xfs/xfs_bmap_util.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index da67c52d5f94..2775bb32489e 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -896,8 +896,8 @@ xfs_prepare_shift(
 	struct xfs_inode	*ip,
 	loff_t			offset)
 {
-	struct xfs_mount	*mp = ip->i_mount;
 	int			error;
+	unsigned int		rounding;
 
 	/*
 	 * Trim eofblocks to avoid shifting uninitialized post-eof preallocation
@@ -914,11 +914,13 @@ xfs_prepare_shift(
 	 * with the full range of the operation. If we don't, a COW writeback
 	 * completion could race with an insert, front merge with the start
 	 * extent (after split) during the shift and corrupt the file. Start
-	 * with the block just prior to the start to stabilize the boundary.
+	 * with the aligned block just prior to the start to stabilize the
+	 * boundary.
 	 */
-	offset = round_down(offset, mp->m_sb.sb_blocksize);
+	rounding = xfs_inode_alloc_unitsize(ip);
+	offset = round_down(offset, rounding);
 	if (offset)
-		offset -= mp->m_sb.sb_blocksize;
+		offset -= rounding;
 
 	/*
 	 * Writeback and invalidate cache for the remainder of the file as we're
-- 
2.31.1

