Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42016 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751393AbdEELcY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 May 2017 07:32:24 -0400
Date: Fri, 5 May 2017 13:32:19 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: XFS and multiple mounts protection (aka preventing multiple
 mounts)
Message-ID: <20170505113219.dovbzhbmt6e3ooem@eorzea.usersys.redhat.com>
References: <3cf2f8cd-d18f-2a65-c540-5527a366d2fb@assyoma.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3cf2f8cd-d18f-2a65-c540-5527a366d2fb@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Gionatan Danti <g.danti@assyoma.it>
Cc: linux-xfs@vger.kernel.org

On Fri, May 05, 2017 at 12:29:46PM +0200, Gionatan Danti wrote:
> Hi all,
> I have a question about multiple mounts protection in XFS.
> 
> On the iSCSI list, discussing how to avoid accidental multiple mounts, I
> received the following advise: "Use XFS. XFS won't let you mount it several
> time on different machines without various "force" options."
> 
> I just tried mounting an exported iSCSI disk formatted with XFS and I *can*
> mount it concurrently on two different Linux boxes (both CentOS 7.3 x86-64).
> 

This is not true, XFS can't identify mounts on different systems. It is not a
shared or clustered filesystem.

At the worst case, it would need to store something to disk saying the
filesystem is already mounted, and the mount process would need to read it
before actually mounting the filesystem. Nothing though would prevent a race
between two systems, or even make the filesystem unmountable after a crash,
needing something like xfs_repair to clean some "is_mounted" flag, which would
trash one of the reasons why we have a journal (fast recovery without needing an
fsck before mounting).


> I am missing something?
> Thanks.
> 
> -- 
> Danti Gionatan
> Supporto Tecnico
> Assyoma S.r.l. - www.assyoma.it
> email: g.danti@assyoma.it - info@assyoma.it
> GPG public key ID: FF5F32A8
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
