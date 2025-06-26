Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AABA833EA;
	Thu, 26 Jun 2025 00:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750897680; cv=fail; b=ADeTCD8O8ig+9yiUt2VxqhoC0Q9zLk6LV68hmLhQUijvYpOWtlEwlliV/KOzXVn/w3nWbwIEo+FZvV9hQqOT2NuoDYEnFTIpPkipqbK6enAYKE8+S1rdg+ML4Y+PY2Cs4rjaZLHKzMl9b61sy8FLRi7n1skznL4qP3CgJryDaQI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750897680; c=relaxed/simple;
	bh=5N7D7VndrRUKz/1CcfcuTBh10FjArpIXj/jQ3WICZtU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rvJbjh8Oab20QkAINUxDV8NrZbKBiBelDyMXv++btO9ruR3SUaeZUAl0CASke5LBi4QkDqAEFJCZ23ICsJcPkP0J0whaYD/bA1JYyFmp6pzfGzta8L5mlF35I8p7upwnOvhd7EJMaBMvUmB9puhSmCHms2L3Q40f1zkXW6FUb0E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cEV22sXE; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bSsp6jMP; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cEV22sXE";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bSsp6jMP"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55PLBbJu022859;
	Thu, 26 Jun 2025 00:27:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=LLiqNxvx34ud0FxHVGixSR7/lHdXirlGZzX2zkcAlTQ=; b=
	cEV22sXEreoHcKjo2O0UiJgYKWWNYXdWvlFmlGYR7GBJHp3CZyEz6CnDQX+YbjW/
	znN36BbP/3m/OhB02CWw5vyw+x3VWOnVT+D8KaTLd4NdEUuwKmrtf56xDPn/nhs/
	FD8uq1ZQyq72QhDV0mfL4lt/+gOCxw74eTOkz2eXI41tkCGi6FubR+zrSy79ufjY
	X/1WjhMdL3Y4OD6VlkZ8692dPEIHl5tY6KIfxQpexC3qENlPSptAway47oGXiYiN
	LrniwBuuEUgjIU17hMbVEytQuixoQh5sfkcic/aj9NtBtavnGJjAc5/K55GJLPJm
	zrDnCYr1n11S4li8QPXVkw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47egt5qnkd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Jun 2025 00:27:52 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55PNt1sL034423;
	Thu, 26 Jun 2025 00:27:51 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02on2042.outbound.protection.outlook.com [40.107.212.42])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ehps9xjy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Jun 2025 00:27:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k0D/YZHEkdPB1VMi5hfwgXNgxzu0PxuT73PIUFS2pLeWzMpZ+chLhxRcu0bYg6wG2pNU6Be6FbMUnurC0zjJilShZrX8fP+yLMvKpZmfZPvvmSy4yE9cArU1wCe0kSJ/fAjB7JxmNt6EV0CBPetdEm8TufxlmitaVxwt3eqOYVl08VZsnmClpbUpyuWDjF4XDdE/KQinOUxrGIJ3/NOcXpqah2SesShbJXAcKUx/SDjG/cXBcZOiQ33xHnBkxU0rWeoEa7doxHfizRwATAcLkpNAAq+PRiwhWeuJw0yH0mBUnRh4vPAyzxXv/8qWeldxvHCiATfyZ2thx+8UoP6R0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LLiqNxvx34ud0FxHVGixSR7/lHdXirlGZzX2zkcAlTQ=;
 b=odyXD3bSC3FJjwTN1V1pKldUlSrS0Wt0OvDWCxyIdk1FbdKvbFer6Phrk3OTiCY0CKjlIVrlfwi1WICJZP7jnMqojYIBFFeTiMd1Wk2xoEKHDtjm9IL3sFdm3XZHo7sXNOgFZInnR05WX1wFvTKYW+TybbkAH5x5Mm5p4osU1Is/ggojTqmajtb4KigAnFRKr+JkDa06KtQJytFeMBL9ZfrAoxDEoxyvtiljMdvvfPtq3auURpOVQj7gTTM/+1METr/gvVeP3q+M5i5PDs/jiMYxE06NxwCE9WxLYvKycgesxANNFZG/jgQV4TMReM3aS6R4QhDEXasclEwlOjBhTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LLiqNxvx34ud0FxHVGixSR7/lHdXirlGZzX2zkcAlTQ=;
 b=bSsp6jMPxlJwK/IXwc8Fg1WaeYO4qKTlAz7b4kM5Gu0FHGTKPITeupT4qcK8B0jBisxIo6agNDwl33/CYHdNSq7MkvfA10MnPkmbh/jgBKhaXLxS0tu4767rkvc3aQT1F3zB7tse7QvmRU0bbG+ZzbH+JjXi0dxWF0hCxeYRIVA=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH0PR10MB7098.namprd10.prod.outlook.com (2603:10b6:510:26e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.16; Thu, 26 Jun
 2025 00:27:43 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%7]) with mapi id 15.20.8857.026; Thu, 26 Jun 2025
 00:27:43 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc: djwong@kernel.org, john.g.garry@oracle.com, ritesh.list@gmail.com,
        ojaswin@linux.ibm.com, zlang@redhat.com
Subject: [PATCH v6 3/3] xfs: more multi-block atomic writes tests
Date: Wed, 25 Jun 2025 17:27:35 -0700
Message-Id: <20250626002735.22827-4-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250626002735.22827-1-catherine.hoang@oracle.com>
References: <20250626002735.22827-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0087.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::28) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|PH0PR10MB7098:EE_
X-MS-Office365-Filtering-Correlation-Id: 57e9414d-5dae-455f-4a90-08ddb448447c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|10070799003|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4H5iTaOjSpj/zRbXHchGABybHyDozRXgL80b0Gn2OKIQlhynlQOUEBjwXOjG?=
 =?us-ascii?Q?UuRNDeXj/xxs9D5Esodk6jKMxPIujisCS6sZ75Vo3weUC253/8edot+TJC3j?=
 =?us-ascii?Q?XUeuMH5oyOqhGcCYuoCy/tpzZHzfbmKGrTaX9X7RrrnktYJtTdpIUllEHZXq?=
 =?us-ascii?Q?H6/Iw6pxnhwgWR4RWW8CsENQ3I1RuOVloIUjwo58kmUSv9VJ/zalt2KM0ahe?=
 =?us-ascii?Q?2ONgnpbvLOlRG3FxVrHiJJuBC3mKsOkHrIBAlscN2AZyZklYZmFNNU2mGXWl?=
 =?us-ascii?Q?J5PT1HAJaDwYK4c+S0N89GfOLM7/EaSo05iSh//oG4Y8urlYd4plylspzxtW?=
 =?us-ascii?Q?1pMYqhP12PC/Eh78gDPcIxNDb6qqjiNaXeAh/H+nvDlAvjFUu+lsAQrCzFbI?=
 =?us-ascii?Q?p+AmFDdU5go1u2cjjfEYqoQlt3Pvd7DCc9rBlv8PhCJAqmTpbyBhfDpuTAda?=
 =?us-ascii?Q?BjIyi5QgAdi0yceDpjQbzZRRTh+jm4S1DHAUXvwnPEW8WX93ak/q2pUBHCtr?=
 =?us-ascii?Q?CVfPn80dqG472/xr4r/gAPGge9F4sf1tg/3zdTSibUip0fKmYFmN80MHOy5z?=
 =?us-ascii?Q?G2qTlx8R+uEJG/DX6I+OgcvX89cGOFaco890m99cWlkSwtd12anrJgHNaGNE?=
 =?us-ascii?Q?pLMf3LS5dIunFzNrFZKGo7qS7OmvW3SNdtQV8w1Sajc2JlpNf7EOlfx9FZ/A?=
 =?us-ascii?Q?n6X8bobbifdnONIg3hJufG0b4NzIGo3GfkXMvZD3Xj0WPK1Ds8CapMog9vjA?=
 =?us-ascii?Q?O/1vkaiTsSuWtBBgybDmjjFU1sHtgMBhVxJsmwcSPALliFr9kqvA/Gy1wnJN?=
 =?us-ascii?Q?v1YbudDQ8Uxcqk4f03fw/iEQ7sjqFVU066Nig7g/0crskz99L4BnxDyfIYPx?=
 =?us-ascii?Q?6tJrRA6CQ8hsZpA/EkxYn5ENr+ExZUJ547FdenLub0XaZwXgC24w2l5ekb8K?=
 =?us-ascii?Q?d8jiu/XyJxXLgG2xN7Y0RzovE3zIsW16tRCaPeBwhl1WALs5T4h281kpJST/?=
 =?us-ascii?Q?hicMsG0SQyN3Vr5psyoPJ/uW7pqcVAlZ+reqEHXeb5dSZEtRB8Q6AUlP+ST4?=
 =?us-ascii?Q?uQNORM7Rumrr23CqD9hUd4S0BB+833yY3cPlpvjsX9FZ5HOMPdJ/khqWh0Bs?=
 =?us-ascii?Q?09u3uFOpafAX2eRWvIJYNgaB+cPSa+aqg4G83CvwkyrjD9x0+KN7qILKDDe4?=
 =?us-ascii?Q?Wnbc7lItlp2emgswmpXVCT4EkOGT2BqT6Txfhd3MTrO8V/75gfi5ibjiqd9E?=
 =?us-ascii?Q?/W7uCwB9yY1UU9zrTfdhRSzQ2cTlo1rfszmPEpvKzKt/tyI9ieq/wboTCYEX?=
 =?us-ascii?Q?5fS/1IH1p0/IDiP8cX7i6tHHBNJnsOeK2MP5l+5F98HkDzZJRn9e7j+5pJhP?=
 =?us-ascii?Q?lxJ9dBdZvvg1cnnTqmi7kmnQ5Nkyon58iibNvHD5yStTYAbOOtFCh2/odMAy?=
 =?us-ascii?Q?dkIdFbfQ08M=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(10070799003)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OHoTQqYPbEMDZJWKedIvTMewxEkG4aXnj2WkksLonG6Y88d1akDlBoKKdsA3?=
 =?us-ascii?Q?2YUKj4drwI1ED3ZkpAJ3mQpFPcARq9yypFrcREbPqWcHm7tOmLUVBjSA5gQi?=
 =?us-ascii?Q?8J35t9tKmBzj8vt+n5oGkbkW2RlGMzgNMpQjrIi7m2JdnQCv4MErAgl4cjC/?=
 =?us-ascii?Q?LNpd4IL+PNhV4O/hTtkYOw2nM8sfEq/uwA58qn63qF6ZiJLedqof+WFiB+ur?=
 =?us-ascii?Q?4GEnLieA5wf2LbD/YSLb3aGNrixubarsbEHXddsfoEMHvvmQb/1DPOwbl0qd?=
 =?us-ascii?Q?0KiMkb8fqPsFxPRbkhe3Aw9VcVJ2eSUok4Rrhqhr9u4utB2XUCpvOXnSgXki?=
 =?us-ascii?Q?mR6Y4RwHVW3g5UkaFHQ2W32HfiQ5t6C+W4OBt06BMKd09HW7dwBEnJXpISwU?=
 =?us-ascii?Q?+aDrB7mHcsTuHq/gagGhXnStl/YbyR61KRgjRAU7znFLpPmMfmJvRibdw4c6?=
 =?us-ascii?Q?CuCe2oR9D+WqmlGph5c29LrSggj/iewp7nD7UF+6xtVCkDIPKPa/7NbHoXWB?=
 =?us-ascii?Q?3jlnDpN6JzTBRxp3I08Q7+0y8JZdCIOGdrfBebLgdJNoarmGNyjJflyrvarR?=
 =?us-ascii?Q?alqZYto4ykhLPiXHguNiPANNaAqWuxuYlVgy69ums1Diecm15sladnGH79jR?=
 =?us-ascii?Q?vGrRX3p1yt37ePHcbJ1m8NtjxS9IRHd+3HdAT9DfLqEuPSZnSdUAlwrNBOLN?=
 =?us-ascii?Q?N4RlKYYhnuJZ1MSa9454sP8p/Bol0HlDhkf9di4gq5/e3R+fuDMhta1E0V0x?=
 =?us-ascii?Q?uBtofQGDyDGuwIjKS6lABvx/UJ1L39lsTC4TmpF+SGdTm6fNyLYP2xQg9ese?=
 =?us-ascii?Q?90myEQ9PzY/5gI4yM/KVSU8ICgHms89t5o9t4VejWwpiMJbtqgwUZ6BBgMWb?=
 =?us-ascii?Q?uN9elqqNH2XvoZ9Jzn5VDtDkrWOWCQCMZC6aj3rE1Ffb1oNRpqRdT9UHsr1E?=
 =?us-ascii?Q?0VuXlf63ChwX9JynYPgenNKmygGZwZR3yGm3JSyJhLmcZfhr8yzIXtypjUc7?=
 =?us-ascii?Q?6X6BupEGoaWDLs/1n6w+EVMcJWpfmAhpWWwkDWi2Jl2KX+BcjRnHKESVAmhm?=
 =?us-ascii?Q?MvwVur7pOsr29ZgKoJJ6yHOe23ENyjXriUAKSPzoe08JQtnqtOp6wCu5lBK9?=
 =?us-ascii?Q?RFgRIdWi5Vyi/8I9wGMmjN9Gknmdp7TIEeHPxx+/WxDwydDpY/KvMEQNE7QU?=
 =?us-ascii?Q?xjFpxaZTC64tTryVUcsmm+CPVVBOEifuAOxapLMaaa+ekrME5PnyLX8tmabW?=
 =?us-ascii?Q?C/y9ONruPbsnOQlK73jBtRVzN14umMAXJmj7dZW/KrUfxMdHsDlAE/m6s/jS?=
 =?us-ascii?Q?UJWnPyLE5C+KgKbWA5zT6bovuoQAvqMjJl0cadek1KqvePI4GDL25akaF7R+?=
 =?us-ascii?Q?OqHXM/BjlXedi8Hrh9QVxM41B1eBYCJyLC/hbI8V2P4HvSJrTcSBvRZ8rH4W?=
 =?us-ascii?Q?E1RrRPUh9x8J3aEY7Ngk2hNciwJDxyMaS94PWglrJU6D1ozjM6KnVI8fJ6Vd?=
 =?us-ascii?Q?rklu5OETI9bk/8kDUp/D5DNQGr/hJYc6TWNSLfVowQFunxpGFrt9JkYyolh7?=
 =?us-ascii?Q?GgPlp/gmsm79YR/l13UPLl0Idhmlrsd83tRXoA+hQxko6GYfR62afT5IL0S1?=
 =?us-ascii?Q?cwtOlqHjolhYXQmljcZqvTrroay8NaV816FnCa4BfB1Gm7AWhvSm1z6XkzKP?=
 =?us-ascii?Q?oe9LJA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qhs0nt+nIYNKH5Ifeh603nmferZVOBLHm4FSUcAvghWiJGJYeRTc4tzd/kZw+ce8erl530sLy98j9ULunSHBpQVaEYM3k/PFxKpMPxsakJS+76Ve1CztzCDJ9VxmaoS+oGFMwlvK1LohNXMjRIhivUOy/ARLV3+LlPV61ardB2BE4aVMYKZTVkidyTx+Q2nyhMZ89ftzhIqeSnBSrrTCdH0oUBwE4GRxmp/4lE6GbAUqVtwrcxe9AJzJlh6yTFtW/KGr8Q8EIvoGLgKwDTYxREog0VtQrgyfHypdMxzfGySH3Nf9Oi/gfo7NP+rsbq3/yn0swj9gXXt8NJd8MyzPuyzHwTKJ36J+uWMdCluYOIJ7UgU1zpvYTaYJHkeFksQc4rXAMAbUtxge2MxLUuqhzn+lgt5tpy6sevqS12WYTk9o2b1y9THZLXCndMG+hCd8gaxNpFBs6lgMpiDEmSgKEM3twdixdgIRD3MEDIBqxqryjpiaRk/Y6j7ue/u9p8VbAh9EtMQWxF+t1Rqn+s93xKRwHGFJDfnw33nUC+gTtCApAnS9ZNTLyZAR8PKmxUQmHcfuP/qpSH6W5zjluv2APN6KzZW3KcYdRO8rRVdoSag=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57e9414d-5dae-455f-4a90-08ddb448447c
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2025 00:27:43.8298
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0kARehHilsD8NT6O0ZdlrjHdfBCVEGsLcSqkYnnjqStVZWGXieMwRsO1sRV1kUdPAKx3k74qjLDNC6HCXF4sCOnRQNiMURmq/cV4vGHCoY0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB7098
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-25_08,2025-06-25_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 bulkscore=0
 malwarescore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506260001
X-Proofpoint-GUID: KQitgavex2F21B_SQtbAd-SeG6vgPrD9
X-Authority-Analysis: v=2.4 cv=PMYP+eqC c=1 sm=1 tr=0 ts=685c9408 cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=FPzu-_wniR3LNvefyx4A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjI2MDAwMSBTYWx0ZWRfXzOhUSC9j8tR2 vvJ/shLjXJX2x7gYBPCCrb9dhNztOpDLly5xyoyENwMipqi1Q4qBUL1At36Z+TP0mNzRjpJntUk CNBabecMZ/WaBMGYLloHVhgcrPrgWFw66sA+L+cID58V8wsfw0rrrUctI58pX8lWPSV+X9hikto
 koftOUGAW3tKsIc2XVZcD6zAtVd19Hd6TpuHc+Cd5vemTNXbZXOgaYqhRwm9gduZPjIdRlUMzl0 RpQBbcXVpm5IMRMxhLdf8MEW8UjUoWuB+1V9znl+PbgxFwca2eteJ7QWZCNyaBQe97eVtBouMEi OIocl0sZzZehAxXPY7F8FSeRNPfVEvmoNz60ffhZs/EOz6n5Norcp/pyC0xyvZpEgr6IHxaYmLK
 nvoUQx5zv5MRudguJ1/RMPgSf1wpXjlXtwb+/6ra1sb1MXtLfwqlXGx3D7sv76W7hMZkOjNq
X-Proofpoint-ORIG-GUID: KQitgavex2F21B_SQtbAd-SeG6vgPrD9

From: "Darrick J. Wong" <djwong@kernel.org>

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
 tests/xfs/1216     | 69 ++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1216.out |  9 ++++++
 tests/xfs/1217     | 72 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1217.out |  3 ++
 tests/xfs/1218     | 64 +++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1218.out | 15 ++++++++++
 6 files changed, 232 insertions(+)
 create mode 100755 tests/xfs/1216
 create mode 100644 tests/xfs/1216.out
 create mode 100755 tests/xfs/1217
 create mode 100644 tests/xfs/1217.out
 create mode 100755 tests/xfs/1218
 create mode 100644 tests/xfs/1218.out

diff --git a/tests/xfs/1216 b/tests/xfs/1216
new file mode 100755
index 00000000..3db99b24
--- /dev/null
+++ b/tests/xfs/1216
@@ -0,0 +1,69 @@
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
+_require_xfs_io_command "statx" "-r"
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
index 00000000..38360564
--- /dev/null
+++ b/tests/xfs/1217
@@ -0,0 +1,72 @@
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
+_require_xfs_io_command "statx" "-r"
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
index 00000000..57a24ade
--- /dev/null
+++ b/tests/xfs/1218
@@ -0,0 +1,64 @@
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
+. ./common/reflink
+
+_require_scratch_write_atomic
+_require_scratch_write_atomic_multi_fsblock
+_require_xfs_io_command "statx" "-r"
+_require_xfs_io_command pwrite -A
+_require_xfs_io_error_injection "bmap_finish_one"
+_require_cp_reflink
+_require_scratch_reflink
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

