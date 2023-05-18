Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F817C77B7A
	for <linux-xfs@archiver.kernel.org>; Thu, 18 May 2023 00:12:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbjERAMf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 17 May 2023 20:12:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjERAMe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 May 2023 20:12:34 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DBA65246
        for <linux-xfs@vger.kernel.org>; Wed, 17 May 2023 17:11:56 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34HIGiqG002897;
        Thu, 18 May 2023 00:10:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=1ZpS+N2FsBjNNbos9fOmOJVCgp3OIeLfjhtQ/GUt0vg=;
 b=aynSee14R29QM6N2Psez5QEbyT6NQK4f2Nzi4TD3VhrLGC0u3uoGKmJ9Jh6BcgDvtVsU
 jtdxgxRJz7UflrjeNqvTNH6hMN8ya4LruUfgebOUbAhii56PJr42cylwLhkrREXTDLrI
 uwWBFHcIiH2dkBRMbLO6OtlD1Z8AVLSAzVeNulEXz6PNcN0nXnRIcVx+31KBLBqHIaUo
 7Bj1bWeKug/hGfQApad6Yevy+e/51zMyNt0//zjDXBKuAkUMDbTE5PZwTtO0fxTl4g+i
 ybSQHCJBu6Ux83J+bh2Ryu/rW9CBqrVukMRB5TZ9rtPZ363XixjzWXeppyzETVmt6tgi qA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qj1fc747u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 May 2023 00:10:57 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34HNJ1Hn033862;
        Thu, 18 May 2023 00:10:56 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qj106kdk6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 May 2023 00:10:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iBOqwf6SJSrTRuebfbWs8/e2bBN+u2/CaA6k3cY+XAbBlsj5VlRZX/A6TdX9FRxh0iLYrmmvaYCC0CrFs/g+zizoifGDs2HcQhNkHnDRy6K9kTUe7N2qoV+12geaF255/yvKsnm6NJSo8ZQxEBFWGqzb5PpiichX+FCEHASIMwg7DwgL3KrRg1tNoXv1BG7qmtaoLLQFweDd9IbpIW1liMK28AfucF/V3Zo5j0jHb0IvPN6myezsHAMm8934GBYte35W5cL+pfmIyI0Tndx5xcQ8veTJl4JkWCeli7xwJxhTyk/bo7NgtyGTDBNZQcaVfVwg2vY7yqVY/QKxOUsWCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1ZpS+N2FsBjNNbos9fOmOJVCgp3OIeLfjhtQ/GUt0vg=;
 b=ELHQ2crnkuThE019+fQ8Zx8zHOQq96RE1OMPu3bdkiUVBXnm37PhrHkbcw/8TGuUK40RKPOBgRQW21fg6TAkzCrIMa1P1v1zn7w3+oBNUeJKD2mu5zOPjW8z76WzzJaZmlQ2wwk5C7wOk30SZGl75+/P8yYVx8PFLEq91qzjGkVkCQn/dewQCW6SBBCggExczKKsItOdl/VlBgyb1SO6VVP2l9vHfYS0vy4+Wact7K0kBQqAc1fcD4r9iz04BsaqoTim5RToSNVClG9AJAnGLeGlJAm+08TgB393h8SliENSKM/uc+AaM31NxOptNSM68LZIPFOIDJMnezL4TxJ5YQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ZpS+N2FsBjNNbos9fOmOJVCgp3OIeLfjhtQ/GUt0vg=;
 b=MhqLg0xhD1BYU1PQCtn0oELRAMgwQKKygCOiYnkltaFW96rc7+8albZY0yIHgByNGxrv3Fv/gqNzVzWCwntQFrBSDNSBNbEWLqAcH1ufxaukKn7ZM2emR8u7Gx4fhSB8u/pHKfWN6fEac0j+SVCFp364uWyzchyw9HX9AIhrSpA=
Received: from SN6PR10MB2701.namprd10.prod.outlook.com (2603:10b6:805:45::20)
 by DM6PR10MB4249.namprd10.prod.outlook.com (2603:10b6:5:221::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.33; Thu, 18 May
 2023 00:10:54 +0000
Received: from SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::58cd:8b89:f285:ca2b]) by SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::58cd:8b89:f285:ca2b%7]) with mapi id 15.20.6387.035; Thu, 18 May 2023
 00:10:53 +0000
From:   Wengang Wang <wen.gang.wang@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
CC:     "Darrick J. Wong" <djwong@kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: avoid freeing multiple extents from same AG in
 pending transactions
Thread-Topic: [PATCH] xfs: avoid freeing multiple extents from same AG in
 pending transactions
Thread-Index: AQHZdv9AR28b2kBDxE2gDgdaeEYEXK9XEBuAgAAZP4CAABXWAIAAEsyAgAXgZgCAAJU2gIAAC2uAgAEmj4CAADwYAIAAFrUA
Date:   Thu, 18 May 2023 00:10:53 +0000
Message-ID: <51550386-87D3-4143-9649-04E69CC178F8@oracle.com>
References: <20230424225102.23402-1-wen.gang.wang@oracle.com>
 <20230512182455.GJ858799@frogsfrogsfrogs>
 <592C0DE1-F4F5-4C9A-8799-E9E81524CDC0@oracle.com>
 <20230512211326.GK858799@frogsfrogsfrogs>
 <050A91C4-54EC-4EB8-A701-7C9F640B7ADB@oracle.com>
 <11835435-29A1-4F34-9CE5-C9ED84567E98@oracle.com>
 <20230517005913.GM858799@frogsfrogsfrogs>
 <ZGQwdes/DQPXRJgj@dread.disaster.area>
 <94FD314F-7819-4187-AC42-F984AF42C662@oracle.com>
 <ZGVZ9o1LIkZ5NPAo@dread.disaster.area>
In-Reply-To: <ZGVZ9o1LIkZ5NPAo@dread.disaster.area>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2701:EE_|DM6PR10MB4249:EE_
x-ms-office365-filtering-correlation-id: 658f7a23-9394-4ff9-ed52-08db5734587e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uR4sweSiUPYomxiMC2JBn91OAHMFNmer+t7a+RMuoSEm0Z9Q6kOon2RwQIBRh8aICKl2E1RBVPU6VW9+DMDhwLzcdpGLu4OOYBcW6GScShXV5MILAdIajNEdVuY9Xi3WobuA7aS5s6Of1+qaFlXp1OpiYqsU8/cNXJsHtCvswkbM6EzziqOMPBpu/6urcP20IFkgsufLvP4zjyPm48gbTIIloBPNg32pba/98UPByEM+zX7aPIruVcfwWxpoH/VjKC8AHFlgQbIGP8isakEywKF6b/bjhOtE2zwd8JFlKCMZVzy/flyxJQpGDQUMpCvo0hu848bpVEVVn/x6XFtY/TpVy6ZOF5ZQydtAEImCrqH0JR61QHLjWI5xchYCCd4YIJEV7VKm2dq7feu85SqrvUThczRVf7vx8MJN1f6BQkE2ifruqixDLgqo4zfETXMnSd6v9dGaUqrlHTQDeoZ6Ts6niRcCpjqOyQiyzTNr9v+dgl/36shu2OXLqrWc5ppljNFx95mh/7LYtSYOV2l7p4/GTJsVg6I4iyTW6lFIzFPhi/dACy9e1TzBMs977SF1h0bQZUm2Fj3Z2cFUMKYWgbP6DQF7tWlF1MVwc46rdARRDd8+qhGNbdXu38p5f/t41+cdGeTOwS2ad3i8XaFS7Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2701.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(396003)(366004)(39860400002)(136003)(451199021)(6916009)(36756003)(4326008)(2906002)(66556008)(8936002)(8676002)(5660300002)(64756008)(86362001)(41300700001)(76116006)(66446008)(66476007)(91956017)(54906003)(66946007)(33656002)(6486002)(316002)(478600001)(6506007)(6512007)(2616005)(83380400001)(26005)(53546011)(38070700005)(38100700002)(71200400001)(186003)(122000001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aVBvNWpzMXdmWFltZytKNlhHajAzU2FPMm5ZTzBzb0ZYaDYybEN4dTFCOE9n?=
 =?utf-8?B?eHE0T3BzRnRTMFdCcGpkdHQwZFVXbkI2cnVSbytVeUliMEgrM3FIUXZBdHRG?=
 =?utf-8?B?Zmd6YStVYUFrSUZxNEZPT2JCMTF2RHVUNXJ2YVNjek1LOEN2N0drcGhjaCti?=
 =?utf-8?B?dTFiZEJpVmMwcUNWVm5qMExrdDZKQ2tTTzBINmFCNytVV3NpQkVZY0hIOXlK?=
 =?utf-8?B?bDh2S28zOVk4WnpDRk5VbjJ0b1BDVGcrdXZkYUh5OHZvaEE4dnZXbmdiQjg5?=
 =?utf-8?B?U1B4Y01abmx2RXMvbmlDTEJUUnNCNGZYTStla2FKRk45aUZLTVFEZ3lHdGw0?=
 =?utf-8?B?ZHdBOUsxa1BYQUU1K0lRdXlvVWxCOVozdDU0N0pHRWRtZVo0WlVpWFQzeU8x?=
 =?utf-8?B?a3k0K29qSVBYRndUNmtFTkpUV1lCaUk3VWxFSE5KcjBIMEp3V3lOMkFXOUZJ?=
 =?utf-8?B?ZGdyRjdsUlRRSTgxV0FJQ001c2JmaXcyZi9ic09JVnJSbXNJZVpSMjJzaVp3?=
 =?utf-8?B?dC85Mm9vNXhwalRPSy9XbTRadDlVdkNaZUlaaFpEMTd3b1Z0MEgrL09OVWtC?=
 =?utf-8?B?bDhPdTYxZUZTcDNwSE9YQVhhSzF1akRGYUFpY2FLYlJ1dE8vZk51MFBPUGM1?=
 =?utf-8?B?OGpJYVlkdk40Um1vMHFrZk1mdEFVOEhnNU1jNUFhd1JyVGovYW8zS04vS2Zo?=
 =?utf-8?B?RVJJM0FmOHVxMFdRNFZnTDY1MVVrNFhMS2Q2akNjZ3RGaTd0RXhWdFdjNi90?=
 =?utf-8?B?eFROREVldzd1cnhvaWdKQVY2dGJ5NitIbHlDSjNlVndHTGdhdWg5UmtPSm93?=
 =?utf-8?B?RGcwYU4wS3B0TWdXL1M5S3NXQlVIalFvVkFzdWhpelhuK3VwdW9iREtJeHIz?=
 =?utf-8?B?UkE0cVNaenJTOVNvQWtvRTRSdXZHdU5lYUhNVVQ4Z2NaUWhPMm5zVURmNWww?=
 =?utf-8?B?eSszUlZXdHd2UGJXczhDVFpSR01SWlR6bUx1OWlvVnRJejB2SG4rWUJVdlpL?=
 =?utf-8?B?Skc0N29oMFlzcGdwN0N6S0NnSjM2Rzk3RURmSUZMQmt6T2g4WmZQREJoSmVM?=
 =?utf-8?B?YTdUNTVoSUJrZjR0UDFzV0tLanZHeS91c3F0WnVCaWtNZzJkN1lPakRydlZZ?=
 =?utf-8?B?elJ2WEJwSVloNUdiWTZEa1hMcWl5YS8vSGM0RGZBWjdMWVduQ0o3eWE2UG1S?=
 =?utf-8?B?MG9LcFFiUCtBYnBmQWp0Y0lUR1ppL0Z4aS9jN08vYnNYa2N6K3AyVytVT21M?=
 =?utf-8?B?MUlkR0lFY21WeDdCenNlMmlFaXhtY3dQVjErcTY5WVRDVEdLNkVYZ2hyT1ZH?=
 =?utf-8?B?bUh5bUlZTnljVURiZk5qS2hieVRMQTZiWE1LVjYremU1bFU3NzV6SlJlRlZD?=
 =?utf-8?B?Qk1WUWdXN0NDUlQxZU0rZmRQeEZXenpRb1hTUUlySnBWUVZjYkFGenI1eTBL?=
 =?utf-8?B?YkVMbzNrK0p5TFVkVzJ6N3p0WlFhTThSRDVWSDBYdFJ4Y3lCdTZHRVZiVTdv?=
 =?utf-8?B?eFJaV3JkbHJpVGpYZ0gxbmlwYU1PdXFjdVpsY0M4WW5LdG9jYUNnYXJ5Ym1C?=
 =?utf-8?B?Q1lXV09KbDQ1cFZFUDBpc3F1UjBBZ0ZNKzlRa3RuU29CeEFIdzlWaDg2NHdF?=
 =?utf-8?B?eUV2anNjMi9WYndtcEc2dkhMcWdEYXRWRWg1TWNGWTRjZzNMNzBwcTJXQ3Va?=
 =?utf-8?B?alFyQllpVGZ4UGJPRjFDeGM1RjRmOEpTaDVBZEM1aUF5MTdsR1RnSGZ3WEpx?=
 =?utf-8?B?TEZjTUdzY1BpWWhGa1lBK0o2UXNtOGZXemhuWDN0NEFLTisxaXNpUXJGUGRO?=
 =?utf-8?B?TkZUWGFpaEVQd3lrSlBVNVRlWHpEZGVnSzdabXJ4M3JGeUxmRVg4ZmdMQjlS?=
 =?utf-8?B?b2tTOVJoTlN1OTlOL3ZqbGcvRzBFZ3hqQXl2dUtTaFpGZlk4cUxxZDhiejNU?=
 =?utf-8?B?QzBHNVZVcTBXM2c2Uy9jTnh3OHE4eGJPWVVVS3FYVHg2MHJaT0p4NEw0ZHQ0?=
 =?utf-8?B?d1RhQTR5UVRYZWZJcVp6VldjWGpkckU2SkcwQkk0QkFuVVVuQUt1M3BkNTBM?=
 =?utf-8?B?TldoeEx5MHdWdFNrS1Y2OXl2RVpuMXRiKzVJNE8xazJNcEdZcndxNkNqUVJZ?=
 =?utf-8?B?dlU2M01tYmdreWVxTlo5eXZNeTljMzNtK3c2TUxvVEppVkMrRzAxb3FWaUgz?=
 =?utf-8?B?YUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <44C3ECA09DB11B45B8ADB394A38767A8@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: ytP6Vtc1Z5R2StMAGZRU4o8xKE6Em5Q0e18UQZTAUMLvNf/C0cVGhiwheCeB0WFAz+b1bOsMPgCSZBYUj49W5GG0kpcQ81Tey7mZMhqd7mkbifW7f6CO/gx7A5P1I7+Y+uJA8DDmxQVUgFKT6c14KLbgTIlL+HoiPe7e8V7iSQ/zxKj33t9Q6xyXF4wSk6RFy9h0bTyJDST+IpNN3cMnkZHZAZC4pO5pina08rnykBWFuU3gakjg6qJIwky8hadzV9aqcfQhhfO3r2rg6J07Eb7biBXxj597XlN2XvevspuzAzWWZox4lOrufwrN0wQmFJZIX8yogpQ9bYl5taJPwUvno7S2iaxtf38KJAQKP+PvGzD1QWMKFQzcNHHIx2IqqeqxJYJxNDq7L7KUGYOln0K8OPbdqctjuTZHT9ERuWXbsCvZjf7pDrvJEevT7PV7JUtROwVYQa97GyXB0mPPcoLQfYch1CXrQa5ozV2zoaaA6GDmY8vyDWyq4Pr7q62mzaGoT0aNg9e1U326CI7/9ZmzHZY0E/opH18pMyrk8gMtmPsIgY4ZhzQ/nlG2E6W73iyecupdwCDw7BgNiaznRaWk4dafVNnDyytDROTJT75LwmV5mO3A39M+CPSTzn0OnJDKa1XhLMVXuWyAQ19SK1x5N0hPiQbVafwmX0K6Z4PbIobk7ICuq5f/EYYlRjYRaCYJ1ZA/TKe6uWRCP5OCivuCphk3cgBK9zyC34JxBeXcV34/q6PBoYO/M9PmlR3GIfuI35RAN2lhyNlRbSVPu0Q+s4ATYj2SmRcl66W/Xqq9ANLgMX0dbDHKB4bXsEPClo9V/A7LGlKdOAshkCe9rQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 658f7a23-9394-4ff9-ed52-08db5734587e
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2023 00:10:53.7136
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j9We3UCk9OYJ5RVUmJBlxj0sXEEXuhdVos0aXWtHGVXorPH3n9Vou5mLfo0/U9HdzWfQBeG+tiiMS6Vv5qF845xZ3s+l10D3IuSBTTznoPA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4249
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-17_04,2023-05-17_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 spamscore=0
 bulkscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305170199
X-Proofpoint-ORIG-GUID: W1NfOYn-HVBS5ROhDk4U4fXpdVpIF7hS
X-Proofpoint-GUID: W1NfOYn-HVBS5ROhDk4U4fXpdVpIF7hS
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

DQoNCj4gT24gTWF5IDE3LCAyMDIzLCBhdCAzOjQ5IFBNLCBEYXZlIENoaW5uZXIgPGRhdmlkQGZy
b21vcmJpdC5jb20+IHdyb3RlOg0KPiANCj4gT24gV2VkLCBNYXkgMTcsIDIwMjMgYXQgMDc6MTQ6
MzJQTSArMDAwMCwgV2VuZ2FuZyBXYW5nIHdyb3RlOg0KPj4+IE9uIE1heSAxNiwgMjAyMywgYXQg
Njo0MCBQTSwgRGF2ZSBDaGlubmVyIDxkYXZpZEBmcm9tb3JiaXQuY29tPiB3cm90ZToNCj4+PiBP
biBUdWUsIE1heSAxNiwgMjAyMyBhdCAwNTo1OToxM1BNIC0wNzAwLCBEYXJyaWNrIEouIFdvbmcg
d3JvdGU6DQo+Pj4gSSB3YXMgdGhpbmtpbmcgdGhpcyBjb2RlIGNoYW5nZXMgdG86DQo+Pj4gDQo+
Pj4gZmxhZ3MgfD0gWEZTX0FMTE9DX0ZMQUdfVFJZX0ZMVVNIOw0KPj4+IC4uLi4NCj4+PiA8YXR0
ZW1wdCBhbGxvY2F0aW9uPg0KPj4+IC4uLi4NCj4+PiBpZiAoYnVzeSkgew0KPj4+IHhmc19idHJl
ZV9kZWxfY3Vyc29yKGNudF9jdXIsIFhGU19CVFJFRV9OT0VSUk9SKTsNCj4+PiB0cmFjZV94ZnNf
YWxsb2Nfc2l6ZV9idXN5KGFyZ3MpOw0KPj4+IGVycm9yID0geGZzX2V4dGVudF9idXN5X2ZsdXNo
KGFyZ3MtPnRwLCBhcmdzLT5wYWcsDQo+Pj4gYnVzeV9nZW4sIGZsYWdzKTsNCj4+PiBpZiAoIWVy
cm9yKSB7DQo+Pj4gZmxhZ3MgJj0gflhGU19BTExPQ19GTEFHX1RSWV9GTFVTSDsNCj4+IA0KPj4g
V2hhdOKAmXMgdGhlIGJlbmVmaXRzIHRvIHVzZSBYRlNfQUxMT0NfRkxBR19UUllfRkxVU0g/DQo+
PiBJZiBubyBjaGFuZ2UgaGFwcGVuZWQgdG8gcGFnYl9nZW4sIHdlIHdvdWxkIGdldCBub3RoaW5n
IGdvb2QgaW4gdGhlIHJldHJ5DQo+PiBidXQgd2FzdGUgY3ljbGVzLiBPciBJIG1pc3NlZCBzb21l
dGhpbmc/DQo+IA0KPiBZb3UgbWlzc2VkIHNvbWV0aGluZzogdGhlIHN5bmNocm9ub3VzIGxvZyBm
b3JjZSBpcyBhbHdheXMgZG9uZS4NCj4gDQoNCkl04oCZcyB0cnVlIHRoYXQgc3luY2hyb25vdXMg
bG9nIGZvcmNlIGlzIGRvbmUuDQoNCj4gVGhlIGxvZyBmb3JjZSBpcyB3aGF0IGFsbG93cyBidXN5
IGV4dGVudHMgdG8gYmUgcmVzb2x2ZWQgLSBidXN5DQo+IGV4dGVudHMgaGF2ZSB0byBiZSBjb21t
aXR0ZWQgdG8gc3RhYmxlIHN0b3JhZ2UgYmVmb3JlIHRoZXkgY2FuIGJlDQo+IHJlbW92ZWQgZnJv
bSB0aGUgYnVzeSBleHRlbnQgdHJlZS4NCg0KWWVwLg0KDQo+IA0KPiBJZiBvbmxpbmUgZGlzY2Fy
ZHMgYXJlIG5vdCBlbmFibGVkLCBidXN5IGV4dGVudHMgYXJlIHJlc29sdmVkDQo+IGRpcmVjdGx5
IGluIGpvdXJuYWwgSU8gY29tcGxldGlvbiAtIHRoZSBsb2cgZm9yY2Ugd2FpdHMgZm9yIHRoaXMg
dG8NCj4gb2NjdXIuIEluIHRoaXMgY2FzZSwgcGFnLT5wYWdiX2dlbiB3aWxsIGhhdmUgYWxyZWFk
eSBpbmNyZW1lbnRlZCB0bw0KPiBpbmRpY2F0ZSBwcm9ncmVzcyBoYXMgYmVlbiBtYWRlLCBhbmQg
d2Ugc2hvdWxkIG5ldmVyIHdhaXQgaW4gdGhlDQo+IGxvb3AgYWZ0ZXIgdGhlIGxvZyBmb3JjZS4g
VGhlIG9ubHkgdGltZSB3ZSBkbyB0aGF0IGlzIHdoZW4gdGhlDQo+IGN1cnJlbnQgdHJhbnNhY3Rp
b24gaG9sZHMgYnVzeSBleHRlbnRzIGl0c2VsZiwgYW5kIGhlbmNlIGlmIHRoZQ0KPiBjdXJyZW50
IHR4IGhvbGRzIGJ1c3kgZXh0ZW50cyB3ZSBzaG91bGQgbm90IHdhaXQgYmV5b25kIHRoZSBsb2cN
Cj4gZm9yY2UuLi4uDQoNClNvIHlvdSBhcmUgdGFsa2luZyBhYm91dCB0aGUgY2FzZSBvZiDigJxw
YWdiX2dlbiB3aWxsIGhhdmUgYWxyZWFkeSBpbmNyZW1lbnRlZOKAnSwNCkluIHRoaXMgY2FzZSB5
b3VyIG5leHQgdHdvIGxpbmVzOg0KDQogIGlmIChidXN5X2dlbiAhPSBSRUFEX09OQ0UocGFnLT5w
YWdiX2dlbikpDQpyZXR1cm4gMDsNCg0Kd291bGQgY2FwdHVyZSB0aGF0IGFuZCByZXR1cm4gaW1t
ZWRpYXRlbHkgd2l0aG91dCB3YWl0aW5nLiBTbyBUUllfRkxVU0ggaXMgbm90DQpoZWxwZnVsIGlu
IHRoaXMgY2FzZS4gDQoNCj4gDQo+IElmIG9ubGluZSBkaXNjYXJkcyBhcmUgZW5hYmxlZCwgdGhl
biB0aGV5J2xsIGJlIHNjaGVkdWxlZCBieSBqb3VybmFsDQo+IElPIGNvbXBsZXRpb24uIGkuZS4g
d2FpdGluZyBvbiB0aGUgbG9nIGZvcmNlIGd1YXJudGVlcyBwZW5kaW5nDQo+IGRpc2NhcmRzIGhh
dmUgYmVlbiBzY2hlZHVsZWQgYW5kIHRoZXknbGwgc3RhcnQgY29tcGxldGluZyBzb29uIGFmdGVy
DQo+IHRoZSBsb2cgZm9yY2UgcmV0dXJucy4gV2hlbiB0aGV5IGNvbXBsZXRlIHRoZXknbGwgc3Rh
cnQgaW5jcmVtZW50aW5nDQo+IHBhZy0+cGFnYl9nZW4uIFRoaXMgaXMgdGhlIGNhc2UgdGhlIHBh
Zy0+cGFnYl9nZW4gd2FpdCBsb29wIGV4aXN0cw0KPiBmb3IgLSBpdCB3YWl0cyBmb3IgYSBkaXNj
YXJkIHRvIGNvbXBsZXRlIGFuZCByZXNvbHZlIHRoZSBidXN5IGV4dGVudA0KPiBpbiBpdCdzIElP
IGNvbXBlbHRpb24gcm91dGluZS4gQXQgd2hpY2ggcG9pbnQgdGhlIGFsbG9jYXRpb24gYXR0ZW1w
dA0KPiBjYW4gcmVzdGFydC4NCg0KSW4gYWJvdmUgY2FzZSwgeW91IGFyZSB0YWxraW5nIGFib3V0
IHRoZSBjYXNlIHRoYXQgcGFnLT5wYWdiX2dlbiB3aWxsIGJlDQppbmNyZW1lbnRlZCBzb29uIHdp
dGhvdXQgYW55IGJsb2NraW5nLg0KSW4gdGhpcyBjYXNlLCBpbiB0aGUgYWxsb2NhdG9yIHBhdGgs
IHN0aWxsIHRoZSB0d28gbGluZXM6DQogIGlmIChidXN5X2dlbiAhPSBSRUFEX09OQ0UocGFnLT5w
YWdiX2dlbikpDQpyZXR1cm4gMDsNCg0KVGhlIGNvbmRpdGlvbiBvZiAiYnVzeV9nZW4gIT0gUkVB
RF9PTkNFKHBhZy0+cGFnYl9nZW4p4oCdIGNhbiBiZSB0cnVlDQpvciBhIGZhbHNlIGFjY29yZGlu
ZyB0byB0aGUgcmFjZSBvZiB0aGlzIHByb2Nlc3MgVlMgdGhlIHF1ZXVlIHdvcmtlcnMgKHdoaWNo
DQpzdGFydCBjb21wbGV0aW5nKS4gIEluIGNhc2UgaXTigJlzIHRydWUsIHRoZSBjb2RlIHJldHVy
biBpbW1lZGlhdGVseS4gT3RoZXJ3aXNlDQp0aGUgY29kZSBydW5zIGludG8gdGhlIGxvb3Agd2Fp
dGluZyBhYm92ZSBjb25kaXRpb24gYmVjb21lIHRydWUuIFdoZW4NCnRoZSBxdWV1ZSB3b3JrZXJz
IGluY3JlbWVudGVkIHBhZy0+cGFnYl9nZW4sIHRoZSBhbGxvY2F0b3IgcGF0aCBqdW1wcw0Kb3V0
IHRoZSBsb29wIGFuZCBnbyDigJQgdGhhdOKAmXMgcGVyZmVjdC4gSSBkb24ndCBzZWUgd2h5IFRS
WV9GTFVTSCBpcyBuZWVkZWQuDQoNCg0KPiANCj4gSG93ZXZlciwgdGhlIHNhbWUgY2F2ZWF0IGFi
b3V0IHRoZSBjdXJyZW50IHR4IGhvbGRpbmcNCj4gYnVzeSBleHRlbnRzIHN0aWxsIGV4aXN0cyAt
IHdlIGNhbid0IHRlbGwgdGhlIGRpZmZlcmVuY2UgYmV0d2Vlbg0KPiAiZGlzY2FyZHMgc2NoZWR1
bGVkIGJ1dCBub3QgY29tcGxldGVkIiBhbmQgIm5vIGJ1c3kgZXh0ZW50cyB0bw0KPiByZXNvbHZl
IiBpbiB0aGUgZmx1c2ggY29kZS4gSGVuY2UgcmVnYXJkbGVzcyBvZiB0aGUgb25saW5lIGRpc2Nh
cmQNCj4gZmVhdHVyZSBzdGF0ZSwgd2Ugc2hvdWxkIG5vdCBiZSB3YWl0aW5nIG9uIGJ1c3kgZXh0
ZW50IGdlbmVyYXRpb24NCj4gY2hhbmdlcyBpZiB3ZSBob2xkIGJ1c3kgZXh0ZW50cyBpbiB0aGUg
dHJhbnNhY3Rpb24uLi4uDQoNClllcywgdGhhdOKAmXMgdHJ1ZS4NCkJ1dCBmaXJzdCwgd2l0aG91
dCBUUllfRkxVU0gsIHRoZSBjb2RlIHdpbGwgcmV0dXJuIC1FQUdBSU4gaW1tZWRpYXRlbHkgDQp3
aXRoIHRoZSBmb2xsb3dpbmcgdHdvIGxpbmVzOg0KDQogIGlmIChmbGFncyAmIFhGU19BTExPQ19G
TEFHX0ZSRUVJTkcpDQpyZXR1cm4gLUVBR0FJTjsNCndpdGhvdXQgYW55IHdhaXRpbmcuIFNvIG5v
IHByb2JsZW0gaWYgd2UgZG9u4oCZdCB1c2UgVFJZX0ZMVVNILiANCg0KDQo+IA0KPiBJT1dzLCB0
aGUgVFJZX0ZMVVNIIGNvZGUgcmVmbGVjdHMgdGhlIGZhY3QgdGhhdCBmb3IgbW9zdCB1c2Vycywg
dGhlDQo+IGxvZyBmb3JjZSByZXNvbHZlcyB0aGUgYnVzeSBleHRlbnRzLCBub3QgdGhlIHdhaXQg
bG9vcCBvbg0KPiBwYWctPnBhZ2JfZ2VuIGNoYW5naW5nLiBUaGUgd2FpdCBsb29wIG9ubHkgcmVh
bGx5IGtpY2tzIGluIHdoZW4NCj4gb25saW5lIGRpc2NhcmQgaXMgYWN0aXZlLCBhbmQgaW4gdGhh
dCBjYXNlIHdlIHJlYWxseSBkbyB3YW50IHRvDQo+IHJldHJ5IGFsbG9jYXRpb24gd2l0aG91dCB3
YWl0aW5nIGZvciAocG90ZW50aWFsbHkgdmVyeSBzbG93KQ0KPiBkaXNjYXJkcyB0byBjb21wbGV0
ZSBmaXJzdC4gV2UnbGwgZG8gdGhhdCAid2FpdCBmb3IgZGlzY2FyZHMiIHRoZQ0KPiBzZWNvbmQg
dGltZSB3ZSBmYWlsIHRvIGZpbmQgYSBub24tYnVzeSBleHRlbnQuLi4uDQo+IA0KDQpJdCBzZWVt
cyB0aGF0IHlvdSB3YW50IGdpdmUgYW5vdGhlciBjaGFuY2UgdG8gZ28gb3ZlciB0aGUgZnJlZSBl
eHRlbnRzIGluIEFHDQp0byBzZWUgaWYgd2Ugd2lsbCBoYXZlIGx1Y2sgaW4gdGhlIHJldHJ5IHdp
dGhvdXQgYW55IGd1YXJhbnRlZS4gSXTigJlzIHBvc3NpYmxlDQp0aGF0IHdlIGFyZSBsdWNreSB0
aGF0IGluIHRoZSByZXRyeSwgdGhlIHJlbGV2YW50IGJ1c3kgZXh0ZW50cyBhcmUgcmVzb2x2ZWQN
CihjbGVhcmVkKSwgYnV0IGl04oCZcyBhbHNvIHBvc3NpYmxlIHRoYXQgd2UgZG9u4oCZdCBoYXZl
IHRoZSBsdWNrLg0KDQpBbHNvIHRoZSBUUllfRkxVU0ggZG9lc27igJl0IGxvb2sgdG8gYmUgYSBr
ZXkgcG9pbnQgdG8gZml4IHRoZSBvcmlnaW5hbCBwcm9ibGVtDQooZGVhZGxvY2spIGJ1dCBhbiBv
cHRpbWl6YXRpb24/IEFuZCB0aGF0IG1heSBoZWxwIG9ubHkgb25saW5lIGRpc2NhcmRzIGFyZQ0K
ZW5hYmxlZCAoSSBkb27igJl0IHRoaW5rIHRoYXTigJlzIGEgcG9wdWxhciBtb3VudCBvcHRpb24s
IGl0IGtpbGxzIHBlcmZvcm1hbmNlIGdyZWF0bHkpLg0KSWYgeW91IHdhbnQgdGhhdCBhbnl3YXks
IEnigJlkIGxpa2UgbWFrZSBpdCB0aGVyZSBvbmx5IHdoZW4gIm9ubGluZSBkaXNjYXJkcyBhcmUN
CmVuYWJsZWTigJ0sIG90aGVyd2lzZSBpdCBoZWxwcyBub3RoaW5nIGF0IGFsbCBidXQgd2FzdGUg
Y3ljbGVzLg0KU28gY2hhbmdlIHRoZSBsaW5lIG9mDQogDQpmbGFncyB8PSBYRlNfQUxMT0NfRkxB
R19UUllfRkxVU0g7DQoNCnRvDQoNCmlmICh4ZnNfaGFzX2Rpc2NhcmQobXApKQ0KICAgIGZsYWdz
IHw9IFhGU19BTExPQ19GTEFHX1RSWV9GTFVTSDsNCg0KU291bmRzIGdvb2Q/DQoNCnRoYW5rcywN
CndlbmdhbmcNCg0K
