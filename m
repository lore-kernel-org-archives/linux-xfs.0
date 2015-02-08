Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 532247F7B
	for <xfs@oss.sgi.com>; Sun,  8 Feb 2015 17:41:37 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1367C304039
	for <xfs@oss.sgi.com>; Sun,  8 Feb 2015 15:41:36 -0800 (PST)
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24]) by
	cuda.sgi.com with ESMTP id aqu4BZIBSXI6oLK0 (version=TLSv1
	cipher=RC4-MD5 bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 08 Feb 2015 15:41:34 -0800 (PST)
Received: from epcpsbgr3.samsung.com
	(u143.gpu120.samsung.co.kr [203.254.230.143])
	by mailout1.samsung.com (Oracle Communications Messaging Server
	7u4-24.01 (7.0.4.24.0) 64bit (built Nov 17 2011))
	with ESMTP id <0NJH001FR8H2TN20@mailout1.samsung.com> for
	xfs@oss.sgi.com; Mon, 09 Feb 2015 08:41:27 +0900 (KST)
From: Namjae Jeon <namjae.jeon@samsung.com>
References: <001f01d041cb$39fbbc70$adf33550$@samsung.com>
	<54D45068.2030209@sandeen.net>
	<002401d041cf$570eae40$052c0ac0$@samsung.com>
	<20150206222227.GN12722@dastard>
In-reply-to: <20150206222227.GN12722@dastard>
Subject: RE: [PATCH] xfsprog: xfsio: update xfs_io manpage for
	FALLOC_FL_INSERT_RANGE
Date: Mon, 09 Feb 2015 08:41:26 +0900
Message-id: <001501d043f8$c143a290$43cae7b0$@samsung.com>
MIME-version: 1.0
Content-language: ko
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: 'Dave Chinner' <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, 'Eric Sandeen' <sandeen@sandeen.net>, 'Ashish Sangwan' <a.sangwan@samsung.com>, xfs@oss.sgi.com

> On Fri, Feb 06, 2015 at 02:39:56PM +0900, Namjae Jeon wrote:
> > > On 2/5/15 11:10 PM, Namjae Jeon wrote:
> > > > Update xfs_io manpage for FALLOC_FL_INSERT_RANGE.
> > > >
> > > > Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> > > > Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> > > > ---
> > > >  man/man8/xfs_io.8 | 5 +++++
> > > >  1 file changed, 5 insertions(+)
> > > >
> > > > diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> > > > index cf27b99..416206f 100644
> > > > --- a/man/man8/xfs_io.8
> > > > +++ b/man/man8/xfs_io.8
> > > > @@ -404,6 +404,11 @@ Call fallocate with FALLOC_FL_COLLAPSE_RANGE flag as described in the
> > > >  manual page to de-allocates blocks and eliminates the hole created in this process
> > > >  by shifting data blocks into the hole.
> > > >  .TP
> > > > +.BI finsert " offset length"
> > > > +Call fallocate with FALLOC_FL_INSERT_RANGE flag as described in the
> > > > +.BR fallocate (2)
> > > > +manual page
> > >
> > Hi Eric,
> > > So, it looks like the fallocate(2) manpage will need an update as well.  :)
> > Right, I am planning to send the manpage patch for insert range when merging linus tree..
> 
> Best to have the man page with the rest of the code changes, that
> way they all get reviewed at the same time. :)
Agree. I will also send the manpage patch soon.

Thanks :)
> 
> Cheers,
> 
> Dave.
> --
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
