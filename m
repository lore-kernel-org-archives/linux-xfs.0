Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F10C1191484;
	Mon,  2 Jun 2025 19:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748892150; cv=fail; b=WiJBTObXsG5/9Co+ZFKb1rGCPi8CnjKO8JvuAmJMcixk67PEpQEETD9pbIJfae6uOEgysJQgMHKbQgrBRjsmIRl92IRDKzhuH+59qnyNrfJ7gBE8Cn8B3xoQmk1s/nHqcZtS9wEANHRNKKUeszNpmtUUkiqNw58Meb87GS6PwXQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748892150; c=relaxed/simple;
	bh=K3oFUVgHmZUx0OYjC2IqmX5bP8ifG6JFExFWSLJ2bhU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KUy4fsCr06WJvwKe2KlrILYeU/XQj1tqIy/Or/Qvb4o/mb/zKuvySl+WtJkePs04/BQCcZpRl8yctuIY+LUVEXpOLb5FjUbqmSsSE8gr02V083Y0gjMaUh6tfDsi2Bl0yE+gkzZ/eyb6VuPHFKDXKDQAoJukdrptA7miO3h49a8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Sz/7clHz; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jAOpqLhc; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Sz/7clHz";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jAOpqLhc"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 552HNLaF029753;
	Mon, 2 Jun 2025 19:22:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Kpqn9zIJBBxZbksGaRNkJGvKEZ2GHK4zoC+gFgsqHvA=; b=
	Sz/7clHzLCvCPSvLR+nLcFZjswBDObmd6QnWiamXjRtaCzFr8D2/gR32WDr6vIAU
	8XzhPdLbBMGravZu7+hHLwYHeMjzDdDo4lVpxVMvHTNU/XuZU0feEiuloOVLlzAk
	ENSGj6UUhREGzgJxg5jSE6ngkKMiFYbCKwUyb5nOft0XPcleFdTNPBONx1caWV0v
	H6RQK0PpyYkcruRs/x3NvliDzNPGQpXSDHKi+EAS+bgcmJ0CDyOY5XwpIKYHWXcV
	btjuPOlaArsfX5rzS6Tw6F0VE2Hh9N4jIcXzuYS1cNDeGUnWAPVR+DVEgJ0Ih6nW
	d0735GDcVkHyLGV8/EA/6A==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 471gah87hk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Jun 2025 19:22:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 552Hb5oT034987;
	Mon, 2 Jun 2025 19:22:22 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012011.outbound.protection.outlook.com [40.107.200.11])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46yr78mn0n-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Jun 2025 19:22:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g5zFsj/6lQ5MGJI9sgrAXk66fJDYapuXXHHMi0+0k3Ny5+otC/ImItvE4+bvzNqm+3Ir/mSDx5YszRhqgvNJyDCAi+hOmH19RukXZ6eX6hn27dgUUZQrwDj/FrNeWsScxKKe4SG1sIhKtYyBHJRjY5wp+4FnUX9S3lmHEn4f5ElerXcR3bEAuq3YzAyUgPKIQxeSRAoxDBwwVKU6nNbvMxWb9HK/HC7iJttpjlytZ7n+gBdsLGgGSNb04l/p4FEm1+jci6QZcG1N+l46H75PxW0UnKLgGUJMhSpTENdXzXVBgASU2CT5DtNLN0eYlRohF4n2SMld7dNCt5JSz6O7Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kpqn9zIJBBxZbksGaRNkJGvKEZ2GHK4zoC+gFgsqHvA=;
 b=F7BalCkhCtor+2/qEZPsXEnop/qL+omayoUK0nWufEQsVONGTUx9BDZPq0zSORAQJXp9cnpq8GFqWAgEku199hlTKo8NI5DSWDN6ctXpVPgR6+9AMdVYlURsqZFm89V230ScqTgQsObkuox1YzEJupa2p4GTP/SEPL29VtrRMU+Ib1smPcw/UIZ/G3GsZsE9bFoJ92I8uU/Vr/lmww8SKXuZlDuXBduatm+um/FT/p9HsejIHS0W76n6AtUbXrxxy2ee+OLk4LX+J0ZjtSRPeiJfjoSgumEN4paQWXN3hTR0ddpt75O1EvZYWBQxEK0w6/kPIVRaI2oYWl221f4WEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kpqn9zIJBBxZbksGaRNkJGvKEZ2GHK4zoC+gFgsqHvA=;
 b=jAOpqLhcpULHHcpT00R+zRJXvKmqcX7pWY2WtFjqvbBxurUwb/B/aWXVN+wsDOqEgtknjsFZUlV3qCcjLB9Hv69bRCHpklnNS+Hd4IsAY4FEYD0GimkVW2vLun+2/3DeOyVYcmOKYGwT5tem2RQ78X4anRZqOP7z6pMd3m1aMI4=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by IA0PR10MB7158.namprd10.prod.outlook.com (2603:10b6:208:403::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.41; Mon, 2 Jun
 2025 19:22:20 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8792.034; Mon, 2 Jun 2025
 19:22:20 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc: djwong@kernel.org, john.g.garry@oracle.com, ritesh.list@gmail.com,
        ojaswin@linux.ibm.com
Subject: [PATCH 2/5] generic/765: adjust various things
Date: Mon,  2 Jun 2025 12:22:11 -0700
Message-Id: <20250602192214.60090-3-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250602192214.60090-1-catherine.hoang@oracle.com>
References: <20250602192214.60090-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0026.namprd21.prod.outlook.com
 (2603:10b6:a03:114::36) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|IA0PR10MB7158:EE_
X-MS-Office365-Filtering-Correlation-Id: bc22cf7f-384d-41b1-6020-08dda20acb4a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oNPsG6mk51qu7gTgqfaxVkpaTunybraHGwDrE3s+hzzlaSHE6XHiCWpMGSKC?=
 =?us-ascii?Q?wCofYft/+tAX+bcDoqIdF1zkFil1VXSmTVQnVEJX9YtGXN+7ZtoVRHrQ3g//?=
 =?us-ascii?Q?n9TzcUy4LCLAa4go+aEokEbrQxQ5AfU417fbvQbcaP3UgO9QEqFUDihE2+es?=
 =?us-ascii?Q?vyNIKPsSnWNuK+z/0fgoQzJZbmEJ95AKf3Un3o2jBUdt8vv5XY+OnauEUd9r?=
 =?us-ascii?Q?gBv9b2KSv9YyXp94BPq6atSiWjvERb1/Hq/nNZdUEnqsnaao1so+DxoIC4h3?=
 =?us-ascii?Q?HWg/c/mrA3N4x+CZNNel1B+bmD1uvo4WoSH3f72UMBhsZpVlopwfuSzd8euU?=
 =?us-ascii?Q?cmTeQEfJClfR85HkrWbEME4nD/G19ifH6rFVGFEUGJZbm53DNvSMGqbKxmpT?=
 =?us-ascii?Q?OeskNxJkdWdQk3xyviRSz5GQ3SJkrwzBNPFysaGDCgsEiqGFEhPH5/8FqfNf?=
 =?us-ascii?Q?VcFnzdr2jnDasPCe8jt+O+oG1+WQKeKhw6mj47koBy1uZAetWuimcUMxI0HR?=
 =?us-ascii?Q?5jxo2cUrMnxVwer2iL0AddnQGj6n4Cf8CQ7Ug1MPiHI6npp0M4A9CoZXpzTB?=
 =?us-ascii?Q?ImXW3Cg183hhi9nfT4wB/xViJYiihRwRXrzhbpycZrXofxigC0XCqsnM/jpS?=
 =?us-ascii?Q?obJZJlD18JPzWAsAmI8GcWAAoMc2AECY7X1YyysCMesvcbpZB5GWHkhXAqGh?=
 =?us-ascii?Q?0j+1Gf5H+qf1atdSi3xI9/8GfRH9ED1SPgVzfkhUghQis2FRvu3o+O7BPI5K?=
 =?us-ascii?Q?tFK7hc1vR2n4LjtNyyoccL/DI9pF8/99mEkCxI0GXPyjl9KL4C4Zc4a2Ht5h?=
 =?us-ascii?Q?JAopEAoAop32hJnwbLgkfTlgYrTSMh0Y01PEyZTRyQBWQmSaf0GDHecO7/zk?=
 =?us-ascii?Q?iRw31vaWfe9BAkd4kQVNqg36SADv2tR0PLlNdDvt+GolmfHsV28Z49TGJH5A?=
 =?us-ascii?Q?+RLigyh9Aq2eVtlfqA2Z9TDLHuX63UFaWykK48K+6EcWs2+e9/OI4KwpLH5R?=
 =?us-ascii?Q?P+U/sP3gA5Ya1ZytflvadTvsN1oGxUeI9NVmqQK9E4RHqeMbxrOe/pdov8Cf?=
 =?us-ascii?Q?erJJ1YSitQKiO5Y7rL926qAJNys1rNsFgAFDtzYYAX8fEbK5OAj2k+VzLbA5?=
 =?us-ascii?Q?jCK9HEFYMsJBVTuI8ccfTROhxInQB6UhX7I6dNaZX3qcfsnw0w73K4C8kpab?=
 =?us-ascii?Q?MYUXH+wdcZGXDn0u4MkTJhgKHe3gOldBeQ2hn/GCYY3tnd+67YNpmkLwa/jQ?=
 =?us-ascii?Q?Xftnp4bDfdGif68OJ/qRbztoJS/xAeApQkd5OEo5WZx1LiDQvGwrpFuYXaYt?=
 =?us-ascii?Q?b8uD2VoUFcSc3Y43aNhCFa5yc+/AM2wfMgj51xHJ/kHHOIHZywdmntjMllUb?=
 =?us-ascii?Q?qb8Z6/cCv6+QoIYMzZPXlZtMITFx6YrHG30gsr9UqO2p/ijz2YnmQDbRH1Ev?=
 =?us-ascii?Q?N73hlicOoKM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fIPo82xM1dfvAvaIYhaHdvztBZdz1uiMfTRVx9DrS3UINmM3UTrTxqVuRQbQ?=
 =?us-ascii?Q?2w919EbrPLjhY8hTbdYOef2WZlaGkIryqGG9JgcfwvKLFpwlrX1t+ekgpXSh?=
 =?us-ascii?Q?y/fMGuwyEqdd6njhYCm+RRJ/xbdIUsOgMTmk64rFRLszmTrTHGl3/aHANkH9?=
 =?us-ascii?Q?eGUXmWCf9oddO8fcEfsbmqNjuxo3VwO5JgBgc8axqNW/N4h+MMhE928QoCo1?=
 =?us-ascii?Q?EChKNW0BK+bqs4OPwkkjqACQ4KN9nI5bvrpL9T5gr+BPBIXebralfnQmdali?=
 =?us-ascii?Q?21w8o+lJgijyr/DoU1yELUXKkmumJSGHtSTaB795PTNab5aDqoXUGDw5Q0Ia?=
 =?us-ascii?Q?jrP4xVVNFJm8+HPJPQ77N7CdMy1pou8DzltebFwajVTzIkUypIFos4W8dX0O?=
 =?us-ascii?Q?Pq/CJG/sYASNUV8IwhYnm5nl87Zsqz2zjF7rXzg6nJfLsbB3hAsikM4uwFTj?=
 =?us-ascii?Q?bIGWokFm/TmEBKEWRgFLMwKzBxEY71BDzokdezI9AedhM/TXLBCy8KH/MOdS?=
 =?us-ascii?Q?qamd/Zjqv/s+iuFEDk3E63WseXzpkq0EL6QhQOOPyFVOJKA0w5Qu/BL5SefS?=
 =?us-ascii?Q?ZoCiU8dByZzSgj1ep+hL9kG35nLM2pKbAygM3cYYZMkxBcaxDIdEP0ZiR3xX?=
 =?us-ascii?Q?5U2oGfukIY0X8EcYyChU4NtKXZ9tvtNV9W0Ajvu9DU4/E2G7VVaB1GgNKyk5?=
 =?us-ascii?Q?uchluBsBowJ9XaViyhdmDo2XCQVSH0Qyf3Ah9eVcQDyIspnUEHulbW8RVv8G?=
 =?us-ascii?Q?XAs4w93yTpfGoM9hrnYvncAK7NYmwpN3SmYY3JMRg/fUEXPtX7pMbMvkEATL?=
 =?us-ascii?Q?HIdeBmYi+2WcL51P6k5BCoeU6yAE1ceFy09amyoWzeKGcPiwXWeuyIDDqxOH?=
 =?us-ascii?Q?XWBGVxn18s7o5cjWJjFuk5kuQSYumUHdF+AgvwWCkWkyPt5pdjiCyBQlwcRg?=
 =?us-ascii?Q?fnRkwf6pSsdgaMoeY4YEa2UmWqNbOVsXUQjkwFz2f2J9o6FZH8SHoTRoYQpc?=
 =?us-ascii?Q?iRILoC7roVYcFXy6t2/r6kf06kN0+IU2UgNjePAgkWc31tNQ2WRYzCVryJbn?=
 =?us-ascii?Q?LIgw+7u/0Z98wP8y2Rix9b9vWGqHvd+AKfrFrZZi7T11ol+d9p0ytWG0BeVb?=
 =?us-ascii?Q?pLM508jzIGWpEyJZo3YCEPCdrIBMQb1WRw0wMJ0kr4oeUmhjAPNpFEVgiZVJ?=
 =?us-ascii?Q?FAEsRnqafm2fHDuPepXJGuYjfjSHfG4HyE+fqDwKk2PeDl9ajcQ33tghekI7?=
 =?us-ascii?Q?Eq9ZPpHuN5D6m2yGk+s/6bcZL6tggTHvU1ejcDRMLaB+pwmAt7+80UXhveAo?=
 =?us-ascii?Q?DChmqniqrYeQCFRy4JOp4EjpWjynJMMOt3kegNVwfdE1Hwz9lANXEQSD/0Mp?=
 =?us-ascii?Q?GAHVMWBOcpWWgHYvVBrOOle2x7KEGH5q1/oxOYfl18dK7kCvGRZxODVQe7no?=
 =?us-ascii?Q?hkxyZlfK6k/qj6h+gI2+DeuzqI7c5iQP5FutryF9u6fEXlWVYUTAEuTU5lEQ?=
 =?us-ascii?Q?hBIMiJa+ZxG9iuoR2qecozeBkYLg0xXQR7pc9BZWuL+2BoDqvG7KNi7sz49V?=
 =?us-ascii?Q?fNpP7MaUGfPnciqbiztJATkUG26JRPjSLg68K6hH5T7cz8H3GcoMK2G4G5yF?=
 =?us-ascii?Q?gy+eBPsjnhXS04XLTB2IUzWEZUA81vL+96cZlYJn3KEx9LcXCURql78PRYBT?=
 =?us-ascii?Q?tyDhaQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RjwZdmLjqu3YXVNR6ve/3GjSwdGf2rTBBAGBnlGdiLNy1djZk2POkNCRqAXkCNXSJbSsZADYj9QDq2FskKAZybV3gOSx8LgPGmbBrH3qYvOwQW0f8ekyfsLdnqinuwCGRQ+/jZ8FnOOw2cotKiU0Jj+pGg+XmLVjNUJ9P3k+Gzz/3k4ZLZczZhE16WNDES+PTcAXLHh4c3HGAcU85I/fa2MKbT2KcPgjo3HMmFn/9IZyBeXtQ7Dr3GM66AuDQd6nj0QB1Sf53X/Imru+I2cpDQ4dvUsE37QNIle7ZpRRZWVc+annwGy2KQPfkaAGeu6sY0ygIqnKjoQIrSaCbX/yKAXwxu80PYjlEL708Ax0tLA3aLCZ6UlpkOS+IpoE/eVcGh9BUhBg2FScIbmyOMslnv+O3biVLW1zwLrgl/pINCRPe+TlCRX0mAmDSlOXsS+skrt0bjW422tdJhNfj5pAsVW3IRdNmrcRnGjZQzY7/4WEeufy7yqN6Y0DvfuANa7ijp2VLYEnfC2V3iHlxfN4uRn3is3xB96G5F4wZ7hI0Yo+jm/ji8RfhPg0lHBUmSzj41VrX4IlSKY+/JXZ4cjVEGAQPTPZoPXR6ifnr6VPaok=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc22cf7f-384d-41b1-6020-08dda20acb4a
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2025 19:22:20.2364
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: haJ5SP3BgdusUVmPIJpph8xToI6KOKc20+Pl2GofUameuoXncKmBHbIjzuZ7g9xLVtrDnn3ya0zrcHY2BWHj1jHGLl2LpIIkF6O17HG3x3M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7158
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-02_07,2025-06-02_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506020159
X-Authority-Analysis: v=2.4 cv=aqqyCTZV c=1 sm=1 tr=0 ts=683df9ef b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8 a=ZHJybXuDlUOdVKnBWFoA:9
X-Proofpoint-GUID: ulMfyk7SzR4H_HiizvKcJ1ibRVa2C4bO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjAyMDE1OCBTYWx0ZWRfXwJ8b3dJy5wRD S8posoeoFPbawyAt7RcBz1mnnUF9F1hMdxhllkgX5gTFLq/LyEI5614pZFoLepxRxnJKO7/GCeb yMLmvejFZFOMQ08mwtTOnbpqjD9hzPxCUEYCwoP6wgIoRO7nGImZIki++CVKJ1vBdRyPL3y+StK
 v23lDm1nGE1tcm/48icJc/pkkYXCk/EwsWDCSMu6eyt0fZirPb2SCdwx6BDoRoihdSG/yPjEj8L YrMP3K5Ebvn+JANi8qXvqUuO+e/UUkNp25QOhG1noMyPv63OLzd9nIDd6xEZXzampsx3CKRXmfC 48ML088QNl+2k/wu+eIUnhVpj8dgv1kXoU0U6tX/TTqNhjYZ+KVLWhqGLZAwS7MctHEJSKp8QOp
 Y9sAg+U3FMCKNWzIyBSHRDMrx1EiqNzBBEtZgGSmeZDLdT/lCUqTx8OlpQ1gQ9lUG7+Q0QvN
X-Proofpoint-ORIG-GUID: ulMfyk7SzR4H_HiizvKcJ1ibRVa2C4bO

From: "Darrick J. Wong" <djwong@kernel.org>

Fix some bugs when detecting the atomic write geometry, record what
atomic write geometry we're testing each time through the loop, and
create a group for atomic writes tests.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 common/rc           |  4 ++--
 doc/group-names.txt |  1 +
 tests/generic/765   | 25 ++++++++++++++++++++++++-
 3 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/common/rc b/common/rc
index d34763ff..f7d38894 100644
--- a/common/rc
+++ b/common/rc
@@ -5452,13 +5452,13 @@ _get_atomic_write_unit_min()
 _get_atomic_write_unit_max()
 {
 	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
-        grep atomic_write_unit_max | grep -o '[0-9]\+'
+        grep -w atomic_write_unit_max | grep -o '[0-9]\+'
 }
 
 _get_atomic_write_segments_max()
 {
 	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
-        grep atomic_write_segments_max | grep -o '[0-9]\+'
+        grep -w atomic_write_segments_max | grep -o '[0-9]\+'
 }
 
 _require_scratch_write_atomic()
diff --git a/doc/group-names.txt b/doc/group-names.txt
index 58502131..10b49e50 100644
--- a/doc/group-names.txt
+++ b/doc/group-names.txt
@@ -12,6 +12,7 @@ acl			Access Control Lists
 admin			xfs_admin functionality
 aio			general libaio async io tests
 atime			file access time
+atomicwrites		RWF_ATOMIC testing
 attr			extended attributes
 attr2			xfs v2 extended aributes
 balance			btrfs tree rebalance
diff --git a/tests/generic/765 b/tests/generic/765
index 8695a306..84381730 100755
--- a/tests/generic/765
+++ b/tests/generic/765
@@ -7,7 +7,7 @@
 # Validate atomic write support
 #
 . ./common/preamble
-_begin_fstest auto quick rw
+_begin_fstest auto quick rw atomicwrites
 
 _require_scratch_write_atomic
 _require_xfs_io_command pwrite -A
@@ -34,6 +34,10 @@ get_supported_bsize()
         _notrun "$FSTYP does not support atomic writes"
         ;;
     esac
+
+    echo "fs config ------------" >> $seqres.full
+    echo "min_bsize $min_bsize" >> $seqres.full
+    echo "max_bsize $max_bsize" >> $seqres.full
 }
 
 get_mkfs_opts()
@@ -70,6 +74,11 @@ test_atomic_writes()
     file_max_write=$(_get_atomic_write_unit_max $testfile)
     file_max_segments=$(_get_atomic_write_segments_max $testfile)
 
+    echo "test $bsize --------------" >> $seqres.full
+    echo "file awu_min $file_min_write" >> $seqres.full
+    echo "file awu_max $file_max_write" >> $seqres.full
+    echo "file awu_segments $file_max_segments" >> $seqres.full
+
     # Check that atomic min/max = FS block size
     test $file_min_write -eq $bsize || \
         echo "atomic write min $file_min_write, should be fs block size $bsize"
@@ -145,6 +154,15 @@ test_atomic_write_bounds()
     testfile=$SCRATCH_MNT/testfile
     touch $testfile
 
+    file_min_write=$(_get_atomic_write_unit_min $testfile)
+    file_max_write=$(_get_atomic_write_unit_max $testfile)
+    file_max_segments=$(_get_atomic_write_segments_max $testfile)
+
+    echo "test awb $bsize --------------" >> $seqres.full
+    echo "file awu_min $file_min_write" >> $seqres.full
+    echo "file awu_max $file_max_write" >> $seqres.full
+    echo "file awu_segments $file_max_segments" >> $seqres.full
+
     $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile 2>> $seqres.full && \
         echo "atomic write should fail when bsize is out of bounds"
 
@@ -157,6 +175,11 @@ sys_max_write=$(cat "/sys/block/$(_short_dev $SCRATCH_DEV)/queue/atomic_write_un
 bdev_min_write=$(_get_atomic_write_unit_min $SCRATCH_DEV)
 bdev_max_write=$(_get_atomic_write_unit_max $SCRATCH_DEV)
 
+echo "sysfs awu_min $sys_min_write" >> $seqres.full
+echo "sysfs awu_min $sys_max_write" >> $seqres.full
+echo "bdev awu_min $bdev_min_write" >> $seqres.full
+echo "bdev awu_min $bdev_max_write" >> $seqres.full
+
 # Test that statx atomic values are the same as sysfs values
 if [ "$sys_min_write" -ne "$bdev_min_write" ]; then
     echo "bdev min write != sys min write"
-- 
2.34.1

