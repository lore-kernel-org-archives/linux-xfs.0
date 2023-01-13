Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EF76C678D4
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Jan 2023 18:09:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbjAMSJO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Jan 2023 13:09:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231169AbjAMSIr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Jan 2023 13:08:47 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F29E7871F7
        for <linux-xfs@vger.kernel.org>; Fri, 13 Jan 2023 10:03:07 -0800 (PST)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30DEqQte030755;
        Fri, 13 Jan 2023 10:02:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=rjzz5fKFZIPL2eK1ziZwhj/T8RJLGwh8vJ4fxOJmH/A=;
 b=Z4ph3I459qYyRkXBn8+z4i916UZriQu32hn006YP/Za5I2J9MB03Uj/gmb9UOVeps5GQ
 UtQV7UuES8/d8MA4wr9qqskCh1UHjeKvjtoMrtJEE9dv3AsPN+9lNAytzfYiKL0WdWCj
 YfQAiQHPl+91EfHllOpeiiCA3jPg3PAXQqi8yTnsCZxOsAnTzcTNdQGXn4oJMBWsD5D3
 ZHo5s4jTqGvHLPAV6eRugr10yUtYGepBlMq0/Zv+hwdCpilTY4RBdxZ75WO/52EdK8l6
 P/Pz0LD9BE1tUV2pXErRBnKzMHj94LuBPJsLIaGOvISzsGCj2eQzG6mY1dFsuPDORPSa Jw== 
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2044.outbound.protection.outlook.com [104.47.73.44])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3n2xau48cg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Jan 2023 10:02:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jnKhTUbJc8YJsXcHCpbZ3VclP5oCUQBkUXO6lDRvSYqh5UuaC5AzFEr1Fz34kDjsFQkIP2yVtyjPE4WlcrxN1uZJX5csoB/5UjVRJ/R0/qvnA0lWM3IYLF+eLCRLarUw5r0OEMH3fPQgl3Nt6KWqctWcxImRZZtVIGIJaYUnigsV8c0DA9J3MZDsJ0Bd3xHgcI/y5FYY3+CUPi27M6bDww+R4oqfjK65k2gosfscD8u5cDlmmBur+9BJUTBZ0sg346pDv7pgouDoPcKb4B8s/t+1yOhNI3Vil+AQ2EhJzLTe/bC/AksbFGtJisPXBg0kqVHS6IJ68TKDHY1zKvxVBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rjzz5fKFZIPL2eK1ziZwhj/T8RJLGwh8vJ4fxOJmH/A=;
 b=IkBepqSYlBhtDDXi+18Vr389RMlGv1FIYJf2ueymiGJTB5CgUQEKuY9yvi92CC1ZTgDrR3GPQodnj2yH0Jgoac9J9/eYWh1hzZyyL/hTGknSC1f32V3vjZSlxgVaxt4x1J3M+a2otcEmPupHGx+btHdpHqw3JVsooywFm6Ol58cap2y9ESXF5SvwRKh/ByB2UQtdhLOQtsnucd4QXJ/pvFSyknJJBZIZZ++YDb74MwG2PQ2O7cfmaBGfoEXJG8Bc3cW/aX9RG2n/VbHz7BJDZaoXSazh534GFrREtSZ2S3itRA1dqADlt0rKVnf3j5urs9h3EWkuVxHAjKkXTX9aXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from DM6PR15MB2316.namprd15.prod.outlook.com (2603:10b6:5:8d::10) by
 DS0PR15MB6207.namprd15.prod.outlook.com (2603:10b6:8:161::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.18; Fri, 13 Jan 2023 18:02:49 +0000
Received: from DM6PR15MB2316.namprd15.prod.outlook.com
 ([fe80::fb17:8ae4:5201:6100]) by DM6PR15MB2316.namprd15.prod.outlook.com
 ([fe80::fb17:8ae4:5201:6100%7]) with mapi id 15.20.5986.018; Fri, 13 Jan 2023
 18:02:49 +0000
Message-ID: <7944bc40-9331-0ae8-fdd6-8a0d846c8a15@meta.com>
Date:   Fri, 13 Jan 2023 10:02:46 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH] xfs: Call kiocb_modified() for buffered write
To:     "yangx.jy@fujitsu.com" <yangx.jy@fujitsu.com>,
        "shr@fb.com" <shr@fb.com>, "djwong@kernel.org" <djwong@kernel.org>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "ruansy.fnst@fujitsu.com" <ruansy.fnst@fujitsu.com>
References: <1668609741-14-1-git-send-email-yangx.jy@fujitsu.com>
 <15e09968-8395-c8e4-aa6e-aa11b29fa175@meta.com>
 <8987307e-14b7-44a0-fab0-ab141921f858@fujitsu.com>
 <OS3PR01MB9499B1C48D863B2A62E9EA0983C29@OS3PR01MB9499.jpnprd01.prod.outlook.com>
Content-Language: en-US
From:   Stefan Roesch <shr@meta.com>
In-Reply-To: <OS3PR01MB9499B1C48D863B2A62E9EA0983C29@OS3PR01MB9499.jpnprd01.prod.outlook.com>
X-ClientProxiedBy: SJ0PR03CA0218.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::13) To DM6PR15MB2316.namprd15.prod.outlook.com
 (2603:10b6:5:8d::10)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR15MB2316:EE_|DS0PR15MB6207:EE_
X-MS-Office365-Filtering-Correlation-Id: f276e33c-c469-4f21-ae42-08daf59061da
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gFlNesM07TKJoQj5u/Nwtdw717y58cz/SqRbpulAsuFtSgLlQhfO+nTPsILKHYlSI1zSe0IHCLEdGrRAtwVSQ/6zotKr8fSeJXJx1En7N67EAHHeEcGXEhEKQQy0kRmy5E5OBFnXWzaJAIGtwzx0bBYRUQ9vg+SyscBZjkYzRoie9YE7+4Ktk0+ereo14ztfd51u+IFSCvsiKy7Blg8KP5cQK9iZlby/KTuF2zt2H8RGjL6MLD/QDUxn2M4cO9RsUdW7bCVb+au7OGnGiDC0jYu5hTkoCfEB7gfa0OA4cWUtFb3ZkLQma1mx5NS6+Bhhfde8uOwXqqWb2Uy+0AwDGPKBtVOdQW99V1Ui3hW7KF18i0BguLmrwQNWOhpX6IDxpBrkSSm6oUk2XHi3SrOSXyWaEYibD1NHdwLJMNnQNeIN5xt9wbfbVqEoBppx7s5KiaE53Yu6nzcgdiZU8DFFNk8T/fHwsHeRj6Abu2ck8Xv64mfLAn8zPgg3S1PO0QA30i2AHKErnwFAeaL7IIztNMj3ECSAXWNFKW8aSW3z11fAJIZdWjPygcfGpi0++J6F2CmuITy9o7TrTTRYKyZJKFLxTAySl3Y2dKzSWi/hPafhauLyhwgLkT3siIbmEIHqZewSucNiSMtob1N43zwhK5j52xkt0H0Pl3F3TKBsn/7kTopMdrg9Qbwnq0778OUWqRqiANq0hkx5ySmxk1Amjlih9McP7uUL3DAT7kwzwOn0zczt0p48mGd1HM1cGOFz7Mn6knPPMBtPSoYH4J1pqPcTcUbVWOyKGpo5P8ihtCY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR15MB2316.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(376002)(39860400002)(136003)(366004)(451199015)(38100700002)(316002)(41300700001)(66556008)(66946007)(66476007)(8676002)(54906003)(2906002)(36756003)(2616005)(110136005)(4326008)(6666004)(8936002)(53546011)(5660300002)(6506007)(31696002)(31686004)(86362001)(83380400001)(966005)(6486002)(6512007)(186003)(478600001)(21314003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eEdPS2d4YkQ3cisvY0ZGQWxVN0lKVUNZNEpVVnM3dkpCZXNMUThteWR1bWhj?=
 =?utf-8?B?RmQxRHVJODZzSUlHaTJIYnFwWE5MeUlPTldiR0p6VmgvY0dSMmVUYXFpdjNa?=
 =?utf-8?B?eEg4MmtCRU9jZURXRm02ejJ3UzZ2aHdkSERMdUpQRjg1TnpCWW9YY3FvbGJu?=
 =?utf-8?B?UFR5UGhpMU53UGJnR2JYNkcwemJXOTBnb3N4cnI5QXJlY0dFSUtiSlNKRjVo?=
 =?utf-8?B?QVNkbUp6dUVYNVA4ek1VK25ScG8rWlJ2VHdHQUZtTnFuWGt4MXlvQXNqMGJu?=
 =?utf-8?B?NkJxbUphZHJ4MndFTDZ2ZjdteSs1TWNhVEJ0V2JCUzFGQTVuOXdNWU5mTjhv?=
 =?utf-8?B?bTRETmI4NkVqN2xWWFU2NHNtWWdtRnFtTUVscG5GdUdSa1pwM291MGRBeGNY?=
 =?utf-8?B?YlkvNE15aHdKd2llME9aWitTNkZFRzdWRXltRndOUlA1enFyaWhwWWl2Tyt6?=
 =?utf-8?B?NHhHT3hzS3ZpT0tqVUZ3dVNEQldrRjM4RFQ0Y0ZmWVhJaGp2RUxlQXIzYWxD?=
 =?utf-8?B?QjI0Mm9iWXNQSmh5QW9YZ1MwYnF1NXExelF1cnRQeGRvc1pMSTdkWkVsMTYx?=
 =?utf-8?B?MlZNSzZob1F3ZE0wR1pzMjRqNkgrTi8wajl0aDA3dHhLeVhiM3I0cFROMHkv?=
 =?utf-8?B?aEU1UW5GQ01XbTYrQ0xnS0sycmZKemltWFFlamhvc1VLSURWV0VFZWc5UitS?=
 =?utf-8?B?dHIxLzNxOFJlWWdJSWdEQXVQbUEvZ3l0VlpBMTAyaVJ1ZHFWWE5aNHdsSmhQ?=
 =?utf-8?B?cStiZkMxYnNndE4yd0FYdkZ4bUVTamJZMjkxNWZNQktmSXEwMG8rNEpJczk4?=
 =?utf-8?B?N1BXbWY5elNTUk15TGxiaXQwNXgrWFN1aWs5SWplKzFhRXJlMmk5UUJKdnk0?=
 =?utf-8?B?MU94R1pDb05lcWpWSUxEcjFKZ3VKREw1a0lrM1FHN2dhWExMTGYyMC9QQXBV?=
 =?utf-8?B?TEFjWDRwcG9hM1hja3Bsb2hBSVB4dy8rcExweG5xOUw1czhZcXZUbzRPVDdn?=
 =?utf-8?B?R0IyZ3lWYmdxQmVvMGd3SFhweUJkQ2d1MDY3aXIyT1pPSitqWXJyY3pLYlh3?=
 =?utf-8?B?MFRKSE04bTBRNWkwa2JVVVFLZjdlZmxBNk0wa3FzRzVVaGJnekY1emprM3Bv?=
 =?utf-8?B?TGczVGUvcXE3OWQ0VU43RC9lWDlnZDFJUUFJcjVUWDNsUnlVR1VrMytMSmdo?=
 =?utf-8?B?QVAyaUpPdEhvRmJDY0tORExJUHpkaUNISnpycnBlT1NaVVgzNnc1cFIwMHlj?=
 =?utf-8?B?Q2FJSUp3QS9aMUt4ZlhjWDZWcjJnaVZvdjdSeG9DZ1pBZ1BsTmsvb0h4ZlIy?=
 =?utf-8?B?WXpBTjVFR0J6aktkYlRBeWl2NEpURWJ4QlJMdndseURDYmswdHRQdDJxaXBY?=
 =?utf-8?B?VXlZTFdYbDRMRnp0Y3ppZW1OdVpxTHVwSGtWb2ZOVXVHMlBCV0R5ZkYybmxU?=
 =?utf-8?B?RXVIWFQ3STlVRVBGNFR5eHJTdExmdThLODF5ckJxWGo4V2F2NVNtQ25hMDFT?=
 =?utf-8?B?N2p2NVJ4R2dwYzlFell1cTEwdWQ1SzREVDRFYXBUK3gvU2MzMFBORlRwQmNt?=
 =?utf-8?B?Vm0yR2QvMlZlL1NPK0F3ejFGdjFtS0RqRWE4K3Vna0NrMms5M2l6WUFoQUkx?=
 =?utf-8?B?aEdmZlFXbTgvYXF0b2Y2RGV2MHI5bWpQeE44M3FremY0VzczTS9UZ3JFSlBi?=
 =?utf-8?B?SkxtQ01LbWk0ZTgzaEhGZTlOSy9zWE9SWlZGY3NvTHYwN3gyNHlSVm1obFE2?=
 =?utf-8?B?WE5wZ2UrQVR1SUhNQ0ZPeTE2c0NyY1VicXNHR0ZzYmlIQnF6eUREWGZCV0JL?=
 =?utf-8?B?S2FkVytUbUhzQW5VNzY5RHpWbEtsS1loS1o2bGtkVkM1U1NCV0JOTU1Mamd4?=
 =?utf-8?B?MVZCOFhoTlFtWFhQNXg4YWdJUURpcE16dDVWam1FZUJKS3J6aTFFVFZKTURE?=
 =?utf-8?B?TzI3N1h4eWhqVXdkVFBGZ3lNSUkvNldNTGN4QU10UStkaEE2RE10N2t0R2Vq?=
 =?utf-8?B?dTZRU3h5STd0Rm5vUjBMbUtXSndBSjRzazBWZXEwV0pDUHFwaHNzbGVXNUdh?=
 =?utf-8?B?K3Zzdmk0S0Q3WW9FR0RQS3VOWmQ1OWNHWk55cWxNNDUrWEJLWWJndWtENFdy?=
 =?utf-8?B?eEx4WktxWGlOR3RYVXZRZjJFZFdFWVJIaTdjRVg1UWxIVVpueThzZCsvdCty?=
 =?utf-8?B?Ymc9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f276e33c-c469-4f21-ae42-08daf59061da
X-MS-Exchange-CrossTenant-AuthSource: DM6PR15MB2316.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2023 18:02:49.4194
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qrIj/eidk5EIF3IBzx96Ud4NrjS+UcobcbsLeHNNpqqJKm70NhajZmBX9jhECvhy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR15MB6207
X-Proofpoint-ORIG-GUID: -MnNtYVrvwT0F_hQJBA0jeeXmbo9eHXC
X-Proofpoint-GUID: -MnNtYVrvwT0F_hQJBA0jeeXmbo9eHXC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-13_08,2023-01-13_02,2022-06-22_01
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This has been discussed in https://lore.kernel.org/linux-xfs/b2865bd6-2346-8f4d-168b-17f06bbedbed@kernel.dk/

Here is Jens comment:

From: Jens Axboe <axboe@kernel.dk>
To: "Darrick J. Wong" <djwong@kernel.org>, fstests <fstests@vger.kernel.org>
Cc: io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	david@fromorbit.com, jack@suse.cz, hch@infradead.org,
	willy@infradead.org, Stefan Roesch <shr@fb.com>
Subject: Re: generic/471 regression with async buffered writes?
Date: Thu, 18 Aug 2022 11:00:38 -0600	[thread overview]
Message-ID: <b2865bd6-2346-8f4d-168b-17f06bbedbed@kernel.dk> (raw)
In-Reply-To: <Yv5quvRMZXlDXED/@magnolia>

On 8/18/22 10:37 AM, Darrick J. Wong wrote:
> Hi everyone,
> 
> I noticed the following fstest failure on XFS on 6.0-rc1 that wasn't
> there in 5.19:
> 
> --- generic/471.out
> +++ generic/471.out.bad
> @@ -2,12 +2,10 @@
>  pwrite: Resource temporarily unavailable
>  wrote 8388608/8388608 bytes at offset 0
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> -RWF_NOWAIT time is within limits.
> +pwrite: Resource temporarily unavailable
> +(standard_in) 1: syntax error
> +RWF_NOWAIT took  seconds
>  00000000:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
>  *
> -00200000:  bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb  ................
> -*
> -00300000:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
> -*
>  read 8388608/8388608 bytes at offset 0
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> 
> Is this related to the async buffered write changes, or should I keep
> looking?  AFAICT nobody else has mentioned problems with 471...

The test is just broken. It made some odd assumptions on what RWF_NOWAIT
means with buffered writes. There's been a discussion on it previously,
I'll see if I can find the links. IIRC, the tldr is that the test
doesn't really tie RWF_NOWAIT to whether we'll block or not.

-- 
Jens Axboe


On 1/12/23 8:55 PM, yangx.jy@fujitsu.com wrote:
> !-------------------------------------------------------------------|
>   This Message Is From an External Sender
> 
> |-------------------------------------------------------------------!
> 
> Hi
> 
> Kindly ping. ^_^
> 
> Best Regards,
> Xiao Yang
> 
> -----Original Message-----
> From: Yang, Xiao/杨 晓 <yangx.jy@fujitsu.com> 
> Sent: 2022年11月17日 10:28
> To: Stefan Roesch <shr@meta.com>; shr@fb.com; djwong@kernel.org
> Cc: linux-xfs@vger.kernel.org; Ruan, Shiyang/阮 世阳 <ruansy.fnst@fujitsu.com>
> Subject: Re: [PATCH] xfs: Call kiocb_modified() for buffered write
> 
> On 2022/11/17 3:00, Stefan Roesch write:
>>
>> On 11/16/22 6:42 AM, Xiao Yang wrote:
>>> kiocb_modified() should be used for sync/async buffered write because 
>>> it will return -EAGAIN when IOCB_NOWAIT is set. Unfortunately,
>>> kiocb_modified() is used by the common xfs_file_write_checks() which 
>>> is called by all types of write(i.e. buffered/direct/dax write).
>>> This issue makes generic/471 with xfs always get the following error:
>>> --------------------------------------------------------
>>> QA output created by 471
>>> pwrite: Resource temporarily unavailable wrote 8388608/8388608 bytes 
>>> at offset 0 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX 
>>> ops/sec)
>>> pwrite: Resource temporarily unavailable ...
>>> --------------------------------------------------------
>>>
>> There have been earlier discussions about this. Snippet from the 
>> earlier discussion:
>>
>> "generic/471 complains because it expects any write done with 
>> RWF_NOWAIT to succeed as long as the blocks for the write are already instantiated.
>> This isn't necessarily a correct assumption, as there are other 
>> conditions that can cause an RWF_NOWAIT write to fail with -EAGAIN 
>> even if the range is already there."
> 
> Hi Stefan,
> 
> Thanks for your reply.
> Could you give me the URL about the earlier discussions?
> 
> kiocb_modified() makes all types of write always get -EAGAIN when RWF_NOWAIT is set.  I don't think this patch[1] is correct because it changed the original logic. The original logic only makes buffered write get -EOPNOTSUPP when RWF_NOWAIT is set.
> ---------------------------------------------
> static int file_modified_flags(struct file *file, int flags) { ...
>          if (flags & IOCB_NOWAIT)
>                  return -EAGAIN;
> ...
> }
> int kiocb_modified(struct kiocb *iocb)
> {
>          return file_modified_flags(iocb->ki_filp, iocb->ki_flags); }
> ---------------------------------------------
> PS: kiocb_modified() is used by the common xfs_file_write_checks() which is called by all types of write(i.e. buffered/direct/dax write).
> 
>>
>> So the test itself probably needs fixing.
> 
> In my opinion, both kernel and the test probably need to be fixed.
> 
> [1] 1aa91d9c9933 ("xfs: Add async buffered write support")
> 
> Best Regards,
> Xiao Yang
