Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q37E0dpR011030 for <xfs@oss.sgi.com>; Sat, 7 Apr 2012 09:00:41 -0500
Received: from fieldses.org (fieldses.org [174.143.236.118]) by cuda.sgi.com
	with ESMTP id EQqy861FBQAZE6hw (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 07 Apr 2012 07:00:30 -0700 (PDT)
Received: from bfields by fieldses.org with local (Exim 4.72)
	(envelope-from <bfields@fieldses.org>) id 1SGWBp-0006Gx-GV
	for xfs@oss.sgi.com; Sat, 07 Apr 2012 10:00:29 -0400
Date: Sat, 7 Apr 2012 10:00:29 -0400
Subject: detecting case-insensitivity
Message-ID: <20120407140029.GA24090@fieldses.org>
MIME-Version: 1.0
Content-Disposition: inline
From: "J. Bruce Fields" <bfields@fieldses.org>
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

Is there a generic way to detect whether a given filesystem is
case-insensitive?  If not, how should it be done?  (A bit in s_flags?)

(Somebody recently pointed out to me that NFSv4 has a "case_insensitive"
attribute, which we aren't currently returning a sensible value for.)

--b.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
