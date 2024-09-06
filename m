Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C111D6DC5
	for <linux-xfs@vger.kernel.org>; Fri,  6 Sep 2024 21:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725657119; cv=fail; b=tAhHMkIz/en8eRTp+sU26pCofwdNDQBzfhA6e6Vdah+qoOQi/HARj53VmcohS5yJD87NRtpSwMlyHE4jYnhpWozhq/5106eeNdHf/rITaVBktN3NovM3z+Fpcj9wWDu5VRfvgTRgOmlLcXJbhuRRrTuNhfaW4yt3YM4RK3LZYz4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725657119; c=relaxed/simple;
	bh=/yFhShMsiZQVVKJmf10L3KPPS3o67lLMjGLP603145g=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DzU1ilzI+H9sFt8REqfuvswxZ6jfZKvB5zgaK0kvyk5FyNYp3Ic0DmkwRS31/cgeAxu0kSwCHo8YcvnANA8IVT6AWBHmjbinRcZdApwp4ghrA7O0754dpccBXX40auBO0+Rh1pzMi3vH8AL2ReWyyDnzpRvMU6JZyHgEYDoQUGY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=b7CqCm/s; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=eSZgWnAe; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="b7CqCm/s";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="eSZgWnAe"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 486KXWIq011342
	for <linux-xfs@vger.kernel.org>; Fri, 6 Sep 2024 21:11:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=uDBlipRV5kDf3e1tqFszGfF5GDRdZRdYIlu1u2QeQA8=; b=
	b7CqCm/sncL3LYleTVP2doy5tKdooZcFlv+ywBhPJO0Ly8htQMp2fqEZPq4lJrB4
	1LHEuio3nDRkiEaGB/+FD4GxuPulXQA0MSLzuDAJqHS2yi0L22MzaUTM61XBEgG3
	81Xsr6IBCspbFHOmTvV6keQVeWHelcQQxbzejduKQkysJK42FLiPa4xT9P1fxskU
	+2S35YqPeJKsomsf6IgDxHSKR0xQQ2cZYJlXwjDGFOwx9UGGGO+44hyMa7VHTKQR
	nOyfytOi2FpsYSAMakZSi1ZWMpaqxQPpzHEpcOoxnCb0D6MMOG5pKJxzVuUx34r4
	pVjufjNuXEsqkI4xi2QCWw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41fhwkajay-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 06 Sep 2024 21:11:56 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 486KCuR2016252
	for <linux-xfs@vger.kernel.org>; Fri, 6 Sep 2024 21:11:56 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41fhyjeyvw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 06 Sep 2024 21:11:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RF4eNK9YnrXY0sJ15c+UOMK1LrMCQ+Csbz54RGkLjrBmtpB2OAb5BnFMMaR2zRydMjn1jx0kKb5nVvnY4Bp4KNMQKW8C2gj1WJyOaDOiCb7U7lPa4b5z5om1dqSQBG+mcKJ0iw0/y89B1peBrBjR/VZAh7kscB6V/+EgPZuXqU6zj485L/Op0fhM/P8xPpMwp11tAzFiUNg4UCsfmo3POZmT/GKSmsKUqPzqGvxgX5gg3tVcsVMRP6HWLX7W+UZcP0LwlF8h0uOPcG+LXFUNdAgOUj3bGqtYJWvPsTqY8ZWGBmToTDCT6VePQgKQxcuQjGCxRY8Ig8MD4iXE1OoTEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uDBlipRV5kDf3e1tqFszGfF5GDRdZRdYIlu1u2QeQA8=;
 b=KEaweLfXv+di6sLsUsOHcGrevHQo6UtWceRRyhF3lN7ljChX8fKMamv3ltxd7uaPn/bXdGSzrw5N241PAfJfcXjr7LqglskbA+iez+WB1i9UjTAZDYTSZs8YFV4zg6aCJY0mFv3zYFUNNDOg3iX83Je47MuJaAFZW6e+HSV69sbw3mkBY9+/udCMWsS7QzI8mmyXggl3xZ3jusybhc2GIsM3UbMMU33v7R3KeRDYPil+5nGw5hLEQP3T6Vv2UxcDlJS/LaPCPky5Z14cfEL5cFAPvL0VCVnyD5RMkcKemxzkzFbqKujVr6NKBPR5G3l5z65y4QzO2S11ePESjETydQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uDBlipRV5kDf3e1tqFszGfF5GDRdZRdYIlu1u2QeQA8=;
 b=eSZgWnAefi6eE1+xyV48fAl4LX1CHcfqvehVjrXkHYcCpAtAnj+ZTxQcXnQRmfnsWpQH+hgkf/qgI5xMst5IFu5W093rPbzou6/7jL6IHp76TgP2VmnQQTVBXZ6MTwsGwyzO8KNG5OIMNlfb2r2qlsmJxajvDHOslbPseh2ir1E=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DM4PR10MB6765.namprd10.prod.outlook.com (2603:10b6:8:10f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.9; Fri, 6 Sep
 2024 21:11:54 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.7939.010; Fri, 6 Sep 2024
 21:11:54 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 06/22] xfs: check opcode and iovec count match in xlog_recover_attri_commit_pass2
Date: Fri,  6 Sep 2024 14:11:20 -0700
Message-Id: <20240906211136.70391-7-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20240906211136.70391-1-catherine.hoang@oracle.com>
References: <20240906211136.70391-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0132.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::17) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|DM4PR10MB6765:EE_
X-MS-Office365-Filtering-Correlation-Id: 54939de3-947d-48da-418c-08dcceb888d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UJWuDyxQnKxItNpxRAaxlNa92KuSr+/cK4IehuSR9bwVIXcwZRwbAbeoUWyg?=
 =?us-ascii?Q?5Ysmtk34uSkE/d/1Jgq83uODGmLLLOuZ/fANrqcmC3cs6OYsCouyGxWSHk8O?=
 =?us-ascii?Q?8cTCfH/DrGonAoxTJPoXVJB54qwzrmQscPXl7lObLlLQpJ+3RaGUbACil3Om?=
 =?us-ascii?Q?8EhN7OXu+5Sf9fRU5zKX3ssr4SEw+jMROq1e0NLh7ec+kUFdbMn3WVOW4AKd?=
 =?us-ascii?Q?ZHVMIq0eydvjjrWnxs0BjXedEgzXDQBUdG6YwrlEZX9uMoN7Wo3NnmDrCfIs?=
 =?us-ascii?Q?eSjdaibnpPurb03dzgmX0CXLJKIRY58anZFoiGrsTtcET2VJQanFFLzjj48H?=
 =?us-ascii?Q?B89X4cwdXo4LQhbPhkyakm8b2HgCRT3EFZ54Z6bk/IoGJKvgoA19QIrc5NWE?=
 =?us-ascii?Q?Ou1K0wVVSRr47OziMj/YswHzMFaiLtuz4fd58KfezcDc6kyDOkoKyEnOlVlj?=
 =?us-ascii?Q?pU2hTm9JzlXXxfZQQepE3O2Z/HGPPI2uYeCGOsrqNQ5iz9Zurz5CnX9ilHBq?=
 =?us-ascii?Q?q3bViistcIm8rn09Lw9a3eOkpfn/pall72+Gha1VPLAwUJVRTAGI/uYmPU1R?=
 =?us-ascii?Q?snlvDIkTHyo7gQNRU1y3gTMnP8jJzUF7pQMh2iZTydT9RyPOoC1InZkAWvfX?=
 =?us-ascii?Q?5QWVnLEsjNTXaPNf/Nyc8ziLEM+scsFCaU9O3g1Hh9DB8rmNH1VD0+MnVvfD?=
 =?us-ascii?Q?FaWyIUtniyvDhfWskkn35mSUU6Y3gPlsaEZFPPm/Fbe7McDgsPUYEPooPc2z?=
 =?us-ascii?Q?saFoQHu14Y0pBn9xJb+ZbmHIkCSRl10cMus2XBL5XRfLIY8EpOTQr6g8tDsf?=
 =?us-ascii?Q?DuFFZh3biSlYzHdvjOHnOexK89cCf9HYTNHJ547vUc25cYmIKd8oF6dzX2+L?=
 =?us-ascii?Q?r63jvyOAgkU73foWC8trIhnbKw59fHeoC1Su/Jk8qta1luBJnZ87bZO0o56U?=
 =?us-ascii?Q?qvCGzjdR6QljMTyUU4EW4BDkcuOn9rpWMXhER1RpWEVnjK3mEDNZCxHlqWOp?=
 =?us-ascii?Q?feaID3/xRIeLhzMGxEv6Ot3PKH1bEu/sCNWeyZ30YyWVq/yk6oH4d/dm8Spv?=
 =?us-ascii?Q?8S3YIOppTB+QRTNtb5tJHvCR7NXM+sTugCdstqHHide48anBnkbvN+SGJz5p?=
 =?us-ascii?Q?Bx4ljKgd3KU/KJA8FZUheB4y8/LLPKyXGN4OSQ/0GBw2HhRhI/ATmY3SV1fC?=
 =?us-ascii?Q?1B01xac31cBWY52N5FJfpsCahUtG8atzzn3Agd2B37wQ+rm5MyCexNpbkx9b?=
 =?us-ascii?Q?tZ1UkbasTeTTFp6qKdrtSCwoJNl48dD3Vw6p2PYAUwRWzOHZ3NaV2sTEqdro?=
 =?us-ascii?Q?ny5G+OVO+aDHqoj/pbF6zudbBX9eAYYzy4JnCl2Uheso+A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?T4ZdEzcVIbOKzTnAimZzHLU7tKBXY8IqBioV05FOGyNGoN0wqHnUpQOgLO75?=
 =?us-ascii?Q?wQknrIKtSjW/9G0p1GMlTGj0MPK4PwD6ikI+vPuurzlJLcjhP8gdsGxRMQ+7?=
 =?us-ascii?Q?63Wae0BpFwQWee1CYxFVlWveSV9pZjj0MlWOXkuNLYIdoAumn9QVrYCO8roe?=
 =?us-ascii?Q?ZA5SPy+W7LyFb46Q69ibYj9ul1qpJT2kAR2yvsTDLEMD+1uBuJ4WAwQXAKc2?=
 =?us-ascii?Q?q1TXYdNJqI3nbNV2OF0rpUkS87utSCUHfHTZyzpjNaKoRNmMO+gOyybfPShR?=
 =?us-ascii?Q?wi9ltFAyYWxHZVa1/tTTeM8N8L+m0oZsNHqETkg2hrahWReBYppzsFKG5kuz?=
 =?us-ascii?Q?fxAR+JnGERuBhrj2DTIKb5tjs5u/iaGbxto6nZ9KEr+4RRfXgolpqq25MleO?=
 =?us-ascii?Q?vauWLaORwZ/WZM2GrVt53avir9xVzeI4y0mv2RF5NUoLTgJPcZGhl4af3QpO?=
 =?us-ascii?Q?jjUJIFuUwIjBT61bNk8HM1sS3biqUh9tzv6lYNsNzPnSd60WjmRV/ZNoATMx?=
 =?us-ascii?Q?UQtW/GHpBty0sb72Oqb1hzasdJu2a8FIOm1yT7/SM45s5tLYl8IxUduUGPwt?=
 =?us-ascii?Q?1ihl9d5V0x7GLr6TfRGG69vKJhtzMumvJ93VesoBhBRfBy08mGUIe0jj/VDe?=
 =?us-ascii?Q?fEHdwADV4eZdA/YPcO5D2k7aKvi234dZfuOIm4UXHHFpVpjEyN6sZe0/3WXX?=
 =?us-ascii?Q?0cCZGnfGhvaZ/JPNFrPu+3zET+pkZUwrK8UUr5lin7iWeygOwUAikn3v8dp6?=
 =?us-ascii?Q?QIee54e62gGhMXoP1lmKCPmJviRDsEs/6v3iqxJH749wYaxeot4kFI6ZEk6n?=
 =?us-ascii?Q?G46avczyVfiZfZWABfq/C0dmaFQNCPJMJehSp0lMdLzgMy1zG3Bm6UUxFUSB?=
 =?us-ascii?Q?5OKBNLC8/gMCsA7/aBDfi1/xSjVisDvZh1legPiwcIdxwcfWQLiMQZAvksIg?=
 =?us-ascii?Q?D0Gx3e0KnayubZjGgUw1zI2B5Qvh4XP6MCia72aWq282PpbgAi2i3831DFU/?=
 =?us-ascii?Q?+iwcbf48G7R/ZKSg4kriq0UNpJ/g5S7ovilkmw9fGXUx2cVu6i8yptVTQBgp?=
 =?us-ascii?Q?DdlhP3MRyRbVylN2dGxN3LvM+JJR9rxvTulQWRb/OXL5SS67AszSdc6nYLED?=
 =?us-ascii?Q?VAtUGy+D4wNghD6s5mYE13u4Hpsq77y95Qs6wz7jYpjTxI2b7KAsw/eT0DXY?=
 =?us-ascii?Q?lccIxuRsKfVgbx9ezEK4q4QEbFVSSKtRFBhGhYuP58WcC+DDeyDvTghRzJSW?=
 =?us-ascii?Q?hGENdk6BbSDx8bWgkjNQrpP3bTnN0y21fqLS8FnfyDAE5/+qaB1JkREZCM1e?=
 =?us-ascii?Q?mIcyvFSJCiNJ1mOOjuYaVBOeUh5gcEk4TgI77Ji1jtWYiJouubSo3y3HVg86?=
 =?us-ascii?Q?NUDcveZGNsQmKnunVnFsq7DEAC7d5mOiv5pJafFXryh3r+iJm8AQz8/0gC9w?=
 =?us-ascii?Q?85B/167MfX68I1NBifD/YtegYqtTy1GQcosucZNEHAXjcSl4u9cAEv9BGL8v?=
 =?us-ascii?Q?WFT6Ub9Q5WBJBZ83zcxiT96zqcpetAWFR3SIUzG00UtdV5a/XFLaH+gCoWTx?=
 =?us-ascii?Q?OzUQRIeMvxqhCkwvtzgpLfgZAThWczTTwAf6jROG6yUXpnd3Z7YlU4EpR9MC?=
 =?us-ascii?Q?qw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pkgeC1yfgVYSifpQTI+0lxAyeOpDj7+53FeGzBhlKRhMIFZ0XH6iIvbl7yVT7+biaMa/kl87IDZzCA+1EpF9lrQ+QPmETLNuOjlsKrpRhNOnuRulEHXa4w/1LWuwS4nu+qHArplzTkHBtPOaz1qtWbIb6MbtAL6gZEyOTZ6lPSfDH7JY7dRTFYurq7lEgHUj3rPIH6aswjE7/GBcg2QucIWSD8X5+vykkIRClD9LevRW0Tgi5Z5hxS5Y30tCdoAHJKtR41r4ct0qa0EyPGNPh7SImrOPpy7+DyoI+W4QpLoKxAjzC68S1811HgqYSmtTYZK5mhKba8YYXXerZSu1tJpcSUe536laDR5NK8UzMky6kCDZ3Nqr602gVwpXDl6jLGCIEgAwdZXDL8Ie0yYBndgLlffhrms6ad1IIRXzU08mTKkqIlwdBBSaIneULcniq4U6ANEYCqPIpk7fWOV7lD8DgZylC5EjINJy3qglW3UWrjtn1BT3o5uQVgsPiW8RSP0cmchN4vWwcdKjWBl3jNeydClG6zH2boDSK/BKCnmWPFu1VGv0FjSSCL7DEX6WQWSqz6XnlHBVJ5Bj4rx+mu722HfVZrKzc2kShzC1Qtw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54939de3-947d-48da-418c-08dcceb888d9
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2024 21:11:54.6361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c4F72VvpteOAiuhpI/7ld8dRUcq7bAtjafe2xSL/eo2ENwEAA6Mvnbqc4lcO9LLJLbMhR3vv04rKFMETzbe0kQ0dZRuo5jchBzzi8fcBERE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6765
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_06,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409060157
X-Proofpoint-GUID: QlmH68SvBIhR59dFHQA_eSJSlyeOaPLZ
X-Proofpoint-ORIG-GUID: QlmH68SvBIhR59dFHQA_eSJSlyeOaPLZ

From: "Darrick J. Wong" <djwong@kernel.org>

commit ad206ae50eca62836c5460ab5bbf2a6c59a268e7 upstream.

Check that the number of recovered log iovecs is what is expected for
the xattri opcode is expecting.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_attr_item.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index ebf656aaf301..064cb4fe5df4 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -719,6 +719,7 @@ xlog_recover_attri_commit_pass2(
 	const void			*attr_value = NULL;
 	const void			*attr_name;
 	size_t				len;
+	unsigned int			op;
 
 	attri_formatp = item->ri_buf[0].i_addr;
 	attr_name = item->ri_buf[1].i_addr;
@@ -737,6 +738,32 @@ xlog_recover_attri_commit_pass2(
 		return -EFSCORRUPTED;
 	}
 
+	/* Check the number of log iovecs makes sense for the op code. */
+	op = attri_formatp->alfi_op_flags & XFS_ATTRI_OP_FLAGS_TYPE_MASK;
+	switch (op) {
+	case XFS_ATTRI_OP_FLAGS_SET:
+	case XFS_ATTRI_OP_FLAGS_REPLACE:
+		/* Log item, attr name, attr value */
+		if (item->ri_total != 3) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					     attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+		break;
+	case XFS_ATTRI_OP_FLAGS_REMOVE:
+		/* Log item, attr name */
+		if (item->ri_total != 2) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					     attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+		break;
+	default:
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				     attri_formatp, len);
+		return -EFSCORRUPTED;
+	}
+
 	/* Validate the attr name */
 	if (item->ri_buf[1].i_len !=
 			xlog_calc_iovec_len(attri_formatp->alfi_name_len)) {
-- 
2.39.3

