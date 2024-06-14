Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30053183094
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 01:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718329811; cv=fail; b=ZMRpYmLf0KeN3QeYd7Jh6N794oiE9L/i7a0QjWT3Zl8eyrW7PxQxA6Q5YN7PWr1VXh3cB+rDpRth7HhSW9bvy65npmxrcWxLCrE2rFy8qaSCjAmrkCLLEgm3b/a1Krma0OlrDKqC9NRTs6Sk5vSjJZ7OwlN4N1pHjexwgMYAOlg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718329811; c=relaxed/simple;
	bh=3/Whu5djeSVVuU2sxYhU5fUwPh7ZdzfRED4VPPG62PU=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jzbcZIQb6YUR1AzIK0LNOfaT5QQ6fS19ygXLFoMAebE7aOlJX5wZk9Gu/MK4MDM1JNvNmYa42trWzbsA9figXiQE881LQh0NI6uwlQw2/egfxznE7xjisIYUnd5jyix1QniJmtWupiMlm73CMiqTO3W2kVKj9jY/GWhnfYUydD8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oDNoZYuX; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=r7/uC72U; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oDNoZYuX";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="r7/uC72U"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45E1fpDq029945
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 01:50:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=5xgls130spLE51iyGYJRg6WubAZle7LHF/OhLQev2R8=; b=
	oDNoZYuXefwcnS4S7YrePPql0prhwTUcazUgSAx1AbaAhWK1sgNcajgQZEM7uJM+
	shMAHs8B1cgxaGD/VMeUpSO8Y/oQqNPFveuZ4kH0EXHAsd49OlGJSXUlWQ8Pa8Fe
	I4gb2HKl4l4wosybt/t9vejb6LAIWk90Dy28qgFNZsZNWg7YPdOubNr7QIGf3m0+
	Bqctv+Ev/3Juo0PoNCeTX4c0OLc5lsPcroyPHydXU0R0xsq825NLkG+n24fwHojb
	D2hll2s2kJnZTgeWUbIp/foGV9MKBkjCzIQQ6LYKnBzu9qBSbegfqJd3XimERdKE
	RhWn1XEfdE1Mkuym0eNC+g==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ymh3pangp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 01:50:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45DNDhaE012526
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 01:50:08 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ynca1uw1k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 01:50:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b7X04BBSw7TQ6zM16NJNHeAYqZ+xHBSwQeQ1sWMuIFTqFzsFC90dMiB0iBHqerJiHA2K97ovSvN9W+Pt7qmyhyfOwD5+nrtOe7edIF8FqgNCgOKsz8Pd1AC9+H551pPEivqHrd5PYI7pM70cH7gfVsvZtLaNmbTx+lYsmP+VFFcu8GGKp1cnMxwlrwvozipBtz5s/PDIeaxrGI+9ToUmLUDJ8mr6VeuCC+wTv1BjuPAo7Q02Jinr6gvAAyI4kSGHIyn36IfJAe6DVQOwdxkmNmoTeLUOkgYiweqH0knjtxl6MeMAVAJVSg1MJsiTKmgi+pHP1KrMhiaQAaP3LAM7SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5xgls130spLE51iyGYJRg6WubAZle7LHF/OhLQev2R8=;
 b=hzjQhQ4MM84foL5JuF5qr7vSsjcjABSUtQG0DLdKHWlpFpC18IjjF/hPdPZ++u5nGnJqmaHPnplcbLOUTYxV980i7YXwIg/MdDTfLdJM40+zWrEVdw+9KKfSwL258Bl6d4aSaAxRE1IvO1QnnvH+pa0R2O7luR3uyxH/wHoRjMzuW1e0oKGGNhK0UN7E/wyy0USmgKMOWQ+Odk69GCYIkXJaPUkd5PDTsd5OKDYAEGKYfA2fRzMWDpgkW6ZfV8n1R+Vst0pJkvF6wsjNT1V9v1T525iuxmQ8VI9xzvRf2DJzvLDHpMu9n09vmeBTa4jrfmVO9g3NCIZ3vF3eTQDRIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5xgls130spLE51iyGYJRg6WubAZle7LHF/OhLQev2R8=;
 b=r7/uC72UMNVlNm8uIakxl3lkLL2kqosszoB5UWodA9LQC9VW1ify2M4cnZ9/hiFtFJWkJo9WpSuvnleU3v6AUOTvip/ZVLGQ4nsyYfkXPFgHMeRvFfNkSgN/FOjsaImLJkVmzIIy+JcCv9PZ19WOL6JnS6K8qy6TxUsbj3qf/EY=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DM4PR10MB7475.namprd10.prod.outlook.com (2603:10b6:8:187::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.20; Fri, 14 Jun
 2024 01:50:05 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%5]) with mapi id 15.20.7677.024; Fri, 14 Jun 2024
 01:50:05 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 7/8] xfs: don't use current->journal_info
Date: Thu, 13 Jun 2024 18:49:45 -0700
Message-Id: <20240614014946.43237-8-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20240614014946.43237-1-catherine.hoang@oracle.com>
References: <20240614014946.43237-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0010.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::15) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|DM4PR10MB7475:EE_
X-MS-Office365-Filtering-Correlation-Id: 3612999f-d5db-4132-cbed-08dc8c145009
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230035|1800799019|366011|376009;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?1n54AWagXwT6iubCERFehI43G5OakHea2NqovXzxn3OyYRJ/017mrp4GJ0ub?=
 =?us-ascii?Q?dcd73JQ4eoH+9bjkRBz8Fw/qFna2EaLBCnJqnbCzixHitn4meUyxeIJPKv9B?=
 =?us-ascii?Q?QgRi9sxpjL4JWHhxjg9+ivgxw6se2bfNNVaZLBdxVXi7aeQk2mebGTXpvs/X?=
 =?us-ascii?Q?kM2RGyYRCGb99InjgnHvTe8ulvNgAwWRIj6iZ8lgeqf7MjPO1i709dlpurf9?=
 =?us-ascii?Q?vnFyXBKJtkx77U0Hhv1ndb9tJg3jB/3bIc04a/avLB0hpKrNQ0aTrDrk2Q4L?=
 =?us-ascii?Q?2V8MdzoA+4IVCJp9brT67gz0sDfzpNWsquI/P9JKtx+1W3qChHrtzpnDMUhw?=
 =?us-ascii?Q?jijhQeQK9Un70ZnU9+p4gJruHUg5bQh64JEEhbnFcZrJ/bE3uIhMJdZrpA7j?=
 =?us-ascii?Q?F/tnt5MBj3aQq6rW35zeG0XlfQrHZQjRd0BhBVOxkUTr3NrTiV5D+g9r5EUc?=
 =?us-ascii?Q?xwEgxUwYklp2H90cfZb0pTXC2fZXuDROLIZt9lUhC8Y2C446iAQYx41xtWir?=
 =?us-ascii?Q?aqdxZ+GuQd7ZMGzibSLi80xsxrpYeS45cYT4ldCFwqRK0Kwux4/D6cUINAeB?=
 =?us-ascii?Q?xaQ0kyu8s081EtQqhKWgzUJZuJXxwFfcgMKt9ceGXSydXQA557ewaVcBPPb5?=
 =?us-ascii?Q?ygjbhNQJi4HHEFPh2wQPJ9/R9vt9UbFtrTbEEx841tCeRViWofRQMRytSL5e?=
 =?us-ascii?Q?0WpciRMKoO376yJD/F58VNxA1wOLnbhLyBnmX8RqNhMUW69sDbW/znKIOlIE?=
 =?us-ascii?Q?gCjm7zCKyXGW/ApvlwNnPms5/T3OSsQYTyv1SaoW2whFQ8KV+jGIfgK3bGPU?=
 =?us-ascii?Q?OGb6Y9O1KF68jUZwFu+hahjiQsjO1pkTkAvq0Eh25HCc3SXMLkE/z6ZVQq6R?=
 =?us-ascii?Q?qZ0dKo3ZaDChrbUNike9IQrcb6dTaVHqH3II8lr2/13FvR9gASRcyc9Gzzw9?=
 =?us-ascii?Q?9CL1CcOOVtYOplnS1DkYxUriT343QNMCseAfgsGQ35eacLJv3zcgcQTw8wzt?=
 =?us-ascii?Q?wx4HKC0k65b0OhDV9R0BBoZrfnvsJ41Ip8CHMfoGAX2wOAYjBJ4YBSOGG/ch?=
 =?us-ascii?Q?BrpIr38FYU1kArbUdWsQ8GsuxgfO8VhqXTCHGjwphWYmkMdPlY3bEBmRBMdc?=
 =?us-ascii?Q?CoexMMDGrxrcXS5ae+XuBGxR+H5WYWApN57lM7nATsvfg0+MuP4N4Eyp8klq?=
 =?us-ascii?Q?f7SfO8JqzeffVOCoxjD4l5lyqapD2cdrXxJ9GILQU9tOiUarNsppi7Y/6LpN?=
 =?us-ascii?Q?AFutVn7ds2cKNRnd+CGYi+k9mghSGsuEdl8R0vdBLpsh2pUI8wTDnL4Rjy3m?=
 =?us-ascii?Q?urA=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230035)(1800799019)(366011)(376009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?0IGfptyGhOiM/104lzRxaLnqQ2shngQlceZDhL0+Iz5MrYbi1bIPgD5K+pJf?=
 =?us-ascii?Q?TE6SypvtEONbCTq+IDBDsopoC9LSAMOMUxDz6fVm/giIHCUp0x689Z1/2OfS?=
 =?us-ascii?Q?DjQx49Bz1tThGWreDZqDrlAAATVfJ6qJPbXWxEqyGRDfJOhk+rnbrIRgw1Cr?=
 =?us-ascii?Q?3KwaMxgLbh2ya/fCCrDmqVHYAMCoIJ1iMkQ7Xfstqk7yRau2ZxH2ue6sbO6H?=
 =?us-ascii?Q?XnMGZfchGyfj/NuCfXNE+USPMi3iTHIwfueOygC7YDzxXnBNlV+MzMgjG38t?=
 =?us-ascii?Q?hWon/FETuH6+T9Mzlpvk6hzYzYmH3YtAaR/UcDAXh0U7YJl52X/U65/cukix?=
 =?us-ascii?Q?5mxUIUnC5q5a4keMlHvulWZL1dzZdMc+CGPwONPNYSRhiK7uBrsCe+bTt15x?=
 =?us-ascii?Q?5uHBJyaJ9eiVAnjLPxep2Bmq3DQe7AVcOTEhLGw9eyDTsJ+nok7G5sJ88+O4?=
 =?us-ascii?Q?pzxZoq9RKdCrtkT0OdyueSW8j2U4seH9w91tWOZEZjCbCxVGBOOdbzyCWCaZ?=
 =?us-ascii?Q?BcMk+NLamQE2KESjER6CUoYags0W4uR76HUYxYFApOetx5B461l8WOCY+v2o?=
 =?us-ascii?Q?YH5c3qfvwiy8NmLs3EwAYHjX6ra3I9UWNJpW6BOcNxg1dRc9VVKAsLnuPmAi?=
 =?us-ascii?Q?ic6ejNcu68LEA8GwYi96walBdaS7zatcwoyv92m79DUOcXdJyHFOd+24aEca?=
 =?us-ascii?Q?DM0kL5XNINBwgpq/BmW9pWp/Ublye2FKlugq2RvVm832syosV9dl+ZbfiBsU?=
 =?us-ascii?Q?CfWLCaHaH5Z/ClXofYwA6Wy4PN6N8Mnu3suiPJejROZ+yxXUWRTtou73pMdP?=
 =?us-ascii?Q?WmEnOfoZdOQri5EQVOlbvg39tVsi9W75ZaPz2c7aIQ+jzNQ828czc55MgF8B?=
 =?us-ascii?Q?qrji8VOxuLdss+dVvZvKIPNW2QyoUo0HnVgXw9iM7MMO4B3qWpUOnge00uyh?=
 =?us-ascii?Q?Tby+B0r2Hf2AT2tc+Mm6a/lLfvoqaKivVNcRD0boajC3Oeoijy0F9FvOzUgn?=
 =?us-ascii?Q?MQSK25qeQaQQ+DRj+gWYrmjB4h4x/83xkEVVLOaUiQ5QINnz9j5LG6StDAEf?=
 =?us-ascii?Q?gifwObF4cKRwZocKcJesuSIPRIWEFmfGV7iPlrAIii2H7/mF/hjEfAbtw70P?=
 =?us-ascii?Q?TFbw8ZPidiJC/GL4AOoLCFKjAlBNbLLOEPOJGbTZkieOkOTDOHpa96Yyvm1E?=
 =?us-ascii?Q?wsuclE3TeMufg02K6n/z+2vDyTIqRBV2H33PHuIYHCmYLoncAF4zt0V+2pgO?=
 =?us-ascii?Q?nmVYvDkCqX0E8P9lZPiU7v38/XTmZFY+ZpFQbSctUGj+h1fwwoOEhvhMI9yd?=
 =?us-ascii?Q?yhj3CGZU4jfqn4e304xkWpllQjJuEVUYvKgVSCDRfdDSQ+TnJB2/ZS8FFMZY?=
 =?us-ascii?Q?Zy307sLjC9E+drisPWJN2uYypQvF+N8HiBMoVMP+80C1qtsAhxJE+aI+Bstl?=
 =?us-ascii?Q?DKvOUs5pgSMrBQLh482DqKi1iMe7ekguSCQWJMWaDbM0yntvCdJyRjuTJN6G?=
 =?us-ascii?Q?dpYYrlICPsG5XbFnMAC7EPZVnbS0qCAAT1ktwdY/ZnDtyPzYGNxN+/ZRIMZ/?=
 =?us-ascii?Q?UY/9Ypm0RT3vCDhPUsF2+gGrAwglCPH2tE7qEy8gPPf58/3Z1bPdUw9lhJs1?=
 =?us-ascii?Q?l/nNrmbhUn2Iz3OjQrXblNtmZo2LBROZi69pdGEImmJH6TEQhw8WEXOVH1Be?=
 =?us-ascii?Q?VsOdwQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	iorQs06CI7RJ0FEml+oZus1PzR2gLnYrarw1QDAgvZ73yPK2aIxLggQHZTGXVkNyDsmfKDArzqXwNXBD2hY7zkTjfplQojgB4Lhyzw+G/UPw5cAg26W2mdIu4TtEDlwKcQJ3sX3VW1jrhvmVMz6fwR1HG+q/ux4CylFZj8lpFCYCp1ziu4+y8B3QfZM6Pcz65h8fRvkTwSb2906hMzBVAtaxDiB389+f7CNFA/t9lTcC7flu9P2/8bPRvtBytqG8WNjYVPhQnrt5LgM2cf8K4z/lWaICMviQHiDF/JBdk6/zYFWtfiMBziYPJaNcKXyPaEPANkwNIUXHHpajbWDcDWO2Bi9bypMgTWnM3/d2kPk8RiZ6XA4upRMJmtvc6BjwmU2GnKV5PFX8c5djwW4BzAiZwOy6z9SfT7DTIlXDVdbL22Z3N9mut+dK2bJ1HMnYTiV0lQAB9Z8ytpInvrW+W5kutVbRfslgFiLkYsAZI0GRCr5+EjO9gRhVUqOioPY4vjh8hMjQoV9Po6o0Bjp/Y2QChYToKdYU+ceSKqi1Bg8cNrI2C1etbJV5Nhbs0JVTSq/ioF1ktsWvvpoG63qGHMcyD70xIGl8Q2Ut3pKFHPo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3612999f-d5db-4132-cbed-08dc8c145009
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2024 01:50:05.1552
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EDsm7IdyN/iuxhaq016m1+rznyTd0NCYHGp8l+61NqFdw4YFPHsMwy/FdZBqP2ASpJ5RM/AHsCpGyycLP4miDZg6dtUSOcx8fGEoJC2fCYs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7475
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-13_15,2024-06-13_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406140009
X-Proofpoint-GUID: JmPaoyfbcNQMAeWFTaPlAur_rGGnlLhl
X-Proofpoint-ORIG-GUID: JmPaoyfbcNQMAeWFTaPlAur_rGGnlLhl

From: Dave Chinner <dchinner@redhat.com>

commit f2e812c1522dab847912309b00abcc762dd696da upstream.

syzbot reported an ext4 panic during a page fault where found a
journal handle when it didn't expect to find one. The structure
it tripped over had a value of 'TRAN' in the first entry in the
structure, and that indicates it tripped over a struct xfs_trans
instead of a jbd2 handle.

The reason for this is that the page fault was taken during a
copy-out to a user buffer from an xfs bulkstat operation. XFS uses
an "empty" transaction context for bulkstat to do automated metadata
buffer cleanup, and so the transaction context is valid across the
copyout of the bulkstat info into the user buffer.

We are using empty transaction contexts like this in XFS to reduce
the risk of failing to release objects we reference during the
operation, especially during error handling. Hence we really need to
ensure that we can take page faults from these contexts without
leaving landmines for the code processing the page fault to trip
over.

However, this same behaviour could happen from any other filesystem
that triggers a page fault or any other exception that is handled
on-stack from within a task context that has current->journal_info
set.  Having a page fault from some other filesystem bounce into XFS
where we have to run a transaction isn't a bug at all, but the usage
of current->journal_info means that this could result corruption of
the outer task's journal_info structure.

The problem is purely that we now have two different contexts that
now think they own current->journal_info. IOWs, no filesystem can
allow page faults or on-stack exceptions while current->journal_info
is set by the filesystem because the exception processing might use
current->journal_info itself.

If we end up with nested XFS transactions whilst holding an empty
transaction, then it isn't an issue as the outer transaction does
not hold a log reservation. If we ignore the current->journal_info
usage, then the only problem that might occur is a deadlock if the
exception tries to take the same locks the upper context holds.
That, however, is not a problem that setting current->journal_info
would solve, so it's largely an irrelevant concern here.

IOWs, we really only use current->journal_info for a warning check
in xfs_vm_writepages() to ensure we aren't doing writeback from a
transaction context. Writeback might need to do allocation, so it
can need to run transactions itself. Hence it's a debug check to
warn us that we've done something silly, and largely it is not all
that useful.

So let's just remove all the use of current->journal_info in XFS and
get rid of all the potential issues from nested contexts where
current->journal_info might get misused by another filesystem
context.

Reported-by: syzbot+cdee56dbcdf0096ef605@syzkaller.appspotmail.com
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Mark Tinguely <mark.tinguely@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/scrub/common.c | 4 +---
 fs/xfs/xfs_aops.c     | 7 -------
 fs/xfs/xfs_icache.c   | 8 +++++---
 fs/xfs/xfs_trans.h    | 9 +--------
 4 files changed, 7 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 23944fcc1a6c..08e292485268 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -978,9 +978,7 @@ xchk_irele(
 	struct xfs_scrub	*sc,
 	struct xfs_inode	*ip)
 {
-	if (current->journal_info != NULL) {
-		ASSERT(current->journal_info == sc->tp);
-
+	if (sc->tp) {
 		/*
 		 * If we are in a transaction, we /cannot/ drop the inode
 		 * ourselves, because the VFS will trigger writeback, which
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 465d7630bb21..e74097e58097 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -502,13 +502,6 @@ xfs_vm_writepages(
 {
 	struct xfs_writepage_ctx wpc = { };
 
-	/*
-	 * Writing back data in a transaction context can result in recursive
-	 * transactions. This is bad, so issue a warning and get out of here.
-	 */
-	if (WARN_ON_ONCE(current->journal_info))
-		return 0;
-
 	xfs_iflags_clear(XFS_I(mapping->host), XFS_ITRUNCATED);
 	return iomap_writepages(mapping, wbc, &wpc.ctx, &xfs_writeback_ops);
 }
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 3c210ac83713..db88f41c94c6 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -2031,8 +2031,10 @@ xfs_inodegc_want_queue_work(
  *  - Memory shrinkers queued the inactivation worker and it hasn't finished.
  *  - The queue depth exceeds the maximum allowable percpu backlog.
  *
- * Note: If the current thread is running a transaction, we don't ever want to
- * wait for other transactions because that could introduce a deadlock.
+ * Note: If we are in a NOFS context here (e.g. current thread is running a
+ * transaction) the we don't want to block here as inodegc progress may require
+ * filesystem resources we hold to make progress and that could result in a
+ * deadlock. Hence we skip out of here if we are in a scoped NOFS context.
  */
 static inline bool
 xfs_inodegc_want_flush_work(
@@ -2040,7 +2042,7 @@ xfs_inodegc_want_flush_work(
 	unsigned int		items,
 	unsigned int		shrinker_hits)
 {
-	if (current->journal_info)
+	if (current->flags & PF_MEMALLOC_NOFS)
 		return false;
 
 	if (shrinker_hits > 0)
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 4e38357237c3..ead65f5f8dc3 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -277,19 +277,14 @@ static inline void
 xfs_trans_set_context(
 	struct xfs_trans	*tp)
 {
-	ASSERT(current->journal_info == NULL);
 	tp->t_pflags = memalloc_nofs_save();
-	current->journal_info = tp;
 }
 
 static inline void
 xfs_trans_clear_context(
 	struct xfs_trans	*tp)
 {
-	if (current->journal_info == tp) {
-		memalloc_nofs_restore(tp->t_pflags);
-		current->journal_info = NULL;
-	}
+	memalloc_nofs_restore(tp->t_pflags);
 }
 
 static inline void
@@ -297,10 +292,8 @@ xfs_trans_switch_context(
 	struct xfs_trans	*old_tp,
 	struct xfs_trans	*new_tp)
 {
-	ASSERT(current->journal_info == old_tp);
 	new_tp->t_pflags = old_tp->t_pflags;
 	old_tp->t_pflags = 0;
-	current->journal_info = new_tp;
 }
 
 #endif	/* __XFS_TRANS_H__ */
-- 
2.39.3

