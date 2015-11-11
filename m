Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BA0D57F52
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 01:57:21 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4537FAC005
	for <xfs@oss.sgi.com>; Tue, 10 Nov 2015 23:57:21 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id ImsxWAXcUrpjTCPw (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 10 Nov 2015 23:57:19 -0800 (PST)
Date: Tue, 10 Nov 2015 23:57:07 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v15 00/22] Richacls (Core and Ext4)
Message-ID: <20151111075707.GA23752@infradead.org>
References: <1447067343-31479-1-git-send-email-agruenba@redhat.com>
	<20151110112943.GA17038@infradead.org>
	<CAHc6FU5g7=wd1Wt4+GCaLJjNu7giruZyAON3VcYn-A=ffYMsmw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAHc6FU5g7=wd1Wt4+GCaLJjNu7giruZyAON3VcYn-A=ffYMsmw@mail.gmail.com>
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
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, linux-cifs@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, LKML <linux-kernel@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, linux-ext4 <linux-ext4@vger.kernel.org>, Anna Schumaker <anna.schumaker@netapp.com>

On Tue, Nov 10, 2015 at 01:39:52PM +0100, Andreas Gruenbacher wrote:
> > It still has the same crappy fs interfaces with lots of boilerplate
> > code
> 
> Could you please be more specific so that I can trace this complaint
> to some actual code?

if (IS_RICHACL())
	richacl_foo()
else
	posix_acl_foo()

for every call from the filesystem is the major one that came to mind.

> > and still abuses xattrs instead of a proper syscall interface.
> > That's far from being ready to merge.
> 
> The xattr syscall interface is what's used for very similar kinds of
> things today; using it for richacls as well sure does not count as
> abuse. Things could be improved in the xattr interface and in its
> implementation, but we need more substantial reasons than that for
> reimplementing the wheel once again.

And it's a horrible interface.  Look at all the pain for example in
XFS which has a different ACL format, or in fact everyone who just
uses a different xattr name or even none at all.  And all the mess
of people trying to shoe horn crazy interfaces into xattrs.

It was an experiment worth trying with Posix ACLs, but it failed, so
do not repeat it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
