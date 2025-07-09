Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D2C28851C;
	Wed,  9 Jul 2025 10:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752055405; cv=fail; b=JDcRZJdDvMkFFuJh0GZc4WI6iHtW1h+vhYcw0q7XDP+qWckP8dBeYf3k1IhIkj91aAIAl3e+RB1lXIXU1oqJFrIp2Xj7kfJ65ymfj1jDIZh3+3ByO5OvhswHFV9ItlCYtWTZ7MmDDv39Jww8a1G7uRjLJrSHX+Oo0O+o1miEFj4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752055405; c=relaxed/simple;
	bh=7J/GoWqcB8TqZvIOQE+957r+CgM9SgAtc6HDwHHiiX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ddQlO72UPu3huE4D3YCYyaQHsntzSdqzYD+m0cqhmEUuTII39l43TqywzByKb7sXId+DcZ9Whzd39jB803xk+0gPmb8Dj4nAWouz2spj7/lKZGwIoAPJV9JdkhcHbmOa/Zlw+xu4KYaLWcA2QQkQ9Rup0ECUotUCK+QSxYozse0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=pEx5Jhft; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=AbxRZj75; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pEx5Jhft";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="AbxRZj75"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5699q8dA020819;
	Wed, 9 Jul 2025 10:03:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Wg6Wmg1XTAk+HcRE1yWIyDmWORwOgQZYLZm04nEWdBI=; b=
	pEx5Jhft0qF4q6P6m3RhPEsipLZPbbDz2mFSjU7rjgqF0Kb3lDWz7aP8vVZqlbEI
	qvxn30QbgnNQ4pOa2odg8Il2Alp7pHkKJmRN6C+aZbP8mFsD682zKXoqcWVruLBV
	wU84Z6HqAj6GgckCO2CpTewzLWd0Ee1g8uK026Cn3wz8auRtMNzsQnMHHjHUxPu6
	JB58UyjMrn5c3RLTd9Nvbdr/un6jnhOmLRQFVRDK4Dxi4AKJ8nI+qzEXF+j3HROT
	7O9IapH9iJXrEH89sK8hdYrG09HbFdw0Lptp1p536Ek+JCyiREmQxnz/knnzWCMe
	U+B8tzyCpErfS6S1C/iXww==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47sp5p80mj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Jul 2025 10:03:02 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5698Kjk7023620;
	Wed, 9 Jul 2025 10:03:01 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2071.outbound.protection.outlook.com [40.107.220.71])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ptgb181r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Jul 2025 10:03:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MRrW4zLJx/NbWzII6qvp7IdY/hwt3jtFgChHO3vnvihEmJrITVioxZAPGHfC5oJ9WCYtmXXGQ8lv5asYHJuPq9RuNfZ+g8vmtCY7vWa1IXNDwg6q9KUSvl1LGSHCXWRzhrSnMjf7Vvzfx7YqWeZBv8FCcLJOkcolcj/5C91t4CbdkD3KHA2cZ6+u0OsEWSGXECThR29JOsH4kFIYMvsa7FZXZdxN3VE0+2/8447Wc9QQ1ttks9cpVg1lK+cmgXZPFf9gVUHlVpiBR+hV+O/cXk/sUYx+fa/4+8SELNqjSeh+f+AsvlOIaX9dNpceZvZA2a404eTPvpp5sej/uR+SUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wg6Wmg1XTAk+HcRE1yWIyDmWORwOgQZYLZm04nEWdBI=;
 b=pvBTsZnB8uAmP5OmvBxWTkk4CoAkTBHLhf4xRwncv957VVeY0oluUgIW1ZorbfTpDST34L2YrEoUlZVahu8UWwiTvn5w8sPsq5LtHJC+q2V990o45euCfwuVy0nE3zWE0C9nlFbH+crXBvvVVs0KtoPJ4stX6UKa+1P0TKkdr5i8BiWGMu2BG/C9gpMwksa+DHXAy8Qfj1CmbTUhXDNbsNnWakDMzuXAUYTKJZwLche1m6cxHAp8NZGdtJwc+iR0f8QxQ5kxNOrA44jl+w0uKDb96feAsXtbMbFHeBS3fDMmnZWbQYOqqb5uPANrCOefp/B1aB+6PxEbuC/JxAlOxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wg6Wmg1XTAk+HcRE1yWIyDmWORwOgQZYLZm04nEWdBI=;
 b=AbxRZj75WHHvaS6WtYYkB1LqEPorwPIVV2GlT1IW6B4NXyclTufu2dgBTgpGnqyPQnNW+LwM8LyIQoSLmgW1DHQ+rmBkz8+P0GesiXZ4Dkq9nIMbcrkExd2FrV4izCSPt9ryKoTNiQFCG8Wt8egmq/59CP/LBkaOSAIzb8IxwGQ=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by PH0PR10MB4744.namprd10.prod.outlook.com (2603:10b6:510:3c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.27; Wed, 9 Jul
 2025 10:02:59 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8901.024; Wed, 9 Jul 2025
 10:02:59 +0000
From: John Garry <john.g.garry@oracle.com>
To: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
        yukuai3@huawei.com, hch@lst.de, nilay@linux.ibm.com, axboe@kernel.dk,
        cem@kernel.org
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com,
        akpm@linux-foundation.org, linux-xfs@vger.kernel.org,
        djwong@kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v5 3/6] md/raid0: set chunk_sectors limit
Date: Wed,  9 Jul 2025 10:02:35 +0000
Message-ID: <20250709100238.2295112-4-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250709100238.2295112-1-john.g.garry@oracle.com>
References: <20250709100238.2295112-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR02CA0002.namprd02.prod.outlook.com
 (2603:10b6:510:2d0::11) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|PH0PR10MB4744:EE_
X-MS-Office365-Filtering-Correlation-Id: b3e48775-e895-4cc7-3224-08ddbecfc87d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vcdwKypui/qoOpL3Ra84rX1nsQ4PXbp7YN0K0VuFJB3GGLoIAFaq/p72SBDR?=
 =?us-ascii?Q?NqaXQzSsLQBdlJxO9xOkU7nOCaO1cTfu8NXFHAsE7iW0YzxtZxD9io88h7it?=
 =?us-ascii?Q?8etrxrLYtg6D+y2fwpjb3ISlLCBn1FZkZ64ndGEKm2CTeDSb6rOYEoknmLBO?=
 =?us-ascii?Q?GveXGegTcVSD8rbqu0X57cVGGD3vJ1VgNhm3qjc7I4w+znN6hdVA5a8MhSBY?=
 =?us-ascii?Q?/++DsbWNspXTbGntQuN09ds+spBs12dybZb8bgydaIzY3B8LAS6jCrQqfBQ2?=
 =?us-ascii?Q?87VWesvzOl9HbNDkrjtkcxgFuKfKa36WpEhDLKpoY/7YMsSrtiMBOxepDGJg?=
 =?us-ascii?Q?ggn/hzMyyCTu4p0oY1kuS8FuiIMpJjV9U/ukKqw72NkXlO4yBjQg1iA8zrRU?=
 =?us-ascii?Q?GC9DKvNqOVtF0jgxp6wCF8rmTJChudHz3kt+Mq4KiVaLYKMljI5wbys7cvb+?=
 =?us-ascii?Q?aOuaW4o8HVqKvLg8R/MKaeUvAzQ2TWKilVwRinl2WnuqVhk+n0nggjmkohyM?=
 =?us-ascii?Q?3itxgFbp2V60W/LymADdPJ3pNZKS1B6OaEyrcfo93eNAQjRttHDFfF/l92lD?=
 =?us-ascii?Q?+Pa55LuvBcH66UNF8ZzGZR5aCGHnK7wE+wDrqtKN8oslgS9re92TlPfahiQ3?=
 =?us-ascii?Q?ZVHCrGKk0pGStJKvMde5AGQCcKJxSroQPr9qIUDZASbxqCgrn69IlpwvDaP/?=
 =?us-ascii?Q?irBMZNSJluzMpuK2FEvUN7jXMHQmj0PH8jvL/jubyWOFAyIGOYQAhV/gisfW?=
 =?us-ascii?Q?C6IxEPAFIyUuFTVvKg7eeXD7N9oaHH597oQ0IshGR2sVOxY/n/0e8z9BsZub?=
 =?us-ascii?Q?zA7/6+92WdSnDzC1x7M3ncJ1he8q448KYL47098Ahgnxdn9BSQN19vDgPYxy?=
 =?us-ascii?Q?M1owMuNl0ojjwLzMpi7t1jzyXIbcX/bqfRnMkXQuWC7akICB6JdoVln4HBJ4?=
 =?us-ascii?Q?kPIJ69vq8MsA5GtFZqjSaWDWBKDQCH+k06M0mhLWYXYt60GrAq/LKImcI48U?=
 =?us-ascii?Q?C5RKM9DSr/EUIFp5phF3ZQhxgFC6Ql7Am1X865FvfWkE7EJ/m48f9q1+uKQE?=
 =?us-ascii?Q?dUtSJ1SjZiSz5QzIo6cFsb9X8PWulcP+z9y635xEpVAVlLV0iQZdswZ0XOAw?=
 =?us-ascii?Q?ujTP34HC1Wi1bH0Nfi/sB9WVIZ1Drbia22QLorXP6X/aCmduUkWTvvTs9/TN?=
 =?us-ascii?Q?AeQQt/LNb0+ljPMRD4MS/OWvtjkJl1/RTAl+X6j0M0ZrRh4iV/v3Ioxfkild?=
 =?us-ascii?Q?3gONQB5JZO9tU9clI1KtRaXXCpCMWwG10PEQjpusxbhmHKE9qJdYeF39JrH8?=
 =?us-ascii?Q?9TIc9t3LWXb4g20Lui+xRb1aOT7VTGeZ0UwlyWKWhnqf8lVVm4rCe5cFYIoU?=
 =?us-ascii?Q?3aw2F/JcvV6C6P/0Wo4yJ6uNl8xLBwZHAUFNP3ORS3Ocgh3exNkv75BBp6j7?=
 =?us-ascii?Q?KyB7IIBpzJA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VYX5UydTSvRK3CMPYBHbOKWUQVwVISol5mGV2KuHF89eec7X2CpUWTWDg8D8?=
 =?us-ascii?Q?gcJOXoBXzbARzga67s2SEs8i5sQFQj+DaHip+skKPHO7UfzDunmqDIxSujGa?=
 =?us-ascii?Q?8ZnKGl6yS4i7dyS5VpKJkIA9cz1AUMmZ0SnklzPGICnlCPXmlV1BFeX66MGm?=
 =?us-ascii?Q?3BeZEvwonpJtc9c/HEXI3D4QwYfo1hFonYmL3puQrosJy8TrEfDu6zl4xUrE?=
 =?us-ascii?Q?7uOXwCBBPWgpVznCymqOqfTaJikz6Q0atKp+UWcc48jA4tXriadGeq9kEI5X?=
 =?us-ascii?Q?YB5aRpWvcV7FSq0y4bA8e/i1AveGuLKnb4dvdFBjWfsZSspYb9aaJ9PBeRwq?=
 =?us-ascii?Q?Y2VvpnOfrI3Di6IrWTh9EBv6o1Kf9l0lKA+B+wO43wMWbbJDJ+JLyupGSurD?=
 =?us-ascii?Q?IzuQjHuk9EXKsvY7hKcGDoztq2aDjCTmxuu0n57AYATZhTejqfI0gh0FtNv6?=
 =?us-ascii?Q?RHFbgNdIAiGb1Akno335lzq18s3Mtb1GbJI1LpHs3VAr89niAdNtVPOX4FSf?=
 =?us-ascii?Q?Az0Frz4nnNSYcDsmXR3SueDoFCMGp0WknFMvqwu1Gp0ixm5PGsXIkbVPYu8n?=
 =?us-ascii?Q?8St1PE9XXQmYwMfR9/K5EhRConPYNfzSFEsZiPLlUK+IZzz+z71cA6113EGG?=
 =?us-ascii?Q?fKK0/vJtH3JZCUube4KUhBJboCHWhx9SAGGxVLYfoD95zv2pZasebQVSQZU/?=
 =?us-ascii?Q?JHf3Y9CPwSHbHwxhqd+z+pV/8KLT/zQw2sDHNTLFceFbT+YjBwe7IkfCMjIk?=
 =?us-ascii?Q?L8ttzpV9bzPTN95IChd7hOs31LlTprFC7/IfZhNylL3VvkcAoyD3Bfy6QfrM?=
 =?us-ascii?Q?WswCPH7BRIfDvKpjcQeDNMDd8+ZjMSyFjFlfJdIOoe9ajoDvuyjHsDv8WzOE?=
 =?us-ascii?Q?Xzru6EYkNtr/FoVCP2AXM8Uu+qsbGF6t4ZZf2ss6Q9lwXBU1FqGKSKM4JCru?=
 =?us-ascii?Q?uLfYPItUfPTDRJySJtIwheKuNeIs4ddI7YfVReZgW70UGbs/R6QPaOUsKSC4?=
 =?us-ascii?Q?sgtIfFZaeCAEKg/CpYIcXncoxJbF7d+SICTGnERb4XKls9dR+UmOAZ8ufun4?=
 =?us-ascii?Q?Q2HSHFXqRLDjcCaye9J+isSwks8RfzTMZo1gOe901QymcSbDjpG1jSCEqsmT?=
 =?us-ascii?Q?uHjsNfPQUdCR9vUV1FWuOR46OwHRMvEV1YmVYrA/XleAr07fgl6HNIVHt34+?=
 =?us-ascii?Q?kOS8UYqqaqqYs946iECUnvfFFQf/HrypRE3JF4nymN3tU/LKDVFLrNGaO7KN?=
 =?us-ascii?Q?pJHhZInkqSYWoPySZfgMCYzW12gLwLJzxZy3MgGGFxrzZjrxCi5/HvBnYA3J?=
 =?us-ascii?Q?7i/xOaFrQ+WZrji3C+MLxXUGOS4cNL4AheA9oayVu6YGvrg9/muCIv4kBAD1?=
 =?us-ascii?Q?G3jFQhsUlRV2TnD2NE00BH+pZe2LMlLdObOlZ6jjBpyG4YSPwQqBy6EuP4yS?=
 =?us-ascii?Q?EDMOCcWljLLkLRSURyqmhdGFhifhl/bNSp4+nhsmKasMJPZdPRYSvhs1dc4Y?=
 =?us-ascii?Q?laIjm3etTRaH2C4UL0fUtnkz2wipnpDmwv4sPYlOsRv1hHk9H48sX4yZq9Ap?=
 =?us-ascii?Q?9UwcN0s0V/U6WmlpuHZx42ifejre1ACCRAeSZnUJZ+wQt9zkO4f2GDOiZI7r?=
 =?us-ascii?Q?QQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Qm+9wywI5cMshFYU7tJQ7Iy1EYywaqwx2pZ8fPpFLK5vFhinuTWVfvirsCzZTWmir5m6IGNyqpMfLlkXcz5ujAqT6NIfXCu8/PQFcj/HntDrHdKw3VQyR0MhJ1CIM+9lMJn3aVxm81vkzVMYvDtxKgDyrYt8Xl9Wefg1Q857dpDwLJ7LiDuEgpRnQkuUHXxhZLhGSp+Z5elBF6DXIL/8o1VcleaIM4nDR7vUd0sAjH+5gfGudOAYpd3zuC2MOIaFCiOlYLY74kBgInoaa7hxU/oWbN0pNVEyTy+WmycOBc4ryOQRAEqa5LEcXwY8271PPBBUBzKjM/dWXB60ZBrRG5Ncah1YgNk1ZhGJaJ7pqvaNNxdkvS1Jkma4/6C4yP3ut0ejeWzbhn88iFFTZzrIWEiq8gJaQw3WPI8fmt6NzpIzBhWAvY74Yi2QduS1KRjzXpbQGtjxJqVbCmeOe0jew7CtkMj56sTIjL8PljVJOvWysbmmw5Wh5xVbBBqOCB45023at9YeFJN0uriPfayMKPaJR1wJNFywRZfCjnNT/O/AndXfT+YR/IOHPS1IRdBOaBCwZB7M4e+Dv5ouuhYVFjpXSiDvWS/+AjHf0ZFcGT4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3e48775-e895-4cc7-3224-08ddbecfc87d
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 10:02:59.2001
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4SeE0QWBjO7X7fz4baNgBY7W+akvrB5aDFAbyC6DdvhIqP+2qrp6U3kKUyTQiZ0PpQ1M423PYPy7DFtX1zBtDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4744
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-09_02,2025-07-08_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507090089
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzA5MDA5MCBTYWx0ZWRfX21SlSJXbs6Ru Os/8u8TZeHCdNmjH7ZkL9kFlaFN8X8svYYMICEFuRD2ZNf6rr7f+sTZ7jgsdUoU4swAOBUN8O9a K75RDWpcnPloiGGrku4oq9DbCq//p/FGeOu0Ylj6wqq2fFg+H0rNMKrWDeyBqbUt0Bjj8DBG1sf
 KbPNSEP3kNusvThloVgA6MF+xdz3ozhXpZyQX2hooLAxkPdjwbhK0D9nVdk3QzxHqcR1jgZdaoA nuWN+Zm7P4Dil1vyS0l0KR7pLYBYcQkBlytpZDy8yBUop/hnOlYwfH2ZeAR4dLGw15mjMGq+0UV 4p1XoUWBs/M+51feRKVkGougd4Ru/a+XfI9pYfuAKUM3C5FXuMiEGMF1AQ5PGWwi9ZZpxpxcoqK
 oXDroCsWlcwc27zrGWlPoM1nS5qUq/raK13gP/jlztPmdfIq9fVmztC1F/4t2V2b/uYB82S1
X-Authority-Analysis: v=2.4 cv=PIsP+eqC c=1 sm=1 tr=0 ts=686e3e56 b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=VnNF1IyMAAAA:8 a=i0EeH86SAAAA:8 a=yPCof4ZbAAAA:8 a=oeePQw0IGsqOEWDZT9MA:9
X-Proofpoint-ORIG-GUID: s-jMiAkjBMTxka_raelCPI6sjsUNY54c
X-Proofpoint-GUID: s-jMiAkjBMTxka_raelCPI6sjsUNY54c

Currently we use min io size as the chunk size when deciding on the
atomic write size limits - see blk_stack_atomic_writes_head().

The limit min_io size is not a reliable value to store the chunk size, as
this may be mutated by the block stacking code. Such an example would be
for the min io size less than the physical block size, and the min io size
is raised to the physical block size - see blk_stack_limits().

The block stacking limits will rely on chunk_sectors in future,
so set this value (to the chunk size).

Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/md/raid0.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index d8f639f4ae12..cbe2a9054cb9 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -384,6 +384,7 @@ static int raid0_set_limits(struct mddev *mddev)
 	lim.max_write_zeroes_sectors = mddev->chunk_sectors;
 	lim.io_min = mddev->chunk_sectors << 9;
 	lim.io_opt = lim.io_min * mddev->raid_disks;
+	lim.chunk_sectors = mddev->chunk_sectors;
 	lim.features |= BLK_FEAT_ATOMIC_WRITES;
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
 	if (err)
-- 
2.43.5

