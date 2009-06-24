Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5ON6Oh7109427 for <xfs@oss.sgi.com>; Wed, 24 Jun 2009 18:06:24 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B1A3F98E569
	for <xfs@oss.sgi.com>; Wed, 24 Jun 2009 16:15:20 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id Y3FHAT7LZBSvUB89 for
	<xfs@oss.sgi.com>; Wed, 24 Jun 2009 16:15:20 -0700 (PDT)
Message-ID: <4A42B18B.90903@sandeen.net>
Date: Wed, 24 Jun 2009 18:06:51 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: mkfs.xfs created filesystem larger than underlying device
References: <98D6DBD179F61A46AF5C064829A832A0185042D261@erebus.totalmanaged.com>	<4A42A7B7.3040403@sandeen.net>
	<98D6DBD179F61A46AF5C064829A832A0185042D264@erebus.totalmanaged.com>
	<4A42B087.5050205@sandeen.net>
	<98D6DBD179F61A46AF5C064829A832A0185042D267@erebus.totalmanaged.com>
In-Reply-To: <98D6DBD179F61A46AF5C064829A832A0185042D267@erebus.totalmanaged.com>
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
To: Michael Moody <michael@gsc.cc>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Michael Moody wrote:
> Are there still known issues with NFS and XFS? I'm performing the
> same test against a jfs formatted filesystem (exported via NFS), and
> so far, no issues. This is the latest centosplus kernel. Are there
> mount options which could cause XFS to have corruption?

Not that I know of.

Without details about what was corrupt, what xfs_repair said, what dmesg
said, what sysrq-t said, etc. it's hard to say.

Could be 4k stack problems if it's x86.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
