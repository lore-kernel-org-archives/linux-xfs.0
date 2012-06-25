Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5PKo4ed019783 for <xfs@oss.sgi.com>; Mon, 25 Jun 2012 15:50:04 -0500
Date: Mon, 25 Jun 2012 15:51:28 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: Strange case of deleting lots of files and "df" not
	recognizing it....(unless I umount/mount) the disk...
Message-ID: <20120625205128.GA29979@sgi.com>
References: <4FE7FDF4.6080506@tlinx.org>
	<20120625090211.3c5c2032@galadriel.home>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120625090211.3c5c2032@galadriel.home>
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
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Mon, Jun 25, 2012 at 09:02:11AM +0200, Emmanuel Florac wrote:
> Le Sun, 24 Jun 2012 22:58:12 -0700 vous =E9criviez:
> =

> > So when does it actually synchronize w/o me forcing it?  (I.e.
> > umount/mount)?
> > =

> =

> Yes, it happens sometimes and a umount/mount is needed to fix it.

You may find that this will get the job done:
echo 3 > /proc/sys/vm/drop_caches

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
