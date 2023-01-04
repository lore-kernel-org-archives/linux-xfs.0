Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48DB3C4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Jan 2023 17:41:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229441AbjADRl2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Jan 2023 12:41:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235346AbjADRlZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Jan 2023 12:41:25 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C13EC13D58
        for <linux-xfs@vger.kernel.org>; Wed,  4 Jan 2023 09:41:23 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 304FO920000340;
        Wed, 4 Jan 2023 17:41:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=felNmHI2XrHTHgKMGOJs1gAO+dY5jWGSuigHmaHlX6Q=;
 b=gQxFvmjRvydGs7WXebRi7DF0zRb2loWajN50yhGz11G2ThOET+xD5WWau+E0AnV743ks
 sVhGENC39rHdmlCO0eBVOVz7UjRapybmQVTU5iYNp0vc6ql/kjiW6NS30vcQBlpV493j
 t0w5oRz8/E0Fws8YsqDtFelYU6JVZ69PxvkyDSzSFrx1KhSY0mP9LTiofqIa19EPm4C+
 15rZEJcfiKzouzlBHgBx2SpIxljpfwpLqcq2nj9beqIMnanJ4Kp3ACOr594EiJoaAkZU
 guIta7aJLJcVh+BuMd2Mbf+wg/TFck2wc36BPOKHWtTQFgTjITBjPA/ssCoAEUn2IVZ3 yw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mtbgqq4w3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Jan 2023 17:41:17 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 304Gwot5006518;
        Wed, 4 Jan 2023 17:41:16 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2041.outbound.protection.outlook.com [104.47.51.41])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mwdey9wnq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Jan 2023 17:41:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PiiGpiDsND17jA7TkudxWPeX1txYHdRBuepPhPx1pwkeHCfW+mXpfaZo7goeuaqxEUdRIDxgclueIUt4aVHZ7L4Xi9mo4Mvo7LnxgRfNBl8q78IgrUdXD2yW2rBwnZ4q58QU8iyIigouYqgAzpdblcc7aJ5LD88D3YjOuLt5tB+rDn4jqSrnvGYaNaryxklVwt1Bg3eRo5wbBmINmej6owGvkHi1DE8z6V5gZCQS7xVB09pB/poq5CLP7FQLyWDVznHCPCPFJsbBeYxb+g7ZbRWnyZLFnhpCHxd7NfLuHWzn3ii8r1NBNjdpMpsv/VVmvmZQZ+9uf8FkNp50aDSohg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=felNmHI2XrHTHgKMGOJs1gAO+dY5jWGSuigHmaHlX6Q=;
 b=hXF/X3K1gZ/ryprCxEinjVfSGgfTJNmGg1lR5RVuRlm++MfVT9U6MBGgFZ4n9L3A+YQQCZvEZIHtjWscFG5LizShgl9agSdId+36t3p3/Po7NuVN/MnWYfg9ymK4VjIidBN4SRPiVHmSX7jGAnIT+3yLIWAT7F1E8in3G2yiT19duH0N21iZZN3OcajiofoFTTPjJid+O8QQS6d3N54kZSibBqM3oIfpckald6gSzN6kCoL7g5d3wBgCH8rZpmBcSuBYrpQbRFBzc6lNiLQTuxRpIbslnucg0MaMaTC8dlzOytJU6eC8zBVzyquWf1sgDkeoYvbgBBjPUeVus252oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=felNmHI2XrHTHgKMGOJs1gAO+dY5jWGSuigHmaHlX6Q=;
 b=vKCEslrpNLRDqSeaQ27oCy5RQeU0DUynzuqcn0ld9FtBxM94DVN6wo9OhB1xX2L4tROAyR8jr8RuF+CTiIsRpScWo0TlXg+gpWzm9H537ETYJruU7Po/dKThSDD3c/DzvJFN/40phwYBE15mdR5Lo/QoLR2I/QShlUYy4B5EMwE=
Received: from SN6PR10MB2701.namprd10.prod.outlook.com (2603:10b6:805:45::20)
 by DS0PR10MB6245.namprd10.prod.outlook.com (2603:10b6:8:d3::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5944.19; Wed, 4 Jan 2023 17:41:15 +0000
Received: from SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::e751:efd1:ac1c:63ce]) by SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::e751:efd1:ac1c:63ce%5]) with mapi id 15.20.5944.019; Wed, 4 Jan 2023
 17:41:15 +0000
From:   Wengang Wang <wen.gang.wang@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix extent busy updating
Thread-Topic: [PATCH] xfs: fix extent busy updating
Thread-Index: AQHZH6oZFixj4NaZMkejbaCu/jppka6OcsUAgAAVYgA=
Date:   Wed, 4 Jan 2023 17:41:15 +0000
Message-ID: <3C662595-F2C9-47B0-B4FD-1C4F3F10A4E1@oracle.com>
References: <20230103193217.4941-1-wen.gang.wang@oracle.com>
 <Y7WoStJT4ImufLct@magnolia>
In-Reply-To: <Y7WoStJT4ImufLct@magnolia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2701:EE_|DS0PR10MB6245:EE_
x-ms-office365-filtering-correlation-id: 9305151a-509e-4b75-c6f9-08daee7ae0cd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jeBIUP3PlS5ITOsyK99uVbd/DxXG8Ooc7P405i26mdiqHKEbBp3ZIOt7hoHkHORKsA+p6rghkJXXfYrWdVWVGobk9Ag60sApLXNpN4Cbdh4AUj6FTkLkQMLAk2ZDQvvPRO9aausqhtHbqeADrKgMoyGibzaD05rmtthiMr6BwcZqwGuctDzJBo0n8IYk3Pj86c1gA3iMB7nUgkddKCUJ4BzUsukx3yjQmv+OQ7x/URGdRNpCSL4pbUuRESsVMbo1FiEXj371L5c63RexuF9pupFoF8UYK9WFF0P4UsQBywbcb7IHWHn2JndcrZtoQjZ9XfrBgJac3aMOzUr8UOUBJQ4cI7KVmZ8lQ+Njw+xvXGE3ZbsDb9FPxzezP3TzFIt4MKOIY9R3L7VLzQP1s91RcpoYldsD1jB6zaas5hW+Ca/yRF0/tOnD9gUI20Of8UDguDFH3sk+lvia/4BXjhhA66FQKVMnPuUJX/4MU93wm+phsDAbAhWB09O0gLpLnsdVtFgM6wybXVDmvfN03JeH98bZGnig/0/2OY1DimpUVi2mpXgYKubUMWj3oA5FQqOl22wKvF1e4FOmaP4LiOx2/lRxx+6bl1KGn6iOCPdX36WCVn+zwI6d6LIo+XdTPHhQb1mgFA9Yx9TiczoNwdRQZ/u3C4Ae6on5R4lKOd9DXS9aQXPqMmyTVstIhEFQYTfwSB8zTOptMZJ0nheLMAmxv5tGsCKHPi/NbddNRa8JdSA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2701.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(366004)(346002)(396003)(39860400002)(451199015)(8936002)(83380400001)(5660300002)(2906002)(122000001)(33656002)(41300700001)(38070700005)(86362001)(36756003)(71200400001)(186003)(6916009)(316002)(6512007)(2616005)(6486002)(38100700002)(6506007)(478600001)(53546011)(66476007)(76116006)(66446008)(66556008)(4326008)(66946007)(8676002)(64756008)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RFpzc00vWUhwb2NBYklpNFRrOEQzd0sxMDJLZXl1aVhZQ29FZjBtZ2lNa1lM?=
 =?utf-8?B?dFBhVk9GQzZ0dXN1V1YwT1J3ZmZlOUx6cEJ5OUViZEJjZ1VLK0FWTWdPaDFF?=
 =?utf-8?B?U0tYamRNUWQ3MjVLS2MybXBzc2NIL0IvUm14ZTlnbDgwQlN4THZGVytQRkNC?=
 =?utf-8?B?dXVTcFh3aXRlaXFKbTJXV3p1M2p2R3dKeGZZUUh6VmVQKzQ0RVdnTExCaGZo?=
 =?utf-8?B?RnNCbmFrQURMR2dpV2hqdGYvZFdSKzZsellxUmprdVlEelkzbksxdHdndTBx?=
 =?utf-8?B?RXNuVVdhOGVJbDVucitKd2xITUdzNU91REptYUVMQldKUWhqdlcvYitSRnRP?=
 =?utf-8?B?bXZnTCtUbzdQdUdKd1RSYjlDRk11ZGdSMGt3VTRySGdoOUhWZ3ZhTk5oTGd3?=
 =?utf-8?B?YUFYM0FNRS9GTzVwYmpWTUcrRmpxY2pkYk5Ta1hFRDhEdWFxQkhkMktVVXlx?=
 =?utf-8?B?MDhhT3V3K1J0NmViUjJPTW1NTVpSZ01JVytxQjJxaE9jdUxxcVljTG9haWNH?=
 =?utf-8?B?bU1LeklmRU8ycjVRQzFRYnR1U3U4TUdBejVhQTIyV0pXSTEvUTZyUnJEVzhF?=
 =?utf-8?B?aGVQTUxWcXVpVTRNOVZIaGFEVFpYZ0h2Ui8rL1EvZ2UvQlNOMndFQUMyelpQ?=
 =?utf-8?B?TVkyMDdKSTREYmsyOTYyVjFMVzJnZEZtZlJqemMxb0xRUjBqQlVZbnc1VjFp?=
 =?utf-8?B?L25USUE1OFBzajNlYjVheEZLWnUrKzBvZjU4M1c0Wm5aZ1hvNDRzbnJtcTV5?=
 =?utf-8?B?T042eTRlY1AwSDBHTGFhSDlZTnFkZTlzRityTGk0M21yUm5QUnlHYWhYbVdM?=
 =?utf-8?B?Wlh5cWswM3hNRU1YSHUrdnpGMC9lWXhYczlZOVU2RS83WTVMK3Rzd2xhM2t4?=
 =?utf-8?B?Vm9ZeEl0MlFkWUtScWp1NTlYUkdwOVNGc0I2bU85YmQvSTJYd1hJaXVPRkNj?=
 =?utf-8?B?SUtWUlM5OXRaMmdCVkZldnVsbkprNHJTR29DMmhTVnJtcUZnZ0pwK0tZY0xt?=
 =?utf-8?B?Q1lDSVVuTnh2SGk0c25raUFPMzhBUkgvYVN3K3R1OVN3STRTRXgrSnRSc0Qz?=
 =?utf-8?B?Y2ZKT1JITDlwcEdVT2cvVHJjK1o3ZGZKUWNyU3NuSDZwbW1lNUNtcnVRM20y?=
 =?utf-8?B?cnlORXR1c2cyL1llb0JoRUlpWG5kaFh2Z21CK2V0ZXdYc2ZkSDFCc2F2Tk85?=
 =?utf-8?B?ai81b0NhZlVlelU4UE42NjNaOUlrdUN5RVpnblhsandZNm5TUjdRN1ZwNDB6?=
 =?utf-8?B?WG1WV292NjhaT3dqdmFWKzMwSTdmOE5Pb3lvKzU5Ymo2NUZobnJKSkJueHlZ?=
 =?utf-8?B?NXVCWkRiNHV5S3ljeDBUYmZVS21vT2E2NldUeGluVWVUKytwT1ZZUVNPbkQy?=
 =?utf-8?B?b3paT1RSdkVOWnBZalpBMWFhTnFKRzQ4c0FhZlVWcnd2M1doWStKNHBIZTFj?=
 =?utf-8?B?OVl6cGZ1VVNQMjZuT2ZQRkxNMXBybnQ5aXRKRHgzUDNZUlczSkZsSHROejNP?=
 =?utf-8?B?bkE3UXdrVWV4ZnoyU2NLQWpNdU9ydmhvYjBhbE9MVUtydHdqK0xOZUFwMDA2?=
 =?utf-8?B?Wi9lR0dlRGlaSTJWYitvdlA3bUI3SU4zTThJZEZxb0JPK3Fwb3ZBbGI3aHdU?=
 =?utf-8?B?RWt2cGg1WnFNT3dtSkpYRGtjcnozdVNrNjhLTGQvRkJvWkRiS2hraG5CTGtv?=
 =?utf-8?B?Unc2UVByVWZXVzNPYXhTcnh6QkpOalFvT0xFVnU5Y0Y4ejV6bDZ6WHorSGMx?=
 =?utf-8?B?SUZGM0tqOU50aURHYVZIbmluMUFGc1JIM2o2Ukw0NEJlUC80ckZRSHZ3QkRL?=
 =?utf-8?B?M3NhQ3d5TzVwdDBHK2ZDOVB1MlNjN1RHblltUkE5Nk91ZkswMEFxZTJWQkl0?=
 =?utf-8?B?b2w3bVJJR1hlS2h3OUNYRHZxeEtuMmpjM0l3dmZXYlZDbldyTm5sYzR2dXV6?=
 =?utf-8?B?bWh2NDhJQ0xYV2lNdnRROUxjT2tJYTlEOFpMd0FmTzcrc1FKc0oxb3FHZzhj?=
 =?utf-8?B?UEtDT1ZXUkMzYkhoVUlTL3FEc3ZIc0ZVSk9SYXdQeWhMcUN5SXhpYUlGbUFE?=
 =?utf-8?B?S05HRi9oUlorcjFMQ2xUTnBYeFRPdDRNaTRMandFR05rWXlUaGVXMi81RXR1?=
 =?utf-8?B?Y3B6QVZQWmY3STM0V3lWNmtycXcvSitQejVCaHFVemd4WkhSakpNZUIxUVFv?=
 =?utf-8?Q?sk4I+0R2454HuhTfvL+H+sY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8FEAE6086CD49E41A66BCB6721896BEC@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: aHJ2M6NtrLj7Hm6dWA41kIkAO5un5CvjLJ7WgbUORKHdyzeQcsuonbP/KYQXYcQZJ/q4a7ohd+eOL3MY2cTs4GJo4nhfFmduFhJCee3qCyvdv8djLlnJ2t7KAVUYocqTyLXTY8e4m/C4AlB10rkh6onFQ6HT3BEDbtMkte8PsKS5Rv65fhnqlvUq8t8KyrYx7OQ25KJUSwi08anPn4LcgbOPC0bDQTBB7Yrp5GWFK0unotJMUvF2rOi1roO6sKBX+pyiAEH7HEdo1JGyeNPD8/hEyuCx9HiUYtapHE185we7FgejBCRTi0a6uJWqQKGiT/hJplyTeq6h7NiaIHbGSXFCZvCFLWkrTY8UhIi2V1kPEoMYTb2xoJYSZO0FEJgX2NyLXXX3ZhtuBk5Wxw4jQo4nDGzMawrRHZWXQz9cXu/AKOqj+AY79XZCn2TC1Oz0jlzrj576beaM87ZaWJ/SzOmTMDBm+z1H4j79PIUw8EfrGcZr+HnSNKLwBhhoLCktUsiodcRxYIuPZL0WJOiVyg8+kkUCSCULSxrg3ULEQAm7+Za3zL/9Lklhz0GviMoFwMm+jonW9BtRViAVVsrpLOywyuWYaDrq1BYIy7ob/SnQezhGAgKJikrRyzUaOTmiyoQbB3IH10nEhQ9QQNxgSNuv2wop369hUxeg51YBOoebiAuQ0G5CNlOURlnlgupBmxjKcDBGywkOTPWfCuc7QXYGCq0dAhJQGA854jqPgWEgtt18N+rfWw5Tx0IzC6+F3v4jfIFWJeBbLA504ylAs1gv0HwIhEsdMnw+v4vLvdA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9305151a-509e-4b75-c6f9-08daee7ae0cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2023 17:41:15.1037
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JeFck2QuFaVl23G5+vQAINpYL2Z6+I7a1dzhNbs/ykuqIrbjqxmyC2WkUhVnYC/X+K/yaJw36Af2xYf5Kj+TncYpMlQR6VkriLuoBwILqqc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6245
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-04_07,2023-01-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 phishscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301040147
X-Proofpoint-GUID: BIIYUI5ST6KN9NFM60eNRbzLippKWA_G
X-Proofpoint-ORIG-GUID: BIIYUI5ST6KN9NFM60eNRbzLippKWA_G
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

RGFycmljaywNCg0KPiBPbiBKYW4gNCwgMjAyMywgYXQgODoyNCBBTSwgRGFycmljayBKLiBXb25n
IDxkandvbmdAa2VybmVsLm9yZz4gd3JvdGU6DQo+IA0KPiBPbiBUdWUsIEphbiAwMywgMjAyMyBh
dCAxMTozMjoxN0FNIC0wODAwLCBXZW5nYW5nIFdhbmcgd3JvdGU6DQo+PiBJbiB4ZnNfZXh0ZW50
X2J1c3lfdXBkYXRlX2V4dGVudCgpIGNhc2UgNiBhbmQgNywgd2hlbmV2ZXIgYm5vIGlzIG1vZGlm
aWVkIG9uDQo+PiBleHRlbnQgYnVzeSwgdGhlIHJlbGF2ZW50IGxlbmd0aCBoYXMgdG8gYmUgbW9k
aWZpZWQgYWNjb3JkaW5nbHkuDQo+PiANCj4+IFNpZ25lZC1vZmYtYnk6IFdlbmdhbmcgV2FuZyA8
d2VuLmdhbmcud2FuZ0BvcmFjbGUuY29tPg0KPj4gLS0tDQo+PiBmcy94ZnMveGZzX2V4dGVudF9i
dXN5LmMgfCAxICsNCj4+IDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKQ0KPj4gDQo+PiBk
aWZmIC0tZ2l0IGEvZnMveGZzL3hmc19leHRlbnRfYnVzeS5jIGIvZnMveGZzL3hmc19leHRlbnRf
YnVzeS5jDQo+PiBpbmRleCBhZDIyYTAwM2Y5NTkuLmYzZDMyOGU0YTQ0MCAxMDA2NDQNCj4+IC0t
LSBhL2ZzL3hmcy94ZnNfZXh0ZW50X2J1c3kuYw0KPj4gKysrIGIvZnMveGZzL3hmc19leHRlbnRf
YnVzeS5jDQo+PiBAQCAtMjM2LDYgKzIzNiw3IEBAIHhmc19leHRlbnRfYnVzeV91cGRhdGVfZXh0
ZW50KA0KPj4gCQkgKg0KPj4gCQkgKi8NCj4+IAkJYnVzeXAtPmJubyA9IGZlbmQ7DQo+PiArCQli
dXN5cC0+bGVuZ3RoID0gYmVuZCAtIGZlbmQ7DQo+IA0KPiBMb29rcyBjb3JyZWN0IHRvIG1lLCBi
dXQgaG93IGRpZCB5b3UgZmluZCB0aGlzPw0KDQpJIHdhcyB3b3JraW5nIHdpdGggYSBVRUs1IFhG
UyBidWcgd2hlcmUgYnVzeSBibG9ja3MgKGNvbnRhaW5lZCBpbiBleHRlbnQgYnVzeSkgYXJlIGFs
bG9jYXRlZCB0byByZWd1bGFyIGZpbGVzIHVuZXhwZWN0ZWRseS4NCldoZW4gSSB3YXMgdHJ5aW5n
IHRvIGZpeCB0aGF0IHByb2JsZW0gKHN0aWxsIHJldXNlIGJ1c3kgYmxvY2tzIGZvciBkaXJlY3Rv
cmllcyksIHRoZSBwcm9ibGVtIGhlcmUgaXMgZXhwb3NlZC4NCg0KDQo+ICBJcyB0aGVyZSBzb21l
IHNvcnQgb2YNCj4gdGVzdCBjYXNlIHdlIGNvdWxkIGF0dGFjaCB0byB0aGlzPw0KDQpIbS4uIEkg
Y2FuIG9ubHkgcmVwcm9kdWNlIHRoaXMgd2l0aCBteSBwYXRjaC4gV2VsbCwgdGhlIGlkZWEgaXMg
dGhhdCwgZm9yIGV4YW1wbGUsDQoNCjEpIHdlIGhhdmUgYW4gZXh0ZW50IGJ1c3kgaW4gdGhlIGJ1
c3kgdHJlZTogICAgKGJubz0xMDAsIGxlbj0yMDApDQoyKSBhbGxvY2F0ZSBibG9ja3MgZm9yIGRp
cmVjdG9yaWVzIGZyb20gYWJvdmUgZXh0ZW50IGJ1c3kgKG11bHRpcGxlIHRpbWVzKQ0KMykgYWZ0
ZXIgdGhlIGFsbG9jYXRpb25zLCBhYm92ZSBleHRlbnQgYnVzeSBmaW5hbGx5IGJlY29tZXMgIChi
bm89MzAwLCBsZW49MjAwKSAgdGhvdWdoIGl0IHNob3VsZCBiZWNvbWUgKGJubz0zMDAsIGxlbj0w
KSBhbmQgc2hvdWxkIGJlIHJlbW92ZWQgZnJvbSB0aGUgYnVzeSB0cmVlLg0KNCkgdGhlIGJsb2Nr
IDMwMCAoaW4gdGhhdCBBRykgaXMgdXNlZCBhcyBtZXRhZGF0YSAoZGlyZWN0b3J5IGJsb2NrcyBj
b250YWluaW5nIGRpciBlbnRyaWVzKSBhbmQgdGhlbiB0aGF0IGJsb2NrIGlzIGZyZWVkDQo1KSBp
bnNlcnQgdGhlIG5ldyBleHRlbnQgYnVzeSAoYm5vPTMwMCwgbGVuPTEpIHRvIHRoZSBidXN5IHRy
ZWUsDQppbiBmdW5jdGlvbiB4ZnNfZXh0ZW50X2J1c3lfaW5zZXJ0KCk6DQoNCiA2MSAgICAgICAg
IHdoaWxlICgqcmJwKSB7DQogNjIgICAgICAgICAgICAgICAgIHBhcmVudCA9ICpyYnA7DQogNjMg
ICAgICAgICAgICAgICAgIGJ1c3lwID0gcmJfZW50cnkocGFyZW50LCBzdHJ1Y3QgeGZzX2V4dGVu
dF9idXN5LCByYl9ub2RlKTsNCiA2NA0KIDY1ICAgICAgICAgICAgICAgICBpZiAobmV3LT5ibm8g
PCBidXN5cC0+Ym5vKSB7DQogNjYgICAgICAgICAgICAgICAgICAgICAgICAgcmJwID0gJigqcmJw
KS0+cmJfbGVmdDsNCiA2NyAgICAgICAgICAgICAgICAgICAgICAgICBBU1NFUlQobmV3LT5ibm8g
KyBuZXctPmxlbmd0aCA8PSBidXN5cC0+Ym5vKTsNCiA2OCAgICAgICAgICAgICAgICAgfSBlbHNl
IGlmIChuZXctPmJubyA+IGJ1c3lwLT5ibm8pIHsNCiA2OSAgICAgICAgICAgICAgICAgICAgICAg
ICByYnAgPSAmKCpyYnApLT5yYl9yaWdodDsNCiA3MCAgICAgICAgICAgICAgICAgICAgICAgICBB
U1NFUlQoYm5vID49IGJ1c3lwLT5ibm8gKyBidXN5cC0+bGVuZ3RoKTsNCiA3MSAgICAgICAgICAg
ICAgICAgfSBlbHNlIHsNCiA3MiAgICAgICAgICAgICAgICAgICAgICAgICBBU1NFUlQoMCk7DQog
NzMgICAgICAgICAgICAgICAgIH0NCiA3NCAgICAgICAgIH0NCg0KTm90ZSB0aGF0IG5vZGUgKGJu
bz0zMDAsIGxlbj0yMDApIGFscmVhZHkgZXhpc3RzIGluIHRoZSB0cmVlLCB0aGUgY29kZSBoaXRz
IGxpbmUgNzIsIHRoZSDigJxlbHNl4oCdIGNhc2UsIGFuZCBlbnRlcnMgaW5maW5pdGUgbG9vcC4N
Cg0KdGhhbmtzLA0Kd2VuZ2FuZw0KDQo+IA0KPiAtLUQNCj4gDQo+PiAJfSBlbHNlIGlmIChiYm5v
IDwgZmJubykgew0KPj4gCQkvKg0KPj4gCQkgKiBDYXNlIDg6DQo+PiAtLSANCj4+IDIuMjEuMCAo
QXBwbGUgR2l0LTEyMi4yKQ0KPj4gDQoNCg==
