Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AF7117BCD
	for <linux-xfs@vger.kernel.org>; Wed,  8 May 2024 06:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715150388; cv=fail; b=Nu5D9HNibJfVUy0Phm9zqrvcQSdNnj6DB8GYw5psyJjUJBWSV8ur3vKaGG1Ilu+i+w/XpVrjftyFMHHfHgGFJgF2Z9wS5+WQcrGJrQOCZBZRW1RRULRw23NYDPh5uxNiqlRpG0MfmKV00AZYSkGLP4Qkv9iKAvacLqQJ+5ihobw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715150388; c=relaxed/simple;
	bh=wEJWDqBF7HyA1iooqOmdp0Rpv+fmr9lws4Aq3vODDTI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bQajwwEgtpI70OjteZTjbUW3dSmwGqn7ZSkF5og3yXdgp3QX50DE2UhUF44yn9UNprsxiQu34ehqDZ5X2qj/YpIU9pd5McZPUdAjQlI1Imm3aiFGbWAfAeAXhmzAmLa+VWl4NkEAzx2XnvWUsbQHGzjDR1DCgojAhQ9O3nmSEIY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TlbQ7v7/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=vNNzTo/X; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TlbQ7v7/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="vNNzTo/X"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4486O2Xg020073;
	Wed, 8 May 2024 06:39:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=vB9eSdw8GnF6LZbNgDqmYYA1SXA7K7SkbXTkTfVQdMo=;
 b=TlbQ7v7/HfTkh6rKITxr4mYE/bGYZBo8dz2t814/Ywpqu7W8sOEPf3kPOwpBjYNrMbVR
 f4L71kbpFB3KwQni4RFXxT1+jcck6nWMWPA9tBwk72EviqJZupaBerS6aHNz+Q9xUt0T
 3lKO19qELB7+4eqwJtqUvqJO826slNTcmaW7/a08C/GdEjLlxdNYPprfYFeWzbMpPnFZ
 ZEp4WXQXIiUf20ElzLdfn4JJ2g+BU8yeHynkgdq2xVcS4M+zMGv2kLW9HjanAvckZ7Wr
 rN6Mpo2JaY48rfiKAvwUY9WGWgx37v4m++Ok6paq18ha8AxdcyuGcqoSTVxWYNVMUU63 1w== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xysg2gxwr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 08 May 2024 06:39:35 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 448443X8035402;
	Wed, 8 May 2024 06:39:34 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2173.outbound.protection.outlook.com [104.47.58.173])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xysfnvrec-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 08 May 2024 06:39:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QBn1rwRv+WSYX8UZoWG8q7A/x+86eMsExU+3L5tastrCWuPXBm8QWatEYP6X3omLxxD9cX3rgaQ90DGGVIemKtc/huibarOQwC6sF7zillp8T/rTumjQm7RsocwapV3WLES6/851Mig5S3VwaULQ3eZO5KnMIjTkarAN62jjpGkD3bJb3hT+LW/jincaeMoViXd584qLgfhKAorOoQ0vpDFzv7YXTizjLA0n+SUpqygqhQZ44IDqZWHCUI8jWMHceURVOs5ahYaIMd281vOhDLZ9ZoVVh5pLd89sZolcKRTj/jo9q8drB+d9pDGCSP22qljAiaKX/3X7orl1dbAgkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vB9eSdw8GnF6LZbNgDqmYYA1SXA7K7SkbXTkTfVQdMo=;
 b=CtKp5TtQH7rjhvhfpsPlrysOHWSPgiTo3QazzOug08I8FLkkCWk2noBII7xFDALT8OONGrwigxNGafvF1jgLLEbFwFxdCU+i2PZCHIwiH9JCkhR15eQ5U6XOdosIm1MWZLk55mDzZxQ/NJj++8HiqhkKEnbHYthnA3Bw012R5VRnbXNA5ZqNki0S5SGMt+ZMrz5KPooXxt4KVrb7m5S3O3BRHuYOo8MSSg45S8hNWxpVybAB4FG60uZv0r2Weo6AVxSyofY1i5o5wElOim/5N3r9xjRwlasFVmDavr2hKz1KAXFTWNzoxODBEFkGBm4eSB2eFfkLTUD839lTeZp19A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vB9eSdw8GnF6LZbNgDqmYYA1SXA7K7SkbXTkTfVQdMo=;
 b=vNNzTo/XKJURkdjzFj0HgPJzPeVOZSwIHR2oI0NzSBgVlpOPLsSj8IsTe99i4tfpGu12flq4HTC660yF6y5dNGfvy8yyEP6FDNAFSbzoz8AJEiFku+FZjf99o76JIuhEjYHcR6R3RFo1kFvqRQAKB/1D+pi6ERLkFRPBUhBDvBc=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by MN2PR10MB4157.namprd10.prod.outlook.com (2603:10b6:208:1dc::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.43; Wed, 8 May
 2024 06:39:32 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.7544.041; Wed, 8 May 2024
 06:39:32 +0000
Message-ID: <a732f65a-38c6-470b-b383-8de66ff8c278@oracle.com>
Date: Wed, 8 May 2024 07:39:27 +0100
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
X-ClientProxiedBy: DB8PR06CA0033.eurprd06.prod.outlook.com
 (2603:10a6:10:100::46) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|MN2PR10MB4157:EE_
X-MS-Office365-Filtering-Correlation-Id: d386caf0-695b-4ab8-de42-08dc6f299e83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?N1NndE83bTZtTVNPbjJNeXhITThmZStOZzErWFE5ZUJvOGVXc2poNUhmbGg1?=
 =?utf-8?B?SVdZcEozUFVwWlBpVE1DR2s1ZkJiUEZacHh2RnJjTm0wb1JUeC9pVU5RamdC?=
 =?utf-8?B?RHo1MThQMERnMGRvQmlVOUF6ZXovRlY3eDV1YXZmcExFUWh5ZzZBWGtGU01N?=
 =?utf-8?B?TDU5MS9tcllSRFZ3ZWpkTlhkQzdoOHB6dFUrUUwxb01KSEx4MTh0SlB1UjlN?=
 =?utf-8?B?WitxQnVGcGVHM01GcmFyZ2QrYkg2eitjL1IrRHQ4eVMzNGtObnkzaWxsVm04?=
 =?utf-8?B?WHA0ZzhSSkQyMnpMNEIzQmtKajdFcU5lSllkK3Rub3d3WWRSRGVwWElZbHcy?=
 =?utf-8?B?ZlREUHlkZ21jVXVTdG1Na2lMRjNHc25lbEwxTTdZeisvWHJjYTFDS0ZuWEhs?=
 =?utf-8?B?YWJJcFl6cXVzbFVkZFpWL3JXTGhNTTVVVXEveU9XdU9mRWVrbEtFcXpFdU9T?=
 =?utf-8?B?NUNWampsYWdPZVZ6WDZXcGJSYmM2dXdNVkJmTEtGcmVTcUh5NnArY2ZxV041?=
 =?utf-8?B?NW1zYitFa0ZkMW0vUEc0cWJFWEZDTmxPRDhUenkxaHFMaUxRdnZlRGNmY1c2?=
 =?utf-8?B?a3NPc2hvUFd3RW4rM3JRVkxCOGhRZ3RJNGpZL3hWc0lFcHo5Y2FSMFRPL25t?=
 =?utf-8?B?S1dpYXZtV2dNcHljZ3VEYjFESnRER09Wb3lBWjl3UERPcDJ5RW42QndhMTY5?=
 =?utf-8?B?RDVYUmpyMnAwVmUvWTNmTGJuc1dNN2k3dVRkK3Z5c1pjd2dkbnFZYnlWYnJ6?=
 =?utf-8?B?dGQ5UVlPbStBdXQ2aWxNQ1U5MDJpUko2d3NFTi9UU0hOb3ZBN3ZZRWRyMkEz?=
 =?utf-8?B?eVhzQTA5NFM2VEpOZFlIME94TTdEaHlsWndKSnN4cUpEajhIUm5YQUJteWMw?=
 =?utf-8?B?d3NkcVZZbXFSc2tFNUR6aFB6NFFmbFBwbkEvYnU0RE54eUlOWVcwa2Y3eEFB?=
 =?utf-8?B?RllFR2pOMUFTUzg4Wlg4bXBxeHdCN1RLWDlBVnUxbjQ0Ny9jQXpMZEF5K3RL?=
 =?utf-8?B?eWRXMDBTRDRTd08yRVlqSms1amN0eURKS20xS0wreTdpakhvZG9SZTViR2k0?=
 =?utf-8?B?cEZaNXhpZGEzVy9WUHFoMC8vNVpySUhzdlBUYlJKeXRaTG5xazZDazFvODhO?=
 =?utf-8?B?WWo2eDFmcEV0eFBPTnk1UGI3UDZkQWJtdHFtYmZWeHdMM1BQVE5YTjd6VkZq?=
 =?utf-8?B?WGJwTTByM3kzSkZGbm8wNjNpaHI5ZG5TczJBYkFaWGNZWkp3S3ZGOWZiaDRY?=
 =?utf-8?B?TWF5ZTRPZHU0S0xWbDA3Mk9MLytBdm91L3NVRytBMXE2MVdXekhYbC9FaGxG?=
 =?utf-8?B?OWxLMER3YXJ3NmNRQ3dSTTczTzBHQmtsbS9seVBTazFYUDhDMkpkMkhJK0ho?=
 =?utf-8?B?UVM1c1FOcWQrTkhVOVpVdFJ6cG9yL0s0R0JtdnRhOWlXd29yNitQdlcxMytI?=
 =?utf-8?B?dHg3RGtQMitkby9GVXYzYnhOZytXZ2hDUmEyOXYvRzhHMmY4aUhiRjJ4UkFQ?=
 =?utf-8?B?OTFKZ1k4L0RNajk1Zmt2NUdGVHd6RDFjY0hRajNIQlpsUTlRRjVrd3kyWUZZ?=
 =?utf-8?B?YWdxK0NIZ2lsbmJGNnhscWtyYStPb0xPSE9YV3Y5NSt6SVlISnFKYXZwTTFC?=
 =?utf-8?B?djJFKzR6RXg1OTMrQ1RoV2lqRzQ3NFBpVUUxOWFyQU0zMC91Nys1SDd0N2M0?=
 =?utf-8?B?Vmx3cm9oMU5rVXo1UEhpNXZoZ2puQWxmR2Zrb2VWWEF5YWhaZ0l0Q2VnPT0=?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?REV0dThvRS9sNkNEeEtIMUcwcDBuamZteVFMNXY1NE5aNUJIMzU4MG1lQU9R?=
 =?utf-8?B?WFNUYnJyRno5T1pIM1U3a0VwZ1VWeWQvcGxkWlVxdnl2cmtUU05mTTliZjB0?=
 =?utf-8?B?L3EvQlJyb0xLODREZHExSlFnQVdRKzRCNEJ4NzJ4VVg5NFB3ODJ4NlFHOFNF?=
 =?utf-8?B?RUd2cVBzTU1QSmJUSHYyZVEzbnJydE5mZDhOWWNsV1p3dDJSQjg3U1pYV1hD?=
 =?utf-8?B?b3JpY1ptZmpnYTBqN2FDSDk0d2paNERjREYzMm1wWlRvazgySWhjdHhLWHhs?=
 =?utf-8?B?d0U3VkIwUWxUcWo4and0UXhJaGttRGlZZlV3YkhTN1Z3cU1NSXhkdFdzL1JP?=
 =?utf-8?B?azlldUpDa2dydXlYa293QTVFTGt1a29jaFFQSm9iSGNhZDBMcWRxOFVsdmMw?=
 =?utf-8?B?Vmc0ZlJJQ2NNU1hISUxlcWxoTEVKVmFpdkZLdld6YVdQOG56aFZ2RnJxcGZi?=
 =?utf-8?B?QnNDL3FMOE5WUmxsTER3aFB0dWhsNkQyRWNIejRQK09GcnVONVhBSzNyMHA5?=
 =?utf-8?B?U0luRUFNN3RKMnNZNElRSGMzeWg0YTRqZ29uQnU4SUNUc05UcVAzaDZkZjl5?=
 =?utf-8?B?SFZDV2t6cUQ4RUZKZ1pSbVA5RTk4aDFnSVRGem1MbjNBUnRUS2J1SFd1UHJu?=
 =?utf-8?B?T0RaUlJXK2FwN2hmR3lLbEVLWlU5eUc5d0YwQ0tYa1F5U1A2K2hjOGhicm10?=
 =?utf-8?B?ckZwWVdiYUNZa01kb3VoVytTV2pWcThtOVRBWmUyZXFVUFQ4VjJpYTNPbVpa?=
 =?utf-8?B?WDlzbWVnMG9vWG56T0NmVlROTGJ4T1RQMmZnZUdhNGw4QTFpVURCZmIwNWN4?=
 =?utf-8?B?TURlU1gwalBwZWRvNVJ1aVdIcDFlOVFoY0VERHU1dDhaQVlpUHVxV0dkSi9V?=
 =?utf-8?B?SWZWN1VTZE94N0FKaTlSeGVic2FZc1hhSlZsbjFLU08ybVFpZkVrK0hlOEow?=
 =?utf-8?B?Wk4zVU5HKzhSOGMzRDIxQVBzRURlWDFoOGsraWwyUk5ZY1U3RXg1bVZaN1l0?=
 =?utf-8?B?c3lUTkpoQTRkQ1RqdlBWQ2pzM2lGNkE0RlFmb2YzYW5DZ2UyNDVjb2xTOTVn?=
 =?utf-8?B?dHhlTjZ3YWNBVWgzM0Q1NWZUVkFSdFJhYm84YVZwTUk0OXpyeXdZMWt4Zk5j?=
 =?utf-8?B?cG1sMTJMZ3FhQzdKVkoxcDh2T0ozeFcyZ0RmNUl6ekVVSXJOS3NPM3AxcVFT?=
 =?utf-8?B?TFFFWWEvSmRWRld1WEsyTG1nTHJNWnpPZDlzYWlKVWIyVlJyYUpWUnNuMGx4?=
 =?utf-8?B?Ry8xZmk2NUFhQXNINU9KYzhpcHhScWVKZ1RhNUtWMWNiRzM2VllPMnh6cEw1?=
 =?utf-8?B?WlZYK2gzVjRVLzhueGs4KzZnUlRoanlGQTJwcGdRZ0ExQWpPaFFFV3RjUmhw?=
 =?utf-8?B?aEVBY1hvbG1PQTZvY3FUdHlBVHJjYXV0YWthQ2M4bnBseTZQNWcrWW85VmVD?=
 =?utf-8?B?Y3MwUEJ6ZHAvYjVJRDlvdUZ6RTlBNGx0N2VVREZPK3R2NFFMSm54Q1M4ZHBQ?=
 =?utf-8?B?WHR2QmxUSWduTExjYy9WcmhPVDFkT2d1TXpUQndkNjM2L1lyWEdqRnhhT1Iy?=
 =?utf-8?B?eUhkZFRadHZZRUxjYkFtT1o0MWRUWUtwd1FKc3dITzEvWTFMZjg4b09tb3pz?=
 =?utf-8?B?SnJSNlc0SkxtU2k5QWMzT1ZjMTAvVVJIVC94cjl3NUtuaHVtR1BjWlVKTlBT?=
 =?utf-8?B?bFNpUURKNGR0VGNSUUx4azJ2Q2ZRYW5ZSXV5VFVVNWFPc25ySk5lOGcrVUs5?=
 =?utf-8?B?MTNvTDI2NnMxaVdqdDBzUHBrd2U4TmhROGNjN2ZLRzFvbDRtenlxWjliYkJa?=
 =?utf-8?B?ME84bXl3QWgzVVdIeW1VSks1QU5SQkdpTE5LbFM1SGlRenhocVBIUGZjRWJX?=
 =?utf-8?B?L3krOG13OWN3TmFMcTIrbkZHb2k5T3dpVEU3WkJwY3VzWVRuNTAySUZKajBI?=
 =?utf-8?B?QnRWYjV0QVk4RmV1K3RjZXY4b1VQdlloYzc5R1ZUMEVFNmsvWDFxZ3RlR3Zt?=
 =?utf-8?B?b2piUEhpZTdHY3laLzltR2pQR3pLdnBoQmZFV2J0RFVaSGFIUkE3V0dha0xN?=
 =?utf-8?B?UXNBNEl5Q2xGRFJQMmc2UDMxSG5EQlVRRjFOa2ZRTXRLRzljZjhvWWxmeUhw?=
 =?utf-8?B?MmEzWUdUd2dHbjYzZG9ucit6TVc1SkdJU3d1S1JYM0ZKQ0FDcTlCd2dPYlln?=
 =?utf-8?B?aWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	76COyh/elLPyA9IsSdWoNLrAJkCYBfeYD6e0xOyOZdo9pk72IRi/Dr0LoS1/I/h8pniAo9IMzIEXlpjlZi/7jGvknKh8dlMu08RdKEYHLU2cQy9EJbl2coZhvWV9KaVo6VgR5DQZz2tHqh7q9f0/7Cgr0sPfHTRyXom323KK8XX8I1YbYY67PYmFu8BLdJlkbQEfdAVf6IsSG2obEt7L7CS6Gl0O0jHFUcHmiG/9OzqFUifxtp1RhgXS9+G5jCgvrjtRB4Fsoe7vNO3C+VIIl8o7MVssOvUOl8MpZdXlqNIvRcsGSxEOTZFcSyscKUxi5fpR9TtnfMP3keeh5tkt8+lp1HUWGUdCFkIO6EZMvzzzkN1Ab4wfZEcwQNhyZ/p5/soryQxwC0kB9ZhDuyYSZkCS9ZF4ZxpyusOfP9Kw6vZGqPIYlw62DUWDoAtC+Ki+JS45NyL+YRNQldG0pzIIWBUIvf77bkRaTDOsXpH0YjMxqk8NZIk43Z3C9sTlHaQxi5Nrr4tyAAwp6IQcpJrAHRHX6MYwkXL4xrAnT03Er00tLVmAAcUgKyNIefqvj3x0sliDmgNjkCPU9Kozy/IxDZ4qPRFXBVbfwo86sTwYXEc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d386caf0-695b-4ab8-de42-08dc6f299e83
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2024 06:39:32.6313
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V7HsSK6sv1edKCtHfaazE0y3ZG0iQebDuajdvTBYXyB3xKHmJBd7ZThqOA51ryScSh1xA1w3fcwLLm3eF/BB2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4157
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-08_02,2024-05-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405080048
X-Proofpoint-GUID: ydk_6CXv9-EpVB9OxFuf47S5lgbGZsh4
X-Proofpoint-ORIG-GUID: ydk_6CXv9-EpVB9OxFuf47S5lgbGZsh4

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

