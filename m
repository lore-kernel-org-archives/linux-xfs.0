Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B528C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Mar 2022 07:20:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231362AbiCWHVk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Mar 2022 03:21:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233545AbiCWHVj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Mar 2022 03:21:39 -0400
X-Greylist: delayed 64 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 23 Mar 2022 00:20:09 PDT
Received: from esa13.fujitsucc.c3s2.iphmx.com (esa13.fujitsucc.c3s2.iphmx.com [68.232.156.96])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C42E373055
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 00:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1648020011; x=1679556011;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=2PmTupBbObE1DpuZ1dwusgrqnJbMNIYhTPan62wTXJA=;
  b=uQIE4E1ah4/yLK8hH/wq0M3xFyNqbcZzwgIKfsMig3IFq+7u8K7P3aAg
   arv9qQommFm6/iEQt4niPNPV16zb12YJM/7Khop/ndaASkBCsUr+NNRaY
   5k5+PB8rmP+JTgljMxJHCANzSA94m0SobhBYSqPxDRnjTV4IrR3yUZ+wz
   WTg1/NfzF9mJp0S6pOVRmdgFtGb9NWmyz9qDfvlzUQST15LVkgRALNw5S
   D/kqa2exPbXGtORmzray21UbuNrZGSofUWFpa8EX1BorPTyX8Wxai6bJQ
   BQyHgl0AcWDk6VPpQdd67k1VXpXHefshm182oeQbEJ8rUJv13SovxNT71
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10294"; a="52126939"
X-IronPort-AV: E=Sophos;i="5.90,203,1643641200"; 
   d="scan'208";a="52126939"
Received: from mail-tycjpn01lp2176.outbound.protection.outlook.com (HELO JPN01-TYC-obe.outbound.protection.outlook.com) ([104.47.23.176])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2022 16:19:03 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bIhrepP+7i7SuUw4l6JOPg7W5KphNdCQwCx5Vbr3R8lkiVR18KrkVaODRQXmoIrNjNZX6DgCm79hqkLCrGAE+XebgM+ADX3g1ccDDsCTw0jvSwf5OL5SfNIjPMlCslQqsqXnBMZePoNPd96/9qTF/bvaxv0fqNkUXulaTt6kBGo/pBT+EMDPzRcaS1msV+kqTXRCSoZ/IhIST0Q9z+CAOdi5CxC3yextbcwkiGbnSAFzYmu/cGmhq4qJwN7jbd2C0yDVRJJxnfiyJioL3bILx/wpEe/wxNcntPxnIYqAtLs4Knthj7hR+FT+euiJZKv2qFWcrgiKMFm1ezAwznEwPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2PmTupBbObE1DpuZ1dwusgrqnJbMNIYhTPan62wTXJA=;
 b=clIYMUOPEZsHe4EHu4qHwWGoRJhP3QHFGOCgHIQoRltLTFBtT8VPSGxPbvU/wsDSnFrlFLknmQTk+FY7mSdbC7QqPmDeXpSG2hUbmJGEN03La12fYtf0p9iG++bbqHFbdRNVTXJRxt/RH+1UJf248WzVG+1wlHKLwAXGwGPisvBH9MxVxX3peDstZleqqQH3jZjrXefy+RziIHTrjAliW7wynHU88AVXW81ztZNSmEFDMGok3D1X+hT1mHd7a0rLDQWoAw0mIO1jrAsh3QhCCqPTwDH8PZ+6YZEsshZmJ5Ou+lMJs8rmdN5TwUjLUKOJc2xfTeFyX0okzPAh7z3wPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fujitsu.onmicrosoft.com; s=selector2-fujitsu-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2PmTupBbObE1DpuZ1dwusgrqnJbMNIYhTPan62wTXJA=;
 b=aOQulevIs9UVj5Rkw1uFl1K6ka+x7IBzWCQ8rgk0118QXNqHfgY7u3nfGhQFzizn9fPB54cnChhve5edfCOLp00FqKv+H13Z3jOsyBhqFDY33P3WHoDHn5PPNh4461ElAVCPSG0YR65rLiN+NjS24V94JquWHpJaT+IW3Q8e/2g=
Received: from TY2PR01MB4427.jpnprd01.prod.outlook.com (2603:1096:404:10d::20)
 by TYYPR01MB7085.jpnprd01.prod.outlook.com (2603:1096:400:d0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Wed, 23 Mar
 2022 07:18:59 +0000
Received: from TY2PR01MB4427.jpnprd01.prod.outlook.com
 ([fe80::dd2e:e671:b3d5:d354]) by TY2PR01MB4427.jpnprd01.prod.outlook.com
 ([fe80::dd2e:e671:b3d5:d354%6]) with mapi id 15.20.5081.023; Wed, 23 Mar 2022
 07:18:59 +0000
From:   "xuyang2018.jy@fujitsu.com" <xuyang2018.jy@fujitsu.com>
To:     Dave Chinner <david@fromorbit.com>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "djwong@kernel.org" <djwong@kernel.org>,
        "pvorel@suse.cz" <pvorel@suse.cz>
Subject: Re: [RFC RESEND] xfs: fix up non-directory creation in SGID
 directories when umask S_IXGRP
Thread-Topic: [RFC RESEND] xfs: fix up non-directory creation in SGID
 directories when umask S_IXGRP
Thread-Index: AQHYPcNfselsqwhzC0yUXxz4p072iKzLFj0AgAALLwCAAW/YAA==
Date:   Wed, 23 Mar 2022 07:18:59 +0000
Message-ID: <623ACA1C.9050203@fujitsu.com>
References: <1647936257-3188-1-git-send-email-xuyang2018.jy@fujitsu.com>
 <20220322084320.GN1544202@dread.disaster.area>
 <20220322092322.GO1544202@dread.disaster.area>
In-Reply-To: <20220322092322.GO1544202@dread.disaster.area>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ca306e23-661a-4592-0424-08da0c9d6671
x-ms-traffictypediagnostic: TYYPR01MB7085:EE_
x-microsoft-antispam-prvs: <TYYPR01MB7085759046FCF921631C6897FD189@TYYPR01MB7085.jpnprd01.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3Z69CP8XQ3kRugHE4b+O7fWTuI8LN5jFl+50N4RadJBwr6cam2KUkvzRmgPF6qB50iDwSWr37rd6Ozacm7clTQuMCp4UYUPxzu6rDHADlGcpGjpzJRFyrhjZB8EgjqRAXE8/OlybrXBOCW+3IdrHIunpOCoG1A42LlvKDbTKL61c4gcrvKWd3wHBJnImtv5g4iYkK1GnUNDxPYsZNTx+YhmGFAv+yCCHVjPAM0aBETwwh+bZ1Ef4XF1ZpKFvwUdz2voH36IECMtDFRt3hjBTfuPtgViK7/GWt7obIZkf053Bm+wJj8q+lf8ORjYFqU0Mi/Uw4ZoTa/H16uq01IuzOvthGu99OromlQRa7YsgzqL9ve9NQmJvfDXXIquOVtlobPh6NyBuQZG8P5HoHBTKMfhGIISUyzhq0Q/cbK2sei2Wj64wQzXweP7oY+M/7IPACb+ImbUam5XOrTgqgLV6o2eOjR5FyMW28iV2UcMreUHMJ7Lx0voX9TNB5XFosmnLW7GlGR+fnNkO5xMmOVVoznw/Z+pM9p7FTsfB7CpZ4JP6KgeBalglpFjiU1DmDI4Yam3URVOdSUtOTifyilqzLh+v/lqSt4/0WtAn6NNz2G3P2JI6zsUyUHJ/fi1EaqFJ30z8Yum/wmKizdy5K3Fsab4lgCu80j5X/Y07714e6PdaBtEZwEH0f++SKwdPxINhC04LXi+MyNC3e51wnWbjfQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB4427.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(54906003)(38070700005)(122000001)(85182001)(71200400001)(8936002)(83380400001)(82960400001)(5660300002)(508600001)(66556008)(66476007)(66446008)(66946007)(4326008)(6486002)(91956017)(2616005)(186003)(2906002)(26005)(87266011)(6512007)(6506007)(316002)(6916009)(86362001)(36756003)(8676002)(76116006)(64756008)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?SWpMQ1gzT1NnaXlLYmtQQmZvWnpCazZxaU1BbWppU2I2ZEVueUR1dFRlU1lD?=
 =?gb2312?B?TFoyMFNmRHJmZ0FEZG8xZDZ3ZnpvbGxmTnovejVFQnF4SDNUL0VScXdiSllt?=
 =?gb2312?B?aS9MNGcwdDlmdEJleCtjUDdpWWFhb3hBRHpWRm1wMGFwdFh0TEVtOXMrL0c3?=
 =?gb2312?B?WCtITDhuVk9PK28yUmdIR05qTVhyWE5XZHBkYmF1eWRxcEs5WW1TelN1TEtr?=
 =?gb2312?B?T1FUc3BXWEFyWGpYN0N1YTZXYmpvWlVxSkJwWk1BL0c5eFBLbmtibVpZUnZi?=
 =?gb2312?B?USs4S2FHeG83dWFvOHg0c2NwWHd3ektmVGFxSE5vN0JabnVGVTcwRzFCR1c2?=
 =?gb2312?B?YVBkbFc0N0lHQVFxUHhkbW5XVXpzMStDRGg0ckRTelgzL0ZJdDF3OUNpbHhL?=
 =?gb2312?B?WGVYKzg1RnpSZnNqSFpmMHF2NGt3MXJjdmhtVHBla3VneFBHZXA2Wjh0V0cy?=
 =?gb2312?B?bkJqMGQ2YUt6STlhcWJQeU1QRG5tSXhkTWx3NVhQTXQ1UDdYUWNEb2l2Tko0?=
 =?gb2312?B?S0hydDVEbFEzRzlGenp0My9NRGpzbklyWGhscEJaS0ZtUVVzNmxSRE9PYlBU?=
 =?gb2312?B?TkhnMVhGNG5za1owaUNHMFhuZ0FSNjBBVGV3YmQrUFp3ZFh5aU9xQkhRWXpo?=
 =?gb2312?B?bzZneXlNMCszK0ZndytoODVYUXlUeFhZYUNiOUQxQlZuTmVpTWM4RzZMMHFN?=
 =?gb2312?B?V1V2NVc1YWRVa3JCckxieEtwNkRxWjhOWWZrR2ZkSDEwbjJScFdkbndlUXN6?=
 =?gb2312?B?Tkd2cXdqS0tQT1ByY0U0SVhyaW1VZXpIRSt0S1ppd1RVb21KUGhtSkZtajVq?=
 =?gb2312?B?alZ3MUI4anY4V2JaODFMMmZnVXRDNWRJWDFuai94NHQvd2t0M3MvVFU1Mkw5?=
 =?gb2312?B?TUhKa2ZCQ25oRktNSWRsTU43SGhFbGI0UXpkWFpvUDJoT3hsejNxRmdkcVZs?=
 =?gb2312?B?Y3dLTTg3bXVKV2Qvcm5rdm5yV3VDc0hwTFplZC9mRGM3VHR0NEovZ2YxQXFh?=
 =?gb2312?B?TUF5OXNwa2FaMHNyMTRnNVBocWg1bzFzMlAvODZRNklnSXRKTXBsTVp4Q2RJ?=
 =?gb2312?B?Y21ZcVlXUkFtLzhKZjVHZURERFNQK0hNcFNMenJnb1lOdUh0QWFTNExjaHpl?=
 =?gb2312?B?WTN1VVhDUVE1a2xhemZVOWV1ZjJOREYvKzRHblNYTG1jV0pwRUVzNzNFREpQ?=
 =?gb2312?B?T1ZZdHV6Z1ljNnNvcE1jRExYTERlU0taSDRUT0ZZUjhIQllUM2lhL1dpczV4?=
 =?gb2312?B?YTZxNjdoaDNHN1VCSXc5Z09zSFN1NDRIT20yOHlLYlI5REY4M2dLZkpFWWFP?=
 =?gb2312?B?eFRGeGtNa1dIZWZhbFR3WlIyRjl4KzdVV3ZRR2hrZVlVMFZnc0lYcS8rTEly?=
 =?gb2312?B?b2pQZ0FnbkdOZmQrdEVZZFpkRHJ6N1pSRmppNjlNR1dPVWEwMmtqcGdYdHVp?=
 =?gb2312?B?cTJVVzJVVG1tclVTSlI5cys3cmlBT00ySFpBSHgyQVk4Zjlqc2VoNXNHL0FM?=
 =?gb2312?B?dzZ2MVlDSUJJOHJZbnFXMTRSK3BFT1Fvd2xrM3lhV2J1a0dOSi80d0EwaVls?=
 =?gb2312?B?ZlJRUGpsay9uWGNobkJHbmlHZU4rWDlmQVZ6Sk1Zb1p1ZGV5SXpUazhHMUJw?=
 =?gb2312?B?a0dMOVlnMDg0TUF1YnhkajJka0dES3JWTzg3dThES1hxQjZtNjFpb2hyWG5O?=
 =?gb2312?B?bUhHRTZYdFNDVDVqZ2lNRVBEd3dtaHFyQVUzeXN3MlJ3WWc2KzI4Rlg5eWZi?=
 =?gb2312?B?RlY5TVBCRW1uNXdLR2ZLTElqYzJCVklGKzlqKzBNSVp3UEdhSE9BNy95ejlW?=
 =?gb2312?B?VE85bDZvVCsxOFlJWmhiUFRBeFBFWndvdjBGSURSMGJGWS85YUhFZ25kUWdu?=
 =?gb2312?B?NVJqeTJrM0RGOWtWWGtYTVNuMmpCekM2NWdLMi9ENTZ3Q0RibWxmM1M2VHBy?=
 =?gb2312?B?NG9JaGVxVHhXVVo1eEVkVWgvVUE2QjhoNHNidm5FTlhpa2cvQVJ2c2I5Y3NR?=
 =?gb2312?Q?xR0CsQRSVvW+rOtopn1vHVIK/2aXTg=3D?=
Content-Type: text/plain; charset="gb2312"
Content-ID: <D4BA05081BDA664C84E258BB51508E72@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB4427.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca306e23-661a-4592-0424-08da0c9d6671
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2022 07:18:59.4115
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: neH/r0ZcS7MXwIVensbjW+V3lE0I+F6nQICUkk+83nNukLcxgcZO6tp187R398QTcg2ujfBjYHcDsEAUbJ+Xt8JPh4og3Lkaiupn0Boe4NY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYYPR01MB7085
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

b24gMjAyMi8zLzIyIDE3OjIzLCBEYXZlIENoaW5uZXIgd3JvdGU6DQo+IE9uIFR1ZSwgTWFyIDIy
LCAyMDIyIGF0IDA3OjQzOjIwUE0gKzExMDAsIERhdmUgQ2hpbm5lciB3cm90ZToNCj4+IE9uIFR1
ZSwgTWFyIDIyLCAyMDIyIGF0IDA0OjA0OjE3UE0gKzA4MDAsIFlhbmcgWHUgd3JvdGU6DQo+Pj4g
UGV0ciByZXBvcnRlZCBhIHByb2JsZW0gdGhhdCBTX0lTR0lEIGJpdCB3YXMgbm90IGNsZWFuIHdo
ZW4gdGVzdGluZyBsdHANCj4+PiBjYXNlIGNyZWF0ZTA5WzFdIGJ5IHVzaW5nIHVtYXNrKDA3Nyku
DQo+Pg0KPj4gT2suIFNvIHdoYXQgaXMgdGhlIGZhaWx1cmUgbWVzc2FnZSBmcm9tIHRoZSB0ZXN0
Pw0KPj4NCj4+IFdoZW4gZGlkIHRoZSB0ZXN0IHN0YXJ0IGZhaWxpbmc/IElzIHRoaXMgYSByZWNl
bnQgZmFpbHVyZSBvcg0KPj4gc29tZXRoaW5nIHRoYXQgaGFzIGJlZW4gYXJvdW5kIGZvciB5ZWFy
cz8gSWYgaXQncyByZWNlbnQsIHdoYXQNCj4+IGNvbW1pdCBicm9rZSBpdD8NCj4NCj4gT2ssIEkg
d2VudCBhbmQgbG9va2VkIGF0IHRoZSB0ZXN0LCBhbmQgaXQgY29uZmlybWVkIG15IHN1c3BpY2lv
bi4gIEkNCj4gY2FuJ3QgZmluZCB0aGUgcGF0Y2ggdGhhdCBpbnRyb2R1Y2VkIHRoaXMgY2hhbmdl
IG9uIGxvcmUua2VybmVsLm9yZy4NCj4gTG9va3MgbGlrZSBvbmUgb2YgdGhvc2Ugc2lsZW50IHNl
Y3VyaXR5IGZpeGVzIHRoYXQgbm9ib2R5IGdldHMgdG9sZA0KPiBhYm91dCwgZ2V0cyBubyByZWFs
IHJldmlldywgaGFzIG5vIHRlc3QgY2FzZXMgd3JpdHRlbiBmb3IgaXQsIGV0Yy4NCj4NCj4gQW5k
IG5vYm9keSB3cm90ZSBhIHRlc3QgZm9yIHVudGlsIEF1Z3VzdCAyMDIxIGFuZCB0aGF0J3Mgd2hl
biBwZW9wbGUNCj4gc3RhcnRlZCB0byBub3RpY2UgYnJva2VuIGZpbGVzeXN0ZW1zLg0KPg0KPiBU
aGlzIGlzIHRoZSBjb21taXQgdGhhdCBmYWlsZWQgdG8gZml4IHNldmVyYWwgZmlsZXN5c3RlbXM6
DQo+DQo+IGNvbW1pdCAwZmEzZWNkODc4NDhjOWM5M2MyYzgyOGVmNGMzYThjYTM2Y2U0NmM3DQo+
IEF1dGhvcjogTGludXMgVG9ydmFsZHM8dG9ydmFsZHNAbGludXgtZm91bmRhdGlvbi5vcmc+DQo+
IERhdGU6ICAgVHVlIEp1bCAzIDE3OjEwOjE5IDIwMTggLTA3MDANCj4NCj4gICAgICBGaXggdXAg
bm9uLWRpcmVjdG9yeSBjcmVhdGlvbiBpbiBTR0lEIGRpcmVjdG9yaWVzDQo+DQo+ICAgICAgc2dp
ZCBkaXJlY3RvcmllcyBoYXZlIHNwZWNpYWwgc2VtYW50aWNzLCBtYWtpbmcgbmV3bHkgY3JlYXRl
ZCBmaWxlcyBpbg0KPiAgICAgIHRoZSBkaXJlY3RvcnkgYmVsb25nIHRvIHRoZSBncm91cCBvZiB0
aGUgZGlyZWN0b3J5LCBhbmQgbmV3bHkgY3JlYXRlZA0KPiAgICAgIHN1YmRpcmVjdG9yaWVzIHdp
bGwgYWxzbyBiZWNvbWUgc2dpZC4gIFRoaXMgaXMgaGlzdG9yaWNhbGx5IHVzZWQgZm9yDQo+ICAg
ICAgZ3JvdXAtc2hhcmVkIGRpcmVjdG9yaWVzLg0KPg0KPiAgICAgIEJ1dCBncm91cCBkaXJlY3Rv
cmllcyB3cml0YWJsZSBieSBub24tZ3JvdXAgbWVtYmVycyBzaG91bGQgbm90IGltcGx5DQo+ICAg
ICAgdGhhdCBzdWNoIG5vbi1ncm91cCBtZW1iZXJzIGNhbiBtYWdpY2FsbHkgam9pbiB0aGUgZ3Jv
dXAsIHNvIG1ha2Ugc3VyZQ0KPiAgICAgIHRvIGNsZWFyIHRoZSBzZ2lkIGJpdCBvbiBub24tZGly
ZWN0b3JpZXMgZm9yIG5vbi1tZW1iZXJzIChidXQgcmVtZW1iZXINCj4gICAgICB0aGF0IHNnaWQg
d2l0aG91dCBncm91cCBleGVjdXRlIG1lYW5zICJtYW5kYXRvcnkgbG9ja2luZyIsIGp1c3QgdG8N
Cj4gICAgICBjb25mdXNlIHRoaW5ncyBldmVuIG1vcmUpLg0KPg0KPiAgICAgIFJlcG9ydGVkLWJ5
OiBKYW5uIEhvcm48amFubmhAZ29vZ2xlLmNvbT4NCj4gICAgICBDYzogQW5keSBMdXRvbWlyc2tp
PGx1dG9Aa2VybmVsLm9yZz4NCj4gICAgICBDYzogQWwgVmlybzx2aXJvQHplbml2LmxpbnV4Lm9y
Zy51az4NCj4gICAgICBTaWduZWQtb2ZmLWJ5OiBMaW51cyBUb3J2YWxkczx0b3J2YWxkc0BsaW51
eC1mb3VuZGF0aW9uLm9yZz4NCj4NCj4gZGlmZiAtLWdpdCBhL2ZzL2lub2RlLmMgYi9mcy9pbm9k
ZS5jDQo+IGluZGV4IDJjMzAwZTk4MTc5Ni4uOGM4NmM4MDljYTE3IDEwMDY0NA0KPiAtLS0gYS9m
cy9pbm9kZS5jDQo+ICsrKyBiL2ZzL2lub2RlLmMNCj4gQEAgLTE5OTksOCArMTk5OSwxNCBAQCB2
b2lkIGlub2RlX2luaXRfb3duZXIoc3RydWN0IGlub2RlICppbm9kZSwgY29uc3Qgc3RydWN0IGlu
b2RlICpkaXIsDQo+ICAgICAgICAgIGlub2RlLT5pX3VpZCA9IGN1cnJlbnRfZnN1aWQoKTsNCj4g
ICAgICAgICAgaWYgKGRpciYmICBkaXItPmlfbW9kZSYgIFNfSVNHSUQpIHsNCj4gICAgICAgICAg
ICAgICAgICBpbm9kZS0+aV9naWQgPSBkaXItPmlfZ2lkOw0KPiArDQo+ICsgICAgICAgICAgICAg
ICAvKiBEaXJlY3RvcmllcyBhcmUgc3BlY2lhbCwgYW5kIGFsd2F5cyBpbmhlcml0IFNfSVNHSUQg
Ki8NCj4gICAgICAgICAgICAgICAgICBpZiAoU19JU0RJUihtb2RlKSkNCj4gICAgICAgICAgICAg
ICAgICAgICAgICAgIG1vZGUgfD0gU19JU0dJRDsNCj4gKyAgICAgICAgICAgICAgIGVsc2UgaWYg
KChtb2RlJiAgKFNfSVNHSUQgfCBTX0lYR1JQKSkgPT0gKFNfSVNHSUQgfCBTX0lYR1JQKSYmDQo+
ICsgICAgICAgICAgICAgICAgICAgICAgICAhaW5fZ3JvdXBfcChpbm9kZS0+aV9naWQpJiYNCj4g
KyAgICAgICAgICAgICAgICAgICAgICAgICFjYXBhYmxlX3dydF9pbm9kZV91aWRnaWQoZGlyLCBD
QVBfRlNFVElEKSkNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgbW9kZSY9IH5TX0lTR0lEOw0K
PiAgICAgICAgICB9IGVsc2UNCj4gICAgICAgICAgICAgICAgICBpbm9kZS0+aV9naWQgPSBjdXJy
ZW50X2ZzZ2lkKCk7DQo+ICAgICAgICAgIGlub2RlLT5pX21vZGUgPSBtb2RlOw0KPg0KPiBUaGUg
cHJvYmxlbSBpcyBpdCB0YWtlcyBhd2F5IG1vZGUgYml0cyB0aGF0IHRoZSBWRlMgcGFzc2VkIHRv
IHVzDQo+IGRlZXAgaW4gdGhlIFZGUyBpbm9kZSBpbml0aWFsaXNhdGlvbiBkb25lIGR1cmluZyBv
bi1kaXNrIGlub2RlDQo+IGluaXRpYWxpc2F0aW9uLCBhbmQgaXQncyBoaWRkZW4gd2VsbCBhd2F5
IGZyb20gc2lnaHQgb2YgdGhlDQo+IGZpbGVzeXN0ZW1zLg0KPg0KPiBPaCwgd2hhdCBhIG1lc3Mg
LSB0aGlzIGluX2dyb3VwX3AoKSYmICBjYXBhYmxlX3dydF9pbm9kZV91aWRnaWQoKQ0KPiBjaGVj
ayBpcyBzcGxhdHRlcmVkIGFsbCBvdmVyIGZpbGVzeXN0ZW1zIGluIHJhbmRvbSBwbGFjZXMgdG8g
Y2xlYXINCj4gU0dJRCBiaXRzLiBlLmcgY2VwaF9maW5pc2hfYXN5bmNfY3JlYXRlKCkgaXMgYW4g
b3BlbiBjb2RlZA0KPiBpbm9kZV9pbml0X293bmVyKCkgY2FsbC4gVGhlcmUncyBzcGVjaWFsIGNh
c2UNCj4gY29kZSBpbiBmdXNlX3NldF9hY2woKSB0byBjbGVhciBTR0lELiBUaGVyZSdzIGEgc3Bl
Y2lhbCBjYXNlIGluDQo+IG92bF9wb3NpeF9hY2xfeGF0dHJfc2V0KCkgZm9yIEFDTCB4YXR0cnMg
dG8gY2xlYXIgU0dJRC4gQW5kIHNvIG9uLg0KPg0KPiBObyBjb25zaXN0ZW5jeSBhbnl3aGVyZSAt
IHNob3VsZG4ndCB0aGUgVkZTIGp1c3QgYmUgc3RyaXBwaW5nIHRoZQ0KPiBTR0lEIGJpdCBiZWZv
cmUgaXQgcGFzc2VzIHRoZSBtb2RlIGRvd24gdG8gZmlsZXN5c3RlbXM/IEl0IGhhcyBhbGwNCj4g
dGhlIGluZm8gaXQgbmVlZHMgLSBpdCBkb2Vzbid0IG5lZWQgdGhlIGZpbGVzeXN0ZW1zIHRvIGRv
IGV2ZXJ5dGhpbmcNCj4gY29ycmVjdGx5IHdpdGggdGhlIG1vZGUgYW5kIGVuc3VyaW5nIHRoYXQg
dGhleSBvcmRlciB0aGluZ3MgbGlrZQ0KPiBwb3NpeCBhY2wgc2V0dXAgZnVuY3Rpb25zIGNvcnJl
Y3RseSB3aXRoIGlub2RlX2luaXRfb3duZXIoKSB0byBzdHJpcA0KPiB0aGUgU0dJRCBiaXQuLi4N
Cj4NCj4gSnVzdCBzdHJpcCB0aGUgU0dJRCBiaXQgYXQgdGhlIFZGUywgYW5kIHRoZW4gdGhlIGZp
bGVzeXN0ZW1zIGNhbid0DQo+IGdldCBpdCB3cm9uZy4uLg0KVGhhbmtzIGZvciB5b3VyIHJlcGx5
Lg0KDQpTb3VuZCByZWFzb25hYmxlLCBidXQgSSBhbSBub3Qgc3VyZSBJIGhhdmUgdGhlIGFiaWxp
dHkgdG8gZG8gdGhpcy4NCldpbGwgdHJ5IC4uLg0KDQoNCkJlc3QgUmVnYXJkcw0KWWFuZyBYdQ0K
Pg0KPiBDaGVlcnMsDQo+DQo+IERhdmUuDQo=
