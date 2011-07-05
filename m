Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p65AZYB5251482 for <xfs@oss.sgi.com>; Tue, 5 Jul 2011 05:35:34 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 219351E58F75
	for <xfs@oss.sgi.com>; Tue,  5 Jul 2011 03:35:33 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id LTu1zR1Z2YdSNml4
	for <xfs@oss.sgi.com>; Tue, 05 Jul 2011 03:35:33 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 106D76C134
	for <xfs@oss.sgi.com>; Tue,  5 Jul 2011 05:35:33 -0500 (CDT)
Message-ID: <4E12E8F3.4080704@hardwarefreak.com>
Date: Tue, 05 Jul 2011 05:35:31 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: xfs_bmap Cannot allocate memory
References: <4E129B00.4020709@dermichi.com>
In-Reply-To: <4E129B00.4020709@dermichi.com>
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

On 7/5/2011 12:02 AM, Michael Weissenbacher wrote:

> xfs_bmap: xfsctl(XFS_IOC_GETBMAPX) iflags=0x0

Googling the text above returns only 5 results, including your post
today to this list.  Thus I doubt your problem is the result of a bug in
XFS or xfsprogs.

Was the file being written to when you ran xfs_bmap?

If not, did you flush caches before running xfs_bmap?  Did you try
unmounting and remounting the filesystem?  These steps are sometimes
needed to get actual extent usage due to extents in cache that have not
yet been written to disk.

What distro/kernel version?

What xfsprogs version?

What filefrag version?

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
