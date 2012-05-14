Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4ELoqW5129723 for <xfs@oss.sgi.com>; Mon, 14 May 2012 16:50:52 -0500
Received: from whiskey.americas.sgi.com (whiskey.americas.sgi.com
	[128.162.233.19])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 45281304048
	for <xfs@oss.sgi.com>; Mon, 14 May 2012 14:50:49 -0700 (PDT)
Date: Mon, 14 May 2012 16:55:11 -0500
From: Ben Myers <bpm@sgi.com>
Subject: git://oss.sgi.com/xfs/xfs master branch rebase
Message-ID: <20120514215511.GF16099@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

Hi Folks,

   Apparently there was a PEBKAC in my office on April 18.  I pulled in a patch
   twice (on separate hosts) and then didn't notice the merge commit when I
   combined them.
  
   Rather than pollute the upstream tree with this garbage I have chosen to
   rebase the master branch at git://oss.sgi.com/xfs/xfs.  You'll notice that
   now it doesn't contain 64a97f1 and 576f1a5.  Other than that it is the same
   as before. 
   
   The old branch can still be found here:
   http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/xfs.git;a=shortlog;h=refs/heads/master-for-3.5-bad

   I'll keep this 'bad' branch around for awhile for reference.

   Anyone working on xfs atop the old master branch will need to rebase his or
   her changes onto the new one.  I apologise for any inconvenience.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
