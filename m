Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:36251 "EHLO
        mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754421AbdDEQjM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Apr 2017 12:39:12 -0400
MIME-Version: 1.0
In-Reply-To: <149140996132.27340.12936555593689822963.stgit@warthog.procyon.org.uk>
References: <149140993804.27340.4198614944626347024.stgit@warthog.procyon.org.uk>
 <149140996132.27340.12936555593689822963.stgit@warthog.procyon.org.uk>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 5 Apr 2017 19:39:11 +0300
Message-ID: <CAOQ4uxgsmKHZ85Qg__zhU13tb4ARLHHWzUoCEvEUE7LNYNnHnQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] xfstests: Check the stx_attributes settable by chattr
 [ver #7]
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Howells <dhowells@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, fstests <fstests@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Wed, Apr 5, 2017 at 7:32 PM, David Howells <dhowells@redhat.com> wrote:
> Check the stx_attributes that can be set by calling chattr.
>
> The script probes the filesystem with chattr to find out which of +a, +c,
> +d and +i are supported before testing combinations of attrs.  Note that if
> a filesystem supports chattr with these, but doesn't paste the flag values
> into stx_attributes, the test will fail as there's no way to distinguish
> cleared from unset.
>
> Certain chattr flags are reflected in specific stx_attributes flags:
>
>         chattr flag     stx_attributes flag
>         +a              STATX_ATTR_APPEND
>         +c              STATX_ATTR_COMPRESSED
>         +d              STATX_ATTR_NODUMP
>         +i              STATX_ATTR_IMMUTABLE
>
> Signed-off-by: David Howells <dhowells@redhat.com>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

I think you have an unintentional search&replace typo below.
I don't mind though.
Eryu is usually generous in offering to fix these sort of things at
commit time ;-)

> +#
> +#      $CHATTR_PROG flag       stx_attributes flag
> +#      +a              STATX_ATTR_APPEND
> +#      +c              STATX_ATTR_COMPRESSED
> +#      +d              STATX_ATTR_NODUMP
> +#      +i              STATX_ATTR_IMMUTABLE
> +#
