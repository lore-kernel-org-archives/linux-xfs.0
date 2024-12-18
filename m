Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE8DC1FBCB6;
	Wed, 18 Dec 2024 19:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734549466; cv=fail; b=n8CqjNooikzcqeyMxwVsPnw6PHS1FTQwXSRju3ZRZyQzj9+fVgIgt/qJ/mBYhsQxAPMj0jcYj//qhXeKvPzRheZkRqO4D7jhkmUnqQAVD1ZPjNRrp5Y6KWWhJ4/p2SYz/K4S8xUNx6A9FtamSHdROPbXDfNbXNDC7VvmzxdhKHQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734549466; c=relaxed/simple;
	bh=M4/OUhJDQeTdiA0/y4yRQgQD5ujF7G/kKjV8vbt8gSI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lAoyzPHjr+59TQbI97FOhMI8AnxuVakJfkKFt+YFRXJ6BpzoAkSl/JWfLqdqEEfKFaoppiuS6wnCmrEx80W/0aMOzQYDW7yo5dGQeoNaGX6wDSeMvIxlISeBohiJwDNcQA2q3QVzRlt4pnqxwniUxtjnDAw3wFW1bRrfx9G6c1I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XNe+CgVC; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=JZ8ONsmK; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XNe+CgVC";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="JZ8ONsmK"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BIHQnKs001137;
	Wed, 18 Dec 2024 19:17:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=gHBJV/ELYVO2y72AYgs0Cckm4fTOyj0ANdcmgXZSQRw=; b=
	XNe+CgVCWyavoqoXMORx6UMXQBJiyOMHAQnBbC2724g62Ek/TiZgNsfn1mY6RSZ7
	B+AsPtb0mDbCqs9RA+vrCvcurmywbgtb1IvnHo75xTgfys3IrDXWzwYVSPRq9sL+
	cwMZhN+eRCQCtLkdrweNxbA+SvqRu8vcSgiR9DsuiGkbLACmfbyvUp6wBir0F3tL
	Enk3TnjUI4OQdzpAswF1hHT6u19pzW+dH+vTxn3W6dC6COlXCgaDDUbZjATYXRVq
	108+E+AfaKE1j3IMVbrYu7UcvUWgkC55khlOG9luqMf7LVO8uurmjJTuwvq9snU5
	tb5540Wa1Xe3M1BylbeA0A==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43jaj5f706-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Dec 2024 19:17:43 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BIILfBc018984;
	Wed, 18 Dec 2024 19:17:42 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2043.outbound.protection.outlook.com [104.47.58.43])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43h0fafu0g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Dec 2024 19:17:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DueRwwfj9/Cu0EA0f+6XblS/r62pw+pni0vF19BBJm2nsaUSpKt5azBo0G96oUCIY024dgC8p+7UI8trtBdPUJoxRj5DBsLp2lwZeUEtaZio6rID4+zvOtI/ZrmbeCPk1052XgwlCs5dD/MJXDMSbd4p92FS1QmhkSLy2M/EWin9nKdyMjRmnfOebJs/Oj3lhT9eM1yDJEHUAelLKTcMp7GNBF8I1s5cH3ttLAf+a/sM1+5V825wkDk+BF1fWcqPUswSZRQw9DhWYTdiQLa8C5j4hrEtwhPorzvjupQCjWTitRFK4nuZOf9vXxli7zggecsHM8aWkzPP3McI/8dCGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gHBJV/ELYVO2y72AYgs0Cckm4fTOyj0ANdcmgXZSQRw=;
 b=Vg0Th7UG95ziFb39qJFRofLV0eRl44a7k67OvxHQFOfy+RjNgt9LpbO0bu9DL2uEQ71asWoBph8g1q92l/xllUBb4EKiToGSqVPxLxHCET1MJOJZBujz5Q0BPDVj+y9atlAlTV9grZLlxMBjBc++e2Z9E9/mmo9ZpihBfmKfhTRzGvmInQ0yUyUtizxKRrE+SwByu/W8WRJqKeL9rlykhGmPD9JOeaYww4GLR+FjxTLhy2BLxbtymUcKDt3r9eN3o81z30sbGy7hQi0xzOkwDHMbo48OcZ+1vv+YsmEpq0fGPrqT+BGNrVbYXe+5WRVDirKQFUPf3DYtOOxXEJqbkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gHBJV/ELYVO2y72AYgs0Cckm4fTOyj0ANdcmgXZSQRw=;
 b=JZ8ONsmKY+YIlktyhoaH3qFYr2ZZYlNjkpOE8EpHEAk4IY0VqTRmYd4KnpjQZYVnv3owxPout87FvRtA/ugvru8U3Rs6a1U+XUkhtxRLkIQWZyruDkGG3/CJfM22pclUw7PH1C0yFeSe1dvG0tHYa6P6xKgPDkNd/SWLKUQlwQE=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CYYPR10MB7673.namprd10.prod.outlook.com (2603:10b6:930:cb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8272.12; Wed, 18 Dec
 2024 19:17:40 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8272.013; Wed, 18 Dec 2024
 19:17:40 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 07/17] xfs: Fix xfs_prepare_shift() range for RT
Date: Wed, 18 Dec 2024 11:17:15 -0800
Message-Id: <20241218191725.63098-8-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241218191725.63098-1-catherine.hoang@oracle.com>
References: <20241218191725.63098-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY1P220CA0017.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:5c3::6) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CYYPR10MB7673:EE_
X-MS-Office365-Filtering-Correlation-Id: 203c685c-9a0c-4f50-ecc2-08dd1f98a3a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?llsZsGuRvkDnuLNbFk9EBj9jIt1SrQA+cQ/k7QyaNEKkTqNfN8gP7Nqk/Iy2?=
 =?us-ascii?Q?2XG0FX6CpohvdWGQZyEkFbvZanJY31eltx4WBYnCFvw7YCvyjYE/uKw6o7Aj?=
 =?us-ascii?Q?9Cf6G836mHoteQhAJGfz7gliVTti7yav++ENHIKEQjtwGkOx/tBPOyDXvvsZ?=
 =?us-ascii?Q?ayHdyKIIa8W2UzhTw+AtVxgxbpPinLdoP6sC3BubWN3YwWQNqh/0zzoUkfZS?=
 =?us-ascii?Q?O8bE6qfLpxqHcXiArJ9if+AYfm6iGqpeyuCyb5Ka5+2niLiMaih7JSTM5zDq?=
 =?us-ascii?Q?6CSLSSzJB7L8uEJ0fxySzW3KviuD76NHKTjKh5Ys7mYn9DUDCMRU5kxWNSuP?=
 =?us-ascii?Q?kOl8QwL0Xb5Ynm/8MU+RO3M9G0QnomwbuB3UAFV/FxaAcnly8YCvgvs6gSbi?=
 =?us-ascii?Q?mjZgirMRpHQLa1pWMRfQAHj6Bu2fDvDo0yX3PqGLNATeiZGH2Cv1O52J1Lzg?=
 =?us-ascii?Q?6+/6W8iL8zGsA8usoce7i2Dl14rc15g9uFuehgkD6zNn5sxhZJlzucToV6sZ?=
 =?us-ascii?Q?wsBS+Ke9eQ5iZ624IHKKLWkuh8pRserMb4D+IxC/XQ06KhepvCrUVLSCDKlu?=
 =?us-ascii?Q?wXFZVJAdExEeqPe1lB42MolCvsDsyPnhqJOgR2Wi8a/Ki5WUC4+Vgu7vREUl?=
 =?us-ascii?Q?PA2QxRjqSENDw4Dvf5TFPNC+ryKtCVifAZfTPWxFegmjCc1PPuhNIKq5Fbkn?=
 =?us-ascii?Q?dVGPLKA/fN8jxhvDc/m/diY0qValIDeZyVQ8Ll08fGk+ZkyaH9SFKeTjmfQP?=
 =?us-ascii?Q?uAP0Eb9fvNKP77tGxol0/sEyA0RvD6pEzrYyV05BiqSY3oRHRIr4a93vEBsE?=
 =?us-ascii?Q?h1/mAS8yXZcQBnDpKIAp8PslQK2Gcn2aiSczJEtwtkK8vycfXa9n2iMTxm4D?=
 =?us-ascii?Q?DEqhf4yNHX1RLoaHXs5NCWZTK4Wyrw8V/BCFnA3szOrRP0F79Lk3NNE0lZJ/?=
 =?us-ascii?Q?2iYLQZqXbcEaYXujJE4uT9XMtMTD+kLajFUHQAtC/8VhlhcN1T56bMbmsVf2?=
 =?us-ascii?Q?W9bxlOwVVkBzEzxTkM6wRZVdMgZeoGkjYill0OfQPdI7SrpJf4AKTmcQP0lB?=
 =?us-ascii?Q?DMihw/5IYKJohtfDW9/qZpTlLbkPVGkBcxQ9iBNXLoQFsA5QMMw1DS1mFRCL?=
 =?us-ascii?Q?ZPTUt4/gJQkOcvz56Szg4H7DFPkDexbhZ7uZu+6n8TdcREvXQf6mOp9yN2oL?=
 =?us-ascii?Q?f3BZgGPZOgPK/peLKYXlvu/IAxwahCZLpTR0KvxIqxcxGKPmnYF6yLy/QZzl?=
 =?us-ascii?Q?jT6HgVWSzR0JOmmIiFaTKSGZrvt2UdmmFcw4SAMMFjoSdh638I/qgXXaagoj?=
 =?us-ascii?Q?AdVXx+EXY7cLY5uLIYObP4m/oH19EzB+Yp9uXDakWoUORXLE12BZhSjRauXx?=
 =?us-ascii?Q?CuHPTbyEH8/3nGIaHhJUYp5vMwgE?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8/4eJEVqgtVxP3BbqMi+2xDvlbG0TpH86j5KtZJI1U0AJi3dIeS2dKSQlBll?=
 =?us-ascii?Q?wwyMyhdP37YE2xV2xT9okvJcj0p8doCeu2ctQYIdMB0nbu7vFnx0SAcnE+Ma?=
 =?us-ascii?Q?/zfRw0FLzAwSp+q6GZ/Ntf0sukSr10f6jpFV4KpXg7HR76PAohO5PgWhAUzL?=
 =?us-ascii?Q?9D0ggtDR64zqYVrSVIgzOj2JHVDCfcS8aROQR49GYeGeVvKZuMv5Ksl6KrWF?=
 =?us-ascii?Q?tZitLTD/rW1/Uw4dfMVe5wHH2x4+ur7CTvX+S0ITXhX1QMxPrfWYw+WdhCvl?=
 =?us-ascii?Q?IQh2ifAgdrPzo3CF+r3iqu3H6qqKWYikyaaXkf0e5j79FzZQWf1ww1f2Cuzr?=
 =?us-ascii?Q?T25AduD7YT++jJ/hsWs9p+LN5wPy+6sf6OC29JISVZ7EEaPMpGQ4+QMGv2Pe?=
 =?us-ascii?Q?zABaIUQYja8fdwyVQ5IbTiEDM9TrqAR3p6gpy4WONWWeDqe0nAJOinZ40N4Z?=
 =?us-ascii?Q?joCKMGXK6h81TJZuJHKXMU1wh57wdLEty+BeuCW+PbmClqNnSr8BOtvhT/7Q?=
 =?us-ascii?Q?dIFDIlQpgdMYed/ADSlQGMJmPPhF59+G6iS64jFkCYjYjFW7dYgTFq1OMnj9?=
 =?us-ascii?Q?KIkj0TRiOkjvUx9va+VCmNX6rKYtx50pYEg47LWsrVN6ASo6wXN+BxZOoz5I?=
 =?us-ascii?Q?or4nZFIioJmt8edCzygbZ7TAhULrVE72jJbBD/r4em+YR0vObGa496Dt8BDM?=
 =?us-ascii?Q?oUEo6O8C3dXhgvUXnDJM5UcoIB/s9uPR2SoenKFtKDOTCUzvabILGawuO79p?=
 =?us-ascii?Q?Elj3QcW84Kd3PkktB4lWBqEVJziy/KUexYGRDPAV/eQsZY2OOjmGZLvef48+?=
 =?us-ascii?Q?nSX1LVnHDZuhInyb49svkRkjHDoq9xdnSgeNIZ8WU/QWSjt7GmxmGF3bWpWs?=
 =?us-ascii?Q?gsR0yuC0O85XUIuozP8fGmyEdUDRu/M0QnM476eZVVRJm2tHvjfp5iOseNff?=
 =?us-ascii?Q?ZV6c8KS1UKnfGeQlOVbdUZvBUJKnbs8yT7XvgftOV7X/w5iJFqUf/0Ms/V/D?=
 =?us-ascii?Q?ZszsPc76b0pkNuljTQmlWvkqRs4VfZamqgBUBBwT8KPczHhFRhuht6ro3nvx?=
 =?us-ascii?Q?heFkE2KsF9J3Yb9bJy7Op3katkYzYgZiL3Pl3l5V4gR2o5NJesHYGR5BjiBP?=
 =?us-ascii?Q?30T1wu+gH3qvQJp9A2XkQ8Dd3aEhZjuhpf1ewS8nAA2MBQcqlEpWqZTv0JBq?=
 =?us-ascii?Q?wE8SsEtQ+QeNmdSsXPkHfcwcWDDfiI4JdcoGPC12b/R1qcz1/B/oKO6DKE62?=
 =?us-ascii?Q?DjPPPa/NowcOekU15rqRF259q/4WfGy5tLgMs5OINHrfragD+BSkk//JFH6S?=
 =?us-ascii?Q?iyOuoYBNfhY5yDwIwY+4iPsUFplja89eRc5/KZj17XI8Etsp95Up/CwS4fAg?=
 =?us-ascii?Q?jtqt6ba6bf+4kcE3hWrlCZXRq76fkIc6n7UnOn2334/do+gdWrMQDfMWZibo?=
 =?us-ascii?Q?gfjj9SSx4cyW8WntX1Kbd9379AGNWxn6eZrHlU31Qu8iujhAVYy4HjAT2Wbf?=
 =?us-ascii?Q?WzxvxN41xoofzFio0LIgy4/l+Wc5WTlYysdSnbRuWjpS5sfo5GMNUZ8nCDh3?=
 =?us-ascii?Q?953PerUTI4RDi5QvAyoiAsubNhK2uGXBg6GBCh+8L2v/G0CX9cuvJcquuh3h?=
 =?us-ascii?Q?Dnqydtf/DYVMoneKc52lm35evg+FdnELrqZOlKIgyilTdbnUrZny/8VbAsFT?=
 =?us-ascii?Q?Dm6TQw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jiX92j/nJpnO9GfRi0GPRsZaY2WK66TxEO6BOh24MTwpU+abxt3e+PqFqPGLXeRK5EWRt8qNJhwPWTZqjjD00qiV3drLL1ShYtD7nmoVJU2TcIeFxFnxp2ai9voJ4jSF68p70Kpqe3O0DNCeW8LHzl1Rb39K9XGfazOehDz5s6NJVIGgSDwUt0oa3/827wjkJb/CW3BxU3M8HCQU6mp1OfB2Cri+gpmDqrHj6yrKgxbUN2ithwdW8zr0fPjs8Mkvzc6mATz7QXqV+84DYLj3OYz1l15EzmyMl+99OmiG4eNbeujM8NLpK8/yE6+yu6OXaQtr6uJqPF5RfNoJo/nfbRuHjj9xXPQaA+eD15A71zOTq9nhkB3zakBygEF5u3gqPPKewQTkmzJWfKw7q+OvcT+ZlsTrMcRVWW5hwo4Ts6048jlHML866O7gW5pl2g2FB2z+V+ejpzOAKt4aKRB/trik+EjGXSmzzzXsCZyuPaBgwdel77Dfe3tMLlxIjRAYPhOY2QKV2OMgaWnIJ9FmPJHVt3oPisVRDmKl6LdQZO8ofs8QCOsmLSAiFgvImFpBHN4MwZ1QGpgdbpk57wNSIGErnWIXsFXMLvSb2o5vcmY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 203c685c-9a0c-4f50-ecc2-08dd1f98a3a1
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2024 19:17:39.8672
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PV0or5Chkm9rwzP1aoxJlYudF2EcQKwjFxSg8MKPZEWQ1X4e8R1f+CCnxB4IGlI+5uRSjvDGyTzdrEBpT7b+bZS4EAasNpFI0OxXr00cFlI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR10MB7673
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-18_06,2024-12-18_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 malwarescore=0 spamscore=0 bulkscore=0 suspectscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2412180149
X-Proofpoint-GUID: sIIfbREMRel6zrtkbpuMA6TbZE35lkaL
X-Proofpoint-ORIG-GUID: sIIfbREMRel6zrtkbpuMA6TbZE35lkaL

From: John Garry <john.g.garry@oracle.com>

commit f23660f059470ec7043748da7641e84183c23bc8 upstream.

The RT extent range must be considered in the xfs_flush_unmap_range() call
to stabilize the boundary.

This code change is originally from Dave Chinner.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_bmap_util.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 7336402f1efa..1fa10a83da0b 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1059,7 +1059,7 @@ xfs_prepare_shift(
 	struct xfs_inode	*ip,
 	loff_t			offset)
 {
-	struct xfs_mount	*mp = ip->i_mount;
+	unsigned int		rounding;
 	int			error;
 
 	/*
@@ -1077,11 +1077,13 @@ xfs_prepare_shift(
 	 * with the full range of the operation. If we don't, a COW writeback
 	 * completion could race with an insert, front merge with the start
 	 * extent (after split) during the shift and corrupt the file. Start
-	 * with the block just prior to the start to stabilize the boundary.
+	 * with the allocation unit just prior to the start to stabilize the
+	 * boundary.
 	 */
-	offset = round_down(offset, mp->m_sb.sb_blocksize);
+	rounding = xfs_inode_alloc_unitsize(ip);
+	offset = rounddown_64(offset, rounding);
 	if (offset)
-		offset -= mp->m_sb.sb_blocksize;
+		offset -= rounding;
 
 	/*
 	 * Writeback and invalidate cache for the remainder of the file as we're
-- 
2.39.3

