Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6A7R0ei083704 for <xfs@oss.sgi.com>; Fri, 10 Jul 2009 02:27:00 -0500
Received: from fg-out-1718.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AB7D81B4F1AA
	for <xfs@oss.sgi.com>; Fri, 10 Jul 2009 00:27:35 -0700 (PDT)
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.152])
	by cuda.sgi.com with ESMTP id NMAIx02ui830N7nE for
	<xfs@oss.sgi.com>; Fri, 10 Jul 2009 00:27:35 -0700 (PDT)
Received: by fg-out-1718.google.com with SMTP id l27so1514384fgb.8
	for <xfs@oss.sgi.com>; Fri, 10 Jul 2009 00:27:35 -0700 (PDT)
Message-ID: <4A56ED5F.10400@gmail.com>
Date: Fri, 10 Jul 2009 09:27:27 +0200
From: Tomek Kruszona <bloodyscarion@gmail.com>
MIME-Version: 1.0
Subject: Re: xfs_repair stops on "traversing filesystem..."
References: <4A55FAF7.5040908@gmail.com> <4A56D176.9010702@sandeen.net>
In-Reply-To: <4A56D176.9010702@sandeen.net>
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
To: xfs@oss.sgi.com

Eric Sandeen wrote:
> No fix for you yet, but it's in cache_node_get(), in the for(;;) loop,
> and it looks like cache_node_allocate() fails to get a new node and we
> keep spinning.  I need to look some more at what's going on....

Hello!

Is this specific behavior for this particular broken filesystem or is it
a bug in functions you mentioned? I'm just curious :)

Best regards,
Tomasz Kruszona

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
