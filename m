Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B3412E40
	for <linux-xfs@vger.kernel.org>; Tue, 16 Jan 2024 09:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fvzhXHmV";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ntntVnOx"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40G6iEnc001019;
	Tue, 16 Jan 2024 09:26:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=NW0S0FHE5MwzsYps4t2eFcgLWgmudolIxOtn91oxm6s=;
 b=fvzhXHmVUbftiZO/kQR7d4U6maV5m0VRCH4vMUmowXNjaOOZLKGH15CP0c7Y+5iQ8CKU
 Wf1RiW8RBjhARQ/Vr7zRSnCtgX0dS9D3ESBF4SuxqYRMHgHZO532wU0T+OCI5b2oUV3u
 Dk2SsBlNqRh44X/lSw6I2XNvwlawBlRwSPIuk/NiQAqXrJ6hkYpgCdsIJBKKCGjkcFLR
 Mdx0PxN+62dTpWu/NyU+VJKF5/Krxl+LwO0V/5ZJQVrDJU5iYJmcYKWYoVi3BDGKFUCB
 iDFXTskJzw3YVYCm68ZHTfmK9FiA6cAUZp6HafoS/+W+TpfYCDU96SMngAhK4BnEK4d0 qQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vkjb9v4q8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Jan 2024 09:26:51 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40G9DBLm024959;
	Tue, 16 Jan 2024 09:26:51 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3vkgy7qpn4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Jan 2024 09:26:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nLvuxebAB3TQwe2A4k66LkyIoAOhIsQQUz2ExAjGyNYVzAdkollgIgxpQGLSOCuiEaiRd9+pRYhu8DGAp3lBWQOODawBMo2ctLuTnzx49hwihDydTLeRM1s767rxQSpRkFIkJuK1HYaBOjWKLpPlC1Rk4S8NQt3GGcmqGUkK3RzrHa05F1ckxIhRfnCddddAFLTrJp7GWlSaHmiDvBxpYm4U7ibZfFjDkf8Z2wSKBx4UBzfXBXEPM6cM5aZ/vun4Zw4f5PZOV1HOHp2mGB71/fsKI6ZnST4AOiYg3suRFRKTBTuz7I+vO08CCPN4qoRLo9BPZnVL21o/+eEP39q7TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NW0S0FHE5MwzsYps4t2eFcgLWgmudolIxOtn91oxm6s=;
 b=JWqtPcnc281keMtsLPyo8SNk3OkN/1WvRpBrB/yd2XD0Qr5wFsqSlYiAtXHurjcwv7VTWuNzxjte59Z6Opipl+SmrPXe5SdU+FRyDi18JoYIBBs1GzvzgSX2XF5HTKeIonEzWzzf3tD/DT/E+S/+AO96sRAgL9jm6MqgSsfdmDS3z/CFiRC38CSi9VXM8946wQ5EB7Z9NrAddZzGjdIK8tvaCHRVtrYCGuBxCsy46Go5w9587oBrjRZetvCVNxdk5f4Cvyw8WBVEFOwaa/fDtM3SZwE1gNxYU0iqwtcoVLcMssODhxok7qgXRWxzb8p5eco+nuT/v4WpdjHmFynhFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NW0S0FHE5MwzsYps4t2eFcgLWgmudolIxOtn91oxm6s=;
 b=ntntVnOxLRQk0UH8YBM4lgcLebdgndDBjd/yFbJZJNbsypzQ6kownR2Fak/iPy7ocjH87KLpbQUZoG4b4WVPk9+MkGBbzxDbmQSuCDwDtFuf4mBJ19QoL4zeuEQr3oZZZZ0RpC//MvOT6tEE1H+np/A46JHAHnbP6xhcY4h9W8M=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SA1PR10MB6413.namprd10.prod.outlook.com (2603:10b6:806:258::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7181.23; Tue, 16 Jan
 2024 09:26:49 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5d80:6614:f988:172a]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5d80:6614:f988:172a%4]) with mapi id 15.20.7181.022; Tue, 16 Jan 2024
 09:26:49 +0000
Message-ID: <8c8d51cb-88fa-4fb4-835a-0d90ea56dd71@oracle.com>
Date: Tue, 16 Jan 2024 09:26:45 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] xfs: make file data allocations observe the
 'forcealign' flag
Content-Language: en-US
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de, david@fromorbit.com
References: <170404855884.1770028.10371509002317647981.stgit@frogsfrogsfrogs>
 <170404855929.1770028.8502538039360735032.stgit@frogsfrogsfrogs>
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <170404855929.1770028.8502538039360735032.stgit@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0101.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bc::10) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SA1PR10MB6413:EE_
X-MS-Office365-Filtering-Correlation-Id: db6172d0-4824-4480-ceb5-08dc167543f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	mC7PJS0T8fQJYsT3UWmElW06GdMaA9gvLOM+kxtr+TNAqQWRGXo9ihn/Inz3za6cRRSLUFXcvjN9J9jKVnmEs1S9nZpwOZsHLmHaQYiIiO+29GCqX6MkigAzudCWuKV6Bq15/9VM8nCJYNPgKrodIpsESJRcU8LUbnGMTtNWJ+NyAs0rZn2oA9BZehdeKFrj1QYXghdRAeFu4KAx6mrcbTCVJyeyO+1SOvV9NlBtB/Bt9/k9jbGpkAtkHfhwWDglwTu1Yf4FNGX9juMV4St5tyIhUNjRlFIip+eHjicByNNKBvJWMYilz1OMMBWDXE5+aefAuPzw0lPxKKox4AWW0cQN3KfMwZYt1S/AS3T1/mXp5MRSr3co3TJRr1uGmKvJ+4RC6ncsIMVQeJEh1oypUhWlmKeNfp7Jadf/+YoGZniEZi7iUNpifzo2tTHkzkvaxoi8Df7CANeefMvGgYnrjjgFMahXCi+/zW4GqU2yhPQAeTrFbuu5czPfnWOtYfeC7lbAKYINzW0m/Ippuf67+qS6Nldj2T2KlyHUYwL/pkZNvMeK/iaEpW/jwpQGX1V9wsyrLQM/Dm7pFg4jWPb/l2o6OsES7eO9sawVIOhIEbr26sjN8h3hsHEiXzUQQghmVvDosmLfpzgGYIL81bQhJg==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(376002)(136003)(346002)(39860400002)(396003)(230922051799003)(64100799003)(1800799012)(186009)(451199024)(31686004)(41300700001)(36756003)(478600001)(6666004)(2906002)(6506007)(36916002)(26005)(83380400001)(2616005)(38100700002)(6512007)(966005)(6486002)(8936002)(86362001)(66946007)(316002)(66476007)(6916009)(66556008)(31696002)(5660300002)(8676002)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?OGxrZ1hiczZvNTU1UzZyNEZteHM4Q0ZZdkdZaXp6cWpOL2UzRy9DbmxPd0VG?=
 =?utf-8?B?bVBhR0QvamJnbXM3bE9pRnlrYXArRWhkOHVFaHc1YmtNNnFHUkxNK3NYbkZk?=
 =?utf-8?B?SmVFbXllSmVUUTdZS0xtZkx0bkhSM21ZRjNNWVBqM2VHYzc4MFd5M090WHEy?=
 =?utf-8?B?YmRmd09Ucm5jdSsyY3FjMEFESTdEbkVUNGsrMW1POXNTZW5OSjB2eXpqMkFx?=
 =?utf-8?B?QzhZUUFibTJxOUJxSDhUVXdrSmw2cy8rZXA5ejhMdEVXcCtxZXkyNklOZkhH?=
 =?utf-8?B?bjJKMmxudE5Gb1V5d09MK0Nxc09zZ1A3UFFtMG5HdGwwb1ZVb3pCeGdScm11?=
 =?utf-8?B?OHFESzIrb3hNbU1nbWVPNnJVZVF0Q3FXeXpNWktsQ3dpamJZR2VYb1FGaFRL?=
 =?utf-8?B?ZDBNZVRnWHE5dklBQkR0ZmxQc2xUWW9jcXdpelorSzR1Tk1aelBFSWttZVZ2?=
 =?utf-8?B?cThPV0xlTmh6clNabXE3ekZsUkpsUGlpcVNKaEE3RnNhYmpJZXgrMXdaQWhJ?=
 =?utf-8?B?dytTRFdNYkxXYmVNazR3MWx6c2tiY25kdmtDVU1QdHNzYWM5eGtHYWFKejhz?=
 =?utf-8?B?TzhPOFlBY1BuSHBqNTExTmU5U2o4M05FMUN4dHRFNklWdXhtM1Zzc2pRR2xi?=
 =?utf-8?B?Wm80d3NVQjZVc3psZ0cwY2hCQnEzaFRLQXVrRC9YYnJyWlRlNFluNTlqWDZO?=
 =?utf-8?B?NzRna0RLRTdRcm1qanFYamtJZjZ0eFp3Kzk4WXpsRmlSYmllb0V4TVBQZFF2?=
 =?utf-8?B?Szh1bm9KU2p0TDBEK3M2bStaMVFGbjNMOE1KTEZKUi9QNWx0WG9HK2tGTXFQ?=
 =?utf-8?B?VmlVR2JuMVMvMkRJSzMvR2lkVGlFUGIyT3EzcWFPcVNkZDIyOXhIckY1N2JJ?=
 =?utf-8?B?T3ZhRnYvM3lLSlNkK01xTmJlTVV6NGJiYS9QcVgzYmE0Ym45b0llZS9SWlox?=
 =?utf-8?B?ZW96VmhmNHlYSC8zZ1diS1ZMbnViWXcvTFZuNmxpUytvaS9rbnhRVXFjQ3pJ?=
 =?utf-8?B?d0drdlh3MDR6TllWVG1KcUs4Nmw2QWxHa3hFNVV3bFQ4NXJOZWFzNTNSNW5r?=
 =?utf-8?B?VjBhajBYVm1vNXpiU3VyWjhEYVFldWZQalBIS1BQV3RPOG9SQ2FMOWFHSkFB?=
 =?utf-8?B?dHE4TGE5LzJkaTZjby9BSy84bjlQT0RyK213cENpNnl3RjZaK0NiZzQydExv?=
 =?utf-8?B?TGFWSkVFRFp3N1orL0U4TGRISFhXUHBxTDNhQ2tkekFWc2NJSkZsVnZqWG9V?=
 =?utf-8?B?Y09aZmh0dVFuQXVweURadzdaN0s1SHlzZGU1aWFCK3EyaE9PY3hDd3hBd1NH?=
 =?utf-8?B?VUtqOENEc0hnUVM1cmx5TmhpcE8rbFdhNUNta2t4MGJnb21oa2krV1BGU1Fa?=
 =?utf-8?B?VmlaMGZrd3VoSmpLaEJjTFJkNGs2QlhlVzlKQUJqeXhFenUwZUtrUjJabHZs?=
 =?utf-8?B?YUt6MnMyU2hpNkR2L3RoZHNvSWpQTnFIMWdLa251dmZhdTQ1Z1BRbmRUbDcr?=
 =?utf-8?B?UDFWK3h6RjgzWTFwYmxvSERGRVllQ1g0dStibWhjamxSY3dRY1dYWXg4US8r?=
 =?utf-8?B?QXpPdE5NQ2I4OElZT0x0dWV3bjJWeCtSY0FScEdRNXhsNC9xekRMOWg3TTN0?=
 =?utf-8?B?b2pFMWJrVEhha0pMdzZSZjA3cEp2QTJjVUZJTjRTYlFGVGFDdlpzUlNyV2hk?=
 =?utf-8?B?TjBaM29mY0Q3OXdkUm1VbDR0Z05qVFUxUk9oeFFXRkJIZlpGYjJTYVBBQmlP?=
 =?utf-8?B?Z2NscEx1NFAxaEpJWVMwZkdIOXV6d3p4QnFuNGg4a0VCRit3UFJsMVJBSm40?=
 =?utf-8?B?b2traHhSM0J0K1pFM04yMHNrR0R4Yy9kVk5KaSsycjJpYzZwcldUNnpXOFd1?=
 =?utf-8?B?NVhnOUZEV2U4YTZTTUsxWjdtQ2w1eHk1UkdBa0VsbWQ1bHh1Y09vdG9IQ0RS?=
 =?utf-8?B?ZUdUTFNCZ1d5SVNYM215K3VLcXJvKzRVSUJ6THZia0lqVUV6cmhCVU1nUW5m?=
 =?utf-8?B?aVg3VE5JNVN5YnZQYmU0K2RoRTF6dGJJdTM3MWtMQUZHc2d6WGNqSHFtbFZ4?=
 =?utf-8?B?d294OHpZNnp5Yys5QjlxT0U3VW9vejA3SXFhTFJWYXRUamtraXd2ektuUlk4?=
 =?utf-8?B?L1gwekZ0Q2pPWXVVbW5HRXRvd2xnVUdXR08zd3VUMGl5ZmU3UkxkaDUyMUJG?=
 =?utf-8?B?VEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	gs7khuTV21Xc9PO3hsgCzfb6oo64oTQKA8vmlXqLlKqz/w4H72c+GSbzw+jpKEnplGs57i/77F5A8oHZo0RGr14PCh1Sm2NmoQvdKE1Qocs6Kn3ANn/sYYB5ufB8xAcgXOeFAzbH2NqcTgIjg7gMBNitPTkj79xbhzsf9lPykPxISVMqx0UCWMPe7gudxDY2GeRyiujAU96E9sgnBbFO0yCGDli9XGP/4IssSB4wgRORP2w/qEBfRzzb6zefZJX4fmxBVLrrSUy8vlD8ur6jgQg/ZRerWKxwYCH7NtY/3y65NWl0KP0aAQ8VVSqhdePC9hioYcA5OrLWwq15sYPAq7KkfwdQytPNgmog0QWTRGIWhSBfWdKsUAX/zPN5IqAVBCjD3WVHoyN/2QQMwvd4nGEWbOvLhxYAihTTxRW0xB6e1VqdCyGY/EwxwKlnlpD20N4R9vqBXOa2ksydHy72h4tcvpBGHR+gdJ7nxqgmLebb9GqHr/cHnvN9yghHoj5ofELSWmn6+o3QpzElXKWY8p+fMHVjIT5NN0s8CtoWMT4jWOjB8nHOyWRIQ9ACQEsQXhyMG6pud0rXmtA1suliED3r/7jaPmUIanMNHgV+u1I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db6172d0-4824-4480-ceb5-08dc167543f8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2024 09:26:48.9340
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gGAyVSMwI6E80l1s/mojMqegFZYbMWsi96pwqtfKYWieAyQQbvny6DsCj0aOKBzIaYHtQ9+ZRZFLTiIMa8tk7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6413
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-16_04,2024-01-15_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 spamscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401160074
X-Proofpoint-GUID: 9IAWLDQORZDJ3Cin7AaScgtaL_QwQbNf
X-Proofpoint-ORIG-GUID: 9IAWLDQORZDJ3Cin7AaScgtaL_QwQbNf

Hi Darrick,

As mentioned internally, we have an issue for atomic writes [0] that we 
get an aligned and but not fully-written extent when we initially write 
a size less than the forcealign size, like:

#/mkfs.xfs -f -d forcealign=16k /dev/sda
...
# mount /dev/sda mnt
# touch  mnt/file
# /test-pwritev2 -a -d -l 4096 -p 0 /root/mnt/file # direct IO, atomic 
write, 4096B at pos 0
# filefrag -v mnt/file
Filesystem type is: 58465342
File size of mnt/file is 4096 (1 block of 4096 bytes)
  ext:     logical_offset:        physical_offset: length:   expected: 
flags:
    0:        0..       0:         24..        24:      1: 
last,eof
mnt/file: 1 extent found
# /test-pwritev2 -a -d -l 16384 -p 0 /root/mnt/file
wrote -1 bytes at pos 0 write_size=16384
#

This causes an issue for atomic writes in that the 16K write means 2x 
mappings and then 2x BIOs, which we cannot tolerate.

So how about this change on top:

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 731260a5af6d..6609f1058ae3 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -685,6 +685,12 @@ xfs_can_free_eofblocks(
         end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)XFS_ISIZE(ip));
         if (XFS_IS_REALTIME_INODE(ip) && mp->m_sb.sb_rextsize > 1)
                 end_fsb = xfs_rtb_roundup_rtx(mp, end_fsb);
+
+       /* Don't trim eof blocks */
+       if (xfs_inode_force_align(ip)) {
+               end_fsb = roundup_64(end_fsb, xfs_get_extsz_hint(ip));
+       }
+
         last_fsb = XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
         if (last_fsb <= end_fsb)
                 return false;
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 0c7008322326..c906e3a424d1 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -291,6 +291,10 @@ xfs_iomap_write_direct(
                 }david@fromorbit.com
         }

+       if (xfs_inode_force_align(ip)) {
+               bmapi_flags = XFS_BMAPI_ZERO;
+       }
+
         error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write, dblocks,
                         rblocks, force, &tp);
         if (error)
lines 1-38/38 (END)


Which gives:

#/mkfs.xfs -d forcealign=16k /dev/sda
...
# /test-pwritev2 -a -d -l 4096 -p 0 /root/mnt/file
wrote 4096 bytes at pos 0 write_size=4096
# filefrag -v mnt/file
Filesystem type is: 58465342
File size of mnt/file is 4096 (1 block of 4096 bytes)
  ext:     logical_offset:        physical_offset: length:   expected: 
flags:
    0:        0..       3:         24..        27:      4: 
last,eof
mnt/file: 1 extent found
#
# /test-pwritev2 -a -d -l 16384 -p 0 /root/mnt/file
wrote 16384 bytes at pos 0 write_size=16384
# filefrag -v mnt/file
Filesystem type is: 58465342
File size of mnt/file is 16384 (4 blocks of 4096 bytes)
  ext:     logical_offset:        physical_offset: length:   expected: 
flags:
    0:        0..       3:         24..        27:      4: 
last,eof
mnt/file: 1 extent found
#

Or maybe make that change under FS_XFLAG_ATOMICWRITES flag. Previously 
we were pre-zero'ing the complete file to get around this.

Thanks,
John

[0] 
https://lore.kernel.org/linux-scsi/20240111161522.GB16626@lst.de/T/#mbc6824fbe9ce62c9506aa4c3f281173747695d77 
(just referencing for others)
