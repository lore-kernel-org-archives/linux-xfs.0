Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F176191484;
	Mon,  2 Jun 2025 19:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748892156; cv=fail; b=Rrb+h8z13xNph5m3n1UJ95f3NS4rO+pQmGM4tfqiP+ibgUnvl/Bl3GDJKNjVRSMZHdPxcnJYpwxuKcSuqSplUDAYznHLzU4Vya/lAJIZUx6a7RXMm6j8dHwgL/jFCX2YgEWpSN6lZ7VYU03qWfOhvtQOgKdE4pAG2PC87GbI6Es=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748892156; c=relaxed/simple;
	bh=p6Gd50J16Vuxt5ntFvH4Jfrs59v8xp0qwSDNjPXCK2E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KUdFoVqCtrjsPwJIWATret2vK64XCQKPZ6R+hOVx69eNsdf02nrxiInIgC2bnTpv2DAbpxj+eaCMAYUZ114UUDkjRX4FqmoelgYrdc0xB4+z2UZV3xbqKHBKT+ckVB+5c9GceDx1Nva9OoT28M9gF1tj+DRKh+xSRnyK3O3nomA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Zv62URoI; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Q88o+SCt; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Zv62URoI";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Q88o+SCt"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 552HJJnl018235;
	Mon, 2 Jun 2025 19:22:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=UERYa4Vf62871WTkZ8qWryaVYPTrfQ8jsyUsiKKUuRk=; b=
	Zv62URoIlwBgIaPPZReWXjQZHaNWFsrCTQZSww5GGeFBt5abMtTQ/2D8vZe1Mvpe
	18Kdx2Ty+N9c1JbtPUdp5/9hHu79lNunJICxJvH7IbYoYPmbTnYSQT8Gn3lWD/+u
	QaKAhN/SIjoZVI9zKlSn7Juwi2u8GiP5V2G5mDstpWdZidim4z/17cjSP65BGUF0
	z++mkN5ZVLqrZD8KwyjurpYi5plAIvQR7nnQYEfoQf5znW9scyDRJYu+Ermwm32P
	Q7+aluUfSIbL6pnq3d60iuYjCdONDATw+uNRUVgk3b+gNsM25nsDsLt7QKtnmpjt
	p9SiBfc00sL2FFAhWEh/0w==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 471g8j07u4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Jun 2025 19:22:29 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 552J7rlu030739;
	Mon, 2 Jun 2025 19:22:28 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012011.outbound.protection.outlook.com [40.93.195.11])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46yr78d04w-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Jun 2025 19:22:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fNasdTB0Bb7QkkYcAviMBkWrcudB8H+MFZieA2xfFse+leNJkLIHS1OTBz4upkZVpc4Dz5NPzRdkR+fFvkB68yqxv2Ipg4IAfvvbtLORbEi2O7zomef0yxNSdePwInBcT6xaLc5X2BUhR4VpwV2qsACrki/lYrhPpTpkhPJ90n4k/OC7IvGprKajldfVJoXBVuJVAzEmXXH8jYND68aEigpnDWPTBTISf+PMPGt3v8HX8hiD4PTdzrT7cvz2b8CvGORD1y1CGd60retLF27Wb6obaDY9GNWP3+nGoFWJN+Iqv6r1Ci1jjR8BClH4zYTNMTJLDvXLvI2NkAHTbna7IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UERYa4Vf62871WTkZ8qWryaVYPTrfQ8jsyUsiKKUuRk=;
 b=SokmMBxqFTvQuw6CFSDf0PxMYpYZ4aJF6uZ19+toF0lC645HsqOtD+jAqVfGXYOl68UWWzsJcgoZqhu+gIT7d+IpupfODRwiq0rlPlp68C0S1RPMBfxq5rNHSrv8c13CANrOE/JteBMBgaz2jtWubVYVKsHfYsEOG58RONfWb1ux4rXNUyFs+fMrsucoSbXCToF2bvNvQbdW0qBz8SLNCM2YfG1JkvrbphCKxHjTaP45yvMm5DnxESOOhVmG/z/AiiLuVUfr5if0QMYwYxY07V+reW6vr92m3F1UqQuGz7LD6tTSBXCWCJXhAim2wcVsUAKAdO8RzgQUj2TPNTap0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UERYa4Vf62871WTkZ8qWryaVYPTrfQ8jsyUsiKKUuRk=;
 b=Q88o+SCtNdiQmZTdtFa8jvEzaF2JEwHVeP0peVz+BjKGSuUKw+oECKe/i2QcU4xp3iXX6Xc+ex943ojRmQ4tLxVVVXlOrhRjMi7n4dpZXNocKv04/mVjVH1uVtpfNMr2RtldiRHtjpoZ0XYl+HDvKkXPXdSQJJz6CSuiOFPHMBU=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by IA0PR10MB7158.namprd10.prod.outlook.com (2603:10b6:208:403::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.41; Mon, 2 Jun
 2025 19:22:24 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8792.034; Mon, 2 Jun 2025
 19:22:23 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc: djwong@kernel.org, john.g.garry@oracle.com, ritesh.list@gmail.com,
        ojaswin@linux.ibm.com
Subject: [PATCH 4/5] common/atomicwrites: adjust a few more things
Date: Mon,  2 Jun 2025 12:22:13 -0700
Message-Id: <20250602192214.60090-5-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250602192214.60090-1-catherine.hoang@oracle.com>
References: <20250602192214.60090-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0002.namprd21.prod.outlook.com
 (2603:10b6:a03:114::12) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|IA0PR10MB7158:EE_
X-MS-Office365-Filtering-Correlation-Id: a3b05a63-e14d-4977-7a07-08dda20acd8d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9P0032+RJsaTTWy0yIyt5fWXowxlNTlhL4KoQEhSqOlAMyrq4vlUcX8zsK/K?=
 =?us-ascii?Q?fhmM6Ai6grdq8HohbWQkRaZQ7eb9smMhQCXY/zX1R1PFtvqvL5bTZfahEp2Y?=
 =?us-ascii?Q?xgtGpsZ5uk30TRVebXlr39+YjW2ASTFb0a7HHYyM74WJ2LJ03VvDGQUzi9AL?=
 =?us-ascii?Q?59UoPdvi9eUrgzWA92T7FH4385vXRPF03B9TOVc0nR/Ktr0m3PLL05uf54+7?=
 =?us-ascii?Q?5s+BdUAh7D7aE/uHxMHCGDAcd3xN0H5lsdOm28ADtPZ+gYC1vMCBRo5qyB+y?=
 =?us-ascii?Q?NLN3zcLkfk42V6WkD+ibhSWkiJNx8ed2bKGzx5++umAwFI6gxxCMFI53s4no?=
 =?us-ascii?Q?MVx5avzQHzjEsRmgUbYT4Jkvnyrf0TmF85rDJRgO3i/a6p5tK5n0aXMBpVOm?=
 =?us-ascii?Q?RYklfnWBoLbai1DjbHc2HiDi014s06X/pjCWfsmUgahMTCpkAVni5JNLxri3?=
 =?us-ascii?Q?iREOVeVhPITsXU64N9m/iV+7dcIuOAsYRur/FSpARheoP/sw5Fkndx1N917Q?=
 =?us-ascii?Q?cY3DECsw6dEfx0QTq5LXvrr8kWrLVaIObYXzi1S+iG7SmmGoU4rgDZ/nL8oh?=
 =?us-ascii?Q?B7r6SxhLtja5mgR9ZakPj2MJjeIWmChRXfofoPuq2L7ZRBWwhbJvTkglHLWk?=
 =?us-ascii?Q?gvyad6aDuCmlfyDY431mj5MiOEfYN1KQ08zBQL1pomg2QwHcUz0m3Hcg/gBT?=
 =?us-ascii?Q?LDEi/DmCfFDq1LywXziqemaCIQ3drZ047IjmVaWZDMxRbHoEFS+o/DGxFs7n?=
 =?us-ascii?Q?LQ8yaDyFPQeutaSXoC+aE+jSr9y6/MVMjugofU/iHc8olvEI4/xZVvvhPwcS?=
 =?us-ascii?Q?Jt9SxEOcI4g0UFAel2cbdnGEbREf40DVmb9FwjH5s4gF0CRx8w1tcK1uQFwd?=
 =?us-ascii?Q?4/+M5vO+wh8qqbdalimYYnoyW2nPKhDl6tJyRhzIMNrwQndGNvrrvDpa+WQu?=
 =?us-ascii?Q?ZBTtY0HTZnk2W6uVhjXkIZAmNmnXs+gNXK2olO1IpVobesIz1bfC3LN74HlZ?=
 =?us-ascii?Q?mMEjY/llf2BNR1z5pSVRyabtCthTU5IINBHtlhSV0rg8fRGbPze+TqZRlnFZ?=
 =?us-ascii?Q?33M4HhFdymZ9cY9fFoyts8POJfL14FLWtGfOcIFMZEW0ZFLiwj8YEXekNdqJ?=
 =?us-ascii?Q?AnIcbASXq2cE/GLXMmEP1LMkZwV50tru7Rq98KkYNcs63Gdg6BeVxhgdWfbU?=
 =?us-ascii?Q?jI9U7oHrEvAfVmRQypKZs7I+C82sh+DNlzT8gTWFkypzuAWBroQaLFNsfWmJ?=
 =?us-ascii?Q?TkU1CbP0tVpBCAttmmXTDyoMLPHnlP2oPpnfmk+rkEeq5qszK+Zr34Vd+JsR?=
 =?us-ascii?Q?pIuWGNxbKeu1ZPrYdMGHBLht0x2iE9Qx6pIQvqrCiZnfyyLMKQ/P+PrQmLSn?=
 =?us-ascii?Q?u00jbssm59GfDEv1uzb5VEZwJohdP6+teZEvs86LPc2ZdemJj9CHnmykDmo3?=
 =?us-ascii?Q?LcRX4OY4H8A=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Y1XuJf4hzEm2kodr5jRGKO/xdhdAIhKufezEVAQuYvDZdFoQ40WBQa+tjQ89?=
 =?us-ascii?Q?SWrlGiQiT5eKJge0sB4+xiDYoXsQCj58FoFd4H62wWj55Ml9MJrk7cdDMA7L?=
 =?us-ascii?Q?R83ihA625mm22M3z7YsgHzSPyJ0eFDc+bkkG6sc3ObxoMSpUK4nV1A2iiPq1?=
 =?us-ascii?Q?O5bZAIfyVcD7TTucCsq5OdTf9L/ruc8uyp4zMGJEIYQFHZ8uaH67wRsXwDcq?=
 =?us-ascii?Q?pf58Lij7p7cSl+DApSTRefJD0Ubl2ZaRcE+XEx9wYjPXvd5X72dovTtIQm8g?=
 =?us-ascii?Q?8XTMBVQZr/9Tf7mcjasvLPpq9Qenrqt8IFDjwNcqNK8R7lqb9tW75/7FKyJa?=
 =?us-ascii?Q?NJV2YV9IPU7u+cpgMfEvi9r+Mdh4T62SvUz6O8+DynVV3/pIC/NP8RPb0Fq1?=
 =?us-ascii?Q?IhRaPQ4MXJx+qpekiUYNXd94VQMkYRf5LsHVP43ytXvpslSZV8rmYd1ILUGA?=
 =?us-ascii?Q?ww1gxjOzo0Why6qJomZoTMh1UkQN7fo/POZBO1j7/mseRjrHR6U5OKGx15En?=
 =?us-ascii?Q?atmgiee5CaxTTQeHGWo7AkRvCfLrqJeP5LIgvplF+d6ykQvlcmAhR1Py0+rB?=
 =?us-ascii?Q?BAx4ro91QeZ/7PnSkGJTPgHCe2vh+ljbc9Gg3I3/a0KEjHEBYPbJzGKyeKre?=
 =?us-ascii?Q?gUUL9g5M/8FcIzy8QL2hZe1WRTAeuDKWK2bNuqFNQxETKnI+9HCw0B761wRk?=
 =?us-ascii?Q?fZnjufal9Qfeuo03BZX/DBlH5jHaijx7zuqD9Y57TfcS99VDGcbUhvXU/mzh?=
 =?us-ascii?Q?Ze5wm+jEUl1lXl3Bd0myeE1UYJMZ/v5KuMwLEznd+RQIu9xKWyXEweDECaa8?=
 =?us-ascii?Q?KJ6X+uwimhq5h9N9ZzDihjsV6tI/Uu/PfUTrtvZ3UGe/kT6hdVYhXwUcJOoo?=
 =?us-ascii?Q?5hbwwI5v7eq8Fa4PGLyAbnOqF0poBWhy69IPQ8Y1lAcvugOjaRhL2YdyDON7?=
 =?us-ascii?Q?r8V+cSofvS3u+dUSiGJTLKUivCwLj8F6v7xW/bsb85rctPoWuylIKcCVprQU?=
 =?us-ascii?Q?lz9c9PUAQmaGA6oMxkZl69QOH6rfXrporIoEnPZLgKR2SqqeMFhh2ZVgiOjm?=
 =?us-ascii?Q?KvvFH64jUoNgWqOVqO0fEER3cMRZApe8rlPrszQo+xhv4WrIlL/ztGac4xaK?=
 =?us-ascii?Q?HdhgU6Zek/HQ8KDlSjHYWFsAZ4z6zQqqdUS7wbWYd70GxHB39LMhv4qQKj3+?=
 =?us-ascii?Q?Bb1vcPHdFD2Kgbd0c86xQdKuvCz2CXA48db97CNLeGLwbtLkd4XYfG8c37AK?=
 =?us-ascii?Q?kD6MW+jvnancLYddjbEExE7oXAocJxSBQTUQN/3hCj7eJ76jMJPYp7ahEXQM?=
 =?us-ascii?Q?udki9MFHLmNpdqJQf58ruTiWjBFvfTFhIkMztikoVH9QfLudCVAjgLseLkF9?=
 =?us-ascii?Q?CdHN7eIu0Lcj1lWXZfRbgD5u1eH4YW+R34dujOmkhP+tJdtJTJorUDUQToyH?=
 =?us-ascii?Q?5xkkirXF5+xmPOHh3Yuf1XbmRT+GWTnyqA5MsOHnX9ui7zgWw6syFT4uGPw6?=
 =?us-ascii?Q?VNM6zoN+EODtEyAfyvA1tghtsjuohso5Lv2qkjf4r/SyWEcxdkcV6LgOu7s3?=
 =?us-ascii?Q?tI56EubEcSGniwxqE81SYKmOn5CsU8hlTDM9+3Nuim9xbUgyDkNBQFEjvxjO?=
 =?us-ascii?Q?itV9ARy3DHU1lWKlRjrc6Lv8QWtfalU198N3dSzOKqjfPasbk/L/A8pEOnmf?=
 =?us-ascii?Q?8jmHkw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	THzlvKmqMbYfMHaOciI2svsFF+QDi6lLMgaX7AvIBWN2Yqta03bk9Dn2OvFe/m7/4MS1YYfyxd5JHcasrnT6LUujtwd0F4Rf5b44+kHjqWHAK2edry0vwEDlu0r+wiDELDrAN91fQzZvZs11PGZFRmZI4lVYC/0DqWXDVWgImCCOVFKGLRxPdcoYjuHVLz3eWfC5hY42vfEpROJyINhzTRDmSN9t+RVNhzcsWfl0kMREl7v+biteCndjzD8kIehdPu8vlB5Zu9uhyjdJsgbNuMqe+CXPxtJDmm3RWyp7uEhUqI5u0GtbK12+aNxDokYD7Ob63mMpSJ/vR5MuwbX6cQlVNsnSTGP2dnxYj31jLYmlduuBCg03Ud3/G0m2jrKYLLWHo0aY2H/fZ7KpTxkiEuKEschcKHNi7IEtUCPX/JCJEVlBuCCgSmKWxNlOQ7v0iIAdnzk+b74q76JOKKXFbNeEpBBH0I3Cg95JTpD0awY3W4aklvmw7F5nJoxqWeSCjqLx0BNlCOXz7TzMmd4Q40n5Lcpq3yTTt/CYVQB5rfH7dhKnbKRARcScpvquB2gNMooQdDLR3IAJW698n+bfHuj0wwVnwlND1WZMFvsGmPs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3b05a63-e14d-4977-7a07-08dda20acd8d
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2025 19:22:23.9610
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WyC7ftMk4hVxFFcp8Svjs8wbPmd0LGXabGqpx2p+ICplJlWQON0Ko0ROvtHetU5ic9lw/m4UiHk0HWMsTFxg6E1OS59XuM1yZ4gbjXxgb3s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7158
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-02_07,2025-06-02_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 phishscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506020159
X-Proofpoint-GUID: _hvKea-amusvL6FSU2Ms3Okb7-I8c3QG
X-Proofpoint-ORIG-GUID: _hvKea-amusvL6FSU2Ms3Okb7-I8c3QG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjAyMDE1OSBTYWx0ZWRfX/+fBo149asLb YAz6j3SzJcZivZx/FB5aFd8/tTuW/Rsbr4b9hduO6LeMRvz/saDg1I/495SosFLzvOQIUxeU4Ki 8LkAQboAateoE5PoEz6dtifGKW6EnrefxadKBiOxcNLyyH+dr2nwEEJE37se+7j1mYTDVKHZWhp
 1OSYcOEk0aRT6wxlfB3vuMA0NMPy12fKrOS2yi/CNXA0yf5y/UUXdxsuD6bG9ANUzqOGdzL+o2B 6JBAtiOkC1qXmrtuDsd9haN6SYQ/9YeD+Fx4llgVVNL1UvEN7fCDw0u1HbfDwOdGstRAx5h3Rsc UU3FU/5wYxy8+zFTMXZqi5tB2oQUAFURlefNgeVJcApxtOcD42mnRBs2Vl4kvwlVCi1NRCBT3X4
 nGrTAP1bhQOU3V4pe2h5Xw/6+9CgrgVpAaTHxhZ7r151w0jezzSAzcm6CkRY8ziF9NKIRPvF
X-Authority-Analysis: v=2.4 cv=QI1oRhLL c=1 sm=1 tr=0 ts=683df9f5 b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8 a=-DNM3hN0B_qGNDMabmQA:9 cc=ntf awl=host:14714

From: "Darrick J. Wong" <djwong@kernel.org>

Always export STATX_WRITE_ATOMIC so anyone can use it, make the "cp
reflink" logic work for any filesystem, not just xfs, and create a
separate helper to check that the necessary xfs_io support is present.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 common/atomicwrites | 18 +++++++++++-------
 tests/generic/765   |  2 +-
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/common/atomicwrites b/common/atomicwrites
index fd3a9b71..9ec1ca68 100644
--- a/common/atomicwrites
+++ b/common/atomicwrites
@@ -4,6 +4,8 @@
 #
 # Routines for testing atomic writes.
 
+export STATX_WRITE_ATOMIC=0x10000
+
 _get_atomic_write_unit_min()
 {
 	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
@@ -26,8 +28,6 @@ _require_scratch_write_atomic()
 {
 	_require_scratch
 
-	export STATX_WRITE_ATOMIC=0x10000
-
 	awu_min_bdev=$(_get_atomic_write_unit_min $SCRATCH_DEV)
 	awu_max_bdev=$(_get_atomic_write_unit_max $SCRATCH_DEV)
 
@@ -51,6 +51,14 @@ _require_scratch_write_atomic()
 	fi
 }
 
+# Check for xfs_io commands required to run _test_atomic_file_writes
+_require_atomic_write_test_commands()
+{
+	_require_xfs_io_command "falloc"
+	_require_xfs_io_command "fpunch"
+	_require_xfs_io_command pwrite -A
+}
+
 _test_atomic_file_writes()
 {
     local bsize="$1"
@@ -64,11 +72,7 @@ _test_atomic_file_writes()
     test $bytes_written -eq $bsize || echo "atomic write len=$bsize failed"
 
     # Check that we can perform an atomic single-block cow write
-    if [ "$FSTYP" == "xfs" ]; then
-        testfile_cp=$SCRATCH_MNT/testfile_copy
-        if _xfs_has_feature $SCRATCH_MNT reflink; then
-            cp --reflink $testfile $testfile_cp
-        fi
+    if cp --reflink=always $testfile $testfile_cp 2>> $seqres.full; then
         bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile_cp | \
             grep wrote | awk -F'[/ ]' '{print $2}')
         test $bytes_written -eq $bsize || echo "atomic write on reflinked file failed"
diff --git a/tests/generic/765 b/tests/generic/765
index 09e9fa38..71604e5e 100755
--- a/tests/generic/765
+++ b/tests/generic/765
@@ -12,7 +12,7 @@ _begin_fstest auto quick rw atomicwrites
 . ./common/atomicwrites
 
 _require_scratch_write_atomic
-_require_xfs_io_command pwrite -A
+_require_atomic_write_test_commands
 
 get_supported_bsize()
 {
-- 
2.34.1

