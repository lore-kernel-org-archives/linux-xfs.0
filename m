Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24DE1253F35;
	Tue, 20 May 2025 01:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747704865; cv=fail; b=Y+VrderkrT9YzbX2dbLl/aec4zXHYzlegGMPoczrGFI4RqnCHzmp+KOG73uajz9k2rRGXJNLTIdPRiZ3s37n6DJvroU7fAcxRkkUGbcLqRPN7yBmrj9ec0cZXI8CpZg86iU81YUTkGZ6HNEbKcaOdaexLPN8DqyhzHyXlX3U8Yo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747704865; c=relaxed/simple;
	bh=n9dRX7eg7Td4G/THNaGpoRWnCyCrTPL9abIdnpk67pU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jvOF1LM72b4ex+7pqoNf1xg4yIZgX+s0kwk1rkI5YLnrSsC5puxKPciIJY/C2TdPi9JEmZim4AAvC9UHf1c0cojzVbeiPZdBblLR6frOpRHqG4vhv2brrmvnqHjPXajGdpKkB8v5Ml7dnMiGgLkDNRW4/vPbjqOr+3fX0WFXZrg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TCCgkP5V; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=q0eVErgf; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TCCgkP5V";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="q0eVErgf"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54K1NPk2001238;
	Tue, 20 May 2025 01:34:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=7WgfmYJ7EsyfxD3j5mv1aDmF7lhfiQCknlMsF3o6XzA=; b=
	TCCgkP5VX3gvKwNH1YF+qg1WVwXx0DUz6FtZZ+ewn4Y3ZXWBDsuq7lJQ37aTWufP
	DplFavglzr6dKqgs2MoRYBxU/OXHsyW39aQE8BtSeLJV0AncPzuWaFRncOkzmjsc
	rSBV/tqZbP4/90US9O6yYozgouzu9U9tooRce1W2GaW28nEfoSix6Lp67CNMEn2h
	8+Dg/fm+0AmQW9ofSCMKxxcoAXELBFjnqU/saDlMKTLxyHj03q2iSzKYO3huYBKh
	aTyBagLFZsKo+Mkwl4FEsQxYc6nxdAuS+mXEowRSaNRU+oPRDy+2RlfJ6EsJdAAg
	MY+8JNILzbx06QZfrCloBg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46rdcdr6g1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 May 2025 01:34:20 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54JNYvEB000806;
	Tue, 20 May 2025 01:34:19 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azlp17010018.outbound.protection.outlook.com [40.93.12.18])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46pgw7d6xq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 May 2025 01:34:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HMzXL0lxu45eAeCG/wN+7udnAyu0TXtUsYfc4WgNt20joCwI0IMcsOmgZ/lOsg2T9NozoBkg7IuPGuOWjS+WrXCT5cEVDBLwissdL58mwdDOk+4DC8zjLj7qt9uea7Uzh1QT6yTwB771IRbPAYEl25xIbHfGHwkmzdbdWXJH55fA9y20Cr9TJYE91w+QU7y+ffJAWM7BgdlO3OSsmHugHh/pS63qam7QK0bcTqTq38Vqw0SBQyJeiCeB17LW7cm9xzPaXfAXp1S++LBC5q2n0YdZ/yAdJzqrkn7cmEZHX56sYLDfSo/ClYdnykX3H8zyE5jTxdKqlxzwrd8oT/HeFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7WgfmYJ7EsyfxD3j5mv1aDmF7lhfiQCknlMsF3o6XzA=;
 b=WYsJm0mYU1RifGX7uuOoVyLB65XBEMa0YjprunlBiBUSgyhQ62AZnvdIcvyGjMGiY7hlj1rQ/4ds/j4RcnHMrV7U3Vsn01iG17uXPr3qa+1tXTF8Uh6m9+Hp7+SDjjJKmHauJMxTa2cKnGmIO8GaxxIhBGa2yjv+wY376BnkyL2ZAiJqPzUwceWVbmY6vFw1/TCb2Z5W6KZPfaMzcINL+Jz3LUdw+zExRq8/CXLpznzlSmNlifZPNXGL2NbIFSs5dY1i4cg8MGLtQUuA6tIIXsXVFjNinAWoisULewI0hi/XMgFrQYGKwc5l1FQBdJRGDu+bHVKelGhTDupc1IG8Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7WgfmYJ7EsyfxD3j5mv1aDmF7lhfiQCknlMsF3o6XzA=;
 b=q0eVErgfyOJ0Io5K3/i2FWB9i8DoVlSPWDSTt1Km4C1hI3O+hqpKZQ53dKNqakzUu5cK7sFavZpiHchQmCaiq2pTbB7XZq1XyzVdYtueU/SBQRu15GGH5HBL7mSE0DEGSv7SmgMUmArRxQ54yh1aiY1Wvse8G88eOQ1wJRRdWsA=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by SA1PR10MB6639.namprd10.prod.outlook.com (2603:10b6:806:2b8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.32; Tue, 20 May
 2025 01:34:12 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8746.030; Tue, 20 May 2025
 01:34:12 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc: djwong@kernel.org, john.g.garry@oracle.com, ritesh.list@gmail.com
Subject: [PATCH v2 5/6] common/atomicwrites: fix _require_scratch_write_atomic
Date: Mon, 19 May 2025 18:33:59 -0700
Message-Id: <20250520013400.36830-6-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250520013400.36830-1-catherine.hoang@oracle.com>
References: <20250520013400.36830-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0P220CA0025.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:d3::18) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|SA1PR10MB6639:EE_
X-MS-Office365-Filtering-Correlation-Id: 68398d44-03f0-4634-a9e1-08dd973e6c79
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|10070799003|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?enGwVL7/Mu+L4CzbvefJ39mSrX+LOfGh+zfbDbKttL3mi/IoWsvNQP8oCppJ?=
 =?us-ascii?Q?yr219CU1vI5WzbEjgA0S3pdta01K1fRtUMasUY0HZbFSN1yu9V/a8Kcbyh6E?=
 =?us-ascii?Q?ybf7Ywa1T0eFoqIqu2McKCBJTYD3Mzdu7IYiZDpc+Vy6fPOyAKFY9fBz8XzF?=
 =?us-ascii?Q?yEfnOcyOhXGdqe1P+zsu41XyQPRGzV26dQv9JgR/DLfimk+3t5UuC5ODVL5O?=
 =?us-ascii?Q?BuYV7sF4uj2YWP1kIDXmdlyJ71Pugtr2U3ksjf0gzxXruMOchbcxqPC1+GJc?=
 =?us-ascii?Q?H2D+0GyO7PwPpATu/z892i5cY6XhEMnDU9R8p4VYiTKdMYNiA2eyvbkoj+PO?=
 =?us-ascii?Q?rvcvp2Kp8RCxw9Hj5o7ZjFw3lWfw8IQwiqu1c1O5PzAD+tXqOiSYSu1GMyAP?=
 =?us-ascii?Q?wUbIQBH1t2q5tsZm+sb38nZDNK6UD/QpBEaObITru+3+7tovPrskYItaZq9M?=
 =?us-ascii?Q?Gjg78SP6wk016qugu7nmvhbNUMIzPhKBUA1dGboMMAeHkBzIss/pKG52EpF6?=
 =?us-ascii?Q?Kwi8nBm5iuE7UHH2LPxMRRRVuGu6CLECcYOgTbn9pdw2/aAqyveCWr4NjqFz?=
 =?us-ascii?Q?BbDt3ImGEl+DM6v74XfUagNau7ZYrxuChmimStKDPn1AQXUkumS2P4dq7Oef?=
 =?us-ascii?Q?Q8Ggm26urMQ4+sOZuF799V3S5LUWjMn815ftQhU5xJBiZMNWtir0PPwMeKN6?=
 =?us-ascii?Q?cPtuKjyC4q9eQhuUcCHRpKj9urQ0JOj8nQXYAZae1WpuW5rMC8v1JY5tQAGL?=
 =?us-ascii?Q?mWqpBMxUaCySDpirn7DMC4XXlItwAW1rNDH2axvShJVwPcckOcQ3Hems05LX?=
 =?us-ascii?Q?T1NdgW2pvpiRJIZLvvukljTf0QKaY9ULSQJaBtdg/10wAVC2ZGbDBNpRfNPr?=
 =?us-ascii?Q?vQKmlbKalq3am82+dLkwaFs4QdAT6h1xsQHjL2xvBV1y41dt4HIL6oZUYoWu?=
 =?us-ascii?Q?ewTcG/9t2u4Fjf6ailmq+iJfRFfUuJ4SPBzI2eSU3+UT5bZqG0F+s6KiT4y0?=
 =?us-ascii?Q?DTs+w1G9DTjNBgrvL5VBo8/vLzhZ5vz+bF/qYzFEYIdQewKL94bah/9/wj2H?=
 =?us-ascii?Q?78BgKFJ30tVxpQoGi4/O4/xX6nTY4n1ix+fdV9Ze1qlCMpygOJcBsjBbVB4K?=
 =?us-ascii?Q?OPBBuLs6Ylcoe484/Ya11OEDfk8nJgu9wTzzlKr6U48W3nXItfugCU9O/1Mm?=
 =?us-ascii?Q?T02JhJK/wiNIDrKkmBcDOeij5HQ4GOTlDCootw7YDolEPJRxtXZFCB5VRRCT?=
 =?us-ascii?Q?8a7UlOu5KvaqkAZa2PQeYjycDor9QZmZQ8igdg/EqhbwsBLqHxwo+3Np1IM3?=
 =?us-ascii?Q?RymjGWYJvOjWMVRgo57XR/vE1eifT/q+GtXeojY7LHa5xODi1wAw2McKIqAQ?=
 =?us-ascii?Q?o0yZ2SkoRpVnokVuy9jx7PxvVA6ikVk1PmVEd9U4c9+NOl5BcT+b4YEjCXlx?=
 =?us-ascii?Q?uVyWkcm4X00=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(10070799003)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UiuOJn5aEdd1jC19YUJZU1qGTcnX3oVg5GxD/cv/2KaM7j61r1KNzGuHVuKs?=
 =?us-ascii?Q?DidD2jHNXr30VufpsBz/jBEdvxGOaPK7Wt3pKG/d57baUslwoeT1Gr2+rZj1?=
 =?us-ascii?Q?/C2+yrLEmS2+3G9ffa38lV+XEzFyxzC+vO1GyZrddIsNe+EmTT5APuEyh0hM?=
 =?us-ascii?Q?MIVi6IkTO7gnc2IWwPh+ePzf+hIfpIRgXebdNyIMX1Wsy6evPniV4DjEjhdp?=
 =?us-ascii?Q?kkdB1J4qgKPbYfEVIFHer8KXIUWXxrQX7auiouD6pyyoTLNtBlSfufBXnjaM?=
 =?us-ascii?Q?0OesEFN78nMFPTRYZRZkvv2MvB/JFvX5pHBkHhbaHz1wq+Ex17KxmZIGpWT3?=
 =?us-ascii?Q?yny0CMDCN+HLm1Wq8jEbG6jA2vHKTTAhDwMHXW3epl5XJttCfywUJoGwLS+n?=
 =?us-ascii?Q?mCBLRpjIi2C7JCx4LT15f/9TC2mjdFXc26f8xYXGt50iqXwVuTI2kQ+BJXCw?=
 =?us-ascii?Q?2duoBw7iyqINgSn4nk8aX+tKfTCNB4LP4LgvFTHBWE3kmmJkG72KeKcQXjxe?=
 =?us-ascii?Q?TnneijaEI2Kd+IZ+H05kjjEI6ZhANY+9cCGWtblozJN6gAxCUShM/de54pop?=
 =?us-ascii?Q?sh5zDnpqDvxNewZvsci9cWIubmQB0SDwRKxynEb9iShZnYGAM8cTOaX9yBTF?=
 =?us-ascii?Q?voYcMQORkYy7nKTwgNSyr5PR437wqgp4atzNT160JDMxx44movJ/pHpEOnuF?=
 =?us-ascii?Q?uEI0Fsb+9TE3zoq9tofcGkT40obE3O25HO1+Gvch9RshK6aSUfokW1dgqtgE?=
 =?us-ascii?Q?FIO0xo1nzooiNifAzv+UoOyO2eYdM4k+hV3lb5utAI+npxFenNH6mGd3g48x?=
 =?us-ascii?Q?ySvmp7O0dEFK+rcVLijrmVf40tlidRy6XhJF+IlcfN5jRlTkdMGj8S8Rr8tA?=
 =?us-ascii?Q?JJcg5IxJITh6mPWgbUSc/C3NxWiMJoE+j9xY2mbOF9/tfE0k2VvhTqqm2tAL?=
 =?us-ascii?Q?8+JRPzroYbWyZ8cJkkXlCnCEalmrav30Np4FxYB0BVUg1Nwju5KbsZTWngKB?=
 =?us-ascii?Q?u97utCYX/rVW9EgkfasCQHgy2aL7lRk16jgVD/DilkG/js3flK29eB634JNA?=
 =?us-ascii?Q?cOBLySCPYcL1jUJUlFhibC0kgoxnMc2wVFhABcpFbkwz3XVEr3SkVyMrSp3y?=
 =?us-ascii?Q?Z3xYg6Lpf0BwMSnCACbSSIfzZNcKzQatYv6N79Xd2crwdsgdEjFzbUq4c4Qu?=
 =?us-ascii?Q?luZvm18KiCSBzjsm+WrAummxhqI+FB3oa7JLUn8iw6Di5pi3eSjOxe2fuqB3?=
 =?us-ascii?Q?4ooeoUaaIrjiTv4aKNAvcStn03cK1kgWRnxtOqJb2PEgt07rYFiXonTqkKKV?=
 =?us-ascii?Q?r+DzG+S+Egx7NgJhLYLVoNjyJPhI4f0B9txSDqXb77Vyk0Cso8C5HnGYOk4l?=
 =?us-ascii?Q?gwioUfVHN2b0zwqCbuBLHYJeft8rt5WaL0eLBd0lNz566tfwOrOn+2g0A0wb?=
 =?us-ascii?Q?xXBZGEJsjKDNu6QGzzqiuhRxSKB9e7EsnnmAK51TjS6v9hJq1V7ch5pXC3LN?=
 =?us-ascii?Q?rLFOCNYIk4j9xt8XVieZ/MXcuDkhNz5EYgK86CZjpEgHDDgJMUWGuVYz50Iu?=
 =?us-ascii?Q?QuRRuPJOwjdyqUTpCgDuqMQktNWyIM+anlM6RZp1BDREwfEWHHvSjVIfr+qp?=
 =?us-ascii?Q?ro8ye10ApIBCOxv7T0CSQSYZrk+ZegyQjFs/IPJoxPLWVy/PNKAtF9HLOmSN?=
 =?us-ascii?Q?4KBYow=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+AFKHsTR6fqpVsPUBUzC1VEKgKOtbC7fofOE4aET3rSOymE7Ffb6CqYYQuIQlfV2Td08idb6K4N1h93vwJ00ZaO8LRKENFb+IjVRYEX1PV/MMCfEPOWQXWiMprl0Yifo+5BCnNWvLXpI8AMBp1ixQ996r7VkBT9UTsRKWXCNLtOz0vp8tCO4s3iF5P4Ru3pojGKzsf8dddhp85/mq6UOX5+nSQwnwgTReysku6aB5kENGmChVsl1fQI7ti4Ib6a5qqpPDctxMNDOpWgvREFc21ANfcKcgM56eyrkzsxWIb1tgFksBeg6zWaUuATsZgeWysW1m52rWE03SSQSGQjon+abxHam8LIQ75YuI868mG2hM+oX6n93NfE1r9VE3bbo3QKerZUuOYaNh8AgiOHg8KQiejEhf/CxSC3aa57Isbet47Q4jSzSzKih06TXGoVYO20n+vV79RW5o7EucoaMZ8K4FUAz0idLoJTOwHQNOyqtD0XP6IAqKDiJzy3iFol/cESSnj2e6JAxzyQisNBYHxvtPSASU9r8cM7xel6ExVbt6MRsMUdQwgAwLaBE5ax9lrUYruDhFAJ+QZhdyKqRgVMxFIn7DswY8Sp2TO/Aew0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68398d44-03f0-4634-a9e1-08dd973e6c79
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2025 01:34:12.1796
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YcKS0j8rlqy6vwbiGXxOVJk6BkOzg98FkQo/SV2BRFbuwbcHi/MY0A7RBPitLULgPr/x//Alxqq8ep8xhfbPl/rt2Wwd0H56U2l54CWKQgc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6639
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-20_01,2025-05-16_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 bulkscore=0 adultscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505070000
 definitions=main-2505200012
X-Proofpoint-GUID: dzcinpkqCsgu_l1-xxZw9Dc7KNzPxhA4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIwMDAxMSBTYWx0ZWRfXxOBVgvaIoF1v LTpmNtnEeUa8dRIGXFd4pQ9/A8V22DUpsZpjiS1bOr5xtWMtSwMRI2/LJBWHFglFid+9EyVBaqV p9zQhPMZYOGOd78H6VSUmj9fqSb8MXy/iAmh88mKqt6nkHorBkegd3rX6GezhMD5gznmBnDPwbf
 2zExcEYOSeEgdiY9MDhWXRzoUOR83L2ClYPAV4QqvmFD9GDGK5cFKEfTCREGkCZtovuT6/AXNWq iSQIS85tzZm9jnIpRedsyBfbqdWWKKn8FjurDIGCyEFyyzgN9IuUIfKXaDDAvBpEJOGLSLqcga3 sVGK56yO4OYtiYCpSkPhi7ityCFApUu9+Ki0MqZ4StarhkQ9/3L+9NXA1kzEt6gtxTq88GgUK7n
 DXNmoJl6FkAehWGq/8yuDlUNk69DoY5TURt1/6WoCQX3ApluZqh62Mq5LWs8OJ1jQZ8JPADp
X-Proofpoint-ORIG-GUID: dzcinpkqCsgu_l1-xxZw9Dc7KNzPxhA4
X-Authority-Analysis: v=2.4 cv=Ldw86ifi c=1 sm=1 tr=0 ts=682bdc1c b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=mx6Z5l6ODcrpD94SwjoA:9 cc=ntf awl=host:14694

From: "Darrick J. Wong" <djwong@kernel.org>

Fix this function to call _notrun whenever something fails.  If we can't
figure out the atomic write geometry, then we haven't satisfied the
preconditions for the test.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
---
 common/atomicwrites | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/common/atomicwrites b/common/atomicwrites
index 9ec1ca68..391bb6f6 100644
--- a/common/atomicwrites
+++ b/common/atomicwrites
@@ -28,21 +28,23 @@ _require_scratch_write_atomic()
 {
 	_require_scratch
 
-	awu_min_bdev=$(_get_atomic_write_unit_min $SCRATCH_DEV)
-	awu_max_bdev=$(_get_atomic_write_unit_max $SCRATCH_DEV)
+	local awu_min_bdev=$(_get_atomic_write_unit_min $SCRATCH_DEV)
+	local awu_max_bdev=$(_get_atomic_write_unit_max $SCRATCH_DEV)
 
 	if [ $awu_min_bdev -eq 0 ] && [ $awu_max_bdev -eq 0 ]; then
 		_notrun "write atomic not supported by this block device"
 	fi
 
-	_scratch_mkfs > /dev/null 2>&1
-	_scratch_mount
+	_scratch_mkfs > /dev/null 2>&1 || \
+		_notrun "cannot format scratch device for atomic write checks"
+	_try_scratch_mount || \
+		_notrun "cannot mount scratch device for atomic write checks"
 
-	testfile=$SCRATCH_MNT/testfile
+	local testfile=$SCRATCH_MNT/testfile
 	touch $testfile
 
-	awu_min_fs=$(_get_atomic_write_unit_min $testfile)
-	awu_max_fs=$(_get_atomic_write_unit_max $testfile)
+	local awu_min_fs=$(_get_atomic_write_unit_min $testfile)
+	local awu_max_fs=$(_get_atomic_write_unit_max $testfile)
 
 	_scratch_unmount
 
-- 
2.34.1

