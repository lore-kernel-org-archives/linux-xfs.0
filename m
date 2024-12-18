Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71C557083A
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734488075; cv=fail; b=YUpAlZerzpOuEVv6vXes6zf3e08yOuq4SQ0+MVhw5X1ZA0Qw0Sram9G67lxJSBtpISYTGyPF2afAt++UrIIMhTzI2HAzTR2n2/prQGyPBMJfIZrijgvpS4v/CXNglTnPapjOfoZ956rY4mUiUPH1q2RsAwG3xAVdJaUPInY5t6A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734488075; c=relaxed/simple;
	bh=ekeIErxRU2yYxwP5+JKtEz48TcXsQ4WD+LGplPm6V6I=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QdwsvR7AiM+tG1geulwG0148+JGnhDaeeDnaBHvN89bijDubV/oYt/wNNFBB6/PMyPYW46Nb45qeKgkxLHw4PZVe0qGnw7XtDnkWNBcqP4UvcUXpCp+hAmIpeTBGLZ37jjKX05L6NhELdv5GIgGK+HHBxqBvgscXJjxwDxdqUSs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ceTSpo5O; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Zig7L2gI; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ceTSpo5O";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Zig7L2gI"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BI2BrFB006233
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=t4Lqngq74UPI3uAHgeSo1LKgIBbZXDVIghmlhCliS0w=; b=
	ceTSpo5OMB+RhXWhEwNWNXhKa5DR9Qy2UXGUl9YjUkTlUSDWm2ScfP/W2ZwHo2C2
	2nbi/YUs/2PsHwFD0J8mivnZE1wc3nW9CZ3T/PzX8CvBr3FXG+IscCmZ7cmq/WUf
	6pyPBEfL2Y+H4HR5KrlJ7kCQTKki2tCJK4FNp/nn3/aiHGjUA6BC6s4I/brSXBlO
	J2oGo95SSP5+ZAH0lGSDVXUq8WGQyxnr9B+tr80j3HOUPwkTnHUqHC89NUdaTI1e
	wg7PP47b6A4xsIKKclgETxvYgiDfxgfJD6bygpYo0Z9omuuitBGgKjhplhPKx0GU
	+c+bKmUtVDR6LMPdujdhhg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43h0m07nta-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:32 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BI1V0UU018231
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:31 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43h0f9fbvr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ge9am21DNZ0vrILEFCRrT6Rh9HP5ILqr3O7xcozrdEDdKiKqAhXf6s+/mi5j4+jhGheKw+s472telsGBleOKyujpCPvQHoCWj3qhXkq/f8di/sZwuHjqMkCf6zsNbsyS98qWCWWfvjux47UvQDYEem2SVWNP0hEUc8eMZdXAjcBIAhzYBipt0ps1V4graenVQIq3ZuadBeu+ouljz6EaevwgAJOeoM1FpFRgOUbBaWwMfuOniwa7N+boEp+JyhS76RT7fLhRH7FtfIA7HHKMMM8IlpwFVEI106g86yMq2ZuEDF9+3/1jzdVSFkhSM3+hpzR2S9LJ6IxaFNd0KKQcJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t4Lqngq74UPI3uAHgeSo1LKgIBbZXDVIghmlhCliS0w=;
 b=O2srfLFu7sKClzg+9uU5CLxRobu3EKByfPccN+Rqwsxm/u6D80o+4rFbXzdfveHhDlctZjygjFpM+3bG5HnWQntPPQv5e5sBrRvHfZBoVNvtyRDCZapCy2D8MBazasTUaj3Fn30DsXdbisEAT0NYsb30gm7RWRN58lk3ZmOdqFFGoQRH7nycbjrwzWiLL/40j4AKkoSx4qSSHUuMtErZvZh9x1p/3x385HJWhS7FqxWjw9DQXA7wE0wPZfHQWw0Xj7ObkaMpDrl2PwZthzE1dTGPgS3OktLiuEfMLLkfeAMLhbVGA7e3pVZY5nqGoMsspJuC5X78du3SG7hLFb4uiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t4Lqngq74UPI3uAHgeSo1LKgIBbZXDVIghmlhCliS0w=;
 b=Zig7L2gINzitzMdAblKROPF5ggK/YwEWC2rXsaPbX0Q9DmZvrdz1Ab6Whqa3UELZiy/YJvKO/fOELGjUlmM03EFN0OinD/IeiQ7Mo6gmvA1Jmb2sxYCV6hf4ZgNnXboF6iO6VEEBrUbuMROLIDaTT1YyEXqHAg/rDh0jNbpSS60=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH0PR10MB6959.namprd10.prod.outlook.com (2603:10b6:510:28f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.21; Wed, 18 Dec
 2024 02:14:29 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8272.005; Wed, 18 Dec 2024
 02:14:29 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 09/18] xfs: convert comma to semicolon
Date: Tue, 17 Dec 2024 18:14:02 -0800
Message-Id: <20241218021411.42144-10-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241218021411.42144-1-catherine.hoang@oracle.com>
References: <20241218021411.42144-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR16CA0006.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::19) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|PH0PR10MB6959:EE_
X-MS-Office365-Filtering-Correlation-Id: 99ad9623-ba87-4f17-dc60-08dd1f09b429
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|10070799003|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TE+9P+vs+GhDapZEwBVJIPlkoZLnJg72WlgoHU5fGhSPTCe2wzA+xIV0dD7D?=
 =?us-ascii?Q?r4V3Bj4SEZtF6aJUGeuunqCzuZJ2JyWAGm6FGjoAjhsmX4CDyoByfI0psIW/?=
 =?us-ascii?Q?pzpy3+CgLr/4BFS4ws224V1Bg5v3kviegZDRzB5eSfIuwTjp/hBzxh4k61U3?=
 =?us-ascii?Q?twmyIaESh1TLRMbzByz+UTVC/LYCm/BF2fJ1fJgX49mc8Yxwp4mgcl2injPh?=
 =?us-ascii?Q?KxfjrwfAlfahFobibis/dS86oNG/ZPpLxyLEL/awFOFU5VkLoWL3bMU7h0n0?=
 =?us-ascii?Q?F7Am8wMvxcIEaPlAyIK86e7jBos384HmhtCzVaUvHUhrAdnq5+q3VpksVjBk?=
 =?us-ascii?Q?WLzpIGEdP7ojkaZkqDRVcaq0Hk76aU/KPsTwpC/6ddIuipYDVjC9sPHD/vAU?=
 =?us-ascii?Q?bo+MnL4G8dyC8kMyhswQMcqCouuoUEusGAWn19X6wWFMylievZ4PpydwQwW7?=
 =?us-ascii?Q?DSYTpHK0Pa0F+0gKWbmTJY7sxKRvhSzUPEwjvGDkViYhLXyOpAqCybIaBx0o?=
 =?us-ascii?Q?VbSy9+i2oMCae2x3r3+/gS43Vn8YseF/9bBT/R+uWAFsaWI3jJK/HsakZlz0?=
 =?us-ascii?Q?Oavl9NXWXfhl1Xy5B7/san8yANilI9QButQYvRRJk/QYuUDWS6I6G4oyKcfA?=
 =?us-ascii?Q?ET6V2borEnzWCglYS+cHxOzaVMmHzoQr81jw3D/OD1z664G7HBmXTQi/H44S?=
 =?us-ascii?Q?4B41OfaPHBd9nMEGUz2+uy4UCYf1+46VqJFRGLr/0ngzK6H6q5pucfT8oOrL?=
 =?us-ascii?Q?yupgBOgVdaN/gOyh7nGgHTdn2cB27KukwM59A9WynUtd8r4bfivGHYS+mbBB?=
 =?us-ascii?Q?K5BCs6/FKl8PpN1/WcqdALnvpQUDk1sXcGUrhH8R7Z/im/c0x64cxnPOJ8qu?=
 =?us-ascii?Q?AKWNPQa3bLQlS5iLZ/a1yOqQ5vjrI1RUxGI+ArS7faoif6VVCX1f9w61jP0D?=
 =?us-ascii?Q?Xla2RwPH6nZhix+jbKRUIFk1XYnop+AI3rngj+0Gj7rb5aJir+B02apA8cwO?=
 =?us-ascii?Q?Rqz66/V9V4ySYROfw5IC/lWDApAproy5ySpl3OqvRgwSDy0WnT0Io8oeZFnT?=
 =?us-ascii?Q?CO4A71FgxLoxBz0OL+vGUG7pV0NGBf2BcZV7ZI9fY26MUSwGqG+sRfJhOJY4?=
 =?us-ascii?Q?PA+BTnQNA2947Y/tB8TA7wJ6CNlRzBt7XTjsKLS8zRG9p+fOqeAgJbAofZ4+?=
 =?us-ascii?Q?Xx/yE4hZ4f7ZTQjmgW7O4XH8GfiKbIBvCgdj8WsAGmxmECuWyRGT0oXfmQFB?=
 =?us-ascii?Q?7/9s/ly9nhQh4XAdbZFQBXZP1vpt4fdiIb7susz5v3msMR6nEsX6DVd+eqCt?=
 =?us-ascii?Q?madMha+R2+gvhXdXQ2yRoHhpYwcLpFO+kr4jWC+6I2nJsHVfQkrhFx+ATATw?=
 =?us-ascii?Q?3BpA4cXgfOqTAVRE47Xf1n7jgqPe?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2HVEie/vlwLhdORTc5ZNqZHoqwduxqOwocuHFpIxaDqHUMt81Bh2or6xTooi?=
 =?us-ascii?Q?3ND76lcEEf1iOpXv6rfr33WfKdfqjnp8Tzj+AwqU0svpTbCbS0WOf+1TucHB?=
 =?us-ascii?Q?iWDMhR8s0fcb+U0/k9obHloL71gM20s8ZHpnoOi40BRJkiUYi+NudS3z3gsm?=
 =?us-ascii?Q?rJpUOk7jddXV1rupRkAMKQsiwwhrKOoWRyQoh7GGZ3dRIXGOr4Qqf8Ai5i2M?=
 =?us-ascii?Q?1DJAC5fY6f2VCHKNL7cacTeHVqXBJO/3/O3ri1l1WKRrGK9eayBDitBllEj9?=
 =?us-ascii?Q?bLxHsJMt7M6dUw8EXTKpHAO0ui1TFoMjkbjsmoHdX1luFkRst/KxRO9PPXx4?=
 =?us-ascii?Q?DyDoURR6tgQ/ZOJX1TfmfaJef/TzdLrO9SoNwYkQt5BvQNqAqjMbhcENdlym?=
 =?us-ascii?Q?dt+Cpda/Fbku5JJ144EmABI01Upba6opT+sRhOPaQk+BpcCxq+lf0Xx1zjih?=
 =?us-ascii?Q?oL40g8ojynTDted64WOza+PRdJWOjG2DTpKhhO/zt1HITME1paLWo4lVmVuA?=
 =?us-ascii?Q?6+74E9tbeCjcu3EEl2K67hZaAT3gKY52kYAy5IVtTFEXGp4ccTGvFNfZMvaR?=
 =?us-ascii?Q?tqwvNmVYaTqMG9VY3Mr6y0CMdhbKKoHmMlDKguzktqPWzD8Ogs/bV0KRltMh?=
 =?us-ascii?Q?8F3/XFpXRsXcp3c++bI4r6UtV1qLX4Odr7DhzA4P+PBJ306jn+74CYksorlV?=
 =?us-ascii?Q?lbwnSx7vr6Ne8pbZ5suy8vN/BaFHF0kW2MDXySdjruRPVE92X+E4y0ojSNcu?=
 =?us-ascii?Q?wi1JePDhzjeCoKkVuCzwsdg2Fq37zv5U86RPBQLzmKOLDLGAz5KC1sMHoGBS?=
 =?us-ascii?Q?6HTXUBEaDEvz2JqWsT54f5ICE/syaO8Aj6LaBsOPM7skBTMaR7rKsVZn31MV?=
 =?us-ascii?Q?aGEgEJijQgqV+dWMDiW7Wotekx+WoeprN1LvhqVf3Jqp7abgyjhE9VKIjVZl?=
 =?us-ascii?Q?wwBZru/v4gvzHhmx4smlYctowJAlz8xkxBG4xcPpHbcJHOWdwsoluOk6HGst?=
 =?us-ascii?Q?OtM6GFrgh5KTtf32V6Vj+3Wv6wL4zlH9Gq6XILB4Pdbh2M8Zg0gi4zhwPujO?=
 =?us-ascii?Q?GGcpa/jGO5WxR2709FJ1mGhfuZnzop4pmIvP0HZzZqmOdV0eW24HlsCCWKzh?=
 =?us-ascii?Q?+34J3qeMw8IRsNeSqWEIWdeXdvP2+GpC/L6SQWdRlJiNAH7V+4NQfnBEmZ1r?=
 =?us-ascii?Q?iAhlA4olbKKvGhWGmq1Si5TJOTHlnnHMSfYNm1UNNOCdwgiSD+5GpnfgriBs?=
 =?us-ascii?Q?J1F0Ow2j7YBfd8Bdmbbsk8N4d9JuIyRWALsXBhs3IqKWjiw3kogd8jYIWJkA?=
 =?us-ascii?Q?T0ty4A/yUIDkCla4HUUHQ1udvx13yQQKZ2gP7q+V8ukXsprtoF4tFBJU2xfA?=
 =?us-ascii?Q?FoFzHgc7Qr+UQBVnTs7iw8H3K21K2Fd9ix8IxZn5oU1cN+LnNNdt1VWG9Oak?=
 =?us-ascii?Q?rHTAaeHohY/lEBUSyk+xEeJ03LvHiuHw3EL5BlWjfSynINV/WAyzx6dF3/kB?=
 =?us-ascii?Q?unDJXAhI2DqPFu8P8aqtKFdFC+jO6eJfKl29eBR9jPvUffj0r/mlSBZo/O+K?=
 =?us-ascii?Q?SmxWetS4Xi5GGbEX7JOn789qkTsIAAG2Dxjko3kNghu897N6qktK1fvGI0cB?=
 =?us-ascii?Q?Ip0n/+aFkjD5aDXts8els2aneNLgvRPbqDTpAnWFT1P9DndSigNqD/rtpckf?=
 =?us-ascii?Q?wTcxmA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	IZ4y1/ROp68pAvw+f8kUPY2mQG4GmUbnBUO0clOoy7Kt5KZNgLhObC1+cnTf2QDY39pqorDLRj7PK81izP5uM+/lIBVYStbsrq/D8W/7e6y9I9HetzZXKWoVeVAjkfYCJplm8FHZKK/tu27yuSpAAx6d3UT2SQ4IGdbizcKviNsWnf0CwkpppBbCP+Wpyd2ryErP0oR6Y3zG6+BnR+DICJmvdniU8ZL3N+BF3/HPtNFTpYjMpR4egjV3Ni/k+B5hLM9/8nmTbp/75sbk4Dym6CVQgc03X4efQxc3llkZYy3rfNu5sPwyzyWN8G6dj/TAWPky9zDY53Oym2xT01D3jozHAr831lZ3KeaPBxcvFJAikd/Fpg0caaeKtvu4n6443S2u9x+Iqjq69kNPMJVwi1HOrxcvlbrQb/pE+fD2eHlUbVwrQANPRbNQnK7l/ZqIhuhN0cfMmzrnTrDzPTr9iemtc7DyUBSA5ogqUEN2smX6TvCNw2lbDxZGBCFv3jNqfjBmlQLDPJvIUnyn7pAw7OLsM4Aniol/0pOOZ5SVpMzYUhGau1LScoUjlieWf/z39Rjt+XqNaUPleQMsOVEfI344bhUf0LM21wbX6pogtoc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99ad9623-ba87-4f17-dc60-08dd1f09b429
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2024 02:14:29.5015
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KT7Djg0Ib5R/pM7x/y4Ri/YsU16nosBD4mVeMUOI/f0pTuyaLNBMIoPcQWxZ0w9ewIdtI6m5IPnec+0VgyuB/97hvN/Ek1iEnkhlKYSKl9s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB6959
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-18_01,2024-12-17_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 malwarescore=0 spamscore=0 bulkscore=0 suspectscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2412180015
X-Proofpoint-GUID: CQg8FzQ6DaEwUlHubdUzu1KMAoT_Hd1m
X-Proofpoint-ORIG-GUID: CQg8FzQ6DaEwUlHubdUzu1KMAoT_Hd1m

From: Chen Ni <nichen@iscas.ac.cn>

commit 7bf888fa26e8f22bed4bc3965ab2a2953104ff96 upstream.

Replace a comma between expression statements by a semicolon.

Fixes: 178b48d588ea ("xfs: remove the for_each_xbitmap_ helpers")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/scrub/agheader_repair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 876a2f41b063..058b6c305224 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -705,7 +705,7 @@ xrep_agfl_init_header(
 	 * step.
 	 */
 	xagb_bitmap_init(&af.used_extents);
-	af.agfl_bno = xfs_buf_to_agfl_bno(agfl_bp),
+	af.agfl_bno = xfs_buf_to_agfl_bno(agfl_bp);
 	xagb_bitmap_walk(agfl_extents, xrep_agfl_fill, &af);
 	error = xagb_bitmap_disunion(agfl_extents, &af.used_extents);
 	if (error)
-- 
2.39.3

