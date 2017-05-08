Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42256 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751855AbdEHSlS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 May 2017 14:41:18 -0400
Date: Mon, 8 May 2017 11:41:12 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] ioctl_getfsmap.2: document the GETFSMAP ioctl
Message-ID: <20170508184112.GJ5973@birch.djwong.org>
References: <20170507155855.GD5970@birch.djwong.org>
 <CAG48ez1AWewJRg8gySgihn0y15jRhC6C+5DNwGsDpAhtokB=Lw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez1AWewJRg8gySgihn0y15jRhC6C+5DNwGsDpAhtokB=Lw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jann Horn <jannh@google.com>
Cc: Michael Kerrisk-manpages <mtk.manpages@gmail.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, linux-man@vger.kernel.org

On Mon, May 08, 2017 at 12:17:53AM +0200, Jann Horn wrote:
> On Sun, May 7, 2017 at 5:58 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > Document the new GETFSMAP ioctl that returns the physical layout of a
> > (disk-based) filesystem.
> [...]
> > +.B EPERM
> > +This query is not allowed.
> 
> Please document the circumstances under which a query is allowed.

For the two current implementations, queries are always allowed.

(The doc could be more explicit about this decision being left to the
implementation.)

> Also: From a quick glance at the XFS implementation, I don't see any
> privilege checks. Am I missing something, or does this API permit an
> unprivileged user to determine the number of physical blocks allocated
> for any inode, even for inodes the user can't ordinarily see in any
> way?

Correct.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
