Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B5A827F66
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 10:44:36 -0500 (CDT)
Message-ID: <513F4D76.5000600@sgi.com>
Date: Tue, 12 Mar 2013 10:44:54 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_repair: remove unconditional ASSERT(0)
References: <513F40AD.10303@sandeen.net>
In-Reply-To: <513F40AD.10303@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>


On 03/12/2013 09:50 AM, Eric Sandeen wrote:
> I don't know what I was thinking in 7e8e3cc, but I added an
> ASSERT(0) in the main path.  Obviously this isn't right.
>
> Just remove it.
>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>
> Really sorry, no idea what is up w/ my brain lately.
> Trying to do too many things at once, too quickly.
>
I can relate.  Thanks for the quick fix.

Looks good:

Reviewed-by: Rich Johnston <rjohnston@sgi.com>

This has been committed.

Thanks
--Rich

commit b326e067f1005d584bd8ad21bb9f3e2700230e29
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Tue Mar 12 14:50:21 2013 +0000

     xfsprogs xfs_repair: remove unconditional ASSERT(0)

     I don't know what I was thinking in 7e8e3cc, but I added an
     ASSERT(0) in the main path.  Obviously this isn't right.

     Just remove it.

     Signed-off-by: Eric Sandeen <sandeen@redhat.com>
     Reviewed-by: Rich Johnston <rjohnston@sgi.com>
     Signed-off-by: Rich Johnston <rjohnston@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
