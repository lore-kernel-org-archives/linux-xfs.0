Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q11EV6l2254693 for <xfs@oss.sgi.com>; Wed, 1 Feb 2012 08:31:08 -0600
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id ye1kreNPeIDCAub8 for
	<xfs@oss.sgi.com>; Wed, 01 Feb 2012 06:31:04 -0800 (PST)
Date: Wed, 1 Feb 2012 15:31:00 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: File system remain unresponsive until the system is rebooted.
Message-ID: <20120201153100.41d1586d@harpe.intellique.com>
In-Reply-To: <20265.12473.715630.925704@tree.ty.sabi.co.UK>
References: <CANs4eSBWLc4HxAbPZ8kOVOdJ7RKiA+-ai3Q2J+FAyuzHtUqfdg@mail.gmail.com>
	<20120131013124.GE9090@dastard>
	<CANs4eSBgmvJCR7vfFa1W5h8tUYFQi=LRPWDPQ1exB29D1o_RjA@mail.gmail.com>
	<4F27AE92.9060003@hardwarefreak.com>
	<20120131120859.1f1d6a17@harpe.intellique.com>
	<20265.12473.715630.925704@tree.ty.sabi.co.UK>
Mime-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Peter Grandi <pg_xf2@xf2.for.sabi.co.UK>
Cc: Linux fs XFS <xfs@oss.sgi.com>

Le Wed, 1 Feb 2012 12:31:53 +0000
pg_xf2@xf2.for.sabi.co.UK (Peter Grandi) =E9crivait:

> In that case I eliminated all but the root filetree VM disks and
> replaced them with filetrees exported via NFS from XFS on the
> underlying VM host itself (that is not over the network).
> =

> This improved performance tremendously (in part because in most VM
> layers virtual NICs are more efficient than virtual disk adapters)
> but in particular much faster check/repair and much reduced crazy
> latencies during backups, because I could run check/repair and the
> backups *on the real machine*, where XFS performed a lot better
> without the VM overheads and "skewed" latencies.
> =


Thank you for all the good info. To add a last note, I use iSCSI to
export lvm LVs to VMs from the host, and it works fine. Exporting
files living on an XFS works well enough, too, though slightly slower.

It can be useful particularly for windows VM, because many windows app
really behave poorly with network shares (or refuse to use them
altogether).

-- =

------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
