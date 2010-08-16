Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7G9he1A231153 for <xfs@oss.sgi.com>; Mon, 16 Aug 2010 04:43:41 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 62B834BE627
	for <xfs@oss.sgi.com>; Mon, 16 Aug 2010 02:44:08 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id DLlXVlTYZqwj8lYn
	for <xfs@oss.sgi.com>; Mon, 16 Aug 2010 02:44:08 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id A17436C2D8
	for <xfs@oss.sgi.com>; Mon, 16 Aug 2010 04:44:08 -0500 (CDT)
Message-ID: <4C690868.6040209@hardwarefreak.com>
Date: Mon, 16 Aug 2010 04:44:08 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: xfs.fsck change that is unhelpful
References: <4C670101.8050901@tlinx.org>
	<20100815005240.GH10429@dastard>	<4C674AE8.7030107@tlinx.org>
	<20100816015505.GJ10429@dastard> <4C68A1CC.4050206@tlinx.org>
In-Reply-To: <4C68A1CC.4050206@tlinx.org>
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
To: xfs@oss.sgi.com

Linda Walsh put forth on 8/15/2010 9:26 PM:

>     That said -- how many people, who have their /home or /usr/people
> partition
> 'local' to their machine, automount it?  

I do.  Who wouldn't?  And why not?

/dev/sda6  /home     xfs   defaults   0     0
/dev/sda7  /samba    xfs   defaults   0     0


> I admit to thinking of the fsck
> field as having
> some meaning in the order in which file systems are mounted.  I guess
> that order is
> random now, though how I'm supposed to tell mount that '/home needs to
> be mounted
> only after "/", but need to be mounted before /home/share, without some
> ordering
> in fstab is something that is supposed to be specified....where?

The device mount order is defined by the lines in the fstab file.  Devices are
mounted in order, top to bottom, as each line is read.

>     I.e. isn't that field also the order in which file systems are
> mounted, or
> is there some other place that order is maintained other than in fstab?

>     Sorry, am definitely showing my ignorance in this area.

No need to apologize.  This is easily remedied by learning.  Start here:

      In general, file system mount order is determined by the order in which
the file systems appear in the fstab file. The exceptions to this ordering are
file systems mounted with the _netdev flag or filesystems that have their own
init scripts.

      A file system with its own init script is mounted later in the
initialization process, after the file systems in the fstab file.

      File systems mounted with the _netdev flag are mounted when the network
has been enabled on the system.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
