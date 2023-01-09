Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C85F9C5479D
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Jan 2023 09:59:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbjAIJ67 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Jan 2023 04:58:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237071AbjAIJ55 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Jan 2023 04:57:57 -0500
X-Greylist: delayed 64 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 09 Jan 2023 01:55:53 PST
Received: from esa8.fujitsucc.c3s2.iphmx.com (esa8.fujitsucc.c3s2.iphmx.com [68.232.159.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95451E8E;
        Mon,  9 Jan 2023 01:55:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1673258154; x=1704794154;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=I8unJhr2f78zqKL1YMr1azSUXPcAd2/dsYdt2OKBYwY=;
  b=DX4ctFXBo3tZd9v3QX8HRAA7yPAFglmmZ7Lca1NQmnhZp1WBkaGbyQsl
   SnFGxu2bgiEgRp+LiknTPoRRxtRWZhykQCegmqQ2qo06aKrB2n/WCdzeH
   jwl1zKSXCkdQ0bKI+1e420lfsfPMT+G+fc/eX01sR26oTjABsAFn/iafQ
   +NrhVPItgv7UDRA/pFUImsyBMLGz39XigeltkMTD2Ybd/U1DoUpDy9ro4
   zO3Ddox9OMVB8AUVhIiua/PDchEL3y42Oc/ike8bOFIK3MuNnzQ4PK4fB
   CxGuYthFFy2A5uUjwr4yAjW07zgJQZWrUMnkJ4NAp7foD9JqRlcrEmZh0
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10584"; a="74016463"
X-IronPort-AV: E=Sophos;i="5.96,311,1665414000"; 
   d="scan'208";a="74016463"
Received: from mail-tycjpn01lp2169.outbound.protection.outlook.com (HELO JPN01-TYC-obe.outbound.protection.outlook.com) ([104.47.23.169])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2023 18:54:46 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nfoyZwvCnZUzbJy65afxpvkzPIRd+XKjPuFz+rhqSXThfAw5AeHh0+jiJEYQzzcPoWbrAw4Oj9mYcmSfWK+LYLw2SvGFtrBXO19/nIxhvNxYXdT5QbcpwIAvcEjaeHChGsrLfQSg/Uj0xo2vY52ETKqtlkew+mRhJiDK6/yavKyD6i++CVItyHmNu5R7F3dD6vaTxGjItk/CXu5tMilMGjrphEZwWoWN9HD2/vSwYiv+WRKk1tpH7l6oKxmDPtVi4kS3MPh4sn+sJWV0y46+x5+ftmUCNsruCahDLhN7tpGSF+7JKdgvNIf1BADV4W1YJ5NL/sktvq5duAyRkhlxuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I8unJhr2f78zqKL1YMr1azSUXPcAd2/dsYdt2OKBYwY=;
 b=V9/VqgQtaGgusKCDDWGd1R7Z+BU5TefUmVLGid8MQa9sBVnv1kMXyJJSPZuOVpqT5IlmGUiEPMYOFJGfTERKqJHOzq7Dj64Jy/Fkh81fdEzbdAW1wLJ9T423MFxSlaN2C4JUgoDizzdPCr21EfbRh3vuL1WSLyvc0/AcvjLHp0HjEe2uTTwNN8UqU8tATjxpzmXBCUse6sPiyo3mFttG+GtzHDyQwVTk9Lo3ew5eQiVRN7169CxgBtduujlSHPbnLUEjqI9go+ddV0i9o7PBM30mChN+uBslfLhAAxSiml7CJajuPb8LDDuij0M9gdtvQnXYQy27cM9kJUyazCCD4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from TYWPR01MB8313.jpnprd01.prod.outlook.com (2603:1096:400:166::9)
 by OS3PR01MB8209.jpnprd01.prod.outlook.com (2603:1096:604:173::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 9 Jan
 2023 09:54:43 +0000
Received: from TYWPR01MB8313.jpnprd01.prod.outlook.com
 ([fe80::46b4:9cb3:b477:46e0]) by TYWPR01MB8313.jpnprd01.prod.outlook.com
 ([fe80::46b4:9cb3:b477:46e0%4]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 09:54:43 +0000
From:   "xuyang2018.jy@fujitsu.com" <xuyang2018.jy@fujitsu.com>
To:     Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
CC:     "hsiangkao@linux.alibaba.com" <hsiangkao@linux.alibaba.com>,
        "fstests@vger.kernel.org" <fstests@vger.kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>
Subject: RE: [PATCH V6 2/2] common/populate: Ensure that S_IFDIR.FMT_BTREE is
 in btree format
Thread-Topic: [PATCH V6 2/2] common/populate: Ensure that S_IFDIR.FMT_BTREE is
 in btree format
Thread-Index: AQHZDe61Lx7tu/Yu90WjyHCzX2RXb66MdaiAgAAaRACAABkPgIAEpUkAgAS2M/A=
Date:   Mon, 9 Jan 2023 09:54:42 +0000
Message-ID: <TYWPR01MB8313945EC255851E3113BF23FDFE9@TYWPR01MB8313.jpnprd01.prod.outlook.com>
References: <20221212055645.2067020-1-ZiyangZhang@linux.alibaba.com>
 <20221212055645.2067020-3-ZiyangZhang@linux.alibaba.com>
 <c984985a-ec53-9f32-ef93-946b0500bcd5@fujitsu.com>
 <0b95a29d-43ca-ba29-365f-9161a213dc17@linux.alibaba.com>
 <c9355efb-cebe-8efd-8844-1d00d649e602@fujitsu.com>
 <3d9d3d69-4a6b-0661-97ea-facc33149c80@linux.alibaba.com>
In-Reply-To: <3d9d3d69-4a6b-0661-97ea-facc33149c80@linux.alibaba.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: =?utf-8?B?TVNJUF9MYWJlbF9hNzI5NWNjMS1kMjc5LTQyYWMtYWI0ZC0zYjBmNGZlY2Uw?=
 =?utf-8?B?NTBfQWN0aW9uSWQ9NTI0ZmVhZDctZDY4Yi00ZWQzLWFjNWItZWIxYzIzODM5?=
 =?utf-8?B?ZTFjO01TSVBfTGFiZWxfYTcyOTVjYzEtZDI3OS00MmFjLWFiNGQtM2IwZjRm?=
 =?utf-8?B?ZWNlMDUwX0NvbnRlbnRCaXRzPTA7TVNJUF9MYWJlbF9hNzI5NWNjMS1kMjc5?=
 =?utf-8?B?LTQyYWMtYWI0ZC0zYjBmNGZlY2UwNTBfRW5hYmxlZD10cnVlO01TSVBfTGFi?=
 =?utf-8?B?ZWxfYTcyOTVjYzEtZDI3OS00MmFjLWFiNGQtM2IwZjRmZWNlMDUwX01ldGhv?=
 =?utf-8?B?ZD1TdGFuZGFyZDtNU0lQX0xhYmVsX2E3Mjk1Y2MxLWQyNzktNDJhYy1hYjRk?=
 =?utf-8?B?LTNiMGY0ZmVjZTA1MF9OYW1lPUZVSklUU1UtUkVTVFJJQ1RFRO+/ou++gA==?=
 =?utf-8?B?776LO01TSVBfTGFiZWxfYTcyOTVjYzEtZDI3OS00MmFjLWFiNGQtM2IwZjRm?=
 =?utf-8?B?ZWNlMDUwX1NldERhdGU9MjAyMy0wMS0wOVQwOTo1MzowM1o7TVNJUF9MYWJl?=
 =?utf-8?B?bF9hNzI5NWNjMS1kMjc5LTQyYWMtYWI0ZC0zYjBmNGZlY2UwNTBfU2l0ZUlk?=
 =?utf-8?Q?=3Da19f121d-81e1-4858-a9d8-736e267fd4c7;?=
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYWPR01MB8313:EE_|OS3PR01MB8209:EE_
x-ms-office365-filtering-correlation-id: 30c04dab-7779-4b21-3190-08daf227883b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6wJGBfry3ComtB5Dq/4RVzAs0+e5K6EVMYpgDBnfSvj+1oqLaZkwoJKsJOAPdlWFOS9OMq2HGfQQgyatyFVwH/vrv1RPcfifCKQNN4S8D3ylLoMdMgVDHcBJSr/+D/Ln87ricEUZkvaJMi8ByGvuSoT11tb9UQS6PuJ1u4Fm8iQc/oTke8LW/3T9vPe/Ja293lQWno8uAnkw3qD7Caz/ceTWUNU9EaQLOg4LTPz45gXqJpG4OpzAeDf3ZxvmAWxUU5QIUYadB06wLtUMLy2l6/VJF7CfU1FFoUXaVqrJULKRzhpsZxZq6cNHb88G4GbX27n866A/wzhnP6Zf4a9xLsVGp8f3LEplaSYYi5K9vPMkUO/hZ4jcDbvzS2mSE3/Z7phl0k8pI9wpp99Jt5Ahb6r+N1BbEILeLN0ogZH4bgr+WGQqZU7SDRs+4oT/I+ugpVY5roGJAWXvBT5Udir035Ae46+/j9XoObi/4HaRLER0Rla5n5XsqIvkjwhmsvDh/r1yjrV4tf7MP7NzhWwOJZv8Tx9oht6ucst1qdngWzvIkvcnek81F/xkb0TSzbYzK2pQ+XDMCQadDrEJ6eJtvmiUeM581MbM3PG68XCdkTszXYHtwgsCR+1dYjWaw9GDlLsN7KZCiL/uBH1BQ+OIWLUvHvkQ6il6sveFoEh/NDwm66fEWd02ptfZdY5FPDeZGjh7MWy8CH3nFZlOkO11jCB/vN/FVRcvI+Whob2TQ9M=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYWPR01MB8313.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(396003)(376002)(346002)(366004)(1590799012)(451199015)(1580799009)(52536014)(2906002)(8936002)(85182001)(4744005)(5660300002)(66556008)(41300700001)(8676002)(66946007)(66446008)(66476007)(76116006)(64756008)(316002)(71200400001)(7696005)(54906003)(4326008)(33656002)(53546011)(26005)(478600001)(6506007)(9686003)(186003)(6916009)(55016003)(86362001)(83380400001)(82960400001)(38070700005)(122000001)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YVZSK21HYnBmRGNEZE4zZFRNeVJwQmU4aytYU2p2cmd1OXNra05aanVDbDgr?=
 =?utf-8?B?RUMrcGxHaHRaKzl0NW1GZXZQTzNaOTJVR1Y5ZFQycUFPenRjYVh3NHNxQjA4?=
 =?utf-8?B?YjFReDljbVFib1JWTFRwb1NUbnlkUlpWUE4reHFVSkxBUmlkSWJrVFJGQkFK?=
 =?utf-8?B?QmVNVnFVbjFwdUZxRG04MENVUnhRQ2RTME5lVHVqUEFsZmptMVQydEtYUmhq?=
 =?utf-8?B?ZU5LVkFWc3BpRU5HN0ovd1FJNU44aHd3Y1d1L0d5bXV3RTlqcGFsUHFKZ0lv?=
 =?utf-8?B?U21MOWtFY1NTenBHMUZFRzdTczZ1VUwza3lTR0paWjJlcmE2ekRpa1duQjhZ?=
 =?utf-8?B?VHN2MDBIcHkvYk9VcG01WEdqTnJBYkdMYlU3MUt4bDFmOFlxYW45Vko3di9E?=
 =?utf-8?B?YzBjeGJOS2ZGM1E5VFJGdDArY29uU0pvWm4yWTY4SndXZDMydW4xdkhKc1dk?=
 =?utf-8?B?YmwraXZ1UU9qbmpTdG1ldjRKb1gxQzZaRFVaNThHOTQybVkrYzgyTmF4RldV?=
 =?utf-8?B?THFkRmJKbTZVSktwMFVGTFcwUGk1Vk9VdEo1VzEvNFM3Q3FXRUg5T1YraEVL?=
 =?utf-8?B?VWJ0OWJ6SFB3ekFrNi9XQzhZQXM2ZjhSb3IvMTVRYWJQK1V0ejhxUjg0aGUw?=
 =?utf-8?B?aHdpcytoL1BZczhaU3huZFdUMzBJTGhlZkZjd1NLbUt3clhSKzZBNndpM1dv?=
 =?utf-8?B?YmNwaTFUNlU2WlZxSFd2c3NDdDlhZ050bWxlaERjTURFd2VOZ3M1ZDZQeHox?=
 =?utf-8?B?Yy9jYkt1ZE5pR1I4d2phUnBzYWFtZHkrZnE3OFhlWExGME1sYklHUmQybVZa?=
 =?utf-8?B?NitYWHRPUjV6RWhNVGxnT1pLaDM3cjBtaktZNmYzRUVOVDNMUGRaS1A4VDVZ?=
 =?utf-8?B?YTByMDltc0tzRnBLK2xiWkYwVmdQNW5tQ254enNHUGNxZ1dBTFh5WXNpNWRp?=
 =?utf-8?B?STZKWVpjcnBaR3FBZ3pzNU9ibkx3UCthQzhGdS9YNkJQU3FzbTdLTUxhQW9n?=
 =?utf-8?B?bnBPakxoaWNXTW8vNWVGaHBWTkgwVXZVdU0vL08yUzhQdVluUStjdmFKYlgx?=
 =?utf-8?B?RE9FZ1FDWGN6WFFwWlgvREtzUGpzUzF5SVZJZmt2WXRiQ3BCSHFJWlJobmph?=
 =?utf-8?B?MTVOa0hlZnFld016TFFjRDhsaE9Rb29Da2gwTWt1T2pFdzhwUEllK1BQbHpX?=
 =?utf-8?B?c3BnV0Vxcjh3WnZmZEtyZmw3VWhLczZ6UmpvUW5JZERCS0daNlo5cE8wVnNW?=
 =?utf-8?B?RkJ2bUloMUQ5ZEVKY2hvZE0xUGt2NUZSY243VHRnNmZnKzZSeDNTSXNSVjYr?=
 =?utf-8?B?b0czN2dvVHMrS0hjT1VBL01kdVhWOHRXczJnblNTd0JLR3BUMnlQZVAwT1Fs?=
 =?utf-8?B?MWVhaHBjajVpdWhDLyt1aWxtS0FlYUtUZnFINDF0eUdGYkcrVmNSUk0wUDFh?=
 =?utf-8?B?OWNzaWZwd1pLQTdHUThTTmlENnRXVHdydjJ3YmorL3VaNnllY1lNRmNEYWFD?=
 =?utf-8?B?S3E2NXgwMjR0TCtlb2d0U1lITHJSNmtKYmNzNHc1SkNXd3gyM01Mc1BmRHNK?=
 =?utf-8?B?UWZwb3NVZ3lUNEVVditCL0JTS2Vvdnh4TUNzQzBxbkhWYzViSGVJSXhibXoy?=
 =?utf-8?B?YzlSbGtzdldnRHRTT1ZORnhvK2FabVVHYjJNYjNmWmc0ek9YYmZ3a2lFRXlC?=
 =?utf-8?B?N0VlUmFIRW5POGprcHA1QXByaFNaV1VEVC9hODZ2VHBqYytoeFJiUjJzWmV6?=
 =?utf-8?B?a0l2R2hwQ2hQVTFJUzhwM3Z4TzIyTkl2RW9HcFFBNndCL2YzTDBZTVNTYlYy?=
 =?utf-8?B?VWdFRjdLWkg1QVZpTkhadGdSQTMra0dVdHBIeVVkYWU2SzdxazcvUGRGUWlk?=
 =?utf-8?B?ZGZ4MUhYQVQ1cmlHQ1NuWTZyL3BhV3JNMmQ5dVFXMithYTcwb1pNSW5ZeTVp?=
 =?utf-8?B?SGk4YklvT090ZjdjRHM1QXU3NC9KREl3Y1RBbXBCQTdUK2pCMkczVWtEbmNV?=
 =?utf-8?B?SlN5b0M4aVBhdkE0T0llQ1FJeDlTVjhIVWxMT2xsUS9BR29mWkFWaThmR21z?=
 =?utf-8?B?RG9xQ1pZODVkVENEVVhCTEpqWWhKbzRFWU5QTEUrcEJIaGxVdzN1cENzVEFt?=
 =?utf-8?B?OXFTdzdxZ0psME9OOXNoMjFaZXJLQ1dleWVobUwxRjVMSkpnS0FZeUFqZ1BE?=
 =?utf-8?B?ZWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 7porRhciOnaO6Cl6vUT5CnV7VHXCqHVyfUqBAd4E4DXU28V87Nj8+1XIshvDUAnave6pR70eSypT7LqDMZU12AZxUWis+c9iUQUFvFpNNdaGxS/olSwFkP1koQppkJqBW4e5lVlxb6UaTWZ1xHfW9RdJpzK6Ajss4wiVCKrrtdfOfehv4hpyyE45qOWKx672isYT3w2wUTNFiQyHRrcpRWUpMoLrGdKCq45xFn4TTVJhUnO78rsSb+/SFOHdZCuA60omZh3PN80Evl7LfKxFBkSoVEJftvO6R4moJ7VkhEJ6QO0lEZUTuEx2ociST3Tbr717uobs5MHEk/JKXylaIIM7mf9OVvAoI8ML/TBsfnGjUBiLWkTBCyCQBqPVx9uStAHPHq+WV3zgTvEk+yXMeE34SRqz2MgEcmL29WaRUI4LmPDAS0bUSRtH1KSwtnsJuEfTSPP3SKRWnqjMV4As42j5MsWOvrLLe/7a9UySBTjGcajHosHiRX4qABGda/1CCk6NYd9HxprTb9wWQXqXLCx6nFUxnrlmYjrdnR5ysCG7noPWck6+JG2WbfYz9f7+Xg1pW7uGhrhafJnjVDiBeg6is5oeKqyAVigROtTqUVj1lhOMVZkMQZGShCMEuMVRnxk76hVV3jIUTsdArh71BSEDb7bnFyqD4ZveU9aAY7lxyy1YARGcNwVjEH+oiTGBDXv005y5w6s+OH+07RDPMozEeFxEuKf19y1wQlNY0p8SsbOftkFz7DREDKZ40JKMep2dWMrffEBLDWjn8hAVuDlr7FGCd0hoOZz84l0shvOUOAfFdDjejZNQUsw9s9USX1PKFqqMqZiPJ7xeXaWtMMDRIJJRAR9P3SfBKjsZI2k=
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYWPR01MB8313.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30c04dab-7779-4b21-3190-08daf227883b
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2023 09:54:42.9261
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qPNTVz1zzyAsCinS1Y3MKSTdT8ZKk00spzSbtfqUbZknmhkeobxMqR6Xl3JGGIX5cXP6UdqxsXStRbLP/sLfZe78zf9q2Z7QALqrN7iE9rc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB8209
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

DQpPbiAyMDIzLzEvMyAxNzo1OCwgeHV5YW5nMjAxOC5qeUBmdWppdHN1LmNvbSB3cm90ZToNCj4g
b24gIDIwMjMvMDEvMDMgMTc6MjksIFppeWFuZyBaaGFuZyB3cm90ZQ0KDQo+IEhpIFlhbmcsDQoN
Cj4gQ291bGQgeW91IHBsZWFzZSB0cnkgdGhpcyBwYXRjaDoNCg0KPiBkaWZmIC0tZ2l0IGEvY29t
bW9uL3BvcHVsYXRlIGIvY29tbW9uL3BvcHVsYXRlIGluZGV4IDQ0YjRhZjE2Li5iZWRjZGM0MSAx
MDA2NDQNCj4gLS0tIGEvY29tbW9uL3BvcHVsYXRlDQo+ICsrKyBiL2NvbW1vbi9wb3B1bGF0ZQ0K
PiBAQCAtODEsNyArODEsNyBAQCBfX3BvcHVsYXRlX3hmc19jcmVhdGVfYnRyZWVfZGlyKCkgew0K
PiAgICAgICAgICMgYnRyZWUgZm9ybWF0LiAgQ3ljbGluZyB0aGUgbW91bnQgdG8gdXNlIHhmc19k
YiBpcyB0b28gc2xvdywgc28NCj4gICAgICAgICAjIHdhdGNoIGZvciB3aGVuIHRoZSBleHRlbnQg
Y291bnQgZXhjZWVkcyB0aGUgc3BhY2UgYWZ0ZXIgdGhlDQo+ICAgICAgICAgIyBpbm9kZSBjb3Jl
Lg0KPiAtICAgICAgIGxvY2FsIG1heF9uZXh0ZW50cz0iJCgoKGlzaXplIC0gaWNvcmVfc2l6ZSkg
LyAxNikpIg0KPiArICAgICAgIGxvY2FsIG1heF9uZXh0ZW50cz0iJCgoKGlzaXplIC0gaWNvcmVf
c2l6ZSkgLyAxNiArIDEpKSINCj4gICAgICAgICBsb2NhbCBucj0wDQo+IA0KPiAgICAgICAgIG1r
ZGlyIC1wICIke25hbWV9Ig0KPg0KPiBUaGlzIHdpbGwgYWRkIDEgdG8gbWF4X25leHRlbnRzLiBU
aGVuIHhmcy8wODMgd2lsbCBwYXNzIG9uIG15IGVudig2LjEga2VybmVsLA0KPiA2LjAuMCB4ZnNw
cm9ncywgc2VsaW51eCBkaXNhYmxlZCkNCg0KWWVzLCB0aGlzIGNhbiBzb2x2ZSB0aGlzIHByb2Js
ZW0uDQoNCg0KQmVzdCBSZWdhcmRzDQpZYW5nIFh1DQoNCj4gUmVnYXJkcywNCj4gWmhhbmcNCg==
