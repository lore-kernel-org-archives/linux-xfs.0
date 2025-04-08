Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C28F1D54E9;
	Tue,  8 Apr 2025 16:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744129498; cv=fail; b=N0i+7/jrnelNmw6O3dgbsk6dXA5GZ9S1oU8tePsas+FXMtoP4wO82Z3EK58Ze/6Z/6teLyrMxZ+maBkMsmlbW8q8hspt3DnvQzPv37DYgoxSyaWy0Q90BRd1c7h9k3ICRMFigW/CdgErqNO/tsy1m3vexu/vmBA1ZcZHyRKeNxQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744129498; c=relaxed/simple;
	bh=Tvx1CBudR5TUf/RoXMVchJm8UWyyrNvEB78AF9MxJ2A=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bdunx5VZrcrdn5aIUbXiyPkReD7XTq7IP7WudilK4wMS5/ayc/dLJNeXIRpSB8p5/v4SO4V5y/H04XznEldG4fO5QzPSp4zSkdStO+oJ4bP4YVfTnOexGMFfqM3Hao5HQPbQXQHxIlxNmq6Mhw3+ZtSr8EYc1P3uLbQg22aTDMU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IvV/GKBo; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tWfrO94K; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IvV/GKBo";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tWfrO94K"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 538GBt1N009931;
	Tue, 8 Apr 2025 16:24:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=6Acu/qHz9hMkwO1FqhTFtEp8BTE+PU4YNydOYSdRr8A=; b=
	IvV/GKBoUJsJ/0aB97DkFFN/szRLMRxw4IXZlVrlCm6nRHG0Pev9XRhaJQnubdp6
	LKCWarjrJtxFCzWs4X8raFt75nojLhJfTvH7afXfKvLrFHhdWA2tw/8Ml+rLBSCx
	pD3tt2S08OjyH+qC46ViFY6HCNJoJofCekk7GyxWs/MoMTMRRlUmQc3xKqUiAvRC
	6vFR+afCbVXo8S7U/qubXe5dC1GBf61Q2uQzMKeYnYJehwUzjEvZY56seOYP/emx
	qveAPEDkXIph0VRZRbbgEMR2sbNUUsGow/YbfS6cup3J4S4z/MLT22aqYX9pl9fm
	4BWPPQYvjP1KX8k4AulL5g==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45tvd9w56t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 08 Apr 2025 16:24:55 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 538FJFF8013700;
	Tue, 8 Apr 2025 16:24:54 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazlp17012037.outbound.protection.outlook.com [40.93.1.37])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45ttyfu991-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 08 Apr 2025 16:24:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ij84SXCkhWeA1w/kl9D1LOILsUrYifGfSKzWC7tpXc1ia9iAVq+a5ZodzU+tNCOrOFJTT5adHXGQEpeTdi+cDvgjMyBC8OcCkISPTn0rR67jckMEC+f6sgwbP+EOSlTHhmLWvhCCuvPWbdojSRpw7f/H8K8jvSoQ2ujKplrgr/q7O3sPoxOtUoz3zJa8+tBxenA7QWRQD/PdNajyZZpVZoL4AKS44e6aQ5+B9BSg9QfqvXBOLaypGzHRc7V5ze/Jjdk7zONRUwQTtT4V4f8QC5MRfE99pPwi/8wStuQajsXOaIegJINTJ4r2Leu+vu/Xa+jtjrcKO8v1HsoWxK/jZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Acu/qHz9hMkwO1FqhTFtEp8BTE+PU4YNydOYSdRr8A=;
 b=HnJyipWaFcrY47/Zkq5riFmIaqzQe0tpwSOxPT563QyYzA2HQp7GNfqDERwst4SQIBAcDLWBikPbaq91RaYzXanBb16yOOdF0lk9VRJxTztFJVtEXDT1MaO8WX3NP+lVIRoHFohi8RbsMLZ79tqaet08dpq8Cs7ODidvjno7X5X7Hh5HWXLhPg3dmW8FcBwG/3qtO/Bp2pjwYbPTu1rihfbplHQr3TOojEy9KY6pVqPZb4Tl03Ap0u84bJ/rtAGU1BQw5bNavepAQpWtjtUYmmVnjYGM6bPAxJ585lywh3Np/OzXAkM2U2HFXnynZASTId/YV/6Z0K24r88YJ+Ihxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Acu/qHz9hMkwO1FqhTFtEp8BTE+PU4YNydOYSdRr8A=;
 b=tWfrO94Krp36sIryKBmT7To1PHY5UUQ8hNzQ3RBtN9DzulhmSc5ZfYc1eTSaWAeNQs1h4IoGgLGTRZMtJEa4DHidXBvy1wRGzzrp433oA9RffOKrMc2qJZIq0o34bvYTNuXBDCWP6+eBLnq8x5UtjPyaW1k96Fyc5mYWWdCckXo=
Received: from CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9)
 by DM4PR10MB6864.namprd10.prod.outlook.com (2603:10b6:8:103::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.34; Tue, 8 Apr
 2025 16:24:49 +0000
Received: from CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::fd5e:682a:f1ac:d0a2]) by CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::fd5e:682a:f1ac:d0a2%6]) with mapi id 15.20.8606.027; Tue, 8 Apr 2025
 16:24:49 +0000
Message-ID: <feaabfc0-1fe3-445a-8816-c72d52132ed2@oracle.com>
Date: Tue, 8 Apr 2025 17:24:44 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] generic: add a test for atomic writes
To: Catherine Hoang <catherine.hoang@oracle.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
References: <20250408075933.32541-1-catherine.hoang@oracle.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250408075933.32541-1-catherine.hoang@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P123CA0077.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:138::10) To CH2PR10MB4312.namprd10.prod.outlook.com
 (2603:10b6:610:7b::9)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR10MB4312:EE_|DM4PR10MB6864:EE_
X-MS-Office365-Filtering-Correlation-Id: 35be3270-5f46-4b7b-7d08-08dd76b9e256
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NFR3ZHdhMkV0TjhnNG1XcGhLYmJ5Kyt5UkdHTGx6Rnllb3NIUWxtZkZUblQz?=
 =?utf-8?B?OXlqcU1ZZ3IvczJBb0pqRmdZQWhtclJBWUU2eUlCRkNUTmJqYk96TjV3Rzlk?=
 =?utf-8?B?TTlCeXBhYzlEQkNWRDJTYjhHdDhQN1JvZVVrZEllL1NHQ0RvcG9rZnpqN0JG?=
 =?utf-8?B?NVpuUnhTeVFjbFArWm0rSkRFNm1OWXVmdlRuVDdrUmI2QWxycTN6cmdUS1Vw?=
 =?utf-8?B?RDNCTDZwNTgraDBVMzhVMGVDWlI5elVHNlVjRjNMMGI5YnV0QldjVWlZOURB?=
 =?utf-8?B?YWF6aDdSUnZ3L0ZhMDg3bVVWU3lTclNCcHRyb29sMEJWMDhHL1FmbTNQWnYv?=
 =?utf-8?B?QjNyRjZPSTZhZWlRNWxNOTBORzB4eDdyN25CRmhqcjBsSWlwTk9tbjJ5VHJI?=
 =?utf-8?B?SkVjNzRiV3hoRjBkMGlJbzE0dkJPK2VZTVRqcHk5ZG9LU2x2RlFnbGhrT1pr?=
 =?utf-8?B?cDREOGFiME9wd2tQUkhnaHZBK1BreVVlNnN5ZlZxN1NRdjZDay9vSjZtUGEr?=
 =?utf-8?B?T1hvSTlzcEwwNldacjJxV3ZqdmxiQWNjbzdaSnlMa0JEUzVUVm1uT1h4cUp0?=
 =?utf-8?B?bDlSRVQ5UkR4ZE9LaHFzYXZ0VlBhd0x5NUFoNEhSaE1Ubm5udVlLNVBwa24v?=
 =?utf-8?B?VlJWNHNkZTMvbVd4U0FtSklzamx1aGRkQ1E4MjlDTjFFdHpqVHM2NEx6eVZ1?=
 =?utf-8?B?ck4zUFhhWGVFaTUrWnhmM0ZKakhhOUhlOG8reWpmRCtlbTVmekhEOERTRWFO?=
 =?utf-8?B?OGd1ZnVTM1o0YUloMDRKcmE3bTZiUmFsS2ZUUlFzcUp3VlMyTFNjeUphRnhC?=
 =?utf-8?B?NFRtREdvUDlFUU1qYnNCUXg3NDlFRENLcmxQa3JBb0NyNDhWR0Rxc2kxVE9h?=
 =?utf-8?B?WVg1Sk44OVRydEFrc1JWeWh0TFpxYWdxbkp1cUNUWVNJU254cTdUSHRkSGZI?=
 =?utf-8?B?TGp3Y1pub2xoZDdRL2x1TXFKRzdxRmZ5eHJFMWVybkJDazk4T2l1ampFUjY4?=
 =?utf-8?B?L29lZW1DMWVYTHI0Wmg4bHRnK1lSTWZLVGZNbkZRUlBadm15UUErNzlCVFcx?=
 =?utf-8?B?b1BKM1J5dis4L0hYQnhlek5COXRxK0FwLzN2dmMxd0MxV0Z2RVFlTUNIQWta?=
 =?utf-8?B?cHk4TC9lMnJvZVZTUmsyL2NqVEc5T1BUYU92elhiWFRvdUVDY1JwTFM4RDc0?=
 =?utf-8?B?YjFXbktHREVrdmp3Wlp1cEkrak82VjBHU1IwdGRTREpGdUN6M2xaWEtvU29B?=
 =?utf-8?B?VGVmYml3ZkRrdFphU3FYODRpVzY3aDNFTG1jUVdYM0p5bFgybU9qSXhsK2J1?=
 =?utf-8?B?endjbUt4VDlRT3lTdkkwdGRMVHl5ZUFCbXVDVWpuUDdkMHg2UkdSTStMYXpF?=
 =?utf-8?B?NEF5SGhNbVEwQitta3EyN3ZYM2hjdzZvVlhKTjREMVFadlBmeFRKQ1RvRThK?=
 =?utf-8?B?ZGNJV2k1Uys3NlRJbzdBL3N5aTVOUzQ5U1lJR20yb2lRS2plc2V5dmhtRVBa?=
 =?utf-8?B?TTJVL2VNbVgrdER2dWgzUUFNL1pRaWN0ek1XSXFDdGg4bnM5bC9nbklGazFo?=
 =?utf-8?B?alJDRmsrU3NNYXNmbjZBSlVCdlQvdkNBZ3FkUTRqMmh1cFBLTU81MWx2WTg5?=
 =?utf-8?B?RU1CbFpMSHpaM3lvOVJ0eEJCTHNxTytJaGtmS0VPcGFhaXhCY3R5NWdzZDVy?=
 =?utf-8?B?MDdpd0Z0Qm84Q05ES2hPNk1TNUhhQ0U1UUhYK2dEcTJXV2xPUjlKOWtNWnJS?=
 =?utf-8?B?M3J5ZDd1eHdCQzhUQVRFOGpCb1haYWlYQk1jTjN2bXUrVFpuYldYdnpSL3pS?=
 =?utf-8?B?TEVtUFYvMXhNZU5mdEZKZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4312.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VVlNRENNcHJQL0ZWVmFXekJ4bXVhWVZmQzAxNTlzU3dxbjBiUFhXTlNNT1hO?=
 =?utf-8?B?MFlRbnpUZm80VHJBTEhZSG1VbjlRbWlXQWFLOGUrTWpWeGZYcWJXb0dJRHhH?=
 =?utf-8?B?eVh3TzFleCtOZzRlRnpaTk5CZ0JZeXYrUGJTaUh0bHNiem5DM3VlcGdjYnBZ?=
 =?utf-8?B?R0E2UnNaak1uREh2UkhaNTF3RlpJTFlvT2Nnam81VEhyd0V2anE2S2NLbDg0?=
 =?utf-8?B?Q1JqbmkwM2dyYXpIVkllZG8yUnFtSTYrRExOSDNKSnBrVDNwVmRXUHg0VnQr?=
 =?utf-8?B?NnJNa2xRQzRNMktIN1NLcC9sbmRVN0x4c0FWT2ROU0E4L20vNXcxR0JlN2FR?=
 =?utf-8?B?QndMQUVrMXdqc1J6QmxBY0I0ZGxZbXZNeWdGRm5GNjZmYW5ZVTFrVUMybFZ1?=
 =?utf-8?B?c2ZRYUw5a2pETmhQbHdENEsrN091U21YZFkwY1JqZFNXLzczcmxNZlQvOWhS?=
 =?utf-8?B?Z1pJaVNRUXdrK3NHazhtNmNMYkJCYjl5VUhIczBmLzRvWUxpZStadVpQMmty?=
 =?utf-8?B?clcxRGF0TlpUTUN5WkJ5bVljSmlGdU9XSFV1SVA1ekM0WnRWT0hYT0E5NjNN?=
 =?utf-8?B?SzVkZ3RlczNtSmJZRXhtaGxlbGxBMUhjcFE0UWJ1ckdZcW9OcmtXdjF4RnQ0?=
 =?utf-8?B?K240cnUxZG1MNUIzUndyVWF6eWVWMjZLQzIrWGFIVklHL28wVy9tcG9LbkY0?=
 =?utf-8?B?aGJEQU9MUHd2OCsrakkzZGNmbXJCTFIyejE4c2JCL3o2amRHQ0MrUjlqWWlZ?=
 =?utf-8?B?YUJhblB3enhxQUo4OUJhSmFNMTlqcUFWajBudkFTcWM2WU1zSDJpY2pNVjlQ?=
 =?utf-8?B?NlM4VkVJaVJmS2IwZEgyc3N2K0k3SGZIdSs0QzJkbkp3dDNpVTc1R3Nsempl?=
 =?utf-8?B?QUtDbVE2S2w1REppSFZrakllRXlFQUt0ejdHdGFwRFVLdStJdkVPc01lZTVn?=
 =?utf-8?B?OWZ2RDhPS3k2cnliT1lhNkdiR2Q4K1VXd1V5ekVJbjVtMEJVZWpMZHZjKzJn?=
 =?utf-8?B?NHFSOGl5TDUyMDZZUHNlaXZjSm5LQXZlc2pCdlhRUW1udUNUN3RaUW5SWGdO?=
 =?utf-8?B?MUQ5RE1rVTZnSjFieWY5Y1FSSndoUDdDN1VqelM4aEp6M3ZpdXltcUdNTERB?=
 =?utf-8?B?Ung1N05ZY1AyUzNESVJ4OCtrVVNRNitoTEpCNExBQWdsNnlLZVpUQitaNDFM?=
 =?utf-8?B?dVNUelRtMzdza0s1MHcyWWhSOEhGTWl5WUF4ZHU5eXFBT0I1QkRyMk00OGhz?=
 =?utf-8?B?cmtUMmFuWTRIUmFtaXBhNXNqOTNPc0FjeitxUDBuR3dZOC9LcDlRUmNUOUhV?=
 =?utf-8?B?Nk9LSFhGbE8yNjdKaXI5V3VmdG9vYnRqdE1MNlJkckZMOUhoMDZ6Y0NzNktq?=
 =?utf-8?B?T2JzM2FvM2pYckdrSWsxV3JvQ0h5NnFYeDlCK28yQTRXQnVaK2RqM3dnWTVx?=
 =?utf-8?B?OXJwN05qTnlRSStZR0tuMTEzNkdBcU1uVTVrdTU0MmlOQUhYKzQ3NnJ3VXVr?=
 =?utf-8?B?SkY1VjNWK0c5Z0JXYUdpNXNVZlhuQkhEZ0F3WTA1RkNWalJUclFqTm9ibmdO?=
 =?utf-8?B?UnZrK1JEWmRMNkVrMnFLb0FSTE9sN2xVLzMwWmlyMnA1MlhKOGZITUt6OXVX?=
 =?utf-8?B?TGVGaWQ4c2dDYlh5SExVdmRtdlRUcGJvckJPOG1wZTJUaGdCTWQrWHNWdGlB?=
 =?utf-8?B?NHR5YUphck1UZVJYODNIRlkwK0dHdGkwdDBnNFhOcFJ4Z2dCeGxab1ZYZVlz?=
 =?utf-8?B?NG9rZDFVTmFlZXZiNWJQTWpLWTVTQTJJSldGV2pJZWJFTXNtMXR6eDBydm9V?=
 =?utf-8?B?OXBVNFd5MHRIem9JSjdQemlxZWxTOFUxT3pxMWdPQUFmd2ZCV1lPUGpzZmZK?=
 =?utf-8?B?bjc4Qk9iRmczb3RDMDRwK0ZxQVVpeGZJQ1ZUY2pXR0lBUndjaXJRWTRPbUU4?=
 =?utf-8?B?OVZxS2VqV1VpNDI1bmFmSlBWTHgxMThxYkRxak5BU0kzYklZdm9KLyswcTJN?=
 =?utf-8?B?Ym1acjlyYndGRFY5N3pKbDY5UFdTSktHaGtLT1VZZG8wbWJ6OUVJL3pEMmEz?=
 =?utf-8?B?bkNtZ2kyaTB4bzhOamgyTlFIMS9KdE5JMGF5eXRFOFZZS0hEbVNVRlA2N3ln?=
 =?utf-8?B?Z21sY05XVXhiY25SS3hRdzNFd095LzdZcGpXYnpFSkNtdDFteFQ0c0wyM1Bt?=
 =?utf-8?B?L0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RueiP8SGzymEp9rXJNaI1Rdc9Ln8TJ7UzQVIy36b8GjHf2s7H4rPCF6lHiwMkgz4bhLIWDZj1lzGJ3BLepk3dWH+9K4wFp8OYaw5enQY+M25VCpEBYN6lnKfzheySgNfHCknrflc89phB46Rm/lXpCwQHacNq93swAn6N/98DGqKiZJfq0q9OaTPQ37o6WPgtnYAuUwd+3ijSiSJTduMKGuvC6r7qWcYuH2GiEBo/CCuGKCeZCqSp/g3UWvK/nFblEOZFbgOvD9Xgt3UxSuY5s0zRw9CIOULQOPBnusMPpYhyl8NBZ/yqVOKbEHM5NfQqJKfOUGW70fmvmDFTZR9LiOnL4wlUoB7VvRp5DxdmxOEld4sgne3b0XE376GEF2765KTq8bfo06exrkfnBl1n3GJKiV6iZZa+V3No/ZoRbfSmwgxHIcdNSNMijv9wzOeh6AYLiY9FIuCb/cDcqDLwNLer8bNpnOfcGHvgUrVAqGYOE5hfinanFhBGMF/1GMmji9TxSONQ6Ub9WqtlkE/DCAO6rnWyKro8BmwZxNMyNXifsSxREs9DJmqd9BASiLFG9v18Vm6fnqwNe5QperPVoPmX16LJ0vBfPN6aGEuXIU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35be3270-5f46-4b7b-7d08-08dd76b9e256
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4312.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2025 16:24:49.7033
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YuPmLC987lif3dHdW3F39nyvTRj+umCNG5y6S91Sgap4qMREgBfKcnquXYVeIhDGWYc/IfkgfG6kdXqQG9NJiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6864
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-08_06,2025-04-08_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2504080113
X-Proofpoint-ORIG-GUID: DvBrPI1udV1ZuOE2UQfAyLW7A1BcGSuy
X-Proofpoint-GUID: DvBrPI1udV1ZuOE2UQfAyLW7A1BcGSuy

On 08/04/2025 08:59, Catherine Hoang wrote:
> Add a test to validate the new atomic writes feature.
> 
> Signed-off-by: Catherine Hoang<catherine.hoang@oracle.com>
> Reviewed-by: Nirjhar Roy (IBM)<nirjhar.roy.lists@gmail.com>

Please see comment below, but this seems ok apart from that:

Reviewed-by: John Garry <john.g.garry@oracle.com>

> ---
>   common/rc             |  51 +++++++++++++
>   tests/generic/765     | 172 ++++++++++++++++++++++++++++++++++++++++++
>   tests/generic/765.out |   2 +
>   3 files changed, 225 insertions(+)
>   create mode 100755 tests/generic/765
>   create mode 100644 tests/generic/765.out
> 
> diff --git a/common/rc b/common/rc
> index 16d627e1..25e6a1f7 100644



> +}
> +
> +sys_min_write=$(cat "/sys/block/$(_short_dev $SCRATCH_DEV)/queue/atomic_write_unit_min_bytes")
> +sys_max_write=$(cat "/sys/block/$(_short_dev $SCRATCH_DEV)/queue/atomic_write_unit_max_bytes")
> +
> +bdev_min_write=$(_get_atomic_write_unit_min $SCRATCH_DEV)
> +bdev_max_write=$(_get_atomic_write_unit_max $SCRATCH_DEV)
> +
> +if [ "$sys_min_write" -ne "$bdev_min_write" ]; then
> +    echo "bdev min write != sys min write"
> +fi
> +if [ "$sys_max_write" -ne "$bdev_max_write" ]; then
> +    echo "bdev max write != sys max write"

Note: for large atomic writes according to [0], these may not be the 
same. I am not sure how this will affect your test.

[0] 
https://lore.kernel.org/linux-xfs/20250408104209.1852036-1-john.g.garry@oracle.com/T/#m374933d93697082f9267515f807930d774c8634b

> +fi
> +
> +# Test all supported block sizes between bdev min and max
> +for ((bsize=$bdev_min_write; bsize<=bdev_max_write; bsize*=2)); do
> +        test_atomic_writes $bsize
> +done;
> +
> +# Check that atomic write fails if bsize < bdev min or bsize > bdev max
> +test_atomic_write_bounds $((bdev_min_write / 2))
> +test_atomic_write_bounds $((bdev_max_write * 2))
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/generic/765.out b/tests/generic/765.out
> new file mode 100644
> index 00000000..39c254ae
> --- /dev/null
> +++ b/tests/generic/765.out
> @@ -0,0 +1,2 @@
> +QA output created by 765
> +Silence is golden
> -- 2.34.1
> 

