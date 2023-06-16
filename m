Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD03AEB64D9
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Jun 2023 00:42:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbjFPAmS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Jun 2023 20:42:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjFPAmR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Jun 2023 20:42:17 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 933651BD4
        for <linux-xfs@vger.kernel.org>; Thu, 15 Jun 2023 17:42:16 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35FGJCPX027548;
        Fri, 16 Jun 2023 00:42:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=DTFtJmQu2WYPN0nbDXVnzp9vZVs+tAcyrb7Thn3jCiA=;
 b=b5cnDR00LwTluEZizKnsH0d+yvlok9jIa7V5BZdUTO8yIMxcmTuNt9Gy25SESEldEond
 MX+0pP2tDKwxKqXdCken0QYwA725F9/V4Xm664KFlECVWQenQKrAUuIhymrmezksXeeq
 1kUmJe/hEwWqhDBPpl7sILJkQs8FG0mMuuJUP0JZQ9+bgZy/YyiWM4GFZKM5kFYaMnpF
 QfZWSS6q48uIQmZBnVUpNGzO/KVPZIc62pwd7xzBLa0CC6NaCfeT2cWgDgTX87Ow7LiZ
 CL7f9Ent51SDyr1EsbMS420tP1b1wdxHmx2bxLnXFvtX7fANfM/7/w/1hhCbHQk1OI45 Pg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4fy3k735-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Jun 2023 00:42:14 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35FM4QsX038878;
        Fri, 16 Jun 2023 00:42:13 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm7by59-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Jun 2023 00:42:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FBPXDuV/kC6QDWPVGDeBoc7YyPmwsw394EfdtysPsItMHF7b5EYK+1HgQyB2LpDXqX7pAOcdUj9EYlMBYB73Xc1QhlIkC3epnJlV7PXGATdvDeJjamBvIIERzSHWLrVycfZw86b7fFghjpmilVtJhVHTWc9/Q++KYcRbYqWAjdnVkcnHsLkwq+CMdbkCEAtcMOuU8PZEzhAsIRIzwMv8DNKUUKZpHjT9GPprENF6yXultdJbVZHUMwmGxdwaU/jh7RLhJGwdwidLJz4ja4DIrh/nRmdijE1iT8+UWaFtSgnLwV0B5USGargORElHIuxRVjd4hSqf3q2K9yfhGj5j+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DTFtJmQu2WYPN0nbDXVnzp9vZVs+tAcyrb7Thn3jCiA=;
 b=X6JJ3q8tgUI1MrWsoyQq7YltSBrBxx7/Ns5+YOKDPIpvsT5Wg80cxkiSPl+Ts7skW9sqbuWa9jAIjclgbV/V9R/EoRutRENtoU6z58y0PIN2wS1OoozAkOMVFPIN1SVgQ4gnM7EfO8NCPnwCXGRkkcuhtgEprgDR94VjwVIkKOLNZAI+uzat2gP+Z2GcEs60DwVycbcVk19YUI+RCYRs056/Ly4vDVHBa50Y8KwAX3YWyIkIsNTkBZS7f20yyW2H3Dvl29Ru3bMufTyNgUmCNZx5S4ySMqUtAlPUw411iTK0w+Qsj7jVjKwc83XtQa2Lbkd5xgtZszKv1xSjjrIvmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DTFtJmQu2WYPN0nbDXVnzp9vZVs+tAcyrb7Thn3jCiA=;
 b=y63Rv69LDBIk2mps+ls1QB3rfOWqBrxPEhovI87iyspi8GnWJGW5Ph0fJbvSs8ypRLh5eqLATz9TTcWegu0E4hAyNmun0/11ci0NeLOCPK28VCTaO8h/S4VdjXmG/VtWJWoqSKwc+/JijGZHMgBYRmINgCTxzXn/1O5ms6aSm7g=
Received: from SN6PR10MB2701.namprd10.prod.outlook.com (2603:10b6:805:45::20)
 by MW4PR10MB6653.namprd10.prod.outlook.com (2603:10b6:303:22e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.28; Fri, 16 Jun
 2023 00:42:11 +0000
Received: from SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::5f1f:6ddb:112:a1a1]) by SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::5f1f:6ddb:112:a1a1%7]) with mapi id 15.20.6500.029; Fri, 16 Jun 2023
 00:42:11 +0000
From:   Wengang Wang <wen.gang.wang@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "chandanrlinux@gmail.com" <chandanrlinux@gmail.com>
Subject: Re: [PATCH 1/3] xfs: pass alloc flags through to
 xfs_extent_busy_flush()
Thread-Topic: [PATCH 1/3] xfs: pass alloc flags through to
 xfs_extent_busy_flush()
Thread-Index: AQHZnyqiJVfvBqN/ZEat6GgWNoCKPa+MalAAgAAE8YCAAASYgIAACrOAgAAGmoCAAAT8gIAAB3wAgAAGxIA=
Date:   Fri, 16 Jun 2023 00:42:11 +0000
Message-ID: <903FC127-8564-4F12-86E8-0FF5A5A87E2E@oracle.com>
References: <20230615014201.3171380-1-david@fromorbit.com>
 <20230615014201.3171380-2-david@fromorbit.com>
 <25F855D8-F944-45D0-9BB2-3E475A301EDB@oracle.com>
 <ZIuNV8UqlOFmUmOY@dread.disaster.area>
 <3EEEEF48-A255-459E-99A9-5C92344B4B7A@oracle.com>
 <8E15D551-C11A-4A0F-86F0-21EA6447CBF5@oracle.com>
 <ZIuftY4gKcjygvYv@dread.disaster.area>
 <396ACF78-518E-432A-9016-B2EAFD800B7C@oracle.com>
 <ZIuqKv58eTQL/Iij@dread.disaster.area>
In-Reply-To: <ZIuqKv58eTQL/Iij@dread.disaster.area>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2701:EE_|MW4PR10MB6653:EE_
x-ms-office365-filtering-correlation-id: cbd56462-2d4f-41eb-b615-08db6e0285a1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QMxWBVQJYSVQfybLzGjSBU4xoFmEI97EGlSTJXvj6+k1pBE7zR9ypgdp006RVMSfP3G58m06eaIVImsj0VhSCISW6kHAszlZ1goTx/0v4RKwhQN35wBKLOy4HzNTfw/PXRg+GqHnWJxY3437/l3cU3Dg9Bd6GwEvV5Yyus0nOfcZPeYGutI669JKs7B6lBAX3wSSCtgEPGWkzyaUBe856WjG56nGEQZz9JTX6IrR9TyMpzpscgyti9T1ecwq9WZ512rTwyfPyKFFUgs4vB2bZ/JMr4sVTd5+T/A2sjw7lLEFZ4a4U7HaSR5H9pY7UAqNp0cxhx/1msMWtqZmx1hMZDPqJdgMbuyvkvFLql3XYOWvLvhSZufmijlLtPWpvixWV8xOjYrz2zHkbhJvAdkobMId8kkiiv3E8Zf1P0ZI31qLKDdYzxOgPAf98glLfHOvqEnlUyP4dYUFh/lvSxZAm0S6nK86SIllU3+QxjUtmJSuuqBzT0VzSDLxK3sI9xEk7RJDC2cd9ozNDkFUoELNIi8YmetQ6YNaSELQd0PfY8Gm5Ys7iEOc6hmmenr1/Gp/DYyQfhoyFsS6hf/r5a/UtawJp6ZrURmwuyni9mE03k1ePkZxJeVdII9nEz8oDagNXVQi03h2p7Labh2sNk0t3g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2701.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(346002)(136003)(376002)(39860400002)(451199021)(8936002)(316002)(2906002)(66556008)(76116006)(66946007)(8676002)(64756008)(66446008)(966005)(5660300002)(54906003)(71200400001)(41300700001)(26005)(6512007)(186003)(6506007)(6916009)(36756003)(2616005)(4326008)(6486002)(53546011)(66476007)(83380400001)(478600001)(122000001)(38070700005)(33656002)(38100700002)(86362001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RlZZemp6N3AyZ2lYWVRFcm5McFFLeHZxbWZrb3dJak1OUC9TeTNFYVFHclh1?=
 =?utf-8?B?bUV2a1J5MHhodjA5a0lrTlV0K0w3anZ6MFdxbGtmRXZBQ0hFSExmdldOcS80?=
 =?utf-8?B?cHdvbkV6OHJjWU5GRmpuWEJHUzJlVDhSV2MwNmZqSUJqcGZqbGkzZXhmL2tk?=
 =?utf-8?B?bEVyOVEzSjFlRys1eVBaYVMxM3djSXZsblg1VTBkVS9JRVQ4VEs2MXdZbUNn?=
 =?utf-8?B?ejBZVXNaT0NleU92STNHRitVOVBIdmdxb25WOTk0Qld5czBydVhPemNtdXRI?=
 =?utf-8?B?UVNWa1ptWVhLOHdNZ3c4UWpraCt0UHAvZGtuRFJEb3ZLZDFTU3JMZFVWNi80?=
 =?utf-8?B?Tk0vUzhIQThQRVNkMC8wZERHL2VVWUZNRUdOYXZkZGl3N3JTSlUxUVQvSkxS?=
 =?utf-8?B?YjIraWdIekpaZ1lFVDRkWkUxazVsNWpjbXl1WkFGNktJbk9FQzAvckhLWmRL?=
 =?utf-8?B?NU9iOEdjT05VQm4xaytrQ01PejZEdTd2NFJNQWVZelVSRGhhd2kvRDUyeStG?=
 =?utf-8?B?dENLcW54a2ZtRjVCN21BUkJJYkVxeFp5a25SVHZKc1dTTGNTdVluKzVBc0Jz?=
 =?utf-8?B?RXR1N0wwRWVWZWY3L09DVlJVSm0wcnMrZUx3L1d5TG14alJHRmdWNUdQRW5r?=
 =?utf-8?B?dUhiMXZhd245cHY2aU50QVY4V1RaNzRkVyt3T3k2MWIyNnZHMkhmNlREK3Ns?=
 =?utf-8?B?SzByZldQTTN6UURkcmRTc0ptVW1XRDRvRGxrZWJTNXZDazRuNW9RY3ovQUMv?=
 =?utf-8?B?Tmt3UW5XYXU3VEpKTE5INXMyRHAveXZXNkU1QjVJZ01RZjJaSDNXeU1BV0Vw?=
 =?utf-8?B?bktlZkhFc2lzRmU2R0NKRnczYmNhaWhSL3VjdDd5eTVaMDhGdnFuSkx2cTcv?=
 =?utf-8?B?bDhPWmhRVEhKYmFsNnNITHN4bE1NbVowWTF5Y3QyLzdGalpQSDRGSnFkY3p2?=
 =?utf-8?B?TWVkOStjRXRPeUlabVB4YVMxVHNjcmEvWmh4VEVBenMrMmlaMVZOeHdCa3U3?=
 =?utf-8?B?S2FXdmtIVEtEeHBYcE8xc0JZeHkwd3NYWnlwS3RWRXVZNlRZUnkva3lZRGMy?=
 =?utf-8?B?dmRaaVY0N1NYQjZpOFlxR0J2anJ3YjBKTHFxVE1XZVROcnZFVVNEVVVBUlRq?=
 =?utf-8?B?Mnp2ek9kZDV3dFhsMDN6TWp1QXR0QWd6cWRnNXE5dkpHeHQ5TDdWRGh6RlJ4?=
 =?utf-8?B?OHJJcTdVTFBkTTZuclFGa2Q4OVdMOVczb1pHR1dmNTNwRlFsNkdDdjFLdXVV?=
 =?utf-8?B?Z25uOGYyTW1wK2FrK05GNGxnMlNLOGtpdFo0TlhVUUhveHg1TThReHl2d2JO?=
 =?utf-8?B?RFRQaXR3RVppVVhISU5STEFyclZhSXlTV241SVJxblhmZzAyUjRJK0pJOUVS?=
 =?utf-8?B?ZXdWMTM3bldhR25tcFYxbDNONU9HOGJZb3ozMUllRlAzSWRFUGhMY3k1Q3NB?=
 =?utf-8?B?dWhHdjNTOVh4c1FXekpER01XNG5oUncrSlUrQzBJSk96cG1IUzJlSDFTTUJY?=
 =?utf-8?B?YkwxYnpndzg3ZnRjYTUvNml2SjhHbWdKUlRIYVIrVkE1M2szTHhZY0U0ZVdX?=
 =?utf-8?B?UlI0UTlLSkdhV2EyZUFiWlMydUswQWo1ckRWQlliZFZlT24yVlU4NU5uWnIx?=
 =?utf-8?B?d3ZINzRISDNmcEp2NWp5LzBESi9XcWZremlGMXU4VXdPMEN3emZCcUlDUW1H?=
 =?utf-8?B?MkxHeEZMQmJGMjRRckN6bHZjRTRTWXpFZDEwSlJrSDZjL1lNdUR3Z2dyM3Vl?=
 =?utf-8?B?OGQ4a1BndUN3VWMzcjJ5Z2M3dk04VnF5N3BZVUY1RC9CL0wybkluYVo2Y3Bz?=
 =?utf-8?B?K3lYVVIyd0tmOHRQRk1qYkRQMXFzbkxGRTI1TGQwbnpUZGNSRzFMRk9lNE5q?=
 =?utf-8?B?VEhCeERmbzlxemNkMFBoOHFHa3J1Vm5lTlZKVmJ3a2pVRkFRaG1UNG96N0NI?=
 =?utf-8?B?RUlscVp0TEVTdkZsY2NJQUVRTnJYQ01QcDBSS1VmT1N5dlpoV0V2MnlPSWYz?=
 =?utf-8?B?MTVQMmcvQ2pHdzlPcldkdWJrVisrbjR0Y1BWOC9OUWNPZldZRVdYUVdJaFB3?=
 =?utf-8?B?MkxzNGJNdlg5eFNkNHJpQVVJcjIxV3hCVm0rWXJSQkdmdmZuQytnVTh4V2Ex?=
 =?utf-8?B?UTN3RXhtUTJuSE5IUERJakExTVVETkJYSXhLQnhxTjQ2VWo2M3VDWEdKNlV4?=
 =?utf-8?B?dmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E0DE16E7CCFC8B489E630014B1752264@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 9rdpGbsNTLjYriqkPLrET+w2OR8tIlx6UT2YnqLisNFqAIQHw8Ks1QHt8/yEMq4XqkY72VGFBkHsBWu+Va6/TADw3O/87eafARuQg7KHhckOkPspQQv7f+ZMJgpcYKsbOfG9S+b2gTkcQnpXrQp6JXvIgY31psHbiglhjoquHhRvua32QrvKpTNNN7U6h17UpsNyNueDnyJdbYYNgGfVn3ajaeDAE66EE+6ZKodHyXEflCEdjeqfGXsvPiVnvscmLxA15XoTA+n9vI1KjZIjjmdffrMP89Pk0YLrPKNgVLcyb7I0282LJuPHvV3o98wtns1R9MFxmYtdfRilSWByOPoOYVgHFhRF/6HND0fp2OfrUKsQjmXm2/11zPMHyU/3AFXKtbnNMM3PyuqfBKr9DaiorVznPLqBZq0AFIX+zutPA4fBN2c9OnbMHbe4AcHe5T3dyf0wn7sj8J3azQ4L1EfRyoDekf6gWEd5VRRFOqenv60yQdQbiZDFH9Oqb2jWoDrjA8jupLrx3AIFMOqQH7GToEtQQFDZS7KllSdgpBVtwsf0gh+p12juece4f7WoNyoesSaEKprZtGrB/quqktuwvrU8cVs2JinsMMkJNwoJ6mYOh4KrBc9c3g9Blxwe3gMQVpeGp7KuOi1/9E1PWyT5aeUefB0+xNtZ1JsXMbZyTzlbF1cyrtQnuIGfprLJ2c70Hb1fpmPQd4Eyp7CVnqqIEV8Z6JbuKm8zhEdxJ0k7KYrCgMcjf85fZ6JDFKBRHZAZayL7NWHxqPAnkef6XGE2fP1bI5wdC6RFPW6+l13Ri6mW6OgQPwkXBFfxMoRHEGVZdgIuTkY+PSRd0YHozA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbd56462-2d4f-41eb-b615-08db6e0285a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2023 00:42:11.3642
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O+aGU3kL7uJ4aPI3UAcQBBgH+fOpQbkiasnAWEAOoOU1sJaXXeKJxeFgsA+InH34zrW6mRU5jUakpl0LUPM9VLyiS0Ps1iaHieeF2lUzjt8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6653
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-15_17,2023-06-15_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxscore=0 adultscore=0 spamscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306160003
X-Proofpoint-GUID: A0l10iejjShsIWer2B-S57sm0DUSYaNs
X-Proofpoint-ORIG-GUID: A0l10iejjShsIWer2B-S57sm0DUSYaNs
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

DQoNCj4gT24gSnVuIDE1LCAyMDIzLCBhdCA1OjE3IFBNLCBEYXZlIENoaW5uZXIgPGRhdmlkQGZy
b21vcmJpdC5jb20+IHdyb3RlOg0KPiANCj4gT24gVGh1LCBKdW4gMTUsIDIwMjMgYXQgMTE6NTE6
MDlQTSArMDAwMCwgV2VuZ2FuZyBXYW5nIHdyb3RlOg0KPj4gDQo+PiANCj4+PiBPbiBKdW4gMTUs
IDIwMjMsIGF0IDQ6MzMgUE0sIERhdmUgQ2hpbm5lciA8ZGF2aWRAZnJvbW9yYml0LmNvbT4gd3Jv
dGU6DQo+Pj4gDQo+Pj4gT24gVGh1LCBKdW4gMTUsIDIwMjMgYXQgMTE6MDk6NDFQTSArMDAwMCwg
V2VuZ2FuZyBXYW5nIHdyb3RlOg0KPj4+PiBXaGVuIG1vdW50aW5nIHRoZSBwcm9ibGVtYXRpYyBt
ZXRhZHVtcCB3aXRoIHRoZSBwYXRjaGVzLCBJIHNlZSB0aGUgZm9sbG93aW5nIHJlcG9ydGVkLg0K
Pj4+PiANCj4+Pj4gRm9yIG1vcmUgaW5mb3JtYXRpb24gYWJvdXQgdHJvdWJsZXNob290aW5nIHlv
dXIgaW5zdGFuY2UgdXNpbmcgYSBjb25zb2xlIGNvbm5lY3Rpb24sIHNlZSB0aGUgZG9jdW1lbnRh
dGlvbjogaHR0cHM6Ly9kb2NzLmNsb3VkLm9yYWNsZS5jb20vZW4tdXMvaWFhcy9Db250ZW50L0Nv
bXB1dGUvUmVmZXJlbmNlcy9zZXJpYWxjb25zb2xlLmh0bSNmb3VyDQo+Pj4+ID09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0NCj4+Pj4gWyAgIDY3LjIxMjQ5
Nl0gbG9vcDogbW9kdWxlIGxvYWRlZA0KPj4+PiBbICAgNjcuMjE0NzMyXSBsb29wMDogZGV0ZWN0
ZWQgY2FwYWNpdHkgY2hhbmdlIGZyb20gMCB0byA2MjkxMzc0MDgNCj4+Pj4gWyAgIDY3LjI0NzU0
Ml0gWEZTIChsb29wMCk6IERlcHJlY2F0ZWQgVjQgZm9ybWF0IChjcmM9MCkgd2lsbCBub3QgYmUg
c3VwcG9ydGVkIGFmdGVyIFNlcHRlbWJlciAyMDMwLg0KPj4+PiBbICAgNjcuMjQ5MjU3XSBYRlMg
KGxvb3AwKTogTW91bnRpbmcgVjQgRmlsZXN5c3RlbSBhZjc1NWE5OC01ZjYyLTQyMWQtYWE4MS0y
ZGI3YmZmZDJjNDANCj4+Pj4gWyAgIDcyLjI0MTU0Nl0gWEZTIChsb29wMCk6IFN0YXJ0aW5nIHJl
Y292ZXJ5IChsb2dkZXY6IGludGVybmFsKQ0KPj4+PiBbICAgOTIuMjE4MjU2XSBYRlMgKGxvb3Aw
KTogSW50ZXJuYWwgZXJyb3IgbHRibm8gKyBsdGxlbiA+IGJubyBhdCBsaW5lIDE5NTcgb2YgZmls
ZSBmcy94ZnMvbGlieGZzL3hmc19hbGxvYy5jLiAgQ2FsbGVyIHhmc19mcmVlX2FnX2V4dGVudCsw
eDNmNi8weDg3MCBbeGZzXQ0KPj4+PiBbICAgOTIuMjQ5ODAyXSBDUFU6IDEgUElEOiA0MjAxIENv
bW06IG1vdW50IE5vdCB0YWludGVkIDYuNC4wLXJjNiAjOA0KPj4+IA0KPj4+IFdoYXQgaXMgdGhl
IHRlc3QgeW91IGFyZSBydW5uaW5nPyBQbGVhc2UgZGVzY3JpYmUgaG93IHlvdSByZXByb2R1Y2Vk
DQo+Pj4gdGhpcyBmYWlsdXJlIC0gYSByZXByb2R1Y2VyIHNjcmlwdCB3b3VsZCBiZSB0aGUgYmVz
dCB0aGluZyBoZXJlLg0KPj4gDQo+PiBJIHdhcyBtb3VudGluZyBhIChjb3B5IG9mKSBWNCBtZXRh
ZHVtcCBmcm9tIGN1c3RvbWVyLg0KPiANCj4gSXMgdGhlIG1ldGFkdW1wIG9iZnVzY2F0ZWQ/IENh
biBJIGdldCBhIGNvcHkgb2YgaXQgdmlhIGEgcHJpdmF0ZSwNCj4gc2VjdXJlIGNoYW5uZWw/DQoN
CkkgYW0gT0sgdG8gZ2l2ZSB5b3UgYSBjb3B5IGFmdGVyIEkgZ2V0IGFwcHJvdmVtZW50IGZvciB0
aGF0Lg0KDQo+IA0KPj4+IERvZXMgdGhlIHRlc3QgZmFpbCBvbiBhIHY1IGZpbGVzeXRzZW0/DQo+
PiANCj4+IE4vQS4NCj4+IA0KPj4+IA0KPj4+PiBJIHRoaW5rIHRoYXTigJlzIGJlY2F1c2UgdGhh
dCB0aGUgc2FtZSBFRkkgcmVjb3JkIHdhcyBnb2luZyB0byBiZSBmcmVlZCBhZ2Fpbg0KPj4+PiBi
eSB4ZnNfZXh0ZW50X2ZyZWVfZmluaXNoX2l0ZW0oKSBhZnRlciBpdCBhbHJlYWR5IGdvdCBmcmVl
ZCBieSB4ZnNfZWZpX2l0ZW1fcmVjb3ZlcigpLg0KPiANCj4gSG93IGlzIHRoaXMgaGFwcGVuaW5n
PyBXaGVyZSAoYW5kIHdoeSkgYXJlIHdlIGRlZmVyaW5nIGFuIGV4dGVudCB3ZQ0KPiBoYXZlIHN1
Y2Nlc3NmdWxseSBmcmVlZCBpbnRvIGEgbmV3IHhlZmkgdGhhdCB3ZSBjcmVhdGUgYSBuZXcgaW50
ZW50DQo+IGZvciBhbmQgdGhlbiBkZWZlcj8NCj4gDQo+IENhbiB5b3UgcG9zdCB0aGUgZGVidWcg
b3V0cHV0IGFuZCBhbmFseXNpcyB0aGF0IGxlYWQgeW91IHRvIHRoaXMNCj4gb2JzZXJ2YXRpb24/
IEkgY2VydGFpbmx5IGNhbid0IHNlZSBob3cgdGhpcyBjYW4gaGFwcGVuIGZyb20gbG9va2luZw0K
PiBhdCB0aGUgY29kZQ0KPiANCj4+Pj4gSSB3YXMgdHJ5aW5nIHRvIGZpeCBhYm92ZSBpc3N1ZSBp
biBteSBwcmV2aW91cyBwYXRjaCBieSBjaGVja2luZyB0aGUgaW50ZW50DQo+Pj4+IGxvZyBpdGVt
4oCZcyBsc24gYW5kIGF2b2lkIHJ1bm5pbmcgaW9wX3JlY292ZXIoKSBpbiB4bG9nX3JlY292ZXJf
cHJvY2Vzc19pbnRlbnRzKCkuDQo+Pj4+IA0KPj4+PiBOb3cgSSBhbSB0aGlua2luZyBpZiB3ZSBj
YW4gcGFzcyBhIGZsYWcsIHNheSBYRlNfRUZJX1BST0NFU1NFRCwgZnJvbQ0KPj4+PiB4ZnNfZWZp
X2l0ZW1fcmVjb3ZlcigpIGFmdGVyIGl0IHByb2Nlc3NlZCB0aGF0IHJlY29yZCB0byB0aGUgeGZz
X2VmaV9sb2dfaXRlbQ0KPj4+PiBtZW1vcnkgc3RydWN0dXJlIHNvbWVob3cuIEluIHhmc19leHRl
bnRfZnJlZV9maW5pc2hfaXRlbSgpLCB3ZSBza2lwIHRvIHByb2Nlc3MNCj4+Pj4gdGhhdCB4ZnNf
ZWZpX2xvZ19pdGVtIG9uIHNlZWluZyBYRlNfRUZJX1BST0NFU1NFRCBhbmQgcmV0dXJuIE9LLiBC
eSB0aGF0DQo+Pj4+IHdlIGNhbiBhdm9pZCB0aGUgZG91YmxlIGZyZWUuDQo+Pj4gDQo+Pj4gSSdt
IG5vdCByZWFsbHkgaW50ZXJlc3RlZCBpbiBzcGVjdWxhdGlvbiBvZiB0aGUgY2F1c2Ugb3IgdGhl
IGZpeCBhdA0KPj4+IHRoaXMgcG9pbnQuIEkgd2FudCB0byBrbm93IGhvdyB0aGUgcHJvYmxlbSBp
cyB0cmlnZ2VyZWQgc28gSSBjYW4NCj4+PiB3b3JrIG91dCBleGFjdGx5IHdoYXQgY2F1c2VkIGl0
LCBhbG9uZyB3aXRoIHdoeSB3ZSBkb24ndCBoYXZlDQo+Pj4gY292ZXJhZ2Ugb2YgdGhpcyBzcGVj
aWZpYyBmYWlsdXJlIGNhc2UgaW4gZnN0ZXN0cyBhbHJlYWR5Lg0KPj4+IA0KPj4gDQo+PiBJIGdl
dCB0byBrbm93IHRoZSBjYXVzZSBieSBhZGRpbmcgYWRkaXRpb25hbCBkZWJ1ZyBsb2cgYWxvbmcg
d2l0aA0KPj4gbXkgcHJldmlvdXMgcGF0Y2guDQo+IA0KPiBDYW4geW91IHBsZWFzZSBwb3N0IHRo
YXQgZGVidWcgYW5kIGFuYWx5c2lzLCByYXRoZXIgdGhhbiBqdXN0IGENCj4gc3RhY2sgdHJhY2Ug
dGhhdCBpcyBjb21wbGV0ZWx5IGxhY2tpbmcgaW4gY29udGV4dD8gTm90aGluZyBjYW4gYmUNCj4g
aW5mZXJyZWQgZnJvbSBhIHN0YWNrIHRyYWNlLCBhbmQgd2hhdCB5b3UgYXJlIHNheWluZyBpcyBv
Y2N1cnJpbmcNCj4gZG9lcyBub3QgbWF0Y2ggd2hhdCB0aGUgY29kZSBzaG91bGQgYWN0dWFsbHkg
YmUgZG9pbmcuIFNvIEkgbmVlZCB0bw0KPiBhY3R1YWxseSBsb29rIGF0IHdoYXQgaXMgaGFwcGVu
aW5nIGluIGRldGFpbCB0byB3b3JrIG91dCB3aGVyZSB0aGlzDQo+IG1pc21hdGNoIGlzIGNvbWlu
ZyBmcm9tLi4uLg0KDQpUaGUgZGVidWcgcGF0Y2ggd2FzIGJhc2VkIG9uIG15IHByZXZpb3VzIHBh
dGNoLCBJIHdpbGwgcmV3b3JrIHRoZSBkZWJ1ZyBwYXRjaA0KYmFzaW5nIG9uIHlvdXJzLiBJIHdp
bGwgc2hhcmUgeW91IHRoZSBkZWJ1ZyBwYXRjaCwgb3V0cHV0IGFuZCBteSBhbmFseXNpcyBsYXRl
ci4gDQoNCnRoYW5rcywNCndlbmdhbmc=
