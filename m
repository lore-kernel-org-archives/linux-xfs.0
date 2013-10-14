Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B85487F37
	for <xfs@oss.sgi.com>; Mon, 14 Oct 2013 15:09:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 53DD8AC003
	for <xfs@oss.sgi.com>; Mon, 14 Oct 2013 13:09:40 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	Tq3bjdqeHEWCGU5i for <xfs@oss.sgi.com>;
	Mon, 14 Oct 2013 13:09:38 -0700 (PDT)
Date: Tue, 15 Oct 2013 07:09:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RESEND V2] xfstests: Incorrect check for gdbm/ndbm.h
Message-ID: <20131014200935.GM4446@dastard>
References: <20131013215708.GF5663@dastard>
	<1381762899-6799-1-git-send-email-stanislav.kholmanskikh@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1381762899-6799-1-git-send-email-stanislav.kholmanskikh@oracle.com>
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
To: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
Cc: vasily.isaenko@oracle.com, xfs@oss.sgi.com

On Mon, Oct 14, 2013 at 07:01:39PM +0400, Stanislav Kholmanskikh wrote:
> Current version of AC_PACKAGE_WANT_NDBM has following bugs:
> * a typo (',') next to 'gdbm/ndbm.h', so C compiler fails
>   with a syntax error when trying to compile
>   "#include <gdbm/ndbm.h,>"
> 
> * autoconf never defines HAVE_GDBM_NDBM_H_ because it
>   converts both header names (gdbm/ndbm.h, gdbm-ndbm.h)
>   to GDBM_NDBM_H
> 
> Because of these bugs 'dbtest' can't be compiled on systems where
> 'gdbm-ndbm.h' header is absent but 'gdbm/ndbm.h' is present.
> 
> Fixed this.
> 
> Signed-off-by: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>

Looks good now.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
