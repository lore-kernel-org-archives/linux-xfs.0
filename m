Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 13E6F7FF3
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2013 05:45:47 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 748ACAC002
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2013 03:45:46 -0800 (PST)
Received: from ppsw-43.csi.cam.ac.uk (ppsw-43.csi.cam.ac.uk [131.111.8.143])
	by cuda.sgi.com with ESMTP id qHPisleooeaGUkS5 for
	<xfs@oss.sgi.com>; Thu, 14 Feb 2013 03:45:44 -0800 (PST)
Received: from nat.mrc-lmb.cam.ac.uk ([131.111.85.79]:60986
	helo=mail.lmb.internal)
	by ppsw-43.csi.cam.ac.uk (ppsw.cam.ac.uk [131.111.8.139]:25)
	with esmtp id 1U5xG4-0001ok-nl (Exim 4.72) for xfs@oss.sgi.com
	(return-path <dhoworth@mrc-lmb.cam.ac.uk>);
	Thu, 14 Feb 2013 11:45:44 +0000
Received: from oldlmb.lmb.internal ([10.130.0.1] helo=[10.14.0.2])
	by mail.lmb.internal with esmtp (Exim 4.63)
	(envelope-from <dhoworth@mrc-lmb.cam.ac.uk>) id 1U5xG3-0004TY-OJ
	for xfs@oss.sgi.com; Thu, 14 Feb 2013 11:45:44 +0000
Message-ID: <511CCE67.5010402@mrc-lmb.cam.ac.uk>
Date: Thu, 14 Feb 2013 11:45:43 +0000
From: Dave Howorth <dhoworth@mrc-lmb.cam.ac.uk>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_mkfs: wipe old signatures from the device
References: <1360667215-14701-1-git-send-email-lczerner@redhat.com>	<20130212202753.GC26694@dastard>	<20130213080154.GC18597@x2.net.home>	<alpine.LFD.2.00.1302131127070.2315@(none)>	<20130213121655.GA7799@x2.net.home>
	<20130213221720.GH26694@dastard>
In-Reply-To: <20130213221720.GH26694@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Dave Chinner wrote:
> IOWs, it is the responsibility of the filesystem tools to correctly
> identify the filesystem being operated on, and not to
> modify/trash/recover anything unless specifically directed by the
> user.  When a filesystem tool gets it wrong, then that specific tool
> needs to be fixed.  i.e. it is the responsibility of filesystem
> tools to behave sanely, not for the rest of the world to have to
> work around the dangerous behaviour of a specific filesystems'
> toolset.

As an average Joe user, I started to agree with this, but then as a
developer I had second thoughts. It can't be right that every filesystem
tool has to have code to recognize every other type of filesystem; that
just doesn't scale. So each tool would need to call some API, which I
suppose would need to access some kernel code that iterated for every
filesystem type the kernel was configured to handle, or knew historically.

And then we have identical code in every tool, and that code is not
serving the tool's primary purpose, so maybe it should be factored out
on the one-tool-one-job philosophy. So perhaps there should be a single
tool that tells what filesystem type is present on a device, which
everybody runs before mkfs. Oh wait, df -T or other utilities already do
that.

So I'm not sure the issue is black and white. As an average Joe, I
expect mkfs to trash whatever I give it, so I'm pretty careful to check
what is there first. And if I expected to be overwriting an existing
filesystem and I did it often enough to know about the mkfs.xfs
behaviour, I suppose I would always invoke it with the -f flag.
Consistency among the various flavours of mkfs would be nice, though.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
