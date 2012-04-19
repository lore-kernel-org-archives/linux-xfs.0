Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3J8bi0v031616 for <xfs@oss.sgi.com>; Thu, 19 Apr 2012 03:37:44 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id dHfWVUdbNjfl0cJQ for
	<xfs@oss.sgi.com>; Thu, 19 Apr 2012 01:37:42 -0700 (PDT)
Date: Thu, 19 Apr 2012 10:37:36 +0200 (CEST)
From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 1/3 V2] xfstests 233: fix user fsgqa access to fsstress
In-Reply-To: <20120419000141.GT6734@dastard>
Message-ID: <alpine.LFD.2.00.1204191035040.4508@dhcp-27-109.brq.redhat.com>
References: <y> <1334654687-25450-1-git-send-email-tmarek@redhat.com>
	<20120419000141.GT6734@dastard>
MIME-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: Tom Marek <tmarek@redhat.com>, lczerner@redhat.com, dchinner@redhat.com, xfs@oss.sgi.com

On Thu, 19 Apr 2012, Dave Chinner wrote:

> On Tue, Apr 17, 2012 at 11:24:45AM +0200, Tom Marek wrote:
> > User fsgqa may sometimes be unable to run fsstress (when xfstests are owned by
> > root) because fsgqa doesn't have rights to list directory where the fsstress
> > utility is located.
> 
> That sounds like an installation problem, not something that needs
> to be worked around in the tests. Indeed, this problem woul dmean
> that the fsgqa user woul dnot be able to execute anything in the
> src/, ltp/ or tools/ subdirectories, and I don't think we want to
> work around all those sorts of problems in tests like this.
> 
> Indeed, if you look at the make install rules, the install rule for
> the ltp/ subdir does:
> 
> ....
> TARGETS = doio fsstress fsx growfiles iogen
> SCRIPTS = rwtest.sh
> .....
> install: default
>         $(INSTALL) -m 755 -d $(PKG_LIB_DIR)/ltp
>         $(INSTALL) -m 755 $(TARGETS) $(PKG_LIB_DIR)/ltp
>         $(INSTALL) -m 755 $(SCRIPTS) $(PKG_LIB_DIR)/ltp
> 
> It changes the permissions on the ltp/ directory to rwxr-xr-x, as
> well as for the binaries in the ltp/ subdir. This means the fsgqa
> user should be able to run the ltp/fsstress binary without any
> changes to the test scripts.
> 
> Cheers,
> 
> Dave.
> 

Hm, good to know. I did not knew that, there is not a word about this in
README, but I could have just read the Makefile I guess. Tom could you
rather fix the README ?

Thanks!
-Lukas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
