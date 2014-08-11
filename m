Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D7F1C7F3F
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2014 09:44:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3D960AC004
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2014 07:44:07 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ZogptlbFC3ArOz5T (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 11 Aug 2014 07:44:05 -0700 (PDT)
Date: Mon, 11 Aug 2014 10:44:00 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Subject : Happened again, 20140811 -- Got "Internal error
	XFS_WANT_CORRUPTED_GOTO". Filesystem needs reformatting to correct
	issue.
Message-ID: <20140811144359.GA10217@laptop.bfoster>
References: <alpine.LSU.2.11.1407021104480.9881@Telcontar.valinor>
	<alpine.LSU.2.11.1408111559280.2447@minas-tirith.valinor>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1408111559280.2447@minas-tirith.valinor>
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
To: "Carlos E. R." <carlos.e.r@opensuse.org>
Cc: XFS mailing list <xfs@oss.sgi.com>

On Mon, Aug 11, 2014 at 04:23:01PM +0200, Carlos E. R. wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA256
> =

> =

> =

> El 2014-07-02 a las 11:57 +0200, Carlos E. R. escribi=F3:
> =

> >I got this error:
> =

> Happened again, I'm on middle of recovery procedures, and using my laptop=
 to
> post.
> =

> =

> The system did not "die", I could still use xterms owned by root. So I tr=
ied
> to use xfs_metadump before rebooting, but it refused, said that the
> partition was mounted (and I know from previous times that umounting fails
> or locks the machine). It also said that it could not intialize the XFS
> library.
> =

> So I logged out, and issued "reboot" on tty1 as root. No go, it got stuck
> somewhere, and I had to hit the physical reset button on the machine. I h=
ave
> not looked at the logs yet.
> =

> I am now running the machine off a live usb stick (13.1 XFCE rescue syste=
m)
> to avoid the automatics to fsck the home partition, and I already obtaine=
d a
> xfs_metadump of it.
> =

> I post this in case you have some suggestion before I nuke the partition
> (rsync, reformat, etc). It shold take some hours.
> =


Assuming you already have a pre-repair metadump, I'd suggest to
xfs_repair, capture and post the repair output to the list and leave it
at that (for now at least). I think you mentioned previously that the
problem hits more frequently at this point, so I wonder if you could try
to reproduce and get a better idea of what might contribute to the
failure.

For example, can you actively reproduce at this point? Perhaps get some
work going on all of the applications you typically have running and run
some hibernation cycles..? While a reformat might spare you from the
issue for a bit, it's going to make it that much harder to get more
information on what's going on.

Brian

> - -- Cheers
>        Carlos E. R.
> =

>        (from 13.1 x86_64 "Bottle" (Minas Tirith))
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v2.0.22 (GNU/Linux)
> =

> iF4EAREIAAYFAlPo0c4ACgkQja8UbcUWM1wIewD/eEwnzZpDjJLuytDOD9bqiypF
> ly6QCDckRvc2rVuCbwcA/0IX5tXGhAHr6izQvWol3F4RoxLk0uf74Ayn8lvSlDU0
> =3DWAIZ
> -----END PGP SIGNATURE-----

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
