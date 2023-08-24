Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBF5CEE49A0
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Aug 2023 23:55:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236851AbjHXXyc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236640AbjHXXx7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Aug 2023 19:53:59 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A89DC19BF
        for <linux-xfs@vger.kernel.org>; Thu, 24 Aug 2023 16:53:57 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37OJEVIf007577;
        Thu, 24 Aug 2023 23:53:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=K1AQ71z18MxZQkgdn2zOXy7p4MDBHU3iIe8cqWW+Wrg=;
 b=uZpdu4EET43oL+BdUamlTlkCVl+iOhmnou4Fi+7uaNyBmIz+Ggf1uwhyTYvnBfyBZMi8
 AGqRJjbSf/+LooJ/ZX+ZUkfJ/UVfCYYJaMNEmkRW2LdsoFGVljBiz68++L3in65qkgqn
 L1+Fv3jy+fWWSvToz2k4jjV41qa3qZNggjEXRtSLs+oE4K7KVLhK0AzdBW5olNhmcuPa
 Mgwt+QcZKyjZq+MHyeLtQOZQbvvfej25Csjfau6YcoJmn4ohofUKaW7k0Djdpqo87cnc
 D0TGwgT+dBkq3FEglVe3Pld+qZnpmdpSjSPxJ2DHlZrUkme0u5mcAcdoMNJkvZiJ/Ssk 4Q== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sn1yvwamw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Aug 2023 23:53:49 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37ONeSxp036185;
        Thu, 24 Aug 2023 23:53:48 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3sn1ywndct-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Aug 2023 23:53:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H9BU+A6jT4G8mLVOHKsYa7BOA8COb8gm1HbZqaTr/aKRH7SPw1Nzar3rgJeSUzVd/TdQyfHuezTjOLO1M1Wg0+64udHDXb1LXe1qzQhK9vyxkuaOdS+O5oQhNWujjVuJw43AcmaEPuBfCQysB1YWxDfXZUFPCCK57I83OhNn9R6EV8PrBmwwX6blP+7NYFlaDmCspGxou12Ei4NnJof7JSR4WCjx3zZLLGreqmx7kyeZo4QO36JH/x8IF59CleeosmNIAzdKcfYJgUb1GNGzd6NGJK9xyt0ohJ5Eg8iKoPs7HeNjQ42xNLx1zU7K4BiYGFtjBwleGTBkQTXLcM3IoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K1AQ71z18MxZQkgdn2zOXy7p4MDBHU3iIe8cqWW+Wrg=;
 b=FobmSL602QdIpD4pK4y8Vdeo4rA4vsW0Heay4pm6488pjl3FCgLd+4CC6y+y2A1wqYSpf5gcuRhAP+qU+zezxnVmOPqRWKhz7/TcOP6es6VoSavVeLMEkstLbLqr3GbMokmTNry8HzcnuO2fpLXhR7ewa4viDsctM7qLcdckgothbCLvacfqgy2EB7ldgvwy3zT60RY8BrK+1PArdXPlxP/9tdRGrHylb+PUWMDSb2mF1+Ino8NeYud5stSv+nvgrHvpfBmYiET6ppgkXS8jaQu+aLXf8aYz8PtMfZ9r82ilsUhb2AqNGDrm48y9uzKnPqLexBkyU5mFDWu8czCBrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K1AQ71z18MxZQkgdn2zOXy7p4MDBHU3iIe8cqWW+Wrg=;
 b=C+xmaI/sqe72p7OGtsfWkRF+tEHP43N2tKuIXIIA/BCehi9xcbGp/4hMdITbfPcIe7Y95CVN9S0ciaHvg9U2Ztz/mp6YABHk7A7vMvRHzd3Cd0ONhT7uZlqoI6SimQsqI7cpJ1X+K/AQZvxQoIKHFttu10pGavGdZmaE5TXJYPg=
Received: from SN6PR10MB2701.namprd10.prod.outlook.com (2603:10b6:805:45::20)
 by DS0PR10MB7407.namprd10.prod.outlook.com (2603:10b6:8:15c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.27; Thu, 24 Aug
 2023 23:53:46 +0000
Received: from SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::3730:5db3:bd47:8392]) by SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::3730:5db3:bd47:8392%4]) with mapi id 15.20.6699.027; Thu, 24 Aug 2023
 23:53:45 +0000
From:   Wengang Wang <wen.gang.wang@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
CC:     "Darrick J. Wong" <djwong@kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        Srikanth C S <srikanth.c.s@oracle.com>
Subject: Re: Question: reserve log space at IO time for recover
Thread-Topic: Question: reserve log space at IO time for recover
Thread-Index: AQHZuctArDqu+2gh/UuDZaYn7kAqiq/AN2uAgAAaCICAAE50gIAEAZ+AgAN+qQCAAR5UAIACO3SAgAQL+wCAIA3CgIAJhk0AgAAriYCAARNBAA==
Date:   Thu, 24 Aug 2023 23:53:45 +0000
Message-ID: <A64D6558-EB1D-4C18-A29E-A6E434728344@oracle.com>
References: <ZLcqF2/7ZBI44C65@dread.disaster.area>
 <20230719014413.GC11352@frogsfrogsfrogs>
 <ZLeBvfTdRbFJ+mj2@dread.disaster.area>
 <2A3BFAC0-1482-412E-A126-7EAFE65282E8@oracle.com>
 <ZL3MlgtPWx5NHnOa@dread.disaster.area>
 <2D5E234E-3EE3-4040-81DA-576B92FF7401@oracle.com>
 <ZMCcJSLiWIi3KBOl@dread.disaster.area>
 <BED64CCE-93D1-4110-B2C8-903A00D0013C@oracle.com>
 <3B6E1DAE-5191-4050-BE97-75B4D22BDE24@oracle.com>
 <20230824045234.GK11263@frogsfrogsfrogs>
 <ZOcGl/tujTv2MjEr@dread.disaster.area>
In-Reply-To: <ZOcGl/tujTv2MjEr@dread.disaster.area>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.700.6)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2701:EE_|DS0PR10MB7407:EE_
x-ms-office365-filtering-correlation-id: 39a88b8e-7357-4b5d-cdc8-08dba4fd5aaa
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8U10ZDZy5V1wZZ8Yt6z+zLq6cNftDXDLcZVvcM9Y3DkP1fjPzenOJhAXxoIKcL0rfIiHk8I+09Ja3BC72tOuvxAuBmvscQAn1/4zldm7VZo6f4QJtE15muNvxFOGSfix8NaSqWjjCphvhVlZ7rmSLlaNK+ywr0w43LqSitscK0yZdj/eIBQ68+p5AVcgMkuOm1IAWavRiYPhWu2eAlkImkQRZeysa+2bF0LMBCOOyxSvg9BF8XGDjBfH1dO63qiNQLAVGlYQ7fSGcvZKw22Sw9a0n099wNtpShygffe6BMG0wBansmOmWDIZR5tzQPXfgELBBcyTLPdwUJl+OWTqizeuMilB4YGfGeOX/o9JHTFZxHu9JdrDexE1G81g1S4EYvZamlS8X5o/v66OqQRMsJ+c1sjcFWAAtQmCa22nErl98sGaXZ1wdXQ+DCQbrGEto7jtKThhzBU1sJM7KfxZlv+5ZQI8fgzLPLuF1DlkGEvki3fk6ocyTLiNriVzKFj0YPh/zEUMvBVeCEnT11e+ErOIdJ1XSLf+iaS0VigjWZjlFAC7BbYFTiVjXIedUSGM/GR6j0XAEcEbA3Rh62xBSs8TU7qHdAXH1jI5hpGAUg1f0jebdw9e5i8B5sTchn7vAB80lW2gOyQ5j05YWWJovQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2701.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(396003)(366004)(376002)(346002)(451199024)(1800799009)(186009)(33656002)(86362001)(122000001)(38070700005)(38100700002)(36756003)(6506007)(71200400001)(478600001)(6486002)(5660300002)(54906003)(316002)(6916009)(76116006)(2906002)(4326008)(8676002)(91956017)(8936002)(64756008)(6512007)(53546011)(83380400001)(66946007)(66476007)(66446008)(66556008)(41300700001)(107886003)(2616005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bWhQamdYRndPbEFCNzFXT3FEb2tneFdYNDlpdXhqRTlwTXdXOG5YVlNjbDRL?=
 =?utf-8?B?TGU5TXVlUkMzQXp6ekxqSnJsNGVGL1JrOWpsSk9vQlR4dnFtamJISWlwd3Vx?=
 =?utf-8?B?NktkYmNZYTlYUElVK05EbmZxbkhSNWZMd2hXdTB0UnRMd3FWN1FJMXBCZ1M3?=
 =?utf-8?B?N1FMU280eHJmWnBRemtsakw3MldpNEFyNXhra1pJeDJYWGJFeVR1Q3h6aldG?=
 =?utf-8?B?cGcyYlVQZFlqYWFSdzdDT3EyQk0wWjUwbDcrTDMxWmUxa0hJTGtzRSt0ZjJX?=
 =?utf-8?B?bThtQmpPam9vU3p5UFhGelRWSzA4a1JqSzB1MnRybzdBdjdpWEt5RmZhZzl6?=
 =?utf-8?B?eXdWQ08veXU2WFR6WWhqMDRvaDcxdHNtZlV6aS9GbkFtRW9ZUis4M2tJdDV4?=
 =?utf-8?B?TTM5VnNraGx5bis0VVphbms2R0dmOUEzL0RLWHpnVmswYUhJSEtoUWZiUWpT?=
 =?utf-8?B?VURDeE1aditWYTFsTnNtWU05QmFBNUliSGY1dW1OOWNoQTdob2Uwb0Y4TE5V?=
 =?utf-8?B?SWFpWUZaTjhlUG9UaUdIMUZpUS9LZFU1TXk1MHpCOVV1MTNTbDlZeHlLaTJk?=
 =?utf-8?B?SU9WeGhpRS9NQlA2Vm9jZG95ODFRQ3pNV0ZOb1A5Smd6ZkZpZnJaR2pjbDZh?=
 =?utf-8?B?bnMvMkpjeHFMYTVBZjFTZTl3dnYwMVRkVkNTeC9CaWZ0T0JQNTA0Mk1YM0R6?=
 =?utf-8?B?cFlqVUtCUmxFeGdqU0ZqdDI4OExQNXFWUmpFZmw1NkJrRDg1VXFIMW03RHZM?=
 =?utf-8?B?RW9aQ0tPSzE4ejg0MnFBbGZra0R0eE1TR0hIeFpOQ1NyVGdmL0pFOFZJMnRs?=
 =?utf-8?B?Mk84ZEJaaFZCYTNmdE5ySHdPWnBRZU9xdEw0bmhyQVBneEtGb29ML3dCc3Rx?=
 =?utf-8?B?WTJSQWsyNkZLSy9WVzNCaTUwcjdFSzRzM1pwd1pHUnZjUXY1RlpQa0lad1BP?=
 =?utf-8?B?eW9XV1A5am8yM1VwS1RxcXcwQUJ5Wm92ekNVTWx1TjJFNVNBYldDcCt4aGRt?=
 =?utf-8?B?VTZiZXVXczJ0RVpSNEVja3YrMlhQMUs4V1N0OFl0VExzRHFCY2hMbDBIcjd6?=
 =?utf-8?B?VUduOVpxYjJuazR1bi9QbVF5Z2IrTFI1YXcvbkFCNWlOUVJhZmdjZ2VQa3lz?=
 =?utf-8?B?by9vL3hzeWxvc29PM3lLbEJhSE5wTER6c0JKTDUzdGIwNldGa0ZCb3NRbzQ3?=
 =?utf-8?B?cUtpOTk1cFpWT1BnUGZOYWZwZjlhV09uRm1Ub3BFUGFLdTF5ei9sdS9WZ2s1?=
 =?utf-8?B?a0J2WFZoeUQzNnNidmJjYWZnV3dEMGNUSFd0NnZMWFI4c2JiYVBuMHc1bUsr?=
 =?utf-8?B?ZEJmZFgvdUpnOHduYW5aZlVIamtBQXhJenFaRGRWQ2xrczd0VW43ZXd2WDNn?=
 =?utf-8?B?VTNRT0E2NElXUG5zUXFRZEg5RFA1L0VQMVJuSHZmQzloaHBEU1hwNzU0MjR0?=
 =?utf-8?B?d1F3aGVFMDdUWWJFdWFyUFQvTVd5V1lPRnB3WDY4TlNqNk1PZkMxY3pJU3Mr?=
 =?utf-8?B?cy9hUC91U1lrQkQwSHkxelU1V25DNWQzbU9qTTVtUnVoU09vMVBxWlQvb0x3?=
 =?utf-8?B?M3BtUERXemt2K1ZlVktkV243ZHZjakdIYzN4NUFsNHVRVUtldWN4SmdmeWRU?=
 =?utf-8?B?UFRhNExsTXVEQi9EN0piNmFBWFkvWkZsWXdxMjZXbloyT1JWOHVlZGtNNlpL?=
 =?utf-8?B?aG5HbmZrQTd2OTR4Tm1kSW5kN21zOXV3dzhTd29HdzJHd0VlV2d3WG4xK0lj?=
 =?utf-8?B?MHVmRk5qTnhteEo2aU16MkFrUitkWmdJY2VycWpjZFoxanZ2R25nUVptM1pW?=
 =?utf-8?B?a0Zpdm9FZWFiaDVtRngrb1d4N01walRaS0lvbnRkNXRhblRjSEo1NUNaTC9D?=
 =?utf-8?B?c3FEUU1VdlVXUE8zOWtTM0tseVEvaWYvcXhmUmJQait6MEpJVW14UXlzVVJx?=
 =?utf-8?B?SjdIMkF1Z01mN2RrME1nZVpva2VVNHh6djdJOENyOUlLRVUrcGI4UTlIamFY?=
 =?utf-8?B?d283MWNtc2N4NWh5elowOE10eVNwejNYMzk3RnQ5YkZWRVl5ZnlPZWJSSzBt?=
 =?utf-8?B?c0hxcTRRUW80U0JmT0xaZWlna05KbldDY2VlcGZ6Tyt2cm00ckg4Y2YxTXZ6?=
 =?utf-8?B?RDZ0RnEzS3MzZnlnMUZGOWhNa1JTVjFrYmR5bUtLbW9JYXcwcUhYN3J2MUs5?=
 =?utf-8?B?TlMySGhrRkhmVlZGVHU1S091UE9hRTFMd2d5Unh1N2VzTXR1UkZXSzhwUjZn?=
 =?utf-8?B?VkFSbG1qUXZnK1UyMEtjREhUMDRnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <61D3CBA4D21330419926830055ABF3E3@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 33gm8BCc1w0AAIFC5rOCHnsjT6shbyJST7pS8LY0gTyTd4EOfieqIH6wL8rZf2JGVIvoHmDlZ84CBfRVUt83tTOhFFH2PiwnRjxZWRrvroq9r9bv4junUyhnFi13hfgfMy7FAlE/uIPEaW217tCAP9BfAHxxSDet+Br/vcGslHyzcSiG+5O9ZoXjIVQEyRWqeFUekj3cy2jDoihM3FdwNzU6oqWriQVccrT8OjyD9ERk3dmmAGcNS7qi1fsPjGOpmcm1WQ2m2IxsFiq9dKNXXngCo7f9Hhrh265o8eR3wlQxssZLfwb9/wD4tv0xlOlUn4GHtIN6fiWpyLXxTDbA4vVaexb7h5N+YjxEyE5SbGHyJK+IcCtqcQRKa1AjuJQP7yaOszCK4+tRP6laZq3cDJVeX771Eo44mKzJiLU7oCnI9yS6B1BxRxKS+btTm2Pz+KBRfNprGmPRLoliQOCYfitExW8mN4THwHHO5EqbuSu/5h9fXOavMct73sYm7K85zEyDk4H4NIdr1j+nKWSlmRPmX1uKNUK03qEfhWUW5Vg51v2+s1CSTl4+BidbLBTdbJAbAZKRcrqq/YEQXwtq2j+/LMltcNPEX4NQyro+dFT+b/pJWkBpAnI7x9jgDB0GGV8pOHWW4GfrFOVxC6lDeZo4aFDD5cVzQTrSCGw8ICzEBy2o0GfRj8HvzViggJh44wZLMCVDUaDM+qDAUttDxtJrrPZD8AN54CvJ7WDMjOI7gKI/nLvOg8/SRFZlMKv4nQlaj+6890+i5l7CjluqzSyWo9WBdgFhscxI6d8kLD3e8zQxG5v04qMOr0T4FYxUV3z9eJnNHwP+6FMTT+CDrA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39a88b8e-7357-4b5d-cdc8-08dba4fd5aaa
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2023 23:53:45.7860
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GUwWwh6bhoOAaFfopkrkcUbDERGfwqiM3eXdPdevqQ0wDh1Z75TU8Y9Uldf7fMMe4rjDr5ZO1VL0lWB5yg33bjjcTZGpJ9AvXAzVWNMhh/Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7407
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-24_18,2023-08-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 spamscore=0 phishscore=0 mlxlogscore=999 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2308240209
X-Proofpoint-ORIG-GUID: f7Zx94rDLFmN2blIjY4_0NxJM0aTSikm
X-Proofpoint-GUID: f7Zx94rDLFmN2blIjY4_0NxJM0aTSikm
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

DQoNCj4gT24gQXVnIDI0LCAyMDIzLCBhdCAxMjoyOCBBTSwgRGF2ZSBDaGlubmVyIDxkYXZpZEBm
cm9tb3JiaXQuY29tPiB3cm90ZToNCj4gDQo+IE9uIFdlZCwgQXVnIDIzLCAyMDIzIGF0IDA5OjUy
OjM0UE0gLTA3MDAsIERhcnJpY2sgSi4gV29uZyB3cm90ZToNCj4+IE9uIEZyaSwgQXVnIDE4LCAy
MDIzIGF0IDAzOjI1OjQ2QU0gKzAwMDAsIFdlbmdhbmcgV2FuZyB3cm90ZToNCj4+IA0KPj4gU2lu
Y2UgeGZzX2VmaV9pdGVtX3JlY292ZXIgaXMgb25seSBwZXJmb3JtaW5nIG9uZSBzdGVwIG9mIHdo
YXQgY291bGQgYmUNCj4+IGEgY2hhaW4gb2YgZGVmZXJyZWQgdXBkYXRlcywgaXQgbmV2ZXIgcm9s
bHMgdGhlIHRyYW5zYWN0aW9uIHRoYXQgaXQNCj4+IGNyZWF0ZXMuICBJdCB0aGVyZWZvcmUgb25s
eSByZXF1aXJlcyB0aGUgYW1vdW50IG9mIGdyYW50IHNwYWNlIHRoYXQNCj4+IHlvdSdkIGdldCB3
aXRoIHRyX2xvZ2NvdW50ID09IDEuICBJdCBpcyB0aGVyZWZvcmUgYSBiaXQgc2lsbHkgdGhhdCB3
ZQ0KPj4gYXNrIGZvciBtb3JlIHRoYW4gdGhhdCwgYW5kIGluIGJhZCBjYXNlcyBsaWtlIHRoaXMs
IGhhbmcgbG9nIHJlY292ZXJ5DQo+PiBuZWVkbGVzc2x5Lg0KPiANCj4gQnV0IHRoaXMgZG9lc24n
dCBmaXggdGhlIHdoYXRldmVyIHByb2JsZW0gbGVhZCB0byB0aGUgcmVjb3Zlcnkgbm90DQo+IGhh
dmluZyB0aGUgc2FtZSBmdWxsIHRyX2l0cnVuY2F0ZSByZXNlcnZhdGlvbiBhdmFpbGFibGUgYXMg
d2FzIGhlbGQNCj4gYnkgdGhlIHRyYW5zYWN0aW9uIHRoYXQgbG9nZ2VkIHRoZSBFRkkgYW5kIHdh
cyBydW5uaW5nIHRoZSBleHRlbnQNCj4gZnJlZSBhdCB0aGUgdGltZSB0aGUgc3lzdGVtIGNyYXNo
ZWQuIFRoZXJlIHNob3VsZCAtYWx3YXlzLSBiZSBlbm91Z2gNCj4gdHJhbnNhY3Rpb24gcmVzZXJ2
YXRpb24gc3BhY2UgaW4gdGhlIGpvdXJuYWwgdG8gcmVzZXJ2ZSBzcGFjZSBmb3IgYW4NCj4gaW50
ZW50IHJlcGxheSBpZiB0aGUgaW50ZW50IHJlY292ZXJ5IHJlc2VydmF0aW9uIHVzZXMgdGhlIHNh
bWUNCj4gcmVzZXJ2YXRpb24gdHlwZSBhcyBydW50aW1lLg0KPiANCj4gSGVuY2UgSSB0aGluayB0
aGlzIGlzIHN0aWxsIGp1c3QgYSBiYW5kLWFpZCBvdmVyIHdoYXRldmVyIHdlbnQgd3JvbmcNCj4g
YXQgcnVudGltZSB0aGF0IGxlYWQgdG8gdGhlIGxvZyBub3QgaGF2aW5nIGVub3VnaCBzcGFjZSBm
b3IgYQ0KPiByZXNlcnZhdGlvbiB0aGF0IHdhcyBjbGVhcmx5IGhlbGQgYXQgcnVudGltZSBhbmQg
aGFkbid0IHlldCB1c2VkLg0KDQpIaSBEYXZlLA0KSSB3YXMgdGhpbmtpbmcgdGhlcmUgaXMgYSBw
cm9ibGVtIHByZXZpb3VzbHksIGJ1dCBJIGRpZG7igJl0IGZpbmQgYW55dGhpbmcgd3JvbmcuDQpQ
ZXIgbXkgdGVzdCBhbmQgYW5hbHlzaXMsIHRoZSBjaGFuZ2luZyAoYWRkaW5nIGFuZCBzdWJ0cmFj
dGluZykgdG8vZnJvbQ0KeGxvZy0+bF9yZXNlcnZlX2hlYWQgYW5kIHhsb2ctPmxfd3JpdGVfaGVh
ZCBtYXRjaGVzIHRoZSBjaGFuZ2VzIG9mDQp4bG9nLT5sX2N1cnJfY3ljbGUvbF9jdXJyX2Jsb2Nr
LiAgQW5kIHhsb2ctPmxfY3Vycl9jeWNsZS9sX2N1cnJfYmxvY2sgbWF0Y2hlcw0KdGhlIGRpc2sg
bG9nIGhlYWQgY2hhbmdlLg0KDQpBY3R1YWxseSB0aGVyZSBpcyBubyBwcm9ibGVtIGF0IHJ1bnRp
bWUuIFdoYXTigJlzIHdyb25nIGlzIGp1c3QgdGhlIHJlY292ZXJ5IHBhcnQuDQoNCkFzIEkgc2Fp
ZCBwcmV2aW91c2x5LCBpdOKAmXMgbm90IHRydWUgdGhhdCB3ZSBhbHdheXMgaGF2ZSB0aGUgZnVs
bCB0cl9pdHJ1bmNhdGUgcmVzZXJ2YXRpb24NCmF0IGFueSB0aW1lIGR1cmluZyB0aGUgcHJvY2Vz
cy4gTGV0IG1lIHNob3cgdGhlIGRldGFpbGVkIHN0ZXBzOg0KDQoxKSBXZSBkbyBmdWxsIHRyX2l0
cnVuY2F0ZSByZXNlcnZhdGlvbiBmb3IgdGhlIHR3by10cmFuc2FjdGlvbiBjaGFpbiAoaGFsZiBl
YWNoKSwNCmFuZCBnZXQgdGhlIGZpcnN0IHRyYW5zYWN0aW9uLg0KDQoyKSB3b3JrIHdpdGggdGhl
IGZpcnN0IHRyYW5zYWN0aW9uLCBhZGRpbmcgbG9nIGl0ZW1zIHRvIGl0LiBOb3cgd2UgaGF2ZSBm
dWxsIHRyX2l0cnVuY2F0ZQ0KcmVzZXJ2YXRpb24uDQoNCjMpIGluIHRyYW5zYWN0aW9uIHJvbGws
IHdlIGdldCB0aGUgc2Vjb25kIHRyYW5zYWN0aW9uLiBUaGUgc2Vjb25kIHRyYW5zYWN0aW9uDQph
bHNvIGhhcyBoYWxmIHRyX2l0cnVuY2F0ZSByZXNlcnZhdGlvbi4gIE5vdyB0aGUgZmlyc3QgdHJh
bnNhY3Rpb24gYW5kIHRoZSBzZWNvbmQNCnRyYW5zYWN0aW9uIHRvZ2V0aGVyIGhhdmUgZnVsbCB0
cl9pdHJ1bmNhdGUgcmVzZXJ2YXRpb24uDQoNCjQpIHN0aWxsIGluIHRyYW5zYWN0aW9uIHJvbGws
IHdlIGNvbW1pdCB0aGUgZmlyc3QgdHJhbnNhY3Rpb24sIGluY2x1ZGluZyBFRkkgbG9nIGl0ZW0o
cykNCiAgICBpbiBpdC4gVGhlIHJlc2VydmF0aW9uIGJlbG9uZ2luZyB0byB0aGUgZmlyc3QgdHJh
bnNhY3Rpb24gd2VudCBpbiB0aHJlZSBkaWZmZXJlbnQNCiAgICB3YXlzOg0KICAgMS4gc29tZSBh
cmUgdXNlZCB0byBzdG9yZSB0aGUgbG9nIGl0ZW1zIChhbmQgdGhlIG5lY2Vzc2FyeSBoZWFkZXJz
KS4NCiAgIDIuIGEgc21hbGwgcGFydCBpcyBzdG9sZW4gYnkgdGhlIHRpY2tldCBvbiBjaGVja3Bv
aW50IGNvbnRleHQuDQogICAzLiB0aGUgbGVmdCBpcyByZWxlYXNlZCBhZnRlciB0aGUgbG9nIGl0
ZW1zIGFyZSBjb21taXR0ZWQgdG8gQ0lMLg0KICAgICAgIHhsb2dfY2lsX2NvbW1pdCgpIC0+IHhm
c19sb2dfdGlja2V0X3JlZ3JhbnQoKSAtPiB4bG9nX2dyYW50X3N1Yl9zcGFjZSgpLg0KDQogICBO
b3cgd2UgaGF2ZSBvbmx5IGhhbGYgdHJfaXRydW5jYXRlIHJlc2VydmF0aW9uIChmb3IgdGhlIHNl
Y29uZCB0cmFucyBpbiBjaGFpbiksDQogICBOT1QgZnVsbCENCg0KNSkgV29yayB3aXRoIHRoZSBz
ZWNvbmQgdHJhbnNhY3Rpb24gKGl04oCZcyBzbG93IHNvbWUgaG93KS4gTm93IHdlIGhhdmUgaGFs
Zg0KICAgdHJfaXRydW5jYXRlIHJlc2VydmF0aW9uLg0KDQo2KSBQYXJhbGxlbCB0cmFuc2l0aW9u
cyBjb21lIGFuZCBnbywgdXNpbmcgdXAgb3RoZXIgZnJlZSBsb2cgYnl0ZXMuIE5vdyB3ZSBoYXZl
DQogICBoYWxmIHRyX2l0cnVuY2F0ZSByZXNlcnZhdGlvbi4gQW5kIG9uIGRpc2sgbG9nLCB0aGUg
ZnJlZSBsb2cgYnl0ZXMgaXMgb25seSBhIGJpdA0KICAgbW9yZSB0aGFuIGhhbGYgdHJfaXRydW5j
YXRlIHJlc2VydmF0aW9uLCBidXQgbGVzcyB0aGFuIGZ1bGwgdHJfaXRydW5jYXRlIHJlc2VydmF0
aW9uLg0KDQo3KSBTdGlsbCB3b3JrIHdpdGggdGhlIHNlY29uZCB0cmFuc2FjdGlvbiBpbiB0aGUg
Y2hhaW4sIGZyZWVpbmcgdGhlIGV4dGVudHMsIHN5c3RlbQ0KICAgIGNyYXNoZWQuIE5vdyBoYWxm
IHRyX2l0cnVuY2F0ZSByZXNlcnZhdGlvbi4NCg0KU28geW91IHNlZSwgc2luY2Ugc3RlcCA1KSB0
aGVyZSBpcyBvbmx5IGhhbGYgdHJfaXRydW5jYXRlIHJlc2VydmF0aW9uIGV4aXN0LiAgVGhlIGlk
ZWENCnRoYXQgZnJvbSBzdGVwIDEpIHRvIHN0ZXAgNykgdGhlcmUgc2hvdWxkIGJlIGZ1bGwgdHJf
aXRydW5jYXRlIHJlc2VydmF0aW9uIGV4aXN0IGlzIHdyb25nLg0KDQpZb3UgY2Fu4oCZdCBhZnRl
ciB0aGUgZmlyc3QgdHJhbnNhY3Rpb24gaXMgY29tbWl0dGVkLCB0aGUgcmVzZXJ2YXRpb24gZm9y
IHRoYXQgdHJhbnNhY3Rpb24NCmlzIHRpbGwgdGhlcmUsIHJpZ2h0Lg0KDQpUaGFua3MgZm9yIHlv
dXIgZm9sbG93aW5nIGNvbW1lbnRzLCBidXQgdGhleSBsb29rIGJhc2VkIG9uIHRoZSB3cm9uZyBp
ZGVhLg0KDQpUaGFua3MsDQpXZW5nYW5nDQoNCj4gDQo+PiBXaGljaCBpcyBleGFjdGx5IHdoYXQg
eW91IHRoZW9yaXplZCBhYm92ZS4gIE9rLCBJJ20gc3RhcnRpbmcgdG8gYmUNCj4+IGNvbnZpbmNl
ZC4uLiA6KQ0KPiANCj4gSSdtIG5vdC4gOi8NCj4gDQo+PiBJIHdvbmRlciwgaWYgeW91IGFkZCB0
aGlzIHRvIHRoZSB2YXJpYWJsZSBkZWNsYXJhdGlvbnMgaW4NCj4+IHhmc19lZmlfaXRlbV9yZWNv
dmVyIChvciB4ZnNfZWZpX3JlY292ZXIgaWYgd2UncmUgYWN0dWFsbHkgdGFsa2luZyBhYm91dA0K
Pj4gVUVLNSBoZXJlKToNCj4+IA0KPj4gc3RydWN0IHhmc190cmFuc19yZXN2IHJlc3YgPSBNX1JF
UyhtcCktPnRyX2l0cnVuY2F0ZTsNCj4+IA0KPj4gYW5kIHRoZW4gY2hhbmdlIHRoZSB4ZnNfdHJh
bnNfYWxsb2MgY2FsbCB0bzoNCj4+IA0KPj4gcmVzdi50cl9sb2djb3VudCA9IDE7DQo+PiBlcnJv
ciA9IHhmc190cmFuc19hbGxvYyhtcCwgJnJlc3YsIDAsIDAsIDAsICZ0cCk7DQo+PiANCj4+IERv
ZXMgdGhhdCBzb2x2ZSB0aGUgcHJvYmxlbT8NCj4gDQo+IEl0IG1pZ2h0IGZpeCB0aGlzIHNwZWNp
ZmljIGNhc2UgZ2l2ZW4gdGhlIHN0YXRlIG9mIHRoZSBsb2cgYXQgdGhlDQo+IHRpbWUgdGhlIHN5
c3RlbSBjcmFzaGVkLiBIb3dldmVyLCBpdCBkb2Vzbid0IGhlbHAgdGhlIGdlbmVyYWwNCj4gY2Fz
ZSB3aGVyZSB3aGF0ZXZlciB3ZW50IHdyb25nIGF0IHJ1bnRpbWUgcmVzdWx0cyBpbiB0aGVyZSBi
ZWluZw0KPiBsZXNzIHRoYW4gYSBzaW5nbGUgdHJfaXRydW5jYXRlIHJlc2VydmF0aW9uIHVuaXQg
YXZhaWxhYmxlIGluIHRoZQ0KPiBsb2cuDQo+IA0KPiBPbmUgb2YgdGhlIHJlY2VudCBSSCBjdXN0
b20gY2FzZXMgSSBsb29rZWQgYXQgaGFkIG11Y2ggbGVzcyB0aGFuIGENCj4gc2luZ2xlIHRyX2l0
cnVuY2F0ZSB1bml0IHJlc2VydmF0aW9uIHdoZW4gaXQgY2FtZSB0byByZWNvdmVyaW5nIHRoZQ0K
PiBFRkksIHNvIEknbSBub3QganVzdCBtYWtpbmcgdGhpcyB1cC4NCj4gDQo+IEkgcmVhbGx5IGRv
bid0IHRoaW5rIHRoaXMgcHJvYmxlbSBpcyBub3Qgc29sdmFibGUgYXQgcmVjb3ZlcnkgdGltZS4N
Cj4gaWYgdGhlIHJ1bnRpbWUgaGFuZy9jcmFzaCBsZWF2ZXMgdGhlIEVGSSBwaW5uaW5nIHRoZSB0
YWlsIG9mIHRoZSBsb2cNCj4gYW5kIHNvbWV0aGluZyBoYXMgYWxsb3dlZCB0aGUgbG9nIHRvIGJl
IG92ZXJmdWxsIChpLmUuIGxvZyBzcGFjZQ0KPiB1c2VkIHBsdXMgZ3JhbnRlZCBFRkkgcmVzZXJ2
YXRpb24gPiBwaHlzaWNhbCBsb2cgc3BhY2UpLCB0aGVuIHdlIG1heQ0KPiBub3QgaGF2ZSBhbnkg
c3BhY2UgYXQgYWxsIGZvciBhbnkgc29ydCBvZiByZXNlcnZhdGlvbiBkdXJpbmcNCj4gcmVjb3Zl
cnkuDQo+IA0KPiBJIHN1c3BlY3QgdGhhdCB0aGUgY2F1c2Ugb2YgdGhpcyByZWNvdmVyeSBpc3N1
ZSBpcyB0aGUgd2UgcmVxdWlyZSBhbg0KPiBvdmVyY29tbWl0IG9mIHRoZSBsb2cgc3BhY2UgYWNj
b3VudGluZyBiZWZvcmUgd2UgdGhyb3R0bGUgaW5jb21pbmcNCj4gdHJhbnNhY3Rpb24gcmVzZXJ2
YXRpb25zIChpLmUuIHRoZSBuZXcgcmVzZXJ2YXRpb24gaGFzIHRvIG92ZXJydW4NCj4gYmVmb3Jl
IHdlIHRocm90dGxlKS4gSSB0aGluayB0aGF0IHRoZSByZXNlcnZhdGlvbiBhY2NvdW50aW5nIG92
ZXJydW4NCj4gZGV0ZWN0aW9uIGNhbiByYWNlIHRvIHRoZSBmaXJzdCBpdGVtIGJlaW5nIHBsYWNl
ZCBvbiB0aGUgd2FpdCBsaXN0LA0KPiB3aGljaCBtaWdodCBhbGxvdyB0cmFuc2FjdGlvbnMgdGhh
dCBzaG91bGQgYmUgdGhyb3R0bGVkIHRvIGVzY2FwZQ0KPiByZXN1bHRpbmcgaW4gYSB0ZW1wb3Jh
cnkgbG9nIHNwYWNlIG92ZXJjb21taXQuIElGIHdlIGNyYXNoIGF0IGpzdXQNCj4gdGhlIHdyb25n
IHRpbWUgYW5kIGFuIGludGVudC1pbi1wcm9ncmVzcyBwaW5zIHRoZSB0YWlsIG9mIHRoZSBsb2cs
DQo+IHRoZSBvdmVyY29tbWl0IHNpdHVhdGlvbiBjYW4gbGVhZCB0byByZWNvdmVyeSBub3QgaGF2
aW5nIGVub3VnaA0KPiBzcGFjZSBmb3IgaW50ZW50IHJlY292ZXJ5IHJlc2VydmF0aW9ucy4uLg0K
PiANCj4gVGhpcyBzdWJ0bGUgb3ZlcmNvbW1pdCBpcyBvbmUgb2YgdGhlIGlzc3VlcyBJIGhhdmUg
YmVlbiB0cnlpbmcgdG8NCj4gY29ycmVjdCB3aXRoIHRoZSBieXRlLWJhc2VkIGdyYW50IGhlYWQg
YWNjb3VudGluZyBwYXRjaGVzICh3aGljaCBJJ20NCj4gLWZpbmFsbHktIGdldHRpbmcgYmFjayB0
bykuIEkga25vdyB0aGF0IHJlcGxheWluZyB0aGUgbG9nIGZyb20gdGhlDQo+IG1ldGFkdW1wIHRo
YXQgcmVwb2R1Y2VzIHRoZSBoYW5nIHdpdGggdGhlIGJ5dGUtYmFzZWQgZ3JhbnQgaGVhZA0KPiBh
Y2NvdW50aW5nIHBhdGNoc2V0IGFsbG93ZWQgbG9nIHJlY292ZXJ5IHRvIHN1Y2NlZWQuIEl0IGhh
cyBhDQo+IGRpZmZlcmVudCBjb25jZXB0IG9mIHdoZXJlIHRoZSBoZWFkIGFuZCB0YWlsIGFyZSBh
bmQgaGVuY2UgaG93IG11Y2gNCj4gbG9nIHNwYWNlIGlzIGFjdHVhbGx5IGF2YWlsYWJsZSBhdCBh
bnkgZ2l2ZW4gdGltZSwgYW5kIHRoYXQNCj4gZGlmZmVyZW5jZSB3YXMganVzdCBlbm91Z2ggdG8g
YWxsb3cgYSB0cl9pdHJ1bmNhdGUgcmVzZXJ2YXRpb24gdG8NCj4gc3VjY2NlZC4gSXQgYWxzbyBo
YXMgZGlmZmVyZW50IHJlc2VydmF0aW9uIGdyYW50IG92ZXJydW4gZGV0ZWN0aW9uDQo+IGxvZ2lj
LCBidXQgSSdtIG5vdCAxMDAlIHN1cmUgaWYgaXQgc29sdmVzIHRoaXMgdW5kZXJseWluZyBydW50
aW1lDQo+IG92ZXJjb21taXQgcHJvYmxlbSBvciBub3QgeWV0Li4uDQo+IA0KPiBDaGVlcnMsDQo+
IA0KPiBEYXZlLg0KPiAtLSANCj4gRGF2ZSBDaGlubmVyDQo+IGRhdmlkQGZyb21vcmJpdC5jb20N
Cg0K
