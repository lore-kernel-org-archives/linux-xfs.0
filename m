Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 845377F37
	for <xfs@oss.sgi.com>; Wed, 29 May 2013 11:21:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 70CF7304059
	for <xfs@oss.sgi.com>; Wed, 29 May 2013 09:21:18 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id QCsAP8JJIqYsjuCu for <xfs@oss.sgi.com>;
	Wed, 29 May 2013 09:21:17 -0700 (PDT)
Message-ID: <51A62AFC.9050704@sandeen.net>
Date: Wed, 29 May 2013 11:21:16 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: add missing colon in _filter_ln
References: <1369842106-9869-1-git-send-email-eguan@redhat.com>
In-Reply-To: <1369842106-9869-1-git-send-email-eguan@redhat.com>
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
To: Eryu Guan <eguan@redhat.com>
Cc: xfs@oss.sgi.com

On 5/29/13 10:41 AM, Eryu Guan wrote:
> On distros with older coreutils(eg. RHEL5) generic/294 fails like
> 
>     -ln: creating symbolic link `SCRATCH_MNT/294.test/testlink': File exists
>     +ln: creating symbolic link `SCRATCH_MNT/294.test/testlink'File exists
> 
> _filter_ln ate the ": ". xfs/103 has similar issue. Add ": " back.

Ok, so older coreutils does i.e.:

ln: creating symbolic link `b' to `a': File exists

and newer:

ln: creating symbolic link `b': File exists

We want to convert the older output to the newer, by removing the " to `a'" part.

Seems like my sed script is the long way around that ;)

Still, looks like your fix does the right thing, thanks.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

-Eric

> Signed-off-by: Eryu Guan <eguan@redhat.com>
> ---
>  common/filter | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/common/filter b/common/filter
> index bdd6427..dbb1674 100644
> --- a/common/filter
> +++ b/common/filter
> @@ -243,7 +243,7 @@ _filter_spaces()
>  # Account for different "ln" failure messages
>  _filter_ln()
>  {
> -	sed -e "s,\(creating symbolic link .*\) to .*: ,\1," \
> +	sed -e "s,\(creating symbolic link .*\) to .*: ,\1: ," \
>  	    -e "s,failed to create,creating,"
>  }
>  
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
