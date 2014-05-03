Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1AEEB7F37
	for <xfs@oss.sgi.com>; Sat,  3 May 2014 10:14:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AD912AC003
	for <xfs@oss.sgi.com>; Sat,  3 May 2014 08:14:45 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id b5BCfqU0E2shmlRZ (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 03 May 2014 08:14:44 -0700 (PDT)
Date: Sat, 3 May 2014 08:14:40 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix Q_XQUOTARM ioctl
Message-ID: <20140503151440.GA28608@infradead.org>
References: <535580A1.20806@redhat.com> <20140503114816.GA31191@infradead.org>
	<5364FED5.1050203@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5364FED5.1050203@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Sat, May 03, 2014 at 09:36:05AM -0500, Eric Sandeen wrote:
> Whoops, missed reply-all.
> 
> Yes, it will fail this way w/o the kernel patch.
> 
> User quota gets removed OK because flags accidentally line up;
> group quota remains, so you'd see exactly this.

Ok.  Dave, can you pick it up for for-next?

> 
> -Eric
> 
> On 5/3/14, 6:48 AM, Christoph Hellwig wrote:
> > Can I assumes that xfs/007 failing with:
> > 
> > --- tests/xfs/007.out	2014-05-03 08:58:08.000000000 +0000
> > +++ /root/xfstests/results//xfs/007.out.bad	2014-05-03
> > 11:48:05.000000000 +0000
> > @@ -7,4 +7,4 @@
> >  *** umount
> >  *** Usage after quotarm ***
> >  core.nblocks = 0
> > -core.nblocks = 0
> > +core.nblocks = 1
> > 
> > is because this patch didn't get picked up yet?
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> > 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
