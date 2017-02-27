Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57420 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751617AbdB0IQl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 27 Feb 2017 03:16:41 -0500
Date: Mon, 27 Feb 2017 09:16:36 +0100
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: Why does fsck.xfs not do what xfs_repair -n does?
Message-ID: <20170227081636.2evil6tpv75o5ldw@eorzea.usersys.redhat.com>
References: <bfb182d9-a005-2d9f-355e-0d785c87c116@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bfb182d9-a005-2d9f-355e-0d785c87c116@gmx.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Marcel Partap <mpartap@gmx.net>
Cc: linux-xfs@vger.kernel.org

On Fri, Feb 24, 2017 at 09:49:17PM +0100, Marcel Partap wrote:
> Dear XFS dev crew,
> > fsck.xfs(8)
> >         fsck.xfs - do nothing, successfully
> >         If you wish to check the consistency of an XFS filesystem, or repair a damaged or corrupt XFS filesystem, see xfs_repair(8).
> 
> So there's a FS check command that does not work as with all the other filesystems. Instead of checking the FS, it tells you to use xfs_repair both for - XFS repair.. and XFS check. Whereas in the man page of
> > xfs_repair - repair an XFS filesystem
> it doesn't tell you right at the top that xfs_repair can check XFS. Instead
> > *       -n     No modify mode. Specifies that xfs_repair should […]  *scan  the  filesystem*

Xfs used to have two different tools for that. xfs_check and xfs_repair. This
required one more tool, several more lines of code to be maintained, while
xfs_repair does the check job with '-n' option, so, it was decided to deprecate
xfs_check and keep efforts only in xfs_repair.

> 
> Is this imperative? It does not make any sense to me apart from the quirk.
> 
I am not quite sure what you mean by "imperative" here, but most (if not all)
repair tools, have a dry-run mode with -n, as so, xfs_repair also does. The name
of xfs tool is also kept due historical reasons, once, AFAIK, xfs_repair is the
name for the tool since its beginning.

If you believe that the first description of xfs_repair's man page, should say
something like "check and repair an XFS filesystem", feel free to send a patch
for that, IMHO I really don't see any reason for that, giving that the main goal
of such tools are to fix filesystem inconsistencies.

Cheers

-- 
Carlos
