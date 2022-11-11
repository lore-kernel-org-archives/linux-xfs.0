Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15336C433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Nov 2022 00:57:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbiKKA52 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Nov 2022 19:57:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiKKA51 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Nov 2022 19:57:27 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 265BA606BC
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 16:57:26 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AB0ub2i011669;
        Fri, 11 Nov 2022 00:57:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=IsD9FIVS31g83GLUt6717yNVOfmGf5+vXuuF0fwACwI=;
 b=pNrgBLtUuxiNRNUV+bkZbw+BQxM9zBfN0DukoiWLb4cmkEZpScfX0q0FwKUaq147E2FV
 B9vomKsxLNjoqn0YtppUxJCVsLSs8Te60bpjloY9SNgclKFYyV1SeaJVP9+xlZ76D23a
 IBLVcokmISpQsvKlyDoebqzsArtQstForE0KeOQGt+CcY9wViefNxDxnUqTQqyjG3RQm
 ocxWi5Ocj7ZuffL5IhlR0ruMKsrCzkmK2jS9wP2psGsLLWb5cBdLPajEGY8sLObPmUzJ
 HJIFXQUiCcZ4aPvFcsPn+vi4v0hfrAu/Va5rUGIF4f3f47ERC3gaF/wlltFtxRR6S/Y9 EQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ksc9gg008-59
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Nov 2022 00:57:20 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AB04rLq019819;
        Fri, 11 Nov 2022 00:41:23 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2175.outbound.protection.outlook.com [104.47.73.175])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcqkuqjw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Nov 2022 00:41:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lq4G09ySp8xdkiUF15rv04HtjxX2zfO4jYnO/0tm/l6bBRJzhzFKkfyP1srjg/eDxDcfi2enYkvaPim2ykn0vlb7eYunFrU1z1JNlioXhqRQjRipcDt9q+EdrYAnE7Ez/BEOx4lwhxyi7Fsfe/ZLaIk/omYBBeXnTTK5SXl1nbXuNI5kjj3xlK5D/fLm1KBKnOEC3JcV/uBlsw2I52caJqaoPfSgXefx7wHf3VZsW83+Pbl644sYOhab/J6yHxLRgo0ia+6GSp2Q7LnBwJzaL9Um7C7O5sz5vnHyThRzy0FL6EY32UjXo4pmmIm8tazUQF/ry1OCb3q9hT+n0zADhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IsD9FIVS31g83GLUt6717yNVOfmGf5+vXuuF0fwACwI=;
 b=BaxZiRJ87F9DIDyTqykN3jC0JQCUccYkaU7tbzZfT1FGcsK4GRhNAZ+cVDcPCAvgT515hY4bUycmBsP3j8ndhPvQEZgaS+3qtohCLnR6fSvxuI6OjGyXdTxjcfjVL9KOJ5fkcOBrmtihw7vJqXXen58NRrPk8ZidcCZLJtUToSZm7JP4bCxOylgMr04KXoniuFxm11i1VSobbvBXWbD8n81+AdqcVTQ0sIZhbc5yPxJE/yLP5XvKr7wWhBCY+r1aAfTBTx4tTJy+0XbX7HhnAzITVtK0DbRl33GX+UT9D/MxyI4USKsd18k0Vw4v0kP7z2AI5HzwBCN2h0FCLErLaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IsD9FIVS31g83GLUt6717yNVOfmGf5+vXuuF0fwACwI=;
 b=YGVmz7n1qzzhS3xQ1yUltas8qMMgKzqKMs5jHLFkXGAwdg2/mDem2VTuH4kwj4U4puwTnUNPu44Nj3La+BdHdWnPwY/zXAfwJrKo/JTTJWCmJFziiUibBPcfbM7Lg0w/64pkRaYOlziVP6LJad4VmQipt0opq/PYTka9uxpUMr4=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by MW4PR10MB5752.namprd10.prod.outlook.com (2603:10b6:303:18d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.12; Fri, 11 Nov
 2022 00:41:20 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::e1d1:c1c7:79d:4137]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::e1d1:c1c7:79d:4137%4]) with mapi id 15.20.5813.012; Fri, 11 Nov 2022
 00:41:20 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "tytso@mit.edu" <tytso@mit.edu>
Subject: Re: [PATCH v1 2/2] xfs: add FS_IOC_GETFSUUID ioctl
Thread-Topic: [PATCH v1 2/2] xfs: add FS_IOC_GETFSUUID ioctl
Thread-Index: AQHY9Ilt/8XhT0e4yke3a0w9jJjRLa44lnyAgABNEgA=
Date:   Fri, 11 Nov 2022 00:41:20 +0000
Message-ID: <8B2A7B26-B254-4B61-9F86-24B68CB3BC2E@oracle.com>
References: <20221109221959.84748-1-catherine.hoang@oracle.com>
 <20221109221959.84748-3-catherine.hoang@oracle.com>
 <Y21ZibTXMsyjekbW@magnolia>
In-Reply-To: <Y21ZibTXMsyjekbW@magnolia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BLAPR10MB5316:EE_|MW4PR10MB5752:EE_
x-ms-office365-filtering-correlation-id: 4ef9d30b-d2aa-460f-c5da-08dac37d73ac
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DIcMfJp/WHDx4KRGNI5j82KJArq8yMxTCQdcUCLDAySzvLKFOr0SAwz6SO5tCJdifVxU+arjoVT+ZIFOqOKlC5ilo9MLC58LKDt9yk2vA2DuuFRqZd1qVA62FwoNqmY1MBuSJkjVolQ8I6xWlvHFINj4yLPArsoFlqIEUuSqWY8iFqllEhISKUe6tCnFnKwd0u0hOU/0vLVVLajUi6JjlcgCSAc9Xk2mfdzK5oUGOEbWTrGFfc/pDcqYs3ILwbJDO80Y5tcnIICm2d1nfxq0thrEp35jAfOW3I4cbcz6mea/eVd6WAGCqW2Eqi6KToLe7oUKg0i5AicCEZ+j8r2xUNAfe/FZX2jZyY0XwnlqjuR7I4zomAzYQZKg2/vnUEL1i/DuMu08+67yAlgCRy5FQ4JhLOFBuE7+eGRPPQZVO88Sg5yZy132v0Vro46k6/bs4LLLIws11Fk6d7JDrQk3RO4OOeVTFCkbqngHTezc7j8wBDBH4K7NP5MJNW0gP33VFMqovffpHGX98OoPwu+lNFUzInKeIKw4xPhKjdDdmX9s+FwCpzlZpEejEs7MFvGvvK0IGalSzaYxq/3SUeztYiBpkkNfoaYr0wQQ6WyoSUT1loOZCqkjK7TGqi4Qyw8VGP4XP9DWTj+cM0DoWS0aT9vsdSRtZfapxr5Vnk2rID8c6MQuGjyzWJMiXp+M2AeW8uNfbwPG42jzyLgcpyJBOC/XxTaaqG1KJRpH+V2tQsGtvkpw6bnCyJHk0qxCwVtKi1OXI06BtiRxSWYeq3EvkR7hyo4ir5ttM9CtvL+d3W4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(366004)(376002)(396003)(136003)(451199015)(91956017)(36756003)(6506007)(6512007)(71200400001)(6486002)(5660300002)(38100700002)(66556008)(8936002)(54906003)(44832011)(6916009)(316002)(86362001)(38070700005)(83380400001)(4326008)(66946007)(33656002)(76116006)(64756008)(66446008)(8676002)(2616005)(186003)(53546011)(66476007)(41300700001)(478600001)(66899015)(122000001)(2906002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q1RDSGNHRkNtaXhwQTJldy8vUmZBYVRNWEJIVGp6T0NjSGozWjJueVNybTBB?=
 =?utf-8?B?dUZOa2YzQ3RLeE53bHB4U0pneDk5VEVWNGRaUXluLzdkdGF3RDNJd3hqYzY4?=
 =?utf-8?B?NEVMRUZNT0VPZnBvU29NRzk5SGt0R2ZmTzJ1NHVWWE5DWEVRSWltUUhUdzBX?=
 =?utf-8?B?QTd5U0dCdmsrRDlPMkVienFtcDZBMUw4TkRTZENQUE9rWllpcVNFcjVpZTVX?=
 =?utf-8?B?S0pzZHIyalFiUzUycVY4akNlaDRkd2hWL0JVZXlsOGo0WEZSNngvY0ZyYWZL?=
 =?utf-8?B?ZUd0dDlISmc5eVQycGRGNWRCNW5raFNBemFMMWx0M21vTE1FZ2VsbThIL3Zk?=
 =?utf-8?B?My90MmtiRnRFdWF3Z0c2WWlkTSs5SHZwYWsvTTBmK014di85SENWc2UwbzN4?=
 =?utf-8?B?YjYxUEk4cEhSa0UvVld2MWg5K0lFTE9vWlUxZVhJS0k0WHBtQmUzbkw5cFJB?=
 =?utf-8?B?bUt5dXFlbDh0WlM4TnhreDVXNVZRTU9lQ0I0cFQxcGFlazR3NDB1dXRTZkQ0?=
 =?utf-8?B?Tit4ditmNFVFcjlkTGhQV2NnYlFSTDc5MCsrSUN6eTRGQ0FlODdOVkFkRUpZ?=
 =?utf-8?B?YmlrVG94V3g1ZHppei9tajI4V2pyOGFZVGVOVnF2VVBKSVc0RVVRMkcyTjZD?=
 =?utf-8?B?TWY3cUFlaDNsZll0L2RubXVGSHhtWk05R09VdEhFK1hyUk53MkFZdVVTOTdC?=
 =?utf-8?B?THpxYmFtRFlVKzl4dUNhMkk4SEFSQUoyeW5KZlk0QWpNcXN6aEp4eGJVcWQ4?=
 =?utf-8?B?WUtzbnJYODdCbStMNUpXY0FNT1d6NXRrc1NKMUdVM29XU3ZPdDJLNUhRTmU3?=
 =?utf-8?B?cE5pbG92ckdqalBOZmtBUUI0eDNzSHdmdEdCMG1vTFdFY2pHYnpyNStSWW9P?=
 =?utf-8?B?T0wrNGlHcVBubTRCTVhMcDBWZ3dqWWwrS1ExeWdoQkNBeXdRWUV4azJneGpz?=
 =?utf-8?B?eE1FalZicUp4bFVOMGdUaVJLY0RMOWZuSmlJd3pTRTE4K2RSaWdkZlFxdVhk?=
 =?utf-8?B?ejZnMzZ3UVM5YlFldkpBOThrdzZVRjREK1dQU09XVmdzT1FiVXQyM05Nbzds?=
 =?utf-8?B?Qi84Y2NvbjNjZnhxMjVjdlVOUWtuT0tMa3pPQUNVNXFBcFdHQmVuUnlGbVVx?=
 =?utf-8?B?T0Jic0FQUmtPMjJQcEk5VHorWGFYZEdmR1BrQ2M2Rmh2dlp0Z0x0c3JKSU12?=
 =?utf-8?B?akdrekhmVXJWTHFDYUtUR2thU1hWVW45bDhJci9SUnE2aE82Wlo2TTZQS0o0?=
 =?utf-8?B?Rm4rZm5xekJLZzN4VkNxdEFKdUFkUkVaamQyZExGMkZZYUdZall1TW1xcnpj?=
 =?utf-8?B?bEh4Z28vdEtJQUxnZEhycDB6YjdsTHdTQnlFMHN0Mk0yTmovNnNreHZ6TXQy?=
 =?utf-8?B?SzdpV3FxbTY5Z1pVeGpibkI2RGMvd0Y3RXlHb1Y2Rnp1c1VuQUJqZWVIZjBp?=
 =?utf-8?B?Yk9iWklRRXArSkZxMTVQUDBYOXhWTEJQWjIrNkx2ak9jalFCWUdHRGZ2WGo0?=
 =?utf-8?B?Nnp4WjN3czVKeG40TXIwQWw3aEVRaE5adDMybHpHS1N3dFFHRFNjcE1tQWNG?=
 =?utf-8?B?bTI1MXRrMkNOOFZBWDRVUlpORG9iMGJNMTRDcnhuVGgyVi93YXJDZWlWbExI?=
 =?utf-8?B?QUNkZjlSL1lpZUNZeFZhT0c2TkdrS28yMEpSRkpwTHh1ajM1SXIvQXpBcHZk?=
 =?utf-8?B?aHdLRjJrU1dYZ1FHMmY2VkFlWnhLZjRrY2FOMStqMGZHSWtLdk5GTmFrWGFG?=
 =?utf-8?B?T3VjMUgvTjloY3RqUEltU0ZTWlVkaVhKY2RrRG1BTlV6S081RVk3SWpiMTBH?=
 =?utf-8?B?VjlCUEtmUnE2ek12VmwzMXlZZkNnc2NGazN2ekRUMmNicEpTMlBmL0ttNEZP?=
 =?utf-8?B?Y2JNV0lWUlQ0YlJVRDd5bHMwTWFncmY4ckhJRi81ZnJueGx6Y3BCZXBIcUpF?=
 =?utf-8?B?Qk1iQ3g3Z285Q1RvNW5mRUk5Vk1iMThEczRPd1FOSTcvWGEzeldHWmJwNHpt?=
 =?utf-8?B?OFRVNEJ5dGNndWNjMVhmOTI1NXJGNWt1eEE0bUJOZGI5amh6bDZFOFY3V21X?=
 =?utf-8?B?dURpUzV5RXFKaTkzbmx2SE01RVhFWTdmMmU2OWkxS2haMUs4cVFkZWp5ckNw?=
 =?utf-8?B?aEN2YStxQ0xUUjV5UVRxOWlrdXprVlhjT3NEWFEvVWZPT3lLeXBHZ3hBM0hC?=
 =?utf-8?B?bEtoU09PQmFNRGxiVHIwMGFMWGJ0d2Q0eE1JQ2JuZERwdGk5TEZDRzlqaHF6?=
 =?utf-8?B?UnFpRG5VaU9QV2hZb3dmY09QNmNRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BFAA37FE1152474BA462B7B3B6861780@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ef9d30b-d2aa-460f-c5da-08dac37d73ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2022 00:41:20.4753
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FuVBXwJ7tQuJFliJjQJQdIzDEK9tJHCYwK2aCDeuPVhdIpu8Of74RtT7ET/Z2zt6sVx2b8MaCzjbafw1aTEnOEcH5X8yQkuDX+nN3e79Mgs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5752
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_14,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 suspectscore=0 spamscore=0 malwarescore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211110002
X-Proofpoint-ORIG-GUID: 3XodM2fSTRGw0TSVm_SE72fgUh1Nw1P9
X-Proofpoint-GUID: 3XodM2fSTRGw0TSVm_SE72fgUh1Nw1P9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

PiBPbiBOb3YgMTAsIDIwMjIsIGF0IDEyOjA1IFBNLCBEYXJyaWNrIEouIFdvbmcgPGRqd29uZ0Br
ZXJuZWwub3JnPiB3cm90ZToNCj4gDQo+IE9uIFdlZCwgTm92IDA5LCAyMDIyIGF0IDAyOjE5OjU5
UE0gLTA4MDAsIENhdGhlcmluZSBIb2FuZyB3cm90ZToNCj4+IEFkZCBhIG5ldyBpb2N0bCB0byBy
ZXRyaWV2ZSB0aGUgVVVJRCBvZiBhIG1vdW50ZWQgeGZzIGZpbGVzeXN0ZW0uDQo+IA0KPiBJIHRo
aW5rIGl0J3Mgd29ydGggbWVudGlvbmluZyB0aGF0IHRoaXMgaXMgdGhlIHByZWN1cnNvciB0byB0
cnlpbmcgdG8NCj4gaW1wbGVtZW50IFNFVEZTVVVJRC4uLiBidXQgdGhhdCdzIHNvbWV0aGluZyBm
b3IgYSBmdXR1cmUgc2VyaWVzLCBzaW5jZQ0KPiBjaGFuZ2luZyB0aGUgdXVpZCB3aWxsIHVwc2V0
IHRoZSBsb2csIGFuZCB3ZSBoYXZlIHRvIGZpZ3VyZSBvdXQgaG93IHRvDQo+IGRlYWwgd2l0aCB0
aGF0IGdyYWNlZnVsbHkuDQo+IA0KPj4gU2lnbmVkLW9mZi1ieTogQ2F0aGVyaW5lIEhvYW5nIDxj
YXRoZXJpbmUuaG9hbmdAb3JhY2xlLmNvbT4NCj4+IC0tLQ0KPj4gZnMveGZzL3hmc19pb2N0bC5j
IHwgMzIgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4+IDEgZmlsZSBjaGFuZ2Vk
LCAzMiBpbnNlcnRpb25zKCspDQo+PiANCj4+IGRpZmYgLS1naXQgYS9mcy94ZnMveGZzX2lvY3Rs
LmMgYi9mcy94ZnMveGZzX2lvY3RsLmMNCj4+IGluZGV4IDFmNzgzZTk3OTYyOS4uNjU3ZmUwNThk
ZmJhIDEwMDY0NA0KPj4gLS0tIGEvZnMveGZzL3hmc19pb2N0bC5jDQo+PiArKysgYi9mcy94ZnMv
eGZzX2lvY3RsLmMNCj4+IEBAIC0xODY1LDYgKzE4NjUsMzUgQEAgeGZzX2ZzX2VvZmJsb2Nrc19m
cm9tX3VzZXIoDQo+PiAJcmV0dXJuIDA7DQo+PiB9DQo+PiANCj4+ICtzdGF0aWMgaW50IHhmc19p
b2N0bF9nZXR1dWlkKA0KPiANCj4gTml0OiBmdW5jdGlvbiBuYW1lcyBzaG91bGQgc3RhcnQgb24g
YSBuZXcgbGluZS4NCj4gDQpPaywgd2lsbCBmaXggdGhhdA0KPj4gKwlzdHJ1Y3QgeGZzX21vdW50
CSptcCwNCj4+ICsJc3RydWN0IGZzdXVpZCBfX3VzZXIJKnVmc3V1aWQpDQo+PiArew0KPj4gKwlz
dHJ1Y3QgZnN1dWlkCQlmc3V1aWQ7DQo+PiArCV9fdTgJCQl1dWlkW1VVSURfU0laRV07DQo+PiAr
DQo+PiArCWlmIChjb3B5X2Zyb21fdXNlcigmZnN1dWlkLCB1ZnN1dWlkLCBzaXplb2YoZnN1dWlk
KSkpDQo+PiArCQlyZXR1cm4gLUVGQVVMVDsNCj4+ICsNCj4+ICsJaWYgKGZzdXVpZC5mc3VfbGVu
ID09IDApIHsNCj4+ICsJCWZzdXVpZC5mc3VfbGVuID0gVVVJRF9TSVpFOw0KPj4gKwkJaWYgKGNv
cHlfdG9fdXNlcih1ZnN1dWlkLCAmZnN1dWlkLCBzaXplb2YoZnN1dWlkLmZzdV9sZW4pKSkNCj4+
ICsJCQlyZXR1cm4gLUVGQVVMVDsNCj4+ICsJCXJldHVybiAtRUlOVkFMOw0KPiANCj4gVGVkIGFu
ZCBJIHdlcmUgbG9va2luZyB0aHJvdWdoIHRoZSBleHQ0X2lvY3RsX2dldHV1aWQgZnVuY3Rpb24g
b24gdGhpcw0KPiBtb3JuaW5nJ3MgZXh0NCBjb25jYWxsLCBhbmQgd2UgZGVjaWRlZCB0aGF0IGNv
cHlpbmcgdGhlIGRlc2lyZWQgdXVpZA0KPiBidWZmZXIgbGVuZ3RoIG91dCB0byB1c2Vyc3BhY2Ug
c2hvdWxkbid0IHJlc3VsdCBpbiBhbiBFSU5WQUwgcmV0dXJuDQo+IGhlcmUuLi4NCj4gDQo+PiAr
CX0NCj4+ICsNCj4+ICsJaWYgKGZzdXVpZC5mc3VfbGVuICE9IFVVSURfU0laRSB8fCBmc3V1aWQu
ZnN1X2ZsYWdzICE9IDApDQo+IA0KPiAuLi5hbmQgdGhhdCB3ZSBzaG91bGRuJ3QgcmVqZWN0IHRo
ZSBjYXNlIHdoZXJlIGZzdV9sZW4gPiBVVUlEX1NJWkUuDQo+IEluc3RlYWQsIHdlIHNob3VsZCBj
b3B5IHRoZSB1dWlkIGFuZCB1cGRhdGUgdGhlIGNhbGxlcidzIGZzdV9sZW4gdG8NCj4gcmVmbGVj
dCBob3dldmVyIG1hbnkgYnl0ZXMgd2UgY29waWVkIG91dC4gIEknbGwgc2VuZCBwYXRjaGVzIHRv
IGRvIHRoYXQNCj4gc2hvcnRseS4NCg0KT2ssIHRoYXQgbWFrZXMgc2Vuc2UuIEnigJlsbCBhcHBs
eSB0aG9zZSBjaGFuZ2VzIG92ZXIgdG8geGZzLiBUaGFua3MhDQo+IA0KPj4gKwkJcmV0dXJuIC1F
SU5WQUw7DQo+PiArDQo+PiArCXNwaW5fbG9jaygmbXAtPm1fc2JfbG9jayk7DQo+PiArCW1lbWNw
eSh1dWlkLCAmbXAtPm1fc2Iuc2JfdXVpZCwgVVVJRF9TSVpFKTsNCj4+ICsJc3Bpbl91bmxvY2so
Jm1wLT5tX3NiX2xvY2spOw0KPj4gKw0KPj4gKwlpZiAoY29weV90b191c2VyKCZ1ZnN1dWlkLT5m
c3VfdXVpZFswXSwgdXVpZCwgVVVJRF9TSVpFKSkNCj4+ICsJCXJldHVybiAtRUZBVUxUOw0KPiAN
Cj4gVGhlIHJlc3Qgb2YgdGhpcyBsb2dpYyBsb29rcyBjb3JyZWN0IHRvIG1lLiAgVGhhbmtzIGZv
ciBnZXR0aW5nIHRoaXMgb3V0DQo+IHRoZXJlLg0KPiANCj4gLS1EDQo+IA0KPj4gKwlyZXR1cm4g
MDsNCj4+ICt9DQo+PiArDQo+PiAvKg0KPj4gICogVGhlc2UgbG9uZy11bnVzZWQgaW9jdGxzIHdl
cmUgcmVtb3ZlZCBmcm9tIHRoZSBvZmZpY2lhbCBpb2N0bCBBUEkgaW4gNS4xNywNCj4+ICAqIGJ1
dCByZXRhaW4gdGhlc2UgZGVmaW5pdGlvbnMgc28gdGhhdCB3ZSBjYW4gbG9nIHdhcm5pbmdzIGFi
b3V0IHRoZW0uDQo+PiBAQCAtMjE1Myw2ICsyMTgyLDkgQEAgeGZzX2ZpbGVfaW9jdGwoDQo+PiAJ
CXJldHVybiBlcnJvcjsNCj4+IAl9DQo+PiANCj4+ICsJY2FzZSBGU19JT0NfR0VURlNVVUlEOg0K
Pj4gKwkJcmV0dXJuIHhmc19pb2N0bF9nZXR1dWlkKG1wLCBhcmcpOw0KPj4gKw0KPj4gCWRlZmF1
bHQ6DQo+PiAJCXJldHVybiAtRU5PVFRZOw0KPj4gCX0NCj4+IC0tIA0KPj4gMi4yNS4xDQoNCg==
