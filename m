Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A30361427B
	for <linux-xfs@vger.kernel.org>; Wed,  8 May 2024 06:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715150444; cv=fail; b=nX7BTHIsPw3hj9LI5W3dpfVbgjZspMLZ6hO/heTXf0Knhon9w5Py9ufFakQVFYbiu/oq2UrFEcSoJQzy/v3YIyVDHfQO8rJaRjeiIVC5taHMgi+vhuvEOUUt5OXMMO7xN6qwHiHSM8JJJciIedWbDjEmgldOMeJZAAGh5ZE19Qs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715150444; c=relaxed/simple;
	bh=wEJWDqBF7HyA1iooqOmdp0Rpv+fmr9lws4Aq3vODDTI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Dj2UHskfgM61FPgU+eShwzJ/Tq/CC1ezpmsTy/oH/dXVFvJ9VQBjTOqiv0Xj0AO/TkrpAkHgm2h24ZVTLamhV5EdH9RIA60AKCmmmFdOOQZWrf+x3JQQbWP3Rv3hF3UmlQyKiWLOjtxBjYdDqsNQHhvaFg2/mTLZx/jhJfgKWdM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RGvQEgez; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zMqgdNiY; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RGvQEgez";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zMqgdNiY"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4486ShwZ026054;
	Wed, 8 May 2024 06:40:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=vB9eSdw8GnF6LZbNgDqmYYA1SXA7K7SkbXTkTfVQdMo=;
 b=RGvQEgezj4WKh5w08PYmClO92Zi9TrTIUwOS5Q89i9lPR/+OqDYwclnePSIcSy/pEVYY
 2S/5i7mmub9aMipnmyug5DMh3BM5k+qLoqgIK0jwfepri6GZmne6a0gEO0YX9J5qDVz/
 HQCkCViIU3Jk6qMqRaIsSSLuAsGelB3iDQBEWow0kTuyv/d20+F1JNREHEHkjMc1N8hs
 +YucclGSO4YjRfFz18qLMdsO51kCvOaUwLxuGNReymRj3UyeUsqDXsVuOI6sglkravsQ
 qB4ca4snn6sE18CxKVpV1g6eHUZbriisHhAN7xP7b5Gm6OLHMwIkD/WnnZAbBn4w3eDA 2g== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xysfvgyyr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 08 May 2024 06:40:30 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44841HpD024509;
	Wed, 8 May 2024 06:40:30 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xysfmvfv7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 08 May 2024 06:40:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SC9jv61B8BxbIGJCDWl/WYVle0HTXavtnNElIdU1D06sPg6M5VohtlxL1yx9/ZDyM/ba/Kra0ttWsN6SeTc2kW15NFKLWJEQSRyXxrTx2oXPjDpkcVqlyFstzcYXigny9zo64fw0VgRSKbPzrmozT1ApQO4yeUAPXbmMdPHuqOPVUZXdKW1LHrouMqxAe3yV3bMNeY25zz/puNe0gs0sE7aFkFeS2c26akgB0yFMMXyf56uiuV+45PQIDRvKdkcVqpilpBJwqJHJHDtjf/cV/uHOEExLtF5LskLtJdI6yfs6ktLkway81NmJ4WZAd3UjraJp40CrjXUFgMXqvPuaeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vB9eSdw8GnF6LZbNgDqmYYA1SXA7K7SkbXTkTfVQdMo=;
 b=c5RAvCjMbcTy/dg0a+v+dSBCajocVGz5ykYuX9EhnTFxKHsrNmeYRTBH7TaRGTjzzkWlXp2Urbq4PwSVkoNW5tKnRBoSPrX+9anYXaUun6Hg9JjsRpy72/SaLm2AqbeZA0Z6q5gwvcWqukvoiMsMETnv/YLQ1eUS7T4/G91Dt0YX9QNoquQRT4JDRkzC0cKLgZ8DaVYSjn2o+cjOTRnDlBMXNWvG1FCMteo+lWKnheendVj7+o8IO0Zh3hLwO1ez+ZnY38Ve4qfqbAxvKWoraKcIzr277JQimeoqIuDJIRFhl8zFYM+JwGZnOloZTZgjbpTqSglwhAi5AKEKfi1YiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vB9eSdw8GnF6LZbNgDqmYYA1SXA7K7SkbXTkTfVQdMo=;
 b=zMqgdNiYWMVfCheUCX3GURXFqjRhervZjIweymm78RDNhpJLD/DzySQZSl++nxMVSiTFaqO6F2/llIxZdMEID+Xrfp/5kTLJRIxqneFJUOGz2UJL8A0hLMwDgKduiJvWagL4qwY9SDcwc/C8FCzJTKTdK8vL4eAq+Rp03DylP8w=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by MN2PR10MB4157.namprd10.prod.outlook.com (2603:10b6:208:1dc::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.43; Wed, 8 May
 2024 06:40:28 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.7544.041; Wed, 8 May 2024
 06:40:28 +0000
Message-ID: <c59c5e87-7460-4ac7-8533-87d96d890b1f@oracle.com>
Date: Wed, 8 May 2024 07:40:25 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 1/2] xfs: Fix xfs_flush_unmap_range() range for RT
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: chandan.babu@oracle.com, dchinner@redhat.com, hch@lst.de,
        linux-xfs@vger.kernel.org
References: <20240503140337.3426159-1-john.g.garry@oracle.com>
 <20240503140337.3426159-2-john.g.garry@oracle.com>
 <20240507205822.GR360919@frogsfrogsfrogs>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240507205822.GR360919@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DB8PR06CA0035.eurprd06.prod.outlook.com
 (2603:10a6:10:100::48) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|MN2PR10MB4157:EE_
X-MS-Office365-Filtering-Correlation-Id: 2636211a-a8a3-4681-8fdd-08dc6f29bff6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?RUNUQlFQVFBvRHFaNTBhMmhuY3FueDJ2ZmFMYVlJRldJYWU3YkRmdXkyV2N1?=
 =?utf-8?B?bjIwZFlpSHVsY3RyMWNaT2N5UDE3MGpIalBXM1JkcmVnWkdwUjVHdE41SlZC?=
 =?utf-8?B?NENoT0F4SC9ZT1dBU0dpUU93eDQxbUZpc084alhIRHpEL2I0cDFUWDFCYnJI?=
 =?utf-8?B?SGdMdTEzOG9YVFNwOEpkYllNSVRjOFRBME9DQyt4NkhIM1d6b1J2bFkyVVRG?=
 =?utf-8?B?Y1BBS1M3elk1RWFCMWdvWlVCbFQ0Q0pIeERsOWtDTnNneEE0MGJaeW45S0VQ?=
 =?utf-8?B?YnF0QWV3T2lrTkVqbnFsT1FZZVRwZVpkMWRJSUZZL2hFSVlrdEJYRnlYSmpq?=
 =?utf-8?B?elhTRlRnQlBhcWJ3L1JmWGxGTit3dTVuVHJzV29xMmNJT21UMzNJODNQcW9Y?=
 =?utf-8?B?UExkL1gzRHZKQlRXUHo1VHgxZWhtUjFrUUxlUktXM09kd3QzOEczaHpoL1NK?=
 =?utf-8?B?dnVFVTJrUG0weXg2Z05HUzkzbVZHclNiQnNYN2VsY3NSU1R3NjRwZGNsaFI0?=
 =?utf-8?B?dnZMc2ZwSzYyeEpHNjFEaVdKdW9TUVFtR1huRnV4cEZ5QVJISXdNaUlVOUdX?=
 =?utf-8?B?MkhBSmxzU0RxYkFZRHFGUU1xWXNXaVBvZ2lVVkhTalpmRU1NUFltaVZuTC9L?=
 =?utf-8?B?NXQvdTAxTHV5Mmpqc3ZLdHB1ektGenFXMmlWWDAxejFncitXZFQ0Qi9tR2cy?=
 =?utf-8?B?RjMrMjVwd0o3ZXVRNStsaWdoUTlyMWNBZHRoSStYWTlFSXhoRUJmTDRDaXhl?=
 =?utf-8?B?Z095V083anR5eGF4ams1QXltY2RscUhyMkxiQXZ1azBlSm1NUDBadVowWXgr?=
 =?utf-8?B?RHIxTmtwQTRlNW9QSHFQb3V6RGNyc3AzRnhWQ3UzZ2c4Mkt2a1VsSTdQeFNl?=
 =?utf-8?B?dFgwaktLZXYrMlZiV3NIVzBmMU8zSWJrZHdmSkxCSWk2MUtQZEpwY3B3NnpI?=
 =?utf-8?B?Szl3SFl2OWJFeHVjWXRPT2FqYWY2Q1M3aWdENHBtWnR0RzZDMWIwUE94WWpu?=
 =?utf-8?B?aTVpbDRybmg5eGhHb3RaREo1NXpSYUxLOUJaTHdWVFBIR2tsSENmZkw2VWVH?=
 =?utf-8?B?RWt0L3VoSHhId0x2Y2Z2bHU4eDBDbURRSTl6aThjUEx3NlFkVFNoS1JYak9M?=
 =?utf-8?B?WmtGV09oajZMR2NqY21ocGhTdlBzcFdaMUt3aXlrVE0yMm1lUDZHVEp0aHZX?=
 =?utf-8?B?bmZxZHlmSFFkRFV0SGFPL2t1UnJ3clhKUVc5SExsbGpPOGhwQ0ZVMFNTOEFX?=
 =?utf-8?B?dGg0MDE5OEYrdFkxTDlUUXZCY1o5aGVYOUp0d1l0WnEzSmRQZjZoRlNNcjd1?=
 =?utf-8?B?Sm5XRXArL0FLWUQ1azhCSko4a3RBWXFJMm15N3RmNGRXN2NwWUFuZGRhdlFx?=
 =?utf-8?B?cXp6T3VMR3E0T0JqNUJjM0VkYmd0R1JLVkN2REVlSDEvNlJBSVNoY3hxWTdo?=
 =?utf-8?B?UmZaQ0hmUk1SYkJIZW90Ris0SXA4NlhQR29xaHBsZWJmWlJKODhnQjFNR1gr?=
 =?utf-8?B?TTd3alRDOVd0eDUzR3hyYS9BR3NPdnpDN3BFbVBjKzVwOEwrVmNUM1BjNnpa?=
 =?utf-8?B?QmRYR3phSHg3eHdzSFM0ejNha2lBQWx4aDZ1dWlOTlpzOU00NWVkeks5ejUr?=
 =?utf-8?B?T0lZN3YxSlh0S1RnZFFDQnBrWGF2TGVMdjR4L1orY3g0WVBsYzZKa00wVDZP?=
 =?utf-8?B?NDVxa0R1blVpQ3VydUN4Q2h4SlRyR1ZzZXo1SDZDVXRRTG40MjkzOTN3PT0=?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?Y1IrYzIvNGZQWXVkK2xKMThKYnlZRDlIUXo3citTa0ZWMVdUMzd2UXlBaHdI?=
 =?utf-8?B?U3pxZkxvOHlFU1k5WGMwNDhUZDhUZHE5aU0rdVR3aHJlUnNkKytJenFPODNT?=
 =?utf-8?B?bVZVSHBnRC9Dc0RRSnJneVZ0aGc5NU9TZURjbkRaSjl4UTFleWJvd2plV1ZF?=
 =?utf-8?B?OExsM29YSjZvYWNiUGZmN2tpL2x0clZMdjZXeExaNUhzcVUvSGMrSmxOU3BL?=
 =?utf-8?B?c1ZvRDdMcWZaVFpNbnEwcFRvTzBWRDRIT2NhazV0emV4ckdSbTN1QTh4V1Jn?=
 =?utf-8?B?ZjNDOFh4QStpWWF3TVdjQlErN1pkQTFva0VuUnpJVGF0OUdOcll1K2Jmditi?=
 =?utf-8?B?ZTFhb0ZNb0NiR21Vb0pHb1U5WlZuS281ai9XTmdSaDUzM2ZRd29EZ3Bnc0pi?=
 =?utf-8?B?Sm0rNWtVbXpWcU1aN1JlR21idzd1aVRFbThhYmhwaXBwOUNkSDBMWFpZNGVX?=
 =?utf-8?B?bGhEZ0FpUVV1cjV2M2NneStIMzZNRllVcTk1aEVJaWRjN0xuS1ZwZHZtZ013?=
 =?utf-8?B?VS8zU3cwYkx5ZGNndG15Y0RMVVcwSTJ3M0EvQ1hEcVZ1WEd2OWE4eWw3YmUw?=
 =?utf-8?B?N2g2M2FoUjhTSC9tMzg5VVZuY0J1bG1yOWNYQk4rVXU2NWNzYjltRXYzUGIz?=
 =?utf-8?B?RDIwUGxzaGVuMlZReGxXcURsMEwzZ3BEVkVlNStEc21RV215dE1PY09GSnJh?=
 =?utf-8?B?a1BIZ01LeFlQcGQ5c3FpOERjS0VWRzVxTGpUVkpQRkxGbDd5L1dUdDhmYXZn?=
 =?utf-8?B?SWJrZk1yVXI4cDZrMENRQnMwUzZoamhZVDlVU2NjaVdxSG1TaFlrMEVMWDd5?=
 =?utf-8?B?cU9NL1VTdGxlWkUrTFc4Ukd0OFVXVVQ0Z3RjRzM3TytEN0h0bEF5UWlIY0Zz?=
 =?utf-8?B?UktGQ3krZldjK0Jlci9ya0ptaGhJN3Q4MzV0dEJSb0hDWE90Wmxtcm05UVo4?=
 =?utf-8?B?dVhWdWYycDBmRUlHcE8xWHBVaGVSbjk4bUtKNHQzK2RQd3pPUmp6NGkxbDdu?=
 =?utf-8?B?MzVRWXUrMVprdXduaHZNWlhIVCtMZ2RkTVR5dGdBMVBYZWdZNTJkUWJXZVhB?=
 =?utf-8?B?WVBtSE0wYlQ5bnd4T2hFYU1hRGYwZGpvek12Q2oydVhTNE9Fa3ZSVEU4eHJX?=
 =?utf-8?B?ckVGTW1saFpPOVBKbE9CK1FFQU5UbWdrS1lpTFFyNithYk03bFhpUEswdEs0?=
 =?utf-8?B?a3ZmSWpYaHRwSTI1aVZIYUVCckJpQWprNFZuNzZKN1M0RG9QWkorZjZRN2hP?=
 =?utf-8?B?bERWMk5UQzJLS3lVV2lMMlVLUlpDMERXYlFENnpzN1VVZGxoWXhQdjF5MC9P?=
 =?utf-8?B?Ly9lL0ZpUEE1UEw4N09qRzhpbExVZDdmMDRINEhJVkNsU2ZmQkJweS9xVlNZ?=
 =?utf-8?B?OUsvZHJ2Vkd2SHE4SHpFNjBLa1MwejF3SVg5bnUyZU1TMkhFRzZ3bG1xUmth?=
 =?utf-8?B?K0FJMFdhM3YxWjZ3K2hyaVN0YnRNTVE3Z3BHNVN3MFdsSHViWGppeEVmTStn?=
 =?utf-8?B?SXdqMExXZGZ6UCtNWG1VaHgwSFh6dTRleVA2cTEyaFNjaHYzODNaMzNNWTda?=
 =?utf-8?B?ZmNFWnRpL0dNMFJ0dk1pakZNdEhmWHIvaVhQczBxNUlKWUxseDZETjg4Nklz?=
 =?utf-8?B?SXZ6NWVKajFBMDB6OUY1alZUU3R6WXNDU0h0WVJhNk1TVzdITGgrVVl1Vit6?=
 =?utf-8?B?K1E1VGl3WmxIallCTThOYXk0VUI3cXhERjhNeWlMZW5JVG5PWG82QjJsK1Vp?=
 =?utf-8?B?V2FEVGlhK2t2dmtvWHdJK0FpdVdJQ2gxbnFJb05GTEZ6V0gyUlA2ZGI3Z0V3?=
 =?utf-8?B?RGU2NWlwbUl0aUViVVhzSlc4UEo2ZmQwbmNkcVRYaUJKL0xWK0ZVY0YxblY4?=
 =?utf-8?B?ZlAwVEZHZkszcHRPc0ViRTJuOWxuaEZ6eHhORmhZRUNqWjdoNzlBZDFtbzFC?=
 =?utf-8?B?ZmlESzFmTm9ZRW1JQkU0SnowYUhnaXNCOG8wd1U4MUtTNjBhRHFEQmRkNXpS?=
 =?utf-8?B?OEZQdDZsS08zL1c4LzlPMFk5d253c3lrS2t3Q2hnK1NxTCtpd0ZqK2FjOUx4?=
 =?utf-8?B?WklHSjMrMVhjMmlqUzhUSlB5RTBZeDBrdmtUbmowc2tEc3FHckNXWGllaUE2?=
 =?utf-8?B?MURHa0hMWXhJYk51VVg0aEJvTnRCOG44SDlpVDlDbVNrRW5iWVNhdnZ1dUJn?=
 =?utf-8?B?UVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	j2FJQxf1ZLSxDmHnEAcNdQ7dKW3AIF4ZRXtcb90Z5ApKed4EZhKOuy/AcyS1485BuV8N6vswcyaPKobvF412LthHYNLdPypv2lajwKchCW6VS/fUQnGgTzWTxTfKu2P4gNBoyfsuPi6MNc1SLCG/UbwTYlv8TgsHVRIBCS4V99CPoXVeyIlzSOwt+DByDUP4I9A3WO7EzX2iNUmP27zJzGATJN29gnx2EF29lw9y3Unw+ynFJKzx8a1Wrl2ORESSRhhNMBhuoIxdQSeGD5TZJ2hRFpoJc9CrLnIf4sSvFyxHcoY3Vmo1Z4JhBQlOdSYEbm7xkPspsqfNCFBsao8uD3333khAJpsbesNI5O7cT3npBCPJcPClVAU2gbFRzQ8v5oPJNTAQC6TYh3nGC7bCbPBmr865WE4+Ze9Dbn3ajcEeWrRcP/pU7D07SSj7JqFdZqeEPL56EJroWtbPo1yi0IvECPKIvdk4G3OO4StCt1ucb2H5VE3EsA+B/lrl8kToVfLs8rx8/kOpFeOtl8BBz/cHE/RlhjLm9fX7KRcMiGWoG7/NpTXKa5OQJEakVHJ4t21cUn/tZ9b69N2K+GTKM55+gE7tce7983ZFxiAi/o0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2636211a-a8a3-4681-8fdd-08dc6f29bff6
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2024 06:40:28.6465
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aiD+zxFPNHTqnCuZSg4gXdPrK2JgUmObF33noIZzj07Eoxic+p8LR3nFokvcwEsUlKgmBkSRuELv/QuCZr9RFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4157
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-08_02,2024-05-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405080048
X-Proofpoint-ORIG-GUID: ZwKr_peJLSme4OZsB5tBDzRmhBghbsEU
X-Proofpoint-GUID: ZwKr_peJLSme4OZsB5tBDzRmhBghbsEU

On 07/05/2024 21:58, Darrick J. Wong wrote:
>> -	rounding = max_t(xfs_off_t, mp->m_sb.sb_blocksize, PAGE_SIZE);
>> +	/*
>> +	 * Make sure we extend the flush out to extent alignment
>> +	 * boundaries so any extent range overlapping the start/end
>> +	 * of the modification we are about to do is clean and idle.
>> +	 */
>> +	rounding = max_t(xfs_off_t, xfs_inode_alloc_unitsize(ip), PAGE_SIZE);
>>   	start = round_down(offset, rounding);
> round_down requires the divisor to be a power of two.

well spotted, and so the round_up() call, below, also needs fixing.

> 
> --D
> 
>>   	end = round_up(offset + len, rounding) - 1;

