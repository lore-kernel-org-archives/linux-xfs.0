Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47417C4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Nov 2022 19:01:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234061AbiKPTBZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Nov 2022 14:01:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233325AbiKPTBX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Nov 2022 14:01:23 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BDAE2937E
        for <linux-xfs@vger.kernel.org>; Wed, 16 Nov 2022 11:01:21 -0800 (PST)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AGD02r8009634;
        Wed, 16 Nov 2022 11:00:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=//KbGBBT64Suq9TpwrNZ2KfwCzz2aaiverIGzErdGA8=;
 b=lA7/PgU8nY3o2+M0UgbkDd0phvRNySdq+vChsR/ZioxkxK8HlPsP6XPhbmqMu4Z4q6CC
 FOWzQAEYXbkXLQFDh87FCS/A1ZKmw42Ts6Gq6P68qBTosr8oSGv5XkMAYO6QW6aYRyoy
 krmnx66Ko8s1i02awLQX7r0JcMpWfQCaNzVnG4S0m8KCS1W/dPIMmfdbPp8sR7lHCbo7
 RT0GAZ8W5EMr7GVeX2QR8zqoCdMgMYnb69p1hJmm85ceZHa+8tqjtRkTlO5AZK0/dNGV
 EwGPp6XdrxyE+rebFYA0lZ3S1UPiJUEBZkWmTdtMQ2FAYy7U3FT9SnioG+h8D0d9rSX5 6w== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kw0bs3fqt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Nov 2022 11:00:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZICMEdN1q5z6r/qR1kZ5AU3jWppYsiwfpu1Mr4PtBfPfUjk5CAHABuNOz7OBkp87M+LkG9g/hd/V8czVwSadWQzLT6mOWbmsfoTYL3v/hMl8/rr4daV/5hJJVscxRbL8IEN3Rrrh/rcr3J5cslhuEY5+C6XHeAYSq3/idIAtu8iXis7DfErdij3XyHf9b9BwypyI29PtROfZwTLxi/hCRVrdTPPLQu3ng9aLMVMXw0Xq6mi2ekyeud4In+3AqzQ4xGhi/7P9S5H/zMRB8hypRfKQXIM8wQbiC6P7aJ1SL9Dmh+n5g2zo6JqqcZLLN7TKlHg429RDM9vwLsTWW9VV/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=//KbGBBT64Suq9TpwrNZ2KfwCzz2aaiverIGzErdGA8=;
 b=iCCddR6W2ZsovGSNXws4XRI1zLi/Z7ofaw6tTzhpGAmcMrggV+n6qicfbLNAyPIXvYFNQCUO9f/bp3d08fLebEsMmxs/vZXl0qV5tiirT/ZOiIMkTYPC9YvhagkgTC0OgsVla3arn7nReES7v09FgOExoCacygJSn7U1IuaphPWw10CF3/OQAoKBGKcgmnd7wzIpiKWXy+Dy8XCP3fotK6p7qfL13yRZD1QEG9HbjQtW2dH+LtqOda1jz7eVw9it0visHQfq43XQKWVwkv7SH1vF8CGCux3oHraOO2muP5cIDZmLsc4C2mzw2DYKAmugRRWWwPKEWcLNfQcvEWH3Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from DM6PR15MB2316.namprd15.prod.outlook.com (2603:10b6:5:8d::10) by
 DM6PR15MB3452.namprd15.prod.outlook.com (2603:10b6:5:164::26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5813.18; Wed, 16 Nov 2022 19:00:37 +0000
Received: from DM6PR15MB2316.namprd15.prod.outlook.com
 ([fe80::b891:1241:9b15:478d]) by DM6PR15MB2316.namprd15.prod.outlook.com
 ([fe80::b891:1241:9b15:478d%3]) with mapi id 15.20.5813.017; Wed, 16 Nov 2022
 19:00:37 +0000
Message-ID: <15e09968-8395-c8e4-aa6e-aa11b29fa175@meta.com>
Date:   Wed, 16 Nov 2022 11:00:33 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.2
Subject: Re: [PATCH] xfs: Call kiocb_modified() for buffered write
To:     Xiao Yang <yangx.jy@fujitsu.com>, shr@fb.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, ruansy.fnst@fujitsu.com
References: <1668609741-14-1-git-send-email-yangx.jy@fujitsu.com>
Content-Language: en-US
From:   Stefan Roesch <shr@meta.com>
In-Reply-To: <1668609741-14-1-git-send-email-yangx.jy@fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0154.namprd03.prod.outlook.com
 (2603:10b6:a03:338::9) To DM6PR15MB2316.namprd15.prod.outlook.com
 (2603:10b6:5:8d::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR15MB2316:EE_|DM6PR15MB3452:EE_
X-MS-Office365-Filtering-Correlation-Id: bdd257ae-b1d7-49cb-6af0-08dac804d8e9
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Yks5ITMwkCqDY+NF0+TH9xx8caeVQl0iqE3X2DAkgDMEy2yU9fwxezMcTtfW+fJNyM3xJ+cGXO4LJ5ZAecs3df9j2D8A1NJbohzbGXe0dtoGQZtsnAfbIoj8EbHgdGQIGhTYfZjiSTssDKGXw+sTpI0Ao4LxKinkSIDQOlrfgJmBjztt0s95+bU+7wtoSTUAiqOsztgj5yiJ9DCHj+NeCu8u1kYp59Gmc5TfGb8+v1c6bDyae9XXJfv/p9lFroSdRKUa5qpsMbop0TDvmOqrgIrkV3gnsSxuTWhHpB/jfAcaBhleUBMmTFg3XXhJ0nuMnRT/tWBdssOd57kepVx+7SaMpi9tfHB7HoHDQVchx/jDEpMTDu/1n3SYCwQIqs2rKjUgbuP0iPBwKEvgQ1gNKDwWL0X7aWSe+LFtTqDczOVmD6I62kCZkpQ6ftABk8wTYVuo6DoEA5wCCcwRrPYqih26cGZLqi1BBDDmmPKLQu2C6oAuMu4qYZxiJHiEpSfoOe0eVxE+lfWMklLLy8ITvxGAMu5uf+CtIQT5KBrlQdTDEKPVfdsM7TZWNCUp7WOfVmbcGH+l1KdLRTh+ZVip6Ovq2VDc35ChAW179gkSpTmNq23tUdkMKU1ehjDwbeL2UV7//QuD/RlGURUVPGM7+8g6aw7CO2zyd4ghecN8zQWkv7BZBTupwpIKoiwc9q9MQ15+Lhaa/0KSUOSTdj9jRLBM1YbfBDZskyi3e92VFw9XPU6yJkk5PFhoG6/LZxIFAfzhE+CDogRSQ/fY2IAF6Z5Nx0s/N/JCjeH8Bj2AZyTYRRZjqEKOGD/E8qgv8JGk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR15MB2316.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(366004)(39860400002)(136003)(451199015)(31696002)(86362001)(186003)(38100700002)(83380400001)(41300700001)(2906002)(5660300002)(478600001)(8936002)(6666004)(6506007)(6486002)(53546011)(6512007)(66476007)(8676002)(66946007)(66556008)(316002)(2616005)(4326008)(31686004)(36756003)(21314003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WWFuZmhSWTcvTytjOFEzLzZFN2R2Y2l5V0pweDRVSFE4eG9TUjdidEtpcTVt?=
 =?utf-8?B?cFFiR3ZWcEZVTG9yczBiWk1KZlZPcm93ZVJpRXJhRmZObmFvMXp0dmZaQVlw?=
 =?utf-8?B?S2NCNXNFVU10MWRzOWJTaDZqMUlFSzF0Z1ZNMDV6VGowUlM4NTFzSXJNanc4?=
 =?utf-8?B?Z1djVUwrSGlPZU15S3RmK3NkelowK3phcFBHU1N4eVdneWJtM3lyVy9BVXlX?=
 =?utf-8?B?RVptSVlXeTc4ZThETVhuL2RvM0srZ2F6L3hQa0Q5SnVMT2FiU1dGMUNrUWJm?=
 =?utf-8?B?VFM2a29tZ1IxdXZHcXFyMzNETUE3OEpSWi9WNDVIVUxHMGxZMTdYT2t1MkVm?=
 =?utf-8?B?Vm5kMjFxMjBFeDZBTmgyRnBGQUwyT2k3elI4b01QRCtzUnZuNngrWFY2S3g2?=
 =?utf-8?B?RzZzdU82SlBEOWZFODFnVEdiZEFiOFZDSjRZakVhL0hEeVVsOFZGemZ3amVQ?=
 =?utf-8?B?aExra1RSdG1kM1lFQjl5eUpidEdhSDhSTDV4N3dwZ2RhdWhLUDlYaTZTTHho?=
 =?utf-8?B?RWpQTXZPa21YcFJWYjMxOTI4UGJYME9OblhEcGxTWUZTZUdMUkxrb2hIaHdO?=
 =?utf-8?B?c2RaQTlZZDN0MUd2N2ZMVDRGRk96SjZOd2ErNEYzWGNWNjY2cjVlSWIyUEMv?=
 =?utf-8?B?dUlXNkE0R000cWphUmhjT05aVGdOS0RPaXFXUHE0YmczaFR2R1UxdGRjM0ZU?=
 =?utf-8?B?dVdKZ3RFcUZGaHdTc2xuQ2hOZy9pazhrS1BTSk52N0JNRG51OWNwQkdlU0lw?=
 =?utf-8?B?bzBJcm0zZ1BYV1ZVWG9IcDdjcU85RlBWVTR0UXpORy9yRTk1MkNuWnVnM2ZX?=
 =?utf-8?B?RFNGMWV5dTZ4bnZtSUpNLzE4amVUcUdzcnlmZEJEYlF3MCttOE03aTdMRTRU?=
 =?utf-8?B?ZDZ1VlMxb0QycDZscGVVaW9tY3NxUTJ3cXZGQTA0eHFYOWJ4dzJNQjFURW9j?=
 =?utf-8?B?VDdrVmVoRXdmWU11ajlveHFaU3NMMTVCSlBybjlhRVlYaXNjVndSMmY1dXlW?=
 =?utf-8?B?eFhPMXdZMFlXTTdkbjZNQU1GNzVnMEhzRXBsMVdIandvc2h1Umw2cEdwdDFs?=
 =?utf-8?B?bG9mTTNtSEdHemVadENmUjRSNlltNXVzMDNhQU5FUWZUQ0xINVFvOTNPVWo3?=
 =?utf-8?B?RExSTmxjdWtNVEhIeVM5NDZOaHBoL1ZEb1pLQVJkL3J5VVFhKzAwUFNWVU1D?=
 =?utf-8?B?cHlNMWJubmZkdjMwYWhIeGZaL0pZNTNJeE5sM05YU2FJMDNGVUlseno3RUJr?=
 =?utf-8?B?UXlHY2xOY1dxYjdjK3BNSytQR0dIbnZUTUdrSVkvdkNyVllENFpXVWs5b2Mv?=
 =?utf-8?B?elQyYnVvNStlaGlCb1JLVEdtNU5oZlFmQm5idTc5VTFENUtYdUM3V3VDWjFN?=
 =?utf-8?B?MDl4ci9QSTNvSTd5czQzOU5MLzEycGlPbFJkWkJsY2J5anJicnhGdXE4WG1j?=
 =?utf-8?B?Wk9iS21hdG83azZ3eVVMWmhBcEc4cXhteG9KNkZaNUo1STVZQnBwdWUrRVV2?=
 =?utf-8?B?OWNBMUhVUThUYjNjM2k0d0dETk9LUVZUR3o4emlORlpUeTJpUEF5S1czQjMv?=
 =?utf-8?B?d0ZlTVJ3VFpmKytlcURzTjlyYnVHQXJ4YjFXaWd5TmFraG00Z0hyRjF0SHZu?=
 =?utf-8?B?eDRGblZLZXMrMERSL2F2SzNBMkNHbTZDRVY2LzNPU2pyUzNzMVltOGJYcXcv?=
 =?utf-8?B?RXBUbHdHY1JEK0wvN0dlNGdtQ1M4UThxK09vOFkvTHNnd0doL3hUOTZkdDBh?=
 =?utf-8?B?SUh0cy9NOGw4bm00d2MrczBGQXdxUEVFMFdia1pORCtmQkU1aXNWdVN3c3pN?=
 =?utf-8?B?TW85aHNoRFNRU1ZlU0xwRURWN05DYkRTcTA1Tm94UTI3YVBhT3ZVZkdnTmg5?=
 =?utf-8?B?UWNwQkdXNDdSVXAvdE5qV1ZtTTR3YlgyY0lwekZlVE9selR3UVZmcStaalVU?=
 =?utf-8?B?WCs2UVJDZmQxcFQ1bzhVT1VSY2FWdjdFSG9FdDFQSTJ2VW1uUmxrWlBvZU9v?=
 =?utf-8?B?dzVUejY3dHV3SUlRZXpEdjRzMndLTEpVV05FYVRRMGtCak5iTmZDZ2NZd0RM?=
 =?utf-8?B?enV6MjY5MjhacHZBWkZUeE1YS25sNVpjN2Y5YVdjV1ZObWVKL1I5NUFsZEF2?=
 =?utf-8?B?aERZNllSb0NFa3orT1AyTmMzcjg4MzBDQVlMeXFKY3JuU3lTMkRPM1hES1Fy?=
 =?utf-8?B?Unc9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdd257ae-b1d7-49cb-6af0-08dac804d8e9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR15MB2316.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 19:00:37.2821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MXgfNVVvMvPDI83yjOMvOi4EynfgMM6vJWtiVS5lROPkhNLjjQFPQSrvAbNogQCR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3452
X-Proofpoint-GUID: 4KIp-xzY4t2qjylRZUIWKCfMGrDsUpEL
X-Proofpoint-ORIG-GUID: 4KIp-xzY4t2qjylRZUIWKCfMGrDsUpEL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-16_03,2022-11-16_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 11/16/22 6:42 AM, Xiao Yang wrote:
> kiocb_modified() should be used for sync/async buffered write
> because it will return -EAGAIN when IOCB_NOWAIT is set. Unfortunately,
> kiocb_modified() is used by the common xfs_file_write_checks()
> which is called by all types of write(i.e. buffered/direct/dax write).
> This issue makes generic/471 with xfs always get the following error:
> --------------------------------------------------------
> QA output created by 471
> pwrite: Resource temporarily unavailable
> wrote 8388608/8388608 bytes at offset 0
> XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> pwrite: Resource temporarily unavailable
> ...
> --------------------------------------------------------
> 

There have been earlier discussions about this. Snippet from the
earlier discussion:

"generic/471 complains because it expects any write done with RWF_NOWAIT
to succeed as long as the blocks for the write are already instantiated.
This isn't necessarily a correct assumption, as there are other conditions
that can cause an RWF_NOWAIT write to fail with -EAGAIN even if the range
is already there."

So the test itself probably needs fixing.

> Fixes: 1aa91d9c9933 ("xfs: Add async buffered write support")
> Signed-off-by: Xiao Yang <yangx.jy@fujitsu.com>
> ---
>  fs/xfs/xfs_file.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index e462d39c840e..561fab3a49c7 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -417,6 +417,9 @@ xfs_file_write_checks(
>  		spin_unlock(&ip->i_flags_lock);
>  
>  out:
> +	if (IS_DAX(inode) || (iocb->ki_flags & IOCB_DIRECT))
> +		return file_modified(file);
> +
>  	return kiocb_modified(iocb);
>  }
>  
