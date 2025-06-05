Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DD3736D;
	Thu,  5 Jun 2025 04:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749096101; cv=fail; b=TYiXq4YAVU08/MJOVfQOD7eExBcUukTmWQ0bF2w3vZk3wAb4AEGROGz9sjfTuEJuvADh2IO8esQ/jqJD9Bwg35Q8qTN+vTVGcIkR5TFP5X4Q/nyu8bdENVdL79aGcx3K8QzYiGPsdJ28SgRwX58kn6fEIIxJCX4r4pCTOWIreck=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749096101; c=relaxed/simple;
	bh=ZM4PKWNRUgc4zehAqe3IlCFtKJswqD4u57k4amH7e9Y=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=CjjYEL0o8gQyc79L/oRwVLWZrLhCipo5OvLBj2zF3/sjJ0sVzphxtzDecRNEFq7ZtxxdlUB/fN8j447qTnsJZn7f/arxNqfDoeBPmxNCwESOAin09ASf9c6VtqoZohgu5kNF7zFB8ulZEI/tdaTDtG/KAwwqhr5mKE6+ojLEAjw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=sPOkCA44; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=A1GKf+eW; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sPOkCA44";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="A1GKf+eW"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5550fmsa008667;
	Thu, 5 Jun 2025 04:01:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=D1VjvJw2KZI4DuR2
	9XeOjuBHDC8Z6Dz7TRyPEl5sPCM=; b=sPOkCA44N/rK5Y1E6v56966108IJ1geM
	RWAQq+gJsvntz+I3Ml8hT/+xGsQ2TqwAXtWpRXgvkiA3gWMfnasTNp4uWjMx3CG0
	YXyjwGLusE8jKQ9Wfx9i2YiVPRY34yebr2/X1Ij1outTYkRJj/QV91dqf48scH3g
	/5ZVWBunR5MOoXG55igDYoFvdJU50Z4guTyPLIqEaO5ENdGUia7KzETdS0O4DJTr
	PHpaZb6eGu40OG7yd25wD9cuz+fy4ETyGLIZh+T9exAKzy+ZZqsU1WN8aSusOoNH
	5ge7ZauWv/VARGJbThqdD1ICxZ9dIMjMc/wZaU+Hvw35GrsSRlC51w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 471g8dwc5b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Jun 2025 04:01:28 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5551Zx8v016244;
	Thu, 5 Jun 2025 04:01:27 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04on2047.outbound.protection.outlook.com [40.107.101.47])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46yr7bjgqu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Jun 2025 04:01:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ARgdvL2e24Mrid5Iub/9koUbajPma36z1c6IcENj5UWOXa685v3frmWxqkE8kW1mKzag7t327z+WtZpz4tI3z4J2yJrMEJlqNphKeOAuhPW2HGjU8Scj+FpKT3uUH8RUSMBAXqKk0R3CB6G9s5mJmAWiPXevidnI+yC1pWeE9dhgCrRxEPRRBijGOY5s1TEMlgfL3FpbopWN/WmDcevMuG+rBiW43+KMtF9PxveuXcuCGnrIlZw0oGCUbiLU183s2t77zQNL+qRcw/0gCxIJVxg5qJF0+SITApUqXWsrAlfg7VmnWuDMqJqgKvWT7FpA0hdRI/9ZPx388kOGcTbLpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D1VjvJw2KZI4DuR29XeOjuBHDC8Z6Dz7TRyPEl5sPCM=;
 b=UaS4i/Yw776AgkvSEPqf+x7s5PsZQrSCHSRQnElepNcYYZJ3FyRH2Q58qdo5hUvzdV8dkKO3krcTMk+9qqlAL81mKV1NeAq8mYaCIqBYNihxYVdmqKzeX3eOiZelqfG7F15FBwA3usaBTSHGxEBIeQlsN2SOZ48KI2C/oWZCoteb4U1QzT6Qdt6BLhVQjsL9izSEaJzKv7zgK4lE1YFpa2hJjabkhvGIZS/bB1FaRVWaQ4NynQQYMNDb3ruLPFqRZHZI6kw2rZLAC+XzVGqcfJW5TAHlWhlpi8CCrzQamNfUSkBOYRdwDyarSCFB0G0XgfbdYqAnvMyJDKWhktdNbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D1VjvJw2KZI4DuR29XeOjuBHDC8Z6Dz7TRyPEl5sPCM=;
 b=A1GKf+eWqQRTOOFubH0EfnqcaLr+fzH7Q49XOhUXWpPoO1cvfG9b3Xl5yraYCZqZXkCSOnwcKLUVWDIhNWa6Ma4Qm+7zRy4Rz6U5QsSBYElT3grT3tyqNrLVtGs0pqrQc9/CFm4lYLX/6U5Kn7ebOta4zX1GGuNsKmBEzRXW5r0=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by IA0PR10MB6723.namprd10.prod.outlook.com (2603:10b6:208:43f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Thu, 5 Jun
 2025 04:01:24 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8792.034; Thu, 5 Jun 2025
 04:01:24 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc: djwong@kernel.org, john.g.garry@oracle.com, ritesh.list@gmail.com,
        ojaswin@linux.ibm.com
Subject: [PATCH v3 0/3] atomic writes tests (part 2)
Date: Wed,  4 Jun 2025 21:01:19 -0700
Message-Id: <20250605040122.63131-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0P220CA0028.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::11) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|IA0PR10MB6723:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b7cec3f-87d4-4541-0dd4-08dda3e5a365
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|10070799003|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OpXa9EOWj4VA5fzgXAD8O5tyNXagul08mfj07nj4vKPdzYJSeyVJH/KHAALg?=
 =?us-ascii?Q?Hn2OIJdDQw5HM77+iCKnd8VXrduk8VNXa7nYfrKopVVs49UFpwaNVwFhvMU5?=
 =?us-ascii?Q?GJ3ElhL5Rx/H2J6BxG+efDuXaeP/nHaHTRDh9HW+Oh8TPC8Xtm3k2HQofQkw?=
 =?us-ascii?Q?jWKeoFSFK1fi4pioK+O86I/Kp5zZV3DWhaT6VPOIC+U+FmgdTUGXALHO39zS?=
 =?us-ascii?Q?GrmyawA5yLzNtNsPDsD98GRw2v1SFw6JImMoh0ha4HShlT1MMfo413GMJ3qw?=
 =?us-ascii?Q?byYvx6UlvgeMUDT76/qSIwbGwUCbtmrWaJF7QOPGc0hIfD4tEj/U4KtIE51f?=
 =?us-ascii?Q?tVNyuthEXCm3KP3zvA/V6QU2BnVF95+GwuZNS9/aaLkQYxWp9WtXpc1HITe2?=
 =?us-ascii?Q?fFwhSMXR1hq8pQDYYy7pUpySTZKdjruyEo7nyatCxVuGPGPyfkrVtTeAM0h3?=
 =?us-ascii?Q?ODKZb2GBTTHHXi4Iu03RUBo55MsKTc3ACyMSKSKM1qL3eMjp6Ltm0mi5qgz6?=
 =?us-ascii?Q?kQyQFDqa7V7Q7ICyDS8b0ARCPLj80Ihtc4MWt9ohvAZd+ZIvEPvkb2yNjSuv?=
 =?us-ascii?Q?qe/hDIWZHofnrQth7v/inTW2RHIzUCcO/t0ikPSjl7v8OKw/jTNSmWoD8gdZ?=
 =?us-ascii?Q?RoT2DsJawdFtHfD/XorbRSI5ENYJJU0LpSp9b8HMAAhoFkmyH3tFp/M02kca?=
 =?us-ascii?Q?JdcVUyPjIyEYXf6Ph3e072DZOdyKxonrC2rehOcc+scAvHDoe/aZ8hhZ+4WQ?=
 =?us-ascii?Q?hTgAYZtBrewtnS4mKU0cQHngfL81REcmiuDL2bvaj8h9nGuiwEwo1F3vgW2E?=
 =?us-ascii?Q?yqhzvfiPWn7qyFitwBh8PPQs3gvn0Smp2Sw5oaCp7Tr8po7LZE4vWYXpmJJR?=
 =?us-ascii?Q?gijEElpE0P/4Pjyaj2wG//JyL/3Izsx55zmoT7nQGt7WXr5t4H3equ25M+LP?=
 =?us-ascii?Q?3hJHljP3HIfaBAJSs+7t2G50ICOjgB5Pt4vbpyeIEEqu8UrDFkK2whah/aeO?=
 =?us-ascii?Q?qHVvtanEy4FqTNo1uLyoE+CRSJWhHWP1x3b3nffJ7SH1b72TS3ujBFYEOan3?=
 =?us-ascii?Q?v099OuviVX9IFFf+ZFqupWaUZlaN4MAZJTMFHUJXn26uxyfen3Rdl8jSRVtL?=
 =?us-ascii?Q?mDC14PLnR1X3th1D3ReYt+Fw7xWJCWwYTDxpGur+kgimaoRfY72lv/g8RqRY?=
 =?us-ascii?Q?sGnu4hpWHhCZU9wxqOa2XIuKY+t2/VHrQcX0E0/R2w+wyX9oEf7KN4jrZZzd?=
 =?us-ascii?Q?VGToSQxtE2OUHyWEHvNzmoSuxhqIv1Y43XuYuKGA8B1knO49KKF+6n5PtC3l?=
 =?us-ascii?Q?DUDxrPOYhtBGNzINW6NHnUgEmlHZdPkGbIYdjfzQS/Msu+yW0Ps3a5fJV158?=
 =?us-ascii?Q?NIygO8RShwNAb1aNBgDZZju4OzU/QdCrhXaI8AqJzCa1vS96rMzhim3vwgYX?=
 =?us-ascii?Q?XH3R/UiAiwM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ad7kCmVq8v1HR3Gx9hN8UjePrsTN/bzVKhZVgR+LrfCzd1iwbF78cVUlQrrR?=
 =?us-ascii?Q?XawhoPNshtZh8jLXIOy9cDbbkOg4mKPgg9XsJdJQJmqocTXQ81dQvynsyj+8?=
 =?us-ascii?Q?x1UeO1iW5g/XfX8u0v+MKIn1yA3zD7/MdnJjyjWH9BtDCo2kXQzX9CGgu4uE?=
 =?us-ascii?Q?Xs5og2PkPM4HzoiN1irM472iFa50RDE3hpWh8yK1Hw26j+1T0hkicDO9enIr?=
 =?us-ascii?Q?0yG3S3VBACpYN+T286d7Kr64D9HCLg+FkqBI8llaiA1LK6+xvowYRp9z17iP?=
 =?us-ascii?Q?sfigo1ov5lotIbuF/Q21/T/BXsI1vVOLSBTd9dbXESFZwsER7Bj4OZtE+oKX?=
 =?us-ascii?Q?qevjD+Qlmd++ywIVsDPRHzFEi88vzr3PH9VYOvyNe4KXXXPjKaLQrrirhJkJ?=
 =?us-ascii?Q?RzUtnoPTAfMpAwShgno6j6vARzbgc4ZJDDxvjy2PQik6GuVNgW0d+Mruv2FK?=
 =?us-ascii?Q?d1Iq0Zk45/Ds77R0PsvKxxSJLnANNWGakekOn5YB7tOWNTQxvM+47VOYZDEi?=
 =?us-ascii?Q?r1FU/6ybJdNsoXRIu68Igh6TFo7V05kHvUPOo3Ws6CI7RtEM194KjIIS7Nnr?=
 =?us-ascii?Q?jNn8Jh9VAARaekEyYgyVvHIZahyyBv2FBLbcHiBrkXIBw6tw3j1R72JVdxob?=
 =?us-ascii?Q?WHGPDwz5CStaNhrjKbP/hnaWBdDirRmlzhpg+yB5WezL5xz1aIDDVQ67wD9K?=
 =?us-ascii?Q?2MgzO+wkvAGLzU2e5VW3ToyDwLEVhcPwXeuWn53nYbqlhr4xsIQR7BTSUYvR?=
 =?us-ascii?Q?/MKm/rVmPt/UP927wIfOEEJoSygawR+4zlrKjRZHThRb2MpkvqOE6FUJ0Js/?=
 =?us-ascii?Q?bWh5C9zi0FXQxUHKC9tXVc5CgiwbV7H18OJ0HTNAoeZVG5CnxG8D/n/BCrae?=
 =?us-ascii?Q?+VUQZj99269cKK1l+zqP6ChIVHKvy6HaZJ3MskDb7qg/Gvq6nXyGVmcIgaR+?=
 =?us-ascii?Q?FzJb55VXSfb4MoUmavwNaSrg9JJ05TAT1ZPt0cwryx4oqRvBqJJhQvD9MOOP?=
 =?us-ascii?Q?bE/gAnYJDm+DM5eWLAoIVnbgzciav5hTxIrnKgHxICV5W1lDQlilADoZD5aR?=
 =?us-ascii?Q?AX1uFN6vZZdqM57VdB/VWwej6j5RLSY35KQSCeDnBSXF8kdoNnHo6S2yOsvT?=
 =?us-ascii?Q?BiZojKrssE5J1yu87oR98Tj1BqCyJlqwx3vBMq3lmfQUwwd2kgCKk5mmAVze?=
 =?us-ascii?Q?t1a+LZqagULO1wG2kyRIhWgC8qVSWn7Hf2lmjabs8tYgHpfJHKEPUdUDew3j?=
 =?us-ascii?Q?vpncJc87AUcnwSfHCcYKQAf7hKvcJP8muPqAEvo0LxVFrV+iHrVOBcfTf61Z?=
 =?us-ascii?Q?A9syNYznEXDmIYwRTL/XYCJYJ3MyjbRazz9gpeqkxku3HF25EhR9gzGvycx+?=
 =?us-ascii?Q?YeZRxbpkU6csWYwcXwre1us+vZH1I6lu7CBhQGLbvskkeztL0E6CqPsd3NlL?=
 =?us-ascii?Q?Y6zFCWNxIRtL3gdkfH8k3vsvtFDSiqv743w64dK3tdY0vP/h+1xd3vyrX0Nn?=
 =?us-ascii?Q?VKPUg80XqWoyFRMidrlAvx9Tj1dcc7hCBNqxsRY/UWFhieLoeWptOZW7NVYK?=
 =?us-ascii?Q?tBYd2/KTLz1vijPpPSG0jJnTLWmT3HWbR3T+h29qT532CHq3jb24uwU7+i4+?=
 =?us-ascii?Q?/RQttRihsvUOgH8z+CgonxVrIHlvEfrpuVa/L8wpg8hlMM/hM1uR6ZXQwGg+?=
 =?us-ascii?Q?3ET/cA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	bZNLTIz7Ov/SMU6nvw5rKh8lJhZlRRsLBVF2Q2uhynGraZZe0Kia/qX7BLGGS6fGulZuJNl/fM9JhdIo8jbeCdZtJ34kDeRy71PEj/jGQfLIG4GdirvnITLqtt1iBRlf1vOZHntOCW+YxEVC1yGWL4u2cxnqeHrb1EavDXC0xaGHTOQUZeGiyy8u3pYP01nPpkCRRLzyfFOE5CruhtAYWXTaD6y3s//sI13Z/OSzfFF/acNRBg8Vf69ZFMCtTW4cHX/ukLam1MtEQ0NyOeHf49UY6H7oX5XnUt6B9r9To6J+tRTxR+BUvyj0kSGKv7YecFJ0pfrZKasAj9fdGoDLCIr6nEy5/TJl3z1/5va4Kupm3szCffFtoDVG5ipzxEs2ATK2rR+r2Ut5ugxpgwj+dwEt8pt9yCWPlBoK8peyW17sB5g9rdvOSzkT582Q4lvY6XuYg4/svIH7ZaPjQOHh6vnRzinCmhfqQrX7nWeKBeplan9GzfgShSmZk8Btk5zxoVjNvt8mXp88pmbBaGJMLXiqTpTBeLxhOrg6GZkarSYJJxQCCogh2t6FnJPWHshk4xjcxwve5tDMIiZOh5bbnd8yKYRCpXpAqB+LndXXiLg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b7cec3f-87d4-4541-0dd4-08dda3e5a365
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2025 04:01:24.3585
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eLsfGmwkrz8rGyN/m9ZcZVoZrEN9Ojg0/80i0DyqchaZ5lXCDJWqGXqZcNnHFpTW9P0JD8dX8BqqoaM8jGuMnwEnu8WNIyGzH3IfW5TYC+k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6723
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-05_01,2025-06-03_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 bulkscore=0 spamscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506050031
X-Authority-Analysis: v=2.4 cv=Va/3PEp9 c=1 sm=1 tr=0 ts=68411698 cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=mMjgV5l9Tzkeoy6GIG0A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjA1MDAzMSBTYWx0ZWRfX81wU3TRzCorq GJYHpSiuXQyGmE7KkUn3pjd9nR90QUtKlhsimmQ7eQOBd6cFW7Fmy3HeBYZjCYDvHdH+arJws8y G+OAuhwoLDFK7C/jTs0BaqTisoZSoA11OGvLwrxGTjh0Bx7pB/tW2WN3iQ1fxctWvZGmiQM6MsA
 xxb99qL0DwgQyMwq82+ggjcdeJk/bsomrtH+vW7sxfeO9vgIU+aBa7Ip91ZkvjhdYlQ2SUc/SpX PWBeEWBRZwnIqkl72nT5MdO3/m9uRyCCk8LAI0gGf6mfMzAj1nv38ZTzQxfN6oOCihNZh7iFJJO EYS6aZ00Fy0LX8VAyRqVAkaTRAm1t5ukzP32VWJqGIKa/WbsGdlDiZsCzM2G9tytWblutd0cAwQ
 TV/Yoxt0bWcdOYr0sooRgAraEYTJYqV36SGhb998vVuR/U6B/SWzqRz0lEepRq9mTSZHS7Zf
X-Proofpoint-ORIG-GUID: _98ZbOtzXN_ND18PXB8CAwTA9Um7eG71
X-Proofpoint-GUID: _98ZbOtzXN_ND18PXB8CAwTA9Um7eG71

Hi all,

This series contains the tests from patch 6 of the previous atomic writes test series.
https://lore.kernel.org/linux-xfs/20250520013400.36830-1-catherine.hoang@oracle.com/

Relevant changes from v2->v3:
- add a new _require_scratch_write_atomic_multi_fsblock function
- split xfs tests into a separate patch
- split mixed mapping test into two separate tests (reflink and non-reflink)
- generic/1222: check that required xfs_io commands are present when using
  scsi_debug
- generic/1225: add more tests for unwritten and interweaved mappings

This series is based on for-next at the time of sending.

Catherine Hoang (3):
  common/atomicwrites: add helper for multi block atomic writes
  generic: various atomic write tests with scsi_debug
  xfs: more multi-block atomic writes tests

 common/atomicwrites    |  31 ++++++++++
 tests/generic/1222     |  89 ++++++++++++++++++++++++++++
 tests/generic/1222.out |  10 ++++
 tests/generic/1223     |  67 +++++++++++++++++++++
 tests/generic/1223.out |   9 +++
 tests/generic/1224     |  86 +++++++++++++++++++++++++++
 tests/generic/1224.out |  16 ++++++
 tests/generic/1225     | 128 +++++++++++++++++++++++++++++++++++++++++
 tests/generic/1225.out |  21 +++++++
 tests/xfs/1216         |  68 ++++++++++++++++++++++
 tests/xfs/1216.out     |   9 +++
 tests/xfs/1217         |  71 +++++++++++++++++++++++
 tests/xfs/1217.out     |   3 +
 tests/xfs/1218         |  60 +++++++++++++++++++
 tests/xfs/1218.out     |  15 +++++
 15 files changed, 683 insertions(+)
 create mode 100755 tests/generic/1222
 create mode 100644 tests/generic/1222.out
 create mode 100755 tests/generic/1223
 create mode 100644 tests/generic/1223.out
 create mode 100755 tests/generic/1224
 create mode 100644 tests/generic/1224.out
 create mode 100755 tests/generic/1225
 create mode 100644 tests/generic/1225.out
 create mode 100755 tests/xfs/1216
 create mode 100644 tests/xfs/1216.out
 create mode 100755 tests/xfs/1217
 create mode 100644 tests/xfs/1217.out
 create mode 100755 tests/xfs/1218
 create mode 100644 tests/xfs/1218.out

-- 
2.34.1

