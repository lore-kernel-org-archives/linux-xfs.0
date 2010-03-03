Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o230NcwV026448 for <xfs@oss.sgi.com>; Tue, 2 Mar 2010 18:23:39 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 95EB9211D0F
	for <xfs@oss.sgi.com>; Tue,  2 Mar 2010 16:25:04 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	Zuc94YFy0cExvh1K for <xfs@oss.sgi.com>;
	Tue, 02 Mar 2010 16:25:04 -0800 (PST)
Date: Wed, 3 Mar 2010 11:25:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Stalled xfs_repair on 100TB filesystem
Message-ID: <20100303002500.GH18369@discord.disaster>
References: <DD534F7C25BFA14FB18E6D603135D7EA0A11E82ECB@sbapexch05>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <DD534F7C25BFA14FB18E6D603135D7EA0A11E82ECB@sbapexch05>
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
To: Jason Vagalatos <Jason.Vagalatos@citrixonline.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, Mar 02, 2010 at 09:22:34AM -0800, Jason Vagalatos wrote:
> Hello, On Friday 2/26 I started an xfs_repair on a 100TB
> filesystem:
> =

> #> nohup xfs_repair -v -l /dev/logfs-sessions/logdev
> /dev/logfs-sessions/sessions >
> /root/xfs_repair.out.logfs1.sjc.02262010 &
> =

> I've been monitoring the process with 'top' and tailing the output
> file from the redirect above.=A0 I believe the repair has
> "stalled".=A0 When the process was running 'top' showed almost all
> physical memory consumed and 12.6G of virt memory consumed by
> xfs_repair.=A0 It made it all the way to Phase 6 and has been
> sitting at agno =3D 14 for almost 48 hours.=A0 The memory consumption
> of xfs_repair has ceased but the process is still "running" and
> consuming 100% CPU:

I wish we could reproduce hangs like this easily. I'd kill the
repair and run with the -P option. From the xfs_repair man page:

       -P     Disable prefetching of inode and directory blocks. Use
	      this option if you find xfs_repair gets stuck and
	      proceeding. Interrupting a stuck xfs_repair is safe.

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
