Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17CC97BAF9
	for <linux-xfs@vger.kernel.org>; Mon, 29 Apr 2024 14:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714399592; cv=fail; b=ubMhyqZNLAcPyhbyOmae73RmCyyWiVzJql95CojBivdKcEkR3b/gaJDnXYcCIaOQU5mDF7za5d+fBwuhLzbfY3ny1+AUGaYFgf7MkTel4A04KGOZylFC6rsiT1TBr4c4NMlu4OfqjYoDkU4DDObktBXlJaEZOqu0Iq1SSk/8cPs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714399592; c=relaxed/simple;
	bh=w+CefDwTIHvsJTLmWYbze/SE6G1mmcT/oN0+G4j7UjM=;
	h=Message-ID:Date:Subject:To:References:From:Cc:In-Reply-To:
	 Content-Type:MIME-Version; b=c64hWrVDi9Hjq/5874jHEXaoY0aixEGbh1+MOpRN1FAnb7x4ZPpJKQCd4MRX0hoc6F+BFQWZhdt9RJT8T6Iuy9NjHyAqFdJOyN6uT0hc4NuG2lD4gPal/JyLanEdCC+SXUjOBW1+Q4PlwtCTzqgmd7ImeC1pjPXLPhzbl24Kfnw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eQV1zsEv; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=0J6BD218; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eQV1zsEv";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="0J6BD218"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43T7jPO3006857;
	Mon, 29 Apr 2024 14:06:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : cc : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=x8hh7Wovs3twlxWqwZHey+zDQxmL8HrtE455k8Ycad0=;
 b=eQV1zsEvLP/PlQtLSFYrBhvPkmm7cnfCzHZJyq6jFhzZb6xsv8jp9irF7v+dHVK+LmcN
 KkwaeiN6jb0vrhYImutXCg8bz1xfEEHKFfCrTlEgN+jQHDr42y/x7f64lLBjECK8eNWP
 oqeXrsdmSZdjcnuehLis00sAmrfOKv4l3Zk0HijWOpmTNLil5+MVjDUbBdALhgcqtfaj
 O37QPdubSGZ9QC+AjB+oF+3S8Ef92Vd3y07KV404tAFD1RihrmO/HXMHJGOseUak6jWC
 ErnZfdqXkLTHhSLnkJBUs/f+1tejrK8Mzf1zI8nckHTv3Y5rGRfTadkMbCh/+y8Er0pD iQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xrs8cjnds-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Apr 2024 14:06:23 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43TCUmVl011399;
	Mon, 29 Apr 2024 14:06:22 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xrqt6cwvp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Apr 2024 14:06:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FbvO+eEFCqVfMVNY+2BYlBCLinnrVL0c5ftLOU9RT0F77tktoH1D1CPgDk9V693CNdJeX8G30kyDMeyif2L3c9HTgw/AomXVRK8WX2BljiWzQwNzbKRqj9tLB13t1YOe7xwXThc1yXFEz4kfLpLVbazbQwMLL5IYP8t0ihVPpzr2nwhBlfpsWRazZxNgoRlz3H/LCruL4fTk6y4LncAJD7unanHzJVd03oDZKeRzGZspTCmkpW7HNorCUNGA0eGisHDEY2nUi0jRDvDGT+DbBBzKm6NGZ5B86lQH0xlOliyBvcrLF/S1fAmuwEXLJ2dqnsZj9IFzUeJRZHhMoe6Vvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x8hh7Wovs3twlxWqwZHey+zDQxmL8HrtE455k8Ycad0=;
 b=DAYIEUJbPs6T5gcq+L9jW0aYQFdnRETcO6oTcsGHeW5v6vKxShxwPzveo5VejKLoHwcXK1MGMFo6vTfIW1sm6naSjzNsL1qG7NyYXpftXzLLWbNYyYF6Y7WFv7UP8Jo+y4R893gSbYv33shO4G9xkb+xWV2n4DoTZvRYxixlgGm31MW6+7d2cK2Bb/sWXkT/26RVHiMUOMXogPflgZ8FwhbRrLIcJG3UTYgR3/7qAZtauLKGf9T+xzODtZgxOKZ1ZnXVlwwYbqcwKnnEm+dd4eO97dS/EA3fpGrP5rCrOI+ryV/Xzu9JRcXpLapI8nS4i4Sqo3K5Hl1+2dRCIDB7QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x8hh7Wovs3twlxWqwZHey+zDQxmL8HrtE455k8Ycad0=;
 b=0J6BD218ceDiwfPv04PHdA/sJvR8+WA8LxSHnNEMOnxqXe5qBpodeYYWtaD3sx91hxykVc5X4bTjKSmbNSOWfZvxc0Rf4SaD+An+YTAXMtSGDKzstOVNUyrd/yahZmhryuiXwqEMS703DMsMrLDNIRVotb85vzEd3SmgsTXZnaQ=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ0PR10MB4671.namprd10.prod.outlook.com (2603:10b6:a03:2d5::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.35; Mon, 29 Apr
 2024 14:06:20 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.7519.031; Mon, 29 Apr 2024
 14:06:20 +0000
Message-ID: <083f3d88-cd39-41ef-9ee1-cafe04a96cf9@oracle.com>
Date: Mon, 29 Apr 2024 15:06:16 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] xfs: allocation alignment for forced alignment
To: Dave Chinner <david@fromorbit.com>
References: <20240402233006.1210262-1-david@fromorbit.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
Cc: linux-xfs@vger.kernel.org
In-Reply-To: <20240402233006.1210262-1-david@fromorbit.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0345.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18d::8) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ0PR10MB4671:EE_
X-MS-Office365-Filtering-Correlation-Id: 0342fc7f-2ed5-4824-8b62-08dc68558b5a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?eGxkTlV2ZVBNQXJhRVAwSGEyYmJTRmJoMG5oMjRKTHpES3NWWTdYZWxKQ0pV?=
 =?utf-8?B?RVpMQTlnbWNkaHdZTi9kazZuTmVzeGJ1TTAyUDRWekhaNG9ZS2F2WGphQm5h?=
 =?utf-8?B?SmQ2bkgvakRxWEdvM0doVWdEL1hOUjBPaEloaytFVG9WNlRnSnlVK3pZeC91?=
 =?utf-8?B?RDVOWCtKRHgzWnptRWhKR0tTTFo1MVVlVzNMYkpIaFB1UDV6OEw3YUE4SWx3?=
 =?utf-8?B?VXNvUktlZ1FsYURtV2F4V1dpall2OU9FS3hLZElYcVorSjROaW1ZMTFLZ0xz?=
 =?utf-8?B?T0llaXhJeE0wVDBsSlA2MFJzbTI4Sm80UHB1MklzSGZmZExpWG9EVUFZVCtq?=
 =?utf-8?B?V09oZmFtTWlGdWpIdzJPSXNyVzE4ZFNibnpwWDZINEVFY2RwV0lua1Y2bXdY?=
 =?utf-8?B?Tm0vQlpkYm5scXY0OWdKa3k5ZE80b0dOM3RkUldmR295ZERDVnZsaUZuUWNO?=
 =?utf-8?B?cWtHRUN3RXVBSzNCTEZjSVR4M01pTDJldUZLUVU1ZHErSkkvdnFuL3oxTWl1?=
 =?utf-8?B?YWljdE5YNE4vWVZJUEdpR0YxVUVyWWFldFdVdE9hT2VNd2FqQlliZ3NCSWpS?=
 =?utf-8?B?NForU0pLZUF0ZUlMOVRqeFZFeXhuMHp6b1J5TzlJdmJZU0oxOVU1RTFjTzhv?=
 =?utf-8?B?WVhrVmlVc0lkZVFDeStBNHpidW9Uc3JUczViUlNIbFRqRENUVWdnTGRHVVRL?=
 =?utf-8?B?Tmtjd3F3TjFrRVdhekNDSmh6ZzlTWllTcTNjbW04VVVwbjVad3h4YkZCSVZT?=
 =?utf-8?B?dDFwai9GMTZCN1R0bmhZR280TmpOSW92dmYrUy8zVDZRVlQvOXM5YmNpUkZD?=
 =?utf-8?B?V1czcVA1Y2duWEx0L2VzdXhVNWc4SmttMGVjTUkzMDBnNFNvUUl4c3p2MmVo?=
 =?utf-8?B?T1lBT1Z0Lyt4ZmdCZStqM3BnUzNqZ1ZrZDVyTTRJd2dqWTlSZm02NjRiaU1m?=
 =?utf-8?B?YjN1c3hsWktrMFo0ZUF3c0lrZVBkR0hXeTlwYnd5MXludzU0eWZCajV4OUhS?=
 =?utf-8?B?UXZYejJzVmFwb1IrdkxsVks5MERORjZxOXAxMFBNVkFRRnBpWmdwRXdDWk50?=
 =?utf-8?B?K1FYWjRtR2lqNHFBd0ZmZC9NektDV0V1WUtBbWxoejVYUGYxY2x4ZjJvb0pl?=
 =?utf-8?B?aTUwU05MbmFESXZWUmtMdktHOGFDbWI3SEoySXVSR0VwaThxNXlXZzNFa3RZ?=
 =?utf-8?B?d09YUHg0WUR6azUyeUZJZnJ6Y1pDdnl1Ky9scVhNWWJMcHpvdHdpdk11cTVp?=
 =?utf-8?B?Z0h6OG8xODRvWXMvT1pkeDA0RGNwaElIZEpLdEtHRm1qUzlnZlFXU1Q0UVVH?=
 =?utf-8?B?R1ZGeDMvVnIxMHc4T3FFM3pOQUs0QTgwMHljRXhxenlxU251b2M3NTQ4ZFU4?=
 =?utf-8?B?R0MvM3lsNmRoVTBhbEZSWU1jZXZDaDhjZEFxbmF1Y0Zsb2JjVkk0YmJaN293?=
 =?utf-8?B?U2JJRkpKdDJhTFV4U0QyVFBldGxKQ2VidFZPVWV1UXRRZHZLdG1TOWVzT1ZH?=
 =?utf-8?B?ZTJYZnVDVjlYRjkxcnQrbU5TMStuQ2pKSjNVdHlPUEtvbWxPZ1FwRnJJWHpw?=
 =?utf-8?B?bEdhMnZST1R1b3BLbWVWaEI2UG5YbjJXUFJWaWMrZVI3b0VHS0NpTFpna01q?=
 =?utf-8?B?OTNxa2RhbE4xRmVzNldvb0kzU1E1RmEyMmMxZVd2anRUQ1h6cWtNalc1cTBE?=
 =?utf-8?B?RUp5V2QzSE1Wd2VzVDZySi9BWGsxMS9HR2V6dHQzeVJ3Z25YWDV1Z0NRPT0=?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?T3l3Rm9rd3NadUdhM09abUV3T05taW1VWU9mVldqNjlmODU3TWF0UTgxYmhW?=
 =?utf-8?B?UG4rL244RDNvajdNMnErdjVadzFmM21FRVpFNFdiWk44azlmNlBBV2RXL1Z1?=
 =?utf-8?B?YTg4TkVjK1pCQk90eFo0eVFhdWZSSVBFZ1NpTHZaMDNSNXNYV1ZpbDFNU1cz?=
 =?utf-8?B?K3AyK0NHNjByR2ZISmN6WGhiUjltOWtRSnF2YXNUZzR5UzZCcjRndDViVkR0?=
 =?utf-8?B?ZzJkVkZkZWtkUU4zWEVyYWdaem1JMkJIZnQxeUYrc2ppWTRXUDI2bnI2MnIy?=
 =?utf-8?B?VE1yZjZ1d3ZrTHlQVDRJNVZZMjBoSkp0UDJCS3VwWXNXOWxBUVBSRWQ0NThz?=
 =?utf-8?B?Z1RGZlBvczBMRWtQZExRN1hVTG9JbFI1Vnk4UUJqTkZ4aTRmVTBRREVaaFp1?=
 =?utf-8?B?NlYyZEpKTjlLOGpDbVNoY3R2azVuMDlLRllzNWNtUTJ4T005Si9NQ0Y4TDc2?=
 =?utf-8?B?WkdaamZhQ25pUGo5ZU4rY0RyaVY5V2hPMktJQXpEQklQQXQrZjBlV2VRdFZv?=
 =?utf-8?B?TzNQZ1JmUXdxaEh4MW5EUTVwSnFIR200MGlwL0JBVG8yajd1WTVVeU1xRklD?=
 =?utf-8?B?RFNzL3d0VGNNbnJXMmtLU0JmR0ZEZ0w3b1RjQlpDL3phR3pDQS83ZkM1SmFS?=
 =?utf-8?B?NXN2ZSs3WjVtMnNtRXlnSWlNcUFRTTU1eHQvY0IrQ21KMENjdDBjYVZGeHVO?=
 =?utf-8?B?d1R3SlVNcFhaRlE4eWhqemd2ZHZOQnR1amVSZ3ZxVDRlcytncDZCVytjOGxF?=
 =?utf-8?B?YURtcUFxRVRzbGFNSDZ6WmVQUjZ6bG5ZaTFGUG0wckVpRndaNjlpdXJEMmlD?=
 =?utf-8?B?RE9IZXllOFc2YytoNGRKNWNTT1ZPN2cvM0htbEJKa2xyNVM3SnFEbWtuSi9B?=
 =?utf-8?B?NVdINFRYK01Wd1owdnZFTXVDR0YwVHV2MFFUOVJNbGdQOHFrbVByOW8rNlp0?=
 =?utf-8?B?S0t0QlBXa3dPRzFQWXhUSUtRbDAwWnVITEQ0RWxlaFdTYmtsc1Nnb0tMWFZy?=
 =?utf-8?B?NVFISzA1b25BdFJ2T053ZnB4UmgwVitBNXZYVldoS1YvbStQcldiZ3U0Q00w?=
 =?utf-8?B?dXlGQW5JRGs0RWpVOHhjNUhCNXJEemNzNWxCMDM1SVlGYjZBQzdoUkFmQnRR?=
 =?utf-8?B?ZXIwcGw4bEVzN3NmaWpuK0xFczlqRnVPMWJ5Y1h1SlJnQzhsWHlZYUp1TjJB?=
 =?utf-8?B?MURSU2lXK2hZVzBEOVJZU0FGQ1NjUEJIclgyTnJLc252b3RHRlBXd1FkS01Q?=
 =?utf-8?B?V2VJWGl3cWVGcmlxWExPOEZYNEQyQ3piMmhrZ0dwVWt5Q1pRWW4xb1c5elBs?=
 =?utf-8?B?SXprWXprTHV2M1Y0M2lwd1VqRC85Y2FkaDRVb0xnRVd5OHhrM1c5cEk3c08y?=
 =?utf-8?B?emlBYWZZamtkbVZhZkVNSGhyTDdrNTQ0NVY1bmUvaTdvajdweWdsaG9MWWxO?=
 =?utf-8?B?TFVhYWxwQmlSN1o0ajR1VlNmUlFFTkpwQktFNlFyMmNNMG1MTXRmRk1rTkhW?=
 =?utf-8?B?VnlJZlBSZG8yd1BCMTZ3Zy8vQ0xxQ1Y3VkF1TEVCMHlKTnhobkpvcnRCYkJD?=
 =?utf-8?B?Y2RKVFVpU2lqWHE4V3daMk9NRi8zNHhPYnFJUTVqa0tpbW1OTGtqb3lncnVM?=
 =?utf-8?B?eGwvSkl4WG5uWU9HL0VkQjRuaG5qdkNBekVjRlVhS2dZeVFBeGRHSHpTU3BH?=
 =?utf-8?B?STU1bTVGV2g2a3VIR2hyN3RTUktweG1GcFFxKzI0cklYQjBCOUFxN0pINXFR?=
 =?utf-8?B?WXQ1azdZTkFralI4cWtweHdTQVB6VGJSaHBidXo1aHlGaDJIejF5NTdkOVRj?=
 =?utf-8?B?OXgxUmJqeWNBRGxxU24wRFFkdjQ4MzZsYVZvVGtxK2l3VDVQbGhzS0lpUzJK?=
 =?utf-8?B?Wm1CY2ZnaE9OWGtQQUU5U3VRT0ROOUpLbG5ldEpxWUtWNTBXQnBZbXdtVW1q?=
 =?utf-8?B?emxWbG44MjNUT0RFbGVXcmpLeDMxdGNLVnlXOWlLUVpHVmoyUzFJZTZVYUtZ?=
 =?utf-8?B?OS9aV3F4QTlOaVJkc0FJZ1FPaEVpNDRaNmhNeHIzQ1J1OXdZUUVsYnh3TGVZ?=
 =?utf-8?B?UFRUN0hNTTBmaXQ3a3Q1dUI5ZWxmYTJFZlRVNFY1ZFpYSHVWcERvenR4bzF6?=
 =?utf-8?Q?8Gm7ptWZzOYijuwlIca5dKT3+?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	vn2fwCOE+3rcx+slFhD6jIzseL86kgFInJQpJ4NORxfgZgTWYgJZdI58d0lGMKR41fqUEr3ggg617ZR8GgNH5fUCOgV+Q4PUAlV3BR44ePPbl809x7Ww5RUgDxthM2rjir1e0pY5tohB4tq+vWPIlX6B6tOMTDnzlrxXxwgNv8oUWW+2ZLHogwQ/41NzB3xzmv9h1TgqQ6in+gsa4XcGlIZSZ3853Xp4Ej/5tsbWA9mQEHx9xZFqo8P6B/mAPclzPOweDrRodoBnvwLkZMPJwS4ysQdnf9rxXYnQnAggXZMz1F7te9mQ76uJKj26ZVnzg5mHT2cKEraDjW4yBSveQ/ny30XK+PH5xlyILMTAlQ/ukat5C117shQ2fU+C4EqJjTz2fHcUmYNaiboCwwlwzfSpdGl0c9o2ABgI2tQ4W9Fvw3OkMbKf8Y+545HVsyh+mHDF9Jby8hkWXu7EievdaqNJsnjEo0ts4jqfUEPOlfXjqAECiBYanlchv+DRW9cL+q8ZSlxvSEuOt+yeydxHFrZvDLEfFbxLNFRGvKTLgxhtxdSwKnadtMh+B0kynrKYQTUJUI2og1sbfcUuY3W2mpWQ99IcYjQ0nYKKR4u2aWI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0342fc7f-2ed5-4824-8b62-08dc68558b5a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2024 14:06:20.1335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pWch/Nol2tDMI6viGPcloc+aOE1egypQ7jKBTh5Hlp5oylebkMkWyuLnbgBlmX1rqF+Y8xZbF+QjXZHEN+vdQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4671
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-29_11,2024-04-29_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 mlxscore=0 suspectscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404290089
X-Proofpoint-GUID: ww26Ns4kO-cGOzLmSdIJCKNOxfOe3Eq0
X-Proofpoint-ORIG-GUID: ww26Ns4kO-cGOzLmSdIJCKNOxfOe3Eq0

On 03/04/2024 00:28, Dave Chinner wrote:
> Extent alignment is currently driven by multiple variables that come
> from different sources and are applied at different times. Stripe
> alignment currently defines the extent start alignment, whilst
> extent size hints only affect the extent length and not the start
> alignment.

BTW, I have been testing stripe alignment for this series vs mainline 
(v6.9-rc1), and I find that I more often get stripe-aligned extents with 
this series. I guess that you expected that.

However, we do seem to make more trips into the block allocator for 
that. For example, writing a new file with 6014 blocks and sunit=16:

this series bmap:

File size of /root/mnt2/file_48 is 24630784 (6014 blocks of 4096 bytes)

/root/mnt2/file_48:
  EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
    0: [0..48111]:      547456..595567    1 (240768..288879) 48112 000111

The block allocator gave 1x 6014 block

mainline:

/root/mnt2/file_48:
  EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
    0: [0..48111]:      547440..595551    1 (240752..288863) 48112 001111


The block allocator gave 1x 6000 and 1x 14 blocks, which are contiguous.

Let me know if you want more details on this. Obviously more often 
aligned extents is nice, but more trips to the block allocator isn't.

Thanks,
John




