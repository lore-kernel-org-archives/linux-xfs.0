Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CD71F7F3F
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 12:55:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9BD728F8059
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 10:55:29 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id JgdDqbQXHjCmSitb for <xfs@oss.sgi.com>;
	Tue, 29 Oct 2013 10:55:28 -0700 (PDT)
Message-ID: <526FF68E.9070500@sandeen.net>
Date: Tue, 29 Oct 2013 12:55:26 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: generic/317 318 need procfs uid_map/gid_map
	support
References: <1383049068-3020-1-git-send-email-eguan@redhat.com>
In-Reply-To: <1383049068-3020-1-git-send-email-eguan@redhat.com>
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
To: Eryu Guan <eguan@redhat.com>, xfs@oss.sgi.com

On 10/29/13 7:17 AM, Eryu Guan wrote:
> generic/317 and 318 need /proc/<pid>/[uid_map|gid_map], test fail on
> older kernels without that support.
> 
> Add a _require_ugid_map() function and called by 317 and 318.
> 
> Signed-off-by: Eryu Guan <eguan@redhat.com>
> ---

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

>  common/rc         | 10 ++++++++++
>  tests/generic/317 |  1 +
>  tests/generic/318 |  1 +
>  3 files changed, 12 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index b5eb582..ea3af12 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2142,6 +2142,16 @@ _require_dumpe2fs()
>  	fi
>  }
>  
> +_require_ugid_map()
> +{
> +	if [ ! -e /proc/self/uid_map ]; then
> +		_notrun "This test requires procfs uid_map support."
> +	fi
> +	if [ ! -e /proc/self/gid_map ]; then
> +		_notrun "This test requires procfs gid_map support."
> +	fi
> +}
> +
>  _create_loop_device()
>  {
>  	file=$1
> diff --git a/tests/generic/317 b/tests/generic/317
> index 6d8d3c4..c042f79 100644
> --- a/tests/generic/317
> +++ b/tests/generic/317
> @@ -63,6 +63,7 @@ rm -f $seqres.full
>  _require_scratch
>  _need_to_be_root
>  _require_user
> +_require_ugid_map
>  qa_user_id=`grep $qa_user /etc/passwd |awk -F: '{print $3}'`
>  
>  _filter_output()
> diff --git a/tests/generic/318 b/tests/generic/318
> index d3bce51..3e8eb50 100755
> --- a/tests/generic/318
> +++ b/tests/generic/318
> @@ -63,6 +63,7 @@ _require_scratch
>  _need_to_be_root
>  _acl_setup_ids
>  _require_acls
> +_require_ugid_map
>  
>  _print_getfacls()
>  {
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
