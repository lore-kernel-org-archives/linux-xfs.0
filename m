Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5FA1F7CA3
	for <xfs@oss.sgi.com>; Sat,  2 Jul 2016 14:50:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 234F48F8035
	for <xfs@oss.sgi.com>; Sat,  2 Jul 2016 12:50:08 -0700 (PDT)
Received: from smtp5.clear.net.nz (smtp5.clear.net.nz [203.97.33.68]) by
	cuda.sgi.com with ESMTP id B7Dd2DhV8pPaiSWq for
	<xfs@oss.sgi.com>; Sat, 02 Jul 2016 12:50:00 -0700 (PDT)
Received: from mxin2-orange.clear.net.nz
	(lb1-srcnat.clear.net.nz [203.97.32.236])
	by smtp5.clear.net.nz (CLEAR Net Mail)
	with ESMTP id <0O9P00HLMDQLLAGN@smtp5.clear.net.nz> for xfs@oss.sgi.com;
	Sun, 03 Jul 2016 07:49:59 +1200 (NZST)
Date: Sun, 03 Jul 2016 07:49:58 +1200
From: Richard Scobie <r.scobie@clear.net.nz>
Subject: Re: High Fragmentation with XFS and NFS Sync
Message-id: <57781AE6.10605@clear.net.nz>
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

  Nick Fisk wrote:

"So it looks like each parallel IO thread is being
allocated next to each other rather than at spaced out regions of the disk."

It's possible that the "filestreams" XFS mount option may help you out. See:

 
http://www.xfs.org/docs/xfsdocs-xml-dev/XFS_User_Guide/tmp/en-US/html/ch06s16.html

Regards,

Richard

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
