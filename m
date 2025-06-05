Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E35D81F7580;
	Thu,  5 Jun 2025 04:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749096106; cv=fail; b=kEAnZ7Vd2eN3gRVMdG5TIyjZTwbdu0919ulsghICRMlYGhm/IOi+KS/HLBvW3aWEF1qN8fQVaHvmyACKVQgVqM8b+v4YzElxtDGURuEuFNUlGSuG63nuydXuSOJILUSVGF7KZ1FU5yaZJeQ6pbtxUc9WlM8SbQdAWn/6nHjzjVE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749096106; c=relaxed/simple;
	bh=WPGilrTnt19l1aNtD93MHD6DTcfe1nBesdru0KQcKzk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=W3ybhOIkuSTwh9YyMuQrIn2U1+3gBbR/T7Ow85/+ELVGn0nw5d2ZVCI6jRcaw0/zqQUbpvuqEq38eywMo8XihZWC74rBgcuGufWkQiVydRvBA6BthZxHmhFQd3bXhr+26SbJm21ICPx0WwWPt/NERS8QJzo3N6g4WhTzjOcxSlE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AB5JP+wW; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ghLeQQzL; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AB5JP+wW";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ghLeQQzL"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5550h746010616;
	Thu, 5 Jun 2025 04:01:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=DBmI+IIUQc3PUR/32MRKeNMgVl921OcoAnIZiOoRY4g=; b=
	AB5JP+wWwAAKU29ksZwqrlUjLZ4V/uidBoFU6YN8IWBpTM++2QtnF9x7ZV7y6uJh
	pk3tJkle1h54Os7aHOmUMx/VBH49mWZqu1PeQ7N2OdQ5cFZ0wE8OdXh8sOF93ruE
	nwD1BXpJQ8IdGUxbHANSC/QZvvr9NdCYxqEn9A+G/yqG3MGExh5IYdZS57+OFS+m
	+XrsemxHw2UVMmuzQf8X3jBGnayrRVfXO3ajsL16D753zy0sO9M9VSaf5yg8/qh5
	9TRpwukjkLAZMPNMH7gXcRjMPX4f6rf3cIngGNgoJI1jkC20uIra/8/6RnpZBdol
	fmcw9azoDsvqpXScuc9XfQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 471g8gd9b6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Jun 2025 04:01:32 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5551jOcZ034872;
	Thu, 5 Jun 2025 04:01:31 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04on2057.outbound.protection.outlook.com [40.107.100.57])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46yr7bt9pr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Jun 2025 04:01:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LmMyPCHdo9NOoi/+0J5PFoEq0kyXjtvoNsKEmcjQR2zhtrNTgM8MS6FByDZvUdktv7IxcUJxuXWFGuJ/GyVmZmEEJG7Rqi7Sq/SmmsGzDVAlbZjeFU9YbCWGPDQIP4kAIeJn2q56ivFLXWP//V+HQOCUa9D/HniSK+FkuoZ4O/QEsP0yf78nADosJZC24LmukX8BCpna9f0wwu3JH8YgAgZ4m/wWUUvr/5lpYH0cij70PQFe8W5eU6Mx4iYh+cIxVPA55PBCkLLVTDFCKaw8Qf8e5kI6n/40ft/RKn5qPoQlWM0tYp1p/fLvWsW2TCdHAuNgOB0B9wMt85iZg1zZfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DBmI+IIUQc3PUR/32MRKeNMgVl921OcoAnIZiOoRY4g=;
 b=o1nfeqKrvWHPmRZnMpQG8/3I3zQ/YAK+7Ktv78rozbN5P2OjSa9PvZEGChA6/7vMuQojl2qyNd1OW2xDXooXbASGUI8bbe3kBXljZaCzLNgnwE/dWD9yunxrI2jZtPeZzWJQmqJQpzDpLa7AvywWkT2I1X7LRxv8m3TpfAkqPEqULsC9fAO0zSvru6sq/2/XWhRU+fIz30/GS+kNTh7BF9ijADEDEqwjZYiCwQZbheet7eWQLJKjMn5o0Ne8cIDsiftTqz4d4QefqRUx2tkzWi4eEaL6bH7tlMa4AaUjtgdigPJCjKUGm17neqx+14iAudCI5dPryufiXtp+w7afsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DBmI+IIUQc3PUR/32MRKeNMgVl921OcoAnIZiOoRY4g=;
 b=ghLeQQzLpQBt8Xi5kknFD5VG+mlz1Dd82F+9eVSVpVDo39XxBpTkGvHi0JsvnPFJqRofaFz+Y1LsrBtNwE24UgAfFFR1mqhfaw0TwzttJJrhgmQB4UB2pWcynP2G31y7EBMO/1Jy/c0xAzBp0XFghFC4uvya+DbNFJXRb6nYH6c=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by IA0PR10MB6723.namprd10.prod.outlook.com (2603:10b6:208:43f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Thu, 5 Jun
 2025 04:01:28 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8792.034; Thu, 5 Jun 2025
 04:01:28 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc: djwong@kernel.org, john.g.garry@oracle.com, ritesh.list@gmail.com,
        ojaswin@linux.ibm.com
Subject: [PATCH v3 2/3] generic: various atomic write tests with scsi_debug
Date: Wed,  4 Jun 2025 21:01:21 -0700
Message-Id: <20250605040122.63131-3-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250605040122.63131-1-catherine.hoang@oracle.com>
References: <20250605040122.63131-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0P220CA0017.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::27) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|IA0PR10MB6723:EE_
X-MS-Office365-Filtering-Correlation-Id: 4358a186-973b-4f19-f8d7-08dda3e5a5fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|10070799003|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5g4R4j9//YxPzCoQ6kOxGjAqKvrvvrtUZw6WVIxqYKpu095i4plpZneEz+YT?=
 =?us-ascii?Q?r4Q+vzgMBg/H7PGON9PWj3m0pdz9ynBWOnfx+FHnlhDSA2aTwTC9Ql/hfKLc?=
 =?us-ascii?Q?XpNmNEjpA2HWSPfqBg/3++1GP6Gi/25mNn4Bc5FngumB9QnCBsNuc9hWwCU/?=
 =?us-ascii?Q?xR8dz7oXGUJWN9TYnE0P+2UWmtxhiFsGsU2E/xhRJboL6fiOocB3X7RFYGJ6?=
 =?us-ascii?Q?6cGiPKZ+w7io1MJparZeU/H/o8Hyrd7CpSr2JbHfb/j3L28BkP+BPQs88diU?=
 =?us-ascii?Q?/x1evDBV/GqfUJtz8vWnhSGdaJxy5bB8nEiYeCxl/H/t2O/aRWmD+0cmkXbk?=
 =?us-ascii?Q?Ao52NwzPvEa+gr7jDiAk85tlo/MCddlrAUZJUzukqPf8Hp5mEluP7MHkHz2z?=
 =?us-ascii?Q?TPnOuu1u+lRVzH1839p4DbNbqlq7go92jqSYXcmq6yfIIfT1QuQTJZDZzeZx?=
 =?us-ascii?Q?dXQY+2LExx8IMwiIxRsyAQnA3qyWUJg0E+AqliNNbEuck/1ZCk6n5eMxar0F?=
 =?us-ascii?Q?dY1m5AO8NRn8AnfhdnxCdDAss7v+eNvTk8Sb9QD+5xePZEan86MD3rrCYQUE?=
 =?us-ascii?Q?G6Y5p/OLEXMKw22T2piAhW3ULfObGNjJQjGi0iXtZjbFYwHIE7dnqfWAW72+?=
 =?us-ascii?Q?QoFCo6w8FpJM5ngZGxV8/XkelybOInYNjU3/ev4pgPyXKKa7Uag13lcpljRD?=
 =?us-ascii?Q?THJ4hPUsqZgM4R8CpilMCtAqV6K4pHrmcBOYCuTc5qyz9d++B1FOxAJw+rE2?=
 =?us-ascii?Q?MMh/uWfuFFchbgy2DV9ho3rQQcECZJf5UeY/TEEy3CasNEIu8id6TPjuVLbH?=
 =?us-ascii?Q?a7Btjms9sj8odGZv+CjQRuO23l8Wy7m99HNVKLIHYpI8+A1ORE7l5X2ojJBO?=
 =?us-ascii?Q?SKctlrQz/qyy2SoYTKifYjg0OaE+KEQkIJ3IpGbRXJX0b4QA0hcATs6Bpc8r?=
 =?us-ascii?Q?JT5qYdwlnYOoJB12fm30zB7LTzm0jpTx34AE2iNAc31CIEnyIJhFSbQUc2Mo?=
 =?us-ascii?Q?Oy5U9nuGMf67FKzFIBkTN5QS8XsZNTug6VG5OOx7CoLbYapvLDFRQtFazlNI?=
 =?us-ascii?Q?l/cJHmBn5qCLak0CLa8+cEuuOnAhNvCoPI7v/D5kJbeW1oHnIfWLfuqhlwtA?=
 =?us-ascii?Q?ujlmwemo9b3uBjGYwh8sFEb4YKGAK2M46c+E0srAmgWxtePferowTgo3Q1y1?=
 =?us-ascii?Q?WscFCp9EsgkkgxJXgmxHQEgfhL+y1dpmUKciQ7hG5Rn6yjqXEOgbSKybyXwR?=
 =?us-ascii?Q?Q4KG0ts1SaMlUHt35zjSKCptLkV8FUJnGvCZ3v60dmoiVWFeRteUKE8rT1kp?=
 =?us-ascii?Q?7rtVeTTEnyFTmvwWd8ZxoF4uFwVjSyjqXeDxf+koIsmjn3y4OvlqZVuNxjm+?=
 =?us-ascii?Q?97OO2ZnOAKIQu4tOki8j3tXt72M8ljW/MQ0SEUJgAoV4EI2rCyXLSer91ypf?=
 =?us-ascii?Q?2CkJ6iNJVqo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wW0J0YzyriWxQIkJ11I8dMZ1EWC3rDABv2Axr0KImzrLayHQjgxUEjMfJ52V?=
 =?us-ascii?Q?Wxb/fx7KzGVdYj4dkX9b/6/EJRbJPVWGmSA/+5hwIuorSE63VFMB99lxNtUX?=
 =?us-ascii?Q?PoaY6v4jTFF1vR8rlgCxmCZ2CNMCYFwBdxleIfcJbScOoRDs/lUm8JpCpc8Y?=
 =?us-ascii?Q?D43r3RZ4iHrxdx59JTTluhI75EMZncx/wiqCtLPTLAb7tnqWN62m2eT20N7W?=
 =?us-ascii?Q?93sI2n7y/+A8z8O2hXBqE4RHEzl92GQEDkHSyvqCKDqGWCTIVFhLKyJTAJ0a?=
 =?us-ascii?Q?aMi3r+IcbaKx8ORERNINTL0Cr3wnhjvZGoe6WwzDcE2XtbmqfD7UdZ04HTot?=
 =?us-ascii?Q?BxQXZEt3oegdkxz7r1WP3jaDsNJHnbXeipz8IzBGAOIFqgG23YdonOt5mC5g?=
 =?us-ascii?Q?FQSDTZkKcJ6je5r8Y9FjIjkWntocvDv6WtitwQZbuFZGxYvHlVLD/b7Ne+6E?=
 =?us-ascii?Q?AgBovHeUEZbkxBBcwC2L0dnSo6oCj/bNk2G3xQz3AdwiH+rHin3Y8v0wkfuz?=
 =?us-ascii?Q?ubCiXmw+o5wQAAm8/gYV1/nVruD/vlxSuFWFkNZJG86ah77KJRscJs03fiN7?=
 =?us-ascii?Q?IkssGwh2rVaCQpQGV0m67hnLuYA8AMRlk87yu7osDz8sSH7gWvgExAm0g7ow?=
 =?us-ascii?Q?C51BrJwbj/PqTTSby5FlbAGGu16Z8tVGrrU7zb4RW4HdK21G59wZ9cGclnn+?=
 =?us-ascii?Q?jPyJRqgq9TNoHlv39QtT+tp7COq7oFwyDyh2+15K1AELWoq5hgfpvyNRl/Eu?=
 =?us-ascii?Q?6S/hNtHXskZ3CSzC/RB9e0eLhJpu4A4LmcnYyL3gKQFxHoFei1cgw35GXPSK?=
 =?us-ascii?Q?Kj/Cz5se4HllvC6CU/Jzi5c8onZaiZldYLWQl42mf0PkQbj/u129wVsWGnzY?=
 =?us-ascii?Q?WIeEeqmRiHDP8YkeLZx4wrVfOHe8xxLJ+BASIg3A+0nCIimENLN2sHVQaHWe?=
 =?us-ascii?Q?QetUnG4HVzpe/2dF6+Fh1FbisxIBdgTGffNdMOw0VhHJW8E7bS1G7qXZxb7T?=
 =?us-ascii?Q?zNyNDoDM9rpOsuV0HtMXcbpu4HuwK+ynaEBbFnezFrgGYG4a7ikx+k0fkBAG?=
 =?us-ascii?Q?d/9QhTkQ6OIBoZtVAcvcTZpiA5psK8NwI9k0BJ3skg3kYGaRtMNFrvKMnYXi?=
 =?us-ascii?Q?9HKfkV3880X66TqrBX1vb+3fOrzZgN/zEwK4Wlgy0hh8gRgLhJgwoJoxG+nI?=
 =?us-ascii?Q?QXyi0xgQxlCmW/IuipzSM1hJJ3FOn9X+Yunn4wCSBsr+C7vT1QqRAP/IO71N?=
 =?us-ascii?Q?jNkqvbYaCFrGfPnQuxoLay48Di2yzeOtFf9USGmgmnnlil+9LMF7ZeO8bspz?=
 =?us-ascii?Q?W/4X3NENxZ/x4D2KHptPqKeul+efslXdLEERULU7wkpaoQwuDbBhn/MKx3M7?=
 =?us-ascii?Q?eYDlXh9l7xZ/rU1kQ9fZlfdYoRbGKBW7k0KTU6hKO1c81LVXxmguk4PBGoil?=
 =?us-ascii?Q?CDMrjsWgIXAmlbOPCxotrwFXaebkksf11fRl+kG76+bw3z3e7VY7DvJ2rZSp?=
 =?us-ascii?Q?5v1E4Ts/ZlkHyz03Dy1eUqeEmnOhCZYYA0H2bc2cxIAXdU0vhs3oXXJ3cSbi?=
 =?us-ascii?Q?HotELZ/d6FexcUYfo178JoR0xR2QFYSsYsjQ46kjIQcj4VGxD7Tj6N+6ABMo?=
 =?us-ascii?Q?kKOD4c7P3sswoEZfiCMcI6PGCotORv3uT7w7rY0RxXQAhNI+OVWIZZKYegtm?=
 =?us-ascii?Q?KtVPOQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YmB37a41NHiks4WGtOjbrDZvB7670eC8W68de2OsU9LGouqzaH+53vzJCKGpUEBtT+foT/mkbRjNv/a0rFaYAi7IS6klUHtCwFKqFQxMK9DEp1eH532fh84bpX7a/p67UZLFYw8Lc4SewdsdDyGxeQfLc5BBkQ+jKDMJOa/cqgWTYog+kQWTiGuXltrlD0C1Nl30f0/xJdLSmKqSwCSA1N+KzjwLbKsD8jnMTG7cOibKy+6co18w2UlRHb51X/tRlbS9QsFcN77OXbo9/aPCI2WL444+3GErDve8/CYE+C5mJ4v1CGcVMEjlhJQoWpOjKpzzdo3eTkCJELA2D3mZcTSwrL/N9W1sPtXKUorxqvaroIDhpRKKyhz7QK6hZmZT7z7+/RDIAw4pcE95He/mxC/l3d8u8bkow6YOpYHxq2QqKoHUHTaQ+rzq6+aXT1gcWdqbYwT/Vg4PQC/0IL8HYSMoIp4d7wAONMtiMu2URV0IExYbCNvDhqSTAVqSFKqncsyS1BZu9FE6xNLcTaQilvd1BSSxOXJTZKZH5XH7RgTkoOcjjgbPeNzSC/avyb1BwU+VXJz6yeTr8mFFqBiccsyaBJqMJq+PdU7h2ts4rps=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4358a186-973b-4f19-f8d7-08dda3e5a5fe
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2025 04:01:28.6688
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MFwHx3ibiuy/SNh77p2GzUl4TUsd7EsuO2GWnAz3UukZ0AcwvFj1/xJ1/twJZQMW253DEjKDAkzZhjlqBUjJQzwe1EAAarD6JsVsrySKct0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6723
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-05_01,2025-06-03_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506050031
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjA1MDAzMSBTYWx0ZWRfX0LiqHUyroPEY J1H0X4x0wH2Xbt5dWy68KAWmFfgkO1Wkx5GnUMP+XoJceiWsp9ghyFVvu8GNL8T/f2L9D8fCwlo 6sei93AkexJMbnvv/yceEnH0I7UtI5Bax1ndTOu+45pafL3YtZu6fveA8BFsuecG6wfBIf/RuJN
 OeXULBjhlpOZ355VzZ2kHHlWNoS5eDu+r/QkwuMJCF2d7iuKi8WGf7YXEX+stMH1HoQKeLsArYR +fkmFyOCaysmZsriOrQ854i435T7pAS23j5mbq0Oo+cxkw0euD5P9rdKBpKEoNcxWmf8igE7Vuv TgQur0IEyoanc3lHYEg6jGrAD6dpglGsuVh6/tpUvAmZY6g0sI1zrnx/vaTTDocDsfVc/vfY2hb
 m0WMRTyxnOyKCceNS/yp3tMz9tph4Jn3Yp0rCFRmc70DjGHazL2GeyfobTxGAMhqc4Q7po/G
X-Proofpoint-GUID: VO58TXwp4VkHZaGT0y5VUHrevz6tWzNE
X-Proofpoint-ORIG-GUID: VO58TXwp4VkHZaGT0y5VUHrevz6tWzNE
X-Authority-Analysis: v=2.4 cv=H5Tbw/Yi c=1 sm=1 tr=0 ts=6841169c b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=ZIPHqqkTwhlAWEAS_2YA:9

Simple tests of various atomic write requests and a (simulated) hardware
device.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 common/atomicwrites    |  10 ++++
 tests/generic/1222     |  89 ++++++++++++++++++++++++++++
 tests/generic/1222.out |  10 ++++
 tests/generic/1223     |  67 +++++++++++++++++++++
 tests/generic/1223.out |   9 +++
 tests/generic/1224     |  86 +++++++++++++++++++++++++++
 tests/generic/1224.out |  16 ++++++
 tests/generic/1225     | 128 +++++++++++++++++++++++++++++++++++++++++
 tests/generic/1225.out |  21 +++++++
 9 files changed, 436 insertions(+)
 create mode 100755 tests/generic/1222
 create mode 100644 tests/generic/1222.out
 create mode 100755 tests/generic/1223
 create mode 100644 tests/generic/1223.out
 create mode 100755 tests/generic/1224
 create mode 100644 tests/generic/1224.out
 create mode 100755 tests/generic/1225
 create mode 100644 tests/generic/1225.out

diff --git a/common/atomicwrites b/common/atomicwrites
index 88f49a1a..4ba945ec 100644
--- a/common/atomicwrites
+++ b/common/atomicwrites
@@ -136,3 +136,13 @@ _test_atomic_file_writes()
     $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 1 $bsize" $testfile 2>> $seqres.full && \
         echo "atomic write requires offset to be aligned to bsize"
 }
+
+_simple_atomic_write() {
+	local pos=$1
+	local count=$2
+	local file=$3
+	local directio=$4
+
+	echo "testing pos=$pos count=$count file=$file directio=$directio" >> $seqres.full
+	$XFS_IO_PROG $directio -c "pwrite -b $count -V 1 -A -D $pos $count" $file >> $seqres.full
+}
diff --git a/tests/generic/1222 b/tests/generic/1222
new file mode 100755
index 00000000..d3665d0b
--- /dev/null
+++ b/tests/generic/1222
@@ -0,0 +1,89 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1222
+#
+# Validate multi-fsblock atomic write support with simulated hardware support
+#
+. ./common/preamble
+_begin_fstest auto quick rw atomicwrites
+
+. ./common/scsi_debug
+. ./common/atomicwrites
+
+_cleanup()
+{
+	_scratch_unmount &>/dev/null
+	_put_scsi_debug_dev &>/dev/null
+	cd /
+	rm -r -f $tmp.*
+}
+
+_require_scsi_debug
+_require_scratch_nocheck
+# Format something so that ./check doesn't freak out
+_scratch_mkfs >> $seqres.full
+
+# 512b logical/physical sectors, 512M size, atomic writes enabled
+dev=$(_get_scsi_debug_dev 512 512 0 512 "atomic_wr=1")
+test -b "$dev" || _notrun "could not create atomic writes scsi_debug device"
+
+export SCRATCH_DEV=$dev
+unset USE_EXTERNAL
+
+_require_scratch_write_atomic
+_require_scratch_write_atomic_multi_fsblock
+
+xfs_io -c 'help pwrite' | grep -q RWF_ATOMIC || _notrun "xfs_io pwrite -A failed"
+xfs_io -c 'help falloc' | grep -q 'not found' && _notrun "xfs_io falloc failed"
+
+echo "scsi_debug atomic write properties" >> $seqres.full
+$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $SCRATCH_DEV >> $seqres.full
+
+_scratch_mkfs >> $seqres.full
+_scratch_mount
+test "$FSTYP" = "xfs" && _xfs_force_bdev data $SCRATCH_MNT
+
+testfile=$SCRATCH_MNT/testfile
+touch $testfile
+
+echo "filesystem atomic write properties" >> $seqres.full
+$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $testfile >> $seqres.full
+
+sector_size=$(blockdev --getss $SCRATCH_DEV)
+min_awu=$(_get_atomic_write_unit_min $testfile)
+max_awu=$(_get_atomic_write_unit_max $testfile)
+
+$XFS_IO_PROG -f -c "falloc 0 $((max_awu * 2))" -c fsync $testfile
+
+# try outside the advertised sizes
+echo "two EINVAL for unsupported sizes"
+min_i=$((min_awu / 2))
+_simple_atomic_write $min_i $min_i $testfile -d
+max_i=$((max_awu * 2))
+_simple_atomic_write $max_i $max_i $testfile -d
+
+# try all of the advertised sizes
+echo "all should work"
+for ((i = min_awu; i <= max_awu; i *= 2)); do
+	$XFS_IO_PROG -f -c "falloc 0 $((max_awu * 2))" -c fsync $testfile
+	_test_atomic_file_writes $i $testfile
+	_simple_atomic_write $i $i $testfile -d
+done
+
+# does not support buffered io
+echo "one EOPNOTSUPP for buffered atomic"
+_simple_atomic_write 0 $min_awu $testfile
+
+# does not support unaligned directio
+echo "one EINVAL for unaligned directio"
+_simple_atomic_write $sector_size $min_awu $testfile -d
+
+_scratch_unmount
+_put_scsi_debug_dev
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/generic/1222.out b/tests/generic/1222.out
new file mode 100644
index 00000000..158b52fa
--- /dev/null
+++ b/tests/generic/1222.out
@@ -0,0 +1,10 @@
+QA output created by 1222
+two EINVAL for unsupported sizes
+pwrite: Invalid argument
+pwrite: Invalid argument
+all should work
+one EOPNOTSUPP for buffered atomic
+pwrite: Operation not supported
+one EINVAL for unaligned directio
+pwrite: Invalid argument
+Silence is golden
diff --git a/tests/generic/1223 b/tests/generic/1223
new file mode 100755
index 00000000..e0b6f0a1
--- /dev/null
+++ b/tests/generic/1223
@@ -0,0 +1,67 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1223
+#
+# Validate multi-fsblock atomic write support with or without hw support
+#
+. ./common/preamble
+_begin_fstest auto quick rw atomicwrites
+
+. ./common/atomicwrites
+
+_require_scratch
+_require_atomic_write_test_commands
+_require_scratch_write_atomic_multi_fsblock
+
+echo "scratch device atomic write properties" >> $seqres.full
+$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $SCRATCH_DEV >> $seqres.full
+
+_scratch_mkfs >> $seqres.full
+_scratch_mount
+test "$FSTYP" = "xfs" && _xfs_force_bdev data $SCRATCH_MNT
+
+testfile=$SCRATCH_MNT/testfile
+touch $testfile
+
+echo "filesystem atomic write properties" >> $seqres.full
+$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $testfile >> $seqres.full
+
+sector_size=$(blockdev --getss $SCRATCH_DEV)
+min_awu=$(_get_atomic_write_unit_min $testfile)
+max_awu=$(_get_atomic_write_unit_max $testfile)
+
+$XFS_IO_PROG -f -c "falloc 0 $((max_awu * 2))" -c fsync $testfile
+
+# try outside the advertised sizes
+echo "two EINVAL for unsupported sizes"
+min_i=$((min_awu / 2))
+_simple_atomic_write $min_i $min_i $testfile -d
+max_i=$((max_awu * 2))
+_simple_atomic_write $max_i $max_i $testfile -d
+
+# try all of the advertised sizes
+for ((i = min_awu; i <= max_awu; i *= 2)); do
+	$XFS_IO_PROG -f -c "falloc 0 $((max_awu * 2))" -c fsync $testfile
+	_test_atomic_file_writes $i $testfile
+	_simple_atomic_write $i $i $testfile -d
+done
+
+# does not support buffered io
+echo "one EOPNOTSUPP for buffered atomic"
+_simple_atomic_write 0 $min_awu $testfile
+
+# does not support unaligned directio
+echo "one EINVAL for unaligned directio"
+if [ $sector_size -lt $min_awu ]; then
+	_simple_atomic_write $sector_size $min_awu $testfile -d
+else
+	# not supported, so fake the output
+	echo "pwrite: Invalid argument"
+fi
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/generic/1223.out b/tests/generic/1223.out
new file mode 100644
index 00000000..edf5bd71
--- /dev/null
+++ b/tests/generic/1223.out
@@ -0,0 +1,9 @@
+QA output created by 1223
+two EINVAL for unsupported sizes
+pwrite: Invalid argument
+pwrite: Invalid argument
+one EOPNOTSUPP for buffered atomic
+pwrite: Operation not supported
+one EINVAL for unaligned directio
+pwrite: Invalid argument
+Silence is golden
diff --git a/tests/generic/1224 b/tests/generic/1224
new file mode 100755
index 00000000..3f83eebc
--- /dev/null
+++ b/tests/generic/1224
@@ -0,0 +1,86 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1224
+#
+# reflink tests for large atomic writes with mixed mappings
+#
+. ./common/preamble
+_begin_fstest auto quick rw atomicwrites
+
+. ./common/atomicwrites
+. ./common/filter
+. ./common/reflink
+
+_require_scratch
+_require_atomic_write_test_commands
+_require_scratch_write_atomic_multi_fsblock
+_require_xfs_io_command pwrite -A
+_require_cp_reflink
+
+_scratch_mkfs_sized $((500 * 1048576)) >> $seqres.full 2>&1
+_scratch_mount
+
+file1=$SCRATCH_MNT/file1
+file2=$SCRATCH_MNT/file2
+file3=$SCRATCH_MNT/file3
+
+touch $file1
+
+max_awu=$(_get_atomic_write_unit_max $file1)
+test $max_awu -ge 262144 || _notrun "test requires atomic writes up to 256k"
+
+min_awu=$(_get_atomic_write_unit_min $file1)
+test $min_awu -le 4096 || _notrun "test requires atomic writes down to 4k"
+
+bsize=$(_get_file_block_size $SCRATCH_MNT)
+test $max_awu -gt $((bsize * 2)) || \
+	_notrun "max atomic write $max_awu less than 2 fsblocks $bsize"
+
+# reflink tests (files with shared extents)
+
+echo "atomic write shared data and unshared+shared data"
+dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
+cp --reflink=always $file1 $file2
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 32768" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+md5sum $file2 | _filter_scratch
+
+echo "atomic write shared data and shared+unshared data"
+dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
+cp --reflink=always $file1 $file2
+$XFS_IO_PROG -dc "pwrite -A -D -V1 32768 32768" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+md5sum $file2 | _filter_scratch
+
+echo "atomic overwrite unshared data"
+dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
+cp --reflink=always $file1 $file2
+$XFS_IO_PROG -dc "pwrite -D -V1 0 65536" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+md5sum $file2 | _filter_scratch
+
+echo "atomic write shared+unshared+shared data"
+dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
+cp --reflink=always $file1 $file2
+$XFS_IO_PROG -dc "pwrite -D -V1 4096 4096" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+md5sum $file2 | _filter_scratch
+
+echo "atomic write interweaved hole+unwritten+written+reflinked"
+dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
+blksz=4096
+nr=32
+_weave_reflink_rainbow $blksz $nr $file1 $file2 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+md5sum $file2 | _filter_scratch
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/1224.out b/tests/generic/1224.out
new file mode 100644
index 00000000..89e5cd5a
--- /dev/null
+++ b/tests/generic/1224.out
@@ -0,0 +1,16 @@
+QA output created by 1224
+atomic write shared data and unshared+shared data
+111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
+f1c9645dbc14efddc7d8a322685f26eb  SCRATCH_MNT/file2
+atomic write shared data and shared+unshared data
+111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
+f1c9645dbc14efddc7d8a322685f26eb  SCRATCH_MNT/file2
+atomic overwrite unshared data
+111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
+f1c9645dbc14efddc7d8a322685f26eb  SCRATCH_MNT/file2
+atomic write shared+unshared+shared data
+111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
+f1c9645dbc14efddc7d8a322685f26eb  SCRATCH_MNT/file2
+atomic write interweaved hole+unwritten+written+reflinked
+4edfbc469bed9965219ea80c9ae54626  SCRATCH_MNT/file1
+93243a293a9f568903485b0b2a895815  SCRATCH_MNT/file2
diff --git a/tests/generic/1225 b/tests/generic/1225
new file mode 100755
index 00000000..f2dea804
--- /dev/null
+++ b/tests/generic/1225
@@ -0,0 +1,128 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1225
+#
+# basic tests for large atomic writes with mixed mappings
+#
+. ./common/preamble
+_begin_fstest auto quick rw atomicwrites
+
+. ./common/atomicwrites
+. ./common/filter
+. ./common/reflink
+
+_require_scratch
+_require_atomic_write_test_commands
+_require_scratch_write_atomic_multi_fsblock
+_require_xfs_io_command pwrite -A
+
+_scratch_mkfs_sized $((500 * 1048576)) >> $seqres.full 2>&1
+_scratch_mount
+
+file1=$SCRATCH_MNT/file1
+file2=$SCRATCH_MNT/file2
+file3=$SCRATCH_MNT/file3
+
+touch $file1
+
+max_awu=$(_get_atomic_write_unit_max $file1)
+test $max_awu -ge 262144 || _notrun "test requires atomic writes up to 256k"
+
+min_awu=$(_get_atomic_write_unit_min $file1)
+test $min_awu -le 4096 || _notrun "test requires atomic writes down to 4k"
+
+bsize=$(_get_file_block_size $SCRATCH_MNT)
+test $max_awu -gt $((bsize * 2)) || \
+	_notrun "max atomic write $max_awu less than 2 fsblocks $bsize"
+
+# non-reflink tests
+
+echo "atomic write hole+mapped+hole"
+dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -D -V1 4096000 4096" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -D -V1 4096 4096" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+
+echo "atomic write adjacent mapped+hole and hole+mapped"
+dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -D -V1 4096000 4096" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -D -V1 0 4096" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -D -V1 61440 4096" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 32768" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 32768 32768" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+
+echo "atomic write mapped+hole+mapped"
+dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -D -V1 4096000 4096" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -D -V1 0 4096" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -D -V1 61440 4096" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+
+echo "atomic write unwritten+mapped+unwritten"
+dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
+$XFS_IO_PROG -fc "falloc 0 4096000" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -D -V1 4096 4096" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+
+echo "atomic write adjacent mapped+unwritten and unwritten+mapped"
+dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
+$XFS_IO_PROG -fc "falloc 0 4096000" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -D -V1 0 4096" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -D -V1 61440 4096" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 32768" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 32768 32768" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+
+echo "atomic write mapped+unwritten+mapped"
+dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
+$XFS_IO_PROG -fc "falloc 0 4096000" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -D -V1 0 4096" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -D -V1 61440 4096" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+
+echo "atomic write interweaved hole+unwritten+written"
+dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
+blksz=4096
+nr=32
+_weave_file_rainbow $blksz $nr $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+
+echo "atomic write at EOF"
+dd if=/dev/zero of=$file1 bs=128K count=3 conv=fsync >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 262144 262144" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+
+echo "atomic write preallocated region"
+fallocate -l 10M $file1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+
+# atomic write max size
+dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
+aw_max=$(_get_atomic_write_unit_max $file1)
+cp $file1 $file1.chk
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 $aw_max" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -c "pwrite 0 $aw_max" $file1.chk >>$seqres.full 2>&1
+cmp -s $file1 $file1.chk || echo "file1 doesnt match file1.chk"
+
+echo "atomic write max size on fragmented fs"
+avail=`_get_available_space $SCRATCH_MNT`
+filesizemb=$((avail / 1024 / 1024 - 1))
+fragmentedfile=$SCRATCH_MNT/fragmentedfile
+$XFS_IO_PROG -fc "falloc 0 ${filesizemb}m" $fragmentedfile
+$here/src/punch-alternating $fragmentedfile
+touch $file3
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file3 >>$seqres.full 2>&1
+md5sum $file3 | _filter_scratch
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/1225.out b/tests/generic/1225.out
new file mode 100644
index 00000000..92302597
--- /dev/null
+++ b/tests/generic/1225.out
@@ -0,0 +1,21 @@
+QA output created by 1225
+atomic write hole+mapped+hole
+9464b66461bc1d20229e1b71733539d0  SCRATCH_MNT/file1
+atomic write adjacent mapped+hole and hole+mapped
+9464b66461bc1d20229e1b71733539d0  SCRATCH_MNT/file1
+atomic write mapped+hole+mapped
+9464b66461bc1d20229e1b71733539d0  SCRATCH_MNT/file1
+atomic write unwritten+mapped+unwritten
+111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
+atomic write adjacent mapped+unwritten and unwritten+mapped
+111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
+atomic write mapped+unwritten+mapped
+111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
+atomic write interweaved hole+unwritten+written
+5577e46f20631d76bbac73ab1b4ed208  SCRATCH_MNT/file1
+atomic write at EOF
+75572c4929fde8faf131e84df4c6a764  SCRATCH_MNT/file1
+atomic write preallocated region
+27a248351cd540bc9ac2c2dc841abca2  SCRATCH_MNT/file1
+atomic write max size on fragmented fs
+27c9068d1b51da575a53ad34c57ca5cc  SCRATCH_MNT/file3
-- 
2.34.1

