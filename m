Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:45132 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754226AbeFUTcp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 Jun 2018 15:32:45 -0400
Subject: Re: [PATCH] xfs_bmap: don't reject -e
References: <20180621184945.GE4838@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <9abcfd43-7d1f-bc8f-299b-0d015c4f2241@sandeen.net>
Date: Thu, 21 Jun 2018 14:32:44 -0500
MIME-Version: 1.0
In-Reply-To: <20180621184945.GE4838@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On 6/21/18 1:49 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The xfs_io bmap command has an -e switch that prints delalloc extents
> without fsync'ing the file first.  The xfs_bmap manpage says it'll pass
> -e through, but it doesn't.  Fix the script and fix the weird manpage
> discrepancy where it doesn't list -e in the available options but
> discusses it anyway.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

need to fix it all up for "-c" as well, right?

and I think:

Fixes: 7536ce44f6 ("xfs_io: bmap should support querying CoW fork, shared blocks")

