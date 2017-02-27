Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40102 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751571AbdB0U2I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Feb 2017 15:28:08 -0500
Date: Mon, 27 Feb 2017 12:27:55 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Why does fsck.xfs not do what xfs_repair -n does?
Message-ID: <20170227202755.GB5297@birch.djwong.org>
References: <bfb182d9-a005-2d9f-355e-0d785c87c116@gmx.net>
 <20170227081636.2evil6tpv75o5ldw@eorzea.usersys.redhat.com>
 <20170227182646.GO31264@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170227182646.GO31264@wotan.suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Marcel Partap <mpartap@gmx.net>, linux-xfs@vger.kernel.org

On Mon, Feb 27, 2017 at 07:26:46PM +0100, Luis R. Rodriguez wrote:
> On Mon, Feb 27, 2017 at 09:16:36AM +0100, Carlos Maiolino wrote:
> > On Fri, Feb 24, 2017 at 09:49:17PM +0100, Marcel Partap wrote:
> > > Dear XFS dev crew,
> > > > fsck.xfs(8)
> > > >         fsck.xfs - do nothing, successfully
> > > >         If you wish to check the consistency of an XFS filesystem, or repair a damaged or corrupt XFS filesystem, see xfs_repair(8).
> > > 
> > > So there's a FS check command that does not work as with all the other
> > > filesystems. Instead of checking the FS, it tells you to use xfs_repair
> > > both for - XFS repair.. and XFS check. Whereas in the man page of
> > > > xfs_repair - repair an XFS filesystem
> > > it doesn't tell you right at the top that xfs_repair can check XFS. Instead
> > > > *       -n     No modify mode. Specifies that xfs_repair should […]  *scan  the  filesystem*
> > 
> > Xfs used to have two different tools for that. xfs_check and xfs_repair. This
> > required one more tool, several more lines of code to be maintained, while
> > xfs_repair does the check job with '-n' option, so, it was decided to deprecate
> > xfs_check and keep efforts only in xfs_repair.
> 
> A symlink to xfs_check and a check for the alias would have sufficed to keep the
> old interface while sharing code. That can be considered should folks agree this
> desirable and should be a few lines of code.

Yuck.

xfs_check does not (and has never had) the ability to repair anything.
so fsck.xfs should /never/ point to it.

Furthermore, xfs_repair was designed to work around the scalability
problems that exist in the bitrotting xfs_check codebase.  In other
words, _repair superseded _check long ago.  These days _check implements
the bare minimum it needs to get by on a v5 filesystem without blowing
up xfstests, which is afaict the sole remaining _check user.

As for boot time checking, XFS stores logical in-core updates in its
journal (unlike ext[34]|ocfs2 which store physical blocks in their
journal), which means that the log replay only works in-kernel on the
same type of machine that wrote the journal.  Therefore, running fsck at
boot time because we crashed is pointless because xfs_repair cannot
replay the journal.  Nor can xfs_check.

I admit that fsck.xfs doing essentially nothing is weird, but it /does/
tell you to go run xfs_repair if you really mean it.  It's unfortunate
that there really are two use-cases here -- boot scripts running
fsck.xfs (in which case we really do want to do nothing) and the admin
running fsck.xfs (in which case the current behavior is clunky).

This may become even less important once online fsck stabilizes,
though I'm putting the cart way ahead of the horse on that one. :)

--D

> 
>   Luis
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
