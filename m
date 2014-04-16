Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7EF6F7F61
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 12:29:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 720B78F8033
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 10:29:32 -0700 (PDT)
Received: from zimbra13.linbit.com (zimbra13.linbit.com [212.69.166.240]) by
	cuda.sgi.com with ESMTP id FRHEmmxFQSz3Fx8U for
	<xfs@oss.sgi.com>; Wed, 16 Apr 2014 10:29:30 -0700 (PDT)
Date: Wed, 16 Apr 2014 19:29:29 +0200 (CEST)
From: Andreas Gruenbacher <andreas.gruenbacher@linbit.com>
Message-ID: <359356562.473582.1397669369258.JavaMail.zimbra@linbit.com>
In-Reply-To: <20140416111402.GA32350@infradead.org>
References: <1397071311-28371-1-git-send-email-bfoster@redhat.com>
	<1397071311-28371-2-git-send-email-bfoster@redhat.com>
	<20140410102421.GA17641@infradead.org>
	<20140410121947.GA14124@bfoster.bfoster>
	<20140410122944.GA6579@infradead.org>
	<20140415175228.GE26404@infradead.org>
	<1188577823.463241.1397590262478.JavaMail.zimbra@linbit.com>
	<20140416111402.GA32350@infradead.org>
Subject: Re: [PATCH v2 1/2] xfs: fix tmpfile/selinux deadlock and initialize
	security/acl
MIME-Version: 1.0
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
Cc: linux-man@vger.kernel.org, Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com, linux-security-module@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Wed, Apr 16, 2014 at 04:14:02AM -0700, Christoph Hellwig wrote:
> On Tue, Apr 15, 2014 at 09:31:02PM +0200, Andreas Gruenbacher wrote:
> > from how O_TMPFILE is documented right now [*], creating such a file and
> > then linking it into the namespace is one of the obvious use cases.
> 
> Btw, I think the man page is wrong - given that the tmpfile is not
> visible in the namespace it is obviously not created in the directory.
> The directory passed in is just a handle for the filesystem it should be
> created in.

I don't agree.  If the file is created with O_TMPFILE | O_EXCL, it is clear
that the file will never be linked into the namespace.  Even then, there are
operations which are affected by the inode permissions and label of the
anonymous file, and those should still behave reasonably.  In this context,
I would expect them to behave as if the file was actually created in the
specified directory, not in the file system root or "nowhere" with no clearly
defined permissions and security label.

If the file is created without O_EXCL, then it is clear that the file can
later become part of the namespace.  In that case, I would also expect the
file to be initialized in the context of the specified directory.  The file
can then be filled with data, permissions and other attributes can be changed
if desired, and then the anonymous file can be linked into that directory.

> Michael, should I send you an update for this, or do you want to do it
> yourself as you can probably come up with better language anyway?
> 
> > The
> > intent seems to be to make it seem like the file was created and populated
> > atomically, possibly with inherited permissions and all.
> > I think this
> > behavior require that the O_TMPFILE file inherits from the directory it
> > was "created" in.
> > 
> > Adding code to achieve the effect of create-time inheritance at link
> > time, only for O_TMPFILE files or files without any links, doesn't seem 
> > reasonable to me: it would duplicate create code in the link code path,
> > and it would make it harder to override inherited permissions or labels.
> 
> Inheriting any ACL on creating an anonymous file seems utterly wrong.

Why?

> Inheriting on link seems somewhat more sensible and not too bad in terms
> of code, but very confusing in terms of semantics.  I think the best
> method is to make sure it simply does not inherit any ACL and document
> that clearly.

Again, this approach would make it almost impossible to use O_TMPFILE as a
way to atomically create and initialize a file with permission and security
label inheritance.  This would severely limit the usefulness of O_TMPFILE.

> > (Trying to fake inheritance by reimplementing it in user space seems like
> > a much worse idea still.)
> 
> We don't fake inheritance when linking any other file either.  And
> creating a file in a /tmp without any ACL and then linking it into the
> filesystem already is very common today.

Well, creating a file in /tmp and moving it somewhere else often doesn't even
work because of file system boundaries, and sometimes it simply is the wrong
thing to do:

When the intent is to "create a new file in a directory", such as when saving to
a new file in an editor, the result should be as if the file was actually
created in that directory.  Creating the file in /tmp and then moving it to
where it should end up is simply wrong.

When the intent is to "move a file from here to there", the file should keep
all its attributes, including permissions and security label. It should make no
difference in result whether the file could actually be moved or if it had to
be copied across file system boundaries.

Thanks,
Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
