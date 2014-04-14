Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 401337F4E
	for <xfs@oss.sgi.com>; Sun, 13 Apr 2014 19:14:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 193488F8037
	for <xfs@oss.sgi.com>; Sun, 13 Apr 2014 17:14:14 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	tLYOyve8YGK8c9yz for <xfs@oss.sgi.com>;
	Sun, 13 Apr 2014 17:14:13 -0700 (PDT)
Date: Mon, 14 Apr 2014 10:14:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] generic/237: fix filtering for expected failure
	message
Message-ID: <20140414001408.GC27694@dastard>
References: <1397343317-14669-1-git-send-email-tytso@mit.edu>
	<1397343317-14669-4-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1397343317-14669-4-git-send-email-tytso@mit.edu>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Theodore Ts'o <tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com

On Sat, Apr 12, 2014 at 06:55:17PM -0400, Theodore Ts'o wrote:
> Newer kernels return EACCES instead of EPERM when modifying an acl
> fails.  Update the filtering to handle this.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  tests/generic/237     | 2 +-
>  tests/generic/237.out | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tests/generic/237 b/tests/generic/237
> index 6a61ec8..b068150 100755
> --- a/tests/generic/237
> +++ b/tests/generic/237
> @@ -68,7 +68,7 @@ touch file1
>  chown $acl1.$acl1 file1
>  
>  echo "Expect to FAIL"
> -$runas -u $acl2 -g $acl2 -- `which setfacl` -m u::rwx file1 2>&1 | sed 's/^setfacl: \/.*file1: Operation not permitted$/setfacl: file1: Operation not permitted/'
> +$runas -u $acl2 -g $acl2 -- `which setfacl` -m u::rwx file1 2>&1 | sed -e 's/Permission denied/Operation not permitted/' -e 's/file1: //' -e 's,[/a-zA-Z]*setfacl: ,setfacl: ,'

This is getting unweildy. Can you factor this into a local
_filter_setfacl_error function of some kind? It would also help if
you put a comment iterating all the different output formats it's
now trying to filter out, too.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
