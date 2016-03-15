Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 95F617CAF
	for <xfs@oss.sgi.com>; Tue, 15 Mar 2016 02:17:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EAF46AC001
	for <xfs@oss.sgi.com>; Tue, 15 Mar 2016 00:17:22 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id TzxwZrk6mLzItXoP (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 15 Mar 2016 00:17:21 -0700 (PDT)
Date: Tue, 15 Mar 2016 00:17:07 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v18 21/22] ext4: Add richacl support
Message-ID: <20160315071707.GF19747@infradead.org>
References: <1456733847-17982-1-git-send-email-agruenba@redhat.com>
	<1456733847-17982-22-git-send-email-agruenba@redhat.com>
	<20160311142719.GG14808@infradead.org>
	<CAHc6FU4TVKKYr-apCNTuR3aWAHpv7wZJ7ixePfy0Qt2VA49TZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAHc6FU4TVKKYr-apCNTuR3aWAHpv7wZJ7ixePfy0Qt2VA49TZQ@mail.gmail.com>
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
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, linux-cifs@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, LKML <linux-kernel@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, linux-ext4 <linux-ext4@vger.kernel.org>, Anna Schumaker <anna.schumaker@netapp.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

On Mon, Mar 14, 2016 at 12:08:31AM +0100, Andreas Gruenbacher wrote:
> The xattr representation is the same on disk and at the xattr syscall
> layer, and so richacl_from_xattr is used for converting into the
> in-memory representation in both cases. The error codes are not the
> same when a user supplies an invalid value via setxattr or NFS and
> when an invalid xattr is read from disk though. I'll add a parameter
> to richacl_from_xattr to make this more explicit.

Better add a wrapper instead of a parameter.

> 
> >> +static int
> >> +__ext4_set_richacl(handle_t *handle, struct inode *inode, struct richacl *acl)
> >> +{
> >> +     const int name_index = EXT4_XATTR_INDEX_RICHACL;
> >> +     umode_t mode = inode->i_mode;
> >> +     int retval, size;
> >> +     void *value;
> >> +
> >> +     if (richacl_equiv_mode(acl, &mode) == 0) {
> >> +             inode->i_ctime = ext4_current_time(inode);
> >> +             inode->i_mode = mode;
> >> +             ext4_mark_inode_dirty(handle, inode);
> >> +             return __ext4_remove_richacl(handle, inode);
> >> +     }
> >
> > Should this check for a NULL acl instead of special casing that
> > in ext4_set_richacl?
> 
> I'm not sure I understand what you mean. When the

ext4_set_richacl checks for a NULL acl pointer and then calls into
__ext4_remove_richacl.  I'd rather have that special casing in one
place.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
