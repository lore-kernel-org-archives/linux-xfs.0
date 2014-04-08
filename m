Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9B4E18149
	for <xfs@oss.sgi.com>; Tue,  8 Apr 2014 19:05:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8C9AE8F8092
	for <xfs@oss.sgi.com>; Tue,  8 Apr 2014 17:04:57 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	ZVYDjWsM5GFHSAFV for <xfs@oss.sgi.com>;
	Tue, 08 Apr 2014 17:04:42 -0700 (PDT)
Date: Wed, 9 Apr 2014 09:43:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstest: log operations properly to generic/001.full
Message-ID: <20140408234354.GM27017@dastard>
References: <CAG+wggbx13tnYB=J8q83oK72td2VV=V1Fg=-q3JnZb=5tCgCSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAG+wggbx13tnYB=J8q83oK72td2VV=V1Fg=-q3JnZb=5tCgCSQ@mail.gmail.com>
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
To: Ming Chen <v.mingchen@gmail.com>
Cc: Erez Zadok <ezk@fsl.cs.sunysb.edu>, xfs@oss.sgi.com

On Sat, Apr 05, 2014 at 01:52:43AM -0400, Ming Chen wrote:
> Part of the operations were written to 001.full from the awk script, while the
> rest were piped to 001.full using tee.  The resultant 001.full did not reflect
> what are really performed.  This makes debugging difficult.
> 
> Signed-off-by: Ming Chen <v.mingchen@gmail.com>
> ---
>  tests/generic/001 | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/tests/generic/001 b/tests/generic/001
> index 6e5f3dd..e1142ed 100755
> --- a/tests/generic/001
> +++ b/tests/generic/001
> @@ -190,7 +190,7 @@ _mark_iteration()
>  #
>  _chain()
>  {
> -    $AWK_PROG -v full_file=$seqres.full -v verify=$verify <$tmp.config '
> +    $AWK_PROG -v verify=$verify <$tmp.config '
>  BEGIN  { nfile = 0 }
>  /^\#/  { next }
>         { file[nfile] = $1
> @@ -210,7 +210,7 @@ END { srand('$iter')
>                 printf "if [ ! -f %s ]; then echo \"%s missing!\";
> exit; fi\n",file[j],file[j]
>                 printf "if [ -f %s.0 ]; then echo \"%s.0 already
> present!\"; exit; fi\n",file[j],file[j]

Your mailer program has line wrapped the patch and converted all the
tabs to spaces. I've fixed it up this time, but please read the
Documentation/SubmittingPatches file in the kernel tree to learn how
to prevent this from happening in future.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
