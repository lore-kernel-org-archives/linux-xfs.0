Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C0A33EA;
	Thu, 26 Jun 2025 00:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750897675; cv=fail; b=VJYLaxgjwdV8cIqqi3QKquUCEiHD1OoXM894qDAZ22i6QdBedqUl80/W6VQpxZmDEIjwCjdbl2YIkdXSTxLDoHHJEiDTaNjCWclqjMaNjWKsyXdvWOBQsGzUr5zLw9odZyXVYDHpmvpuvDJnwsujda9UqVK0hWHSozIfQDL8rpo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750897675; c=relaxed/simple;
	bh=pGzcHutD1NLFrmzRiSOauWiCnJwjZLnZx041YaPcICg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=K9A3Kt4RE/2DJSQi3r6h49KIs5L2yx6HAWhOcHD2c7b9NNwWqkEwpkNaOJQQIeHi9lbUBgtIGuvHPc5D5qtutGdQE9/o98sfQaT3NwIqhAvkYe3CK2nax9kwndymUy0vjV5is1Ey1qa1/+9CZvboa1HpfffWngQBC7Zk++aY5zY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QASjf0JH; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=gcp4MSqf; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QASjf0JH";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="gcp4MSqf"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55PLBxA1008102;
	Thu, 26 Jun 2025 00:27:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=IVYZ+JbRAz2t8dNd8AesybgXPGEiiHYJ2mPqVH9AgqY=; b=
	QASjf0JHBjcUHBZk1gZNWYgYXhjjZdIXvv1UvCyk9wSljODGOcN6Q048HQHvWBXo
	vFvn+95NK/41YQiIUNr8iHaL2dWJWXLJJ+Tt89HVa/H5T8YR0F2wJcb0rb/cOFDe
	Co63Gd+Nh1mkP/vnyAbh8GHs2UC48ORsHrbTGiaykLLgSKBQAf/OViSbqkenmwuo
	JitbyOYcHA9nQmJHREUfq/MiVmbUwtFCxXE2RpEs2EbhqRAt1ZsymXPNiy7qy/Kg
	XcMd0NGQ75Ad0gwlpoMq03cCswIOMiKi4h3rwdfJZb+fl4zMfQS8JjXNLUtaAL/a
	L265HBK1r1C4xTqWYU7IYA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47ds880snw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Jun 2025 00:27:45 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55PNeVRt012862;
	Thu, 26 Jun 2025 00:27:43 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02on2042.outbound.protection.outlook.com [40.107.95.42])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47ehvya6e7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Jun 2025 00:27:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vFuQt4xbWTsFROPsETcnO/MNySol7LtOQA/a3xuOiG6HBrWWDEVp87tegKR1HBdSGJ4omDv/dgD+77+Xj7rJvR/10RUKmCnMPK1nmhKn8uwgXoW24i4wPQWlcJx9Obmf2y7KTdECkWkk60qoa5gWIOssjAdMpmD+UvE/Q0kLICDlinsZz32NY8Q2rYSWNIkiWaj8bVRLJS8jgWgVGcJCwuHJ0f3sWRWPDzdqRnTtPBMl+xrNOpp+oWe0kuTHlBmWJ5bMf+bkJXQMFsWbVSeaHXfIj45RZSegCKRk6jpDtW9rpCAeD/ED6fCyrZhur0MpagPTXlEdL6+X08MI7R25gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IVYZ+JbRAz2t8dNd8AesybgXPGEiiHYJ2mPqVH9AgqY=;
 b=LcSRn/rhatyhs4KEHZh9Wh9nlbugDRIuca5sAyuOvdHUpE2Wo+sabCD+VC7t74Ab/Hy70xAhdQu23I+PlUDWNF//C21mDKIMvjT1a4mgVa41DwqpKzIh44zuZf9yCWSTuDdv1p461IXXy3hTzgBpqqGLWyzGi443SpTcIkrqumkTUq/fT3SgnnWLpdJcP36HlUvW/TNf4muze9GFbsEidaMD/7cLwtUVTlygPHIIbTdbWq6OySvwm57ImgYySYn+ZMwuKGN5himkbX4guzXSKklJ5hd+auvtu0FCVE+v7SLVHlGLzi/AOpXVCOcWZVR6rJLmalZBpD2W1ZXfJaFcQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IVYZ+JbRAz2t8dNd8AesybgXPGEiiHYJ2mPqVH9AgqY=;
 b=gcp4MSqfbj/hSXz+NFGottlVeQZOQa2d2/d3dRpPD9ZTy/Qw86E4InQzD8hZdKHP0tS3YdbdzUU/1nDCnJBnRYFFe96pv17pybMpTyBNq9Wi5E47mP633mn2t61C1oWb84rGpV2lnkzHeJ7/FmagiN/KcqbpNkGVIIPHv5P1E1Q=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH0PR10MB7098.namprd10.prod.outlook.com (2603:10b6:510:26e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.16; Thu, 26 Jun
 2025 00:27:41 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%7]) with mapi id 15.20.8857.026; Thu, 26 Jun 2025
 00:27:41 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc: djwong@kernel.org, john.g.garry@oracle.com, ritesh.list@gmail.com,
        ojaswin@linux.ibm.com, zlang@redhat.com
Subject: [PATCH v6 2/3] generic: various atomic write tests with hardware and scsi_debug
Date: Wed, 25 Jun 2025 17:27:34 -0700
Message-Id: <20250626002735.22827-3-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250626002735.22827-1-catherine.hoang@oracle.com>
References: <20250626002735.22827-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0101.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::42) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|PH0PR10MB7098:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a431229-d670-4d95-d905-08ddb448431d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|10070799003|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UsW1+hh20jqEmANjcXCPcazbKvd60YF2QbEJuWrl3+egWMmfJVAPHTxkPC6I?=
 =?us-ascii?Q?ff8kTisvGHYYPQUDQ6DdRqOocz/tJVG+9ad2tpbC5ETlrMmjWGUgWxW4Nx7J?=
 =?us-ascii?Q?kC7q3qYmDA66A9OAjjFGLv+K2Ng5GQBJpj1pu6AwLriFhrSWpZ0ySUG0CJCL?=
 =?us-ascii?Q?vgkziic2ryyAXoP10C2Uwgmye9WnQ9W+LriJ8GvF4M7FBXaPk0GsaPT7lzIF?=
 =?us-ascii?Q?66hCK1a8K95Ae8fM90wURSgJXCh6iom3bhfi9bz6nBPvi0Y1aAHEWJ/Di1us?=
 =?us-ascii?Q?pWDLyaQlymS+wOcFnVilAh0aFYuuiMYkgqee/nXk5RcTHSuiy2omPypMeX+v?=
 =?us-ascii?Q?cdVHQxyAFv9DQygp18Xax0UoiWwC3X5l+eG6uwXTKAFR9MIJP+N+TDwzQvKO?=
 =?us-ascii?Q?pD9ezCprTh/PlMSm5bLMdbwgTY7JM87Q8FCYFmULdknD6d8XMG1BCqpbxb2i?=
 =?us-ascii?Q?JkJECDFSpM0qW7ySnCYaFpGHcXYjG5sfJbjuH9mcZEvcKIicsn9ou1P/e3JJ?=
 =?us-ascii?Q?nQtXfnHoJJo5iv0LO2uXiHNY3mYQNrtGLY6moHoIJs5qEDkKthURQl7743f+?=
 =?us-ascii?Q?A88Nzq2dJgGRRT5axpRXPl7DnhpwQ+8jxC0b3APRzEtIizgwM//kPfiCJCc+?=
 =?us-ascii?Q?SdQbD6gUJNQXVqEWtfSkau1lFJlaCC06lD+LKXw2YgEhsc0MR2VMRjjUTJ6n?=
 =?us-ascii?Q?EFhC3VGRUb9S6hs6AgMUbn89GEFDSdBKXFwdQL/MPLHbrLGghY16XHR+eKhx?=
 =?us-ascii?Q?cxbCJa5cQvWQEdGbDFaThGq82mogXa1qDQu2jjS2Yl+65k+V41NeIyFU9Jf1?=
 =?us-ascii?Q?7ya2CuaxWw5WEwTpd+9QAGuOu3hZ0JUis7VE1YN7r7GME1tCdTL5yHwAUC4N?=
 =?us-ascii?Q?XWZAsk4uF5S5avd4kn92+5z5rl83Bc3vY4Fv8gsQblkiO/54IIvS6erra/Bi?=
 =?us-ascii?Q?w8TyQnglU2j352IDMe7mHVz2+8whYxLbuxjZQyJSsZxCbUVGsA1QT3bYa1Vq?=
 =?us-ascii?Q?EXnMAY63aGeOMHV+u9zg0zyt747Cyv2Q8X/HJsZfU4HYnAnrI9BqJlNoUGaJ?=
 =?us-ascii?Q?qsKTkebW7I8rbyMQVc9N+RbFBaFi6tEbn0XIheYM5TrHXoROkdhOSMxj3R7Q?=
 =?us-ascii?Q?TdaMckILAzrVosiPxnc+Ym0Z0V43nh6Z6itiP5ZRaZJ/vQGJLdKh2jEGxzLF?=
 =?us-ascii?Q?z3PpK6onGOTAAzh96OQsWJtGJt40ISe/JPdot6k1fF+fe/QTsFMK++IohjpC?=
 =?us-ascii?Q?l8TbChdBBRxUfPbFYo9NC/r/gb0G7KFUuHcMujyNS4ZwUtZ8m3Bsgae3amNb?=
 =?us-ascii?Q?UPNqnJIEH1oquKpkdeGIKAchXZJMSeCiha/9K+eszN9wpMaU26fdGZGfjQ0L?=
 =?us-ascii?Q?igM2/RGbkzzYZ2UfNtouRp/tWt2u08v+fKJ/mHi39kdBNqpWnBjkwHdvsViy?=
 =?us-ascii?Q?E9lMbsr3Z3s=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(10070799003)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HIRXwaxps9e80ffNQt3pY4q2FVn/ShjqtdgDB3p9ZFLud2bBm0UyVX0ExhmF?=
 =?us-ascii?Q?rmF77RpBKAJPTf4yq3lmndRcXJ5h0gvXc49PgnrbS1n46cNzgLfMmONQzD2N?=
 =?us-ascii?Q?BkdOMIlLOubgnkALp77SnmBr7aaYubFrKfXD6ZhoaCnp0LYG7ASJpyPdjdeE?=
 =?us-ascii?Q?zPrVb9aiQu9gaNf7rL+nmwtrPfnLKyWFqVIZCJU5utRCMUCWnxEvh5Cr4PTs?=
 =?us-ascii?Q?lwewMuYeivbpMjbyOt9IUCotPtSeL8eJjdIW8m0Q8Gr6IX6GExdW3z0fWSOa?=
 =?us-ascii?Q?BvzUd+ecBhplEoZXjyHdh9FtYCGyMt7QmD7e4HOPnHFngf02mDc+XHrVLB70?=
 =?us-ascii?Q?V+MajWi9TSjmnPvEU77Bqv41+M08+SlWfp2+jCCqVbeWvaacQDCEQr8zIWxY?=
 =?us-ascii?Q?XE5joMqH5IpMF2n6l+4sDmhbFyqQ/5k5PezgzaKptkEbaIetzXfOD0t4/gBb?=
 =?us-ascii?Q?AsoH205iXhbQD0I0pLg12KzXhS4CWxQsLRxqqnEspiP7HNAVTx85gECX8aEb?=
 =?us-ascii?Q?vyTaeuCX5oeLimIl09fHl8pIj+P+acYKzQYDO7U+6nDtOclxK8z5ihHqdNJo?=
 =?us-ascii?Q?Ow5h7eHRpA3kWmLMDbl4JxppDNGKGZ+/fwyN2LPeBmoP6BbsKHKydFfFaIQz?=
 =?us-ascii?Q?PcxObNxq2eWfyNkE1VDot0P2zyYuua9XZHGnqs+mIURBlv0yhfP4ipjCE5OL?=
 =?us-ascii?Q?Z7EQaXXDVv0ISul+oFf55drev/ev1COzVD5P9CprLSN/+zO5c/TnMO/vNFio?=
 =?us-ascii?Q?F6dTDB7qf6EQ7J9kOxFZCqXphffmJf/bvOPK69q02TqxgJ/QY+eMOEHcLQa5?=
 =?us-ascii?Q?ljRfTiNdMov+w/SyKaYQ8Xfba4xEDQ190G3AlXJojrEj4m0gWp+EgfE3kQmD?=
 =?us-ascii?Q?yzwAJdaiXytFVq80o1ejga3P0Ezr08ZgnozDngyNClf8z5pkvwiKjww5Rpah?=
 =?us-ascii?Q?JSyB9Md5yT23w2QwId/hyH5K2lxjSJcaW3OF8wGJrdHjCrdaQ0jh0Fk8u+Pc?=
 =?us-ascii?Q?G4i9WJ4x+VziytvJYLk8cr34mmaGS1u/VSguxPa63gjiojIgH2hsJ+s/S3dX?=
 =?us-ascii?Q?mDyQNjPTYOVz5v73rSKxnqvlpwgf5/dPOJpglIOlyCL4u0wEIbUDIcxoqtLk?=
 =?us-ascii?Q?Sff+eZRSNuZPuQk+lafyO3Xc79YCykZbkvEmnBIZVCrZIXicU3tSeVdY3IV9?=
 =?us-ascii?Q?xBgleSiclTnpM6vGVKbws3ODzDW+UOiaWDshpMZ3wFYgrZGw62huB2zQE03g?=
 =?us-ascii?Q?+Him3Ox34QtoIdS43Y2Doc0q5vY2CZfxXSbg3Qu1Tu/WIAJVu3HAtu5y+Q0A?=
 =?us-ascii?Q?WRW1m8n5/d3jEX9EVSyYROkusdbmIzwFLO1g/HCsXHJhain7GuNvMffqXFFG?=
 =?us-ascii?Q?fYgc8KCUcLJwyMNYW/RmTftU/7CiTAmj6KHfohdwXiv6cEp/3s3KwQK1x/ez?=
 =?us-ascii?Q?mRm2uvABJ8BZZqONVNCnWIs6z6QBmMVT/shidMazwQNFO6FVOB3Vg7wvVJld?=
 =?us-ascii?Q?qagV87Ho6Cff1NPHBzJu+FayDKOdCxbdTcyUXJ3+XqstQzlJcm8J2eGPqQQU?=
 =?us-ascii?Q?oXsveEA7Y5vX6kFu2B4L+V0MszkHUQfei+7g89koAouwPWQwJ2PM00oGzud7?=
 =?us-ascii?Q?OhjgsioLZh83wWwNwn1aFZTCfGMd/ld9Zz4v8hzVkiKTX9dnAwvU6KqTxeYR?=
 =?us-ascii?Q?GAxhpQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sf1axWEN8oUsbl1ddyxPOn+y/IbbCfAYWAq7j3z+AmOq3BFRlHEA8BF+mmi8VodYaLTjlq8oMuW7D82cufBhu9fKwQRZneMhiAeiLH6Dbbk9iikZJiaLKsoXbXG5LY2UqqisrtgrqzNTAXkqKH41c661INTeM0y2tvjIaIOGSZ6dBtwwEr47yjDNB2Tc3SXfOhCLt5v6YfmBfxnrU4hVQLf5SlAriZykhmqfY97xN9u0s1TOqtO7dEa1ZEabO0CvWaEZxQon2U2UKj9YWTcUYtIGTRz0KoqGUbDpNo0KItq4j61ENu603ywYV23szZsHZ9bGUC+8NVMNsgxaXc3a/XM3351MjnrK+7azaRWnIR8k+yP1mFUtIZDyvJ5Ea6nLM+kBUzI7uqN1jJcc6X4b8zrKIJqrZvi8gytMV45iu5EDBLfNv4bA/f/bVtuYi03MbjIIlARZG4P6Mte/3IE9OBfGDMk6Kqit4CZLJvFdacLRUAqAoE4E61qityTKq0W3/xUL/fQtm8LKGCZTFy12qY3ue2iC/7FHUhMlN+Fs2AixcvB/s82y12+tT8lVkknglC7M6ejMLEtg5tJpr2jLktf8QietvkakVKPchYt38FA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a431229-d670-4d95-d905-08ddb448431d
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2025 00:27:41.5992
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H7j1v4H/MQmz2mvEoexJ9Gur03fKI4DRb1uls/aC2zIBjncjy9A42RkVw41LlONnVlD2DH+u0+3sWdchcUgqsRIiy1kKQC1jsa+JhCEtQiY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB7098
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-25_08,2025-06-25_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 phishscore=0 adultscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506260001
X-Authority-Analysis: v=2.4 cv=a8gw9VSF c=1 sm=1 tr=0 ts=685c9401 b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=VnNF1IyMAAAA:8 a=mHjRQy0VDrkUE9po3vUA:9 cc=ntf awl=host:14723
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjI2MDAwMiBTYWx0ZWRfXwXWl9ddfcFyY 7nyWWso2OOZR/fodHfIvFf8Rv6Idz9UXoFN5Zxd1D5Hyk5EqnvpgQyEOdDdTiIz1NGVF5gIbNaa Mab705O/Fnzvv9Y+shoW65SYeabJSR4M/+8dScFPS6Z66SWO/EsWBKVZ3gj9cnWs9M8Up7lJSPr
 NpbTkXDv1rnq7SeZLauQ+0OEmFRXUUm2d+fRQhoiBrOOW7HWdTQQxtVrVceUAHoUoW+u6KqsP1/ hBKds7DHmMoNhRe/ZUqGbd2lAL4CkdMuEk2vgFmtk9llaJ+lEb0mlYhaQap1IUYDizRnt/YQGt2 nHnqPth4RNwFxStAYOTO1rUpT78a+Q9lYAlVrupz7GHaor2sriX/Gwnf8ZzyteDo1BKaZgyUNd0
 PkFnrIKOoXtWkiHSQCAnfL4+bnqlSqlyDa2mW1T/Ata0zPaiI+m8xm8KWwvFt7IC/BKKqCg/
X-Proofpoint-GUID: YGIvXe1A32aVPgOGv6pcGewfpK2ixA4l
X-Proofpoint-ORIG-GUID: YGIvXe1A32aVPgOGv6pcGewfpK2ixA4l

From: "Darrick J. Wong" <djwong@kernel.org>

Simple tests of various atomic write requests and a (simulated) hardware
device.

The first test performs basic multi-block atomic writes on a scsi_debug device
with atomic writes enabled. We test all advertised sizes between the atomic
write unit min and max. We also ensure that the write fails when expected, such
as when attempting buffered io or unaligned directio.

The second test is similar to the one above, except that it verifies multi-block
atomic writes on actual hardware instead of simulated hardware. The device used
in this test is not required to support atomic writes.

The final two tests ensure multi-block atomic writes can be performed on various
interweaved mappings, including written, mapped, hole, and unwritten. We also
test large atomic writes on a heavily fragmented filesystem. These tests are
separated into reflink (shared) and non-reflink tests.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 common/atomicwrites    |  10 ++++
 tests/generic/1222     |  93 +++++++++++++++++++++++++++++
 tests/generic/1222.out |  10 ++++
 tests/generic/1223     |  68 ++++++++++++++++++++++
 tests/generic/1223.out |   9 +++
 tests/generic/1224     |  88 ++++++++++++++++++++++++++++
 tests/generic/1224.out |  16 +++++
 tests/generic/1225     | 129 +++++++++++++++++++++++++++++++++++++++++
 tests/generic/1225.out |  21 +++++++
 9 files changed, 444 insertions(+)
 create mode 100755 tests/generic/1222
 create mode 100644 tests/generic/1222.out
 create mode 100755 tests/generic/1223
 create mode 100644 tests/generic/1223.out
 create mode 100755 tests/generic/1224
 create mode 100644 tests/generic/1224.out
 create mode 100755 tests/generic/1225
 create mode 100644 tests/generic/1225.out

diff --git a/common/atomicwrites b/common/atomicwrites
index ac4facc3..95d545a6 100644
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
index 00000000..bce19c26
--- /dev/null
+++ b/tests/generic/1222
@@ -0,0 +1,93 @@
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
+_require_scratch
+_require_block_device $SCRATCH_DEV
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
+# Check that xfs_io supports the commands needed to run this test
+# Note: _require_xfs_io_command is not used here because we want to
+# run this test even if $TEST_DIR does not support atomic writes
+$XFS_IO_PROG -c 'help pwrite' | grep -q RWF_ATOMIC || _notrun "xfs_io pwrite -A failed"
+$XFS_IO_PROG -c 'help falloc' | grep -q 'not found' && _notrun "xfs_io falloc failed"
+$XFS_IO_PROG -c 'help statx' | grep -q -- '-r' || _notrun "xfs_io statx -r failed"
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
index 00000000..5cf12933
--- /dev/null
+++ b/tests/generic/1223
@@ -0,0 +1,68 @@
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
+_require_block_device $SCRATCH_DEV
+_require_xfs_io_command "statx" "-r"
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
index 00000000..d7a4dcd8
--- /dev/null
+++ b/tests/generic/1224
@@ -0,0 +1,88 @@
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
+_require_block_device $SCRATCH_DEV
+_require_xfs_io_command "statx" "-r"
+_require_atomic_write_test_commands
+_require_scratch_write_atomic_multi_fsblock
+_require_cp_reflink
+_require_scratch_reflink
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
index 00000000..e3d11a76
--- /dev/null
+++ b/tests/generic/1225
@@ -0,0 +1,129 @@
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
+_require_block_device $SCRATCH_DEV
+_require_xfs_io_command "statx" "-r"
+_require_atomic_write_test_commands
+_require_scratch_write_atomic_multi_fsblock
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
+test $max_awu -ge 65536 || _notrun "test requires atomic writes up to 64k"
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
+dd if=/dev/zero of=$file1 bs=32K count=12 conv=fsync >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 360448 65536" $file1 >>$seqres.full 2>&1
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
index 00000000..c5a6de04
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
+0e44615ab08f3e8585a374fca9a6f5eb  SCRATCH_MNT/file1
+atomic write preallocated region
+3acf1ace00273bc4e2bf4a8d016611ea  SCRATCH_MNT/file1
+atomic write max size on fragmented fs
+27c9068d1b51da575a53ad34c57ca5cc  SCRATCH_MNT/file3
-- 
2.34.1

