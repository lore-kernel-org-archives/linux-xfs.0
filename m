Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B8AE58034
	for <xfs@oss.sgi.com>; Tue,  5 Mar 2013 13:49:13 -0600 (CST)
Message-ID: <51364C42.6030307@sgi.com>
Date: Tue, 5 Mar 2013 13:49:22 -0600
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH V3] xfstests: don't remove trailing zeros from integers
References: <20130305191748.GB3930@wallace>
In-Reply-To: <20130305191748.GB3930@wallace>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Whitney <enwlinux@gmail.com>
Cc: sandeen@redhat.com, xfs@oss.sgi.com

This patch has been committed.

Thanks
--Rich


commit edce9e677fda49ca20d6059248937ab4af65d053
Author: Eric Whitney <enwlinux@gmail.com>
Date:   Tue Mar 5 19:17:48 2013 +0000

     xfstests: don't remove trailing zeros from integers

     _within_tolerance strips trailing zeros from the min and max range
     values it outputs.  This leads to damage if the min or max value is
     an integer containing trailing zeros rather than a real number with
     a fractional part containing trailing zeros. Xfstest 289 can exhibit
     this problem when its input is out of range.  Modify the code so it
     will only remove trailing zeros found after a decimal point.

     V1->V2: Remove decimal points not followed by digits
     V2->V3: Per Dave Chinner, simplify by using multiple sed expressions

     Signed-off-by: Eric Whitney <enwlinux@gmail.com>
     Reviewed-by: Eric Sandeen <sandeen@redhat.com>
     Signed-off-by: Rich Johnston <rjohnston@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
