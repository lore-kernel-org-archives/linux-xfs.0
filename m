Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nB13s0dK093010
	for <linux-xfs@oss.sgi.com>; Mon, 30 Nov 2009 21:54:00 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DDC351905712
	for <linux-xfs@oss.sgi.com>; Mon, 30 Nov 2009 19:54:29 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id OrZT2IjeBOFGhrSY for
	<linux-xfs@oss.sgi.com>; Mon, 30 Nov 2009 19:54:29 -0800 (PST)
Message-ID: <4B14936F.7040401@sandeen.net>
Date: Mon, 30 Nov 2009 21:54:23 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: can xfs_repair guarantee a complete clean filesystem?
References: <389deec70911301805j37df7397l1c3ddbbad7e91768@mail.gmail.com>
In-Reply-To: <389deec70911301805j37df7397l1c3ddbbad7e91768@mail.gmail.com>
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
To: hank peng <pengxihan@gmail.com>
Cc: linux-xfs@oss.sgi.com

hank peng wrote:
> When using xfs_repair, I want my XFS filesystem complete clean and
> continue to work even if some files lost. Becase we use XFS in low-end
> NAS box, customers want a tool to repair the filesystem when it has
> problem and they allow some files be lost and don't want the whole
> system to stop.
> So, I wonder if xfs_repair or some other tools can satisfy this funciton?
> 

Yes, that is exactly its purpose (any potential bugs notwithstanding...)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
