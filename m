Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1FJIpo1091210 for <xfs@oss.sgi.com>; Sun, 15 Feb 2009 13:18:51 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6EC5B122DD7
	for <xfs@oss.sgi.com>; Sun, 15 Feb 2009 11:18:17 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id V2Am1sMYHrFrff9N for
	<xfs@oss.sgi.com>; Sun, 15 Feb 2009 11:18:17 -0800 (PST)
Date: Sun, 15 Feb 2009 14:18:16 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Oops during umount of r/o file system
Message-ID: <20090215191816.GA4626@infradead.org>
References: <499540B1.2080100@decisionsoft.co.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <499540B1.2080100@decisionsoft.co.uk>
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
To: Stuart Rowan <strr-debian@decisionsoft.co.uk>
Cc: xfs@oss.sgi.com

On Fri, Feb 13, 2009 at 09:43:13AM +0000, Stuart Rowan wrote:
> I fetched and installed the linux-image-2.6.26-bpo.1-amd64 package from  
> backports.org.
>
> This is the Debian lenny kernel, but backported to etch. It looks to be  
> 2.6.26.8 and a few patches. I realise the "and a few patches" sounds bad  
> but usually with Debian they are minor things like adding device ids.
>
> uname -a:
> Linux tigris 2.6.26-bpo.1-amd64 #1 SMP Wed Dec 17 12:18:36 UTC 2008  
> x86_64 GNU/Linux
>
> We do the following as part of our backup script:
>
> mkdir -p /tmp/dev/data/home-xfs; /usr/sbin/xfs_freeze -f /home ;  
> /sbin/lvcreate -s -L 20G -n snap-shot /dev/data/home-xfs ;  
> /usr/sbin/xfs_freeze -u /home && mount -o nouuid,ro /dev/data/snap-shot  
> /tmp/dev/data/home-xfs
>
> (rsync the snapshot offsite)
>
> umount /tmp/dev/data/home-xfs ; /sbin/lvremove -f /dev/data/snap-shot
>
> The umount, intermittently, of this ro filesystem hangs until a reboot  
> as below.

Any chance you could capture the output of dmesg after an

	echo t > /proc/sysrq-trigger

to see where it hangs exactly?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
