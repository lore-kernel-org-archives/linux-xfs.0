Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 14 Sep 2007 13:42:33 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8EKgQ4p019152
	for <linux-xfs@oss.sgi.com>; Fri, 14 Sep 2007 13:42:28 -0700
Message-ID: <46EAF230.4030407@sandeen.net>
Date: Fri, 14 Sep 2007 15:42:24 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Newbie question about xfs_db with the response message "unexpected
 XFS SB magic number 0x2e524d46"
References: <12682767.post@talk.nabble.com>
In-Reply-To: <12682767.post@talk.nabble.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Hxsrmeng <hxsrmeng@gmail.com>
Cc: linux-xfs@oss.sgi.com

Hxsrmeng wrote:
> OpenSUSE10.2. and 2.6.22-rc7-default XFS
> 1)
> I'd like to run "xfs_db -f -c "sb 0" -c "p" ./myfile | egrep
> 'agcount|inopblog|agblklog'" to see the three values.

if "myfile" is a file on your xfs filesystem, then that's not right.
xfs_db needs to be pointed at a block device (or filesystem image file)
containing an xfs filesystem.  You can look at it while it's mounted,
though (IIRC) the information may not be perfectly in sync with the fs's
data.

agcount, inopblog, etc are parameters of an xfs filesystem, not a file
on that filesystem.

What are you trying to learn (about your file or filesystem?)

-Eric
