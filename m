Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1RAaciY046515 for <xfs@oss.sgi.com>; Mon, 27 Feb 2012 04:36:39 -0600
Received: from smtprelay04.ispgateway.de (smtprelay04.ispgateway.de
	[80.67.29.8]) by cuda.sgi.com with ESMTP id nOjNOzMXrUmocISP
	for <xfs@oss.sgi.com>; Mon, 27 Feb 2012 02:36:37 -0800 (PST)
Received: from [62.43.225.238] (helo=[192.168.30.191])
	by smtprelay04.ispgateway.de with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.68) (envelope-from <richard.ems@cape-horn-eng.com>)
	id 1S1xwa-000193-F5
	for xfs@oss.sgi.com; Mon, 27 Feb 2012 11:36:36 +0100
Message-ID: <4F4B5CB3.8090107@cape-horn-eng.com>
Date: Mon, 27 Feb 2012 11:36:35 +0100
From: Richard Ems <richard.ems@cape-horn-eng.com>
MIME-Version: 1.0
Subject: Re: XFS status update for January 2012
References: <20120225120216.GA21721@infradead.org>
In-Reply-To: <20120225120216.GA21721@infradead.org>
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
To: xfs@oss.sgi.com

On 02/25/2012 01:02 PM, Christoph Hellwig wrote:
> January saw the release of Linux 3.2, which as usual included a large
> number of XFS changes, most notably an large speedup for removing files
> that have external attribute blocks, speedups and livelock fixes for
> sync while doing heavy I/O, and large internal cleanups of the inode
> block map handling.  The diffstat for XFS in Linux 3.2 is:
> =

>  54 files changed, 2414 insertions(+), 2625 deletions(-)
> =

> which is slightly below the average of the last releases.
> =

> In the meantime development for 3.3 went ahead full speed, including
> the removal of the deprecated pre-delaylog logging code, various
> quota cleanups, a shrink of the inode, a great simplification of the file
> write path as well as the usual batch of fixes and cleanups.
> =

> On the userland side xfs_repair saw various major fixes and speedups,
> with few other fixes thrown in, while xfsdump got two commits fixing
> longer standing issues recently reported on the mailing list.  For
> xfstests January was an extremely slow month, seeing only two new test ca=
ses
> and less than a handful of other updates.

Many thanks to all of your for the good work and support on the mailing
list !

cheers,
Richard


-- =

Richard Ems       mail: Richard.Ems@Cape-Horn-Eng.com

Cape Horn Engineering S.L.
C/ Dr. J.J. D=F3mine 1, 5=BA piso
46011 Valencia
Tel : +34 96 3242923 / Fax 924
http://www.cape-horn-eng.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
