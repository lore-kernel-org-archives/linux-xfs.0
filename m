Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0440F7F58
	for <xfs@oss.sgi.com>; Tue, 23 Jul 2013 23:38:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E67DB304067
	for <xfs@oss.sgi.com>; Tue, 23 Jul 2013 21:37:57 -0700 (PDT)
Received: from Ishtar.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id G8NwhqF72HoKTWSY (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 23 Jul 2013 21:37:55 -0700 (PDT)
Received: from [192.168.4.12] (Athenae [192.168.4.12])
	by Ishtar.tlinx.org (8.14.7/8.14.4/SuSE Linux 0.8) with ESMTP id
	r6O4boGk043724 for <xfs@oss.sgi.com>; Tue, 23 Jul 2013 21:37:52 -0700
Message-ID: <51EF5A1B.6020005@tlinx.org>
Date: Tue, 23 Jul 2013 21:37:47 -0700
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: BUG: ACL's are a security attribute. They belong in the Security
	attrib space, not the Root-attrib space.
References: <51EEF5C6.3050904@tlinx.org> <20130724040525.GQ19986@dastard>
In-Reply-To: <20130724040525.GQ19986@dastard>
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
Cc: xfs-oss <xfs@oss.sgi.com>



Dave Chinner wrote:
> On Tue, Jul 23, 2013 at 02:29:42PM -0700, Linda Walsh wrote:
> > Currently there are 3 disjoint attribute spaces on files -- user, root and security.
> >
> > (there is a misprint in the manual that says there is 2, but later, it gives
> > talks about using no switch giving the User attrib space, -R for Root attrib
> > space, and -S for the Security attrib space).
>
> You're confusing on-disk formats used to store attributes with
> namepaces used to report and access them.  Linux has security,
> system, trusted and user namespaces, while on disk XFS has "root",
> "secure",  and "user" spaces.
>
> i.e.
>
> Linux attr    XFS on disk
> system        root
> security    secure
> trusted        root
> user        user
-----
    That makes the man page even more dated...

Why don't we copy your explanation into the manpage!  It's certainly
more clear! ;-)


>
> > Of these, the ACL's are being placed in the root, which might describe
> > file types, or other OS related info, but not security attributes like ACL's.
> > They should be in the Security attrib space (otherwise what is the point of a
> > Security attribute space).
>
> Posix ACLS are defined by the *kernel* to be in the "system"
> namespace:
----
    Likely because the system namespace predates the secur[e/ity] namespace,
which seems like it might have been the timeframe that part in the "attr" manpage,
saying there were only 2 namespaces, was written?

>
> #define POSIX_ACL_XATTR_ACCESS  "system.posix_acl_access"
> #define POSIX_ACL_XATTR_DEFAULT "system.posix_acl_default"
>
> IOWs, the Linux *kernel* doesn't consider ACLs to be part of the
> security namespace, and so neither does XFS.
-----
    Well, of the kernel I can understand why ... and then it
makes sense that XFS would have followed the kernel through its
evolution...;-)

So that still leaves the Q's about the -l (--list) function no longer
being maitained, and the suggested alternates having no similar functionality
nor any for the 'root' or 'secur' namespaces.

Maybe not important, but sometimes linux security looks a bit like it is
partaking of
security through obscurity...or it could just be generally obscure engineer
writing...;-)







_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
