Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3NKZ66c085880
	for <linux-xfs@oss.sgi.com>; Fri, 23 Apr 2010 15:35:06 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4A7261317B5C
	for <linux-xfs@oss.sgi.com>; Fri, 23 Apr 2010 13:37:06 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id GENJWbfWf8KYJG5t for
	<linux-xfs@oss.sgi.com>; Fri, 23 Apr 2010 13:37:06 -0700 (PDT)
Message-ID: <4BD204F2.9020506@sandeen.net>
Date: Fri, 23 Apr 2010 15:37:06 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: How do I use "realtime subvolume" for storing video data?
References: <y2u389deec71004230221zb7fe7249g91f09cf4845ae4a6@mail.gmail.com>
In-Reply-To: <y2u389deec71004230221zb7fe7249g91f09cf4845ae4a6@mail.gmail.com>
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
> Hi, folks:
> I am using XFS in storing video suvillence data, and today I found
> "realtime subvolume" feature on SGI website. I used to make xfs with
> default parameters, but I think this feature is maybe very useful to
> me.
> SGI website said: XFS supports the notion of a "realtime subvolume" -
> a separate area of disk space where only file data is stored.  This is
> really what I need, since disk space become biger and biger nowerdays,
> if some sectors are corrupted, video data is lost which is acceptable
> but the whole XFS filesystem down is not acceptable.
> 
> I googled some information, but it seems that few people made use of
> this feature. I wonder if it is usable in my case and how do I use it?

build with CONFIG_XFS_RT=y, and see the mkfs man page for the -r option.

Then mount with -o rtdev=/dev/blah

And test the heck out of it, it doesn't get that much use.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
