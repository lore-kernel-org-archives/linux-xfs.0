Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 839547F50
	for <xfs@oss.sgi.com>; Wed, 27 Mar 2013 14:05:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 604B5304087
	for <xfs@oss.sgi.com>; Wed, 27 Mar 2013 12:05:16 -0700 (PDT)
Date: Wed, 27 Mar 2013 15:05:12 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Announce re-factor all current xfstests patches request
Message-ID: <20130327190512.GA22889@thunk.org>
References: <5152F2BB.4000709@sgi.com> <20130327134606.GJ5861@thunk.org>
	<5153217B.5070909@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5153217B.5070909@sgi.com>
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
To: Rich Johnston <rjohnston@sgi.com>
Cc: linux-ext4@vger.kernel.org, linux-btrfs <linux-btrfs@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

What do you think about renaming the existing tests from NNN to
NNN-descriptive-name?  That way it will be easier for people who are
trying to track regressions, since they can easily map from the new
more descriptive name to the old test number for comparison purposes
(i.e., to see whether a failure is a regression or not, etc.)

Would you be open to changes which did this?  I'd suggest sending the
changes as a shell script to minimize the chances of patch conflicts.
It will cause people to need to regenerate their patches, but that
means now would be the time to do this, when everyone will need to be
fixing up their outstanding changes anyway.  :-)

       	      	      		- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
