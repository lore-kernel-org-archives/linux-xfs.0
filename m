Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F04453E169B;
	Wed, 22 Jul 2026 03:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.178.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784691146; cv=fail; b=cZq+2MpjHpqdDOgomR4Znu7bNgU6pDRG78CTBg0Qjy87MRN24z/Sxhsgs7tIcWYQqD0XmfJUtFhBYpKddohUtfp7ZSmraxY3jazcRe6Vr33Y6TG8DmIDG6Ss5QWaZY6rKt/I/EwTaI2r6yDpdfjugKcBjnblNpxmKD6dXGL4aHs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784691146; c=relaxed/simple;
	bh=5DPPW1vFl2Md9zYCLqdeRHF/dIaRgcGETkKuloQu/wI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RU+nixhBFGCAtVfFg1Ong4gk3DHBMi8jLrejXmVlwMiORDxK43T4dk7RyNrhXIUEtzO0SkRavtKETaHIIza+CYjYxAxy/nCnrhU8QGfn6bHbPYngcNDIQ3EsfHn2rkItYSlu7he7I9gL1pQHQAGgpEMjiPdwH18S5ecJ/igVaY4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=unknown smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=E4Bj+gUd; arc=fail smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=tempfail smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="E4Bj+gUd"
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66M1EwF03838136;
	Wed, 22 Jul 2026 03:31:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=Rs15JN6Mo3Ql/ic0CANpEhPa94sGRPafBM/AQqOHYnA=; b=
	E4Bj+gUdjEsyxLiuXG/zFO8LMWnFV1x1vxfqZF4rqKsXPZREK9FoGHAtagre/AxR
	sOtc56vRucsOSI2NnhobYPUZ1orY2549reLx5Y1Mz1Bge4yMMPFRvI30MaAiQMJO
	IXDvotUrViQX8QzqI//kiYYTds9sz5pCMNEr2yC8JX85PtmFRprO/CwmHMO4a0i7
	3vfAE48oCyEE5HPE5CH0Ni08mWDBWiXv9va4MbhAoRgAdAOU2Htix3sVN6/eHMOb
	bxWgk8LkMa5Ih5srGs9kjDmpeTFSH1ku5gSeviby5qhdfBGxed81vMTjgSVe+Gav
	H7ZtoCew0h4kYohK7hjZtA==
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011039.outbound.protection.outlook.com [52.101.52.39])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4fg0f5f6my-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 03:31:47 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Uuq8nf2ht9U9zQRo9PvTyA7Owx6qv+jRSJkgBfkLQxqs1UmcuVdfVMymZ0vuaYVrbWuy9K3WYP6ojiIYBcFwCOvGeifLkPceX+NAiv36N07eTOOnu31VyrC0PpfulazrVYpq+ScoBJes9XZe5IEiR36jEk4cI+xNs9602cLZaRWzwMTOFPX4zuPE9jE5Ujz3HJ1KsmDAtY5Un2aV0aHtJkxz5i32QYkWrR0WhMmQ9UyYXt3EuIkfBB/09ZMKk2RNNgpaDsOd9YRkWxbYA2XqA2fT2NCPM228P8r3+sptgSPRjhYXpMcqt506sZZ7bpDD4E2Kc33FgURTSaKjiLvG5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rs15JN6Mo3Ql/ic0CANpEhPa94sGRPafBM/AQqOHYnA=;
 b=PMu58+H/lkr7mppmGlmagXN8NfFqPJ9tsaqCWMjhHw9hgAgDU/p7RIxEvEaQWdqIJUqaCGWmKeKo1BowbfqJkArOquUNwm8bYzh1CJM7d8WI2rm9NMFSrP6O/0hkgPmuRUF6xtpdZNkaSF2+0k2bhEOpOSlU4hoTOI4UzERPUAgxjIFPLkd4Nw6CJ7FsqnMSo5SqxgcQOczcC/Q+xK9zuknqmMPVhDJ991snO11KFzCT1HHSo/1Es5sqefKJJc73fR2nd3P5mVxvDg7rAVi6BIrLGwEbE0sGc32nClHkaNyTtf97QPtP4y8C7XnqVxM93LI4Oz2bdSYgJSfDULX3kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from CH0PR11MB5332.namprd11.prod.outlook.com (2603:10b6:610:bf::17)
 by MW3PR11MB4635.namprd11.prod.outlook.com (2603:10b6:303:2c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.18; Wed, 22 Jul
 2026 03:31:44 +0000
Received: from CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13]) by CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13%6]) with mapi id 15.21.0245.009; Wed, 22 Jul 2026
 03:31:44 +0000
Message-ID: <b7930582-b75f-4380-b5a3-e0bb7fbdf841@windriver.com>
Date: Wed, 22 Jul 2026 11:31:36 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [xfs-linux:xfs-7.3-merge 37/54] fs/xfs/libxfs/xfs_sb.c:1473:34:
 warning: variable 'bp' set but not used
To: kernel test robot <lkp@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-xfs@vger.kernel.org,
        Carlos Maiolino <cem@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>
References: <202607212237.Pzw1sr5k-lkp@intel.com>
Content-Language: en-US
From: "Zhou, Yun" <yun.zhou@windriver.com>
In-Reply-To: <202607212237.Pzw1sr5k-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SL2P216CA0073.KORP216.PROD.OUTLOOK.COM (2603:1096:101:2::6)
 To BL1PR11MB5333.namprd11.prod.outlook.com (2603:10b6:208:309::23)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR11MB5332:EE_|MW3PR11MB4635:EE_
X-MS-Office365-Filtering-Correlation-Id: 099540fb-39b5-47be-ffbf-08dee7a1c02c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|18002099003|22082099003|10067099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	0FRTAaT6gJmtwd0pSETaiDhuwtPHiSgbhMBom3FDDK7sdmPbSDVUQo54wmT54uNPHA7Gv0TfD+AVh30eoVshCYiPq3MHwvS7gC+I3PrAK40j6t2KWA35bpKZcCrZp3yxHvU5hYSjNsfgcFswtaxUDXLfx5rnFq8++kTq4cK/3fm7gTX2oiOy64X7eC7ZbydXxe/ZYCUt/PC1J8fJy+gDR0tK3LgWcjoO1yLKiuGAmaDUlAN0pPJ/YK5BqF2PUqOU564cQ6iOtGpO8xuRpWsk/JDbaf7LHcREAzvJoF/WJsbsnYKp7iTBga3mvODkvkgkZMiamieVRCOu1dLd8lJEaFHuCsDEPEFPy8/4Qr/A4UwmbD6Efj0unsQVYYnEzoi1g8UlGKtCD8GYs0VZDbaP330BChfFGkOWCR7mn/XArfkqUpBajjOJRBX6bchxesDjQ2St6A3DHbxbrZWKTwk/zQlvzGgHMXLxKqLS8m4vZGTHARY4kgSGdrlZ94T6jxxysylbLF2+STM5ajOQwhdaAda/Lcyyyk5PUgR48HTbgv4sEBr3J5mDRuKjFbevc/MeaZYF/jdaXJrQ6b4jVJUYTgBcLBiEin3Gr/wULzz5aK3Mjk46dFs/bOkavlF0tE+U
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5332.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(18002099003)(22082099003)(10067099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TnF0T1ZuQ2JvVTc3c3k2STNydDAxMGFTK2FBeDN0bmJ4ZTMxQkdnZndoMklH?=
 =?utf-8?B?eEZwclAvclBLcVZUcUJ4Mk1sYTQvSDRsMG9tL3hiTVVJNDk1Y0E2anA4ODk0?=
 =?utf-8?B?YmswQ3V5RW5iMHY0YTJGVmZLUjRVelZ2T3pYd2RqZTh3aTRmUWZWSE5XWnR6?=
 =?utf-8?B?Y0FOTHFKMytraEJkZkxzZXBVQlU1QzNQYWFFdU96WWw3U3FtdThHSEZNazhG?=
 =?utf-8?B?N0JkelBwZUNjeUVDcTFEcENyOEY3ZE1BYTNjbTBCck9YaGZuL2NWaERVTnow?=
 =?utf-8?B?OHNSbWxWaFVtODhYQWFSS25LdXhWd3hIbE1CS3BtK0krVmVlWTY3NXpKZFZR?=
 =?utf-8?B?b0pmMXliSDVnR2R2aC9iakJtcTkvclg0UTJUUkI3dVR1QUwyNHFoNHFGTk0r?=
 =?utf-8?B?elcyM3RxNGhrcXVhR3FjU0w1Rm5sM2pmbEx5ZUtWaXZNdkYvdTdXNFRybmZr?=
 =?utf-8?B?TlpiQWpmWmRNMzMxN2E2YkJsR3lpUjZNVU5zNkx0TGozdkxLRUE5UGhzMEUv?=
 =?utf-8?B?VkN1aDBUVFB0SHVmR0xhR1R1TGUrVENRMnY2ZHFLTVJ1YWhqblJDdTlzeFJy?=
 =?utf-8?B?eG1RSHlFa3VXdHNabXhUbER6bUE2My8xK2NPMUdvNlZyNGVXSmhhL2NHdzVQ?=
 =?utf-8?B?VG1WenlxdmZOLzJmMUVGbUVWN3dMTmVVNG9iTTR0TUZvbUhuK0xvWDNyVHBx?=
 =?utf-8?B?c3hFSVVHTHFFZkZLOVNxcFVFR3kxdjlQL0E0cWZlRDM5bktyRlNYNXBPYmZO?=
 =?utf-8?B?dzBkSEl3Uzk1bUpWczFGVlZEa1ZTUGc3eHFJMkYzUS91c3NuU01Kb1VGdlB4?=
 =?utf-8?B?c1huSktUNFQ2WU5qbU05VHdHdTdPYzJNSU1taVMvbG13akdkaGw1T1dNUDBs?=
 =?utf-8?B?T0Zpa2FueUxMbEk1dnVKOE84bitoZ005bVlTN1lkK1lidXhOWVpUb2k0WHFW?=
 =?utf-8?B?elNmZngxelZDRkxYcGtQSTc3TFVlb0hIL1lqb21TTmpnVzh1U0xFWHMzamhn?=
 =?utf-8?B?ODdSOTlGLzZhSFpITU5NeHJ2KzFYL2FGWUlOZWZrWUdlL24vSHJTY1UxZnNm?=
 =?utf-8?B?TXR1bGphVFMrWUNjZmVzMGpVMGlpVGI1VUpMZXZid0NNV0NyTzR0M2xaVDVF?=
 =?utf-8?B?bE9nNkhwWGIralFLTkhlMVcxUjhLNDlLYkxtTEtCL0RLVWppRWxCQ2E5MDRE?=
 =?utf-8?B?WFp3dm9YL1lyN3FPTjNza1dad2dWVkVodXAxZ0gxS0lOZ3c1RXRicWpRZ1Fs?=
 =?utf-8?B?UTBrR0xMNFJNaytObU5QU0ZKczBlWGRWdmJvblZJNVNON21vVHVpQndvQUNm?=
 =?utf-8?B?SjB3S25mQ21OVGw0N3RydEozT0NmcEh3eWlGWjJjQU5zR0V1ZmlpSnVublAv?=
 =?utf-8?B?R0NIZmhlMTU3c1lwcXJMcC9idW1rTVdvdFpwMVpRSzV1Y3RKbGVCS2tmSGE3?=
 =?utf-8?B?RGQzN2ZPR2lBYVA0K3AxdHZobmwvTHRmbm5tZFFOelRhRk5DWll5ZFNZR3hU?=
 =?utf-8?B?VzJVcnVDOVdMczhSNk1wekg5UmJOQXhZNkw0QnptcUlFS01QU3pZdGNGalVW?=
 =?utf-8?B?enVYQXJpYUtjdmlycU01Q09meFVoRzZnZWVSQTRlcmVVNnAwUkpzWGVzTWQz?=
 =?utf-8?B?K3QyUnhieDRDOFlydmtQYUw3VVVTNzEyUk5PK1ZwcjV4SjFmb3lyMllWbjdY?=
 =?utf-8?B?VU5hNnQvaUp3SElrSTJtZmR3dVRyZ1MyYjVEcUo3VVdQVGJ5T0FhSnRreTM0?=
 =?utf-8?B?YTZzNDJnaHJCN2t4S2Zad1hlOWJCQitTZjVnTHBRQWcxMzFHZXR3LytGYkF1?=
 =?utf-8?B?UEplQlJxR1FlM0xwOWdpMmRTcFF3NU1wckxvcFVoUkRPUDgzT2RJY2hjRXJl?=
 =?utf-8?B?MG41L2F6KytjSnFqczFGZGpVYURlZWhNV2JPUC8xbittaHFHMlJUWkhKM3Vz?=
 =?utf-8?B?OHFSWTJZS3Z0RUs2SVd1SHl3alFybjRnNHBWWDh4d2lCUmd1Mk1EY1M4cllJ?=
 =?utf-8?B?M1NvK2NIOGZtbEZVM2x5SGNCMHhsL25BaTJMbEQ4QzM5M1hhdXdrbnVKNnVD?=
 =?utf-8?B?UFNKQzVRV0tQTUxPSGxucHZjUkh1RkpVQTRKQUpvdVNSUS9YWFNuK25nRVA1?=
 =?utf-8?B?MEY0OGlrSUFySks2aHNNUklYV1pCWk56aU4zNHVCLzFIZC9sOTRnOUVkdko1?=
 =?utf-8?B?dWJ1VGMweFlFNDhNZVlxdnJvVnAxb0JCZUM1NERIM3dlazlhcGN4ZndvVVZh?=
 =?utf-8?B?aEx2R0k0eHUzUjFUMHFrWmZLNkVwTjZ5ekszdzNlM2tYZTB6YkFKZlhOUEN5?=
 =?utf-8?B?ZUNpcVpFWkIvTk05NW11TVZOTnVvbDhmVk52MnlodnJqK1Npb2V6UT09?=
X-Exchange-RoutingPolicyChecked:
	fhgu56T9HsWXbwHlQhWLhuE9HsTk/SW2kNtfL15G6F4T8PMM+tgxaJDJjDL9BQh3QnJu/B/nYtyKta485ql184Opa9K6X01xyLH6J6hKMc/hmUq9bBnoseIdty7c+aFKrJU93O+X5yT94T99Li+LtYyItba/Q6LLFzxzpHrmMEBjCfMkjifYxaC3lGtUpVWt61VA87OAFiA5VKOI3xzRH4eKIseBQ2n882MBQTWfbQyGhrsC0IPppr2darmLJy/XLXt0BAwXEZ+i3nlCOhehBDHjxzt7xiw8Vru+gTpUebydiwbEmUX3hKn9q1aClCWhyOVNx2aRHNPPMC0AnAsVJw==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 099540fb-39b5-47be-ffbf-08dee7a1c02c
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5333.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2026 03:31:44.1136
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FSGE9gwE4Ue4MszEBGjpeHufzHg6epAfQ2rSA7jpxh3Kgf5XRToUgLn45g6vbtYzQiH6wu4L9aF01v+XeUvwCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4635
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIyMDAzMCBTYWx0ZWRfX87V5uO54LydB
 d6r6I3MOk/xZIckeNSSj3I2lv9iu6+Ffvdss07fjIWLbZrVynON7LWWqhTgHD7iCd1k55qZKxk1
 XKkHfNLHRPGggP5yRSD8jsbzRh6m6oJJvQC17R6lZ06czRf+MzxtTUyT+rSdtOLS+SsqKTqMci3
 NfQ95+m0ceuRnbflj76h7WyklkriQlwHBqd6AoVeRVPC7bsk9s8VJOVouBwA+/QSE0KoAb+We5c
 DOZSVd2/TmBWfggv87F4NJNCd6ZIDpM3HQLrRtbky2odfFePHN21zNYV/NSj60V2BBrLKT8jvPM
 zHTi1BlgynkNst6X+/UKFLqLfPnFq0ggLYNVhvueM+Y+KEcGx7pXXYmeZe3IK8OrA5zw/h7z85P
 ZGb4ZA9xL/9wrtHnS7El4AKlCPXI9pq65MOPW85xD+GUJD9vDGjYLyvQqI6uKKDvcv7vbtuY5f2
 Ck+UQeqSaQurohTqMBA==
X-Proofpoint-GUID: xG_eeXjQ6HAxehzk81rkb2g8urqV5HVE
X-Proofpoint-ORIG-GUID: xG_eeXjQ6HAxehzk81rkb2g8urqV5HVE
X-Authority-Analysis: v=2.4 cv=IM0yzAvG c=1 sm=1 tr=0 ts=6a6039a3 cx=c_pps
 a=GQEFHjoEDIuuLG6+yye4Mw==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=fTW__CHxibyLmBMfj2wP:22
 a=VwQbUJbxAAAA:8 a=i3X5FwGiAAAA:8 a=QyXUC8HyAAAA:8 a=F5zg2Lcm_Ke2ylwqDXMA:9
 a=QEXdDO2ut3YA:10 a=mmqRlSCDY2ywfjPLJ4af:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIyMDAzMCBTYWx0ZWRfXweNHUHEl4Y8T
 jt0KDEBxy5QJP1AWgVdRVTNQJvdbEVhwZS0mpff/qPus38HgENpOI9w68MW/vDppff493/s66gi
 1woot5aLgozaxgikTTN7WFBknOYHfoXvvxEn6tPCeT7XZdFIOlZs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-22_01,2026-07-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 spamscore=0 clxscore=1011 adultscore=0 phishscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607220030

On 7/22/26 04:35, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git xfs-7.3-merge
> head:   97f34168769238b1fe4412229c99f1a78364f6f9
> commit: b9ad0b9891dd0ddbfd8d9bfc7a55b0b70e9871f2 [37/54] xfs: don't hold buffer locks across sync transaction commit in xfs_sync_sb_buf
> config: x86_64-rhel-9.4-bpf (https://download.01.org/0day-ci/archive/20260721/202607212237.Pzw1sr5k-lkp@intel.com/config)
> compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260721/202607212237.Pzw1sr5k-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202607212237.Pzw1sr5k-lkp@intel.com/
> 
> All warnings (new ones prefixed by >>):
> 
>     In file included from fs/xfs/libxfs/xfs_rtbitmap.h:9,
>                      from fs/xfs/libxfs/xfs_sb.c:28:
>     fs/xfs/libxfs/xfs_sb.c: In function 'xfs_sync_sb_buf':
>>> fs/xfs/libxfs/xfs_rtgroup.h:362:41: warning: statement with no effect [-Wunused-value]
>       362 | # define xfs_log_rtsb(tp, sb_bp)        (NULL)
>           |                                         ^
>     fs/xfs/libxfs/xfs_sb.c:1483:17: note: in expansion of macro 'xfs_log_rtsb'
>      1483 |                 xfs_log_rtsb(tp, bp);
>           |                 ^~~~~~~~~~~~
>>> fs/xfs/libxfs/xfs_sb.c:1473:34: warning: variable 'bp' set but not used [-Wunused-but-set-variable]
>      1473 |         struct xfs_buf          *bp;
>           |                                  ^~
> 
> 
My apologies for missing the CONFIG_XFS_RT=n case. A fix is ready and 
currently being tested. I will send it out shortly.
