Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4IER3IP189586 for <xfs@oss.sgi.com>; Fri, 18 May 2012 09:27:03 -0500
Date: Fri, 18 May 2012 09:31:43 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: How to recover data from an xfs partition
Message-ID: <20120518143143.GN16099@sgi.com>
References: <4FAE9DBF.1090505@linuxsystems.it>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FAE9DBF.1090505@linuxsystems.it>
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
To: =?iso-8859-1?Q?Niccol=F2?= Belli <darkbasic@linuxsystems.it>
Cc: xfs@oss.sgi.com

Niccolo,

On Sat, May 12, 2012 at 07:28:31PM +0200, Niccol=F2 Belli wrote:
> root@firewall:~# xfs_repair /dev/loop51
> Phase 1 - find and verify superblock...
> bad primary superblock - bad magic number !!!
> =

> attempting to find secondary superblock...
> .........................................................................=
.......found
> candidate secondary superblock...
> unable to verify superblock, continuing...
> .............
> [...]
> ....................................Sorry, could not find valid
> secondary superblock
> Exiting now.
> =

> =

> How can I restore my data?

I recommend you give it a shot with the latest xfsprogs.  However, it may be
that your filesystem has been corrupted beyond repair.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
