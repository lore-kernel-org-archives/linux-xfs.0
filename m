Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 14 Sep 2007 14:21:12 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8ELL24p027543
	for <linux-xfs@oss.sgi.com>; Fri, 14 Sep 2007 14:21:06 -0700
Message-ID: <46EAFB3D.9080109@sandeen.net>
Date: Fri, 14 Sep 2007 16:21:01 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Newbie question about xfs_db with the response message "unexpected
 XFS SB magic number 0x2e524d46"
References: <12682767.post@talk.nabble.com> <46EAF230.4030407@sandeen.net> <12683711.post@talk.nabble.com>
In-Reply-To: <12683711.post@talk.nabble.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Hxsrmeng <hxsrmeng@gmail.com>
Cc: linux-xfs@oss.sgi.com

Hxsrmeng wrote:
> Thanks. 
> But what should I do to " look at it while it's mounted,though (IIRC)"?
> Only thing I know is that I have to umount xfs_disk to use xfs_db. But at
> this time, I can not see files in my xfs_disk.
> 
> Actually, I'd like to know where exactly myfile is located in xfs_disk.

xfs_bmap -v myfile

-Eric
