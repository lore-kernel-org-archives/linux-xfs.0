Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6F36C004D4
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Jan 2023 22:38:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbjASWil (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Jan 2023 17:38:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbjASWhM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Jan 2023 17:37:12 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BCEE3A5AD
        for <linux-xfs@vger.kernel.org>; Thu, 19 Jan 2023 14:18:56 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30JLSlHl026909;
        Thu, 19 Jan 2023 22:18:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=WS6WslxbZczOhx+PA/NfsAHeKKWqQgSvUGfJhtmsCw0=;
 b=0cQqjKK2ClM6wlaEBQO3AVwyXehu2KEqkhmZb4WJDA8vPja0VbcCea9jBsVwPk07Dn0J
 9O0o5nEbhfA3jzpvpKGH1rVcwdl2ukznrrIuhCT52e2Sg/7HcmqF3OoapANWGupUWt6p
 PGl6mB6AQG/x/Xphtk7Jte4aW/900sJFBSUhpVPdLS9PDbBTTUSFHvx0YdSMYPIdmHRy
 KVBusNn/gyCRvRAvBUG3DdFerhX4ClM5BnqQHFpxdKuW7H4h8OX5d+U8bCg+G1h747nh
 +dqnTIWaqshubwV8wyGAt+X9G6FSVVEZyifqEZDYWEuzCIrwbxY24nRrkgbmTd0hQT/D Hg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n3kaakdt5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Jan 2023 22:18:55 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30JLNKDe007802;
        Thu, 19 Jan 2023 22:18:54 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n6rgdratg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Jan 2023 22:18:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bDXZ6/26WkwTDAPWyti3N3zuERvi42ukVrHtZ8jQgMIBeY88/ux284sTMC/h0CQ6ij5CLmGK5jS22bHx3r+2LcLN1HSyadbbRRVcL4K8nczDWpNEnVL2/wbqyDRYdJvegO5GX9lVUq+201haZPL0meDyvycznUgVYpx9vboKH3sCydsMor4HsTcVBdpkz/TmlmjcuB0jAfzJffUxxYd2mVexmvtpvm113MhpJYtsjUikcaH6e81I93vG9yB3P2H8HU0pjAI5ffIAk4aocQt0lLSMfRso6FAgeIgYRZjHHGd+cPkbDnnC7yGaMPH88KvG62t7ghaMDA88yu8oGwT8eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WS6WslxbZczOhx+PA/NfsAHeKKWqQgSvUGfJhtmsCw0=;
 b=UeUAe+DER7K5SBXBoNjbuiVxueg8DoiNy/eZu/yvyvKrqifLG8Onkf1nJbaio5cS3rHCBFArbdycmJtIG2fFGi8wwNClxMqpTTj2cZwOnaoDJWa9yZk5OLe7vpCbRy/+OPoa35OFZAlrWgbl0ACJrMdD3Uf8H8kZ6g8D9fJ+BefjJuJLGqs9bF1+/usvcY9sDoz2PXVvYJDxw3dSc5y2M27y13ZD/GJeEjt40F4OxfQ2Xj2R0FOlekoZ1WOCVxNwgFz2QeM/ji5nzAZGhuKUPZPJ4D/NuGhqJWPo6Z2VlQ9oEwGSwM42tULA3YahN+BGS0tADrq4phrN/2c3c96AcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WS6WslxbZczOhx+PA/NfsAHeKKWqQgSvUGfJhtmsCw0=;
 b=nD4VXLYl6JoUPR5QboHQrvauHkErCE9Y3C5VNbJFH7JGd9Z12O30UFzxhibuy8DsPqomFJiH03v5rK88p2YoB2ZPfeAUHr7h/Ivo2i8yyu9gzD3o8d74Nm8ZGXYakllgOxDxBHlHDWTfLnRXho/YYbYH1D3L/dFjLZdcS/tYgrA=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CH0PR10MB5211.namprd10.prod.outlook.com (2603:10b6:610:df::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.6; Thu, 19 Jan
 2023 22:18:50 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%5]) with mapi id 15.20.6002.012; Thu, 19 Jan 2023
 22:18:50 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     "david@fromorbit.com" <david@fromorbit.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 06/42] xfs: don't assert fail on transaction cancel with
 deferred ops
Thread-Topic: [PATCH 06/42] xfs: don't assert fail on transaction cancel with
 deferred ops
Thread-Index: AQHZK46TZvEgUNhDdEijugMlLlMgfq6mUOEA
Date:   Thu, 19 Jan 2023 22:18:50 +0000
Message-ID: <2bc438e61effb185718cf1989b64b597413628a2.camel@oracle.com>
References: <20230118224505.1964941-1-david@fromorbit.com>
         <20230118224505.1964941-7-david@fromorbit.com>
In-Reply-To: <20230118224505.1964941-7-david@fromorbit.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4306:EE_|CH0PR10MB5211:EE_
x-ms-office365-filtering-correlation-id: 2c28b266-6a8d-4429-a2f7-08dafa6b2420
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: azdLhGY8OPbK9rqIbZWJu/JvdRFpqj5VPgbM8t5cekT1CCq5kZfPT82ZzmyL58I01VnJJT2nFOIZTH4jvmdSUXsYzfj1faRe3eY8Nm4sqpgP2yrdjTOicL9M0jxCaHnJFWDwZBolEXGT08osZ8tjWh04vig0i/vvCDVjr1cwoAfoUdhcKB854Kups8Nw0yg3uvQGZUxo/BI3UMksCfIJL2nkU5pc/ygTb6QTXgciwRC1SRLdlQ9aFCqHjd85m84SdwcBfkXHDTnV/QaHB+k0gtC9rgHaPTGxmPK1juwjtQ4XHd9Vhk7ICcH38/mI5+UPTKAc1MWPO/ptV4rRF7vE7d7EQJUgkxhMwPTvnnw6Dwn5Iq/z5WOV0ADBdYcUDsCoCYYmHKe/huDl+6l4GSQXUFmASKdavl2lx0rNzjEWEG6SOuiTBa63FTRqV2IStw1VjkP6bMzfGnLrRa7SfYfhrbBJZkc3VICDmzSi9AmmwJe0apxpyyub2x+jFLtvszdKghsByePVFPR5EeL9pSJj1yEUaF/OWfDVLfBooCWlXwZKZjG0EEVMlJWbCcGKmjMDxnY6pzYa+BXvlxxyJe8+nJ8HO81Q1wb5iLIkAKlcsE1heZMxIxebzrFe0mGBo9JQsYQQo9OnYt+NBR5Wb/Q/CHx2C5yqQ89JwGKONXSe04JRFO+zP4N0hjlK4Z+tKwFjsehGi1gHqdopE0Rb+nkxRQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(396003)(376002)(39860400002)(346002)(451199015)(6512007)(478600001)(38100700002)(26005)(186003)(71200400001)(6506007)(86362001)(6486002)(122000001)(38070700005)(41300700001)(2906002)(8936002)(2616005)(44832011)(110136005)(316002)(5660300002)(8676002)(66556008)(66446008)(66476007)(66946007)(76116006)(83380400001)(64756008)(36756003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WURrTllFNlBlV0ZTaU42U29SbmxBeHJ2czk5bGdzdm1QQXdCcURlM2t2Wkk1?=
 =?utf-8?B?cU43SW9IQko5V2lDbS9jTzRBVi9aOGhjUXVEOGtVNEVkTWZyS2VsaVpUbTlq?=
 =?utf-8?B?aGtqRDJ6djRBYVZBTEJLRjI4SVh1K3lXVWN5VGpIWWZHSERYRzYxSGZHeVdq?=
 =?utf-8?B?UkY4SHp4dzNCKzliaXNnUEsxd2dmRkJXclEzbDJITnBBNUpibEl2ZFFNNGVB?=
 =?utf-8?B?RjFhVGZtWkJITUYvZVhDdVhQY1VTZzZIbit6dVE0MXMxWmVpTmdwaU9nOGFm?=
 =?utf-8?B?TU0rZUhZVjZvVjJlY3puYUFJTGdBWmJ1cGl2c3FYUDVhckVKNGlEYTRUS3ZL?=
 =?utf-8?B?cStnVDduWGFLUWMwYTFyaFl4MytKV3NsSW5vVTUvb09VU1FkQjc2ZzJMbmk1?=
 =?utf-8?B?ZDlLSzRWeHlwVFFHOVZsZUlXSmxKR3lsMWM1RVNwTlNXWVZMMmZtYllXSmZP?=
 =?utf-8?B?THpxaXA5UnBjYXVaUmdsU2NGTDNzc1RUVFJIc1hnSGpKb1ZpdHF0NUNrTFFK?=
 =?utf-8?B?aUN0ak1EREpiVjc0V1d0L1g4M0xjUTlLeHR0dWw4WlI4QnI5VEtxZTN1L0Fp?=
 =?utf-8?B?OW5pNitldjhTUlJWNU1MQ1IyUHl0REh4aFFNYndvVmpvUmdMYUVhYVBYbnlM?=
 =?utf-8?B?SjkyTUF0MndJQ2lTTXJRR3NHU0FMeHNrTXhxVWx1OGEreE51bTdVaTZxK3BI?=
 =?utf-8?B?QXA2V2txUmVBakUxOEZ2QmVmUm5tSzhiR1hJb3JOMzNJUTU1R2RrWlhkY2JO?=
 =?utf-8?B?NUFOL0FRNlQvSzJjMWVCQW1MS2JkeHJOUEF5dmRldVl2a1pxRFRoYVAzV09y?=
 =?utf-8?B?UlBKUnVoVjQ5NkVNU1BzZ1ZyTHhicXpJY2pZZkM3TDRGVWNPbFBjeUZ4NW9W?=
 =?utf-8?B?aFdwcEs1WnozQ01IdjZYMldieWl5UG1mQVZaVlBtWlBOdkFGeCtVSC9GNE1k?=
 =?utf-8?B?K1djanp6QmM1cnFzakxWRUI4OWRuaUFzb1ROZ3dvdlgyRXRqUzQ4Z1Jna3Bm?=
 =?utf-8?B?RlRuaTNHQkc1MTF2Z1ZiZDYxanhrekxLNHJHMXBjK05RMmpadlA4dGhtR1h3?=
 =?utf-8?B?c1dhT21JMWNQMTRad1pVcUpCbFNuMTV6R3VXQzREQytxRXlZOVZmeStIWE51?=
 =?utf-8?B?bjdYSm1QVFdVbXVkdks4ZFVaVFRHaWMrVG9sUDZWbGJvSVZFNkxpb3lSaklO?=
 =?utf-8?B?MnVhTUxzdzJIWXVvTXJ6R0dqemkzVDRic3lQM2xlK3FPU2dWS2tOZ3hRc085?=
 =?utf-8?B?Yjd3a3ZCU2tTRVJvenhWSEdTYW1nZUJwKy92MWZMdUdyRkF2MlFaRGNuemZ3?=
 =?utf-8?B?elVGaGFrVUcyWEd0QnZ0Q2pyRUNFZk80aXZRc0xhcVExWEhKSkVKdHNIMzVr?=
 =?utf-8?B?KzYzTUpxUnJiSjRoNjFOang4Z21pTmtwTVVzMGtOVjI0REhLVnljdElkaytQ?=
 =?utf-8?B?di9DNk5qVTlFOTk0ZnlzSkZCRHQ2N0FHTitwQWxBaFNKZjhLODV4QnEyU0Nh?=
 =?utf-8?B?a0NydE5GbjB3T2xEN0c0aCtIeGFZWHV1Z2YyV2huRWJCejBzaVhEU2Z1Vm0y?=
 =?utf-8?B?cVdtcHB5dGtJM0sreVJXQjYvNWd5RU1jK1NubU9OQkhqSWIwV2ZhTkpNeHNx?=
 =?utf-8?B?SFRuNVExbzBHTVh1UVR6TWNrZ3NJdlpqT1pNdTVvUSt3QWFBV2RWcHNtdG1F?=
 =?utf-8?B?ZUlyTW0wSVVlM2dtR2FVOFFhdXd4TzJ6VlhJSm40ZU1hNGxuY1gzYUdBdjZm?=
 =?utf-8?B?dmFsaFZYY0Vkd3VHY2piQWpQdGNsOHRkQVBUK3RTbjlnVGxzenpZeFpHaS9t?=
 =?utf-8?B?ejNlem5TUHdQaGtMTG9zSlhveDlHWHRkTnpSdERHVlNOaFVrTzZVOFJyOFBt?=
 =?utf-8?B?KzRxNFQ3Q01lQ0lEeDlkU3RaWlRnY2FGaWVRczlnbEl0N2lTUmtmdXBnTHJk?=
 =?utf-8?B?VjRNUU5iUFpUM1dJWndqZlVBcnE1MG9iVThyTXZaemdyZHFwT1p2MWtkZGpw?=
 =?utf-8?B?UHFDY1hmcVdVSGRoQllHazNoN1J6VDBKZVdJYWkxWGtkeDdPcTM5NmttQXFm?=
 =?utf-8?B?N0gwQ1M2WXVpQlRJVWtWQnZsUEVBWUttYktvUGVBblJWYXo4NHF1MjNiMGVy?=
 =?utf-8?B?cEtnSldLQWxiZHdSUCtUVmd3U3k0UjJ3R1hiK3VlSlZTUmZLYzNhM1Z2cnR4?=
 =?utf-8?Q?tAciRdJtBzUWhibw1b7P0yQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <772D7646489CB34BADB977C27D928E80@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: jUpKjwVpoOneRqc9KqpOs0q8gzqT5qdxRsSwVJAXGPBpz+qYZHka2zDhzt4NIdikixUOGFTQjYEr4QO6EJbNKZ+0DATRbMvLPlCwue6MWHjOijzWl5OdNKtcP9NA6LKodgnVqmbOVrMe5sBhrv9Qvna27IdZAmdmbOzGfRv4rqyx6m9qimrYtVMSR+wcicRoez5sj/o91WtYCNyYKueNnFPlriBgAsC3G1QCJwSOdbXlgFkDqAjZeNDHrxzgR8WK994bkyCmaso5+WoEOxcNZ7XqkTnRsdYA4GBPf3lesEeF0jb032A0JnzMo6ghnDvqbYjeSnDbWsYIhNhmzLukXNuN/tBKtyAJJe0Mjjy7D/xz87IxdMUqC+yClGWFlxVqYB9XiyF74LNUvXoMdLWOqUtMpNzG54j6df2Wv3PpEA2z63ApLlO/O8LrjpIKoHUg9/BBPdA6bUyIF5HDePwhw3vCjbyEYoKizoVpjFCGwZ4lXWwJEaTwlCNFu05tZBo4gkH7gZvb9bJ1/ny9GUtvacmsBJxdUyfqbeUf7EwuqkBhutIHH8mkepaD/6Al3hQz0jVPl9TKaW/4GIFxqQ7fcW7scmMm+rQRi41kuhCv/cZkI6nXhYkh+4hbL1Efysez5ElKw1e/S4TLUYRf5ACpkhdBnNyDmt2a8bRCV24cVYPg+xNuZYrSJ/wTxUC5RcdjFpYw6bWLIqQq4V2Q6fiNVjTcI8zVMFPDyTK2LFogLgR3KE25n5drJH0ys5yIV9T//47DCriUuflvPjcVhhvVPI9CS6Wqi5xipHA68l65wfo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c28b266-6a8d-4429-a2f7-08dafa6b2420
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2023 22:18:50.0441
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jepAhQN4OzETYLYHcyeHJ/vDAJgl8UtR6UpfHKRkQh9CBhp80Y8ssQ21mbQhstzaEpcRE/PbrT6aNqWyUO3/yA4JqxB3iivBhYmtctA54HI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5211
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-19_14,2023-01-19_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 mlxscore=0
 malwarescore=0 spamscore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301190189
X-Proofpoint-GUID: WqlEAWSGddsjTm48PVXeHDZ8nXsVBTPa
X-Proofpoint-ORIG-GUID: WqlEAWSGddsjTm48PVXeHDZ8nXsVBTPa
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

T24gVGh1LCAyMDIzLTAxLTE5IGF0IDA5OjQ0ICsxMTAwLCBEYXZlIENoaW5uZXIgd3JvdGU6DQo+
IEZyb206IERhdmUgQ2hpbm5lciA8ZGNoaW5uZXJAcmVkaGF0LmNvbT4NCj4gDQo+IFdlIGNhbiBl
cnJvciBvdXQgb2YgYW4gYWxsb2NhdGlvbiB0cmFuc2FjdGlvbiB3aGVuIHVwZGF0aW5nIEJNQlQN
Cj4gYmxvY2tzIHdoZW4gdGhpbmdzIGdvIHdyb25nLiBUaGlzIGNhbiBiZSBhIGJ0cmVlIGNvcnJ1
cHRpb24sIGFuZA0KPiB1bmV4cGVjdGVkIEVOT1NQQywgZXRjLiBJbiB0aGVzZSBjYXNlcywgd2Ug
YWxyZWFkeSBoYXZlIGRlZmVycmVkIG9wcw0KPiBxdWV1ZWQgZm9yIHRoZSBmaXJzdCBhbGxvY2F0
aW9uIHRoYXQgaGFzIGJlZW4gZG9uZSwgYW5kIHdlIGp1c3Qgd2FudA0KPiB0byBjYW5jZWwgb3V0
IHRoZSB0cmFuc2FjdGlvbiBhbmQgc2h1dCBkb3duIHRoZSBmaWxlc3lzdGVtIG9uIGVycm9yLg0K
PiANCj4gSW4gZmFjdCwgd2UgZG8ganVzdCB0aGF0IGZvciBwcm9kdWN0aW9uIHN5c3RlbXMgLSB0
aGUgYXNzZXJ0IHRoYXQgd2UNCj4gY2FuJ3QgaGF2ZSBhIHRyYW5zYWN0aW9uIHdpdGggZGVmZXIg
b3BzIGF0dGFjaGVkIHVubGVzcyB3ZSBhcmUNCj4gYWxyZWFkeSBzaHV0IGRvd24gaXMgYm9ndXMg
YW5kIGdldHMgaW4gdGhlIHdheSBvZiBkZWJ1Z2dpbmcNCj4gd2hhdGV2ZXIgaXNzdWUgaXMgYWN0
dWFsbHkgY2F1c2luZyB0aGUgdHJhbnNhY3Rpb24gdG8gYmUgY2FuY2VsbGVkLg0KPiANCj4gUmVt
b3ZlIHRoZSBhc3NlcnQgYmVjYXVzZSBpdCBpcyBjYXVzaW5nIHNwdXJpb3VzIHRlc3QgZmFpbHVy
ZXMgdG8NCj4gaGFuZyB0ZXN0IG1hY2hpbmVzLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogRGF2ZSBD
aGlubmVyIDxkY2hpbm5lckByZWRoYXQuY29tPg0KT2ssIG1ha2VzIHNlbnNlDQpSZXZpZXdlZC1i
eTogQWxsaXNvbiBIZW5kZXJzb24gPGFsbGlzb24uaGVuZGVyc29uQG9yYWNsZS5jb20+DQoNCj4g
LS0tDQo+IMKgZnMveGZzL3hmc190cmFucy5jIHwgNCArKy0tDQo+IMKgMSBmaWxlIGNoYW5nZWQs
IDIgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9mcy94
ZnMveGZzX3RyYW5zLmMgYi9mcy94ZnMveGZzX3RyYW5zLmMNCj4gaW5kZXggNTNhYjU0NGU0YzJj
Li44YWZjMGMwODA4NjEgMTAwNjQ0DQo+IC0tLSBhL2ZzL3hmcy94ZnNfdHJhbnMuYw0KPiArKysg
Yi9mcy94ZnMveGZzX3RyYW5zLmMNCj4gQEAgLTEwNzgsMTAgKzEwNzgsMTAgQEAgeGZzX3RyYW5z
X2NhbmNlbCgNCj4gwqDCoMKgwqDCoMKgwqDCoC8qDQo+IMKgwqDCoMKgwqDCoMKgwqAgKiBJdCdz
IG5ldmVyIHZhbGlkIHRvIGNhbmNlbCBhIHRyYW5zYWN0aW9uIHdpdGggZGVmZXJyZWQgb3BzDQo+
IGF0dGFjaGVkLA0KPiDCoMKgwqDCoMKgwqDCoMKgICogYmVjYXVzZSB0aGUgdHJhbnNhY3Rpb24g
aXMgZWZmZWN0aXZlbHkgZGlydHkuwqAgQ29tcGxhaW4NCj4gYWJvdXQgdGhpcw0KPiAtwqDCoMKg
wqDCoMKgwqAgKiBsb3VkbHkgYmVmb3JlIGZyZWVpbmcgdGhlIGluLW1lbW9yeSBkZWZlciBpdGVt
cy4NCj4gK8KgwqDCoMKgwqDCoMKgICogbG91ZGx5IGJlZm9yZSBmcmVlaW5nIHRoZSBpbi1tZW1v
cnkgZGVmZXIgaXRlbXMgYW5kDQo+IHNodXR0aW5nIGRvd24gdGhlDQo+ICvCoMKgwqDCoMKgwqDC
oCAqIGZpbGVzeXN0ZW0uDQo+IMKgwqDCoMKgwqDCoMKgwqAgKi8NCj4gwqDCoMKgwqDCoMKgwqDC
oGlmICghbGlzdF9lbXB0eSgmdHAtPnRfZGZvcHMpKSB7DQo+IC3CoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqBBU1NFUlQoeGZzX2lzX3NodXRkb3duKG1wKSB8fCBsaXN0X2VtcHR5KCZ0cC0N
Cj4gPnRfZGZvcHMpKTsNCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBBU1NFUlQo
dHAtPnRfZmxhZ3MgJiBYRlNfVFJBTlNfUEVSTV9MT0dfUkVTKTsNCj4gwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqBkaXJ0eSA9IHRydWU7DQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgeGZzX2RlZmVyX2NhbmNlbCh0cCk7DQoNCg==
