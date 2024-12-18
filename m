Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A89C9157E88;
	Wed, 18 Dec 2024 19:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734549459; cv=fail; b=uNdMmUCn4QxUrFu0OaYFX1D1YuHZpSq/xaiVDMc/GoA72KOgRXSFmt8Xwab33KHrhqeWZQWC5+TkCz1RIzy97y3IIKsiqcZgSdLJ/m/VEA1LViUvIhkDMHlJCJyQur4T29jZTW4kLiJCgWp1VyLZJozyxsyqZKnStX8Q7VCdFg0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734549459; c=relaxed/simple;
	bh=HlEcayD1xyf8iW8DFGFSi5Y5yNWDyRiBdxfgp7jJ81g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KKJclpXrNexAbPYqTpNLeJoSamehgOBZyGlIN4UQ0+MyWR0B7TjG+BUGrsTnZmG5rtV9kll23sBSpqCnS/fQUCNurEbMjop1OF6JE293dP1m7OBddrImo03A/EbtMr7DxBcTy2qgbx9Xdn97pL3WP0KvXGx4dqmkbB3ltJltFIg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GdmasDBD; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dVXwzQye; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GdmasDBD";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dVXwzQye"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BIHQeYN005633;
	Wed, 18 Dec 2024 19:17:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=ScPg7Mg/0yZeA+OkXXYut4hUI6ZV5gQk944GDbsngNI=; b=
	GdmasDBDoa+0tnY0qAu1RPHkdRtzKMYvh4ai+OLGiCbO/1HXzKiWf5YzZvFYREKe
	OCAPwTlBmHmf+PtS2EsF8f4i6v0007Z+osnszGO26gvbkz2hGggyGgIct3oTb8Y+
	VgbH46hVAYRG53C5tqM851+zhIuhi/szwaJHrD7Tg+/j0ZBtiampuhOofKXyFIiI
	WhUo4DrPjDkDxTsW8M8kwjcoG0sCSDkw3vhZmuHb84lBzteHplg9cyUHg71PMCUz
	LQMffjJLQji6fG/ggf1iwNsxJrSq9SkBn18pvrMmdroMBYCcFzPXu6klALgQdWv5
	LYEEjppLK6Sv8X0IrcostQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43h0ec9bu4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Dec 2024 19:17:36 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BIHTSZ2035463;
	Wed, 18 Dec 2024 19:17:35 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43h0fa8g5r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Dec 2024 19:17:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TPeZQMxvpVld7rDcl9HZUqImkxA2m9vd8bXvXY4eFvl2Gr7Piig2hVS8MEZDpw4Os/K3P3g09c9fMN5WWJhoWz1mS3hQnT//vASnnYGxfGYSs9WP3+t1V7wCpFxuCvAocZladEmrKfVzckPU5bG5mZA7asF96hlfqy0Hm/t50RIy2clzKDT0eok2ZtZsWKCXDKHVjSt0q7ZzEiAapo7+FFTjEb0Z/vwMaOSbJNf6KsIFP0UyzzYde4GIGq7SZEq8PVWJYteZExNvfYYV4TFZ0Qqr47VJJmHuaVfIx+iG95um9ktYsX9AJs5Q+0G4pSsg0ObNQyopQqLYOwOckSEc2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ScPg7Mg/0yZeA+OkXXYut4hUI6ZV5gQk944GDbsngNI=;
 b=qMQWT3VqSPhcTxMwJ3W2K3AhoaJ8NlrvlANHbtXZyDDlUuOjfBABNvLs/96ElUQt3AWsZ/3ux1ALEuwdwONvh+/kakaOUBlsWwLx9sCZzhZhQCMbhqLkCppt7+lQpZVlWWiVRxMCcmO4UaQ9rnngZ4ZI2Dw7ZuZn9LVAZlsopIqtTLRHemUW6FKGbN/N9t1OfY86eAsl4TnhjXeeF/cVGYv+XAFY4idl2rcGcHcJfKe2vAFQ+tUPr46yZsg16Zlp59HEYJxz67xZUufo/m4kRobZSlN4itfIEt+PjGZtxdv3yvev+8A7Y0EZPDt0W66yy3HPApzPIfMw4Qp3TF88cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ScPg7Mg/0yZeA+OkXXYut4hUI6ZV5gQk944GDbsngNI=;
 b=dVXwzQyeAycm8hlp7LGsOW8DUDJKyAF/b7BMtXfzmE6s9gtw+R8zSpqQaX3kLBxFMNgQEWMRkxLyOxs7NlKkJB7dHEvr4T5LQ3snRciPu5wa/7YWs6mgKkhtGJ1scvRJGUBXIpUHYjdXykYTZwCype6am/xGNNFw+Mm4ZgmkbLU=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CYYPR10MB7673.namprd10.prod.outlook.com (2603:10b6:930:cb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8272.12; Wed, 18 Dec
 2024 19:17:32 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8272.013; Wed, 18 Dec 2024
 19:17:32 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 03/17] xfs: use consistent uid/gid when grabbing dquots for inodes
Date: Wed, 18 Dec 2024 11:17:11 -0800
Message-Id: <20241218191725.63098-4-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241218191725.63098-1-catherine.hoang@oracle.com>
References: <20241218191725.63098-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY1P220CA0021.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:5c3::16) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CYYPR10MB7673:EE_
X-MS-Office365-Filtering-Correlation-Id: 57f61b1e-6561-4729-85bf-08dd1f989f5a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4p6K9b5J9VTmozSZ+mFwk7xz+zKj0Q93XNpC9kZcvZ36Ehp3z6YIcy3PuDdW?=
 =?us-ascii?Q?6b6fekjG4X2mTQkGT2WaQXpgRuJ1Kzr+ZbBZ/1GKX6xkXUuLpA6Ylnczexfk?=
 =?us-ascii?Q?F4SdRGn2UbSiEWXMGB1aT2YoARqIDT3tPAWF/oCtASrRLXIjzfh+cSjUWvbW?=
 =?us-ascii?Q?ZpsXqsnYQYEr+l6hNtDjC76etoRMRIIr1rbXYruas1ALndJQi02oQMhc6cff?=
 =?us-ascii?Q?cl0eAZ1L/4GmXEfLu4kn9lLjTvuVvGakFwL+h2yf2kQkOJMQWAacIcMLS64v?=
 =?us-ascii?Q?eynXWTC87/Q88NSbF350sgUP7xoP4kSGbFvUB1DkIiNmq9jaJsckZmkrT+f3?=
 =?us-ascii?Q?DTxkpT0es/lH0Toz+9cD7Pc58wBqfxfgpRLSOVUIcLlWewHEEZqN4R479yZ3?=
 =?us-ascii?Q?V5e/IxCAb3Wee9vy/nosCy7+XZBrcWjMYmoQa9nS35CztwpEgNWwYWsxf1ec?=
 =?us-ascii?Q?V1nkEhuWzAqq7S0fEfAiClXS+B37NG5IaHC5dWeLNJTBnDbw2WrDU3QmVdjO?=
 =?us-ascii?Q?8RNHmXY0Ml8WwP4BqtzbEXNMUSze0orEAPSbz1MkqQafuZAprlPKptwnHxhk?=
 =?us-ascii?Q?xkEab72YQvMLVOozItSTtTy2wRXHoW36BXoT/3iX2/lZW2PHa2Kc6bdTqo0V?=
 =?us-ascii?Q?SmGgOrgsqrn6GKXsN2btBZW4ihPcWBPx/5M8aHR2mlVPp9iB3Uoqwra6r5cg?=
 =?us-ascii?Q?g5o7RkhobUrVGd29nYWQCBN6eKnUN7uh4/k+IXrspt2uLsNSAAFgREU7VdmO?=
 =?us-ascii?Q?7TyZRJDXaxwEQs0Gx1KXW2luH5C7XLJkPCHIvbC5lLQVBuDKfE/1lmAb1VtP?=
 =?us-ascii?Q?CJVZXTs3C6Vj3CMtDyRtDjipicmyFxHJM87X9j3O8VdYR6uFqXgapgfTFulV?=
 =?us-ascii?Q?EAEeIw0L8UKFDg9xCOvVZHYk2jBiTw026NsCrKnzEvUCwxeWJnMk5XjCrDVe?=
 =?us-ascii?Q?KFldeYc09Zgn5gKsZGq3B1t5oSHUFEV6+2UzCH6XaX+jNooFSxaBQ07a3t/E?=
 =?us-ascii?Q?rJEDtqfA3qF0/QEkx3CbLT1QRaHJiQDPlP6qWtF4olY/+NmcZzFe6hnitfu+?=
 =?us-ascii?Q?bVi/48XdUQwX6QvmbqzeZrN4aDLSCj6MogYZppDoaIEv+qb/BajsIXH5AAs0?=
 =?us-ascii?Q?q4kVc7ar1OrQbyvslaJcFNauulDBLLPJwImTV3o08d6Suol51Q9umqlKfFMi?=
 =?us-ascii?Q?t+nzekDjnh4NJZ13w/FhcAfwImG7kAmHqZ0OK2rhA1Ii7GLA6iN/W6qI5WuO?=
 =?us-ascii?Q?E+cO7v6NWf+CAaCGaISFqismhZmb0PyC4ww+d3mMuCPT/wDn2cX0jko9VKhu?=
 =?us-ascii?Q?X8/SalWMrS/+g6kQjbd7s/hm2N1/zhUb2m3CWHQFzL1PrHitQOwseGdJLuwP?=
 =?us-ascii?Q?li0Xkp3a9051VOiCDM0NW6twJ7hK?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BsewNKRvh/5QY3j0UY/1/CP5IXmsxv2kIqNX9uckWBd513jMIzeMBht6/28V?=
 =?us-ascii?Q?Mt+nFKmKqbSsErS8tN0NQZ7BRPWM6vCpzpVf+NBVLPJAZrYQ2tv0aSut1qtI?=
 =?us-ascii?Q?toumZqHYDYQF0xO12Vmzgoqh1UNn67kE1xTgVUFuSkqsLf87o+h89JBjhtmK?=
 =?us-ascii?Q?7vInI+Vlgo9qLxfqq7bn64nak2j3mRaiZHYq+CZ3SXtcWHr0ljoWRvgfnSbC?=
 =?us-ascii?Q?yWDnHO14wmYFyNVlA7GPhoA8skFqmj74RhS7WncHUp4mCyCcxDboVtqRatN0?=
 =?us-ascii?Q?+vhf/V+6uidyO+aLlN+0z9U7J5Rzll/Wnai/aHBExMfp8OGJ4ElapDbv9Dl1?=
 =?us-ascii?Q?/lbv2somDJKbfTygdk/1G6Y5tAq714c54i4jJFhZ/3DEIOhyRQJUoyKQuLz3?=
 =?us-ascii?Q?29PRCMukOjXv+sFNDsX9E8U/KCfgXlKTROa4N/r00mBR3voTMomPw3+O39SB?=
 =?us-ascii?Q?ACqKvOltfZUqlK2FFq8yMZLN2mggP5n88Fonz/95jp8Q51i20D/Ffj09cX43?=
 =?us-ascii?Q?XxrFlfKKPkZjkmBAk1+AFS8Eol4AviF5U9pl9AdjtVUejpXsy7iPriVgRS4O?=
 =?us-ascii?Q?OTTwbCii4yF5yc1JdhtWztEXTXEVn1aqWwb5O5tZZxm5iw3MFQf3ymn2WGL9?=
 =?us-ascii?Q?dMRNPxONnyR0BRhWBP43V0KpmlbHw0pdL2acR7pw/Z3MrNdW6GpfGlh1Y51x?=
 =?us-ascii?Q?X6Wv/qg5EBn4Q0zbWdNN68/vqBCkl0EDZcL/n0sUIwqBSZzVHp9ywhfLx1ot?=
 =?us-ascii?Q?g34QKlutRBWh3vU/ZGJH5Xiv0nGYw33k1wnCSox4xo6nGJfejtfQmg3j8Wtk?=
 =?us-ascii?Q?2KCH87MCnOf/K06DKic2F80X8HKIGHuBE1JHqEgT9/WyAkB7gzro6PqxDJGO?=
 =?us-ascii?Q?jYO7gcjv8QFWDTOwvsH83DXcmsA5Fu1Oh/JqCy4EASgVvooywSQM5yuuv8GV?=
 =?us-ascii?Q?IPA1cYV5Q7STInQVr9mgbhhROdNmsqYG7bloEnSehfdgpMYn36RFIGEZ9fHp?=
 =?us-ascii?Q?sphWpjqfhtzjCfCERMl5BqVk3ayRzBddCrs8/FAOrIRPbxiycwVEdxGhswWq?=
 =?us-ascii?Q?palJEtE+GHay7U+oYRd+LC71Xl8btHUo2VzSbHS47lSXFJct0fgMZDbqYFh3?=
 =?us-ascii?Q?5INOPfjxlZ9ralDReIitgk9akp/lZtPhkGvHPJjSc0UWrceRanwk14M+3B/f?=
 =?us-ascii?Q?x0DOQVoi50qw8I3nNWqBnUL/+qY+VAiVnXdqIO8ljjMLi2rMr60xyx7NtI3F?=
 =?us-ascii?Q?qu+or9rNuegdpvtJD4CWOFLdAcQ9SL+ejDoQcAEd869nmkVGmiXGPxCpJuMn?=
 =?us-ascii?Q?x8VBj6+9zeOHvI07+Duwixg9DJjxpATBM8HZ72dEYs33xB/G1fM7CL9ioLJu?=
 =?us-ascii?Q?944ABhcobHbtgZ/YIKlYFDCNuHPYyRnH3MsKPGEz1Rs85PNxuzJQqwtkE1ol?=
 =?us-ascii?Q?Fcvh4WiyW0xiKpHJpVZ+V7DQYenkEQhLAsa5g7yb8wZ3F2tOcP2YwkzcLzOX?=
 =?us-ascii?Q?dkqBsVoTzMYA6NDp1bqmVwJ+kTEDtbQFpoELnvVj6Wei7KXmSslApPPF9t+Z?=
 =?us-ascii?Q?M5Mk42qrfvG8vd2bcyVA/gwhUs8AsUSHEZFz1Rwf7benGriqoXU8+rmY0vv1?=
 =?us-ascii?Q?fHO2qpIVi+mNZJpAV0mR275nAzO6qpsca6yI7RtbBe1YbN16blOkDv7LNRa0?=
 =?us-ascii?Q?Suh3xw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	l4jqFMcbeteuLN8sFXiklo9SpWG0WH81DFz96OwSOzBU/CNsEtczUAVTEbqEomGPNyF5DeSex7rzx+bZskeAxOVDEfxuucQq7IfF7g5uKmP0rjRMb1shsbkwhJqXK37DuUPVf443vewsw4TfaV6GHIsSVUJ8lcKtGI+3S1msabBnCz/E3c6q9SCBEdcD3H/nQwkN2YivDy9G5zgkNTYFdv5/7Svm76EuZ/CKk8qqNDkKGTbGcpzJpTlDdBBM0sOnq+0OIIJiIeldVvcreLPBmbkJi8ePTvBrEDLWeoS94RSt2CtoyXMUYBQMQ1cSjxImdcUKAtYuDeRDPRnP9X0ksPYbS082S0M/FuMuilNexFuRgQDGKIvk03SSa6uM8EfOqHXcImagT+gViqhfUXJP9yK6FBObXIemLOM2KEOVdoaFc4vZ2+1+W3Gl6XdGstZ2AlbH6N33VycbVYLBONt1OWWac7dnfgCNvWGwaV6hJxlPfrXP7CKDHDyllAw/phEpRTaHEYwFzbIgTyYi7630VKEebhhnUg/GHJvTklsplz2q8OH+sITh73zGBwsewAdfd5DIAohpGEdORkZ851zugSjxInxRG2h69nSyMaad+0o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57f61b1e-6561-4729-85bf-08dd1f989f5a
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2024 19:17:32.7369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p6UBtoOtaNLxsjKL4txmrUs8rO6IEyynyXomDHwJaXaiC6McZ24PyYKU3QV+e8gmuJPxRyhHcjeZ2jlSyTiuhDaaikXHLFWBak1htOfCXOk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR10MB7673
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-18_06,2024-12-18_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 spamscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2412180149
X-Proofpoint-GUID: Qf4DQxX1nAjxbilEV-c_1eBYHkmD_-V4
X-Proofpoint-ORIG-GUID: Qf4DQxX1nAjxbilEV-c_1eBYHkmD_-V4

From: "Darrick J. Wong" <djwong@kernel.org>

commit 24a4e1cb322e2bf0f3a1afd1978b610a23aa8f36 upstream.

I noticed that callers of xfs_qm_vop_dqalloc use the following code to
compute the anticipated uid of the new file:

	mapped_fsuid(idmap, &init_user_ns);

whereas the VFS uses a slightly different computation for actually
assigning i_uid:

	mapped_fsuid(idmap, i_user_ns(inode));

Technically, these are not the same things.  According to Christian
Brauner, the only time that inode->i_sb->s_user_ns != &init_user_ns is
when the filesystem was mounted in a new mount namespace by an
unpriviledged user.  XFS does not allow this, which is why we've never
seen bug reports about quotas being incorrect or the uid checks in
xfs_qm_vop_create_dqattach tripping debug assertions.

However, this /is/ a logic bomb, so let's make the code consistent.

Link: https://lore.kernel.org/linux-fsdevel/20240617-weitblick-gefertigt-4a41f37119fa@brauner/
Fixes: c14329d39f2d ("fs: port fs{g,u}id helpers to mnt_idmap")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c   | 16 ++++++++++------
 fs/xfs/xfs_symlink.c |  8 +++++---
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 7aa73855fab6..1e50cc9a29db 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -982,10 +982,12 @@ xfs_create(
 	prid = xfs_get_initial_prid(dp);
 
 	/*
-	 * Make sure that we have allocated dquot(s) on disk.
+	 * Make sure that we have allocated dquot(s) on disk.  The uid/gid
+	 * computation code must match what the VFS uses to assign i_[ug]id.
+	 * INHERIT adjusts the gid computation for setgid/grpid systems.
 	 */
-	error = xfs_qm_vop_dqalloc(dp, mapped_fsuid(idmap, &init_user_ns),
-			mapped_fsgid(idmap, &init_user_ns), prid,
+	error = xfs_qm_vop_dqalloc(dp, mapped_fsuid(idmap, i_user_ns(VFS_I(dp))),
+			mapped_fsgid(idmap, i_user_ns(VFS_I(dp))), prid,
 			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
 			&udqp, &gdqp, &pdqp);
 	if (error)
@@ -1131,10 +1133,12 @@ xfs_create_tmpfile(
 	prid = xfs_get_initial_prid(dp);
 
 	/*
-	 * Make sure that we have allocated dquot(s) on disk.
+	 * Make sure that we have allocated dquot(s) on disk.  The uid/gid
+	 * computation code must match what the VFS uses to assign i_[ug]id.
+	 * INHERIT adjusts the gid computation for setgid/grpid systems.
 	 */
-	error = xfs_qm_vop_dqalloc(dp, mapped_fsuid(idmap, &init_user_ns),
-			mapped_fsgid(idmap, &init_user_ns), prid,
+	error = xfs_qm_vop_dqalloc(dp, mapped_fsuid(idmap, i_user_ns(VFS_I(dp))),
+			mapped_fsgid(idmap, i_user_ns(VFS_I(dp))), prid,
 			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
 			&udqp, &gdqp, &pdqp);
 	if (error)
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 85e433df6a3f..b08be64dd10b 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -191,10 +191,12 @@ xfs_symlink(
 	prid = xfs_get_initial_prid(dp);
 
 	/*
-	 * Make sure that we have allocated dquot(s) on disk.
+	 * Make sure that we have allocated dquot(s) on disk.  The uid/gid
+	 * computation code must match what the VFS uses to assign i_[ug]id.
+	 * INHERIT adjusts the gid computation for setgid/grpid systems.
 	 */
-	error = xfs_qm_vop_dqalloc(dp, mapped_fsuid(idmap, &init_user_ns),
-			mapped_fsgid(idmap, &init_user_ns), prid,
+	error = xfs_qm_vop_dqalloc(dp, mapped_fsuid(idmap, i_user_ns(VFS_I(dp))),
+			mapped_fsgid(idmap, i_user_ns(VFS_I(dp))), prid,
 			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
 			&udqp, &gdqp, &pdqp);
 	if (error)
-- 
2.39.3

