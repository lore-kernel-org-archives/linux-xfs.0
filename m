Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q22597Jk244260 for <xfs@oss.sgi.com>; Thu, 1 Mar 2012 23:09:07 -0600
Received: from busoni.debian.org (busoni.debian.org [140.211.15.34]) by
	cuda.sgi.com with ESMTP id 0Dzs5heUurbRCH5m (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 01 Mar 2012 21:09:06 -0800 (PST)
Subject: Bug#661580: mkfs.xfs fails to detect correct sector size
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.661580.B661580.133066473517512@bugs.debian.org>
Message-ID: <4F505517.8060304@sandeen.net>
Date: Thu, 01 Mar 2012 23:05:27 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
References: <20120301081409.3103.43155.reportbug@frosties.localnet>
	<20120301083345.GA24409@infradead.org>
	<4F4FE24C.6050304@sandeen.net>
In-Reply-To: <4F4FE24C.6050304@sandeen.net>
Reply-To: Eric Sandeen <sandeen@sandeen.net>, 661580@bugs.debian.org
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
To: Eric Sandeen <sandeen@sandeen.net>, 661580@bugs.debian.org
Cc: Christoph Hellwig <hch@infradead.org>, Goswin von Brederlow <goswin-v-b@web.de>

I've pushed a commit which should fix this, assuming xfsprogs is built with libblkid support enabled:

http://git.kernel.org/?p=fs/xfs/xfsprogs-dev.git;a=commitdiff;h=287d168b550857ce40e04b5f618d7eb91b87022f

-Eric


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
