Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1LGldpd161727 for <xfs@oss.sgi.com>; Mon, 21 Feb 2011 10:47:39 -0600
Received: from mail-vw0-f50.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EB9A012B76F4
	for <xfs@oss.sgi.com>; Mon, 21 Feb 2011 08:50:22 -0800 (PST)
Received: from mail-vw0-f50.google.com (mail-vw0-f50.google.com
	[209.85.212.50]) by cuda.sgi.com with ESMTP id gS5ghQEcwpAw1thL
	for <xfs@oss.sgi.com>; Mon, 21 Feb 2011 08:50:22 -0800 (PST)
Received: by vws11 with SMTP id 11so1154468vws.37
	for <xfs@oss.sgi.com>; Mon, 21 Feb 2011 08:50:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110221124635.GA5525@infradead.org>
References: <4D6221B8.9040303@gmail.com> <20110221124635.GA5525@infradead.org>
Date: Mon, 21 Feb 2011 17:50:21 +0100
Message-ID: <AANLkTi=bJBeR0m3xuGX_9YZPqRFuMY=bKoxZEWJt37=M@mail.gmail.com>
Subject: Re: [PATCH] Check for immutable flag in fallocate path
From: Marco Stornelli <marco.stornelli@gmail.com>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, cluster-devel@redhat.com, Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

2011/2/21 Christoph Hellwig <hch@infradead.org>:
> On Mon, Feb 21, 2011 at 09:26:32AM +0100, Marco Stornelli wrote:
>> From: Marco Stornelli <marco.stornelli@gmail.com>
>>
>> All fs must check for the immutable flag in their fallocate callback.
>> It's possible to have a race condition in this scenario: an application
>> open a file in read/write and it does something, meanwhile root set the
>> immutable flag on the file, the application at that point can call
>> fallocate with success. Only Ocfs2 check for the immutable flag at the
>> moment.
>
> Please add the check in fs/open.c:do_fallocate() so that it covers all
> filesystems.
>
>

The check should be done after the fs got the inode mutex lock.

Marco

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
