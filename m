Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7FMhOmt205551 for <xfs@oss.sgi.com>; Sun, 15 Aug 2010 17:43:25 -0500
Received: from enyo.dsw2k3.info (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2F3E8170DF55
	for <xfs@oss.sgi.com>; Sun, 15 Aug 2010 15:43:52 -0700 (PDT)
Received: from enyo.dsw2k3.info (enyo.dsw2k3.info [195.71.86.239]) by
	cuda.sgi.com with ESMTP id n6RMuQLV75otcYry for
	<xfs@oss.sgi.com>; Sun, 15 Aug 2010 15:43:52 -0700 (PDT)
Date: Mon, 16 Aug 2010 00:43:41 +0200
From: Matthias Schniedermeyer <ms@citd.de>
Subject: Re: xfs.fsck change that is unhelpful
Message-ID: <20100815224341.GA9438@citd.de>
References: <4C670101.8050901@tlinx.org> <20100815005240.GH10429@dastard>
	<4C674AE8.7030107@tlinx.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C674AE8.7030107@tlinx.org>
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
To: Linda Walsh <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

On 14.08.2010 19:03, Linda Walsh wrote:
>
>
> Dave Chinner wrote:
>> On Sat, Aug 14, 2010 at 01:48:01PM -0700, Linda A. Walsh wrote:
>>> Some time ago, when I upgraded a system, I ran into problems when
>>> it hit a file system that was offline.  It wasn't a critical
>>> partition, so it normally wouldn't have been an issue, but somewhere
>>> along the line
>>> someone mangled fsck.xfs.
>>
>> fsck.xfs is behaving identically to e2fsck when presented with an
>> invalid block device - it exits with an error of 8, which is defined
>> as "operational error" in the e2fsck man page.
> ---
> 	That may be fine for the ext2 fs, but I am asserting that in actual
> practice, with xfs, it does more harm than good.

I would suggest using autofs, so that you can keep fstab to an absolut 
minimum.

Except for devices related to booting, i personally mount everything 
either with autofs or manually(In that case it's normaly a one-shot 
thing).

In my case that are all "non boot related" devices, DVD-drive, network 
filesystems, some "tmpfs"es for playing, removable-devices, etc.





Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
