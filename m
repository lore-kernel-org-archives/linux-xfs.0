Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1A3B433BB
	for <linux-xfs@vger.kernel.org>; Thu, 18 Jul 2024 18:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721327388; cv=fail; b=O8qqVF3kScTPOL5nqBw1UNqvo4Px4+RoI7pAKJ3TGipik2Z+rld9OsQgrARN+pySHbnRwijPImDRlhZs5PkMravzCamO7VlfEc0ILTZ/Baa38rvnWsllxPCoE9rt6OLiBUNCrtKdZK+3dJA+yzkhik2MQpeuuWH0b7FcGZKS+vg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721327388; c=relaxed/simple;
	bh=iJcLLiTY6rOkHG6McKGrbwmxiWHpVoGmAop/Vntg6tU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=q8GDql61L6D5nkjMlIzv2k5hugnIfOrmsHLmiQbFyztzCctGHaOciMD5MYfJRYbuu6L32Qp6AmeEtU3/eWv4xuRvm1qRcw1DMl0m8Ec9Z/9JH9KiKaTUHr416O7YIFr263TlfOubt5nGAPY51fW9ntjY6clc/MGadc8rS4T5/x0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=iFlVLLpV; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=C348MugB; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iFlVLLpV";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="C348MugB"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46IIFwfV004367;
	Thu, 18 Jul 2024 18:29:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=corp-2023-11-20; bh=iJcLLiTY6rOkHG6McKGrbwmxiWHpVoGmAop/Vntg6
	tU=; b=iFlVLLpV/SSNnBxQGk2IIO9TvTiBOUqVPSs9J/PthDbOmKIwjEGYYTOdu
	uL+uU+U7dP7mx1G9S2Kl97s3d4jEqRO2Zv2Ab8gANPPNeKkW4C0v7v9AkXZzsUZx
	JztlNJa2Y6eMcxfVn/jaQqfE6RDiZ8tgDtsGlj9xfPDJc+9sf418CkYfvIBCNVeQ
	7+nzJoXlfcUmtIbL33whITdy0YUFdoSiiT0+R8yDe/d/CpQRwPLSQQp6aCQp58Mb
	OBh7jVbE5KkN9W7148r8cNLeWBoidNZY0HwI8vQ8K2ZZNjEzb2sCDdriDKwTe+4k
	D6z9ZVK/nMhAJqNuxApv6g3BNSm1Q==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40f85u816e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Jul 2024 18:29:45 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46IHdNNs006706;
	Thu, 18 Jul 2024 18:24:43 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40dwf09e68-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Jul 2024 18:24:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QmgqnCHpi8LK8Ko1xaz05S3r+brdGHuc3+oXpLK3Anc0N+w+k0yLRvn0yi4zSOFe7jCzjP6ZQGWGEwOi6THia1eDVXM7jogmXEikhOLExlNzS9Dga8VMDhI/NwRS4Y2g9SFIhECaqqVcniyYlJwHWl9p2g4HrqdjNlVvuasMfFMs/JGQBHpsENMUXj/YKQ0YlYDtpr9C9c4GmOBh7hSzwAGjf1LMUoXt7akcpOOzILf0MG2LaO9HyIQKo63OJdggUf7Yj7v8B1dei5G2tvkUZ5OHNo0QvwKZ2dL7o8O/7WdcIqMjjieyvTOT5ycTeD4nTwxASJOO+lbWY9+kQw670g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iJcLLiTY6rOkHG6McKGrbwmxiWHpVoGmAop/Vntg6tU=;
 b=wCuxSveO1iifUkwyCpeZuBEtllykoBCwZ5S4bJI1PycyuXKPZ++d8NA/jSy/a/XiApLZdh9QSn4LmpGd4aj2aU5CHAMYiZi26Hf5SEYyg0IMIujlUgSPjfDxde2h3lSKpIv71bLXrmgVqNG8DEBWrUAj3rKMSgp/yq6SOTPJtn7dn5FSKM+7ZrurJrsgU9+jkoBP+PEOtN+GOywQqavk0g+C5hl4w2H3L16sHTvaKw0ts/AXmOBcQbcE1TMufOZttSOmk/xCEZHvTT2hxdSGvKpQ8TFg96TAz1+ooU45+E2d24Yn3F6p7DG65PTm8B/hXudXBWUkcIzQzy1kZbMEiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iJcLLiTY6rOkHG6McKGrbwmxiWHpVoGmAop/Vntg6tU=;
 b=C348MugBAhTcfqnOTYmzW+/Q5ajsWk7u4W1/C4vFPgrWt2ZwBHMOslC+HTqpZX/BmXAWxEvlr7eeQzOo/3id7TIbAL+tRFt1Fj7ucJ/yCqXcaXIJzAHWC4+jHJ0NLJjmeahgHcnZrokA0i3TcNHKdmDOLV6HTLBPnBjbqd207TM=
Received: from PH0PR10MB5795.namprd10.prod.outlook.com (2603:10b6:510:ff::15)
 by IA1PR10MB7116.namprd10.prod.outlook.com (2603:10b6:208:3f1::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.16; Thu, 18 Jul
 2024 18:24:40 +0000
Received: from PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27]) by PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27%4]) with mapi id 15.20.7784.017; Thu, 18 Jul 2024
 18:24:40 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: Dave Chinner <david@fromorbit.com>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 6/9] spaceman/defrag: workaround kernel
 xfs_reflink_try_clear_inode_flag()
Thread-Topic: [PATCH 6/9] spaceman/defrag: workaround kernel
 xfs_reflink_try_clear_inode_flag()
Thread-Index: AQHa0jOvpBMHbEeYYUi6eQA2kII/eLH4iOkAgARSI4A=
Date: Thu, 18 Jul 2024 18:24:39 +0000
Message-ID: <737923F0-EB6B-4495-BF14-D6017309F705@oracle.com>
References: <20240709191028.2329-1-wen.gang.wang@oracle.com>
 <20240709191028.2329-7-wen.gang.wang@oracle.com>
 <ZpW9+PsbhhoXYeyC@dread.disaster.area>
In-Reply-To: <ZpW9+PsbhhoXYeyC@dread.disaster.area>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5795:EE_|IA1PR10MB7116:EE_
x-ms-office365-filtering-correlation-id: 78ced247-5f64-45ef-b0c8-08dca756e331
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: 
 =?utf-8?B?bkxYTmJtUHBjN2JkODM2L3hKeEdnc3kvRC9jdDBiM05YbFJ1NG9sTTBpc2FE?=
 =?utf-8?B?bmRMOUk5dmZDY0cybWpjU1RnR2ZacnBiVUFWNmRwR2NHd0k0c2s2Um0xN1Jp?=
 =?utf-8?B?TUhMdTRiY2NtSHJlY040L3EvREpnWUFtVHl4MDEzSUN5dXZBNjQwYUJ2YWNX?=
 =?utf-8?B?eGFBZTNqcmFBYjBkOGdMcDFWK0tlY2plaENvOHdGdlViTHF2MWRBczRkSE1I?=
 =?utf-8?B?Z3FWT242YSt4VXVLZTBCR2oyTU9ZcHk2a21YMXdFSUxPcVYwVk5taExCaWhS?=
 =?utf-8?B?RjhRdHVmMGYvSjRhZW95Q0dUWnE2akg1NUpTQTlBbUFqNXA4WS90NHVTank4?=
 =?utf-8?B?N21hZWV4d3cvTks4bUhUWW1kTTg1cG5SNXMreVdDY1UzR25xOFN5VFcxa2lH?=
 =?utf-8?B?TUxsVE1DMyszTk41SStlUVRDQjR3Z0hIMDIwNWtmVTFPT1RnSEJ5M3NySUNu?=
 =?utf-8?B?R09EdndjMGR5TzF1QkFGSS9pTXU3SHdlNGJ3MDNNR1B5WExQY2VMRzBLOERn?=
 =?utf-8?B?Wk92bHFFWU40RG5WZGdoUGY1RkdaUUU4VWJFUHlNV2NzbWR2dmRQT1RpcDVY?=
 =?utf-8?B?emNrczh4VWZpdHI1RGpucExQRDBKSVYrcGZYeGNNU3BtbnZKT3M5WGh5VSt3?=
 =?utf-8?B?UFI1c0NZK2FlUGh1SnNWN04zd3Rjai9YOUpyZnZiM3E1RlppMkhzRHMyZmVV?=
 =?utf-8?B?anFYZDdOWDRUdllYaGRLYmtnS3lnWDA2eElYaHArd3NxTldtZGNUSVhqaUJJ?=
 =?utf-8?B?ZmI3WWZJa3NkRllFYzdqa2FYT21ZM29iVjVaaU1ueGlwSWN0RUtxTzA5eHhh?=
 =?utf-8?B?Z1ZMdnlHOWlzT0ttWkFHNHNvVEQxU1YycjFCSDFsc0JmRExwckk3ZTdUNEF4?=
 =?utf-8?B?dXZ5aTFIc2hGS0dNeHIzTW5ERDlhcUM1eXhwS21CdFJoWnJTOEJKNFVGem0x?=
 =?utf-8?B?S0hBOW52cUt3bGxvRU0wa29uYytiSmJFNDQvZ1hTSHFrWHd5R0ZFdDJjSHQ5?=
 =?utf-8?B?TXI2cjBjWmorM3BsSXdxQnUyY21VcWFhb0pCL2xWVWRyd3ZUdzVsMGhmTml6?=
 =?utf-8?B?YmNib3lxc0tCbC9pQ2c5QkgvNERCUTFiRmRHNHM0Rk9qaXFBQ3hGZ0tQeDU4?=
 =?utf-8?B?NUFaU2hzUElnekIvdFhkdkVFNndDN0tJYlRNZ0c0VWFuWnVKMjZTTXowdXFR?=
 =?utf-8?B?SlVlZFlEU3Nac2FyRkROTzMweTk2dXRYK1NaT3NwOUd3QnhDeXpxTThVbUNp?=
 =?utf-8?B?YWVPK3YvRTF1MytUWERKcXN2b2JHaVRiaU8wL3JzT29yQnlOaDJTZ3JDS29s?=
 =?utf-8?B?YVpaS081MTVHV0h3UWlGSncxYWdkZFBrN3FmSmNSeFpTQTZlMkl2cXk3Y1NW?=
 =?utf-8?B?WWFML2ZIUWNvaXJUSXRVbndIN0RYYnBmS2orenQ0VEorZWtLeWRQNVJhUTZ0?=
 =?utf-8?B?OG5ZK0duTVNIRk13YVM4TFkxdUoyQ0tKeVBPYVMzVWlLM3pFd1VtUjFyNjNl?=
 =?utf-8?B?cjltczloN3gzdGFOclVvTUREZ01zYkpJNzFyeUFxZ29ZMnRPTW9CTFVrYVFU?=
 =?utf-8?B?REtZeGVFWVJsV0FGVEZ5ejNmWWdXbUJDdVVvSXA3V3ZNZTZ2VUduNUNhUXlK?=
 =?utf-8?B?Y0x6QTFiSmpnREo3d1RTNUcyRy9PVVlVK2VxWmF2b0lBbW5LdnBKTUdSR1Aw?=
 =?utf-8?B?Y3VzZnVoQWRnNDZ0ZitrQXVNSFVvd2RNME9FaDFra1dnUVFYbmNVR3BMZW1R?=
 =?utf-8?B?QnVVOUVzaEZqVTk1ejRUQVpVZ2NWcXlMSEt4ZTB0OEdSZVhYY2wyZE9hVS9r?=
 =?utf-8?B?ZHR0WWVGRWNTRC8yUEw0YVR3NUU5SFZjTFZrZzM3Q3JUUlR4OFkzLzRlTmtL?=
 =?utf-8?B?bTBnZ1o1MjcrTEpDckhkeDE3SjBWRlVheXU2elhRVlJydmc9PQ==?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?ZlZuR1lvSkJDSDhqT3Zzb2k1eFVOcE1oM1k5TVV2NFRpVHA3Vm4vUVNVNEtP?=
 =?utf-8?B?WVVhaU5GaTJZVklKVnN2TlNmZ0FmclloaHY0Q1lEYyszak8zU0xvaGE5VWJz?=
 =?utf-8?B?eHQzQjVocWFJdWJUMVVUTWpKQThhNG11UlY4aTZlc3JRUmJkbEdkZkkySHZh?=
 =?utf-8?B?K3NiTFJ6UTlMTlM0ZnllVTN0QlljbEd0czV0RnRHd3dXVzNnTjZvL2VNNzVm?=
 =?utf-8?B?SnhOTndmOXJ5dG1SMkpSUkczTlpTNlNKQWVteE5VN1crNHV6UmlGV3ZyOXlP?=
 =?utf-8?B?RVh3S0k3VFF4cmFUeVJDeGdPYjFKUllSOFBaYWdNZzVzYmozTXFoR2dwVWxH?=
 =?utf-8?B?TGc4a21aQk11M1FGMFJ2bm9yZDhuY2tOWnFtbjRoNm0zRW1QMWxkVFZsVWdq?=
 =?utf-8?B?SU5vVjBLU09yalZzNklzY1FhUGw4TGdUc25qNXIrOUZVRTYrdG1FdEZnZ29q?=
 =?utf-8?B?SW1WbXUxZmMxdisyUzdRMUpoMlFHUEFaTVd0R3RuakpzbjUvZVQ1M1Rma2ZQ?=
 =?utf-8?B?S2hoNTV5d1hlTFR5MkM5czlJLytuZURVSlBWZlU5Mk1WTk5PREVRY1JyZ3Z3?=
 =?utf-8?B?VWtKZlM5UHNYd3Z1bW9ZKzlYd3o4YW9sWGE1d0FGL3FaWVlTSTJIT2NwaGg0?=
 =?utf-8?B?Zlo0ZHR1L1JzUWJvZ2JjZVdjNWdmeVl0aEYydUNSWHpzS1Q1QTZWWVBBREMv?=
 =?utf-8?B?OHpLcVdpNEpPRFJ3Z01BQWRCR1Y0a1hmU2N2WUFLdGM2d0p2eVJHM1Q1NnJZ?=
 =?utf-8?B?WkE3WU1BY3dlUWQ0b1BBUG91c0NacG1RZmVvdGhrU1k1UWYydkU4TGhRNGJh?=
 =?utf-8?B?YmFuRmJlZFZLc05TbHZ1TkZ0L2lGbkd0eVdBN0VqOUVtb0FFSFVXRlpRRGxI?=
 =?utf-8?B?Zll1cTRwYUlWeFJheDhYZGcxa0ZRV0w1dGpQNmdubFpqS2gyTzF4VlVaNjRv?=
 =?utf-8?B?SUZucllsK0J5ZWgrUmlPR1VYNHlXZythcTU1L2FMWWZ6aGU3MXJmc3dqMHQv?=
 =?utf-8?B?UUxNajk3Tk5OV01nVmVjT0pMSmNmSUt4N1ZMaEo2MzJZYmJxRXRPVUx2ZlRC?=
 =?utf-8?B?WUduSlFzZW8vd3pPTTUrZUxva1dqRnRUV2pnNnlJZUtVT29rZlFQWmFhVmtT?=
 =?utf-8?B?aDN4SEZVanVoUno5VVRyTXgrTU5vb1ZMTXVITXB2eG9nSit5d21admJTTE5i?=
 =?utf-8?B?WENReVA0RE50NGI3d1hncmFPQXZVYUdwT0R0ZnRzSjh2RkZRQllqanlvNjdE?=
 =?utf-8?B?VUpzZnFKQnlsOXltL3EzaE45UEx1UytSVkdtQmZSRjJHc1FCdzE1ejlzZ3VP?=
 =?utf-8?B?S2FwcTBjdDVIY1M5UjlOL0ltYk1ubm5vRHVQbHZwOEFJSkRMc0xzZTVFQ0Zs?=
 =?utf-8?B?WFFtc09IV29IWk9ZYTY5d1N4Ly8rMWNiMElJcHVJNnZqQlBDbHV5cGdCSGVx?=
 =?utf-8?B?WG9kMU9JREtvRkZaQVE0VU9oem5QMzhZNHh5K2ZTWWVpc2IxUkVPR1JPQmxz?=
 =?utf-8?B?SXlxVWVGOFgrUGJJMTJyOTdock1GY0tldVltVXh3aGpsWXB1NUl3MUhxTUJL?=
 =?utf-8?B?SjJzRit6djhrNDZOU21hckdHVGlqdmVseGF6eGhzaXNodWxqZHd1cE9UQ012?=
 =?utf-8?B?ZURWVW1PeUlrMXg5UlNPTHRpL083dkZqVnYvOGxxcFl2UEV6azcxWWc0eEJ1?=
 =?utf-8?B?NlJDY0JwMFNxbHptZ1d1U3RnUS9nbjUzZHBXcm5RKy81a0dDRmVFZElvUFdL?=
 =?utf-8?B?RGs2OURodWZJd1V6THM1UXM0c0k0bHRBNVh3QlVJV2VLSktzZnM0WElIUVFG?=
 =?utf-8?B?cERoZHpTYTVlNnJNYUcvZ3piZGFhY1Y2MHNiTlRaZ0lKcTRRY1ZseGtUd0ZC?=
 =?utf-8?B?QUpkTG5HTFN5SlJIaGU3MzRRNVorSXBxMGl2LzBMMTJWa045M1Jlcnhla2Jr?=
 =?utf-8?B?bEFPbXl4dFA5RHNXRXI4WmhYVVpldWs1RGZ0Ni9rUXVJZ1QrOUFoeHhxUENm?=
 =?utf-8?B?alFaZ3pXUEFXdGY0TnJLMC9BU1UySmJtNy9PcnpRY2RYTEZYRGxKY1RsVU5m?=
 =?utf-8?B?N1Bla3JqM1pHRWx6Z2ZCNzI4d0VlMHk0Mi9NT2JjcjFjaG5CMEY1TDJiUXR2?=
 =?utf-8?B?S3pkNU9XTHRKSDhVRnNUZ2Z3dDRjcVpLL1NMUitvNmVveEJzK1QrS0tsbTlE?=
 =?utf-8?B?SmV0cC9EWlFHQ1JvOVlUdEMrQ3d5MWFsbmxZcmRtUG1KbmlzVjhyellOQzZU?=
 =?utf-8?B?U21ra2NxWDZPREVqZFcwdXdXYXBnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AACB30FBD266FA419F5440A7E275B04B@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	Hs4tSrZWYW73PcCZJlWYdWlk25pU8dGlpEHpuKpmC6avWdRf1gTZBir+U776E254NzbV0XP3x07tk0W6Hv0/2qtY/pZVRZP/R69/NBDAnAz/9LBbXA/ZlAq68EmNRgr9eKdpCW+8n3VVrIFrCidHsQoBfI83eXSDxLw7V9xRrZTTmXUDLmix5SaucXVMYX+1Njstg3PVEyZOK3BuZLFgFpmc4ONvFkvg5vsmrqFHhS8FjaY+BXbpDOdxO2BCpvveqNZu7f8cZ2t64ghswzJu5j3sB8WfnmiCedmDv1yOIcZtuO2hS3CmhENpdRW2jpNjVelzWoxxev5yDaAfOV5UPF2jJFnqdJes7IcTaJp03xfaILTv25qzsAKII/diU/DRz/Lax9FqyQJPvgrIwqnwA2HWLKyFAxQ2SgFOKwXwz1AFDY3m5MSKeGGGuzsgSUzOCqOIjuobx3hJtL8F30u/xcwFdoPuz67LK6ELaOjyTPvR7OsaULPnIzvB56E0hrEGx4QUyWF7ClaJ0XE0yYIMX0zHckTeDUv4/VFn3CKaMNvlvdllnU4k0lzrqaFOAh3aVK2JmGGStRy3Ad/jxHVKvktfxa4VHwbXaMxaKUD7P6Q=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78ced247-5f64-45ef-b0c8-08dca756e331
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jul 2024 18:24:39.9871
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0Yus8ST8Zmbhmt/z3CMc+X3QGs0Yb7hODGAggn4n0HbaHZJskutZVyXYH4V4c1vBVT8snOtATg79bEUvr8entG+XBwpybL+eVuzZST+Pets=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7116
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-18_12,2024-07-18_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 mlxscore=0
 malwarescore=0 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2407180121
X-Proofpoint-GUID: 6MBdLZBAhbV8UqhVuwjqJE5N6xJws2sP
X-Proofpoint-ORIG-GUID: 6MBdLZBAhbV8UqhVuwjqJE5N6xJws2sP

DQoNCj4gT24gSnVsIDE1LCAyMDI0LCBhdCA1OjI14oCvUE0sIERhdmUgQ2hpbm5lciA8ZGF2aWRA
ZnJvbW9yYml0LmNvbT4gd3JvdGU6DQo+IA0KPiBPbiBUdWUsIEp1bCAwOSwgMjAyNCBhdCAxMjox
MDoyNVBNIC0wNzAwLCBXZW5nYW5nIFdhbmcgd3JvdGU6DQo+PiB4ZnNfcmVmbGlua190cnlfY2xl
YXJfaW5vZGVfZmxhZygpIHRha2VzIHZlcnkgbG9uZyBpbiBjYXNlIGZpbGUgaGFzIGh1Z2UgbnVt
YmVyDQo+PiBvZiBleHRlbnRzIGFuZCBub25lIG9mIHRoZSBleHRlbnRzIGFyZSBzaGFyZWQuDQo+
IA0KPiBHb3QgYSBrZXJuZWwgcHJvZmlsZSBzaG93aW5nIGhvdyBiYWQgaXQgaXM/DQoNCkl0IHdh
cyBtb3JlIHRoYW4gMS41IHNlY29uZHMgKGJhc2luZyBvbiA2LjQgbWlsbGlvbnMgb2YgZXh0ZW50
cykgd2hlbiBJIGFkZCBkZWJ1ZyBjb2RlIHRvIG1lYXN1cmUgaXQuDQoNCj4gDQo+PiANCj4+IHdv
cmthcm91bmQ6DQo+PiBzaGFyZSB0aGUgZmlyc3QgcmVhbCBleHRlbnQgc28gdGhhdCB4ZnNfcmVm
bGlua190cnlfY2xlYXJfaW5vZGVfZmxhZygpIHJldHVybnMNCj4+IHF1aWNrbHkgdG8gc2F2ZSBj
cHUgdGltZXMgYW5kIHNwZWVkIHVwIGRlZnJhZyBzaWduaWZpY2FudGx5Lg0KPiANCj4gVGhhdCdz
IG5hc3R5Lg0KPiANCj4gTGV0J3MgZml4IHRoZSBrZXJuZWwgY29kZSwgbm90IHdvcmsgYXJvdW5k
IGl0IGluIHVzZXJzcGFjZS4NCj4gDQo+IEkgbWVhbiwgaXQgd291bGQgYmUgcmVhbGx5IGVhc3kg
dG8gc3RvcmUgaWYgYW4gZXh0ZW50IGlzIHNoYXJlZCBpbg0KPiB0aGUgaWV4dCBidHJlZSByZWNv
cmQgZm9yIHRoZSBleHRlbnQuIElmIHdlIGRvIGFuIHVuc2hhcmUgb3BlcmF0aW9uLA0KPiBqdXN0
IGRvIGEgc2luZ2xlICJmaW5kIHNoYXJlZCBleHRlbnRzIiBwYXNzIG9uIHRoZSBleHRlbnQgdHJl
ZSBhbmQNCj4gbWFyayBhbGwgdGhlIGV4dGVudHMgdGhhdCBhcmUgc2hhcmVkIGFzIHNoYXJlZC4g
IFRoZW4gc2V0IGEgZmxhZyBvbg0KPiB0aGUgZGF0YSBmb3JrIHNheWluZyBpdCBpcyB0cmFja2lu
ZyBzaGFyZWQgZXh0ZW50cywgYW5kIHNvIHdoZW4gd2UNCj4gc2hhcmUvdW5zaGFyZSBleHRlbnRz
IGluIHRoYXQgaW5vZGUgZnJvbSB0aGVuIG9uLCB3ZSBzZXQvY2xlYXIgdGhhdA0KPiBmbGFnIGlu
IHRoZSBpZXh0IHJlY29yZC4gKGkuZS4gaXQncyBhbiBpbi1tZW1vcnkgZXF1aXZhbGVudCBvZiB0
aGUNCj4gVU5XUklUVEVOIHN0YXRlIGZsYWcpLg0KPiANCj4gVGhlbiBhZnRlciB0aGUgZmlyc3Qg
dW5zaGFyZSwgY2hlY2tpbmcgZm9yIG5vdGhpbmcgYmVpbmcgc2hhcmVkIGlzIGENCj4gd2FsayBv
ZiB0aGUgaWV4dCBidHJlZSBvdmVyIHRoZSBnaXZlbiByYW5nZSwgbm90IGEgcmVmY291bnRidA0K
PiB3YWxrLiBUaGF0IHNob3VsZCBiZSBtdWNoIGZhc3Rlci4NCj4gDQo+IEFuZCB3ZSBjb3VsZCBt
YWtlIGl0IGV2ZW4gZmFzdGVyIGJ5IGFkZGluZyBhICJzaGFyZWQgZXh0ZW50cyINCj4gY291bnRl
ciB0byB0aGUgaW5vZGUgZm9yay4gaS5lLiB0aGUgZmlyc3Qgc2NhbiB0aGF0IHNldHMgdGhlIGZs
YWdzDQo+IGFsc28gY291bnRzIHRoZSBzaGFyZWQgZXh0ZW50cywgYW5kIHdlIG1haW50YWluIHRo
YXQgYXMgd2UgbWFpbnRhaW4NCj4gdGhlIGlpbiBtZW1vcnkgZXh0ZW50IGZsYWdzLi4uLg0KPiAN
Cj4gVGhhdCBtYWtlcyB0aGUgY29zdCBvZiB4ZnNfcmVmbGlua190cnlfY2xlYXJfaW5vZGVfZmxh
ZygpIGJhc2ljYWxseQ0KPiBnbyB0byB6ZXJvIGluIHRoZXNlIHNvcnRzIG9mIHdvcmtsb2Fkcy4g
SU1PLCB0aGlzIGlzIGEgbXVjaCBiZXR0ZXINCj4gc29sdXRpb24gdG8gdGhlIHByb2JsZW0gdGhh
biBoYWNraW5nIGFyb3VuZCBpdCBpbiB1c2Vyc3BhY2UuLi4NCj4gDQoNClllcywgZml4aW5nIGl0
IGluIGtlcm5lbCBpcyB0aGUgYmVzdCB3YXkgdG8gZ28uDQpXZWxsLCBvbmUgY29uc2lkZXJhdGlv
biBpcyB0aGF0IHRoZSBjdXN0b21lcnMgZG9u4oCZdCBydW4gb24gdXBzdHJlYW0ga2VybmVsLg0K
VGhleSBtaWdodCBydW4gYSBtdWNoIGxvd2VyIHZlcnNpb24uIEFuZCBzb21lIGN1c3RvbWVycyBk
b27igJl0IHdhbnQga2VybmVsDQp1cGdyYWRlcyBpZiB0aGVyZSBhcmUgbm8gc2VjdXJpdHkgaXNz
dWVzLg0KU28gY2FuIHdlIGhhdmUgYm90aD8gDQoxLiBUcnlpbmcgdG8gZml4IGtlcm5lbCBhbmQN
CjIuIEtlZXAgdGhlIHdvcmthcm91bmQgaW4gZGVmcmFnIHVzZXJzYXBjZT8NCg0KVGhhbmtzLA0K
V2VuZ2FuZw0KPiANCg0K
