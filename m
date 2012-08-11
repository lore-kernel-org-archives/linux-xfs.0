Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7BLjtth022391 for <xfs@oss.sgi.com>; Sat, 11 Aug 2012 16:45:55 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id J3yhNg4FmESIhCb0 for <xfs@oss.sgi.com>;
	Sat, 11 Aug 2012 14:45:54 -0700 (PDT)
Message-ID: <5026D290.10209@sandeen.net>
Date: Sat, 11 Aug 2012 16:45:52 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: bad version from xfs_repair after raid crash
References: <27CE2179D1925A4F9F4874725C3B4E0F0C5EFB6E94@COSMOS.nbg.geneon.de>
In-Reply-To: <27CE2179D1925A4F9F4874725C3B4E0F0C5EFB6E94@COSMOS.nbg.geneon.de>
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
To: Andreas Vogler <andreas.vogler@geneon.de>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 8/11/12 9:59 AM, Andreas Vogler wrote:
> Hi all,
> 
> we had a crash of a raid 5 system. After rebuilding we could access one of  two partitions. Upon mounting the second parttion we got an error "mount: Structure needs cleaning". So we tried using xfs_repair.
> 
> Xfs_repair returns: "bad primary superblock - bad version number !!!"
> 
> and tries to find a secondary superblock but gives up after scanning the volume.
> 
> Looking at the superblock with xfs_db looks good as far as I can tell. Can anybody give me a hint what "bad version number" means?

There is a version number in the superblock itself, which must have features recognized by repair.

Is your xfsprogs version up to date?

You could also include another email with the output from xfs_db -c "sb 0" -c "p" /dev/blah

-Eric

> Thank you very much in advance.
> 
>   Andreas Vogler
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
