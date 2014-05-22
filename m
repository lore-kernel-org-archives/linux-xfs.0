Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B354B7F3F
	for <xfs@oss.sgi.com>; Thu, 22 May 2014 08:17:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A032B304071
	for <xfs@oss.sgi.com>; Thu, 22 May 2014 06:17:01 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id OJViRQEQ5I6sE5w5 for
	<xfs@oss.sgi.com>; Thu, 22 May 2014 06:17:00 -0700 (PDT)
Date: Thu, 22 May 2014 09:16:36 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC PATCH 0/2] xfs: sysfs attribute support
Message-ID: <20140522131636.GA33295@bfoster.bfoster>
References: <1400263966-35541-1-git-send-email-bfoster@redhat.com>
	<20140521144859.GB3580@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140521144859.GB3580@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, May 21, 2014 at 07:48:59AM -0700, Christoph Hellwig wrote:
> On Fri, May 16, 2014 at 02:12:44PM -0400, Brian Foster wrote:
> > Hi all,
> > 
> > This is an rfc to get some discussion rolling on sysfs support for XFS.
> > The motivation for this work is here:
> > 
> > http://oss.sgi.com/archives/xfs/2014-05/msg00381.html
> 
> All the sysfs magic for this looks pretty ugly.  Why can't we just
> dump it into debugfs given that it's very much a debug only feature
> anyway?
> 

Yeah, it kind of is. I think it also could get a bit worse as the
dataset expands and we have to embed more kobjects in the various data
structures. i.e., I think creating a full on directory structure in
sysfs will involve a heirarchy of ksets/kobjects that would have to be
instantiated and reclaimed as the associated subsystems are.

debugfs seems like a reasonable suggestion. I think it's suitable for my
initial purpose here (log leak detection), at least. Taking a first look
through the debugfs code and some examples, it looks like there are some
templates for simple/basic types, and then more customized items/output
or things that require locking would require custom handlers. It appears
we can associate a file with an object in memory. The desired directory
structure is created more explicitly (debugfs_create_dir()), so we can
still create an arbitrary directory structure. That and the fact that
debugfs probably isn't considered ABI are positives to me.

I suspect the debugfs interface means we'd probably want to combine the
setup and teardown into a single path (i.e., xfs_init/fini_debugfs()),
otherwise this would probably get just as ugly by carrying around
debugfs directories in in-memory objects such that the infrastructure is
available per-subsystem. We'd also have to consider that we might
require active modification of the directory structure
post-initialization (i.e., Dave's example included per AG attributes, so
consider growfs). That could perhaps get ugly with this model vs. one
that naturally updates as objects are instantiated/freed.

So to me, the right approach seems like it depends on the grand scheme
of things here. The wide and encompassing model with per-AG data and
controls probably favors the sysfs model where individual files are
managed via the individual objects. The current/initial use case
probably favors using debugfs. I'd also be happy to start this off with
debugfs and we can consider converting it to sysfs when the expanded use
case is more defined and justified (though if use cases are clear to
others, I'd prefer to do it correctly now rather than waste time
converting back and forth). Thoughts?

> It would also be really nitfy to have a tool to fronted it in the style
> of xfs_db and xfs_io..

Perhaps, but what's the purpose of having a tool that just reads/writes
these kind of attribute files? Something like that would be great were
these controls exposed via ioctl(), of course, but the existence of
sysfs/debugfs with per-file controls eliminates the need for that kind
of custom tool IMO. Did you have additional functionality in mind?

Thanks for looking at this...

Brian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
