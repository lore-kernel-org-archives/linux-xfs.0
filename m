Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C7B787F50
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 11:36:08 -0600 (CST)
Message-ID: <530CD48B.5000100@sgi.com>
Date: Tue, 25 Feb 2014 11:36:11 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_metadump: include F in getopts string
References: <530CC371.8030005@redhat.com>
In-Reply-To: <530CC371.8030005@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Boris Ranto <branto@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 02/25/14 10:23, Eric Sandeen wrote:
> I added an F case, but didn't add it to the bash
> getopts string last go-round.
>
> /usr/sbin/xfs_metadump: illegal option -- F
>
> I sure thought I tested this, I'm not sure how it got lost.
>
> Reported-by: Boris Ranto<branto@redhat.com>
> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
> ---
>
> diff --git a/db/xfs_metadump.sh b/db/xfs_metadump.sh
> index 7ce7a6d..71f579d 100755
> --- a/db/xfs_metadump.sh
> +++ b/db/xfs_metadump.sh
> @@ -7,7 +7,7 @@ OPTS=" "
>   DBOPTS=" "
>   USAGE="Usage: xfs_metadump [-efFogwV] [-m max_extents] [-l logdev] source target"
>
> -while getopts "efgl:m:owV" c
> +while getopts "efgl:m:owFV" c
>   do
>   	case $c in
>   	e)	OPTS=$OPTS"-e ";;

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
