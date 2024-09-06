Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B4C158D7B
	for <linux-xfs@vger.kernel.org>; Fri,  6 Sep 2024 21:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725657111; cv=fail; b=Mtr7tSQHzjtOmQNn6FIxfsmTiKX8dwqURhHcKxZV6pcCpPLy4IJXRv9PbceXAofqQ4SrZjOFhG6C+viuTyX7qjgFs/mIa8Jr5usRTOzFrbOjyIqUe8XhREdzLEnkpvuiuIg14/ZoIBPsZWpoLXbm6PirH8ZFzo1G+p0ePeNP0pY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725657111; c=relaxed/simple;
	bh=X2DnA7ZC+DoRx60TbIiXRACpsYI11z5HLsh3cqWuPc8=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WvyxwM+1ZHubtR9/dLvSY+t8dV5RilgLqC0r3ANuRZAvwHJRg+Hjv40OVLKbaVkI5XBM+SrTg0kxtZaPq82sJAeVLak0aeuZGbcoyb/E+TmxdCHR7sOoQxt+1da5r7UcV7U+/eaXMw7rZR2tmoHndDDv9TPLGx1bL1K6cGd2gY8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Kbs5ODcB; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=QazZj8Pu; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Kbs5ODcB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="QazZj8Pu"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 486KXV0O015021
	for <linux-xfs@vger.kernel.org>; Fri, 6 Sep 2024 21:11:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:subject:date:message-id:in-reply-to:references
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=6d0nsBvi1FRbFaqVbRM5NAAPIbgj3sIou/pOldgMldE=; b=
	Kbs5ODcBBW1rkSmqdYqOOUflItjzfuZ/eADvV53orjTCRTjbp75iShifPEEIDxqQ
	PGqFm26SD2K4W0NqHDN9yV+5PkMNM7LjDFNmgNjzjLD2XSZqWT3YjF0ztgipZJKp
	r0MDR9EZMAywjncxuIjs6JZCigp7XRdO+MOj7C5cB6Rvx40J9tr0J1Q/jRwUWVwP
	CtjDG7WWMuLf62pKcG8udMHCExlSQTfroxbWiCLG/wtkjoHnBh5uISGL5LmOHEXo
	oebBw081KJLTyIfrlTNxQ5NmMxM94X4+GHvthGyz1xMEQ/Q6EbwZyGvsO6zYBwgG
	bZwOLOB7WvR/tMg7s91mgw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41fhwjjmxm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 06 Sep 2024 21:11:48 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 486JldpZ016162
	for <linux-xfs@vger.kernel.org>; Fri, 6 Sep 2024 21:11:47 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41fhyjeyqy-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 06 Sep 2024 21:11:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OGJkxZrDp4FNtHQEO2VzzfOT7g4dSMCfR+OMUoLUlKFo2kNjtTcRTk73uVx5pVtEjB1iF5AWjDn6TsnFlLvLVcnLo9/iHZZgXDeehuN9Cwyja/BPKyf9czL2xF5exEhBbkumm/thdWk0NzX/ozbtz3zE+P8gXjdd57MURlXf08z4QC5cze3jm9k1mtrdnNWILLFlq0+ZUBu0VHozkcIz2Bt2X7tq7vY512kWitePFVvs7l65b84hBRsKNr3e0c8JsGLFzebhFgt1mGPYUeZ3w0Ff4IC+BFv96c8luAPwp6KWagxwB6A+Np6roECviUWlm62MVq/bffzT++9INrQEFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6d0nsBvi1FRbFaqVbRM5NAAPIbgj3sIou/pOldgMldE=;
 b=ysvA5LRrCeeROBAPj8bxot3eh2G2D7nshs6imfoiWxPPz02HLWKuWOZhWtrofr79ec/dh4qMltxwXwiw8RhgxVafWOXWOedvMxRz7voMxhMQExS0XPj2OT3BPBNNIQG+v5mmR/O1bmExWrIo68kdW0+u6y5acQL441NuikhHTGulq3Q55kFQyqbPDTdaPGKQo+LUsozjZ2NnRWZEn7a3ymL2TtrUeG0AZ+CTflznwSTvPi1njUhHkVXm+ej9K0XF+3SwPPclwDEukWQpw6ucNG56JlYwBYbk2X/pmgbysA7iCeuG2ewDNFri0qc7YZjjC5dDEpuzomPcOmhEisMfdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6d0nsBvi1FRbFaqVbRM5NAAPIbgj3sIou/pOldgMldE=;
 b=QazZj8PuQTxgGRFCXl29uz3nyl5LoDgoy9clVEMCGSsXd+lGk0sCbWLExZnMZQR9Kj6QTjCtY+AyZl31/iG1micCPxg0MBFUrMhT9tOL1zrXP5PUbLpInFuKt5YkR4AK9MZ8+rVsaF/7AefpuwLRhuEauwYSn2qxh55GoQ9biVE=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DM4PR10MB6765.namprd10.prod.outlook.com (2603:10b6:8:10f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.9; Fri, 6 Sep
 2024 21:11:45 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.7939.010; Fri, 6 Sep 2024
 21:11:45 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 01/22] xfs: fix error returns from xfs_bmapi_write
Date: Fri,  6 Sep 2024 14:11:15 -0700
Message-Id: <20240906211136.70391-2-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20240906211136.70391-1-catherine.hoang@oracle.com>
References: <20240906211136.70391-1-catherine.hoang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0127.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::12) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|DM4PR10MB6765:EE_
X-MS-Office365-Filtering-Correlation-Id: fb7cd463-43b8-4908-3c27-08dcceb8836f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dXNqeEZ0d3dXclBQTSs4STU0bW9NOGdOTE9TQit4cUZnYzFMZnJZWGZJMXRo?=
 =?utf-8?B?Y1pTNHl6eXN2NlZMK0NIdGVPWDVhZHljWmJCQUNvU2pvcmRVSFMvdXRZQlU2?=
 =?utf-8?B?ckp6WmVDemVUc3RyWkorMGM5ajF1cjA3bzQyakpiaHhCS3o2bjZQdU94L1pL?=
 =?utf-8?B?SlhHcVlOQWpuT3h3aTNiaVRpWTA3N0VMclVNRld4RWJjRUkvVDBGQU9URWRM?=
 =?utf-8?B?R3JDa2JRd2F1Z3BjdDJnT3piM2lHcGM1bTlRdTdocVpRR21uSFlPUTlOQUFX?=
 =?utf-8?B?RUJrNUVOM2xHVUxsNkNHMVlzNFFibmt0RHlDakJITlBpUTdLS2hpWFArQ0pn?=
 =?utf-8?B?K2t5YVlTY1N4dko3bGJyUzc1bFZZWFpEbkRITFVnTjVHS1QzaDl2VGoxdEQv?=
 =?utf-8?B?TjU0TStGbmsrRnNiZUpHRnRqdnRiQkt5Ti9QbXQyc1FQY2xZRWpCTWRqckFD?=
 =?utf-8?B?Y3h2M0dseThLQ2pQKzhoWHU5WitEUGZuTFlZV29FRHhqRDc2T1VLUy94UmFu?=
 =?utf-8?B?cVRVQStCcUcyTE0zV0RsWm9wd1ZKU2srdk1iMEpsWnpndUFlR1N5VjB2NjVU?=
 =?utf-8?B?bllIamtkVU5wcHM3MUxUR2xMUWo4aWJpSURlNjZTUFM3NElCVFJLN3lxM1JI?=
 =?utf-8?B?bVB0aDVtT1ZqTFN5alRRZG1jdWgrckpHd1NyT2FoTDNycFE3bE1LcEZRS3hw?=
 =?utf-8?B?WUs4Q0dYQmROK2JSWVVUQWYvbGdOOHlJRkdDT0FjUjVSOENDT3NtTFRzVUdy?=
 =?utf-8?B?WUZNSmVDeUFpQTQxMG94N0pPZzh2bk5aUzRhbnhubWovM1BPR0x2NWE3eit3?=
 =?utf-8?B?dWhFR0trdkhPTlVvMWxOanAyVlhtbTM3T00xSzFwYU5aVVhkaWJkcmtCVXBC?=
 =?utf-8?B?bzNZRHRBSGVta0haUnlEdEpaNmdzREdRU1NSak5Gd1BMMXJHRFgrdFIrTkxy?=
 =?utf-8?B?SGpDamhjMDh4SDk3SDdyM3NNSGxaMWRic3dKNEo0RitJWE1KQjg3TE9vb25W?=
 =?utf-8?B?enRpM2x5bGNoUFV0YncyZXQrcGFYNUp1aWZXa2RJMndmU01oTysyLzZkL21y?=
 =?utf-8?B?UHI3SnNWdTgrQlowZytvNlFDam5uM0Voa1Y3UjFGNnh2RTZnSk5WVkh2VTlS?=
 =?utf-8?B?Y0hYZGN6WW5lYktiSXk4NnU4eWczczVaUVQxWlYzNFlsMTM5UkZQbkwrdDB0?=
 =?utf-8?B?UkRlN2VZdzRZYnpJUXlPWGs5eU40cDZGZ04xbzBLSmZwWUMvK3JKcUdnOTJW?=
 =?utf-8?B?WEQ3N1VOYlNTNlI4c1VFR2dGajN3UWczOVFkc3R2cFIzNU1jOTZPcGVTYnhY?=
 =?utf-8?B?TEZLRjdHN2NMaFN4SXQ5YzBQUmRzYzA1ekRVRXBvbzRlRHZGeStNLyswbSta?=
 =?utf-8?B?alBkNXAwbloyK1ljY1RuZTlUbGhSUXd0eWlkenZyRUZUN3FYVzhybDdiZ2Zu?=
 =?utf-8?B?SjZ2UGVDYUJSa0hleG05QUZBUlRKaWVLUTkwRnlUYzh1Zlh0cStPeTdsNU9t?=
 =?utf-8?B?NHRTQXQ1akRSd1pzcCtpWUl1NXpuOENhYWkzTjF2djEwak9xbEcweG5JQTlR?=
 =?utf-8?B?N0pkdjlFL0FHTUJwMGRYaWpuUURubXFFemd4cTBtdHp2YVZxWUNiVjBPb2No?=
 =?utf-8?B?RE1YeFlvMG9jb0lhNjZVdjNJWHNhTnNjUnRuajJqL3FZa1hCbHEyS1hRUG5B?=
 =?utf-8?B?SWdTWWNuYWx1ZTkwV1cybjQva0VIQ2ZLUXd0NVgrSDZaNWhOQUI4ZUQ3RjBy?=
 =?utf-8?B?RUJxb2tuUk9FT0VaYW5FeTZHeG12Qml6c3lrdS95dzQvZW52a3RTQUl3djFa?=
 =?utf-8?B?d3pJOXBIRmNETzY3LzRTQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SXlKR3RRZTBZV2oxTDNuWHlCNTg3UytiQmhjb0NPZnJ3Vm9Qa01VTURQTGEy?=
 =?utf-8?B?eE9VNm9vY1RQcHJJZlNQUXpNTEdBaGpuUzliSHhleEp6eDhLR3pFcGFFMDdN?=
 =?utf-8?B?MUxxaHY3TFBlVVNqeVVHOU9ZRThMRG9rNU9FcXlhV2VNY3BNLzYrakVyMzJt?=
 =?utf-8?B?eUJOYnI3U0pQVXN1NFpLVjdzdXEzVXF2dTJiYlBSdmFUd1VJYnpRRm9tZU5W?=
 =?utf-8?B?Q0hQZi9oc0dhdU81TkdIMWM2amg0MVpxaU8xMnV5Nm43TmxvYjlHbmlzK0M1?=
 =?utf-8?B?T0RZa1dhR2RKWUVLOFpwTWtwc3VqS3p1VVFUY0NXK0l0Nmp2cnRDQktzYlNL?=
 =?utf-8?B?NVRydFl1MndHWVFuajk0aHloZXE0eG9PUWRhWERpSGRlbUpWVkUrVmRxelpt?=
 =?utf-8?B?N3dpUTE4SUlNU0tJTFJuMGtwdWdzNHhoaHJKVVh1d1M3ZGFEbG9rVEpIekhh?=
 =?utf-8?B?d1QvaVdmaWpWK0s4dFZDajFNMlZFQXNxa01pOFl4MFJjN0xaUEM2emovK3o4?=
 =?utf-8?B?cWRyejc4aVIwVXVnSnRkNFlFa2RTaXVtK1ZOU1lQNCtFQS8yVlFmT1M5ekdm?=
 =?utf-8?B?UEJjZEdzL3FBWExZbkw4QVZIai9GR3JjQ0RrWXF1MTliT3ZmZ0RRUGVQUDNu?=
 =?utf-8?B?ZW82aW10VERCemRkRE43UkN5THY2emhZc3RKQjkrdDhSVlhmWkpBRGZIRzNK?=
 =?utf-8?B?WDR3V2c5YnJLbm05R29nSGlpOExwSzBBaDBXMkxzYzJQRE1jTE5Wd05WQWJO?=
 =?utf-8?B?cWsyaEs2U05hOG1nTWg1ZENWQncyaDBCc3VncG9iZlFVSmQ4MUk4OTVjQmlZ?=
 =?utf-8?B?UENFaFVWSExGQWlUSytLZVFpNHpyWjBSeXh5UzUxVUNkQXVZZDJiQUlxTHl6?=
 =?utf-8?B?Si8vTzJHaE1tZWJJbnBqSlZTSTV5d2hRbXRYN3ZwbFZ2T0VEOVNkSWZ2VGwz?=
 =?utf-8?B?YlZaUnBWMHhLQ25TWjRpM3VSRzF4QVY1NkNIbnY0VTJRbUZqekg1M0hEK2ly?=
 =?utf-8?B?dWpuWVE5U3BjbnVSWGUxR2svUG00OFNmdlNKUmNQMTE5WGJpTkdTQ2FiNHZq?=
 =?utf-8?B?N3lwdWJmNktta1NYd250TmpTTFhPY1Ntdzd5ZGJpMldpNjZrSzh1MUxaenRk?=
 =?utf-8?B?emlJOHZnRVBUZC92RE11Um9XMjRhTy9oYkc4RVRKMTNaUmpmS3gzY01NUWk2?=
 =?utf-8?B?SkJKVmE2MWFhdzZvSVlkOWVxWFBCS0VKaWFaWXkvcnVTeTJLY3ZPL1o5UFk2?=
 =?utf-8?B?bFNkL0toTlZCWTV0OXhRZmRVUWFBVElHZS9PQVlMaW5UWmg3V3lINU5TeFRB?=
 =?utf-8?B?a1hBSHlJRXlHVnRMbXR1TjBwbHZqSVpvRm5mV0pUbU01b1ZpcDVpNGEzWDlV?=
 =?utf-8?B?SXY5SVR2T2ZBeFhIWnVSaWRIMjVxVTV1VDFxU1dsL1V2VlhiNklFSTBpVzg2?=
 =?utf-8?B?TWtwTmEvWEhmVEJFQVNvWEp6RWxIcDJ1MEk0dnM3cEFhd2l6STdKNkdXa2cr?=
 =?utf-8?B?TzMxWENZRUt2M1I5TlVqYy9Ya2tQU0FpUHBYSk9HektqQS9EZDgwRkFoK1dM?=
 =?utf-8?B?Wit1ckptRVppN1ZRNG81ZFEzdkpxb2RwS0QvRU5uaUxFZnpOUkdGN0tsTEU0?=
 =?utf-8?B?SlpnTVZwUE0zY1dtNE5wQVM3NUU0ajRRYldYRVdlWjRObkdxbTRjOHRRVWVJ?=
 =?utf-8?B?VkZCSGY2NUtIV2VqRHo3ZnN2OXF6MldMYUFPYUxFekRSd0FVcm1oSWo1anox?=
 =?utf-8?B?a0V0TmMxeXlQNFU4bFAwYUFsNTNqbm91MFUyYVhoV2tuSjc4NFc4dEF3TWVJ?=
 =?utf-8?B?Y1BlNXFybjRmUitOazdsSmZzWDVlVFZRcFRzbXArTmEzMzc1Rkllak05Tm9T?=
 =?utf-8?B?b2RWckk0VVR0VnVlY1k2SjdjNXJMa0FRd0R0c0U3Y29xa1QzNTY3K1pOTkxF?=
 =?utf-8?B?dldCMnNlZTIrSlZvTnM2NVVmc1drSWZjM1FHb1g4UGRCd3BkY3gzME1wYTcv?=
 =?utf-8?B?N2hzTjUxN0txdnN2NnpwSDJ4OURTN1hlZXJNWURWZmVCbnk1bU1uR2lRejUx?=
 =?utf-8?B?RFVNeXJIejlrQUdlblVoQkJTaTZFaWhBMkhXTmZ2TTNxRnQraE9jU3hBZEJZ?=
 =?utf-8?B?UVB5Uk1aNVJDVTJwWENRRnFGY1lxVm91cDdZRXo4Sm8ySE42WVVFWVFCSlph?=
 =?utf-8?B?OWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	N4/dlk58uWUTLun3qol+uraqJiXyBZ1gTnD4urjB/WJucmYcArlE+NqwhYCzWFXeJcaGUEK6PfO1tug3uuJGx6C9wZIu9Hh7ZOtwiksQFUJfcS7yggnLVxk+d4qL+8M0JEzFraN38DDDSCL1SVARn5pyyJi9hwUlFRoF59x/o52ymJZj1aCeipffllxuM0jP9mA1CqSr/2l/JpYtgoefFo2r16cNZYqPI2XpYMzMdfkJ4AJat0i+/mZYk4vgmSy23JN2e5eEw8mW0fv8hsLM2xXcaEfVo54yqcCo+uaXeErHuGb9XOY4f6ix9sz+ok4JQpgZpNBr5DatcXpLvxWRPpBMTytEgTJ92RAj86JbG+bD0DA44m2mFvCrAxtg923IglqEGn1AIp2Sw0qBrOSeGzWO35jxhReCEebR+MYuUBV31CDC3+IzWUqvAcmXUlv22RnMZY0Hav9Gj9/aAeP9Qc81VgyilgjLbUL0HXik9TVwQUKYNNkN/j5qVJvbRqB4EV/YQVyIGBruQ+sRQr37pZHUQEIMQIeNVCKsTtPJ3xriUPU4f+e8MOCa8/5wS85OtAhSLiJA367z984JAnc2b7pkS0hekps/WwFpx2d74AY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb7cd463-43b8-4908-3c27-08dcceb8836f
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2024 21:11:45.6416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M7Cs+xmf+I0pVCiZO0IZsSMHSWSq6IHN8YgPaJ5dA2NoGB/vqY5ZO9MwxQCN0o5jI0V/pPa0FkzJyJwjovwZPpIhiRmsvzBn9wOFDMQMLlE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6765
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_06,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409060157
X-Proofpoint-ORIG-GUID: jSxmJAqNUExwZJQ6etHtdHEC_K9-e0Y5
X-Proofpoint-GUID: jSxmJAqNUExwZJQ6etHtdHEC_K9-e0Y5

From: Christoph Hellwig <hch@lst.de>

commit 6773da870ab89123d1b513da63ed59e32a29cb77 upstream.

[backport: resolve conflicts due to missing quota_repair.c,
rtbitmap_repair.c, xfs_bmap_mark_sick()]

xfs_bmapi_write can return 0 without actually returning a mapping in
mval in two different cases:

 1) when there is absolutely no space available to do an allocation
 2) when converting delalloc space, and the allocation is so small
    that it only covers parts of the delalloc extent before the
    range requested by the caller

Callers at best can handle one of these cases, but in many cases can't
cope with either one.  Switch xfs_bmapi_write to always return a
mapping or return an error code instead.  For case 1) above ENOSPC is
the obvious choice which is very much what the callers expect anyway.
For case 2) there is no really good error code, so pick a funky one
from the SysV streams portfolio.

This fixes the reproducer here:

    https://lore.kernel.org/linux-xfs/CAEJPjCvT3Uag-pMTYuigEjWZHn1sGMZ0GCjVVCv29tNHK76Cgg@mail.gmail.com0/

which uses reserved blocks to create file systems that are gravely
out of space and thus cause at least xfs_file_alloc_space to hang
and trigger the lack of ENOSPC handling in xfs_dquot_disk_alloc.

Note that this patch does not actually make any caller but
xfs_alloc_file_space deal intelligently with case 2) above.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: 刘通 <lyutoon@gmail.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_attr_remote.c |  1 -
 fs/xfs/libxfs/xfs_bmap.c        | 46 ++++++++++++++++++++++++++-------
 fs/xfs/libxfs/xfs_da_btree.c    | 20 ++++----------
 fs/xfs/xfs_bmap_util.c          | 31 +++++++++++-----------
 fs/xfs/xfs_dquot.c              |  1 -
 fs/xfs/xfs_iomap.c              |  8 ------
 fs/xfs/xfs_reflink.c            | 14 ----------
 fs/xfs/xfs_rtalloc.c            |  2 --
 8 files changed, 57 insertions(+), 66 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index d440393b40eb..54de405cbab5 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -619,7 +619,6 @@ xfs_attr_rmtval_set_blk(
 	if (error)
 		return error;
 
-	ASSERT(nmap == 1);
 	ASSERT((map->br_startblock != DELAYSTARTBLOCK) &&
 	       (map->br_startblock != HOLESTARTBLOCK));
 
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 48f0d0698ec4..97f575e21f86 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4128,8 +4128,10 @@ xfs_bmapi_allocate(
 	} else {
 		error = xfs_bmap_alloc_userdata(bma);
 	}
-	if (error || bma->blkno == NULLFSBLOCK)
+	if (error)
 		return error;
+	if (bma->blkno == NULLFSBLOCK)
+		return -ENOSPC;
 
 	if (bma->flags & XFS_BMAPI_ZERO) {
 		error = xfs_zero_extent(bma->ip, bma->blkno, bma->length);
@@ -4309,6 +4311,15 @@ xfs_bmapi_finish(
  * extent state if necessary.  Details behaviour is controlled by the flags
  * parameter.  Only allocates blocks from a single allocation group, to avoid
  * locking problems.
+ *
+ * Returns 0 on success and places the extent mappings in mval.  nmaps is used
+ * as an input/output parameter where the caller specifies the maximum number
+ * of mappings that may be returned and xfs_bmapi_write passes back the number
+ * of mappings (including existing mappings) it found.
+ *
+ * Returns a negative error code on failure, including -ENOSPC when it could not
+ * allocate any blocks and -ENOSR when it did allocate blocks to convert a
+ * delalloc range, but those blocks were before the passed in range.
  */
 int
 xfs_bmapi_write(
@@ -4436,10 +4447,16 @@ xfs_bmapi_write(
 			ASSERT(len > 0);
 			ASSERT(bma.length > 0);
 			error = xfs_bmapi_allocate(&bma);
-			if (error)
+			if (error) {
+				/*
+				 * If we already allocated space in a previous
+				 * iteration return what we go so far when
+				 * running out of space.
+				 */
+				if (error == -ENOSPC && bma.nallocs)
+					break;
 				goto error0;
-			if (bma.blkno == NULLFSBLOCK)
-				break;
+			}
 
 			/*
 			 * If this is a CoW allocation, record the data in
@@ -4477,7 +4494,6 @@ xfs_bmapi_write(
 		if (!xfs_iext_next_extent(ifp, &bma.icur, &bma.got))
 			eof = true;
 	}
-	*nmap = n;
 
 	error = xfs_bmap_btree_to_extents(tp, ip, bma.cur, &bma.logflags,
 			whichfork);
@@ -4488,7 +4504,22 @@ xfs_bmapi_write(
 	       ifp->if_nextents > XFS_IFORK_MAXEXT(ip, whichfork));
 	xfs_bmapi_finish(&bma, whichfork, 0);
 	xfs_bmap_validate_ret(orig_bno, orig_len, orig_flags, orig_mval,
-		orig_nmap, *nmap);
+		orig_nmap, n);
+
+	/*
+	 * When converting delayed allocations, xfs_bmapi_allocate ignores
+	 * the passed in bno and always converts from the start of the found
+	 * delalloc extent.
+	 *
+	 * To avoid a successful return with *nmap set to 0, return the magic
+	 * -ENOSR error code for this particular case so that the caller can
+	 * handle it.
+	 */
+	if (!n) {
+		ASSERT(bma.nallocs >= *nmap);
+		return -ENOSR;
+	}
+	*nmap = n;
 	return 0;
 error0:
 	xfs_bmapi_finish(&bma, whichfork, error);
@@ -4595,9 +4626,6 @@ xfs_bmapi_convert_delalloc(
 	if (error)
 		goto out_finish;
 
-	error = -ENOSPC;
-	if (WARN_ON_ONCE(bma.blkno == NULLFSBLOCK))
-		goto out_finish;
 	error = -EFSCORRUPTED;
 	if (WARN_ON_ONCE(!xfs_valid_startblock(ip, bma.got.br_startblock)))
 		goto out_finish;
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 282c7cf032f4..12e3cca804b7 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -2158,8 +2158,8 @@ xfs_da_grow_inode_int(
 	struct xfs_inode	*dp = args->dp;
 	int			w = args->whichfork;
 	xfs_rfsblock_t		nblks = dp->i_nblocks;
-	struct xfs_bmbt_irec	map, *mapp;
-	int			nmap, error, got, i, mapi;
+	struct xfs_bmbt_irec	map, *mapp = &map;
+	int			nmap, error, got, i, mapi = 1;
 
 	/*
 	 * Find a spot in the file space to put the new block.
@@ -2175,14 +2175,7 @@ xfs_da_grow_inode_int(
 	error = xfs_bmapi_write(tp, dp, *bno, count,
 			xfs_bmapi_aflag(w)|XFS_BMAPI_METADATA|XFS_BMAPI_CONTIG,
 			args->total, &map, &nmap);
-	if (error)
-		return error;
-
-	ASSERT(nmap <= 1);
-	if (nmap == 1) {
-		mapp = &map;
-		mapi = 1;
-	} else if (nmap == 0 && count > 1) {
+	if (error == -ENOSPC && count > 1) {
 		xfs_fileoff_t		b;
 		int			c;
 
@@ -2199,16 +2192,13 @@ xfs_da_grow_inode_int(
 					args->total, &mapp[mapi], &nmap);
 			if (error)
 				goto out_free_map;
-			if (nmap < 1)
-				break;
 			mapi += nmap;
 			b = mapp[mapi - 1].br_startoff +
 			    mapp[mapi - 1].br_blockcount;
 		}
-	} else {
-		mapi = 0;
-		mapp = NULL;
 	}
+	if (error)
+		goto out_free_map;
 
 	/*
 	 * Count the blocks we got, make sure it matches the total.
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index ad4aba5002c1..4a7d1a1b67a3 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -868,33 +868,32 @@ xfs_alloc_file_space(
 		if (error)
 			goto error;
 
-		error = xfs_bmapi_write(tp, ip, startoffset_fsb,
-				allocatesize_fsb, XFS_BMAPI_PREALLOC, 0, imapp,
-				&nimaps);
-		if (error)
-			goto error;
-
-		ip->i_diflags |= XFS_DIFLAG_PREALLOC;
-		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-
-		error = xfs_trans_commit(tp);
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		if (error)
-			break;
-
 		/*
 		 * If the allocator cannot find a single free extent large
 		 * enough to cover the start block of the requested range,
-		 * xfs_bmapi_write will return 0 but leave *nimaps set to 0.
+		 * xfs_bmapi_write will return -ENOSR.
 		 *
 		 * In that case we simply need to keep looping with the same
 		 * startoffset_fsb so that one of the following allocations
 		 * will eventually reach the requested range.
 		 */
-		if (nimaps) {
+		error = xfs_bmapi_write(tp, ip, startoffset_fsb,
+				allocatesize_fsb, XFS_BMAPI_PREALLOC, 0, imapp,
+				&nimaps);
+		if (error) {
+			if (error != -ENOSR)
+				goto error;
+			error = 0;
+		} else {
 			startoffset_fsb += imapp->br_blockcount;
 			allocatesize_fsb -= imapp->br_blockcount;
 		}
+
+		ip->i_diflags |= XFS_DIFLAG_PREALLOC;
+		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+
+		error = xfs_trans_commit(tp);
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	}
 
 	return error;
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index a013b87ab8d5..9b67f05d92a1 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -333,7 +333,6 @@ xfs_dquot_disk_alloc(
 		goto err_cancel;
 
 	ASSERT(map.br_blockcount == XFS_DQUOT_CLUSTER_SIZE_FSB);
-	ASSERT(nmaps == 1);
 	ASSERT((map.br_startblock != DELAYSTARTBLOCK) &&
 	       (map.br_startblock != HOLESTARTBLOCK));
 
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 055cdec2e9ad..6e5ace7c9bc9 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -317,14 +317,6 @@ xfs_iomap_write_direct(
 	if (error)
 		goto out_unlock;
 
-	/*
-	 * Copy any maps to caller's array and return any error.
-	 */
-	if (nimaps == 0) {
-		error = -ENOSPC;
-		goto out_unlock;
-	}
-
 	if (unlikely(!xfs_valid_startblock(ip, imap->br_startblock)))
 		error = xfs_alert_fsblock_zero(ip, imap);
 
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index e5b62dc28466..b8416762bb60 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -429,13 +429,6 @@ xfs_reflink_fill_cow_hole(
 	if (error)
 		return error;
 
-	/*
-	 * Allocation succeeded but the requested range was not even partially
-	 * satisfied?  Bail out!
-	 */
-	if (nimaps == 0)
-		return -ENOSPC;
-
 convert:
 	return xfs_reflink_convert_unwritten(ip, imap, cmap, convert_now);
 
@@ -498,13 +491,6 @@ xfs_reflink_fill_delalloc(
 		error = xfs_trans_commit(tp);
 		if (error)
 			return error;
-
-		/*
-		 * Allocation succeeded but the requested range was not even
-		 * partially satisfied?  Bail out!
-		 */
-		if (nimaps == 0)
-			return -ENOSPC;
 	} while (cmap->br_startoff + cmap->br_blockcount <= imap->br_startoff);
 
 	return xfs_reflink_convert_unwritten(ip, imap, cmap, convert_now);
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 4bec890d93d2..608db1ab88a4 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -840,8 +840,6 @@ xfs_growfs_rt_alloc(
 		nmap = 1;
 		error = xfs_bmapi_write(tp, ip, oblocks, nblocks - oblocks,
 					XFS_BMAPI_METADATA, 0, &map, &nmap);
-		if (!error && nmap < 1)
-			error = -ENOSPC;
 		if (error)
 			goto out_trans_cancel;
 		/*
-- 
2.39.3

