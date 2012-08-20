Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7KLRTdm003502 for <xfs@oss.sgi.com>; Mon, 20 Aug 2012 16:27:29 -0500
Message-ID: <5032ABBD.80504@sgi.com>
Date: Mon, 20 Aug 2012 16:27:25 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [RFC] [PATCH 0/18] xfstests: move tests out of top level
References: <1343294892-20991-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1343294892-20991-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 07/26/12 04:27, Dave Chinner wrote:
> Alt-Subject: Games with Sed, Grep and Awk.
>
> This series is based on top of the large filesystem test series.
>
> This moves all the tests into a ./tests subdirectory, and sorts them into
> classes of related tests. Those are:
>
> 	tests/generic:	valid for all filesystems
> 	tests/shared:	valid for a limited number of filesystems
> 	tests/xfs:	xfs specific tests
> 	tests/btrfs	btrfs specific tests
> 	tests/ext4	ext4 specific tests
> 	tests/udf	udf specific tests

The SGI XFS group talked about your proposed changes to xfstests and the 
response is very positive.

The couple concerns are:

1) There is a consensus in the group that the benchmark framework
    should remain until there is a common benchmark available.

    Could the benchmark infrastructure be placed into its own directory
    until a new common benchmark framework has been adopted?

2) Could there be a single result directory rather than mirroring the
    test hierarchy? A single directory can eventually become uniquely
    identified and also be easier to upload to a result depository.


Lastly, there are a couple minor link issues:

1) In tests xfs/071, xfs/096 and generic/097 the links are missing the
    $RESULT_DIR and the links are being made on the top directory. For
    example in generic/097:

- rm -rf $seq.out
+ rm -rf $RESULT_DIR/$seq.out
if [ "$FSTYP" == "xfs" ]; then
-     ln -s $seq.out.xfs $seq.out
+     ln -s $RESULT_DIR/$seq.out.xfs $RESULT_DIR/$seq.out
else
-     ln -s -$seq.out.udf $seq.out
+     ln -s $RESULT_DIR/$seq.out.udf $RESULT_DIR/$seq.out
fi

2) In patch 18, the old link needs to be removed in _link_out_file()
    routine to prevent "File exists" errors on subsequent runs of the
    scripts.

  _link_out_file()
  {
-   if [ -z "$1" ]; then
-      echo Error must pass \$seq.
-      exit
-   fi
-   rm -f $1
-   if [ "`uname`" == "IRIX64" ] || [ "`uname`" == "IRIX" ]; then
-      ln -s $1.irix $1
-   elif [ "`uname`" == "Linux" ]; then
-      ln -s $1.linux $1
-   else
-      echo Error test $seq does not run on the operating system: `uname`
-      exit
-   fi
+	if [ -z "$1" -o -z "$2" ]; then
+		echo Error must pass src and dst.
+		exit
+	fi
+	rm -f $1
               ^^^ should that be $2?

Thank-you,

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
