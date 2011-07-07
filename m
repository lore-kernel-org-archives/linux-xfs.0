Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p67CiGQi166170 for <xfs@oss.sgi.com>; Thu, 7 Jul 2011 07:44:16 -0500
Received: from mail.lncsa.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DEC5253497
	for <xfs@oss.sgi.com>; Thu,  7 Jul 2011 05:44:13 -0700 (PDT)
Received: from mail.lncsa.com (mail.lncsa.com [213.215.28.11]) by cuda.sgi.com
	with ESMTP id 1AjQ2zDZD7IcXVsj for <xfs@oss.sgi.com>;
	Thu, 07 Jul 2011 05:44:13 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by sargon.lncsa.com (Postfix) with ESMTP id 0E7AD6F4221
	for <xfs@oss.sgi.com>; Thu,  7 Jul 2011 14:44:12 +0200 (CEST)
Received: from mail.lncsa.com ([127.0.0.1])
	by localhost (sargon.lncsa.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VSGXn8wstq8y for <xfs@oss.sgi.com>;
	Thu,  7 Jul 2011 14:44:11 +0200 (CEST)
Received: from [192.168.0.31] (donald.lncsa.com [192.168.0.31])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sargon.lncsa.com (Postfix) with ESMTPSA id 638806F4206
	for <xfs@oss.sgi.com>; Thu,  7 Jul 2011 14:44:10 +0200 (CEST)
Message-ID: <4E15AA1A.3090802@lncsa.com>
Date: Thu, 07 Jul 2011 14:44:10 +0200
From: Laurent CARON <lcaron@lncsa.com>
MIME-Version: 1.0
Subject: Number of ACLs
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi,

I'd like to know if it is possible in a simple & safe way to increase 
the number of supported ACLs on an already existing FS.

xfs_acl.h:
#define XFS_ACL_MAX_ENTRIES 25

Changing XFS_ACL_MAX_ENTRIES to something higher should do the trick, 
but will it be safe: ie: will I risk corrupting the FS this way ?

I understand it'll imply a performance penalty if I add too many ACLs.

Thanks

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
