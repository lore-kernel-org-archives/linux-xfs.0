Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1233BC433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Apr 2022 15:34:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242230AbiDYPiB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Apr 2022 11:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230098AbiDYPiA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Apr 2022 11:38:00 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C44BD45519
        for <linux-xfs@vger.kernel.org>; Mon, 25 Apr 2022 08:34:56 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23PDRcYG025368;
        Mon, 25 Apr 2022 15:34:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=AJtAOozTawHYOCIqqhc5AMIbdnDCocvT6PzHwXO4gws=;
 b=lzOoG/13grlSkjof7qsm0WuZ0jMkrNNvtbdVPQM4+OUCeiWGy/rLmXgPiy8/waLi4NXO
 z5Nvp9a+d4iPJuF/p6RpVvNn70/1GS1/OCIXLoRbjX7CLMP6qPLwiJrj72oBLdqqq9Dr
 Qqnv8ttyZgchncth6wzRDndq4HrBW6n91S6txTh1oMicTNI14K1BvMYT7SoYnn3zg+eE
 tjf2ju+4now5xUytwYx/Gf6nljO9RHXtHvNXri1qv+n0YFQLCgZsaLjJaDHN9bgIfr7R
 29dl8iFRH4lFTRF22NysXpgrx7eNZfN5OR9kj7uahOT511lSoMcEF4eJOZkZpl4o9fmf IA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb1mkjr6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Apr 2022 15:34:55 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23PFUIrG006813;
        Mon, 25 Apr 2022 15:34:54 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fm7w2g02g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Apr 2022 15:34:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l6+k/kUM6pYxXptw0eaRj9STZ7TAfdGdzvCjqc/Fm7eRozH3izAH4XRQPbINiqJSBL/HwmOzOTPOJ4BKh3RZyjb0Z69DY7EyEo64oXMqqeJZG4IDfz6jzVlLtj2gccmY0VWVjQtCgzWMcX7hd1O0jdJXnV/kJ6HfR+tEIkJVVzhtSo4/jiHBFquxv+tCSpx2pWsgufbNwXIAR+JjZ6OyVNrw0jS4bKyPA5jiPHJoysRti0mHb26oLe+TJnpCZiTc6rUH2/+ZeO/Ki2DQBmlR/I6w3sOccoanc+zOP74m4nUO7SzZSGpaefOt8XDaYRM2nE0q0VVSHZ04396P0CEyVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AJtAOozTawHYOCIqqhc5AMIbdnDCocvT6PzHwXO4gws=;
 b=EbH9SiqB1SD5GDP6Ra7NXATZ9BbKOzeWg1mBi1ALfxXBTJv7bTh1t+xyMjn4ZFaLNf2Izk58ZWmaiw9QXTGsxGavxQX/7RGbWmZxUrbBJL8HfjVim9whCciswI0/5Gf7tXH+AF20v+afcZDK8ZskZUG8u0WRA9GV/QJXE0RTj+458H6Hc26cBfPld+f2anLynsCVcsJUD0N8fOGhl0+RTRntuGhcuF1umCN6ewRaK4ASIeAQnfiAEimgcYX6dFH+zRjWrB+RzMc6uJ6LGKuWem5+lwx3Boj2cS5LpRtZFS+O1WyZWd+5+J7+efDqTfRJNU894atqZPJ6+UirD3VS1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AJtAOozTawHYOCIqqhc5AMIbdnDCocvT6PzHwXO4gws=;
 b=ZOiToqa6KhYffOR3U9iAB00aBks9N9/ue5YnKyS1k3vr2riSGMZXSQvGhSXAmwQ2lYIZnu61uLHnWtbUaUNiRwgQ+PYTb/r0WCZFcYdVxCJoTf1ZKLlRmxUIcZGC7OSzf2SIAwQ996eoVo11OkMQWxEl5rC1YFyaah/UfFh5884=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Mon, 25 Apr
 2022 15:34:52 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::8433:507c:9751:97b0]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::8433:507c:9751:97b0%3]) with mapi id 15.20.5186.021; Mon, 25 Apr 2022
 15:34:52 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [RFC PATCH v1 2/2] xfs: don't set warns on the id==0 dquot
Thread-Topic: [RFC PATCH v1 2/2] xfs: don't set warns on the id==0 dquot
Thread-Index: AQHYWLoBf6r9bE9uU0qZnqzKDLhoDQ==
Date:   Mon, 25 Apr 2022 15:34:52 +0000
Message-ID: <05AA5136-1853-4296-8C56-8153A34F44D1@oracle.com>
References: <20220421165815.87837-1-catherine.hoang@oracle.com>
 <20220421165815.87837-3-catherine.hoang@oracle.com>
 <20220422014017.GV1544202@dread.disaster.area>
In-Reply-To: <20220422014017.GV1544202@dread.disaster.area>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8ecc011d-9ee1-485f-20e1-08da26d12449
x-ms-traffictypediagnostic: MN2PR10MB4320:EE_
x-microsoft-antispam-prvs: <MN2PR10MB4320C8B542EE23B70D58338689F89@MN2PR10MB4320.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tIkPZyoDbov8K1iTC4Ljzj7Ic09Oak7zDpZI6lXCMa+X3pGitZkLEgKmYEfRAzhtIInNXJ9dwoLDubeFqvvbbGQWkc8M8+ZmGzcmljvUPGniCU8LbsfwuZe0gge3T+eaQVczZwdQN4PyzSh6Bk3qjVMVe91VahbbySV92JJ/BWzCbqpPXGn0HRnDtQf5oPE/XNeZ3zaiuiDuZMCA6lRY7+NlNxULBUO3u4j+EBfjx9iZYG06O1qbm8ezg/6C6lgpGflZtQDeACbqMAf3Ig2TJTnJVDyIUmhPnIxQzSsL0vepAylXtrtbSrdHWIwZ8b3YkZ7iWvYEVAu827lrf57mJhgXX2qbo8R/PwgzkzVtj21fhflUmfqdJPmDgueMhh8aM4mhT14RHAjsLeKB+4Vy2SP+eKA9tlvD/q1nXK7lpfFoxm0E3wv6KDgxw9MYfWJprXWjF6NiVDPUAkEqznAaViivzD82wK4iq6kA+RqhRjIUeLPbqzVpKGpCz3WOw+0GPUdxtz1GKlUEVLYmstaKZ1gNXI8DMc0EllzK5cb94hlsSGEAETiBHL4pSgdS1wKyDDB0VLgoUjqiotqvpPrteYChyIt9E8IauUskfpmyBxtxU8tvMNWYJQTKafyeNn3cXbBainCA3JpfNmFHhp8tkJUo6PCQOprF7RAzOJFuTsbLigWgSz4rSaHdZlTTpfwzeayVNbvPOilYO/ElxF+wNc168FvoJjfpmmojlg1iqX5EtS2Jjd4FZgycqOpZfwUn44P8NbIwJ0XWvlMuuaNg+Y36+B1+dceJWhBIMT/kzUY8rL8Hij1aO1wko45Q61ve
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(44832011)(83380400001)(6512007)(6916009)(316002)(5660300002)(33656002)(36756003)(186003)(6506007)(2616005)(53546011)(86362001)(966005)(38070700005)(2906002)(38100700002)(122000001)(508600001)(6486002)(71200400001)(66946007)(8676002)(4326008)(66556008)(66476007)(76116006)(66446008)(64756008)(91956017)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pDvQuS4lRnxo1kIhPeW5ZeiJjkk+UYzHEEcwpii4oi/dKYXVO5DWmG2oGgHB?=
 =?us-ascii?Q?bvooH1XhAeufaTyCkiKGQvHFwEAoRJZt22ICCAcLtn8j46xVhnGNXGMLAMjA?=
 =?us-ascii?Q?7sIdt5oDa9h0KGqCL5IuPhtOlp63j+scU4+FxfcpKjfdcbCAF+7gYLNSf6YT?=
 =?us-ascii?Q?6RGbjAIwpEqbFL7KYfWhGncNwZost4UAuMvNZkt0AVHv1HqnC4Bt18VvLwf4?=
 =?us-ascii?Q?aT/603AKn6kHg19JskrrSg3Cx4c0lPHBw1fXSdavg31q+2z9qWxPPme8Bf3M?=
 =?us-ascii?Q?o67rP2RAcXY30AGNSuZasl91uc6+gAnEITZYRy9tycLloJY045Cml0Plsug7?=
 =?us-ascii?Q?DcTc+ZM2PWYdsKLULjx61ZGsPg1DVywCySOiJfIovBLqtykpWFL2UhnQXSH6?=
 =?us-ascii?Q?gW0Aa7Lu3/lzq/bJicCW6uS2o7AdPh+7K+/7fbpeXIs7cE67SCcSqOCU2i8h?=
 =?us-ascii?Q?egpPuSZ6b0HlfVR2xq8p62AZRJxc+MZiG9dHZb2sylifv4prcGrvutwLTBk5?=
 =?us-ascii?Q?ExE4p3gxcA05IM2Nj/iWpi+FwciEIuuNhmB91UKsPVIzUrU+H5TrG7FWYoKy?=
 =?us-ascii?Q?WV6m2QbfP7ByiW26jNBg3g4tHk9t7xwS42UB8T6sYGcjSKNGAOTc8wSlNr6A?=
 =?us-ascii?Q?OCd0RHRPmrmBfI+oR9Cy/6lluzoymRg3TrZyHEYHdL+tvyQp7qGeCnFGgPgx?=
 =?us-ascii?Q?lak8Tsv2Hfq4yReKGkfVgbwHk8UkZ21CxiyH5Z3LAFFH1s6mFnqbaNOIzsRA?=
 =?us-ascii?Q?XnIDHEfBOL9xXSYZgOBJaUkvDQhgwjlr3C/VrC3vncIBGIH3pAQCVxK7SGu8?=
 =?us-ascii?Q?IQbrpLnZijwrXCI3JT0c8RkWoBwcf1xgoalTavHFmbrSB9dggy98LKI+CoE4?=
 =?us-ascii?Q?Ha3YKlYK1sVetUR/jWXwxi9C3kQjJ25sZq4MMiZbj0svhnLcPitIca9Y0Y1T?=
 =?us-ascii?Q?uL6m/Yy/vHc7CuwYjfgyZGPCEkkxeF+NGk2m80MAPAw86BFmEPJP0/gY6HtV?=
 =?us-ascii?Q?WIJXSGEv2g6IkmxEf247SKLs0wX7vQXTf5HW5mpdTzMQdTWPDe4OmvFVNCqV?=
 =?us-ascii?Q?+oeMJ5DYR8Wf6U7XKo/FMvOEYPr397eP1bBOBj06UqMyzTkRPTz0hJZzja29?=
 =?us-ascii?Q?4BixX0vpRf9G9Kj57dYaIwebzT3qyQ7mnD/8qYmCCx13kh10/aJFGnH/ezlB?=
 =?us-ascii?Q?1e/w8xpLcpq4wLTte6xkMQiNSiKrRPfhhH9h47YnjclTDuSwR4kMnNAXnQfd?=
 =?us-ascii?Q?/mYPiNgUwHRBIImem8rNSBn5Eh1UwE4Ya6PZ+d5VhwypmEP6GakXsyOfo72N?=
 =?us-ascii?Q?R+bMuW9g0YIlBgK1RHf/Gl8RRCXc0nlLqrjKNfL083McMqmifxkW+kOVr+bm?=
 =?us-ascii?Q?W0IQbpjv/cs0i82Eqp9tXenVx2EVdu38Ny4Ml4ZyKIXOzH99tkPlwlsdkl35?=
 =?us-ascii?Q?9VBC/4eTXeVBnb/gw8+v09qqN5F9TnGdqJ6jMpIFJ9Z7s//1hdMorby4dGhx?=
 =?us-ascii?Q?+21gneIUsqoKPTtWIFRJwHuFwoPPI/vbENVj/wDMBjuGSmQG1DvBj4bx+fzS?=
 =?us-ascii?Q?g4zDpeQTH7lUSdKMI5QtsHpd5UjqbmE8v1Kxxv/kG6vKNLq3RaWZXRhKUzxO?=
 =?us-ascii?Q?pvaSgcjHw8MN08jRWXtn2kgSSIRhDUL+6wZjUDDUZRXf7w0Ewm4wf9V7EfpS?=
 =?us-ascii?Q?Qx3I/65q2nKnzNgHKQXFRL92yZ6otOI0WFpFX0jHOOTosH1CD/JPQFPimdKz?=
 =?us-ascii?Q?23LII8El+iwBJ5O3MaSkuqW5HQ34uaAfnR2D1xlE4rsHe2LSyJ2nqiiX9mKr?=
x-ms-exchange-antispam-messagedata-1: ZLybU6W9XCXVCdu8XiAjF7OMZyIb9KOIdM8=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DED452EB2CCA0C478CE0F3232B424BF2@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ecc011d-9ee1-485f-20e1-08da26d12449
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2022 15:34:52.4514
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0Q30WRvYKWpnEdmZtMAShikUcDiTQfZ6nEUaXpkUk1ecgoMQRk0ltQVqCMQvGfyMU+sfsdm0olkIRhp1i9Gd8EYBxvzMd3vXlRW1o1xNdxk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4320
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-25_06:2022-04-25,2022-04-25 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 phishscore=0 bulkscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204250068
X-Proofpoint-GUID: w1I4yEvtlIYB-bO1-ooYEhmc22cnPRsa
X-Proofpoint-ORIG-GUID: w1I4yEvtlIYB-bO1-ooYEhmc22cnPRsa
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> On Apr 21, 2022, at 6:40 PM, Dave Chinner <david@fromorbit.com> wrote:
>=20
> On Thu, Apr 21, 2022 at 09:58:15AM -0700, Catherine Hoang wrote:
>> Quotas are not enforced on the id=3D=3D0 dquot, so the quota code uses i=
t
>> to store warning limits and timeouts.  Having just dropped support for
>> warning limits, this field no longer has any meaning.  Return -EINVAL
>> for this dquot id if the fieldmask has any of the QC_*_WARNS set.
>>=20
>> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
>> ---
>> fs/xfs/xfs_qm_syscalls.c | 2 ++
>> 1 file changed, 2 insertions(+)
>>=20
>> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
>> index e7f3ac60ebd9..bdbd5c83b08e 100644
>> --- a/fs/xfs/xfs_qm_syscalls.c
>> +++ b/fs/xfs/xfs_qm_syscalls.c
>> @@ -290,6 +290,8 @@ xfs_qm_scall_setqlim(
>> 		return -EINVAL;
>> 	if ((newlim->d_fieldmask & XFS_QC_MASK) =3D=3D 0)
>> 		return 0;
>> +	if ((newlim->d_fieldmask & QC_WARNS_MASK) && id =3D=3D 0)
>> +		return -EINVAL;
>=20
> Why would we do this for only id =3D=3D 0? This will still allow
> non-zero warning values to be written to dquots that have id !=3D 0,
> but I'm not sure why we'd allow this given that the previous
> patch just removed all the warning limit checking?
>=20
> Which then makes me ask: why are we still reading the warning counts
> from on disk dquots and writing in-memory values back to dquots?
> Shouldn't xfs_dquot_to_disk() just write zeros to the warning fields
> now, and xfs_dquot_from_disk() elide reading the warning counts
> altogether? i.e. can we remove d_bwarns, d_iwarns and d_rtbwarns
> from the struct fs_disk_quota altogether now?
>=20
> Which then raises the question of whether copy_from_xfs_dqblk() and
> friends should still support warn counts up in fs/quota/quota.c...?

The intent of this patchset is to only remove warning limits, not warning
counts. The id =3D=3D 0 dquot stores warning limits, so we no longer want
warning values to be written here. Dquots with id !=3D 0 store warning
counts, so we still allow these values to be updated.=20

In regards to whether or not warning counts should be removed, it seems
like they currently do serve a purpose. Although there's some debate about
this in a previous thread:
https://lore.kernel.org/linux-xfs/20220303003808.GM117732@magnolia/

Catherine
>=20
> Cheers,
>=20
> Dave.
> --=20
> Dave Chinner
> david@fromorbit.com

