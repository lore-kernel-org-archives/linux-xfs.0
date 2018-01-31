Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:52957 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753270AbeAaQqm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Jan 2018 11:46:42 -0500
MIME-Version: 1.0
In-Reply-To: <1517401762.3612.0.camel@kernel.org>
References: <20180130173126.2806-1-jlayton@kernel.org> <20180130203221.29310-1-jlayton@kernel.org>
 <CA+55aFw5Xf4V-BF1JK+SpjXnmrgeMe-k0wLaFc_=6ojbhfWEtQ@mail.gmail.com> <1517401762.3612.0.camel@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 31 Jan 2018 08:46:41 -0800
Message-ID: <CA+55aFxB6og=iRkRchiOrr8EW2=jgb_i4nUiPsvEa+8F64APxA@mail.gmail.com>
Subject: Re: [PATCH v2] iversion: make inode_cmp_iversion{+raw} return bool
 instead of s64
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@kernel.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, linux-xfs <linux-xfs@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, linux-integrity <linux-integrity@vger.kernel.org>, Trond Myklebust <trondmy@primarydata.com>

On Wed, Jan 31, 2018 at 4:29 AM, Jeff Layton <jlayton@kernel.org> wrote:
>
> Do you mind just taking it directly? I don't have anything else queued
> up for this cycle.

Done.

I wonder if "false for same, true for different" calling convention
makes much sense, but it matches the old "0 for same" so obviously
makes for a smaller diff.

If it ever ends up confusing people, maybe the sense of that function
should be reversed, and the name changed to something like
"same_inode_version()" or something.

But at least for now the situation seems ok to me,

            Linus
