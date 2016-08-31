Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 75D6D7CA0
	for <xfs@oss.sgi.com>; Tue, 30 Aug 2016 19:01:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2B77D8F8052
	for <xfs@oss.sgi.com>; Tue, 30 Aug 2016 17:01:29 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	iCevv1LF95TPEwAW for <xfs@oss.sgi.com>;
	Tue, 30 Aug 2016 17:01:27 -0700 (PDT)
Date: Wed, 31 Aug 2016 10:00:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs/187: fix new sb_features2 ftype stop case running
Message-ID: <20160831000051.GV22388@dastard>
References: <1472542532-16497-1-git-send-email-zlang@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1472542532-16497-1-git-send-email-zlang@redhat.com>
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
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com

On Tue, Aug 30, 2016 at 03:35:32PM +0800, Zorro Lang wrote:
> This case is too old, at that time there's no "ftype" feature for
> XFS. Due to this case need to clear features2 bits when mkfs.xfs,
> so ftype bit stop case running for long time.
> 
> We care 6 features2 bits in this case:
> 
>   "ATTR2, LAZYSBCOUNT, PROJID32BIT, CRC, FTYPE, FINOBT"
> 
> ATTR2 and LAZYSBCOUNT bits will be tested in case. FINBOT will be
> disabled if CRC=0. So this patch only check and disable PROJID32BIT,
> CRC and FTYPE features when mkfs.xfs.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---
> 
> Hi,
> 
> I think we shouldn't skip this case if user doesn't specify suitable
> MKFS_OPTIONS and MOUNT_OPTIONS. Because this case need complex options,
> nearly no one will specify these all options for xfstests at same time.
> 
> Thanks,
> Zorro
> 
>  tests/xfs/187 | 51 ++++++++++++++++++++++++++++-----------------------
>  1 file changed, 28 insertions(+), 23 deletions(-)
> 
> diff --git a/tests/xfs/187 b/tests/xfs/187
> index 836b924..5e7c677 100755
> --- a/tests/xfs/187
> +++ b/tests/xfs/187
> @@ -31,7 +31,6 @@ seq=`basename $0`
>  seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
> -here=`pwd`
>  tmp=/tmp/$$
>  status=1	# failure is the default!
>  trap "_cleanup; exit \$status" 0 1 2 3 15
> @@ -58,24 +57,32 @@ _supported_os Linux
>  
>  _require_scratch
>  _require_attrs
> -_require_attr_v1
> -_require_projid16bit
>  
>  rm -f $seqres.full
> -
> +_scratch_mkfs >/dev/null 2>&1
>  # Reset the options so that we can control what is going on here
> -export MKFS_OPTIONS=""
> -export MOUNT_OPTIONS=""
> -
> -# lazysb, attr2 and other feature bits are held in features2 and will require
> -# morebitsbit on So test with lazysb and without it to see if the morebitsbit is
> -# okay etc. If the mkfs defaults change, these need to change as well.
> -export MKFS_NO_LAZY="-m crc=0 -l lazy-count=0 -i projid32bit=0"
> -export MKFS_LAZY="-m crc=0 -l lazy-count=1 -i projid32bit=0"
> +MKFS_OPTIONS=""
> +MOUNT_OPTIONS=""
> +ver2=`$XFS_DB_PROG -c version $SCRATCH_DEV | sed -n -e "s/,/ /g" \
> +						   -e "s/.*MOREBITS\(.*\)/\1/p"`
> +# clear features2 bits which we won't test
> +for b in $ver2; do
> +	case $b in
> +	CRC)
> +		MKFS_OPTIONS="$MKFS_OPTIONS -m crc=0"
> +		;;
> +	PROJID32BIT)
> +		MKFS_OPTIONS="$MKFS_OPTIONS -i projid32bit=0"
> +		;;
> +	FTYPE)
> +		MKFS_OPTIONS="$MKFS_OPTIONS -n ftype=0"
> +		;;
> +	esac
> +done

We're doing stuff like this in way too many places to keep old tests
working with new xfsprogs as the defaults change and new options are
added. This is not maintainable in the long run.

I think we need to start marking test as requiring "old" filesystem
formats, and we configure the mkfs options required to create such a
filesystem in one place.

i.e. add a rule:

_require_old_xfs_format()
{
	# calculate necessary additional options to ensure
	# 16 bit project id, no CRCs, and no ftype.
	BASIC_MKFS_OPTIONS=.....

	# add "old" option to default mkfs option set
	export MKFS_OPTION=S"$MKFS_OPTIONS $BASIC_MKFS_OPTIONS"
}

And now any specific test that relies on a format not having CRCs,
ftype, etc, can simply _require_old_xfs_format(), and so we can
get rid of all the per-test magic we have to futz mkfs options into
the "old" format the test requires.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
