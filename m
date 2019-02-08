Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk1-f178.google.com ([209.85.222.178]:34746 "EHLO
        mail-qk1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726522AbfBHQ5p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Feb 2019 11:57:45 -0500
Received: by mail-qk1-f178.google.com with SMTP id a15so2522212qkc.1
        for <linux-xfs@vger.kernel.org>; Fri, 08 Feb 2019 08:57:44 -0800 (PST)
From: "Ricardo J. Barberis" <ricardo.barberis@gmail.com>
Subject: Re: Metadata CRC error detected at xfs_dquot_buf_read_verify
Date: Fri, 8 Feb 2019 13:57:39 -0300
References: <201902071309.38999.ricardo.barberis@gmail.com> <201902081249.24904.ricardo.barberis@gmail.com> <20190208162617.GM7991@magnolia>
In-Reply-To: <20190208162617.GM7991@magnolia>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Message-Id: <201902081357.39265.ricardo.barberis@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, Linux-XFS list <linux-xfs@vger.kernel.org>

El Viernes 08/02/2019 a las 13:26, Darrick J. Wong escribi=C3=B3:
> On Fri, Feb 08, 2019 at 12:49:24PM -0300, Ricardo J. Barberis wrote:
> > El Viernes 08/02/2019 a las 10:17, Brian Foster escribi=C3=B3:
> > > On Thu, Feb 07, 2019 at 01:09:38PM -0300, Ricardo J. Barberis wrote:
[ ... ]
> > > Does xfs_repair find and fix anything? Please show the associated rep=
air
> > > output.
> >=20
> > Unfotunately I didn't save xfs_repair output, but I don't believe it fi=
xed
> > anything other than the log that first time.
>=20
> Eric Sandeen amended xfs_repair in xfsprogs 4.17 to detect and zap
> corrupt quota blocks.  I don't know what version of xfsprogs centos 7.6
> ships with, but you might try running something newer?
>=20
> (Run it with -n first to make sure repair identifies the corrupt dquot
> blocks, as is customary...)
=20
I can try to compile 4.17 (CentOS 7.6 has 4.5.0) and see if it helps

Thank you,
=2D-=20
Ricardo J. Barberis
Usuario Linux N=C2=BA 250625: http://counter.li.org/
Usuario LFS N=C2=BA 5121: http://www.linuxfromscratch.org/
Senior SysAdmin / IT Architect - www.DonWeb.com
