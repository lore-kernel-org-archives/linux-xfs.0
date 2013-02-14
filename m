Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B159D7FEE
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2013 01:30:11 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 488F3AC001
	for <xfs@oss.sgi.com>; Wed, 13 Feb 2013 23:30:07 -0800 (PST)
Received: from slmp-550-94.slc.westdc.net (slmp-550-94.slc.westdc.net
	[50.115.112.57]) by cuda.sgi.com with ESMTP id pKPOUMAejb9MLbp1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 13 Feb 2013 23:30:05 -0800 (PST)
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH] xfs_mkfs: wipe old signatures from the device
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20130213221720.GH26694@dastard>
Date: Thu, 14 Feb 2013 00:29:59 -0700
Message-Id: <982B8DBB-3FBA-4213-BC92-848A64C60110@colorremedies.com>
References: <1360667215-14701-1-git-send-email-lczerner@redhat.com>
	<20130212202753.GC26694@dastard>
	<20130213080154.GC18597@x2.net.home>
	<alpine.LFD.2.00.1302131127070.2315@(none)>
	<20130213121655.GA7799@x2.net.home>
	<20130213221720.GH26694@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: sandeen@redhat.com, xfs@oss.sgi.com, Karel Zak <kzak@redhat.com>, Zach Brown <zabrown@redhat.com>, =?windows-1252?Q?Luk=E1=9A_Czerner?= <lczerner@redhat.com>, linux-btrfs@vger.kernel.org


On Feb 13, 2013, at 3:17 PM, Dave Chinner <david@fromorbit.com> wrote:
> it is the responsibility of filesystem
> tools to behave sanely, not for the rest of the world to have to
> work around the dangerous behaviour of a specific filesystems'
> toolset.

I appreciate this, and in particular that mkfs.xfs doesn't nerf a file system without the use of -f; even an existing XFS file system. Considering most data loss is user induced, I'd appreciate it if other file systems's tools weren't so easily made belligerent by (hopefully temporarily) confused apes wearing pants.

Chris Murphy
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
