Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9893579949
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706658311; cv=fail; b=YdTV3BC7rbwfC9qj1SlGeIKAmkOMkV6Vt1+gzzc4fF26QVTq7anTlArBXGMir4XpO4dyp2jGXQQpHhkzeM3oOP1llycClVS4fPeiGhQF3Qp4wbWYA8NmDQgkhc0GKvr6mr/nKsVGuLYrGviEESTjXuhb8Slr8S1c+m16zRne/4w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706658311; c=relaxed/simple;
	bh=8nJQ6Xfyu8kIESNGyxqX/d3QyLkc7TMEImcDNDV1sOE=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YdhVsvCfjRGzIpt8TkID/BDiAT+o10pj7keQavuDnMrtoUNJWlhVqRgmIWSjN5mJOCRv7AqhnEN3WSlZ5YAmhxteOHRC1cRQXSMa8kXvp1T5FfnINjR8JzfV3GJhonX1HUbrl2cog+gOSTT6GX2oCCwA1SSFq9q/G3fMuyriKuU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YKN8HS+p; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=z2pPVfcv; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YKN8HS+p";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="z2pPVfcv"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40UKx2j0003587
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:45:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=ZcVg6FhlIzOzz73xD+aGgcmYSbYZymJ/o348m+dO8uA=;
 b=YKN8HS+p/aP30P1OH84dL5DdO6+gRLR8xvWnCHm1wOiW14Lqm2t7GolXLPBg/nQc9qQ2
 tVmGqA6x6N/FvsrI+1m/0tlEcf3pYYi0Kr1c7x5gxGZaSG7tpasJU80wfpvnpWGLc0a6
 nPrQEPc6VSwpjV7LPqjtYpyDnhjkJ50xVzwnfm4AlHPfACn5bwnon1cBxrfqPQuEcopy
 TZeo3tkSGizvFNAhSnm42J1Po7yKuOohERogK9AjX/W1TL4+97xV3E6FBKsJiX0oHvHJ
 aMILC3r4rBINtGe6cH2smVHdra+UZYVYohwybOeEOtdtO7TiL+cH66Vqp4wEZHRb635g Sg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvr8eg9ht-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:45:07 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40UNZ4aR035273
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:45:07 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr9e1dys-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:45:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NPAwmMlRI5bo4CPnZWjHV5eaichSCCyT90TOuGx4+ipzaxShEVUS8XNzuOQpcqQrHH79r7H40rQUHHEmV1SKEXjvqDqalSr6kR8WKbasuBlpbjBBtNAV7fCaqxCkHclr8/e3f1HofNLEk2jE22VlqX/DmNpkj2mEszd7bszG/kYcZNtmh6kPl9uQZxV5pLwIemZzGxO1XAgIEcFFFboT1r6X/USgwcaNxVSXfOP7eMrjl4a72ITQPWtkYTRd8oFLi806V2c0iWZLmJkPPzmVuRNV9Vtlmuvixj3kNjE3rlV2ZEQNcDvoBLLm+RrBcJ596kg4DIXqCZHDmQDNBuVftQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZcVg6FhlIzOzz73xD+aGgcmYSbYZymJ/o348m+dO8uA=;
 b=ALYTlpr2f3ak6iypHeAsqVYBxHNGf+VE0eeSPf+CLHi7Ikf00wAIKN1bB26QqKkI2IoLi+O7OZT/WWjzfRoux4skKhL160l36jXavQe5ZukXOTgDarP8+HgB1/fIDQjaXsdcf5bSIpiadTBaY3RtTanQumMXx95sQ/qXz7fd7uWd08VEGYfKiWbvqTY76UjSaAjRTLkzLiZwNTvszAbWmkBphQWs2y5QEptnXYKc2zNpXjhZcIevk8Xps5QUZauGdvtmzs1E5SOn4udoPs2QVTOnuOVvqOqSXEZJusViILF3a01IoQEGj8W4wCmEgIXAiUxXgUqu0rYRzgfDMJ0DfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZcVg6FhlIzOzz73xD+aGgcmYSbYZymJ/o348m+dO8uA=;
 b=z2pPVfcvI9UfVfQCJqTiE+kx4KqZpxI2NyOhP1H58tfHKaZ/fq1b54nfzSNURw5l6pq23pPFWc3+qGchgqFRwi/tAfWE/2m/36TY/thEjQF9QSqV/ZfAcNGl58Cs/lU9AZSuNHYnydTLy1OqeKUNL910RcTCHcMityrcH1gfnI4=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BL3PR10MB6092.namprd10.prod.outlook.com (2603:10b6:208:3b8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.34; Tue, 30 Jan
 2024 23:45:01 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f%4]) with mapi id 15.20.7249.017; Tue, 30 Jan 2024
 23:45:01 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v1 20/21] xfs: clean up FS_XFLAG_REALTIME handling in xfs_ioctl_setattr_xflags
Date: Tue, 30 Jan 2024 15:44:18 -0800
Message-Id: <20240130234419.45896-21-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240130234419.45896-1-catherine.hoang@oracle.com>
References: <20240130234419.45896-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR13CA0003.namprd13.prod.outlook.com
 (2603:10b6:510:174::14) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|BL3PR10MB6092:EE_
X-MS-Office365-Filtering-Correlation-Id: 2236332d-eae1-49e1-a5ab-08dc21ed79e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	qc+Xw7DAbs6tOxh7bWJ7+/AXfEau0Vle0wuGUzsEVbEPnP27msiKREhKRT0DTDyOeL6k2kmB3lVu9/+YMb2YQY3lQSUxozty0tSBr/K7Vz+aAJRZRthOuTTuH8xd9NejXl4OpiflAnlJsFG6aEOreZx4WPsH15Ije5Vx7QSxD832wgo0TddcHBXx5YkPh7wv6hpolqbcwKS8MD031lVR64tLTk8oMp4mcMgU9xwsoHSADitLm8EsiTrZ64Ra50rc022jHHrOuYPAUYKQ9uINlSfwKKf4xhaFTMZpFWSiH1r7s+3q4qb+lhsCLKriaT4yQfJIpXQKNhA7cMkhNQHZ9W8XDA1qeBBEpKWZFY+NiSOflth5RsrJO4CYOrGmPL46fDBbJivC7+cwCvyKubzXOFDJOZQZXQFGRJBMyWXv7cwcqyaT7OWoYNYfAu32ufSBlHndI9xl3VbDdP4NgGc1ZYJDHDpXR130lF87rUPSOE7u8laGhcYJuL9ol/Tp+YbTU188KQRaNuRVvV4IFW829JKsD9bIWJVGgNbqhV4H/Go=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(376002)(346002)(136003)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(41300700001)(8936002)(36756003)(86362001)(66476007)(38100700002)(478600001)(2616005)(83380400001)(1076003)(6512007)(66556008)(966005)(66946007)(6486002)(316002)(6916009)(6666004)(6506007)(8676002)(5660300002)(44832011)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?+ao9WRdwi47hLeZNZlmmvkCfNHbJ6RHasUn4owoHRaGd2wecznc+jxHbXKuS?=
 =?us-ascii?Q?xhxC/Vcr8+L1OUaBYBjqIZEWCYsu+mCYdY4+lUcBBTnP/0vWFc1qGF9mLN7X?=
 =?us-ascii?Q?iUAnCiWlLckBGyUQCo+kcgjVs3mQf7BezAKJRfBf5ZtoQFuOSpl2o2nfcT3A?=
 =?us-ascii?Q?75Ktgu2jEvxRfk/570nXMIqeCiCCMfiH1gk+DFV/ksdrWV7rXYV6ynY77/89?=
 =?us-ascii?Q?TuZ7EjoZbrW0QIdXJb7LJYFLmLDu5m+UJ+Ok/7viODI2CIA7R6JpR/99kpOm?=
 =?us-ascii?Q?lDIn5xed423A5q/zBQ0QjOngy2hL6dxDXaOgEe2JcNegsNkVTSCmngeck+hz?=
 =?us-ascii?Q?wBTYL061icXCvd3JiatFqnm2pthemcWMNcrIeYbz34HPDlywbOS64QFAbp3r?=
 =?us-ascii?Q?ebLgxRmb6MsyHugqS80i/yXRFLj2fioQTGZ1CQuM6DZ103uG14h5uKewrekC?=
 =?us-ascii?Q?sZq7dXi9KoR/L/vWu+IAtEtWPiItBNGy4kC9z7UGdQ5U3rNxBcF769vPqUjP?=
 =?us-ascii?Q?mfwD1rHF18BeGQvkCXT9vBQ9fyWWypGKvuL4ULn+5OLlngMkF6DJ4Vzt6f5M?=
 =?us-ascii?Q?ccXWDUoJs4Jf13SBWq/TmmIoHjc1bobNpUQHkQ+txUhuKuAKSCRD3toLKexY?=
 =?us-ascii?Q?flsN/cHY6+RmLB/SJnYpHLjzcGLi2/7rm5VI4qElh/Fi/WyXRvJZ4lRRgbdL?=
 =?us-ascii?Q?sh2l6GdRgoB+YreNP+GfBfJvyvr3Q4XtqLhP6rClvxOfM+uExjNvAh+m3UUg?=
 =?us-ascii?Q?h3Yz8sCQisOWPniKubwY5dCOHpK4T94xrt5xblxAySorTPTL4/zuVMaEXc16?=
 =?us-ascii?Q?Njq3MN+Rd32lWHmQbrVRp+bwoRyEohbE5e3WoRKP0aRZ/SBvvjKsGjIniLBQ?=
 =?us-ascii?Q?EJVG1+6DuoHJjTuSOXzs+kFx4sIW9nh4VaCOAtVqrjWVWt5wJyNLNq9XY+QG?=
 =?us-ascii?Q?WXO6uT4uheniG784bacRvQoIdgZGaldqwIijeRHBPHO/2mLvDx6BOp6o11pR?=
 =?us-ascii?Q?kI49Ztl/2Vimj6WcJH0BUi16TieLpRbY+jnyiVcBZvMQtEDGXjdnCUfX80gK?=
 =?us-ascii?Q?T8vnIF76kDNT8KnofyqYyX1aDlOwJkTUmcDhifCZJL/QYBbm72qyQCtOpH75?=
 =?us-ascii?Q?63vLuj4Kai5uDTc4yyq+vBdwtq5wozWwesbJ57QjzpoLxQcap6qbzGhoNs4R?=
 =?us-ascii?Q?S/Kx4GDvGUTzT84jr1Lbssyhz0mpQANIb8dQgsbtNz/Q8Udyk67wqbPDrrxl?=
 =?us-ascii?Q?cDCcBs0iqnhTEOfNTB3zRKmlDp4+07mJi717T2A1dAudQh1Zdr1AcvNWZpAA?=
 =?us-ascii?Q?20LYYe6M1HKbUAyj4sttuupBQ6SfF5Vp5EBI1iZ8Fug8Na5NMvKH+F7rJnly?=
 =?us-ascii?Q?zYRie16tsdTTa6IvNXZ5O5W+AcB05LXV+K6B6FvPchaAAXug8C7yogSpzZHW?=
 =?us-ascii?Q?dcpeXKBbP6nOagH9G5PV9s84ezWyWoUuiajAQMogTH4LP86T1L0mUXDIrcLl?=
 =?us-ascii?Q?lpt7S9YEiEXO2RJbRFCgalK67fZ0NZXehlFw11X4FDBqXA1oOw9wnN1x42HD?=
 =?us-ascii?Q?Mf5xG09all7m2uYvmMZGyelUg0o+m3+ac/5HpRkdMSkCEAupcp9rdQyLYjWg?=
 =?us-ascii?Q?gnEdAkuBxqzb3r0CPbi0dGOqkFpA+JVMnKWYnLT3WC+IcMsY4YX73vouK5zc?=
 =?us-ascii?Q?KDXshQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	bHcMFmtz10vE7iDN/eSxAApkGUwotoFQfPjQtzC63+qtgk4S08P8w/lFXHoZu2sUcYytVS9+GV+pv3xFri+qfj4qhmW1FsoMFeTCHcWtBzakNTEMzsvILEXgUYLCGZ8NCmvoF5ldSdkyOuVjMnoMPF1wfWbOXZ8hYpB0c9pOzF9jmhiXs0ooWpWj+qTPIqlzGYoHARtAWrxhNxu8QC+UYM1yjvqsQdXjZQ+m74ztlHwTEW2vVOfXJs01Kn1kxfFhx+PuYg5yBUkz2CpXRTCGIhO3cyUWJeUnBYIyKOPi5MTMc5OV8P7DeG0qhX/9bI6iuUzPjnkikwU1lnOI4iRKq9ZAavJUzUy5AfEtnVGZMtvRYQuC7iS9+VT/zyV2UF2phq16hkMOyxewue1ZyLns+ebu+MwkvxFLrKeRcTV0GZG1OItIZl4m+0HS/XmK+liDQMNjS/zZv9JG9xL9kUNDnai0dq7loDKx7Pw+ng8FiOqSeb3b7lg6r6E9KlL8eHcdfKnRSLj8oP6xQ1eKqjB8JdmppiA+9TvjLUQ6PYpUFHucb+E6LSFb7egK02Z+TDs7IfvaLZVtyAXWDEzQBWsorKCRcw4rV1o8c2GZdQnem9I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2236332d-eae1-49e1-a5ab-08dc21ed79e2
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2024 23:45:01.6727
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /J9TkBDwB0dtHDD9H+puhzQ8fX7oc9l7VTyxS95GybBqb/F3G36m0yl4kkQ3lBzDxsFPr0lY8sqOcEFC9cn4w1GN5h305t5hqHKh80vOn/Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6092
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-30_12,2024-01-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401300179
X-Proofpoint-ORIG-GUID: qUIe0To7cjc5VplDHat-cPCbCNkBqvKd
X-Proofpoint-GUID: qUIe0To7cjc5VplDHat-cPCbCNkBqvKd

From: Christoph Hellwig <hch@lst.de>

commit c421df0b19430417a04f68919fc3d1943d20ac04 upstream.

Introduce a local boolean variable if FS_XFLAG_REALTIME to make the
checks for it more obvious, and de-densify a few of the conditionals
using it to make them more readable while at it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20231025141020.192413-4-hch@lst.de
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_ioctl.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 55bb01173cde..be69e7be713e 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1120,23 +1120,25 @@ xfs_ioctl_setattr_xflags(
 	struct fileattr		*fa)
 {
 	struct xfs_mount	*mp = ip->i_mount;
+	bool			rtflag = (fa->fsx_xflags & FS_XFLAG_REALTIME);
 	uint64_t		i_flags2;
 
-	/* Can't change realtime flag if any extents are allocated. */
-	if ((ip->i_df.if_nextents || ip->i_delayed_blks) &&
-	    XFS_IS_REALTIME_INODE(ip) != (fa->fsx_xflags & FS_XFLAG_REALTIME))
-		return -EINVAL;
+	if (rtflag != XFS_IS_REALTIME_INODE(ip)) {
+		/* Can't change realtime flag if any extents are allocated. */
+		if (ip->i_df.if_nextents || ip->i_delayed_blks)
+			return -EINVAL;
+	}
 
-	/* If realtime flag is set then must have realtime device */
-	if (fa->fsx_xflags & FS_XFLAG_REALTIME) {
+	if (rtflag) {
+		/* If realtime flag is set then must have realtime device */
 		if (mp->m_sb.sb_rblocks == 0 || mp->m_sb.sb_rextsize == 0 ||
 		    (ip->i_extsize % mp->m_sb.sb_rextsize))
 			return -EINVAL;
-	}
 
-	/* Clear reflink if we are actually able to set the rt flag. */
-	if ((fa->fsx_xflags & FS_XFLAG_REALTIME) && xfs_is_reflink_inode(ip))
-		ip->i_diflags2 &= ~XFS_DIFLAG2_REFLINK;
+		/* Clear reflink if we are actually able to set the rt flag. */
+		if (xfs_is_reflink_inode(ip))
+			ip->i_diflags2 &= ~XFS_DIFLAG2_REFLINK;
+	}
 
 	/* diflags2 only valid for v3 inodes. */
 	i_flags2 = xfs_flags2diflags2(ip, fa->fsx_xflags);
-- 
2.39.3

