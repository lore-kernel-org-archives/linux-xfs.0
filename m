Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E92A4D7D5D;
	Tue, 13 Oct 2026 09:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791884429; cv=fail; b=HyFzPhMWtT5l7komnI6mlp+Chb5NUEWIs9sqIA5/TY1c7rAPRRoeV7LD1XFo2s/FLmNU0bIzc36RoNvvvOgpL+IQg06f7aSec9XQItqwXRD0SsdISRyKWjN6oV+aGy3DL/HVLrRS25UGdi/tZtKsIkeUO10nTof+cvNetKQbfw8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791884429; c=relaxed/simple;
	bh=Nnoa0vu70ss3DbiAl71w0JKE9WVMReNq7LowQYH0pbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ajedrsPdsfo336fikKLk8GB09NdOqeGptuIgwThcwkoAjRN3LkjrWWqd763GGNk1yCXpA2NY9UqHWQ+xqOwYWzOX2Wt/yDuWa6KM0HdEC+X4MLeQ1Dw8YOIlnKk3j0xupd0+e2U2o6TSSD1v1TRqLLPs5eIlB+u3efpbeexoaOk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ioaOpiNJ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=LvyMgIRb; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ioaOpiNJ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="LvyMgIRb"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D4QsU73251786;
	Tue, 13 Oct 2026 09:40:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=xnXFJlowAbH33sUZegxon7NLwItV9gCjeigtC38feQc=; b=
	ioaOpiNJuaGDZvaC9t6EnUHTHxxH/NgegpAeC/UA6GyC/CSRVfeo29cYh+J9jK8s
	pq36DEN2+Gfwh0tZlcMbrwzpcAwMdt+rBln4gD0JIyk661mNAH9LQYR53GDzMrCb
	yA1+tN9uh17eG268i4PAt7UBAvwfkYdFl+B6T14lsuM6YpvNHbZQHHRvgUjLOUrj
	DkVa6F3LLka67w8C8W/tvGv8ThvoG6e8aD77y9KoQnNWFsy5XrqUWbl4ldiAeQ7c
	0WXyWZNShQQI6LtGO2TSJBpjnoHLfthjuU/It3TnHIF/G9mzzBvUqsS9wBskKCj4
	nn9ZWT5Afrg38UcujOfJuA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7dwtbpc8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 09:40:24 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D9aTpZ010875;
	Tue, 13 Oct 2026 09:40:23 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013020.outbound.protection.outlook.com [40.93.201.20])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7bt9d65x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 09:40:23 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EoSojGeC4kL8jqbpr5hSTJ6KV5R/J0eJyLqgbIaZnRuWPq4/Ab/S8OTnF2KbonWuzr6cZTZGnInguJPnAghNKdfxTmokGbrybxeBoDClheyg3SIAQTBPSt2Y00ZpalOAlXXu+cni1Ax0582knH3dU/R80p2+YqMuGr6LVPoAqr/jlQCkwdUKNvoCzY8u44pf4sGASxAqpvtx8dkkXxaX+2pCdsUh6EIIJsyqOHX1FgmqR+0DbTXCaTPi2pC3StDotTE1RdyvuAce4cEf9vf+YkOYYZAlneHkMH69MGcdDPzebBe6i5FULT0IAUz7ZU9Tqcs8jiD3OVZsINtqHwdv7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xnXFJlowAbH33sUZegxon7NLwItV9gCjeigtC38feQc=;
 b=e2s/k53AOwEjuLAvOj+E0rHN9+fZI4/SElUcgmqDV7eOMPUaIhWG4kjduVnTTEKcsxjL6R14WgD36Z0CruedHXRCEdqeJarhY4MNvvExbC+ioqh0rzvGkBDuUAmcc8/F+0fcjhvaTaI+kkmk91Xz/+RO7aY2YKw6F4B6+vIQdPXBWsuDHiEKI5KHGNFst5/z81xLhvG3OdB/5mkkGk7oIczGdo13pTtz+C24St4uxL+A6UWGZwQDY7ZH+l6qjTBxyYIwFh10AGWqGtuxcCv4K69rPTsG0uSdfIeaCbDGOgEIAft4O1h2a7A+CF6D0Uw5XpzMpRvdzQx/VRzx8+WeGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xnXFJlowAbH33sUZegxon7NLwItV9gCjeigtC38feQc=;
 b=LvyMgIRbK5YaWXO1Fo/dHJtFwf6OIfsTEA2qgj8YFcR1ZS4ZOMojvQej+TChhiyaM5aYjNgANssh5T4ePIwhtvAE4wPX/OA7rIYpjtjlNKCUGU6BzjLYUvz4/C14hk40bqymTIUKySxICeKyA1ob0Ht43QfFYBJUZYKU0fEumb0=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 IA1PR10MB6145.namprd10.prod.outlook.com (2603:10b6:208:3ab::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.11; Tue, 13 Oct
 2026 09:40:19 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 09:40:18 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>,
        Mark Tinguely <mark.tinguely@oracle.com>
Subject: [PATCH RESEND 5.10 v2 05/19] xfs: hoist recovered refcount intent checks out of xfs_cui_item_recover
Date: Tue, 13 Oct 2026 15:09:34 +0530
Message-ID: <c2d57f03837daca139818ad131134ba9e41eb354.1791883301.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791883301.git.siddh.raman.pant@oracle.com>
References: <cover.1791883301.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PN3PR01CA0003.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:95::14) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|IA1PR10MB6145:EE_
X-MS-Office365-Filtering-Correlation-Id: 69ed2392-7e60-4001-5f89-08df290dfdff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|376014|1800799024|23010399003|56012099006|261009223027099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	sJubsUGlHIPP7uYiUCOfheVZE8pZ03ygInAFi2BWq0U52Q1B+CjMCQjN9cEZ3vbq9ITqLjjq57nTbF6/I+1FE2yHHz8L69fmSIZprZ9szHhb5ibt829T5oiLbLlJ1ky1ztXrzgVz0/E0xmnM/GYIu94q1WW5d1wpjxiJVKFjD+2MzVM/a+eII8UCkJjZza8YwoTbfRNMCIXsppTTn+fs74IVSbCqxRTlM6yXmX2oPrQkGFFmPhOK+/F+TqitjbeuvBZLujmSogX0bkcn7Z3Tj6KoVGqLJsLCNxeyV8yMTidgo8riWpTPqLdRNPVxn2ELx8soLig7IzaKXJTkEIblZP40+4+TCZBnuWMRDCfMd2fej0wfbQ/Bjtuf2r8ErVDxJDQWzmDxb2AH2IokwNhir+Y3lar9LuEcYGSax5vs9lISdd3FXHq3LMaeF5PHespoZguhkNr2+6lg6ioKLCdQuta6NwD+xq6TIyNgEpA7QRlqEIVrrPOALBPlkIUBw9h3v1i8hh3lKO/6YTY6IJmCKuZETzop7V+4SvY7QO+8mI18SwGnuUw7QJ3lGslC7pYJjzmiyPXAEClQ8wrWkUdSc8cO2Xx8z5RggocWYhESCdG/2g/pOmtrKogdFDaqdvy9keqs/4h1G65RYsEoNd4FsX+aptczGVAbe6t+c9+Vodg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(376014)(1800799024)(23010399003)(56012099006)(261009223027099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2vbMc3OH0wazmPX+qgADxJfGqZUFpTwHTFn1d58Hl0W4GIxKokvuFs6ca6/H?=
 =?us-ascii?Q?/z0qaNvWsoLhyG1kajp0yFEty7fg9iYaQusQ3Sx6q1qUHCv476tnu1aOj4AF?=
 =?us-ascii?Q?LjlLBpEJXs50b4mZ595FXEjskUFdcVD++h15u8+YkOBV8/AX+dO5xkOQcoB7?=
 =?us-ascii?Q?l8bumTZ4bM/wU0+j6UNrEqmgdn2yvRZDmr8kUlyIXKaw5qvHY7NDUNwjgl1h?=
 =?us-ascii?Q?paKNL8QyTDc2k0YaPtw4izjMQOkr7JE02IgnyU6MUcNufgJk5eAbkaM8kd47?=
 =?us-ascii?Q?9uMVidSV9caQFBoRofSTzMNxui8rbv0zsqa/RzHkeB85zJDRZxJUUcXiLr4r?=
 =?us-ascii?Q?J1qdZjXgywakkCutRSL/Tc3m9ncvrjy0O4wbsYJ20ye80YCnZQ7nqnt9oVMM?=
 =?us-ascii?Q?BTqj6RcZbL84QpjLNvOYm27Mp84fuFR9JBKHCHBDqT9oaA9tCudgWsAe6eXi?=
 =?us-ascii?Q?mFCWhVzfvfkZ06OXTZsmQh4nvtr+lREDxBkUHKooGg63aHMoAFRnXQs+fvSO?=
 =?us-ascii?Q?lYfTreOI7soFGm1Q9FeZ7jLrmO7B59PsF9Hca8cl65fFuz2w4Wa0BH28OBhE?=
 =?us-ascii?Q?V4yfI6KbHi1G0AbBS6Z/C5BXRsPZJvwVZ1X0YPC4Zv6C0u1NNqPTon6mxAk0?=
 =?us-ascii?Q?zmTmT+Zi6L7NsDcLmEwum0bhFoomDaNO4JvNWPFcP8Drjfx5Ubf0NY+1LjYf?=
 =?us-ascii?Q?95xMqh+21DTvowBwetDiK8noNG3GVkZNB+LIMr8BoYDjgSFj1ZhMGFv/wYo2?=
 =?us-ascii?Q?ygRjGp70fSzkIR5bSzwuWCd0GDxBWVHKkNnIuWf4koK3v32oBRKIkSCboQJm?=
 =?us-ascii?Q?6Adugg90sWfmvh263Qb8MAlNBIP7pOfZH2x7Yf3jGCjFAVtxmejSqlBu1ObL?=
 =?us-ascii?Q?azHxRHYA9k1VfMxDxF2wpJigJBQuQk92LTNbPOyE4pdkl2Z6H5tR6hFVC9lt?=
 =?us-ascii?Q?9WQ3rJrZUVGoWdbnHBOhfutZhv0w3B5dgpOlnGGWVLJo3A+0cSVSgVpSyoE3?=
 =?us-ascii?Q?UPc4qWaO/L0YvoeNmj/dD72H8ARhRehfCOYfNqSIRvdYQKfoxWJjDMGIsU74?=
 =?us-ascii?Q?ehIZvrhBfR4Muo6IkIQEnm1MRybXkTofVvROen0nwOX2zx19w1bsW1jHBqBX?=
 =?us-ascii?Q?yAPIvsIRQepqmlX/l5VWNYvGF8gNv/JVL83GJOBkQVoGtMqx8Q6GOq+IG3+H?=
 =?us-ascii?Q?R+Go9zvkh6Hrhjrj4BIULgFFNVJB0VS9rmReus5ig1B2Ipshz/EAHz8u4sEA?=
 =?us-ascii?Q?JbqAdn8OdgU/2C3P9HU3Ehs2nf35JdkNLcTdItbESnYJm/ZfRIoT6CN6n076?=
 =?us-ascii?Q?ILkNvZaAt3yYihPeJWiYNEMpOLjVrVPeDAsh6Snk9LdmljlbdaCRzefiB8KM?=
 =?us-ascii?Q?aaV5M3RBHwKeMws17IThExB3QYrH04Q1oe9LhOMHVvsxt8AZhawRhXsixYb/?=
 =?us-ascii?Q?jwUTqRm+eq6zsh2buS1cwTQ/PbUCOdRG0iz4UiGf0rIw9NXcyHqzwXZMapix?=
 =?us-ascii?Q?OG35HBpM+nNsOP+sICs3oAqT0HxdyQ95y3rRueUplycjBCKpTz47ppp9x//5?=
 =?us-ascii?Q?d+GKWQrKtyRKgnrMHgo2MTFUxQrOAU4Cq9WatXtZtvVmTKZAWjfpMjDEg7Bu?=
 =?us-ascii?Q?qRq9v/Ab+EYz27cX98dtU7EXNjb8IepeFd4L4J6S6K8bN6Ex0ek5fFAPo5B9?=
 =?us-ascii?Q?5saLxz653gMGUFziNb0pQwb/YhYrJ+SQpdVDHh40cqs7gLO19iySRO454KV3?=
 =?us-ascii?Q?PljXf+ftN4y7/ry72jemcwgZ7zeReG0xfPV9J1sRVNxnruPllYYu5iq8lHRS?=
X-MS-Exchange-AntiSpam-MessageData-1: +8zPI1OP6NxYB8MsDjVL26sLakl15HADmVc=
X-Exchange-RoutingPolicyChecked:
	sWhzpiDTVTI0FLq2dsBHYKF7aeVomb5GRG+i2RzQhSsVVmPJbmc3kJ+MXTJ5irHo6d+PepgBt0UpSZpcFt8qL4ZfB/o3dYwW9XWOnwAXr6uE+bl7OndiYyjOZ/HNLd8tntssbgJdfwHyU5xj/+/enaAKniLweq2E8oFa274e4V017MbAzkRdMv1hmsNufJqqkssvgx42MXSb1S9rpmRqa47CL+vwf3OT67MiKMyb0MYc+oIxHh9i1ENFJc/ncmsWMe/j6RY0dq12MZhSco9/lcOrOC4OJk37Xs6qC5N5G8lSd62BQURoHHo3NxzUrYFBx/FwMKM3DBHX3f1wDrZDqg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	30u/a/t/oaV5vEiehvEuwLPLu5qS4AQNpZlJIv9NYWmRf7+EqbWkIzGqpDHqcmmzvcQvPivSwqXlUXEORfPYgwSp8XnDtM2bwIWB48EdRf/j4RkoiykrgiigrhJ9ChCaJUZul8TQd0ccPw+fwzkOrm0JfQVqAECaRDNN9abVS7pj5BiibMqoL5E31SJep6sNcqkHjNnM4+UtjugW7pjLRGxClHeUzyifyluxTkzOfww3+4h9HGLDdDVpT7M05qFndF1+cqQsA2RuKIXtYmv6msswfCz1uqRHQUN8gggbsIkQsXxvMepNhFhKG6KlW65KNx8oy//UXR4l46Vfo/xM33CbcYdVN+LJSfQTs8Q2BhBQl4oDwuTFFJLCaQi2O8JO3AnInWaFEQ/ynoG6TFldV7AaYuLnOlnjuL5XCopaJ+Typzt3yTdgpeu0bejLw8IdIafIM/AFEuDs9reo2dmwlRlRD3JxYM/W3A7wynIb6GXcxqMgDiKCpZQMZYDdmBUzP9Sh0L4C2lx0dJuW4Pr996X+i9HrQZe9bVtO0I90kioKa3H9kJ62SOYHwfm3Dlhl1LAeVjHIMsg/tGDnB77LaE7vKRPyVcYKIL5GwP95/HI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69ed2392-7e60-4001-5f89-08df290dfdff
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 09:40:18.6250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0RQvDXUMcHYqQYc5FjG52Pzz6BzFzQ7GP92t0AliYQgl5Tx/jrY6wkVJ0iYca0+IlDOvSGdbhovJieU+8O+TP7ZFSZ6UATwRlGuDe7j5FFo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6145
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 phishscore=0 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130038
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX1SRfWIYVvjb8
 050fXAZOGzFWHVJcsLdOM3lCBJBJKjwUh+4AMrCQCLxZ84T+kOYx3D/GPC1HXdDOQ9eAMj2EWOe
 oKGnLiVCwS4RRH75qLjjYTIa3jjRrVOFxCU1cJTejjGad6aas0vINP4UifCdcvkTZ3rE3an9WeG
 IzsHt/soP+/v2sVhAa0VPRtMWbUoDGcM67YRsdCJrSBGmonpxi2oJbu6IY43PYJIi9zPE41igqu
 WQxG+zKCiaZOlTy54MRht+smdLiY1piWdPI1cYmfTVI4fbqj/e1FsslxVmlA5Qgd45cbZHYHZrg
 BTAN/NajgBjoe4Abow8gWVbjmC+eB6I1GyEUmMljlCeJFYR8fsR22kTxCXr7uKRUcuwYvBI4JO8
 hNUI4YfuWwEhuuuykXCqjQh2Hwt/LHpzm8Xa1kY2JqBGor8l9CZa6TjPiUxiArrI/tt6mvXQCOb
 tjr0xAFdnpjSpsctBcA==
X-Authority-Analysis: v=2.4 cv=Kp7YSmWN c=1 sm=1 tr=0 ts=6acdfc88 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8
 a=XUHDQfcMxKEf4e_NL1gA:9 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-ORIG-GUID: AfMNiubn5jBlwsr-K72pjEvljh8u9xE9
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX0dDkw/FSIDq6
 2rpE8XLJO9VIUexiTw6gn88EXrrlmIWwismLtgsQ23JfsyctJNaTdJbGJGjnLFVmgKXmMSGcHTo
 /3fNiw7LrXk2+tDmzSzRS8cLXK0+SgOLy1o5RGO6GZNrWZNnVdYC
X-Proofpoint-GUID: AfMNiubn5jBlwsr-K72pjEvljh8u9xE9

From: "Darrick J. Wong" <darrick.wong@oracle.com>

When we recover a refcount intent from the log, we need to validate its
contents before we try to replay them.  Hoist the checking code into a
separate function in preparation to refactor this code to use validation
helpers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
(cherry picked from commit ed64f8343aafa62e762c74dfb400f640b6fa6c15)
Stable-dep-of: 7b5f775be14a ("xfs: fix unmount hang with unflushable inodes stuck in the AIL")
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_refcount_item.c | 59 ++++++++++++++++++++++++--------------
 1 file changed, 38 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 0dee316283a9..83dddec08f3c 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -417,6 +417,38 @@ const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
 	.cancel_item	= xfs_refcount_update_cancel_item,
 };
 
+/* Is this recovered CUI ok? */
+static inline bool
+xfs_cui_validate_phys(
+	struct xfs_mount		*mp,
+	struct xfs_phys_extent		*refc)
+{
+	xfs_fsblock_t			startblock_fsb;
+	bool				op_ok;
+
+	startblock_fsb = XFS_BB_TO_FSB(mp,
+			   XFS_FSB_TO_DADDR(mp, refc->pe_startblock));
+	switch (refc->pe_flags & XFS_REFCOUNT_EXTENT_TYPE_MASK) {
+	case XFS_REFCOUNT_INCREASE:
+	case XFS_REFCOUNT_DECREASE:
+	case XFS_REFCOUNT_ALLOC_COW:
+	case XFS_REFCOUNT_FREE_COW:
+		op_ok = true;
+		break;
+	default:
+		op_ok = false;
+		break;
+	}
+	if (!op_ok || startblock_fsb == 0 ||
+	    refc->pe_len == 0 ||
+	    startblock_fsb >= mp->m_sb.sb_dblocks ||
+	    refc->pe_len >= mp->m_sb.sb_agblocks ||
+	    (refc->pe_flags & ~XFS_REFCOUNT_EXTENT_FLAGS))
+		return false;
+
+	return true;
+}
+
 /*
  * Process a refcount update intent item that was recovered from the log.
  * We need to update the refcountbt.
@@ -433,11 +465,9 @@ xfs_cui_item_recover(
 	struct xfs_trans		*tp;
 	struct xfs_btree_cur		*rcur = NULL;
 	struct xfs_mount		*mp = lip->li_mountp;
-	xfs_fsblock_t			startblock_fsb;
 	xfs_fsblock_t			new_fsb;
 	xfs_extlen_t			new_len;
 	unsigned int			refc_type;
-	bool				op_ok;
 	bool				requeue_only = false;
 	enum xfs_refcount_intent_type	type;
 	int				i;
@@ -449,26 +479,13 @@ xfs_cui_item_recover(
 	 * just toss the CUI.
 	 */
 	for (i = 0; i < cuip->cui_format.cui_nextents; i++) {
-		refc = &cuip->cui_format.cui_extents[i];
-		startblock_fsb = XFS_BB_TO_FSB(mp,
-				   XFS_FSB_TO_DADDR(mp, refc->pe_startblock));
-		switch (refc->pe_flags & XFS_REFCOUNT_EXTENT_TYPE_MASK) {
-		case XFS_REFCOUNT_INCREASE:
-		case XFS_REFCOUNT_DECREASE:
-		case XFS_REFCOUNT_ALLOC_COW:
-		case XFS_REFCOUNT_FREE_COW:
-			op_ok = true;
-			break;
-		default:
-			op_ok = false;
-			break;
-		}
-		if (!op_ok || startblock_fsb == 0 ||
-		    refc->pe_len == 0 ||
-		    startblock_fsb >= mp->m_sb.sb_dblocks ||
-		    refc->pe_len >= mp->m_sb.sb_agblocks ||
-		    (refc->pe_flags & ~XFS_REFCOUNT_EXTENT_FLAGS))
+		if (!xfs_cui_validate_phys(mp,
+					&cuip->cui_format.cui_extents[i])) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					&cuip->cui_format,
+					sizeof(cuip->cui_format));
 			return -EFSCORRUPTED;
+		}
 	}
 
 	/*
-- 
2.53.0

