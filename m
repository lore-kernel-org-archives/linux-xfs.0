Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA274EB64DC
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Jul 2023 22:58:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbjGRW6B (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Jul 2023 18:58:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231438AbjGRW54 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jul 2023 18:57:56 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E1B7113
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jul 2023 15:57:48 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36ILebXJ017993
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jul 2023 22:57:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : content-id :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=ebiAS4pJ9bQrApBOMqYrC+F/3OacsOekgmZhBsAgSQw=;
 b=JMlQGHO5rotkq1+dC1S58TjGKEf4o1gS1tiLwcL2kKB6VgH2mbFE7QtmNtRzZK+uTacs
 tWLJzVOtCeMJtGxoVVkB9IkBa80Q8EoWTPzkeKif41tH3X+LdJYtLh6vf/2q7IKh4BSa
 97IPlCIl/NzDit9iTjIFECc0164Zt8FahfHJp+s8DeXz/M2kkhhsou0P65ijJPABgtRq
 uXG7gduDbFRdZ+jEcDaHaeGUFVoYLYTqi7bq3XT4R6CzYJ4pONKX3TC7vkJuuKDXHEor
 tUEQC5xTSsQskjMpOQ8EKdkTZ98I2dt9GunheJmdRYPMTzrrzQ195yt+x+C7lXqgRr11 rQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3run8a6b3a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jul 2023 22:57:47 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36IKpSgj038189
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jul 2023 22:57:46 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ruhw5ugx6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jul 2023 22:57:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mQNdMxqyKo6Xb7dfal27pFFBf5/oQ4ogD/SEG9S8VjsE5FPGvBsaFf1CGEPP+ygM3mKNjJrR1dGbLtthTrOi1O5RjDLa01yBrbL3mVhCfkLP3A/JtsNZM0SmD+TcuPKNPRq7D8TRCPTU6QW5Yf3X0f5NyFlcoaRnLQLE4dva0oTdk92N+Ihu1QrapdPJji+2t5BWEHofLTnnEJhdG0Vzc/dIq25USaUejDN7ohn6c4b43uR5sDKSWBlMUDQ4/N2iKh90CbVAva5r115XkIZBP/BL5GfI6xLB8xp39gtvSaLRwB8+tzav1E8kzFrzz5LVYJPMvf5gdzDYTcOZspBS7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ebiAS4pJ9bQrApBOMqYrC+F/3OacsOekgmZhBsAgSQw=;
 b=GMTFLUvsggNmB7ziBa3M5SMpMmOVSrG3lwkE4wP+IH/Wwg7QZUkaSuFNvpr+LdWiHErI/dSfI/h/AQvXsYQU23p+ePvm7F7dSuUtlnWRnX3QekXp95YrY3CJ7i8acHNeGoCj9JXf5RpeibK4VhptY727HqrtD67isrcSzM3tral2ByvDUO8S60xVkBg33IliLDs7hA9ZrLffQKhMT0Aa/gGe330MC2g8W8z3u6bwquOiPcE1rYnUShUMNoVTKkOoCV6Lbg8/8wEgqN5/iPdaGQtuc9Pq2XUfLw59DzlY7EoRw7hnb32DT5EGQO7C+LOGFpK8WV0ZtDYjIJxD/R0y0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ebiAS4pJ9bQrApBOMqYrC+F/3OacsOekgmZhBsAgSQw=;
 b=N0iD7nflkjYdVeG8TcM9QFjqIBMOVsTw+Mi5ktL9etU5WYPKEydiELl4yeKaLi//7xcPByGpHg8wH7nQpli+PuphUZ06B9n3oY5bwFpQ7LYV7MuzTXf8PjS71KBl34Kj9rRKh+J8+oMKAQp/EHdHcpmQpOmS264loutHnvQVQwQ=
Received: from SN6PR10MB2701.namprd10.prod.outlook.com (2603:10b6:805:45::20)
 by CY8PR10MB7291.namprd10.prod.outlook.com (2603:10b6:930:7e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.27; Tue, 18 Jul
 2023 22:57:39 +0000
Received: from SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::72f4:e7e3:9b11:8c74]) by SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::72f4:e7e3:9b11:8c74%5]) with mapi id 15.20.6588.031; Tue, 18 Jul 2023
 22:57:39 +0000
From:   Wengang Wang <wen.gang.wang@oracle.com>
To:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
CC:     Srikanth C S <srikanth.c.s@oracle.com>
Subject: Question: reserve log space at IO time for recover
Thread-Topic: Question: reserve log space at IO time for recover
Thread-Index: AQHZuctApGWc9uvtR0uQfuoZOzE5mw==
Date:   Tue, 18 Jul 2023 22:57:38 +0000
Message-ID: <1DB9F8BB-4A7C-4422-B447-90A08E310E17@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2701:EE_|CY8PR10MB7291:EE_
x-ms-office365-filtering-correlation-id: 7f0f59a1-8fc4-4f92-21f7-08db87e2628f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vkvXCzXCVbTQCcbMk2GCFQ8CgMQaftbqI7ysu3uLb1/lhh+7fKE7xiZDw3dk05e38KYKmmGK9ryIuF6eVDmKWBFj9RdZX+Hmk4pcIRLvG91UGWZ1viaU9Jjoy7JqK2FVBrAcCYhyVH85snNZLxFZwzPzcB30PeQy1wgazI1HIiBq7Y0Y+xxMLC8Xd7yLUjFcwq0mwh2cmset5N01o1vL8zbTeCkmkqbkRVaqvMs7ntu2BL097dWhjoNQ4x3yehB99cn+jFrM2/j0EGhSZ3/D6Oe+5In4Y88IQbIzQWQg2UbYMTfN9am+sIdY55xhiTbIkkD8luofzU24ReuZYUIyIdmaIVfSG/L5KlcKSBeWwVHZtg6/4iY+hp0lB5aaKi2hbfhW33EZ0plUFeGlbNuzU5Qj1jePoPu3pRrFcDp9JSSkmmAZweaVAnWPj/lgFw7uwrNHvYEH33TsE61DvcHeXhCbYys43WdIWi8o61cjkmKv3OT4v55N8Mbes8IWa1uPnjo4ovIL8K7WKGbpqORo2EKa39ySCwTk7Gx8i2NfLEHBlXH8HJSqQSe6Z4GMc0Kj24voRCI2ckUop5EujQKWQzUtJElyPUgBBh2Pfk7yWwuLD54XkZdmf5OLfAJvb7vwL9tJOFB/8w8Z5CRsZ6utEQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2701.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(366004)(39860400002)(376002)(396003)(451199021)(86362001)(478600001)(33656002)(41300700001)(36756003)(107886003)(8936002)(6512007)(8676002)(4326008)(64756008)(6916009)(6486002)(66476007)(76116006)(316002)(66556008)(66446008)(66946007)(186003)(5660300002)(6506007)(91956017)(26005)(71200400001)(2906002)(2616005)(38070700005)(122000001)(38100700002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WEVXM2c3UkQvbUsvaE44TDcrV3JxaTRpN1J6Q3ZyaWk5c1I5T3pHSHZ0dk5B?=
 =?utf-8?B?UXQvMnZFVlE3WVhrb3U3YmpiZ1ZJQlhjYkd2RnRsaXFiTlZEWTFRTjhlYzh5?=
 =?utf-8?B?elVZZlNSdjBYL2NVcFhJT3ZybWpSMndveWtRN25VSkl0WFZxWEdVbXZqQU53?=
 =?utf-8?B?NjdqUVBBc0s3N2FPSzZ4dml4RkppZ2M0QU1RcFY5OGNRWU1vcUpmTHlGV0w3?=
 =?utf-8?B?TEFVMUFTZ1l4cmNob0czUGVPVzdvUHpRU3g4M1lBSUhqZWIxNDBoa1FVMWxJ?=
 =?utf-8?B?dnNVZnVqc0w3QVpRYmtFczdidU83dmtGMGNEQlhtT201RGVTNEx0THFtSHV2?=
 =?utf-8?B?dTYxRW5BWm1reEFTK1pUdHVMTEpnZHkzMVRGS0hscXZld2ZEcTJKRjVNVktG?=
 =?utf-8?B?bmhmRlpwZEpvRkxOQmRtY2ZtSUVLQmlRZHpnWi9jSnkyNndqbzViNkttcVE4?=
 =?utf-8?B?WEo2QnVJOFZJcVBEU2IvR2p5ZzVYdkxXUHNjbk9RMHd5aUFLUFJ1OUNlRjRy?=
 =?utf-8?B?MUVXejJ0MFlYZDJVL1RwUHhBYWdNUWZKaWxUTkxlcXJ6ZDlta1dRQTFJT2No?=
 =?utf-8?B?cXkyTXhMWjRBRHdPV21IODE3NWpnVWd2ZllGM0pkTkhpY24wR1pmUjVLQnRQ?=
 =?utf-8?B?T0hrM1JVZFJ4OXh3SmJMTVJpajdDVHRnY1ZCditadUMrOStPM3JHaExDSUdj?=
 =?utf-8?B?RTFtTE1mRDJ1K2lEM3ZWb2hmVDh5RURVeUc0MFVZcmxiVjdwaWhrakkwU0VV?=
 =?utf-8?B?YTFlWDNJODJuUW5PSE10QVRBRVF5dmRuR3JWeFNZQWNER0gwWmlkNUdqNjdq?=
 =?utf-8?B?d2hjanVSNUpDYm0vTjhMVENHMG85TkJXVW5heWVaVWY3Nkk4WUdjbUJGUDJt?=
 =?utf-8?B?RUUzRkFCYnlCVForSEZsNFMzR2hjUjlDbUpURDc4dlpaSEVreW1BcWpGYjY3?=
 =?utf-8?B?dHB2YzVtRktEaUk5aXFTZjM0N0pEajdlc2tUQjNObWpPZFlIYm1TYzJJL3B1?=
 =?utf-8?B?ZDMza2svYVpxK2cxSllZRFRzYVNZMktrNzZZbG45MWhQNnYxV0NKdFFvQWp1?=
 =?utf-8?B?d0h0YWcveUtXdXBxOGRzT2dPYjIzVm9hZ0E2aHV1aGVkd3lWWG9Ca2hHbUtV?=
 =?utf-8?B?SE9pY3pHSmFZMnV4T1FUNW1RVkZqVFFEZHJHL000V3pPQjg3bHBHcCtTM0lk?=
 =?utf-8?B?MXlPdENhenIrRGtZN0xOanB2eUxtaVc5ekpvYUdYNWlJNWg1ZUxvdGdVMU9Q?=
 =?utf-8?B?TnJFVnE5K1dIOEJydWQzWDg1QU56Vmw5V3RMZ1JIOU5lMVFHTlMyZWZvU2dG?=
 =?utf-8?B?Qno3RkIzNGxoMS9ralpiQ29tMjVlTnh2NEpGUmFGZHpnREN4Ri9NWGdua0ZI?=
 =?utf-8?B?ZUhKZGQ0TTFVN0pUemR6MWZ5WDNxNzJvZ1M3MVppM0NndUhoQUhRQytBbURX?=
 =?utf-8?B?RzA0V2FQME1XaHBqR0NLaGt2QUV0a0tWNWlQV2hzRFN4Rmt1Tm1jcHVlMk83?=
 =?utf-8?B?SUd1aWNiWElyc3Z4MFF3Z1BMWEhFS2FFcWQvUDhSU2dTTlJFSnhYallBWk5q?=
 =?utf-8?B?dDB5RDNUMWRWVUsxVVdFUmw5QUFxcldid3ErMThyeEU4YVFjcDgyOXdtQUV5?=
 =?utf-8?B?dGVmd1h6NWNJUi9CZ1hydlAzK052MWczN0tVRDFYWUsrZ3lwRmNrVnFQUG5l?=
 =?utf-8?B?TERkcHRuR0E4UGovdUlDYTV4QXBFanVZb0JtTlk4eTRieFhjZUt4YTRLUzdi?=
 =?utf-8?B?TnJ4NnpSVWtRM00rSVlYTDZlNGxDdUw4Q2twTzNrUEdIM2xhTGhhOXNtWkln?=
 =?utf-8?B?Q0hJaml0MkdKSlNWc1l0WmMxQWlvczVCVTJocGowWTNTaVFFMXhac014L2Fo?=
 =?utf-8?B?blJjTjNwTDdMU0grZVlGVVYrSlJob2prQmc2bkNwaXF6TjlMaEhMK2V0R1Nl?=
 =?utf-8?B?WVVMbmhLMzk5NzdpdmdicTNyemg0U3dvUTAyVm52MCtTUUN0UWVEd2dnWm5a?=
 =?utf-8?B?TDFDUnhQeW9GQnZHVm9jOHFMSE9OeW9BQldoNDdDS1ZLRFdWYzVpNTk5SVFC?=
 =?utf-8?B?bUVsS2sxcWJ3UFVEOUF2MHl0Q0NDQXRVM3d5VUpnRGVSZ3g5UXA2OWhNWGor?=
 =?utf-8?B?Z1BOSVB4UXc4c0o1cjBGWVpJQ1Q5b0JqNkhhRi95QlVkKzZRR0pUWjRYUE85?=
 =?utf-8?B?MUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A5F4CE9AE75AC54BAF15201122C1BDB3@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: +qNt7OHnfKTcfA487qhSgUN6vH1IAGU2nThirjRZWzOewmUEWYNUF3CqrhEMkUAH4rQhx3u08MAqmcpugnT3yTo64Yw/ZI3h9ZoVhJ4K6EBgi1JVoBup1O0Qq/2NyY/b/f3tZjeExNQy4zY7qX0I85AeXKn+VVqP1hHps59ePYVQvUM2vyrmAEEYteAaTxHLz1Ddz0HsIVXs5w/Tqv/QmxBO6T7330J6KaiCF/+RpTq4Z2A715uDx0D9jCMRWESZRufnnVwBSvJ6CXnEjMQZvpK4ordpsVdLZWNnlcFDayNNj5cNW41JLgwszTnTIc+5e+D4V9vvB8uKW7I06718h4TSLNVTSL4RkF3iJT751Sbptbt3B4UMx34KdYuPOBB2cedOGFwWn0J3+wcB+5EYwA1RodqpBUHjSfmytSHBINapPdSsyBJKWF/CKRzWeduOGWnjK6aPgoRbDqDaFQaZkSJkkDkTx+srVRzPxv5WM+X/MXxB5C687uNVOS13+yRzuFkUuYF2MF7przNKRxtFIv+W5FZ5hDP0bH7+qI4P4/n4xOG3Hzm6e6zjhsgsUBGn5TUP1y0iW3XOkCA2f9SE83EcYgERDGq+E/K4eRv4TGlHxw/u0XodLknhy+qzKMrGHBUbTUXZ8t8xwUhH/d7Khlu/lPBSGvCe5AGrS49sQ2uAZg3PHHXEvzZH2iVgHv+nVwsbDJjy10HYfRPHkVImO+Q+en3vZlH/HBb5fa+bnZSN4rV2N/p8sCxYgIOcU2jU+q5Ik+dCrbV6gTPKTqrkGg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f0f59a1-8fc4-4f92-21f7-08db87e2628f
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jul 2023 22:57:38.8857
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D/goHh8vnUUGkN8PQcmMUgMacAxwcetUk94odoCrL69hJ6A5hLlF/BKuCWD+e5vXRxBytUkKYDB0AjgWezULJylXRIR9yTBswJibu6m+qBY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7291
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-18_17,2023-07-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 adultscore=0 spamscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307180203
X-Proofpoint-ORIG-GUID: doSYDnZPc29dz40PXnlIFJFxdqRtK_0K
X-Proofpoint-GUID: doSYDnZPc29dz40PXnlIFJFxdqRtK_0K
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

SGksDQoNCkkgaGF2ZSBhIFhGUyBtZXRhZHVtcCAod2FzIHJ1bm5pbmcgd2l0aCA0LjE0LjM1IHBs
dXNzaW5nIHNvbWUgYmFjayBwb3J0ZWQgcGF0Y2hlcyksDQptb3VudGluZyBpdCAobG9nIHJlY292
ZXIpIGhhbmcgYXQgbG9nIHNwYWNlIHJlc2VydmF0aW9uLiBUaGVyZSBpcyAxODE3NjAgYnl0ZXMg
b24tZGlzaw0KZnJlZSBqb3VybmFsIHNwYWNlLCB3aGlsZSB0aGUgdHJhbnNhY3Rpb24gbmVlZHMg
dG8gcmVzZXJ2ZSAzNjA0MTYgYnl0ZXMgdG8gc3RhcnQgdGhlIHJlY292ZXJ5Lg0KVGh1cyB0aGUg
bW91bnQgaGFuZ3MgZm9yIGV2ZXIuIFRoYXQgaGFwcGVucyB3aXRoIDQuMTQuMzUga2VybmVsIGFu
ZCBhbHNvIHVwc3RyZWFtDQprZXJuZWwgKDYuNC4wKS4NCg0KVGhlIGlzIHRoZSByZWxhdGVkIHN0
YWNrIGR1bXBpbmcgKDYuNC4wIGtlcm5lbCk6DQoNCls8MD5dIHhsb2dfZ3JhbnRfaGVhZF93YWl0
KzB4YmQvMHgyMDAgW3hmc10NCls8MD5dIHhsb2dfZ3JhbnRfaGVhZF9jaGVjaysweGQ5LzB4MTAw
IFt4ZnNdDQpbPDA+XSB4ZnNfbG9nX3Jlc2VydmUrMHhiYy8weDFlMCBbeGZzXQ0KWzwwPl0geGZz
X3RyYW5zX3Jlc2VydmUrMHgxMzgvMHgxNzAgW3hmc10NCls8MD5dIHhmc190cmFuc19hbGxvYysw
eGU4LzB4MjIwIFt4ZnNdDQpbPDA+XSB4ZnNfZWZpX2l0ZW1fcmVjb3ZlcisweDExMC8weDI1MCBb
eGZzXQ0KWzwwPl0geGxvZ19yZWNvdmVyX3Byb2Nlc3NfaW50ZW50cy5pc3JhLjI4KzB4YmEvMHgy
ZDAgW3hmc10NCls8MD5dIHhsb2dfcmVjb3Zlcl9maW5pc2grMHgzMy8weDMxMCBbeGZzXQ0KWzww
Pl0geGZzX2xvZ19tb3VudF9maW5pc2grMHhkYi8weDE2MCBbeGZzXQ0KWzwwPl0geGZzX21vdW50
ZnMrMHg1MWMvMHg5MDAgW3hmc10NCls8MD5dIHhmc19mc19maWxsX3N1cGVyKzB4NGI4LzB4OTQw
IFt4ZnNdDQpbPDA+XSBnZXRfdHJlZV9iZGV2KzB4MTkzLzB4MjgwDQpbPDA+XSB2ZnNfZ2V0X3Ry
ZWUrMHgyNi8weGQwDQpbPDA+XSBwYXRoX21vdW50KzB4NjlkLzB4OWIwDQpbPDA+XSBkb19tb3Vu
dCsweDdkLzB4YTANCls8MD5dIF9feDY0X3N5c19tb3VudCsweGRjLzB4MTAwDQpbPDA+XSBkb19z
eXNjYWxsXzY0KzB4M2IvMHg5MA0KWzwwPl0gZW50cnlfU1lTQ0FMTF82NF9hZnRlcl9od2ZyYW1l
KzB4NmUvMHhkOA0KDQpUaHVzIHdlIGNhbiBzYXkgNC4xNC4zNSBrZXJuZWwgZGlkbuKAmXQgcmVz
ZXJ2ZSBsb2cgc3BhY2UgYXQgSU8gdGltZSB0byBtYWtlIGxvZyByZWNvdmVyDQpzYWZlLiBVcHN0
cmVhbSBrZXJuZWwgZG9lc27igJl0IGRvIHRoYXQgZWl0aGVyIGlmIEkgcmVhZCB0aGUgc291cmNl
IGNvZGUgcmlnaHQgKEkgbWlnaHQgYmUgd3JvbmcpLg0KDQpTbyBzaGFsbCB3ZSByZXNlcnZlIHBy
b3BlciBhbW91bnQgb2YgbG9nIHNwYWNlIGF0IElPIHRpbWUsIGNhbGwgaXQgVW5mbHVzaC1SZXNl
cnZlLCB0bw0KZW5zdXJlIGxvZyByZWNvdmVyeSBzYWZlPyAgVGhlIG51bWJlciBvZiBVUiBpcyBk
ZXRlcm1pbmVkIGJ5IGN1cnJlbnQgdW4gZmx1c2hlZCBsb2cgaXRlbXMuDQpJdCBnZXRzIGluY3Jl
YXNlZCBqdXN0IGFmdGVyIHRyYW5zYWN0aW9uIGlzIGNvbW1pdHRlZCBhbmQgZ2V0cyBkZWNyZWFz
ZWQgd2hlbiBsb2cgaXRlbXMgYXJlDQpmbHVzaGVkLiBXaXRoIHRoZSBVUiwgd2UgYXJlIHNhZmUg
dG8gaGF2ZSBlbm91Z2ggbG9nIHNwYWNlIGZvciB0aGUgdHJhbnNhY3Rpb25zIHVzZWQgYnkgbG9n
DQpyZWNvdmVyeS4NCg0KdGhhbmtzLA0Kd2VuZ2FuZw==
