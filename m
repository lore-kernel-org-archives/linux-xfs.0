Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4981C001DF
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Jul 2023 17:56:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232346AbjG1R4g (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Jul 2023 13:56:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233791AbjG1R4d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Jul 2023 13:56:33 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F657449A
        for <linux-xfs@vger.kernel.org>; Fri, 28 Jul 2023 10:56:24 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36SF4Zb0018446;
        Fri, 28 Jul 2023 17:56:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=Rx0YMmzfzdIkn31PldXSX232AJAPVcadvSXjh30Iejo=;
 b=CBLQk80VTQjn8xXpYDTF6rKc/bYeFv/vBuXS5f/pI1YTQMnFT8io7fyq9fWEai+/4Vqa
 Zq6GFc4M7WU7Nmd1I3ZQ6dJTksPggzqked8j//lp2buNz6yWu9x2tnqv1wmHcD6Y4qzL
 MXomnGupjR037it4Ggg9xHhwxNKHMYlLGHV8bFyLuzMLqU1KeLNJNo2LLkXVUzOsc8LD
 Ltm65Q6Jl8q/O1/j/qTqZKIRfBbpNbkRjOhkVPoqY0/i4B3SNOS7BpbtLYgDgXXZA2dY
 sW/YZqrKge0gvW24eftAW8/KyIIzwv8dIxICiLeeJv079j8fxCV4BF/7J+4A2uwdduhH dw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s05w3vegh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Jul 2023 17:56:14 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36SHioBR011788;
        Fri, 28 Jul 2023 17:56:14 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j9n3uu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Jul 2023 17:56:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ehffMLSf6yAVoVcCodOytLch5c9Z7ASsuBlFeJP+JHXqV3HRA7/q0MfZOMhky3ajOWhCvoeXVPaBCgA9IbLBPhnF5iwbaU4/mOCmYH8KQamtlMHbSMMlSJorpUL+rYJJ4GEfpA/bTaWqgKo7dCtAA4T7syeARJ41oYCfSFHI2dtRLNJxgTsESYuFqj9Lb6DcLTtD3+9QyE2u8XUTueE4j+XUlj+ZBm29krGJL9+ncLTBcoYi9SdB9vOLm2EGcBy2NKCoydC+m4jNlcJsH0UeKdGi3AtHZdia3U/PAZeku+eGHzz80fbezKzW8d4R2shXhIFKX9+DhZKM5gkpTOnW0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rx0YMmzfzdIkn31PldXSX232AJAPVcadvSXjh30Iejo=;
 b=N3mcAFUVRm9IpyZdhm97kZdb6Cw4gbHuazLNKhvVS5FYOfH58KZMgBuR8QWREO+KiuJ3vb+s7P8SOsTMlc7sQ7km6SitE3IZvebnprJkUK/enIRfraR0T3GGZLf+XthBQ+NN+6GXiWOMwimaUHWB0E8/0H5evvZS3VVbnRMIRYONIhvfC8dkpGWktzOQbpEV6F0PevVAl80LroqUClnNT+8vpKqDwrSQIoj3iwkTbjvXvfDxWxlKfH8yHjZdb81WUGtFsyC/EDXN19u0+kBJjDTA9Z2BZGJEnVR7iWMcOduxX5MZ3+lPJp+kK7Z+PNlt0rGmPeABPsHPJAsJxHy3dQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rx0YMmzfzdIkn31PldXSX232AJAPVcadvSXjh30Iejo=;
 b=fyqCzA5ni3EWTZoc2mvT3cWwqnx1u8EtrZSG2Ei7xToXKhVhnjSYl7L3Wht8dKi9h+fvbvM5I4qNBQnVjJaW+WI2aKSdMnuf1MYLi2r7XNTcpUk4VIYOlFcrw10yP1cOSXeu2VbCrh+RK3xgymyWq58CvztNvQXO92fTWAXdaII=
Received: from SN6PR10MB2701.namprd10.prod.outlook.com (2603:10b6:805:45::20)
 by SJ0PR10MB5742.namprd10.prod.outlook.com (2603:10b6:a03:3ed::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.29; Fri, 28 Jul
 2023 17:56:11 +0000
Received: from SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::72f4:e7e3:9b11:8c74]) by SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::72f4:e7e3:9b11:8c74%5]) with mapi id 15.20.6631.026; Fri, 28 Jul 2023
 17:56:11 +0000
From:   Wengang Wang <wen.gang.wang@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
CC:     "Darrick J. Wong" <djwong@kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        Srikanth C S <srikanth.c.s@oracle.com>
Subject: Re: Question: reserve log space at IO time for recover
Thread-Topic: Question: reserve log space at IO time for recover
Thread-Index: AQHZuctArDqu+2gh/UuDZaYn7kAqiq/AN2uAgAAaCICAAE50gIAEAZ+AgAN+qQCAAR5UAIACO3SAgAQL+wA=
Date:   Fri, 28 Jul 2023 17:56:11 +0000
Message-ID: <BED64CCE-93D1-4110-B2C8-903A00D0013C@oracle.com>
References: <1DB9F8BB-4A7C-4422-B447-90A08E310E17@oracle.com>
 <ZLcqF2/7ZBI44C65@dread.disaster.area>
 <20230719014413.GC11352@frogsfrogsfrogs>
 <ZLeBvfTdRbFJ+mj2@dread.disaster.area>
 <2A3BFAC0-1482-412E-A126-7EAFE65282E8@oracle.com>
 <ZL3MlgtPWx5NHnOa@dread.disaster.area>
 <2D5E234E-3EE3-4040-81DA-576B92FF7401@oracle.com>
 <ZMCcJSLiWIi3KBOl@dread.disaster.area>
In-Reply-To: <ZMCcJSLiWIi3KBOl@dread.disaster.area>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2701:EE_|SJ0PR10MB5742:EE_
x-ms-office365-filtering-correlation-id: 855f1a9d-a59b-401d-a817-08db8f93ed8d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: O67e1wTUBfi63tv8vF5bXHkWOX8p/wy9WDaBVlLdTo5uhKxNrPFl9O/l13Ha96edBEw/ZXNRWrpGPKKG4v1ExE/mSBh+B8pQcUslNB5bpVi3oz8K/OSgYK6wW6YFf6M3oY3TCX5cZdWXcHcFZiUcn2d01ZsSwGwScNDbTP84rxQN3T9Ymfi5EOQPfNv360t6O7TqztuJeUZZ01JyS7enxBYvzlOHaNsTI2WN+vF0oX9d/9qutNYDJCxCLeisoZ6VlrefTLP2AWKCWSYPEyJhUKI067xQL9/KXfJD7vTaKTg/iGTMqjmV42fzoCxGZlexlb9/0Pl+dk4KkXzPh1NsYtFKj0+17iQtD5hgSZTJ1n13/bC0IOGfOs2PH279lrikY31sBvl6gU7Up6EPoMWC2F/p0olKazRoSk06jS8P+HYZcu177sRmywKxwtmhJIZd3O+GT+Z7N2zLSKDYMOLKGaHhqTn/DJrwQKEdbO4jjw8om5eLFFJ+CgR/Oz/dGUIOXl1oSHYQnTFZh/tkQSb6x72UednEiyJafUcxvdk5wjigxD7FajL4bBnl+ij6DHafLdWgsBln6ITlb5hTvQ97jQQJ4q6yE0T2tQblw5gIQd4lFRNhtkfxsezbTU+Bn1BrHGhcMrQtBoZ8a9Pf/CRM5Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2701.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(366004)(376002)(346002)(396003)(451199021)(2906002)(71200400001)(6506007)(26005)(186003)(316002)(64756008)(38100700002)(122000001)(107886003)(2616005)(83380400001)(53546011)(66446008)(66946007)(66556008)(33656002)(5660300002)(76116006)(66476007)(41300700001)(8676002)(36756003)(8936002)(6916009)(54906003)(38070700005)(6486002)(478600001)(6512007)(4326008)(86362001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Si9hOXh2KzM4SnJIaDVrckFOUDNhVHRpQStzVForZmd2T2NsdzduNDcyOGRQ?=
 =?utf-8?B?UVJUWFJsdlBpaEhvU1pDeFBXY1RKZmt1eXRGRTBmMFFKc3I4aTNSQUxnN0ZQ?=
 =?utf-8?B?cW5obXd4RHlSWnFiNVdrRGRHZEE2aDUwelV0dGJKcEpzUlB3YzhzTEIvNGdv?=
 =?utf-8?B?L3kvMWQxUi9hditQdjd3T3hWWkxIMHExNW92V3BlSjMzNHUybGZTOFpXZnQv?=
 =?utf-8?B?d21UWFhteWU5VmZuMWhqRS80TEJmcXNWOVo1VThLcTVMZHNDckZMc0ZoRiti?=
 =?utf-8?B?QXRKa0YranJEV0ladzlLMkg4M2djcE4rTG5Da2JDTlR0Y1FsMlV5d0hOUlY2?=
 =?utf-8?B?MExBbUU4SDFBT0pkY25wRmZZcFZvaHB3dURldzY2SllLSUxGbXE0VGlra0d4?=
 =?utf-8?B?b3p1cE5mVER3cWVTL2huaG11TExtZUg5MzdtSUhnSFBTM1lYMjBvM0w5N3JT?=
 =?utf-8?B?R25GTHR1dGdUSkswRkhmL1p6b3g2cERFWjlHdHh4UzRQSENMSEwxaTlaZzhm?=
 =?utf-8?B?UE5QOS9zcVpFNFFRTVNGQWNwZ3JFTHZaUldBbkJKL1g3VURnbmkxbG9FYk1K?=
 =?utf-8?B?VTU1VTh4VzNOQWp6WENQN25YYzd0REVEUHV2YnBWcGpGQzcwbHU3aFRZQTZi?=
 =?utf-8?B?dVhCNUtuNGZFZ2o1OCtPVzk0OUoySUtVaElpSmVHckpiTWgxVkwvd2dCZTU2?=
 =?utf-8?B?OHJJRzh5YUcvbEY2QmlValVRZHFBMDlRWW5IR1FiZk41N0o2K3RhdlFPeE9H?=
 =?utf-8?B?RGFYekJCTCtpVTNSRmJWSDNIRDNsQTNISkxJYUpxYzZuQWR4WS9ncnlNWTBI?=
 =?utf-8?B?N0JHd3BsWHhHM1QwT3JpM3RwRXdURTdXb0p2UHRacGVnVk9WU0ZrYnQ2NFhS?=
 =?utf-8?B?T1ZNZzBvV2dUS1A2YTZjNm1aRmtUcjNhRlN0VWs1cFRQb0hsOFUwWGwzaFdl?=
 =?utf-8?B?TTg2QzI5WkJ3b05IZFFwaHhzSDJ3RFoyeVlla3VmbTBFTTdZRWpQVDRuWlI4?=
 =?utf-8?B?N3RMUHR0SXZXZ3FLa0U1OGZzRFNKSlgraks4Qm9aeEhmTGdyb1o3VUdNelNk?=
 =?utf-8?B?Y0VpUTNTdUJESlYyZHlGYzc1cFEyNGpmM2ZHRHdyc3A4cHVnc0lZWXhyUlR0?=
 =?utf-8?B?cHFhNHUxVHlEdW01bGNTZG9zUURITmllMmloNXN0VFl0SW9DR3UzRURBWStJ?=
 =?utf-8?B?d1RIaHJib203eFBPQmxUTUVFTUp5dHAyREloOFRQcjNhb2FxbTZrY0liNTFx?=
 =?utf-8?B?Z0gvT1AwdEVJYjl1Z0l4RnVPRE1SVWxjV21uQzFUYWNxZWZrRUEyN3ZEa1dL?=
 =?utf-8?B?RTVQaHRSNTdXM0ZLT09mWVdyYkFHeDcxeW1FTHBJMm52YThRaklvN0IreGFX?=
 =?utf-8?B?Ym5BNTU4Qk1lMTN5clhDY213OFROYXp4Vzk4b1BRRld2Y2FpdTdFNlRSSWpm?=
 =?utf-8?B?ZHRCN1dMWGk5b1lmVFhVQ0VDbXpuYkQyMkpZbUM0WWZROFY2d3A5TmdKK3Q4?=
 =?utf-8?B?M0s0K3N0bWs0YlVBUHRTUUk3Q3p6OWFxcmF0S2xWbGE5eVJmQ1B0T3JwQ1F1?=
 =?utf-8?B?cmt0SVBBcjc3TC8xTXNlTFRBWFovQitVdUlFOHFOa0dETjdaZ1FPNU9wMmha?=
 =?utf-8?B?OTdMZWFuaVFINVZuK0J0R1JLUC9mVjNXSTh6bTQ5TFFxbFlIS3NWbDRPd0x5?=
 =?utf-8?B?T3BZOWxxMHJNY1p5TG10S3JneUJ6cGs4NmpzOVNaY2tUc3V5MklhTDZ6cWk3?=
 =?utf-8?B?WGd3NUF3aFVUaWU0dUNKOWd5UjdBbXBaN3ppdnQ2SjIwTzBHV2tVQlkycDQ3?=
 =?utf-8?B?dU9HeWRnN2xvNStiMUx2cEdPTlZOZE9iMHRraDBtMG03Sm9VbU94dXBRUXh1?=
 =?utf-8?B?ZFlMelpXSDYwSmhIcm5RdmNQOXBoV0JBaFowTmZqUURUTGN1cHlhTDlZMzhy?=
 =?utf-8?B?ZUlCUWVjSGFjaFBDWlBZajVFbTFsaXhpZUJGK1pyVVVTWEZTYzQzTXJzNkZQ?=
 =?utf-8?B?OVRkeE9teTdmUkQxNFNJV2gzVE1CdUI1cW81elZtQkhXaWttdjF5c0FMQTU0?=
 =?utf-8?B?SFRyeTA3dGk4N2VWTzV3VzQvZGtodzRWcnJBVXcvTmVPVjUxdmhVK25UUWdY?=
 =?utf-8?B?aTBVL2V6NmhVY21QS25pTk5zVFdDOTI1QWZwcnR3TDJ6ZVBQU0F6SzhXV2JZ?=
 =?utf-8?B?enc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EF4992782CFF6D49B52513430F85FBF4@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: JqsMLxhfEvdoiPHrvB6VJ3MUq3/+hSNQs1JjKKKPhfY6CSrIwfHkb9/vZl79XSphdSx/b9Cpx3oCtiYqxBQ9dbHmV0acYEViCTG4XdTMwpPRtPXm3I7SDB5/HZfbZzRAuGWYXKAv44l9w2TTuvlMZR679TzYoPNKhSTV+F/guNkZfCTjAJm2SUe/6a41hycNl8Yf+HPBvztkwUcq1XUf6cjnOoAihAXtzYa+0wHbXzbUUbgPdARe1sL1MkIa/vTiGhKUCa98NoK3qbLLeH6y36nUaK18pqZrchY1W+O4cCEcxTIMLKKpT7VF0LbgGBoFPsFWtV7NcCGfkbFWK5QFZiykCYg9zYc16NO6fNHrgTt7almRIj+jyfMGFUUVRNG02RZXpwQ/alrXJO3rADUNOqJaAkK1eDb7g/RxzsDy2bm9ml5JLfKz4/CBfuYaxzbzRi6B1ccILRGcSSFTOigcgEisQG3aFnrFqsBW2NeJQ3Z4FqAxzQU9d9PPfXTtc7fMvLJ4P95ghxPW/ZQecyBBnvKSx4MNQfgSlsevmFjgCdGl+Ui3u0Pux4kS/mFtbbEhvPxjddAcPZNvbbKYuCm9IbPxCaRQCHtD21iIihOO4jQ6V3+XHL8d658V2sGZxU92V/+lp7Fo/jNtbvbUllT32r0/Hze5DMBm/x9iLdZgi5s7IRI9FpDQN/MSX2QXs454ZGEVRhOi84ps+PUvvESg8vk2oCbLOWJboCp21eOIdotN4Ak5xK1TO8EtpGj8/xsxRIK+MQPh7LekgTbZ0fqWk8V+5a/0JiaXAeiwLbcWch0VDAAUVCBTCSjFt5nzWZ2hiBf9fOIV9UM11tD9UZI1Rw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 855f1a9d-a59b-401d-a817-08db8f93ed8d
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jul 2023 17:56:11.0975
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I6iSGit2xP2p9sR85qzDUDLHyPxtXknkmQ+mORbi4h/i+gBuFu8SjxKszbcHVb19tyg+iklLJybKrjMzG7ctbx6GAxfBT3jn7XUkWBIBc3w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5742
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-27_10,2023-07-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307280163
X-Proofpoint-GUID: v0zvoohUB6LtTQGU0vet7-s7XvH637tn
X-Proofpoint-ORIG-GUID: v0zvoohUB6LtTQGU0vet7-s7XvH637tn
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

DQoNCj4gT24gSnVsIDI1LCAyMDIzLCBhdCA5OjA4IFBNLCBEYXZlIENoaW5uZXIgPGRhdmlkQGZy
b21vcmJpdC5jb20+IHdyb3RlOg0KPiANCj4gT24gTW9uLCBKdWwgMjQsIDIwMjMgYXQgMDY6MDM6
MDJQTSArMDAwMCwgV2VuZ2FuZyBXYW5nIHdyb3RlOg0KPj4+IE9uIEp1bCAyMywgMjAyMywgYXQg
NTo1NyBQTSwgRGF2ZSBDaGlubmVyIDxkYXZpZEBmcm9tb3JiaXQuY29tPiB3cm90ZToNCj4+PiBP
biBGcmksIEp1bCAyMSwgMjAyMyBhdCAwNzozNjowM1BNICswMDAwLCBXZW5nYW5nIFdhbmcgd3Jv
dGU6DQo+Pj4+IEZZSToNCj4+Pj4gDQo+Pj4+IEkgYW0gYWJsZSByZXByb2R1Y2UgdGhlIFhGUyBt
b3VudCBoYW5nIGlzc3VlIHdpdGggaGFja2VkIGtlcm5lbHMgYmFzZWQgb24NCj4+Pj4gYm90aCA0
LjE0LjM1IGtlcm5lbCBvciA2LjQuMCBrZXJuZWwuDQo+Pj4+IFJlcHJvZHVjZSBzdGVwczoNCj4+
Pj4gDQo+Pj4+IDEuIGNyZWF0ZSBhIFhGUyB3aXRoIDEwTWlCIGxvZyBzaXplIChzbWFsbCBzbyBl
YXNpZXIgdG8gcmVwcm9kdWNlKS4gVGhlIGZvbGxvd2luZw0KPj4+PiAgc3RlcHMgYWxsIGFpbSBh
dCB0aGlzIFhGUyB2b2x1bWUuDQo+Pj4gDQo+Pj4gQWN0dWFsbHksIG1ha2UgdGhhdCBhIGZldyBt
aWxsaXNlY29uZHMuLi4uIDopDQo+PiANCj4+IDopDQo+PiANCj4+PiBta2ZzL3hmc19pbmZvIG91
dHB1dCB3b3VsZCBiZSBhcHByZWNpYXRlZC4NCj4+IA0KPj4gc3VyZSwNCj4+ICMgeGZzX2luZm8g
MjBHQi5iazINCj4+IG1ldGEtZGF0YT0yMEdCLmJrMiAgICAgICAgICAgICAgIGlzaXplPTI1NiAg
ICBhZ2NvdW50PTQsIGFnc2l6ZT0xMzEwNzIwIGJsa3MNCj4+ICAgICAgICAgPSAgICAgICAgICAg
ICAgICAgICAgICAgc2VjdHN6PTUxMiAgIGF0dHI9MiwgcHJvamlkMzJiaXQ9MQ0KPj4gICAgICAg
ICA9ICAgICAgICAgICAgICAgICAgICAgICBjcmM9MCAgICAgICAgZmlub2J0PTAsIHNwYXJzZT0w
LCBybWFwYnQ9MA0KPj4gICAgICAgICA9ICAgICAgICAgICAgICAgICAgICAgICByZWZsaW5rPTAN
Cj4gDQo+IEhtbW1tLiBXaHkgYXJlIHlvdSBvbmx5IHRlc3RpbmcgdjQgZmlsZXN5c3RlbXM/IFRo
ZXkgYXJlIGRlcHJlY2F0ZWQNCj4gYW5kIHN1cHBvcnQgaXMgbGFyZ2VseSBkdWUgdG8gYmUgZHJv
cHBlZCBmcm9tIHVwc3RyZWFtIGluIDIwMjUuLi4NCj4gDQoNCkhhLCBpdCBqdXN0IGhhcHBlbmVk
IHRvIGJlIHNvLg0KSSB3YXMgdHJ5aW5nIHRvIHJlcHJvZHVjZSBpdCBpbiB0aGUgc2FtZSBlbnZp
cm9ubWVudCBhcyBjdXN0b21lciBoYXMg4oCUDQp0aGF04oCZcyBPcmFjbGVMaW51eDcuIFRoZSBk
ZWZhdWx0IGJlaGF2aW9yIG9mIG1rZnMueGZzIGluIE9MNyBpcyB0byBmb3JtYXQNCnY0IGZpbGVz
eXN0ZW1zLiAgSSBjcmVhdGVkIHRoZSB4ZnMgaW1hZ2UgaW4gYSBmaWxlIG9uIE9MNyBhbmQgY29w
aWVkIHRoZSBpbWFnZQ0KZmlsZSB0byBhIDYuNC4wIGtlcm5lbCBtYWNoaW5lLiBUaGF04oCZcyB3
aHkgeW91IHNlZSB2NCBmaWxlc3lzdGVtIGhlcmUuDQoNCj4gRG9lcyB0aGUgc2FtZSBwcm9ibGVt
IG9jY3VyIHdpdGggYSB2NSBmaWxlc3lzdGVtcz8NCg0KV2lsbCB0ZXN0IGFuZCByZXBvcnQgYmFj
ay4NCg0KPiANCj4+Pj4gNS4gQ2hlY2tpbmcgdGhlIG9uIGRpc2sgbGVmdCBmcmVlIGxvZyBzcGFj
ZSwgaXTigJlzIDE4MTc2MCBieXRlcyBmb3IgYm90aCA0LjE0LjM1DQo+Pj4+ICBrZXJuZWwgYW5k
IDYuNC4wIGtlcm5lbC4NCj4+PiANCj4+PiBXaGljaCBpcyBpcyBjbGVhcmx5IHdyb25nLiBJdCBz
aG91bGQgYmUgYXQgbGVhc3QgMzYwNDE2IGJ5dGVzIChpLmUNCj4+PiB0cl9pdHJ1bmMpLCBiZWNh
dXNlIHRoYXQncyB3aGF0IHRoZSBFRkkgYmVpbmcgcHJvY2Vzc2VkIHRoYXQgcGlucw0KPj4+IHRo
ZSB0YWlsIG9mIHRoZSBsb2cgaXMgc3VwcG9zZWQgdG8gaGF2ZSByZXNlcnZlZCB3aGVuIGl0IHdh
cw0KPj4+IHN0YWxsZWQuDQo+PiANCj4+IFllcCwgZXhhY3RseS4NCj4+IA0KPj4+IFNvIHdoZXJl
IGhhcyB0aGUgfjE4MGtCIG9mIGxlYWtlZCBzcGFjZSBjb21lIGZyb20/DQo+Pj4gDQo+Pj4gSGF2
ZSB5b3UgdHJhY2VkIHRoZSBncmFudCBoZWFkIHJlc2VydmF0aW9ucyB0byBmaW5kIG91dA0KPj4+
IHdoYXQgdGhlIHJ1bnRpbWUgbG9nIHNwYWNlIGFuZCBncmFudCBoZWFkIHJlc2VydmF0aW9ucyBh
Y3R1YWxseSBhcmU/DQo+PiBJIGhhdmUgdGhlIG51bWJlcnMgaW4gdm1jb3JlIChpZ25vcmUgdGhl
IFdBUk5zKSwNCj4gDQo+IFRoYXQncyBub3Qgd2hhdCBJJ20gYXNraW5nLiBZb3UndmUgZHVtcGVk
IHRoZSB2YWx1ZXMgYXQgdGhlIHRpbWUgb2YNCj4gdGhlIGhhbmcsIG5vdCB0cmFjZWQgdGhlIHJ1
bnRpbWUgcmVzZXJ2YXRpb25zIHRoYXQgaGF2ZSBiZWVuIG1hZGUuDQo+IA0KPj4+IGkuZS4gd2Ug
aGF2ZSBmdWxsIHRyYWNpbmcgb2YgdGhlIGxvZyByZXNlcnZhdGlvbiBhY2NvdW50aW5nIHZpYQ0K
Pj4+IHRyYWNlcG9pbnRzIGluIHRoZSBrZXJuZWwuIElmIHRoZXJlIGlzIGEgbGVhayBvY2N1cnJp
bmcsIHlvdSBuZWVkIHRvDQo+Pj4gY2FwdHVyZSBhIHRyYWNlIG9mIGFsbCB0aGUgcmVzZXJ2YXRp
b24gYWNjb3VudGluZyBvcGVyYXRpb25zIGFuZA0KPj4+IHBvc3QgcHJvY2VzcyB0aGUgb3V0cHV0
IHRvIGZpbmQgb3V0IHdoYXQgb3BlcmF0aW9uIGlzIGxlYWtpbmcNCj4+PiByZXNlcnZlZCBzcGFj
ZS4gZS5nLg0KPj4+IA0KPj4+ICMgdHJhY2UtY21kIHJlY29yZCAtZSB4ZnNfbG9nXCogLWUgeGxv
Z1wqIC1lIHByaW50ayB0b3VjaCAvbW50L3NjcmF0Y2gvZm9vDQo+Pj4gLi4uLg0KPj4+ICMgdHJh
Y2UtY21kIHJlcG9ydCA+IHMudA0KPj4+ICMgaGVhZCAtMyBzLnQNCj4+PiBjcHVzPTE2DQo+Pj4g
ICAgICAgICB0b3VjaC0yODkwMDAgWzAwOF0gNDMwOTA3LjYzMzgyMDogeGZzX2xvZ19yZXNlcnZl
OiAgICAgIGRldiAyNTM6MzIgdF9vY250IDIgdF9jbnQgMiB0X2N1cnJfcmVzIDI0MDg4OCB0X3Vu
aXRfcmVzIDI0MDg4OCB0X2ZsYWdzIFhMT0dfVElDX1BFUk1fUkVTRVJWIHJlc2VydmVxIGVtcHR5
IHdyaXRlcSBlbXB0eSBncmFudF9yZXNlcnZlX2N5Y2xlIDEgZ3JhbnRfcmVzZXJ2ZV9ieXRlcyAx
MDI0IGdyYW50X3dyaXRlX2N5Y2xlIDEgZ3JhbnRfd3JpdGVfYnl0ZXMgMTAyNCBjdXJyX2N5Y2xl
IDEgY3Vycl9ibG9jayAyIHRhaWxfY3ljbGUgMSB0YWlsX2Jsb2NrIDINCj4+PiAgICAgICAgIHRv
dWNoLTI4OTAwMCBbMDA4XSA0MzA5MDcuNjMzODI5OiB4ZnNfbG9nX3Jlc2VydmVfZXhpdDogZGV2
IDI1MzozMiB0X29jbnQgMiB0X2NudCAyIHRfY3Vycl9yZXMgMjQwODg4IHRfdW5pdF9yZXMgMjQw
ODg4IHRfZmxhZ3MgWExPR19USUNfUEVSTV9SRVNFUlYgcmVzZXJ2ZXEgZW1wdHkgd3JpdGVxIGVt
cHR5IGdyYW50X3Jlc2VydmVfY3ljbGUgMSBncmFudF9yZXNlcnZlX2J5dGVzIDQ4MjgwMCBncmFu
dF93cml0ZV9jeWNsZSAxIGdyYW50X3dyaXRlX2J5dGVzIDQ4MjgwMCBjdXJyX2N5Y2xlIDEgY3Vy
cl9ibG9jayAyIHRhaWxfY3ljbGUgMSB0YWlsX2Jsb2NrIDINCj4+PiANCj4+PiAjDQo+Pj4gDQo+
Pj4gU28gdGhpcyB0ZWxscyB1cyB0aGUgdHJhbnNhY3Rpb24gcmVzZXJ2YXRpb24gdW5pdCBzaXpl
LCB0aGUgY291bnQgb2YNCj4+PiByZXNlcnZhdGlvbnMsIHRoZSBjdXJyZW50IHJlc2VydmUgYW5k
IGdyYW50IGhlYWQgbG9jYXRpb25zLCBhbmQgdGhlDQo+Pj4gY3VycmVudCBoZWFkIGFuZCB0YWls
IG9mIHRoZSBsb2cgYXQgdGhlIHRpbWUgdGhlIHRyYW5zYWN0aW9uDQo+Pj4gcmVzZXJ2YXRpb24g
aXMgc3RhcnRlZCBhbmQgdGhlbiBhZnRlciBpdCBjb21wbGV0ZXMuDQo+PiANCj4+IFdpbGwgZG8g
dGhhdCBhbmQgcmVwb3J0IGJhY2suIFlvdSB3YW50IGZ1bGwgbG9nIG9yIG9ubHkgc29tZSB0eXBp
Y2FsDQo+PiBvbmVzPyBGdWxsIGxvZyB3b3VsZCBiZSBiaWcsIGhvdyBzaGFsbCBJIHNoYXJlPyAN
Cj4gDQo+IEkgZG9uJ3Qgd2FudCB0byBzZWUgdGhlIGxvZy4gSXQnbGwgYmUgaHVnZSAtIEkgcmVn
dWxhcmx5IGdlbmVyYXRlDQo+IHRyYWNlcyBjb250YWluaW5nIGdpZ2FieXRlcyBvZiBsb2cgYWNj
b3VudGluZyB0cmFjZXMgbGlrZSB0aGlzIGZyb20NCj4gYSBzaW5nbGUgd29ya2xvYWQuDQo+IA0K
PiBXaGF0IEknbSBhc2tpbmcgeW91IHRvIGRvIGlzIHJ1biB0aGUgdHJhY2luZyBhbmQgdGhlbiBw
b3N0IHByb2Nlc3MNCj4gdGhlIHZhbHVlcyBmcm9tIHRoZSB0cmFjZSB0byBkZXRlcm1pbmUgd2hh
dCBvcGVyYXRpb24gaXMgdXNpbmcgbW9yZQ0KPiBzcGFjZSB0aGFuIGlzIGJlaW5nIGZyZWVkIGJh
Y2sgdG8gdGhlIGxvZy4NCj4gDQo+IEkgZ2VuZXJhbGx5IGRvIHRoaXMgd2l0aCBncmVwLCBhd2sg
YW5kIHNlZC4gc29tZSBwZW9wbGUgdXNlIHB5dGhvbg0KPiBvciBwZXJsLiBCdXQgZWl0aGVyIHdh
eSBpdCdzIGEgKmxvdCogb2Ygd29yayAtIGluIHRoZSBwYXN0IEkgaGF2ZQ0KPiBzcGVudCBfd2Vl
a3NfIG9uIHRyYWNlIGFuYWx5c2lzIHRvIGZpbmQgYSA0IGJ5dGUgbGVhayBpbiB0aGUgbG9nDQo+
IHNwYWNlIGFjY291bnRpbmcuIERPaW5nIHRoaW5ncyBsaWtlIGdyYXBoaW5nIHRoZSBoZWFkLCB0
YWlsIGFuZCBncmFudA0KPiBzcGFjZXMgb3ZlciB0aW1lIHRlbmQgdG8gc2hvdyBpZiB0aGlzIGlz
IGEgZ3JhZHVhbCBsZWFrIHZlcnN1cyBhDQo+IHN1ZGRlbiBzdGVwIGNoYW5nZS4gSWYgaXQncyBh
IHN1ZGRlbiBzdGVwIGNoYW5nZSwgdGhlbiB5b3UgY2FuDQo+IGlzb2xhdGUgaXQgaW4gdGhlIHRy
YWNlIGFuZCB3b3JrIG91dCB3aGF0IGhhcHBlbmVkLiBJZiBpdCdzIGENCj4gZ3JhZHVhbCBjaGFu
Z2UsIHRoZW4geW91IG5lZWQgdG8gc3RhcnQgbG9va2luZyBmb3IgYWNjb3VudGluZw0KPiBkaXNj
cmVwYW5jaWVzLi4uDQo+IA0KPiBlLmcuIGEgdHJhbnNhY3Rpb24gcmVjb3JkcyAzMiBieXRlcyB1
c2VkIGluIHRoZSBpdGVtLCBzbyBpdCByZWxlYXNlcw0KPiB0X3VuaXQgLSAzMiBieXRlcyBhdCBj
b21taXQuIEhvd2V2ZXIsIHRoZSBDSUwgbWF5IHRoZW4gb25seSB0cmFjayAyOA0KPiBieXRlcyBv
ZiBzcGFjZSBmb3IgdGhlIGl0ZW0gaW4gdGhlIGpvdXJuYWwgYW5kIHdlIGxlYWsgNCBieXRlcyBv
Zg0KPiByZXNlcnZhdGlvbiBvbiBldmVyeSBvbiBvZiB0aG9zZSBpdGVtcyBjb21taXR0ZWQuDQo+
IA0KPiBUaGVzZSBzb3J0cyBvZiBsZWFrcyB0eXBpY2FsbHkgb25seSBhZGQgdXAgdG8gYmVpbmcg
c29tZXRoaWduDQo+IHNpZ25pZmljYW50IGluIHNpdHVhdGlvbnMgd2hlcmUgdGhlIGxvZyBpcyBm
bG9vZGVkIHdpdGggdGlueSBpbm9kZQ0KPiB0aW1lc3RhbXAgY2hhbmdlcyAtIDQgYnl0ZXMgaXBl
ciBpdGVtIGRvZXNuJ3QgcmVhbGx5IG1hdHRlciB3aGVuIHlvdQ0KPiBvbmx5IGhhdmUgYSBmZXcg
dGhvdXNhbmQgaXRlbXMgaW4gdGhlIGxvZywgYnV0IHdoZW4geW91IGhhdmUNCj4gaHVuZHJlZHMg
b2YgdGhvdXNhbmRzIG9mIHRpbnkgaXRlbXMgaW4gdGhlIGxvZy4uLg0KPiANCg0KT0suIHdpbGwg
d29yayBtb3JlIG9uIHRoaXMuDQojIEkgYW0gZ29pbmcgdG8gc3RhcnQgYSB0d28td2VlayB2YWNh
dGlvbiwgYW5kIHdpbGwgdGhlbiBjb250aW51ZSBvbiB0aGlzIHdoZW4gYmFjay4NCg0KdGhhbmtz
LA0Kd2VuZ2FuZw0KDQo=
