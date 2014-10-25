Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0BDBA7F69
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2014 13:58:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EE41F304032
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2014 11:58:26 -0700 (PDT)
Received: from smtp5.clear.net.nz (smtp5.clear.net.nz [203.97.33.68]) by
	cuda.sgi.com with ESMTP id 9WcYFOXfyKeArBPv for
	<xfs@oss.sgi.com>; Sat, 25 Oct 2014 11:58:22 -0700 (PDT)
Received: from mxin2-orange.clear.net.nz
	(lb2-srcnat.clear.net.nz [203.97.32.237])
	by smtp5.clear.net.nz (CLEAR Net Mail)
	with ESMTP id <0NE000JQUKP8YC10@smtp5.clear.net.nz> for xfs@oss.sgi.com;
	Sun, 26 Oct 2014 07:58:20 +1300 (NZDT)
Date: Sun, 26 Oct 2014 07:56:47 +1300
From: Richard Scobie <r.scobie@clear.net.nz>
Subject: Re: file streams allocator behavior
Message-id: <544BF26F.6000708@clear.net.nz>
MIME-version: 1.0
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
To: xfs@oss.sgi.com

Stan Hoeppner said:

 > How can I disable or change the filestreams behavior so all files go
 > into the one AG for the single directory test?

Hi Stan,

Instead of mounting with -o filestreams, would using the chattr flag 
instead help?

See 
http://xfs.org/docs/xfsdocs-xml-dev/XFS_User_Guide/tmp/en-US/html/ch06s16.html

Regards,

Richard

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
