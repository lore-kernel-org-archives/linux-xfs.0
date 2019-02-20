Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37254 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725826AbfBTN2e (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 Feb 2019 08:28:34 -0500
Date: Wed, 20 Feb 2019 14:29:52 +0100
From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 4/3] generic: posix acl extended attribute memory
 corruption test
Message-ID: <20190220132952.GW9874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <154993784038.1948.7502664832930298472.stgit@magnolia>
 <20190213204814.GB6477@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190213204814.GB6477@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: guaneryu@gmail.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Wed, Feb 13, 2019 at 12:48:14PM -0800, Darrick J. Wong wrote:
> --- /dev/null
> +++ b/src/t_attr_corruption.c
> @@ -0,0 +1,122 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * Copyright (C) 2019 Oracle.  All Rights Reserved.
> + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> + *
> + * Test program to tickle a use-after-free bug in xfs.
> + *
> + * XFS had a use-after-free bug when xfs_xattr_put_listent runs out of
> + * listxattr buffer space while trying to store the name
> + * "system.posix_acl_access" and then corrupts memory by not checking the
> + * seen_enough state and then trying to shove "trusted.SGI_ACL_FILE" into the
> + * buffer as well.
> + *
> + * In order to tickle the bug in a user visible way we must have already put a
> + * name in the buffer, so we take advantage of the fact that "security.evm"
> + * sorts before "system.posix_acl_access" to make sure this happens.
> + *
> + * If we trigger the bug, the program will print the garbled string
> + * "rusted.SGI_ACL_FILE".  If the bug is fixed, the flistxattr call returns
> + * ERANGE.
> + */
> +#include <sys/types.h>
> +#include <sys/stat.h>
> +#include <fcntl.h>
> +#include <stdlib.h>
> +#include <stdio.h>
> +#include <string.h>
> +#include <stdint.h>
> +#include <unistd.h>
> +#include <attr/xattr.h>

This does not compile on some systems, sys/xattr.h works (it's provided
by glibc) and is also used by other fstests' sources. I'm not sure where
does attr/xattr.h come from, my devel package for libattr provides only
attr/libattr.h.
