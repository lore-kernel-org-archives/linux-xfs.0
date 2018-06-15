Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:36792 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965119AbeFOAOg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Jun 2018 20:14:36 -0400
Received: by mail-wm0-f44.google.com with SMTP id v131-v6so853278wma.1
        for <linux-xfs@vger.kernel.org>; Thu, 14 Jun 2018 17:14:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180613094048.6becmt42cvdhvg66@odin.usersys.redhat.com>
References: <CA+Xn3kwTnu8yd-DCy37323waPgNm0jNuL9NDhz8s8pY023COSw@mail.gmail.com>
 <20180612143608.ok3jqtl3l34vdlpy@odin.usersys.redhat.com> <CA+Xn3kyxiOj+irNiqKWQWfJ_aUv1RYFsH+UCnv3gnMuYJ=oUQw@mail.gmail.com>
 <20180613094048.6becmt42cvdhvg66@odin.usersys.redhat.com>
From: Ilya Pronin <ipronin@twitter.com>
Date: Thu, 14 Jun 2018 17:14:34 -0700
Message-ID: <CA+Xn3kzsrqjNH2yXdtfsRuiCBfvX2GSWOW2SaLPL4h1PmQsGBg@mail.gmail.com>
Subject: Re: Reading/changing projid of a symlink
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, Carlos Maiolino <cmaiolino@redhat.com>

Thanks everyone for the answers!

On Wed, Jun 13, 2018 at 2:40 AM, Carlos Maiolino <cmaiolino@redhat.com> wrote:
> The symlink's project id, will always be related to the project id of its parent
> directory.
>
> At the end, Project quota, is a way to create a directory tree based quota,
> where all inodes corresponding to a single project id, should be under the same
> subtree. If you are creating a new subtree, under an already existing project
> id, IMHO, the right approach would be to remove the project id from the old
> directory tree, and add it to the new tree, and use user/group quotas for any
> quota accounting that should be done filesystem-wide (instead of directory tree
> wise).

It's a bit weird though that a symlink can inherit project ID from its
parent directory, but then cannot get rid of it :) And thus doesn't
allow to completely remove the project ID from the directory tree it's
in.

-- 
Ilya Pronin
