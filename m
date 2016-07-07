Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 509097CF2
	for <xfs@oss.sgi.com>; Thu,  7 Jul 2016 09:14:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 217243040E4
	for <xfs@oss.sgi.com>; Thu,  7 Jul 2016 07:14:20 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id mUmhIDRbHziK4H8X (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 07 Jul 2016 07:14:20 -0700 (PDT)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1467831425.2908.16.camel@redhat.com>
References: <1467831425.2908.16.camel@redhat.com>
	<1467294433-3222-1-git-send-email-agruenba@redhat.com>
	<1467294433-3222-14-git-send-email-agruenba@redhat.com>
Subject: Re: [PATCH v23 13/22] vfs: Cache richacl in struct inode
MIME-Version: 1.0
Content-ID: <1688.1467900853.1@warthog.procyon.org.uk>
Date: Thu, 07 Jul 2016 15:14:13 +0100
Message-ID: <1689.1467900853@warthog.procyon.org.uk>
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
To: Jeff Layton <jlayton@redhat.com>, Andreas Gruenbacher <agruenba@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-nfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, linux-cifs@vger.kernel.org, linux-api@vger.kernel.org, Trond Myklebust <trond.myklebust@primarydata.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, dhowells@redhat.com, Andreas Dilger <adilger.kernel@dilger.ca>, "J. Bruce Fields" <bfields@fieldses.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Anna Schumaker <anna.schumaker@netapp.com>

Jeff Layton <jlayton@redhat.com> wrote:

> > +	if (cmpxchg(&inode->i_acl, ACL_NOT_CACHED, sentinel) != ACL_NOT_CACHED)
> > +		/* fall through */ ;
> > +
> 
> So you do the same thing regardless of the outcome of the above? Why
> bother with the if at all here? Just do the cmpxchg and toss out the
> result.

gcc might complain if you don't check the result.

However, this does look like it's subject to a thundering herd problem.  If
30000 processes all look at the ACL at the same time on a network fs, could
that cause 30000 RPC calls to be transmitted for the same thing?

David

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
