Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC423B42CD;
	Tue,  4 Aug 2026 12:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785848175; cv=fail; b=rVJmof9hckubmjZiRhFT6O43zdjGkTPV+kyzrKpoZdQpF8Vhvi1FQ3njfuU11i4BL51uTmJKp7zfXTg0knYi6JolcSU+mNz0HewpP2khKooSqW9Lii21lMCAfg4MidrThWyB45fxSzUTtNNhtTS0NSBFnmuyjrib1Y5AZQ+wUSU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785848175; c=relaxed/simple;
	bh=l/MOmvp/Je/pjqN+qTW5Tcszxq/Wybie3BzPCk8SVWk=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Pe20dEP5Nr2jarO6Qysv3X20EjfBu3z/ErYtEpxW4ReRQsgBTptjNYCQMh/0DcY5e5+8qMQORpOg48FF5MnDbnkI9GdtQOc82o2HhieNmTVia6yoZ4aHwYLz1yUBXOFn1bPeaheMcqd1uz9eHH13TTyCZAXfIs+uy0T8a+Ux1Ng=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eyoTcstX; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=MNHzNbzT; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eyoTcstX";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="MNHzNbzT"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 673LAiK72697832;
	Tue, 4 Aug 2026 12:56:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=eDwTBzmLrl6frbSviD
	MqV//95o9ZadgKLIaB/1mwjkw=; b=eyoTcstXuMBEApiEM5GyCkDjecxNWzqNwu
	W0ERJgMvcVNRSR1ybDGZ93CtIvjWHfJBZok4H/A8278kuXiIXhE8veSdEDEk+Xf9
	4T5Bne+TIYh1ElXxNx23UFfxOtTGfGd/vyGjXqYGLoeyjT2WXYPtfyr8GGx3dtqt
	7xyPZ+Jth5TSt+o1rUTYK4h6vyCt5btuAfK/Isgx9Tp2pzUNM3NZenx0XIbYVADB
	cK5FZ1DaQQL4xMWJIT4dAKNvXFPAK2LGlqJolbJ9aJfQE7FQdRPnx6fheVzEIKhy
	0LDeBtLXqUmWSKGtiYg7qUZ8SwxQrOvTBNLc+cPA3Nz//q7UlEAw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fs77enpxx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Aug 2026 12:56:04 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 674CoBOJ014299;
	Tue, 4 Aug 2026 12:56:03 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010042.outbound.protection.outlook.com [52.101.201.42])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fs78c2hab-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 04 Aug 2026 12:56:03 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LCBfxemdQvE6GRk31Vg/7YI6QQ2gtsSei+zkGM1ZOsekiN0XqYPdqHIl0mJmz69FZuqq202Gusbai3tTEZIFvp6YNuzB+ZLbYYlw/eQVcUnfezuq51M/cbNNuPefWReX9d1aZ/OGwhar55I58HLe3Y/R4wlyW3sWh7bzNPxhi5pqaJsrMP9y+wUgyPehgoEPrYJUBz+lxgSe63/sm09Wm4sdI6v2G2f4OUdNuC6/3ViWxODx5r/ugnWH7SHByh9qYKUr8+h92OaelXWOpxwtaA7WzbcuzQ4Gs80jmTA9S+gJrhcDb+XsyAWAxtWqBitVkakicagGXz01W2+AGMUSAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eDwTBzmLrl6frbSviDMqV//95o9ZadgKLIaB/1mwjkw=;
 b=m3o8WOp10HXShk4H9BgAUpeWhHV/y2wG5F4yu9MYT9WhiN5WXJDDQyiVU6ij4RBvX5d9GPwQ5XMC5EB1JPC+O3L5WwMOyrgnMX0F5JL/ykFiw0Qm2dGl99c1/x3gAhswt2N48H27zd2H96qkNZGdX/sSP+ckjXyNJaC4ZHS4lPWVDBGklgzoIWo79wJB97z3AiZrvLp2A37Xf6aOuCcFa1I3wLyaucMFIu0yAAZc9TADqlM6M8pbF3VxSM3mgz2xuiT51jdkPFNdUJrTwRylxmYC2ENNw+5eIyfiwY6DQPku9cJ8H6TawBV6nq9EFiHqgsdBhG+EaRYabFu/teFQ9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eDwTBzmLrl6frbSviDMqV//95o9ZadgKLIaB/1mwjkw=;
 b=MNHzNbzTUZ+lxGC4hr3b++ULYwL7CEaoJGLhUlc21IbPHcSd/SvQ7aKyqnAVhow4HDN3u7qpE5m4brXJIvUh45Ja4nCT4q4z9Q/n208VYFXoFDyVwhHVRQxaqUizyPyxMQ7Kd8qvz9ZV7bCAwK7HPlmtSW/vTEBZtCio6qQAR4w=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CY5PR10MB5940.namprd10.prod.outlook.com (2603:10b6:930:2b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.15; Tue, 4 Aug
 2026 12:55:59 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0270.016; Tue, 4 Aug 2026
 12:55:58 +0000
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Kanchan Joshi <joshi.k@samsung.com>,
        Anuj
 Gupta <anuj20.g@samsung.com>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>, linux-block@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: fix fs-integrity for non-PI metadata v3
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260804123928.736596-1-hch@lst.de> (Christoph Hellwig's message
	of "Tue, 4 Aug 2026 05:39:22 -0700")
Organization: Oracle Corporation
Message-ID: <yq11pce6o5d.fsf@ca-mkp.ca.oracle.com>
References: <20260804123928.736596-1-hch@lst.de>
Date: Tue, 04 Aug 2026 08:55:56 -0400
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0025.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:86::29) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CY5PR10MB5940:EE_
X-MS-Office365-Filtering-Correlation-Id: 461b654f-8626-446a-c298-08def227ba6d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|10067099003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	f9OUaun+xIsEVDPd7hNXRlOJVoD1cHF32h3CRySb4Nap79zWKi4E9+PCGfiaWlPuvPD2eWiE8aD+qsd61mz1xykkB3OPEZDmwnwOXOzIp5FrS4ASw55TOcPg6Yb+02kn23QzhCnflRqBVOCGIosAmf3UHztKyKEQnpqlhD5Fy0/iEjTiVTZZD3aTjzztkOuKxZ8t+lM55BJ2DCdafcmlGW4l99BqfA6+ScNlAOcfAqPkjmv5quB1NEgLy8kwNtDu7Yce/jSaA6djIy9oMYBD5eXyv48uMFHXHhjKhfQGNCadcNdpXkBlSjZDD+09rVZIfB1Kxvm0gpMXcPsmXXtNBZFwQ2u5VwslWr1ecc/1AlqFqBY/kidSQhVUy/waNfaElJ8dJX2viU0X9LkRAOudCibSGQye2aDvNDv9d7ljl9EaE/unPXvdysNesXXqLd3rJPuNF/OJUreSOnsjYci6mToFJ1hQooh4B7n/qezl1S8Wk0+x4quK0O2RlZ1e2njLFE38Hkx1XBnDu6QRTI2U0rW/SIJ97qEJ92apV2VxefH/1jweClVGum59q26ATcQsYEoUjbffVxjuAZhcwJXsIUBQdb8C1tr/FcQ3p63fh3M1DeJ154OR9thH70kqC9XouMlyr34jye7wQxSDmg9PPqiSZrds1BP44c0KP4dP2uQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(10067099003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?329YOr7OV3qvgWONGMO3fiF19yypxHz+T5kcxWRYu6PaPHLUrKxFfoLTJqBW?=
 =?us-ascii?Q?Wx84GHEE+KKFNrENFiiqioJ+91i0VpiNTn9tOOWAI1t2XzAU7IZCHTZz5Nv7?=
 =?us-ascii?Q?fl5TOiBv/PSfaxHShsqo5O8ZgiiMd6Z1R5hMnvv8MFJYVfnsgDXPRwzuYHgo?=
 =?us-ascii?Q?D8dv7d+/FC5oxXyV59doOW9pITTnxSR7FukriflvcvmGreQe2jhjTPgtyZnk?=
 =?us-ascii?Q?Fx1lJtItMK2s02i5eiM/O385mGplTi8H16Oa2jutPtptVCzKEVVcShaJuE7b?=
 =?us-ascii?Q?t7ECggn2o71+XyU22k2PgyIK9O/Nhsa4YKio5KHajWFy3q2JyAMyk2/uac6y?=
 =?us-ascii?Q?uX4Xje8d8EfRLrWycFvo4XU3zaoeMOrBKn/Ggsk0P7ejFzD0q4kwvCIsCNT6?=
 =?us-ascii?Q?JcFWyN4pZHyQ7yuiSTKbRWLw2ABM3SygHQVgmC+p7q2DzMFmI+U93yuzqZ7L?=
 =?us-ascii?Q?VCObA90/lycXPhagCvYyGXJeP59xBir11C2PHoqMbFBcZ9+AaR/E6jR6MxJX?=
 =?us-ascii?Q?NAYnYIosCf5mU9UKtZLh4ktzh/kIW2gRe8+DhrwTdXFlyWW8cf67HLMn5/+W?=
 =?us-ascii?Q?uVI1jJqo8ryOgw9JuEKLp5IM7Wz5tkGc8Bhl7UnlgKmn/U3ZZjsDrMr6kwJH?=
 =?us-ascii?Q?wgYbmyUSnFxGSq13NGu2v1qOaGfMEnAdHuZ6PwxCSzCtsmfbH6Z9ZAPbS6Ez?=
 =?us-ascii?Q?/mGKItVuxled+fRPjFpnyqUmmdhJXnuLbVZpVI7/3WhbWvZmivmNCRLE8te3?=
 =?us-ascii?Q?r0Mjbgw2dczyFSTQFnz1mtVK+Nv3pvZbitCaFharch6ZSy10Jbc/WZzMtTRJ?=
 =?us-ascii?Q?1VqMUmc8JciQjbXTJSPRTfrIAGPEfnqmKqqriA0a3GCuXXZnBglsMq6I7e6I?=
 =?us-ascii?Q?bpj/GCMOKbsEaFjrc8Wi9z7fwbISYPjowwWOtQ4ydXOzWtI+8cCy0kgMOAVw?=
 =?us-ascii?Q?87aN/A4oXr+tt2m+Xy6zUakE1rk122jEU8pffdbawwQY2IGFmE4ZBFW2rVsD?=
 =?us-ascii?Q?M9/YDpkPqESxJFACavuYtb/b4M3MoGZHOGjyLu/kdNT+u50q/0sQM/vqNz1E?=
 =?us-ascii?Q?V2nvM3BhoNbNcY1b0L3PRxLU7t1wwr+5Jo8vAMJfEec9eZxQCXdG7xzthFwj?=
 =?us-ascii?Q?muM58Cx7r401lBigcR7/mzEqSvMwy9mjyuP7m39trzPuOMoW/3VeMtTjjhLT?=
 =?us-ascii?Q?JCNNtSqrhzpwIMnfGccr2aAzkSZeCJO+H4DTIUkjhIaNDaGeq3w5CDcjbDlQ?=
 =?us-ascii?Q?qhBivrhNsXxplOXeM3z9NZFEEc9kruBWSMp7XFJuLFo0MLerwRVbN9Dc7O+b?=
 =?us-ascii?Q?p/auZ5x/qnpmQqKKZ/vf2QHgOie2VIfbXMonGE4pg9MURdT5K78Kc39Klxpx?=
 =?us-ascii?Q?kXLy60leJHEuudB1fvl3FqSVrrk1vgeLonb4r+CitkEyS3QKTMQdGnGbKj4r?=
 =?us-ascii?Q?yXDnT7AjxmSPs27D+dformoKdf+Dq2hq3EpvCGfR/aCDusm3ID9LFEnFbuGV?=
 =?us-ascii?Q?gcxnBf8+bv4uC/A9lya3h6eRkyqQbJ78opYTNAy2B/gHmJnzHoRPqZ5I27DF?=
 =?us-ascii?Q?ykYtPyqIQZHopwxCBuHRRteazyP9akB7LhyaAT6KspoMWN1Sz/SY9iBG3F+b?=
 =?us-ascii?Q?lJA264XZ19KZ96+CtchA6K21uD6EN61AhVNRWPIw84xlEYhon6URa9qanIxQ?=
 =?us-ascii?Q?Pfw84gYkXtQF559A1ITLWQSYw84BRaU326GmVGp8HORqppJMKemjge/h8Lhy?=
 =?us-ascii?Q?+1M5VU3v0a3dICow8CdZztuQ6AJAzQw=3D?=
X-Exchange-RoutingPolicyChecked:
	N3LVEeJxIGRHRGe3/c0ozoONswJTDx7+WqxVfWAwtYgohgiZ2H8eRCK8oNe0mx6Dl8fDn+q0S3HeIbnguYNeuBAUuET95FU1gd9iu0YFl2+yHnESj/1uwRYRplkg71r8xbdDEWtSvXAuwhvcfIALcYKpZGcBqnLZ0ic+86HCAe2hMIAcebGl5hN3q70vLxd2PQoisgJl1svZCp+sZfEEMrZrJ6MeXswZ41N3Iemlzr5XOsOlbbyKzBZ0Guhm0tPUdYLpcqZBYoqKaGJVCEiA5F7B4CCsLev7B9Y0ZbTcSF8YxdKUKCJhO5v+pLi83EjmPHGYg5Puwg06oSBUZx6GzA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hsTZ4ZqkOcINojj9aHV7Auc8DOllSw+Oq2rQcb7wULyaxw6e1ZBX0GVgsWbpmMOd4doNHSVwHS7xMMlnRLSrO8pVLacvNrHWYtcuh08P+mnOvb1GTJu7D09Wjj20OVe+1bWNJhz8DIO+SvitSMGqRFllnn9fee5Cu90Rz9PRPU+9Xu/f0hkWE7Ht1OIdsPM9iP07u5ViKYs50hL6lM33sy7Vxs6lbI9ucN/oj7Zx0ol0F6s52Y7kt6C6Vn1Z4NCfKl1+ERU3+7ddYSieIGZNoIPmHNknUfSc/gc8UOJ6GLeeBigFhdQXpsKbWoHcQ44JyApVJlvRs/iRjK4tDc7Kq0r/d1ufcUOdd3fy6a4J0e6kkqtF6IeBO22vv/W7TEf+gRdRVyHmYLYOPw3ALW0MSRFgf+KiJyPy2hR2cjpUbT5BP3tavWBhGvogvz4S7jsm9eETSGMtdw6AMdV1C7MldSl5U94bDsXcxu+uMLYQhY8sK+TI7/vSFyj41khGTWU/DVZO4a3VgeZVJurdkqEuy7tDH9Oio2qA8Hd+Op2TP22zQejlv0OsMRsgez7WPxluXy36amRCd6ZmP9tv7Rn0/IcOuGcjXuRRTgCWizsl9iM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 461b654f-8626-446a-c298-08def227ba6d
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2026 12:55:58.5607
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KBu5KEziYxn64lkE09s976GbF+t0QFb0c1o7RZsduu0jF7fN9Cd01EpFjpxVRNQPky2d8jKv3FdcqI3yLjdDzWbVDaWuWG3jvVM4cvQe1q8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB5940
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-04_03,2026-08-03_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 mlxscore=0 bulkscore=0
 spamscore=0 malwarescore=0 mlxlogscore=999 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2608040103
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA0MDEwMyBTYWx0ZWRfX1VMNkUbS2gDf
 7r0cz3tew6XdfFgIMuwGRFaOiQ7f3cwXzueQirocqcB1auILOxTJFlEgHUM1JYTn7eIpbEr84+6
 sY+m7FziKONZ2qnKs9ANouz86xWdZiQOb9ML6Ou+zVoCMYy5KIfxZxksXb52Mba9HMTVz/T0DoP
 toPwNnZrFqHbjnFLWD2jL1sJJZAv8SZJtp4WOmwAEy60+HsKYieVIom/xKmef2WkcOC+chzR9mv
 unLGDt+qR8Zfu3oNs6OsnY4K38nqx1DCDsRgu4CikYREHY1pTvHAhZTO/VYcjx28jknky0sS5+1
 C/c3c/8DjKQrQVlgZjFaSQPNSlIm4RG6TrrwkiRj0UQ4ESvGU6zUcFS0ns+YkpqEeU8L4/Eskba
 tMW8bDERRRr2YUxW1Goq5Mxr+vhmJVYDcbhlK8rZcjJ98zVpbam+v6PxwnOYytmBQEDX5tvsV/K
 xWcuZahQ3+endfCBdnw==
X-Proofpoint-GUID: BqbxES8hsMhremc9ZwKRPFzuLw0EDYmH
X-Authority-Analysis: v=2.4 cv=OqZ/DS/t c=1 sm=1 tr=0 ts=6a71e164 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Sv0fKeRqtYgA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x4eqshVgHu-cdnggieHk:22 a=yPCof4ZbAAAA:8 a=ZKNfoTd1Dl6EU1cwPjYA:9
 a=MTAcVbZMd_8A:10 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-ORIG-GUID: BqbxES8hsMhremc9ZwKRPFzuLw0EDYmH
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA0MDEwMyBTYWx0ZWRfX0cbsxJfbgyBw
 X4pp8n2Z0QEx4l/cOJNGs2fWTG7HJuK+Ma743AtLQ7eVY1J/iSu3v3aBL0aw9Nr046fidaLHVVC
 GvmwkSabJsqToJ4ixXocSHGzqL7bjVcr76tzZexs669J4uY3I9PY


Christoph,

> this series fixes incorrect calls into the PI generation helpers when
> using fs-integrity on devics with non-PI metadata, which can cause
> kernel crashes.

Looks fine.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen
