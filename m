Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5F7A17F80
	for <xfs@oss.sgi.com>; Wed, 29 Jan 2014 08:26:46 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4BC628F8054
	for <xfs@oss.sgi.com>; Wed, 29 Jan 2014 06:26:43 -0800 (PST)
Received: from internal-smtp4.wesleyan.edu (internal-smtp4.wesleyan.edu
	[129.133.6.200]) by cuda.sgi.com with ESMTP id SkjiOZgnOTz6vUfA
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 29 Jan 2014 06:26:42 -0800 (PST)
Received: from localhost (al.wesleyan.edu [129.133.22.76])
	(authenticated bits=0)
	by msa.wesleyan.edu (8.14.4/8.14.4) with ESMTP id s0TEQeVx020755
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NOT)
	for <xfs@oss.sgi.com>; Wed, 29 Jan 2014 09:26:40 -0500
From: "C. Morgan Hamill" <chamill@wesleyan.edu>
Subject: Question regarding XFS on LVM over hardware RAID.
Date: Wed, 29 Jan 2014 09:26:40 -0500
Message-Id: <1391005406-sup-1881@al.wesleyan.edu>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs <xfs@oss.sgi.com>

Howdy folks,

I understand that XFS have stripe unit and width configured according to
the underlying RAID device when using LVM, but I was wondering if this
is still the case when a given XFS-formatted logical volume takes up
only part of the available space on the RAID.  In particular, I could
imagine that stripe width would need to be modified proportionally with
the decrease in filesystem size.  My intuition says that's false, but
I wanted to check with folks who know for sure.

Thanks for any help!
--
Morgan Hamill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
