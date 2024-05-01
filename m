Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706A54CE1F
	for <linux-xfs@vger.kernel.org>; Wed,  1 May 2024 08:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714551045; cv=fail; b=UkrkriejdTAd8LplRKBktJetpp17hDPdeKznTKR7vVbyVit4vptZrAkrN6XMLIszK7Kj4no0LVsL343XdXDjNeNd5kQRTPtskM0Fa5VO4krYOcAob9fWUKqrn8TQHAsuV6bnKqcsOvJOSFqRkvokwjzXLT0Dn0SkI2LRg7+CSzs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714551045; c=relaxed/simple;
	bh=hjV8fzEuwE+KJBDC1cYCMZ63ngAiN293EQV6MJqPMCE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=axg8V3RMozXrUXJmqwXI2uoqXdOqvR+p7+Sw/yyHgZUx2ZLmyrOIUe/JlX6ZvVgTe8BfxW6KF5+X1+wI0bXFp37QoGZibttPyDfOtmcHpnVGV/MCU1jpl4xjPUumBQwQDzI6k9h9xNUFuO/TWu/4uPb1nmaxM2aP0fjj+G76+OM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=LjT9vHcA; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=uUl3Qyrn; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LjT9vHcA";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="uUl3Qyrn"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4412jUpT023029;
	Wed, 1 May 2024 08:10:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=wWxBLAk4jpINDWwb10A+dpmwK3htJV5Ty/4vK+tSIJ8=;
 b=LjT9vHcAO2IzQezJm5PznG4HuBW9eF3G/FEgGbSOSonSJESn/1N15rMW3GcB9hYwlVwp
 AMIrpq8dXweWcTk+pbNjs1WDTY3dEKN8jpOPkcovSOAvPqPRz8mnEZQRl9j3BR0/eL5S
 Vy132aBzNL7FZP6UWQ3/O0XgGc2huFhQJ4pv/lkZtFKPisJjFRdRVueudSIl9/cNNiOk
 jUrRCRr38xcw8LLBDAJN6UOH55Pyrng3LWWwzMdlwHexY77CXThC5RaXa6Fp32/bLrSW
 /3CaG28b4rJUjqOfk8kLiapGwFrAERfcmfMaKBkOBp5NjNE1PTSkZ+VAvwxGjzCeX/jE mw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xrswvpsbw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 01 May 2024 08:10:29 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4416fw2g011384;
	Wed, 1 May 2024 08:10:28 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xrqt92bgh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 01 May 2024 08:10:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BJ6XXeEjq2dzoDbrIaYMhVqEwa4yxnawOrutH7ygCwhkNT5KTGtj0FEoBbOwVITuRaX1ZfW+6LlD1q9Q7o6QRFz0kkNWlo907C4a28SBX2u7RzfeGMU/HP8oJDttlScZeuz82Bevc1E6ZjYJ5cYfksHoMln84VmlmxaDGSelsgDzIk6Ii2/o5tfSkCVTfVHJmqBv8PmCrfN9BOM1YFy2b6/WBQhnn3+gpfIts40Y/ce4cQU2wo4vI6aLWxx/h0yAcMQ/Pug4n4bkUx7K6PO9GQVhHhJdrapD6dKWOkwXJkDmkdg/UBEgzLIy5Mo0PZhtL/C82PRfMvr+Kgn3GmHxIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wWxBLAk4jpINDWwb10A+dpmwK3htJV5Ty/4vK+tSIJ8=;
 b=A5Uhl+qSsvCiDYcg8FI/KWtb7h3U78/88SzSOHBrQDfGhkMObiqZZ5DnAlLYnkqDpwBhuVZX1OIo5Yp4FSCddTVQoD04lZvp0zNIUu33PlVhGmC8RNWsgNMzx/5SXMZEe6KDwq1SMtSb0o8EnMDsIevDD1qQ7fM8rs01U2jNUij2S7oqntZNGD7XG9047pODVbBpOt3ImpwxGa4cIobgAL2ngMu57emzfI8YD3qAIyDlpNvwA/HpWgsN0LMTSU9XytksHofk+qF1UvhgnTDFoO+4rmxqc9DNdqfF9QaJYDvT/f6oAZWe3FV4eZKvXGuugOeZwFT+P0TNopTGAyNICg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wWxBLAk4jpINDWwb10A+dpmwK3htJV5Ty/4vK+tSIJ8=;
 b=uUl3Qyrnzzpa49n77wa7EPIYmTslwUXDBxpQovmxCiDilaJAbXaiIpIQ7YmCe6F/vP3Jg/x3vyDvub2nRIQ3g68GuViBvwdu8XXYVwhSMhST9CNO4lurmGdu8MUOt9NMtuYsZXiGa7daEget0Ae9Rpd3WPpWcnfz1W4kbtdngds=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DM4PR10MB6136.namprd10.prod.outlook.com (2603:10b6:8:b8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.35; Wed, 1 May
 2024 08:10:26 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.7544.023; Wed, 1 May 2024
 08:10:26 +0000
Message-ID: <c0fe3156-d2b6-4a23-8d0a-de069b079eda@oracle.com>
Date: Wed, 1 May 2024 09:10:22 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] xfs: Clear W=1 warning in xfs_iwalk_run_callbacks():
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, chandan.babu@oracle.com,
        djwong@kernel.org, linux-xfs@vger.kernel.org
References: <20240425120846.707829-1-john.g.garry@oracle.com>
 <20240425120846.707829-2-john.g.garry@oracle.com>
 <ZipJ4P7QDK9dZlyn@infradead.org>
 <01b8050a-b564-4843-8fec-dfa40489aaf4@oracle.com>
 <Zipa2CadmKMlERYW@infradead.org>
 <9a0a308d-ecd3-43eb-9ac0-aea111d04e9e@oracle.com>
 <a99a9fa0-e5ab-4bbf-b639-f4364e6b7efe@oracle.com>
 <ZirnfaFFqqyaUdQv@dread.disaster.area>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <ZirnfaFFqqyaUdQv@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR03CA0015.eurprd03.prod.outlook.com
 (2603:10a6:208:14::28) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DM4PR10MB6136:EE_
X-MS-Office365-Filtering-Correlation-Id: 3bea815e-1aed-41ea-1d0e-08dc69b62870
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?ZGRKd015NnZ4dlVuMkRsa2I1WmVBRnl0N2FrQzVUS1pWeERHVXozVE9OUVVV?=
 =?utf-8?B?WFdlYkc4MU1uSk50ZzZTRVhnWUJlWU9YK0tvdDZqWlBmalZGUTVxY2plc2p5?=
 =?utf-8?B?ZkY2T2F0RXJWQWRQU2Z1cXl4c2NPY1JFSDNrZXVGUzFXN1I4MW13cm12c0Zt?=
 =?utf-8?B?SjhKWVlrdWJ2VTBDVWJucFkvVjFIYy9YbDYyNTFTdyswdENqWkJkQTZyL1dr?=
 =?utf-8?B?aEFyNndITENaR1drMndjQVIrdmlGbkJnTTNMY0NHVnI5SGhkNEtyUW1sWHRV?=
 =?utf-8?B?S2pLbEZlSjJyNWx6UHJ0ekpMRFArMVlDdUk2eFBtelJqaWFKTE5UaS9NL2xV?=
 =?utf-8?B?VUpTdVp6ckdDWXpRajJxYTRtTnNyNzBrcjFOOUVLU3J1STJxeDBFZ1RDRDBE?=
 =?utf-8?B?K0I1dWF1N3k3U0dScUlPSjBXSUZQM3BDTHBWMS8yTnRQV0xxaEEwOXBwZjVQ?=
 =?utf-8?B?SzhFTlpyd2Y3SmNjOFc4WE9iSmtySldodU5OV21VZFNxTHdUcS9nMDdGMDZX?=
 =?utf-8?B?N2RSNEdxNnhWZmZKSXBkdk5lYWlFYm1mL25NUXpzSTJhN1ArTllpdVJJbUN3?=
 =?utf-8?B?bE5LMmxVcmhGMWNtWktXdmx2a3lTcDlNdjQrRHVCQ0VCSWFCN2I5VHBnRmNX?=
 =?utf-8?B?OU1ndW5BcmxHZmducHY3V3gxT3RuSUcra2RENEJKcG9rNEwwY1RORkt4eXdD?=
 =?utf-8?B?Y0k2b3FaRDRoblZOZ3VFQUNiY1YvOHA2b3J2NHpyL0FmdGRSbVhyWmtjak1l?=
 =?utf-8?B?VmkyYnpaUjRQMHk2dTMvZ0M2djZ2blVsazBYeDNZQnp6V3ZtR2tUc3I4R2sw?=
 =?utf-8?B?dVh4cDZZVFdVZ1B4VGhzOS9XNkx2WklHc1o0M0hrL1pkclJja0UzMng1K0Jk?=
 =?utf-8?B?cnMyNURrcmtDdndueC9mZHl2OGdWWW5JNkZaSjZhak0ySTIxMzdYS2ZLTjZO?=
 =?utf-8?B?bjhBb1NCb2dubWF4RnNXS1F1RnNGRUE1K3krNm5BYTNBTktUS2w1aWRzTitQ?=
 =?utf-8?B?TitYdEtUN1VCWU5NSlIvVFZDVDErSkFWbXNPYnYwTG5PZy9nSy9ESXV0MWU5?=
 =?utf-8?B?cHFMMGU5SmlsZ3BhQm9PL2g3RUhLbnIvSGMyYTMxZnBkd2F4Mkt0U1dGRlM1?=
 =?utf-8?B?b3A0NUh1SzJJYmlES3ZKbzY3SXU2Yk03bmlaY0VEeWNWODI2bFlTeFlFNERW?=
 =?utf-8?B?VGZOZUI4MnltUG8xeTBwQmxjZzVJWDJ5bzV1VEp4aEJtTmFGTWM5ZzZaUENu?=
 =?utf-8?B?dEQyWFhJbmV5eERIdEk0a3VUTjVaSGV1ZFVsYU1XV2JTKzFaT0c1WjQ0QUQz?=
 =?utf-8?B?VzUzS2hrQkJqZ3hWL29seDdROW1sUnBtN3poZWpNUHd2NWlhQzQvN0h6UXdy?=
 =?utf-8?B?K2d3WjlhejZld2w3cUU0KzJTQnYwUk9aVzJ6ZnYyMnlLOUFQRXN2MmhMaVZk?=
 =?utf-8?B?THFLRGIvYVZiVHpCaWZCeGJBdEJBczNQVEJRT1RoRFBObUhjYStYOU9YUjFG?=
 =?utf-8?B?V2tIRDhRWVE5OGYyUVdld0FTU2FpWWdPdHUwT0U1UVY2R0VQVTBIanNBeURK?=
 =?utf-8?B?ZWJkZ2RhNWNpQjZ5djVoaER3cHUxV1cvRElKdEtIOUd6UlFpSWliV2xEZVk2?=
 =?utf-8?B?NGxmeEtRUVBQZkhUR0xPSkIxekxnc2R0NVROU1pheDlxeHhvbXFHVGliM0I5?=
 =?utf-8?B?cXR4U2JzQjZtRVpSK0RuaUwwWENJVnFUNXJBcW9POXM5Sk9jR1cxdHZBPT0=?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?N1VpOEhCVXJMQi9IbG5UbnN1N2VaZ2U1c0V6YUtMOFVIeHovTEdOYmtlNUw3?=
 =?utf-8?B?YXRlOVZwaERnZTdqeFNFN29MK01kVnJ3SnJZZGJXY3JpbklCb0pvdnlNYUpy?=
 =?utf-8?B?K0ZZY1NZcmZrQ09kQkZtVVY2QTVaYUZwK2RDYjNKNGVSWkkrclM0VmZqR0lw?=
 =?utf-8?B?eUp3a3FiVWRyL0dKMlJrOUIvazQ2eXR0LzVIc1UzL1ZDTlZhTTc3QVVyTGZv?=
 =?utf-8?B?TjNDWjBmVlR6aGQ0RmJxSVNqNDRSTGsxOHFuUytIdE1SRFV3WGE0dHB5K0dK?=
 =?utf-8?B?SlZOZk04R2Rwb2UxVU0zQUtRZlgrcUJpek5rYlhqdjZHVjF6RmNRenFRU1Zx?=
 =?utf-8?B?VythYU9WS3lmQThwY2k2emNaaURYc1p3Q3cybXZoQUJoZE1sRGo3WVBGWTdJ?=
 =?utf-8?B?dnRZS1RDRVFSbjZSZi90a1k2S0plZzN3NlNUMS9CSmR0OEV4TWdHUkMveEhL?=
 =?utf-8?B?QXgySXN0YXFpdUNwZ3ZqNjhYN2doSWNEZU5PdU8xVUhjYXorOUMreEV5TE0y?=
 =?utf-8?B?eGJJUktJbDFrUE5CZHJpZmpBZHdqRlA4RER5ZHZUL0dNN1pQVTJvQmZ6dldP?=
 =?utf-8?B?RVMra1N4THZGakVVejlZVCt0VmQ5N2x3M3o5aWQvakFxZnVMQVYzTmV4dHlV?=
 =?utf-8?B?VHo4eUdCNWlySU9nMWRGNzI3QXNBMTNOTXZoVE94MTFOWjYvQXljL1Z1d3o4?=
 =?utf-8?B?WDRHa05wYk1YdUZabjhUdFBiMFJFeXhYSk12cjgyODdZeHYvT0VJbGdBWkVj?=
 =?utf-8?B?d3ZKbk93VmJ3VCtoRG51Ym9RbkkxTElmQllCUjFobGpKZXYwcFNpaFRMbnoz?=
 =?utf-8?B?Uy9oZ3Bid2lnd3pHemFWUkVueEtDMFlIVXI5azBpTS9DaDIwSE1zUXJEMGJ0?=
 =?utf-8?B?Uzkwa09OemVoNk9KUTFRNXFncnBLMXhuQW5WQkNPa0VQVHdKeUZ3eUwrTE05?=
 =?utf-8?B?UzMrNmx0T2Y0MkFsZHA4NHRxZUtVYU1MYytHMFprUXRzVS9VaElUUHlZbUIr?=
 =?utf-8?B?K25ScDZ6azRSbE5pVWRXMDU0c2RQc1RpOERvUVptL2k2RXIxRnNJOVV0elFK?=
 =?utf-8?B?eG1uaDJaSkFoODRzVk5VS3JUWExydHVyZmU3UHplMXNTYTBBRU5YYjdjcjhG?=
 =?utf-8?B?aU5HWVZmNWN2NE5WUkRNVmI5SkkyMDlXRGZrU1BVdENCY0o5SmYvUWZjMXA2?=
 =?utf-8?B?MmpvajNHUkRSTC9laDVNMCtBYUNRRi9aTWM2ZklvbXFDSk9oL3N5aTVLZE9B?=
 =?utf-8?B?ajROazRPNVhiYVpjdnNLNzdsdkhCcUhOdlE1WkNOeERCQTdCdVd0ZGg4c25I?=
 =?utf-8?B?QzVqTVNsUE1qNENWMnJaT2xHVmJ6TUpvZ2lJSmVCcUl6b28zZEVjRGY3QzY5?=
 =?utf-8?B?RXRDTGpXcFBSRWYyZUpoRytYTDFrcnk0RnF0ZENTSGkzeTZtSTZvRjlvV2Fs?=
 =?utf-8?B?VEh1ZnhWcWVNcExpM3RYLzc3TERBaE5YU0xyQ0MvdXNZa1ZNdUk1eWI5TGZS?=
 =?utf-8?B?ZklqMGZTZnlaMytnUC9RR2hHdVV6WjFwNVJRSk1HZWVMUzh6QlFTQUF1NVI3?=
 =?utf-8?B?UmsrejNZR0FSTnFybE1vci8vTlAxcXZtT0lzL092S002REV0a1pGVTZRNzVw?=
 =?utf-8?B?Wm9vWHdJb1oxdkdHTU5YMDE2Uk51RllKME5PYWwyNjRnbTlQM3ROakFJYXJx?=
 =?utf-8?B?bHlZSW51QmE3R2J2MTl6WUJ4dFRmTklROE5DY3o0bS9VcnZyUS8rRStENm10?=
 =?utf-8?B?amp6a3ZXNnlabjlUU3pNOUFCbzRwb0FSTk9kWFR6Y2Z1bjBrYjRhMzUyLzlF?=
 =?utf-8?B?S0NHVUZzUnVVaGFEUFZlYm04RGxKSTJOQWh0MnlWL1pSdE1RZVNkUkVxYkNH?=
 =?utf-8?B?RE9xTXZPVkRyVmJPbDlJSjQ4bnZRbHdZUGFOYnRDaFdoZ3B6ZzFrRDFYSDZL?=
 =?utf-8?B?MmdZTGhGR2lKdmVZZVRSUlJwOGdublowT3NZd2k4VlR1NloybktudUU5eWZT?=
 =?utf-8?B?Y0Q1VmhHREdubENrWGR2a1Z2NGl4UUFMOThvR3p5OVJOYkZiZWVLSitJZnpS?=
 =?utf-8?B?Y2NZNHBJL3BmalUyL1NDNFQ0NDBaSUpmKzkwZEVxcUFQY2swcVdabWRURjh0?=
 =?utf-8?B?b3oxMC9KL3A4bzF3dE5QNXhZWGhnM1BOdTZ1Zm15SEFVRVdVQVE0NU9ZdUpS?=
 =?utf-8?B?SHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	Wu5nSACsSyBzHzlEdXltxIfWmEZM5cnn+6HfS8v+J4A0c8M7QAbnkZVAB64CXSYosth60kQTx49eWnEoKDs8sGibI2QkGvGgI0yw4CND53mJ/q5Jm0TGbQqRLQ2qMeFjnMtjEgCgkuoOCvlkhJ6uEnPsYrSFT9ozXJTCQNamJ/ZLDXE2ROUGKx86+kVURvowr9bjOZHoJ+oDFBaxy31VETfHiTK5B6/BlGYqPNyeRuPWfJlrOIMa9n/kj76oxVaWI8JQ0qkcY0UFUBbsVY+tD+6E5e81kr4MPqXtwhm2eQVigdQW0KxY2930JvblOmao76FMRKs9nkTO0dPhY6XMfEnHulL1jbjxeoDLlga1Wkdwxj0/oFXoTVHNlf3hk4Gjz0sXiJqcCytdmKYu3mJewcz6cvdOeaacqw4yIpDy+2ukFNRCEWnU4bIMTDxUzPQoDP9NlNZOO2AhKVlNCiKRptVSm9o4mbRIq9mYEjWNbjsQFIBotPl89PaP1+odpOHq9JgeksBReC61RleJIJqlxaj5FStNaA5lEimk7fnIsGKEJ9F90N5Db3Km3fhwLws861ACWk49WNAt8CDLuW4r5Umd1NbQcuJEpOEOlFQGEpo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bea815e-1aed-41ea-1d0e-08dc69b62870
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2024 08:10:26.5675
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y64gsG/RPwmiV8ig8Kdwrnggf6vW+Ks7epb5Qu5+tQH3b2ocWvo1FWWYyCtIq/YZyqGhDv2F1My0jIbVCkRXdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6136
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-01_07,2024-04-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 mlxscore=0 suspectscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2405010056
X-Proofpoint-GUID: p-xBzZaAQ2kGJSbfR821VtU2s4uTxrQX
X-Proofpoint-ORIG-GUID: p-xBzZaAQ2kGJSbfR821VtU2s4uTxrQX

On 26/04/2024 00:30, Dave Chinner wrote:
> Can this be written differently that has no need to access the
> on-disk AGF at all?
> 
> 	Yes, it can:
> 
> 	ASSERT(xfs_verify_agbno(args->pag, acur->rec_bno + acur->rec_len));
> 
> 	or:
> 
> 	ASSERT(xfs_verify_agbext(args->pag, acur->rec_bno, acur->rec_len));
> 
> The latter is better, as it verifies both the start and the end of
> the extent are within the bounds of the AG and catches overflows...

Fine.

I'll send a single patch to convert both instances in xfs_alloc.c and 
tag you as "Originally-by" in the patch. Let me know if not ok.

Thanks,
John
