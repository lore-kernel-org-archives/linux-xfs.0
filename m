Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2EApdoJ066135 for <xfs@oss.sgi.com>; Mon, 14 Mar 2011 05:51:44 -0500
Received: from mail-qy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2A1453429B2
	for <xfs@oss.sgi.com>; Mon, 14 Mar 2011 03:54:32 -0700 (PDT)
Received: from mail-qy0-f181.google.com (mail-qy0-f181.google.com
	[209.85.216.181]) by cuda.sgi.com with ESMTP id
	MJpMBZzLnkRg1p7z for <xfs@oss.sgi.com>;
	Mon, 14 Mar 2011 03:54:32 -0700 (PDT)
Received: by qyg14 with SMTP id 14so4227818qyg.5
	for <xfs@oss.sgi.com>; Mon, 14 Mar 2011 03:54:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110314102426.GA29888@infradead.org>
References: <4D6221B8.9040303@gmail.com> <4D6F5473.2070709@gmail.com>
	<20110303213903.GL15097@dastard>
	<20110314102426.GA29888@infradead.org>
Date: Mon, 14 Mar 2011 11:40:26 +0100
Message-ID: <AANLkTi=w2uV_Gy3zOapQishk_qqskQz72p2fnQMQZczx@mail.gmail.com>
Subject: Re: [PATCH v2] Check for immutable flag in fallocate path
From: Marco Stornelli <marco.stornelli@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, cluster-devel@redhat.com, Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

2011/3/14 Christoph Hellwig <hch@infradead.org>:
> On Fri, Mar 04, 2011 at 08:39:03AM +1100, Dave Chinner wrote:
>> WTF? =A0Why does append mode have any effect on whether we can punch
>> holes in a file or not? There's no justification for adding this in
>> the commit message. Why is it even in a patch that is for checking
>> immutable inodes? What is the point of adding it, when all that will
>> happen is people will switch to XFS_IOC_UNRESVSP which has never had
>> this limitation?
>
> xfs_ioc_space unconditionally rejects inodes with S_APPEND set for
> all preallocation / hole punching ioctls. =A0This might be overzealous for
> preallocations not changing the size, or just extending i_size, but it's
> IMHO entirely correct for hole punching.
>

xfs_ioc_space is in the ioctl path, but we are talking about the
fallocate path. Both of them calls the xfs_change_file_space, isnt'it?
However we are agree about hole punching, the patch is already in
Linus's git tree.

Marco

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
