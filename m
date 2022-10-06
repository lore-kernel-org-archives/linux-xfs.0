Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57046C433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Oct 2022 01:25:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbiJFBZp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Oct 2022 21:25:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiJFBZn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Oct 2022 21:25:43 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AD3A5FDC
        for <linux-xfs@vger.kernel.org>; Wed,  5 Oct 2022 18:25:39 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29603nEI012829;
        Thu, 6 Oct 2022 01:25:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=vw226PycbE4ryM48SQt5eAtV0z4r6GyL++iGCuleTHs=;
 b=kM1BGTgw82zM9QU8QuNsZNr7MUQJa73VGXPyoQH0d5iUS6KtcElm8cheK4zKdHHa45Kr
 ZCe6+4aGcXu6kqZ53Wwflj1AR9xPAY1mfXikY2AAhDcFCyO/tRbSyOzF+lvp6VCF0LSh
 ZuRoNbBz8pug49h+Zl3zm8lCqjiYfmXaAxXHYVwQL8Fp2BgaLYeAOvEy1w444WM7oMAB
 oIUXnFvplNX1Ar01p9cYbeLOJAcHSC9iN56nDJGNV/AVv2CoxdzOBRiSrNbPQ2Kozdll
 dWJWLvplMqEWCfwsJaa7nTd+uj5hlqYozAwC1oPle+mCpiGQABGvxWmQeCahpsKYRCk+ Lg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxc5233gs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Oct 2022 01:25:28 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29606w7l010350;
        Thu, 6 Oct 2022 01:25:27 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc0bvtq9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Oct 2022 01:25:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G7jKVYxHszc66MIHTlwXpYPQmZnGfqqdDVUF+xWuzxOnexz3W1Zv3phpKT+0UNjA5y5IeOLf+0+eyv9s8O7emA83BLPe7i2gNcfC1849lOWuYfne2jS0LyQcLFiBZmS101tenXQ9m4c/17d3kW12k/sJw3k6cQQW5WEpcYi//FgeZFMfRBT1R+5Y5af9IjmJo48p2pNyornUJVxqBpQ8m8GPIR+Y3a92GPRoy1V05aY7NwJcZ8cyhOmFI4PueYJ+Iq0rITbmfMnxsbObwb7Xvz7ooBt3jt1L9n7vm+vFc8vlsWiBdpqsZhsNipeJJrr1PQNqoqwthUCCry0M6MMw9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vw226PycbE4ryM48SQt5eAtV0z4r6GyL++iGCuleTHs=;
 b=Pa71Kq1fyRw30id6m8EnBWP1fF/9CRVkDtgkxYt8b6CxHClYYCW3vlJWM9jsV0KZR1F3UKxPjNgoHjWqA4PMXQF34fGnq5qVZOESOklLR03GOl1ML3ihCJS+BVA0J/UyVTo3pF1HnbGRRSgbZ0A0CjAkTgrLI9aqqBoM1GYX+PDa5CfNAXF3uCMWzxKSXhaVcfK1MkwLxPKftvbrY7t7rfAbWTF0ZNSL/1/mIxzD84jLRyddJ3kLYmZCJ7K1mjb16AAQF00whap7rK22Sd+OvMDODoJeC7wo4ARkUO42iDic+Zgu4xsau3nwlg+s2xSoqzXDd+5r0ZdggjLklD13Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vw226PycbE4ryM48SQt5eAtV0z4r6GyL++iGCuleTHs=;
 b=iL94Tdr2qOKA6TnMhbTQj17FA20D35aDbkdSRtznkhQL88jyPuXnB2x3T2M+RI8N2L62g0fu+hhdqekavuMma/ETFbcuEs+rESaK/7HGqJhnrdDBEEmOv0QVtNt8/5yEua5/xdtfr4iQMAtOwdRMBDEWpuBOcZ4HOutq8cwIiOA=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH8PR10MB6552.namprd10.prod.outlook.com (2603:10b6:510:224::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Thu, 6 Oct
 2022 01:25:24 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::bf88:77e2:717f:8b9a]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::bf88:77e2:717f:8b9a%8]) with mapi id 15.20.5676.036; Thu, 6 Oct 2022
 01:25:24 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v3] xfs: add LARP state transition diagram
Thread-Topic: [PATCH v3] xfs: add LARP state transition diagram
Thread-Index: AQHY2SKBkR9SsfCEKkqhjac8xRTszQ==
Date:   Thu, 6 Oct 2022 01:25:23 +0000
Message-ID: <34590CAE-C56B-4F21-8901-17976B4EE39C@oracle.com>
References: <20221005233801.1731-1-catherine.hoang@oracle.com>
 <Yz4d8NC53oVfPhGP@magnolia>
In-Reply-To: <Yz4d8NC53oVfPhGP@magnolia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BLAPR10MB5316:EE_|PH8PR10MB6552:EE_
x-ms-office365-filtering-correlation-id: c91d44dd-a025-4e5e-1b19-08daa739a466
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Jy1fBPTmgjx5Y9RMMeULpy725dVZMS1rCkL5Vi1PxLmAo37uIDlOHiXg5R6zrs/iSBIRMwXSy8MqOP8lwQfMT+0ivC8fFzkUnn06NUeveqbFQDO6R9bZK30U6AZniCwmyje9x303GQIQKo8qhtrdKmsuBDM4GL80ST3fstRUvyU9DUPQS/ToFOaiSKnOpWsa58cEB4TxbXSbiiExIBjudPXZzirsNuQTnbOglwNZms/cfg7mPv+yD3nwgMuHFxUGVT5P/VqSa72Q0SUzxxTDuaVAwGce5VrtxvLZ68EfRlNQlaSa9cS791E59fmOP72cVjOtQA5VUbP56UCp6duUER0UgjqzBJvg/cwlYX9wAECJt+jmA0DuZa1onLssbq2yDTskXb7uAmjhOcpfSnSZGZS4ZH05hVhLRSyXhevOOoeeFBt8KwZgGv8uSF4Z507pBBHrcZ8ixz+jZJKM+Nr/ROshc9d+OLDmv4Zr4KtI+rpcPBKHTQnZng1D+6Wk+5iEP87Xoin5yx33fFgLwY/pzs4KToaMTZAygRJBSw79rM3S+5Hy98J0TI5VJjMFH7tm+xzcZ+d4VES3wblxtIJsLUA3jxtBjq1fk7Z+/4jj8WPV/IYmPHkZRujG3zkhBBI3c34MU26hjnTh0XTGV2/9GRxyBhIJc2V2FNb8S2PTWaCn5n2XOrC/DuDJN/X+UUSnQXFRctVbcjXzprkrAhDR4fFcRwjyHgrYjXPYVbeezNqrk9Zig2Cuo5EacOoiADupD7qZC5IQM90Tbba70b+I27kDU1H3m5lQbsV9+QwSLXTNj3ZPJ+pkq4CCv9F0stZPSqh1g0JlkHZLHXZCmaGqMDdVukvqR0523UYHNlv8pVE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(39860400002)(346002)(136003)(396003)(451199015)(186003)(76116006)(122000001)(41300700001)(66946007)(2616005)(36756003)(38070700005)(91956017)(8936002)(2906002)(6512007)(316002)(6506007)(86362001)(38100700002)(6486002)(966005)(478600001)(5660300002)(33656002)(44832011)(53546011)(6916009)(83380400001)(64756008)(4326008)(66476007)(66446008)(71200400001)(66556008)(8676002)(45980500001)(579004)(559001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jpxseKoUk7KD0pfHLmZNAQcqtFXOAwjkYIsnj8H8yO64rOj8TO+ed1ZjyKBY?=
 =?us-ascii?Q?OqQxEXVQAML8i/Xr1YlkDsrxnrk3pUbUIRMZ93KerDNcoJiNc1uPppWSNKwP?=
 =?us-ascii?Q?HH27ufUVl8psl0ZLjXsly+dHNA68+xny1WmlAh6Ot2GNfVW3EC9UzhA+NCiR?=
 =?us-ascii?Q?kor//8D2PRB8o4gGfObCq4qo2NBEWtuqLJO1bGhBzTgE3KKc7MlrVOpjHW+y?=
 =?us-ascii?Q?gUJjjwpbs6LHOVJUv/XTraFRdXL06DFlsHF7KhGAMZAtBAN5RuRpYmjyAQKU?=
 =?us-ascii?Q?V1nW8DAB3rDIniZr+TcNzXp4Psj7WNy5LZpWbFbbSx8w/HyirgDfr+Quxu4m?=
 =?us-ascii?Q?ox799m5LSkzAtubKbvfOl9gJSOD3gWFmhRXHFAceoWhUYO0ll/4NoNIOcqRd?=
 =?us-ascii?Q?8/5KAbMpOyWfM8rgPzohe2OHh6srcdMGScS/ESPRHcm8aTvAFCpjbAdDeJvq?=
 =?us-ascii?Q?NJ+g0xwCXM3ZIfPQuqyUbA81UShpXU26xYubnLdPdt0W62XEiGJjD3DObliB?=
 =?us-ascii?Q?kbmeqRtnpi52mc2Qxfc6gmCSQPjXZU2bTHmYjjN85ae46z4YXSkUBaoQjtQ/?=
 =?us-ascii?Q?LDMpoFs1KuNni1PZqFbv+C70h8BrXk1izlb1D0oOPlaobQuXWfytqx+3l6FH?=
 =?us-ascii?Q?sogKkaaRuyllgnnaTE3OmG1rcPMhyuFzICmgqizPac1YNuUl6OWQyZrytTRQ?=
 =?us-ascii?Q?SavMZVdU/VHUPRkVvUH/TF9j50WY31gePaO8TTRYABQf783LfHO19zyY+f2b?=
 =?us-ascii?Q?kD1SAuO0KV8Ldt8WT+v8KuCUfXpTMvDt0OGPFYByq2PVLw8BCPJr2Oe1iVcq?=
 =?us-ascii?Q?vmxCSfjMKN6T8r4izC9oK5wUDQoMSMzY7A3BRPx/67GD1bFepdOSb/FSVMQG?=
 =?us-ascii?Q?VmfaYG9HU3EQNDBKnyjuavKckZ7H4EnpW4fUIS0iC6mHFPRdpMbJAQ/nb26H?=
 =?us-ascii?Q?nH/O+B0GW1kPZATurz0HluTbjJ0DKfYbPYnLNuzDYnyO2Y/9HQdraNX0vFpC?=
 =?us-ascii?Q?7EG/LJejcr73MF/QNI7jk9MQqe/gF5CoW6LVSKsR5xzLPpKt6mxuBTRLyF25?=
 =?us-ascii?Q?4boGVT31U1n5tIufQB7E0Ah3R+giyQvUl3mM2FQ8rJev2I7X3lmE1GPPbSK0?=
 =?us-ascii?Q?qvhYQTcBnu3A+WwcxYZDmqB6wNYEs/lTzLYmeq8xzGpm5irN/0NK2jvoLG0t?=
 =?us-ascii?Q?/WKPo3h7anelJH556WcaOaqYVlq/th0xPIpxNiaWH+3Q42285N4wOGYShdDg?=
 =?us-ascii?Q?u3S5uqxsG3sUGler27aI5lNx9GZlS9R07/BUaMM35AZEJ8cDvhWOEnjOepE7?=
 =?us-ascii?Q?6XetnYy9eZBvMpSNYrT6xSFYB/N+cBENQ4dB9Gs16ubMbqMgKDFmYC4Wq8s+?=
 =?us-ascii?Q?8HzHJBzcrB+jx23FiVkGGhbdHaQchMzReiwN4YNJC+uEjvCtI18gLh1Qgmu+?=
 =?us-ascii?Q?GDnbB3DKpXKa6UW6BkTEtGcpDznqTaI3jXZFrCOBZuUo9nDgs0tDWYcGmtCB?=
 =?us-ascii?Q?QDj3yF5fI9cFgAjDdXOkFibRmxarF6RbbX6L/tyGrqz/ZVKMtzKqy5Xfm35X?=
 =?us-ascii?Q?kzWdVRshz7/+WhUgLaWXtgkZTmLQ+vybcw/866X3ksdcE+1FvVRlUi4C9pwZ?=
 =?us-ascii?Q?j7WjtVaCXvj8WCHjCMSwZnSVcvBkK1PAWcMYGC/NEOFF?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <862E064FFB9286428519B7CFD5962C73@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: HM9bjs9oJAJpLHjtAZBMiUMT6B/fmPbT5m2kOG7bTey6iKvYfGHoGOojOKGCwUfQcct5mb1bHmTpzhZndAxu+9gX127zz8MRsf8B6fLGFaCoyJMO0mKn16p8yVSaBHM5mMZ3NCs8KcnWDEbyQB2CqmSgzuOt4vmxiQCwYbLaI3iIQlPHwe4XJXlqZsuitsZEWYLNl1AcrkrSrQOJ1JTpFWN22oeelPriJTjDAZtWwHQrsyJg/PInSc0JtJ7UKzLzzApyOpuArzrDpEtXvNGDa9BBptiJZ8R9XeSFqRSwCr2XG5bkc/+Ty1ohngHOxeqT2xUqpbH826qX4vRXw4RaA+rLkseuZspfqXIUC2lyBbOqE8CMUiSfXzZaABKn/Rb0RX7e1iYjA2kxZqqCIPrNrqysS7WMTnhU70pPQ26PhjCTcQtiViGAZAAaKSq/5yqM+bt40yPxarJLJgbaaBh7C0jvYMSz2AkX7bGwToL9+4Z20Se+Nmzcq+JfzhZMmelxAeXflfEo8jzk7Tcfzt5+EqC3LNn/063MMWn7fCWssKcvziMofcFuJsT7eCxYhWolzjKVZ/lWZ6uN9nD4LKDCKOBrhTrqC18HIXVNFM/XLkaV5w0s7Bp7I0uM+ps8hD2SVNwi4JAzTVP20XFZbOPw+m1z7OsRPnSMb5aIiBk6hKkEPssd3BBgpWZVa1sQowJLkxCMK6Zu4Ww4L83NEAxUn3CVVNfdEHg3JKvFBdfW7KM5QCQx5RnSeaoP27lO3Yw3cQhzctZot0ZLx7YtaG8Kt5dvpkxqes23RCnqMOcJQF0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c91d44dd-a025-4e5e-1b19-08daa739a466
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Oct 2022 01:25:23.8851
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Oev4OIAlfKbwhRSZZ9cQecA31mp8R3zhl1M7Siw5lWM5qn6vhO3GrIb1DRAtN0iRs8lFth6ruQ12STJ5gVTaZNAudaS8C9Zke6AAEVzBDEA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6552
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-05_05,2022-10-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210060006
X-Proofpoint-GUID: 7DnJY5JojDcz7Zn6TP0zmr_VJP7eKQzK
X-Proofpoint-ORIG-GUID: 7DnJY5JojDcz7Zn6TP0zmr_VJP7eKQzK
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> On Oct 5, 2022, at 5:14 PM, Darrick J. Wong <djwong@kernel.org> wrote:
>=20
> On Wed, Oct 05, 2022 at 04:38:01PM -0700, Catherine Hoang wrote:
>> From: Dave Chinner <dchinner@redhat.com>
>>=20
>> Add a state transition diagram documenting each logged attribute state
>> and their transition conditions. The diagram can be built from the
>> included text source file with PlantUML.
>>=20
>> [cathhoan: add descriptions, links to docs, and diagram image]
>>=20
>> Signed-off-by: Dave Chinner <dchinner@redhat.com>
>> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
>> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>> Documentation/filesystems/xfs-larp-state.pu  | 103 ++++++++
>> Documentation/filesystems/xfs-larp-state.svg | 253 +++++++++++++++++++
>=20
> How did you get it to pretty-print the svg?

I used xmllint (from libxml2-utils package)
>=20
> This looks great!  I think the next step is to link this into the
> rest of the documentation, but that's a separate patch.

Sure, I can add this to the docs in another patch. Thanks!
>=20
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>=20
> --D
>=20
>> 2 files changed, 356 insertions(+)
>> create mode 100644 Documentation/filesystems/xfs-larp-state.pu
>> create mode 100644 Documentation/filesystems/xfs-larp-state.svg
>>=20
>> diff --git a/Documentation/filesystems/xfs-larp-state.pu b/Documentation=
/filesystems/xfs-larp-state.pu
>> new file mode 100644
>> index 000000000000..7a54773665a6
>> --- /dev/null
>> +++ b/Documentation/filesystems/xfs-larp-state.pu
>> @@ -0,0 +1,103 @@
>> +/'
>> +PlantUML documentation:
>> +Getting started - https://urldefense.com/v3/__https://plantuml.com/star=
ting__;!!ACWV5N9M2RV99hQ!NYe1OFcyncxFaBFfccRk5NQIpAlol_w3rCc5iKroZaFpH161mJ=
gSu3jqyTfcoU9UjVynGAjC21WEmBpkM4w$ =20
>> +State diagram - https://urldefense.com/v3/__https://plantuml.com/state-=
diagram__;!!ACWV5N9M2RV99hQ!NYe1OFcyncxFaBFfccRk5NQIpAlol_w3rCc5iKroZaFpH16=
1mJgSu3jqyTfcoU9UjVynGAjC21WE_ILtnf8$ =20
>> +'/
>> +
>> +@startuml
>> +
>> +state REMOTE_ADD {
>> +	XFS_DAS_..._SET_RMT : find space for remote blocks
>> +	XFS_DAS_..._ALLOC_RMT : allocate blocks and set remote value
>> +
>> +	XFS_DAS_..._SET_RMT --> XFS_DAS_..._ALLOC_RMT
>> +}
>> +
>> +state ADD {
>> +	XFS_DAS_SF_ADD : add attr to shortform fork
>> +	XFS_DAS_LEAF_ADD : add attr to inode in leaf form
>> +	XFS_DAS_NODE_ADD : add attr to node format attribute tree
>> +
>> +	state add_entry <<entryPoint>>
>> +	state add_form <<choice>>
>> +	add_entry --> add_form
>> +	add_form --> XFS_DAS_SF_ADD : short form
>> +	add_form --> XFS_DAS_LEAF_ADD : leaf form
>> +	add_form --> XFS_DAS_NODE_ADD : node form
>> +
>> +	XFS_DAS_SF_ADD --> XFS_DAS_LEAF_ADD : Full or too large
>> +	XFS_DAS_LEAF_ADD --> XFS_DAS_NODE_ADD : full or too large
>> +
>> +	XFS_DAS_LEAF_ADD --> XFS_DAS_..._SET_RMT : remote xattr
>> +	XFS_DAS_NODE_ADD --> XFS_DAS_..._SET_RMT : remote xattr
>> +}
>> +
>> +state REMOVE {
>> +	XFS_DAS_SF_REMOVE : remove attr from shortform fork
>> +	XFS_DAS_LEAF_REMOVE : remove attr from an inode in leaf form
>> +	XFS_DAS_NODE_REMOVE : setup for removal
>> +	XFS_DAS_NODE_REMOVE : (attr exists and blocks are valid)
>> +
>> +	state remove_entry <<entryPoint>>
>> +	state remove_form <<choice>>
>> +	remove_entry --> remove_form
>> +	remove_form --> XFS_DAS_SF_REMOVE : short form
>> +	remove_form --> XFS_DAS_LEAF_REMOVE : leaf form
>> +	remove_form --> XFS_DAS_NODE_REMOVE : node form
>> +}
>> +
>> +state REPLACE {
>> +	state replace_choice <<choice>>
>> +	replace_choice --> add_entry : larp disable
>> +	replace_choice --> remove_entry : larp enabled
>> +}
>> +
>> +
>> +state OLD_REPLACE {
>> +	XFS_DAS_..._REPLACE : atomic INCOMPLETE flag flip
>> +	XFS_DAS_..._REMOVE_OLD : restore original xattr state for remove
>> +	XFS_DAS_..._REMOVE_OLD : invalidate old xattr
>> +
>> +	XFS_DAS_..._REPLACE --> XFS_DAS_..._REMOVE_OLD
>> +}
>> +
>> +state REMOVE_XATTR {
>> +	XFS_DAS_..._REMOVE_RMT : remove remote attribute blocks
>> +	XFS_DAS_..._REMOVE_ATTR : remove attribute name from leaf/node block
>> +
>> +	state remove_xattr_choice <<choice>>
>> +	remove_xattr_choice --> XFS_DAS_..._REMOVE_RMT : Remote xattr
>> +	remove_xattr_choice --> XFS_DAS_..._REMOVE_ATTR : Local xattr
>> +
>> +	XFS_DAS_..._REMOVE_RMT --> XFS_DAS_..._REMOVE_ATTR
>> +}
>> +
>> +state XFS_DAS_DONE {
>> +}
>> +
>> +state add_done <<choice>>
>> +add_done -down-> XFS_DAS_DONE : Operation Complete
>> +add_done -up-> XFS_DAS_..._REPLACE : LARP disabled REPLACE
>> +XFS_DAS_SF_ADD -down-> add_done : Success
>> +XFS_DAS_LEAF_ADD -down-> add_done : Success
>> +XFS_DAS_NODE_ADD -down-> add_done : Success
>> +XFS_DAS_..._ALLOC_RMT -down-> add_done : Success
>> +
>> +state remove_done <<choice>>
>> +remove_done -down-> XFS_DAS_DONE : Operation Complete
>> +remove_done -up-> add_entry : LARP enabled REPLACE
>> +XFS_DAS_SF_REMOVE -down-> remove_done : Success
>> +XFS_DAS_LEAF_REMOVE -down-> remove_done : Success
>> +XFS_DAS_NODE_REMOVE -down-> remove_done : Success
>> +XFS_DAS_..._REMOVE_ATTR -down-> remove_done : Success
>> +
>> +XFS_DAS_..._REMOVE_OLD --> remove_xattr_choice
>> +XFS_DAS_NODE_REMOVE --> remove_xattr_choice
>> +
>> +state set_choice <<choice>>
>> +[*] --> set_choice
>> +set_choice --> add_entry : add new
>> +set_choice --> remove_entry : remove existing
>> +set_choice --> replace_choice : replace existing
>> +XFS_DAS_DONE --> [*]
>> +@enduml
>> diff --git a/Documentation/filesystems/xfs-larp-state.svg b/Documentatio=
n/filesystems/xfs-larp-state.svg
>> new file mode 100644
>> index 000000000000..860fe2b59093
>> --- /dev/null
>> +++ b/Documentation/filesystems/xfs-larp-state.svg
>> @@ -0,0 +1,253 @@
>> +<?xml version=3D"1.0" encoding=3D"UTF-8" standalone=3D"no"?>
>> +<svg xmlns=3D"https://urldefense.com/v3/__http://www.w3.org/2000/svg__;=
!!ACWV5N9M2RV99hQ!NYe1OFcyncxFaBFfccRk5NQIpAlol_w3rCc5iKroZaFpH161mJgSu3jqy=
TfcoU9UjVynGAjC21WEunHI90w$  " xmlns:xlink=3D"http://www.w3.org/1999/xlink"=
 contentScriptType=3D"application/ecmascript" contentStyleType=3D"text/css"=
 height=3D"1462px" preserveAspectRatio=3D"none" style=3D"width:1857px;heigh=
t:1462px" version=3D"1.1" viewBox=3D"0 0 1857 1462" width=3D"1857px" zoomAn=
dPan=3D"magnify">
>> +  <defs>
>> +    <filter height=3D"300%" id=3D"fc2ynpqha1fpc" width=3D"300%" x=3D"-1=
" y=3D"-1">
>> +      <feGaussianBlur result=3D"blurOut" stdDeviation=3D"2.0"/>
>> +      <feColorMatrix in=3D"blurOut" result=3D"blurOut2" type=3D"matrix"=
 values=3D"0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 .4 0"/>
>> +      <feOffset dx=3D"4.0" dy=3D"4.0" in=3D"blurOut2" result=3D"blurOut=
3"/>
>> +      <feBlend in=3D"SourceGraphic" in2=3D"blurOut3" mode=3D"normal"/>
>> +    </filter>
>> +  </defs>
>> +  <g>
>> +    <!--cluster REMOTE_ADD-->
>> +    <rect fill=3D"#FEFECE" filter=3D"url(#fc2ynpqha1fpc)" height=3D"230=
" rx=3D"12.5" ry=3D"12.5" style=3D"stroke:#A80036;stroke-width:1.5" width=
=3D"284" x=3D"188" y=3D"926"/>
>> +    <rect fill=3D"#FFFFFF" height=3D"197.7031" rx=3D"12.5" ry=3D"12.5" =
style=3D"stroke:#FFFFFF;stroke-width:1.0" width=3D"278" x=3D"191" y=3D"955.=
2969"/>
>> +    <line style=3D"stroke:#A80036;stroke-width:1.5" x1=3D"188" x2=3D"47=
2" y1=3D"952.2969" y2=3D"952.2969"/>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"14" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"98" x=3D"281" y=3D"942.9951=
">REMOTE_ADD</text>
>> +    <!--cluster ADD-->
>> +    <rect fill=3D"#FEFECE" filter=3D"url(#fc2ynpqha1fpc)" height=3D"559=
" rx=3D"12.5" ry=3D"12.5" style=3D"stroke:#A80036;stroke-width:1.5" width=
=3D"384" x=3D"43" y=3D"320"/>
>> +    <rect fill=3D"#FFFFFF" height=3D"526.7031" rx=3D"12.5" ry=3D"12.5" =
style=3D"stroke:#FFFFFF;stroke-width:1.0" width=3D"378" x=3D"46" y=3D"349.2=
969"/>
>> +    <line style=3D"stroke:#A80036;stroke-width:1.5" x1=3D"43" x2=3D"427=
" y1=3D"346.2969" y2=3D"346.2969"/>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"14" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"31" x=3D"219.5" y=3D"337.99=
51">ADD</text>
>> +    <!--cluster REMOVE-->
>> +    <rect fill=3D"#FEFECE" filter=3D"url(#fc2ynpqha1fpc)" height=3D"295=
" rx=3D"12.5" ry=3D"12.5" style=3D"stroke:#A80036;stroke-width:1.5" width=
=3D"804" x=3D"1041" y=3D"320"/>
>> +    <rect fill=3D"#FFFFFF" height=3D"262.7031" rx=3D"12.5" ry=3D"12.5" =
style=3D"stroke:#FFFFFF;stroke-width:1.0" width=3D"798" x=3D"1044" y=3D"349=
.2969"/>
>> +    <line style=3D"stroke:#A80036;stroke-width:1.5" x1=3D"1041" x2=3D"1=
845" y1=3D"346.2969" y2=3D"346.2969"/>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"14" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"60" x=3D"1413" y=3D"337.995=
1">REMOVE</text>
>> +    <!--cluster REPLACE-->
>> +    <rect fill=3D"#FEFECE" filter=3D"url(#fc2ynpqha1fpc)" height=3D"75"=
 rx=3D"12.5" ry=3D"12.5" style=3D"stroke:#A80036;stroke-width:1.5" width=3D=
"79" x=3D"683" y=3D"176"/>
>> +    <rect fill=3D"#FFFFFF" height=3D"42.7031" rx=3D"12.5" ry=3D"12.5" s=
tyle=3D"stroke:#FFFFFF;stroke-width:1.0" width=3D"73" x=3D"686" y=3D"205.29=
69"/>
>> +    <line style=3D"stroke:#A80036;stroke-width:1.5" x1=3D"683" x2=3D"76=
2" y1=3D"202.2969" y2=3D"202.2969"/>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"14" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"63" x=3D"691" y=3D"192.9951=
">REPLACE</text>
>> +    <!--cluster OLD_REPLACE-->
>> +    <rect fill=3D"#FEFECE" filter=3D"url(#fc2ynpqha1fpc)" height=3D"242=
" rx=3D"12.5" ry=3D"12.5" style=3D"stroke:#A80036;stroke-width:1.5" width=
=3D"290" x=3D"739" y=3D"373"/>
>> +    <rect fill=3D"#FFFFFF" height=3D"209.7031" rx=3D"12.5" ry=3D"12.5" =
style=3D"stroke:#FFFFFF;stroke-width:1.0" width=3D"284" x=3D"742" y=3D"402.=
2969"/>
>> +    <line style=3D"stroke:#A80036;stroke-width:1.5" x1=3D"739" x2=3D"10=
29" y1=3D"399.2969" y2=3D"399.2969"/>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"14" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"99" x=3D"834.5" y=3D"389.99=
51">OLD_REPLACE</text>
>> +    <!--cluster REMOVE_XATTR-->
>> +    <rect fill=3D"#FEFECE" filter=3D"url(#fc2ynpqha1fpc)" height=3D"363=
" rx=3D"12.5" ry=3D"12.5" style=3D"stroke:#A80036;stroke-width:1.5" width=
=3D"389" x=3D"873" y=3D"664"/>
>> +    <rect fill=3D"#FFFFFF" height=3D"330.7031" rx=3D"12.5" ry=3D"12.5" =
style=3D"stroke:#FFFFFF;stroke-width:1.0" width=3D"383" x=3D"876" y=3D"693.=
2969"/>
>> +    <line style=3D"stroke:#A80036;stroke-width:1.5" x1=3D"873" x2=3D"12=
62" y1=3D"690.2969" y2=3D"690.2969"/>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"14" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"113" x=3D"1011" y=3D"680.99=
51">REMOVE_XATTR</text>
>> +    <rect fill=3D"#FEFECE" filter=3D"url(#fc2ynpqha1fpc)" height=3D"50.=
2656" rx=3D"12.5" ry=3D"12.5" style=3D"stroke:#A80036;stroke-width:1.5" wid=
th=3D"199" x=3D"230.5" y=3D"961"/>
>> +    <line style=3D"stroke:#A80036;stroke-width:1.5" x1=3D"230.5" x2=3D"=
429.5" y1=3D"987.2969" y2=3D"987.2969"/>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"14" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"153" x=3D"253.5" y=3D"978.9=
951">XFS_DAS_..._SET_RMT</text>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"12" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"179" x=3D"235.5" y=3D"1003.=
4355">find space for remote blocks</text>
>> +    <rect fill=3D"#FEFECE" filter=3D"url(#fc2ynpqha1fpc)" height=3D"50.=
2656" rx=3D"12.5" ry=3D"12.5" style=3D"stroke:#A80036;stroke-width:1.5" wid=
th=3D"252" x=3D"204" y=3D"1090"/>
>> +    <line style=3D"stroke:#A80036;stroke-width:1.5" x1=3D"204" x2=3D"45=
6" y1=3D"1116.2969" y2=3D"1116.2969"/>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"14" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"170" x=3D"245" y=3D"1107.99=
51">XFS_DAS_..._ALLOC_RMT</text>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"12" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"232" x=3D"209" y=3D"1132.43=
55">allocate blocks and set remote value</text>
>> +    <rect fill=3D"#FEFECE" filter=3D"url(#fc2ynpqha1fpc)" height=3D"50.=
2656" rx=3D"12.5" ry=3D"12.5" style=3D"stroke:#A80036;stroke-width:1.5" wid=
th=3D"181" x=3D"96.5" y=3D"542"/>
>> +    <line style=3D"stroke:#A80036;stroke-width:1.5" x1=3D"96.5" x2=3D"2=
77.5" y1=3D"568.2969" y2=3D"568.2969"/>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"14" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"124" x=3D"125" y=3D"559.995=
1">XFS_DAS_SF_ADD</text>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"12" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"161" x=3D"101.5" y=3D"584.4=
355">add attr to shortform fork</text>
>> +    <rect fill=3D"#FEFECE" filter=3D"url(#fc2ynpqha1fpc)" height=3D"50.=
2656" rx=3D"12.5" ry=3D"12.5" style=3D"stroke:#A80036;stroke-width:1.5" wid=
th=3D"201" x=3D"205.5" y=3D"686"/>
>> +    <line style=3D"stroke:#A80036;stroke-width:1.5" x1=3D"205.5" x2=3D"=
406.5" y1=3D"712.2969" y2=3D"712.2969"/>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"14" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"140" x=3D"236" y=3D"703.995=
1">XFS_DAS_LEAF_ADD</text>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"12" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"181" x=3D"210.5" y=3D"728.4=
355">add attr to inode in leaf form</text>
>> +    <rect fill=3D"#FEFECE" filter=3D"url(#fc2ynpqha1fpc)" height=3D"50.=
2656" rx=3D"12.5" ry=3D"12.5" style=3D"stroke:#A80036;stroke-width:1.5" wid=
th=3D"258" x=3D"59" y=3D"813"/>
>> +    <line style=3D"stroke:#A80036;stroke-width:1.5" x1=3D"59" x2=3D"317=
" y1=3D"839.2969" y2=3D"839.2969"/>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"14" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"148" x=3D"114" y=3D"830.995=
1">XFS_DAS_NODE_ADD</text>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"12" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"238" x=3D"64" y=3D"855.4355=
">add attr to node format attribute tree</text>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"14" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"68" x=3D"375" y=3D"298.6982=
">add_entry</text>
>> +    <ellipse cx=3D"409" cy=3D"320" fill=3D"#FEFECE" rx=3D"6" ry=3D"6" s=
tyle=3D"stroke:#A80036;stroke-width:1.5"/>
>> +    <polygon fill=3D"#FEFECE" filter=3D"url(#fc2ynpqha1fpc)" points=3D"=
289,421,301,433,289,445,277,433,289,421" style=3D"stroke:#A80036;stroke-wid=
th:1.5"/>
>> +    <rect fill=3D"#FEFECE" filter=3D"url(#fc2ynpqha1fpc)" height=3D"50.=
2656" rx=3D"12.5" ry=3D"12.5" style=3D"stroke:#A80036;stroke-width:1.5" wid=
th=3D"218" x=3D"1318" y=3D"542"/>
>> +    <line style=3D"stroke:#A80036;stroke-width:1.5" x1=3D"1318" x2=3D"1=
536" y1=3D"568.2969" y2=3D"568.2969"/>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"14" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"153" x=3D"1350.5" y=3D"559.=
9951">XFS_DAS_SF_REMOVE</text>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"12" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"198" x=3D"1323" y=3D"584.43=
55">remove attr from shortform fork</text>
>> +    <rect fill=3D"#FEFECE" filter=3D"url(#fc2ynpqha1fpc)" height=3D"50.=
2656" rx=3D"12.5" ry=3D"12.5" style=3D"stroke:#A80036;stroke-width:1.5" wid=
th=3D"258" x=3D"1571" y=3D"542"/>
>> +    <line style=3D"stroke:#A80036;stroke-width:1.5" x1=3D"1571" x2=3D"1=
829" y1=3D"568.2969" y2=3D"568.2969"/>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"14" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"169" x=3D"1615.5" y=3D"559.=
9951">XFS_DAS_LEAF_REMOVE</text>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"12" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"238" x=3D"1576" y=3D"584.43=
55">remove attr from an inode in leaf form</text>
>> +    <rect fill=3D"#FEFECE" filter=3D"url(#fc2ynpqha1fpc)" height=3D"64.=
2344" rx=3D"12.5" ry=3D"12.5" style=3D"stroke:#A80036;stroke-width:1.5" wid=
th=3D"222" x=3D"1061" y=3D"535"/>
>> +    <line style=3D"stroke:#A80036;stroke-width:1.5" x1=3D"1061" x2=3D"1=
283" y1=3D"561.2969" y2=3D"561.2969"/>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"14" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"177" x=3D"1083.5" y=3D"552.=
9951">XFS_DAS_NODE_REMOVE</text>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"12" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"110" x=3D"1066" y=3D"577.43=
55">setup for removal</text>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"12" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"202" x=3D"1066" y=3D"591.40=
43">(attr exists and blocks are valid)</text>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"14" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"94" x=3D"1012" y=3D"298.698=
2">remove_entry</text>
>> +    <ellipse cx=3D"1059" cy=3D"320" fill=3D"#FEFECE" rx=3D"6" ry=3D"6" =
style=3D"stroke:#A80036;stroke-width:1.5"/>
>> +    <polygon fill=3D"#FEFECE" filter=3D"url(#fc2ynpqha1fpc)" points=3D"=
1299,421,1311,433,1299,445,1287,433,1299,421" style=3D"stroke:#A80036;strok=
e-width:1.5"/>
>> +    <polygon fill=3D"#FEFECE" filter=3D"url(#fc2ynpqha1fpc)" points=3D"=
722,211,734,223,722,235,710,223,722,211" style=3D"stroke:#A80036;stroke-wid=
th:1.5"/>
>> +    <rect fill=3D"#FEFECE" filter=3D"url(#fc2ynpqha1fpc)" height=3D"50.=
2656" rx=3D"12.5" ry=3D"12.5" style=3D"stroke:#A80036;stroke-width:1.5" wid=
th=3D"191" x=3D"771.5" y=3D"408"/>
>> +    <line style=3D"stroke:#A80036;stroke-width:1.5" x1=3D"771.5" x2=3D"=
962.5" y1=3D"434.2969" y2=3D"434.2969"/>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"14" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"151" x=3D"791.5" y=3D"425.9=
951">XFS_DAS_..._REPLACE</text>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"12" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"171" x=3D"776.5" y=3D"450.4=
355">atomic INCOMPLETE flag flip</text>
>> +    <rect fill=3D"#FEFECE" filter=3D"url(#fc2ynpqha1fpc)" height=3D"64.=
2344" rx=3D"12.5" ry=3D"12.5" style=3D"stroke:#A80036;stroke-width:1.5" wid=
th=3D"257" x=3D"755.5" y=3D"535"/>
>> +    <line style=3D"stroke:#A80036;stroke-width:1.5" x1=3D"755.5" x2=3D"=
1012.5" y1=3D"561.2969" y2=3D"561.2969"/>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"14" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"184" x=3D"792" y=3D"552.995=
1">XFS_DAS_..._REMOVE_OLD</text>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"12" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"237" x=3D"760.5" y=3D"577.4=
355">restore original xattr state for remove</text>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"12" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"116" x=3D"760.5" y=3D"591.4=
043">invalidate old xattr</text>
>> +    <rect fill=3D"#FEFECE" filter=3D"url(#fc2ynpqha1fpc)" height=3D"50.=
2656" rx=3D"12.5" ry=3D"12.5" style=3D"stroke:#A80036;stroke-width:1.5" wid=
th=3D"218" x=3D"889" y=3D"813"/>
>> +    <line style=3D"stroke:#A80036;stroke-width:1.5" x1=3D"889" x2=3D"11=
07" y1=3D"839.2969" y2=3D"839.2969"/>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"14" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"186" x=3D"905" y=3D"830.995=
1">XFS_DAS_..._REMOVE_RMT</text>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"12" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"198" x=3D"894" y=3D"855.435=
5">remove remote attribute blocks</text>
>> +    <rect fill=3D"#FEFECE" filter=3D"url(#fc2ynpqha1fpc)" height=3D"50.=
2656" rx=3D"12.5" ry=3D"12.5" style=3D"stroke:#A80036;stroke-width:1.5" wid=
th=3D"296" x=3D"950" y=3D"961"/>
>> +    <line style=3D"stroke:#A80036;stroke-width:1.5" x1=3D"950" x2=3D"12=
46" y1=3D"987.2969" y2=3D"987.2969"/>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"14" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"192" x=3D"1002" y=3D"978.99=
51">XFS_DAS_..._REMOVE_ATTR</text>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"12" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"276" x=3D"955" y=3D"1003.43=
55">remove attribute name from leaf/node block</text>
>> +    <polygon fill=3D"#FEFECE" filter=3D"url(#fc2ynpqha1fpc)" points=3D"=
1107,699,1119,711,1107,723,1095,711,1107,699" style=3D"stroke:#A80036;strok=
e-width:1.5"/>
>> +    <polygon fill=3D"#FEFECE" filter=3D"url(#fc2ynpqha1fpc)" points=3D"=
424,1219,436,1231,424,1243,412,1231,424,1219" style=3D"stroke:#A80036;strok=
e-width:1.5"/>
>> +    <polygon fill=3D"#FEFECE" filter=3D"url(#fc2ynpqha1fpc)" points=3D"=
1242,1103,1254,1115,1242,1127,1230,1115,1242,1103" style=3D"stroke:#A80036;=
stroke-width:1.5"/>
>> +    <polygon fill=3D"#FEFECE" filter=3D"url(#fc2ynpqha1fpc)" points=3D"=
722,89,734,101,722,113,710,101,722,89" style=3D"stroke:#A80036;stroke-width=
:1.5"/>
>> +    <ellipse cx=3D"722" cy=3D"18" fill=3D"#000000" filter=3D"url(#fc2yn=
pqha1fpc)" rx=3D"10" ry=3D"10" style=3D"stroke:none;stroke-width:1.0"/>
>> +    <ellipse cx=3D"717" cy=3D"1441" fill=3D"none" filter=3D"url(#fc2ynp=
qha1fpc)" rx=3D"10" ry=3D"10" style=3D"stroke:#000000;stroke-width:1.0"/>
>> +    <ellipse cx=3D"717.5" cy=3D"1441.5" fill=3D"#000000" rx=3D"6" ry=3D=
"6" style=3D"stroke:none;stroke-width:1.0"/>
>> +    <rect fill=3D"#FEFECE" filter=3D"url(#fc2ynpqha1fpc)" height=3D"50"=
 rx=3D"12.5" ry=3D"12.5" style=3D"stroke:#A80036;stroke-width:1.5" width=3D=
"130" x=3D"652" y=3D"1320"/>
>> +    <line style=3D"stroke:#A80036;stroke-width:1.5" x1=3D"652" x2=3D"78=
2" y1=3D"1346.2969" y2=3D"1346.2969"/>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"14" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"110" x=3D"662" y=3D"1337.99=
51">XFS_DAS_DONE</text>
>> +    <!--link XFS_DAS_..._SET_RMT to XFS_DAS_..._ALLOC_RMT-->
>> +    <path d=3D"M330,1011.19 C330,1032.11 330,1062.41 330,1084.71 " fill=
=3D"none" id=3D"XFS_DAS_..._SET_RMT-XFS_DAS_..._ALLOC_RMT" style=3D"stroke:=
#A80036;stroke-width:1.0"/>
>> +    <polygon fill=3D"#A80036" points=3D"330,1089.9,334,1080.9,330,1084.=
9,326,1080.9,330,1089.9" style=3D"stroke:#A80036;stroke-width:1.0"/>
>> +    <!--link add_entry to add_form-->
>> +    <path d=3D"M405.01,324.69 C388.25,340.2 323.3,400.28 298.6,423.12 "=
 fill=3D"none" id=3D"add_entry-add_form" style=3D"stroke:#A80036;stroke-wid=
th:1.0"/>
>> +    <polygon fill=3D"#A80036" points=3D"294.74,426.69,304.0612,423.5096=
,298.4085,423.2927,298.6255,417.64,294.74,426.69" style=3D"stroke:#A80036;s=
troke-width:1.0"/>
>> +    <!--link add_form to XFS_DAS_SF_ADD-->
>> +    <path d=3D"M284.08,440.37 C270.71,457.67 233.1,506.34 208.81,537.78=
 " fill=3D"none" id=3D"add_form-XFS_DAS_SF_ADD" style=3D"stroke:#A80036;str=
oke-width:1.0"/>
>> +    <polygon fill=3D"#A80036" points=3D"205.62,541.91,214.2877,537.2333=
,208.6768,537.9533,207.9569,532.3424,205.62,541.91" style=3D"stroke:#A80036=
;stroke-width:1.0"/>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"13" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"67" x=3D"248" y=3D"501.0669=
">short form</text>
>> +    <!--link add_form to XFS_DAS_LEAF_ADD-->
>> +    <path d=3D"M294.32,440.15 C302.24,449.68 316.96,468.92 324,488 C346=
.2,548.15 338.77,567.03 343,631 C343.5,638.54 345.01,640.72 343,648 C339.76=
,659.74 333.66,671.49 327.32,681.56 " fill=3D"none" id=3D"add_form-XFS_DAS_=
LEAF_ADD" style=3D"stroke:#A80036;stroke-width:1.0"/>
>> +    <polygon fill=3D"#A80036" points=3D"324.6,685.77,332.8445,680.3822,=
327.3139,681.5706,326.1255,676.04,324.6,685.77" style=3D"stroke:#A80036;str=
oke-width:1.0"/>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"13" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"57" x=3D"343" y=3D"571.5669=
">leaf form</text>
>> +    <!--link add_form to XFS_DAS_NODE_ADD-->
>> +    <path d=3D"M279.12,435.14 C244.13,439.78 125.73,460.68 79,535 C21.3=
4,626.71 114.04,753.21 162.04,808.84 " fill=3D"none" id=3D"add_form-XFS_DAS=
_NODE_ADD" style=3D"stroke:#A80036;stroke-width:1.0"/>
>> +    <polygon fill=3D"#A80036" points=3D"165.41,812.72,162.5343,803.3003=
,162.1337,808.943,156.4911,808.5424,165.41,812.72" style=3D"stroke:#A80036;=
stroke-width:1.0"/>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"13" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"66" x=3D"69" y=3D"644.0669"=
>node form</text>
>> +    <!--link XFS_DAS_SF_ADD to XFS_DAS_LEAF_ADD-->
>> +    <path d=3D"M200.19,592.24 C209.69,608.72 223.37,630.61 238,648 C248=
.26,660.19 260.84,672.29 272.39,682.52 " fill=3D"none" id=3D"XFS_DAS_SF_ADD=
-XFS_DAS_LEAF_ADD" style=3D"stroke:#A80036;stroke-width:1.0"/>
>> +    <polygon fill=3D"#A80036" points=3D"276.26,685.92,272.1376,676.9754=
,272.5033,682.6204,266.8583,682.9861,276.26,685.92" style=3D"stroke:#A80036=
;stroke-width:1.0"/>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"13" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"99" x=3D"239" y=3D"644.0669=
">Full or too large</text>
>> +    <!--link XFS_DAS_LEAF_ADD to XFS_DAS_NODE_ADD-->
>> +    <path d=3D"M283.25,736.1 C263.5,757.03 234.89,787.32 214.19,809.25 =
" fill=3D"none" id=3D"XFS_DAS_LEAF_ADD-XFS_DAS_NODE_ADD" style=3D"stroke:#A=
80036;stroke-width:1.0"/>
>> +    <polygon fill=3D"#A80036" points=3D"210.68,812.97,219.7611,809.1577=
,214.1068,809.329,213.9355,803.6747,210.68,812.97" style=3D"stroke:#A80036;=
stroke-width:1.0"/>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"13" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"96" x=3D"255" y=3D"779.0669=
">full or too large</text>
>> +    <!--link XFS_DAS_LEAF_ADD to XFS_DAS_..._SET_RMT-->
>> +    <path d=3D"M338.34,736.22 C347.05,744.59 355.33,754.73 360,766 C386=
.58,830.18 360.57,913.1 343.05,956.16 " fill=3D"none" id=3D"XFS_DAS_LEAF_AD=
D-XFS_DAS_..._SET_RMT" style=3D"stroke:#A80036;stroke-width:1.0"/>
>> +    <polygon fill=3D"#A80036" points=3D"341.07,960.96,348.206,954.172,3=
42.9809,956.3396,340.8133,951.1145,341.07,960.96" style=3D"stroke:#A80036;s=
troke-width:1.0"/>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"13" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"81" x=3D"372" y=3D"842.5669=
">remote xattr</text>
>> +    <!--link XFS_DAS_NODE_ADD to XFS_DAS_..._SET_RMT-->
>> +    <path d=3D"M211.45,863.11 C236.53,888.89 276.25,929.74 302.71,956.9=
4 " fill=3D"none" id=3D"XFS_DAS_NODE_ADD-XFS_DAS_..._SET_RMT" style=3D"stro=
ke:#A80036;stroke-width:1.0"/>
>> +    <polygon fill=3D"#A80036" points=3D"306.52,960.86,303.1148,951.6185=
,303.0348,957.2748,297.3785,957.1948,306.52,960.86" style=3D"stroke:#A80036=
;stroke-width:1.0"/>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"13" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"81" x=3D"255" y=3D"906.0669=
">remote xattr</text>
>> +    <!--link remove_entry to remove_form-->
>> +    <path d=3D"M1064.01,323.32 C1093.31,336.87 1242.6,405.91 1286.71,42=
6.32 " fill=3D"none" id=3D"remove_entry-remove_form" style=3D"stroke:#A8003=
6;stroke-width:1.0"/>
>> +    <polygon fill=3D"#A80036" points=3D"1291.33,428.45,1284.839,421.042=
8,1286.7915,426.352,1281.4822,428.3044,1291.33,428.45" style=3D"stroke:#A80=
036;stroke-width:1.0"/>
>> +    <!--link remove_form to XFS_DAS_SF_REMOVE-->
>> +    <path d=3D"M1304.5,439.67 C1320.69,456.36 1368.95,506.14 1399.84,53=
8 " fill=3D"none" id=3D"remove_form-XFS_DAS_SF_REMOVE" style=3D"stroke:#A80=
036;stroke-width:1.0"/>
>> +    <polygon fill=3D"#A80036" points=3D"1403.52,541.79,1400.1148,532.54=
85,1400.0348,538.2048,1394.3785,538.1248,1403.52,541.79" style=3D"stroke:#A=
80036;stroke-width:1.0"/>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"13" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"67" x=3D"1367" y=3D"501.066=
9">short form</text>
>> +    <!--link remove_form to XFS_DAS_LEAF_REMOVE-->
>> +    <path d=3D"M1307.38,436.76 C1347.18,449.86 1519.53,506.59 1622.18,5=
40.38 " fill=3D"none" id=3D"remove_form-XFS_DAS_LEAF_REMOVE" style=3D"strok=
e:#A80036;stroke-width:1.0"/>
>> +    <polygon fill=3D"#A80036" points=3D"1627.01,541.97,1619.7068,535.36=
22,1622.2595,540.4103,1617.2113,542.963,1627.01,541.97" style=3D"stroke:#A8=
0036;stroke-width:1.0"/>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"13" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"57" x=3D"1512" y=3D"501.066=
9">leaf form</text>
>> +    <!--link remove_form to XFS_DAS_NODE_REMOVE-->
>> +    <path d=3D"M1293.54,439.67 C1278.62,455.18 1236.24,499.23 1205.72,5=
30.96 " fill=3D"none" id=3D"remove_form-XFS_DAS_NODE_REMOVE" style=3D"strok=
e:#A80036;stroke-width:1.0"/>
>> +    <polygon fill=3D"#A80036" points=3D"1202.06,534.76,1211.1866,531.05=
79,1205.5307,531.1608,1205.4278,525.5049,1202.06,534.76" style=3D"stroke:#A=
80036;stroke-width:1.0"/>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"13" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"66" x=3D"1247" y=3D"501.066=
9">node form</text>
>> +    <!--link replace_choice to add_entry-->
>> +    <path d=3D"M715.58,229 C700.21,240.69 659.7,269.88 621,284 C547.76,=
310.72 452.81,317.14 420.41,318.6 " fill=3D"none" id=3D"replace_choice-add_=
entry" style=3D"stroke:#A80036;stroke-width:1.0"/>
>> +    <polygon fill=3D"#A80036" points=3D"415.11,318.81,424.273,322.421,4=
20.1054,318.5959,423.9305,314.4283,415.11,318.81" style=3D"stroke:#A80036;s=
troke-width:1.0"/>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"13" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"73" x=3D"657" y=3D"280.0669=
">larp disable</text>
>> +    <!--link replace_choice to remove_entry-->
>> +    <path d=3D"M730.32,226.84 C756.8,235.83 841.65,264.27 913,284 C963.=
24,297.89 1024.07,311.44 1048.3,316.7 " fill=3D"none" id=3D"replace_choice-=
remove_entry" style=3D"stroke:#A80036;stroke-width:1.0"/>
>> +    <polygon fill=3D"#A80036" points=3D"1053.39,317.8,1045.4395,311.987=
1,1048.5031,316.7426,1043.7476,319.8062,1053.39,317.8" style=3D"stroke:#A80=
036;stroke-width:1.0"/>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"13" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"79" x=3D"914" y=3D"280.0669=
">larp enabled</text>
>> +    <!--link XFS_DAS_..._REPLACE to XFS_DAS_..._REMOVE_OLD-->
>> +    <path d=3D"M870.12,458.21 C872.7,478.28 876.41,507.1 879.35,529.89 =
" fill=3D"none" id=3D"XFS_DAS_..._REPLACE-XFS_DAS_..._REMOVE_OLD" style=3D"=
stroke:#A80036;stroke-width:1.0"/>
>> +    <polygon fill=3D"#A80036" points=3D"880,534.95,882.8093,525.5103,87=
9.357,529.9915,874.8758,526.5392,880,534.95" style=3D"stroke:#A80036;stroke=
-width:1.0"/>
>> +    <!--link remove_xattr_choice to XFS_DAS_..._REMOVE_RMT-->
>> +    <path d=3D"M1101.74,718.03 C1087.66,734.18 1048.4,779.2 1022.42,809=
 " fill=3D"none" id=3D"remove_xattr_choice-XFS_DAS_..._REMOVE_RMT" style=3D=
"stroke:#A80036;stroke-width:1.0"/>
>> +    <polygon fill=3D"#A80036" points=3D"1019,812.91,1027.9279,808.7516,=
1022.2844,809.14,1021.896,803.4965,1019,812.91" style=3D"stroke:#A80036;str=
oke-width:1.0"/>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"13" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"84" x=3D"1060" y=3D"779.066=
9">Remote xattr</text>
>> +    <!--link remove_xattr_choice to XFS_DAS_..._REMOVE_ATTR-->
>> +    <path d=3D"M1113.32,716.81 C1123.94,725.33 1145,744.27 1153,766 C11=
55.61,773.09 1154,775.51 1153,783 C1144.59,845.92 1122.05,917.01 1108.58,95=
5.84 " fill=3D"none" id=3D"remove_xattr_choice-XFS_DAS_..._REMOVE_ATTR" sty=
le=3D"stroke:#A80036;stroke-width:1.0"/>
>> +    <polygon fill=3D"#A80036" points=3D"1106.82,960.87,1113.5521,953.68=
12,1108.4609,956.1469,1105.9952,951.0557,1106.82,960.87" style=3D"stroke:#A=
80036;stroke-width:1.0"/>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"13" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"67" x=3D"1148" y=3D"842.566=
9">Local xattr</text>
>> +    <!--link XFS_DAS_..._REMOVE_RMT to XFS_DAS_..._REMOVE_ATTR-->
>> +    <path d=3D"M1014.51,863.11 C1032.1,888.79 1059.92,929.4 1078.55,956=
.61 " fill=3D"none" id=3D"XFS_DAS_..._REMOVE_RMT-XFS_DAS_..._REMOVE_ATTR" s=
tyle=3D"stroke:#A80036;stroke-width:1.0"/>
>> +    <polygon fill=3D"#A80036" points=3D"1081.46,960.86,1079.6731,951.17=
46,1078.634,956.7352,1073.0734,955.6962,1081.46,960.86" style=3D"stroke:#A8=
0036;stroke-width:1.0"/>
>> +    <!--link add_done to XFS_DAS_DONE-->
>> +    <path d=3D"M432.14,1235.11 C463.07,1246.94 575.27,1289.82 649.28,13=
18.11 " fill=3D"none" id=3D"add_done-XFS_DAS_DONE" style=3D"stroke:#A80036;=
stroke-width:1.0"/>
>> +    <polygon fill=3D"#A80036" points=3D"654.1,1319.95,647.1215,1313.000=
1,649.4296,1318.1647,644.265,1320.4727,654.1,1319.95" style=3D"stroke:#A800=
36;stroke-width:1.0"/>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"13" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"129" x=3D"571" y=3D"1286.06=
69">Operation Complete</text>
>> +    <!--link XFS_DAS_..._REPLACE to add_done-->
>> +    <path d=3D"M793.93,460.12 C749.79,481.09 702,515.46 702,566 C702,56=
6 702,566 702,902.5 C702,1037.15 636.85,1061.95 549,1164 C516.18,1202.13 45=
5.77,1221.51 433,1227.73 " fill=3D"none" id=3D"XFS_DAS_..._REPLACE-add_done=
" style=3D"stroke:#A80036;stroke-width:1.0"/>
>> +    <polygon fill=3D"#A80036" points=3D"798.46,458.01,788.6128,458.1929=
,793.9294,460.1252,791.9972,465.4418,798.46,458.01" style=3D"stroke:#A80036=
;stroke-width:1.0"/>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"13" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"150" x=3D"703" y=3D"842.566=
9">LARP disabled REPLACE</text>
>> +    <!--link XFS_DAS_SF_ADD to add_done-->
>> +    <path d=3D"M114.94,592.05 C64.47,613.96 6,651.89 6,710 C6,710 6,710=
 6,1116 C6,1201.03 331.99,1224.78 408.2,1229.18 " fill=3D"none" id=3D"XFS_D=
AS_SF_ADD-add_done" style=3D"stroke:#A80036;stroke-width:1.0"/>
>> +    <polygon fill=3D"#A80036" points=3D"413.25,1229.46,404.4801,1224.97=
8,408.2574,1229.189,404.0464,1232.9663,413.25,1229.46" style=3D"stroke:#A80=
036;stroke-width:1.0"/>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"13" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"53" x=3D"7" y=3D"906.0669">=
Success</text>
>> +    <!--link XFS_DAS_LEAF_ADD to add_done-->
>> +    <path d=3D"M406.56,730.32 C463.32,747.11 523,778.63 523,837 C523,83=
7 523,837 523,1116 C523,1168.56 462.26,1208.72 435.93,1223.66 " fill=3D"non=
e" id=3D"XFS_DAS_LEAF_ADD-add_done" style=3D"stroke:#A80036;stroke-width:1.=
0"/>
>> +    <polygon fill=3D"#A80036" points=3D"431.44,1226.16,441.25,1225.2858=
,435.8108,1223.7318,437.3648,1218.2926,431.44,1226.16" style=3D"stroke:#A80=
036;stroke-width:1.0"/>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"13" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"53" x=3D"524" y=3D"990.5669=
">Success</text>
>> +    <!--link XFS_DAS_NODE_ADD to add_done-->
>> +    <path d=3D"M174.11,863.2 C152.55,903.85 115.24,988.43 133,1060 C145=
.59,1110.75 147.29,1131.18 188,1164 C255.99,1218.82 366.69,1228.16 407.89,1=
229.71 " fill=3D"none" id=3D"XFS_DAS_NODE_ADD-add_done" style=3D"stroke:#A8=
0036;stroke-width:1.0"/>
>> +    <polygon fill=3D"#A80036" points=3D"413.01,1229.87,404.1523,1225.56=
4,408.0129,1229.6987,403.8782,1233.5593,413.01,1229.87" style=3D"stroke:#A8=
0036;stroke-width:1.0"/>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"13" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"53" x=3D"134" y=3D"1056.066=
9">Success</text>
>> +    <!--link XFS_DAS_..._ALLOC_RMT to add_done-->
>> +    <path d=3D"M349.93,1140.18 C370.21,1164.76 400.66,1201.7 415.4,1219=
.57 " fill=3D"none" id=3D"XFS_DAS_..._ALLOC_RMT-add_done" style=3D"stroke:#=
A80036;stroke-width:1.0"/>
>> +    <polygon fill=3D"#A80036" points=3D"418.8,1223.69,416.1738,1214.197=
7,415.6245,1219.8279,409.9943,1219.2786,418.8,1223.69" style=3D"stroke:#A80=
036;stroke-width:1.0"/>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"13" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"53" x=3D"389" y=3D"1185.066=
9">Success</text>
>> +    <!--link remove_done to XFS_DAS_DONE-->
>> +    <path d=3D"M1234.17,1119.4 C1183.73,1141.3 902.74,1263.34 777.39,13=
17.77 " fill=3D"none" id=3D"remove_done-XFS_DAS_DONE" style=3D"stroke:#A800=
36;stroke-width:1.0"/>
>> +    <polygon fill=3D"#A80036" points=3D"772.63,1319.84,782.4784,1319.93=
43,777.2183,1317.8532,779.2995,1312.5931,772.63,1319.84" style=3D"stroke:#A=
80036;stroke-width:1.0"/>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"13" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"129" x=3D"997" y=3D"1235.56=
69">Operation Complete</text>
>> +    <!--link add_entry to remove_done-->
>> +    <path d=3D"M418.16,326.32 C441.07,340.4 499,381.04 499,432 C499,432=
 499,432 499,640.5 C499,684.61 504.38,697.56 526,736 C625.8,913.44 687.15,9=
51.91 873,1035 C1006.08,1094.49 1186.57,1110.25 1231.53,1113.35 " fill=3D"n=
one" id=3D"add_entry-remove_done" style=3D"stroke:#A80036;stroke-width:1.0"=
/>
>> +    <polygon fill=3D"#A80036" points=3D"413.84,323.73,419.4797,331.8043=
,418.1212,326.313,423.6125,324.9544,413.84,323.73" style=3D"stroke:#A80036;=
stroke-width:1.0"/>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"13" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"148" x=3D"527" y=3D"715.566=
9">LARP enabled REPLACE</text>
>> +    <!--link XFS_DAS_SF_REMOVE to remove_done-->
>> +    <path d=3D"M1430.83,592.05 C1434.97,620.23 1441,668.38 1441,710 C14=
41,710 1441,710 1441,987 C1441,1074.24 1303.43,1104.2 1257.06,1111.83 " fil=
l=3D"none" id=3D"XFS_DAS_SF_REMOVE-remove_done" style=3D"stroke:#A80036;str=
oke-width:1.0"/>
>> +    <polygon fill=3D"#A80036" points=3D"1251.87,1112.65,1261.3875,1115.=
1832,1256.8076,1111.8628,1260.128,1107.283,1251.87,1112.65" style=3D"stroke=
:#A80036;stroke-width:1.0"/>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"13" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"53" x=3D"1442" y=3D"842.566=
9">Success</text>
>> +    <!--link XFS_DAS_LEAF_REMOVE to remove_done-->
>> +    <path d=3D"M1680.62,592.02 C1660.83,619.03 1633,665.02 1633,710 C16=
33,710 1633,710 1633,987 C1633,1067.52 1329.29,1104.76 1257.21,1112.46 " fi=
ll=3D"none" id=3D"XFS_DAS_LEAF_REMOVE-remove_done" style=3D"stroke:#A80036;=
stroke-width:1.0"/>
>> +    <polygon fill=3D"#A80036" points=3D"1252.06,1113,1261.4238,1116.052=
7,1257.0335,1112.4855,1260.6006,1108.0951,1252.06,1113" style=3D"stroke:#A8=
0036;stroke-width:1.0"/>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"13" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"53" x=3D"1634" y=3D"842.566=
9">Success</text>
>> +    <!--link XFS_DAS_NODE_REMOVE to remove_done-->
>> +    <path d=3D"M1234.32,599.03 C1273.24,623.26 1316,661.02 1316,710 C13=
16,710 1316,710 1316,987 C1316,1037.48 1271.82,1085.78 1251.73,1105.12 " fi=
ll=3D"none" id=3D"XFS_DAS_NODE_REMOVE-remove_done" style=3D"stroke:#A80036;=
stroke-width:1.0"/>
>> +    <polygon fill=3D"#A80036" points=3D"1248.06,1108.6,1257.3489,1105.3=
263,1251.6943,1105.166,1251.8545,1099.5115,1248.06,1108.6" style=3D"stroke:=
#A80036;stroke-width:1.0"/>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"13" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"53" x=3D"1317" y=3D"842.566=
9">Success</text>
>> +    <!--link XFS_DAS_..._REMOVE_ATTR to remove_done-->
>> +    <path d=3D"M1125.42,1011.19 C1157.86,1039.79 1210.2,1085.95 1231.98=
,1105.17 " fill=3D"none" id=3D"XFS_DAS_..._REMOVE_ATTR-remove_done" style=
=3D"stroke:#A80036;stroke-width:1.0"/>
>> +    <polygon fill=3D"#A80036" points=3D"1235.92,1108.64,1231.8338,1099.=
6788,1232.1767,1105.3253,1226.5302,1105.6682,1235.92,1108.64" style=3D"stro=
ke:#A80036;stroke-width:1.0"/>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"13" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"53" x=3D"1179" y=3D"1056.06=
69">Success</text>
>> +    <!--link XFS_DAS_..._REMOVE_OLD to remove_xattr_choice-->
>> +    <path d=3D"M932.94,599.16 C985.76,632.8 1066.27,684.06 1095.71,702.=
81 " fill=3D"none" id=3D"XFS_DAS_..._REMOVE_OLD-remove_xattr_choice" style=
=3D"stroke:#A80036;stroke-width:1.0"/>
>> +    <polygon fill=3D"#A80036" points=3D"1099.99,705.53,1094.5499,697.31=
99,1095.7735,702.8428,1090.2505,704.0664,1099.99,705.53" style=3D"stroke:#A=
80036;stroke-width:1.0"/>
>> +    <!--link XFS_DAS_NODE_REMOVE to remove_xattr_choice-->
>> +    <path d=3D"M1157.74,599.16 C1143.62,630 1122.72,675.66 1112.73,697.=
49 " fill=3D"none" id=3D"XFS_DAS_NODE_REMOVE-remove_xattr_choice" style=3D"=
stroke:#A80036;stroke-width:1.0"/>
>> +    <polygon fill=3D"#A80036" points=3D"1110.54,702.26,1117.9134,695.73=
06,1112.6144,697.7106,1110.6344,692.4116,1110.54,702.26" style=3D"stroke:#A=
80036;stroke-width:1.0"/>
>> +    <!--link *start to set_choice-->
>> +    <path d=3D"M722,28.29 C722,41.73 722,66.81 722,83.45 " fill=3D"none=
" id=3D"*start-set_choice" style=3D"stroke:#A80036;stroke-width:1.0"/>
>> +    <polygon fill=3D"#A80036" points=3D"722,88.75,726,79.75,722,83.75,7=
18,79.75,722,88.75" style=3D"stroke:#A80036;stroke-width:1.0"/>
>> +    <!--link set_choice to add_entry-->
>> +    <path d=3D"M715.46,106.53 C675.48,134.25 464.17,280.75 417.94,312.8=
 " fill=3D"none" id=3D"set_choice-add_entry" style=3D"stroke:#A80036;stroke=
-width:1.0"/>
>> +    <polygon fill=3D"#A80036" points=3D"413.56,315.84,423.2339,313.9919=
,417.6668,312.988,418.6707,307.421,413.56,315.84" style=3D"stroke:#A80036;s=
troke-width:1.0"/>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"13" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"53" x=3D"627" y=3D"227.5669=
">add new</text>
>> +    <!--link set_choice to remove_entry-->
>> +    <path d=3D"M730.92,104.39 C750.14,109.72 796.57,123.68 832,143 C926=
.76,194.66 1023.54,284.76 1051.19,311.39 " fill=3D"none" id=3D"set_choice-r=
emove_entry" style=3D"stroke:#A80036;stroke-width:1.0"/>
>> +    <polygon fill=3D"#A80036" points=3D"1055.03,315.1,1051.3279,305.973=
4,1051.4308,311.6293,1045.7749,311.7322,1055.03,315.1" style=3D"stroke:#A80=
036;stroke-width:1.0"/>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"13" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"102" x=3D"994" y=3D"227.566=
9">remove existing</text>
>> +    <!--link set_choice to replace_choice-->
>> +    <path d=3D"M722,113.07 C722,134.33 722,180.92 722,205.72 " fill=3D"=
none" id=3D"set_choice-replace_choice" style=3D"stroke:#A80036;stroke-width=
:1.0"/>
>> +    <polygon fill=3D"#A80036" points=3D"722,210.95,726,201.95,722,205.9=
5,718,201.95,722,210.95" style=3D"stroke:#A80036;stroke-width:1.0"/>
>> +    <text fill=3D"#000000" font-family=3D"sans-serif" font-size=3D"13" =
lengthAdjust=3D"spacingAndGlyphs" textLength=3D"100" x=3D"723" y=3D"156.066=
9">replace existing</text>
>> +    <!--link XFS_DAS_DONE to *end-->
>> +    <path d=3D"M717,1370.21 C717,1387.84 717,1411.13 717,1425.84 " fill=
=3D"none" id=3D"XFS_DAS_DONE-*end" style=3D"stroke:#A80036;stroke-width:1.0=
"/>
>> +    <polygon fill=3D"#A80036" points=3D"717,1430.84,721,1421.84,717,142=
5.84,713,1421.84,717,1430.84" style=3D"stroke:#A80036;stroke-width:1.0"/>
>> +  </g>
>> +</svg>
>> --=20
>> 2.25.1
>>=20

