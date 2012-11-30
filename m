Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAUHIkK0202329 for <xfs@oss.sgi.com>; Fri, 30 Nov 2012 11:18:46 -0600
Received: from buxtehude.debian.org (buxtehude.debian.org [140.211.166.26]) by
	cuda.sgi.com with ESMTP id Ji83dsBWAOLtLcoF (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 30 Nov 2012 09:21:05 -0800 (PST)
Subject: Bug#694624: /usr/sbin/xfs_freeze: freezes under lying (root)
	filesystem if mountpoint is not currently mounted
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.694624.B.135429580531653@bugs.debian.org>
Date: Fri, 30 Nov 2012 11:04:42 -0500
From: Christoph Hellwig <hch@infradead.org>
Message-ID: <20121130160442.GB5667@infradead.org>
References: <20121128134342.4359.51203.reportbug@t5>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121128134342.4359.51203.reportbug@t5>
Reply-To: Christoph Hellwig <hch@infradead.org>, 694624@bugs.debian.org
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
To: Patrick Emblen <support@talbragar.com.au>, 694624@bugs.debian.org
Cc: Debian Bug Tracking System <submit@bugs.debian.org>

It probably makes sense to only allow it for mountpoints, then again
I fear people might already be using it differently in existing scripts.

Maybe be should add an -s / --strict option that forces it to only work
on mountpoints?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
