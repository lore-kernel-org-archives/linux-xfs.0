Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A64C157E88;
	Wed, 18 Dec 2024 19:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734549462; cv=fail; b=N9Y+UgkWJDGhOzArlQVUO4tZ6sW3g3Sf1mcyi4uJCcRAp8tlxuODQ9/xG6h4A6DMFi5Owh9pjeOM+7W3/BmXGwi1a0N/vnfOLfzBF+EXG56Y9bE4dM5ukxtdlmApXeUM/k6iJCCSwRPlk5kyz/KUcd6v7jIKh3+U7Cvwg60bGBU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734549462; c=relaxed/simple;
	bh=rU5A1ix8klwpqgOcS3je+akte08S90E7Js43OnpqtcQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jUcR7U/p9ShseNtb39K2PgQZkAdh2c0AaHXeF6v+/0TdyiADg/0/IbUCdFeeEAwgdzB5NpnxZVArVMnseOd1fSqFKqCAcuvUaD0jIv44CKlQv/U0XsVBCFkyIN1cybqxMzJFcnou4MWWd9P0E3ohzp0f7E7G4Z/VfA0ULT0HY2Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bvHTgKuO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=AfB5nbMA; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bvHTgKuO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="AfB5nbMA"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BIHQbIn024323;
	Wed, 18 Dec 2024 19:17:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=xDbnsAhsWykhd0kUnxWekk7sKX4B1ut0Gm7uPi6H1Ng=; b=
	bvHTgKuOwEn2L99D4gc1E00fIJ1BZeTX+17T3kSkh4R6Xva75tzzu+mEhkjkn6IG
	uRvr9W/sU+0B4dFqnFWjLYqI81ED7duH7u06clISQbTJusdfiqklZ3UgJNesVZ1i
	HhBzIv6Ii/yVHCuAYM5TyvPNNNFykPHHYe3sxoQTPgkswTBQz3F2lL6UbXTigXl9
	9zewBsQatsSzng+2o/9w23pBG4IpD7SOY006b8/o9nkpn1p8iwhqG7zvv1LAuqIy
	BvR6retxPP9WjFM7ikTE1FXJh4ZyNMiw+ooQhQeIFu6BYY6QzgnOWnjvXmpMGa3p
	X6b5Dk4l5ARFGXHYDmOBkw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43h22csekd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Dec 2024 19:17:38 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BIIAsw8000776;
	Wed, 18 Dec 2024 19:17:38 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43h0fad59y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Dec 2024 19:17:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LP42vZKOWHTc6uvQwFTYR2IAl0gpTi58PgFKGlPQVF+SGHhX8uEtY64KzkVYt44Q/WP//8klSx7KcIU3Ks+jOI0NZSPIp9HO1WwHlvL9O/vyrG10wFLWdztxPqZi4zHKlitgRQnvZOGNs/3ATa1uWTTFj8gIlKSMJ/9QXlSxa+v/IfIPivKHwcIwfRMYN6IOzxbyJ/yWx+BRHAcXcBw1wnu2C8XDwyZViBmMXm2quJZC7Ff8UQxXq1HpOxChjPOH00NgrnHFgdJTobSASRPvvkBEFRm9xqgdnd9iFHxUffmxo65F6I/hJlm5BuEZcRXgpNJ/BDsoIfmK5bXrqzW9Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xDbnsAhsWykhd0kUnxWekk7sKX4B1ut0Gm7uPi6H1Ng=;
 b=rdAdMpx1Q0txbUxQAXGDUAriCYoVaIPXliCNYo8lzraGqdmEZNeC8PxgpzHybh3/J7rW7M2Yn2Xydxq7P2PK3yYj90dtpETR2mxCSs0vf6uFrTwzYBB+1oWnHPl0rUjijwvBCg2axxSvrK98tH4fOg9cz7dcymv187LpL641QkXLTGmfA3nihFyev0yAeh28XOCUySZql5fjxvNVYLz/3qVTznMLXF0dnTOgFVLyo1ADb8aGTq7ULjnDaHCE8aN5I37kmzzU0Q2M/38tOgTt6yPavt8X/qjobn+VjDXpcFXr32cWxh5nfYOb/KKzsXpPZ+oWHUFNytsWIqYrL0NUJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xDbnsAhsWykhd0kUnxWekk7sKX4B1ut0Gm7uPi6H1Ng=;
 b=AfB5nbMAejEfOdPF1myrf8ldM63MYMIUqSVJSGtJ7EzUjjQcvSmC7dGJt+NDO7QGBO/xV3g3lyZZCoXAEXylwgTH5fC6haHqwc23CXIXn4yV5Xxbsaa+5AaVqKVdoq8RQGqaUE3hvAUSQ+XsX2//sWg5GCl2Ez3lZ0iUnEuph3w=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CYYPR10MB7673.namprd10.prod.outlook.com (2603:10b6:930:cb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8272.12; Wed, 18 Dec
 2024 19:17:34 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8272.013; Wed, 18 Dec 2024
 19:17:34 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 04/17] xfs: declare xfs_file.c symbols in xfs_file.h
Date: Wed, 18 Dec 2024 11:17:12 -0800
Message-Id: <20241218191725.63098-5-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241218191725.63098-1-catherine.hoang@oracle.com>
References: <20241218191725.63098-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY1P220CA0023.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:5c3::11) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CYYPR10MB7673:EE_
X-MS-Office365-Filtering-Correlation-Id: fc1fca48-14d8-4893-b6d1-08dd1f98a089
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7AS36fIOHglkMNfv3RkMtmzm2Czvb4vUjy/JnE9XclWggVwi+Jolgtn1lkH3?=
 =?us-ascii?Q?JD02/xJvrv01L9+ffwMydrnZpYTIVSYF79QWOfWw0cZqIIYadrCKBh5Dj0sW?=
 =?us-ascii?Q?V+6MFANtroqCVc3bx7yzXt4er1bg6nGW/x3djbUux99iM9dxnKoID+VO27dR?=
 =?us-ascii?Q?/+KEr1WF1dovt3GdPPW0I07fLneyM3dizrfAvHUHLUAqRcHEIMaSM4otLmXS?=
 =?us-ascii?Q?mGGyev6GTbBcP4kHzQT5aesIMBHfTWLyhCXTgigBYACP7AxSXwi1vFeWVFSQ?=
 =?us-ascii?Q?tFG+yWAIrEZcs0mG3hHV+RcsEQXepNQCjGlqEaBHmlbCiq/VPUPfqESQoOpt?=
 =?us-ascii?Q?bUepnuNUoUzMper2o1D5j6pY0RfqIZkXWSnMERgkjISotRX6pjmG3eMTsYv6?=
 =?us-ascii?Q?ldLNRX2d8SVQ2G3uvJS4QdMIy1u+1vNWRgliXDmIbyeAPikRNxiotSgOE1NM?=
 =?us-ascii?Q?6LqoMb9VNZdIWvG5wnUUaWROnqBm5ZGp7dC4WtN76Wqe4o0VmKLnazwL4Ck9?=
 =?us-ascii?Q?FNJt4b0CbJrvfuKNghpBwk5Y0DD9wZHmmQxnhv9ldKYe/oHoZFc/9tHYXYTU?=
 =?us-ascii?Q?X3SSdfz01qZnNl2RhaVfQxCdbxJGR5jONB/N17hAqgpGqcZxG6ecoGAJ4Sud?=
 =?us-ascii?Q?0fBYqVRbZDlAAIbsN3aLDBMzURLwqV3FK7R6FNTOqDFTr48jeNEUtSA1FNQY?=
 =?us-ascii?Q?eQ6bJxPQ1uq/sdQJxmoHXU8uYa20YyLf04HxJ5lyfUbvpvynW9pkQQdpUkLH?=
 =?us-ascii?Q?U1zGTKVaC63qeRDPk0klzvE89TlTF4pykRds5Ogf3/A3mWiM94XoznAK4P2u?=
 =?us-ascii?Q?jtxcNNpAXfDlh/2x/echCFrzOPKYyKhKJ4tJ9XhLsdq3SWZR1QOA4qGl3wVo?=
 =?us-ascii?Q?7y3a4HxFDRnBBmHgqoSzocHJ5mdY+Vt0BWi8StOXsn7qCZ1BCDifxGnIwxgG?=
 =?us-ascii?Q?7t91Ey1orh+HnQjX1eEdjCDewapDmkIijgt4rZT+HnUEED7dX0gSsKevALOa?=
 =?us-ascii?Q?OhdmX6oYOPl4NHytGwz3vFUgIF8z99GSGzooyMi1zwm+C03f+prpE+Y/gGGx?=
 =?us-ascii?Q?ojlFb9ZJ2j+a+NsehLL/01rajVNEOaPeuJxQe/MmzFtN7IvKJCKUJw3HQTUv?=
 =?us-ascii?Q?6LMj6KGfszW/HD2ipddgHBDqpgF7WflfGOu4zoLn0aHW7tzPfwr3lFxxJEt1?=
 =?us-ascii?Q?9sFHGQesvYpJ+jcpzIpRfoAvOu/RKsi7Gmhvw4QbRyzNUSNsubC5MVK23c7e?=
 =?us-ascii?Q?XpyNot5PhFiYX9PoDEeTIphgimlZUGINVk6Kl7R//LrSrAlzc+P3zsI5JmpR?=
 =?us-ascii?Q?RmGBGCtakycTJaniuZsjRZgkY70y4zJrrYnqSlnHHrYNR83ZOAxDmm3mtNwp?=
 =?us-ascii?Q?+vXZL6P1pmgN8b8rgC3fEZlcX4iT?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jTCzLDXxZ6B4w0Bob5MrT2Z0C494sjUK24ajTARjUFJaD1o8ILiSjh2RoLQI?=
 =?us-ascii?Q?sKvxbQhFf/mW/GYdJNuFijyZPuQRIyPm+QJx8/VEkjCssfkotrgr/o602m3d?=
 =?us-ascii?Q?Co6YhnlFbjyCC5hK0QjQvJUCcDZtAqpCBP6IDwft1g28joXUiogzapWPmzHd?=
 =?us-ascii?Q?ldzDhmVUW4WAe5al6kLS5vglH2+vp7X7XNWKNiQ8uBvxE2F8InKfKm+Ztx4Q?=
 =?us-ascii?Q?q3aOcr7Pu6cdIQl7JDMVadaDdP8Jztn6GFr+DTWyALuvcyM4Syw8D+9hQzN/?=
 =?us-ascii?Q?6fQay4dflyj2Gysozb2XiFdvYOmYNzqbYyT/Q7Y6BQxSmA8y5+GI1xM48+kP?=
 =?us-ascii?Q?yARijI18zF4HQGy4SuBuWqOsoPQwax2baOEq0KPUWJ0TsHCyUImd1CypG5Fc?=
 =?us-ascii?Q?xeF08grfZW/GPDofZeUq0uuloskctgixO2Z3JqHh1VSqPT797DYLSB1/q4a5?=
 =?us-ascii?Q?7xBy59QBclNqeCv2w3y7jUO1wpQxV06p0BSafdsZUHR+wbDdKGMOKu0hwPx1?=
 =?us-ascii?Q?rLoh3hoTItyXHTIjS4wMIFIty1T/0UbZ7jppSgcyJWOep3EzHHVD5zMELzjy?=
 =?us-ascii?Q?dj/5UDIQNbuzUdvRIl7Eqtqr7f13uTSqdLiACrDtYwguGhSBiuWgK3+e8VGz?=
 =?us-ascii?Q?vrdkTzkRMRVRZIl73ESCxxkZRqqD6TJ6tj71gux9hlCZacJEipzhDMroeihz?=
 =?us-ascii?Q?XFpKSs8eYAbYjNN3/iJ3Xo/0ZzUG4TN2Uo/0QIYBLjmwNVmIHa4TWggm0B46?=
 =?us-ascii?Q?kjji+NTvpFSzycFxmgmVDFv8wGtok4DrwL7/JtxAAF9zqE/MVEdjqGSeP+v4?=
 =?us-ascii?Q?6mg5cZ9zRPbrrnXe296RWn2v2B9pwMk1sE3I+ci7ksUb3aJBan8vcjRr8sQa?=
 =?us-ascii?Q?61vHcXduLuDe6hP5gUiwh16s+Z0cmDt9kXizpcbM7gyMfVFg9gO+8mduJA8W?=
 =?us-ascii?Q?MMsb3pPjS2G66B8zErCIJ5b0KTzcWp/jUeY3m+l7h3j2ekaU065D6eKClfmN?=
 =?us-ascii?Q?gEsdvoN2qx54NLOQZfHR5jIURGGXbUC7ccz0Kcy5OFYI9SjZcP5HW0Ndsjb/?=
 =?us-ascii?Q?pSK6DQdE89n8+4zory6X6ufn4AIu/Ks1A8VKRBYg6wXQBZlzDpIPL5ZxZJbE?=
 =?us-ascii?Q?2FaNMh+zXNAdjr8paYcMs5XSuT9LZhuNzHDN6b7RsYsty0fgQBy1tLj/rWMc?=
 =?us-ascii?Q?UViA7JHuhGu8RNAqtA1ndiPn4V1bPLaSwbOGokDQtuzLKqmx9vDvqaZ8Lk7+?=
 =?us-ascii?Q?VEhC83/hMfTAwVBGHEyUP1VbsNN1uz1VP888JT97TwwkZ6EEjB1xG2yDURbc?=
 =?us-ascii?Q?52lz+xLBjZvVKl7XexhDoIA6svn8xB8oCh1mRN9nCUBVgXxI2EP/nMq03oy1?=
 =?us-ascii?Q?+0/c3yJpXGKydZuHAWw+1dP1CVKsDtaLry8Rg/o4YOMWsqoB3x3Nmm2N7Yok?=
 =?us-ascii?Q?/ePxhE3JKI12PFIbFkNtIdtxcX6gP2XtBCf/hvP/ttfT8e/ciJ1qxQrjEhLb?=
 =?us-ascii?Q?a9cT+JU/94uHdNIO9z2ZMbuWsWnU7/SVMcZM4vHGDruCATtYTh2DFYvALTtE?=
 =?us-ascii?Q?bVfdpc+s9fnSFuC2fP0+n62AD3l7fivCYXUUauZZhk7CD7F6Pyk8siTmn267?=
 =?us-ascii?Q?yp8Y0absSUR2JMVxjVHw0nhUk7eAkwPW0hZ4kNp0+OX/ECvQS4CrHe/y0YCJ?=
 =?us-ascii?Q?omRbhA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JVmtxmxSjRP2bPM75tvsAaxlp2nA2gBsN58sDfVX6Ss2Y/BfolM3OJ+L4d63Fg2ldqOSeZCd/VK26tCRmIDEzY+s9/1pk0EETvPWNalEZdCRH2XdcQ+kWZb1D1kJ88BX688q+3G4xX8LxQFjBDvIA6gYYpt7hPh6sI0eQOFO+r2zXKzJmySqwoTfC0FxLnooTwcIJOrCg3EsZ7odu2jnAnouhU3a+MWJSo9l9QKLskRuA4z6TaTuDzykaEwVAK4WukW7hJzxWj5IOkfyz6hxIb+mk1JTFl9WVG3xfQKAVl9CFtzW//8EE2q+4taxezAy8xNy+kevp5WYdYbZm18zqdTMh+hj3Hx0xx4IFXehgZii+L0bkF5U64jmoNr1MbbWWfSq5CZophDRJO4KeKzd8hfbUlg/EJo166Qkdzp+rQeXb+nykk9t14kMo9tQKZVWusf7uezobc/Qjd6256FCWONOK5TORWqAI64JkKMCyVS4ehgwINLSCagSAetFyyMfYFJLJl1HYt8LQ/6cOqkFdVIhTM83YyWy8xLuK1GOmCTGx9m1ZxwgcdpQI/G/YaT8HcqWB7SfDrD20sy8pgGhifeJW3eD1JrFRO+f+rMeihY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc1fca48-14d8-4893-b6d1-08dd1f98a089
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2024 19:17:34.6596
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I41BBlTqJ3esOdDS1taaeYf9HE6b3Mm9s6/f4TlLiWnhlEFLCtrLRh1yCks6ITJbn38lU5Qs7/jDPrSF/pn8VShs4tdxorcWjSqhCWQwJOQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR10MB7673
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-18_06,2024-12-18_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2412180149
X-Proofpoint-GUID: eW-oX5djLEKY0fhWtjaqlsHsha13Wp2T
X-Proofpoint-ORIG-GUID: eW-oX5djLEKY0fhWtjaqlsHsha13Wp2T

From: "Darrick J. Wong" <djwong@kernel.org>

commit 00acb28d96746f78389f23a7b5309a917b45c12f upstream.

[backport: dependency of d3b689d and f23660f]

Move the two public symbols in xfs_file.c to xfs_file.h.  We're about to
add more public symbols in that source file, so let's finally create the
header file.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_file.c  |  1 +
 fs/xfs/xfs_file.h  | 12 ++++++++++++
 fs/xfs/xfs_ioctl.c |  1 +
 fs/xfs/xfs_iops.c  |  1 +
 fs/xfs/xfs_iops.h  |  3 ---
 5 files changed, 15 insertions(+), 3 deletions(-)
 create mode 100644 fs/xfs/xfs_file.h

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index e33e5e13b95f..b9b3240a3c1f 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -24,6 +24,7 @@
 #include "xfs_pnfs.h"
 #include "xfs_iomap.h"
 #include "xfs_reflink.h"
+#include "xfs_file.h"
 
 #include <linux/dax.h>
 #include <linux/falloc.h>
diff --git a/fs/xfs/xfs_file.h b/fs/xfs/xfs_file.h
new file mode 100644
index 000000000000..7d39e3eca56d
--- /dev/null
+++ b/fs/xfs/xfs_file.h
@@ -0,0 +1,12 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+#ifndef __XFS_FILE_H__
+#define __XFS_FILE_H__
+
+extern const struct file_operations xfs_file_operations;
+extern const struct file_operations xfs_dir_file_operations;
+
+#endif /* __XFS_FILE_H__ */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 535f6d38cdb5..df4bf0d56aad 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -38,6 +38,7 @@
 #include "xfs_reflink.h"
 #include "xfs_ioctl.h"
 #include "xfs_xattr.h"
+#include "xfs_file.h"
 
 #include <linux/mount.h>
 #include <linux/namei.h>
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index b8ec045708c3..f9466311dfea 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -25,6 +25,7 @@
 #include "xfs_error.h"
 #include "xfs_ioctl.h"
 #include "xfs_xattr.h"
+#include "xfs_file.h"
 
 #include <linux/posix_acl.h>
 #include <linux/security.h>
diff --git a/fs/xfs/xfs_iops.h b/fs/xfs/xfs_iops.h
index 7f84a0843b24..52d6d510a21d 100644
--- a/fs/xfs/xfs_iops.h
+++ b/fs/xfs/xfs_iops.h
@@ -8,9 +8,6 @@
 
 struct xfs_inode;
 
-extern const struct file_operations xfs_file_operations;
-extern const struct file_operations xfs_dir_file_operations;
-
 extern ssize_t xfs_vn_listxattr(struct dentry *, char *data, size_t size);
 
 int xfs_vn_setattr_size(struct mnt_idmap *idmap,
-- 
2.39.3

