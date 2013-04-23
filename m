Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9BF2C7F37
	for <xfs@oss.sgi.com>; Tue, 23 Apr 2013 08:03:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6ECF5304064
	for <xfs@oss.sgi.com>; Tue, 23 Apr 2013 06:03:17 -0700 (PDT)
Received: from buxtehude.debian.org (buxtehude.debian.org [140.211.166.26]) by
	cuda.sgi.com with ESMTP id 31YzTpHr4Lx1CF8c (version=TLSv1
	cipher=AES128-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 23 Apr 2013 06:03:13 -0700 (PDT)
Subject: Bug#705483: xfsprogs: xfs_quota misinterprets usernames with leading
	digits
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.705483.B705483.13667221219243@bugs.debian.org>
Message-ID: <5176864D.6050604@sgi.com>
Date: Tue, 23 Apr 2013 08:02:05 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
References: <516C12DB.3060806@bytemark.co.uk>
In-Reply-To: <516C12DB.3060806@bytemark.co.uk>
Reply-To: Rich Johnston <rjohnston@sgi.com>, 705483@bugs.debian.org
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
To: James Carter <james.carter@bytemark.co.uk>, 705483@bugs.debian.org
Cc: submit@bugs.debian.org

James,

The following commit will resolve the issue.

Thanks
--Rich

commit fd537fc50eeade63bbd2a66105f39d04a011a7f5
Author: Rich Johnston <rjohnston@sgi.com>
Date:   Mon Apr 22 17:32:05 2013 +0000

     xfsprogs: xfs_quota allow user or group names beginning with digits

     xfs_quota does not properly parse users or groups that begin with a 
number.
     Only call atoi when user or group consists of digits only.

     Signed-off-by: Rich Johnston <rjohnston@sgi.com>
     Reported-by: James Carter <james.carter@bytemark.co.uk>
     Reviewed-by: Eric Sandeen <sandeen@redhat.com>
     Reviewed-by: Chandra Seetharaman <sekharan@us.ibm.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
