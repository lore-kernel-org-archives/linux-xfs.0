Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4IMlOlG255947 for <xfs@oss.sgi.com>; Fri, 18 May 2012 17:47:24 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id dar3lKfnq3eOE4Gp for <xfs@oss.sgi.com>;
	Fri, 18 May 2012 15:47:23 -0700 (PDT)
Message-ID: <4FB6D17A.7070408@sandeen.net>
Date: Fri, 18 May 2012 17:47:22 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: How to recover data from an xfs partition
References: <4FAE9DBF.1090505@linuxsystems.it> <20120518143143.GN16099@sgi.com>
	<4FB66430.9040202@linuxsystems.it> <4FB68AF6.1090303@sandeen.net>
	<4FB6B7AB.8030405@linuxsystems.it>
In-Reply-To: <4FB6B7AB.8030405@linuxsystems.it>
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
To: =?ISO-8859-1?Q?Niccol=F2_Belli?= <darkbasic@linuxsystems.it>
Cc: xfs@oss.sgi.com

On 5/18/12 3:57 PM, Niccol=F2 Belli wrote:
> Il 18/05/2012 19:46, Eric Sandeen ha scritto:
>> the file backing it - what was that stored on?
> =

> It was a raw image created with dd and stored on an SSD (ext4). Some
> of the virtual machines were on traditional hard disks instead
> (ext4).
> =

> Only the running virtual machines got damaged, the main filesystems
> are perfect.
> =

>> What it was that did the scribbling
> =

> Rebooting. A simple, stupid reboot after upgrading Xen. While
> rebooting the system I got some kind of kernel panic and I had to use
> magic sysrq keys (remount read-only, sync, reboot).

Well - somehow the first sector of the xfs image got junk written into it...
hard to say how that happened, but the magic number lives in the
first sector of the xfs image hosted on ext4, and it was junk post-reboot.

I have never seen xfs corrupt _itself_ this way.  TBH I'd be as likely to
blame the SSD, as anything.  But you also have to have all of the data
integrity bits set up properly all along the virt stack to survive
a panic or power loss w/o corruption after the fact.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
