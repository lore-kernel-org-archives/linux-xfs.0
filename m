Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1QF1fB4009263 for <xfs@oss.sgi.com>; Sat, 26 Feb 2011 09:01:41 -0600
Received: from mail-wy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 876C82FFDCF
	for <xfs@oss.sgi.com>; Sat, 26 Feb 2011 07:04:27 -0800 (PST)
Received: from mail-wy0-f181.google.com (mail-wy0-f181.google.com
	[74.125.82.181]) by cuda.sgi.com with ESMTP id q3KLHYTeTy8VSYSs
	for <xfs@oss.sgi.com>; Sat, 26 Feb 2011 07:04:27 -0800 (PST)
Received: by wyb42 with SMTP id 42so2536158wyb.26
	for <xfs@oss.sgi.com>; Sat, 26 Feb 2011 07:04:27 -0800 (PST)
Message-ID: <4D69154F.8090000@gmail.com>
Date: Sat, 26 Feb 2011 15:59:27 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH] Check for immutable flag in fallocate path
References: <4D6221B8.9040303@gmail.com>
In-Reply-To: <4D6221B8.9040303@gmail.com>
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
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: cluster-devel@redhat.com, Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Il 21/02/2011 09:26, Marco Stornelli ha scritto:
> From: Marco Stornelli <marco.stornelli@gmail.com>
> 
> All fs must check for the immutable flag in their fallocate callback.
> It's possible to have a race condition in this scenario: an application
> open a file in read/write and it does something, meanwhile root set the
> immutable flag on the file, the application at that point can call
> fallocate with success. Only Ocfs2 check for the immutable flag at the
> moment.
> 
> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>

no comments?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
