Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32C7DC7618A
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 20:41:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbjCPUlX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 16:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbjCPUlW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 16:41:22 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2214E1933
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 13:41:19 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32GJmQKY015248;
        Thu, 16 Mar 2023 20:41:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=ZENVnql6BKUsAiskj6pF9tcwaVpDykuHe7+jBj1Gfwc=;
 b=Ry6dPO7bNjvF2R28szY/PDnCNkUFyN7NAO4VnhVqsvrC0VGo8oPJ0gFUHqrtUkHdHfIX
 de2eOk9jomhopOHP9aQWczomzSPgwLIWuYrs/vTpOVd9ry7Gj15KLbynZ90YNGAf8Jwz
 9ylMRo/ol1sgiReLnWXgp9l3Q744nL+37Ct9Ll5Gi313JTmizLhH89wV32rHnVTe5Lfm
 szeCjwD7pPakCz0uyLunupelyV8i+B7X67s9bYmFr4pg27ZaEiGiMRvTjlPAYnijTns9
 6UO+q2Q+jKFfjvLvIuKfczX8mPAxACrVjUabTjx/GJpDC8EP7urCAa7fZ5ifHLpAtz9u sg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pbs29j8hs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Mar 2023 20:41:18 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32GJmFZQ037154;
        Thu, 16 Mar 2023 20:41:17 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3pbq9j3wf4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Mar 2023 20:41:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e4renp8nlZirubaWDmYC6Fkp4yis68HT9yoQmIto+QYD6h+JvFY+DasTrynt9y4XComfQHFV0YZguMXSw2VwN7O7Vb3a96ai1atXgIQpNT25l9DkVxJI243/F4Nquu4q4ZMwxyGu08HMALwbheqmXP4BnaNQmV7LA0TGeHJgoqe61w5/rHlBWK0I7lAIrhgoE2LALCAHyHgRQx5wqWYZ+ejyJ3k2uLVpr4t8b5m/bmkBjmRs+iFD7aP0x8U0JJ+jRyFDgAQkBLReh+eYhTk+t+bTfb59n+lxzLAUTYq+ld5xp/KRm2vUh7OYM1JzdXRsrU+COLvMpl0XJHJK5Oy/eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZENVnql6BKUsAiskj6pF9tcwaVpDykuHe7+jBj1Gfwc=;
 b=QSI3yV03rEtZltkfWwvjjcHe9GHlrPzE8UrkgJR699fu4KY2Ii54k5WbRIHtatra+nwF1Y0G1kxzAQOcckd14OlRa8gwgMXynoN3qBph7Ky+ZYrc0de+gt0+b6hwcaU+Cr2ITBKm6cwupYP61n3g4DozwrXmihval9CQpJk1zsBfEAaYAB/SFk3yK3jImKP/ibkgmWQw5HeBAwWlI4qtAug5edDucqkPASr+S7o+6LVFE322kfOgnvuKjL465NNx9aHxqS3Bk/RmzsJBGsj9Gnfx58mODu6POxJ6FZ+6SZVtu8ykRnKLzpq3jpwuVRS7zQaArctIrfx0TchfSLiOzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZENVnql6BKUsAiskj6pF9tcwaVpDykuHe7+jBj1Gfwc=;
 b=iDiHY7EEqukQYK7vRnJUxn/8s4BaHNhLuhMnF54t6j30YjhL2h+rOxXWE/Uc7TsyDI4mIii2ikt4dQ3mBy6eEnh+VjJoNkW7qYahijHU5rBYhBUxX24oXoozxwvNe0XBQ9WaYRjoD76VP4AtviMpZAAgiYPhFb4RASMD/AojKw8=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by SA2PR10MB4715.namprd10.prod.outlook.com (2603:10b6:806:fb::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Thu, 16 Mar
 2023 20:41:15 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::b647:355b:b589:60c]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::b647:355b:b589:60c%4]) with mapi id 15.20.6178.033; Thu, 16 Mar 2023
 20:41:14 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v1 0/4] setting uuid of online filesystems
Thread-Topic: [PATCH v1 0/4] setting uuid of online filesystems
Thread-Index: AQHZWEemEU1BZgASt0SW5i8V9LBCIg==
Date:   Thu, 16 Mar 2023 20:41:14 +0000
Message-ID: <953CAB5C-E645-4BB2-88E2-E992C5CC565D@oracle.com>
References: <20230314042109.82161-1-catherine.hoang@oracle.com>
 <20230314062847.GQ360264@dread.disaster.area>
In-Reply-To: <20230314062847.GQ360264@dread.disaster.area>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BLAPR10MB5316:EE_|SA2PR10MB4715:EE_
x-ms-office365-filtering-correlation-id: 7167fea5-93a1-4599-0728-08db265ec945
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H9v6W8PEhq1yWrjxNT8bazxAc4k1SyQmu//dI97u/Z8Zdg5jDuTJHUoqmoOeVQ17ncNw32swkrVGCIOXa9RCkAsvx9DhsLXnBh1/urwmAAj33BMcvSftVYGwrOynnLsCLWaIJbFVajPVe05722/urGQGprjshXOomX/ZLkbhq6uZuhFQf4tGkNsLdJSqkSsJiUGQuhb8MpNfDorQsLEQs5NQu5Tkif/jlhrm2j9XinOiwXaqtNcK37z6/DvqcmoYoICILOtTOHC/Lckqr5hXRezuh635qxU+KIdSFajlBSok0gICA2MnVGKcS0srzY9ooP7H9MvGUNhskhgQb2wAmxNcpxBdozPgSmyFEos0lTFZnRtAjqI7/SnaQcR0x+qU+njJdZNfZN7vOjivqEtl6lDGMwvbpwG3DpqxeNXJhDrGf/tZ/bUocqD+HvMPegkK380vqUVPT2I2jvM4VinfgHEPor3HEZmgE6ox5LLl063PO8nwU+b2dZ42C8gW5ONIJPTh43pgfc2Bsfy4sWb+i85wrMQjxjFgEBco2NXUbrwxMyPTPkERfxI96G8ARnu61AbuBzPi13pPFUUts/LPQNWsZSF8XOOyvgF33fUqxtI1Tq2lo4fWu/v7OLRNkAbbupcjr8lZACdUmdrO4Za/brbnVAchEzI8bScjzqKXyWDxvX9ww4jKP8PxqGCVAFaHN5/ufvJRujxI6+VuU+5mqOi/Z9WwSanRBKI80Hqq6E4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(136003)(396003)(366004)(39860400002)(346002)(451199018)(8936002)(5660300002)(41300700001)(44832011)(2906002)(38070700005)(38100700002)(33656002)(122000001)(36756003)(76116006)(71200400001)(6486002)(91956017)(66946007)(8676002)(478600001)(64756008)(66556008)(66446008)(66476007)(6512007)(53546011)(6506007)(6916009)(4326008)(83380400001)(2616005)(86362001)(316002)(186003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xZo9xP00cZuNYBq8Ylxz1wfp7XViYdKKardbFnaYBp0UxNE1JaqKJ75MPeDf?=
 =?us-ascii?Q?jH3YP24Qi46eluZkzey+/pec9X5O3M9v4W/K1ans5ovpbBGRwuDxzLY+Ys1U?=
 =?us-ascii?Q?XDktE/J4gzJelh5e49Q30PmVK9cXR2ksmXibrXpQDr/5zUBOL4RCDRrc9sqO?=
 =?us-ascii?Q?ASYz3/OmT7zah0NUXZze5wnyBluVz+E8rBya/+zjfqzVhAoFZEwQN5ysGB1u?=
 =?us-ascii?Q?Ex1EA8F1oc61GYTdq3HqzjuFpvlRB1ooxTRodiHMEh2JGPS0LpL3FZadZ966?=
 =?us-ascii?Q?jtXl8eNqqVzXOPes1983Vzwa5BFQVMDck7TeZlyojLmoPqwR39vcr3PgxmGG?=
 =?us-ascii?Q?nW4n4YSbOffmEorEITzcjyWVvvXp9bAHkhKxPQ8VNQrlAzTNGnNyrZ6cFIO9?=
 =?us-ascii?Q?eckfpJtKz0wz55Ix/RQv9MwkX/CGh1Tw7RmvLOvcmRr6uMt5KTHsm+N82oKw?=
 =?us-ascii?Q?faujEOLQIwzTJeuiPTmrsifSELIvo5myyb7jzSxg4dJ2ay+l9l14dUADIEY2?=
 =?us-ascii?Q?8IGO5xE8z/i/LDCT/2VAbFTKMfhGj71o881pCr4PQk0Z2cWucluYtLlBgDKT?=
 =?us-ascii?Q?FuDO/rQBc29yP9wbSIQ96eHeb0KndvwfvXhFL1OdgCznzuakRYDn9lhSM/pn?=
 =?us-ascii?Q?jVjSPGROkbaDtJ7P1mRJLJ4dR7d5DsgKU4Xi0kKijV5Pj77Xabxy2fNp1MdI?=
 =?us-ascii?Q?Mss9R5xRHEFu/I0RsVIBy/UaXmr2tqZIgZnDQ6qSsO/8HGBjeKvPpQSJcUpb?=
 =?us-ascii?Q?2RUeqU3DbW2lkMAAFMhpOOKUg174B1Be4KMkZxfGz/XmLQDUm79MLknSQeJD?=
 =?us-ascii?Q?TpDS5s3xwikNbERD5Enwr3Si7XeJCoDXfGKXt2w7EqKE47+K/hnCBxlazluJ?=
 =?us-ascii?Q?c+cWAKc+Wz0NVHzV0lEO+SP9TuF4FXapOKWTSR1K8enjkpa2tiPIBAkATFsG?=
 =?us-ascii?Q?2EydcZ2V0tudJDp823X3cLI004AXPzg+/7IXttdOHQsGnYh/wcZHNJ8w2Q7H?=
 =?us-ascii?Q?yDQxrjiyWEfjfwg890XHvZICeNmCQ5BzLhYuYYylvYYJZ7VVCt24vaK0CyyQ?=
 =?us-ascii?Q?JmiMogPNFQ71KeSg9/jGp0yfjctI9u7ksbq2SRMm3O0yD0miDoKIdTlQfdbL?=
 =?us-ascii?Q?tnJIvKGoGOkeS702of+SetD0AvdmWKquj2tgH9WJ5ZN58IqdxwmUueBzUun+?=
 =?us-ascii?Q?YawV4cs1MzycqR0VvujUgBrC7/+w5jYGBJAkUwfxNkBRA38hEvLORTHv282/?=
 =?us-ascii?Q?QUK2HBLt/cJJKF/YXoYW86gw6Pzd1j082gjgtgk04IUSSPJ5Xo/HLW1m/i/U?=
 =?us-ascii?Q?lgtrS6uTL6jf56u9GtVLjIc3fRyr2QxDaqKNd3FB0JaAZyBshnLnYcufQ02x?=
 =?us-ascii?Q?nsz5SiD/wM6Y0wt+0aYfLWhvhNsbkOuiCJOhsZKhOGENxJCGE5/BsDX2emBU?=
 =?us-ascii?Q?ZI/81OdyAiP4S2+f0edq2+TBQj8iuLNoG6IOFlAzLP8lEFtjvMDUJfg1Aa12?=
 =?us-ascii?Q?wY7SLhOIQ8avWOuk+D4fiD9e+c68GYs9jgTW63RUp4+5V96UxSb8QZgYHpU2?=
 =?us-ascii?Q?tE5tutjcBSXwhftXmUiVgN+WZX9z4fD58bDqR4RvSdmPlytRHuFVSYL+T6FO?=
 =?us-ascii?Q?lW1bs1PafMJvZnslDEPwuxhCzBYXuc2Ab/fu7UaLCIYuyoaLH8dtCwYWskcw?=
 =?us-ascii?Q?JNIKMRZgfAuJMfS1e1q4749LnXQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <25A07913BBB7AD438E39B6F3CB440D8B@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: x8I+nzMQ33Gqb5WWYDI2nZnv7lCcwW1PzrFQoBK3ZVwp0/w402TdtUrgqeXWbc7quRoIY9z32LOv7inwln2zeYBKUgRTrDpaHUzjmM2bsngQby1D5Xy8t7Ph89JislyLcTZOwHRWdfPECz7a2oxPk7zn/4tHNbg/iW5RN3irYrAOnI2O0m271bdUMWoJiyF6++s4tcp4y06FhwDQJEbXSzdStkLxXDeNThMAl9snHoE/xVBbzquFQiz9Z/sMw9yEjzz/q19hPG5bUQCQ0TcGLZldgmkSiMdgbMv35MkFkcBiM3sEM2PR4xkvKUbuUXgynrgC1sQtGeeGx+B+fw5tDi7CoUZOP2rrDBba9lRATJziyOLxPQDs276XgCX5LWXWOUKDzQtVtDKsLDEL7HO4ldcMZq0FJrOnvyKZHiP8maGXfSEZdODia/1wTMmTKWyiMBqosx26/Hz+M12iVwPy8XDzEaUfEmxva5lekX0wWvdbv0lWgOauSauodC/gj0uQr4NJ95qTiPuvpdbkvd+llc5keITym5A6nYwUOiBj6FA5YJwhxWdzVsecADQXvnp7uCMcZjwG4t/WmRzio6DmORrpKjf/tmWY/b7xMskfVMBtl5VaHFY9/Af6wi+XBg+64Tq0UEGiNbAZIz8LI6hvhw+mD1bJBlSjYJ/phg1odZdBfZtOd1XtQkOSxPCmaSdq08aajxC6kpYNGogZMMeeKjCwOGzmUS33gJT4Olm3/IYFfq6jXkizkEMPzj9uXYxMW9fS1YwsRzkHdjbkQKIYoeZ4IkioQuGLTRZ1fYwHz04=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7167fea5-93a1-4599-0728-08db265ec945
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2023 20:41:14.8113
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GkajofVilO46dL3+yRAgnXt1r1apwR/qVEPVXd7CWi2kXhrNX43H5gIoMGjVhJ530A19BEqWd65JXsOzupvsFYmrxE5LptNAbqxJccjDKBY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4715
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-16_14,2023-03-16_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0
 mlxlogscore=684 malwarescore=0 mlxscore=0 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303160155
X-Proofpoint-ORIG-GUID: HevRXL5bJfjZuAlbDlvMA9CAxGPPt5E5
X-Proofpoint-GUID: HevRXL5bJfjZuAlbDlvMA9CAxGPPt5E5
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> On Mar 13, 2023, at 11:28 PM, Dave Chinner <david@fromorbit.com> wrote:
>=20
> On Mon, Mar 13, 2023 at 09:21:05PM -0700, Catherine Hoang wrote:
>> Hi all,
>>=20
>> This series of patches implements a new ioctl to set the uuid of mounted
>> filesystems. Eventually this will be used by the 'xfs_io fsuuid' command
>> to allow userspace to update the uuid.
>>=20
>> Comments and feedback appreciated!
>=20
> What's the use case for this?

We want to be able to change the uuid on newly mounted clone vm images
so that each deployed system has a different uuid. We need to do this the
first time the system boots, but after the root fs is mounted so that fsuui=
d
can run in parallel with other service startup to minimize deployment times=
.
>=20
> What are the pro's and cons of the implementation?
>=20
> Some problems I see:
>=20
> * How does this interact with pNFS exports (i.e.
> CONFIG_EXPORTFS_BLOCK_OPS). XFS hands the sb_uuid directly to pNFS
> server (and remote clients, I think) so that incoming mapping
> requests can be directed to the correct block device hosting the XFS
> filesystem the mapping information is for. IIRC, the pNFS data path
> is just given a byte offset into the device where the UUID in the
> superblock lives, and if it matches it allows the remote IO to go
> ahead - it doesn't actually know that there is a filesystem on that
> device at all...
>=20
> * IIRC, the nfsd export table can also use the filesystem uuid to
> identify the filesystem being exported, and IIRC that gets encoded
> in the filehandle. Does changing the filesystem UUID then cause
> problems with export indentification and/or file handle
> creation/resolution?
>=20
> * Is the VFS prepared for sb->s_uuid changing underneath running
> operations on mounted filesystems? I can see that this might cause
> problems with any sort of fscrypt implementation as it may encode
> the s_uuid into encryption keys held in xattrs, similarly IMA and
> EVM integrity protection keys.
>=20
> * Should the VFS superblock sb->s_uuid use the XFS
> sb->sb_meta_uuid value and never change because we can encode it
> into other objects stored in the active filesystem? What does that
> mean for tools that identify block devices or filesystems by the VFS
> uuid rather than the filesystem uuid?
>=20
> There's a whole can-o-worms here - the ability to dynamically change
> the UUID of a filesystem while it is mounted mean we need to think
> about these things - it's no longer as simple as "can only do it
> offline" which is typically only used to relabel a writeable
> snapshot of a golden image file during new VM deployment
> preparation.....
>=20
>>=20
>> Catherine
>>=20
>> Catherine Hoang (4):
>>  xfs: refactor xfs_uuid_mount and xfs_uuid_unmount
>>  xfs: implement custom freeze/thaw functions
>=20
> The "custom" parts that XFS requires need to be added to the VFS
> level freeze/thaw functions, not duplicate the VFS functionality
> within XFS and then slight modify it for this additional feature.
> Doing this results in unmaintainable code over the long term.
>=20
>>  xfs: add XFS_IOC_SETFSUUID ioctl
>>  xfs: export meta uuid via xfs_fsop_geom
>=20
> For what purpose does userspace ever need to know the sb_meta_uuid?

Userspace would need to know the meta uuid if we want to restore
the original uuid after it has been changed.
>=20
> Cheers,
>=20
> Dave.
> --=20
> Dave Chinner
> david@fromorbit.com

