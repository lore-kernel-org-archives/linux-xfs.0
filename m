Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 589BA199E9D;
	Mon, 17 Jun 2024 23:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718665451; cv=fail; b=FredASxjERzhCNa4p+kOfKgxoTcYba7PiMrRA8J1Wp+MSUU0iJtNaLiglMexcxuzkTWzVDGrDRwSIfZmvSq8MOD8L5/FVbMegnQKxjiDjjCZvKhM/9ewpF+lhnzR/rz+lAf84++eOornwPpMMbXS0+YT3+eKdYjMB4LYlwxO81I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718665451; c=relaxed/simple;
	bh=d0HIIN7iVy7HE8eykv6zoTGaGbsgPsacrbMsPaMumFA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IqDQGPQy08zF+mtDwfxTj6XC7UWKQID+tbx9oxNB/16vDwlkoN35ML9P2Oq+2t+TDqzPhYj3+qEmaUbCkI2Bq0g9vZuEi5xEfK+DrFubR9kDc2PGurKzzbDjq/TzgwjFINYaLDf4yK8bNkZcpvBfxoHylOY4lZbdOlkOdFcFn6w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NiMLUIVz; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ib+tz6xk; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NiMLUIVz";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ib+tz6xk"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45HMXSrT006546;
	Mon, 17 Jun 2024 23:04:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=WpsAtZfHGLIJ4+cK8VnhETlFMJ+GolOU6LlQ8O69tNY=; b=
	NiMLUIVzFZJ2B9EO2mxDfZ7nuZnwp7RpQC9OvqrJzOi/xtX8z+vvNmSGVOsKXecU
	VNrtg/GsffXIIoCQMqfYef4x95ilsqc3Y/vC2vyLNISI6IT16XGd5PMOOsRHOMMq
	5Z7LbmaW+h1jiWRQsSlp/uNwURUEBLwgFDxI0LMBFmItISqw7LMEkTETGy27zH56
	4g/KD1e+L3JKtg1lI72ZRQ9FSf7mIAXNPGI9cEJrzelptilMVsy2aFS5ZZmYjvje
	3yMPPl83jvzZVC9f1SCf/x4ifs6MYEOgp2yFcV1nj8zO17E8w38vvLgMp8ZL8xpA
	QcuCSBx3NNf2gnBuYFTQBg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ys2js3r8t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Jun 2024 23:04:07 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45HM0QCB007268;
	Mon, 17 Jun 2024 23:04:07 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ytp8dmmmk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Jun 2024 23:04:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DX9PlMXbmAiMIRf9/sYfaeaz07oHEYJ8cuuDBMlhUCKFglWoYtI5MIJYfoaJPHpu7GpUuToOjpVS1CoxcOWBlBd+jcswOQ0XK5joFQE0cF8s+N4rhvuXNAxPn2GWvwLqiQyNvf0+xxfbJ3JUSJ52rxCh6AtHoibU/Wn2WSqTW9ejzpU/tYOAcyiK93Osx0ujeaXnnp1lmlVSpZ4SXyDO+NYQwI976G2dzVyw/grysQy3j/I2txgzOkGpbJ8GENxfxDVNqbpCN7X5E7jonJjXeb72mhR1vZFXNpmWwN4Nz1uVadLh3X4DlZ4mbPmnzppU3eZCaxMXpZ4+VAjxSCIL2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WpsAtZfHGLIJ4+cK8VnhETlFMJ+GolOU6LlQ8O69tNY=;
 b=Lm7Gw/ZImeQLFZkvN2nWBE59bOi6Ya9PnTSO37MJ0+qWZwklFIprJmD/ihKFHVuJwq1ULTi4u15e1TnyMVtkzaD7iJLgNVLBI5i/FTKcAXx+9u61nWWJFseSTIDGIYDucQ9LTC4wwRZ+aXxNJAs6MN8RcBM15nCC8YjBZB1viv2Y4G2m7l+HkAs3y55vmu2T+GPsakDtldsmDihDLnV9gduSIwU+GiUa1AkXrONRMyVfSbB/aSqfwVsmCvZPnb/0ofEz+J8EffroAI2JL5I3SrnGSz45I/gtlFGtw0glGn6yu6SZwQAW3hmF215IkrAo7rGg+zFVhz8lc8Xajml40w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WpsAtZfHGLIJ4+cK8VnhETlFMJ+GolOU6LlQ8O69tNY=;
 b=ib+tz6xkUo1QmW1db3FgAHsW+x56J9IKKdRxyaPln8zYyvonWkBQOjDqOMULCcLMVa7s2rQPLHGP/RApRJP2DArwSUfr7yMseykgExs7WyRo+9xCjZYzs1P9XZ9TaGCKhbjqfHZ4dXtNr2XAVyq5dx2aBD3aYsYtqYR7aL0UcAQ=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DS0PR10MB7398.namprd10.prod.outlook.com (2603:10b6:8:135::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.30; Mon, 17 Jun
 2024 23:04:05 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%5]) with mapi id 15.20.7677.030; Mon, 17 Jun 2024
 23:04:05 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 4/8] xfs: shrink failure needs to hold AGI buffer
Date: Mon, 17 Jun 2024 16:03:51 -0700
Message-Id: <20240617230355.77091-5-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20240617230355.77091-1-catherine.hoang@oracle.com>
References: <20240617230355.77091-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0359.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::34) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|DS0PR10MB7398:EE_
X-MS-Office365-Filtering-Correlation-Id: 7546c6bd-66a8-483e-8691-08dc8f21c952
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|366013|1800799021|376011;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?EbHwvtx8G4hgRTDiv6czH1UYOImLWo1QuyHEmF5Blj0ldDyXRuCByuqMPlOd?=
 =?us-ascii?Q?48uDCoGcPhvhxGqDGlskWpkjw00dJX99N1mDs+s8xLVSYfE6pBut+S9jNdyT?=
 =?us-ascii?Q?MTKWKXHuwTavVlo8qChTP1H1mQsBEOou045q8evICE2BeGiXmp1gGwIBkyhJ?=
 =?us-ascii?Q?tpC0Goykf3WyDGbgQnicu/toboMKLQYHV1PFchJW9jHkfT8qxCIqJg6wQsiK?=
 =?us-ascii?Q?sC7lXQZDqb37gI4OmHlDYxbz4LyTAfdms40eFtslc839ZN4KgOsz+LpLtY1R?=
 =?us-ascii?Q?hvwq1vtadVu0vDLg7/j2R14Im4IHhQn4Z7/9gMou1+CCkF2T/yGBzLlfpOxz?=
 =?us-ascii?Q?44c6h+ylIBSIZQ1RQ5ux1oZ26UyEVp5RjodyjIjmTtNC4O+2ZkoEMwsr7YWu?=
 =?us-ascii?Q?iMYicrQhrkAxM4McCBhzODcOB5zxtQlDHDHrc2QtE1tA0DUjkzU6AAtEHSBs?=
 =?us-ascii?Q?lKgXPzyJWZRSHBeKjwa8BZDy2hZf7vk6a4Fzo4S4bRAnT8y6tpuFChLckbEi?=
 =?us-ascii?Q?1Se5fIf3TXnZLE+aoRNBt67i/XDbb983TF72QyQILRqsvAf5CMzU759pRxOW?=
 =?us-ascii?Q?Sew39QggD3xJ4QSrkWhnv1mvM29JXmq9JxR8msY46tu+JIzh44b9ISmJtoY/?=
 =?us-ascii?Q?BXW5MgT9vrsEO1fxlbf8LnOUTx3HJ2peqNSwseETx2n2rlaT6pKBnN+Nopuj?=
 =?us-ascii?Q?PgCpb6o/jE96pPhOSkBsMGhMed6H22ba/8z09UguwggBTe+nTHEzaRj0V7R/?=
 =?us-ascii?Q?oLt0vQjPxMoRWXikUp3lAmqxwAhE22PQ816vQOC2i7YfkNoBQyKwELz9y3bQ?=
 =?us-ascii?Q?tJF9kr/Rnu1ltD9BSTqVGeea6Ai4mMgRZERLS68gR6XSLtUCTn1B1mkSmCzc?=
 =?us-ascii?Q?52szwZhiRxrFrhiffVgE006bS0EbJbhSHZFTDkEbt7smbrBCKQemPnr0WpX8?=
 =?us-ascii?Q?brlUILWvnTo+3ss9fTEkoxd7IEwNkYvBMY46nkE6+7T43ahyERshYEjU62ty?=
 =?us-ascii?Q?jeWf4G66oE8QcLjqcVvfTkTZxVuv9PSfnhJsaLTNKHdmIyoaJ1NVJMiMOdjW?=
 =?us-ascii?Q?hQR8ujEECJHGIh6V0d8UktojSZmNLXAroxwwL66wo+JMjpL8gsJtCFvTsKQ9?=
 =?us-ascii?Q?30CxMXLIuvtHMnvg0xL5Ag6p3jF/CgrfrI0XBUwceEVVEUBHO+eNkTK8nQn7?=
 =?us-ascii?Q?AxyG/9RgrYtfc0JM+gteM3dyvGapf0qLqM+jyDI5QSVs3vwcuws7kk4l2gZe?=
 =?us-ascii?Q?Mi/DlMVbRaLYiUYgWTCihrBgblkevu0wpdekEg7B4/7GhvWPIvN0P//v6FJF?=
 =?us-ascii?Q?wEZ1rJelO9w+nLZO/uiNsHfZ?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(1800799021)(376011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?4/UZKaGA5p2fJRNdRFr+QqXSZ8yXPTAKMtaS587Noe8+xMXrqyFZwonF+t/5?=
 =?us-ascii?Q?eENOpsk2emV3K1mBk0MUWKhcvgLj/9eh+3PwsbIb8MFR9lsO5ak1l7O/s4WA?=
 =?us-ascii?Q?AXUJ5yvMxMXQVSJT3bZ/Vdi7tYDUILUE5SRpcxRFqWecqVQjfQ49jfJakgd9?=
 =?us-ascii?Q?jsbf+R55N5brN+pweKsIoa+0d7OwS8s2Z9k6cKFSB60oYYq661KlRQiAk23L?=
 =?us-ascii?Q?hPLLjUfszLE1NbeYMKm7TdHUb2ZgXdkVNu9W/TcAHGakJG6CQADC08A+W5SV?=
 =?us-ascii?Q?5mW+j66Cx6VTOOfXDaHI0pW55M8k87RrFpkVj4mpXUsaMd5+C5q464htN+kp?=
 =?us-ascii?Q?4Lp0VlG2uev7EPJs2+k90KaVOkJJs7A/MeoRIZa3FDMUii7V6WOviVmbOWKs?=
 =?us-ascii?Q?YetCWOQ1yUa2IwRFGOKFjoyt44N1wxq2db5qIGJPSqX6cikSrdCb+H1jOJBq?=
 =?us-ascii?Q?xWqCuH4adD6ttErqxL9xoe+QDITj//oYOdHsmCWa+RteOpVquVPNZvt9zw6O?=
 =?us-ascii?Q?sdLAAZDoX/BFz+e5nOfjMXGGzr8liOKdOky5rqg2+vc5PgG88ZFAa2lk2+k3?=
 =?us-ascii?Q?B8sa/lMIKXwxcQBy6MtcrUTMaWI6e6jyGQTAtLLOb9xQtNnjdJICDn6R9hGU?=
 =?us-ascii?Q?PRJ9zOujTWFlVBsJlUS1XXdW054JnBJ/+eBJEY2viK0AsWh7RGxRgObkQQVj?=
 =?us-ascii?Q?2WZhBrc8Xsr6f/P456hrnj3HgevwkGRH4rXuKhEulmZ7VKyZ4GYsKGpnYU4Z?=
 =?us-ascii?Q?wR+cQbJVF+JStpbOqSSrBGcr6CYi/aj5wWRjd/rckUAi0uGFo0Ja8WD1inuM?=
 =?us-ascii?Q?2brQpOn9nZMw+1//BSuCNO7+B7hpNoRNY9uEb0WriFT6GigUId31vGmn8bN9?=
 =?us-ascii?Q?IwuZIhpojFnIJL1LCIq606om2zp1kMAViog1ftjJ9icQM60rUPI8EBzS0KCc?=
 =?us-ascii?Q?U0IW1G42nv0wNOHIWdduaAB0S/XNBeAFQWi1LBK/3oBut3Q4Qjlhob9fNKAQ?=
 =?us-ascii?Q?HErp9IFS4/r1IKdLjIqz2U8AkrZlIDAKEWTF7+IIWdICN6DWjCva9yOBGI4w?=
 =?us-ascii?Q?0QSbH4R//VspQij5fT58qIm3sr6JrqTZHHXb1g4kb29cEKC1xxZZKEODK2d/?=
 =?us-ascii?Q?7O77xsu46WfcuX6KP5s7nZ2Vuz6fsBfZxVs7e+8dltz1BB5n1sydTHQ2AE8N?=
 =?us-ascii?Q?SeOn9Ew4UMKZhOHZuYIRT/eqx85YD4bIbFN5A//FoCwpqawVpHOGt6haNK9p?=
 =?us-ascii?Q?cEn3YQY6tZD2rbZp9zw/8d1riv+30L8x1xx2qGWIfTFUbKAZhIHBptne59NX?=
 =?us-ascii?Q?jTsbKYAKFTOg//0O9tGglWJwY0PjzjDsw0iJyOvahoGfjyTglSiuegXYX1ea?=
 =?us-ascii?Q?gqsYrYvaN6popGaxuVXHxSbp9HIMQeYz0ScGChNSFgT/DQHe/Uy+K+6gz6/C?=
 =?us-ascii?Q?RDJfuQwIaFOrRLZPhUGZHuaXvpG5AQwoEuzy2h2s21mIrHiz1oPhJNusJYxH?=
 =?us-ascii?Q?tgUktHBMouud4EZXcUz0su0U59hCyQZcipJ7uQnvtm4dYwmhMrJ1bYX3agSR?=
 =?us-ascii?Q?IvoTizxMl8oFj2q4cXyKhK6lsC5duFC2SIpkwW0A4mO+J+bSdBCaKYf38WKs?=
 =?us-ascii?Q?ASno1tAwUFKd14AF1A6daYgI//swbBEuzVDHzOXolJXOHUQMaO/lZ5f6XWg+?=
 =?us-ascii?Q?++5EiA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	mJWlxlJif7jhlMSFMJqSphfKg6KhqSoPaih0duEYEQ2OUum3YbzNNRUaTU9t9PwqetHyi+bOdYVxYp0uX6am/GnHzJ2R9sKQiEUt7MNtCTTE6GOMwPfyun5CaqarPcean8ZugW1HFodqBPjnlnoC9JgrWJACScQ37ODwm0KMwkhb1a4LpcQoHVitbDFD7d83KMdn9H0NV88htz8IjKV4uUh2ygpkUWy22lXXLzRkx06Hwe45jw1XkcyW0DNLxkYFsVM/lVht00jk+XvOwBaTHMpCikzC4um4J1bzsPDgl3AMH5nN/Yk9+KaF6kEhF0e/duhFyjiWEHns3fjcejZI4y+7AjZ0n2D3kDyn/Q+l07BO1qjjaiqP5GIQWXKmSqkToUyTgwnpCdlLXMa3uCfiWlsoTm04Ydq5aBA2VSi+fSZWkLKSNap5PfUK9HCt9fsh49HcCnyKLVwNk+juFCWp2z7LzgCkcyELYYRLLBZmfrywYsKZgwvft2N1V7xgXYTwWWyv8W3/m4/SvUhkNvQuFfh4+FjiHQhGd/8U6YSDTduogmWfAQ9n+HG/MKjgDV/jwfMiuyMLzGyzaIz7OBFW520WQsbdszMM4tu02m3apBQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7546c6bd-66a8-483e-8691-08dc8f21c952
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2024 23:04:05.5443
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q8i8YVFmrNCUsXBHIlilLoAoRW8394EbRNPnjHUyxrJPWhPl/0hezTe1A9NtscLFXV8L6V/e9MEAgwGcLcwMNRDE6D5PdbGIq/yA+cHm5zw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7398
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-17_14,2024-06-17_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 bulkscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406170179
X-Proofpoint-ORIG-GUID: BX9ms_jEOwGmAyRKRXxozAvrdMNHt8oZ
X-Proofpoint-GUID: BX9ms_jEOwGmAyRKRXxozAvrdMNHt8oZ

From: Dave Chinner <dchinner@redhat.com>

commit 75bcffbb9e7563259b7aed0fa77459d6a3a35627 upstream.

Chandan reported a AGI/AGF lock order hang on xfs/168 during recent
testing. The cause of the problem was the task running xfs_growfs
to shrink the filesystem. A failure occurred trying to remove the
free space from the btrees that the shrink would make disappear,
and that meant it ran the error handling for a partial failure.

This error path involves restoring the per-ag block reservations,
and that requires calculating the amount of space needed to be
reserved for the free inode btree. The growfs operation hung here:

[18679.536829]  down+0x71/0xa0
[18679.537657]  xfs_buf_lock+0xa4/0x290 [xfs]
[18679.538731]  xfs_buf_find_lock+0xf7/0x4d0 [xfs]
[18679.539920]  xfs_buf_lookup.constprop.0+0x289/0x500 [xfs]
[18679.542628]  xfs_buf_get_map+0x2b3/0xe40 [xfs]
[18679.547076]  xfs_buf_read_map+0xbb/0x900 [xfs]
[18679.562616]  xfs_trans_read_buf_map+0x449/0xb10 [xfs]
[18679.569778]  xfs_read_agi+0x1cd/0x500 [xfs]
[18679.573126]  xfs_ialloc_read_agi+0xc2/0x5b0 [xfs]
[18679.578708]  xfs_finobt_calc_reserves+0xe7/0x4d0 [xfs]
[18679.582480]  xfs_ag_resv_init+0x2c5/0x490 [xfs]
[18679.586023]  xfs_ag_shrink_space+0x736/0xd30 [xfs]
[18679.590730]  xfs_growfs_data_private.isra.0+0x55e/0x990 [xfs]
[18679.599764]  xfs_growfs_data+0x2f1/0x410 [xfs]
[18679.602212]  xfs_file_ioctl+0xd1e/0x1370 [xfs]

trying to get the AGI lock. The AGI lock was held by a fstress task
trying to do an inode allocation, and it was waiting on the AGF
lock to allocate a new inode chunk on disk. Hence deadlock.

The fix for this is for the growfs code to hold the AGI over the
transaction roll it does in the error path. It already holds the AGF
locked across this, and that is what causes the lock order inversion
in the xfs_ag_resv_init() call.

Reported-by: Chandan Babu R <chandanbabu@kernel.org>
Fixes: 46141dc891f7 ("xfs: introduce xfs_ag_shrink_space()")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 18d9bb2ebe8e..1531bd0ee359 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -979,14 +979,23 @@ xfs_ag_shrink_space(
 
 	if (error) {
 		/*
-		 * if extent allocation fails, need to roll the transaction to
+		 * If extent allocation fails, need to roll the transaction to
 		 * ensure that the AGFL fixup has been committed anyway.
+		 *
+		 * We need to hold the AGF across the roll to ensure nothing can
+		 * access the AG for allocation until the shrink is fully
+		 * cleaned up. And due to the resetting of the AG block
+		 * reservation space needing to lock the AGI, we also have to
+		 * hold that so we don't get AGI/AGF lock order inversions in
+		 * the error handling path.
 		 */
 		xfs_trans_bhold(*tpp, agfbp);
+		xfs_trans_bhold(*tpp, agibp);
 		err2 = xfs_trans_roll(tpp);
 		if (err2)
 			return err2;
 		xfs_trans_bjoin(*tpp, agfbp);
+		xfs_trans_bjoin(*tpp, agibp);
 		goto resv_init_out;
 	}
 
-- 
2.39.3

