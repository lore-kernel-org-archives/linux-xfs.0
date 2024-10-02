Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC751D1738
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 17:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727890899; cv=fail; b=AJ/zEF1bAAA5YAUcQJBIAmQVWv+fVoAroiLCUP/NgwICMIF6Of10YKsrJ+oTTOcxc3ozwR2e3jv8XKR3Z6xPoPoq3Ta9+Lt5WIYlImrVb/khIK9RXaX+ANIMAR6BQcBRDnh0RbEbgghfr2mU0ucqryJzv1o7iHFW8e8vAN97dz0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727890899; c=relaxed/simple;
	bh=jLmafBpi7O5EXAWPspNMqPsJ6hlU6OP+qeezPN0mwPo=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tCCeiSbPjfrAR8yzLrhJzF6IVNIkUrMXkd52Nc+XEetAskPqmg2y9whf7UVEl+47VhBCZpDfmd4qZFOvlaqxzG7zc/uaYkRxbCHse4knwY6cZsgbyIQWyZyd9Ym14zUpytaPjm+TpJkwEiJ1H0AtlsHzQcZ6w08Lg8mdbD1Q+vE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FqRiovgT; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=lLrKvTbX; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FqRiovgT";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="lLrKvTbX"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 492Hfan4025055
	for <linux-xfs@vger.kernel.org>; Wed, 2 Oct 2024 17:41:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=PNkjkwkY6oPvrfr/q5f8WlFIn3CkAlLQ/6Hu83Tf/3o=; b=
	FqRiovgTPd07I+n2s0IcAi3KRw2Y+Zmhbp7lQZmreUsdsEPfvImRSzkNd5kLiGtE
	jmI3Z1VEuhK1mQDLXhd5N7ULAYMT0ZZxkUbRBdNJTqpr7TUozb+n4sTJxl8do2Ne
	eU9dRoI/uupLuVv8wt3XYOi226lnTC13H9C75QHozGJhGpnwD4qnJMFAzXNaZaI/
	X9UWzw2VT+p6hfXsn3LCg3Bpw8bL0GG9ZWAbSQPIDbRyqKU7t/VfRCyEeniHn2W0
	3mXxxNOgpW/iszd76Qp+I/OWl1pc3RexQqsVPfh8SU/t+LSp8R00ole+05XDy9R7
	lBJ4J7UYH2xs+qGR+uXAHw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41x9p9t3dp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 02 Oct 2024 17:41:37 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 492GOowA026192
	for <linux-xfs@vger.kernel.org>; Wed, 2 Oct 2024 17:41:27 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41x8897fbt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 02 Oct 2024 17:41:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lucv9/fJqNkK8zYpjgSRu2DEvlFTx2QTYrybX3wyKuE43o5oH5zYQylVOqPiWEqyDs4BRcBm7P/9TTsOh25zjLlCzGyeLmVkS7rh3QfuE1OuIlBWnJnK7pLNVdEe7BkUeDOdrn7NX32KOQTVVX0QYdXd/nvTQDJZgR+dTQ93RZp2T8tve4rKFQg1mVlDjzPn8cf6dM1J+QdB1vWuDVL0qR+YyPydP5EMjUB01lefvu+J/jc5XVWJaPJu6CisnttdM1M20LyKNOUym7WhvDSIfMbZAhmESQnd50YgChqyD5vTUWgm7UK7QqWnZ1BikOfAD4I9uabKTFE8Vxa+ox4JbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PNkjkwkY6oPvrfr/q5f8WlFIn3CkAlLQ/6Hu83Tf/3o=;
 b=TRZC0CIZVfmE2A+bN44ineOSy4K2gjMXB0ls1VMAOVc038thFK8DUwUwuyPR2JuQtODkDclb8Qv5YdAJhagrGd/15bqjFQQYx9EUZ2VvYEdhoqcX3ll4GC8Y8VHqaE/wWnnqHZyIrU71yeK2NZY8osZd9BqIvgNl8sevhaHUF44X9akeFwYyYLrCKNmQgTPcyuX3zIxtXnwxbEXw2c/zX76XUu0dZiThUQeQSIT2gBbtpcx435Ld6ZZDdPKvUWZ0NbvDPUN2cLVdiQqA9E+WANouFnA2OkhjqVr0BUcukE2UCBDfPbl35XKeYogfeoLP3HRTBpHjc3+h8UwEaUeq/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PNkjkwkY6oPvrfr/q5f8WlFIn3CkAlLQ/6Hu83Tf/3o=;
 b=lLrKvTbXpuNvkHwxy0CGf0iwwPujlPoMlxJs6emK7Ug9cQNWanLnRaE+ADUVmTgp1jqGTR1XD81FBfwmFGgGcfIaVCIpr0D6SClnnRkdOa9pd8qtdfz5M9oAej0Clo7Hg132DqmxvB2gLcJocImuAaQY7AXQbNTfi3wWYqO5cUo=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CY5PR10MB6047.namprd10.prod.outlook.com (2603:10b6:930:3c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.15; Wed, 2 Oct
 2024 17:41:25 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.8026.016; Wed, 2 Oct 2024
 17:41:25 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v2 07/21] xfs: check shortform attr entry flags specifically
Date: Wed,  2 Oct 2024 10:40:54 -0700
Message-Id: <20241002174108.64615-8-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241002174108.64615-1-catherine.hoang@oracle.com>
References: <20241002174108.64615-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0033.namprd08.prod.outlook.com
 (2603:10b6:a03:100::46) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CY5PR10MB6047:EE_
X-MS-Office365-Filtering-Correlation-Id: 67dd5ff6-b7ff-47e5-ce6a-08dce3096ffe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|10070799003|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?v5NPuxfMMFmNLfYBU2+9Dq+VJkE5pflOWsKzSmwWbt15hhSqyKOCyYIWA4sc?=
 =?us-ascii?Q?pT0RH4VH5unHn36ju3LZzd9m3b7b6J6Lcx3rXe4IlX8w7oxQnWs+P71QErLy?=
 =?us-ascii?Q?m+xIuhINJbV+Uid//epjXcLdxUQB9cp/unZT63Vsl/NNc3q6EAanfiBpdBk7?=
 =?us-ascii?Q?Lsb2KlGdCzU2vCmDoeJuEUVNM+LvuW7u5fuCyX6AnpnjXWMRN6Q0KEOfRScO?=
 =?us-ascii?Q?z1b1s0kTWrD62GQSNXSeQAWURSgWjXO8VIKxBCuY820ssMH5H/ekTZxvLi3r?=
 =?us-ascii?Q?K5SsVe7oMhYlTY1m/tQRUSP9W5rIzf6CZXKslYoOJMpPCObVqbmJHxP9/XEF?=
 =?us-ascii?Q?pcxKxITt80WzWgn4PUFexgma01Z52lyI7CIVNaDJjQwWas7SjT90J1Te3rGL?=
 =?us-ascii?Q?cTDE/j0aykr7xAnbKXFS9RsrDV6af+en34ZxRGNIE25o6tw1y8Su0qQqMgV2?=
 =?us-ascii?Q?DxELx66i1rhz5aFyYTMdPTCeFYAiGU0Geqvu2c0wjzwDNmu2twNL+HkvWCdB?=
 =?us-ascii?Q?DIqv1lXHDLfn9S2LooEuqf76h04KM2IpSiOAztmdqmul1nvnne/uniTSB42Z?=
 =?us-ascii?Q?Z0ThClLJaFHW9lZsyEQqr6K7DAKBJ8CchYQkNxNM/yW7qSjhjF+XrFMZ1h1U?=
 =?us-ascii?Q?sUHdyNKGMJH0fg0OrKGgTA/wGzjZpbd6g+MQrUZG3leg8u0ugcGWgRHRzXCU?=
 =?us-ascii?Q?uLass8qJI68MQRhUqChIf8NgM6uN1cuEOoujmlNMAfRy6QTPyNrgxdJ/eJcM?=
 =?us-ascii?Q?SCvf6cSp82/EJJwnzEgtWBHNOaEFH/8vLFLFBOH/jI4e3vpIugfRUnxg4c/k?=
 =?us-ascii?Q?XF6kSg8DmOECl1cwAmK2Jd+k8CErxvdGaiHWoHtdvb3+LqrkGvpPhG2NBzXz?=
 =?us-ascii?Q?O7V4XgbjnG9Sb6zNvpbSny18ip78ih8xZh51mdun1LFqLmEYCSi9OBgyFBCL?=
 =?us-ascii?Q?v2jnqZbRRKfkd/uUvM03L9XrUpGH7tCzoch2ua6u/iojRsssJrIr+UiMLPe2?=
 =?us-ascii?Q?joSmar9rp2stow/GidRgvpPPBQc0mQieLHWav7Sb4Fvq8IS1V/pRbsGq8Dpq?=
 =?us-ascii?Q?fhKeSId0Ds06azxcpsurDud7xeF3HnPENrceNuEh+KxuW+8HYalyfeO4Z5Iu?=
 =?us-ascii?Q?vUPmQlc5z9J8/5H7juvU9A/tZAwlmgYk1JLApf1R49viJ0ks/7Y2Z65r63FM?=
 =?us-ascii?Q?YkBPOltIgkCDEAUSTA2i2E5KHM7QZ17Pwtx0wasVdStGurBZ/cCnLNyNx3Rd?=
 =?us-ascii?Q?VLjEB+46K/1ivAEGZcSeRi+tPcCuWAGUMGgkm9KBTA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4zqaQQ2EunlmyIcKL8h0CIWI9U8eLmSqmegI4CPv3hEy6sUEvwXBnT4oZFEg?=
 =?us-ascii?Q?Lsrk1al0m2oF1E/oMPwspW6UWPdfMFTJeMcK+Dmovi8qYYqUIJI+8lCLXpRo?=
 =?us-ascii?Q?HJ4jb7xzeW6ONWLRP5UeVvv82lta7N6yROx0uT9mzAvQSo/39/Wtsnljx0ez?=
 =?us-ascii?Q?7NOHwsbUuKqqIV7jMapftVg5KgdJnFXL09HoPiLNETRsvoltMsrxgVbWnHwn?=
 =?us-ascii?Q?5RxrXBflrX5xOgtsKaTamQzbDHzD7X4CZAw76nZTIiQbCehpKGuByP9VzUfk?=
 =?us-ascii?Q?2kk1nXtHmAanxdK3MLL1X/+9RRc3ZcNarVQrVzSA+fXKF6hiYqpioZHpc7rv?=
 =?us-ascii?Q?i3qI/+Bl5ZG92d8TwvrRvtXN08sRmnvYhXE3iO+TpdvAKettbEEOqCnSMwFt?=
 =?us-ascii?Q?asMS5miXzvSeht4g0KvD5HhjTyEqDXsrrOOdEWELFGBusGsl0/d3UQaVSemI?=
 =?us-ascii?Q?Yh1+vKu6A8pke/LuPstHTNA6PJuISD9EzWcRhK5HN0CmS9pg0Vf3Z3MhRvFv?=
 =?us-ascii?Q?Uh68n1yjks0tlu9i9Me1PCQqb7KpL3IYhhkewdhRHEEad6qab0uJLuiVGYLP?=
 =?us-ascii?Q?KOxQZx8a2TvDdzpBdDZ2zKQR6f/pAOejP4f0nZ3z5Wt5zZJFe0jWSaRi9epb?=
 =?us-ascii?Q?dB/3oh8DwFzyc1rLSyIpoXbFztHjyX0v+6WnQDXdwNuPk/LTNKKCWK2yk/g0?=
 =?us-ascii?Q?C9SJsKS3yUdfF+aF2+X7kh1p6ZKjHNXFsLFLP779jaBI4no9KdRLUZWl5Jzc?=
 =?us-ascii?Q?FWw0Jk9NJKOhry6LhhHTjXTmfWUGYsc/oKStF948NYJRcBLpvtNKLaPKT99G?=
 =?us-ascii?Q?91izb6EGPoC0YWjMXGBwHi0+qIbQNRt2VcuYPpe2ZA1bymkMsE0b2PVPFLbN?=
 =?us-ascii?Q?K5yR780A+g0bwN7rj7l4M9llJQuHTmKyYKl3xWWFYZUJ4Tq2z9Rf6IdKDA3I?=
 =?us-ascii?Q?dG17HM4ZKv2ygokJ6VVD4YpelsEKkNVLaMCpXPauLWkuPqf6yLUHSLlDI6lm?=
 =?us-ascii?Q?4K8f0cti/kM0tjrfEHznd71DoQlYdMolRsHE1l5aAR2HcPJ64PDYKo1KC0Pt?=
 =?us-ascii?Q?p2xH2sPjVif0kZvh8XOAme3wbcA9av2usj3rIQTcaP6W0EKGGAQ1K4X5ogrS?=
 =?us-ascii?Q?dF6zN5rMC/RJwnvBeZ5I4l6Q5JYqtG5Nkqg68dOB70+1uAYomzZb6+AVYsKs?=
 =?us-ascii?Q?d1E3fEY63ohdooBEv57NM8n1/xaJRKcBgA5x7boPnd2eAYza70GZ6Fz4rpXs?=
 =?us-ascii?Q?LenBj8Ovrved2hc9FKfUQIMJuE1fiXGBhWJUIft27Q6fDW9Z3Z6rnNUWV/XY?=
 =?us-ascii?Q?fCrR62kuap4EfbFq/0FStmVKXt990fjKtfQaizcw7nl0Te+/Dwi1ICjla9GC?=
 =?us-ascii?Q?TJwMb7dm66v5pVEs+y0kbDYh3S5Ic93ZQQWKYEDNgZ2nBceXHruubQHhy+az?=
 =?us-ascii?Q?2xnJcsDo22WMuEWuXT4oS16/0DLduVNqiOf/qY8+nq3mQgeAFv/5ED0qMG+e?=
 =?us-ascii?Q?2olQVhFCIX/ZBH8TzOSE1e5uYbIrS+ODbmUn0iQU6E/OoLE9AvELDHhu+UdG?=
 =?us-ascii?Q?t5e6KeVUjoepA65hUfo/GwdOmvf9l/IzDhY6n0SzZPNM5tX1dr1IMuUsexME?=
 =?us-ascii?Q?ZS3CPR+LjKHxKxgXDhQqZ6E8Xu0/qGXQCDi2/pkXyuCAIMYJOnbhsC2rqK4D?=
 =?us-ascii?Q?enQYqg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HHBbI07+WJiH7p784pKC9lFK3TUe50svc2KqSZ+R6laRprpZUDinL3C8Xv+vcvwtc1odReKmKLUUT4g0Xj/bwkUXbKYHo/AuJs/lYiyLwIg6dxxflZHRM64riLPdY5+129evFKi5ErMhZkqlJT2jNsbaS0Z/MrVT6ctO1rKm52i6y/ILMekij9syvKIKWDTB0gugzJxXe3MJr5lmSZ40D+q3it+g/ocZTPt2pdp9IgOdUDL2bBsMQBvxYkaep6ecXEjUNzU0ck1tcpb/BAJBcu6aT7sMJYiJQeXlDRmQSLB9JL8A0J+bb/GOOoTGqiEfqe5no1tRdn7coUwIwCXwByXop45G5lxMqWyaWt2W/uGY6aFT0SQ1jW+a/vnGDqVq+BGGJMMs84yAHlaDvHta275WuNIfcIfAYAshktUhUySn/GedyfWJf9LooYT7rfBTHFtkC6QH6IsDBJHRCPydR7LUKkDn2ztUjvNuNWP6OyBFbxfT5uecupmDZPtTAfeyyAqyHY2J+JhLjGROpopjnBKhANAEXBa7r8TmseSXg5+V8lFP5sTwxVU6dvQri9mVpFPJNWvIzN3wlpWolGD12ggMvMOY7uXBRj08e5ewRSo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67dd5ff6-b7ff-47e5-ce6a-08dce3096ffe
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2024 17:41:25.3723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jQ1dt6NQfCBJRZ1zgYTIvkrHcHHkQTgxuwmykLKpx5hPFVF8lKGniccMpBTfEPQzVukDqipYSmq/GGuC7ZOMbtfev9mfIW2n6fcjiuJYWYQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6047
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-02_17,2024-09-30_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2410020127
X-Proofpoint-ORIG-GUID: kTdyyu2pcY6iA4wi8Ug4-5erGtUOeS2l
X-Proofpoint-GUID: kTdyyu2pcY6iA4wi8Ug4-5erGtUOeS2l

From: "Darrick J. Wong" <djwong@kernel.org>

commit 309dc9cbbb4379241bcc9b5a6a42c04279a0e5a7 upstream.

While reviewing flag checking in the attr scrub functions, we noticed
that the shortform attr scanner didn't catch entries that have the LOCAL
or INCOMPLETE bits set.  Neither of these flags can ever be set on a
shortform attr, so we need to check this narrower set of valid flags.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/scrub/attr.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 990f4bf1c197..419968d5f5cb 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -566,6 +566,15 @@ xchk_xattr_check_sf(
 			break;
 		}
 
+		/*
+		 * Shortform entries do not set LOCAL or INCOMPLETE, so the
+		 * only valid flag bits here are for namespaces.
+		 */
+		if (sfe->flags & ~XFS_ATTR_NSP_ONDISK_MASK) {
+			xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, 0);
+			break;
+		}
+
 		if (!xchk_xattr_set_map(sc, ab->usedmap,
 				(char *)sfe - (char *)sf,
 				sizeof(struct xfs_attr_sf_entry))) {
-- 
2.39.3

