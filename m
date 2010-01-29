Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0TG68YC128321
	for <linux-xfs@oss.sgi.com>; Fri, 29 Jan 2010 10:06:08 -0600
Received: from lo.gmane.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4F61B1363101
	for <linux-xfs@oss.sgi.com>; Fri, 29 Jan 2010 08:07:13 -0800 (PST)
Received: from lo.gmane.org (lo.gmane.org [80.91.229.12]) by cuda.sgi.com with
	ESMTP id FYbZDtlcUcFLzpkZ for <linux-xfs@oss.sgi.com>;
	Fri, 29 Jan 2010 08:07:13 -0800 (PST)
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1NatNH-0004Ew-PK
	for linux-xfs@oss.sgi.com; Fri, 29 Jan 2010 17:07:11 +0100
Received: from vm15c-113.broadinstitute.org ([69.173.114.122])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Fri, 29 Jan 2010 17:07:11 +0100
Received: from nico by vm15c-113.broadinstitute.org with local (Gmexim 0.1
	(Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Fri, 29 Jan 2010 17:07:11 +0100
From: Nicolas Stransky <nico@stransky.cx>
Subject: Re: Filesystem corrupted: "Sorry, could not find valid secondary
	superblock"
Date: Fri, 29 Jan 2010 11:06:48 -0500
Message-ID: <hjv12n$r2o$1@ger.gmane.org>
References: <hjus58$6oi$1@ger.gmane.org> <4B63010D.1080608@sandeen.net>
Mime-Version: 1.0
In-Reply-To: <4B63010D.1080608@sandeen.net>
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
To: linux-xfs@oss.sgi.com

On 1/29/10 10:38 AM, Eric Sandeen wrote:
> xfs_repair needs to be smarter about this; I at least wish it'd say 
> -why- the candidate was not valid.
> 
> Can you include the whole repair output?  Then maybe we can direct 
> you to some xfs_db jujitsu to examine the fs.
> 
> Trying newer xfsprogs would not be a -bad- idea...
> 
> -Eric

The output is as follows:

# xfs_repair /dev/sda
Phase 1 - find and verify superblock...
bad primary superblock - bad magic number !!!

attempting to find secondary superblock...
......................
found candidate secondary superblock...
unable to verify superblock, continuing...
......................
found candidate secondary superblock...
unable to verify superblock, continuing...
......................
[The previous one repeats hundreds of times over many hours]
......................
Sorry, could not find valid secondary superblock
Exiting now.


I am trying right now xfsprogs 3.1.0 from Debian testing, will see what
it gives...

Thanks!
NS

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
