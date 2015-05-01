Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CBEBF7F47
	for <xfs@oss.sgi.com>; Fri,  1 May 2015 03:07:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5A416AC002
	for <xfs@oss.sgi.com>; Fri,  1 May 2015 01:07:50 -0700 (PDT)
Received: from smtpbg298.qq.com (smtpbg298.qq.com [184.105.67.102]) by
	cuda.sgi.com with ESMTP id W3XxQNURO3lNBvfo (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 01 May 2015 01:07:48 -0700 (PDT)
Message-ID: <55433443.1010606@foxmail.com>
Date: Fri, 01 May 2015 16:07:31 +0800
From: shhuiw <shhuiw@foxmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests/common/renameat2: pass the renameat2 flags from
	_rename_tests, to _rename_tests_source_dest
References: <55433293.7070301@foxmail.com>
In-Reply-To: <55433293.7070301@foxmail.com>
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
To: mszeredi@suse.cz, dchinner@redhat.com, david@fromorbit.com, xfs@oss.sgi.com

On 05/01/2015 04:00 PM, shhuiw wrote:
> 
> _rename_tests() recognizes the 'flags' arg but doesn't pass it to
> _rename_tests_source_dest() in old code, thus any 'flags' to
> renameat2 is missed. Fix the missing.
> 
> Signed-off-by: Wang Sheng-Hui <shhuiw@foxmail.com>
> ---
>  common/renameat2 | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/common/renameat2 b/common/renameat2
> index a335169..df2df2e 100644
> --- a/common/renameat2
> +++ b/common/renameat2
> @@ -78,6 +78,7 @@ _rename_tests_source_dest()
>         local source=$1
>         local dest=$2
>         local options=$3
> +       local flags=$4
> 
>         for stype in none regu symb dire tree; do
>                 for dtype in none regu symb dire tree; do
> @@ -107,11 +108,11 @@ _rename_tests()
>         local flags=$2
> 
>         #same directory renames
> -       _rename_tests_source_dest $testdir/src $testdir/dst     "samedir "
> +       _rename_tests_source_dest $testdir/src $testdir/dst     "samedir
> " $flags
> 
>         #cross directory renames
>         mkdir $testdir/x $testdir/y
> -       _rename_tests_source_dest $testdir/x/src $testdir/y/dst "crossdir"
> +       _rename_tests_source_dest $testdir/x/src $testdir/y/dst
> "crossdir" $flags
>         rmdir $testdir/x $testdir/y
>  }
> 

Sorry, this patch seems get corrupted by my mail client.
Will resend it.

Regards,
Sheng-Hui

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
