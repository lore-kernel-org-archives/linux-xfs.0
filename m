Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0DC517CAF
	for <xfs@oss.sgi.com>; Tue, 15 Mar 2016 02:19:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D21578F804C
	for <xfs@oss.sgi.com>; Tue, 15 Mar 2016 00:19:15 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id ysjZ1RL7TBFsgURf (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 15 Mar 2016 00:19:13 -0700 (PDT)
Date: Tue, 15 Mar 2016 00:18:54 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v18 21/22] ext4: Add richacl support
Message-ID: <20160315071854.GG19747@infradead.org>
References: <1456733847-17982-1-git-send-email-agruenba@redhat.com>
	<1456733847-17982-22-git-send-email-agruenba@redhat.com>
	<20160311142719.GG14808@infradead.org>
	<CAHc6FU64SzTN23LMzGcPex=jRz_Euwb_CHrW=kX+A5sn8=SFSg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAHc6FU64SzTN23LMzGcPex=jRz_Euwb_CHrW=kX+A5sn8=SFSg@mail.gmail.com>
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

On Mon, Mar 14, 2016 at 02:02:33PM +0100, Andreas Gruenbacher wrote:
> On Fri, Mar 11, 2016 at 3:27 PM, Christoph Hellwig <hch@infradead.org> wrote:
> >> +static inline int
> >> +ext4_acl_chmod(struct inode *inode, umode_t mode)
> >> +{
> >> +     if (IS_RICHACL(inode))
> >> +             return richacl_chmod(inode, inode->i_mode);
> >> +     return posix_acl_chmod(inode, inode->i_mode);
> >> +}
> >
> > Thi isn't ext4-specific and potentially duplicated in every caller.
> > Please provide this as a common helper.
> 
> This can go in neither fs.h nor posix_acl.h nor richacl.h unless we
> turn it into a macro, and I don't think we want to add a new header
> file for such extreme trivia.

I'd expect us to grow a few more of thos helper if we get the sharing
right (either a real common base object, or wrappers for anything
dealing with the acl pointers in the inode), so a new linux/acl.h
should be fine.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
