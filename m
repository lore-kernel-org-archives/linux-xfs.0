Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o08IDiWO061840 for <xfs@oss.sgi.com>; Fri, 8 Jan 2010 12:13:44 -0600
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D4B038F808E
	for <xfs@oss.sgi.com>; Fri,  8 Jan 2010 10:14:37 -0800 (PST)
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: xfstests: [PATCH 0/2] ignore duplicates reported by repquota
Date: Fri, 8 Jan 2010 12:14:37 -0600
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A6932@cf--amer001e--3.americas.sgi.com>
From: "Alex Elder" <aelder@sgi.com>
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

It is possible for the same numeric user id to be assigned to
more than one user account.  The repquota command, as well as the
xfs_quota "repquota" command (if not given an upper bound user id
to scan for) will scan the entire password file using getpwent()
in order to report quota information for all users.  As a result,
any numeric id that is used more than once will also be reported
more than once by "repquota".  Multiply-used group and project
id's would have the same behavior.

The effect of this is that in some of the quota-related tests, output
mismatches will be reported in the event an id used in testing is
associated with multiple users/groups/projects.

To get around this, arrange to ignore duplicate entries reported by
requota and the "repquota" xfs_quota command.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
