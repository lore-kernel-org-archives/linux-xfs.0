Return-Path: <SRS0=LwPM=5E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E26C0C4332B
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Mar 2020 01:07:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92D7820767
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Mar 2020 01:07:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=intel.onmicrosoft.com header.i=@intel.onmicrosoft.com header.b="iYZKQ1H8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbgCSBHr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Mar 2020 21:07:47 -0400
Received: from mga14.intel.com ([192.55.52.115]:32051 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726596AbgCSBHq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 18 Mar 2020 21:07:46 -0400
IronPort-SDR: B5ahK8/1XFPa7G/zToifPpRVrJmCwLE/9GsknOX8f4E7m68c7TalCirNaMtBTjnhIIMnGvkBF6
 IKSVnOka5MGA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2020 18:07:46 -0700
IronPort-SDR: 3zaj8piwApwZHb/ja3gaNzvikellLEjP3OqqtRaDPU4IClH+Iyo/jRngQVl67dDOU3gJuBbhwz
 mZiWi/UaJC1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,569,1574150400"; 
   d="scan'208";a="248369023"
Received: from orsmsx103.amr.corp.intel.com ([10.22.225.130])
  by orsmga006.jf.intel.com with ESMTP; 18 Mar 2020 18:07:45 -0700
Received: from orsmsx152.amr.corp.intel.com (10.22.226.39) by
 ORSMSX103.amr.corp.intel.com (10.22.225.130) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 18 Mar 2020 18:07:45 -0700
Received: from ORSEDG002.ED.cps.intel.com (10.7.248.5) by
 ORSMSX152.amr.corp.intel.com (10.22.226.39) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 18 Mar 2020 18:07:45 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (134.134.137.101) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 18 Mar 2020 18:07:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RshpPmCYhfPse6QtGEmuRNqHyLO5+4oo8DuYmKoK0huqAe9bQIbYCAGZ3k2AeUWtZOaU/Sj0LjeF0WRwbVPrW6/i05Pbcby/91mWDZ1eB2PPjXYeAXfXvtm3LakXdYhoSI2wrNlr1JzX/ljl54F4ONXsOF5/eKhzpMSR48U8efyIyOGlizeAzeZlWDlIYuSaIckTGTEmSkmGWvWAC+XlVccvDWjNRknh/o1nME2uv1a0Xlsgbor63vGxVHf5qghQjqie7Ba11oEXoZbTkZH8BECt+ACvlxlVSVBSsa31edMfjs1fppsInTFf6wzmm513wJqgF+oggtwug4s2Vp6g7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rtzaro/I92MbeJBBM6dnWVqpJRyQYkS58cmAoW4pzmc=;
 b=Dr2qkbKonMYe8ewYELdnH/lbSOQ6WQ2NwhzDgqt1nwSLCZDlfU45iUBanvkLSTD7Ye3GLTheNmQAiKSq80x9wZOZ/81ZVOIRZRGmkNeNXuh579wBUo9OVL5tpRnJ0yMcd1BF1OIMMj0bo4nzB0d1cvfuRvg4+UprmJkfelLXTAuHoMH2p+d9YxBiJDShUJcoWk8lgdS7ZehAwzNXXGV4oJkOJB80NSjBAEUSZR72i4+RmHdtLlLRitlRAJj6ZZEBDRW7Xo3xhVMzaQFQCGz2WRxYF5lIgtpc1gksCMuUF7e57F/uh9oRo4h/dIVVAIOJ85AE1i1GPqihBgZ5L1cwRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rtzaro/I92MbeJBBM6dnWVqpJRyQYkS58cmAoW4pzmc=;
 b=iYZKQ1H8ptAlehb3xIIm+TY+0j7w7H5tSeaqPkW6KGvju0x3SI4PtXYosGE6jMerPJzOeVE28oD9C7v+ZKflkNZw2NzV2NQHWeEu49HnI+sSmj3iG64Xj8lJLRS6XN9F/ju5jrANWxL1cjYABfpzouOFJNNAebilbwQQES8aBFw=
Received: from MW3PR11MB4697.namprd11.prod.outlook.com (2603:10b6:303:2c::15)
 by MW3PR11MB4571.namprd11.prod.outlook.com (2603:10b6:303:59::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.19; Thu, 19 Mar
 2020 01:07:43 +0000
Received: from MW3PR11MB4697.namprd11.prod.outlook.com
 ([fe80::15fe:e674:d028:813a]) by MW3PR11MB4697.namprd11.prod.outlook.com
 ([fe80::15fe:e674:d028:813a%4]) with mapi id 15.20.2835.017; Thu, 19 Mar 2020
 01:07:43 +0000
From:   "Ober, Frank" <frank.ober@intel.com>
To:     Dave Chinner <david@fromorbit.com>
CC:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dimitri <dimitri.kravtchuk@oracle.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "Barczak, Mariusz" <mariusz.barczak@intel.com>,
        "Barajas, Felipe" <felipe.barajas@intel.com>
Subject: RE: write atomicity with xfs ... current status?
Thread-Topic: write atomicity with xfs ... current status?
Thread-Index: AdX71Vq//eR+Sn2pQqqqxpz9L7kkRAACMYeAAANDggAAMGvUIAAH+EWAAC5Pg0A=
Date:   Thu, 19 Mar 2020 01:07:43 +0000
Message-ID: <MW3PR11MB469795EF1A6AEE92B8CB16268BF40@MW3PR11MB4697.namprd11.prod.outlook.com>
References: <MW3PR11MB46974637E20D2ED949A7A47E8BF90@MW3PR11MB4697.namprd11.prod.outlook.com>
 <20200316215913.GV256767@magnolia>
 <20200316233240.GR10776@dread.disaster.area>
 <MW3PR11MB4697D889E18319F7231F49BD8BF60@MW3PR11MB4697.namprd11.prod.outlook.com>
 <20200318022719.GV10776@dread.disaster.area>
In-Reply-To: <20200318022719.GV10776@dread.disaster.area>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=frank.ober@intel.com; 
x-originating-ip: [192.55.52.205]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 38f3ab76-1589-4b1a-b775-08d7cba1ee00
x-ms-traffictypediagnostic: MW3PR11MB4571:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB45717ABF30F3B75F97D5D9F88BF40@MW3PR11MB4571.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0347410860
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(39860400002)(376002)(366004)(346002)(136003)(199004)(6916009)(6506007)(2906002)(5660300002)(7696005)(26005)(4326008)(53546011)(54906003)(81156014)(186003)(107886003)(81166006)(9686003)(66946007)(478600001)(55016002)(8936002)(33656002)(76116006)(8676002)(64756008)(66476007)(66446008)(66556008)(71200400001)(86362001)(316002)(966005)(52536014)(163963001)(15398625002);DIR:OUT;SFP:1102;SCL:1;SRVR:MW3PR11MB4571;H:MW3PR11MB4697.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iDVTizuyvm0OdTropKLecnk48iklCIFcodqZdkXZdQOFesw5Eoo73LPbxbMOyoklZ1hv3lvqNygfGgce6Cg0uy/rpZMMnR2gxhrP1Zp+yapYDlbVson2QP7IcMwisRxTqVHZUXbI0tBzmXmpTuHGR4bQjDo6d1Z3EEGrRP8lxXIbo12mGmOmzmUSkyxRXWKhbOhnim2y2yP7gZSqMklk9QUjLba4m8lAD6QRADp/Sntvp9pDCuMtQ+smHvLxtP4/2KsEMxCmkIe4DxDhSXM3uMwzeeIjNh1+koRQzjdXNjJwxhpxiSxTA0OFN+aRZ8C7VIkD8zDUV/+uI/wTWB2YkUblL5ChXDT+1yet8dSLv5WpJyYJrv324qBt/E8lscV9QUNkEkZru+hAm1Ptpyz4WwmTgraJMZtHQybDvVqnSySD5NfJi+EsCp7wijiYPNeaso9gT+IbtYnJIFy4vJvZd8HkeeFbQi8a1zy3HZshY3cC1j7JN/ZV3UXt5pZFNaJeJ10iShs4HjaFqOAdWnbZasv29hKJLkAWGMqMDaCD/VWMBgMPYrezbKyINArU3hysU7q5/F42Pg0EbLf0+KzAILicsdM6YBoLgwhP+Mz1BU4=
x-ms-exchange-antispam-messagedata: 7OYsDCi6fVJ4X3KyCoSnq4SaTVPtl+QPGg6AIFmI+DPKW8D6OILUEUynxSOiT+xWXIu4qbRt/zHnp4JMaMW/6y1AneJ4IsvQsPz6YCNJPB8S3x8xqKiT1f3jw96Tbfo+42x2Uk9babbtO80Ni4NSeQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 38f3ab76-1589-4b1a-b775-08d7cba1ee00
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Mar 2020 01:07:43.7699
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +PLMm9UVSW5WHTqBzz/92YkxSB2xxkCtGDBByBi+z73wHvZNJeMbCMQZHrwz4tHuaS5ZLD5fMz4b8A2Q3L8bjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4571
X-OriginatorOrg: intel.com
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Dave,=20
Is the nvme 1.4 specification really broken? It provides boundaries as note=
d.
https://nvmexpress.org/wp-content/uploads/NVM-Express-1_4-2019.06.10-Ratifi=
ed.pdf

Check section 6.4 page 249. There are several ways to do this and this rati=
fied specification is quite deep about atomic writes and describes what you=
 are saying. I know you told me in another note, there is a glaring hole in=
 the specifications, but is this hole still in the 1.4 specifications?

The layers above the drive could leverage identify namespace, which the dri=
ve's controller could advertise to anyone looking for awun and awunpf, but =
if this would be required to be an offset all we can provide is either 512B=
 or 4096B which are the two nvme block sizes that are atomic on our drives =
today.
If awun/awunpf were the offset to our standard blocksize (512b or 4096b) wo=
uld that work?

nvme id-ctrl /dev/nvme0n1 | grep aw
awun      : 0
awupf     : 0
Frank

-----Original Message-----
From: Dave Chinner <david@fromorbit.com>=20
Sent: Tuesday, March 17, 2020 7:27 PM
To: Ober, Frank <frank.ober@intel.com>
Cc: Darrick J. Wong <darrick.wong@oracle.com>; Dimitri <dimitri.kravtchuk@o=
racle.com>; linux-xfs@vger.kernel.org; Barczak, Mariusz <mariusz.barczak@in=
tel.com>; Barajas, Felipe <felipe.barajas@intel.com>
Subject: Re: write atomicity with xfs ... current status?

[ Hi Frank, you email program is really badly mangling quoting and line wra=
pping. Can you see if you can get it to behave better for us? I think I've =
fixed it below. ]

On Tue, Mar 17, 2020 at 10:56:53PM +0000, Ober, Frank wrote:
> Thanks Dave and Darrick, adding Dimitri Kravtchuk from Oracle to this=20
> thread.
>=20
> If Intel produced an SSD that was atomic at just the block size level=20
> (as in using awun - atomic write unit of the NVMe spec)

What is this "atomic block size" going to be, and how is it going to be adv=
ertised to the block layer and filesystems?

> would that constitute that we could do the following

> > We've plumbed RWF_DSYNC to use REQ_FUA IO for pure overwrites if the=20
> > hardware supports it. We can do exactly the same thing for=20
> > RWF_ATOMIC - it succeeds if:
> >=20
> > - we can issue it as a single bio
> > - the lower layers can take the entire atomic bio without
> >   splitting it.=20
> > - we treat O_ATOMIC as O_DSYNC so that any metadata changes
> >   required also get synced to disk before signalling IO
> >   completion. If no metadata updates are required, then it's an
> >   open question as to whether REQ_FUA is also required with
> >   REQ_ATOMIC...
> >=20
> > Anything else returns a "atomic write IO not possible" error.

So, as I said, your agreeing that an atomic write is essentially a variant =
of a data integrity write but has more strict size and alignment requiremen=
ts and a normal RWF_DSYNC write?

> One design goal on the hw side, is to not slow the SSD down, the=20
> footprint of firmware code is smaller in an Optane SSD and we don't=20
> want to slow that down.

I really don't care what the impact on the SSD firmware size or speed is - =
if the hardware can't guarantee atomic writes right down to the physical me=
dia with full data integrity guarantees, and/or doesn't advertise it's atom=
ic write limits to the OS and filesystem then it's simply not usable.

Please focus on correctness of behaviour first - speed is completely irrele=
vant if we don't have correctness guarantees from the hardware.

> What's the fastest approach for
> something like InnoDB writes? Can we take small steps that produce=20
> value for DirectIO and specific files which is common in databases=20
> architectures even 1 table per file ? Streamlining one block size that=20
> can be tied to specific file opens seems valuable.

Atomic writes have nothing to do with individual files. Either the device u=
nder the filesystem can do atomic writes or it can't. What files we do atom=
ic writes to is irrelevant; What we need to know at the filesystem level is=
 the alignment and size restrictions on atomic writes so we can allocate sp=
ace appropriately and/or reject user IO as out of bounds.

i.e. we already have size and alignment restrictions for direct IO (typical=
ly single logical sector size). For atomic direct IO we will have a differe=
nt set of size and alignment restrictions, and like the logical sector size=
, we need to get that from the hardware somehow, and then make use of it in=
 the filesystem appropriately.

Ideally the hardware would supply us with a minimum atomic IO size and alig=
nment and a maximum size. e.g. minimum might be the physical sector size (w=
e can always do atomic physical sector size/aligned IOs) but the maximum is=
 likely going to be some device internal limit. If we require a minimum and=
 maximum from the device and the device only supports one atomic IO size ca=
n simply set min =3D max.

Then it will be up to the filesystem to align extents to those limits, and =
prevent user IOs that don't match the device size/alignment restrictions pl=
aced on atomic writes...

But, first, you're going to need to get sane atomic write behaviour standar=
dised in the NVMe spec, yes? Otherwise nobody can use it because we aren't =
guaranteed the same behaviour from device to device...

Cheers,

Dave.
--
Dave Chinner
david@fromorbit.com
