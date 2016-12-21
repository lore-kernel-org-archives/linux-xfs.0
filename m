Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:33708 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751257AbcLUVgF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Dec 2016 16:36:05 -0500
Date: Wed, 21 Dec 2016 13:36:01 -0800
From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH v4 6/6] generic: test for weaknesses in filesystem
 encryption
Message-ID: <20161221213601.GB136777@gmail.com>
References: <1481833585-39148-1-git-send-email-ebiggers3@gmail.com>
 <1481833585-39148-7-git-send-email-ebiggers3@gmail.com>
 <20161219072628.GC1859@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161219072628.GC1859@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: fstests@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Richard Weinberger <richard@nod.at>, David Gstir <david@sigma-star.at>, Michael Halcrow <mhalcrow@google.com>, Eric Sandeen <sandeen@redhat.com>, Eric Biggers <ebiggers@google.com>, linux-xfs@vger.kernel.org

On Mon, Dec 19, 2016 at 03:26:28PM +0800, Eryu Guan wrote:
> 
> Can you please send an updated patch 6/6? Otherwise the whole series
> look good to me! I'm going to let the patchset sit in the list for
> another week and push them out to upstream in next fstests update, if
> there's no further comments from others.
> 
> Thanks,
> Eryu

I just changed patch 6/6 but I went ahead and sent out v5 of the series so that
people don't mix up the different patches.

+Cc linux-xfs@vger.kernel.org

Also, would it be possible to get the xfs_io patch merged into xfsprogs at about
the same time?  Ultimately, both the xfstests and xfsprogs changes are needed to
run the new tests; without the xfsprogs change they'll all be skipped.

Thanks,

Eric
