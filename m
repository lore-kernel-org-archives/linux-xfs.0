Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2988E29DFB
	for <xfs@oss.sgi.com>; Thu,  1 Aug 2013 14:25:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 09B4D8F8037
	for <xfs@oss.sgi.com>; Thu,  1 Aug 2013 12:25:11 -0700 (PDT)
Received: from e33.co.us.ibm.com (e33.co.us.ibm.com [32.97.110.151]) by
	cuda.sgi.com with ESMTP id hRKw5tFoKHB8AIA9 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 01 Aug 2013 12:25:10 -0700 (PDT)
Received: from /spool/local
	by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Thu, 1 Aug 2013 13:25:09 -0600
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com
	[9.17.195.226])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 77E211FF001E
	for <xfs@oss.sgi.com>; Thu,  1 Aug 2013 13:19:43 -0600 (MDT)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r71JP5ee146968 for <xfs@oss.sgi.com>; Thu, 1 Aug 2013 13:25:05 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r71JP5YB017528
	for <xfs@oss.sgi.com>; Thu, 1 Aug 2013 13:25:05 -0600
Received: from chandra-dt.austin.ibm.com (chandra-dt.austin.ibm.com
	[9.41.106.170])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id
	r71JP2vc017305 for <xfs@oss.sgi.com>; Thu, 1 Aug 2013 13:25:03 -0600
From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 0/2] xfsprogs: Allow pquota and gquota to be used together
Date: Thu,  1 Aug 2013 14:24:59 -0500
Message-Id: <1375385101-3673-1-git-send-email-sekharan@us.ibm.com>
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
To: xfs@oss.sgi.com

Hello All,

These two patches make the relevant user space changes to support
the gquota/pquota in kernel.

It applies cleanly on crc-dev branch of xfsprogs.

Regards,

Chandra

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
