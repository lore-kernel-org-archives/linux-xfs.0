Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A6A5A7CA4
	for <xfs@oss.sgi.com>; Tue, 15 Mar 2016 02:11:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6AF588F809C
	for <xfs@oss.sgi.com>; Tue, 15 Mar 2016 00:11:09 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id QXGAJF4QlWog1LlE (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 15 Mar 2016 00:11:06 -0700 (PDT)
Date: Tue, 15 Mar 2016 00:10:14 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v18 19/22] richacl: Add richacl xattr handler
Message-ID: <20160315071014.GB19747@infradead.org>
References: <1456733847-17982-1-git-send-email-agruenba@redhat.com>
	<1456733847-17982-20-git-send-email-agruenba@redhat.com>
	<20160311141735.GF14808@infradead.org>
	<20160311141905.GC13178@fieldses.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160311141905.GC13178@fieldses.org>
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
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Andreas Gruenbacher <agruenba@redhat.com>, linux-api@vger.kernel.org, Trond Myklebust <trond.myklebust@primarydata.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@poochiereds.net>, linux-ext4@vger.kernel.org, Anna Schumaker <anna.schumaker@netapp.com>

On Fri, Mar 11, 2016 at 09:19:05AM -0500, J. Bruce Fields wrote:
> On Fri, Mar 11, 2016 at 06:17:35AM -0800, Christoph Hellwig wrote:
> > On Mon, Feb 29, 2016 at 09:17:24AM +0100, Andreas Gruenbacher wrote:
> > > Add richacl xattr handler implementing the xattr operations based on the
> > > get_richacl and set_richacl inode operations.
> > 
> > Given all the issues with Posix ACLs and selinux attributes these really
> > should be proper syscalls instead of abusing the xattr interface.
> 
> What are those problems exactly?

That people get confused between the attr used by the xattr syscall
interface and the attr used to store things on disk or the protocol.
This has happened every time we have non-native support, e.g. XFS, NFS,
CIFS, ntfs, etc.  And it's only going to become worse.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
