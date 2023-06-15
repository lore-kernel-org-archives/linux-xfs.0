Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95EC1EB64D9
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Jun 2023 22:31:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbjFOWbb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Jun 2023 18:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbjFOWba (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Jun 2023 18:31:30 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8362F1FD4
        for <linux-xfs@vger.kernel.org>; Thu, 15 Jun 2023 15:31:29 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35FGJCiB027538;
        Thu, 15 Jun 2023 22:31:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=kjG8c4BmU1BRM4J1O97Hyf/EBBwVi4ZCmOsBft2cBB8=;
 b=GFiYawh0yb1tNE5AizfTwtE9YUVUcH9ueedDll8KrcCjqgVJqwuH918kOZnMEFRuw8sp
 0VsaiCBHHRmNwMH1xPJ7VLT7TAj4oSt6zYqg1TGqGwQtF2MnSblte/LCG67SILm3hpQn
 9Ng3+tolgjMoIhR5jlhqjqe+WD/WF0nW6FAIhAw/s9ObKmTxvUqsLSIopk4M//1hJRpq
 v7t/V2Vsigb7w2tbC1O+yX5RFK7EPZV5CJsIVQPOH1Syja6gZ48kfCOTM4ViVYhPkFuo
 wM+gzYFHJK7tb7MgGSsMlGmNHJ2jsFPKzedsAp1WDerBLnJPEBCaNkgFM67rMvOQTRXs mQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4fy3k3ex-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jun 2023 22:31:27 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35FM1IPv038937;
        Thu, 15 Jun 2023 22:31:26 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm794q0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jun 2023 22:31:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jz0F4+2ebyfMLWfXmbkbclDp5g32ftOtmSM1KtY0kI2D9zrtOpJNVfHxJe42ad/FBJeRmjcvnq/s6GsllRjdn5E3SQIVAKAxzSJ5arePtLPL0B7R0S3+hheNZ3nTQ9JTrdkLX1fRSZZ3cjiMnV69W1KY+fji1WFTJEFieuOlOO9yBQaqnR29nLVNCmlQoUkxpDOQeTfr19ycvMuuepG8afXUVTQ8NER/76f04Anfnu/M1WhlVarry7E4+t6XucV3O6+2La10mjGn0hKtMo1jR+K6DLEKYWJUH3sinfUNBly2Yr+lQw8sa8WPHlY/oWmOSXwyUi+OFl7Y5ObEKJ7ATQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kjG8c4BmU1BRM4J1O97Hyf/EBBwVi4ZCmOsBft2cBB8=;
 b=HKETZUQAW7J9g9QfiEXSPPOtq/ADIizvqJ5UFQuxgLpEe75vQYWoe4y79mCWEsMEkjlM6PBNctp5OSIhgBprXpBBD61cKlYCjjVzzdcdOB6DuvVIoi3XP9pKMMJwtwUBNmn50UkWVe4OEE5YP2a4adxmSbYC19+DIUpNJ0K6nXKXDmwhQQKq0Lth9/y/iM2w7dDD+73FMMLa7/Czs1b9T/+27JwTefmXW7bmacsurI/nLtFrJef1oRpZe9JQ7RySjnteg7KKTc2Z6XBPZz7mKAL67buRhH7rOAqY4zcEuQXNpxDku5kA7zL2ANlr1r5nZndqPLfmM519bHNsf0LEUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kjG8c4BmU1BRM4J1O97Hyf/EBBwVi4ZCmOsBft2cBB8=;
 b=VT5mwWtRcj94BW3hgNkHRGhGJGRUbLV+vr1MRxdrjnF0JHCT6gJBHSriRVfBqm/seuz2Pohhxe8kcAGOu6WZR+ip1V2TYx8lPdqwGGDTtsycmkx308nuvNTANnaXOMOumanR+g5zVveu40p6UR+ioMP/ZkRNfHhGqV0RCI72pug=
Received: from SN6PR10MB2701.namprd10.prod.outlook.com (2603:10b6:805:45::20)
 by IA1PR10MB6783.namprd10.prod.outlook.com (2603:10b6:208:429::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Thu, 15 Jun
 2023 22:31:23 +0000
Received: from SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::5f1f:6ddb:112:a1a1]) by SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::5f1f:6ddb:112:a1a1%7]) with mapi id 15.20.6477.037; Thu, 15 Jun 2023
 22:31:23 +0000
From:   Wengang Wang <wen.gang.wang@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "chandanrlinux@gmail.com" <chandanrlinux@gmail.com>
Subject: Re: [PATCH 1/3] xfs: pass alloc flags through to
 xfs_extent_busy_flush()
Thread-Topic: [PATCH 1/3] xfs: pass alloc flags through to
 xfs_extent_busy_flush()
Thread-Index: AQHZnyqiJVfvBqN/ZEat6GgWNoCKPa+MalAAgAAE8YCAAASYgA==
Date:   Thu, 15 Jun 2023 22:31:23 +0000
Message-ID: <3EEEEF48-A255-459E-99A9-5C92344B4B7A@oracle.com>
References: <20230615014201.3171380-1-david@fromorbit.com>
 <20230615014201.3171380-2-david@fromorbit.com>
 <25F855D8-F944-45D0-9BB2-3E475A301EDB@oracle.com>
 <ZIuNV8UqlOFmUmOY@dread.disaster.area>
In-Reply-To: <ZIuNV8UqlOFmUmOY@dread.disaster.area>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2701:EE_|IA1PR10MB6783:EE_
x-ms-office365-filtering-correlation-id: a625ae5b-0b73-4cd7-08e5-08db6df03ff5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: urkHUEcMZHlxQrbaZVFIWuvG+pB2Ptv4Zn7Ik6WNh6qUSU2s5rPDfDyqLnYZO0o9UCooPxnmv3L+icPK3c0TrNV1ufz/zIMYlirdmsCBPGSvweb7IwHAfoX76lmz8h4msRiXiG4rjAkOZ5MEDTw1UaN0sFbzhvtO71eZwpw/fP7/GYj5EOIbjicQBajnZHYlGpwwKU5nPu64hCSRE7da/YZ9gNK6G5J3MVJCdnyiOssLdB/UbCdBPF4laOwxyfYonICNoGm2xj6rtYKSE9p57ASZqwFqUoLoAMq9LX655v2ptDc1DVKP2wiDiCkFACBfsyL3V7PWmCKO1tZ74IvQ7PlHBRc1E40GcSDjnSX5b6vYUpLVnojyJ/CPRUNSOcKayN5IAqDJN1RkO5kBsGAieN1GjlF8uKQPbhIMc8lVuAI8lpe3ccGSl+Bj5xTQAjVNgQEqiZeLShhRIPMmmQhFmiwJludDX4G4O5EMmbft1XiPa+AzZcxJ5wSnoOQb4n9vjcWPT+4qLSAOLApmcc12RBC+j5spdyoDsXNCVst+u3DciHMgkwGEv3RLxF4GwLpWBXh8eavd/tReTCbCpxIxnE2Wxj/1iqTKGCtzglm7UQ3xMCPdlqbeRo0BD9CHOliH
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2701.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(366004)(396003)(346002)(376002)(451199021)(66946007)(66476007)(36756003)(76116006)(478600001)(54906003)(8936002)(5660300002)(66556008)(66446008)(64756008)(6916009)(71200400001)(8676002)(4326008)(41300700001)(316002)(966005)(6486002)(38100700002)(122000001)(83380400001)(38070700005)(26005)(53546011)(6506007)(2906002)(86362001)(6512007)(2616005)(186003)(33656002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RlJjMXc2VXl3dTBCcnQvRTNPem10clp1NWtBSnlvRTUrVFFnWFpDZzBCUTQ5?=
 =?utf-8?B?eXAwK0I3K2tHV3IrRklVb0dJRWRGeUpmc1RYYkg5MnBXYWJ5ZlB6a1NNS1ZO?=
 =?utf-8?B?c1JJZThWRHhSRXpta2MvbFFubW5CbUg5dGtsV3QzMk9SdmhWZEZEb3Zjczlx?=
 =?utf-8?B?NS9INFFLczlmNU5ZVnR0WVdMWG5oMVpIK3ROOEtXM3lzazBZM1ZabmVDNHp3?=
 =?utf-8?B?VDFMd25HaFVUMllMSXYvWFpORVlHSXFxOVBQYTBHcUx2NThMeWFJVGt5djNU?=
 =?utf-8?B?Y3FUb2lzWU9tTjN5UlQwTUN5U2taVWVubkZvZ1Y4ZHFweUpsdmhxNWg0ZFhx?=
 =?utf-8?B?ekpvZ0tKUDM1Q0xJVFE0WDEyVkczYTQvTnlhWWY5SnJqcHhJeFZDNWloeTlL?=
 =?utf-8?B?cjFyMTJOSS9BTCtXVVd3VnJJOG9hdnU0eGthZEpVOVA4SmV4czFRazNjMm0x?=
 =?utf-8?B?dG9HeUF6UmlqbWJTamRVTGRIcUVGTXdUZVZqQnBSeXhOcUpnRUwxVWt4N2c3?=
 =?utf-8?B?ZCtnYXQrQ3VrblhnWUx2OUR3WXhuVFVKM1kxWkg3K2d6TFlCQWhYeERRUHBz?=
 =?utf-8?B?Wm9ETkNJODRUMU82dHdLT2ZmRXREK0V0a3J3K1BlMGh3S2xDZWF6b0RsWlJj?=
 =?utf-8?B?eC9QNW1LZm9ZVGNpS2xESC9pTlRwMkFETHk2Y3Nod3YyYjg5bVdNc0RaSHoz?=
 =?utf-8?B?YzYwNk1CYzhaWXRGeVZnL0JqVU1odUt2cm1yYUpVUnpKOWdNRzBJZ1BCZEhn?=
 =?utf-8?B?QnA3bUE1V1FYUGlRQXl3T0cxMU9hWEtYRmxGblFaK0FiN2JYZURPTVp2ZVEx?=
 =?utf-8?B?RUtZWHNwbmE2T3h4NUFFSXZGYVdXU0dFTURoMTlzRDlxS09PalBmVkdrdjBY?=
 =?utf-8?B?aXBCcW1ld1JxSWhPWmtDSVpQU3BMQWdsdWtIek5iQjgvQTZWb096eWp0QnA3?=
 =?utf-8?B?VHV4ZkxXNHV0TUt4MUZ1aWNuNmFKQnN4V1RTQWVGRThud2hNNm5ZdHJJNjhF?=
 =?utf-8?B?V1QweEdoV1ZnOERLZmdKL2NuZXhYbnQ1MW1nQW9hd1kyZHNiNGhtMk1ndElR?=
 =?utf-8?B?MWF1Vm5xck1lc3dRalhMVnFhdGVwT0laTDhxVmU5aU1mUmh1VWswalRWS21v?=
 =?utf-8?B?Nk9vZVlpZTBUc2g4N0wvcFFEYnBnaTBBYXVKVjBEMFF2RjNNSjAxZWcvSzZS?=
 =?utf-8?B?UGFiSmk0bDl6MDRvcnhlR2N1UHRnQmh1TDVkQ25oK1prZWROSU51UEw1RHc0?=
 =?utf-8?B?TElsc1FDV1hSVG9taUdEZGxaNG5BYnRlODdGbndEcTFlTUpKU1ZoVlFQL1ZK?=
 =?utf-8?B?ZVFVOUNZYnEvakp5MFd3aHdHTXVUa0xsbHJhNWFnM0pxMTZuRlo4MFBrMHFD?=
 =?utf-8?B?RlEyaHlMbFFTM1M1YjdqOVZRa01qRGlsZHdhYWNZYUVyakgxNFN0eUtLRFFu?=
 =?utf-8?B?MXFCVENRNzh3QlRhd1poM2lNL1hRai9WczUvK1BIb1lvSkJHNnRacFdJenZx?=
 =?utf-8?B?OWNwL0JMbHM5OFhXakpsU1VUemwyR1hOTnJKZzlFRUpNSWRHMk1sVmJnNXpN?=
 =?utf-8?B?ZnJJVWNvZHBnVFV2TmdtMGZTWmUyU0dlWi85SFYraWdKNnBrVGJLcVo1VjBD?=
 =?utf-8?B?VDA4aVJqaDdSZUJNMUx4SGwwNEVsUjVQSGxHVFhOR08yaW1GRmhYU0MyWVpO?=
 =?utf-8?B?SS8vSGszOGV3aFdNbTdDRS9GVWpFdTZsVWxLZHBnb2w0OTVNZ1pkSXliRzd4?=
 =?utf-8?B?czZyK2VGaExwY1ovdm5CdHF1dFM3UUp6RisxTEVSUjl0aFlDZkVwN2tQYzIy?=
 =?utf-8?B?WU50OGxTSDdYSHAzRW5kRHN4VlEyYktlQm1PQVdZK3ozVVNCTTJhUUQvdFBv?=
 =?utf-8?B?aEQ5Z2tCQkNnbUkwNGZKU08rT3dOcVFLQ1M1YSswUm1jQ0xSeTNLNGQ1NXc3?=
 =?utf-8?B?eDRWcmNZZVoxNUNwajlaeWVxWEx1OUt4M1FXN1VZSWRWM1pHdDdrejQ5SUhW?=
 =?utf-8?B?T2M2STJVcW8wc0dmbjZ2V2pjM0FWdGJWV0NMYlZ2SDkrZStYNnE2RDJWMCs3?=
 =?utf-8?B?WFpiSWY5ZWh1STloQ205b0VnTWg0WW4yZlUyMGx0NTNzWGZ4cW9lNExmVXVn?=
 =?utf-8?B?bmFpMkEvTDIzSU9IY1ExR0JGdFdXZUswWGQyaEFOWktNYlZiWmdhUzZwUS83?=
 =?utf-8?B?TVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BBEEAE182191DD4486C1745FAD3EECD2@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: n/0SIO5jG1uLkqTMf0lZWTWm2HqzqsMny3jn7otgOCmYAOUuzugxas629t3lgiYj1q7qk0zWgy7yDI7qPKFaYM/QOPl31F/nttjEN/Hde/OA66OrV4BPP3K7nYgi7pcz8Vy70kI+990GyErntN1WFYqTRX4iSqKFM4/GB/4rMgbXdWf8EY8pEhcCFMlVhqtR6Y/wPJ7Rdo6tyBvqLHrfYg0VM4CLK0XijiYMzEMnm8SAIKWTBchjTg4wcErReLIAuXVxU4TInZ9syyQ+sRzpw30uKq5nqQrzDTPlKyjxpq4JE/6wCLtKIxl+xpyuqlx5PH6CTljf5643Ez9k4bw7WJGA5v3iK+OHLTEAKO1gMg0rvKM64BXZMICtT/nUEhDzK3Lrq8r5gFwJO+X+1rvWhd0YKay5vEFuKBHtydPP0GafmJZyMK1OjD3fDoVwJq78iGTT/pivY+/9FMLLMVg1jajiI4GcNkePt8FEOUkXcwvS5gmGmcM+PhJn1pchzBzStJ09p0N1Cye/cAmFa8mVpARGgjFM92NrgoZvDTLYzgNpVj5vCi+MTyOvyY9Cw7IW3qZU/RJzEYLicx59kKLARemco/3RnrvjNj9jUSWZJNJXw/0U/6Zs2HncgJYnzIeXLbERSVMeTK2d+ioZl0wdnULxUH5SBUpgXS5EC2PjMxvWpSn7kFlVWW4PnSoVcJVeFw5XxEl1TG8Y3QJrZJMa2Kj4e3iK7DIrkpEwyz7RiPAOawxPTQDFPWsronuGUjRLlt7jDUJfk5rk/T3rfV+S+nCAN7BhXtztKKOoNUTLvv/kqN+n95ZiHqojoIgUchagatHEJd57ViSKXcisqaEvhQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a625ae5b-0b73-4cd7-08e5-08db6df03ff5
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2023 22:31:23.5623
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fCJd3of8ki6KKgl1e5dsjUjbJyWLkiI4bVHRjNYAeImfbolSRkQHCr2heVeq4wTidllbx5CvjlTpRyd7rQ4DCP1PXQPZujwvmq4naWiui5A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6783
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-15_17,2023-06-15_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxscore=0 adultscore=0 spamscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306150193
X-Proofpoint-GUID: Yb3XE4tlirVLOh5QoBxsKIhz17DlHULV
X-Proofpoint-ORIG-GUID: Yb3XE4tlirVLOh5QoBxsKIhz17DlHULV
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

DQoNCj4gT24gSnVuIDE1LCAyMDIzLCBhdCAzOjE0IFBNLCBEYXZlIENoaW5uZXIgPGRhdmlkQGZy
b21vcmJpdC5jb20+IHdyb3RlOg0KPiANCj4gT24gVGh1LCBKdW4gMTUsIDIwMjMgYXQgMDk6NTc6
MThQTSArMDAwMCwgV2VuZ2FuZyBXYW5nIHdyb3RlOg0KPj4gSGkgRGF2ZSwNCj4+IA0KPj4gSSBn
b3QgdGhpcyBlcnJvciB3aGVuIGFwcGx5aW5nIHRoaXMgcGF0Y2ggdG8gdGhlIG5ld2VzdCBjb2Rl
Og0KPj4gKEkgdHJpZWQgb24gYm90aCBNYWNPUyBhbmQgT0w4LCBpdOKAmXMgdGhlIHNhbWUgcmVz
dWx0KQ0KPj4gDQo+PiAkIHBhdGNoIC1wMSA8fi90bXAvRGF2ZTEudHh0DQo+PiBwYXRjaGluZyBm
aWxlICdmcy94ZnMvbGlieGZzL3hmc19hbGxvYy5jJw0KPj4gcGF0Y2g6ICoqKiogbWFsZm9ybWVk
IHBhdGNoIGF0IGxpbmUgMjc6ICAqLw0KPiANCj4gV2hvYS4gSSBoYXZlbid0IHVzZSBwYXRjaCBs
aWtlIHRoaXMgZm9yIGEgZGVjYWRlLiA6KQ0KPiANCj4gVGhlIHdheSBhbGwgdGhlIGNvb2wga2lk
cyBkbyB0aGlzIG5vdyBpcyBhcHBseSB0aGUgZW50aXJlIHNlcmllcyB0bw0KPiBkaXJlY3RseSB0
byBhIGdpdCB0cmVlIGJyYW5jaCB3aXRoIGI0Og0KPiANCj4gJCBiNCBhbSAtbyAtIDIwMjMwNjE1
MDE0MjAxLjMxNzEzODAtMi1kYXZpZEBmcm9tb3JiaXQuY29tIHwgZ2l0IGFtDQo+IA0KPiAoYjQg
c2hhemFtIG1lcmdlcyB0aGUgYjQgYW0gYW5kIGdpdCBhbSBvcGVyYXRpb25zIGludG8gdGhlIG9u
ZQ0KPiBjb21tYW5kLCBJSVJDLCBidXQgdGhhdCB0cmljayBpc24ndCBhdXRvbWF0aWMgZm9yIG1l
IHlldCA6KQ0KPj4gTG9va2luZyBhdCB0aGUgcGF0Y2ggdG8gc2VlIHRoZSBsaW5lIG51bWJlcnM6
DQo+PiANCj4+IDIyIGRpZmYgLS1naXQgYS9mcy94ZnMvbGlieGZzL3hmc19hbGxvYy5jIGIvZnMv
eGZzL2xpYnhmcy94ZnNfYWxsb2MuYw0KPj4gMjMgaW5kZXggYzIwZmU5OTQwNWQ4Li4xMWJkMGEx
NzU2YTEgMTAwNjQ0DQo+PiAyNCAtLS0gYS9mcy94ZnMvbGlieGZzL3hmc19hbGxvYy5jDQo+PiAy
NSArKysgYi9mcy94ZnMvbGlieGZzL3hmc19hbGxvYy5jDQo+PiAyNiBAQCAtMTUzNiw3ICsxNTM2
LDggQEAgeGZzX2FsbG9jX2FnX3ZleHRlbnRfbGFzdGJsb2NrKA0KPj4gMjcgICovDQo+PiAyOCBT
VEFUSUMgaW50DQo+PiAyOSB4ZnNfYWxsb2NfYWdfdmV4dGVudF9uZWFyKA0KPiANCj4gWXVwLCBo
b3dldmVyIHlvdSBzYXZlZCB0aGUgcGF0Y2ggdG8gYSBmaWxlIHN0cmlwcGVkIHRoZSBsZWFkaW5n
DQo+IHNwYWNlcyBmcm9tIGFsbCB0aGUgbGluZXMgaW4gdGhlIHBhdGNoLg0KPiANCj4gSWYgeW91
IGxvb2sgYXQgdGhlIHJhdyBlbWFpbCBvbiBsb3JlIGl0IGhhcyB0aGUgY29ycmVjdCBsZWFkaW5n
DQo+IHNwYWNlcyBpbiB0aGUgcGF0Y2guDQo+IA0KPiBodHRwczovL2xvcmUua2VybmVsLm9yZy9s
aW51eC14ZnMvMjAyMzA2MTUwMTQyMDEuMzE3MTM4MC0yLWRhdmlkQGZyb21vcmJpdC5jb20vcmF3
DQo+IA0KPiBUaGVzZSBzb3J0cyBvZiBwYXRjaGluZyBwcm9ibGVtcyBnbyBhd2F5IHdoZW4geW91
IHVzZSB0b29scyBsaWtlIGI0DQo+IHRvIHB1bGwgdGhlIHBhdGNoZXMgZGlyZWN0bHkgZnJvbSB0
aGUgbWFpbGluZyBsaXN0Li4uDQo+IA0KPj4+IE9uIEp1biAxNCwgMjAyMywgYXQgNjo0MSBQTSwg
RGF2ZSBDaGlubmVyIDxkYXZpZEBmcm9tb3JiaXQuY29tPiB3cm90ZToNCj4+PiANCj4+PiBGcm9t
OiBEYXZlIENoaW5uZXIgPGRjaGlubmVyQHJlZGhhdC5jb20+DQo+Pj4gDQo+Pj4gVG8gYXZvaWQg
YmxvY2tpbmcgaW4geGZzX2V4dGVudF9idXN5X2ZsdXNoKCkgd2hlbiBmcmVlaW5nIGV4dGVudHMN
Cj4+PiBhbmQgdGhlIG9ubHkgYnVzeSBleHRlbnRzIGFyZSBoZWxkIGJ5IHRoZSBjdXJyZW50IHRy
YW5zYWN0aW9uLCB3ZQ0KPj4+IG5lZWQgdG8gcGFzcyB0aGUgWEZTX0FMTE9DX0ZMQUdfRlJFRUlO
RyBmbGFnIGNvbnRleHQgYWxsIHRoZSB3YXkNCj4+PiBpbnRvIHhmc19leHRlbnRfYnVzeV9mbHVz
aCgpLg0KPj4+IA0KPj4+IFNpZ25lZC1vZmYtYnk6IERhdmUgQ2hpbm5lciA8ZGNoaW5uZXJAcmVk
aGF0LmNvbT4NCj4+PiAtLS0NCj4+PiBmcy94ZnMvbGlieGZzL3hmc19hbGxvYy5jIHwgOTYgKysr
KysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0tDQo+Pj4gZnMveGZzL2xpYnhmcy94
ZnNfYWxsb2MuaCB8ICAyICstDQo+Pj4gZnMveGZzL3hmc19leHRlbnRfYnVzeS5jICB8ICAzICst
DQo+Pj4gZnMveGZzL3hmc19leHRlbnRfYnVzeS5oICB8ICAyICstDQo+Pj4gNCBmaWxlcyBjaGFu
Z2VkLCA1NiBpbnNlcnRpb25zKCspLCA0NyBkZWxldGlvbnMoLSkNCj4+PiANCj4+PiBkaWZmIC0t
Z2l0IGEvZnMveGZzL2xpYnhmcy94ZnNfYWxsb2MuYyBiL2ZzL3hmcy9saWJ4ZnMveGZzX2FsbG9j
LmMNCj4+PiBpbmRleCBjMjBmZTk5NDA1ZDguLjExYmQwYTE3NTZhMSAxMDA2NDQNCj4+PiAtLS0g
YS9mcy94ZnMvbGlieGZzL3hmc19hbGxvYy5jDQo+Pj4gKysrIGIvZnMveGZzL2xpYnhmcy94ZnNf
YWxsb2MuYw0KPj4+IEBAIC0xNTM2LDcgKzE1MzYsOCBAQCB4ZnNfYWxsb2NfYWdfdmV4dGVudF9s
YXN0YmxvY2soDQo+Pj4gKi8NCj4+PiBTVEFUSUMgaW50DQo+Pj4geGZzX2FsbG9jX2FnX3ZleHRl
bnRfbmVhcigNCj4+PiAtIHN0cnVjdCB4ZnNfYWxsb2NfYXJnICphcmdzKQ0KPj4+ICsgc3RydWN0
IHhmc19hbGxvY19hcmcgKmFyZ3MsDQo+Pj4gKyB1aW50MzJfdCBhbGxvY19mbGFncykNCj4+PiB7
DQo+Pj4gc3RydWN0IHhmc19hbGxvY19jdXIgYWN1ciA9IHt9Ow0KPj4+IGludCBlcnJvcjsgLyog
ZXJyb3IgY29kZSAqLw0KPiANCj4gVGhpcyBpbmRpY2F0ZXMgdGhlIHByb2JsZW0gaXMgbGlrZWx5
IHRvIGJlIHlvdXIgbWFpbCBwcm9ncmFtLA0KPiBiZWNhdXNlIHRoZSBxdW90aW5nIGl0IGhhcyBk
b25lIGhlcmUgaGFzIGNvbXBsZXRlbHkgbWFuZ2xlZCBhbGwgdGhlDQo+IHdoaXRlc3BhY2UgaW4g
dGhlIHBhdGNoLi4uLg0KPiANCg0KUmlnaHQsIHRoZSAudHh0IHdhcyBub3QgcmF3Lg0KTm93IEkg
Z290IHRoZSByYXcgZm9ybWF0cyBhbmQgdGhleSBhcHBsaWVkIHRvIHVwc3RyZWFtIG1hc3Rlci4g
TGV0IG1lIHJ1biBsb2cgcmVjb3ZlciB3aXRoIG15IG1ldGFkdW1wLCB3aWxsIHJlcG9ydCByZXN1
bHQgbGF0ZXIuDQoNCnRoYW5rcywNCndlbmdhbmcNCg0KPiBDaGVlcnMsDQo+IA0KPiBEYXZlLg0K
PiAtLSANCj4gRGF2ZSBDaGlubmVyDQo+IGRhdmlkQGZyb21vcmJpdC5jb20NCg0KDQo=
