Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pALH52sZ011005
	for <linux-xfs@oss.sgi.com>; Mon, 21 Nov 2011 11:05:03 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6045E1F395E2
	for <linux-xfs@oss.sgi.com>; Mon, 21 Nov 2011 09:05:00 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	6s9O6FG5rM2I20jW for <linux-xfs@oss.sgi.com>;
	Mon, 21 Nov 2011 09:05:00 -0800 (PST)
Date: Mon, 21 Nov 2011 12:04:59 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: stale NFS file handle problem on XFS inode64
Message-ID: <20111121170459.GA1327@infradead.org>
References: <CAJNJY8Q--O2Z3K6KFxVKOivwaABk+oRtC1y0eQ0nS1WdPNMwsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAJNJY8Q--O2Z3K6KFxVKOivwaABk+oRtC1y0eQ0nS1WdPNMwsQ@mail.gmail.com>
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

On Mon, Nov 21, 2011 at 09:00:57PM +0800, hank peng wrote:
> Hi:
> I have a 4TB XFS filesystem mounted with "inode64" option, and I
> exported it using NFS v3, on NFS client, I entered a subdirectory and
> got "stale NFS file handle" error.
> ls -il showed that its inode number exceed 32 bit limit.
> NFS server: kernel version is 2.6.35.6
> NFS client: kernel version is 2.6.18

Do you export the root directory of the XFS filesystem, or a
subdirectory in it?  If it's the former it should work in theory,
althrough I'm not sure how well 64-bit inode numbers work with a client
that old, if it's the latter it needs a few tweaks to work, see

	http://xfs.org/index.php/XFS_FAQ#Q:_Why_doesn.27t_NFS-exporting_subdirectories_of_inode64-mounted_filesystem_work.3F

for details.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
