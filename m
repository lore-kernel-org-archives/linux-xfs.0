Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 017B97F52
	for <xfs@oss.sgi.com>; Fri,  2 Aug 2013 18:48:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DC8D08F8037
	for <xfs@oss.sgi.com>; Fri,  2 Aug 2013 16:48:25 -0700 (PDT)
Received: from e9.ny.us.ibm.com (e9.ny.us.ibm.com [32.97.182.139]) by
	cuda.sgi.com with ESMTP id gaTEco8W2ZSZJEcP (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 02 Aug 2013 16:48:24 -0700 (PDT)
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Fri, 2 Aug 2013 19:48:22 -0400
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 84E3DC90026
	for <xfs@oss.sgi.com>; Fri,  2 Aug 2013 19:48:19 -0400 (EDT)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r72NmLha37224450
	for <xfs@oss.sgi.com>; Fri, 2 Aug 2013 19:48:21 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	r72NmKVR003181 for <xfs@oss.sgi.com>; Fri, 2 Aug 2013 19:48:20 -0400
Subject: Re: [PATCH 01/10 v2] xfstests: Run all tests when nothing is specified
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <1373539085-8577-2-git-send-email-lczerner@redhat.com>
References: <1373539085-8577-1-git-send-email-lczerner@redhat.com>
	<1373539085-8577-2-git-send-email-lczerner@redhat.com>
Date: Fri, 02 Aug 2013 18:48:19 -0500
Message-ID: <1375487299.4155.68.camel@chandra-dt.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, 2013-07-11 at 12:37 +0200, Lukas Czerner wrote:

small nits. Otherwise,

Reviewed-by: Chandra Seetharaman <sekharan@us.ibm.com>

> Currently when no tests or test groups is specified xfstests will
s/is/are/

> silently test nothing. Interestingly enough when test groups to exclude
> is specified the rest of the tests will be run.
s/is/are/

> 
> This commit changes that to run all possible tests (for a given file
> system) when no specific tests has been specified. This matches the old
> xfstests behaviour.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  check | 6 +++---
>  group | 5 -----
>  2 files changed, 3 insertions(+), 8 deletions(-)
>  delete mode 100644 group
> 
> diff --git a/check b/check
> index ff8fbcf..71b179b 100755
> --- a/check
> +++ b/check
> @@ -115,7 +115,7 @@ get_all_tests()
>  	for d in $SRC_GROUPS $FSTYP; do
>  		ls $SRC_DIR/$d/* | \
>  			grep -v "\..*" | \
> -			grep -v group >> $tmp.list 2>/dev/null
> +			grep -v "group\|Makefile" >> $tmp.list 2>/dev/null
>  	done
>  }
> 
> @@ -263,8 +263,8 @@ elif $have_test_arg; then
>  	# had test numbers, but none in group file ... do nothing
>  	touch $tmp.list
>  else
> -	# no test numbers, do everything from group file
> -	sed -n -e '/^[0-9][0-9][0-9]*/s/[ 	].*//p' <group >$tmp.list
> +	# no test numbers, do everything
> +	get_all_tests
>  fi
> 
>  # sort the list of tests into numeric order
> diff --git a/group b/group
> deleted file mode 100644
> index 4e01f0c..0000000
> --- a/group
> +++ /dev/null
> @@ -1,5 +0,0 @@
> -# QA groups control file
> -# Defines test groups and nominal group owners
> -# - do not start group names with a digit
> -# - comment line before each group is "new" description
> -#


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
