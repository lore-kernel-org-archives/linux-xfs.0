Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4GHvV1L179010 for <xfs@oss.sgi.com>; Sun, 16 May 2010 12:57:31 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C81121308179
	for <xfs@oss.sgi.com>; Sun, 16 May 2010 11:00:40 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 4ArvD89tQzdezXg2 for
	<xfs@oss.sgi.com>; Sun, 16 May 2010 11:00:40 -0700 (PDT)
Message-ID: <4BF03290.6080803@sandeen.net>
Date: Sun, 16 May 2010 12:59:44 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Structure needs cleaning - Seagate Expansion External HDD 2TB USB
References: <4BEF12A5.2030505@btinternet.com>
In-Reply-To: <4BEF12A5.2030505@btinternet.com>
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
To: Marcel z maleho mesta <newsx@btinternet.com>
Cc: xfs@oss.sgi.com

On 05/15/2010 04:31 PM, Marcel z maleho mesta wrote:
> Hi all,
> 
> I'm new to Linux (still got Win XP running on my laptops :(, but 
> installed on my old machine Fedora 12, which looks really good :)
> 
> I have got a problem with my external Seagate Expansion External HDD 2TB 
> USB drive which has been connected to my NAS Bufallo LinkStation Mini.
> 
> I did have to disconnect the USB drive from NAS one day and since then 
> it would not be recognised by NAS. So have tried some Win tools, but the 
> USB drive has got XFS file system.

Ok, so some unknown thing went wrong by this point.

> When I plug it to pc running Fedora 12, Palimpsest Disk Utility see the 
> Hard Drive, but when I attempt to Mount the drive Error mounting device 
> - Unknown error msg. comes up.
> Details:
> Error mounting: mount: Structure needs cleaning.

At that point, type "dmesg" to see what error is in the kernel log.

> Have googled it: 
> http://xfs.org/index.php/XFS_FAQ#Q:_I_see_applications_returning_error_990_or_.22Structure_needs_cleaning.22.2C_what_is_wrong.3F
> and tried xfs_repair /dev/sdb1 and xfs_check /dev/sdb1 and can Mount the 
> disk and all the folders in root apart from few files are ok "copied 
> into Lost+Found Folder", but the most important one "DVBgrab" with about 
> 400Gb of data :( (each file is between 1 and 2 Gb)

I didn't parse that very well, I'm afraid, but - either your files are
where they should be, or they are under lost+found, or they are more or
less lost, though some sort of pattern search over the drive might work.

> Are those files gone, or is there a chance that they can be somehow 
> recovered with combination of xfs_repair commands?

You've already run repair, there is no magical "recover my lost data"
option to it, I'm afraid.

There's really not much to go on here, other than "something corrupted
your filesystem," probably while attached to the buffalo device, and it
sounds like some data was lost.

-Eric

> 
> Thanx in advance.
> 
> Marcel

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
