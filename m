Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q12LeM5I076169
	for <linux-xfs@oss.sgi.com>; Thu, 2 Feb 2012 15:40:23 -0600
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id F8hqi6hW0JvIypqv for <linux-xfs@oss.sgi.com>;
	Thu, 02 Feb 2012 13:40:21 -0800 (PST)
Message-ID: <4F2B02C4.8070903@sandeen.net>
Date: Thu, 02 Feb 2012 15:40:20 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Placing the root partition on an XFS filesystem is not supported
References: <loom.20120129T133929-288@post.gmane.org>
In-Reply-To: <loom.20120129T133929-288@post.gmane.org>
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
To: Marcos Mello <marcosfrm@gmail.com>
Cc: linux-xfs@oss.sgi.com

On 1/29/12 6:46 AM, Marcos Mello wrote:
> http://git.fedorahosted.org/git/?p=anaconda.git;a=commit;h=b3e19d43840f6c4015fab75411853003fcf26a63
> 
> Does someone knows why? I'm trying to get rid of EXT* partitions on my new
> CentOS 6.2 installs but apparently it will not be possible.

Was done for RHEL, AFAIK.

In general there is no problem with xfs on a root partition.  However, the installer
may not make it easy or available for you.

(I never use xfs for /boot though, I don't trust grub enough for that honestly).

-Eric

> Marcos
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
