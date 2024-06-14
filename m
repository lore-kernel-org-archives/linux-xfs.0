Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02295183071
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 01:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718329801; cv=fail; b=UfOVjfamPZNjajhlzCDLKspdf1ZBtohHyBX/bQHB49IzxkOfNaO1kGiAUGd/O/my5IJGRl1H+b/VCBfsie6053X+QIy1RUK/nZz9Tr0x9/LU2BZfJaBcEn6niOaHHNIsPZNDdtHw7cxNaixsjEMTYXSqMUlePOH8/AGlmdxZWPk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718329801; c=relaxed/simple;
	bh=Vi6URTW+xE45X/TiFWIKAg34Bs197fIgD4ZXSbDmew8=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rMWarCatSjAwmCxCFJ7jSTrgvV50eatFd22zSP7Wedg+88+daJcM9loJ5ZBTI1BFSCgPdINaotediEu6mK83me19X9TiFIavd0AbGOiyaEmKQ+A/JVKFrPwQ9g+GBwVlivRX5oT3ckWfyiNGzNDLgwixLY+7ALA8izsYH09cxNE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=K3cuY/4/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=q5Kqc3wB; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="K3cuY/4/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="q5Kqc3wB"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45E1fVXU029842
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 01:49:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=6tI/eWEHU5k27jVKl4QE80YPRsxgzIgyX0BXs1AXpGA=; b=
	K3cuY/4/y0ryRCL7gxQEUD6SgIySl771JJ/YIUJ5uqkV2ps+WMPH9+VbNd02cnfg
	9hMY1zHTdxAcOi7QCOFSUQ7E680nudgmkn9g5t194WrFP0HW3TSP2vymoYyGB7fI
	smwUqGELXaOMaihXhIox3KLbJix2OIgJo53EiXniqcU4kV3++d5r1/ZRKB8Uz+3y
	pYQZXxDCtCnWNjmQt+wD6Ij8Y0W97txfqAq6ETv53WOINET+v4IQMv7JrcM0g/YJ
	+LIP6ELuoldA4KRZjDy33a1RvFh3DS6lN3SpQliw2oWDubuPwd7lo4sv4Z26WYuS
	vq7uzOztjLgPQ8gKSzyM5Q==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ymh3pangf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 01:49:58 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45DNkGX5013327
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 01:49:57 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ynca1uvu2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 01:49:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LkT1Jkycl5/xNHofCifkKU/GakzpiMlCDJIUuR08viAUk4qkj1nb0zTY/50zccPAGjDrDn83qL5X1ExLxepdKz+1zHktWIFDY2shTVzXWDGU4mEwb2GRD3D4DhASA5JxgcQ8LDW34awCX4tajB8h//gjGoUNd7UKzns6LRcpEB7OEBgdUuuWS3wL7h/Rq4O/TNG4THw/i7sLRUxO1VfXqQZXbcNs74ExCEsNeHJEc8upbekIipEh6MVuUGsZZrcpcIOcsI/nOrSNYq11riBr1rpIMqpPTiNjQSccOLXdQjG8MAQgqlJJm3cKNAhHkrP/CrnsrG9gX6qD4EtE3sRIrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6tI/eWEHU5k27jVKl4QE80YPRsxgzIgyX0BXs1AXpGA=;
 b=b6ZB/qEhAGSuzRNd8ox14vWuDAjSX+RHGYrYNdg1EF0UrArGZ/Vj76r3rnWKU/+tNIfcAJcKco8tG6oKbFXo1pYcc1kpCNvCDfzIgo4MmwZN8WAwsNs1HtmKju8pRcdyu9m5yg9CnfgqNMU8spIkRjE7KLHGgdHb9wzHEGuIdCdx7aCXlBjmTv95iD9o/e4Uj+3q2an5XmxE2G6vz7I+cjSHYpY3bSa8rxjo1ISTllds35Ssle2Kbd7I3BAZZB7Oh4nJP3MgsNbJ5SmlRV6W0CH80mRY2gt5A51EUxeHtMA0rKD5SXszaeMOBRUtjfEWiLFpXkuV3Jji7PRKBECqhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6tI/eWEHU5k27jVKl4QE80YPRsxgzIgyX0BXs1AXpGA=;
 b=q5Kqc3wBRrELsbFNm2bR5YsAgs7eISfipr4zyUI1j6AcDdhZwur8paIls4je4OIGropkGyoJdqWtaedJE7ROiJm4s+/oqXFBMjFK/3mN2dj4m/DnzkoUY5eAw5E0nW/rNiFOmBiBTV5+veueuzimoGuaB09OAHw7jI/SDcKDWm4=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DM4PR10MB7475.namprd10.prod.outlook.com (2603:10b6:8:187::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.20; Fri, 14 Jun
 2024 01:49:55 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%5]) with mapi id 15.20.7677.024; Fri, 14 Jun 2024
 01:49:55 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 2/8] xfs: fix scrub stats file permissions
Date: Thu, 13 Jun 2024 18:49:40 -0700
Message-Id: <20240614014946.43237-3-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20240614014946.43237-1-catherine.hoang@oracle.com>
References: <20240614014946.43237-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0020.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::25) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|DM4PR10MB7475:EE_
X-MS-Office365-Filtering-Correlation-Id: 9716f524-6ad3-431b-aebe-08dc8c144a60
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230035|1800799019|366011|376009;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?ZpLpk9+Z39dySoA6Wnewo/b/q976ZyVAGRcSDJSMBxg7ve5ChxgE2jfX2Y4G?=
 =?us-ascii?Q?I2gNnFA8Y/A+vsCpK6l3gq3J0ca/vUUbgwrpB0c0m0qGngFt8VOlZ7zwK6lr?=
 =?us-ascii?Q?UCg+q6bU5gfumjfp1YGc1t41rTwFrYdyefd8eqle0ani5TumWbznYEncov70?=
 =?us-ascii?Q?Y8PfeBbgpde34Kyh35Fg9qXVauplWVxoW9ON36ezHuhAqX1bu+a5oS8LDJNU?=
 =?us-ascii?Q?TfRtNx8w+4FGwmfu8l62ou5wEaU/V8Xun82iXpWqllNZw7eaXPTSZrt8oHOg?=
 =?us-ascii?Q?6wGB8J2FOpVqdcJL9KGNBYIAluNSHZw7Bvhn9Oaivw/AahXwetnz/sb1pGkB?=
 =?us-ascii?Q?uBGHm7W+62BHUnUJ7R5CzTT7lY/UIvmGWns4AQlpNOp3ep53UShVPOzBA3Aq?=
 =?us-ascii?Q?cN65zzLRvvDnUa8/gIG/r7hKdpfdzd+24BX2TwW6QfcDLSmFM3OO4U7osNEI?=
 =?us-ascii?Q?o+CaR6w4oouqjsSPK0TbIH7ZPlH70UkoUlbBKjksb8Alx6d5kae0p66o51ji?=
 =?us-ascii?Q?T/tgMrXlXBgqU/cRuNJZamu4HrZmmRR7eGSrlRXlQ3rkwxAqs2cHaK5X89CL?=
 =?us-ascii?Q?oT1uWWkQYd3FhuJAR+L7bNSNR7w06fHIQllZA0y7c3wjkONMlMJnBgL3RHfe?=
 =?us-ascii?Q?EUDPF51T+U7G0WRy1Y5LuGTWimAiagvXN8H4gD3IV7bdVtS8XaonDU4f0/75?=
 =?us-ascii?Q?ZmlDPIQrRHx/Z/Bl34Mq1QAHQ22qZWvhNlTUdc2csr3vlNwnCd0Qrr39+JNc?=
 =?us-ascii?Q?PsJTmGmAJqNToNjEZyDiYQLT29zg7w9LVDqddR+IzgBuqHcj4NtrLmthssLW?=
 =?us-ascii?Q?7t4HzX8Lhg6owPuXj6kExYTcMWa8jrpbpif6NZaAevcs/NsaGnxCdfKDx0zT?=
 =?us-ascii?Q?86qjvXqdFtFTpIBY4wppWvpaBNJa0+dRKjUdiWoOUWE/g2blAVqJhcUt6XcY?=
 =?us-ascii?Q?JIJ48xHKzbz5ktYtAOOaG4xRHhuA+R8v4eZJdbwYO40MLjhELRSrh7qJPq1T?=
 =?us-ascii?Q?vBkU3fzS3HjcWLKsmQk47y5jJKjPRqrgjoY5k//OmIE5b8j+VnHS97qjKVJs?=
 =?us-ascii?Q?TzVUN6bgsBH7rpN+qb3MGytKSarZ17ago3ALqczhaJNRqP05KrvHkAdRXx8B?=
 =?us-ascii?Q?jVtu+GBJhe686G+g8eOTpoeANhb+zCQEvd2Z5xr2sNfDoia79Z+z856YqUkV?=
 =?us-ascii?Q?kji/KaydYF/G6HrHfOzXWTPxbT7+JLWSGTTr+njWK5Gl/m7upYABO55k4DSS?=
 =?us-ascii?Q?QgyHiUSMtNuN1QBN3RdXcHJDQb7SNs2et0M1jpSY27r4w+AwR6L5dUIO8qkN?=
 =?us-ascii?Q?jfSZMwUz0vsetpvlqPZQ5L9V?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230035)(1800799019)(366011)(376009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?DtElAl93NeefnX9uzihy+JYzK5CH4D2FFJE481+ffilUI0CPcfXun3My9usd?=
 =?us-ascii?Q?IjB4y0foL0ZrciD2fICkbs0efg9vQDp6BocCrjwutYIOz6qOFpqu+V3xtocF?=
 =?us-ascii?Q?yKQBJb2QCaYFanhAEhxAnCvSBZ++SWFgLoGcjAKQi7CCgGQOYW9Eix9sfHqo?=
 =?us-ascii?Q?jt7Rro7/GR9Nw/tmF/Mg4HhUSsu5GOc7hb4orHsYynunu1LkBZ6D0Aryorkz?=
 =?us-ascii?Q?wDtPrlcr2RXcKirYE1rAlEv9AQUokbUDhYqmSOfrZS88K6nEfZ+uwRjG+pHa?=
 =?us-ascii?Q?3TTzaXGMX2gHIcml6uC/qn7ayLIAZgFNqyFrvNdjhotbT56AtPVBpqaGusQA?=
 =?us-ascii?Q?piPuoY81PEstzzZZzBQ5QoVDvWhS0r+U72SORMREOu8/X6aXTG0/X5cb/aAl?=
 =?us-ascii?Q?f3V5lttD7ekyL25N+BSmwGcBgQaVK7UKlh1imDtLK+qQx8NwvoVPrr3axMZK?=
 =?us-ascii?Q?kG+VrEaIQYPuAavdC2lVRX2QaX1JTZoffznzYqzRlgvoSKoR1lX/pqFT+TjQ?=
 =?us-ascii?Q?OWeLIRRr9SbLudbaLAY36Coe75L7YizJclJBXUNN2dtY+DvwB3poZJTKQ5Up?=
 =?us-ascii?Q?wkpD8uxuH0zZ28FgzPYmI2AXqQy6kH5nUiWUa+9UygVcqMfHtdpH60Dw9wtp?=
 =?us-ascii?Q?+egi7pQnCkXN1eaWUFanyqkelKd24tVFYje/eQuSc1xvi/w/SuIcmCmiJkjq?=
 =?us-ascii?Q?XMe4j690LaHwjKxnmKVUz1J3TrObc7JV+izKLcjMGmXToFUl40EhRWV1zAcx?=
 =?us-ascii?Q?Ng+WLg+6AsHaNjpUIPlShiEK7cAFoaTHEA+H1l3SfllbZgVfziWhV4w7weDh?=
 =?us-ascii?Q?2dBZyrAYAd1TdKvvL03W6XJO/NmWDWiO+tfApXBGHBVT+MtoQAtHUIMTUpcu?=
 =?us-ascii?Q?05RFwktPY9Ppr3APH8vz9swAHzKeObzMoAntU3jNHuj1RVZbH8sRuFH2q6yE?=
 =?us-ascii?Q?95VfL8aiH8ddYPQPIMWbvnNSkoN0dGUr0/evSfMxm9ZX7fkZqGWjtT3j9+pL?=
 =?us-ascii?Q?kat/juAgl9aD3xRv59UuehTwsDPmeBFPuWUqiqO+6I2x1NW33lPJNkX05R82?=
 =?us-ascii?Q?M0lWgL9jeCLKP1REeNPNxMoZuub+Hk6W45hwPgVjS0mqTcD+G/czvHxhnY1+?=
 =?us-ascii?Q?54GN5y+cYc0QB/zQOMArNXW5OYEQ4bQmLF4QLlv5Iz9FTJ0dwRady6IUdSjD?=
 =?us-ascii?Q?FDktfHr/6r02XV8FC8sxLH/6l9cJazgu783+hRDYtgniSVaq4cEkj+M1kU7q?=
 =?us-ascii?Q?gdzSWooYtxE35WFnUxnkZIqK+pBH/X60PnRoQXJ2Ya0eCzM/VS373SydTiOq?=
 =?us-ascii?Q?hmF+v/D6DeS1XV7SiLFBYOQeXM68YVvZ31LN6+44LDFBlLoGxRW13PSUV8wN?=
 =?us-ascii?Q?AYBltEZ6caZHH8aMMk4cVGLAHJJdoHbnq6K0T9YTW722JMk81cTFZVJjNhcf?=
 =?us-ascii?Q?SDUcBij7U6C2vXA6h+fsp+FaCDZD1QNcnt/XIg8bsEp6eWd2cSTGwZ6wghqb?=
 =?us-ascii?Q?SqFhVecwUrwjW05HckdxMiB/4DdbtJvb8MQUo0VhI/1RbIWWCwgYk4w1tPxy?=
 =?us-ascii?Q?WAhu0lmxv+mjijTtx0z+oPLIC00W1zyJ6Enxa4iPmWjjE6bYfPbeg75A391m?=
 =?us-ascii?Q?IDOHQlGtSXPcSrLrG1mdLImPfUnFuwBDGNuouOu6jgjjIOypvTVm35IX50ze?=
 =?us-ascii?Q?dRVrsw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	LELnkHVrZ79Gzf/4Y8MtHGBNIO/JtXgU4WB+PJzq0/KUDgF6lDzktxFkuImPXRYbxmnrIzBlFFPO7veR2W0h9kQTYXGOsVPU9I+4+dEzy1jmmi8GSwaYYuy+NRxrP0yHHHYiiQhR3Mc1Kiw5PD4ZwfFShm/C+/CcL51QsEE6Cb0EgKaZCMUNwERBToZI86tazBKK/diO6tj6ZuJ69Ab4S3Djtr+kjs3nJq3Iuez9Fh3nGJLjMwBxRQyjlRRiU4aUgWdMVPE7v8MYTHzZUO6++qcgfO8pjw6lovNY5BRrD4RxArmbo0nXwVYxclaFzcvdFF0ayNq91uerqzV5GB/Rb73PWeXSqnj4ckdL3CINn4iPpsx8Fs4fhYUCRkvR+2sDpp168vN4YPcytU9uAQ7N7HJc2NZjoyTTkPpMjOITHhIRKjvjLfAVm788j658R1HaoS7LaTQ5RZoledZpc8GwaOvZ9AJIPmYPlh6yEwVDScHkWSalldAFfEZEUWDh/wkFz8pSQSZdghDT0UqM/v+P1LnC00yFQr2IxfDS5d283IoT1xWx/8Agm15alET9zQMd3sDddQ1cz5Y/q90mSsov8cR6+2J8vloxnMlOJMa1LDM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9716f524-6ad3-431b-aebe-08dc8c144a60
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2024 01:49:55.6330
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9s3VwHXYk7CAHPQ50l6gndYGaro3V0QCXcjtqYLvocrkjQKaW01x3G/AGp08fYZkpZZlOO+f+/dhRXD3oUFyq8v6kiU7YsdlKmyfOxOV53c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7475
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-13_15,2024-06-13_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406140009
X-Proofpoint-GUID: 7pgZQDOhkFAsawlO452G7aVWHz3_mIBL
X-Proofpoint-ORIG-GUID: 7pgZQDOhkFAsawlO452G7aVWHz3_mIBL

From: "Darrick J. Wong" <djwong@kernel.org>

commit e610e856b938a1fc86e7ee83ad2f39716082bca7 upstream.

When the kernel is in lockdown mode, debugfs will only show files that
are world-readable and cannot be written, mmaped, or used with ioctl.
That more or less describes the scrub stats file, except that the
permissions are wrong -- they should be 0444, not 0644.  You can't write
the stats file, so the 0200 makes no sense.

Meanwhile, the clear_stats file is only writable, but it got mode 0400
instead of 0200, which would make more sense.

Fix both files so that they make sense.

Fixes: d7a74cad8f451 ("xfs: track usage statistics of online fsck")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/scrub/stats.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/scrub/stats.c b/fs/xfs/scrub/stats.c
index cd91db4a5548..82499270e20b 100644
--- a/fs/xfs/scrub/stats.c
+++ b/fs/xfs/scrub/stats.c
@@ -329,9 +329,9 @@ xchk_stats_register(
 	if (!cs->cs_debugfs)
 		return;
 
-	debugfs_create_file("stats", 0644, cs->cs_debugfs, cs,
+	debugfs_create_file("stats", 0444, cs->cs_debugfs, cs,
 			&scrub_stats_fops);
-	debugfs_create_file("clear_stats", 0400, cs->cs_debugfs, cs,
+	debugfs_create_file("clear_stats", 0200, cs->cs_debugfs, cs,
 			&clear_scrub_stats_fops);
 }
 
-- 
2.39.3

