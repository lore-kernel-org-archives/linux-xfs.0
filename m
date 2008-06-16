Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 16 Jun 2008 03:00:33 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5GA0RhP011056
	for <xfs@oss.sgi.com>; Mon, 16 Jun 2008 03:00:28 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DE520122E66E
	for <xfs@oss.sgi.com>; Mon, 16 Jun 2008 03:01:25 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id ONKgY6BlPxr9QMLp for <xfs@oss.sgi.com>; Mon, 16 Jun 2008 03:01:25 -0700 (PDT)
Date: Mon, 16 Jun 2008 06:01:22 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS errors / BUG / panic, with 2.6.25.7-queue (and older
	2.6.25.y)
Message-ID: <20080616100122.GA1360@infradead.org>
References: <6101e8c40806141241h4a23f7a6ka5366c84130f1291@mail.gmail.com> <48547604.9060700@sandeen.net> <6101e8c40806150538h4372dcedob2ab9c45aa01741c@mail.gmail.com> <48553C11.2060606@sandeen.net> <20080616045221.GJ3700@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080616045221.GJ3700@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, Oliver Pinter <oliver.pntr@gmail.com>, xfs@oss.sgi.com

On Mon, Jun 16, 2008 at 02:52:21PM +1000, Dave Chinner wrote:
> > is the first event of interest, it is hitting an assertion on the
> > remount path:
> > 
> >         ASSERT_ALWAYS(atomic_read(&mp->m_active_trans) == 0);
> > 
> > in xfs_attr_quiesce.
> 
> That's caused by a race condition in the VFS w.r.t setting the MS_RDONLY
> flag. It should be fixed in 2.6.26.

I was claiming it would be fixed in 2.6.26 but unfortunately the part of
the the per-mount r/o patches that fixes various bits in remount isn't
there yet.
