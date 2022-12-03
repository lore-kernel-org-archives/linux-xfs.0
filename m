Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1122C47089
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Dec 2022 00:27:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234966AbiLCA1U (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Dec 2022 19:27:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234938AbiLCA1M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Dec 2022 19:27:12 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D260F2C49;
        Fri,  2 Dec 2022 16:27:07 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B2MNq2a023091;
        Sat, 3 Dec 2022 00:27:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=b2yRev//4Y2uvd/z8dtBF0COx3RzBS2rAsQOMHH37mM=;
 b=e2Y0NObylIYbRacdDFpa+xyrn8MjI0jDt4EHYef9dDS3oKeKfxizes/Z8tm40zOy7HJU
 JdVQerDfJ0IXzZdiaqcW7pkA5yhCcQbg/U7BKg56ONKa0oPanqvRH+/4OV8ZiduElxBM
 C1NGPd4C1ZeonDfL1YhBJcq1Xo2v7+wPOZhE1Q+OKqqSvmfW6SV9aBrziFcOd/2eqS3l
 0hcsE5K87PNSBdmY5jkLgd6gGWfg8jqJjCGTQoPybck69+Z8JLp5NtBOdtQqduaqsAav
 e2rdBQDafn2ttX45c2zr9u+V+9mxGwAtT5RENXlt6cHftKywUcoW5sisrJWQdIfvKgxh DA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m782hb0s5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Dec 2022 00:27:00 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B2NNjPJ040010;
        Sat, 3 Dec 2022 00:27:00 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3m398m55c5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Dec 2022 00:27:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i1bGzbjIBiPEq85IZj8McKqxsVTLPBaQrj26dhIITuONOroo582nvFyi/mfxNGYlKIC2fpRz/+hLisyfwJVEaDZhFL6btyJDy3zyiuVOk/rct41D81sA4ZAecmH1M0mcnHiTgtssdmLMIaHiho2LJjjp0hBnnNCprsVZmIxlBDGQico69WhKL2Vf1W6xLrwDXaTujUAIJljOJOlvoKJ2nrdhv/hNqKLzYACADIWDK8nw6W6p8MnnhCQoTHEjkNsbuykZKZo+9eiI+tN0h9wWd4V2B9Wev35YcRQ5cpkRmLGVvyQ/rtWAwCmSjkWIxFZQ0xjSrZw2oZYmFJSAZLnc8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b2yRev//4Y2uvd/z8dtBF0COx3RzBS2rAsQOMHH37mM=;
 b=B0V9bmbqOuXhZL9UOh+Mj7E8Spe+rvHcrJ0Y0Uf9ueFKycXyCADzHYEQ+s2puvuU/LqDa9vbIeNZVEqqFLyZNokXYTHPPVAEC8bBK8wXwRG1FCohAq293e0T/LgkFUN/Qh7bTLBNKfKR3m/0sweKW7Kcfd0vxsntJSxPBPq6meSvPuPVDuWk+wcF8tkqKrPTcFsu5Ze8fzfx9/CyOQfgRBTR4nDxGj/ENb4JFgztSN1nCPwMeElZrmG3mhslf1a98As03lkLWDH8iCxdoWLztc0V96+2sOWoLssJ0+EGbtSu3j20UeXDdZgXjwgN5A4I30LIuY0yCxskO1rFoBn5vQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b2yRev//4Y2uvd/z8dtBF0COx3RzBS2rAsQOMHH37mM=;
 b=B/VOtQkEwA1AjmGnBaWI8ooRoQ33dGHwJdaJ5hzGQIeejdoMnD2Z++EhuvCmhT3E4Hk1XcbDLRQRlz3i9py3ebAvwrO5DHE+0Ad860xk5E9YmN42fCe5Ggzss+ezlz/ZsHG7ByX6f3ljCcNVtYei8K37wkiLG2QC7cULLaAcwn4=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DM6PR10MB4347.namprd10.prod.outlook.com (2603:10b6:5:211::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Sat, 3 Dec
 2022 00:26:57 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c%4]) with mapi id 15.20.5880.010; Sat, 3 Dec 2022
 00:26:57 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     "fstests@vger.kernel.org" <fstests@vger.kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "ZiyangZhang@linux.alibaba.com" <ZiyangZhang@linux.alibaba.com>
CC:     "djwong@kernel.org" <djwong@kernel.org>,
        "hsiangkao@linux.alibaba.com" <hsiangkao@linux.alibaba.com>
Subject: Re: [RESEND PATCH V2] common/populate: Ensure that S_IFDIR.FMT_BTREE
 is in btree format
Thread-Topic: [RESEND PATCH V2] common/populate: Ensure that S_IFDIR.FMT_BTREE
 is in btree format
Thread-Index: AQHZBkEw5hbPOL7vqE6B6ifYNuQE365bT2SA
Date:   Sat, 3 Dec 2022 00:26:57 +0000
Message-ID: <030e253f14fcdff29d43bafa690435be06abacb4.camel@oracle.com>
References: <20221202112740.1233028-1-ZiyangZhang@linux.alibaba.com>
In-Reply-To: <20221202112740.1233028-1-ZiyangZhang@linux.alibaba.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4306:EE_|DM6PR10MB4347:EE_
x-ms-office365-filtering-correlation-id: 51f1b844-caec-4c32-2319-08dad4c5165e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DmaHPF/902KVh/gBbhO+cqF/Irickg874Py1HleZUT7tHZZVue36BoBL0K3lit7PzJrpy/QMnAr7G6aYfeSV1Jjn/4uk9KF0Tw68ACFV6UofPsS5y55L+FGZBXFFdnZrLlr3ZN8KT5dm5AfIJo/7W0X9lmywCTom2ibozWsx17OnrrNoxrlmu/33ItMm67jv+pswkrCJEaw3iLnNV/y5OUU6ZZaefL+RAkvUNfIv5iXMjtBJTsTocYl/A+NapkhgpkmIGeZbXcUNJPTR5tDuM4aif9BxdPuG3y2WTqCFGumSPeBRIGkoDhi6AEuG2qqao44/0Zup53lHtzHVddaWvNIb1ux7JWb/cyMZzxQz8ayBoHJsrz6ORdq3IzsEOPi3YzbI+GVO88Ri3kSYcXpunuLDSOuUqecw8zcAIRXCJlTg/CFSXu2RgtAvgGg42irEXQ2e0R3VB1dQzFKFy/RjZKoiwFFOgAGJdl2NPJ0UNlnL10ObHmELXkOEDHbWNNgu1InpUJUxD5+VpF5HUCmT7iWTBi7OfOi+k02+AzuZIK+W7JmQsouR8D9DtC60Yh7IXFgyEX5xLtejrDO6JLYtTS8TWI+Ykjy3QlNGH0HwaUTJU9QPk3UAy+4xGQMNIl8l49Ik66FWy4K9M6c3DTjgKmWx3uOX96R05lo73Y5/trhd0cEFEqqNpM+gjY0O2B47
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(376002)(136003)(396003)(346002)(451199015)(5660300002)(316002)(6512007)(54906003)(110136005)(26005)(44832011)(36756003)(41300700001)(2616005)(4326008)(186003)(66476007)(66556008)(66446008)(76116006)(8676002)(64756008)(38100700002)(8936002)(122000001)(2906002)(86362001)(38070700005)(83380400001)(66946007)(71200400001)(6486002)(478600001)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UWY0M001L1dxZ0Zlbk14b3gyektaWGszdWhMaytGemIyVGZsZlpkRTVlTFNI?=
 =?utf-8?B?Rmg2MmdXWVNRaWpBcUFWUnFHdjFGcndrNUpLOHBZWjgwbHhGNWpQMXVnUmFz?=
 =?utf-8?B?bTFHbHhZOFZsd1FqenJLeUoxeEhWbGo1Zm1BU3Q5WDdNYTBVOVhtUVdTZUJ5?=
 =?utf-8?B?bmsrRDd4cTJTaHU5elFjY1AwUUk4YWFkbzlhOERwOUFpNit4ck1VRzhEU1VD?=
 =?utf-8?B?VTRSekpwajZoazJCcWlkQnNvYjZ5T1JhZzNjVGZlMnVOREZDQTl3S2ZXWHd5?=
 =?utf-8?B?Z0RkRnVEclJ5WE1VR2ovZjdyanJub0JkQ0RFL1YrYVhQZ0pYcHJMbE1iRWpI?=
 =?utf-8?B?YnZxTktxRWt4NERGMFpTeFYzaVllenJuMkNGQmVRY1dqcXdnNjRQVFdyWHJp?=
 =?utf-8?B?Sm5IM1ZKM3dQNW96UEpOUjU1dEE5TUhYenlzaHg2ZUZwdExuWlNGS3ptdmcx?=
 =?utf-8?B?RHFkWDVJcXo4VjBJQ2hxZVUrUmsrVW8zdXlybXl5alorRXN3VEZwdElYd2Zx?=
 =?utf-8?B?cmNmc1gyOE9CUmljclU0UVVGbmJ1ak5wVkR2NWtqdVJMY1hYQmx6M3N0ZmZE?=
 =?utf-8?B?bGFIcnZIYnR1RFgwRDExQTN6QkZ3VytQQVFCN3E0MHo2TlRpYmhZRnJ5L05P?=
 =?utf-8?B?bElYVGVUckd2Rk9uNjlVNlI0Z1BjTUhLaStmYXIvUEtTMXdZWjJIanBoWjBj?=
 =?utf-8?B?L05hRVpDbDFCMC96aVpyZHNoSm9lMjJ6ZkJuVFRPd0RmRW0rS3RMcnFjb1ZV?=
 =?utf-8?B?YWRZYmdiRGJsREZlUkdLTk9hZC9GTS9vbnNyYWhXOHVoVGZBd25BQmlPd0Na?=
 =?utf-8?B?eVRrQmtaU2lLYXJaODl2VG9MbGNjYk91RXkvWUowbDZrTC9OVUJFTURjWWsr?=
 =?utf-8?B?cVRSbUpTdHlJa1VXcFdmRHNUcDJ2WkRYbUN2ejA1ZGNnN3BwL1RTRmhWdytZ?=
 =?utf-8?B?Y2J4cUpRNmFydmp1SEpaaGR1Z2dsT1JGbWU0clYvRUx3dlVuNzJQQlR1T01J?=
 =?utf-8?B?d0dlcTNsYi9CU2JNSEd1TDZnekdKUnVNTCtwMXJscEgxYWxFQUFiV1pWOVVO?=
 =?utf-8?B?bFBoVjFKZUZ6OC9GdmU2ZjdKazg2Vk1PUEYvWVhCL0hRTWZZcTV1a1p3aGpn?=
 =?utf-8?B?TGJiUlRGcnY4a3IrR2RjZWpNL2NVNnZlcmY2WXdUVDFhQVdER0NISnEweFFL?=
 =?utf-8?B?Yk92S1BoaXNkRVNKK1BXRmVHSEYyYUdFSmpKUFNJSlo4VERTZFIxa0syZHlL?=
 =?utf-8?B?RjVKTlAyY3ZVWVJPVjE2NDFkWFNjbkZqYjJNc2gzSEJkT2NTK3pFL1lKOENx?=
 =?utf-8?B?TVlFQ3l2Q1BPVzQ5Y1dsRzd3dHJoK01OVXB2OVJ5a0djaEI3VHppZkJSallq?=
 =?utf-8?B?eEhBdTVBRUtiR3JpeXM1TjBjb2NBblI0aGx5OHNPREs5N21FS2xMc3BRV0VM?=
 =?utf-8?B?ck9ER1hqeHRGVmZGOWlhS2pYL1dhRnNadkI0T1BmanBpK2FMQmhhRkJmaDBI?=
 =?utf-8?B?aEN2YmxIbldqTnpmNnJMVWZRSUlVenkyRDEvczFEenhnR3pyeklBQnF4SHRQ?=
 =?utf-8?B?U3lyQm1ObnltQlM5cTZLQk5ac3V4RlJRdWpnbzROQUxkL2F3Z0VMQVpWb3hO?=
 =?utf-8?B?NjZuUStWUDhiNEpPeXpscGJjYnB3U1NUMXo4d1JOSFhRVFpCWWo3Nk4yRFVL?=
 =?utf-8?B?bUN1dVJsSG5sbEEyWVVWalhvSWpxUFl2R1BhVEpyKytPanJyNmFHYWI3MDI1?=
 =?utf-8?B?ZWFsNGllVWFnUHNjTE85UlJnYWJEaG95Q2tUMGZ1Mjc5S1lLb2JKUnp0YW9z?=
 =?utf-8?B?WStEWmJzV1krUUxGcWowWmFlZ3RmbkxudFhZNzF3bW0wN1JNNTlTWjRnQnYw?=
 =?utf-8?B?WXQ4N2UzZXNyZXpobk1LaEVYb01abjNVMmtkT3MxQlpJaWJ6TGZMVFpPRWc2?=
 =?utf-8?B?ODFvNVpIeXBNZHJSWWJnZ3pkdFJPeDdnZnQ3djgremxPK205ZEI0dHBWOUcx?=
 =?utf-8?B?Z2dMOW1NMDA1VUZ3ZU0rQS9NZmQ4bVNkZFRQVDFpcDBhQ3N4UTRFTXNDeHhB?=
 =?utf-8?B?bFpNMmhkS2xINU5BbjAyWGcxVEczWnZOUzFmZjNFVWoxd3g2YmlqdmhwMnlU?=
 =?utf-8?B?b0Vxdllwb0dEZEFXRXo5Vkh3SHJNUituQ3pwZzdmbUtLV0N3VWtVeENCazFJ?=
 =?utf-8?B?cXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A07BAE8518EC4E4BA03AC6E001DB21AA@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?V1Jvcm9YM2F2WGtsbW9JSlNtaElCQVRQUWZMY3RFVnBIU3Jtd2V2TUFaTHBX?=
 =?utf-8?B?K2d4OFl4RWRkVmhtbXlEeGxNQ2F0NGdlanExU0ZKazVrb3NmM0RGQnYyenZS?=
 =?utf-8?B?TENnZXhNL2RoS01UTHNnTGl4dWRFOHhDUTBXR3NuZk9ITVpmYXp0ZUo5cGNh?=
 =?utf-8?B?R0Q3Rlo2YmdxQkZlckdzU1JZL1VnMTBhTTJhbmpjdjU1Ri9oZmN6VXlKWjdn?=
 =?utf-8?B?VUQ1SjltTDhRcElRd1l3c20zQzdmNDF0RVg5SG1TazZydDE5WVpOYi8xMW16?=
 =?utf-8?B?ZWNOVFpNV0JFMVFxU2NZZ2dPemRGT1ZtU2FycVdES1Njd0sxekVXZDhoSlMv?=
 =?utf-8?B?RFNSM2dueEhEM2NHTGJMbVRTRGtuZEE0UjRBbFkzSWdqTlhxYmZxWlRGT05P?=
 =?utf-8?B?Z1RPS0VneHdNcEJER1daeDRsMDRGVzlmQnphNThTeE1xNVMvNnliMTRPUzlt?=
 =?utf-8?B?a29OeVdmcXF0bk5CdXNHS0FJSGYwK2JHN3dkd0JxT2R4K0g3NXd6Z211NXFY?=
 =?utf-8?B?cTB0ZWNKelcxSzRraUthdzFxb3VrSHpYOU1hT2duVkVKMk4yZHpldXdKb0gx?=
 =?utf-8?B?d014cS94bnp2cnlMdzk1UkpybWQ4OGZZTkFhTDIydlgxaFVxd2lod01lU3Ny?=
 =?utf-8?B?OElWM2F5TUhib29CTzhjSGZ5Z3pqZkkrSkxRRXVNSGNwcWdVam81MWNZVDJr?=
 =?utf-8?B?R014YmpSZ2ViWFZ0RFR3MW96dkRxNEFIaVNhYTRXZ1VpTWhWanUvWFV1RlJv?=
 =?utf-8?B?eWs1YVRMeE5WcUNyUjRPMHVWQ290dUh1S1pXYmg0akZDRFZDY0pVaGd2b0Yx?=
 =?utf-8?B?Mk5zb2dtQWZlU1RZemJxLzJUNktnMFM5enFiWEdTTjI2YXZ5TWdOc2dkYXJQ?=
 =?utf-8?B?TldoN3BTb216TTNQbnlPa3dpcmRWb1FZVmNSVjdMMnM0WjFQTGxYaWd3S2U2?=
 =?utf-8?B?V0tqRnZVeVJxY09TeVUybG4rclk1TnFQVmxoZXVrNUdxUmF4YTdiNVN5Q2w5?=
 =?utf-8?B?USt6S290QmxBR0tDMlhQY2lvZHZNVURITHNhSkUzeksrR0dqSURVQjJjRmZH?=
 =?utf-8?B?WTZJVEVJQ1ZacHdRUEE0eCtlSm1DK3FBbFhhTk9jbVVjdmttNzRRTHB0emRD?=
 =?utf-8?B?SlpsSjZCbjhuS01veXlBWit6MWJzbEJJdHlyNUlDU285dXFTaEJLcjZxVURX?=
 =?utf-8?B?a3JxNEI0RDFNN1Z4dVc5Y0lsSnFEcnR2ejJPcHZBdVU1Ly9nYVFoTHdTZVFw?=
 =?utf-8?Q?HurlKlrsx/yJwxl?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51f1b844-caec-4c32-2319-08dad4c5165e
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2022 00:26:57.4635
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kjF48X6604hK7YVjp41ZId5u//f7UfyztOPxOSOT8kYosooOyuhza7RKBfiLSbXG9PD9km6NlkCHPdMzTLefatRhJ7tAtTT2IeIC1+gZ2ok=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4347
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-02_12,2022-12-01_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 phishscore=0 suspectscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212030001
X-Proofpoint-ORIG-GUID: 39X9k8wBIHe3fx1T2Uj0F-UJp88FpYOe
X-Proofpoint-GUID: 39X9k8wBIHe3fx1T2Uj0F-UJp88FpYOe
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

T24gRnJpLCAyMDIyLTEyLTAyIGF0IDE5OjI3ICswODAwLCBaaXlhbmcgWmhhbmcgd3JvdGU6Cj4g
U29tZXRpbWVzICIkKCgxMjggKiBkYmxrc3ogLyA0MCkpIiBkaXJlbnRzIGNhbm5vdCBtYWtlIHN1
cmUgdGhhdAo+IFNfSUZESVIuRk1UX0JUUkVFIGNvdWxkIGJlY29tZSBidHJlZSBmb3JtYXQgZm9y
IGl0cyBEQVRBIGZvcmsuCj4gCj4gQWN0dWFsbHkgd2UganVzdCBvYnNlcnZlZCBpdCBjYW4gZmFp
bCBhZnRlciBhcHBseSBvdXIgaW5vZGUKPiBleHRlbnQtdG8tYnRyZWUgd29ya2Fyb3VuZC4gVGhl
IHJvb3QgY2F1c2UgaXMgdGhhdCB0aGUga2VybmVsIG1heSBiZQo+IHRvbyBnb29kIGF0IGFsbG9j
YXRpbmcgY29uc2VjdXRpdmUgYmxvY2tzIHNvIHRoYXQgdGhlIGRhdGEgZm9yayBpcwo+IHN0aWxs
IGluIGV4dGVudHMgZm9ybWF0Lgo+IAo+IFRoZXJlZm9yZSBpbnN0ZWFkIG9mIHVzaW5nIGEgZml4
ZWQgbnVtYmVyLCBsZXQncyBtYWtlIHN1cmUgdGhlIG51bWJlcgo+IG9mIGV4dGVudHMgaXMgbGFy
Z2UgZW5vdWdoIHRoYW4gKGlub2RlIHNpemUgLSBpbm9kZSBjb3JlIHNpemUpIC8KPiBzaXplb2Yo
eGZzX2JtYnRfcmVjX3QpLgo+IAo+IFN1Z2dlc3RlZC1ieTogIkRhcnJpY2sgSi4gV29uZyIgPGRq
d29uZ0BrZXJuZWwub3JnPgo+IFNpZ25lZC1vZmYtYnk6IEdhbyBYaWFuZyA8aHNpYW5na2FvQGxp
bnV4LmFsaWJhYmEuY29tPgo+IFNpZ25lZC1vZmYtYnk6IFppeWFuZyBaaGFuZyA8Wml5YW5nWmhh
bmdAbGludXguYWxpYmFiYS5jb20+CgpOZXcgdmVyc2lvbiBsb29rcyBtdWNoIGNsZWFuZXIuICAK
UmV2aWV3ZWQtYnk6IEFsbGlzb24gSGVuZGVyc29uIDxhbGxpc29uLmhlbmRlcnNvbkBvcmFjbGUu
Y29tPgoKPiAtLS0KPiBWMjogdGFrZSBEYXJyaWNrJ3MgYWR2aWNlIHRvIGNsZWFudXAgY29kZQo+
IMKgY29tbW9uL3BvcHVsYXRlIHwgMjggKysrKysrKysrKysrKysrKysrKysrKysrKysrLQo+IMKg
Y29tbW9uL3hmc8KgwqDCoMKgwqAgfCAxNyArKysrKysrKysrKysrKysrKwo+IMKgMiBmaWxlcyBj
aGFuZ2VkLCA0NCBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCj4gCj4gZGlmZiAtLWdpdCBh
L2NvbW1vbi9wb3B1bGF0ZSBiL2NvbW1vbi9wb3B1bGF0ZQo+IGluZGV4IDZlMDA0OTk3Li4xY2E3
NjQ1OSAxMDA2NDQKPiAtLS0gYS9jb21tb24vcG9wdWxhdGUKPiArKysgYi9jb21tb24vcG9wdWxh
dGUKPiBAQCAtNzEsNiArNzEsMzEgQEAgX19wb3B1bGF0ZV9jcmVhdGVfZGlyKCkgewo+IMKgwqDC
oMKgwqDCoMKgwqBkb25lCj4gwqB9Cj4gwqAKPiArIyBDcmVhdGUgYSBsYXJnZSBkaXJlY3Rvcnkg
YW5kIGVuc3VyZSB0aGF0IGl0J3MgYSBidHJlZSBmb3JtYXQKPiArX19wb3B1bGF0ZV94ZnNfY3Jl
YXRlX2J0cmVlX2RpcigpIHsKPiArwqDCoMKgwqDCoMKgwqBsb2NhbCBuYW1lPSIkMSIKPiArwqDC
oMKgwqDCoMKgwqBsb2NhbCBpc2l6ZT0iJDIiCj4gK8KgwqDCoMKgwqDCoMKgbG9jYWwgaWNvcmVf
c2l6ZT0iJChfeGZzX2lub2RlX2NvcmVfYnl0ZXMpIgo+ICvCoMKgwqDCoMKgwqDCoCMgV2UgbmVl
ZCBlbm91Z2ggZXh0ZW50cyB0byBndWFyYW50ZWUgdGhhdCB0aGUgZGF0YSBmb3JrIGlzCj4gaW4K
PiArwqDCoMKgwqDCoMKgwqAjIGJ0cmVlIGZvcm1hdC7CoCBDeWNsaW5nIHRoZSBtb3VudCB0byB1
c2UgeGZzX2RiIGlzIHRvbyBzbG93LAo+IHNvCj4gK8KgwqDCoMKgwqDCoMKgIyB3YXRjaCBmb3Ig
d2hlbiB0aGUgZXh0ZW50IGNvdW50IGV4Y2VlZHMgdGhlIHNwYWNlIGFmdGVyIHRoZQo+ICvCoMKg
wqDCoMKgwqDCoCMgaW5vZGUgY29yZS4KPiArwqDCoMKgwqDCoMKgwqBsb2NhbCBtYXhfbmV4dGVu
dHM9IiQoKChpc2l6ZSAtIGljb3JlX3NpemUpIC8gMTYpKSIKPiArCj4gK8KgwqDCoMKgwqDCoMKg
bWtkaXIgLXAgIiR7bmFtZX0iCj4gK8KgwqDCoMKgwqDCoMKgZD0wCj4gK8KgwqDCoMKgwqDCoMKg
d2hpbGUgdHJ1ZTsgZG8KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgY3JlYXQ9bWtk
aXIKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgdGVzdCAiJCgoZCAlIDIwKSkiIC1l
cSAwICYmIGNyZWF0PXRvdWNoCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCRjcmVh
dCAiJHtuYW1lfS8kKHByaW50ZiAiJS4wOGQiICIkZCIpIgo+ICvCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqBpZiBbICIkKChkICUgNDApKSIgLWVxIDAgXTsgdGhlbgo+ICvCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgbmV4dGVudHM9IiQoX3hmc19nZXRf
ZnN4YXR0ciBuZXh0ZW50cyAkbmFtZSkiCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqBbICRuZXh0ZW50cyAtZ3QgJG1heF9uZXh0ZW50cyBdICYmIGJyZWFr
Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGZpCj4gK8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoGQ9JCgoZCsxKSkKPiArwqDCoMKgwqDCoMKgwqBkb25lCj4gK30KPiArCj4g
wqAjIEFkZCBhIGJ1bmNoIG9mIGF0dHJzIHRvIGEgZmlsZQo+IMKgX19wb3B1bGF0ZV9jcmVhdGVf
YXR0cigpIHsKPiDCoMKgwqDCoMKgwqDCoMKgbmFtZT0iJDEiCj4gQEAgLTE3Niw2ICsyMDEsNyBA
QCBfc2NyYXRjaF94ZnNfcG9wdWxhdGUoKSB7Cj4gwqAKPiDCoMKgwqDCoMKgwqDCoMKgYmxrc3o9
IiQoc3RhdCAtZiAtYyAnJXMnICIke1NDUkFUQ0hfTU5UfSIpIgo+IMKgwqDCoMKgwqDCoMKgwqBk
Ymxrc3o9IiQoX3hmc19nZXRfZGlyX2Jsb2Nrc2l6ZSAiJFNDUkFUQ0hfTU5UIikiCj4gK8KgwqDC
oMKgwqDCoMKgaXNpemU9IiQoX3hmc19pbm9kZV9zaXplICIkU0NSQVRDSF9NTlQiKSIKPiDCoMKg
wqDCoMKgwqDCoMKgY3JjPSIkKF94ZnNfaGFzX2ZlYXR1cmUgIiRTQ1JBVENIX01OVCIgY3JjIC12
KSIKPiDCoMKgwqDCoMKgwqDCoMKgaWYgWyAkY3JjIC1lcSAxIF07IHRoZW4KPiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoGxlYWZfaGRyX3NpemU9NjQKPiBAQCAtMjI2LDcgKzI1Miw3
IEBAIF9zY3JhdGNoX3hmc19wb3B1bGF0ZSgpIHsKPiDCoAo+IMKgwqDCoMKgwqDCoMKgwqAjIC0g
QlRSRUUKPiDCoMKgwqDCoMKgwqDCoMKgZWNobyAiKyBidHJlZSBkaXIiCj4gLcKgwqDCoMKgwqDC
oMKgX19wb3B1bGF0ZV9jcmVhdGVfZGlyICIke1NDUkFUQ0hfTU5UfS9TX0lGRElSLkZNVF9CVFJF
RSIKPiAiJCgoMTI4ICogZGJsa3N6IC8gNDApKSIgdHJ1ZQo+ICvCoMKgwqDCoMKgwqDCoF9fcG9w
dWxhdGVfeGZzX2NyZWF0ZV9idHJlZV9kaXIKPiAiJHtTQ1JBVENIX01OVH0vU19JRkRJUi5GTVRf
QlRSRUUiICIkaXNpemUiCj4gwqAKPiDCoMKgwqDCoMKgwqDCoMKgIyBTeW1saW5rcwo+IMKgwqDC
oMKgwqDCoMKgwqAjIC0gRk1UX0xPQ0FMCj4gZGlmZiAtLWdpdCBhL2NvbW1vbi94ZnMgYi9jb21t
b24veGZzCj4gaW5kZXggOGFjMTk2NGUuLjAzNTllNDIyIDEwMDY0NAo+IC0tLSBhL2NvbW1vbi94
ZnMKPiArKysgYi9jb21tb24veGZzCj4gQEAgLTE0ODYsMyArMTQ4NiwyMCBAQCBfcmVxdWlyZV94
ZnNyZXN0b3JlX3hmbGFnKCkKPiDCoMKgwqDCoMKgwqDCoMKgJFhGU1JFU1RPUkVfUFJPRyAtaCAy
PiYxIHwgZ3JlcCAtcSAtZSAnLXgnIHx8IFwKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqBfbm90cnVuICd4ZnNyZXN0b3JlIGRvZXMgbm90IHN1cHBvcnQg
LXgKPiBmbGFnLicKPiDCoH0KPiArCj4gKwo+ICsjIE51bWJlciBvZiBieXRlcyByZXNlcnZlZCBm
b3IgYSBmdWxsIGlub2RlIHJlY29yZCwgd2hpY2ggaW5jbHVkZXMKPiB0aGUKPiArIyBpbW1lZGlh
dGUgZm9yayBhcmVhcy4KPiArX3hmc19pbm9kZV9zaXplKCkKPiArewo+ICvCoMKgwqDCoMKgwqDC
oGxvY2FsIG1udHBvaW50PSIkMSIKPiArCj4gK8KgwqDCoMKgwqDCoMKgJFhGU19JTkZPX1BST0cg
IiRtbnRwb2ludCIgfCBncmVwICdtZXRhLWRhdGE9Lippc2l6ZScgfCBzZWQgLQo+IGUgJ3MvXi4q
aXNpemU9XChbMC05XSpcKS4qJC9cMS9nJwo+ICt9Cj4gKwo+ICsjIE51bWJlciBvZiBieXRlcyBy
ZXNlcnZlZCBmb3Igb25seSB0aGUgaW5vZGUgcmVjb3JkLCBleGNsdWRpbmcgdGhlCj4gKyMgaW1t
ZWRpYXRlIGZvcmsgYXJlYXMuCj4gK194ZnNfaW5vZGVfY29yZV9ieXRlcygpCj4gK3sKPiArwqDC
oMKgwqDCoMKgwqBlY2hvIDE3Ngo+ICt9Cgo=
