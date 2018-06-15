Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f170.google.com ([209.85.128.170]:43619 "EHLO
        mail-wr0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755566AbeFOHId (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Jun 2018 03:08:33 -0400
Received: by mail-wr0-f170.google.com with SMTP id d2-v6so8802272wrm.10
        for <linux-xfs@vger.kernel.org>; Fri, 15 Jun 2018 00:08:32 -0700 (PDT)
Date: Fri, 15 Jun 2018 09:08:29 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: Reading/changing projid of a symlink
Message-ID: <20180615070829.m5ligybzlods4l5r@odin.usersys.redhat.com>
References: <CA+Xn3kwTnu8yd-DCy37323waPgNm0jNuL9NDhz8s8pY023COSw@mail.gmail.com>
 <20180612143608.ok3jqtl3l34vdlpy@odin.usersys.redhat.com>
 <CA+Xn3kyxiOj+irNiqKWQWfJ_aUv1RYFsH+UCnv3gnMuYJ=oUQw@mail.gmail.com>
 <20180613094048.6becmt42cvdhvg66@odin.usersys.redhat.com>
 <CA+Xn3kzsrqjNH2yXdtfsRuiCBfvX2GSWOW2SaLPL4h1PmQsGBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+Xn3kzsrqjNH2yXdtfsRuiCBfvX2GSWOW2SaLPL4h1PmQsGBg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ilya Pronin <ipronin@twitter.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jun 14, 2018 at 05:14:34PM -0700, Ilya Pronin wrote:
> Thanks everyone for the answers!
> 
> On Wed, Jun 13, 2018 at 2:40 AM, Carlos Maiolino <cmaiolino@redhat.com> wrote:
> > The symlink's project id, will always be related to the project id of its parent
> > directory.
> >
> > At the end, Project quota, is a way to create a directory tree based quota,
> > where all inodes corresponding to a single project id, should be under the same
> > subtree. If you are creating a new subtree, under an already existing project
> > id, IMHO, the right approach would be to remove the project id from the old
> > directory tree, and add it to the new tree, and use user/group quotas for any
> > quota accounting that should be done filesystem-wide (instead of directory tree
> > wise).
> 
> It's a bit weird though that a symlink can inherit project ID from its
> parent directory,

Well, yes, a symlink occupy an inode, and so, we need to account for it, in case
for example, you limit inode creation in the project id.

> but then cannot get rid of it :) And thus doesn't
> allow to completely remove the project ID from the directory tree it's
> in.

Once you move the symlink out of the project subtree, the project id will be
removed or updated to the new project id (in case its new place belongs to
another project id).

As I said before, IMHO, I believe the way you are using project quotas is wrong.
Project quotas is supposed to be used on a sub-tree based granularity, not on a
file based granularity. But again, that's just my opinion.

> 
> -- 
> Ilya Pronin

-- 
Carlos
