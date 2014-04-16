Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 04BCD7F5D
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 06:14:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E09D18F8066
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 04:14:07 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id MjOiNU53AbplHaGH (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 16 Apr 2014 04:14:06 -0700 (PDT)
Date: Wed, 16 Apr 2014 04:14:02 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 1/2] xfs: fix tmpfile/selinux deadlock and initialize
	security/acl
Message-ID: <20140416111402.GA32350@infradead.org>
References: <1397071311-28371-1-git-send-email-bfoster@redhat.com>
	<1397071311-28371-2-git-send-email-bfoster@redhat.com>
	<20140410102421.GA17641@infradead.org>
	<20140410121947.GA14124@bfoster.bfoster>
	<20140410122944.GA6579@infradead.org>
	<20140415175228.GE26404@infradead.org>
	<1188577823.463241.1397590262478.JavaMail.zimbra@linbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1188577823.463241.1397590262478.JavaMail.zimbra@linbit.com>
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
Cc: linux-man@vger.kernel.org, Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com, linux-security-module@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Tue, Apr 15, 2014 at 09:31:02PM +0200, Andreas Gruenbacher wrote:
> from how O_TMPFILE is documented right now [*], creating such a file and
> then linking it into the namespace is one of the obvious use cases.

Btw, I think the man page is wrong - given that the tmpfile is not
visible in the namespace it is obviously not created in the directory.
The directory passed in is just a handle for the filesystem it should be
created in.

Michael, should I send you an update for this, or do you want to do it
yourself as you can probably come up with better language anyway?

> The
> intent seems to be to make it seem like the file was created and populated
> atomically, possibly with inherited permissions and all.
> I think this
> behavior require that the O_TMPFILE file inherits from the directory it
> was "created" in.
> 
> Adding code to achieve the effect of create-time inheritance at link
> time, only for O_TMPFILE files or files without any links, doesn't seem 
> reasonable to me: it would duplicate create code in the link code path,
> and it would make it harder to override inherited permissions or labels.

Inheriting any ACL on creating an anonymous file seems utterly wrong.
Inheriting on link seems somewhat more sensible and not too bad in terms
of code, but very confusing in terms of semantics.  I think the best
method is to make sure it simply does not inherit any ACL and document
that clearly.

> (Trying to fake inheritance by reimplementing it in user space seems like
> a much worse idea still.)

We don't fake inheritance when linking any other file either.  And
creating a file in a /tmp without any ACL and then linking it into the
filesystem already is very common today.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
