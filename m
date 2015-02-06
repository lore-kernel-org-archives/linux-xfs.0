Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 16982803C
	for <xfs@oss.sgi.com>; Thu,  5 Feb 2015 23:40:06 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 047B68F8064
	for <xfs@oss.sgi.com>; Thu,  5 Feb 2015 21:40:05 -0800 (PST)
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34]) by
	cuda.sgi.com with ESMTP id e7LGUpQviGPnjfJh (version=TLSv1
	cipher=RC4-MD5 bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 05 Feb 2015 21:40:01 -0800 (PST)
Received: from epcpsbgr1.samsung.com
	(u141.gpu120.samsung.co.kr [203.254.230.141])
	by mailout4.samsung.com (Oracle Communications Messaging Server
	7u4-24.01 (7.0.4.24.0) 64bit (built Nov 17 2011))
	with ESMTP id <0NJC0096D52NS180@mailout4.samsung.com> for
	xfs@oss.sgi.com; Fri, 06 Feb 2015 14:39:59 +0900 (KST)
From: Namjae Jeon <namjae.jeon@samsung.com>
References: <001f01d041cb$39fbbc70$adf33550$@samsung.com>
	<54D45068.2030209@sandeen.net>
In-reply-to: <54D45068.2030209@sandeen.net>
Subject: RE: [PATCH] xfsprog: xfsio: update xfs_io manpage for
	FALLOC_FL_INSERT_RANGE
Date: Fri, 06 Feb 2015 14:39:56 +0900
Message-id: <002401d041cf$570eae40$052c0ac0$@samsung.com>
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
To: 'Eric Sandeen' <sandeen@sandeen.net>, 'Dave Chinner' <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, 'Ashish Sangwan' <a.sangwan@samsung.com>, xfs@oss.sgi.com

> On 2/5/15 11:10 PM, Namjae Jeon wrote:
> > Update xfs_io manpage for FALLOC_FL_INSERT_RANGE.
> >
> > Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> > Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> > ---
> >  man/man8/xfs_io.8 | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> > index cf27b99..416206f 100644
> > --- a/man/man8/xfs_io.8
> > +++ b/man/man8/xfs_io.8
> > @@ -404,6 +404,11 @@ Call fallocate with FALLOC_FL_COLLAPSE_RANGE flag as described in the
> >  manual page to de-allocates blocks and eliminates the hole created in this process
> >  by shifting data blocks into the hole.
> >  .TP
> > +.BI finsert " offset length"
> > +Call fallocate with FALLOC_FL_INSERT_RANGE flag as described in the
> > +.BR fallocate (2)
> > +manual page
> 
Hi Eric,
> So, it looks like the fallocate(2) manpage will need an update as well.  :)
Right, I am planning to send the manpage patch for insert range when merging linus tree..

> (linux-man@vger.kernel.org I believe)
Okay.

Thanks for your point :)
> 
> Thanks,
> -Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
