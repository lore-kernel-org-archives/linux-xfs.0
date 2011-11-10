Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAAMd0k3138561
	for <linux-xfs@oss.sgi.com>; Thu, 10 Nov 2011 16:39:00 -0600
Received: from exprod7og114.obsmtp.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 84B32236F41
	for <linux-xfs@oss.sgi.com>; Thu, 10 Nov 2011 14:38:58 -0800 (PST)
Received: from exprod7og114.obsmtp.com (exprod7og114.obsmtp.com [64.18.2.215])
	by cuda.sgi.com with SMTP id kqcqjt9ZUgVJyYy3 for
	<linux-xfs@oss.sgi.com>; Thu, 10 Nov 2011 14:38:58 -0800 (PST)
Received: by iaek3 with SMTP id k3so926452iae.28
	for <linux-xfs@oss.sgi.com>; Thu, 10 Nov 2011 14:38:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20111110222424.GB2386@dastard>
References: <loom.20111108T180925-222@post.gmane.org>
	<20111109080133.GB20604@infradead.org>
	<CAGedfzmcmfLXhBEzm9yhpRQTf-7dnMenXqe0FABAzJgP0rxSUA@mail.gmail.com>
	<20111109223314.GQ5534@dastard>
	<CAGedfznrW4c9Bf3D-7+CEUUa-_u5iVzh+KskwFS9bom0s=C=gQ@mail.gmail.com>
	<20111110222424.GB2386@dastard>
Date: Thu, 10 Nov 2011 17:38:57 -0500
Message-ID: <CAGedfznRyZAymqtw7i1GeN2u9C4uhHiT_bxqAqrE-m1TqbJ0GQ@mail.gmail.com>
Subject: Re: XFS realtime O_DIRECT failures
From: Alan Cook <acook@visionpointsystems.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@oss.sgi.com

On Thu, Nov 10, 2011 at 5:24 PM, Dave Chinner <david@fromorbit.com> wrote:
> XFS metadata IO is tagged with REQ_META, so the block layer can
> easily distinguish it from data IO. =A0Even if the version if XFS you
> are using is not doing this, it's rather simple to add it to
> _xfs_buf_ioapply().
>
> With that, your problem at the block layer goes away, and hence the
> need to separate data from metadata at the filesystem layer goes
> away, too.

Thanks.  I'll take a look into my particular version of XFS.  That tag
may well solve my problems.

> > Unfortunately they do not tell a lot. =A0Running xfs_check/xfs_repair -n
> > prior to running the test reports no errors. =A0However, attempting to
> > run it after the test fails results in an indefinite I/O block (state
> > of D+ for the process). =A0In fact, if I run the test utility twice, it
> > results in a hung system.
>
> That sounds like you have a problem with your block device or
> underlying storage, not a filesystem problem....

I had the same thought at first, but I get the same behavior using
only ramdisks.  This issue only occurs when using RT subvolumes.
Using XFS without separating the data and meta data (e.g. all on one
device) has no issues.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
