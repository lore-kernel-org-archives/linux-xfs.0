Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [150.166.39.100])
	by oss.sgi.com (Postfix) with ESMTP id 819107F5D
	for <xfs@oss.sgi.com>; Fri, 22 Mar 2013 11:52:00 -0500 (CDT)
Date: Fri, 22 Mar 2013 09:51:59 -0700
From: Phil White <pwhite@sgi.com>
Subject: Re: [PATCH 01/25] xfstests: remove remake script
Message-ID: <20130322165158.GB25253@caliban.engr.sgi.com>
References: <1363350489-22257-1-git-send-email-david@fromorbit.com>
	<1363350489-22257-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1363350489-22257-2-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Fine by me.

Reviewed-by: Phil White <pwhite@sgi.com>

On Fri, Mar 15, 2013 at 11:27:45PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We don't ever do wholesale rebuilds of the output files anymore, so
> kill the script that does it to reduce the dependency on common and
> common.rc.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  remake |   72 ----------------------------------------------------------------
>  1 file changed, 72 deletions(-)
>  delete mode 100755 remake
> 
> diff --git a/remake b/remake
> deleted file mode 100755
> index a95aae7..0000000
> --- a/remake
> +++ /dev/null
> @@ -1,72 +0,0 @@
> -#! /bin/bash
> -#
> -# Copyright (c) 2000-2001 Silicon Graphics, Inc.  All Rights Reserved.
> -#
> -# This program is free software; you can redistribute it and/or
> -# modify it under the terms of the GNU General Public License as
> -# published by the Free Software Foundation.
> -#
> -# This program is distributed in the hope that it would be useful,
> -# but WITHOUT ANY WARRANTY; without even the implied warranty of
> -# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> -# GNU General Public License for more details.
> -#
> -# You should have received a copy of the GNU General Public License
> -# along with this program; if not, write the Free Software Foundation,
> -# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> -#
> -#
> -# Rebuild NNN.out files
> -#
> -# $Header: /build2/depot/linux/pcp/dev/qa/RCS/remake,v 2.11 1999/09/20 03:42:19 kenmcd Exp $
> -#
> -
> -tmp=/tmp/$$
> -trap "rm -f NO-PREVIOUS-OUTPUT $tmp.*; exit" 0 1 2 3 15
> -
> -# generic initialization
> -iam=remake
> -. ./common.rc
> -
> -. ./common
> -
> -[ -f check.time ] || touch check.time
> -
> -for seq in $list
> -do
> -    if [ ! -f $seq ]
> -    then
> -	echo "Remake: cannot find \"$seq\""
> -    else
> -	echo -n "$seq"
> -	lasttime=`sed -n -e "/^$seq /s/.* //p" <check.time`
> -	[ "X$lasttime" != X ] && echo -n " ${lasttime}s"
> -	rm -f $seq.bak $seq.full.bak
> -	if sh $seq >$seq.new 2>&1
> -	then
> -	    if [ -f $seq.out ]
> -	    then
> -		$diff $seq.out $seq.new
> -		rm -f $seq.out.bad
> -	    else
> -		touch NO-PREVIOUS-OUTPUT
> -		$diff NO-PREVIOUS-OUTPUT $seq.new
> -		rm -f NO-PREVIOUS-OUTPUT
> -	    fi
> -	    echo ""
> -	    [ -f $seq.out ] && mv $seq.out $seq.bak
> -	    if [ -f $seq.full ]
> -	    then
> -		[ -f $seq.full.ok ] && mv $seq.full.ok $seq.full.bak
> -		mv $seq.full $seq.full.ok
> -	    fi
> -	    mv $seq.new $seq.out
> -	else
> -	    echo " - failed (exit status $?)"
> -	    sed 's/^/	/' $seq.new
> -	    exit 1
> -	fi
> -    fi
> -done
> -
> -exit 0
> -- 
> 1.7.10.4
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
