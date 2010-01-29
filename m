Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0TFblD1126804
	for <linux-xfs@oss.sgi.com>; Fri, 29 Jan 2010 09:37:47 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D5A411C8B320
	for <linux-xfs@oss.sgi.com>; Fri, 29 Jan 2010 07:38:53 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id hvcxEwyMmDtHKlVM for
	<linux-xfs@oss.sgi.com>; Fri, 29 Jan 2010 07:38:53 -0800 (PST)
Message-ID: <4B63010D.1080608@sandeen.net>
Date: Fri, 29 Jan 2010 09:38:53 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Filesystem corrupted: "Sorry,	could not find valid secondary
	superblock"
References: <hjus58$6oi$1@ger.gmane.org>
In-Reply-To: <hjus58$6oi$1@ger.gmane.org>
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
To: Nicolas STRANSKY <Nico@stransky.cx>
Cc: linux-xfs@oss.sgi.com

Nicolas STRANSKY wrote:
> Hi,
> 
> I'm using Debian Lenny with xfsprogs 2.9.8-1lenny1 and a kernel
> 2.6.26-2-amd64. Recently I had some disk failures on a 1.5TB RAID 5
> array, which is now running in a degraded mode but the xfs filesystem on
> this array is inconsistent. I can mount it with -o ro,norecovery and
> read some files, but I can't read most of them.
> Using xfs_repair, I tried to repair the filesystem. It went for 12
> hours, displaying these messages:
> "found candidate secondary superblock...
> unable to verify superblock, continuing..."
> and finally:
> "Sorry, could not find valid secondary superblock
> Exiting now."
> 
> Is there anything else I could do to repair the filesystem? Upgrade to a
> newer version of xfsprogs? Is it possible that there is no valid
> secondary superblock on the whole disk or are they just not found?
> 
> Thanks a lot for any help,
> NS.

xfs_repair needs to be smarter about this; I at least wish it'd say
-why- the candidate was not valid.

Can you include the whole repair output?  Then maybe we can direct
you to some xfs_db jujitsu to examine the fs.

Trying newer xfsprogs would not be a -bad- idea...

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
