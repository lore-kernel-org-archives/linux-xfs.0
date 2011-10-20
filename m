Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9L202nK038060 for <xfs@oss.sgi.com>; Thu, 20 Oct 2011 21:00:02 -0500
Received: from e9.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 323EF16158A5
	for <xfs@oss.sgi.com>; Thu, 20 Oct 2011 19:08:10 -0700 (PDT)
Received: from e9.ny.us.ibm.com (e9.ny.us.ibm.com [32.97.182.139]) by
	cuda.sgi.com with ESMTP id yV11HbcdRVejsBeH for
	<xfs@oss.sgi.com>; Thu, 20 Oct 2011 19:08:10 -0700 (PDT)
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by e9.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p9KMPxsX031640
	for <xfs@oss.sgi.com>; Thu, 20 Oct 2011 18:25:59 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p9KN2RFN228900 for <xfs@oss.sgi.com>; Thu, 20 Oct 2011 19:02:27 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p9KN2Rjm027660 for <xfs@oss.sgi.com>; Thu, 20 Oct 2011 21:02:27 -0200
Received: from [9.53.40.164] (chandra-lucid.austin.ibm.com [9.53.40.164])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id
	p9KN2Q35027632 for <xfs@oss.sgi.com>; Thu, 20 Oct 2011 21:02:26 -0200
Subject: A question in the context of independent pquota
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Thu, 20 Oct 2011 18:02:26 -0500
Message-ID: <1319151746.1959.63.camel@chandra-lucid.austin.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
To: XFS Mailing List <xfs@oss.sgi.com>

Hi All,

Few days back I posted a patchset to allow pquota and gquota to be used
together. I have a question in that context.

In order for the user space to get the stats for pguota and gquota
together (quotactl command Q_XGETQSTAT), I need to add a field to
fs_quota_stat. So, I have to change the version number.

But, the version number is only set in the kernel and not checked. Which
means the kernel cannot know what size of the fs_quota_stat data
structure the user space has provided in order to decide if the kernel
can copy the newer (bigger) data structure to the user space or not.

One option I see is to add a new command to the ioctl.

Is there any other options ? ( or am I totally missing it :) ?

Thanks

Chandra






_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
