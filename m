Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3J01kS3250373 for <xfs@oss.sgi.com>; Wed, 18 Apr 2012 19:01:46 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	WawUgbbIgk07npcN for <xfs@oss.sgi.com>;
	Wed, 18 Apr 2012 17:01:43 -0700 (PDT)
Date: Thu, 19 Apr 2012 10:01:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3 V2] xfstests 233: fix user fsgqa access to fsstress
Message-ID: <20120419000141.GT6734@dastard>
References: <y>
 <1334654687-25450-1-git-send-email-tmarek@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1334654687-25450-1-git-send-email-tmarek@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Tom Marek <tmarek@redhat.com>
Cc: lczerner@redhat.com, dchinner@redhat.com, xfs@oss.sgi.com

On Tue, Apr 17, 2012 at 11:24:45AM +0200, Tom Marek wrote:
> User fsgqa may sometimes be unable to run fsstress (when xfstests are owned by
> root) because fsgqa doesn't have rights to list directory where the fsstress
> utility is located.

That sounds like an installation problem, not something that needs
to be worked around in the tests. Indeed, this problem woul dmean
that the fsgqa user woul dnot be able to execute anything in the
src/, ltp/ or tools/ subdirectories, and I don't think we want to
work around all those sorts of problems in tests like this.

Indeed, if you look at the make install rules, the install rule for
the ltp/ subdir does:

....
TARGETS = doio fsstress fsx growfiles iogen
SCRIPTS = rwtest.sh
.....
install: default
        $(INSTALL) -m 755 -d $(PKG_LIB_DIR)/ltp
        $(INSTALL) -m 755 $(TARGETS) $(PKG_LIB_DIR)/ltp
        $(INSTALL) -m 755 $(SCRIPTS) $(PKG_LIB_DIR)/ltp

It changes the permissions on the ltp/ directory to rwxr-xr-x, as
well as for the binaries in the ltp/ subdir. This means the fsgqa
user should be able to run the ltp/fsstress binary without any
changes to the test scripts.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
