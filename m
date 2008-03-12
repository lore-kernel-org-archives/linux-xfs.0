Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 12 Mar 2008 00:22:51 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2C7MVgO001676
	for <xfs@oss.sgi.com>; Wed, 12 Mar 2008 00:22:32 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 75E5BF7406E
	for <xfs@oss.sgi.com>; Wed, 12 Mar 2008 00:23:02 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id x5cXt6TH1meFqMs2 for <xfs@oss.sgi.com>; Wed, 12 Mar 2008 00:23:02 -0700 (PDT)
Date: Wed, 12 Mar 2008 03:22:59 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH, RFC] - remove mounpoint UUID code
Message-ID: <20080312072259.GA26148@infradead.org>
References: <47D20F78.7000103@sandeen.net> <1205196252.15982.69.camel@edge.scott.net.au> <47D5DE13.8030902@sandeen.net> <34665.192.168.3.1.1205266196.squirrel@mail.aconex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34665.192.168.3.1.1205266196.squirrel@mail.aconex.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: nscott@aconex.com
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On Wed, Mar 12, 2008 at 07:09:56AM +1100, nscott@aconex.com wrote:
> I don't have any immediate plans.  I can imagine it could be used to
> stitch parts of the namespace together in a filesystem that supports
> multiple devices (in a chunkfs kinda way) ... or maybe more simply
> just an in-filesystem auto-mounter.  *shrug*.  But its there, the tools
> support it (once again, I didn't see a userspace patch - hohum), so I
> would vote for leaving it in its current form so some enterprising,
> constructive young coder can try to make something useful from it
> at some point.  :)

That kind of automounter really doesn't belong into the low-level
filesystem.  If we really wanted it it would go into the VFS, storing
the uuid or other identifier for the mountpoint in an xattr.  This is
really just dead junk that should go away.
