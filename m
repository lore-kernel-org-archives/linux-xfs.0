Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 601687CA1
	for <xfs@oss.sgi.com>; Fri, 11 Mar 2016 08:19:08 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2FFB5304048
	for <xfs@oss.sgi.com>; Fri, 11 Mar 2016 06:19:08 -0800 (PST)
Received: from fieldses.org (fieldses.org [173.255.197.46]) by cuda.sgi.com
	with ESMTP id EM8ImUykuWOQx6qJ for <xfs@oss.sgi.com>;
	Fri, 11 Mar 2016 06:19:06 -0800 (PST)
Date: Fri, 11 Mar 2016 09:19:05 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH v18 19/22] richacl: Add richacl xattr handler
Message-ID: <20160311141905.GC13178@fieldses.org>
References: <1456733847-17982-1-git-send-email-agruenba@redhat.com>
	<1456733847-17982-20-git-send-email-agruenba@redhat.com>
	<20160311141735.GF14808@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160311141735.GF14808@infradead.org>
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
Cc: linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Andreas Gruenbacher <agruenba@redhat.com>, linux-api@vger.kernel.org, Trond Myklebust <trond.myklebust@primarydata.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@poochiereds.net>, linux-ext4@vger.kernel.org, Anna Schumaker <anna.schumaker@netapp.com>

On Fri, Mar 11, 2016 at 06:17:35AM -0800, Christoph Hellwig wrote:
> On Mon, Feb 29, 2016 at 09:17:24AM +0100, Andreas Gruenbacher wrote:
> > Add richacl xattr handler implementing the xattr operations based on the
> > get_richacl and set_richacl inode operations.
> 
> Given all the issues with Posix ACLs and selinux attributes these really
> should be proper syscalls instead of abusing the xattr interface.

What are those problems exactly?

--b.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
