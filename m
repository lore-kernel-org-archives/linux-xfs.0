Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C2C3B7F37
	for <xfs@oss.sgi.com>; Fri, 15 May 2015 02:19:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B4AA2304048
	for <xfs@oss.sgi.com>; Fri, 15 May 2015 00:19:01 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Zn2KomDo2GOliPmx (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 15 May 2015 00:18:57 -0700 (PDT)
Date: Fri, 15 May 2015 15:18:46 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] xfstests/common/renameat2: pass the renameat2 flags from
	_rename_tests to _rename_tests_source_dest
Message-ID: <20150515071845.GH1140@dhcp-13-216.nay.redhat.com>
References: <1430467867-5565-1-git-send-email-shhuiw@foxmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1430467867-5565-1-git-send-email-shhuiw@foxmail.com>
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
To: Wang Sheng-Hui <shhuiw@foxmail.com>
Cc: mszeredi@suse.cz, xfs@oss.sgi.com

On Fri, May 01, 2015 at 04:11:07PM +0800, Wang Sheng-Hui wrote:
> _rename_tests() records the 'flags' arg but doesn't pass it to
> _rename_tests_source_dest() in old code, thus any 'flags' to
> renameat2 is missed. Fix the missing.
> 
> Signed-off-by: Wang Sheng-Hui <shhuiw@foxmail.com>

Looks good to me.

Reviewed-by: Eryu Guan <eguan@redhat.com>

> ---
>  common/renameat2 | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/common/renameat2 b/common/renameat2
> index a335169..df2df2e 100644
> --- a/common/renameat2
> +++ b/common/renameat2
> @@ -78,6 +78,7 @@ _rename_tests_source_dest()
>  	local source=$1
>  	local dest=$2
>  	local options=$3
> +	local flags=$4
>  
>  	for stype in none regu symb dire tree; do
>  		for dtype in none regu symb dire tree; do
> @@ -107,11 +108,11 @@ _rename_tests()
>  	local flags=$2
>  
>  	#same directory renames
> -	_rename_tests_source_dest $testdir/src $testdir/dst     "samedir "
> +	_rename_tests_source_dest $testdir/src $testdir/dst     "samedir " $flags
>  
>  	#cross directory renames
>  	mkdir $testdir/x $testdir/y
> -	_rename_tests_source_dest $testdir/x/src $testdir/y/dst "crossdir"
> +	_rename_tests_source_dest $testdir/x/src $testdir/y/dst "crossdir" $flags
>  	rmdir $testdir/x $testdir/y
>  }
>  
> -- 
> 2.1.2
> 
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
