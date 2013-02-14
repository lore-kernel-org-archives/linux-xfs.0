Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0C1FA802B
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2013 13:17:17 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E62BE304051
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2013 11:17:13 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id yYLAHAUi9YwboKkn for <xfs@oss.sgi.com>;
	Thu, 14 Feb 2013 11:17:12 -0800 (PST)
Message-ID: <511D3838.5000903@sandeen.net>
Date: Thu, 14 Feb 2013 13:17:12 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_mkfs: wipe old signatures from the device
References: <1360667215-14701-1-git-send-email-lczerner@redhat.com>	<20130212202753.GC26694@dastard>	<20130213080154.GC18597@x2.net.home>	<alpine.LFD.2.00.1302131127070.2315@(none)>	<20130213121655.GA7799@x2.net.home>
	<20130213221720.GH26694@dastard>
	<511CCE67.5010402@mrc-lmb.cam.ac.uk>
In-Reply-To: <511CCE67.5010402@mrc-lmb.cam.ac.uk>
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
To: Dave Howorth <dhoworth@mrc-lmb.cam.ac.uk>
Cc: xfs@oss.sgi.com

On 2/14/13 5:45 AM, Dave Howorth wrote:
> Dave Chinner wrote:
>> IOWs, it is the responsibility of the filesystem tools to correctly
>> identify the filesystem being operated on, and not to
>> modify/trash/recover anything unless specifically directed by the
>> user.  When a filesystem tool gets it wrong, then that specific tool
>> needs to be fixed.  i.e. it is the responsibility of filesystem
>> tools to behave sanely, not for the rest of the world to have to
>> work around the dangerous behaviour of a specific filesystems'
>> toolset.
> 
> As an average Joe user, I started to agree with this, but then as a
> developer I had second thoughts. It can't be right that every filesystem
> tool has to have code to recognize every other type of filesystem; that
> just doesn't scale. So each tool would need to call some API, which I

Yep - it's called libblkid, it's very easy to use for this purpose.
xfsprogs already does, and I just sent a patch for btrfs-progs as well.

So libblkid contains all the smarts, really, and it's not a code duplication
problem.

> suppose would need to access some kernel code that iterated for every
> filesystem type the kernel was configured to handle, or knew historically.

Nah, it doesn't matter what the running kernel knows about, IMHO, just what
is recognized on the disk at hand.

-Eric

> And then we have identical code in every tool, and that code is not
> serving the tool's primary purpose, so maybe it should be factored out
> on the one-tool-one-job philosophy. So perhaps there should be a single
> tool that tells what filesystem type is present on a device, which
> everybody runs before mkfs. Oh wait, df -T or other utilities already do
> that.
> 
> So I'm not sure the issue is black and white. As an average Joe, I
> expect mkfs to trash whatever I give it, so I'm pretty careful to check
> what is there first. And if I expected to be overwriting an existing
> filesystem and I did it often enough to know about the mkfs.xfs
> behaviour, I suppose I would always invoke it with the -f flag.
> Consistency among the various flavours of mkfs would be nice, though.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
