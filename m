Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7S4GiCH129930 for <xfs@oss.sgi.com>; Thu, 27 Aug 2009 23:16:55 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1B6DB1571D9C
	for <xfs@oss.sgi.com>; Thu, 27 Aug 2009 21:17:30 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 0mUOcTx3uJSi2zfA for
	<xfs@oss.sgi.com>; Thu, 27 Aug 2009 21:17:30 -0700 (PDT)
Message-ID: <4A975A35.3060809@sandeen.net>
Date: Thu, 27 Aug 2009 21:16:53 -0700
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs data loss
References: <B9A7B002C7FAFC469D4229539E909760308DA651DE@DU-EXC-MAIL.empa.emp-eaw.ch>
In-Reply-To: <B9A7B002C7FAFC469D4229539E909760308DA651DE@DU-EXC-MAIL.empa.emp-eaw.ch>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "Passerone, Daniele" <Daniele.Passerone@empa.ch>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Passerone, Daniele wrote:
> Dear xfs developers
> 
> We have a SUN X4500 with 48 500 GB drives, that we configured under SUSE SLES 10.
> 
> Among others, we have 3 RAID5 xfs filesystems, /dev/md4 with 20 units (9.27 TB)
> /dev/md5 with 20 units (9.27 TB) and /dev/md6 with 5 units (1.95 TB)
> 
> These units are not backed up.
> 
> Due to a power shock, suddenly and without log messages about one half (5 TB) of the user 
> directories on /dev/md4 have disappeared.

I presume you mean after a reboot?

> Upon reboot, /dev/md6 showed only 3 units, and after a xfs_repair it was again ok.
> /dev/md4 mounted immediately, but always with one half of the directories.

Were the lost directories recently created?  I've never heard of 
untouched, existing directories disappearing after a power loss...

> WHat can I do? Any help would be appreciated, I would really be happy to recover those files...
> :)

Not much to go on here I'm afraid.  SLES10 is an old kernel, but it's 
supported by SuSE at least.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
