Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C1E14D283;
	Thu, 12 Jun 2025 01:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749693444; cv=fail; b=ie2SObA1W8Fj1Fvg2l0z0OcnPMOPMVn2A3IAeeh8JAmartfqqlhIyNFRbUYRzVa7de9nRuYTaTqX9LzfTR54SxJjRmxZ86xijwUMAV3PYnJJ0wUPhWiMm2WhDdEJAcgAZhIz7KGmQO07+IXO/1GWUzBhTO51wPBwIpaSYNEijH0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749693444; c=relaxed/simple;
	bh=1fPtg7yD//w5o47tYFxdrIZiBhWGC0FUiVjXc5sjEzs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EyUjorFhZw0ENsqXn8PY7F5fdhIoTiQmjOWRyOkbJDGg16IKNcRe9RDJuqNFBZonmYjhogbDj59QNfnf/z6i/YdD9fLCege1Kuz6autkhUFSOk06AdLXINvrKxKd9k12N2YUeGRbMEX/bAB8F0z1mhZuMHNKUSJJbpWaUX4rZ3M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Cd83R3qQ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=gLmPTkWu; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Cd83R3qQ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="gLmPTkWu"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55BMPKbn016899;
	Thu, 12 Jun 2025 01:57:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=7OeM0pjTSUvmTJvSY1agHPz4EYZRHyuTL75VotYeYmY=; b=
	Cd83R3qQslcjr91UmdwIWteI1DqwvVPo69gHGA+TvHZzBiwONe5o5zOllrfYoAEI
	WNvSCT/uRvsgTwJj/58f7RWyOFB1NicnacfFoXl5RfjYKSlwrQi27hs+lcokbWEp
	lYHhr282Xs3jiv2JGWBweKYDlL7VGNFxZISv38m4ZjCbXZjam5t6TsRQ1xBsf1NG
	cnv8O5rrw1PEcCm+GyVu6JaKRPkz8gPYbbGmJnEB1RXsobaVWpRFc9ZaVShOlop4
	pC89jpyAN7T6VYJgXh8lmZEwfVZ3WBy6gGuOAq2fhJlirTKSPVDZetrys2IVD1OV
	suZchrehxY3lK3hiVD/LCA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 474c750t83-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Jun 2025 01:57:16 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55C12po6003202;
	Thu, 12 Jun 2025 01:57:16 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02on2043.outbound.protection.outlook.com [40.107.212.43])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 474bvaywnh-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Jun 2025 01:57:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HeQpB1Pv4Me+D0uFwAmM3wHZECa3KBuczeY/pB+GGoij4GZ3rMH0tVxBta1JZl8PTUZG5ies3XxZWTeiPU33sIKTjZsHoEkD0j5jVoAEE321fvuZa4p+Fhammfb9NUnuzJ7ragLyi+sizGhrc/94rQyToZIwL7hkhE52DIxkmL9hIGxQ5W+5jMF3w3S1ceqH6pJnBtqhW1hG0eIJWvEbKDG/chYtF6h0YgD8BqYzxk+5Ksgi3P2ctElaDByJSm5nbZ/IsFOjZ6KIL5MsJiTrGOA73cxPBj09mVF9KT7aeMJWO7U29CdCVAR+f6Y4ORW4WiYaMynQf1GorkT2VTIiHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7OeM0pjTSUvmTJvSY1agHPz4EYZRHyuTL75VotYeYmY=;
 b=EiMMbCIWKqmMjAAvR415CJ5/3cwH8TPCy4wiSs1fXDyW8oUhsffWKQLTShnw5l22TMtpjWKYQVgy+cNt7TIgc7Y6Rqqylw9mOYcYWrFgG3HJX8N3lwGE3MHrXQxv1f9Qb4xpkJc4wK6McZAr93MzQ/jkB7i+h/iSI9lBBU+feWSQmGU34miRYVSyf9Jrj0LmV4LLUWIP3r7ZgmppGWVpePWLQrKvVSJXmGP17anP+XwQMG9QGScIDmVTC38Lj7R0jgZfTOuj6bX+cvOQpDQ9Pxfq6a4Gn411/hMo6IPxGkC4IqrIynJOKjRpAKcXFRq3wzIk97q+RDJLexyVJZVMKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7OeM0pjTSUvmTJvSY1agHPz4EYZRHyuTL75VotYeYmY=;
 b=gLmPTkWuTtEz+3LFFrr+tqP158Z2vv746x0mNGbYLMc0D6FLQYEsr6RlbFnVoediI6RNWQPP8JKVqpX+oUvbzhRgSOKuSgGPLLlmNgTuK2nRvYvF4NqGewVmrEhbABycKzQ5eHcIR8s17WdumH8M0IjpmpxDQuLWfMAzrEJOMzc=
Received: from DS7PR10MB5327.namprd10.prod.outlook.com (2603:10b6:5:3b1::15)
 by PH7PR10MB7839.namprd10.prod.outlook.com (2603:10b6:510:2ff::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.25; Thu, 12 Jun
 2025 01:57:14 +0000
Received: from DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::43e7:5b82:9069:b402]) by DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::43e7:5b82:9069:b402%6]) with mapi id 15.20.8813.024; Thu, 12 Jun 2025
 01:57:14 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc: djwong@kernel.org, john.g.garry@oracle.com, ritesh.list@gmail.com,
        ojaswin@linux.ibm.com
Subject: [PATCH v4 3/3] xfs: more multi-block atomic writes tests
Date: Wed, 11 Jun 2025 18:57:08 -0700
Message-Id: <20250612015708.84255-4-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250612015708.84255-1-catherine.hoang@oracle.com>
References: <20250612015708.84255-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0020.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::25) To DS7PR10MB5327.namprd10.prod.outlook.com
 (2603:10b6:5:3b1::15)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5327:EE_|PH7PR10MB7839:EE_
X-MS-Office365-Filtering-Correlation-Id: 50869b95-254a-43f1-3a43-08dda95473c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|10070799003|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tGKqcRS9kIpRJqXcgPlbbcHxe52zNVOKZHKz9aIi6+G0AeZWJ0qm334fc5iO?=
 =?us-ascii?Q?XMMhYuluvpEx0yzNcIl+ohLthchK+2glu5KVGqNH28gIWupTHCUksI37aZzu?=
 =?us-ascii?Q?yMnexc+OFBGZVWseRynOdY6d+EBKVHftO51WHIxVXFu7KSAmlmytZ6NzeFuQ?=
 =?us-ascii?Q?rUTgCcGSTAO73D4AcU+fEzRYQxcLBe86djhwu6g6MIgs53RuRQB3rF9Cy6UY?=
 =?us-ascii?Q?teeA1T1LIjc10Y/fNLrYAVzIs8OnIDxvaI7Rv34dMO5nNhZ0XGrRNbSvJ5GE?=
 =?us-ascii?Q?1lEy6q5y7hYo5eJ4pZawc1dO7QdhpXQnjmPCsepcABWK3hGosXRETuBM6PiI?=
 =?us-ascii?Q?rD9/+WvuR93xxk6YoU9pyjrHXnWCO5YSgkLMqL2gBfVgRQpirXLKiOmTY51t?=
 =?us-ascii?Q?3wXFmGg0dwHl4EhHTTMGbmRawfpfCstzL6WItEwBzGjWYWHRcAR8b14xDmv2?=
 =?us-ascii?Q?3RSmV3STN4BM4kvZc1DIIqordqurgMQt0uEyOMibhhMGqHzs97MudU7S/46h?=
 =?us-ascii?Q?/6/b5g8TarnXNp3z9MENv+ly/HoaDvrbp9CajS/rVX5MQYAurgcaZklZcDRI?=
 =?us-ascii?Q?T0RRAqRaTPd6TwjXYbZDH+aZIR3VOHf8FEcVTlGxdlQfTqL5VGS53fS3UQC8?=
 =?us-ascii?Q?FMdcZYTq137ibhfFXwoweiRTdbY4GvyNt3MXbev6zOV7UKW6Kgi1EQ9qxX9P?=
 =?us-ascii?Q?xOaD6i3/QXp6Jg7PMRYgtoAXIfmWU0MYcplURW5ss7G393cMeBDjSAHFgAUp?=
 =?us-ascii?Q?Fry0wW7wKgiYJWFOX9PLy5nEIFGnGHVbtre5qubU5TTzG6S3Yh2R9ipfCOTA?=
 =?us-ascii?Q?k5FWHooDcVLFu1BDSjLa/5UUc7LKIULx5W49NuETdELlnv7uEdPiUUmNeBK/?=
 =?us-ascii?Q?0wlL3S5QKarSr+v9qSXMt03UYChx/1Y+IOTNsoiSV5GxAJCGbfI7N0mDnLUy?=
 =?us-ascii?Q?EeJZ0xf2b2fewjA9Dp6qXaNUOJgj72sHzIqSPV5dfTBtWGPbrW7YSlBqbggu?=
 =?us-ascii?Q?XHIj5TaoBKQpRXVMHJgI+HQGUnxbX3AzJmMX94kWRZub15aMhk96F/cLjwsy?=
 =?us-ascii?Q?y4yFvt94J2zYr4vGwNDDgn9gyMhwk8PWiFwsbOJ03Wv1jJkXsYkAob+3jmrH?=
 =?us-ascii?Q?QmdCYKffUQlC6l2kefeyYZ54KRYxs/8Q50U9p9vq135cN7DEJFeKDLXe1n4A?=
 =?us-ascii?Q?PrYOoUCR/Yn0wNupZKH0abWcN/QsfirE7hIney4IfQSkfnIQj6fO8HCx+gJR?=
 =?us-ascii?Q?BzUZphPKMRwWbPmwFhZH3Yh7gzaLqMy76cimm8ONdTDN9b5rOmLoP1zNFY4i?=
 =?us-ascii?Q?axr4E+tyvCZuUYMEn42ZfpBDH0afwbfU8mieaQZgjX9+bdvm9zE1Xe0mcJlK?=
 =?us-ascii?Q?bjL86xXSqvU6oiyWFvTWGrtfzVIpY618BWcMc0aY2+KDsbLDjMLHjnXwhsUA?=
 =?us-ascii?Q?dpHW6t+xuKI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5327.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1q6qJLuMbmQPi+a1Ynqsq1vVoRD9FJHPTnip+NTYnlGo7RzDGjjhPkQaVVXG?=
 =?us-ascii?Q?ZyzADt5r4WNIbHZCAKW6WkNUoKJddF62A8m44zkDJSErtXOjhth014j+FcZr?=
 =?us-ascii?Q?8EpgUVu//HH8TL2uvhawOyelHvAe9qtenrJNpEAQj/3MndN+7sQzFddZB4c7?=
 =?us-ascii?Q?i3Z07Ft5163MgeOdw0oHklw+KP6h+s1wk6GbaEOmPgXWBAWv5KziMr5ulyjt?=
 =?us-ascii?Q?sqahfzHwF7E0yGz/EHwL6/aRnyTlhfJskVt+4uAELvy9hYBnKvu0+Q0J3cXm?=
 =?us-ascii?Q?BsmtCO/lETwNrThL+Z8ouup+v7NS5/PUaLk6f238ObjizUByrmzVxNEQhetA?=
 =?us-ascii?Q?yU4rbbFYZHiCqRnf6JwuoxvREhH6CXWz0xbXGQJvmwXLUe2JT/SZYea8LIRx?=
 =?us-ascii?Q?QwW2VB1FLqdnYLjR58qMaCXfBg8XQ2LieQ4Y7u0YQehlpiOSk5VF5ddshS70?=
 =?us-ascii?Q?OMEcyoHhxLLjCBwgp7BR+3FSLAO/GKuSqM9NtwH+fAos+a1vSv4zawm5Fs/U?=
 =?us-ascii?Q?bY73BzmZx8H766Eqpb05Ukl6jKN+duTF4npfhAR++PE2NoOagPFMExRYC/aR?=
 =?us-ascii?Q?oM5w2Bu6m7coXYErFI0fdAeK1iacPYZFjhUJWye82cRpxoZFKj5YJaQFC7Je?=
 =?us-ascii?Q?vIz1055EAgu7BGBNCRqzP7AgQtHa62x3iePIqirMomr5D0iC5+hIe7TohETM?=
 =?us-ascii?Q?02Ok23+AULJldv6QDbPYArA/+p7/Lm0J/6okYaS9qfiuPpJRk7dDClHBOMzM?=
 =?us-ascii?Q?NPFcplkwJ80Ds/HGNa0pe9dxDz2ILuOC4bS5TnxiGggtnBK2n8031frEuxBm?=
 =?us-ascii?Q?HZY9k1E+rCA6Rf6BWWz6RQkjeU1xanlRMEXlW1dquoq6H6p41Or1KEZUs3ik?=
 =?us-ascii?Q?en+Q/WhiyHfK7UfuhFLKug4GDL+N0+ZOSzEMZJI8liIkOFuXSZ4gcAyOeN7I?=
 =?us-ascii?Q?9G7EzxGr0ypnIuavEB+SjWdrfepTJ3ya4k8QOaSvM6akKkFthn8GyWuGbFWj?=
 =?us-ascii?Q?UYgtb5WJhFSthCLVDI6mRRuh5odGcgCBtJkOr3pFzy7ZpHzUtglmZ6O2eTKe?=
 =?us-ascii?Q?TuL2hqY3J2qN1qPvotouH5GjhSk7fZlmKrwAyBot8T8uSmuqNUKSncSDIs0J?=
 =?us-ascii?Q?E+sdmmqqoyhy4ln5+gECRAubbc3l6/eGGBus+XOyZ4Qt5HPk8a7FLEiC+l1g?=
 =?us-ascii?Q?cU1Pjo8IZqsndGLJ6i1WDsNdgpVe8iA1lYZhWEeRp0tEwDUvjVMcwbAC6MyH?=
 =?us-ascii?Q?fexWgEmwnV38eCh/VzhuwGc/Sv6wNHpr+zLjc1vjMaKUApWFfdPb06/JFfOU?=
 =?us-ascii?Q?iwoaF4wb1axPo9y4dnsjPYuqmuvGuCo5OYnWD39Mit+ZPUhOzGU3cL+7/kuC?=
 =?us-ascii?Q?ggM1+cgk05tU3XpGdT88vlm0+osXknxTI8zoePWeKGUyLbvhYCV6CHlIq682?=
 =?us-ascii?Q?XVv4dL8UqsfENpNR3nVXsxH3acIOoE24u21mxZ8HG7jCPLBPCcIk4/SwXu4D?=
 =?us-ascii?Q?ZexEhosl5jttHCSuZtbvALxF1Q/7XdM0xsTfe4MD6n/n/MegZUtXQc7nUcSt?=
 =?us-ascii?Q?1T8h4N33GCm8pfQnzA+aanp7NnfZkxb/iuCVXOUTerpWfxclal898G75GQWU?=
 =?us-ascii?Q?5qopluNI8d+qBFUKwkgtKIAele9HcAQnkLwY1fdaTeSd0QznWpuer543Kz/P?=
 =?us-ascii?Q?YI/NSQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	McRyicvNQM1Ls/34WO0ngKj07E6DyB1r//WpbTA8pxnd47XaHY5AUj6GAhgFjtweMsFVH6caqDdxi1s8aOqq7S85N6CJ9vV+7NuDJP048WRzt5WnyNxGC3jCvyGtUCezwsNilPp5u+di+mbFuCdGSzjrxy7bOnvuQ+ZWPl9iwLxycstWeOaFOuFrS0WmCmUtf2P5orZEyVNy9N1jGZaSs9Nm9n0qsLE4p6cFuVXFgbC90CHaK8/N6C/dGGuqq8NBg1MSyNhbXiGX7iqmJJXqhxgQ51sETj92x9h8U1SsqFAnDwHplNLbu4briIf1kASOwZyP6iY42DoWOnfnjqahcuKelC4qFtSHDg1suulJd0Um3hEFRsmrbQy5Wnl58EpZRdFKPNE0mKAgzwnPiBURav6DglTe2z88DwLXCXwrHG6Fd187lJj+jxWQNLSXs30TfGqW9rYp1anmmgX7LuisP8TnhvIgyrPv3Y3kaiWY1livHa5Z8FzEmEWLOW7sqrhq7sXn7o+ZCJgtu2M+9cG27pFeEFwJw/xM6HzFM4/qhuIUKe3IBT7NgF8qPDdHkdp6kSCXZkJfYY70tNP4cFSKf8Y8zmzACiGmR4HNe2jvya0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50869b95-254a-43f1-3a43-08dda95473c1
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5327.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2025 01:57:14.2675
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l0Vl2Hcm0KWokbEBZU8z0rBxJYtKAvrhtV0ssF35WODKt/9VuwX8gHgbEQwJS03YWHjPq8yyFoS3cudOmdT6bAeZSnq7bnWEQALLje08PJ4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7839
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-12_01,2025-06-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506120013
X-Authority-Analysis: v=2.4 cv=LIpmQIW9 c=1 sm=1 tr=0 ts=684a33fd b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=FPzu-_wniR3LNvefyx4A:9 cc=ntf awl=host:14714
X-Proofpoint-ORIG-GUID: kBccv8Mx4bl7jqzmUOqChfvDzKNjlw7-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjEyMDAxMyBTYWx0ZWRfXxkoKOkfrkfnb iQZ3UHkbSWO6eOoC5UTN+mbh21dQlaiJT2JAfBjrkD3nSz4jpVcBDYCajU3kQGfs3D1h9g2atv2 KeZw2MxVXqhBp7KDzSpXy5P4rQ+e21M5egpKPMNiifZM6b0PykuS1MpgjmcvAeFTl4slpgdbPjp
 ab9S6ELIofOtpTt1fTw2qk17nDn2ZTdJcyZURmZvUNC1cqFlx0SLNV7rs/YKEbpKmRLaIN4i53b mDZsl7h1XpeNCed+C5KSedRrmDYeswheCYkRiq2eFKCRRA0AgUH5suteZZ88MUsVMYKcijM/HmG N5MAM8glHBpxxVIaCi+Jgg5KpuQQU9seb55R7tQBQgjxQGbPZkqbp1lt2bxNtXuS10H82yd6qeh
 Wt+nEFF/ccrf4zEYis4lshOfR57vjea87lESrGUsMSTNUkaaAar7EAs1McEFRXHmhTJt7Zkk
X-Proofpoint-GUID: kBccv8Mx4bl7jqzmUOqChfvDzKNjlw7-

Add xfs specific tests for realtime volumes and error recovery.

The first test validates multi-block atomic writes on a realtime file. We
perform basic atomic writes operations within the advertised sizes and ensure
that atomic writes will fail outside of these bounds. The hardware used in this
test is not required to support atomic writes.

The second test verifies that a large atomic write can complete after a crash.
The error is injected while attempting to free an extent. We ensure that this
error occurs by first creating a heavily fragmented filesystem. After recovery,
we check that the write completes successfully.

The third test verifies that a large atomic write on a reflinked file can
complete after a crash. We start with two files that share the same data and
inject an error while attempting to perform a write on one of the files. After
recovery, we verify that these files now contain different data, indicating
that the write has succeeded.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
---
 tests/xfs/1216     | 68 ++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1216.out |  9 ++++++
 tests/xfs/1217     | 71 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1217.out |  3 ++
 tests/xfs/1218     | 60 +++++++++++++++++++++++++++++++++++++++
 tests/xfs/1218.out | 15 ++++++++++
 6 files changed, 226 insertions(+)
 create mode 100755 tests/xfs/1216
 create mode 100644 tests/xfs/1216.out
 create mode 100755 tests/xfs/1217
 create mode 100644 tests/xfs/1217.out
 create mode 100755 tests/xfs/1218
 create mode 100644 tests/xfs/1218.out

diff --git a/tests/xfs/1216 b/tests/xfs/1216
new file mode 100755
index 00000000..694e3a98
--- /dev/null
+++ b/tests/xfs/1216
@@ -0,0 +1,68 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1216
+#
+# Validate multi-fsblock realtime file atomic write support with or without hw
+# support
+#
+. ./common/preamble
+_begin_fstest auto quick rw atomicwrites
+
+. ./common/atomicwrites
+
+_require_realtime
+_require_scratch
+_require_atomic_write_test_commands
+_require_scratch_write_atomic_multi_fsblock
+
+echo "scratch device atomic write properties" >> $seqres.full
+$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $SCRATCH_RTDEV >> $seqres.full
+
+_scratch_mkfs >> $seqres.full
+_scratch_mount
+
+testfile=$SCRATCH_MNT/testfile
+touch $testfile
+
+echo "filesystem atomic write properties" >> $seqres.full
+$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $testfile >> $seqres.full
+
+sector_size=$(blockdev --getss $SCRATCH_RTDEV)
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
diff --git a/tests/xfs/1216.out b/tests/xfs/1216.out
new file mode 100644
index 00000000..51546082
--- /dev/null
+++ b/tests/xfs/1216.out
@@ -0,0 +1,9 @@
+QA output created by 1216
+two EINVAL for unsupported sizes
+pwrite: Invalid argument
+pwrite: Invalid argument
+one EOPNOTSUPP for buffered atomic
+pwrite: Operation not supported
+one EINVAL for unaligned directio
+pwrite: Invalid argument
+Silence is golden
diff --git a/tests/xfs/1217 b/tests/xfs/1217
new file mode 100755
index 00000000..f3f59ae4
--- /dev/null
+++ b/tests/xfs/1217
@@ -0,0 +1,71 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1217
+#
+# Check that software atomic writes can complete an operation after a crash.
+#
+. ./common/preamble
+_begin_fstest auto quick rw atomicwrites
+
+. ./common/atomicwrites
+. ./common/inject
+. ./common/filter
+
+_require_scratch
+_require_atomic_write_test_commands
+_require_scratch_write_atomic_multi_fsblock
+_require_xfs_io_error_injection "free_extent"
+_require_test_program "punch-alternating"
+
+echo "scratch device atomic write properties" >> $seqres.full
+$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $SCRATCH_RTDEV >> $seqres.full
+
+_scratch_mkfs >> $seqres.full
+_scratch_mount
+
+testfile=$SCRATCH_MNT/testfile
+touch $testfile
+
+echo "filesystem atomic write properties" >> $seqres.full
+$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $testfile >> $seqres.full
+
+bsize=$(_get_file_block_size $SCRATCH_MNT)
+max_awu=$(_get_atomic_write_unit_max $testfile)
+
+test $max_awu -gt $((bsize * 2)) || \
+	_notrun "max atomic write $max_awu less than 2 fsblocks $bsize"
+
+# Create a fragmented file to force a software fallback
+$XFS_IO_PROG -f -c "pwrite -S 0x58 0 $((max_awu * 2))" $testfile >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x58 0 $((max_awu * 2))" $testfile.check >> $seqres.full
+$here/src/punch-alternating $testfile
+$here/src/punch-alternating $testfile.check
+$XFS_IO_PROG -c "pwrite -S 0xcd 0 $max_awu" $testfile.check >> $seqres.full
+$XFS_IO_PROG -c syncfs $SCRATCH_MNT
+
+# inject an error to force crash recovery on the second block
+_scratch_inject_error "free_extent"
+_simple_atomic_write 0 $max_awu $testfile -d >> $seqres.full
+
+# make sure we're shut down
+touch $SCRATCH_MNT/barf 2>&1 | _filter_scratch
+
+# check that recovery worked
+_scratch_cycle_mount
+
+test -e $SCRATCH_MNT/barf && \
+	echo "saw $SCRATCH_MNT/barf that should not exist"
+
+if ! cmp -s $testfile $testfile.check; then
+	echo "crash recovery did not work"
+	md5sum $testfile
+	md5sum $testfile.check
+
+	od -tx1 -Ad -c $testfile >> $seqres.full
+	od -tx1 -Ad -c $testfile.check >> $seqres.full
+fi
+
+status=0
+exit
diff --git a/tests/xfs/1217.out b/tests/xfs/1217.out
new file mode 100644
index 00000000..6e5b22be
--- /dev/null
+++ b/tests/xfs/1217.out
@@ -0,0 +1,3 @@
+QA output created by 1217
+pwrite: Input/output error
+touch: cannot touch 'SCRATCH_MNT/barf': Input/output error
diff --git a/tests/xfs/1218 b/tests/xfs/1218
new file mode 100755
index 00000000..799519b1
--- /dev/null
+++ b/tests/xfs/1218
@@ -0,0 +1,60 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1218
+#
+# hardware large atomic writes error inject test
+#
+. ./common/preamble
+_begin_fstest auto rw quick atomicwrites
+
+. ./common/filter
+. ./common/inject
+. ./common/atomicwrites
+
+_require_scratch_write_atomic
+_require_scratch_write_atomic_multi_fsblock
+_require_xfs_io_command pwrite -A
+_require_xfs_io_error_injection "bmap_finish_one"
+
+_scratch_mkfs >> $seqres.full 2>&1
+_scratch_mount
+
+echo "Create files"
+file1=$SCRATCH_MNT/file1
+touch $file1
+
+max_awu=$(_get_atomic_write_unit_max $file1)
+test $max_awu -ge 4096 || _notrun "cannot perform 4k atomic writes"
+
+file2=$SCRATCH_MNT/file2
+_pwrite_byte 0x66 0 64k $SCRATCH_MNT/file1 >> $seqres.full
+cp --reflink=always $file1 $file2
+
+echo "Check files"
+md5sum $SCRATCH_MNT/file1 | _filter_scratch
+md5sum $SCRATCH_MNT/file2 | _filter_scratch
+
+echo "Inject error"
+_scratch_inject_error "bmap_finish_one"
+
+echo "Atomic write to a reflinked file"
+$XFS_IO_PROG -dc "pwrite -A -D -V1 -S 0x67 0 4096" $file1
+
+echo "FS should be shut down, touch will fail"
+touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
+
+echo "Remount to replay log"
+_scratch_remount_dump_log >> $seqres.full
+
+echo "Check files"
+md5sum $SCRATCH_MNT/file1 | _filter_scratch
+md5sum $SCRATCH_MNT/file2 | _filter_scratch
+
+echo "FS should be online, touch should succeed"
+touch $SCRATCH_MNT/goodfs 2>&1 | _filter_scratch
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1218.out b/tests/xfs/1218.out
new file mode 100644
index 00000000..02800213
--- /dev/null
+++ b/tests/xfs/1218.out
@@ -0,0 +1,15 @@
+QA output created by 1218
+Create files
+Check files
+77e3a730e3c75274c9ce310d7e39f938  SCRATCH_MNT/file1
+77e3a730e3c75274c9ce310d7e39f938  SCRATCH_MNT/file2
+Inject error
+Atomic write to a reflinked file
+pwrite: Input/output error
+FS should be shut down, touch will fail
+touch: cannot touch 'SCRATCH_MNT/badfs': Input/output error
+Remount to replay log
+Check files
+0df1f61ed02a7e9bee2b8b7665066ddc  SCRATCH_MNT/file1
+77e3a730e3c75274c9ce310d7e39f938  SCRATCH_MNT/file2
+FS should be online, touch should succeed
-- 
2.34.1

