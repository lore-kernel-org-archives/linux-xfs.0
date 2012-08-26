Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7QKAh4B158474 for <xfs@oss.sgi.com>; Sun, 26 Aug 2012 15:10:43 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id kpcedBh8lNPG33RD for <xfs@oss.sgi.com>;
	Sun, 26 Aug 2012 13:11:32 -0700 (PDT)
References: <CAAxjCEwdYbcDoUvcAV1n8281HCCvrCvReaG2oM5+h+WV5yDZvA@mail.gmail.com>
In-Reply-To: <CAAxjCEwdYbcDoUvcAV1n8281HCCvrCvReaG2oM5+h+WV5yDZvA@mail.gmail.com>
Mime-Version: 1.0 (1.0)
Message-Id: <1104CDC2-47D2-40CF-8294-A17E33125D54@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: umount doesn't seem to really unmount
Date: Sun, 26 Aug 2012 13:11:29 -0700
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
To: Stefan Ring <stefanrin@gmail.com>
Cc: Linux fs XFS <xfs@oss.sgi.com>

On Aug 26, 2012, at 2:32 AM, Stefan Ring <stefanrin@gmail.com> wrote:

> Today I had some data loss with an XFS filesystem, apparently because
> it does not write everything to disk during unmount. Yesterday, I shut
> down my machine for the night. My XFS lives on an iSCSI volume which I
> shut down shortly, but not instantly, after unmounting the XFS
> filesystem. There has been no noticable disk activity after the
> umount. Today, some recently written files all had size zero.
> Additional indicators that something is amiss is, that during startup,
> when mounting the XFS filesystem, it would often claim that it has
> done log recovery, which should not be the case if it had been
> unmounted correctly. Also, when I just mount and unmount the
> filesystem repeatedly, I would at least expect "ending clean mount"
> messages in dmesg, like I get on CentOS 6. Not so on my system.
> 
> This is with kernel 3.5.2-3.fc17 from Fedora. Is there a known problem?
> 
Do you have barriers on and does iscsi pass them through to the target, and does the target propagate them to the disk itself?

Eric

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
