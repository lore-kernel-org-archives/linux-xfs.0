Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3R8ebKr012121 for <xfs@oss.sgi.com>; Mon, 27 Apr 2009 03:40:38 -0500
Received: from josefsipek.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B0584144DD57
	for <xfs@oss.sgi.com>; Mon, 27 Apr 2009 01:43:48 -0700 (PDT)
Received: from josefsipek.net (josefsipek.net [141.211.133.196]) by
	cuda.sgi.com with ESMTP id UoLxJiBHwlqkZOlo for
	<xfs@oss.sgi.com>; Mon, 27 Apr 2009 01:43:48 -0700 (PDT)
Date: Mon, 27 Apr 2009 04:40:35 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: Slab memory usage
Message-ID: <20090427084035.GO3709@josefsipek.net>
References: <73EE3FB2-381F-43F1-82C1-FA4C020E7C02@strands.com>
	<49F260F1.4030503@sandeen.net> <200904262351.22970@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200904262351.22970@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On Sun, Apr 26, 2009 at 11:51:22PM +0200, Michael Monnerie wrote:
> On Samstag 25 April 2009 Eric Sandeen wrote:
> > *from Documentation/sysctl/vm.txt:
> >
> > vfs_cache_pressure
> > ------------------
> >
> > Controls the tendency of the kernel to reclaim the memory which is
> > used for caching of directory and inode objects.
> >
> > At the default value of vfs_cache_pressure=3D100 the kernel will
> > attempt to reclaim dentries and inodes at a "fair" rate with respect
> > to pagecache and swapcache reclaim. =A0Decreasing vfs_cache_pressure
> > causes the kernel to prefer to retain dentry and inode caches.
> > =A0Increasing vfs_cache_pressure beyond 100 causes the kernel to prefer
> > to reclaim dentries and inodes.
> =

> So if I decrease it, lets say to 60, Linux prefers to remember =

> files/dirs over their content. An increase to 150 would mean Linux =

> prefers to keep file contents over dirs/files?

Yep, that's right.

> If so, I think for a fileserver for many users accessing many =

> dirs/files, I'd prefer a lower value, in order to prevent searching. =

> Disk contents can be read fast, with all the read-ahead caching of =

> disks/controllers and Linux itself, but the scattered dirs take loooong =

> to scan sometimes. (Example: a foto collection with 50.000 files in many =

> dirs). Am I right?

Approximate answer is: it depends on the frequency of meta-data reads vs.
data reads. Your reasoning is fine if whoever access the photo collection
does not frequently read the photos themselves.

Best answer is: benchmark it with the exact workload you have to deal with

Josef 'Jeff' Sipek.

-- =

Intellectuals solve problems; geniuses prevent them
		- Albert Einstein

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
