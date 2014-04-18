Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BC6AE7F54
	for <xfs@oss.sgi.com>; Fri, 18 Apr 2014 11:39:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4670CAC009
	for <xfs@oss.sgi.com>; Fri, 18 Apr 2014 09:39:28 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id YVKMVxa8h7TjlPes (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 18 Apr 2014 09:39:23 -0700 (PDT)
Date: Fri, 18 Apr 2014 09:39:20 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 1/2] xfs: fix tmpfile/selinux deadlock and initialize
	security/acl
Message-ID: <20140418163920.GB13808@infradead.org>
References: <1397071311-28371-1-git-send-email-bfoster@redhat.com>
	<1397071311-28371-2-git-send-email-bfoster@redhat.com>
	<20140410102421.GA17641@infradead.org>
	<20140410121947.GA14124@bfoster.bfoster>
	<20140410122944.GA6579@infradead.org>
	<20140415175228.GE26404@infradead.org>
	<1188577823.463241.1397590262478.JavaMail.zimbra@linbit.com>
	<20140416111402.GA32350@infradead.org>
	<359356562.473582.1397669369258.JavaMail.zimbra@linbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <359356562.473582.1397669369258.JavaMail.zimbra@linbit.com>
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
To: Andreas Gruenbacher <andreas.gruenbacher@linbit.com>
Cc: linux-man@vger.kernel.org, Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-security-module@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Wed, Apr 16, 2014 at 07:29:29PM +0200, Andreas Gruenbacher wrote:
> > Btw, I think the man page is wrong - given that the tmpfile is not
> > visible in the namespace it is obviously not created in the directory.
> > The directory passed in is just a handle for the filesystem it should be
> > created in.
> 
> I don't agree.  If the file is created with O_TMPFILE | O_EXCL, it is clear
> that the file will never be linked into the namespace.  Even then, there are
> operations which are affected by the inode permissions and label of the
> anonymous file, and those should still behave reasonably.  In this context,
> I would expect them to behave as if the file was actually created in the
> specified directory, not in the file system root or "nowhere" with no clearly
> defined permissions and security label.

So you want to define the files as being in a directory, but not
actually visible?  That's defintively a new and strange state to be in.

> > Inheriting any ACL on creating an anonymous file seems utterly wrong.
> 
> Why?

Because it has no parent to inherit it from.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
