Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DA44A7F37
	for <xfs@oss.sgi.com>; Tue, 27 Oct 2015 16:39:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 70A5AAC004
	for <xfs@oss.sgi.com>; Tue, 27 Oct 2015 14:39:55 -0700 (PDT)
Received: from mail-lf0-f54.google.com (mail-lf0-f54.google.com
	[209.85.215.54]) by cuda.sgi.com with ESMTP id VHdedAykNz4aC4S3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 27 Oct 2015 14:39:53 -0700 (PDT)
Received: by lffz202 with SMTP id z202so179425459lff.3
	for <xfs@oss.sgi.com>; Tue, 27 Oct 2015 14:39:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20151027201825.GO8773@dastard>
References: <CAHc6FU5gS4BA+iTRHo1oHJMVHkLs4aa0eYd5T1ftLC9biRaxrg@mail.gmail.com>
	<20151024125659.GA8095@bfoster.bfoster>
	<CAHc6FU6eVn=KpKvhD2N8hvAgdFQVdBHHS9tUgaVQJf5wnipY=g@mail.gmail.com>
	<20151024152254.GA22232@bfoster.bfoster>
	<20151026213228.GI8773@dastard>
	<CAHc6FU68MYTGWKM5S14_dQBqXeebd2GwQcKj4RztLvPWL2eksA@mail.gmail.com>
	<20151027053045.GL8773@dastard>
	<CAHc6FU4ZgJDKphScucvDfEWPFFu4dGfDVund9Wrah=X-vxnz3w@mail.gmail.com>
	<20151027201825.GO8773@dastard>
Date: Tue, 27 Oct 2015 22:39:51 +0100
Message-ID: <CAHc6FU4dXfXyTBW2GgckeqaLGuUwney32orV6=M8VA+ix5h1Uw@mail.gmail.com>
Subject: Re: Inconsistencies with trusted.SGI_ACL_{FILE,DEFAULT}
From: Andreas Gruenbacher <agruenba@redhat.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Tue, Oct 27, 2015 at 9:18 PM, Dave Chinner <david@fromorbit.com> wrote:
> Further, user namespaces are irrelevant here - you can't run
> xfsdump/restore outside the init_ns.  xfsdump requires access to the
> handle interface, which is unsafe to use inside a user ns because it
> allows complete access to any inode in the filesystem without
> limitations. xfs_restore requires unfettered access to directly
> manipulate the uid/gid/security attrs of inodes, which once again is
> something that isn't allowed inside user namespaces.
>
> Setting Posix acls by directly poking the on-disk attr format rather
> than going through the proper kernel ACL namespace is not a *general
> purpose user interface*.  Thi exists for backup/restore utilities to
> do things like restore ACLs and security labels simply by treating
> them as opaque xattrs.  If a user sets ACLs using this low level
> "opaque xattr" method, then they get to keep all the broken bits to
> themselves.

Any process capable of CAP_SYS_ADMIN can getxattr and setxattr those
xattrs, it doesn't matter whether it's xfsdump/restore or something
else. Some will mess with those attributes simply because listxattr
lists them and so they will get and set them like all other
attributes. Setting those attributes must not leave the system in an
inconsistent state, independent of what xfsdump/restore happens to do
with them.

Thanks,
Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
