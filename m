Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7DBZocd052990 for <xfs@oss.sgi.com>; Fri, 13 Aug 2010 06:35:50 -0500
Received: from b.mx.filmlight.ltd.uk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 63D704B37E2
	for <xfs@oss.sgi.com>; Fri, 13 Aug 2010 04:36:15 -0700 (PDT)
Received: from b.mx.filmlight.ltd.uk (bongo.filmlight.ltd.uk [77.107.81.251])
	by cuda.sgi.com with SMTP id UyLpnoDXHsI01ZIC for
	<xfs@oss.sgi.com>; Fri, 13 Aug 2010 04:36:15 -0700 (PDT)
Subject: Re: Alignment size?
From: Roger Willcocks <roger@filmlight.ltd.uk>
In-Reply-To: <4C64E52E.2060806@msgid.tls.msk.ru>
References: <4C64715F.8060000@msgid.tls.msk.ru>
	<20100812234911.GC10429@dastard>  <4C64E52E.2060806@msgid.tls.msk.ru>
Date: Fri, 13 Aug 2010 12:36:05 +0100
Message-Id: <1281699365.12371.142.camel@montana.filmlight.ltd.uk>
Mime-Version: 1.0
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
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: xfs@oss.sgi.com


On Fri, 2010-08-13 at 10:24 +0400, Michael Tokarev wrote:

> So why xfs decided the block size is 4K??

We had a similar problem with direct io here, with 2.6.9; I quote from
the Bugzilla:

"mkfs.xfs has md-specific code (!) that looks at the raid flavour to
figure stripe parameters, alignment requirements, etc.

"Raid flavours 4,5 and 6 force the alignment to be the same as the file system
block size (which is 4096 bytes)."

Here's a program to test the alignment requirements:

----

#include <xfs/libxfs.h>
#include <fcntl.h>

int main(int argc, char* argv[])
{
	struct dioattr	dio;

	int tfd = open((argc == 2) ? argv[1] : "/mnt/disk1", O_RDONLY, 0666);

	if (ioctl(tfd, XFS_IOC_DIOINFO, &dio) < 0)
		perror("ioctl");
	else {
		printf("min io size = %d\n", dio.d_miniosz);
		printf("max io size = %d\n", dio.d_maxiosz);
		printf("align = %d\n", dio.d_mem);
	}
	close(tfd);
	return 0;
}

----

The same disk set returned 'align = 4096' for raid 5, but 'align = 512' for raid 0.

--
Roger



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
