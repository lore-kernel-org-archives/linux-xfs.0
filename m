Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n753w8pw213677
	for <linux-xfs@oss.sgi.com>; Tue, 4 Aug 2009 22:58:08 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4E52EAF44F7
	for <linux-xfs@oss.sgi.com>; Tue,  4 Aug 2009 21:08:23 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id qTjw3ca65mk8E8XM for
	<linux-xfs@oss.sgi.com>; Tue, 04 Aug 2009 21:08:23 -0700 (PDT)
Message-ID: <4A790380.7060805@sandeen.net>
Date: Tue, 04 Aug 2009 22:58:56 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: failed assertion related to realtime section
References: <h3gd94$clb$1@ger.gmane.org>
In-Reply-To: <h3gd94$clb$1@ger.gmane.org>
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
To: Roman Kononov <kononov@ftml.net>
Cc: linux-xfs@oss.sgi.com

Roman Kononov wrote:
> Hi,
> 
> In 2.6.30.x Linux kernel, the XFS_RT configuration option does not say "This 
> feature is unsupported at this time..." any more. Nevertheless, when 
> enabled, the feature crashes the file system in my setup. Is it expected to 
> be functional?
> 
> The attached assertion log happens every time with a clean and empty file 
> system.
> 
> Thanks,
> 
> Roman Kononov

While realtime should probably work and not oops (!) I'm curious what
your use-case for realtime is?

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
