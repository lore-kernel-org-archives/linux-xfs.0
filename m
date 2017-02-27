Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38091 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751586AbdB0TNt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 27 Feb 2017 14:13:49 -0500
Date: Mon, 27 Feb 2017 19:26:46 +0100
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: Why does fsck.xfs not do what xfs_repair -n does?
Message-ID: <20170227182646.GO31264@wotan.suse.de>
References: <bfb182d9-a005-2d9f-355e-0d785c87c116@gmx.net>
 <20170227081636.2evil6tpv75o5ldw@eorzea.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170227081636.2evil6tpv75o5ldw@eorzea.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Marcel Partap <mpartap@gmx.net>, linux-xfs@vger.kernel.org

On Mon, Feb 27, 2017 at 09:16:36AM +0100, Carlos Maiolino wrote:
> On Fri, Feb 24, 2017 at 09:49:17PM +0100, Marcel Partap wrote:
> > Dear XFS dev crew,
> > > fsck.xfs(8)
> > >         fsck.xfs - do nothing, successfully
> > >         If you wish to check the consistency of an XFS filesystem, or repair a damaged or corrupt XFS filesystem, see xfs_repair(8).
> > 
> > So there's a FS check command that does not work as with all the other
> > filesystems. Instead of checking the FS, it tells you to use xfs_repair
> > both for - XFS repair.. and XFS check. Whereas in the man page of
> > > xfs_repair - repair an XFS filesystem
> > it doesn't tell you right at the top that xfs_repair can check XFS. Instead
> > > *       -n     No modify mode. Specifies that xfs_repair should […]  *scan  the  filesystem*
> 
> Xfs used to have two different tools for that. xfs_check and xfs_repair. This
> required one more tool, several more lines of code to be maintained, while
> xfs_repair does the check job with '-n' option, so, it was decided to deprecate
> xfs_check and keep efforts only in xfs_repair.

A symlink to xfs_check and a check for the alias would have sufficed to keep the
old interface while sharing code. That can be considered should folks agree this
desirable and should be a few lines of code.

  Luis
