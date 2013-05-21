Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 516C829DF8
	for <xfs@oss.sgi.com>; Tue, 21 May 2013 00:21:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3A908304032
	for <xfs@oss.sgi.com>; Mon, 20 May 2013 22:21:24 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Kah7ZrG2ODiRWmnK for <xfs@oss.sgi.com>;
	Mon, 20 May 2013 22:21:22 -0700 (PDT)
Date: Tue, 21 May 2013 15:21:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests comma separated group names
Message-ID: <20130521052118.GM24543@dastard>
References: <CANW9uytRpGXcd9x=HWMEoFvd3_9G98CN_Tv3YacTtd1h+Gq=4g@mail.gmail.com>
	<20130520113045.GB24543@dastard>
	<CANW9uytQDPaBr_VAGMuwSqhStCfyMCGmV_A3ccNzOExi-KeZfQ@mail.gmail.com>
	<20130521004553.GL24543@dastard>
	<CANW9uyvUgS6i+z0iUtyuJDe2YhbtnVYmYs87xB74=fJCMuG06Q@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CANW9uyvUgS6i+z0iUtyuJDe2YhbtnVYmYs87xB74=fJCMuG06Q@mail.gmail.com>
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
To: Itaru Kitayama <itaru.kitayama@gmail.com>
Cc: xfs@oss.sgi.com

On Tue, May 21, 2013 at 12:45:32PM +0900, Itaru Kitayama wrote:
> In the current check script the -g option assumes only one group is given.
> With this patch, the -g option
> understands comma separated multiple groups as the argument as well.
> Existing scripts are not affected
> by this patch.
> 
> Reviewed-by: Dave Chinner <david@redhat.com>

No, I didn't. A comment on a patch is not a review.

The only time you should add tags like this is if you receive them
in email from the person in question. Once I've actaully done a
review of the code, I'll respond with such a tag. See
Documentation/SubmittingPatches for more information about what the
reviewed-by tag actually means...

> Signed-off-by: Itaru Kitayama <itaru.kitayama@gmail.com>
> 
> ---
> 
>  check |   23 ++++++++++++-----------
>  1 file changed, 12 insertions(+), 11 deletions(-)
> 
> diff --git a/check b/check
> index a79747e..0e0f208 100755
> --- a/check
> +++ b/check
> @@ -164,18 +164,19 @@ while [ $# -gt 0 ]; do
>         -nfs)   FSTYP=nfs ;;
> 
>         -g)     group=$2 ; shift ;
> -               group_list=$(get_group_list $group)
> -               if [ -z "$group_list" ]; then
> -                   echo "Group \"$group\" is empty or not defined?"
> -                   exit 1
> -               fi
> -
> -               [ ! -s $tmp.list ] && touch $tmp.list
> -               for t in $group_list; do
> -                       grep -s "^$t\$" $tmp.list >/dev/null || \
> -                                                       echo "$t"
> >>$tmp.list

There's a whitespace and wrapping problem with your mailer. it's
converting all tabs to spaces, and it's wrapping long lines in the
patch. Please see Documentation/email-clients.txt for help to set
your mailer up properly.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
