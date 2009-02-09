Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n19JJ5jW002839 for <xfs@oss.sgi.com>; Mon, 9 Feb 2009 13:19:05 -0600
Received: from wa-out-1112.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A0FA3100466
	for <xfs@oss.sgi.com>; Mon,  9 Feb 2009 11:18:27 -0800 (PST)
Received: from wa-out-1112.google.com (wa-out-1112.google.com
	[209.85.146.176]) by cuda.sgi.com with ESMTP id
	7w6ACRyrFgJK89DU for <xfs@oss.sgi.com>;
	Mon, 09 Feb 2009 11:18:27 -0800 (PST)
Received: by wa-out-1112.google.com with SMTP id k22so1145871waf.4
	for <xfs@oss.sgi.com>; Mon, 09 Feb 2009 11:18:27 -0800 (PST)
Date: Mon, 9 Feb 2009 11:09:50 -0800
From: Brandon Philips <brandon@ifup.org>
Subject: merging acl-dev and attr-dev [was: Re: [patch 0/4] attr: test/
	improvements and integrate with make]
Message-ID: <20090209190950.GF21254@jenkins.ifup.org>
References: <20090108021947.404730068@ifup.org> <20090108165820.GA3832@jenkins>
	<20090207091033.GO29636@jenkins.ifup.org>
	<200902090000.00162.agruen@suse.de>
	<20090209181257.GA18112@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090209181257.GA18112@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 13:12 Mon 09 Feb 2009, Christoph Hellwig wrote:
> On Sun, Feb 08, 2009 at 11:59:59PM +0100, Andreas Gruenbacher wrote:
> > >
> > >   http://ifup.org/git/?p=acl-attr-dev.git;a=summary
> > >   git clone git://ifup.org/philips/acl-attr-dev.git
> > >
> > > What do you think?
> > 
> > I believe it's a good start; we probably want to merge the trees eventually. 
> > The way how you have moved libmisc breaks the tarballs though; I have fixed 
> > it. Also, I was surprised that your repository has all the history rewritten 
> > instead of merging Christoph's trees, so I redid the merge.
> 
> I think the merge is a bad idea.  attr and acl serve quite
> different purposes and have been different source and binary packages in
> distros forever. 

They can remain different binary packages after merging the source code
repos to share libmisc.

> I'd rather keep it as it was for now and maybe find
> some way libacl could pick up libmisc from libattr.
>
> There's a reason we split up xfs-cmds into more manageable
> repositories.

What was the reason for splitting these two packages from each other?

>From looking at the shortlogs it looks like a lot of the bug fixes are
made against attr then copied over to acl: 

 http://ifup.org/git/?p=acl-attr-dev.git;a=shortlog

> I'd rather keep it as it was for now and maybe find
> some way libacl could pick up libmisc from libattr.

Perhaps. Although, it doesn't seem right making walk_tree or the quoting
code available to applications through libacl.

Cheers,

	Brandon

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
