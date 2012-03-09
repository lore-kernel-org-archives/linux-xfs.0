Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q29DSZp1224725 for <xfs@oss.sgi.com>; Fri, 9 Mar 2012 07:28:35 -0600
Received: from twin.jikos.cz (twin.jikos.cz [89.185.236.188]) by cuda.sgi.com
	with ESMTP id ZHDIGMwhE73YYIO0 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 09 Mar 2012 05:28:31 -0800 (PST)
Received: from twin.jikos.cz (dave@localhost [127.0.0.1])
	by twin.jikos.cz (8.13.6/8.13.6) with ESMTP id q29DSTS8005313
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 9 Mar 2012 14:28:30 +0100
Received: (from dave@localhost)
	by twin.jikos.cz (8.13.6/8.13.6/Submit) id q29DSSXK005312
	for xfs@oss.sgi.com; Fri, 9 Mar 2012 14:28:28 +0100
Date: Fri, 9 Mar 2012 14:28:28 +0100
From: David Sterba <dave@jikos.cz>
Subject: xfstests - unchecked mount failures
Message-ID: <20120309132828.GI4334@twin.jikos.cz>
Mime-Version: 1.0
Content-Disposition: inline
Reply-To: dave@jikos.cz
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

Hi,

I've encountered a bad situation when a failed mount in test 269 did not stop
the test and continued to use the mount point and exhausted space on the root
partition. A quick grep revealed that there are more tests with unchecked
_scratch_mount calls.

The underlying problem with failed mount was observed when the mount comes in a
quick sequence after mount, I saw it with btrfs, and don't know if it affects
other filesystems.

So, either all callers should check the return value or _scratch_mount
calls _fail. I'd go for the latter as it will make it more resilient
against unintentional ommision of checking the retval in new tests and
reviewer does not have keep that in mind.


david

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
