Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6BA0A7CBE
	for <xfs@oss.sgi.com>; Thu, 15 Aug 2013 11:33:13 -0500 (CDT)
Message-ID: <520D02ED.7000109@sgi.com>
Date: Thu, 15 Aug 2013 11:33:49 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: fix _mount_ops_filter() to support $TEST_DIR
	containing -o
References: <1372801497-3941-1-git-send-email-koen.de.wit@oracle.com>
In-Reply-To: <1372801497-3941-1-git-send-email-koen.de.wit@oracle.com>
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
To: Koen De Wit <koen.de.wit@oracle.com>
Cc: xfs@oss.sgi.com

On 07/02/2013 04:44 PM, Koen De Wit wrote:
> If multiple mount options are given with multiple -o parameters,
> _mount_ops_filter concatenates them by replacing all -o's with a comma
> (except for the first -o).
>
> If $TEST_DIR contains "-o" (e.g. /mnt/test-os/) you get errors like this:
>
>     # ./check generic/002
>       mount: mount point /mnt/test,s/ does not exist
>       common/rc: retrying test device mount with external set
>       mount: mount point /mnt/test,s/ does not exist
>       common/rc: could not mount /dev/sdc3 on /mnt/test-os/
>
> Fix it by only replacing -o's that are preceded by at least one space.
>
> Signed-off-by: Koen De Wit <koen.de.wit@oracle.com>
> ---
>   common/rc |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/common/rc b/common/rc
> index fe6bbfc..2a3c040 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -260,7 +260,7 @@ _mount_ops_filter()
>       # the sed script replaces all -o's (except the first) with a comma
>       # not required for linux, but won't hurt
>
> -    echo $params | sed -e 's/[[:space:]]*-o[[:space:]]*/UnIqUe/1; s/[[:space:]]*-o[[:space:]]*/,/g; s/UnIqUe/ -o /1' \
> +    echo $params | sed -e 's/[[:space:]]\+-o[[:space:]]*/UnIqUe/1; s/[[:space:]]\+-o[[:space:]]*/,/g; s/UnIqUe/ -o /1' \
>           | sed -e 's/dmapi/dmi/' \
>           | $PERL_PROG -ne "s#mtpt=[^,|^\n|^\s]*#mtpt=$FS_ESCAPED\1\2#; print;"
>
>
Sorry Koen I did not see this had been reviewed, thanks for the patch.
It has been committed.

--Rich

commit 74357dea4a975d2942163a2df7a527b57c46650b
Author: Koen De Wit <koen.de.wit@oracle.com>
Date:   Tue Jul 2 21:44:57 2013 +0000

     xfstests: fix _mount_ops_filter() to support $TEST_DIR containing -o


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
