Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n99JJNJS094260 for <xfs@oss.sgi.com>; Fri, 9 Oct 2009 14:19:23 -0500
Received: from smtp5-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D8BD31B9B668
	for <xfs@oss.sgi.com>; Fri,  9 Oct 2009 12:20:48 -0700 (PDT)
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5]) by
	cuda.sgi.com with ESMTP id xBZdHFlD0T5L8QOx for
	<xfs@oss.sgi.com>; Fri, 09 Oct 2009 12:20:48 -0700 (PDT)
Date: Fri, 9 Oct 2009 21:19:31 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: can't mount XFS from a read-only device
Message-ID: <20091009211931.221c8425@galadriel.home>
In-Reply-To: <20091009174351.GB13572@dora.cern.ch>
References: <20091009170937.3938ff7b@harpe.intellique.com>
	<20091009174351.GB13572@dora.cern.ch>
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
To: KELEMEN Peter <Peter.Kelemen@cern.ch>
Cc: xfs@oss.sgi.com

Le Fri, 9 Oct 2009 19:43:51 +0200 vous =E9criviez:

> Log recovery is failing on a read-only device.  Try mounting
> with the "ro,norecovery" options.  However, this will give you a
> potentially inconsistent view of the filesystem.
> =

> Are you snapshotting a live filesystem?  If yes, then I'd suggest
> using xfs_freeze -f/snapshot/xfs_freeze -u to get consistent
> snapshots.

Yes, norecovery did it. I did snapshots previously using LVM, but these
are writable, so only "nouuid" is necessary (to mount the original FS
and snapshot side by side).

I thought that xfs_freeze was broken recently?

-- =

--------------------------------------------------
Emmanuel Florac               www.intellique.com   =

--------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
