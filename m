Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n19IDZFP261311 for <xfs@oss.sgi.com>; Mon, 9 Feb 2009 12:13:36 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 78362FFD3B
	for <xfs@oss.sgi.com>; Mon,  9 Feb 2009 10:12:59 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id yvOdvfKEKvPmNCJO for
	<xfs@oss.sgi.com>; Mon, 09 Feb 2009 10:12:59 -0800 (PST)
Date: Mon, 9 Feb 2009 13:12:57 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 0/4] attr: test/ improvements and integrate with make
Message-ID: <20090209181257.GA18112@infradead.org>
References: <20090108021947.404730068@ifup.org> <20090108165820.GA3832@jenkins>
	<20090207091033.GO29636@jenkins.ifup.org>
	<200902090000.00162.agruen@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200902090000.00162.agruen@suse.de>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Brandon Philips <brandon@ifup.org>, xfs@oss.sgi.com

On Sun, Feb 08, 2009 at 11:59:59PM +0100, Andreas Gruenbacher wrote:
> >
> >   http://ifup.org/git/?p=acl-attr-dev.git;a=summary
> >   git clone git://ifup.org/philips/acl-attr-dev.git
> >
> > What do you think?
> 
> I believe it's a good start; we probably want to merge the trees eventually. 
> The way how you have moved libmisc breaks the tarballs though; I have fixed 
> it. Also, I was surprised that your repository has all the history rewritten 
> instead of merging Christoph's trees, so I redid the merge.

I think the merge is a bad idea.  attr and acl serve quite
different purposes and have been different source and binary packages in
distros forever.  I'd rather keep it as it was for now and maybe find
some way libacl could pick up libmisc from libattr.

There's a reason we split up xfs-cmds into more manageable repositories.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
