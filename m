Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BD36A7CA0
	for <xfs@oss.sgi.com>; Tue,  7 Jun 2016 12:12:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 82DD0304039
	for <xfs@oss.sgi.com>; Tue,  7 Jun 2016 10:12:25 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id R5UjzRJF6sjPyyDZ for <xfs@oss.sgi.com>;
	Tue, 07 Jun 2016 10:12:22 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 54F2F873
	for <xfs@oss.sgi.com>; Tue,  7 Jun 2016 12:12:22 -0500 (CDT)
Subject: Re: determining superblock version?
References: <20160607125127.6dd23aef@harpe.intellique.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <ded753a1-8bf2-2071-da8a-ec6939846ab0@sandeen.net>
Date: Tue, 7 Jun 2016 12:12:21 -0500
MIME-Version: 1.0
In-Reply-To: <20160607125127.6dd23aef@harpe.intellique.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 6/7/16 5:51 AM, Emmanuel Florac wrote:
> Hi all,
> 
> as you know kernel prior to 3.16 won't support properly v5 superblocks.
> xfsprogs v 3.2.4 and higher defaults to v5 superblocks. This bit quite
> a lot of people a year ago or so, when some distributions shipped 3.2.4
> xfsprogs with older kernels.
> 
> Anyway, I was surprised to find no easy way to find out the superblock
> version of an xfs FS. The best I've come across is
> 
> xfs_db /dev/this
> sb
> p
> 
> <snip>
> versionnum = 0xb4a5
> </snip>

There is certainly some confusion about naming.

Version 5, compat/incompat features, feature bits, feature names, etc.
 
> So I suppose that the 5 in the end means that the superblock is v5? Can
> anyone confirm please? The man page still pretends that the last number
> should be 1 to 4, which is confusing.

Yes, the last bits contain the version number (masked by 0xf, see below)

#define XFS_SB_VERSION_1        1               /* 5.3, 6.0.1, 6.1 */
#define XFS_SB_VERSION_2        2               /* 6.2 - attributes */
#define XFS_SB_VERSION_3        3               /* 6.2 - new inode version */
#define XFS_SB_VERSION_4        4               /* 6.2+ - bitmask version */
#define XFS_SB_VERSION_5        5               /* CRC enabled filesystem */
#define XFS_SB_VERSION_NUMBITS          0x000f

feel free to send a man page patch :)

> Oh by the way I think the trick to create a v4 filesystem with mkfs.xfs
> higher than 3.2.4 ( mkfs.xfs -m crc=0,finobt=0 /dev/this ) should be in
> the FAQ, with a line like this:
> 
> Mounting the filesystem fails, and output from dmesg says "Version 5
> superblock detected." What should I do?
>
> v5 superblocks require a kernel v3.16 of higher. If you need your
> xfs filesystem to be usable with older kernel, use the following
> options to mkfs.xfs :
> 
> mkfs.xfs -m crc=0,finobt=0 /dev/this

finobt=0 should not be needed, it should be off if crc=0 AFAIK.

However, -n ftype=1 may still be enabled, and older kernels may have an
issue with that as well.

Feel free to add this to the wiki (can new accounts still be created?)

-Eric
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
