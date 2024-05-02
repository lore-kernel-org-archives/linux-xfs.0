Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9676E57301
	for <linux-xfs@vger.kernel.org>; Thu,  2 May 2024 10:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714644562; cv=fail; b=FL78wmHJi0OjWKnJWOgyYDsWQD56aKDy5TeAfK23cML/PjGY78JUAREhiG3wbn/QEHPZkH/s6qHTEqLN6cAYt7NQ3TgTxfMrB3e6kkbNIv9LFh+1yCliBGyPkF/1h5b8FZSujTydgPe5CVZOSQTQ2AUFXddwc0/tzoi/OHNObJU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714644562; c=relaxed/simple;
	bh=Un+7lO7z/YnjDATPScNMaiA5lGXGe9Ryj0WfC901gcE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ROxjwU1kTxr4IOjNir2JamejVFCYvpchhYrabseyXK4+ECcsJ8PSwfrBnVU2ezlBz6G54fzNutpzNSDhgEGxQPSRgr7z5zMZvx7G5DtMd/kSeKCUrClc15NJP9CojG5uCZ1Y+w0rNoGV82vmcql4dbmSyZJ9a4iqdq9qDGaPIhQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kclacQPo; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=unoZU8pH; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kclacQPo";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="unoZU8pH"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44283wMq026428;
	Thu, 2 May 2024 10:09:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=4dqs9aGjC4pllo5h+FMxJdIbw+ikMU+042jgZ8VGVNI=;
 b=kclacQPo4JAb2PNACP5tRwQ0ttV4Kvq+JP2PupB9ernbLbyo654/TEvpMC7tP2uF4arC
 6SjhArNclf/J1zDi1ufsBvcTjchjdjJ+/fnq6+wLSvtigTfzqEAt4J1a2zhY2IS8BeHW
 UDllx54nZkyO6wKj3zrDzp7wI1nTXDJMjOJ+dcU3IQ+TkJd9rFO5ebYqAaWkRmsJb7al
 sjTld0bynqduOr+VDwxYSG0OJS7s+KEE1UmIlPy8gp5YS/T5kzyfiArkEyd/DMaxnOuu
 CEDXjpGUMan6yNuR0w1M9xnqhAb/FyQJ1Igkw8R+RtmeiQzB2iMcB5N8/d0Km4/tlBH8 Ew== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xrqsf57wk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 May 2024 10:09:14 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4428oEER020063;
	Thu, 2 May 2024 10:09:04 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xrqta6s6a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 May 2024 10:09:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dzeBg1ymidbxw8c2+CaQRaDW7HDkZRcxzygzcaSweGZNgBuYLVUEhD9QmIP7I0X6kK3acSvBmP69LgAIupnJkow0v8mDjrTqR69dhsWfGx5NLMzWTPmehQ9mxxtETvNd4adQydBH1j4ds/aWi6PFVvboOlBcb6StcCuMnuH3EMk7E0zzPv3wZ1EbsfvkP4S830rcD7pvEyDDOziR9JEeAjY8U49iyooTe5mMkmjtFnSipUp6C6DDJP9Noh0bvrX29tZtsR9K1oWAXlC/LanrbZWuEeQltiRaj8hFK8HlxqSJt6fjYCxcnSopmmC3kmxTDr02XgCvreidb5ln5rHc0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4dqs9aGjC4pllo5h+FMxJdIbw+ikMU+042jgZ8VGVNI=;
 b=dQZCtdiu/EfBA89Q46OiYMRLAbbdjCHeCXd0kXtPsJWIWUOhwGwkT7TM70Lt6OWKicHABrqQCZfzh5tQZfAhJoQF3BCevUySltaDH/vxYl4NhbJEmiZeE9VR+qk7YauyUjTFKYK8a+zR5IkplESS09sfms41lA7oi4cCUqM6ANiFue9xfDduN6WvTpkeja+Qc0SjfNSYzaQ+iL6g/CfrtHJqxI61GfaaCMQUiVdradycAcOc3TvJfaiZ7X5Ji6N07AFfFcX2fygAJaBsjvkHO4D10w4RIG2lj2QoDJwanxmVcsuZv90usY3kjyx0OmMRmY2pUy9wOgiaNTvjjU0mbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4dqs9aGjC4pllo5h+FMxJdIbw+ikMU+042jgZ8VGVNI=;
 b=unoZU8pHtIMEghG4JIznFwrmcoxkIifFRl/TmbkiJCXyuQ8Nh3brTT5xfrFim9FKCV4BY9s4aftxWRNkyKWm28G5mJQr4L0C/U4uR4dedDe+TQxStoWjdXpD/ORDxczKtCHapxfPhXTpZFydmQnHkV0w3r2bWfWLB+ZJLKDDcws=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by MW5PR10MB5737.namprd10.prod.outlook.com (2603:10b6:303:190::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.40; Thu, 2 May
 2024 10:09:01 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.7544.029; Thu, 2 May 2024
 10:09:01 +0000
From: John Garry <john.g.garry@oracle.com>
To: chandan.babu@oracle.com, dchinner@redhat.com, djwong@kernel.org,
        hch@lst.de
Cc: linux-xfs@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 1/2] xfs: Clear W=1 warning in xfs_iwalk_run_callbacks()
Date: Thu,  2 May 2024 10:08:25 +0000
Message-Id: <20240502100826.3033916-2-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240502100826.3033916-1-john.g.garry@oracle.com>
References: <20240502100826.3033916-1-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P265CA0124.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9f::16) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|MW5PR10MB5737:EE_
X-MS-Office365-Filtering-Correlation-Id: f6bc4fc4-5b8c-49d6-e738-08dc6a8fe362
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?TEUxb0tuUkdCZCtPa0QwWmFiVE1pdENmL2x4TWFDTXIvR3l3TjhaYjN2amRq?=
 =?utf-8?B?ZDdYcms5YWJiNlk1b0hFZ0pVdWpPSkdPL0M3OSs3SjlmVmRFLzllTWYzRk5v?=
 =?utf-8?B?b3N0TzBoNkJEa0JXOHdSQjIyWWN2VkdUMnBOQ3FVUUdCLzhpb2w3dmMwWTBu?=
 =?utf-8?B?aEgzQjhFQk44Y2svMytOT1ZOTlJNMDRaUndUUVRDZVJqU3NaUDBZYnpaV0po?=
 =?utf-8?B?dmgyaXE0R20vblpwYjdNLzRsY09UcUR5V3plYjRwYjhrTTExWnlTSGlQZVdT?=
 =?utf-8?B?YVd4VFhvNHZWSDlWRi8rQXQ3c2xyYmQyd2ZJcCtHODdIczFjQlFGdEY2ODVQ?=
 =?utf-8?B?QjFxQWdIRkZkOVNEb0lMZG9YVnBUWDRSMjhPdHg1aXBIUFBCRmt5RGw1MVA3?=
 =?utf-8?B?S1J1ZkVaYzVmek4zYXdseUc5MTV2ZFQrd3d5SEI2c1UzVlRIU0FGVldzWFJR?=
 =?utf-8?B?ZG5wUVI1K1FhTVYrVDRUKzhydzJkaGl4SUdjQ0NFSkFnYmp3ZVBZNEdZek5i?=
 =?utf-8?B?aUhFakxESDd6eUxlaGlIOFMzUHNJcFlBYVgxbEo1L1U4Y3VPR2tjVWRoakhH?=
 =?utf-8?B?SjRxU1hacHFXNlpEMHdSbFduVnE5VEE4K3NwRC9zQjdJbnJ4TlhueE5ZVENa?=
 =?utf-8?B?US9VQlJra1ZvQ3VycUEzQkJrbkRDV2dBOUxiMDZ2bWhYK29lQ2JXNC82bCtX?=
 =?utf-8?B?eXF5bnZqdFhxYjh3N2JQbyt6VWxtUXl0cnc0Y1RQeTUvbnpKT2FTckxrYVIv?=
 =?utf-8?B?dXhIc1VmYUVnWWlsYW1STUNlSlJXK2cwVlJNWmEzQlVtMktaQmg5ZGZuL1Zt?=
 =?utf-8?B?V1FIRkh0WnBzUFR4cFkybmtPbFlObXYwMzBTUGhmQVVxbzdUUEFPNFVWbUJ6?=
 =?utf-8?B?Y25yZXNoMWQwMkNkVWtjSnQyQXduUGwxV1NtcGY0S3p3WDZXZVEranpLSmxY?=
 =?utf-8?B?aldhNCsrL2M3bXBweG5RWjNYeERzanc1bmhoK2k2S0hJQWd6Yjgwc3lOampS?=
 =?utf-8?B?aVg2aFFXaFhWNWFUcFhybGE5WXI2OFdnVm5iRWE1V0RCTWcydTFGMzBRVi92?=
 =?utf-8?B?OGpGL0xleHM2Vk0ramc4OFZHQ1lCY0drZWprdno0UDQ5cnRFNUNhdCtIL09z?=
 =?utf-8?B?ZDg1cmREUjJFQ1ZXWnppU0E5NmZvekhjZXV1dVpzVTZadVp2MTlaTkdjWmpm?=
 =?utf-8?B?aTByTGFsYVZ3Q2NHeG14RXJ1WWFkdWY0aDBKaUt5dWdPTElBUzIwTm9nWDFI?=
 =?utf-8?B?bG5CWXZVQjhmS05OYXhKTTJnalBKVlJ3YU1PcmcwcW5NN0I2ZzNVS05veHFH?=
 =?utf-8?B?NExSaWZCNjUzWUlXYXRQZC9ZREJubmZyT2N2WGcvMEQ0encwVkl0YjJyV2JM?=
 =?utf-8?B?MU5zVzVNK2hzaDkyMXEwYWFCNXk3M01odDVYRVBXdHNUMGhEV1JldXJLb1Bl?=
 =?utf-8?B?cEttbGQ3MlJnMHEzVWtoOFBjd2JpcHQvT2JCaHZVUWpYUTd4a0tvUzB6dkNX?=
 =?utf-8?B?Z3FXclg3MStySW9SZ0xMOUU3SXV4VXdQSXl4K2JOUjFrdEFMQ3Fvd2xQcHJE?=
 =?utf-8?B?SnFVamNyZ3hkeGV4S3dzTDRCU0N3bWMvOUt2QjI5d2ZINjhSSjFzaWRYK1lM?=
 =?utf-8?B?OWlzNEFVRFlUUXg1OFB6SnA4ZGJaSjMyaFJjR2xGNkl6b0t3WENlZVIwTDVn?=
 =?utf-8?B?b0RncjNCdE9JejE5ZElxUW5WTWhjZldPcWRMMXNuZzlRK3lkNldQR05RPT0=?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?eHR0NlpaOWRWUzJqTzhaV1h2NjZualFHRDE2Nnl3M1BUQUlzNXEwdXdiSXQv?=
 =?utf-8?B?ZFNYYlVIUTFVVitvSkM0OXlNREprVDRFUGJQczA4cXNiL0VWNDBjd3dkallO?=
 =?utf-8?B?Vk16c1BaSEtSeWcreE5zT25Fa3d4V0ZCalNVSDRFVkNDaFpZWGd0ZUE1eDZO?=
 =?utf-8?B?VkxHOHZzZlJDKzZHeDJoeEg4S3lVL2VXbnRFeEYybHNqSUhUaVFMR3dsZUQ3?=
 =?utf-8?B?Y0xJNmJyeFN4N25XRHRJOVVCQWNiQVZJRVZrNEcxM3ZzOUt2UmVHeFAxdERl?=
 =?utf-8?B?ZnZ2cDUwQ3lhdW4xQzh4MFQxNGRLWkM5SGYySWRZMjBad284YXhPRXh1cFRt?=
 =?utf-8?B?b2RiV3dydXdPSCtFOGVCTEd2enB4UEo0cm9RS3JEbmFXYjlHUVhKQTY5dWpG?=
 =?utf-8?B?R3hrdmg2NkNQb0phZC85ZmdOTFlPcHJ3bThNY3FWazhUTU1vTFZxSFJ1cDVN?=
 =?utf-8?B?YWVaWVE4TWNqR2NyK1o5VXowM1VCNWh4bTFQT0tnZzV1NndsK2RWbGV4NnFY?=
 =?utf-8?B?b082WXlJcDFqQUZTL3ZRWjhVMEpkRWUxTDhzU1RKZUdReDZRNWlpamFZengr?=
 =?utf-8?B?VUkvanpxL21nZzRVQ0F0WFRaS213Nk4vKzFjMHFlZTQ3L1VBcTZ1eERrUEov?=
 =?utf-8?B?eGhWMnZnL2FnejVCYXQ5eWpXMmtrbmw2RnpRWTZkd0FtWVJSNGZyc0xZYlNY?=
 =?utf-8?B?US9oYnEvRllydi9DRENvcjd0K0xZNkRkczVyT2FYUE1sZnZpUWxaZG9xandS?=
 =?utf-8?B?R2NRcFBadkptMHZjVndoSDUrSklVNmd5V0tHR3lnMjE3QStmMHprSzhMdmZO?=
 =?utf-8?B?SXZnQURXbnkwV0ZuRVhBVEovakxiY1V3OEgvOHg1WExiZlZGYVMybHMyREQ3?=
 =?utf-8?B?TkdGS1V1ZStMQWdMb1M0em5oZG90a21zVlc2cFhnUEt6TVdFVVpWcm96ZlJs?=
 =?utf-8?B?OS9MQ0lEVDQzWGRmTFZPdXlPU3puSHhtZ2tVSGlGOXVOd1RCd1EwZTRKVk51?=
 =?utf-8?B?UDdCN0hhTzlOQUNQQmp6eUtmRkN6cktlZWJlL2ppVkNlMVpDYWJIeFY0bDN0?=
 =?utf-8?B?RXhQK3doNUlZUzZYS20wbmZXb2Zsa3dGZEsxdGdrMkV5TnVPMEk3VWt1ZFZL?=
 =?utf-8?B?Y0hkL3RjMi8xUzh4cnM4MjlKeE5aN3BtUGdmb1ZzU0RlNk5tb25KZWY4TDhK?=
 =?utf-8?B?bkM2eTZ5UTR2TzFVQlF5Ymw5V09PREhra3hCd2tCNVVRVHcrd2ovQWV0S0hv?=
 =?utf-8?B?aWUrMmRwZFlxQU1UUFdqQXFzbmRMdG5oYStuQ0VRZm9mZmhNbVM5U1hkNFNQ?=
 =?utf-8?B?WTJqemlPZlk5ZUpKNlRSbDRiNytoOFV3K0JsaEdoclpjeWxTSU0wSmJjVitS?=
 =?utf-8?B?V0hPL1RhNDlHcjR2LzBadUhhMkRqNmRrempsS2tYU1NkbHgvSmNSU3YzbHoy?=
 =?utf-8?B?SGM3Z09LZ1hZSlNxZzBGNi81czFORko3MktqUFdtTlZxSFhUZG0xR1BRRHBE?=
 =?utf-8?B?SGRvMXpFUHY2VzdLQStZQTJvS0tUakpvLzJobFhuWE14RThCbU5PNDZERkhw?=
 =?utf-8?B?bGZpck5kVCsvTXJERXplQThZWFNiNXVYdUIrZmVreTU0dCt4ejNIY05iOEdK?=
 =?utf-8?B?VzV1TzM4N0RyZ2xVeHBiRGh0RXAvNnZCcHcra2lLWkMrcVExU1B5T1Q0c3Q1?=
 =?utf-8?B?WUZVVmt5ZDVWTkxMQi9COS9oVmNGdFZETVJ2SnIydnJTWFhFVjh2Ymc1eXpy?=
 =?utf-8?B?Vkc5Z1ppeEh1RWY0NzFYak1aOVovSDRrRTVrSkN1azJhM2hZLzJWZXlwOEpZ?=
 =?utf-8?B?ay9WYUpPUlhFdlZQYzBTVUpFRGU3M3B5TTc5UjdBMDZTM2FUVENLM2hFNHNZ?=
 =?utf-8?B?QjZDSE5mM1psUnc1S2pkdkRjdmtpWGg4MFBPMlFMQmcwVmYya0lwanZoMjNl?=
 =?utf-8?B?YlUyK1prTEJpUERvYnk5ZjNUeTlXUXgzNlBmaE1kL1huMGI1Si9oMTVLblgx?=
 =?utf-8?B?OTJtWjNzRm00cmV5RzNSaGtxL0x4bzRWbHJoaUtreXMrSHJjb29hR3B5MDdv?=
 =?utf-8?B?dENpanJ2Z0RJRnlhanNMUyt2Z1h1eGtJY2VnSVk5Ym9WdktJTnc4MFM0dHM1?=
 =?utf-8?B?ZEtwV0ZETU52Vy9BcTFZc1ZiMURlRUVXVnk5cGJHRVFxV2RXK0JuOFhnMTVV?=
 =?utf-8?B?Znc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	zQDoJDkx1kby9fs3f+TZlTjEcAmPO+jUVy8R6GzRixiJv1Kay49fvF6ophY+O583euRao6gQuGU38tf04OrDEQXXXMloOvjoD6GsbmRYfbI+x41p767KwMJgpR5k+dAzzGfncQqaLU7TzRncl5VZBBt23IgfsMqp0mHt8v8yvDYfug+t2LyLxBPv22ze3/F9uiXqUn92TkDyrx2BDaVYu+gufzDt1ALnnji7d70Yxt9yRzHKZKsJhdrLOl+5OtmQ1xFmaQdICY1DC69cDVcnvvsWWwxyfHnUd0DuqP9Konxz3ExBuxpGw6pSS4Bc4pfz2ceUbVjQxbPDzKdHUzih6LmD8B7es5QZRMxhVYID3VQwtg9GvN0HKVZ6jAutILWImPs9Je9YgTD2+dCqOwTC+IJ1zOIn2Olj3Hswwv32gqp94OdZ9BLsxw4cK4DX7vG0VNLtxfQ8wZ+gyTE9OByNMc82UCUB3VH5rcOKjpPlknAILTe4sqiaa8ZlteDgExNDMZ5KMAKsWyxkfnOrR9Yf1cvHsROrSGFKfM5W06lo4vNnZymJqa5H59oXP9e0Cyc3HMfC351j/TdX7ookzejvVFY5AFWnk3UvjKDicnoLKMo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6bc4fc4-5b8c-49d6-e738-08dc6a8fe362
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2024 10:09:00.9359
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L88C68UDPmS4F/psMbLovVmqIyUEbetewNzmW/Xsl8aBJmqgCP1eS8Ft+LwWZC7ScXB8FClCqGYiDbLAxFdtIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5737
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-01_16,2024-05-02_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 adultscore=0
 phishscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2405020063
X-Proofpoint-ORIG-GUID: 93fD0k5H1js0OiDUWxr6fSgWR__xJ_ty
X-Proofpoint-GUID: 93fD0k5H1js0OiDUWxr6fSgWR__xJ_ty

For CONFIG_XFS_DEBUG unset, xfs_iwalk_run_callbacks() generates the
following warning for when building with W=1:

fs/xfs/xfs_iwalk.c: In function ‘xfs_iwalk_run_callbacks’:
fs/xfs/xfs_iwalk.c:354:42: error: variable ‘irec’ set but not used [-Werror=unused-but-set-variable]
  354 |         struct xfs_inobt_rec_incore     *irec;
      |                                          ^~~~
cc1: all warnings being treated as errors

Drop @irec, as it is only an intermediate variable.

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 fs/xfs/xfs_iwalk.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index 730c8d48da28..86f14ec7c31f 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -351,7 +351,6 @@ xfs_iwalk_run_callbacks(
 	int				*has_more)
 {
 	struct xfs_mount		*mp = iwag->mp;
-	struct xfs_inobt_rec_incore	*irec;
 	xfs_agino_t			next_agino;
 	int				error;
 
@@ -361,8 +360,8 @@ xfs_iwalk_run_callbacks(
 
 	/* Delete cursor but remember the last record we cached... */
 	xfs_iwalk_del_inobt(iwag->tp, curpp, agi_bpp, 0);
-	irec = &iwag->recs[iwag->nr_recs - 1];
-	ASSERT(next_agino >= irec->ir_startino + XFS_INODES_PER_CHUNK);
+	ASSERT(next_agino >= iwag->recs[iwag->nr_recs - 1].ir_startino +
+			XFS_INODES_PER_CHUNK);
 
 	if (iwag->drop_trans) {
 		xfs_trans_cancel(iwag->tp);
-- 
2.31.1

