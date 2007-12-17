Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 16 Dec 2007 23:25:17 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id lBH7P7F3005266
	for <xfs@oss.sgi.com>; Sun, 16 Dec 2007 23:25:12 -0800
Date: Mon, 17 Dec 2007 18:39:17 +1100
From: Greg Banks <gnb@sgi.com>
Subject: Re: [review] Remove the xfs refcache
Message-ID: <20071217073917.GA19445@sgi.com>
References: <4765EC66.5020202@sgi.com> <4765F444.8010705@sgi.com> <20071217071426.GA11462@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071217071426.GA11462@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Lachlan McIlroy <lachlan@sgi.com>, Donald Douwsma <donaldd@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Dec 17, 2007 at 07:14:27AM +0000, Christoph Hellwig wrote:
> On Mon, Dec 17, 2007 at 03:00:04PM +1100, Lachlan McIlroy wrote:
> > Hey hold on there buddy!  We may need to reactivate this code to fix some
> > performance issues.  I've acttually got this code working and proven that
> > it is one way to fix some of the NAS/NFS issues we have.
> >
> > The little comment that reads "reference cache not needed for NFS in 2.6"
> > is wrong - we do need it or something like it.
> 
> Not in XFS, though.  This thing needs to be done genericly in NFSD.
> Greg has been working on an open files cache in nfsd which should be
> helping this.

BTW, status on that: The current implementation has mutated into
a filehandle-to-dentry mapping cache, because that helps some
metadata-heavy workloads too.  I've been testing it these last few
weeks at a customer site, and it's been useful, but there are still
some issues to be worked out before I can post it.

> Adding a cache like this back into XFS will get my veto (at least for
> mainline where I have a bit of a say :))

Greg.
-- 
Greg Banks, R&D Software Engineer, SGI Australian Software Group.
Apparently, I'm Bedevere.  Which MPHG character are you?
I don't speak for SGI.
