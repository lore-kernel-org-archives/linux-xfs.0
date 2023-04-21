Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB6E5C77B73
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Apr 2023 00:32:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231865AbjDUAcW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Apr 2023 20:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjDUAcV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Apr 2023 20:32:21 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B4592116
        for <linux-xfs@vger.kernel.org>; Thu, 20 Apr 2023 17:32:20 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33KNEdgv010986;
        Fri, 21 Apr 2023 00:32:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=BYZGRfW6Bxbonku5MJF2n1kSfzF4gQNOQWGFdgOvgLM=;
 b=WLCef5p+sURCTWE7i8ekw4q0tG8RXL/e92dcWFbfLug/YuKxNRyK4RZR7Y7ZcvMHd3BI
 xml14/99SmanGl5NZMvvQ5auPEJjkLiLUgCug1Agx7PaR/CZOg6Cwj+vbzbgkhm0+ZqH
 KPbbFaTdHfbKBQ5L/7ifysiX0hUG3fRtoSjitTNJbDF9LFQ5FmH/i/7fmtBmaTtN2Ve+
 kzWZzhteFEZQll2+mjn/voxiZ8zk3CJLV+v7qMGRvTDI59u+P2zV+8/ApvEigOL83iMW
 L6ghsYFVrAV9t/ymYZkDXt5mfszS+9IMSvJJ9GP5quo65l7Gx/sAz2GtwBcJ8vVfTHe6 Xw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pymfum6dh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Apr 2023 00:32:18 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33KNnK3Z037960;
        Fri, 21 Apr 2023 00:32:18 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3pyjc8ydkg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Apr 2023 00:32:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q0zdTL32gB6hFP5DfiDj7WQHDV1excMgyeDxXsN9lgD3mdm/xJtcjboyHezz03YUZ8oRW1AUX4N+8Xri83T9kPNPFA95+pLCnO+gkFDU+cqAfkOmemsWGF2qlgjMJvKNAbLxROD6Spcz91YOdRujq2REq46IxP/OzEAv1QuRVcVWb1VoNlutA3+LIcfK/9IqX9HC7LmIA/Lw9AI/cHh39oRSyUOPus0rfHlnxIVkB1QaLhwfHHLg1J4Um+Xn40L73IzFIaEaRkehcWOG3lkHwK+YQ7zyPciiQlxyf33+glSP8om1iqauMuyV5qwUvRddSTWCAW4+4rXro9HJIvR3qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BYZGRfW6Bxbonku5MJF2n1kSfzF4gQNOQWGFdgOvgLM=;
 b=b651yt0qwY1T6t2pq4yQMTgimi57mIBIZTTkTn7S9SjzwAZ10sD7ye14W9mUPr57HKXmjLAGQJDrRwFEN/tEUGOFwrRNciKjbyGaEKg/FeU5JnPpla/WOkF0NxgCSZNsnIioWhSei7qNqlwSRd7NThptJnhkaWltY+YRGlkjF21URR9bwga6LR+ZWo0vmMxUe1k/BmDb/8afbl8riYQN2e/pRac7GLrDM1wAgsP5W/Feq7mWPQ5qzjLjdoFNoGTY6f5mwsxO7H0lpv7Kc3eGVJeNg6r5EQJaUUy/JJhgCwIAUPNko08MlqRf+peKcEtK3GxHbHPMjx5iUSHkucDzrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BYZGRfW6Bxbonku5MJF2n1kSfzF4gQNOQWGFdgOvgLM=;
 b=IwGDbeAkMmc7pMQedp5UmmmFARg5cUChkM+M4ei74ytxMKRTPvE4E697V/aR5ABSSbTz7SzmNcBEWnNHfdEBlHczJT1L95KvLb9SVkH1Oh+P6FzxU9+F75VEWvDPTaUVZoQIZV32tOt4qzdP7mFILQvgUv30ATuykkPZMZSoFvs=
Received: from SN6PR10MB2701.namprd10.prod.outlook.com (2603:10b6:805:45::20)
 by SA1PR10MB6469.namprd10.prod.outlook.com (2603:10b6:806:29d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Fri, 21 Apr
 2023 00:32:15 +0000
Received: from SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::58cd:8b89:f285:ca2b]) by SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::58cd:8b89:f285:ca2b%6]) with mapi id 15.20.6319.022; Fri, 21 Apr 2023
 00:32:15 +0000
From:   Wengang Wang <wen.gang.wang@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] xfs: log recovery stage split EFIs with multiple
 extents
Thread-Topic: [PATCH 2/2] xfs: log recovery stage split EFIs with multiple
 extents
Thread-Index: AQHZbySnyB0tBYYonkGJ9xOudd8YMq8zYG0AgAEXTYCAAGAPAIAAG1KA
Date:   Fri, 21 Apr 2023 00:32:15 +0000
Message-ID: <A6789F19-BE44-4545-B26A-7AE96AB5F4CF@oracle.com>
References: <20230414225836.8952-1-wen.gang.wang@oracle.com>
 <20230414225836.8952-3-wen.gang.wang@oracle.com>
 <20230420003050.GX3223426@dread.disaster.area>
 <C92853D7-A856-4BCC-880E-6DE6D3CC4EF8@oracle.com>
 <20230420225418.GY3223426@dread.disaster.area>
In-Reply-To: <20230420225418.GY3223426@dread.disaster.area>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.400.51.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2701:EE_|SA1PR10MB6469:EE_
x-ms-office365-filtering-correlation-id: 6adb23d4-bede-4b88-2f0d-08db41ffdb7d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: unHSOTvaPMYbIQXRlv02SPqlK3GWmnttXeA0Wcp8Hi1qg0euUNyXglQTDb6Pi3ZIidheOMRGUN8dQkoTg6w7VphySjnPzYj31moKBfh3jsegXiDeT5EAJSXpTfn6HKbajyj37lyvYm4LmCTNDvhLbHmsLWrPWq7WgN0gYXiwaqqvWCNXJMaIgF4DHnrUckXfPkMrTOLi2smwYHnCFMCjyDeAdWiIPcLwK9RvBuW8ji4DpqPnrB6G592RtCnaEiXPXPwLfiDYljS4J8ROTqIWeAIQHVgpQWDSII+qaRFG/OxfzK5GS+PUmiO+nmXzX0l4jywskub0RCB5kbBJbAvymH52KK9CHn9f8NgGvxg37X6jUl2+8CkXhZumOhkIuCJneHzvjcTGTiNcHrCp8+RAJkSXZXJPKBqgu8xUxu1JBLYXl/SvLIvlbBGPmU+jfYi8cY2LkKS4yZmtu7BZz1vOtvM1+CYNSicNCLnr5WnvO/vm18Fo1bMaIEdzhaLUDLWTI891LRlN0kgbS3fAQnWDJiHUuRdvgbJb+tmJJTRz415Bjp916FwjsQoO0mOv0s35wNNNNJ2AxwtSnEXWj23jn2sNGx52nFVXPc52d/zaQKfBEsDvxMRexmfJ+xwat5PkcdEHiYYQZfx+CKcZmARijQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2701.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(346002)(366004)(136003)(396003)(451199021)(36756003)(6916009)(4326008)(316002)(76116006)(66946007)(66556008)(66446008)(66476007)(64756008)(53546011)(186003)(6512007)(6506007)(2616005)(83380400001)(122000001)(38100700002)(41300700001)(8676002)(5660300002)(478600001)(8936002)(71200400001)(6486002)(2906002)(33656002)(38070700005)(86362001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R2ZWMmYwZllJSnQ1bDd4NGhXb3ZMYjlCN2lNa09YaFhYR0NJeGZxd1dBRzlE?=
 =?utf-8?B?UzZ3aGdBWHhERUsyNnllZUFGSk43NUFiZkNiSkFPa2JZcHBFejF4MmY4VFY5?=
 =?utf-8?B?TGJ1dUJWRThXTWhobFRzMUZrNytyOHd5a0hEaFB2eUExTjZhS09XK0VHbWRt?=
 =?utf-8?B?b1B2N0pCbTBhMS9LWndDMUl4c0FUMHpXV2RiRkpQK0ZjU3dCL00rMlFMTlFr?=
 =?utf-8?B?dy9IWWowSFpneE5oR3Y1YUdIVWhKTzhOYzlQblQyUFcxN1pKeGovYk1FR0hR?=
 =?utf-8?B?T2tDdFNNajNTU25seCt0KzQxbk0rOXZIYnhTVFhLSCtZQURkZlhRZlFXYjJy?=
 =?utf-8?B?T2QvUVBBUXdXajlYV2l4TXpmeW1LZTB5Mm4vOWtRZERIMWhraFRmTXFmWm9n?=
 =?utf-8?B?TlIwclVJeWtSVlgwbW1mblBCbEJURGh1cERjL1lYaE1FNk5TRFpLRW9mbnhW?=
 =?utf-8?B?Z3VxRlkzaTJVMGV5KzA0QVQ3U0FsaitNano4ZEt5dHpJdkloUGNUZ0ZYOGJF?=
 =?utf-8?B?eUN2UDU1WjRhMXMrZnpMNmV0LzJUbUJMV2tuS2pXR2l1Y0FweWtBd2lSTzlM?=
 =?utf-8?B?OFU2NmZpMkNNSUxQU1B0MXJ4dVJETHdVSXQ4clBYWGl6RTdsZXY3UURFdStL?=
 =?utf-8?B?Z3hYbks3RGlRS1JVUXJHdnBDbzlaeTczcDhobUN4SUhyZG5rdWZOODNvNFVH?=
 =?utf-8?B?ZS9KdWZvMWMvWkNEcGtkWVZiYmRvcE5lUVJPc0RHdkNYZ0drS1d4UlM0VGNF?=
 =?utf-8?B?Y2ZhVE9QOU5sSXdOci9abTJnNXY4YjFDaGo1VUJRNFNDaEErdmszVXVSQXJn?=
 =?utf-8?B?Q24zbUp3V3lDWlliUStsYzNCeDRYM25vejUrdG43MWd1MGpUTHhFQjUvUVNF?=
 =?utf-8?B?MkRwVFJuSkhFVEswWThnelphdzRmQnFkV2Voczg4cW9IL3ZtTjZzMVF0dnQ2?=
 =?utf-8?B?M053MndsV05JbWpjZ3U0eE5HUTBDdm9YVjNjRDNPZmRXK29kYk5YU05SeG1h?=
 =?utf-8?B?dlUwaWg3UG4vdkIvaURQMXFpQWNjdklLanVCK093VnI1QVJhM0VHSlczRTdX?=
 =?utf-8?B?SlRtUVQ3VEZHVUNJdG12RGFJcE5xUmZ3Z29WT1hOdHVsM0RWY2JwSkxNOU1v?=
 =?utf-8?B?ZW9pYWdPcGsxVm9aUGZ0ZUgrcCt3anRCTlZoV2UxZ3lGL3ZHSTF0a3lhOTNl?=
 =?utf-8?B?VnhmSkRzOXlPcE84STlrRTZYM2NQOUM1RUI2WVlNMVlXcmkrUE1Lam5EUjhU?=
 =?utf-8?B?T0YvdzdKbDc2SHBtVjBCUmlIWjRkMGFQL0dFYVp3RnR5MTZlU1hjTkxVOFJp?=
 =?utf-8?B?VmRHNThOTXBJbVlLbDIydy9lVUpHbHhlSUZWWmViUVJ5a3FCQVkyNS9MTWV1?=
 =?utf-8?B?NnM2SzBReG96THhqb3o1MTUyK0w4MGI5RjVhdVdsNTFSajUwdnFxU2V4QnlL?=
 =?utf-8?B?cGFPK3hYdVdBNWh3N05TSVdaVjg5OUVrUVNBWmx0RUw0YUtIZmZMbGN3WmZC?=
 =?utf-8?B?TFI0Y2l1UHFoUytKVFZXK2NocHZFV25oZDVhSm82V00yVWVZUTc3bUw4T0FI?=
 =?utf-8?B?eUhYNkVuOEgwZlhuYTcrMTlqUExaTndNL0tobUJlc1Fzay9MdUpMVm92RUsx?=
 =?utf-8?B?VmJ5VXQ0UGNCL3hBd2s1dG9aR0hnTVJ6aUoxK3VpSm9GYTc5eGs2V1RWY2JD?=
 =?utf-8?B?c3lGMnIzaExKWnJhVFpqQWhRMk1CQjVPWXRXYSs0c215Snkxd04zOHQwRmFK?=
 =?utf-8?B?TTltaWFPNmxFaDJZY1dCb1RTaGcwT0dxWmJWaUEvSDdkTWJkdzJSeU9oSGJI?=
 =?utf-8?B?am1qWm1yMFlRZ25iS24vQWJrYmdiLzFsZVZFbms3OGl5SmJpRTVPdjBmSHdE?=
 =?utf-8?B?cUZpMHV6M1dyVFl5dUg2Nm1PakRWSi9WeTBJMzJndmZFUEFINnBRbEFQRWxV?=
 =?utf-8?B?b3dPUkovMUNZRnQ5SThxeUhGcW5vdDNCcTZHRXJSZnJkRit3SzUzVUxmZ1d3?=
 =?utf-8?B?RElvKy90Tm9nNFpvN2JuNWU5d3hYL1ZIN1lnaFdQTk9CUVlrRnhWR2p1UDBj?=
 =?utf-8?B?THk0Zk1vb3hUVEwzWXYxckRPUkhQc3p2UTBSWEZlV2lWaENiRkUzMDlTOWU0?=
 =?utf-8?B?a0xzM1lYUnptZjNSa2lkVHc3V1RxcG5ianBKK3dVcHR6TGF3Y0hCQzBodSth?=
 =?utf-8?Q?CW464OcQviWtCx+uzk3HP5MNAbK70mDgJ0lQIuwCenBd?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A8471AFC9E84C94A8BA594DFD8CEAE2A@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 37M2jCtyXCBnF4I9arxRryVQRB2WJYvoj+41kBV/9KTIyLbCg0N2sxACSrAZTmAWvbAEhi68hro3h8Hf/rDvTgX4JEoZHsZf3iPXLPT61Lx8cKEs8fJ26sJiwJPwn0EuIxqi28LZNXsn4sECqHzqwB0q9JLfPLGmc/gEU2i07HPONMofbR3jlbhc595Bxau490KgnKVeB8oetXP+PKMpLid2BJ97djjIf3pdL+nZCAyHpf+5V1PSg0mXo5HUdmQgulvXffUydEu6g+soPJ8vOj8aw5o1Yae6bgiMVFvnMfLHjyeKcNKHaLTsH87BGMBGcsfnIFv1zjEoOypAnEluD4Hm2y/8tqswN5YcqM4PpdSNhVver+pyzHFzZOWKHXPCHqOIQg6dqzkM8Yl9WseRN6ngdrC9qdih69h3/ScnQDjPzNmRYZ3z30ltmaM5YEi5wpzjpoq/MOF+Vyv+I4NWtAzyxN87Dw7sSBXqT4vV8SCoAdcIHJwomYEr2HDTkvRyf6OKxZJ79P6IyXLRFPb//Mp8CBA9vT6UOG2Q9mOWf7w46QW0PX/9mgLeHsX6U/k6Pc9hGVbWWGKHmCPzBEiNWhzfCvAB0SbTqW1IDqyprGOHtW6jxThNCB5ji5esF0vQQqX04TBGxe+DG35xbN3GYhXRRM76zLNi5+p5Ez2ty8Kj7wM957/nK79vuCd/N65IBeluMRY4GDLxLP4PBqNV5N8ejXYIt0KIBcoCsRVQP5NrVv3agrVXtbzUe3ld61rCP9jspUiGSnwEoEevOz1h3QB9GpjvjgF97FmtDxdbxpM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6adb23d4-bede-4b88-2f0d-08db41ffdb7d
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2023 00:32:15.7627
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bDK87nXGujd9CxQzW/VuXDoIeMwl0qzlpfq9Dmc06cCg5NdMbrZ+e0QGDcpF78qbU1Fw1SdYbak6hp9DskpYPI/tr8RTYYnHHOVQMX8fDSE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6469
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-20_17,2023-04-20_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 spamscore=0 malwarescore=0 suspectscore=0 mlxscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304210002
X-Proofpoint-GUID: 1dApQwNicegYCy6tTcYyBig8zY1hhs1e
X-Proofpoint-ORIG-GUID: 1dApQwNicegYCy6tTcYyBig8zY1hhs1e
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

DQoNCj4gT24gQXByIDIwLCAyMDIzLCBhdCAzOjU0IFBNLCBEYXZlIENoaW5uZXIgPGRhdmlkQGZy
b21vcmJpdC5jb20+IHdyb3RlOg0KPiANCj4gT24gVGh1LCBBcHIgMjAsIDIwMjMgYXQgMDU6MTA6
NDJQTSArMDAwMCwgV2VuZ2FuZyBXYW5nIHdyb3RlOg0KPj4gDQo+PiANCj4+PiBPbiBBcHIgMTks
IDIwMjMsIGF0IDU6MzAgUE0sIERhdmUgQ2hpbm5lciA8ZGF2aWRAZnJvbW9yYml0LmNvbT4gd3Jv
dGU6DQo+Pj4gDQo+Pj4gT24gRnJpLCBBcHIgMTQsIDIwMjMgYXQgMDM6NTg6MzZQTSAtMDcwMCwg
V2VuZ2FuZyBXYW5nIHdyb3RlOg0KPj4+PiBBdCBsb2cgcmVjb3Zlcnkgc3RhZ2UsIHdlIG5lZWQg
dG8gc3BsaXQgRUZJcyB3aXRoIG11bHRpcGxlIGV4dGVudHMuIEZvciBlYWNoDQo+Pj4+IG9yZ2lu
YWwgbXVsdGlwbGUtZXh0ZW50IEVGSSwgc3BsaXQgaXQgaW50byBuZXcgRUZJcyBlYWNoIGluY2x1
ZGluZyBvbmUgZXh0ZW50DQo+Pj4+IGZyb20gdGhlIG9yaWdpbmFsIEVGSS4gQnkgdGhhdCB3ZSBh
dm9pZCBkZWFkbG9jayB3aGVuIGFsbG9jYXRpbmcgYmxvY2tzIGZvcg0KPj4+PiBBR0ZMIHdhaXRp
bmcgZm9yIHRoZSBoZWxkIGJ1c3kgZXh0ZW50cyBieSBjdXJyZW50IHRyYW5zYWN0aW9uIHRvIGJl
IGZsdXNoZWQuDQo+Pj4+IA0KPj4+PiBGb3IgdGhlIG9yaWdpbmFsIEVGSSwgdGhlIHByb2Nlc3Mg
aXMNCj4+Pj4gMS4gQ3JlYXRlIGFuZCBsb2cgbmV3IEVGSXMgZWFjaCBjb3ZlcmluZyBvbmUgZXh0
ZW50IGZyb20gdGhlDQo+Pj4+ICAgb3JpZ2luYWwgRUZJLg0KPj4+PiAyLiBEb24ndCBmcmVlIGV4
dGVudCB3aXRoIHRoZSBvcmlnaW5hbCBFRkkuDQo+Pj4+IDMuIExvZyBFRkQgZm9yIHRoZSBvcmln
aW5hbCBFRkkuDQo+Pj4+ICAgTWFrZSBzdXJlIHdlIGxvZyB0aGUgbmV3IEVGSXMgYW5kIG9yaWdp
bmFsIEVGRCBpbiB0aGlzIG9yZGVyOg0KPj4+PiAgICAgbmV3IEVGSSAxDQo+Pj4+ICAgICBuZXcg
RUZJIDINCj4+Pj4gICAgIC4uLg0KPj4+PiAgICAgbmV3IEVGSSBODQo+Pj4+ICAgICBvcmlnaW5h
bCBFRkQNCj4+Pj4gVGhlIG9yaWdpbmFsIGV4dGVudHMgYXJlIGZyZWVkIHdpdGggdGhlIG5ldyBF
RklzLg0KPj4+IA0KPj4+IFdlIG1heSBub3QgaGF2ZSB0aGUgbG9nIHNwYWNlIGF2YWlsYWJsZSBk
dXJpbmcgcmVjb3ZlcnkgdG8gZXhwbG9kZSBhDQo+Pj4gc2luZ2xlIEVGSSBvdXQgaW50byBtYW55
IEVGSXMgbGlrZSB0aGlzLiBUaGUgRUZJIG9ubHkgaGFkIGVub3VnaA0KPj4+IHNwYWNlIHJlc2Vy
dmVkIGZvciBwcm9jZXNzaW5nIGEgc2luZ2xlIEVGSSwgYW5kIGV4cGxvZGluZyBhIHNpbmdsZQ0K
Pj4+IEVGSSBvdXQgbGlrZSB0aGlzIHJlcXVpcmVzIGFuIGluZGl2aWR1YWwgbG9nIHJlc2VydmF0
aW9uIGZvciBlYWNoDQo+Pj4gbmV3IEVGSS4gSGVuY2UgdGhpcyBkZS1tdWx0aXBsZXhpbmcgcHJv
Y2VzcyByaXNrcyBydW5uaW5nIG91dCBvZiBsb2cNCj4+PiBzcGFjZSBhbmQgZGVhZGxvY2tpbmcg
YmVmb3JlIHdlJ3ZlIGJlZW4gYWJsZSB0byBwcm9jZXNzIGFueXRoaW5nLg0KPj4+IA0KPj4gDQo+
PiBPaCwgeWVzLCBnb3QgaXQuDQo+PiANCj4+PiBIZW5jZSB0aGUgb25seSBvcHRpb24gd2UgcmVh
bGx5IGhhdmUgaGVyZSBpcyB0byByZXBsaWNhdGUgaG93IENVSXMNCj4+PiBhcmUgaGFuZGxlZC4g
IFdlIG11c3QgcHJvY2VzcyB0aGUgZmlyc3QgZXh0ZW50IHdpdGggYSB3aG9sZSBFRkQgYW5kDQo+
Pj4gYSBuZXcgRUZJIGNvbnRhaW5pbmcgdGhlIHJlbWFpbmluZyB1bnByb2Nlc3NlZCBleHRlbnRz
IGFzIGRlZmVyZWQNCj4+PiBvcGVyYXRpb25zLiAgaS5lLg0KPj4+IA0KPj4+IDEuIGZyZWUgdGhl
IGZpcnN0IGV4dGVudCBpbiB0aGUgb3JpZ2luYWwgRUZJDQo+Pj4gMi4gbG9nIGFuIEVGRCBmb3Ig
dGhlIG9yaWdpbmFsIEVGSQ0KPj4+IDMuIEFkZCBhbGwgdGhlIHJlbWFpbmluZyBleHRlbnRzIGlu
IHRoZSBvcmlnaW5hbCBFRkkgdG8gYW4geGVmaSBjaGFpbg0KPj4+IDQuIENhbGwgeGZzX2RlZmVy
X29wc19jYXB0dXJlX2FuZF9jb21taXQoKSB0byBjcmVhdGUgYSBuZXcgRUZJIGZyb20NCj4+PiAg
dGhlIHhlZmkgY2hhaW4gYW5kIGNvbW1pdCB0aGUgY3VycmVudCB0cmFuc2FjdGlvbi4NCj4+PiAN
Cj4+PiB4ZnNfZGVmZXJfb3BzX2NhcHR1cmVfYW5kX2NvbW1pdCgpIHdpbGwgdGhlbiBhZGQgYSB3
b3JrIGl0ZW0gdG8gdGhlDQo+Pj4gZGVmZXJlZCBsaXN0IHdoaWNoIHdpbGwgY29tZSBiYWNrIHRv
IHRoZSBuZXcgRUZJIGFuZCBwcm9jZXNzIGl0DQo+Pj4gdGhyb3VnaCB0aGUgbm9ybWFsIHJ1bnRp
bWUgZGVmZXJyZWQgb3BzIGludGVudCBwcm9jZXNzaW5nIHBhdGguDQo+Pj4gDQo+PiANCj4+IFNv
IHlvdSBtZWFudCB0aGlzPw0KPj4gDQo+PiBPcmlnIEVGSSB3aXRoIGV4dGVudDEgZXh0ZW50MiBl
eHRlbnQzDQo+PiBmcmVlIGZpcnN0IGV4dGVudDENCj4+IEZ1bGwgRUZEIHRvIG9yaWcgRUZJDQo+
PiB0cmFuc2FjdGlvbiByb2xsLA0KPj4geGZzX2RlZmVyX29wc19jYXB0dXJlX2FuZF9jb21taXQo
KSB0byB0YWtlIGNhcmUgb2YgZXh0ZW50MiBhbmQgZXh0ZW50Mw0KPiANCj4gTm8uIFdlIGRvIG5v
dCBuZWVkIGEgdHJhbnNhY3Rpb24gcm9sbCB0aGVyZSBpZiB3ZSByZWJ1aWxkIGEgbmV3DQo+IHhl
ZmkgbGlzdCB3aXRoIHRoZSByZW1haW5pbmcgZXh0ZW50cyBmcm9tIHRoZSBvcmlnaW5hbCBlZmku
IEF0IHRoYXQNCj4gcG9pbnQsIHdlIGNhbGw6DQo+IA0KPiA8Y3JlYXRlIHRyYW5zYWN0aW9uPg0K
PiA8ZnJlZSBmaXJzdCBleHRlbnQ+DQo+IDxjcmVhdGUgbmV3IHhlZmkgbGlzdD4NCj4gPGNyZWF0
ZSBhbmQgbG9nIEVGRD4NCj4geGZzX2RlZmVyX29wc19jYXB0dXJlX2FuZF9jb21taXQoKQ0KPiAg
IHhmc19kZWZlcl9vcHNfY2FwdHVyZSgpDQo+ICAgICB4ZnNfZGVmZXJfY3JlYXRlX2ludGVudHMo
KQ0KPiAgICAgICBmb3IgZWFjaCB0cC0+dF9kZm9wcw0KPiAgICAgICAgIC0+Y3JlYXRlIGludGVu
dA0KPiAgIHhmc19leHRlbnRfZnJlZV9jcmVhdGVfaW50ZW50KCkNCj4gICAgIGNyZWF0ZSBuZXcg
RUZJDQo+ICAgICB3YWxrIGVhY2ggeGVmaSBhbmQgYWRkIGl0IHRvIHRoZSBuZXcgaW50ZW50DQo+
ICAgICA8Y2FwdHVyZXMgcmVtYWluaW5nIGRlZmVyZWQgd29yaz4NCj4gICB4ZnNfdHJhbnNfY29t
bWl0KCkNCj4gDQo+IGkuZS4geGZzX2RlZmVyX29wc19jYXB0dXJlX2FuZF9jb21taXQoKSBjYW4g
YnVpbGRzIG5ldyBFRkkgZm9yIHVzDQo+IGZyb20gdGhlIHhlZmkgbGlzdCBhcyBwYXJ0IG9mIGRl
ZmVyaW5nIHRoZSB3b3JrIHRoYXQgcmVtYWlucyB0byBiZQ0KPiBkb25lLiBPbmNlIGl0IGhhcyBk
b25lIHRoYXQsIGl0IHF1ZXVlcyB0aGUgcmVtYWluaW5nIHdvcmsgYW5kDQo+IGNvbW1pdHMgdGhl
IHRyYW5zYWN0aW9uLiBIZW5jZSBhbGwgd2UgbmVlZCB0byBkbyBpbiByZWNvdmVyeSBvZiB0aGUN
Cj4gZmlyc3QgZXh0ZW50IGlzIGZyZWUgaXQsIGNyZWF0ZSB0aGUgeGVmaSBsaXN0IGFuZCBsb2cg
dGhlIGZ1bGwgRUZELg0KPiB4ZnNfZGVmZXJfb3BzX2NhcHR1cmVfYW5kX2NvbW1pdCgpIGRvZXMg
dGhlIHJlc3QuDQoNClllcywgeGZzX2RlZmVyX29wc19jYXB0dXJlX2FuZF9jb21taXQgd2lsbCBj
b21taXQgdGhlIHRyYW5zYWN0aW9uIHNvIHdlDQpkb27igJl0IG5lZWQgYSByb2xsLg0KDQo+IA0K
Pj4gSWYgc28sIEkgZG9u4oCZdCB0aGluayBpdOKAmXMgc2FmZS4NCj4+IENvbnNpZGVyIHRoYXQg
Y2FzZSB0aGF0IGtlcm5lbCBwYW5pYyBoYXBwZW5lZCBhZnRlciB0aGUgdHJhbnNhY3Rpb24gcm9s
bCwNCj4+IGR1cmluZyBuZXh0IGxvZyByZXBsYXksIHRoZSBvcmlnaW5hbCBFRkkgaGFzIHRoZSBt
YXRjaGluZyBFRkQsIHNvIHRoaXMgRUZJDQo+PiBpcyBpZ25vcmVkLCBidXQgYWN0dWFsbHkgZXh0
ZW50MiBhbmQgZXh0ZW50MyBhcmUgbm90IGZyZWVkLg0KPj4gDQo+PiBJZiB5b3UgZGlkbuKAmXQg
bWVhbiBhYm92ZSwgYnV0IGluc3RlYWQgdGhpczoNCj4+IA0KPj4gT3JpZyBFRkkgd2l0aCBleHRl
bnQxIGV4dGVudDIgZXh0ZW50Mw0KPj4gZnJlZSBmaXJzdCBleHRlbnQxDQo+PiBOZXcgRUZJIGV4
dGVudDIgZXh0ZW50Mw0KPj4gRnVsbCBFRkQgdG8gb3JpZyBFRkkNCj4+IHRyYW5zYWN0aW9uIHJv
bGwsDQo+PiB4ZnNfZGVmZXJfb3BzX2NhcHR1cmVfYW5kX2NvbW1pdCgpIHRvIHRha2UgY2FyZSBv
ZiBleHRlbnQyIGFuZCBleHRlbnQzDQo+PiANCj4+IFRoZSBwcm9ibGVtIHdpbGwgY29tZWJhY2sg
dG8gdGhlIGxvZyBzcGFjZSBpc3N1ZSwgYXJlIHdlIGVuc3VyZWQgd2UgaGF2ZQ0KPj4gdGhlIHNw
YWNlIGZvciB0aGUgbmV3IEVGST8gDQo+IA0KPiBZZXMsIGJlY2F1c2UgbG9nZ2luZyB0aGUgZnVs
bCBFRkQgY2FuY2VscyB0aGUgb3JpZ2luYWwgRUZJIGFuZCBzbyBpdA0KPiBubyBsb25nZXIgY29u
c3VtZXMgbG9nIHNwYWNlLiBoZW5jZSB3ZSBjYW4gbG9nIGEgbmV3IEVGSSB1c2luZyB0aGUNCj4g
c3BhY2UgdGhlIG9yaWdpbmFsIEVGSSBjb25zdW1lZC4NCj4gDQoNCk1ha2Ugc2Vuc2UuDQoNCj4+
PiBUaGUgZmlyc3QgcGF0Y2ggY2hhbmdlZCB0aGF0IHBhdGggdG8gb25seSBjcmVhdGUgaW50ZW50
cyB3aXRoIGENCj4+PiBzaW5nbGUgZXh0ZW50LCBzbyB0aGUgY29udGludWVkIGRlZmVyIG9wcyB3
b3VsZCB0aGVuIGRvIHRoZSByaWdodA0KPj4+IHRoaW5nIHdpdGggdGhhdCBjaGFuZ2UgaW4gcGxh
Y2UuIEhvd2V2ZXIsIEkgdGhpbmsgdGhhdCB3ZSBhbHNvIG5lZWQNCj4+PiB0aGUgcnVudGltZSBj
b2RlIHRvIHByb2Nlc3MgYSBzaW5nbGUgZXh0ZW50IHBlciBpbnRlbnQgcGVyIGNvbW1pdCBpbg0K
Pj4+IHRoZSBzYW1lIG1hbm5lciBhcyBhYm92ZS4gaS5lLiB3ZSBwcm9jZXNzIHRoZSBmaXJzdCBl
eHRlbnQgaW4gdGhlDQo+Pj4gaW50ZW50LCB0aGVuIHJlbG9nIGFsbCB0aGUgcmVtYWluaW5nIHVu
cHJvY2Vzc2VkIGV4dGVudHMgYXMgYSBzaW5nbGUNCj4+PiBuZXcgaW50ZW50Lg0KPj4+IA0KPj4+
IE5vdGUgdGhhdCB0aGlzIGlzIHNpbWlsYXIgdG8gaG93IHdlIGFscmVhZHkgcmVsb2cgaW50ZW50
cyB0byByb2xsDQo+Pj4gdGhlbSBmb3J3YXJkIGluIHRoZSBqb3VybmFsLiBUaGUgb25seSBkaWZm
ZXJlbmNlIGZvciBzaW5nbGUgZXh0ZW50DQo+Pj4gcHJvY2Vzc2luZyBpcyB0aGF0IGFuIGludGVu
dCByZWxvZyBkdXBsaWNhdGVzIHRoZSBlbnRpcmUgZXh0ZW50IGxpc3QNCj4+PiBpbiB0aGUgRUZE
IGFuZCB0aGUgbmV3IEVGSSwgd2hpbHN0IHdoYXQgd2Ugd2FudCBpcyB0aGUgbmV3IEVGSSB0bw0K
Pj4+IGNvbnRhaW4gYWxsIHRoZSBleHRlbnRzIGV4Y2VwdCB0aGUgb25lIHdlIGp1c3QgcHJvY2Vz
c2VkLi4uDQo+Pj4gDQo+PiANCj4+IFRoZSBwcm9ibGVtIHRvIG1lIGlzIHRoYXQgd2hlcmUgd2Ug
cGxhY2UgdGhlIG5ldyBFRkksIGl0IGNhbuKAmXQgYmUgYWZ0ZXIgdGhlIEVGRC4NCj4+IEkgZXhw
bGFpbmVkIHdoeSBhYm92ZS4NCj4gDQo+IFllcyBpdCBjYW4uIFRoZSBvbmx5IHRoaW5nIHRoYXQg
bWF0dGVycyBpcyB0aGF0IHRoZSBFRkQgYW5kIG5ldyBFRkkNCj4gYXJlIGNvbW1pdHRlZCBpbiB0
aGUgc2FtZSB0cmFuc2FjdGlvbi4gUmVtZW1iZXI6IHRyYW5zYWN0aW9ucyBhcmUNCj4gYXRvbWlj
IGNoYW5nZSBzZXRzIC0gZWl0aGVyIGFsbCB0aGUgY2hhbmdlcyBpbiB0aGUgdHJhbnNhY3Rpb24g
YXJlDQo+IHJlcGxheWVkIG9uIHJlY292ZXJ5LCBvciBub25lIG9mIHRoZW0gYXJlLg0KDQpZZXMs
IHdpbGwgdHJ5IHRoaXMgd2F5Lg0KDQp0aGFua3MsDQp3ZW5nYW5n
