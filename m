Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q25LeH5a009647 for <xfs@oss.sgi.com>; Mon, 5 Mar 2012 15:40:17 -0600
Received: from mx0.pronet.com.pl (mx0.pronet.com.pl [193.108.35.26]) by
	cuda.sgi.com with ESMTP id 2iMGQ94m8mvOqoRn for
	<xfs@oss.sgi.com>; Mon, 05 Mar 2012 13:40:15 -0800 (PST)
Subject: Re: XFS: Assertion failed: bp->b_bn != XFS_BUF_DADDR_NULL, file:
	fs/xfs/xfs_buf.c, line: 598
From: =?UTF-8?Q?Rafa=C5=82?= Kupka <kupson@kupson.net>
In-Reply-To: <20120303114413.GA18748@infradead.org>
References: <1330539626.7615.73.camel@utemp.mieszkanie>
	<20120302104348.GA22230@infradead.org>
	<1330774627.32457.24.camel@utemp.mieszkanie>
	<20120303114413.GA18748@infradead.org>
Date: Mon, 05 Mar 2012 22:40:12 +0100
Message-ID: <1330983612.28645.18.camel@utemp.mieszkanie>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Sat, 2012-03-03 at 06:44 -0500, Christoph Hellwig wrote:
> On Sat, Mar 03, 2012 at 12:37:07PM +0100, Rafa?? Kupka wrote:
> > On Fri, 2012-03-02 at 05:43 -0500, Christoph Hellwig wrote:
Hi,

I've completed bisection process. It looks like kernel up to

704b2907 "xfs: register the inode cache shrinker before quotachecks"

is good and first bad commit is:

0e6e847f "xfs: stop using the page cache to back the buffer cache"

I double tested it - 704b2907 can do 60+ loops of xfsdump without any
trouble and 0e6e847f breaks in <10 iterations.

> > - git revision c5850150d0b9ae16840c5d9846f9d5a759996a15:
> >     Merge branch 'for-linus' of git://oss.sgi.com/xfs/xfs
> >     =

> >     * 'for-linus' of git://oss.sgi.com/xfs/xfs:
> >       xfs: stop using the page cache to back the buffer cache
> >       xfs: register the inode cache shrinker before quotachecks
> >       xfs: xfs_trans_read_buf() should return an error on failure
> =

> This is the only patch in that area.  Give me a bit more time to
> figure out how it could related to your issues.

Can I do something more to help?

Regards,
Rafa=B3 Kupka

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
