Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:47012 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726178AbfFTTxQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Jun 2019 15:53:16 -0400
Subject: Re: [PATCH 11/12] libxfs-diff: try harder to find the kernel
 equivalent libxfs files
References: <156104936953.1172531.2121427277342917243.stgit@magnolia>
 <156104944022.1172531.15814499652713220817.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <2721bbee-5ff4-4016-f18a-5008e86ad4ab@sandeen.net>
Date: Thu, 20 Jun 2019 14:53:14 -0500
MIME-Version: 1.0
In-Reply-To: <156104944022.1172531.15814499652713220817.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 6/20/19 11:50 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Now that we're syncing userspace libxfs/ files with kernel fs/xfs/
> files, teach the diff tool to try fs/xfs/xfs_foo.c if
> fs/xfs/libxfs/xfs_foo.c doesn't exist.

do we really need this or should I just send a patch for the kernel
to move it?

-Eric

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  tools/libxfs-diff |    1 +
>  1 file changed, 1 insertion(+)
> 
> 
> diff --git a/tools/libxfs-diff b/tools/libxfs-diff
> index fa57c004..c18ad487 100755
> --- a/tools/libxfs-diff
> +++ b/tools/libxfs-diff
> @@ -22,5 +22,6 @@ dir="$(readlink -m "${dir}/..")"
>  
>  for i in libxfs/xfs*.[ch]; do
>  	kfile="${dir}/$i"
> +	test -f "${kfile}" || kfile="$(echo "${kfile}" | sed -e 's|libxfs/||g')"
>  	diff -Naurpw --label "$i" <(sed -e '/#include/d' "$i") --label "${kfile}" <(sed -e '/#include/d' "${kfile}")
>  done
> 
