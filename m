Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE5C1D1739
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 17:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727890916; cv=fail; b=kSDVWc00KuBCuV3Gt5gRrOrXqOZ7qfl3VV0Rqo5TmjepzAWfhAzSRJgZYsT63SA/2qwxwmRf89Yr7rMih8ODwLl1e8VE7JGUp24ALHlg6R6immbMbvu4LE/xsTJuRCY6q+ULq8RFOr6skiCBTOsCoiGM1yRtLr3wxMSht+Bet8Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727890916; c=relaxed/simple;
	bh=pTvhCsPdBqd+3suk9JeashoDNVt3VxpLxDmgHu61NwA=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TSNgC0M6uzLsqX7yiUDgS83cA3cPE5DBFKFFdTmOTyrH7mI22zv1p+xJpej2cxZwVywZ07Ehq1oPCCzbsDBRtjxXt7ngvicHFhuBQE5p0+0n0RsPIm/9Ml1EG7D95Un7tBs+CASdch8NZh7nJFNpFKcyPzkjHH+o7QuvEYM1I9g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jQ0INP4a; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Dj7aDCJm; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jQ0INP4a";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Dj7aDCJm"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 492Hfc3P022784
	for <linux-xfs@vger.kernel.org>; Wed, 2 Oct 2024 17:41:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=evKcOv+6Qp/Niv2wKcPN4j9qJ3CTnZ+LcLZCqWEjlk4=; b=
	jQ0INP4a1LTQTT+uU4bwT+mxXxDI8wodIR/ANn1+qwbV7tlI9VQkZnZ2ebynOUrR
	Y4bsrkpTsxAaO/v+peS1Q8OpUrTC29oG2kUNiLUcee1CbxleQgMfuoYjhWpbHXLM
	YZR6WiD7IwXXSfwSMYhz1svbv5oLsZUuuyjelqUaqOq/Ac8SY92uNx4gzKX4ZMOS
	NGCaHdCVea+5i804m2H55G8iZ5LGC/at7SonKVirUt5iDsLUZPKSTtudrXzXQ5o9
	RkMDSQgSVoWx4IwF3GQg554OuS5GJSNcWVuUMmJV7RfEG2rZsvH3HfWJ4ZeAtAmr
	Ps4fqSd/DjTXHrtbnZXQiw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41x8d1j87f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 02 Oct 2024 17:41:53 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 492G3fHY017452
	for <linux-xfs@vger.kernel.org>; Wed, 2 Oct 2024 17:41:53 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2044.outbound.protection.outlook.com [104.47.73.44])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41x88951ux-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 02 Oct 2024 17:41:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UGZlpGZGR+nB+AiyzOfrZAiXCW49N5aHjgAL8Kh7EZQ/BFi6SrE/0ZHXwYWVY0fBFozIdOR5kB9Xa2kJXCM2OORdhQLZ9DL9Hqgs+VIit6bqOczauRn/oCLTy3FPZz02OAVSKGWvxTlOsuTH+zRqWx5LOZGRGyuVEbwLAjAptfOnjf2CDYi7C7Zlat+QfSw111IpOXEexaEC8Mk5EVRL/XdxoBWKCjuMFrkjMUTWDML6g0gqLcgVA1TjMMu34Hp294mN1vNNjG2XgXKxs8xLV2ww8iXC+mwmlgIHvx0oZDEjZBKxOdy5RGzwDZ+NdTn1FTgBesrI5qzmyuFNxMp0Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=evKcOv+6Qp/Niv2wKcPN4j9qJ3CTnZ+LcLZCqWEjlk4=;
 b=HmRSaW3ac5CordqSiLvdijbkg2ZO2RSJFpFP34sG5SwDBfLAhLCJ6qEZLFedGwcnGcvPlGM+0jwKb8Q3nJtChi5Q9vuFZSjbThNuFxJU9Vg83xDngnJ+m4Z4dllYi8F/jUxCq4tDnVWoJvLJbf2o1T11qqd7iSE6xyhQrCFcUeUqqdEed8bO2bH4tOecNL2BEcfgOvy/sQGzmQqE5EQ10JDygKvmssw2TFdFQ042pJQsW/pcQp6omZ4Q0kUPiHbWeAm1GsRNbPhoWB54eyHwGzsYZ5pYlVXvA7w7trsW/BJY4+BEgfrgCf4+wX/G/VZtFOlG6xNLM2Gy6bh9YMZqRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=evKcOv+6Qp/Niv2wKcPN4j9qJ3CTnZ+LcLZCqWEjlk4=;
 b=Dj7aDCJmPMyJPj3d0ZrncIjJdB6D+I95UvGKAfr1p+mYhyCnFnArUpwPs0fCPauxDThR7OOSkSm59x75pcXggyIoIu4jobo7LLI+cXDW8ouKkXIs7qjVQYMhUZUKpQuR6wfpW3MsyGAO9b2taB11xIWXrlwSUGrH3ZxY0Lt/lYI=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BLAPR10MB4995.namprd10.prod.outlook.com (2603:10b6:208:333::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.16; Wed, 2 Oct
 2024 17:41:51 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.8026.016; Wed, 2 Oct 2024
 17:41:51 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v2 21/21] xfs: allow unlinked symlinks and dirs with zero size
Date: Wed,  2 Oct 2024 10:41:08 -0700
Message-Id: <20241002174108.64615-22-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241002174108.64615-1-catherine.hoang@oracle.com>
References: <20241002174108.64615-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0055.namprd17.prod.outlook.com
 (2603:10b6:a03:167::32) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|BLAPR10MB4995:EE_
X-MS-Office365-Filtering-Correlation-Id: 0360ce46-74e3-44d6-a9c5-08dce3097f4c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|10070799003|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?R82Eqdr30gUDL42kd6d5ntUmYre5eYRX63RtzEoYJDfh5AXDDVg7ybhDI/Ih?=
 =?us-ascii?Q?5ObkLR2IzSHCTWah6DM5VMj4D7Ur6esKY3YBWLrDWKgpmd+9nhRNPaj3WQW1?=
 =?us-ascii?Q?gdyMUpyBrAQ0Fv+IllCWV6O8S+Zs/R6F7WbiIAQC+Gqw6g1njRZfEY1kH+RQ?=
 =?us-ascii?Q?dwZtnFJX7+YkG0acAxFOO4OdbNOSWseDCyMOh8vWVunfT+Z+E+8WFZn+40+O?=
 =?us-ascii?Q?IoDWTsqucQ3B7lIhFE1W7oADMjjrasAJlF3fq6gFZfpoN6zzF9UdcDuqjd3s?=
 =?us-ascii?Q?jExJ68+V+jPwz7fL9+WDMQ+v5y7iYg2w9ufIqfO7bwteRIZPstQXN0kUQnga?=
 =?us-ascii?Q?sfCj5wgz36DxIj1loOYLd6MIn6Z3m0t916ACwPh/ESBaGZT7JJ3qptzEtMtE?=
 =?us-ascii?Q?uwWB7P08gYjeV8ldOqjRI6hNyZgwjV2vzXNaMebqIb4My4BLvyH6FN1wmdvp?=
 =?us-ascii?Q?eKjozNdccuvZUnMhx3q2xnUneTAAY6ruEixtmVcCAnsaLDOlVIRAhvqSVzjh?=
 =?us-ascii?Q?CRWuiTedInpP/O1WJ4hqH4o0qBXXE2nUlsFB2vGZ8BZUBYG8O4AKs/pGGz3W?=
 =?us-ascii?Q?SwGpeqGFsMmFCQhU0kr2GPLOQWmwTzTyo9mFb3Ig+i3MS3ZILef2OFMUWEo/?=
 =?us-ascii?Q?vcOPLnkbA7oK/nn9lp/aZggYG03kfh+IXgxYsFWVIU7JGNrflsKjmm6SCljo?=
 =?us-ascii?Q?nFOr546070lLss5Vhp1Eom+Q2tgacTIATxRTob/iQ/NIe59vRiUfkEdC4UA6?=
 =?us-ascii?Q?BBu587sTggej4v91J+Uz4jLkd2uahZbb4nOkRhwyiskcz4UOWo51mI5oNdih?=
 =?us-ascii?Q?jIox+n22HU/rWzDRthj8FmnkkWHqIo4eZZGhb6fyCIwlOanpli4rcjCuqpIe?=
 =?us-ascii?Q?t/yXk2Nk0GrQjsHdbPB01iKhG5NZhEDapbL8/zHEuGT9a6RkiBDL5USuA5ma?=
 =?us-ascii?Q?utNOA7BFL4j8zojmxkdXoCP6rU1jK81RwS+rifpTfaFuJ4UlZoyCdCf+aqxk?=
 =?us-ascii?Q?GAJ9HiSym7d9wH1R0u975GIBowVb6asI9LTqQiIIO6kfqbfzuyqg1igLj2MY?=
 =?us-ascii?Q?VIEXkxCNZlQgDAg6W4zuekB/UjB7Vi3tbN2oDvLRLchCXCzp7wD1lSb1crVO?=
 =?us-ascii?Q?/hVbgOJSf5J8PFouU7jr5/edsPL8Y5+3LCle4v01mmZSPlRJrfuVv1xRwIS8?=
 =?us-ascii?Q?woS3HQbJh1Yu/ywy5POQoCoje0VOhovw77NWE8LEitkhEQfYbeLyKWmEI4w4?=
 =?us-ascii?Q?+0BQ44nLs5GMR1wq/jx8lSWnF4dgryf6wRnshylOCA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(10070799003)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OVf3YhyiCBjbMsTHUkl8rnwSl+i2q8j5D+y+/EFR5ralFw3HmpUzSRVLnbWw?=
 =?us-ascii?Q?vdwpen5v2b/PKGBk1w7rNbvboxN5jUPVsHRyQRxBiqiCHz0JCNwXD8amDLl9?=
 =?us-ascii?Q?jIqYyiH8CdelYT9NCIOct7WAo3+dHFxZDRRO/m6mlOrqvWw8+zw12jRmWhZH?=
 =?us-ascii?Q?CQFpI8WtGOFoZKC21OWpsDm/g725LfBErSwNqCLnDh0xN5rs9LkZJIfkg1EA?=
 =?us-ascii?Q?I74DYXkL7f/0G/j/vqVgBMtf4f5tuBRnEo3eS5kN7S14Izc+PZG/ZTTh9iad?=
 =?us-ascii?Q?yj8jea/h98ORsBh9w6aopJv5tHEa8kxoJUF03E/kI+rwWcBCZngvj/i6+NbV?=
 =?us-ascii?Q?eDGx/ehqSVnvj4UTX3uWHV/IO8Iceuf/96oofQAF3Lpsqo7MTFFHQDthM9KP?=
 =?us-ascii?Q?tsPoRnGgWRvTgS8oMi9PJ/4NNV6v3d7r3lHvkZhJuLe2sE4+srKaBxSqyOY1?=
 =?us-ascii?Q?mdsZBpXMkQ8+g4RUHmBUGhAcmJGIYo0J35TOzbExeJz02Q67uEHZMEkS4GZd?=
 =?us-ascii?Q?+YCfis9f6Zlm28MUpfRUXWrJoeSG81VHCzwUzC9E4BL+u5PGXeKjwLJtgKqU?=
 =?us-ascii?Q?dGoJqg9EWWfrXuVnhA9LM44pVzqywDFZ7S0PUCmHSwx7Nj/d1vGzMutHJkEc?=
 =?us-ascii?Q?iNd2Do0mvZ+GjTEaCZIbXmjLyTAM+AWt62o5CYdR3BpdlW7UJUTXQKoVZaxX?=
 =?us-ascii?Q?OCYcFE3Jlbz5RAqT+uoONJtfXbTKK/EaJrHUImn/Xo4jWmdfZoEghhESTFq7?=
 =?us-ascii?Q?+NvpjUTpmb5mNU3JETfBp6kTnWhwx96Yf6L5rM4HWbKv4cH74ZroBnR7MUeC?=
 =?us-ascii?Q?cH+EvDpjdFyzykwfl2FWeL5SbxASPRzlb3zY8G59mJJztvCZvXsuRR2pSTR/?=
 =?us-ascii?Q?/8lypM22DhrtXLDLwzs59JMpl4xscGNkbfGGh/4ooIa88mEaLqyVC9sp9+s1?=
 =?us-ascii?Q?JPjyacDlOWt9bP6CyPrH2QfbEPI93wbLTnDNeypc13aN11RCx8x2jP7ultVt?=
 =?us-ascii?Q?o1Pp+7VroxHAoQBxHpxdklGG/JXUPLbVrzZzf8dzKi9Kqox35i5aiThrP+jB?=
 =?us-ascii?Q?1JmvbxWSBGnoy4bXKaW9AiOjsmJJ83j7vrvF5HJVTBQ0OqFpKyyE8Is0gFoi?=
 =?us-ascii?Q?vK9PImhKY3tm4SWTHSVnYR/9zvcAH6Mdl3VlS427j488q9tUj8jE7htq2rhR?=
 =?us-ascii?Q?6xxNuRynniyEMbUQgZ90V9IMnwmfIR80F/s0B66tkDKi7uPfTkwAwushzGcg?=
 =?us-ascii?Q?NFu1RoFtSaAt26RMAPjYQgZ/o+Wk628s2ztulcjczmBLtDY1dnNBwaPQDEyv?=
 =?us-ascii?Q?jBhiYZANK2x/m07qmm8FQi4vM2mn6rBjqasrkDWuJuGddOevyFZBRm4itzIM?=
 =?us-ascii?Q?0Z9fidjOd6MxfwvBMc3XoNP2q0ZAKXV9C6zEn6xSPzvwHVnMaVRLXAAjw6As?=
 =?us-ascii?Q?0nFoqoLhID3yQfKIVvHg7bMRNeJ6ay2a/PQK6JrY9WRoURgg1CkwDZFXeHc6?=
 =?us-ascii?Q?oICA5bRG3TJigDPVjanmnFp/gl032RbHbXxfF3+vfyFYIH96kh7tUxqURVsF?=
 =?us-ascii?Q?mV41t9orW9e2NEq/5rXrEADq1RTmIVLE6sLvL8uIrckX93PhLkkhlXYuQR3p?=
 =?us-ascii?Q?4/Wwkrpd653xMglaY7NvfEcMLDVmjCFZTmIclptYbGGiqBTbI0XJI29AHo2L?=
 =?us-ascii?Q?+DTBqQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wVsFAA6bs2B77zPBgQ/4N6j2xObHA/uC1GZC1Hy/in2wRtZpije7SzxYr5XMAUulwKxfeMTo+y5NrzZAGT+RJNKuXM1STxX+KERADMYg2NKyzXjgeDnlL8YOynLArJnAf59SNkRXLZ0+uXwumGkn6HmslWXlbv3JkzuyMrx9/n9BaOAiTvBuLixaZ+2ni1ZIZ8nnt7rU3VX2t4Ku+Rd0umbMyvTt1Rki8zLI9oF29E/dTFTG2dwg+IenED4TcLmWKoL+FBJl6E+xcabENJfH2Z1VB4YLJKLUVYglzgdxKM38zC2R03FIMgKRu2Ju1Fhz0/0j5owSMhORV3bnTTBpnT4QUhPqmOzTI0e3AAFWs+MdgAOjtO++cJiZ665+ER3G9/mUKE8gj69ef7k0mfzw7t2Vm184AbcFAdMwOhNt9TFpWxXNoszXJ0kjZ6CXuCWQlCGjl5RK2N0eB7LDVo0t3AvXjxytQfcr/Lk/jojjzm5qOzer2Dz6wLdgR04wHv4k6byTFNXAXOHCqqLz8nvdocLr0axHYzepk/j+Z+fFLGjxatt9u73FdqYEtUaRlHP+HpzHsO/LRz0t2HIDTs9X1TwLOPAsy0SodoYEJR7Va6w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0360ce46-74e3-44d6-a9c5-08dce3097f4c
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2024 17:41:51.0967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vma+6ufTzKK6Ac9LcjtbynKlZmFaLsXEKZKT5pOh36UrOB6Woq6/GP7r8TOd9TZJ87lQWJdwrNpZJbubwWgwvNTs459oMT45qnGj8zzFmIY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4995
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-02_17,2024-09-30_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2410020127
X-Proofpoint-ORIG-GUID: 1C5ikbz6gg0IkBChvwPPqR2W5bB_cnyU
X-Proofpoint-GUID: 1C5ikbz6gg0IkBChvwPPqR2W5bB_cnyU

From: "Darrick J. Wong" <djwong@kernel.org>

commit 1ec9307fc066dd8a140d5430f8a7576aa9d78cd3 upstream.

For a very very long time, inode inactivation has set the inode size to
zero before unmapping the extents associated with the data fork.
Unfortunately, commit 3c6f46eacd876 changed the inode verifier to
prohibit zero-length symlinks and directories.  If an inode happens to
get logged in this state and the system crashes before freeing the
inode, log recovery will also fail on the broken inode.

Therefore, allow zero-size symlinks and directories as long as the link
count is zero; nobody will be able to open these files by handle so
there isn't any risk of data exposure.

Fixes: 3c6f46eacd876 ("xfs: sanity check directory inode di_size")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 51fdd29c4ddc..423d39b6b917 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -371,10 +371,13 @@ xfs_dinode_verify_fork(
 		/*
 		 * A directory small enough to fit in the inode must be stored
 		 * in local format.  The directory sf <-> extents conversion
-		 * code updates the directory size accordingly.
+		 * code updates the directory size accordingly.  Directories
+		 * being truncated have zero size and are not subject to this
+		 * check.
 		 */
 		if (S_ISDIR(mode)) {
-			if (be64_to_cpu(dip->di_size) <= fork_size &&
+			if (dip->di_size &&
+			    be64_to_cpu(dip->di_size) <= fork_size &&
 			    fork_format != XFS_DINODE_FMT_LOCAL)
 				return __this_address;
 		}
@@ -512,9 +515,19 @@ xfs_dinode_verify(
 	if (mode && xfs_mode_to_ftype(mode) == XFS_DIR3_FT_UNKNOWN)
 		return __this_address;
 
-	/* No zero-length symlinks/dirs. */
-	if ((S_ISLNK(mode) || S_ISDIR(mode)) && di_size == 0)
-		return __this_address;
+	/*
+	 * No zero-length symlinks/dirs unless they're unlinked and hence being
+	 * inactivated.
+	 */
+	if ((S_ISLNK(mode) || S_ISDIR(mode)) && di_size == 0) {
+		if (dip->di_version > 1) {
+			if (dip->di_nlink)
+				return __this_address;
+		} else {
+			if (dip->di_onlink)
+				return __this_address;
+		}
+	}
 
 	fa = xfs_dinode_verify_nrext64(mp, dip);
 	if (fa)
-- 
2.39.3

