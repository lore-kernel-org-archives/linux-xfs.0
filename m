Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA055E7F14A
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Sep 2023 00:02:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbjI0ACd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Sep 2023 20:02:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233835AbjI0AAM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Sep 2023 20:00:12 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3620C1BEA
        for <linux-xfs@vger.kernel.org>; Tue, 26 Sep 2023 16:17:56 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38QKEOow005291;
        Tue, 26 Sep 2023 21:18:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=+BNY6bMANM7cNjcPVZiplKHIwH6ycKs1jMi64Nx6bY4=;
 b=vbLGBFyX9/EdxHVvahU9KF6U4y/9VDniT2VSfMw9gW2YKkcPlowwKtW3tpW7R+4IdN+W
 WKc8OAFCdUtvh7Czmqbs6+aXelO5Zo/eO5RsO5NTK9wMI43xEjr1/mKIk0qWtA1HIK7v
 0uqOL25XQLYTfhGX3oizM87ilLcZYvOHv3nuffbvwbcl+2KFF9HJTzfASyyCs1c42kPk
 qIlOtUbHrsH2uXvYoEqCpgXo/xNhDmdlEh7tHLZSozzO+h2XzzNYn7Smk329/WOWc2tC
 CfLS763U3Q/bw7ZlNVLH7Ni6aDj8QQU1Go9It6WeG/lKYcLq4ECKWOqW6xo2HSWNsOBO uQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t9rjufxk7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Sep 2023 21:18:42 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38QL5EUJ039477;
        Tue, 26 Sep 2023 21:18:41 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3t9pfcw27f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Sep 2023 21:18:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NHmwVgPcLu4q6H409nEqQ8idRnHQtgWg3ltfrBi86nqxJr6eVuEiX2AbeBJT6DLOIF9s/HYE/JqJuHfL+dXi5EViKWFse443uwS42GfvYqXHqT0vLHUxXaFfPpp9gaytvA5RE/qYAopHL8PDlSovd0nawIRygGEMlhKtv87tXQlhwHENgOBuBIH6y8pfcmwfqpaaoqnDjvfoja7OTKsQ0NQ5CWo83dLu+yDE/EGo20GHzk3fDoZ8ScEub99TLArGdfySq4elGclPXiXsJ86egW9WIk/5t2GwoYelT4btvqe2imaE+kXmDIJsousajrUBpwNsNtuS1WDmhzw29qfxQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+BNY6bMANM7cNjcPVZiplKHIwH6ycKs1jMi64Nx6bY4=;
 b=S1xj1aoasvYuYEOtC+rmG3t8I/dfBDoRdG2b3jO5pYqtnJjPAcp0+4lGtw8hbCjSRhp5rzS8Ob4Z91b1YDZzNAR9VVBvADTipSTdnBT5agotyughSL5lWr9EdxkpEV4fZDVFp9/WG/d4dnlyKmI6Uu+ZJ/8XT4t9CxtRfLUB+Ky4ZWq1xKRBz7AbRFxAUKzTMeyIFPwW3UnAyeB4OCzXpF3O7UOYQ0v4veLB8hFYl8c7UIdG3wNtI09M524bNinyxHzG2VEeT7maCQ6cyQ2v/BUnqWwZkMADjcTSsGEJESVq561RNJQ3Tzz/R4hFWbn3zS9QKUkTZsSuAnfRVGgDFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+BNY6bMANM7cNjcPVZiplKHIwH6ycKs1jMi64Nx6bY4=;
 b=L7KE7iQjiw1sCdnmAWrsazy29ATuzu27ASK7Jyj8y2yPqeZjaBmx5uOQar1dbhyxPVIcEKTIKILjSaxLMBAk4uKRTAts9vn9qcbKLZmKWLXnxQ2jTKeQLrwQ+YxlV6n95BNQet0GbHtlDZHbwnN52jI8xvFvLiGOSvuCLy9gvxc=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by SJ0PR10MB5696.namprd10.prod.outlook.com (2603:10b6:a03:3ef::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.21; Tue, 26 Sep
 2023 21:18:39 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::9ee1:c4ac:fd61:60fe]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::9ee1:c4ac:fd61:60fe%3]) with mapi id 15.20.6813.027; Tue, 26 Sep 2023
 21:18:38 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
CC:     Dave Chinner <david@fromorbit.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: proposal: enhance 'cp --reflink' to expose ioctl_ficlonerange
Thread-Topic: proposal: enhance 'cp --reflink' to expose ioctl_ficlonerange
Thread-Index: AQHZ8L8E7fpyGay/+Eqm1euuNIHosQ==
Date:   Tue, 26 Sep 2023 21:18:38 +0000
Message-ID: <02681670-0DC9-4080-902A-0C210CEF1A23@oracle.com>
References: <8911B94D-DD29-4D6E-B5BC-32EAF1866245@oracle.com>
 <ZQk23NIAcY0BDpfI@dread.disaster.area>
 <20230920000058.GF348037@frogsfrogsfrogs>
 <ZQpF2bRLN3lQk1j1@dread.disaster.area>
 <20230921222628.GF11391@frogsfrogsfrogs>
 <ZQzPWJ/iojT0Vumi@dread.disaster.area>
 <20230925212835.GB11439@frogsfrogsfrogs>
In-Reply-To: <20230925212835.GB11439@frogsfrogsfrogs>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.600.7)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BLAPR10MB5316:EE_|SJ0PR10MB5696:EE_
x-ms-office365-filtering-correlation-id: d3210778-df87-4756-ee92-08dbbed626ed
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6/FQgPmeyPx2CuSPRuewvy3Vj6Y/nUqcHvi84d88pXbzcCQfiX+4NKehTMz+HnnpSTjh7cmwoqmSEZ0W1OBXNDxvkBoaDIQZGuru8++bcqaEYW6tDMe9UAO/MxD88kjMQjp4dlJfFe8J5QivoDuz36dntg74TpC3FlScgy/dB4J3ZxbBcpz9742tfzvtO+aedwa7P/MbFfkVGkKytv6QDXoc32BLlELxsz5T66n+f5dLHb3oem/4wYFh3aTSyL0TpsafzP0OKW7DsxFNP1cP2N/U6gbkZb+EPBNA6If46nXSzQdVJlI2O9UmtdKCc9E84NFzV4bFnjW6UU6OR50cNqA7x/AWFtexTLBWPLpymPAPLm7ofr2LpNAa5kHirBfK5YhPP5LatyGU06nD45kSpunAPsHy/jwObgt0CCOo63CYFhif4pL2XEjExIU19GXNHTVxfH3To7SrNE5iKqryYHKL2b4g9coCSk9WGuelZPWAaNGbgc5E/N3BPnNAq4PgZhT/BXr6l/aF76TNV5Ini9H+3nRJOU6WCgMwjjum7lj6qa1v8/wHr+tBodxcTGmbTJzu3mn7WCxIgA79Sj432C10hwLpkKtR+PmzRy24r0e0bxdl6HnUXMn9rk/aZRQ0kqZgCKI+bIYit1LNH6SORQbtkzYSdkUJzzM//SaKix2JwbCd8WYtREHnvcBcnjaf
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(366004)(396003)(136003)(376002)(230922051799003)(451199024)(1800799009)(186009)(2906002)(8936002)(8676002)(44832011)(66446008)(66476007)(41300700001)(5660300002)(316002)(54906003)(4326008)(66946007)(66556008)(64756008)(6916009)(76116006)(91956017)(6486002)(478600001)(71200400001)(6506007)(53546011)(6512007)(2616005)(26005)(83380400001)(3613699003)(38070700005)(122000001)(38100700002)(33656002)(36756003)(86362001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8zTFA7RksCcNBQFHJg444qL1Xcj2ZJzoPr6ldzLk4gGsSEkowYUIHpWXpVGt?=
 =?us-ascii?Q?26xdEjoW7t5hKlqPevyLfBif9RUosk272jyykOSQm1/fgBFZDunYKgPXlWSy?=
 =?us-ascii?Q?UeJstnrguykTnu6d1beOoucmhAmi5vBJkMKv2mC4rr0wENh4E1o0k5sSwBzT?=
 =?us-ascii?Q?YhAL7sX56fP6ARoFlHekHEM8A/MfSyzNAGVmzGRqDBQrwKkdLB6GgGnuqECX?=
 =?us-ascii?Q?0LS68oPwNj39rrYE8CyWlWSahdoT4YlpfkmbT4h2ZvS3/BL8Yv7WvoCCuXDx?=
 =?us-ascii?Q?FEsXNtTDl568E+fXhfJV2MjwgfD0TXdz/QcP3MyTS10PcpxslTdJEE5EvkKh?=
 =?us-ascii?Q?JPJIgxPwfpNIxpJavtFkidNjzkpzZpzttik/Jw5DNz3nTPhi1KAvdx6w+SZy?=
 =?us-ascii?Q?bqga9FADiL5XYqQmiZqykCnOgOHRShHKMwDb3sRRFbYLGnFjoJLtJXCjwq60?=
 =?us-ascii?Q?nz/sxRqYs2dmbQk+dwrvg2kI/q2C3nJy+f3F64tqhY5az1qdMjTzMkyaxVaa?=
 =?us-ascii?Q?5ZorYSSxkLH95CIDT8UA7kaANqXp5b9rbduBfz9vxX5P5y1u01OQTf1rtTVJ?=
 =?us-ascii?Q?27adPAFkEzKJwrwABu/Rhu1bb5Rq04j7kwzLE9Jjcr7U4oDeh2PxpchQVakW?=
 =?us-ascii?Q?FfC57wzvFRubcervq29WmVNTE09zLJXcM4aDCLNApKS07hq94xWgCnpqXxJ5?=
 =?us-ascii?Q?htOXyMEWDmaYrhYaeulFXyhf932HBUM2prfB35q50x2j3mCpiV6ssI+ZcnmS?=
 =?us-ascii?Q?FWfNzV4nUuSty9Ktum6bn/h+GnIRY7odZVAkWpI1RmrLHvp99oeuSIqlCCm7?=
 =?us-ascii?Q?AO7+S60HMLEnb41R+epjy4lNTJI7IqV3HQji93KtI7Er+KP1O/0a/zEwq7Um?=
 =?us-ascii?Q?Q1Yk5c7Jzlv0onPyIhJMVt2GJrpxLFA0lxWAW60JI9tRiZqyDn8Tb8A4hKep?=
 =?us-ascii?Q?slBv/mBHDlG04QaL8k6liZJpwHslZtNWbSY3R12z2YiyLx1fsqZ8/xfPthv2?=
 =?us-ascii?Q?bKggMRgHfpVlY5527VIsQVa6QVaCpzRZ1OVALgrpB6AL09lzBuiS6Og+nFkr?=
 =?us-ascii?Q?rBKqxkFnhR1bODqn1BH3K/IO49DrsGaIbQe0061oju3lPE7TprtGgnv0jUO4?=
 =?us-ascii?Q?nzdM++DtSO/gM5XadihB80hZgPM3FHtpNQ5pC4BzO15RDdB4qvFG9NVx16Ui?=
 =?us-ascii?Q?m30wLiq62J83fZGQhm10jKgRYcWs6cF3SE5UXjxoHJMfc+579LJ5zUrOngLn?=
 =?us-ascii?Q?gyFVsgaGoi8KkNknuQW6NQ6/L/ca91pug+Sq4qhiD9zks+9AjPm33FyeqNwM?=
 =?us-ascii?Q?dmX1oEi7vUKtGW+kvpYTkPoCRiCol2uOVJsAehep9uhCTkBmJlwbYIxuIccJ?=
 =?us-ascii?Q?GlNRcBoUWorrMYfZLveU823bDcsMxJ5bl15WdwCFSPNyxfkSN6HS2bLk/cz2?=
 =?us-ascii?Q?vZvaa7/xjD4jcEnQ2OxErsYHtMwpmF0Y608F0Wo8GlQm385BC8Cvh92iWsY9?=
 =?us-ascii?Q?eiK/n9ot9CXn/8l98/nkbxHSpPd6FgMhz3rjkIgLSXfBIPZsAWH6dDXwwh+w?=
 =?us-ascii?Q?JP1+CQMRbdgcDXEmh+YtbFEEbfO6T5Ws13legMz2VNwiznUyLCEUVZP+Z5cu?=
 =?us-ascii?Q?yg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0B6C01E612C668428C4EF8C6A8740BAB@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: fszvQXZHhNvvzXz4Sz+nWP1L4J4Fc23r5JtReCrWG5xvs2SVHCpaJrhVpVsL4SaR2rZzdpUeB5Vtg473A/BCkc/8nyOJFPVU/8iUvSbIexsWU4dJ3ACEM/fVSb3wU82JPO9Ueq3M328RdFsA05y1wyjPbSBQ1ra7hJZ1EQktku4Y72attkYpVp1payoO0ya4O76wU8zpO6/sRj+N474OmOpjlYokqKqx101b2D0lTviRC8e7tn/4C9Nhww044bViuSOp/kp9NqglEo7F/1OO5NIQOFVEFj5ri9HdM1sgQqZSORc0H9g8FWRSJsUnRchNxOERuI+H0RWC8A6a5WhMCnUt94N4GX5EdJquUiKZHwlaIGT7FV34/nEn7i2GXFkNddnSb8ERa/TZ9P+1YlinWeQGLv0liUitIP1iC6Dzumt07vCGyr7mg5SYgqD2YkkWEjvJhB9Ysp3NS1MZFsp4MTkOKBFlnnaPJiwLgn7mOaqVkdfx382PQ/g1YkyK6+rxOAor85XspnUOj70YPBHDAWXHVPE+00gUq+DeDzpnGoA+aaBJIMuMdT1PokmzW3wxoBtoqSDS9+5Ajsfbv9Mrr5JmdLt5V05nvO6O/kXSERf2uKJfb3EzsvP4SCOg+uStImVNvoaMFXtjkXV5qbi/hRxcQHOaQPqexKxrKA+RIfvJ2KPSS/tA4hIdUtKpRM1a2l4MrWwCZZBkFgbR/W1CTY8FZ2fzcMyBKGxfxen3npdVMiUXkZWqZ1bxfHgyHtAyzQz0yPQbaiW+lQ+0uPqh53GFf/XZr0ppOcVlQQV0wpkS+oyRHvgdzzCksB/U4cMpDh1khpRDaTETRqcdqAa4IQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3210778-df87-4756-ee92-08dbbed626ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2023 21:18:38.8117
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wwghXY3lnCUlroYbQ+9tn1BK9Q3hy68wm+xrz+lhr6o/EJSUOdBevoL1NDqd65UeOrME3sRuateKNGRpsKveeFYVuYbRSTRNRIuA0Wi92a8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5696
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-26_15,2023-09-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 adultscore=0 phishscore=0 mlxscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2309260182
X-Proofpoint-ORIG-GUID: plB-A8Dr8bmfxY-BA0vhh_QgQRlWLHnU
X-Proofpoint-GUID: plB-A8Dr8bmfxY-BA0vhh_QgQRlWLHnU
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> On Sep 25, 2023, at 2:28 PM, Darrick J. Wong <djwong@kernel.org> wrote:
>=20
> On Fri, Sep 22, 2023 at 09:18:48AM +1000, Dave Chinner wrote:
>> On Thu, Sep 21, 2023 at 03:26:28PM -0700, Darrick J. Wong wrote:
>>> On Wed, Sep 20, 2023 at 11:07:37AM +1000, Dave Chinner wrote:
>>>> On Tue, Sep 19, 2023 at 05:00:58PM -0700, Darrick J. Wong wrote:
>>>>> On Tue, Sep 19, 2023 at 03:51:24PM +1000, Dave Chinner wrote:
>>>>>> On Tue, Sep 19, 2023 at 02:43:32AM +0000, Catherine Hoang wrote:
>>>>>> The XFS clone implementation takes the IOLOCK_EXCL high up, and
>>>>>> then lower down it iterates one extent doing the sharing operation.
>>>>>> It holds the ILOCK_EXCL while it is modifying the extent in both the
>>>>>> source and destination files, then commits the transaction and drops
>>>>>> the ILOCKs.
>>>>>>=20
>>>>>> OK, so we have fine-grained ILOCK serialisation during the clone for
>>>>>> access/modification to the extent list. Excellent, I think we can
>>>>>> make this work.
>>>>>>=20
>>>>>> So:
>>>>>>=20
>>>>>> 1. take IOLOCK_EXCL like we already do on the source and destination
>>>>>> files.
>>>>>>=20
>>>>>> 2. Once all the pre work is done, set a "clone in progress" flag on
>>>>>> the in-memory source inode.
>>>>>>=20
>>>>>> 3. atomically demote the source inode IOLOCK_EXCL to IOLOCK_SHARED.
>>>>>>=20
>>>>>> 4. read IO and the clone serialise access to the extent list via the
>>>>>> ILOCK. We know this works fine, because that's how the extent list
>>>>>> access serialisation for concurrent read and write direct IO works.
>>>>>>=20
>>>>>> 5. buffered writes take the IOLOCK_EXCL, so they block until the
>>>>>> clone completes. Same behaviour as right now, all good.
>>>>>=20
>>>>> I think pnfs layouts and DAX writes also take IOLOCK_EXCL, right?  So
>>>>> once reflink breaks the layouts, we're good there too?
>>>>=20
>>>> I think so.
>>>>=20
>>>> <looks to confirm>
>>>>=20
>>>> The pnfs code in xfs_fs_map_blocks() will reject mappings on any
>>>> inode marked with shared extents, so I think the fact that we
>>>> set the inode as having shared extents before we finish
>>>> xfs_reflink_remap_prep() will cause pnfs mappings to kick out before
>>>> we even take the IOLOCK.
>>>>=20
>>>> But, regardless of that, both new PNFS mappings and DAX writes use
>>>> IOLOCK_EXCL, and xfs_ilock2_io_mmap() breaks both PNFS and DAX
>>>> layouts which will force them to finish what they are doing and sync
>>>> data before the clone operation grabs the IOLOCK_EXCL. They'll block
>>>> on the clone holding the IOLOCK from that point onwards, so I think
>>>> we're good here.
>>>>=20
>>>> hmmmmm.
>>>>=20
>>>> <notes that xfs_ilock2_io_mmap() calls filemap_invalidate_lock_two()>
>>>>=20
>>>> Sigh.
>>>>=20
>>>> That will block buffered reads trying to instantiate new pages
>>>> in the page cache. However, this isn't why the invalidate lock is
>>>> held - that's being held to lock out lock page faults (i.e. mmap()
>>>> access) whilst the clone is running.
>>>>=20
>>>>=20
>>>> We really only need to lock out mmap writes, and the only way to do
>>>> that is to prevent write faults from making progress whilst the
>>>> clone is running.
>>>>=20
>>>> __xfs_filemap_fault() currently takes XFS_MMAPLOCK_SHARED for write
>>>> faults - I think we need it to look at the "clone in progress" flag
>>>> for write faults, too, and use XFS_MMAPLOCK_EXCL in that case.
>>>>=20
>>>> That would then allow us to demote the invalidate lock on the source
>>>> file the same way we do the IOLOCK, allowing buffered reads to
>>>> populate the page caceh but have write faults block until the clone
>>>> completes (as they do now, same as writes).
>>>>=20
>>>> Is there anything else I missed?
>>>=20
>>> I think that's it.  I'd wondered how much we really care about reflink
>>> stalling read faults, but yeah, let's fix both.
>>=20
>> Well, it's not so much about mmap as the fact that holding
>> invalidate lock exclusive prevents adding or removing folios to the
>> page cache from any path. Hence the change as I originally proposed
>> would block the buffered read path trying to add pages to the page
>> cache the same as it will block the read fault path....
>=20
> Ah, ok.
>=20
> Catherine: Do you have enough information to get started on a proof of
> concept?

Yup, this solution makes sense to me.

>=20
> --D
>=20
>> Cheers,
>>=20
>> Dave.
>>=20
>> --=20
>> Dave Chinner
>> david@fromorbit.com

