Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 85E887CBF
	for <xfs@oss.sgi.com>; Mon, 13 May 2013 07:24:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 59A1930406B
	for <xfs@oss.sgi.com>; Mon, 13 May 2013 05:24:35 -0700 (PDT)
Received: from postout.lrz.de (postout.lrz.de [129.187.254.115]) by
	cuda.sgi.com with ESMTP id VMlWH6uFu6YZi8S1 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 13 May 2013 05:24:34 -0700 (PDT)
Received: from lxmhs52.srv.lrz.de (localhost [127.0.0.1])
	by postout4.mail.lrz.de (Postfix) with ESMTP id 8B340200BD
	for <xfs@oss.sgi.com>; Mon, 13 May 2013 14:24:32 +0200 (CEST)
Received: from postout4.mail.lrz.de ([127.0.0.1])
	by lxmhs52.srv.lrz.de (lxmhs52.srv.lrz.de [127.0.0.1]) (amavisd-new,
	port 20024) with LMTP id 8anhYj60u2aO for <xfs@oss.sgi.com>;
	Mon, 13 May 2013 14:24:32 +0200 (CEST)
Received: from [192.168.1.66] (mnch-5d85e8f4.pool.mediaWays.net
	[93.133.232.244])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by postout4.mail.lrz.de (Postfix) with ESMTPSA id 3E737200BC
	for <xfs@oss.sgi.com>; Mon, 13 May 2013 14:24:32 +0200 (CEST)
Message-ID: <5190DB7F.2050505@tum.de>
Date: Mon, 13 May 2013 14:24:31 +0200
From: Benedikt Schmidt <benedikt.schmidt@tum.de>
MIME-Version: 1.0
Subject: xfs_repair force_geometry
Reply-To: benediktibk@aon.at
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

Hi,
currently I'm looking for the correct usage of the force_geometry option 
of xfs_repair. I wasn't able to find more documentation on this option 
beside that it exists. Could please somebody explain it to me?

For a more detailed description of my problem: I've got here a hard disk 
which is dying at the moment, so I copied all the content with dd_rescue 
to a new and bigger one. To use xfs_copy wasn't possible as the 
filesystem was already corrupted. So now I've got nearly everything on 
the second hard disk (dd_rescue could'nt copy something around 6 or 7 
MB), but I can not mount the filesystem or even run xfs_repair on it, as 
it fails to find a superblock. I think the problem lies in the fact that 
the new disk has a different geometry than the previous one.

Kind regards,
Benedikt Schmidt

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
