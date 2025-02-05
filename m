Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D78E21323C;
	Wed,  5 Feb 2025 03:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738724898; cv=fail; b=QBOJxpiiGAjadrexDaSrSCNh4uaBtvM4C6MYfZlrh1uFY9AiPjg7RCddemIC7xHtkH6d8cgt27A7qOcpCH+hZoHgRN6dH/+QBjPQnhn9u2ZUz+UHPhcj8Rm/DRRKObMu3KcOj2iabtAR/psrQC66n1Tn/T7M9Xejr1rNIL7Jxhk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738724898; c=relaxed/simple;
	bh=LUO/jxakQiu1xcq2kej6d/tEWzZRLluj3AqMvMmaO+g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mQXgN5t/wHeA+Gw03e/OysRPBTaAGOBag2ilCajqL9JQhPcnY28QBmEa922IMb+AHvrpjw64PyHXhu4SsdRolsc6GFXArL+QQuUPVrNOVRe0hu4yJZwfo4ZJ/WaG9H/e12jYFWyDadJfgEyWIURIEJPE75szR60YJ0ilGs2yODM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UErpniQW; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=I2yErkzU; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UErpniQW";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="I2yErkzU"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 514NCIjP009379;
	Wed, 5 Feb 2025 03:08:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=a20q3GBAYxXwUHPsWlMo9jo58r3BWvlAQVj3aiNjqOM=; b=
	UErpniQWEjiSJs7JuDwO7OSLlrDcUA23r9k/0dOkg+a5B8/+3RuKp5A3zLdkSV/y
	QMsDoHccl0dZbM84ZHYmnTk/uWiBMawgLdt6Otywk2hT/1xlpkuwzNOE6eWFUdxs
	bSNnvNCPqAPDDn95cH1ZUPR71Ho2LKmzvWRfRRIa65rC1IF6J5rj+Uy++p/PrnzP
	xE2dgmJ7yFSfHBwl95iWZvZYl2iDxG/ExYqcID66dojrqPwaBO5V35XTxsImuflZ
	r45JkKKK5eBnpmMIh1t404W8lfI9Jk9imHN37Uo8jVYUyZn2nS2ocFpiXx4lJmLZ
	WgPcnuSJLyWWrdpXDfzMyQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44hh73nykk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 03:08:14 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51518ZsW037739;
	Wed, 5 Feb 2025 03:08:13 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44j8ghsn1b-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 03:08:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m1enI6oA9Q78leFSN0/IXwu4AxiG5KShAMWenNGZQVoIMSEsSdLpK4pTY+rinwTHKJyhcfGCTBkRb+HLztc4spkyxPRPj4x5+POPpkBpR+t3e935LgGpRkVGg2+a+klSAoGakU/4DIIIlW0YEcDm7UO85uTb17982+Y60J66LJibDEYrcEE9rrPiJKI2aTZaYobVxWp8gFQwJ9qAn1XZ8SNdBX6b/kuVxayB1gdtKZAA7H244l7YSZW/iIIjvv1vCqCCL+GCo5cdPXLkPpbWuS+UWeO7vJsgx4SeuyUuWX/0aHvNPamvKGNejeoFR1wZHYrYNa32C5Jf7I9Ty48EOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a20q3GBAYxXwUHPsWlMo9jo58r3BWvlAQVj3aiNjqOM=;
 b=N3PzfCTsKPQ/cBWC8y+ICZ2xVhbJoMifCizYCovm+cbXaR0/2MWXfUOtgFYn2HpB/485uhmveN9L7qUtYxMxff7TXrPAbz8QtKRjNkVm/rf2TPtfBiTXj5U5ceBkDh5Yg9AURvMji5zAwKqVCZ2YqMrUZtVfAmAy+1WpKGXNXVoc9/guY/4OQbPMRjGPI/4N8r5Z6gE55CMn+DVi+kliPWOHA08m2tmp2xv/MVzgMZDXNudEtW0KR2yAxcZzarejJoHKjcoixN/R7bEOV4dgH13gQJ3dPx1yKnY+vuGUVhnZ54ZQIQKbUu3MIDFZLEhxh5lz0M2M8VzevfQxYDK5eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a20q3GBAYxXwUHPsWlMo9jo58r3BWvlAQVj3aiNjqOM=;
 b=I2yErkzUP481+iGD4qbuvaE4OxpWS829Pq9O4t0YAU1UcRb2RLpHh8jQ3NHbi1Nl2pviR+CVKJr48PjaPSkVs7BnnpxbG7AjIAe0SyK8CYDPT9JAg9A4jsmW3ZbLxcLwF7zEDcBy83gGqBb/QUgnaiV6VYG8maL6YCDdgTaFO6I=
Received: from DS7PR10MB5327.namprd10.prod.outlook.com (2603:10b6:5:3b1::15)
 by MW5PR10MB5689.namprd10.prod.outlook.com (2603:10b6:303:19a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.25; Wed, 5 Feb
 2025 03:07:50 +0000
Received: from DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::43e7:5b82:9069:b402]) by DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::43e7:5b82:9069:b402%7]) with mapi id 15.20.8398.021; Wed, 5 Feb 2025
 03:07:50 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: xfs-stable@lists.linux.dev
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 09/24] xfs: distinguish extra split from real ENOSPC from xfs_attr3_leaf_split
Date: Tue,  4 Feb 2025 19:07:17 -0800
Message-Id: <20250205030732.29546-10-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20250205030732.29546-1-catherine.hoang@oracle.com>
References: <20250205030732.29546-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0116.namprd03.prod.outlook.com
 (2603:10b6:a03:333::31) To DS7PR10MB5327.namprd10.prod.outlook.com
 (2603:10b6:5:3b1::15)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5327:EE_|MW5PR10MB5689:EE_
X-MS-Office365-Filtering-Correlation-Id: 68c8e989-44ed-4f61-cc1c-08dd45924616
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|10070799003|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IWMbGwgv81TQzVCPznA54l4y+SObytnSGMptfNvQHg17ojOt6zfBG3zP3uzt?=
 =?us-ascii?Q?jZtPhiPOMm/lvo6v6X6LZURHRXcpXeeWJEatT6+1Z04OK65qex+C2qcZHWg8?=
 =?us-ascii?Q?GexHg8OjXHfiV6SrjwEVetFP0uh8QPIvtIUrDAGFxbRWPhvBctKIhtmZ2ves?=
 =?us-ascii?Q?nqYjmyWpwpIaxjheuEM+NwDuaPmYDn9v0A79SWOn2szp+TcLIZlVlmsKNDAs?=
 =?us-ascii?Q?9TsmfgIsinprTO2hqG9ZcIDqOck9iMherNqotLi1pDkSxy/cng3n/nxXD14X?=
 =?us-ascii?Q?mGvRv5jvQdcZCR5iiJ4D3Zl0OEPKNP41oFNHOEKJOuXENHKMUHE3FyHH4omw?=
 =?us-ascii?Q?N3lDWl2sQLXTpfWlMwt250XHxr0tCx4stMAeK8RQe6MjC2SGLzqJo2wQR8XM?=
 =?us-ascii?Q?jAfPmap77jVdCt+GAcaNMEkzmpIVKFmi1S2XaaSRIQCAG+iIcfhazLyAWO52?=
 =?us-ascii?Q?xvYJbGVPcRSOwnAcsGrgja462aw6SU5pwZyUmzVikQVMMxzFpuHARNU41lc8?=
 =?us-ascii?Q?SGTbtO/NJpd06Stfh5opJ/FOQfzO8l5EU8W8u1Pm/RZRVWQ2JEOqytuEPPk+?=
 =?us-ascii?Q?XqEFpQQTN8bk+Em0UXguc45ZxlwLGG7oSa52EF0oi95Zp4PoEfbs6Xl1pQDG?=
 =?us-ascii?Q?YGjY7b1m08URmaFPL8ZZQLWYgT/xeVrxKPECeFuBRIODQrY/c/+lxr/RL+8O?=
 =?us-ascii?Q?Wus2cGx4xgZnKq2s+VzBNtsTwwIccBaTRCcrlQNa0c742h1+mFAZK870f5pr?=
 =?us-ascii?Q?hurCaqlxQZPmEkFpn4v8WqinPtM5wp2Z/RAb0VucoafHQSvPOJN35tyUv7b9?=
 =?us-ascii?Q?GhLt0I2Mp1n22eOSl0vwzA4kizLzqlwfRwIN08NE6jwmdaou0JFNFu138ate?=
 =?us-ascii?Q?tStEkh60QyUmp3XP9LA/txJMJavifUUZFWFBZnabkUEUJ9GF8soda3ESYBXH?=
 =?us-ascii?Q?79GioajXUhEYxiqzgNfCgVKQWkhRO9VVcaCKiYYdpxs2TwVOflXWPVMIyZjD?=
 =?us-ascii?Q?Cy7W59qkz4nCqqn9EbiT96Sbc3yxRcqZWyU+pjjr8tZJJpqiSs3nIv1V7LFK?=
 =?us-ascii?Q?GdJpmZrjxyhiDy136NH/9MZPMN/gPbXcklq8FwK65antFZqVbJcpTEW951Ku?=
 =?us-ascii?Q?MZ1h42Ms2Nx+lyfnM6wlemVnQNCQyeqQOd+oYIJtm/rIVsyd6HjDtowbEEj1?=
 =?us-ascii?Q?/PPvnU4rujY/DhHi7HWaLRd6UbzHbhTxhPdE5zuGi8ZOrPV+4c5o8RMudj20?=
 =?us-ascii?Q?idahqoro9Ypx7onbmrgZU0UyqLAV95wFhkQMZOLR4rF9CT3pFQDlL7ZAnB8G?=
 =?us-ascii?Q?KCASuKaZFbIdx3NHLLCrdkcLs9WPbrNe+vSXtnCp9uolhTSwkm2FQAWsUNZT?=
 =?us-ascii?Q?zJBLoR7Bj6UMYHxbzJc6tMBgJTR3?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5327.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Zq/kWHm0aWAQJSHNoS7qBKLWFUleHrDpKHQ88Y2ixFqZhFERyCVc3mtKBWB/?=
 =?us-ascii?Q?zUUkQ9P7/9p21WfbD8GAVxaDGYZ0xCbXj4aWAv5IrlSlDlaH0fZyLqgOrwjl?=
 =?us-ascii?Q?rM6ogcFr3m3yn//Sn4CEP0XfhDTQUnoksK14kyVjhW/J+8q3Nc4pg75khtSf?=
 =?us-ascii?Q?lEwuIlKZbo8Z6qTG6Wgfi9oSmXJ3mmEm9eXf4P7J+/scvidGhvwIun7yGQdO?=
 =?us-ascii?Q?C/a93KOvlZ1eNLo1LikjBx/4evqFMppPnKWh1eoQ6Irb2nR1mDhJHsqTycru?=
 =?us-ascii?Q?dmaR9pOd973LoJ6gEmFt197q4gxwpjxcau23JaUiCxzmQRU9M4XZRXBroRKG?=
 =?us-ascii?Q?B1mp3sT1cns3Qv3Ou5pROrLj9QJhbP+mxPbe9P4mqPHbhmdSRejextI2sfoa?=
 =?us-ascii?Q?fC30aSFZmVBbO+pZlVF0xJJdGajNdjcCEFA1P9+tH4TmVxtgNvlYO/ZFJ0rZ?=
 =?us-ascii?Q?00TSEWYGlsioXn9YHEZ2q3SzfmJHuJ5GKQckMWlodruiYLvOK9csN/BsId5+?=
 =?us-ascii?Q?JpAlUqnmX+PdxWpT4u8XezVmb5WicK8xkdU/sMIXIhMky8W1ns0FszzgoZaZ?=
 =?us-ascii?Q?FKrSkEjAdDnF1gVJooQ/H7TOKQJVic7xfW8N86d3LGm7xQgS9l5YJhYtw5Im?=
 =?us-ascii?Q?R+QIGkNLL+TLVnd3992/mkTBVfRpIS5gfeulwOG3NAKbi2xH3jLu3ovfF0wv?=
 =?us-ascii?Q?4k1jcMafAuoo2UaXX3Ko63tw5nKXSkxPGykrN+grBJjBdKZANCpo3XdNOQKW?=
 =?us-ascii?Q?LU4VfOAvZQ9fO9ta79Kasv94r+Fp0vQM1I31sglAs0UINvWzMnf/yhw9TRA6?=
 =?us-ascii?Q?l1tpZYeXqqbOJp0OK1VsPyhfY4N5jUs37tMDFyVTt1rT/tZA6aGmVLXzstyA?=
 =?us-ascii?Q?Wj2kRpsWXVP15KHRQ1rPMXud81+ERU+zv80y4B8i2Esy10N+kxNub8rclC8Q?=
 =?us-ascii?Q?oni8whnQZHkHvjcxC4oZO/97NSj7Vn0UnZSp3/hgwGYmkgwpzHQis7029gnG?=
 =?us-ascii?Q?dAcVUrz5+Y23yx+nJu9mw055zLHMk8H43ZpDDoz1F5SZRn0JIfCh6/a+AfIr?=
 =?us-ascii?Q?hwnftye1Oog3nr7EK5MHAwk1bsExQXFaGsXHh5F96H9PTgB/OwUmq5ig+Oyw?=
 =?us-ascii?Q?ROHnp9knCD2tHaZtoNCL1wrCLv2zW7BQtx/K4LS4BNYs2p/7BELvT63pjckL?=
 =?us-ascii?Q?VYElDoMB6OIfrtyF9u5rs9SzbxBq474536c2QRVk7UP6jh6Q31XgkJ5kVmjy?=
 =?us-ascii?Q?Cy1Hmm6/CQXJ2yxCTK+ae2SfCZ9Q6wfrvRpBEzAeQwSlSciKdIxRNWQiqrzR?=
 =?us-ascii?Q?qRuI8iiUh+nH+Up3USsLA3PrHQ2W/bxkK1/sii2Ky6Nbpjt1R9lF0BhYP6VG?=
 =?us-ascii?Q?sfnDcp4yD1NiGdHDq1mpOdZniUNbTbTvoBftJGjeXAjisy5J+A9RD8ghvb51?=
 =?us-ascii?Q?qFKbPoFOpw7kyzfmsLycub3tXH/AofV/wJ8tvNRFZ5/ATFbLytA5kgkvJE8q?=
 =?us-ascii?Q?7CjlJFgODbGa9mtwywUjaD+Cyhggpw7F+LjwMvZiTP7wH/oKPcEkyJUUv5sP?=
 =?us-ascii?Q?gUGW/3qokcQbu65oFAwFZhmMWLKyQO8RdytNTD4Mn/A77GAYVVP9OW9xNzUZ?=
 =?us-ascii?Q?fQOxyc3zJGKUxAk+f7ogWiLRsIm/f3K5tCkGcO7IVY+I9s0VDLNCnzyaWWHx?=
 =?us-ascii?Q?snWk0g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qtda/9YJM4auCRtUQ/YpToWUbf92P7jlnNsk/U0OY1HX/AdPTEIT+InOIKU1Lb06EG257OaHEapHoxR9kDTzISpLiPfzv7R9ftep71/vRw5l/zVCBdZ5koaJ8xLlPGFAijLebxTvatil2EigTNJmS0gpllr1YVR1Abq9bGE2KQh3IafFPSly3EYK+4DMtEnB7odqhlJUv/ClMbNA8mtS2OMN+TDmrJzjDiH1lnSKK1VljqF0WRXV+hkJmLbmuuv305gjCGWGtlflqHpO9H1jdPPK1a4xEOoIjvL2DK4HS9tweWfJyUmJlPVP2Mr29sKgVeTNsXS/BJnBLNhe6ZO08NcEgly9yB9KDoU/HQvotTw+ql8ak0KRXJyA8sb56Xd6nrEHZ7rVCEfWXY/o0/M/T3PH2u1ic/ER8Af+YvyeN4lCIxPyumPSGrwkjSWpYwAzEOdl3UGL4r2Yk8AWIAp1pHIMj7kQjOyNWXx7xEjVZLvzB1mQ7y5AnQ2Jwjr61dN35ykuzMywT70saoPJ1A7DhnaYK4U3jstNZCrEYmA4YDzKFZ17m3ThpH4btSdxg9T+eVaeIoWoKuvSQgXiY3DTchGfKdOr8rdjX45EE/H1yxU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68c8e989-44ed-4f61-cc1c-08dd45924616
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5327.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2025 03:07:50.1772
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a9VfK/E4jqHNHIw+pFZsVNkYsa3OGRKYkMK/qMs5a/GwpXwUKHk+2eCzSAJ0n5ACNEOLB5qMGSXaNhAzaMQQD/PBwiQLH9PsHrSm8TjCXts=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5689
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-05_01,2025-02-04_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502050020
X-Proofpoint-ORIG-GUID: vbad51PgzLXdi3tsd7vRJdAuT4dxKEYM
X-Proofpoint-GUID: vbad51PgzLXdi3tsd7vRJdAuT4dxKEYM

From: Christoph Hellwig <hch@lst.de>

commit a5f73342abe1f796140f6585e43e2aa7bc1b7975 upstream.

xfs_attr3_leaf_split propagates the need for an extra btree split as
-ENOSPC to it's only caller, but the same return value can also be
returned from xfs_da_grow_inode when it fails to find free space.

Distinguish the two cases by returning 1 for the extra split case instead
of overloading -ENOSPC.

This can be triggered relatively easily with the pending realtime group
support and a file system with a lot of small zones that use metadata
space on the main device.  In this case every about 5-10th run of
xfs/538 runs into the following assert:

	ASSERT(oldblk->magic == XFS_ATTR_LEAF_MAGIC);

in xfs_attr3_leaf_split caused by an allocation failure.  Note that
the allocation failure is caused by another bug that will be fixed
subsequently, but this commit at least sorts out the error handling.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.c | 5 ++++-
 fs/xfs/libxfs/xfs_da_btree.c  | 5 +++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 539fa31877e7..4e5ede2a296a 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -1340,6 +1340,9 @@ xfs_attr3_leaf_create(
 
 /*
  * Split the leaf node, rebalance, then add the new entry.
+ *
+ * Returns 0 if the entry was added, 1 if a further split is needed or a
+ * negative error number otherwise.
  */
 int
 xfs_attr3_leaf_split(
@@ -1396,7 +1399,7 @@ xfs_attr3_leaf_split(
 	oldblk->hashval = xfs_attr_leaf_lasthash(oldblk->bp, NULL);
 	newblk->hashval = xfs_attr_leaf_lasthash(newblk->bp, NULL);
 	if (!added)
-		return -ENOSPC;
+		return 1;
 	return 0;
 }
 
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 12e3cca804b7..28bbfc31039c 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -522,9 +522,8 @@ xfs_da3_split(
 		switch (oldblk->magic) {
 		case XFS_ATTR_LEAF_MAGIC:
 			error = xfs_attr3_leaf_split(state, oldblk, newblk);
-			if ((error != 0) && (error != -ENOSPC)) {
+			if (error < 0)
 				return error;	/* GROT: attr is inconsistent */
-			}
 			if (!error) {
 				addblk = newblk;
 				break;
@@ -546,6 +545,8 @@ xfs_da3_split(
 				error = xfs_attr3_leaf_split(state, newblk,
 							    &state->extrablk);
 			}
+			if (error == 1)
+				return -ENOSPC;
 			if (error)
 				return error;	/* GROT: attr inconsistent */
 			addblk = newblk;
-- 
2.39.3

