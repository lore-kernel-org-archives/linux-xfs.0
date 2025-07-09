Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BADCA2877D7;
	Wed,  9 Jul 2025 10:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752055398; cv=fail; b=H4Wid4zmgNM1IeiZS37zWW1f8BLqb9Iq9j8rXbLLARgAEXB857wmw3XBLk8VxP4wTcUqo+ZqTVdnuuWLBFEdFB23cuLLfU/MAnplHYCgcH2PJNiAVP2Ay9JBK8dYgwwQH1U2ElOgPScaln8GkRPdzJhhdCnjh5twcCT8nOYKDhE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752055398; c=relaxed/simple;
	bh=T8aKtHZ5k7ZD/Ewv4+4mfasvIN9SOkxZciSULt1kvN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cYp7S7HBEROL7uO5HHeGyob+rr3IlXN9YO4L9kq6vnDIJnZ6u4BKfXbQDWYhXDLAtIj1inHsjdZurQHjoD72VTuNZj5VREE5tKL7iE1tZ+jAoKziyoucelMNS+F1Y8RCs2yNM0rzrABI34y2/y3NLo4pbynIlht3RTZgiixJyRE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ARRPI/YO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=PgNeStk0; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ARRPI/YO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="PgNeStk0"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5699YtWp009147;
	Wed, 9 Jul 2025 10:02:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=LBh8aaNl2XS1fgLcvR1qm3BqHnXvvnqOY73f78WI20s=; b=
	ARRPI/YO8HLx7iEbFVgvcSAY8FGYucohcxWUCgmSpIJmhW6nB4CYTcBjruuP4TZb
	StwudSGKOfl1A6MX5YOj+LbxV6GxOlV7h//N+xrDJTO9c2c35SGXj07VoLO49IoW
	zjwQiRjGoRxGV+hheNrO31w6C0nz7/NoGnCCj4so1QZeaY+9Nnsn9pjd0e9KuLWN
	3fNySQbV8yTv0SIY8fuFMkwD3e3ceg6KFCRukspi20uQOGelmnwgwtAEem9nMjZr
	w1BGVJqDyHQyKvnJNsH065q7qgaM3JLjw8P1sn18FyiIiwjeQQ5LEJljvpj5CZzB
	FghcJOz+WwUwqzOFdFi6Zw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47sm6d88vw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Jul 2025 10:02:58 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 569A0Gb8023586;
	Wed, 9 Jul 2025 10:02:57 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2072.outbound.protection.outlook.com [40.107.236.72])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ptgb17y5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Jul 2025 10:02:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x2hqMsQ2mAiva70Qg63iCeFvKM2gshdhMZHG1hUqDMm8VYKgKJehSJq0jdo6jtXGV07gtUzvDpceDNOhqVzP2anwC+iD1cAX0h6UlmfvHdYUIIqVnYgfzoi0ti1pJA3fLh6eOYBwo1JHk2wE2EwtgqLT+EcC3SVobvh88oFJY0WMNwAjPDeAFNjjh6a2kOwWXaEKMr5CC80j37yDr5UzDI2uZEp5IvyiXf3p1NVRfpxjFdhkrwRUGdyAWHVuAkJscJ66BYeo+z4wgRavoFtgD0qmdOGAzOx0Kp3uifQ5P+yezhkOPU+XE7CPaqy0rXaQQgzIgFRqRwAriBralcWlqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LBh8aaNl2XS1fgLcvR1qm3BqHnXvvnqOY73f78WI20s=;
 b=Su+w9EnI4CmtJq5Ub/q0NnBInOEfgZU+U1W3YyHeZ03WC9S5q99PZDWZ3y/35JiWivBM70OGs9VfXu5qTqvAuP1D7npD1YO1Xd5yENU7Zo1eUb/LlA5cSTKGZdODObmwsC0/zQxpDduh/6jvbXrRhiPHnvYdx293LMARPZQtxnwMx3ur8tql0zQIZClJeLemdhPmCLcE6Vn0L5gS2CN7RGKXwcwq9rFeMZjaT0ZGlUMI3M+imureAKcM0rDS9C20PPzDd+Zpp+6fV4pzJXbi39T+WnHk4wjguELaOZjFTQOR4SpaXfNqFyteVF/dgbrq3S2SqBiqU1uNIttRkso9LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LBh8aaNl2XS1fgLcvR1qm3BqHnXvvnqOY73f78WI20s=;
 b=PgNeStk05+tvSHqb2SDlDGE/enEtHjs56E6sKSZFHhCWb5nG01BKejMZqENDLJlErAcBgcePCr5/CcCYxCsXGluc4ANGx+vMg1g4BeWoD1bjSH7B7F7oAdl1BYCvQGLAPXmwYRuO7AcLd3gmv5Vyn2Ce55Dns2whSSxyyVFk6FI=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by PH0PR10MB4744.namprd10.prod.outlook.com (2603:10b6:510:3c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.27; Wed, 9 Jul
 2025 10:02:54 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8901.024; Wed, 9 Jul 2025
 10:02:54 +0000
From: John Garry <john.g.garry@oracle.com>
To: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
        yukuai3@huawei.com, hch@lst.de, nilay@linux.ibm.com, axboe@kernel.dk,
        cem@kernel.org
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com,
        akpm@linux-foundation.org, linux-xfs@vger.kernel.org,
        djwong@kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v5 1/6] ilog2: add max_pow_of_two_factor()
Date: Wed,  9 Jul 2025 10:02:33 +0000
Message-ID: <20250709100238.2295112-2-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250709100238.2295112-1-john.g.garry@oracle.com>
References: <20250709100238.2295112-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH5P222CA0012.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:510:34b::8) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|PH0PR10MB4744:EE_
X-MS-Office365-Filtering-Correlation-Id: 5eaab3d1-879a-415d-7b1f-08ddbecfc5be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3lwKsWsUAzior/j4iaMcLaxv2u2bK03mV/9utizneMkbjt7esJeqT8Ht8SKv?=
 =?us-ascii?Q?ctgAjLgYi2YO9H6QBuwC074S8r1bz9o/yrKOW8h1dclfU3T4/Sx6juKdkkIT?=
 =?us-ascii?Q?gFoH41Mv256pMrIdqm2XqwHVSHxKj9Dz57kScIKLPXL0c83Nc67+pyMtXaUc?=
 =?us-ascii?Q?ML8Q8Xvym6yB+98xbjmDbcouGG6z+MINXqYQPHTBHJgUl6U7K5W36qP+qaTc?=
 =?us-ascii?Q?98SdzUEiCiF5dKAanP1E/mLfWwnLiHjVN2zoweg3HkcP6KOzwvwHyKLOHBnV?=
 =?us-ascii?Q?q/PeEGkhjAYhXI2ke2OTnHvDk4Qrs+CTZCXmoWvan5TCzvw0fJFvsCaZgVPP?=
 =?us-ascii?Q?Ehgom0xys41jlbUX1BhhHTPVPnjZHyYGn3Smi7RQxNumoRwtJVQJAD6QyOQ/?=
 =?us-ascii?Q?5ZEViIqoSyNl6xmgSbGZTZoqmaUl3tBUQAsjlgA0mig6vSQuoNetWLZGb/K8?=
 =?us-ascii?Q?jxkqsY4X4Ww3/Hz1LO4Hn2TYB/hgZ/DYckkVVsuMeH0F3zR/u3NqxkpaDuZf?=
 =?us-ascii?Q?64nJlRRlQrgPN+EzCMY36qmAlvKhu3uksnjFuL5DgQuELGCdmPUtt1kDn7NQ?=
 =?us-ascii?Q?b5HZhXIKOjP6d4TQZPFzAF9t1QgQ2bOwmwDcl6g0iiNUmrmA6GUSVjUS8oys?=
 =?us-ascii?Q?VgoMDp9RJX6rhQD1AN007SzEI+FHj9xQu8ODEv7pfgpD2t7m5XDazaQrGfu1?=
 =?us-ascii?Q?S0TK0ByJIIwBSlQT4ElczdCUQEpNsBD3pXEr2rBb9pdjMQfgK6eF/M5o6cqu?=
 =?us-ascii?Q?BnBeK21m5BtoCh0ehZCCKRE/IgUn6Ena/pLbLGQUKMwm4604p+A3aRhKIfBR?=
 =?us-ascii?Q?9EfFDGmnX9C/fNW/asDFuHQDXNeOIezHgvNnPw+UEg0Jp/w1BaaALvro7P9E?=
 =?us-ascii?Q?tL2xmFMbhlA9Ph67BwLVHWH5Vc3JLEb13XTAvnw6tLfJid2IzqgL9Zy9UsrF?=
 =?us-ascii?Q?SPbXUhYNMUCDErHCjweyvrLsOVclBy+otNpfp+NXrwZ90DujjTodRPRp/1sa?=
 =?us-ascii?Q?kPkzfJnsYJ+NaHbxf3wHBu72fNrEy6AkQO0J/7HUTUdfBRcfY45lGwc1Hyu0?=
 =?us-ascii?Q?HsZYjNYMJL3/VDKi0V7s235+jbSduLI7B86B++214k8P+T2vizCVUtF8h/au?=
 =?us-ascii?Q?FUR+tf+PzVl1XvxUQPJpcKLfE67v+HKmnmeRZpndTXxx+kmSzbVXQy7I1drw?=
 =?us-ascii?Q?Sn45wnUR6l6jI/GtZfjjNCD7z/gr6XjwHyNGJtUOxhQlD2dey+YOkV8OUm/y?=
 =?us-ascii?Q?hkCjENVxXGUMmvfve6aeS4Zp3w/pOnkrKhE8LHW9lVnvU6bqea0Q2Cj3D2YZ?=
 =?us-ascii?Q?KSHtL6tQxOCX8gV/HL7Zse/DK5UshE8R+qBYbjydnA7IGZLmGrNevwq2ksJh?=
 =?us-ascii?Q?QbJtvF7EjRUzTvtt9xox3djuU0JNFdzVRZbM2AgT7MtV3UU9iV3GPXmpK6ji?=
 =?us-ascii?Q?5k/VzTN93XY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uQiv6bMpL1q0m7kUrNfp05s1WloBbJcf6uDk1yX6z7T0aWKbo0pFVyBjX45F?=
 =?us-ascii?Q?x4XB7L15jyXtGZW0SFmJZJHkzMr5qrypD0g4onhPIgECX0CymRg+NjmRhABr?=
 =?us-ascii?Q?XRZ2O2GTZt6kaopnnpazZQExWy1v5lvJU0Uy3F7ccas1aEoQCmrZxOH8raoA?=
 =?us-ascii?Q?P0HFcdYK0BL1E6SBapTh1LvgB0MbqWnhSEAnqYImsa/pOOqNVdlgLX8TN8pl?=
 =?us-ascii?Q?f/7TJyC7YcbW3OH4M59uV/UUbYmSmtbqbQWGViMjbYEM8NDZJePp+QZ6d/2b?=
 =?us-ascii?Q?fhsgijR+lrFFT1i/JIlvvzolqyfFt1ysh9YMHkhImxTe8FUqvMPBOg2zOYsb?=
 =?us-ascii?Q?nV/C1d3+ps+rRihvfvgzOULWKU+qTh2W7SVQFQN74q53tdwssqDQWqY+5Zrh?=
 =?us-ascii?Q?VYBgECwHd27MLF4dgA9PTaczvAo9fCPRVzcVqdWBoEDn/B5SduHCyPZu9QAF?=
 =?us-ascii?Q?Ik87tQcLjt131/K1rS1Oi3vhWmZ0pSaLi+sDNOzOvHBheeCzG1gIk5+oS4lZ?=
 =?us-ascii?Q?RWykTvB/idMaVYonLnqo6JqbyNnOYWQNm3UQbLApUvwf2a00jaLOOxQWFrSM?=
 =?us-ascii?Q?R4KE8srfngp/uF3M1F9apOf955FZFF49dt6SoZ3QiN/FiF/FerP8RXkA0lm4?=
 =?us-ascii?Q?fDrswPs/kBLFnap1g05M4FNPjh7FjlYuRCK8LvCPqLh0O4hiduCrS+uvfMDQ?=
 =?us-ascii?Q?5qwGj9zGBDdNGqWcKh762ZzeXU+W1TX6HFSLl0Zrkm09OGoNGUUSlmTohgQB?=
 =?us-ascii?Q?gcspOw39HLIbM+GGZJNN7saPYX0HPe2LiSjNsIQdMAn+U5FyM3Uo1GZvetq4?=
 =?us-ascii?Q?kw69+CUncbQT3pfOnGx9qZ/0FFiC/UzpsFIWRLPcYbYJknKHsirxdLdWi5OM?=
 =?us-ascii?Q?f9Iq924bMrl37T72LmC9WHZYYgD4+JKxk/eKOFb1FM767zdy3xWHYGkhiVq0?=
 =?us-ascii?Q?4T0FzFebIwdqFjlxy+hupYV564WD2EY3q8QaQ6no7MosAAiSEHERxNjHqJ5S?=
 =?us-ascii?Q?FRGqnE+Sg08LC2qQ95px8FATT3bFfHmVKyjI8lLsyusCsLlH/60fEISBO4Dm?=
 =?us-ascii?Q?b7qu0Jho27sSoUrF+z0fj7BQOldWR4dVEkE32TI1GbE7Y+7SDtF1Gll2wsbx?=
 =?us-ascii?Q?C+W4lp9v3kpbazgpkZcXrxknV84UCZDtTk3iagZuKz7du8Hc+O4TtirL02qN?=
 =?us-ascii?Q?aJHU+rH7VK5Th51MMwL5DO5j+DcLTN3hJk90WSxfe3yLxK2/z52AZl0Pckpi?=
 =?us-ascii?Q?iF4rGz/Xm9jKANHd4sYmbDzjpU4/GbEy7ENryC+7+jYrRjCGS0xvkXSvSgYA?=
 =?us-ascii?Q?Tp0unv3Carp5p9w7QqkB9ZHhzmjBxgiHdZ8WcOCnWpwzLAfnHx7TFla5WOGm?=
 =?us-ascii?Q?PLTS5ACQWlMhqyTn0PzFhml2Y5UY6tWBzjmvP0GdcnLq1jY3rzBrzA/LpraX?=
 =?us-ascii?Q?XD+MZ7UBA9zKtZf72UlVHBmPf3Qm3QpkJJ7NUXJe48MfkIK+hAmXkIaQoYT+?=
 =?us-ascii?Q?lWDIg6RakDYP1QbcI5g5NgffVjS5UcuyRc9lkP/Fsva9BmSMBTNuBT56zAAG?=
 =?us-ascii?Q?CGF7vgiL1IVBv3aCR0zCcgKTghZ+VZqUbNENm50HEnY21DHmJV/9KxTpRrp/?=
 =?us-ascii?Q?DA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xmxrRCaWup1236QmQNG7HgpLpaJjHmpH9ul4zvAiT92GM3QePk0qpDikzto5gMHcsQkvq92hcdmbO0IOvJBPskmBBZfpPDpQvWbDMCfqVi7bBdJVpvdGmw7SYyWGq0vHmUtS+XHDhDyyyAlZNma4AQFO+1zbpmdIaZIhwpqh906vus4p3HbIi4vO5u6zDYX5RKrZxmeaqPGFTGZoQk9B4gAewHd1sTq6lI1oz3xqIBJ8vWW61icIRBZ5ofp7kN5WeDWOLPJCp3genrcmWNaVVYXO/Z4rH2P7v0UGLXgVovgb7UTkyj2p0fOgqNcYNLUkl1B1MqL7kYNj1v8RRAojeEKPk576IuLSnIePH6NHAP3GoyObFAp+bUOC1Wa0rBU+qUxaTJeHHzj9fmEBmbZzA6u8KlnS99TAc3t5+oUYpg8UKQKrL+lUEmZGERGvQPmpWMcRKtym97ahiHQJOZIjVOOS2vL3fvPQthJzIFrhZ/b5fAxgr2Ynk/txOxd1ns3rO0sn9jn5EwQv9qXfS724Yu6HLcZhVY3pKz3SycHUMGlVBGij+tgMl/FfN9l5l3zGn88tUeYj/tgDpZoWH4Wlz0cMJzGKlniMnxwZqwlbnf8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5eaab3d1-879a-415d-7b1f-08ddbecfc5be
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 10:02:54.3997
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T5rzcDantNOtXKopLD4P7ZqnVr1tfApMhlYmdwAZf0utQUEakSsZN1E4ZF+WD0U4eSTW3Xn9niBfmI7adFC+DA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4744
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-09_02,2025-07-08_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507090089
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzA5MDA5MCBTYWx0ZWRfX8d3ink5xCfST bPtd20McViQJtvIUo+1oG1E2pUwhEaMk2I2mkBpTRMdJ+2UsWZCV2v4iyGdB1hBlzEnmYQb64y3 M4wQxMxXM2gbI1kPe4qGkAY8sKFZRqROE0op6Q5OkExSMUEHdZCKrizVuFq74DdhWqq+oeBIug3
 V0cgiHlkzz3zypz3wxwLlMvy+XkyvZBtPfyFYkc7ZRSbCTceAuSRB7+cl7FUlJs4UMoOL/0RqEw UzZSxCu4Ds4P+INADYb0Da64dFAT7kX5TZa/r4CCk6HyLDmtPkDo4/7Ph9aeg+J+Jm/SIqM2G4U YqJNqjP3DLrrvNmmT3LUQX0Y7zDo38BYrq5wCxigiv40p9CcMitvQ9S8jIYJjRaCdPxzHWZoWDY
 jNUwIcY0WxuPvEzrPVvHJayx/X41EkCWOYTvJINvruXIpdHewdF9U0c7IC1TP2gMxjctMsXZ
X-Proofpoint-ORIG-GUID: ur-Ns_6SJqKVkaMC7byn7A2Cj7Pesaz5
X-Proofpoint-GUID: ur-Ns_6SJqKVkaMC7byn7A2Cj7Pesaz5
X-Authority-Analysis: v=2.4 cv=UPTdHDfy c=1 sm=1 tr=0 ts=686e3e52 b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=9wh2qRDMZpkBaRsaGB4A:9

Relocate the function max_pow_of_two_factor() to common ilog2.h from the
xfs code, as it will be used elsewhere.

Also simplify the function, as advised by Mikulas Patocka.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 fs/xfs/xfs_mount.c   |  5 -----
 include/linux/log2.h | 14 ++++++++++++++
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 29276fe60df9..6c669ae082d4 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -672,11 +672,6 @@ static inline xfs_extlen_t xfs_calc_atomic_write_max(struct xfs_mount *mp)
 	return rounddown_pow_of_two(XFS_B_TO_FSB(mp, MAX_RW_COUNT));
 }
 
-static inline unsigned int max_pow_of_two_factor(const unsigned int nr)
-{
-	return 1 << (ffs(nr) - 1);
-}
-
 /*
  * If the data device advertises atomic write support, limit the size of data
  * device atomic writes to the greatest power-of-two factor of the AG size so
diff --git a/include/linux/log2.h b/include/linux/log2.h
index 1366cb688a6d..2eac3fc9303d 100644
--- a/include/linux/log2.h
+++ b/include/linux/log2.h
@@ -255,4 +255,18 @@ int __bits_per(unsigned long n)
 	) :					\
 	__bits_per(n)				\
 )
+
+/**
+ * max_pow_of_two_factor - return highest power-of-2 factor
+ * @n: parameter
+ *
+ * find highest power-of-2 which is evenly divisible into n.
+ * 0 is returned for n == 0 or 1.
+ */
+static inline __attribute__((const))
+unsigned int max_pow_of_two_factor(unsigned int n)
+{
+	return n & -n;
+}
+
 #endif /* _LINUX_LOG2_H */
-- 
2.43.5

