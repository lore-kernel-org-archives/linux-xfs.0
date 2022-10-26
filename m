Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CD7BC433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Oct 2022 07:40:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233311AbiJZHkk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Oct 2022 03:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233318AbiJZHkc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Oct 2022 03:40:32 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C83252BC6
        for <linux-xfs@vger.kernel.org>; Wed, 26 Oct 2022 00:40:23 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q1naaC024687;
        Wed, 26 Oct 2022 07:40:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=HpAELh/9f2yiVjLX03udixxP5zHqmLCauqB7skmuVBo=;
 b=UlNHYodKGa1un0hCASqNpWHPXwvh3EUX1NHWqvsT4/RBNQV6o9OaygoNGmcgZ1UDXiEG
 dJjCENia21spSh9NofUWig9hPKJH7SpkhVsOWU9ktNgwagg88mrFozs3AhhOWkSaNE/P
 m3MnX9/2rKk2IfMivReTIvXlGJiKTa6RLrJ9Fl2w8WFPB0hlVmNqGE6+Yo5koJMUKgJV
 UwPgpj254Wjou8sWWBSZ67jbg+n2/vEsd2pZQcTYqQIm5FvtCMeiuqO6P6bLuSWwsmCN
 FGYokkdrYmOf1W0vcAbepxb9k/0Z8T3Zo0Tmi4kniA2Wv260EGXDvGrmqVnswygcFW/F Kg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc8dbnfpq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 07:40:13 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q7BAK0022057;
        Wed, 26 Oct 2022 07:40:12 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6ybrtqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 07:40:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FxZtgxuI0O+iWl7s+kQf1lxkBDLhnICeOLgCL52ddl6lT0vATrVVdgn//5ivwlwGFq+aJ0UIljae5RHCIhjQpWEkm2xPwofYfi+UzQWVAWg5e5RI/rG6L7Ti0sBsYbr9tDFjM5u+3R0dTpu+7rEpVswb1hHpDG3NHJwuQd0v9EdpJM6v9GQskQ51/ru2s/oh6s4t4ALLLpaRNRo2HXscsTFIgqNue4kFNnW43T/oAywFwVhpvqLbgd34GUiFwezj032zo3lqCmIaU8qAZwFWWSIwmHSiYVioWjY/jNx2Xt1fI45Eqw3JhyVXE0RbwwstdltwBNwxhSphjtSBF5sIAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HpAELh/9f2yiVjLX03udixxP5zHqmLCauqB7skmuVBo=;
 b=ABDe8h6HlgBvIyTh5tQ/zsvC4jw6CmE654KqjD4iWnrmCTZ6Ns9GcB6DtzQhkFgA7wQFgi2YPw22bZMSEbxryhyPsl7UE9sAPB/kxa4phaMIOtL4S/WjrMRmugEz9UBTmiKb5kTHQXs1nyhfbTRknCXVgBhrHtNYTndKu7lSBcz1qqmmPxl7PWkLaojryazFfkwk5IAdFc51yC1RjQG0i8gHsh9vbLnpuGMYq32NfgvnLa+S54a2tLbi+wk8pVZbMc4P/aYoaucQkbQQH7Y08OIQhCz6srmyPvRngqble1rwOz5Vl5MAeWVXCi7p66+EYyWGA49AFjYxfhcvN5eHNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HpAELh/9f2yiVjLX03udixxP5zHqmLCauqB7skmuVBo=;
 b=HPotb5lIVkMh6Yz9fGHLg1Z2NR0wZpyLwb60X6eegu4en4Af1xCUOiWzq48fmpbjOU9h2yDuWTZqt0qagpvyrRZhizIYsP63t0mKT0GWWvyxPAco4a1MImIREj9diTFiY6AHh1ijFtAQF1UMiBeUgvuPJOWpTV+AyKzxwb0A9f4=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DM4PR10MB5991.namprd10.prod.outlook.com (2603:10b6:8:b0::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.33; Wed, 26 Oct
 2022 07:40:10 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5746.023; Wed, 26 Oct 2022
 07:40:10 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     "djwong@kernel.org" <djwong@kernel.org>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v4 24/27] xfs: Filter XFS_ATTR_PARENT for getfattr
Thread-Topic: [PATCH v4 24/27] xfs: Filter XFS_ATTR_PARENT for getfattr
Thread-Index: AQHY5Zyz9IA/PlI+H0ihMeiUgoAoC64fp9sAgACpRQA=
Date:   Wed, 26 Oct 2022 07:40:10 +0000
Message-ID: <168183071107ae70bce990439d66a6840f969f70.camel@oracle.com>
References: <20221021222936.934426-1-allison.henderson@oracle.com>
         <20221021222936.934426-25-allison.henderson@oracle.com>
         <Y1hWXBsi/BPii7qW@magnolia>
In-Reply-To: <Y1hWXBsi/BPii7qW@magnolia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.1-0ubuntu1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4306:EE_|DM4PR10MB5991:EE_
x-ms-office365-filtering-correlation-id: 2f42a956-6a55-4871-0208-08dab7254fdb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OYrZ/dfGo9LjM1uk0uTVQBTrg0zr/YpL0R+mcSFyKoAyEmQqR37k72jPt5aUw+OtQdvV/IzBTE57DGI1ZxDSvlp/rgGtvRN+JJ9SMUfvfYwEhCfrwWWwVl6KKAvilmLmjgxtB8TM3EAloC+Jb120FXx9YC59LAHl9iO98YjmmfzV0XjTm6BoEzoG12XhqLZd1hWvLb84I2i4iOH6TGKc5aHOyTA+aAyix/b1bOUz6Smjegm7r3USH7d6elFmyBnLkP4+X1OYLzAHkcu1tCU0FjRvZepizTX1svp14SZPnmX5r4IRNteMCPOmCS2+nlye7ROm7vSJQGXWBzHlzkoIsJUKCBVsMmOYIB8qHRIihMpWSiInjmLdpXgk5F4ZqCQ7W84gZob1g7fWB8z6KZZ2e7aZDOXnlVecnMWCnva/bgxC0simEC2AiJplRb9jVez+mWpPEWqWXMDT6FGXJckk0/PR2r+OQiXAH1p/snaJWMg5g98yPSP4mu9jsRYhrhCWtc5kh0k3+dtoxoVavsECXXh5tqqV2YbjBDJRQKAmbdCFBpvGAqVspkUDtB035l+XwCFtCWQDkoBn9h6gj3YuO27F9zvfiOyoaFr3fLJ5F96t3bzY2sE2VgnJXdeksJB/UZT9iMpyxf6u9Rc5moYwFlu5kiNaANtZklchAz1qqMURrhU6hNbaL1eNlP9VgSOGB1IHPdej3BdTjTaQaodBiSPGvJGPWqvNMGqqSsxH+mvdV6cBy7k7vKcGEL8b3+rS
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(376002)(39860400002)(346002)(136003)(451199015)(316002)(66556008)(44832011)(86362001)(66476007)(66446008)(4326008)(6916009)(76116006)(66946007)(2906002)(2616005)(186003)(64756008)(4744005)(41300700001)(8676002)(8936002)(6512007)(478600001)(26005)(71200400001)(38070700005)(4001150100001)(38100700002)(6506007)(122000001)(36756003)(5660300002)(6486002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dUJUM1dITkhma2dhbDlMUU1XQ1RhWE82WitpanVXNVRnYjdoN1dES2lQdmhu?=
 =?utf-8?B?bmhvcysxTk55N0tnbUVtUFpDWkFJTjRzdE42dnJHS0dvdEtrQXd1dWZJOXZQ?=
 =?utf-8?B?NXR1T1VscVdLMUJnN3dXeVJUeDBFTFgydEdKVWYvdGlYRWJjdlU0eVNRQU9r?=
 =?utf-8?B?WDMxaXhtSTQxLzNPdVZmb2ZaZy80ZkQyMHZDbmN6ZEZJNnlCRVpoWnR6bi9s?=
 =?utf-8?B?cDJ2dkpIb28rUjMwNWJORVY4Z1Fkd09CWG1jNHFHcmMrWDJCUG40NWIrQjRj?=
 =?utf-8?B?UjZaRzZDSUdIODJGZ0hRR09LSVBnaGM4eElBSU9UczBBRlptT2VhZFFBeTZK?=
 =?utf-8?B?bGJ1L3BnTUtNL1drMzVRZ3RRNis2R1c0VkNUdFJtMngwRDhMaUNEZjFjeXJM?=
 =?utf-8?B?cEpKbWwxZnZJV09PY0ZWYnZ1N0JuVkh4UHgyRWZZeTI4WHVEbmNHYzZic256?=
 =?utf-8?B?QkRIRXBpM3Q5eS91L2xKVTNDZ1ZwVGYwL2p5VFJ5by9DZU5aN1V0LzBsMUhR?=
 =?utf-8?B?MW9qZ3pUN1lVRTdWaWpBNVRZSVF0OWFocWw0TVJsN1dtWFNDdnpmOVNTdGI5?=
 =?utf-8?B?RkJkSjVSLzFqZzRkcVFYc1N3NWRpWnFMVnBBbDNFczBvejF3U0U2NzJhVWM1?=
 =?utf-8?B?TlA1MWM2NWNYMC9oMW9PVFE1THV0STR4dTZKU09qREV1WlVVMHg1V2VaS05Y?=
 =?utf-8?B?YU9PNGlwZmg4bUlRQU03aUpiL2JRVy81c00vMzFtb1hqa3V2YXRQWDYra2tY?=
 =?utf-8?B?czI4NW81NmVoWmZDQmpEQTlvMUxGSGsxNDY1UlVSckQzTzBUSEE1N3hQN3di?=
 =?utf-8?B?RFlha00wK3paY253NnI1SVhSTUVWeHJEK1Ewckw5VG5RQUlUbVVqNkdTVVpN?=
 =?utf-8?B?YmRDTlFHRUw3OUNSUlgzdTMyOTVuZURkTW81cmlLNFhyb2tRLzdKZGVtdUs2?=
 =?utf-8?B?RGRibXJTRlVDVTVIeFdEbWdxNFE5UVZiVmhDOHFWNVAwcXNaUFUrRjEzNFZa?=
 =?utf-8?B?bG9DZlBPTFZRRFpaS1ArQW9oTWdvNDNXRzI2bjFzVCtCQkJOMnlWbDNFRHE3?=
 =?utf-8?B?ZnpSWURkNUxrRFpTN0ZGY2JjSCtBajBGK1VzYlkyK3VxeE5MQ294UWR2Q25I?=
 =?utf-8?B?K1N4dXJGTnl5Vm9FQjRCZU1KemM3ZGdCSG1FVmlWTnNWd1dKMWQyemQ4ZGpV?=
 =?utf-8?B?UnZzY0Z4c3Vtek5TSlByOTFtdXhjWk5IeGZUZ1F6ODVGYTBQdjYwRjlhMTdo?=
 =?utf-8?B?MlljR0UvelJjVytLdGMram5pT3J5Qzc2SU5sUWd0dU1WcVZNQlJ2Y3pFQmI3?=
 =?utf-8?B?ejVtcERwTjViRDJwMERhVGkzV2lJcElOUmljUVpRV0hrY1VxRGcrc0FWaWhQ?=
 =?utf-8?B?NnhObzZRZGYwZGlNNkVOdVdhRUVvZm9MY0dtR2lnWmFnTGtDMlQ2UlhITDdu?=
 =?utf-8?B?bW5HcjZNdXlOZ0pVQ2hVbXlZZzI0dXlrS01aRmgzOFo4dHpWZFB4NzhMMlNk?=
 =?utf-8?B?NFJTM1REM3lDMmdWTW9ucDVXM3lVK0xjOSttMFN1UTFIeGh2bVZYeFNmb0Nh?=
 =?utf-8?B?RFAwOTBwNWlsNmpCM281K3ZMZnExNHMza28yUS9XdFZ1b0tPekorbmV2Q3h2?=
 =?utf-8?B?RlpCRVlCeVhpRHg4c25zOXVMSHVrdVJyNkY3c0tKcHcyMFdYSDBEOGlXZXVx?=
 =?utf-8?B?U0NYVzc3UUM1eVYzZmNic0RwQ1V1TlRoSEI5K0dieVhZTU0wQjcvL01yV2JD?=
 =?utf-8?B?MUY0YTBzU2NlS0g3RHljYlIxeUp4U3JrejE2dnZWV0JyYmFCNGpDc3Uvallq?=
 =?utf-8?B?WkZGaHNXdk5vbE5ZRFM5REtVMGx0bWQybTBoKzdSSEQ3Nlh6YzV2ZW81UDlp?=
 =?utf-8?B?U3lKN1JqWDB1bkYzMlVzdlYxN3NJUEg2aHZIRHI1Q1ZNdThLc21TSHVtTm04?=
 =?utf-8?B?eVdFMDFwcDdVSUpka0IvTVhaeVB5SGRhS2ZJdXcvZDVxVUFHYng4d09MemlN?=
 =?utf-8?B?RSszWkJFWkNYTFpUN3pSVTZvZ25XalkzTXVWajkwVkZjQXNwWjFGelBxYXNt?=
 =?utf-8?B?aG9GUk1KaEpUMkR1eTl5eUtRaVZzTTdGdTJrdkZBd3hRcFF2akh4SVdDZlEy?=
 =?utf-8?B?Zm9vUWh4b0NQaVhreThiODkwV2dLSS81b1JkREdMMkRSbWRLMndzWGVQeVFy?=
 =?utf-8?B?bkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6D10AC81FA11D848B9B4F1E5C3E43475@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f42a956-6a55-4871-0208-08dab7254fdb
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2022 07:40:10.7616
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OJd9ABlfrYA/Uy3T1KMIL/mmGsZEfkwmX8W+u+a0mP9En68toF3BVa/c41yd1g5hfMgTiQAsCH0cM87kLeGcTltGIdB7o7dxuW+SRsdZylE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB5991
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_04,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210260042
X-Proofpoint-ORIG-GUID: u8dX_MRtXtpx5gzaOPw0XtQW-_ZltGtH
X-Proofpoint-GUID: u8dX_MRtXtpx5gzaOPw0XtQW-_ZltGtH
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

T24gVHVlLCAyMDIyLTEwLTI1IGF0IDE0OjM0IC0wNzAwLCBEYXJyaWNrIEouIFdvbmcgd3JvdGU6
DQo+IE9uIEZyaSwgT2N0IDIxLCAyMDIyIGF0IDAzOjI5OjMzUE0gLTA3MDAsDQo+IGFsbGlzb24u
aGVuZGVyc29uQG9yYWNsZS5jb23CoHdyb3RlOg0KPiA+IEZyb206IEFsbGlzb24gSGVuZGVyc29u
IDxhbGxpc29uLmhlbmRlcnNvbkBvcmFjbGUuY29tPg0KPiA+IA0KPiA+IFBhcmVudCBwb2ludGVy
cyByZXR1cm5lZCB0byB0aGUgZ2V0X2ZhdHRyIHRvb2wgY2F1c2UgZXJyb3JzIHNpbmNlDQo+ID4g
dGhlIHRvb2wgY2Fubm90IHBhcnNlIHBhcmVudCBwb2ludGVycy7CoCBGaXggdGhpcyBieSBmaWx0
ZXJpbmcNCj4gPiBwYXJlbnQNCj4gPiBwYXJlbnQgcG9pbnRlcnMgZnJvbSB4ZnNfeGF0dHJfcHV0
X2xpc3RlbnQuDQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1ieTogQWxsaXNvbiBIZW5kZXJzb24gPGFs
bGlzb24uaGVuZGVyc29uQG9yYWNsZS5jb20+DQo+IA0KPiBMb29rcyBnb29kLA0KPiBSZXZpZXdl
ZC1ieTogRGFycmljayBKLiBXb25nIDxkandvbmdAa2VybmVsLm9yZz4NClRoYW5rIHlvdSENCkFs
bGlzb24NCj4gDQo+IC0tRA0KPiANCj4gPiAtLS0NCj4gPiDCoGZzL3hmcy94ZnNfeGF0dHIuYyB8
IDMgKysrDQo+ID4gwqAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspDQo+ID4gDQo+ID4g
ZGlmZiAtLWdpdCBhL2ZzL3hmcy94ZnNfeGF0dHIuYyBiL2ZzL3hmcy94ZnNfeGF0dHIuYw0KPiA+
IGluZGV4IGQ5MDY3YzVmNmJkNi4uNWI1N2Y2MzQ4ZDYzIDEwMDY0NA0KPiA+IC0tLSBhL2ZzL3hm
cy94ZnNfeGF0dHIuYw0KPiA+ICsrKyBiL2ZzL3hmcy94ZnNfeGF0dHIuYw0KPiA+IEBAIC0yMzQs
NiArMjM0LDkgQEAgeGZzX3hhdHRyX3B1dF9saXN0ZW50KA0KPiA+IMKgDQo+ID4gwqDCoMKgwqDC
oMKgwqDCoEFTU0VSVChjb250ZXh0LT5jb3VudCA+PSAwKTsNCj4gPiDCoA0KPiA+ICvCoMKgwqDC
oMKgwqDCoGlmIChmbGFncyAmIFhGU19BVFRSX1BBUkVOVCkNCj4gPiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgcmV0dXJuOw0KPiA+ICsNCj4gPiDCoMKgwqDCoMKgwqDCoMKgaWYgKGZs
YWdzICYgWEZTX0FUVFJfUk9PVCkgew0KPiA+IMKgI2lmZGVmIENPTkZJR19YRlNfUE9TSVhfQUNM
DQo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAobmFtZWxlbiA9PSBTR0lf
QUNMX0ZJTEVfU0laRSAmJg0KPiA+IC0tIA0KPiA+IDIuMjUuMQ0KPiA+IA0KDQo=
