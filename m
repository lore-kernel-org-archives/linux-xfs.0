Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8951D1756
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 17:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727890901; cv=fail; b=TzR/MNJ9u9/MlXsZEBH6fkF5c1vzPBu6e9of14IEPWWGH59zvwaqdkGlRahHur3HZ/7hVXE8iIx/MTQmh5KcYgpRek0AMwSypZ9r7stm0X6wfNCNJX1GfNkJBOuB8am6YpKbDsiejJREp3w4b9c11kPLIrLn7krlOoNMwaVtycQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727890901; c=relaxed/simple;
	bh=dA7Q/1PYgseBra+f/5uRSSWKHPAy+tVqlspHr72Kzfw=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XGJ1dvqydiy59pBuyYtstlwh3C9HaVVB/dSs4aa8dBqq0EA8n5Ek8g++Iuxs/9mVK0y+H8j14RjZvHZNjM4IrJVgYr6iFGyE04i9M/yFLEr0ugK4QY1onNJo3ckmkyR2QDDo/FsURksM2qCHSKqWzkryRK2ZPjo4D2E3YFLmMRs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ggibXHrT; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wzttCsmP; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ggibXHrT";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wzttCsmP"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 492Hfbla025084
	for <linux-xfs@vger.kernel.org>; Wed, 2 Oct 2024 17:41:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=6si1YAYjj9O/s2iuLd3L25kJZNC/XDVDvrs5DfiN+0g=; b=
	ggibXHrT3ye59iHxIB8q6OInEwM9sQ+tMgVOPp+wX5Kk13s29imLlO4c9TuGAr+b
	jZ3lynMLZ1Bdi+Y5b3BUyHmG9AdCJ6FHlCm8+MSEYt7wBunrjduV1e6J1lYVb/Ul
	UN2Imz83MLlWp3Tb+E9T+KwTdyX54ZiTbKsDMQjEprfWzayCwA+iV+NbV998M47V
	HmlcRy0L/ZUysgV3ZJQf2pC0mgzgMml9Hv4r7H2FGW2MI0RbzwkzvYMJBVow6JpT
	zfZUnudVp5JISRBtVdCqMo3a8PoMzHzB7NBSIXklBdQyW+qODsqY6WlrTf6lDzHE
	47x+CbY0wnG5DwoUWQJ6pQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41x9p9t3e0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 02 Oct 2024 17:41:38 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 492GSYYL028430
	for <linux-xfs@vger.kernel.org>; Wed, 2 Oct 2024 17:41:38 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2040.outbound.protection.outlook.com [104.47.73.40])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41x889d47m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 02 Oct 2024 17:41:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bqDL0roBuV02TpUPijNrJwIlVaurVINuLIWLias5oFRQXL7VbTld/nhkKlajsyk8QuNPl5Jcy5AM+Qz760rbIspM83AMvMzkQ+yU/BiJcYyCMWM5TXFq+5/c7hk7rPXFfdBw0jQsaWOgx2q+pJAY9QPpKmF0noOqpvQmu29jEut0SFdA86IpN+LepwFmt4h2cqsuH++VtlHydEQEgaSx5GcoTy51t4mcJhQg5HXNDKwzMQbKfF2sI29cLEdY1Tyt9aTbkVFb/pXAUg26iaef9h6W2uI6sgtSUMGxqSRj16JM1dg5pIG+S8PkxhjwfQUaOCJ2MTRqLVQpkbUYV++lJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6si1YAYjj9O/s2iuLd3L25kJZNC/XDVDvrs5DfiN+0g=;
 b=D/ospe7SByWQ0qFbIuNjgc1EiHqOPodyI3kFVa0FDL/gQhJgLtiWaTvG2+/APa4zy6Ag0ATALLq0dfm7B5TN1dWOpYXox4QR22M4jEN5rO5SIX7oOtTJSVS6omntaoNngOBll9UdV0EyRa/XXnvGKg1HrFmt7EUWD1BDMalgZc7PeWtl1XnwXt1hr6QgS15yjdf4xX9EmyoTNdyO660GpO9FEE0qqZOqkrWaVnYdPkbISGftUh9EnGmMnecohA+N80yE4cU73c22S6r3BQA0FWWdq3gf+h64szHvvjIkrsbPCzTSa4syG8Xl6CNeSRVWNxyFhARV/JHpxFS/cBXUFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6si1YAYjj9O/s2iuLd3L25kJZNC/XDVDvrs5DfiN+0g=;
 b=wzttCsmPK3KhXm9WRRWOgwxpK0whMiQXGkcYyR9fyFwXFefrApsDdQWLIvwSH5rIcLDMG6RpjLbDeUfccwjJqB+pqUvX0xFQ/mw3DxGvQce3Lk+fK5V9Ff6of+cDVsH13VBJdJVQfPm3zMx4AKoI2BHv3l6wi11iF3sB0oEz3J0=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BLAPR10MB4995.namprd10.prod.outlook.com (2603:10b6:208:333::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.16; Wed, 2 Oct
 2024 17:41:35 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.8026.016; Wed, 2 Oct 2024
 17:41:35 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v2 13/21] xfs: make the seq argument to xfs_bmapi_convert_delalloc() optional
Date: Wed,  2 Oct 2024 10:41:00 -0700
Message-Id: <20241002174108.64615-14-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241002174108.64615-1-catherine.hoang@oracle.com>
References: <20241002174108.64615-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0001.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::6) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|BLAPR10MB4995:EE_
X-MS-Office365-Filtering-Correlation-Id: 345bf2b0-c19b-44bb-479d-08dce3097637
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|10070799003|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rFkO6eseV2g7zxAYRTJFduLOrUvXKRdgsmHwRtmf7wj9Zbnu0VBU2cyt3mcd?=
 =?us-ascii?Q?GAC2oyAJ0kbx5QqYLj8WQx0K7u6/+Qr0zTEfikhjH8i6xpg9uCeXaXgWq/f+?=
 =?us-ascii?Q?gHQm/BB1aNFDO9SaTZyIxWJkvHQPVSmmlkCygdWISHlDkiSu6E9R6j2yEcSK?=
 =?us-ascii?Q?4dVCrRPToEVFC6uSnB9yQbz5CYY990gEPgj+D3+/FWllHMy2i3c0rh8o/UWd?=
 =?us-ascii?Q?9Ukf97oQm7bCgfsv0Mxa5IpitmsRxfdglaV5RfGH8bTlVq/UAgEdaJBmQ57g?=
 =?us-ascii?Q?3WF+Q8m4Dyx7/zJrKAvt/Q/7PWRQEMOH+cDNq0Uim3fbFGsRpPXbW3vFk5h4?=
 =?us-ascii?Q?4LL58iYjfIvXC+lR2o09eVjAp9tkVWl54jyUOeXHnqHhpYcZA5Ct2QEtRhZB?=
 =?us-ascii?Q?3YTla6k8JWppqAyHqzfiSO0Q6Vnhy8j/rvDh0H+EpHcN0Ab+vnTO5psu50Df?=
 =?us-ascii?Q?EZ4ZhhLr03zlhVjtPvd2+36lYf3fSrFVI+FtpigBwfl7AQ1bsi6KXFWN858i?=
 =?us-ascii?Q?NBEkA+QCQyGgzOarCU3dElqA2MqDXaRD0NZqEb9A35/KDHALrXhBrKcUE5RG?=
 =?us-ascii?Q?Xro2zbiL3YxlF/pONjA0nvmCEfnBCgidSXDCxCeQ83qqOd/b38ix8YD9HVbS?=
 =?us-ascii?Q?sTsaYpMAJxUHg+B8mBX06BZBO2iB6RS9tSm/S9+NzvqAWnHTqvVwliHOemcx?=
 =?us-ascii?Q?KxQg2gMUjvfwHfNnBTiTjH4sCA1BY/9cMAi1UFR/sCrw5jUQCEOw/MPAsq8W?=
 =?us-ascii?Q?Qkvwb4/dk8+HPOtX/oLTZwdpAdoShGhIdUa3qmIWvn1C7JEx4PzlN5IsTgrd?=
 =?us-ascii?Q?L3f5anp3+jr6YocgSQE/atY56nVwJ7tTvM6KKP8A3YnWQXplgD+rZbFFQrK5?=
 =?us-ascii?Q?zMV9aDRDVzsEhW8mNxsKX0I5wk8dr8rPXwo1HQV4OlYrexbuQigZSkKzmAmx?=
 =?us-ascii?Q?WBuIq4gRblzBO+QPvI8V6PeUN7NNXoezJTzmpQenTKiNO5DtawmobFMTbqrT?=
 =?us-ascii?Q?hL7gPNw7cQsm6AUMyrmFbaa/2qYPE4LuQDKNYMdN+Ksr7QU344a7u4wsic4k?=
 =?us-ascii?Q?4o7UdU/dU65XKWHMmxDaP6sz8eTLypKAOMuM5zQ7T5/vSBvfsFil0yVefpw1?=
 =?us-ascii?Q?cQHsMIHVpese2W6rfegkbiqPqur3Z2lLctEHhkMz80GmA5GXz9wy4PVz/Y6g?=
 =?us-ascii?Q?shY21vh5hsM0M7voDmnuGnOJOYk6PA/q4ww6GjXYVpap6fuqH7Bjw+NcA5xj?=
 =?us-ascii?Q?nCq3/HyhisskEL6wO0NoRE2Hf9+FrHlcBr2WT2HsIw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(10070799003)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JLApEDJ8RFjGToiygjfD2bPz5hXON5Rb5SPIp7Fl6aLkhnCoPWSl0y79gknX?=
 =?us-ascii?Q?jpPPP+r0JPXdMOon/Oc8uJ/WDfGWwV2n6+4nNoxV1F0KSTXk0STBIYFVJxKe?=
 =?us-ascii?Q?6dCXq+Va3Mo1CfNrAtgbBvpq3H4pQM2TXhDgRrvQBWQ9RGGtr4fe/iBDh2pn?=
 =?us-ascii?Q?KPOvYlOBDaJyek13Lpa6T9DczLPIH6CTLiYioEqbBuHcZHPzwOcWYE/gavix?=
 =?us-ascii?Q?UOupwgAPlUFQikloMuxB0nryVxVFKRytJ2urY0DxIcF/2Kyj7MNQE6d+eZi0?=
 =?us-ascii?Q?kjude39Gc1HOk7uEekdBh/Pmj5YOPXfavzUk0txO9aKWneSl+KgDUaEcpoHM?=
 =?us-ascii?Q?W8pSbzP9MvH/94pp+1ugIbJCTHgo8NaA5mUNweY+95v0w+rAXcjYrmn1qFQC?=
 =?us-ascii?Q?t5zkwVuq3/nIJY2i8ZDRC+QIWNxk019nGV9f0PLlT/doEqNH6G5vdq4JS3S2?=
 =?us-ascii?Q?VILqPNYkoqCpFKeLTh8dwKPkZET5CTIvnXntaQiELN9Y/oOZdFEQ0xrZXH7m?=
 =?us-ascii?Q?BvU9V7hdX7kVuL/dbva7gkXhlYUwNIzhFP87XeP79s7/+h++AoAbdwwTZiWk?=
 =?us-ascii?Q?CliZfmQ5lKvNon4bClK+YwH8v4ckjvf7A8euTFL61dJiHdky7MnHGdnE/BAg?=
 =?us-ascii?Q?tC9ipYikoq6u143BlKDjmyAShGcSk8sapoHBmzTxTY3vsnCUUbvj+msdkEA2?=
 =?us-ascii?Q?ayRJZEDOOmRnusV5lQqryMOa+SuAPojd5AbUMOd7tvLkBqaLFPsfSgDOINJ9?=
 =?us-ascii?Q?m+JJ3e4tSEWiN+iirgQl7U3bRQHbw6DgUZuNv6swcp7jKbewu8CarXgQCdgM?=
 =?us-ascii?Q?sFMY22zs5UymxTi9gW31ZP+Cxo6LIEr6bMOf4rYC6FW61LRYlgpGy8xglHzr?=
 =?us-ascii?Q?LX1yclUmr+17G99nl170LebW4XqrdEo0AGK5GotJpqwh9XEv0QDnDu3XG5Fu?=
 =?us-ascii?Q?tBCGWaUk/svOdFQC5kxEGkDU0sstrgvFB7xBtE/gYdcDqW1ijXeP+HSNzDCR?=
 =?us-ascii?Q?mGV3PRrbsurfzXW4IIBP/TiYnc6oYMUYmsob6V0YSW3e0oQdv3lD4LRyUYF1?=
 =?us-ascii?Q?1cQhpQpZ47HEABqbq1Y1aAZ4mVDVOzDJp7lw0ujRAMIWUoCgDiW/gUwSTRik?=
 =?us-ascii?Q?JFx4ZEH7yFOBz+vd16jJkBbaBIX1fD1b0Xr8ZwOYQOnsj+6+HM765YZyeaur?=
 =?us-ascii?Q?9yIyHf7bUVA8DA21CluMrbnFkKfS/uUZFHebm+zVqMVWtAfOpDD4B6nJNXSL?=
 =?us-ascii?Q?YpGFQQdrYu7mhOf1v+HOAEtXdzxkADq9ABPHTnLP8yM9y7sx6itA00+oHZuu?=
 =?us-ascii?Q?LW1H42hn7OLOzQzpw/IJ+kKFZj2Y5KIlsxChsaXA8wKi7O+Ny2dTvm2IMbR5?=
 =?us-ascii?Q?ikcCJdTr4X/KU+79hnzZ/6D3LmDko7rIpk6z4LjyELqceMSNmDGTWZpNFqDY?=
 =?us-ascii?Q?aivG3iBou0G4LW47Xpcs8Gb36q8OAVi8KHUxUsiJP4KNgqHN3Q8QcJbqPd8B?=
 =?us-ascii?Q?Aq0HJXS2iHpn3B6edwHPyGy41++Hlc3N/ffFyrENLN3ZFLjL4kwcpeyTN+XG?=
 =?us-ascii?Q?XvDrVhiLvgMkY2uLqAUMe5xH6z474lNOXVBIj9BwMWxhTd4aCZYh4JWdKVrN?=
 =?us-ascii?Q?0cmZRA6f3xPJqWCrWgEHf1VGUWIE1t1ZtTBmyVLcxYRmFRmk8leOH3aWOSbk?=
 =?us-ascii?Q?MQ6jRw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zyNQa7KCqPAoByeBFvefy9N/psnRNuj6CMkUQtUGwLyVo2Lr21JTrtRujcwR12tgoHYNp7B2u0IazLj1x1GX8z8X9G62mRGfjA7hlqCAIriF2OE8rF9uSbgyiQWOqGj4OBf8Emnm9DVC28MbOr3s+H/BFtglSxNC+2o4mrrk4tTy9/tW8d23Vmps8f8IgLXz6jUJjqsgewj5WBKMI+UIlQRtARw5SjY3Cf3aWHHXwZrjgDFBLvgECiuuRjt682hiymLvup/zGJ2qBwuonD9BHrCoN+Wi01BdK/mhJHyREisEnj7/nOUwfYhFh8TUx/jHmeIeU4Omd2wiMTAkKwV7E0QiMl7G/zBI66bXgsCRg0ZVy7Qh7ZO9trjlIxec2uHy5rlTj/zahciGg0uThYMZC+N25rRIcTMILaeZDqrWInUGnxfpR+OuCuXtKpyZVciACWJS0rCh42KAScsK1/m5uw5l3dsDs9G8Jfmi/LSPTmJumqYEdJu2QcvEmbiLhO3NY+8uoQIwrZh5x6W9aOBJ+fdtA1cpnKJ51ySvjWsHIfJSUrJXQopWEt3lq3GHDoC3KgRy/gU/zs2itkxvb7Z6IA6vQwwDvOerKPoGMm7ay8c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 345bf2b0-c19b-44bb-479d-08dce3097637
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2024 17:41:35.8777
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mxeJTSiXuzgHw2yBfLFov0zme2XoIXe5Sw7pBdHg/Q6xzgS5Cb1ZNhXkBjieXWsyFcPlHeiA9A6jamSpOm7YdmLgt0i2XTL8QX9esqNkOiM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4995
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-02_17,2024-09-30_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2410020127
X-Proofpoint-ORIG-GUID: oJJHBNFu60LUgqQ5nq06PG5rGAQuS4uW
X-Proofpoint-GUID: oJJHBNFu60LUgqQ5nq06PG5rGAQuS4uW

From: Zhang Yi <yi.zhang@huawei.com>

commit fc8d0ba0ff5fe4700fa02008b7751ec6b84b7677 upstream.

Allow callers to pass a NULLL seq argument if they don't care about
the fork sequence number.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 18429b7f7811..6ef2c2681248 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4595,7 +4595,8 @@ xfs_bmapi_convert_delalloc(
 	if (!isnullstartblock(bma.got.br_startblock)) {
 		xfs_bmbt_to_iomap(ip, iomap, &bma.got, 0, flags,
 				xfs_iomap_inode_sequence(ip, flags));
-		*seq = READ_ONCE(ifp->if_seq);
+		if (seq)
+			*seq = READ_ONCE(ifp->if_seq);
 		goto out_trans_cancel;
 	}
 
@@ -4641,7 +4642,8 @@ xfs_bmapi_convert_delalloc(
 	ASSERT(!isnullstartblock(bma.got.br_startblock));
 	xfs_bmbt_to_iomap(ip, iomap, &bma.got, 0, flags,
 				xfs_iomap_inode_sequence(ip, flags));
-	*seq = READ_ONCE(ifp->if_seq);
+	if (seq)
+		*seq = READ_ONCE(ifp->if_seq);
 
 	if (whichfork == XFS_COW_FORK)
 		xfs_refcount_alloc_cow_extent(tp, bma.blkno, bma.length);
-- 
2.39.3

