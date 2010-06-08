Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o58G3rn8220880 for <xfs@oss.sgi.com>; Tue, 8 Jun 2010 11:03:54 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8AE2D1B1B50E
	for <xfs@oss.sgi.com>; Tue,  8 Jun 2010 09:06:24 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id YUeKgmn24SHuGjcS for
	<xfs@oss.sgi.com>; Tue, 08 Jun 2010 09:06:24 -0700 (PDT)
Message-ID: <4C0E6A7F.2060808@sandeen.net>
Date: Tue, 08 Jun 2010 11:06:23 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH V3] xfstests: use stat not lstat when examining devices
References: <4C091B4E.5030503@sandeen.net>
	<4C0939B9.9000109@sandeen.net>	<4C093F22.1010006@sandeen.net>
	<1275676010.2317.53.camel@doink>
In-Reply-To: <1275676010.2317.53.camel@doink>
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
To: aelder@sgi.com
Cc: xfs-oss <xfs@oss.sgi.com>

Alex Elder wrote:
> On Fri, 2010-06-04 at 13:00 -0500, Eric Sandeen wrote:
>> If you try running xfstests on lvm volumes which are symlinks,
>> it'll fail to run several tests because our _require_scratch 
>> framework ultimately uses lstat not stat, and does not think 
>> the lvm device (which is usually a symlink to a dm-X device) 
>> is a block device.  Sigh.
>>
>> Just calling stat(1) with -L to follow the link should
>> suffice.
> 
> I wonder whether we'll find stat(1) output ever varies
> enough to affect this.
> 
> But otherwise this looks good to me.
> 
> Reviewed-by: Alex Elder <aelder@sgi.com>
> 
>> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Sorry, after all that I'm retracting this patch.  mount, /proc/mounts,
/etc/mtab etc just get very confused when using symlinked devices,
at least as xfstests wants to use them.

For now I'll just make my uber-harness resolve symlinks to the real
device (maybe that could be done in xfstests at some point)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
