Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33701C32773
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Aug 2022 16:36:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353054AbiHSQgk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Aug 2022 12:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353313AbiHSQfI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 Aug 2022 12:35:08 -0400
Received: from mx07-001d1705.pphosted.com (mx07-001d1705.pphosted.com [185.132.183.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1B89120ABC;
        Fri, 19 Aug 2022 09:07:15 -0700 (PDT)
Received: from pps.filterd (m0209326.ppops.net [127.0.0.1])
        by mx08-001d1705.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27JFMjaX022779;
        Fri, 19 Aug 2022 16:06:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sony.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=S1;
 bh=TLnPajpvmC/sQ+g2XszuZn69yia75g29gt5KWF+5R5Q=;
 b=CtxzGkLV4MyzLH6m1ZA7GAXbJ4pBAPeY1ueuChwVDJNb5QI7r56o5dsud40gafvM9FDh
 WVYl56oWOa4B0iGwJdym33FPzTTUxMCbDwE6ewW+kjROOqolOTAG5DjcdCp/+AlOPQyv
 YIph7joSwhXTr+0jfWvEnch6i4eSK5oWJbyYsiNqhyAlgNrMC0/HNGtpLjOrCp7OP3jN
 Xre/6X8Iw78NQ/EU+vj0Z4t94LYME3aJ+vspH3fm6weL6BwAba6/rH+O8B8H0NPPQm91
 IBwsYh7n0voFKqs1xgUzXHsH8V2PRLKCu/Kk0Q7hXy8SxpT350ftIqm8f4kQ6D2olvLp Vg== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by mx08-001d1705.pphosted.com (PPS) with ESMTPS id 3j0nkvu4nu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Aug 2022 16:06:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fdh8nwoItEZaQIx/qr0mrYB/BUa4zvhE38eFO+BfPkn3Aff7ZdGbEo8QGv60qwZNL9Iv4GJqXWD7jKuA69y2Bnc/WmZfbahcxSD9nxpjs0MDn8leKzHs/OEP2H/O1gsBVPLCCdTN1Cu7ExTamhoOcIVNOlQZx/geLvA9+2LAn5fZX8jNUgGPQKD+/pp8bVYW3p3+QZZrn62xgvROAY3lx62Fiy9OYPvXt/IlqW3DiuKQTpXt268YXAbxse/sPbQptyGOrzDi/yQxR4+CXJBVRLMC5a7OTLqMeOS7Z2FfzkhEnN8QSdrLhEQd6v/2yUZYLW6dnHJ/Tya7pob3ne5QTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TLnPajpvmC/sQ+g2XszuZn69yia75g29gt5KWF+5R5Q=;
 b=d8CH6lw/nsCi5jkq/Aq8KCu9AqpY12zgFiYX+hVDTOd+0zn2o0uwkXJacjkgWAAXsHtY9b5qRpE2Zr3Wa6dCKD/Lu++q5mjTl1EaBZp/QKXJ18DLD2pMacYY9Dlnm5wIcQHsWbP616l1gl3BD10tU5JlB6qx/ShHdkTFL17UBwbxmHDUFcGOiWo+5mTIa0r2akCVfZVIj5AveNn0ZfltlpJZYwp/BPKyeVCnrJ98ftmY3+u54j3bZywQ50FA7BkAW3/lzvMSs5r02oP6rTmoj8Hf3/sJgbes7Fv31sQB835qVlgtjCQauFxc04z7hmlB5gtVzT/9CEJsQC+qtmT1/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sony.com; dmarc=pass action=none header.from=sony.com;
 dkim=pass header.d=sony.com; arc=none
Received: from BYAPR13MB2503.namprd13.prod.outlook.com (2603:10b6:a02:cd::33)
 by PH0PR13MB6017.namprd13.prod.outlook.com (2603:10b6:510:f9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.4; Fri, 19 Aug
 2022 16:06:37 +0000
Received: from BYAPR13MB2503.namprd13.prod.outlook.com
 ([fe80::999:56bf:f8d3:7f30]) by BYAPR13MB2503.namprd13.prod.outlook.com
 ([fe80::999:56bf:f8d3:7f30%7]) with mapi id 15.20.5546.015; Fri, 19 Aug 2022
 16:06:37 +0000
From:   "Bird, Tim" <Tim.Bird@sony.com>
To:     Petr Vorel <pvorel@suse.cz>, Eric Sandeen <sandeen@redhat.com>
CC:     Jens Axboe <axboe@kernel.dk>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>, Jan Kara <jack@suse.cz>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>,
        "ltp@lists.linux.it" <ltp@lists.linux.it>
Subject: RE: [LTP] LTP test df01.sh detected different size of loop device in
 v5.19
Thread-Topic: [LTP] LTP test df01.sh detected different size of loop device in
 v5.19
Thread-Index: AQHYsC9/ztNsKeKY9kaZ3LkKAzywXK2vs0KAgACyRoCABGecgIAACy2AgAAGGoCAAAlqgIAASEIAgAE5DYCAAAEDAA==
Date:   Fri, 19 Aug 2022 16:06:36 +0000
Message-ID: <BYAPR13MB25036BC8089554DABE287CC2FD6C9@BYAPR13MB2503.namprd13.prod.outlook.com>
References: <YvZUfq+3HYwXEncw@pevik> <YvZTpQFinpkB06p9@pevik>
 <20220814224440.GR3600936@dread.disaster.area> <YvoSeTmLoQVxq7p9@pevik>
 <8d33a7a0-7a7c-47a1-ed84-83fd25089897@sandeen.net> <Yv5Z7eu5RGnutMly@pevik>
 <f03c6929-9a14-dd58-3726-dd2c231d0981@sandeen.net>
 <Yv5oaxsX6z2qxxF3@magnolia> <Yv5wUcLpIR0hwbmI@pevik>
 <974cc110-d47e-5fae-af5f-e2e610720e2d@redhat.com> <Yv+ziab2IiVIsqN6@pevik>
In-Reply-To: <Yv+ziab2IiVIsqN6@pevik>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c0ef4f27-898e-439a-31ca-08da81fccb5a
x-ms-traffictypediagnostic: PH0PR13MB6017:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Vl3Ie+36nDPGNjTmU9AJvBh/Rl/2xriiziPu/H068jEv7sBNv/VMAepUe7grzh5v5JCsYy/vzV+WDLkKMFyqgyInaE+zb3dqKcWktwukxoln1dskwlXHiINLGu0Vt4UsmNgGiPGztlZG1CjfdA9q81/q4rBrA8v4xxs9NZ9hLlKEB6COKU3XO3m+RK0EmjENDgaKVSUQlcg2AKJ80I9q4/CgoekZQvqp4IUQ+g5M4J96aluEKwibEMpul6XrTBW7FWpXvrfS9jxqwp2CHm3woLHddSAD8bvhE/KaMIJFRwjin5QX1Pb8ZoSZLD1TMEFdjtg7YyOqKQGrBakOcGUERXPg1qn1sT3yupHm9jXFMHcQBCXQ1ZzWjZxEU1a9SjGXvMZ4bgEUfGWY117EfNN2HWzZz5MTVStiKBg52GLH6wCUGEkEz08Dxry7HX1GH2XxAM6Fwyypd87Z1CxK2E86AI8v2PP2xTY1OxaFGPHcJkBKkLSB8qi7BxMzjM4RwP0pqfP0EBZ5SHKS+P0PzXL2zi997DS0h0izdvcV4BykDA8b2HQdgApq6NC20gLwtlPmwTSRdyPoolZRRt1rxd703DO4ohcWBI7B29TIAVXYjplW+P7rg+Id1Sqwa2hbNclLOGifrgHPJoXbucT9ttyklq7vOMa5Rvdc7P2ybbu7WWUUO1YDOsAoTHyMyxTRX0riWwi1p405P25nPhOOvQnkK6khbo6V1f2t1iMtojmutdhFPGstY/ILZ2Gu6uo9jqPGAbZ3y69vaTGf7uEyyqAytNZqDNELd+t9j90UJTVrses=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR13MB2503.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(366004)(376002)(346002)(39860400002)(136003)(478600001)(5660300002)(55016003)(7416002)(71200400001)(52536014)(966005)(66476007)(110136005)(316002)(54906003)(41300700001)(66556008)(2906002)(64756008)(4326008)(76116006)(66446008)(66946007)(8936002)(8676002)(53546011)(38100700002)(38070700005)(86362001)(186003)(82960400001)(33656002)(9686003)(26005)(7696005)(6506007)(83380400001)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NSn+S/AKPql4HaG4o5MLG5iULB2oC0bhYFaY6phkA1Yq+g8x2bXX8mRgZSKx?=
 =?us-ascii?Q?ZnPzL7G/Yr9ONbeFJ1lp6LWlaHRMLpE6YbyqdgdjVZdlvxC9DaTGiSuPsLDa?=
 =?us-ascii?Q?cFDizFvQ3IWxhSEHc/px3LNOC+kPYP9CJuGPw5tKg+LXaFTkKk56tzKfIOfA?=
 =?us-ascii?Q?OP6VAKLE8Ww1o9K9kIIqaWNIeWPxzZmIe9ZF+52yI3V1hIC5ZnTJMJVP9rmM?=
 =?us-ascii?Q?VnKreAQFd5UhjauMuy4XQhATNcqdKHf41Qfz8zKa36wgxk0FM3txLMKB6pzh?=
 =?us-ascii?Q?MQm/FWMxY73ffK+JQhqWZZPPyGmVRFJe4/Ao93PkqQ/fARaZkAIczH6+GLUE?=
 =?us-ascii?Q?Jz0674t7H1vUfRxAmluRF7bRdJPSHEUNuavwpVTJub4zm9KnIsfQWok3YxSt?=
 =?us-ascii?Q?MAKencCspeCF35z5Zz83H3E1IX/GkSsCs0moicxjRHCizK32SLbQnd2NleAL?=
 =?us-ascii?Q?ai2RH04speLIB+RP/z6brwuedbZ6IT3yL6yxO1QJRB0VfZnQchyhZQhEQng9?=
 =?us-ascii?Q?ZHSljNboKLnF/R2M2qFmYlcP5ap4WHX1rGXWD0cqpNlJKiEPXp0JH9cr2cNe?=
 =?us-ascii?Q?SdKQwN+UK15FRtqZ7oxv0OBZpdNpfJhfqcaUYrxYjDSPiMZxhDvZTGJjnUbU?=
 =?us-ascii?Q?tbUipSTRFogYmuL0z1+tYhufTzPweIAXe9g77QX1AXreqZf5Kf5Lxl6tIXws?=
 =?us-ascii?Q?+juXPxVXtzcvpNzqkEO5wfstXKTpalG2c5ECOKw/8Sp+pGJrnml4J8sOu79D?=
 =?us-ascii?Q?wLD2l8tH+2GXqwKeDNLfcLPJmTG17MJg/+kvNI7qRabFpux+LpQR3iAcS04F?=
 =?us-ascii?Q?5eMH9LjHD72lBN6qLupq1TqtrFcjPW2ToD5SCxVw+r4g48D2K3WikIgUEf6S?=
 =?us-ascii?Q?Rjs/RxN1TJd1ZTH3eWlLcrgcsZCPutalVft+aIkkNtrybZ9kdyeHWFLU92f9?=
 =?us-ascii?Q?VoQkDuxaI1AlbUkCaHuV8/zkI5PBL9yDIDGo9F3bfiRCssSEL8B0b8IEmlrs?=
 =?us-ascii?Q?VaMvCXwrUh0JS1C0YVT3IwfGDc/rxIXXH9ypM+Z/crEOodnQHXEEFXbo1SQN?=
 =?us-ascii?Q?AOp8M2Fxb2aFnjXtuSQO3TNIwFrlvxSEjPOz52hmkHohQNAmrXyb8N1BrZu/?=
 =?us-ascii?Q?5ekNcO8HhqnxJdlsXbwv1wEZFK/0OuQzhSihkb9W+TJzJlBXI+7MU/uZdKAM?=
 =?us-ascii?Q?fmKjACW2tnkONE/I5ck/DCdXqEiS5T8jriWWp2MyKZtPo5TNnUHk9+8pY4ab?=
 =?us-ascii?Q?/vCPIm9cPi372wkHZEQ5wVoOb9q5qD4jHP1r5S2CPvZeZOoozxDis3cZQ/5+?=
 =?us-ascii?Q?aqsmnVqVvntfu0OdCmN5+Pou+8RN6TDmL92Y4h/jSpQveUuuoAiiiM1sh8G9?=
 =?us-ascii?Q?Wpm6aUILhPIqekaCbywkX9s91HCqL6aswBmbSd9f86vhskGOTf5mC428IbNW?=
 =?us-ascii?Q?754f2iUdY6CIWMeO8uDOm7QwLU1rPHETcKo4oleAPmMdKOwMi97rBfNZv0zR?=
 =?us-ascii?Q?y3Dee2mbaOcCtJ4B8G5Hk3tLG7MBjrhBncsAGQMty1sRoPztzJSWi8yLmSLa?=
 =?us-ascii?Q?f4KKdZT/XBAXQrKkM5yGKtYNoE+iMzCEWVgOoRG1?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sony.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR13MB2503.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0ef4f27-898e-439a-31ca-08da81fccb5a
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2022 16:06:36.9305
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 66c65d8a-9158-4521-a2d8-664963db48e4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4iXpYweQDr0NIpr9WPSjWrE3FYVTHhrpDMiMUQ+ES+tPfu+NbZF40bEensWxZKSqbjcj/4GkzcfTZAKhGKsS3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB6017
X-Proofpoint-GUID: nDxShuEPeSw6ZwYfb-y4H9tyC3AgIuTZ
X-Proofpoint-ORIG-GUID: nDxShuEPeSw6ZwYfb-y4H9tyC3AgIuTZ
X-Sony-Outbound-GUID: nDxShuEPeSw6ZwYfb-y4H9tyC3AgIuTZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-19_08,2022-08-18_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



> -----Original Message-----
> From: ltp <ltp-bounces+tim.bird=3Dsony.com@lists.linux.it> On Behalf Of P=
etr Vorel
>=20
> > On 8/18/22 12:01 PM, Petr Vorel wrote:
> > >> On Thu, Aug 18, 2022 at 11:05:33AM -0500, Eric Sandeen wrote:
> > >>> On 8/18/22 10:25 AM, Petr Vorel wrote:
> > >>>> Hi Eric, all,
>=20
>=20
> > >>> ...
>=20
>=20
> > >>>>> IOWS, I think the test expects that free space is reflected in st=
atfs numbers
> > >>>>> immediately after a file is removed, and that's no longer the cas=
e here. They
> > >>>>> change in between the df check and the statfs check.
>=20
> > >>>>> (The test isn't just checking that the values are correct, it is =
checking that
> > >>>>> the values are /immediately/ correct.)
>=20
> > >>>>> Putting a "sleep 1" after the "rm -f" in the test seems to fix it=
; IIRC
> > >>>>> the max time to wait for inodegc is 1s. This does slow the test d=
own a bit.
>=20
> > >>>> Sure, it looks like we can sleep just 50ms on my hw (although bett=
er might be to
> > >>>> poll for the result [1]), I just wanted to make sure there is no b=
ug/regression
> > >>>> before hiding it with sleep.
>=20
> > >>>> Thanks for your input!
>=20
> > >>>> Kind regards,
> > >>>> Petr
>=20
> > >>>> [1] https://people.kernel.org/metan/why-sleep-is-almost-never-acce=
ptable-in-tests
>=20
> > >>>>> -Eric
>=20
> > >>>> +++ testcases/commands/df/df01.sh
> > >>>> @@ -63,6 +63,10 @@ df_test()
> > >>>>  		tst_res TFAIL "'$cmd' failed."
> > >>>>  	fi
>=20
> > >>>> +	if [ "$DF_FS_TYPE" =3D xfs ]; then
> > >>>> +		tst_sleep 50ms
> > >>>> +	fi
> > >>>> +
>=20
> > >>> Probably worth at least a comment as to why ...
>=20
> > > Sure, that was just to document possible fix. BTW even 200ms was not =
reliable in
> > > the long run =3D> not a good solution.
>=20
> > >>> Dave / Darrick / Brian - I'm not sure how long it might take to fin=
ish inodegc?
> > >>> A too-short sleep will let the flakiness remain ...
>=20
> > >> A fsfreeze -f / fsfreeze -u cycle will force all the background garb=
age
> > >> collection to run to completion when precise free space accounting i=
s
> > >> being tested.
> > > Thanks for a hint, do you mean to put it into df_test after creating =
file with
> > > dd to wrap second df_verify (calls df) and df_check (runs stat and co=
mpare values)?
> > > Because that does not help - it fails when running in the loop (manag=
ed to break after 5th run).
>=20
> > I think it would go after you remove the file, to ensure that no space =
usage
> > changes are pending when you check.
>=20
> > <tests>
>=20
> > This seems to work fine (pseudopatch):
>=20
> >         ROD_SILENT rm -rf mntpoint/testimg
>=20
> > +       # Ensure free space change can be seen by statfs
> > +       fsfreeze -f $TST_MNTPOINT
> > +       fsfreeze -u $TST_MNTPOINT
> It looks like it works. We might add small binary which just calls these =
2
> ioctl (FIFREEZE and FITHAW), just to be friendly to people on embedded
> environment with minimal dependencies (yes, some people might not install
> util-linux).

Thank you!!  It's good to know that small embedded systems are still
considered, and the consideration is much appreciated!  :-)

Let me know if you'd like me to try writing the utility.
 -- Tim

