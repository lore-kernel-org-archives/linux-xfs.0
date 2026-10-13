Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FBF63EB11C;
	Tue, 13 Oct 2026 08:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791879285; cv=fail; b=sCw8Y6uBxr2fiXBZlYgUADjSyEM+qFeauA+p/AxZGjGJegmL7Xv+K/oyUtQtbRAdkw7CYRG1/hZoM4T1zNI8JydsXQKjr6chSTNWmfMyHNlgfbxW067cocPVrXcWkd/80l3vO4LIsu/2rmVlWP9fX8FbxmB/zGQsXZxhxGCWmPk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791879285; c=relaxed/simple;
	bh=cgCLEnL+WmgQyXi8XZx1/Qs7yfjcZxr3JO6rTPmt+Sk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ixZziuEtXvsQLUbDmT5iYP8SZ71pO70QO706yFzlp+WGyeQ52t1ZjpQCkCJdyq+FQTi+8YFzOq6lFy5wa99BOTcv/LuoTAJHdFX4qX0LBNSnOVmi3hW8IhOVA8EaFAl3wYV4AdKBAdi8CfrGKYvDwMn4V9qDi1AWdB3ohJVLiTA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=q5Pu0Oo+; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=KQaMYYOM; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="q5Pu0Oo+";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="KQaMYYOM"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2CVev3201616;
	Tue, 13 Oct 2026 08:14:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=7HbwMLJQmB4ZVegqluQgLTHPltUqbZKMXAttcPmp85c=; b=
	q5Pu0Oo+KtU2MGUY5sh/gYpxx7ts+wT9ndsCXXGvEbRqxGBtquZ6xIi3QLj8BhXa
	ze4bqxQTZp3Ale+F1a6K9a1QJ3GTCqMNHFArSyMRG+CjqVjI6C6IWK/N0KETE+iE
	058nsQQ14cKKEcrv1+C2mXzVZl09tYTnhmmrqi7o3A3H7+WYcGy1uOb6XDHkgrQA
	5KlhKPCf0qSiB1ZJpJ9g9A9nyjYHNdPQuc4PI+6XdnxyL9NLhVIlv9mmMTPJc0Jk
	fJRScjqtAfKIQjsfSFTdqCj4mJWNlYQL5g0wP89DRb8auL+4Kida83ASrPMTfyMq
	qmch33UVYaTBhQTkRudDGw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7demkkc7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 08:14:38 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D86gsK033468;
	Tue, 13 Oct 2026 08:14:38 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011049.outbound.protection.outlook.com [52.101.52.49])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4h7btnxr18-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 08:14:38 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P1ngXsLPwDPm17tkUJFGqCp7VKlEoiVayji/Cf7GauHv6H/bHLcJRw+LcF60tJzGYgmwyYDfk8eWwLcTWyLRC30dWbAEX8rDz+4BE873fVyfgO9O2+BJMdQxJ6JjUpNfor5ldn9ElJKuQTJSt8Tmj7pHrK2KT/7A4oykoWzvtm42wktJDsponme4wmX4h+YmJAl4cpy1Xrtd2gw2wLMGuEBiS1GJuqFEkgZVgL7/Qy0Qtu977OLRpdpmAmd67i77kfA4oepaycSaIQrNygfnAFBHp9a3Vpj+IUogrAxLePc7nQw3CZhiGuOcvhcJq7mnsaS4CItvm8qfoPGgs8KKxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7HbwMLJQmB4ZVegqluQgLTHPltUqbZKMXAttcPmp85c=;
 b=JGLrO4jttPYz+qC95Zc1XYv9haA/kq8L57EXQnU6NV1qUje2LTfUxtRwIBrX8ybmO9XVzBown6uWjfQIRF/w+WWkzdilX/JV7Fv+86fYfRfeK8tAU5K7v5IAsUQK+WXBxQp0DoVvCzAm5r92Vquu9U9Y+c8CBI1vHCqbDzXM6TVRc7aOKt0eXJLI+aSTtjBmpcIiMA4COwJ84Q0m2tctW1c+B2F2Pz8HwJzWF3x4B5T+CMWJZoyhYcRrhMzl2sMuGI1ieRLil6nv0drsyElYufeNNcRs9EiILuJYOLAztpIBhuzIkqNJc8IqjaS7J3Leu+v7x8TAlaw1xUBa1TvdyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7HbwMLJQmB4ZVegqluQgLTHPltUqbZKMXAttcPmp85c=;
 b=KQaMYYOM9f6wJEsBymmzSeaGH772sbqepffq0yDy1a9H5auRsDIYiSO1/YQ8gb7y8B567tyc2w0KQxl73qD16jNW27ByTblXYqC1vF5XhI9aG0Jt3dUczvzcJUSHmjc6VcZPaOWGjy97vzX6ipM9883CoQiiPPofDZ3ArU92moM=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 DM6PR10MB4138.namprd10.prod.outlook.com (2603:10b6:5:218::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.12; Tue, 13 Oct 2026 08:14:36 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 08:14:35 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 v2 3/9] xfs: fix super block buf log item UAF during force shutdown
Date: Tue, 13 Oct 2026 13:44:11 +0530
Message-ID: <a32850e5f8c70d5d5c9952694f70179c3c42de0f.1791877866.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791877866.git.siddh.raman.pant@oracle.com>
References: <2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org> <cover.1791877866.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0060.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::17) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|DM6PR10MB4138:EE_
X-MS-Office365-Filtering-Correlation-Id: b6b93bf4-2561-4d40-10e4-08df290204b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|10070799003|1800799024|366016|56012099006|4143699003|261009223027099003|260925021911599003|260925021311599003|260925022911599003|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	dLno+p/UUrcILHHDsy0RQldycGziTdCdsfqTZ3mqSRNj4oE1b12VJpKXY1HDbRYldh4pPwF5YykoSJJwNmln9tOBMCsHry+/luT/Su8CbLBnVtnxP+OYdxwtdB6Wu8gPxX5HrguwfCjL+AIFIzXBFl3Bt0/El61KBcRkpWQrmzs2vjar2U0UsVRrGHE7CwQTTIPy2ad6BwTLLpf1VpL5hS8qGBx0Dv0L0s7T0ySuH1Jpu2jlU/CA9jCMunFrfwIGWompBOeLyb78q5e9zKD1TYhFfwPinJEdZeNDpriprlZDBAlQI4a3U+uYZ98oVqlQBMZJKOeva308gkpMoH91RhVyJ7KP4IO91vD2XZGm0FBFlscZ1P8t68mga8ui7q2Er/wbq39Wb/SIWIewu8Iq6k9q61pCNvcfd6tZRmze7oiRENXfEtD7K6lNolF+jUeCUwcykDAwE8qEu6CRfZ+Ovr28SrlUN0KT78yBWLBHrCjXYte/Wi7u6qgOmnGlvgj5RrB7IJvLLMJa1A8AfWGBRweWMOPhtk7SGml9YC5eLToxA8WJG1WrUI5zh1Qk1VsRKxOVHI/gtvjIno5HfttajhHUKcMVMfOJr0tskMMj+sxWoJi1CizfKOgHduWU1cANo9Y5kijfSV4FFZYC4RfXxl9kKBHYCnMdeN/TR1oCVBo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(10070799003)(1800799024)(366016)(56012099006)(4143699003)(261009223027099003)(260925021911599003)(260925021311599003)(260925022911599003)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8PDiVRdlmIs2pyiUrh1JUBZEpiYCMmo5COBYur4yeaIcVsij/KIZ26D7//xr?=
 =?us-ascii?Q?uuQ/e8WE3dUpCVElJ1YE8CkVO+JPLTpW0rynI0fIrLesE+ct+Xb7+gCwL+U+?=
 =?us-ascii?Q?mMnah/tcFquIbDVyDPYAGcNvSfGuWSLJ72xlSKbVXuo0pDiW76mh27U6rv6q?=
 =?us-ascii?Q?Q9YzX4GyLqrr1oNP4kXY2QMvEmBtFTyQs1tp3QtyVzs80/srtp6js0GGc+bo?=
 =?us-ascii?Q?7m21qj992S4mR3WVFajKfo7EM0otgYtNRy9QeHSj3Vx8fmetcUxvWyC7EmWF?=
 =?us-ascii?Q?dGzq86OgGlEnpmTJgMt8vdJ+3YMQ7AKcj9b8w89IQieNEl0l64bkJl8FSCxj?=
 =?us-ascii?Q?69lJ3k3QhFnV63diXlgN8TjVors8J0EODVC6fdwmiwC1MKGMdoQOdqgHoqB5?=
 =?us-ascii?Q?fecqfW6Hkb+qJ+fFqpaRhTJr4oSAw3KhCSu4CRkTZJ8ujZjrc9OX5jftcpLA?=
 =?us-ascii?Q?YPX+TLOLLTpTRKsbAbPiZq4wZ7RzaMCcv53SryzKNv5jZkSpeRv73ZZJ85db?=
 =?us-ascii?Q?fedJ63UhsjweufN0AfRBboE7vQ0sAUoaT3VqmcJ3oqFINwyfiXPrTyEGm9SO?=
 =?us-ascii?Q?y8RvlaiTgo24l6z+Dqlmfm8yahtcDdtxY1FZGZCRPFxauG0/HMuk1OOE9SDF?=
 =?us-ascii?Q?fhNWU4dpBgDHPSW4gsA5VGD6ZOjwX+8Ob8B19YazkFHIyc4ZwxYy6m+4HcSz?=
 =?us-ascii?Q?51oFt3+HbMcbwOpbdL5812OcPNLL02uJ0uBE/9XYvL/aF8rgaer5sYE51B2R?=
 =?us-ascii?Q?qQYFxURk7elwRyk6UXLut2c1zbeZ1xBkvkkM57vf9Jzzprus6oobqzi/Zyx6?=
 =?us-ascii?Q?/zJS+ltOlSXsMXyYjySruElfQ1uLC4AZqTkWiwdOv5VIslyY47PbVqa5kMhj?=
 =?us-ascii?Q?8ShQMFY6t78BwQWIxxgYXwEEzL8BqGq+aZwASPQzvd14DVZuMDGE3SzCK+ma?=
 =?us-ascii?Q?/Tuth5AIppmf88Cecxx+pH8S0OujNsaTm4+iOEA6924El4U/MeKKfJQUhjsB?=
 =?us-ascii?Q?RMUE9FIFO8z4GRmo1JJAb3+RAkKqPK8e097l4Mg9X/FQ+pVrXWbNkS2mKOOO?=
 =?us-ascii?Q?XbwHkXVIKnKdbChIr1GCqv8VJJj0g+EL9QVej6GGnPjMjFrWsEi71hb7Emkh?=
 =?us-ascii?Q?m1ojY8bPrIAv/AcGSqf4oPqoZb45sztJ/rPW9/7NI16KjqlMBu4bQ47D6CUn?=
 =?us-ascii?Q?+U9J5J5vxPpfbYUI6UlUbhfN0R0bVbv9oNIVJxo5MOmMWwIKUdYogE8gzK4W?=
 =?us-ascii?Q?/h5Q2r+yXOg/8sVOFu+d9KuNCQkCod5AKM8RVTW/32XNg1+Uw2soNDVTJ+3p?=
 =?us-ascii?Q?rlp5T6RQdjW9duqR2oF750xUjKZ90j/Umyn1pmOP8FC5kfQ4Q/7Te6EerZ8t?=
 =?us-ascii?Q?Yz58QgGy9HNCwEiUkBVxigK8LH7BxbWfLiDgXNlGICu4K6exOu2Ril2riI74?=
 =?us-ascii?Q?6OgO372OyiOBPttxsbJfDiRUwfU0JAUo88flVNyesm6RpoCYcN4eo2seckoj?=
 =?us-ascii?Q?KUJ9KJwxQmnqcJhb+cNDEiuykUUZhwv3d8coa0idWTB98nfy8C8KZ2Iq6ntK?=
 =?us-ascii?Q?rO/TLINQkT/e+ATa5GLEFryfefCMw2FQgyf52iKaP/xIsjhwbLnxQLvv68Fc?=
 =?us-ascii?Q?nqzLI7jWq9ER3pjktq/Oo2JJUT1LAjEw98RcyTZpnqyGXgYoLXBO/cH8Ru0s?=
 =?us-ascii?Q?DqJbzICHhR84spKsOyDklshMe6igSFh6kIGXP9oBZ5T2BhWuJ4QpelNKrJ1d?=
 =?us-ascii?Q?SuIpBCkvjJlk/BGRBKoQ3MjfcqjBVSV15N7Qg5C9UJ44wvvr2VtzcwUKiPBW?=
X-MS-Exchange-AntiSpam-MessageData-1: jBrEy+Cm0pktJJHtIVTtXIc+0V07CJEVmvo=
X-Exchange-RoutingPolicyChecked:
	BwlOnOhprxhdpdFo31logOdH7E/5GXeYexFou9QJ5StEK50xiBnNlFEW80mlUROufMuR16GriX7fkkgcyn2yxfmiXmio6x/6V4B/Ke950GvOE/5zSzIGdjyh4rj70OR2ctNnAYvk0eFMI2sEwP4aA/3lGt9wdVgKiv5ShlDCxxi9IFZkG6nhSaT6KrSaTF5JCoURt5gq2EeWycps7dqNhYkww5Cfenqy8V2sNaZXIRwbg7S7OswHH+GaN7Iflfn4uioiUZkZk7ZZthgje/DodxROQS+0LEW9zEWDAD6dOiahbWgpF0+140B+IQLlHnRPdAIQ03YL2/YqQ/5wEypkoA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5RhEDUZhum2fri5A0DK6HjTTVlj3gHgRfn2ia80BT7hwZeoImGZEK7aj0GKRjn16MZEP+vdZ00PKL+l7kN+aSrwZH9NQgsNit2LTqg6o/8yabgy2XE5BI7VU3TJYb4XSdW5ljygOGzlibfKZgomtpHd+bMeoZwdnBApzNKynSKkufG+EmaXGj30OL6/WiL7IqQBTOmAl+BDqY9fpN+wuymu4/VSmNRRlEmeTmifuHWlF2Xcpa3nIQlIXcUlFb69f8QEhsuGiJlEMiAVuD3NQ1QUj9nyhcwsF5SEwtKrvUO09PprbV6I83Nj5XomLoc09WKFwa6AWbLmWY4UnovIFvTSCMecbb+R0trrzfx4SOm8LI+2V3HQwhLxFBC8tOrifi9nnsFWnmy3utJNWTJFwYTgZrxg0OzioziOJrMPolncEP9Y76xkOnEY+lfW7RD5XLw/BpTOPbjNQqwg0aWxgyQFZr+TnBibeyK6i7Xllh12ZclQsvYHkZWbb3DibM3UfVOue74qYV0Yj88L7/GKEATXTrSePAbQQA1B8iwLZ3OSBcaqSxUxEPZfjaw1aAlaXznWzqMSRHyHFtBIcHV6229o3JBDLfyeaYMChRlPixMI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6b93bf4-2561-4d40-10e4-08df290204b5
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 08:14:35.8482
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ji4NH8bewFBh95X8dgfgfvVnYZC+1tF3OLk3Uc1MvIHH9RvDxCVc2c10B/YwXtL2ibznlLbc81WGHnfNR8EkXNuuFvxlqds4PzU6LSWXlL4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4138
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 lowpriorityscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 phishscore=0 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130032
X-Authority-Analysis: v=2.4 cv=CoEq4X4D c=1 sm=1 tr=0 ts=6acde86e b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=i0EeH86SAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
 a=ag1SF4gXAAAA:8 a=yPCof4ZbAAAA:8 a=X1hi7w48wxXEZvHpCekA:9
 a=Yupwre4RP9_Eg_Bd0iYG:22 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:13537
X-Proofpoint-GUID: iq9nS7sP7xo-5nFSb8kcHfeqpAQ0_ffh
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX4XzqhkygaNXl
 9tPWTbSdkyA1y+gT2aN1wXJdmCzyoQ53ivmUSUpUqgv2bAbxlo2Y4P/YAEFFm/Mzx8ZSjlAM5+x
 u7tJdhUDbBbGyVECC+e5pvl57q9MTmWQrNVAQTUqvu7IfXgw8iRJ
X-Proofpoint-ORIG-GUID: iq9nS7sP7xo-5nFSb8kcHfeqpAQ0_ffh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfXxyzxT/HX7u/l
 PrxbMDwLZzFmShZRwaRpzrMNvJ0Fv/14PFJcM+n5owNcn6hWcJfgDQgbfL0yz5rQx3l5PZACoCU
 fDq6WCCJEOWc89NbarJjDnaMkZwQTtHgZWKo6fixulTPAIwF/6I1Su8nLZ8Zyv2hZxgv8W5iaQ2
 OUH8mrNS4k+Q0OnwOza0FBxplUCF5bLDwLxbRiS8sNi8EDf+HS+13ZQjSL7SuZX+I7m/ptVrXVs
 /aDFEoSKmsEkQXr6AzzHHGHhkg+Ns34Z9IUyAC3G6kjnA5FTAJeuptX+66qhg7UUAZ+GJfZb3jT
 0wOPBT4hO5U/nIF6ceI+3lJKj8HHn8IfhVo9mr47w+MxPzBv3UGTAqjXOyKSfaSbLVxssTMJ0pJ
 ALY2QZ/+IrJ2DbvimPkBzM4qSUmKcdxtfn1TY95LZ8f7VFuTxtXqMu8GCw98DDK+Y3A0QDbNuow
 EmUc+uuvCqkbltjib6VNkBdEvuQP9rWfTo9+GGIw=

From: Guo Xuenan <guoxuenan@huawei.com>

[ Upstream commit 575689fc0ffa6c4bb4e72fd18e31a6525a6124e0 ]

xfs log io error will trigger xlog shut down, and end_io worker call
xlog_state_shutdown_callbacks to unpin and release the buf log item.
The race condition is that when there are some thread doing transaction
commit and happened not to be intercepted by xlog_is_shutdown, then,
these log item will be insert into CIL, when unpin and release these
buf log item, UAF will occur. BTW, add delay before `xlog_cil_commit`
can increase recurrence probability.

The following call graph actually encountered this bad situation.
fsstress                    io end worker kworker/0:1H-216
                            xlog_ioend_work
                              ->xlog_force_shutdown
                                ->xlog_state_shutdown_callbacks
                                  ->xlog_cil_process_committed
                                    ->xlog_cil_committed
                                      ->xfs_trans_committed_bulk
->xfs_trans_apply_sb_deltas             ->li_ops->iop_unpin(lip, 1);
  ->xfs_trans_getsb
    ->_xfs_trans_bjoin
      ->xfs_buf_item_init
        ->if (bip) { return 0;} //relog
->xlog_cil_commit
  ->xlog_cil_insert_items //insert into CIL
                                           ->xfs_buf_ioend_fail(bp);
                                             ->xfs_buf_ioend
                                               ->xfs_buf_item_done
                                                 ->xfs_buf_item_relse
                                                   ->xfs_buf_item_free

when cil push worker gather percpu cil and insert super block buf log item
into ctx->log_items then uaf occurs.

==================================================================
BUG: KASAN: use-after-free in xlog_cil_push_work+0x1c8f/0x22f0
Write of size 8 at addr ffff88801800f3f0 by task kworker/u4:4/105

CPU: 0 PID: 105 Comm: kworker/u4:4 Tainted: G W
6.1.0-rc1-00001-g274115149b42 #136
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
Workqueue: xfs-cil/sda xlog_cil_push_work
Call Trace:
 <TASK>
 dump_stack_lvl+0x4d/0x66
 print_report+0x171/0x4a6
 kasan_report+0xb3/0x130
 xlog_cil_push_work+0x1c8f/0x22f0
 process_one_work+0x6f9/0xf70
 worker_thread+0x578/0xf30
 kthread+0x28c/0x330
 ret_from_fork+0x1f/0x30
 </TASK>

Allocated by task 2145:
 kasan_save_stack+0x1e/0x40
 kasan_set_track+0x21/0x30
 __kasan_slab_alloc+0x54/0x60
 kmem_cache_alloc+0x14a/0x510
 xfs_buf_item_init+0x160/0x6d0
 _xfs_trans_bjoin+0x7f/0x2e0
 xfs_trans_getsb+0xb6/0x3f0
 xfs_trans_apply_sb_deltas+0x1f/0x8c0
 __xfs_trans_commit+0xa25/0xe10
 xfs_symlink+0xe23/0x1660
 xfs_vn_symlink+0x157/0x280
 vfs_symlink+0x491/0x790
 do_symlinkat+0x128/0x220
 __x64_sys_symlink+0x7a/0x90
 do_syscall_64+0x35/0x80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Freed by task 216:
 kasan_save_stack+0x1e/0x40
 kasan_set_track+0x21/0x30
 kasan_save_free_info+0x2a/0x40
 __kasan_slab_free+0x105/0x1a0
 kmem_cache_free+0xb6/0x460
 xfs_buf_ioend+0x1e9/0x11f0
 xfs_buf_item_unpin+0x3d6/0x840
 xfs_trans_committed_bulk+0x4c2/0x7c0
 xlog_cil_committed+0xab6/0xfb0
 xlog_cil_process_committed+0x117/0x1e0
 xlog_state_shutdown_callbacks+0x208/0x440
 xlog_force_shutdown+0x1b3/0x3a0
 xlog_ioend_work+0xef/0x1d0
 process_one_work+0x6f9/0xf70
 worker_thread+0x578/0xf30
 kthread+0x28c/0x330
 ret_from_fork+0x1f/0x30

The buggy address belongs to the object at ffff88801800f388
 which belongs to the cache xfs_buf_item of size 272
The buggy address is located 104 bytes inside of
 272-byte region [ffff88801800f388, ffff88801800f498)

The buggy address belongs to the physical page:
page:ffffea0000600380 refcount:1 mapcount:0 mapping:0000000000000000
index:0xffff88801800f208 pfn:0x1800e
head:ffffea0000600380 order:1 compound_mapcount:0 compound_pincount:0
flags: 0x1fffff80010200(slab|head|node=0|zone=1|lastcpupid=0x1fffff)
raw: 001fffff80010200 ffffea0000699788 ffff88801319db50 ffff88800fb50640
raw: ffff88801800f208 000000000015000a 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88801800f280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88801800f300: fb fb fb fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88801800f380: fc fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                             ^
 ffff88801800f400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88801800f480: fb fb fb fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================
Disabling lock debugging due to kernel taint

Signed-off-by: Guo Xuenan <guoxuenan@huawei.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
(cherry picked from commit 0d889ae85fcf0cf9bc6e998fca2ec760e08e0b46)
Stable-dep-of: d2fe5c4c8d25 ("xfs: rearrange code in xfs_buf_item.c")
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_buf_item.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 5eb6d787ed4e..065bbf03c7b0 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -1019,6 +1019,8 @@ xfs_buf_item_relse(
 	trace_xfs_buf_item_relse(bp, _RET_IP_);
 	ASSERT(!test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags));
 
+	if (atomic_read(&bip->bli_refcount))
+		return;
 	bp->b_log_item = NULL;
 	xfs_buf_rele(bp);
 	xfs_buf_item_free(bip);
-- 
2.53.0

