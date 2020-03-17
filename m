Return-Path: <SRS0=h+lF=5C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9C11C1975A
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Mar 2020 22:56:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F93220714
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Mar 2020 22:56:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=intel.onmicrosoft.com header.i=@intel.onmicrosoft.com header.b="Qy/WM+MN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbgCQW45 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Mar 2020 18:56:57 -0400
Received: from mga05.intel.com ([192.55.52.43]:49804 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726476AbgCQW45 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 17 Mar 2020 18:56:57 -0400
IronPort-SDR: Ju3R9PthMCk3JwQhvhA0LjZVK+a8hYHjs0iebZ/2+EyPeqslvxs5X5k98oD3Kbr9gGncoV9zf6
 oR6QX0TNRVlw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2020 15:56:56 -0700
IronPort-SDR: FBI3QhKtoH0I/iBXWXphYchj3coagbWtMxIgLEzL71GD2NZf8FBsP2ovStga7ixeSfOJeKcfiM
 +Jb8175oSyFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,565,1574150400"; 
   d="scan'208";a="323984278"
Received: from orsmsx107.amr.corp.intel.com ([10.22.240.5])
  by orsmga001.jf.intel.com with ESMTP; 17 Mar 2020 15:56:56 -0700
Received: from orsmsx114.amr.corp.intel.com (10.22.240.10) by
 ORSMSX107.amr.corp.intel.com (10.22.240.5) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 17 Mar 2020 15:56:56 -0700
Received: from ORSEDG001.ED.cps.intel.com (10.7.248.4) by
 ORSMSX114.amr.corp.intel.com (10.22.240.10) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 17 Mar 2020 15:56:55 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 17 Mar 2020 15:56:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kz5diGmDBRoEqVHYgt9Q4BrtLGAdpgn61g72HOAXV+Jjcr1WiGRzjjwDu+56DAigmUzaNB2yELjybNKdavgFTUvmQU8suw7SKPIelSjjKvEU5dHKdSDsZtg9sFy1vNmDbrYak+2cCcyU1FkLexhLkYRIgbEgy7UaNfyxnQZypXo8O3D4k/DOF3pKCYxGiFkZOLrlN5KJYNh9pw2v19zn26yio9YI2vttxNhvQVxVONjok5KPwQYV+UPS4dWcHbTQ/+G23sArA4m7QDaE3MMaBg3rzHJfaiXyBSYDdgpxB0N0Fk3unZg4ZBDLzv3cokupfRCueUSJEF+NKUW6qNq6vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5NI+/TzI32KweDNuv4HzlROqZdj4QAhYMlN/MUhZM3o=;
 b=lovTBwFhpDP6v0LQ8XqNMJKSqBWnlUWnlCfCuoptOtIdDpOFiYWqGDBvrdzmVlLHTLLHaB0Fq/3OBuPg9N3cMI55Qhr/iNCYNkcVxKgc7r5D4roS1A+u+OCckIJfk0HzhraA+5C16NyTEWKw/TRsRQ78Guz+6/xPc5mLlOHVxcAG8WRUOHp7vXt1leRccl4ta+xfvjC+UY9U8ZLKGpyVA2C3w+FThGEwZmVf1stNKGEy1dOE1wuUkR44Qw6ZH0otSqmPVHbCExqZX/+rgX3xcGbuITxmbJu2x5PApxkQr88jledY31khG7kxq8Z79IL+NWFz5oin+QJH2uExQGMNPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5NI+/TzI32KweDNuv4HzlROqZdj4QAhYMlN/MUhZM3o=;
 b=Qy/WM+MNggs8gFKtckm2o5enCjYhG7QHgu7Ws7u83HStLd75evroLF4q9BqJ+9usbJoOWjHhWjH9W8KZCSpfw25/fQ4L89JQy7FTcKBGLwC3zoinVqdhsEYY5CiNtDFEbGDdO5YsIlrsz8cq7DcT9M91/WVCOgLYxElBbSjCeNQ=
Received: from MW3PR11MB4697.namprd11.prod.outlook.com (2603:10b6:303:2c::15)
 by MW3PR11MB4521.namprd11.prod.outlook.com (2603:10b6:303:55::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.18; Tue, 17 Mar
 2020 22:56:54 +0000
Received: from MW3PR11MB4697.namprd11.prod.outlook.com
 ([fe80::d94:9a48:b973:5871]) by MW3PR11MB4697.namprd11.prod.outlook.com
 ([fe80::d94:9a48:b973:5871%6]) with mapi id 15.20.2814.021; Tue, 17 Mar 2020
 22:56:54 +0000
From:   "Ober, Frank" <frank.ober@intel.com>
To:     Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dimitri <dimitri.kravtchuk@oracle.com>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "Barczak, Mariusz" <mariusz.barczak@intel.com>,
        "Barajas, Felipe" <felipe.barajas@intel.com>
Subject: RE: write atomicity with xfs ... current status?
Thread-Topic: write atomicity with xfs ... current status?
Thread-Index: AdX71Vq//eR+Sn2pQqqqxpz9L7kkRAACMYeAAANDggAAMGvUIA==
Date:   Tue, 17 Mar 2020 22:56:53 +0000
Message-ID: <MW3PR11MB4697D889E18319F7231F49BD8BF60@MW3PR11MB4697.namprd11.prod.outlook.com>
References: <MW3PR11MB46974637E20D2ED949A7A47E8BF90@MW3PR11MB4697.namprd11.prod.outlook.com>
 <20200316215913.GV256767@magnolia>
 <20200316233240.GR10776@dread.disaster.area>
In-Reply-To: <20200316233240.GR10776@dread.disaster.area>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=frank.ober@intel.com; 
x-originating-ip: [99.108.38.32]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3ecd5361-d8f6-492a-e30d-08d7cac67cbc
x-ms-traffictypediagnostic: MW3PR11MB4521:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB452110930989D4063FBBFCF18BF60@MW3PR11MB4521.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0345CFD558
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(376002)(366004)(136003)(346002)(396003)(199004)(107886003)(5660300002)(52536014)(9686003)(55016002)(66946007)(64756008)(66556008)(66446008)(66476007)(186003)(86362001)(26005)(2906002)(71200400001)(76116006)(4326008)(8936002)(53546011)(81166006)(81156014)(8676002)(478600001)(966005)(6506007)(33656002)(7696005)(316002)(110136005)(54906003)(163963001);DIR:OUT;SFP:1102;SCL:1;SRVR:MW3PR11MB4521;H:MW3PR11MB4697.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GzMGjGx3JPa9gt4UpOe46tuB0YNTtvWf70/6o02P5A49ZMcBMOMYhDZ3c5ag1d1lpJVG95nLDELI6G8u5UNzZk2I1Jdy+xCf5TQr4iJDRE/hwBJzXNRBOPCvN4qHaQMFUwDI5cNaXA1MvMEXFWklCjyb/LnjIykm/CxGk1WQOD62tMl6EgcOGPIrfA/sg5ypz/TyxAApM7XueEhHhbLNQ/PmSbdcIrfM9VP3gJYWUhVl/6PfSmY8s3PHUe9AZLjeL+7Gk3DqGMteRrAebJy1phAGrvq8+gXgSyHFDLw0gIQhAJLgMros1GMqQF8b7hsMFcHpekO8Dh6LlmmdnyZ0Zn/3cZ4gzoOPTOv98xkbIstFk3FdA4S6uAifekieI8WJ9QanNpBo7c/C2xT11sNDeWjxLMmujjkgYER69LaXcnkguC19E8TEK1UAj7COFBxXoj+gXq9wlu58m/0OOtQt59SVli7hEB3U+kR2BhAb4aavoIqIm/66qydS6FLJGFDNcaW06nG0lJbXPn+886wp5gq8jhJi7FrtHYRyDstW785szUH9Z4hv87JFwhYTDCzp
x-ms-exchange-antispam-messagedata: WGk5kfoX008YiEAZ/MjMoLuG0LD2WxnV7u3WatU+yoX8V8X5/hGu8NyzN4ujeFVKfsqnAg/uJl9bBXNiVEK2c07KORgKNN2pSEmXIRKl8J9H8KbeLMV/0IvZcyPYKrtVFm7Q+xfnGHfNOLQJtS4TIg==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ecd5361-d8f6-492a-e30d-08d7cac67cbc
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2020 22:56:53.8744
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KoEqaQTIK2uRoG9+SWLYRMNpj4FkiCka6i2YGtdhFJUpSjXIH51Qho9NSpo8IDaDMERctH0vYbTzWf1Qp8kyaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4521
X-OriginatorOrg: intel.com
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Thanks Dave and Darrick, adding Dimitri Kravtchuk from Oracle to this threa=
d.

If Intel produced an SSD that was atomic at just the block size level (as i=
n using awun - atomic write unit of the NVMe spec) would that constitute th=
at we could do the following>

We've plumbed RWF_DSYNC to use REQ_FUA IO for pure overwrites if the hardwa=
re supports it. We can do exactly the same thing for RWF_ATOMIC - it succee=
ds if:

- we can issue it as a single bio
- the lower layers can take the entire atomic bio without splitting
  it.
- we treat O_ATOMIC as O_DSYNC so that any metadata changes required
  also get synced to disk before signalling IO completion. If no
  metadata updates are required, then it's an open question as to whether R=
EQ_FUA is also required with REQ_ATOMIC...

Anything else returns a "atomic write IO not possible" error.

One design goal on the hw side, is to not slow the SSD down, the footprint =
of firmware code is smaller in an Optane SSD and we don't want to slow that=
 down.  What's the fastest approach for something like InnoDB writes? Can w=
e take small steps that produce value for DirectIO and specific files which=
 is common in databases architectures even 1 table per file ? Streamlining =
one block size that can be tied to specific file opens seems valuable.

Is there some failure in this thinking?


-----Original Message-----
From: Dave Chinner <david@fromorbit.com>=20
Sent: Monday, March 16, 2020 4:33 PM
To: Darrick J. Wong <darrick.wong@oracle.com>
Cc: Ober, Frank <frank.ober@intel.com>; linux-xfs@vger.kernel.org
Subject: Re: write atomicity with xfs ... current status?

On Mon, Mar 16, 2020 at 02:59:13PM -0700, Darrick J. Wong wrote:
> On Mon, Mar 16, 2020 at 08:59:54PM +0000, Ober, Frank wrote:
> > Hi, Intel is looking into does it make sense to take an existing,=20
> > popular filesystem and patch it for write atomicity at the sector=20
> > count level. Meaning we would protect a configured number of sectors=20
> > using parameters that each layer in the kernel would synchronize on.
> > =A0We could use a parameter(s) for this that comes from the NVMe=20
> > specification such as awun or awunpf
>=20
> <gesundheit>
>=20
> Oh, that was an acronym...
>=20
> > that set across the (affected)
> > layers to a user space program such as innodb/MySQL which would=20
> > benefit as would other software. The MySQL target is a strong use=20
> > case, as its InnoDB has a double write buffer that could be removed=20
> > if write atomicity was protected at 16KiB for the file opens and=20
> > with fsync().
>=20
> We probably need a better elaboration of the exact usecases of atomic=20
> writes since I haven't been to LSF in a couple of years (and probably=20
> not this year either).  I can think of a couple of access modes off=20
> the top of my head:
>=20
> 1) atomic directio write where either you stay under the hardware=20
> atomic write limit and we use it, or...


> 2) software atomic writes where we use the xfs copy-on-write mechanism=20
> to stage the new blocks and later map them back into the inode, where=20
> "later" is either an explicit fsync or an O_SYNC write or something...

That's a possible fallback, but we can't guarantee that the write will be a=
tomic - partial write failure can still occur as page cache writeback can b=
e split into arbitrary IOs and transactions....

> 3) ...or a totally separate interface where userspace does something=20
> along the lines of:
>=20
> 	write_fd =3D stage_writes(fd);
>=20
> which creates an O_TMPFILE and reflinks all of fd's content to it
>=20
> 	write(write_fd...);
>=20
> 	err =3D commit_writes(write_fd, fd);
>=20
> which then uses extent remapping to push all the changed blocks back=20
> to the original file if it hasn't changed.  Bonus: other threads don't=20
> see the new data until commit_writes() finishes, and we can introduce=20
> new log items to make sure that once we start committing we can finish=20
> it even if the system goes down.

Which is essentially userspace library code that runs multiple syscalls to =
do the necessary work. commit_writes() is basically a ranged swap-extents c=
all. i.e.:

	write_fd =3D open(O_TMPFILE)
	clone_file_range(fd, writefd, /* overwrite range */)
	loop (overwrite range) {
		write(write_fd)
	}
	fsync(write_fd)
	swap_extents(fd, write_fd, /* overwrite range */)
	fsync(fd)

i.e. this is basically the same process as a partial file defrag operation.=
 Hence I don't think the kernel needs to be involved in the software emulat=
ion of atomic writes at all. IOWs, if the kernel returns an "cannot do an a=
tomic write" error to RWF_ATOMIC, userspace can simply do the slow atomic o=
verwrite as per above without needing any special kernel code at all...

> > My question is why hasn't xfs write atomicity advanced further, as=20
> > it seems in 3.x kernel time a few years ago this was tried but=20
> > nothing committed. as documented here:
> >
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
> > http://git.infradead.org/users/hch/vfs.git/shortlog/refs/heads/O_ATO
> > MIC
> >=20
> > Is xfs write atomicity still being pursued , and with what design=20
> > objective. There is a long thread here,=20
> > https://lwn.net/Articles/789600/ on write atomicity, but with no=20
> > progress, lots of ideas in there but not any progress, but I am=20
> > unclear.
> >=20
> > Is my design idea above simply too simplistic, to try and protect a=20
> > configured block size (sector count) through the filesystem and=20
> > block layers, and what really is not making it attainable?
>=20
> Lack of developer time, AFAICT.

There's multiple other things, I think:

1. no hardware that provides usable atomic write semantics.
2. no device or block layer support for atomic write IOs; we need
   IO level infrastructure before the filesystems can do anything
   useful
3. no support in page cache for tracking atomic write ranges, so
   atomic writes via buffered IO rather difficult without using
   temporary files and extent swapping tricks...
4. emulation in userspace is easy if you have clone_file_range()
   support, even if it is slow. We aren't hearing from app
   developers emulating atomic writes for kernel side acceleration
   because it won't work on ext4.

Once we get 1. and 2., then we can support atomic direct IO writes through =
XFS via RWF_ATOMIC with relative ease. 4) probably requires some mods to XF=
S's swap_extent function to properly support file ranges. The API supports =
ranges, the implementation ony supports "full file range"...

Cheers,

Dave.

--
Dave Chinner
david@fromorbit.com
