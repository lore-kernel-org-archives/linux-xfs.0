Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAJ4xjo7031270 for <xfs@oss.sgi.com>; Tue, 18 Nov 2008 22:59:46 -0600
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C26C2159E8E6
	for <xfs@oss.sgi.com>; Tue, 18 Nov 2008 20:59:40 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id Sb0ubK26XGBoIwdd for <xfs@oss.sgi.com>;
	Tue, 18 Nov 2008 20:59:40 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 9D1DDA84089
	for <xfs@oss.sgi.com>; Tue, 18 Nov 2008 22:59:09 -0600 (CST)
Message-ID: <49239D1D.1040401@sandeen.net>
Date: Tue, 18 Nov 2008 22:59:09 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 3/3 v4] hook up fiemap & associated formatter
References: <49089596.80006@sandeen.net> <4908965B.5000803@sandeen.net>
In-Reply-To: <4908965B.5000803@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: xfs mailing list <xfs@oss.sgi.com>

Eric Sandeen wrote:
> Hook up the fiemap ioctl.

sgi, ping?

It'd be nice to get this in so it hits linux-next; it'd be a shame to
have .29 get out there with xfs still not hooked up to extent-based file
mapping, when ext3, ext4, ocfs2, etc are all sitting pretty already in .28.

When the core kernel lifts xfs functionality up to common, it's sad when
xfs is actually the last to accommodate the common interface.

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
