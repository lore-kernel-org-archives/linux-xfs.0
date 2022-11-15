Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8AF4C4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Nov 2022 23:03:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbiKOXDa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Nov 2022 18:03:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbiKOXD3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Nov 2022 18:03:29 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73FA960E2;
        Tue, 15 Nov 2022 15:03:27 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AFME4Ys005216;
        Tue, 15 Nov 2022 23:03:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=YRejPK8t+Bhg8ryXu+C6Xqh8LxQ7IkqM8F87hmeZchQ=;
 b=NmxYser//Q9sTjRX1FVPE/Eb9gajfNZ/WxpSVTG+OoKt3jv/a+Q/YmYGHPIXGxEogMKa
 dN5cNCtvLu1RNV/FbfjqpmodlHE+TOp7BuPfQ2yN+KWsXkN80+PpIJ//dD85udmTDqnL
 pbaSk6No+EoPyMQbZnpRJ2HjpA6ds53kRxjuvzGHKZlyUoh2DzYiIJcg+ZMMZEgLy6D3
 pvTvEPv8BDfcYRvNVoE75TlLeXS8SFa6H9sF/GM4GmAW/uwolt0xdLQoCLvmderAeRtG
 pRXbWm6ouJtA3o/kdJtOgJwFohZJG1S3fcSmAJD3xvP17p9+tfr8QKYlL3kpIaQ4fpER sA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kv3ns36yn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Nov 2022 23:03:25 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AFL7UZs001490;
        Tue, 15 Nov 2022 23:03:24 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kuk1wcj81-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Nov 2022 23:03:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IB8rWLrhlAiRrsMjDfUoLGZs41Ih4a5V3/4zoAUujm1h5svRfipJYoMucxsr3v6nGafJyKnajNWgHwtmNMkgOKZrrWr2r33YHgjeWNgj3L+L5h6s8XtQkBIaj3/w806c9bRrKEveK0aMptC4JnBhtD/NpxMsqkVZxDOaQYh7+dk9Y/O12kLzrgourrZPkGJq/F/T+bjL5AXAy8T9JkXJLHDeYqPUs/2LHJu79idVHc3oHAWdsNv8UrNczLShJ/Crao9kwDXPMS/MOf+TjAQ5/FgA4AO53Dbfn4UfhanC2ehG6iH7WOKJYtWk1idZ5iRn1z6u2Ja9gy26uEJ4JwMfDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YRejPK8t+Bhg8ryXu+C6Xqh8LxQ7IkqM8F87hmeZchQ=;
 b=AJigqXWTDxAOMGO4WzeLkSs48waTEd4cfBp5cNFReSA92Cnv8aQcWDjX6BVLR3b0HDmnsepPFwhrV5853RmCbFOgH6lJ3h/gUVWWo6hkasbeW8h3fxIkoE0JOoC9nM3/5Hp2YnbTkUHjJrOY+8mneKwotE5T05IXIqumn8lrbozsIJYEUCMfYVIAoPiWKzPEPwtD/KjxsucS7vyaLIH/7cHRJbmyqHpRLS6FB4YsUblae2EMUoPpm8/wcJ35R/Ji+/tAy762LZ9Ui3pSn/kQAjW80OGHICe9y/ILdvjsfJ4QACmUfQlniL56NywqOs6miHVP6UavOS/HMC/unNQp8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YRejPK8t+Bhg8ryXu+C6Xqh8LxQ7IkqM8F87hmeZchQ=;
 b=XV5/C182NYQdKnHOu57Z2JVvIqYEqhSLiAwstVeGeTDDBQnU7FSPeNVoxItB4HwBzzGjpkcQMVoElna5fTebitvOaFZeXqggiECkftsQlVr2J6KB7ZR79hsbLxw1pG53VOm+TIPpCshcxeAFfLPq6gMgwfJcgTNAs1Y2K39BlNc=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DM8PR10MB5399.namprd10.prod.outlook.com (2603:10b6:8:25::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Tue, 15 Nov
 2022 23:03:20 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::e1d1:c1c7:79d:4137]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::e1d1:c1c7:79d:4137%5]) with mapi id 15.20.5813.018; Tue, 15 Nov 2022
 23:03:20 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     Zorro Lang <zlang@redhat.com>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "fstests@vger.kernel.org" <fstests@vger.kernel.org>
Subject: Re: [PATCH v1] xfstests: test xfs_spaceman fsuuid command
Thread-Topic: [PATCH v1] xfstests: test xfs_spaceman fsuuid command
Thread-Index: AQHY+UZ0aRhN9aWn2kyma4b+TeoJFA==
Date:   Tue, 15 Nov 2022 23:03:19 +0000
Message-ID: <4FAE30C5-DC4B-473E-96E3-5FEA97814042@oracle.com>
References: <20221109222630.85053-1-catherine.hoang@oracle.com>
 <20221112142416.hhf7dis74rua5xti@zlang-mailbox>
In-Reply-To: <20221112142416.hhf7dis74rua5xti@zlang-mailbox>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BLAPR10MB5316:EE_|DM8PR10MB5399:EE_
x-ms-office365-filtering-correlation-id: dbad056a-1d0c-49a1-d09f-08dac75d96ad
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Va734+Og5DXkjudCJOQe/P+3BWlzt37HFp4TzOG9K5shmXcmNO3Z28O5ZuZefblIM1UeHfyLQrbEGkGV7clAcVNkYWYxd2v7dKMfyYHJWoXZqaLSzMdoNL8mT7Ys+psr97JlHcRA1svnbaZk2aue/o2F/AuOdwxY8S5phCHggOSl9DSu1ufWFqvp3+gAH8p3AXvJchNs6ypouC5MAkwwJwlvRZq1IMdJlzqTay9NzDMxvpTxPwQOutqle67sT1OYdwXcyQpN5QdZevhQp3gcs0/K2h704Gly1PVZvicS8NH22k1soSxGU8pHVQ2FUqjjaCrPej3Rn6APb557bicyjTMu6iFebHPfT8qy3BFPzJZmJ55nPQjLlfZlmPynfj4tkhoUhJZT/ypj09DgYV/l+qoanh8QsiFbiBeIyIVOWvQXW3hNYlb/jvzsuiwkAYjC/krYTwzbQfeoCCEgtXiIOg1VS9NQCRD2LVqu97/di6PU9Mxy6yG0q5fz8c1pv9Asgv36dbLXAcEG1LPJ1caHADP4WvC+SaIdvBpcP9PB/O4zfnIpg6+Rgj9OCSpSX0WID/Lce8OlzbueJ264s9tnehxRKjHPfFA8IRiN9qN2986kYKbSou2TgQJphbuKvvhRB+oULtnHa25tqxWulXGirR3phyrzhz+LkTLvhr6mmeEsPUOt3cbm3uyia137qWbrJc7JlQjUQAgffOExiMZLnxxIhuZOuz0iBFx8seTT1AdBcS6/IVx9w6ZzeHjy3CKkrBj3f/w7vtXHpJH25G2Flt49xkEVuduLZRPUb1GckVM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(346002)(39860400002)(136003)(366004)(451199015)(186003)(6512007)(83380400001)(316002)(54906003)(6916009)(71200400001)(53546011)(36756003)(6486002)(6506007)(33656002)(2616005)(86362001)(38070700005)(38100700002)(122000001)(44832011)(2906002)(91956017)(66446008)(8676002)(4326008)(64756008)(478600001)(41300700001)(66476007)(76116006)(66946007)(5660300002)(8936002)(66556008)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VldYWFJTUnMrWmw2ZS8vb3ppcGtKbkhwZlluak8ydHVteEY2TTZjVHV6aC8v?=
 =?utf-8?B?YnBYNUE5WEQ3R1dvMFkrVlFTUHFNZXFSNUM2ZVIvTnFrNEpSV3ZMcm5FUjVQ?=
 =?utf-8?B?STlWZjIyK3hRMXpjRzVjc1hLdjl0NEJZbjV1MXY2aHY0TWxnbXJyTEZucE12?=
 =?utf-8?B?cVJBSHNnak1lTThrUUpMQlQ5OVcraWU2VS9iZG54enRZNU1hVC8xM1o3S1ZG?=
 =?utf-8?B?dDR4ZmpHejZUNytjQStDdGpkdzJQNEMvMDQvSFkwUnlxT1puQ1RzQTR5aWJi?=
 =?utf-8?B?NlNVdWRUYkt4NjNhWmo5WFp4OHpwUVBHbEprY2xzdTFWMUpZdGxTZjltZWtl?=
 =?utf-8?B?ZkZ0L2xxb0hERndFYTQzNmJ6VTJMdERvMTNLMVBKQnNJRkJnb01lN3pIVzBl?=
 =?utf-8?B?UW5NUDJXSDdvOWovelJVSXdwQzJlN3EyUUo5aUd4UStCVUxzQlJhd3hmek4x?=
 =?utf-8?B?aURxTHkybEFvY2dFUFZzN0RIcFJxREFtWm14ZURGeURKeS9MeEFJNmhtZEdC?=
 =?utf-8?B?dEFMVnJYWjVqNkEzb21Ib0hOdnUrZkpud1VBY2xlVjdSNlhiRWJlY3U3Vlo4?=
 =?utf-8?B?RFRJOHZLUlVGck9LTEN6MHU5UHhJME1SMDNsd1BySTRpYjlVR0UzUHk1NUIx?=
 =?utf-8?B?aWh6aUVhaUlORTBCWEIvOGpORVc2dTBCemNwWlRoYkFrWUJFQ3h2SmdzeWdZ?=
 =?utf-8?B?em5ZM3Q0V1hpZWhIZDkzOWJnNERXNXNvQXM2Vi9mL055UVhlRUwzWjQ3SHEw?=
 =?utf-8?B?djV5bnZ5R2U0bGg0cCtpbGQvNTJUOTlBMURqY1F5Ym5Rd0JJT0V3bmgxYkNI?=
 =?utf-8?B?M3duR3NCMmpoY0dmVnBmR2NGNXhEVVIvUVloRnc1NDRpcGF4WGVqS3RwdEZU?=
 =?utf-8?B?djRtSXdYKyt1T0IwMUhDMnBxRGtVS01uSWFyZmFtYThXNTN3OUthMEFJMUg1?=
 =?utf-8?B?VEdkMnNoUUpaVlQrVGlzbkxtYUFaRUVOVm0vR3lZL3ZISDRua1E2czZZM2ZC?=
 =?utf-8?B?aUExRnNsQVhQSnhXc0szaUdiSVFDSW5JV2Y3Wjg3QUlDUnkzL1Z2RWp1T1Zx?=
 =?utf-8?B?WnhYejM1Y3Fva0p5V3laankvUXBvWWxPTWlhMVlVbGgwOS8xR3p4UUduaGdT?=
 =?utf-8?B?QU42NEo3aUpka05EZFZEV2ZCQ09Od1pzUnVlMTRWWmtxcHZKL1ZSdW5qamJv?=
 =?utf-8?B?bEZ1ZzFEM1dqT2E3cVVIZnV0Z0lRbFdsYi90VzZrSE9OSDdabU1jRlcrUTho?=
 =?utf-8?B?ZXh6dzFKRDlORDBRdndrMmlkbzdhUUVUKzlvV1dJcFNFMW1Fc2NJdllJMkJT?=
 =?utf-8?B?a2lObHFGdm5WY0tTNXRXbHZJUnpwMENsR2hkNGN4dnpTVHg2V1lYVVc5bkxW?=
 =?utf-8?B?V3QwYzhtRE54c2k3VktRcmdYc3ZqNTlDQjYwSXpzNzNqVUxRamR2WnFNTitT?=
 =?utf-8?B?MzRCRUVXbjByWElDMjdsUlM5MzBhUGRJTW5NSVVCWjFYNHlzcUNqOEh3MS9l?=
 =?utf-8?B?SG5GQkFEWWNnSUdzZ3R2ODlIZmErOFNHc1dnNUVTRnFSZFE2bkFacTg0c2JH?=
 =?utf-8?B?WHlKdlVyUERybnk1cmg2VFhqVU5lbURYd28zcGFCYmhRVTQ4a1UzWkZmeFBD?=
 =?utf-8?B?bGNBaUE4dEhWZ1A4Q01YR0Jjc1ZZdytBQktTeWpqRkZYSnQ1S2d3UGVPZWFo?=
 =?utf-8?B?VmJMMmlvL0xBaElCVFRSRHR1Umh2OERZK256K2xxQW8ybnNLTWoxNVRlM2px?=
 =?utf-8?B?bWpLZy9pOWk5LzRMVURCQmFIMEpTbmpodG8rR0JWTWxLVjFWT3Uzc3JaWUx3?=
 =?utf-8?B?cWM4ckxDM000aUU5YjB1UzR5eUJwOXlEamhpbTkzQnVJZUJNQVF4R3hmMTJ4?=
 =?utf-8?B?UzUrdHI2Q01tdDJtM2xMK09HUGZiZTl6akErNHcwOW0wVml1eEpOSnltUWZZ?=
 =?utf-8?B?V1RSRDREemNXeDBiQzVSQWFIVWFLUXJ5Q2JxcWFpTFZwSEt5bldHSzhZek5l?=
 =?utf-8?B?TjlZcHFucDl1Z1lEOU9zbFloY0RsRmR3VnMvcVBmd2ZwcDRmMXZiaSs5NFBL?=
 =?utf-8?B?aXFoamV6aFh1dEFlQzlSWENBVDF3ZS9IZTVXYk9oVDJVZXpBQy8wWFV0V1NN?=
 =?utf-8?B?WVJSUGd0SjhLNlZ6VnhTSDE3bENDZUxZcmpnYlVFYVdRLzZUUHVTK1IwVG8y?=
 =?utf-8?B?SitsOVhGWFhKVVJ5RnJqVEtieW9YMXU5WEQ0REpWTGJURWlDdSs4YzVtdmNO?=
 =?utf-8?B?VUpUdW5ma1VsWmxzZTcyejJ4dkFRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <78CB82027D3F4F46BA59ED1A01845DB7@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: irkBTGCLgTI/M9ef8WOZxeqny8yQk+QqjvnaqQN2SBsFzfskaGZnyO3H6+E4bbvtzqUlTdhtj/o8c0HjPliz8XbfByS/BCP//WQ+MnJ3lmyG60Mda/aZBKrHCTD8mUw6LCSxnB0Ggzar5t6So7HjFm6ZnrNhb+sM/DL5SpL9sbixdXgAPMA/JMzDp5CXC6pUCC5iE+UtXFzPwk5BQ4n8ufoO5MsJi+YuIzjt/y3TpkXBLVdRJejFosHxUYSbpuMnqfvsOpye/8wC/Uv8oHvZnws8VIFTg8g3mDf6zHFWMCZYc6qLdYwUYEOw+SwQgD10xrV9yYwGy/wyC9GJ4IXaOkaHSMsjBFTrL6hTf9K6J9tQDqYYF/3p0fDxMViGFlgW5cnu+CxXQvn6taeUvoyb69zQ/x2QPXnF1eRDofOewsheXPXhz20w0yd03JrJRVQ4T8n+l8nwaFpqd7iTKXWgkQyBAYIu0sMW7pVK3uiNkKCxjs7OONqoqO3ZT7GlwDpSRE9s60AemJsLSNssLWL6/DoUTby2xTqU0oEOkSvtWn22f5jD8UjFLpRP5OAOY78rR2G41MKZQcYPuLyaDFfvoRiZ20o2Ih6oXxeOvzLwWJOstRdRk9fJeqZ/kN2i/AKsVxECXxuvtcEty2jGb5CG9h9BprhjaSHSCYwPSeqeQ+pB700RMH83TsXJwXf9Xkx4lD0g4nBb/eS4gh3asFClPAJu+/4J8hWxq9iLtmPusjz1ENkvJupwI7MlEhjJeyTU1PeiARmXHbHMSutOCYfTJf9f1OILhPDbq35Wd/Tc2++UAAm7L0rAdkFkgX7y2sscd0TsYEo7NelIFJrp2l92Ig==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbad056a-1d0c-49a1-d09f-08dac75d96ad
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2022 23:03:19.9893
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b4xr6ROKs74lOHa3gbUpO1H/r8OmUa0yLgTsaaxrAGPyqnNT6OiYY2QMtrua5sHa3av915VzzqYcPxW0kmU3wC2BMQ79k+zgvh71rNj4TwY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR10MB5399
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-15_08,2022-11-15_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211150159
X-Proofpoint-GUID: PpqyV6V_Klo7QrKJWsdTETh_eZ0cAwmX
X-Proofpoint-ORIG-GUID: PpqyV6V_Klo7QrKJWsdTETh_eZ0cAwmX
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

PiBPbiBOb3YgMTIsIDIwMjIsIGF0IDY6MjQgQU0sIFpvcnJvIExhbmcgPHpsYW5nQHJlZGhhdC5j
b20+IHdyb3RlOg0KPiANCj4gT24gV2VkLCBOb3YgMDksIDIwMjIgYXQgMDI6MjY6MzBQTSAtMDgw
MCwgQ2F0aGVyaW5lIEhvYW5nIHdyb3RlOg0KPj4gQWRkIGEgdGVzdCB0byB2ZXJpZnkgdGhlIHhm
c19zcGFjZW1hbiBmc3V1aWQgZnVuY3Rpb25hbGl0eS4NCj4+IA0KPj4gU2lnbmVkLW9mZi1ieTog
Q2F0aGVyaW5lIEhvYW5nIDxjYXRoZXJpbmUuaG9hbmdAb3JhY2xlLmNvbT4NCj4+IC0tLQ0KPiAN
Cj4gSG1tLi4uIEknbSBhIGxpdHRsZSBjb25mdXNlZCB3aHkgd2UgbmVlZCB0aGlzIHRvb2wgaWYg
d2UgYWxyZWFkeSBoYXMgYQ0KPiAieGZzX2FkbWluIC11IiwgYW5kIHdlIGV2ZW4gZXhwZWN0IHRo
ZXkgZ2V0IHNhbWUgZnN1dWlkLiBFdmVuIGlmICJ4ZnNfYWRtaW4gLXUiDQo+IGNhbid0IHdvcmsg
d2l0aCBtb3VudHBvaW50LCBidXQgaXQgY2FuIHdvcmsgb24gdGhlIGRldmljZSB3aGljaCBpcyBt
b3VudGVkLg0KPiBBbmQgd2h5IG5vdCBsZXQgeGZzX2FkbWluIHN1cHBvcnQgdGhhdCA/DQoNCldl
IGFyZSB0cnlpbmcgdG8gYWRkIGEgbmV3IGlvY3RsIHRvIHJldHJpZXZlIHRoZSB1dWlkIG9mIGEg
bW91bnRlZCBmaWxlc3lzdGVtLiBUaGUNCmV2ZW50dWFsIGdvYWwgaXMgdG8gaGF2ZSDigJx4ZnNf
YWRtaW4gLXUiIHdyYXAgYXJvdW5kIHRoaXMgY29tbWFuZCBhbmQgdXNlDQppdCBmb3IgY2FzZXMg
d2hlbiB0aGUgZmlsZXN5c3RlbSBpcyBtb3VudGVkLg0KPiANCj4gQW55d2F5LCBJJ20gY2FyZSBt
b3JlIGFib3V0IGlmIHRoaXMgY29tbWFuZCBpcyBhY2tlZCBieSB4ZnMgbGlzdD8gSWYgeGZzIGxp
c3QNCj4gd291bGQgbGlrZSB0byBoYXZlIHRoYXQgY29tbWFuZCwgdGhlbiBJJ20gT0sgdG8gaGF2
ZSB0aGlzIHRlc3QgY292ZXJhZ2UgOikNCg0KVGhpcyBpcyBzdGlsbCB1bmRlciBkaXNjdXNzaW9u
IG9uIHRoZSB4ZnMgbGlzdCBzbyBpdCB3aWxsIHByb2JhYmx5IHRha2Ugc29tZQ0KbW9yZSB0aW1l
IGJlZm9yZSBpdCBpcyBhY2NlcHRlZC4gVGhhbmtzIQ0KPiANCj4gVGhhbmtzLA0KPiBab3Jybw0K
PiANCj4+IHRlc3RzL3hmcy81NTcgICAgIHwgMzEgKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKw0KPj4gdGVzdHMveGZzLzU1Ny5vdXQgfCAgMiArKw0KPj4gMiBmaWxlcyBjaGFuZ2VkLCAz
MyBpbnNlcnRpb25zKCspDQo+PiBjcmVhdGUgbW9kZSAxMDA3NTUgdGVzdHMveGZzLzU1Nw0KPj4g
Y3JlYXRlIG1vZGUgMTAwNjQ0IHRlc3RzL3hmcy81NTcub3V0DQo+PiANCj4+IGRpZmYgLS1naXQg
YS90ZXN0cy94ZnMvNTU3IGIvdGVzdHMveGZzLzU1Nw0KPj4gbmV3IGZpbGUgbW9kZSAxMDA3NTUN
Cj4+IGluZGV4IDAwMDAwMDAwLi4wYjQxZTY5Mw0KPj4gLS0tIC9kZXYvbnVsbA0KPj4gKysrIGIv
dGVzdHMveGZzLzU1Nw0KPj4gQEAgLTAsMCArMSwzMSBAQA0KPj4gKyMhIC9iaW4vYmFzaA0KPj4g
KyMgU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjANCj4+ICsjIENvcHlyaWdodCAoYykg
MjAyMiBPcmFjbGUuICBBbGwgUmlnaHRzIFJlc2VydmVkLg0KPj4gKyMNCj4+ICsjIEZTIFFBIFRl
c3QgNTU3DQo+PiArIw0KPj4gKyMgVGVzdCB0byB2ZXJpZnkgeGZzX3NwYWNlbWFuIGZzdXVpZCBm
dW5jdGlvbmFsaXR5DQo+PiArIw0KPj4gKy4gLi9jb21tb24vcHJlYW1ibGUNCj4+ICtfYmVnaW5f
ZnN0ZXN0IGF1dG8gcXVpY2sgc3BhY2VtYW4NCj4+ICsNCj4+ICsjIHJlYWwgUUEgdGVzdCBzdGFy
dHMgaGVyZQ0KPj4gK19zdXBwb3J0ZWRfZnMgeGZzDQo+PiArX3JlcXVpcmVfeGZzX3NwYWNlbWFu
X2NvbW1hbmQgImZzdXVpZCINCj4+ICtfcmVxdWlyZV9zY3JhdGNoDQo+PiArDQo+PiArX3NjcmF0
Y2hfbWtmcyA+PiAkc2VxcmVzLmZ1bGwNCj4+ICtfc2NyYXRjaF9tb3VudCA+PiAkc2VxcmVzLmZ1
bGwNCj4+ICsNCj4+ICtleHBlY3RlZF91dWlkPSIkKF9zY3JhdGNoX3hmc19hZG1pbiAtdSkiDQo+
PiArYWN0dWFsX3V1aWQ9IiQoJFhGU19TUEFDRU1BTl9QUk9HIC1jICJmc3V1aWQiICRTQ1JBVENI
X01OVCkiDQo+PiArDQo+PiAraWYgWyAiJGV4cGVjdGVkX3V1aWQiICE9ICIkYWN0dWFsX3V1aWQi
IF07IHRoZW4NCj4+ICsgICAgICAgIGVjaG8gImV4cGVjdGVkIFVVSUQgKCRleHBlY3RlZF91dWlk
KSAhPSBhY3R1YWwgVVVJRCAoJGFjdHVhbF91dWlkKSINCj4+ICtmaQ0KPj4gKw0KPj4gK2VjaG8g
IlNpbGVuY2UgaXMgZ29sZGVuIg0KPj4gKw0KPj4gKyMgc3VjY2VzcywgYWxsIGRvbmUNCj4+ICtz
dGF0dXM9MA0KPj4gK2V4aXQNCj4+IGRpZmYgLS1naXQgYS90ZXN0cy94ZnMvNTU3Lm91dCBiL3Rl
c3RzL3hmcy81NTcub3V0DQo+PiBuZXcgZmlsZSBtb2RlIDEwMDY0NA0KPj4gaW5kZXggMDAwMDAw
MDAuLjFmMWFlMWQ0DQo+PiAtLS0gL2Rldi9udWxsDQo+PiArKysgYi90ZXN0cy94ZnMvNTU3Lm91
dA0KPj4gQEAgLTAsMCArMSwyIEBADQo+PiArUUEgb3V0cHV0IGNyZWF0ZWQgYnkgNTU3DQo+PiAr
U2lsZW5jZSBpcyBnb2xkZW4NCj4+IC0tIA0KPj4gMi4yNS4xDQo+PiANCj4gDQoNCg==
