Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39EEB1D6DC5
	for <linux-xfs@vger.kernel.org>; Fri,  6 Sep 2024 21:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725657121; cv=fail; b=LNIV3g9o0Jl1XBRabDdwsC1GyvyVpN1EFSeWYiYYu9qyWugRDn2LQyyTpzcBkDm9iLjLi0UwpTGM2RbEjrWMtNXGfwOpzT491AzK26YjQd0fI0FXfHQt2I+hiHDXaO8SdVMN8rIZQrZeBORMe4gNVkPu71eJ7faNtVgE6hYvO2Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725657121; c=relaxed/simple;
	bh=q1KYDJ4Qhh0l202v9P1rrQPA/UwJyuvLLDKrkFTvPBA=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=s1epQkN83iT/DyU8+IrxDalhQ0zKoMytSmxlG2ulOAwM3/RzIg/OkvvY1ZvCPlDzxXNWyuOXFjWbeONhofBbat0DjfK236PD6uNqkMYF7sfoZpvSeOIvr0ykzqXQYS/2/EH+NtZF+yNBOQzAI1wyJQ7UwznvnImlxTCltIqLhjg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QXaNY5Bw; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=OgBB0Kbu; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QXaNY5Bw";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="OgBB0Kbu"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 486KXWsY015083
	for <linux-xfs@vger.kernel.org>; Fri, 6 Sep 2024 21:11:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=hiWHMHNsG3ZBNMvlOpBnBgXotx9Rm/EMcIDZTYzuxFU=; b=
	QXaNY5Bw7y7SOzotwfxANl6UfDC2whubl+k/AqA5wE2bjMgbSHUJM15/A08m738w
	m62xEa94SxFT4uzOkvccruQVQTz5YdKZnsfoNVU41xhe2VFFLqZLeh6EZZRWmQvS
	o1jVcwSMILI/AJ6l1diDN5leIQ8O3LhTgU+kmH/jZUPCXcKW0RIvtcqyM7kPRY5M
	j8vvJ//+ydz25jKitGeH6JVMM68G0ST6ROQ/mwpHKA7swDoUvvDq38WY8QmD/Ok5
	3CfbT+EOkmdiC6aJNa83Ckqgl/oikMjv8H1Atx5UcLj/ASc4cb7vKgH7ooPRetqd
	63C3jjL2jyNe/rlfeqWU7Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41fhwjjmxs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 06 Sep 2024 21:11:59 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 486J6I1t016283
	for <linux-xfs@vger.kernel.org>; Fri, 6 Sep 2024 21:11:58 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2042.outbound.protection.outlook.com [104.47.70.42])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41fhyjeywt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 06 Sep 2024 21:11:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fREVuUbWD4upAbJV4cCCdOHyr8MmpCjhLo3IrP+Uag9oF65gi4UEuRKCRfdKjQlAN+9RdU91WMenySOb+LGlAgDGY1sNmFYgzbZvcH4enhMDTIi9Z8OFmH+HuWxKghTFwRSLiQQFcxUx7BmA3v07xz8xoxKLxqEirK9KQyXv1tFAR18r9typoRtRhkaD3P/LVB7+wpNyQFYdBUjE4EJ4EjlAGyseTFoa3cXBi+9W3MK9hEXR4tot2jkQw6oNKFN6gKcsszad/5DVJigSTO5Md0ptnbTcw3Z59BPQLcbbeMt/7rEFyVDfy06LiNtNPwieMur8uLwJGyCzAoxuH/ZBKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hiWHMHNsG3ZBNMvlOpBnBgXotx9Rm/EMcIDZTYzuxFU=;
 b=Mu1zn85qymBodzQnBgvU2i7gC80WNhkFnNJkbKn2yxsFqX3ZMBOIjswNVvR+g9mBvTcrr2fZiXo4kyRpqebf2swlnS85MGgZ0vCNfyqlfkecATJdRDPOCpUaZL6ol7rqRLfa2t2wV9rSUP+9y5bIjXFbUqKYEfgiLVdtK2FZWZO0OkOibK72wsPeSOB2wwBlAqdaUH8EVxIuj0iYelNkj/9sVeawzP5pbOB8AUC3YSxeAbA0s9WVvhWQEuT4YTy+H0Wq0SJcSuVOhGnU76hntZJbCJ1exYhQQqrVRZoKnltxZACxPTmgyX81D+xq18sfA5/xg8ejcwbPsm68nqhkGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hiWHMHNsG3ZBNMvlOpBnBgXotx9Rm/EMcIDZTYzuxFU=;
 b=OgBB0Kbur/8wCRUCez8X4IyvG2Xjxxn+YQSAxeIW05gc/G0WYHDGNiiqJb0ljPNSa+Nd6NQByXMQolIy0fR6GLGeWsB+D3zDtMUV1bH10h4Lt15AiSjeSssCBrYm8CbFAy65nwca15nqR8DGYdhf/kacd7Efhg/eki+Qz0JeJJ0=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DM4PR10MB6765.namprd10.prod.outlook.com (2603:10b6:8:10f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.9; Fri, 6 Sep
 2024 21:11:56 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.7939.010; Fri, 6 Sep 2024
 21:11:56 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 07/22] xfs: fix missing check for invalid attr flags
Date: Fri,  6 Sep 2024 14:11:21 -0700
Message-Id: <20240906211136.70391-8-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20240906211136.70391-1-catherine.hoang@oracle.com>
References: <20240906211136.70391-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0141.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::26) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|DM4PR10MB6765:EE_
X-MS-Office365-Filtering-Correlation-Id: 1fa0a33d-e465-4ac3-9655-08dcceb889f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5oEAgHnIpjBH0TPRRiefSwmiG7v52Pg1CBA+sgYrbK5C1bNCKP2wjOG4ngna?=
 =?us-ascii?Q?jTZlcVNqiLNM9C5ZJ7/+wzaFOGUoY9SW4rjMtKa3ioRuCWmNy6kWfmrALwEj?=
 =?us-ascii?Q?luHgIm2KNm74P0Vc7JCbkSaX3oC64LPIGFmXEpu5s0JizXkcgckV5QZuSIKv?=
 =?us-ascii?Q?YL1kQ45JyG3pgZpoos7DuFXklHqEun0uWbUvF14DIEi9rkyq3Z/3kDH2ZRpi?=
 =?us-ascii?Q?ZR6N61YUErw08xbioMcL5APHWK2CRAA7zNLK44kIUMKDpYtFHyQ+Rige9rUJ?=
 =?us-ascii?Q?5Tv7VdcoLMMcNqudDPW0GmTdmO+ZcHB3yV7o/Uw+VKZNolz9PFbsAvJcI/IN?=
 =?us-ascii?Q?YyCohUek8L6No5F/Li/YDuPQzd5bpP3rmeDuTzZxri/WJp+oW7iaom4EgFnd?=
 =?us-ascii?Q?y3W0/XCvRF2zWOz4Z6Yk7LOb+4MqBDazA9ekZGO3XNjjPLOiT1sS2dWmPq0y?=
 =?us-ascii?Q?t/aGA2EjBNKiLcYCsHC8LnY4TCBWQkvgAfCYS/u3w9H+3x++zqlmPOVLNDP3?=
 =?us-ascii?Q?Ew02LPNXCrUyKm0HwPWkX0F6HWoXLHYfowWv47IPxW6lOELe1zKpYQxpUFAP?=
 =?us-ascii?Q?OHKrqXfdOpScE2kgZS87UdtPBpqPX5kLUZpsNZYhjuURZsf6bV9WbiWyg5Wa?=
 =?us-ascii?Q?prbfryDzP2WtMdLVg/HaFmVJJpzL82l/9cFy7p1r6En4S0nsZNqIFhpbPa+o?=
 =?us-ascii?Q?lyr7ZVtBUL/hducjzvMg2Za6//nrUVhust7NExv/PAO2TkEBwzQqIbLW+g4x?=
 =?us-ascii?Q?Ey7HetTVtLTOuuG6deIRSFZEDf3yQ8/GkKOy586cORebXCUpPhXGATmf8QHN?=
 =?us-ascii?Q?pnUlP61h7bCs9BxxwYsUKtG7wRmy9wZJKw1tLOw06cfLG8WEdJJh4HaESV7O?=
 =?us-ascii?Q?wtNn0wt2C9/cmAAxzXMQvTpXHEjZsLcylS4yCvjym1XyiQ6ounfUEcE085F6?=
 =?us-ascii?Q?46hJ6sh4NEq+4UMCqYfQTMpzttrcZsopuUdUpUMDnjlFB/F8HFsbnd/RlfU3?=
 =?us-ascii?Q?2E2N38IC/5yCdXmw288K4yNfYsFcD6GhaBLv8rw9X797qGVX59FI8+WrOvqT?=
 =?us-ascii?Q?i2OAfjsuA4oNGiP57SsKEmfgFXbyYwoTrhcFTjMTzq2tHTLg0vKLVSt5XL3A?=
 =?us-ascii?Q?B8TV2ZDB42V3Z5z7QSV0FYcESH9Q+5r5QM27yBaM/1iyhhI4tRs1agXuAb3s?=
 =?us-ascii?Q?ktOatNxGExEWpPkBYZ0wG19pYwU5NngpU5KUEGeltYGO3Mhn9xrBQpk+d0zk?=
 =?us-ascii?Q?xLLI5A0746epBo1XsRFG6Utnqpn3KhNKM8af4EhziyQKP7Kpb4ay/MENNwJ6?=
 =?us-ascii?Q?pNH4Vqb46l86dxwswprarO8bMpKakcHAQNzFwPJ1TGH3ZA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AU+evbFlA+aSTGViSloXo9V30XrL7CeHNTPcfDURhF2FZ2wALfpnUnMxn3RJ?=
 =?us-ascii?Q?XgIjlehpTPgyUHkEbEKrGGjg0Jit0QZ4uIzR7L/9+c/lS+BAb5NxElOqvfsi?=
 =?us-ascii?Q?Y3nKuP7vQBJ7kY0vmOwspLsLSSd7ezZL3mLcQBEoV71K0Mvf88YYRTEanAd2?=
 =?us-ascii?Q?W1XPDcqonMVuBt8CfgH5yO8BOhd/espSgMMwQw7uMqbAPzQ5BwzwQNA0LIdl?=
 =?us-ascii?Q?ax7dPHbme9jVRyWw3u76gnz+ZC4q6N8wzWUV7Tp/ynn2RXiT6NroknBCqe6t?=
 =?us-ascii?Q?CB6s0DTJup6WdFUA0z4rzz+WpgojYAr3lpnfT0x1t2VtA7tyWnW2hm/40aIY?=
 =?us-ascii?Q?wAqmxOsbJX5oQ5SxDNMc4H7Sw5N3cwAioem5/6Nf0rO/FYyCuEEB06KkUzZ7?=
 =?us-ascii?Q?l503Ry6wrZ845nc7IHz2AJjwSoOaqyM5PZmERA9jkBRuH4ejo7DRmn9o88As?=
 =?us-ascii?Q?zcUPuJD99My/hfHffeG1xqm8BSSc2seYGccqzlCt1tQMIMUbQCjb51AANC3q?=
 =?us-ascii?Q?75Bd44eqOpX/mKPor0Jph+7g/fH2JdTBSmTuu1iEQOl0jBwI41Vyt0V+Q8zG?=
 =?us-ascii?Q?cEoTFf8MUkmRjO7s9rOmdfD65hqTGfh51E5TpgpHULQbXtVO/a5CPCVddOte?=
 =?us-ascii?Q?YaIms/RwaomlALIK8yiXB7mGHG6kV+RxXVHUmAwjlOXG760xjspNYIcHiw4h?=
 =?us-ascii?Q?gWfCuARR759gqcYWkOlE9rnynCd95cObXKz8nMTy24aq8+E8tia9OKpXMrAG?=
 =?us-ascii?Q?0FgfuPlb3R86dl9efFkNznc5pgYfqenoetJ7dECkg5tNyMOaSteNOGGVisLU?=
 =?us-ascii?Q?DYOpgZo8sCXk6UiJncooH7NDWbea4M+6stN35NU+2s8JMe/aCf7b20m/uHFF?=
 =?us-ascii?Q?t3xe5bCg4+F36YBcbjsdi7G2NppBNI7p3dCr9NwlZNel+VdtStv5oWG76GHp?=
 =?us-ascii?Q?bMRYErQ1awn01UDozX8aTl7rsySxMgb1VEy9+h/OsuiGidfB3NUmKz2MI2v3?=
 =?us-ascii?Q?vv9qi5ZJ3JmT7QfTP0eTsilWxkFaXCwCZA8H15y/9jh3XthGencZt4l8PCED?=
 =?us-ascii?Q?8nLLNZYCxGVnWO/shj7u/o0HSBxgpaIVr0FWL3mlCQzSKMw2yaThhB7URtau?=
 =?us-ascii?Q?oxRqcOxj9GI7zOc5hO1uJfzwYsGMZBElwE1SW+Fw7OYXk2ojNLBre8lD6KJ0?=
 =?us-ascii?Q?+Pq+tPje7tUlQWcSr+7DAtRR9T1BYMH/Mo656y9aXzUeQ78P03M39lTb19nm?=
 =?us-ascii?Q?w7Hr/F90/XqSZd2ye6Oaod3AVgSYVKciXeMtZDjoFOqm7G/yYlyilCRkxoCo?=
 =?us-ascii?Q?XhGi2fANT5sa/lX50E33kEhdlAk7iMdKoaeyjfQtgQdT4pdAeHVgStSXL+8X?=
 =?us-ascii?Q?JepwJsviHJBVg6mkbIQo05q+RIPcCJLnd+UAhnpy811xXBRsWZdoZWoTyuw6?=
 =?us-ascii?Q?u8iyu6IXc0lYPg+ClUu7B2E4+bI/1PlnERrKQXk0/bX8WhcgQy/Rn52t8Jve?=
 =?us-ascii?Q?3yHi6TkzqSqjjIh/7QQVyiFbJ+EAa/vWm4juEeAPSH5ak0/J7ipyNtvBvkca?=
 =?us-ascii?Q?iSmR74x+nYV8t6vxrP8Zpj0S+GenMteLJod7FmBiQgYt2y2GQzfxS6fBLuxs?=
 =?us-ascii?Q?2g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YPBSxT8XvFSqrYpVD5EV3EigLadwwN2keiSVo4skK7Hb8p/83HjGOcZ8hCIjeToal/YQLcIwLylckgwU71BumJmWIHsLZJRmCdwhFidmpZoU7pMd7XSB2rujgQO7WBTxIg4ag74NR5MBpc1JRtj9H1H2K64jr+zxsLx/t6QL85PgJw3FIf5dKxeeVGlm3i2t1TKpLvfkoWp7CSyqbGa/T3WLmTSli72nm2A6AYHVMuRpLECNqdO5+laADM6oVt6oU2jiOdOxkHS4QW3IOaqkyT+/FaAWBK/+eEdY1pH6qv2S99ClLJjyKJhlW5jhY3qvyDOH82tWAa8FKKFk9MGST3NQU3DYDB/1jXAbS7M6rbZKvOCAtwoMn/OkE/eEwHNrOn9t2guA7tRZL8sUREuZNIZ+AUkk04tKdhjW/8lk7FxWOSwzEvt8oCltLXpULYm50AXfIzD5n23QKWV6A+KmwGBO29HrtZJUcxZRhqidxmGq2gjYaB9XymU+KIETdNdo+vOREStmXW4RMuYchgBMTDgrA7eq9xhgqsop7LHOgUNjWi71/JqEydIB7R5C57Yu9uiZ2MdyZdd9FT3TSO7BBnJ1p5Mkq6NY4pSeKspaMIs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fa0a33d-e465-4ac3-9655-08dcceb889f9
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2024 21:11:56.4546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7GEMfXc10YemKVNrpUvrfkLS039tpUzosR0QW8pg7+l2TZ4UFfPmN78LgL0UqOdnbvYGBBeAbFQBfQ1V5V9FGg5u/F1YkHevpNm9Hl0HLGM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6765
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_06,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409060157
X-Proofpoint-ORIG-GUID: lRqHYH8uaLyHAXzHHsld81l0zZoGYtKu
X-Proofpoint-GUID: lRqHYH8uaLyHAXzHHsld81l0zZoGYtKu

From: "Darrick J. Wong" <djwong@kernel.org>

commit f660ec8eaeb50d0317c29601aacabdb15e5f2203 upstream.

[backport: fix build errors in xchk_xattr_listent]

The xattr scrubber doesn't check for undefined flags in shortform attr
entries.  Therefore, define a mask XFS_ATTR_ONDISK_MASK that has all
possible XFS_ATTR_* flags in it, and use that to check for unknown bits
in xchk_xattr_actor.

Refactor the check in the dabtree scanner function to use the new mask
as well.  The redundant checks need to be in place because the dabtree
check examines the hash mappings and therefore needs to decode the attr
leaf entries to compute the namehash.  This happens before the walk of
the xattr entries themselves.

Fixes: ae0506eba78fd ("xfs: check used space of shortform xattr structures")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_da_format.h |  5 +++++
 fs/xfs/scrub/attr.c           | 13 +++++++++----
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index f9015f88eca7..ebcb9066398f 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -703,8 +703,13 @@ struct xfs_attr3_leafblock {
 #define XFS_ATTR_ROOT		(1u << XFS_ATTR_ROOT_BIT)
 #define XFS_ATTR_SECURE		(1u << XFS_ATTR_SECURE_BIT)
 #define XFS_ATTR_INCOMPLETE	(1u << XFS_ATTR_INCOMPLETE_BIT)
+
 #define XFS_ATTR_NSP_ONDISK_MASK	(XFS_ATTR_ROOT | XFS_ATTR_SECURE)
 
+#define XFS_ATTR_ONDISK_MASK	(XFS_ATTR_NSP_ONDISK_MASK | \
+				 XFS_ATTR_LOCAL | \
+				 XFS_ATTR_INCOMPLETE)
+
 /*
  * Alignment for namelist and valuelist entries (since they are mixed
  * there can be only one alignment value)
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 6c16d9530cca..990f4bf1c197 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -182,6 +182,11 @@ xchk_xattr_listent(
 		return;
 	}
 
+	if (flags & ~XFS_ATTR_ONDISK_MASK) {
+		xchk_fblock_set_corrupt(sx->sc, XFS_ATTR_FORK, args.blkno);
+		goto fail_xref;
+	}
+
 	if (flags & XFS_ATTR_INCOMPLETE) {
 		/* Incomplete attr key, just mark the inode for preening. */
 		xchk_ino_set_preen(sx->sc, context->dp->i_ino);
@@ -463,7 +468,6 @@ xchk_xattr_rec(
 	xfs_dahash_t			hash;
 	int				nameidx;
 	int				hdrsize;
-	unsigned int			badflags;
 	int				error;
 
 	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
@@ -493,10 +497,11 @@ xchk_xattr_rec(
 
 	/* Retrieve the entry and check it. */
 	hash = be32_to_cpu(ent->hashval);
-	badflags = ~(XFS_ATTR_LOCAL | XFS_ATTR_ROOT | XFS_ATTR_SECURE |
-			XFS_ATTR_INCOMPLETE);
-	if ((ent->flags & badflags) != 0)
+	if (ent->flags & ~XFS_ATTR_ONDISK_MASK) {
 		xchk_da_set_corrupt(ds, level);
+		return 0;
+	}
+
 	if (ent->flags & XFS_ATTR_LOCAL) {
 		lentry = (struct xfs_attr_leaf_name_local *)
 				(((char *)bp->b_addr) + nameidx);
-- 
2.39.3

