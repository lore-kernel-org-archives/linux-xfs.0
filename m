Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:35933 "EHLO
        mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751496AbdEGWSP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 7 May 2017 18:18:15 -0400
Received: by mail-it0-f43.google.com with SMTP id o5so56506743ith.1
        for <linux-xfs@vger.kernel.org>; Sun, 07 May 2017 15:18:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170507155855.GD5970@birch.djwong.org>
References: <20170507155855.GD5970@birch.djwong.org>
From: Jann Horn <jannh@google.com>
Date: Mon, 8 May 2017 00:17:53 +0200
Message-ID: <CAG48ez1AWewJRg8gySgihn0y15jRhC6C+5DNwGsDpAhtokB=Lw@mail.gmail.com>
Subject: Re: [PATCH] ioctl_getfsmap.2: document the GETFSMAP ioctl
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Michael Kerrisk-manpages <mtk.manpages@gmail.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, linux-man@vger.kernel.org

On Sun, May 7, 2017 at 5:58 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> Document the new GETFSMAP ioctl that returns the physical layout of a
> (disk-based) filesystem.
[...]
> +.B EPERM
> +This query is not allowed.

Please document the circumstances under which a query is allowed.

Also: From a quick glance at the XFS implementation, I don't see any
privilege checks. Am I missing something, or does this API permit an
unprivileged user to determine the number of physical blocks allocated
for any inode, even for inodes the user can't ordinarily see in any
way?
