Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C7ED87F63
	for <xfs@oss.sgi.com>; Sun, 19 Jan 2014 20:13:59 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8D97C8F8035
	for <xfs@oss.sgi.com>; Sun, 19 Jan 2014 18:13:56 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	LNIRuDdWkSo4vmH2 for <xfs@oss.sgi.com>;
	Sun, 19 Jan 2014 18:13:51 -0800 (PST)
Date: Mon, 20 Jan 2014 13:13:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/5] xfstests: use value of FSTYP if defined externally
Message-ID: <20140120021345.GG18112@dastard>
References: <cover.1389891730.git.dsterba@suse.cz>
	<efafb76f725148435b09a22c62c92a63eedb9b71.1389891730.git.dsterba@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <efafb76f725148435b09a22c62c92a63eedb9b71.1389891730.git.dsterba@suse.cz>
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
To: David Sterba <dsterba@suse.cz>
Cc: xfs@oss.sgi.com

On Thu, Jan 16, 2014 at 06:07:12PM +0100, David Sterba wrote:
> The initial value of FSTYP is unconditionally set to 'xfs' and the
> filesystem type is taken from the TEST_DEV. This could lead to confusion
> if the device hasn't been formatted yet, eg. an empty image in VM, or
> a different test setup took place before.
> 
> Now one can specify the desired FSTYP in advance and be safe. If unset,
> the fallback to TEST_DEV type continues to work.
> 
> Signed-off-by: David Sterba <dsterba@suse.cz>
> ---
>  README | 3 +++
>  check  | 7 ++++---
>  2 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/README b/README
> index a49ca7c3ff15..62974ef87b89 100644
> --- a/README
> +++ b/README
> @@ -65,6 +65,9 @@ Preparing system for tests (IRIX and Linux):
>                 environment variable set to "yes" will enable their use.
>               - setenv DIFF_LENGTH "number of diff lines to print from a failed test",
>                 by default 10, set to 0 to print the full diff
> +             - setenv FSTYP "the filesystem you want to test", the filesystem
> +               type is devised from the TEST_DEV device, but you may want to
> +               override it
>          - or add a case to the switch in common/config assigning
>            these variables based on the hostname of your test
>            machine
> diff --git a/check b/check
> index 320ad26b7c2c..9e4275b1fa37 100755
> --- a/check
> +++ b/check
> @@ -33,7 +33,7 @@ showme=false
>  have_test_arg=false
>  randomize=false
>  here=`pwd`
> -FSTYP=xfs
> +FSTYP=${FSTYP:-xfs}

":-xfs" means assign the value of $xfs if $FTYPE is null. xfs is not
a variable....

>  xfile=""
>  
>  # start the initialisation work now
> @@ -57,8 +57,9 @@ then
>      exit 1
>  fi
>  
> -# Autodetect fs type based on what's on $TEST_DEV
> -if [ "$HOSTOS" == "Linux" ]; then
> +# Autodetect fs type based on what's on $TEST_DEV unless it's been set
> +# externally
> +if [ -z "$FSTYP" -a "$HOSTOS" == "Linux" ]; then

If the default value expansion is fixed, FSTYP will always have a
value here Hence it will never, ever probe.

>      FSTYP=`blkid -c /dev/null -s TYPE -o value $TEST_DEV`
>  fi
>  export FSTYP

I suspect what you want is:

-FSTYP=xfs

.....

if [ -z "$FSTYP" -a "$HOSTOS" == "Linux" ]; then
     FSTYP=`blkid -c /dev/null -s TYPE -o value $TEST_DEV`
fi
FSTYP=${FSTYP:=xfs}
export FSTYP

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
