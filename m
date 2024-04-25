Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43E512BEB8
	for <linux-xfs@vger.kernel.org>; Thu, 25 Apr 2024 12:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714046956; cv=fail; b=gUVIkxfhYzZ97XiEFbWnFDhA71vNjoyIJLwPJvGfz/8AlYXysAt2LDEZ+mPRkEQjeWjHp6y8IgYQhh3lPXGBh0jI3ygvHpTljJn7I8cC2hxah1fKrN6TLlWOMPdlj3SAOptuK6YbNNDVrHWrjTqjPh8JspJ8DLRPxNfG1p4daY8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714046956; c=relaxed/simple;
	bh=iXMGZ70ztuU3bcP38BT1XMRW1i5NNSp683f8I5dRQdA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BakPO+GlwLRVefs3lqE4RofHeJGYJgStSf3cRh/6UfH+wc5FRwJ8c9I8HZvV8CsvP+t9QgFT8re1rOofSipoPFgnhLDp5Xxp0EVuRFZTcaNgcRqdoYDyGHxi2JaQmkv+3cntxucGQlNFMOPnQ6oDT1ge338cDlM0EGeIMJ/ogrU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oufEeh9M; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=AfOyqyJK; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oufEeh9M";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="AfOyqyJK"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43P8wsZE019551;
	Thu, 25 Apr 2024 12:09:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=ZWSxq4AG5T8EyPv4Qi8kPa7W+vlkMf13MJ4uusSmwU4=;
 b=oufEeh9Mj3kboUJOj/y15FJ3BnTYuw/EsSfyE0No8cEQjB8/JkGyVu63nf9hmxKD79QF
 Ojhjp9W0LPhnJIZSWthTaAqN9Sv5mlXqrJGEMZQzb8ZeLfzAP1LuJqefXMnix0Px6JJJ
 hpxjNgWg8k/7vWF/FbVwvWAaVDXe6BBW0HbFPa1+z5HR49H9z8b9V4+843q/Z+8n7+R4
 O14YEiYE4P55dCXhJwC43dn1napjByPjPabwHIYbslrGJHd+eeIqp87oXPUdlq5UoHUp
 uaPfs7GqbLlE2//KY7bek5QJ2qDww8HkGwzzBehJNBgGO0AeKQ+qygCbdkoCgVkiolSD sQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xm44f26ka-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Apr 2024 12:09:04 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43PBVXO1001770;
	Thu, 25 Apr 2024 12:09:03 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xm45awk8u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Apr 2024 12:09:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JsOioyFOMLpIvLCvfFj0O0VGwDTTUncN32gkUCnQS0tYhtV3wWettrqGnpe2elfGARSDFM5LnE5wbADMRYKr9L3rXs2DDKN3a4il7biICLtyMcnSAM/XgYdu3bS1e3zOa5Y9D2NMFbH5FNlDFb9XYC3DEMnUAOpHYUNfMR8ml/FuEnOEdmjN6tufmEzpVFKcIPz4gb/8RuMantMvawdiXcNhi3WdaWe1egacNUAuaV25LemHkrFre8102zJ7HsRi4iVEUua/KfNliqnazlLQHt/w3ZjqcasLlNlXlZ9MX5wGfFl+3TJCDga9izwzJ4J+dtuvWs/q8BydbtoJGdZq8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZWSxq4AG5T8EyPv4Qi8kPa7W+vlkMf13MJ4uusSmwU4=;
 b=K3RrkjFsOKRbWayvZ0RktZMwAbiW+cvgYUQvD3FrFvZBlYoOFoSQD23Qkr3WqdQ8YRrCPCEV8cPjUrgic2HwXN25QeWrXs37/ZwCKa/NqqV3ly13+jaRYrgJ4kTJ8DLJ1gPzDMQTiuSTqpYV9NTcU4pOrKMgJfGyILQFydq7V6VlYByT6KDht7YDfMn2qJaRI1sFSAhFYc0sZNFaYhB8ib/bM4+Yc/qZyV/Fi4MVMm7dtR+NmRz6+csRTlmelNCgWDD39rSyzk/5lm/KHHNl13RpT4KpBDcrnQwlZ/cwED2f+mNC11gXYvSTOCoxvRBSk7lc/kShqifZJJc+kqCTiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZWSxq4AG5T8EyPv4Qi8kPa7W+vlkMf13MJ4uusSmwU4=;
 b=AfOyqyJKU//B6Yr9fhxhWIadY6m8KoTvM+PMvqq1/cSFbXEOQNOd/NFsJHlllStYLj9+h+VjgjnaKO7XcLAnxQRLLrIAI6Hx5rfniRXw3d4DRLOepNcQF0/HZOaQaVUfx5HbEzYX16UFAXw/9Fr9BMJx03m2OY22/0TQmaEHZ1c=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by IA1PR10MB7197.namprd10.prod.outlook.com (2603:10b6:208:3f2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.22; Thu, 25 Apr
 2024 12:09:01 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.7519.021; Thu, 25 Apr 2024
 12:09:01 +0000
From: John Garry <john.g.garry@oracle.com>
To: chandan.babu@oracle.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH 2/2] xfs: Clear W=1 warning in xfs_trans_unreserve_and_mod_sb():
Date: Thu, 25 Apr 2024 12:08:46 +0000
Message-Id: <20240425120846.707829-3-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240425120846.707829-1-john.g.garry@oracle.com>
References: <20240425120846.707829-1-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL0PR01CA0019.prod.exchangelabs.com (2603:10b6:208:71::32)
 To DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|IA1PR10MB7197:EE_
X-MS-Office365-Filtering-Correlation-Id: e72b7563-6f7a-4901-d73c-08dc65207e46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?T3k3TkFyMnVKSzVvTWc1dmtmbUdINFFLc002YlZiajJyemVITmtVY080SVI5?=
 =?utf-8?B?Z2ZQc0JEWUhOR0EwcE4weVA3K084bUU1S2hubTg0azVOakNzb01udHZHLzZB?=
 =?utf-8?B?N1JTOUd6SEVwam12RGhBY1ZYQ1VTa1JucUxhRHhaL1RZa0RjdFZrNENDRmVE?=
 =?utf-8?B?bis4TUNCVTUzTnJsK1EweEY5ODNtYmFBVHFJYmJXRDlMRjcremptdHJtYkhr?=
 =?utf-8?B?SXplL3kyYlQyOUpzcXY0TnoxaUc3SndTUGwvMHFDcjlPU0tKRFFaN1FSa0li?=
 =?utf-8?B?TndMa00xRXcwdG1vTXdJd2IyUjRpUDVIeVg2bjlsOVJYcWk0QlV2RXFydmNP?=
 =?utf-8?B?R1RQYjJrT25GN1Z1ZktDOUNxVkl2V0ErRHdmTEIrNTR5VGNDTjZWdlVpV1Jm?=
 =?utf-8?B?dXVsdVlodWR4VkdKK0pyTTE0UUwrVkl2cVg5S0t5RXVSeTVnNnpCRUMzeVUv?=
 =?utf-8?B?aU1BLzE5V3VFYjdrbW9qd1pqY1NZYm04SmxJa2Zyc0gxLy9kUEtTa2RqaHVo?=
 =?utf-8?B?akpmSG81WlpRek5xdHdlVTIrOGVaWXErM0RBaUFtYXdHTUhiNnBGd29OaFlD?=
 =?utf-8?B?T2hJNERxY09CQU1pK3oyQTdjdzRvYkxjZmtRMTliR1NvenZWZ3VNanE2K3Fq?=
 =?utf-8?B?Tis1bWFWekJ3Y3RZdmNpTUsxVmUyby8vUWdlR2RDQklwTHRiMUZrZHZGQ0pQ?=
 =?utf-8?B?WVhUMDhweG1XOVNjRzJEZnNPYVNtd3pBa3kwT1IycmRMYm5wVzJOb0hYSVQ2?=
 =?utf-8?B?cytmTmpoczgwc0NBMjZ1MW5lSkluajNjQTJpMVZuSVR1ck5IbmNFZ05UbjBu?=
 =?utf-8?B?TGVCOHNMelVkbzZNRFQ2aGpXWGszSnFQdnEvNHltck91YU1ubnMzcDE5eFZw?=
 =?utf-8?B?bVRXNndMT1B1MC9SUm02bnJYdnhtTWJMaFRsbjI3blh1YTkrd3hMQmtWSCto?=
 =?utf-8?B?UWdJQ09XUzA4NnVDS1kzbWlzTlVBNVVmdXNnbHdCaWhETUxSU1BZNExiODRm?=
 =?utf-8?B?UDEwK3dBc013bEVwY1d0ejNHMDRIS0VEUzk1VnlCaFdtazVnVG16NjNjKzNw?=
 =?utf-8?B?dWRoSjdzVHpaMlYzbENrdVBXZXF4STBCMklXLzlyV1FiUEZpb256MnUzdEt6?=
 =?utf-8?B?VUZQSEFHZER1dUZZZlE2REZTVWJSUG9zNFpUR3dJRjduc2FZV0k2K3BVSEt2?=
 =?utf-8?B?QXBzSkkvVlVONHUvZlZ0U3A0U1NJM3FLWUg3UEp4MzI4emFDeGhnaGczT1cw?=
 =?utf-8?B?WVhITk5tMVBYbEEvMW5KbllnNXZNU09nS0VQR0tMOVkwZ1A2aEpRS0YvdzRw?=
 =?utf-8?B?aTBRMnkzaWxKeTVlQTNJanpVS3pHcU5jOHRMVjM5SDhub2x4S0ZCNW5obG80?=
 =?utf-8?B?am01NjBqOElYQW9PZEdqRjUzVGhXYklDVzdDYTNzQXB6OWR4dkVRL2FpZTlM?=
 =?utf-8?B?VHNlWEYwWGhzVXEzcC81WUNLQjVNemxtSU9lYk5zQnJ0M1lLY0w5WmQreDQ5?=
 =?utf-8?B?cG45NGpjQjJqN1Q3L253REwzU25qUWNMUmZRRVpReUcxTHJhRDVxN2JsTEF0?=
 =?utf-8?B?enBRU3hpV0ozQmhYTXpkSFEwRUg0NmI5Q0MvN2hJZHJJdTN3QVpUU0xPU0hk?=
 =?utf-8?B?aG03R2lDTG1UMmdCbG5mWHFUWFcvcXVPdDBpaDVDNk9NejhySTNJQ3ZvNVFn?=
 =?utf-8?B?OXozTUJhdmlRSGpNTU9EUHBiTmhIalQ1cWU0dmpYS1lCWWI0eS9abE93PT0=?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?MHpLR1Q5V2Nxcjl1TjRmK050UzQ5Z2lxNlc3c2FNeHJFcXl3ZUhkZU9WTVdG?=
 =?utf-8?B?WkFMYkVGVE5aVXRHc0ZSMXRPTGtzRWxaR3FhMU9KVFptK2J3VzBieThPNGYw?=
 =?utf-8?B?UStOTGh6OWcxZlpEU2xlTyt4amhURHprMTI1aHdWUGY0OVRrcjRNMzZDUXJX?=
 =?utf-8?B?WElDR3NlUXJwRGdEQ3pzeEoxSFZyNlh5QWVaMUlDdG5nbHVxVUdLZkVyM1ZW?=
 =?utf-8?B?ZytCRlNsdXhRTHBkdHlMSHljV1BPd3ZMOGRkN3FmRXB2bmFVb2JHdGlUMUJG?=
 =?utf-8?B?NnBUQUNlNDBkVjcxUTZ1NkF0R0tlcnFSb0J6bmFCb3JBOUVNVGM3THdZbUVx?=
 =?utf-8?B?Z2RZSzlqQnNKQnkrcWdDSmdqTmtKU0dFdnZqVFZiWnpLQUxvRm0vSVR5b1kw?=
 =?utf-8?B?dHo4OGlhS2NKQTNsS0xlSmVoSGlDbHFzOElDL3IyZFRWYVhNY29FSEptOGFX?=
 =?utf-8?B?Nmh1N1lZTmJ4ZnBkdGhKMWZTbXMwUGdvQ2RXTWppUW0xNU55QkhPQzZRdHBz?=
 =?utf-8?B?eUtsTlBiSW5NM3lWNDVWd3VLcGFxcXBTRzVhTE5nQWFFV1ZrNWF1UStvVENv?=
 =?utf-8?B?Rys3SHBWRmtVUGdNTkJtUFd5WmlTanB1RzJZYzRYNENOanBCRTV4MDhGQ1lx?=
 =?utf-8?B?TStRQ2MxQlFjYnVwdVpTQU15SkdEcHBmMDBhUExHUkZlWTB5VFNBbHFxbVgw?=
 =?utf-8?B?YzVudUJ2b3BRTGhxay9wNEFQODFKK0M2ZTRKT3lCZTNiTjh6Nm1BbDNjOHNq?=
 =?utf-8?B?NGdSMStwdGtQOC9NSGRnajlMcVBrYzdnem44VS9xVnJUNXpRSHYxQnFaMFV4?=
 =?utf-8?B?Y1prVWpkTGJvUU5scFJSWXRjWDBidTB0S0JrNjUyc054K0c2OHBzc1Vhd3A4?=
 =?utf-8?B?eGgrZFBEMGF5bjNiZXRqdmZ3N2lNZ0NFWkxMN3ZOdnh0K3QrZFFFKzJBU2dJ?=
 =?utf-8?B?dkF6MFNXd1VIWld2ZjJLa3Y0ZmxINVAyL0F2YzBpM3RiSkxkcEFXY2FabnBj?=
 =?utf-8?B?QVY0VWR1V3A3VjI2YkRMeVB6ZmtxKzMwWGJKeTBJcUNXbzRFRHF0d2ZqVlZJ?=
 =?utf-8?B?clNPVFhTcHoyWFlZVkRNK3pMUHN5cGhvU3hEZU5zZ1BablF1WmJQZE1LRWMv?=
 =?utf-8?B?bVFGakVWcFBDY1Z2bWVaMTRkaTV3dWd3NCtWdkJhZTFaRWxGaWtybG9wU0pl?=
 =?utf-8?B?c3h1cmZhUW9weEVOb0c5WjRyejhKVDF1V0E5Y2wycTBWci9SM0l6dkY2SDhz?=
 =?utf-8?B?dG1lR0FSWXljL1NIeGpvUUQyQUdUSGQ1ajB4YlF0WTRnQkd5TVQ0bitaRjhI?=
 =?utf-8?B?MU1jU0taWHY1dFFxa0V2RmdRNDRUbWxqVEFLNUU3WFZFeUNKV3pOSGdiV3NB?=
 =?utf-8?B?dndBTWdSZHZQYzVmeHQ4bERoOVAzaHdpMFJ5RUZSd0RyRmVLanE4OG9sUWd3?=
 =?utf-8?B?VTBqelVTRGFxY1BQeUl4alYvejhzL3lIc0VKbzFzeWtYelpwM2dJQzFndjAr?=
 =?utf-8?B?UFVMK3N0REtmMHl0M0taMmhYaWoxQXE3VWNodGFRZllWRFc5clA3UFRabmJw?=
 =?utf-8?B?NHZzWklhTURKWkRYNm9hT3cvVHhOYXdLM0Z1dGcydkoxdVdqM2NJK0tUVE9E?=
 =?utf-8?B?SFRjdXlRcGpSQnpvay95YWpWYndJd24wU2QvYXMvcnkzT1N5L1dwVVA3Q3Zj?=
 =?utf-8?B?eCt6TWtuc01Zak9Ca2tWL2d6U1o4NzFhdEpMZ00rMlpCbFRYZ2lZRDNUeGNW?=
 =?utf-8?B?RDJrUUdWbnFhTngxcVdQcmVYMG9rU3V1QmNncjVSSDcydWRvRkZWL1BkZ0R0?=
 =?utf-8?B?aVc4eTRvbmVvL0hoN3I2bzVJdENidFVjbGxTR2VMUUgxOUNHZVBpeXB0VkJp?=
 =?utf-8?B?VmZiajdlN1QwUDJHUU1iVzRXcTBjTHo5L3NUTVRnNWlnbHFidW1NNlZ2V3N5?=
 =?utf-8?B?ZUFnU0xCc1drNTB3KzF1UGJldjBCL0RLbDBXT3JCdDYzdlpMSEFMQVZqYnBy?=
 =?utf-8?B?KzhDZnNma3k4RDVmZXhXTFBtc3BQRS9BVUtLVzhCSXRrYnJWakJHLzhNM241?=
 =?utf-8?B?dVUvNGlKbkdkQUl5N1R2amlkdzZUR21nRk4rT3lVYVhyM3k4NEN3QzFxV0Nn?=
 =?utf-8?B?MnczNXhqSU9XMlozdG5jV0g5UVU1ajlYeklPTFhUZm9QY2V0TFhkOUFQRTRT?=
 =?utf-8?B?UVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	gK2TKwficUzV3Rvrs8I4Nbk/S8f71vdm63o4Ilm2WW0SvZlptnJMoMU1wzpEoGts87okeWJDYKM7zhu8Zb2fiqWCR4sgw8eROcr/kadhsO29/eFl9Aq8F5WO+fdaghVOUNhiflxDltZpzNsWo3TWNPL2XXmwjXI5NpTPRqC4BsDf4ZPPGmZpJvlrSzlfDcAYAeXTuuEJDdtGb2pqjLkR5HGN5hx/uInXW2k/gsemPu23+Wrju6M+JJx2kwA0nJfsnj1B5nkI7qpyC6Klro1dxBFExbimmv2bpwcm/dXvgWw2hJccrv2uBpZC3UKLw8AuziqVdFxa67p53kseBSGH5Bh8aa1GzG3/TQPsANQQM0+yqHxSKrawI6ka2Y7yzNTVqXaQe78AqX/LW/8RV8tPJj2v3BGVaRg5MXkM2sq+2E1lRsTENnoKoF74OrzYQufJ8F2iDC8ou0VNkxaBtgwNrMnKy8+M7ib2+//Jdd9z+GFRFjxr865CWlIzfn4caGCESAloEArGXmHviNSvOYiSN+n474guYkJr9om6wCcdNFMwN/jFQjcRUoHV47rYdwoAQC2TvT+wr1insna+RM8Me0wmJMEoopX07iUlqN1GUjQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e72b7563-6f7a-4901-d73c-08dc65207e46
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2024 12:09:01.3360
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8uUutKK7wpM9DABxYe0N7sqVjd0bXXZp6xcS1nPE1gQHP9kuXys63dso6QS8eHWUpCyU4Jzoo5V3veD6irCOEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7197
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-25_11,2024-04-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2404250088
X-Proofpoint-ORIG-GUID: E6E110vMRzK-k_YQuuikKVqdvG6LJbiI
X-Proofpoint-GUID: E6E110vMRzK-k_YQuuikKVqdvG6LJbiI

For CONFIG_XFS_DEBUG unset, xfs_trans_unreserve_and_mod_sb() generates the
following warning for when building with W=1:

  CC      fs/xfs/xfs_trans.o
fs/xfs/xfs_trans.c: In function ‘xfs_trans_unreserve_and_mod_sb’:
fs/xfs/xfs_trans.c:601:17: error: variable ‘error’ set but not used [-Werror=unused-but-set-variable]
  601 |         int     error;
      |                 ^~~~~
cc1: all warnings being treated as errors

Mark ret as __maybe_unused to clear the warning.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 fs/xfs/xfs_trans.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 7350640059cc..46674a9b1c97 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -598,7 +598,7 @@ xfs_trans_unreserve_and_mod_sb(
 	int64_t			rtxdelta = 0;
 	int64_t			idelta = 0;
 	int64_t			ifreedelta = 0;
-	int			error;
+	int __maybe_unused	error;
 
 	/* calculate deltas */
 	if (tp->t_blk_res > 0)
-- 
2.31.1

