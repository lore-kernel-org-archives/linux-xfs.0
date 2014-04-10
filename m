Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 18F947F81
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 07:29:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A3ADAAC001
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 05:29:47 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id hHcTHAWMzyrcoXEg (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 10 Apr 2014 05:29:45 -0700 (PDT)
Date: Thu, 10 Apr 2014 05:29:44 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 1/2] xfs: fix tmpfile/selinux deadlock and initialize
	security/acl
Message-ID: <20140410122944.GA6579@infradead.org>
References: <1397071311-28371-1-git-send-email-bfoster@redhat.com>
	<1397071311-28371-2-git-send-email-bfoster@redhat.com>
	<20140410102421.GA17641@infradead.org>
	<20140410121947.GA14124@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140410121947.GA14124@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: linux-man@vger.kernel.org, Andreas Gruenbacher <agruen@linbit.com>, xfs@oss.sgi.com, linux-security-module@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Thu, Apr 10, 2014 at 08:19:48AM -0400, Brian Foster wrote:
> Are you saying it doesn't have to initialize security or the default
> acl, or both?

The ACLs for sure.  LSM do run-time access decisions, so they will
probably rely on the security data being initialized.  Given that
O_TMPFILE files aren't publicly available I'm not sure there's a point
in them doing that, though.

LSMs are also affected by the lack of a proper parent I'll discuss for
ACLs below.

> The intent here was to have the case covered where the inode happens to
> be linked back into the namespace since we don't do this work in the
> link path.

That's an interesting one.  O_TMFILE files don't have a real parent
to inherit ACLs from, the pathname passed in just needs to point to
a directory to find the filesystem to create the tmpfile in.  On
the other hand it seem like the extN implementations do inherity the
ACL in this case.

The link into the namespace is irrelavant here as ACL inheritance only
happens on initial create, not at link time.

I also think we'll absolutely need a test case for ACLs+tmpfile to
make sure all filesystems handle it the same way.

> The bulk of the refactoring was with the idea that the inode setup for
> the tmpfile case is generally equivalent for the traditional create
> case. The original version was posted here:
> 
> http://oss.sgi.com/archives/xfs/2014-04/msg00149.html
> 
> ... and it just fixes the deadlock and adds the security initialization.
> I suppose I could still break that out into multiple patches, but that
> aside, is that behavior preferred?

I think just fixing the deadlock and initializing the security is enough
for the first pass.  If you want to do the refactoring on top send it as
a second series on top of the actual fixes.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
