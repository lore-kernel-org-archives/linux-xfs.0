Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1A7wgN1037575 for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 01:58:43 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A08021906E6B
	for <xfs@oss.sgi.com>; Mon,  9 Feb 2009 23:58:06 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id WUwREX8AOK3aeiB7 for
	<xfs@oss.sgi.com>; Mon, 09 Feb 2009 23:58:06 -0800 (PST)
Date: Tue, 10 Feb 2009 02:57:34 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: merging acl-dev and attr-dev [was: Re: [patch 0/4] attr: test/
	improvements and integrate with make]
Message-ID: <20090210075734.GC27111@infradead.org>
References: <20090108021947.404730068@ifup.org> <20090108165820.GA3832@jenkins>
	<20090207091033.GO29636@jenkins.ifup.org>
	<200902090000.00162.agruen@suse.de>
	<20090209181257.GA18112@infradead.org>
	<20090209190950.GF21254@jenkins.ifup.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090209190950.GF21254@jenkins.ifup.org>
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
To: Brandon Philips <brandon@ifup.org>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Feb 09, 2009 at 11:09:50AM -0800, Brandon Philips wrote:
> > There's a reason we split up xfs-cmds into more manageable
> > repositories.
> 
> What was the reason for splitting these two packages from each other?

That they are not related to each other.

> >From looking at the shortlogs it looks like a lot of the bug fixes are
> made against attr then copied over to acl: 
> 
>  http://ifup.org/git/?p=acl-attr-dev.git;a=shortlog

The only copies bugfixes are the nasty buildsystem which I think Andreas
wants to get rid of mid-term and libmisc.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
