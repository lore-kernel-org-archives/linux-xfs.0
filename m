Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98DD8C05027
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Jan 2023 17:50:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231544AbjAWRuB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Jan 2023 12:50:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbjAWRuA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Jan 2023 12:50:00 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5C2712078
        for <linux-xfs@vger.kernel.org>; Mon, 23 Jan 2023 09:49:58 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30NHYLpK006410;
        Mon, 23 Jan 2023 17:49:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=hmO4VjK2qOOgdt8ODR0hur7jXdq+PSKqNeQBkWXw7sk=;
 b=zjUjKVLRnEhTbHaB5g43enXGUyRdh1fX8nIlRk83jD+bbJy61fphPQCwd5jUdizLAJif
 0cbViHdNzGPNQY1no1ciOVsCP2LLAp1WSaOhkegS1Bihq8Zt1aDBrUzzAplKKZ7cLvWU
 +gIkFKSz23ftM7sgFkCUN/V0bp/wzdVN1Nt7Muiy75pVBMmRFF2+k4TaQ5XGq2K086AB
 5ya3Sesa4xItHrO4Fjd92QobJKm0p4Ad4G5QYRrL6l6aabJiAKHUS9t5fway191cRMBs
 78vm4Q1dMrHwsc4lNDnHUpygCXyyx293lNBs1oxEM0LO06sVrGX0Tsjfj6ItTQdCFYN5 8w== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n883c3ejh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 17:49:55 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30NHkKOa040132;
        Mon, 23 Jan 2023 17:49:54 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2042.outbound.protection.outlook.com [104.47.57.42])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g3uer3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 17:49:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bASl545fMn4JuleSQ0C10Ktx8I0HrOK0SFVEq2joYGzEC347SgJo3umk1YFkPupkvB0Uyg5SU0Jh4iw4N1JI1iIApNsFw+x0GLKUcjXJsLlrwvoJuKrKuCJPT4WIXKlD5nat1Xno3JqbOehnFK7pncGYFhArooM5K/LzbA4WK9w3yyeFogGW/gdS0HlsbXz+IuGBaKtAygR3Qz12Fzb7RyDEOF7ys4ymZHbD8plUj39nRBBdRIbinhnMEzjeTZEiTCCXyAJa56d5YvBVWi4Qf/MF+Nq8qXSutnIXGObcyT7IfNLEWPGktUIsfPM1gnugXqG6B55ml/323plwiHMgWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hmO4VjK2qOOgdt8ODR0hur7jXdq+PSKqNeQBkWXw7sk=;
 b=DmJ3JB7in8HFtS2mP2aermrLFE0sFDs5MxtnSpsuaZ/zc1lKuE5WSuzejA+Jwlo91LqUKAIuq+4hDz1mqr5HyJqEeDhSUbnRWndojvZCbBKdPO0OcpPnB+2EoEuc7Cifugff1ZHswKT3TdNNEB0x0DHoqXUsMXKQLMEewT5+7RUpRbrtzJTdRbpzil+yjnQERov5meNdQ++u/WEg7STXVVoW7PxcfgH9oIzeKPjpnis/DvuFljeYJVRhLI5Mwf5q/7/eOzPkoK23BrECh09OSUvUIr1KgzjScbIlob1jNDoFcYR8HbZHPUOZ5Twom/3Ri+ku1spVCQ+EYzqDWw+pjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hmO4VjK2qOOgdt8ODR0hur7jXdq+PSKqNeQBkWXw7sk=;
 b=ThX/+unZywGUMOe/xhBZxcYuQg0fpsVLk0YkW3bxJT/PE+a5rpVcq/7PD4+bSAEF9L788G5neZyzjjyuW4mwSNNkQqJ9cCff9nHJf5UTKF8BdUwIKQQNBiyAsepINTQBQHqOmYhp7R4urjd+/wyL5PlbZkHZJhjcOdvL0kBP74o=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CO1PR10MB4435.namprd10.prod.outlook.com (2603:10b6:303:6c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.16; Mon, 23 Jan
 2023 17:49:46 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%4]) with mapi id 15.20.6043.016; Mon, 23 Jan 2023
 17:49:46 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     "cem@kernel.org" <cem@kernel.org>
CC:     Catherine Hoang <catherine.hoang@oracle.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [ANNOUNCE] xfsprogs: for-next updated to d8eab7600
Thread-Topic: [ANNOUNCE] xfsprogs: for-next updated to d8eab7600
Thread-Index: AQHZLOZDfflRa/jmc0W7PSbfidaCua6n9eEAgAQIjACAAE3vAA==
Date:   Mon, 23 Jan 2023 17:49:46 +0000
Message-ID: <d1ca3632aa9996c63df72f28228bb97065be09e4.camel@oracle.com>
References: <20230120154512.7przrtsqqyavxuw7@andromeda>
         <YCpxV7N7zijCqzEgnJXPpWgGYUrNV687hdQtYZPyEcYqGI5zrws-hZ6Znw9fOdkrEsLUfLyrBZsxXcb1iJaeYw==@protonmail.internalid>
         <323afbd0338c40d691d79138c1ab93d00074f27c.camel@oracle.com>
         <20230123131050.qsizlly5prd5tydz@andromeda>
In-Reply-To: <20230123131050.qsizlly5prd5tydz@andromeda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4306:EE_|CO1PR10MB4435:EE_
x-ms-office365-filtering-correlation-id: c85b214d-9429-4862-def1-08dafd6a37a6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /aTgHyJQZiaiGnpOZdTR17m78l9hlUXt058fIgGsPW7NBI79Vs1EWAguTRQptx99QxkaY5jbbmkVmF9xneZXnw6jhBpbN2Q+/PVnv4UjVJj+NirbFz2pN9NMNCMOfKd/x5nOCUXvWfn3PvGfomQp7Un2ADAagGVLl2n3fijIm5+EWg3psG495Pp+/gEG0v3SfTmMLBG4pl5LDaeXPhHfQBs9SlpmaCpoVKTb+dpdsu02ZYY1MnKndtglHQZAYwYDfhM0xJMTQ7aJ314LEFKtD5Bblw5JjlXUiIc2XrULexD9hPrgl3WtN1+w9l5/5LIKLcj5oyEsa3jBm5PGZhRVNPgtDnPBnmhCf7bifAY0K3IjRIOp/m7P4aKhynplwB0yeBAhDipRwbl09kqRadQBJ5z3MQQv/3pPmANKTQ1yD7YdfWVEAQlg/F0wj0Lm0NzQam1B4QktNKuy/DSRGpyMmN6s2l4ZCxtZF6sU9kkjkWXLo6cYWrz9dO/fpUJRFf60ocR8vkoOsEG67IMpAGlK1PioNPRoC1GO61xk40CmfESTOP+z1URr8rHciuDQf4WakK57Rkoa3TjCq/Y9iJ1Atn9j6ZxBx0gE7hLIVDH3oUCQXWCTqGT3f+T6a6IHdTe48s/w+0szk3jdeZOWo8hCNzp1LDM8870FakQnxnlGCNhkku2Y2qsou5bXkQPOU0rYq/iyOJ8bI6GqY1+wtiZTxWIWXw0WrLm7/Er3/ucM4aE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(376002)(346002)(396003)(366004)(451199015)(36756003)(41300700001)(86362001)(38070700005)(5660300002)(8936002)(4326008)(2906002)(44832011)(15650500001)(122000001)(83380400001)(38100700002)(966005)(478600001)(71200400001)(6486002)(26005)(8676002)(6916009)(6506007)(186003)(6512007)(76116006)(316002)(64756008)(2616005)(66446008)(66946007)(54906003)(66476007)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VGd5SGo2Y2piUzllaElPME5MV0hDU2FydXNxd2psOS9VYzI2b1ZhdHFQWDBU?=
 =?utf-8?B?ZXFkMmdpUkNxRzZqK2pCWE5meStlRWRWSEhVbXA0dmx5Q2dYejNuYlI3RUZk?=
 =?utf-8?B?R0ZEY24wVnlDUmgxWWs1YVg0MWo1SnZHWGZWSG9aWDBkZnA1d0YyZVhRZmNv?=
 =?utf-8?B?WnI3QWRaMVQ5RXB3eVF0bjNOTDZMeGt6d2I2RGhRWkVJdE5XSEUzNE1ubThK?=
 =?utf-8?B?NDFQRlhLYlZBRVNFYVkyWUtSRTdKVzI1b2xaU2FPUlRCREZzKytiUDVYV09P?=
 =?utf-8?B?Vk1XNkxmN2dYSjhpZTUzdGFvNVNDalIyYm1PZUtDVjVNTFRhNXlIaGZJVHYv?=
 =?utf-8?B?QXpVd20xRWFiakV1Ris3Z2hiMjVZRXJLNFVTY3FJWjlJMWxKL3Q4emNDb1dH?=
 =?utf-8?B?QzM4VWNrcFFoakZIVE1EYmhGM09PUXN1eHBpSWo5b283MHpHNjg0Sk1KeUxn?=
 =?utf-8?B?aThXcWFUUTBTdjdFekhvMS9nejVNSTNDOWJQcnhBUlhCaDdkNlVmMmF3bFFh?=
 =?utf-8?B?UkRRUjNseVdROEhwYXhFQjhOMzlTdUtiN3JhclNRQ0hON0hoaU1jYktUd1hY?=
 =?utf-8?B?QlFDVlc5ck1ZZ0J4OHRGYjB6b01aREtDSHZ1Y2d3eFIxWndua0U3ZWZDYlhS?=
 =?utf-8?B?OXlIR3c2bEVsdEJmdDJFRy9SZ05Kby95SXcrL09TTnNJdTcwY2szdE11VzUv?=
 =?utf-8?B?Z0Q1YVdlQ3lBbkYxNmJTQ0JnN01Jb2ZPWGt0dVJKTE03b2JQaHFhUWplMy9x?=
 =?utf-8?B?U1pMWmVhdzdvcHluczI3YjRTSCtmVWlZQzh2UFBJTi9pcU9MUG1FNTVYaUFQ?=
 =?utf-8?B?RjVNRjcwRnZ2bzJoU05DUVBnQ2tQeDNIWWorNHhsR2dnY2QrOStrTWJ1K1ZK?=
 =?utf-8?B?WVMzYlpCbUQ1R2REcFRjbUgvekI1WHdkbDM2d3NRUEZoZE4wS2dJOGFqQ2NO?=
 =?utf-8?B?OFhDdE1ycHZiT1k1aCtINHlic0ZqeFV0cUV6dmp2RXZNTDJoRW9EYkU4Qld4?=
 =?utf-8?B?b3ROM2NGMmNJVkg2aTR0UjZpczJmR2hUR1kyWDZlVFV2bjQrSFFEbEpya1Zj?=
 =?utf-8?B?c0ZBSWZmbHp3VlFvdnZINjFIUURXNFhXeGFQMk9EaFYzK2RHZmJkWDhmOUY2?=
 =?utf-8?B?Q2NTb09PM0tFbTJ1WGxYcjRQZXVjM0RVM3RyV25PU3hQV0FrZG1DdkhqUDB3?=
 =?utf-8?B?VDhNeVRDWHNMV1BUN3F0cHNkWk1OM1E4SFBSSDlOZE5PaHZQVWUxWDhNUk9Y?=
 =?utf-8?B?akVhZjIzZnVUTHNCd1VHSkhaZ3FOc3ZFRzBOVXB1Ni9MMWFjN3d1K0hKOFI4?=
 =?utf-8?B?ZS9DZGMydERrMk5aTXF3NEl2T1psTzlpWllTbnZDTE5VQ3UxTFB6UjB4ZXYz?=
 =?utf-8?B?eDVoT2x0QThIbTgvRWFlanMzN1owc1JPbG5WTG4wSUovd05pb29JVHhmR2Z2?=
 =?utf-8?B?cVdSOHJ4SHNDL3VhT09DMVl4a1pER09wdmN4OWJ3dWFiRnQwUnBJV2FYZklx?=
 =?utf-8?B?dXJNWDFaNmdQRFpKQmsyVFcvOFFvRG9oaXFXSGRTdjJveHowdzBRQnpmeXl6?=
 =?utf-8?B?bU1JMG91WHE0Z3BIbzE1RkJ3YzNoRjh1VGpINXVVTDQrYWd3NmhkWkhxRkFT?=
 =?utf-8?B?eUZIQWhFVTFtVVNrTUV3U3VTeXBlQ3Y0Z3hNMjNEODVvK2lnSWpaOW1EVGNj?=
 =?utf-8?B?OWZQMHhwaGxyQ0taK0JJMktNbDAyVjltQ3I0TmRmQUNsY1BiVld3bG1wMEFJ?=
 =?utf-8?B?aXN2azFDdVBGWm1lcXJBMHNiRk5kZWtQTzhFSm5mSGpCM2NUOXpVTnIrbTBN?=
 =?utf-8?B?bWIwZWFUTE1iWWpDT0tJVVJJbFhiOWQ2NUM5Q2dSWTRJTnhocDJOaXhmc2hw?=
 =?utf-8?B?aExxRlhLRVRyL0dNZmREMHdqbkRwbVNOWkdqZDY5ZmJFU2lZbGo4c2pmTkhB?=
 =?utf-8?B?WVIzbVQzTHVER0Uva2hONXAxdmIwa1VSejQ3N3NFNkFVSlpFcFltanVCOWVU?=
 =?utf-8?B?OFpXdnVYMXk4MzRMK3RFUTdwUzZ4ODZwWXp5Q3JEbEtyL0QvK1pXN2pUVjdF?=
 =?utf-8?B?OVQ3bHVqdmlDdjQxNEU3NUJkZlY4b1VUUVU2MzFLUnpISHgrYk45am45MENB?=
 =?utf-8?B?SFZwS3RZUSt4SDFNR2JieDYwZCtsK1c0eFJIOXJlamg4U2tyalFEazJ1dkdu?=
 =?utf-8?Q?ElrWYQsqStYyG4/kHtNZrwM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <489DC09EA95C514A80A2D27E386F90F2@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: rgbkT+P2OOxcdX/POiCKJBF1fOAsk380/B1Y3qedCLM2MB1uoQT9EcghLJdRRceLBvBPtAIGExaSjf1OQSLko40S/Z8GnbaESEnp7QxZoD6J7yx6+jw13ykInCXYXH9w92DJzYKqFzHrFTlgQTmPsczEGFQRVpTcSLB03UYm+o40XPiMTMsUNy81OFFCl98V+QAnSSG21YFy8qdYPQjREieqI+e97ubbVfKbavUTU+kyYSZBOOpihQQ7UXPBUlYdSSy1h6zsljF93N0YbkO+eakNZzEQQ4W6ySTda4Xt5mh1KnVTeOkTFoSypSyd0hbReL833QYlLPOK55+FRTIh2p0D6l1Ek5RFXi+9zUTxcgxhwsWxqBEv/Rt57gBXdcNyDAZOzpODTBmpm0TTYfQILtqNHFQk4LbBjtQibj6Ce/p8iRZY7PUSwW5TrruPOjU1tvuMKy0pjkPyy+enlN9v9F0cLSu/+fYXy+DbtJavUEYi3uVylD/kNd+8Yve6yu0+GyAA7VVugEC13BeKZcFhLGKtegBF6KOywm3GvOr+af+5B1mDtCXFV+iwAA5ckED9dZAyi2g8wScvA/xNPiQ9MiLvSvLcKtM0GQAQn808d4zps0wE1lHusWUbelBh14z+HsNoug38W4Yu8vBtQ0khN6+UtvqteQA+oh6eRyzGnFp3eHrdLmJKi5a75NyCCeVC9sZhkmvmyx6tZ63pW3kwZLwIFKewjbiyh4fyUtSFo0n23jcU1AiLoLPPYjJokQlti/1YVkJVUKMH7toEQa1QmTiMmHCU9OS19xMqiTJQBM4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c85b214d-9429-4862-def1-08dafd6a37a6
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2023 17:49:46.8077
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: znG/zuh4+Jzy08shnu33gj2eSGZGwCbWZeKhpJRvSx6ht0uFtXrcscu0uODqc8Wg12wVTgKtKCoHfcbXhgyo/qb+k5YHH1nL1KSLHW/J+lY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4435
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 bulkscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301230171
X-Proofpoint-ORIG-GUID: 0lS0X96oIbDKPndSYvmi-n1jWRI1o23t
X-Proofpoint-GUID: 0lS0X96oIbDKPndSYvmi-n1jWRI1o23t
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

T24gTW9uLCAyMDIzLTAxLTIzIGF0IDE0OjEwICswMTAwLCBDYXJsb3MgTWFpb2xpbm8gd3JvdGU6
DQo+IE9uIEZyaSwgSmFuIDIwLCAyMDIzIGF0IDExOjM1OjEyUE0gKzAwMDAsIEFsbGlzb24gSGVu
ZGVyc29uIHdyb3RlOg0KPiA+IE9uIEZyaSwgMjAyMy0wMS0yMCBhdCAxNjo0NSArMDEwMCwgQ2Fy
bG9zIE1haW9saW5vIHdyb3RlOg0KPiA+ID4gSGVsbG8uDQo+ID4gPiANCj4gPiA+IFRoZSB4ZnNw
cm9ncyBmb3ItbmV4dCBicmFuY2gsIGxvY2F0ZWQgYXQ6DQo+ID4gPiANCj4gPiA+IGh0dHBzOi8v
dXJsZGVmZW5zZS5jb20vdjMvX19odHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vZnMveGZz
L3hmc3Byb2dzLWRldi5naXQvcmVmcy8/aD1mb3ItbmV4dF9fOyEhQUNXVjVOOU0yUlY5OWhRIVBp
UHQyREp4dmJETHdSSkFYc2c1YnVzM3N1dXN0WVBLSEpGbklZOFV1N2g4UXlGSnBEbzhyVkFqcjBB
LWRwR01Qdjcwcm14MDZib1g1aElPJA0KPiA+ID4gwqANCj4gPiA+IA0KPiA+ID4gSGFzIGp1c3Qg
YmVlbiB1cGRhdGVkLg0KPiA+ID4gDQo+ID4gPiBQYXRjaGVzIG9mdGVuIGdldCBtaXNzZWQsIHNv
IGlmIHlvdXIgb3V0c3RhbmRpbmcgcGF0Y2hlcyBhcmUNCj4gPiA+IHByb3Blcmx5DQo+ID4gPiBy
ZXZpZXdlZCBvbg0KPiA+ID4gdGhlIGxpc3QgYW5kIG5vdCBpbmNsdWRlZCBpbiB0aGlzIHVwZGF0
ZSwgcGxlYXNlIGxldCBtZSBrbm93Lg0KPiA+ID4gDQo+ID4gPiBUaGUgbmV3IGhlYWQgb2YgdGhl
IGZvci1uZXh0IGJyYW5jaCBpcyBjb21taXQ6DQo+ID4gPiANCj4gPiA+IGQ4ZWFiNzYwMGY0NzBm
YmQwOTAxM2ViOTBjYmM3YzVlMjcxZGE0ZTUNCj4gPiA+IA0KPiA+ID4gNCBuZXcgY29tbWl0czoN
Cj4gPiA+IA0KPiA+ID4gQ2F0aGVyaW5lIEhvYW5nICgyKToNCj4gPiA+IMKgwqDCoMKgwqAgW2Q5
MTUxNTM4ZF0geGZzX2lvOiBhZGQgZnN1dWlkIGNvbW1hbmQNCj4gPiBPb3BzLCBDYXRoZXJpbmUg
YW5kIEkgbm90aWNlZCBhIGJ1ZyBpbiB0aGlzIHBhdGNoIHllc3RlcmRheS7CoCBEbw0KPiA+IHlv
dQ0KPiA+IHdhbnQgYW4gdXBkYXRlZCBwYXRjaCwgb3IgYSBzZXBhcmF0ZSBmaXggcGF0Y2g/DQo+
IA0KPiBJIHN1cHBvc2UgeW91J3JlIG5vdCB0YWxraW5nIGFib3V0Og0KPiBbUEFUQ0ggdjFdIHhm
c19hZG1pbjogZ2V0L3NldCBsYWJlbCBvZiBtb3VudGVkIGZpbGVzeXN0ZW0NCj4gPw0KVGhhdCBw
YXRjaCBoYWQgZXhwb3NlZCBpdCwgc28gSSBoYWQgYWR2aXNlZCB0byB1cGRhdGUgInhmc19pbzog
YWRkDQpmc3V1aWQgY29tbWFuZCIgc2luY2UgaXQgZGlkbid0IGxvb2sgbGlrZSBpdCBoYWQgbWVy
Z2VkIHlldA0KDQo+IA0KPiBBbnl3YXksIGZlZWwgZnJlZSB0byBzZW5kIGEgbmV3IHBhdGNoIHdp
dGggYSAnRml4ZXM6JyB0YWcuIEl0J3MgZ29ubmENCj4gYmUgYmV0dGVyDQo+IHRoYW4gcmViYXNp
bmcgZm9yLW5leHQuDQoNCkFscmlnaHR5LCB0aGFua3MgQ2FybG9zIQ0KDQpBbGxpc29uDQoNCj4g
DQo+IFRoYW5rcyBmb3IgdGhlIGhlYWRzIHVwLg0KPiANCg0K
