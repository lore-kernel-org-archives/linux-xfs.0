Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0FD212FAD;
	Wed,  5 Feb 2025 03:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738724865; cv=fail; b=rNEff27OyfMl1ILrvGDEAWKB73BKP2E5ve4xJDl14+p6ylBwoxkQiRJ5D+HOi+9sCpkfLNPC0U8c8hYbX+XqvnILFMUAPlb7GCgQooO14c5P2KxKgBGIJRfUKdHo5Zaqh02JUuqByRmMRHT5XARsHUaG9BLoJv20ohkZ7gWu3qY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738724865; c=relaxed/simple;
	bh=G+oOKKVCXLl9VQK9BXizlTnFBJdGc2gdV/2wnXBf7b0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=X8kkrq8kmcfHM/jawROoYLE/OPIfI4jHNUi2ZMCaRPNEQqxyE+6yrKpSgk/uzbNiX+4aXmc6rMDZAjXvUBXlotC1Izs5LNYr9+GpyUL+ieyXbPPNUugjnd/oNDfR/bS2mnnFN2fIB0HXS589jWsssZCGttYM5Ynmj5Es7XKbtDs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=LgElVVy+; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=LaUwixE0; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LgElVVy+";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="LaUwixE0"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 514NBpTY031270;
	Wed, 5 Feb 2025 03:07:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=ouPV2aICGCvXDlIwxfSUL8F8vqWNZwRw0fwD6xBdE1o=; b=
	LgElVVy+RAFe0aBjdNO/5iIg0JdTj55xt+DeuRtTQ3O5HZ7Z7nrlylVRk418QrA+
	CObuh+7iClbd7t+sHlqmTrI035w9s50R1bPW/S1Lgc1SrWvFpmp+vesmHmPYYQAW
	zBVfTtM7sFEtcOmYl8+zMGz1G9cn2S/IEZQTPjmOLdveCFHOseMcUZFx2Do+4voM
	5zcEuabQ2Lac7iepxYuvhqnitGe4lHCPt6i9Z4sjxeqBpbeGzvq4NB+RulcJV8EX
	ux6oJteiI8SQfvX0Nu0dch5+zaVJk2bWSsd2PSnQy2AhKn4+WEWDUbFKzVFYS8Ir
	1QCUkH7UW9a0MyBsZRByiQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44kckxj3qj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 03:07:41 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51531u2l029816;
	Wed, 5 Feb 2025 03:07:41 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44j8p3uf4a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 03:07:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Fgq5DBiMrZ2B827Q5EEvQ++kV7doOyqbM7CT5WABS1CIZ1Vzz10K/nNfd97le2aUxasJdWRPA6XbREMeKwmNdy/N+khmgKCp/CVGszHukMkBvjySMy52ebYyBid9EU0WhLXzMJx6QSEETulNM1lpFpgiv9e/YwEbLlLvGBabj3f9BUPI3tWULxzHchr/2EtQTN1+rDydgTpIlNBYbp5W37+0E22hoPsNtLavWC7kzeUMmhAKMTusuC3+akuDvidHmAXKi1NXUNt6k4/sVlbECVj3wVNsDRJVGHFUlSEsNPDuClbPNKTRh0U0QFkFidlPC834hTkVWo/fnOOyegrfFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ouPV2aICGCvXDlIwxfSUL8F8vqWNZwRw0fwD6xBdE1o=;
 b=EVoJnEdl4U5bRzeI90JEIQ4skCI+D+xLyicMsHNJ3wUETNUM/6geuSnb+hvXL4nAd/g3a5teXywhPd/8bpEvLOCgIi/nlJbi9MIKovyl+SSCkJCccwEsD1PDEHYToPpiO8SZv9uy6GvEpUbK5IXOCzgFK+spmoC1XBayPuEhNOavFDf3u/vSP6z6rwgJ4SxOD5VZ1btEmDfqQw2Th/oGDkxhpGnjjz7Dttxs1lPLCAyiPzIlDmAa+vP/1MAc5/jkoDRY0FhzLK//3ET+fMRIqbhGW4x9M0vPH83MBqon7YuR/xsjD5Pod3AoIcFWqJcczkZobdmEHj7iDRDR3HAzmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ouPV2aICGCvXDlIwxfSUL8F8vqWNZwRw0fwD6xBdE1o=;
 b=LaUwixE0NxVFs3YVgPfNbymR/1lxMPcFaDsadd+eM1EYHvKiwmAf0SQKUhDjr2vWIL5PxJR1mKXgWyn5ZleqLeMefHe3jvrvm4FWIjK1GWmp3mJJM7MNPJLo76LjjVh+wt1VK1aT8map/gbUlH7khLihOdawEzMs+yqYKfO4lRE=
Received: from DS7PR10MB5327.namprd10.prod.outlook.com (2603:10b6:5:3b1::15)
 by PH8PR10MB6477.namprd10.prod.outlook.com (2603:10b6:510:22f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.20; Wed, 5 Feb
 2025 03:07:39 +0000
Received: from DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::43e7:5b82:9069:b402]) by DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::43e7:5b82:9069:b402%7]) with mapi id 15.20.8398.021; Wed, 5 Feb 2025
 03:07:38 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: xfs-stable@lists.linux.dev
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 01/24] xfs: assert a valid limit in xfs_rtfind_forw
Date: Tue,  4 Feb 2025 19:07:09 -0800
Message-Id: <20250205030732.29546-2-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20250205030732.29546-1-catherine.hoang@oracle.com>
References: <20250205030732.29546-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0112.namprd03.prod.outlook.com
 (2603:10b6:a03:333::27) To DS7PR10MB5327.namprd10.prod.outlook.com
 (2603:10b6:5:3b1::15)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5327:EE_|PH8PR10MB6477:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b6798fc-e825-4243-3e12-08dd45923efe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sxMPuJNU0c8qCOhbwfX/XqzLpscImA3RnW7cNBzFu61yfT442ilDk0MEUeF2?=
 =?us-ascii?Q?X/pFPzOsM86DUUZN6Hx5TIU2Zm7EqQm3O5sdebJrEmvlXzhMcSMfqit4OAZI?=
 =?us-ascii?Q?3bo9ZdGlAsFOnUXdjGnHetPwhBHRFjkaNE7RLtXk9t6+a2VO6TwbFr+UgueT?=
 =?us-ascii?Q?nSy5G2Q0/eKJGdsT8i9qXc393YaPzii8Rm2sJHRkhOrncvlo+ktbUvKQheL6?=
 =?us-ascii?Q?a3Rgfxo6ziBw9DOikNKNuY+63SBzxROsi9V7VffBZBizCFgrqT3tmKAjVjmq?=
 =?us-ascii?Q?7YcStGRsgQhl20ExSK/BosJzpqIXkXF8HySS4RpwTNeM0/IaXuObbMebAGW2?=
 =?us-ascii?Q?dcrmaIYKS/uvpmPyiTrlLGsvOjKYiSaOPg7h23qPhEsX2q6IbzZ3+OaGg35n?=
 =?us-ascii?Q?w/eYwvc8MkGQFv8tYoB0ikmg/RYUlsTfV/lLEBYn5PQj+WuhXQfMBDG1tlDr?=
 =?us-ascii?Q?e+uc8ChSeA6bLPVUbnGjydASTrV+506r6IahS+42hgmww3bv4MhOY9BCoXbm?=
 =?us-ascii?Q?9OLGsmWuqz8gQMpKlf383iFUrE5BHDIXiY5vzCiTvMAB3dDtelrSXqUi2rAS?=
 =?us-ascii?Q?q2iqCDsBxbhJj+oi6oRmuwpI9uV+jncR1esjs6/VYy712iRRW+2f7fCgMuhA?=
 =?us-ascii?Q?BGr7qZCBvWNCTwHvCQRz5uuLXYXPvMWQc4rKY/r910uQ4p8AILD6q3aXW1eE?=
 =?us-ascii?Q?DakYPB56fdY1pmCMdAXNV/gcvt+zfP1eBfzYAqTyV64iMCLiQMmNTuutxkE6?=
 =?us-ascii?Q?T2d/qeRO/D+aS1um61g1VQrszaUiyGTX9buwLBvNPcLfQ6Oli+aSThJT/i0X?=
 =?us-ascii?Q?1sPTpVUjg4ByxXmu7QwLarS+SB4NvVxyXA4iffxYGFIsRs5DCLsBT1DvpssK?=
 =?us-ascii?Q?7Q06zYtCLnB/XZ3D/8On5PQf5U1NxHFjEWc1tir8i4yyJdmd3Ju0NmTjat2G?=
 =?us-ascii?Q?6Cos6QIUUwCcLIou9aPnjq2yVr+NdUctz+sb0BqCB9hZ6ObLcF1yMx8B0rcK?=
 =?us-ascii?Q?YUFROEuZwSFqL7J77D/fRp7pf3BWRH6CGZQw+DhFOnIRNepLqxnUHqVmoWp+?=
 =?us-ascii?Q?TWRZT4b5TQgNW5vwq4Zyv7bjU8qF1+dI019FFLnEQJYs1A9APCSDat2xZSg3?=
 =?us-ascii?Q?5Auqe+IJMJxxvQ0yvSYNzfpcAKaVjzxS2/6dUkKU8E0FgTsmylDFHDHI4zG9?=
 =?us-ascii?Q?Nrjf8v/B3YzORCWrEPa0bFo6oTipb6j+ZnHiR0qBCYv4VOtxLsE2NVOA5upZ?=
 =?us-ascii?Q?vEPtzEHp6Nop5TIqNjb/d+2dvugdYuZaz73OcQXLN0SqOoPQNHRfHwKNyZpQ?=
 =?us-ascii?Q?5CurQPBSjF2ClTCGf/oa45fao3rJYQYVNb3nS1+C/ksu7rtOk7a7K8bTblXl?=
 =?us-ascii?Q?qh0AMqQ/g5m3sOdv7Cpjb21gUui0?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5327.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jFE8OU7/O4sifC66Cu2yJsPmomyEHjNiyK7iR5b/s7tI/lGqm6MowlNP2CrD?=
 =?us-ascii?Q?Q0igKjjsQuHvYKkiqmYK6liSYqdLlD24uEPPNaYhA1/m7kEhPH7B4TE6EG/D?=
 =?us-ascii?Q?A6AmxPEslYZYstMgr/F28Xm6Wjm48tbFDwZxJaJtr2FzpFIFYA6ID/M3mpIx?=
 =?us-ascii?Q?OYKoeyLkkQX7rwBFKFVab7ji41G0b6w8vcdCdALyRfg7PjyKlr8T5rRoEpGA?=
 =?us-ascii?Q?oyXAIjoPPB2mYTpBQ72fF4SLo4Mgzk1jX5nqhKjSEVd9yHGAiL1wR5boDejV?=
 =?us-ascii?Q?Tqgn6bk6BC8cY/ucJAFejlIYHKq5UGTeC34r3iAxGobfu+8z7VGzOq1Ywq0p?=
 =?us-ascii?Q?/l4q8uc8YbnaJ/nJAz0l7iBSD0wF6sXkwWfo0BOjKacojlnuyjjU6WNk6PYH?=
 =?us-ascii?Q?8Gv7baTgm5JQ7m5ACPVXQtpMneyTRWDgvHWo1MTyb+owaIXLUWHsIenbwxIu?=
 =?us-ascii?Q?OHTP4J9kfzm9el3ZLfYASYvkeKzWoTcZlFRSTUy7UcYCoxYnX2SliRRMyu9o?=
 =?us-ascii?Q?9PBxoO7sxbwC/xazBo5g9qwNGNaDqp2N4hY3PRExxRPIi6X1yvD9FRNxWB+V?=
 =?us-ascii?Q?7MIrv4EaNZsQ8iiG+nuV2BR/+PtoFfAV7mGiEboI3Nby5AnMy/c1Vp612Jw1?=
 =?us-ascii?Q?GoLV0ceo1iurmy/Ua76DAb+eF/R0QCYMWCNOAm4whZiU+/jL4qvm+p86WAVX?=
 =?us-ascii?Q?OF5g++BoOWvmcbGUpMarNv7Sb1iQ7IyEkyBphsifMWr+gyzNes2yGdF2Fkkb?=
 =?us-ascii?Q?jdVn25p714HK+OZIF4mstbrhqYl4dHWublIBtlpUlklLoOQvGS0rx9w4pcWi?=
 =?us-ascii?Q?CmDNO8Q9oXlnUQcBE50VT5+i/oVjjigTn4Qs7tstnUrf50fF/pltaIo1C4OG?=
 =?us-ascii?Q?DVfnBYCzmfVIWOMvodEGiSQ9W3RvA5n1G7tpbzvw2seITzdisIk4OoqeRg9l?=
 =?us-ascii?Q?t6bRsTIyFb3xcmj/eXQvDIHYRo4OK5swnvk3tqMglyuQb4QjavElGARvDvtY?=
 =?us-ascii?Q?1eOYULfJh1FVCSY+Xar8wdjJIBPXfWHpN/ADH+qFk4xNOg25DHR4LrxjUVq6?=
 =?us-ascii?Q?PY7ghFWCbAoLfk9aOnrtqbzMZouA45768GfV6/BJpm48CgdiZEEItpxv1c4g?=
 =?us-ascii?Q?R4tKouatA7a4w9w5YMmUnWGFoEV58swbZ0abKNOX5bng6NrZ+9CPp88lt/D2?=
 =?us-ascii?Q?MBfuNy/pgiVZJ/ThVMK2HHpeo5US54TQrdaYrKG3B29KMILuMYqRIXxzfoVy?=
 =?us-ascii?Q?5nfpxrfLK1KmvHGxM62eR0gpnMJ7SLTVZNXF2iYwBEHndtB7dSO7BcpaN6pB?=
 =?us-ascii?Q?vOhKFO1Wnm/p/OQ1w/glM2FVgHwfr3zhuVHKOmYFXiryfI2Nnl5iWQK6RiX8?=
 =?us-ascii?Q?NhYU/3HNyMY/ZWAm7zXLn194Wm/zplWEnBp1PT5WuZ5DF01HaSTJklDqrkVh?=
 =?us-ascii?Q?DjbmeLh9MrERk9YVVnKCX4nUiSQl7PGdtiNgUgHrhYILxISQIkzjQNF7hDsf?=
 =?us-ascii?Q?LI6A4rTN7tUsmTxrcyKjS1Ia4G3G71bu4f12/qghq1lX1npp7kCvqqk4Xr32?=
 =?us-ascii?Q?BUlRcWWuHB9A/FA02hbv7MeAHwLz2EID7youbljAol3Ayv/0FoBHmU1TZG6A?=
 =?us-ascii?Q?3l6CCy4gLWTA1YLlIiM8Hbd7L7BMqOMta2b7rZDSbjPtFFWrKPSt/9QuOFit?=
 =?us-ascii?Q?kq5/5w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	55lsTgB6+c5jSC5NsbVKraZ/OrnUQjRkGIo4MCgUYqzOl2/L4wb4FTMtLXoIl8GiEVzG7zeYLJu8U2uCGILbzIkBqiQHxhyEkNzB8lklBLdFKHWpWqOLuTPln1yx5zDN9STZXfmaZ/zN3z3/66NCbkQMPPXKA/ojkb1nb9fUxJF5wEv+tZpBJnG1Zpk1nuXVcHiBpx4knLvRLw9VQRN3Ufw9jwFTmImiqldGbC5hVEBe2zC51k8O28ubEIPOhPO1U0NtBXZpjb9mCZ0H2ApysM2IoEeVa7UQWJbgk98+qg4c9EB5+5NS1W0904YjIYOj9lW5cdIAv1TlqbVb2SZJyo5jWk7wDAAGjmXhta+qm/tlNBMZ3j92mG7GnVNhm+SMYpgts2WDu8zG8kNXvRwf8AatKH+DsxzOBr2KCYV16g3kqJB3dA7D3L1wZ1pX20yZJtDzuNUlzL3fRhhSQCMg7zqyxbZ7HKsQgmehNLZBbPYlPOqWC75MEVcWaYwHtPZoj15lkrrbpdNfqYcXwk8vQhH6+CsBOhLIPFy04WcSm8TswDVs7Tk6uSsMusPo+8pkNoA6nsB1E8n2d7LG06ziftjmtynpCqTcARHPXWDYtTY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b6798fc-e825-4243-3e12-08dd45923efe
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5327.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2025 03:07:38.1990
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pmo5GAcAqLFdh0oJ/yhtRJHnYATfA6C4olxJ/GQY7vTdFCSMIAZn8iRlhIt0ET0pZc5q9ENV6WqlovRArbQ/kh7qTgOPS78V6mGaJK2fsKM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6477
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-05_01,2025-02-04_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 adultscore=0 mlxscore=0 spamscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502050019
X-Proofpoint-GUID: x8QwSoHfrL2mJ4EYoJcUnDIqfTOhI_mN
X-Proofpoint-ORIG-GUID: x8QwSoHfrL2mJ4EYoJcUnDIqfTOhI_mN

From: Christoph Hellwig <hch@lst.de>

commit 6d2db12d56a389b3e8efa236976f8dc3a8ae00f0 upstream.

Protect against developers passing stupid limits when refactoring the
RT code once again.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_rtbitmap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 760172a65aff..d7d06dc89eb7 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -288,6 +288,8 @@ xfs_rtfind_forw(
 	xfs_rtword_t	wdiff;		/* difference from wanted value */
 	int		word;		/* word number in the buffer */
 
+	ASSERT(start <= limit);
+
 	/*
 	 * Compute and read in starting bitmap block for starting block.
 	 */
-- 
2.39.3

