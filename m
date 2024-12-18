Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8573270815
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734488083; cv=fail; b=NqbqMFgRiqN8nbYxJiVW62cWlyhK8mkkqZW2EGiccJNWqTwOch87Ja3YWx8ysGLGx0vxSVnwciJsEr1riM0WR6kutXQBf+GHU13in8VUz7q0rP2/pWzFFIXdzvh92zLClQwT4uHH60pXDZBG89D6E7RtYCXEAal/0ewgMtAqK28=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734488083; c=relaxed/simple;
	bh=DDEG/9z3wPiChZ+8MgRKA+QyiEBiHaWy560hdEfQkDU=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hR5443ID4+sQQv2FvJTNS6abLGImMCFz4k9EMJjZ0GS3hcM463w0WIrjN60BlhX6F/aTgFuBik8hkRrbv09prOLN/J52wHUZh5ooHBvgMLoTePzADni0Y/6l9fTEjYz37DV+fzXU0iWwE6MDhFRWNYBScqnjRsMhYIZKdfID89w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RsDIAye2; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=HMvfSTkx; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RsDIAye2";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="HMvfSTkx"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BI2Brvp006239
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=b+nVDA7iikEzFNWGjlIlqKxCjwwgpI/kDGgYZMYwix0=; b=
	RsDIAye2NF0hgte4SRfB4gXme9ko7JvR3XFZ2ziT4xvqoKgKrkp42u+YiyDmHayL
	9ITtWtCmfj6YkiU80C3v9fJZXLb3igBzZTFMPY+LKx4YcUeCCqcve9tpQJBlP0qB
	f0CVS3i9YQsGvgX1WmaNr9A4GggPlBZRhBnASKBnNtRz2hKE7lNZ1d43QoSkhmqE
	8OUjuDLHMM8NxYXzEQmkPlA4s/uJ69JxvnaaJ3LFvAERro+KyOiGiecaIs3ERsnj
	a67MGuqDkx4EhOFzfZ4kHmaXxPRgNr3VB8tudFcVAJejck6eG097Q3TIYTzZY+ui
	XJROY7sZ35L3G1bTmqBmwg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43h0m07ntc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BI0dED3018376
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:39 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43h0f9fbxx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vzp+f335dW/4pqEE/gyasrDRF8PkrUpSWLKK+7HG7B8SlecHrVmMRWYhL7yrNtfKYJ4FuM7qIQpc45Wfm9SvfAX/PiTH69stQybAyp/k9OOsJstg17UavIED3RSFeGP/DAS3GyXNWlPeUoKfaNXh4VYtmFs9GBKzNFz6eRlzX6rFtM+ZXS/4kSBrIGBi/o5hc8HgQv96+HyTrz9OIemEgrm1KkwcK4zAhVRN5cbHd7iTfJY27zvjqukIHF7RZ1F4Ju7j0XxAWDWbL3s19utEW1+BFv1/sjqaH+0jgLq63zNjKpajlPO5lWJMesQECnMlQfiwc71tWzKA77mIQNmSFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b+nVDA7iikEzFNWGjlIlqKxCjwwgpI/kDGgYZMYwix0=;
 b=shAlCZNRWvkjsPHRob6FS7KzylcLZ+c9mXE8LRJPjY2ozgxdHeflB6ogTvIVGdc4tU2GDH2fVu2N6+W8BjqIPGR0WtEQV8OAo6faYsyJRrdjs9W6LUZinjkgZAqy1DDrhmWqMYvmRYVcSQPwIsZmEG0XLxFv0O1DoBWBN6pBoZ7Jth7/Ls90jTf/eHeDhy3C7m+vQW+ixHPjWFQNMXOyvMfKNF2hhRCNHdAKdOpRiuZK0lWoKuZkzqM5x1N7M3VzFdIHh0kEibD7H5z9rxevYT5Ar+JhDlQNYCIbekwg6QLJayvXfYIK9FxpH+dRMd1Rg3PmJbpm4w5KyHfYLHfamg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b+nVDA7iikEzFNWGjlIlqKxCjwwgpI/kDGgYZMYwix0=;
 b=HMvfSTkxGFrduPzAP2SS0xbKTMCeW/oK/OgzeHR10UwXN8bR1lCwCLOSG6a908gN0igsJS4IrA5Lh8TJzR36hA+J/HUVL/oRCf9uogIVxQ1yTHqKAlIB47xqtmfUe9JEFea9iZ1hCxTTnYPWiScrRvjgKDGGeVgs8A8WYwF1aZY=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by IA0PR10MB7577.namprd10.prod.outlook.com (2603:10b6:208:483::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.22; Wed, 18 Dec
 2024 02:14:37 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8272.005; Wed, 18 Dec 2024
 02:14:37 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 13/18] xfs: conditionally allow FS_XFLAG_REALTIME changes if S_DAX is set
Date: Tue, 17 Dec 2024 18:14:06 -0800
Message-Id: <20241218021411.42144-14-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241218021411.42144-1-catherine.hoang@oracle.com>
References: <20241218021411.42144-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0206.namprd05.prod.outlook.com
 (2603:10b6:a03:330::31) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|IA0PR10MB7577:EE_
X-MS-Office365-Filtering-Correlation-Id: f512d69a-5396-4e86-e4ff-08dd1f09b8ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|10070799003|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?o33t8lJ8aoH1XJHvzxR1gwSqAHhR+iXfBb2NqmKDjIGQXwg7qSH46OUP69BJ?=
 =?us-ascii?Q?pl4obdLkibimTVAGpIadDoNVJzhcSRrM432BYxd883r4AvYfBWViuJ3q0Uqy?=
 =?us-ascii?Q?6nL1Vo6SCUQtcobsxdBGtdBkUCBBB1x0SnWS7aq6D+ozGVOrJdtg8v8SdmfS?=
 =?us-ascii?Q?C8j78R+yGfnY+wkotS6LDP43lGZgDdJVLzP7M0PkTt05IZ1lB1ilaKOXr0px?=
 =?us-ascii?Q?PsguLm8n9Dpe4rngguNDhZM1UGmgTLu/8uiDWS537YSC2gTVbkzOZ5ECupie?=
 =?us-ascii?Q?YNWZEOUoakwwD0G/9F7lpe/b0vkyq5Z3GAxspHginqbY72kpvDuhNjwLizNZ?=
 =?us-ascii?Q?IJkwxyiwbVbcUWsv32D0rmK0m9G3cZiP9Mnt28QBP+a0vhFCXL4sgFWSmhac?=
 =?us-ascii?Q?mXDtFvv1LO0hzNtg1Xsiy4Eu7UFsKsXTmpZ9nfBWhNoTzStsjhfmjr39FiBG?=
 =?us-ascii?Q?Fg6/eUwRObjBCuwaUDwuIbPYrGFVcGyomLJ841z4H1SGfFPNJw6swdTH3TnE?=
 =?us-ascii?Q?ZGJ0fvJZXZL+voFRB7AtQM4fXz56ZOA/SAEKzs9GDegt22QQ6HKCWdqKlkVk?=
 =?us-ascii?Q?bAPvlyNZwaGRifxVP1Or99eSGNo9+kByJxKgE/zjETqPWd++F01jBQCpVq9K?=
 =?us-ascii?Q?UNEVDjwlCrQyGZG9X/TN7pL6OJ1q17xSDgEDmi2BwHlW9g/c/J5z2fQAY79o?=
 =?us-ascii?Q?0OipRJKkTokBSHQD1w80jS9dth6RlvJvYPf3EBO0Xrespd/TbYuaV/QrgpRm?=
 =?us-ascii?Q?Q4vLyZtojqSbNZweTSykrx1IbgrzHnDmKTLYjqHbyux9Tu/VMd6Jj0Ah9tRm?=
 =?us-ascii?Q?nTbbrAEq+oCvSyRLrOzFFtH8kfnz0vXUl2eX4RuD0b9tCCcp3Ew6csPwP23b?=
 =?us-ascii?Q?feqeECkUsDYqPhEC0GujmvZlLIdwDDsOtiq4v3g+84r5a8AH/7O3GPHVsW/U?=
 =?us-ascii?Q?Rrn79is4k3lLDqf0tdW2hPrdMQd9i38VLOEDWMKUC6leUOVf6Izn4buW20iU?=
 =?us-ascii?Q?87JzZryLj6MiYed3e/JVk3op94GFg8Dcc7Bvsm2xxCK9+Cclx9FoLo9t8UJQ?=
 =?us-ascii?Q?OBVe8oMY5aRk6l9iQOSrQk/oZvWD+8Ta3YeIGBt22RBu41f7MtWTYpXZ6E2Q?=
 =?us-ascii?Q?b4jK4v3Py1ne++ecS8zime/ZlIFsB3WbHl4bcHnmwStsoCKSdnumJj2MSwFH?=
 =?us-ascii?Q?DNoKWm4ugVG58jafpVJVHGFcA3fZI2kLfNLqI4r/2rvJzbv1CpQ5qsliB9RR?=
 =?us-ascii?Q?Z0DuBRKU1xm2mSgyMERTUDtbuB0ugbBROv/Dzlt8TxD5UJ8GbPGXyBpuk5ql?=
 =?us-ascii?Q?7QLU8/evm7+tPcSjFl/x2B8wlKRN3UFL7Nb6GbTxg98cSMWnlH/h1kKqPlEj?=
 =?us-ascii?Q?fIJkCvwAECYeTHT75uwzrDVla1WV?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xDkAO9LcS9C3YacUzHbIA5DKUsOGO4otvNP+Zn2nGi6qAJHLDRD4zi+yaOLd?=
 =?us-ascii?Q?z9Je91F4jwrmO5MWwQkeeFWj5+uo25QlNMWKGXCbwNxxhprS8ceCU7FWWk1V?=
 =?us-ascii?Q?gobrzOR7sI6Wp9Snes3hNQap8P+OjlGHeI0HMhUNhNFSRUevCr8k3d0I+Fxn?=
 =?us-ascii?Q?V+4lyXftnE7dpM3NBbsbbWleAs0YTl8DBjoM0dzHK9WntSQaQ2j2Jbr5nYzi?=
 =?us-ascii?Q?lM9tLmubRSYWVOINtwUROpawBqiW5WYlw1Dk816qaw/2qboe2stOSjgD48hq?=
 =?us-ascii?Q?A2Xg45Os0/TiLQ6gJnJ/irIaIhrmsiTohw9WPRuKZBxg0zrtU28Wp9Ex4TVd?=
 =?us-ascii?Q?NJwrLqQpzKWIRtK48nFVLUMCn8gZZ8Gh2gEajXP20iVu4irvofUNYTF4psku?=
 =?us-ascii?Q?az2gns0GOe2x4sGZmHUfeZzHAVR+V44/R07Wmqho4qso8brXuIdqZ0O4OY2n?=
 =?us-ascii?Q?mRgcm5uvkfbDJVL2vjBUj8xgvcQ0wX5mlJeLdJK0U+4wdsT18MsOPtXp0uoK?=
 =?us-ascii?Q?MmJEHbHOwnxgHTr8UfJ5mcq/Bc6rIau6KWhe+Ryq/8zg0p9PkKSUaT4D37My?=
 =?us-ascii?Q?LZoFt1C+LvpSOUkino+vrjRYwn7itr7ZOmm8WH9sSvG51z1RjZqHvWSP7D4U?=
 =?us-ascii?Q?KYLR9xUTcS55OR7Hhxcb5diVlm7jQpLV2zqTv+trwYNQVojI0GCMGk0Mukct?=
 =?us-ascii?Q?kaS8Sl/G6+L0kdHrAZcCf0tk78IvpN0osiroZA/ipcRgiYhRJUZMgBVGcYg0?=
 =?us-ascii?Q?u/CXrh5JkfHL8HkOj6qngRMq0O58mKskm2PlFzWQjvA8PEaGlV+HBD6iq+DM?=
 =?us-ascii?Q?Oay7GQm1EkjN4p/KLsKV8i3Ja6X70xN5XXn3fgjshFmOWvbSWzqIXfRu3YgN?=
 =?us-ascii?Q?FYkRyjrdfHR874oKGhZo7zmMy99hiCFGs+MPGpOkhTGG1ctNYNzteb4ezsXn?=
 =?us-ascii?Q?WoYdtd+s3VjBnS7YdnjVsN9EoXjY9dzf3OQCgL1l6C0ayx7NAdgIZPss9OuQ?=
 =?us-ascii?Q?Qy+mlpKbdgcUzcJvckMVdfuQZkYgfvdKzumXUkvilgP7z+RnK9kdkeh7tI7Y?=
 =?us-ascii?Q?RoHabkBuYW0z1OrIUCRtaiqQGy4CxGvyFGl1jJ3ju9n5nY8GVfvIb7oTmCaB?=
 =?us-ascii?Q?uFVnvLRt2I9f+XDlJKgLMSu8BTqSx77SWj2TH8exZsJA/UQYqDg5MGBz+AOV?=
 =?us-ascii?Q?exI3+TnEIiqYMA185aIaO1Evh0ZwenHiJ28L9x3/LmcIA2ceJCC3e2cSxpex?=
 =?us-ascii?Q?xP2YiN8LJ0jSMBqvJmKXAcNGRcvwf+b/O+N18yAaqe8yUvPS2JW1XmqNW5fs?=
 =?us-ascii?Q?UJ10p8XXKeEEH1GoEFxp5Etd5KJrXiViYMMc9WJenQXccDoL2K+DcQZbPXT3?=
 =?us-ascii?Q?rLSCnOezexkdhTupTJTRsNjTsxnNJ1rT7mhmUUKn9bJPpVfPXgLpv8WiFzjO?=
 =?us-ascii?Q?0zXh+W/w75muQVu/k5PjKQuChQ576ksEfnRbeRGn99s+FXV4tl9NFP2sBbf3?=
 =?us-ascii?Q?efOEqo1QOY41qtLfaxjvxIpexhxMu/3LdEgKN4ocVH349aickwi2dgfUijo3?=
 =?us-ascii?Q?GXAt6Xacxa3hD8JZmY42vNqxzc3iiX3bGyUyHqfBnWbqaWsLHCt4Q7+woWGW?=
 =?us-ascii?Q?16k1eIiIVOT+OwFPMUdRnpT2wgpkh3ULhuPUasNUOE7irF3W+4K8PtHI979b?=
 =?us-ascii?Q?+PZ1Dw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Mek7lqFYZHF0vUiwvEpIj7nf7zYnx9KRgd5EDODppiifCw1yUOwTtYM44Bv6mp1OhXIqo873LjsOv/mhM3lleTlTvnQizjTPG2IKCtZA3FcAfbxwkdrrL04P5W9CBzMJ0r7O569aptquQxRGY6n2gDXoregkzYMexQvsA82Z7hzoJVqNT3WGRfgA7ZPK9uAq7lDJ+sQ1pQ50BPHoGjAKu2muwQaX7QTv1JwNg3gapz13So2g1e82O9/wP600lz5ezdHP3eZfSUkm2Ncod27MVxa+rXQUgvEzMFOSAHDkiBsqfcsfCKqVvt5Io180dQWL+Lz8oIw2+CHGS2Q3i2ZZd9grsmz2jUuTYYrbX1Mvl8KsOCaCwGnGHXZcx/tI4o0VRi3uKL7FbAx3MYr0GFAytRTYKrdmqN4BwykS8MJHiJDbebmTR5cmHN7UPE3neTTIHGwUHGjJuLdA+uX324PT3l55pJE797EjkIZIfu75X11HrNPyyUbdwziHjVZyhN22eb+jfYthQB6cbekTYCE4d5GXz5zIrMMWbdvzJ8GvFGF5U5FPqjSY0VspWqvfzWcRnnUR+9J6YRdFHqeIWBINp6MpI8dkkgG0Q4Nmyf0dzHY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f512d69a-5396-4e86-e4ff-08dd1f09b8ad
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2024 02:14:37.1684
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CiSDoVtic9MkX4teCOn5IIjRki4kqj32OQZgB7Wb+I4yo0ZiA/aHYp21yHvKBPmxcSBcqLBxXxoENMVnkdWEDfaFDzjUIitBhMbjO+NpaVw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7577
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-18_01,2024-12-17_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 malwarescore=0 spamscore=0 bulkscore=0 suspectscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2412180015
X-Proofpoint-GUID: czt8GePKyptWDf9I4r3WO158GgF_piMR
X-Proofpoint-ORIG-GUID: czt8GePKyptWDf9I4r3WO158GgF_piMR

From: "Darrick J. Wong" <djwong@kernel.org>

commit 8d16762047c627073955b7ed171a36addaf7b1ff upstream.

If a file has the S_DAX flag (aka fsdax access mode) set, we cannot
allow users to change the realtime flag unless the datadev and rtdev
both support fsdax access modes.  Even if there are no extents allocated
to the file, the setattr thread could be racing with another thread
that has already started down the write code paths.

Fixes: ba23cba9b3bdc ("fs: allow per-device dax status checking for filesystems")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_ioctl.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index df4bf0d56aad..32e718043e0e 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1128,6 +1128,17 @@ xfs_ioctl_setattr_xflags(
 		/* Can't change realtime flag if any extents are allocated. */
 		if (ip->i_df.if_nextents || ip->i_delayed_blks)
 			return -EINVAL;
+
+		/*
+		 * If S_DAX is enabled on this file, we can only switch the
+		 * device if both support fsdax.  We can't update S_DAX because
+		 * there might be other threads walking down the access paths.
+		 */
+		if (IS_DAX(VFS_I(ip)) &&
+		    (mp->m_ddev_targp->bt_daxdev == NULL ||
+		     (mp->m_rtdev_targp &&
+		      mp->m_rtdev_targp->bt_daxdev == NULL)))
+			return -EINVAL;
 	}
 
 	if (rtflag) {
-- 
2.39.3

