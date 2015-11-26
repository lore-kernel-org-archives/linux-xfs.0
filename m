Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F1E477F37
	for <xfs@oss.sgi.com>; Thu, 26 Nov 2015 07:50:56 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D3EF4304051
	for <xfs@oss.sgi.com>; Thu, 26 Nov 2015 05:50:56 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id b6FpzTuJnoLEnq5S (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 26 Nov 2015 05:50:55 -0800 (PST)
Date: Thu, 26 Nov 2015 08:50:53 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Which xfsprogs version to which kernel version
Message-ID: <20151126135053.GB39911@bfoster.bfoster>
References: <5656DD39.8060403@poczta.onet.pl>
	<20151126132638.53ed9fc7@harpe.intellique.com>
	<565706BB.3030006@poczta.onet.pl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <565706BB.3030006@poczta.onet.pl>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "aluno3@poczta.onet.pl" <aluno3@poczta.onet.pl>
Cc: xfs@oss.sgi.com

On Thu, Nov 26, 2015 at 02:18:51PM +0100, aluno3@poczta.onet.pl wrote:
> Yes I used -f option with 4.X version of xfsprogs but mounting the
> volume was not possible - before mkfs.xfs finished successfully
> (mkfs.xfs -f -m crc=3D0,finobt=3D0).
> =


You posted the output associated with the crc=3D1 fs mount failure, what
happens when you try to mount after formatting with crc=3D0?

Brian

> Should I stay in 3.1.X family of xfsprogs or is it recommended to use at
> least 3.2.x version with kernel 3.10?
> =

> The most I care about xfs_repair.
> =

> On 11/26/15 13:26, Emmanuel Florac wrote:
> > Le Thu, 26 Nov 2015 11:21:45 +0100
> > "aluno3@poczta.onet.pl" <aluno3@poczta.onet.pl> =E9crivait:
> > =

> >> mkfs.xfs -m crc=3D0,finobt=3D0
> >>
> >> but it does not work with 4.X version of xfsprogs. Call trace also
> >> occurred so I tried to use 3.2.4 family with crc=3D0,finobt=3D0 and vo=
lume
> >> mounted successfully.
> >>
> > =

> > Did you use -f? else mkfs.xfs won't do anything as it'll detect an
> > existing filesystem.
> > =

> =

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
