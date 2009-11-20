Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAKNiZQp215818 for <xfs@oss.sgi.com>; Fri, 20 Nov 2009 17:44:36 -0600
Received: from mx.tty.gr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3F239CD7B2F
	for <xfs@oss.sgi.com>; Fri, 20 Nov 2009 15:44:58 -0800 (PST)
Received: from mx.tty.gr (solitude.tty.gr [95.154.208.37]) by cuda.sgi.com
	with ESMTP id J2xk2qiFEM8d7xr5 for <xfs@oss.sgi.com>;
	Fri, 20 Nov 2009 15:44:58 -0800 (PST)
Message-ID: <4B0729D8.3000105@debian.org>
Date: Sat, 21 Nov 2009 01:44:24 +0200
From: Faidon Liambotis <paravoid@debian.org>
MIME-Version: 1.0
Subject: Re: Bug#557262: 2.6.31+2.6.31.4: XFS - All I/O locks up to D-state
	after	24-48 hours (sysrq-t+w available) - root cause found = asterisk
References: <alpine.DEB.2.00.0910171825270.16781@p34.internal.lan>	<alpine.DEB.2.00.0910181607040.27363@p34.internal.lan>	<20091019030456.GS9464@discord.disaster>	<alpine.DEB.2.00.0910190431180.23395@p34.internal.lan>	<20091020003358.GW9464@discord.disaster>	<alpine.DEB.2.00.0910200431290.21878@p34.internal.lan>	<alpine.DEB.2.00.0910210618210.10288@p34.internal.lan>
	<alpine.DEB.2.00.0911201530500.10757@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.00.0911201530500.10757@p34.internal.lan>
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
To: Justin Piszcz <jpiszcz@lucidpixels.com>, 557262@bugs.debian.org
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, submit@bugs.debian.org, asterisk-users@lists.digium.com, Alan Piszcz <ap@solarrain.com>

Justin Piszcz wrote:
 > Found root cause-- root cause is asterisk PBX software.  I use an
SPA3102.
> When someone called me, they accidentally dropped the connection, I called
> them back in a short period.  It is during this time (and the last time)
> this happened that the box froze under multiple(!) kernels, always when
> someone was calling.
<snip>
> I don't know what asterisk is doing but top did run before the crash
> and asterisk was using 100% CPU and as I noted before all other processes
> were in D-state.
> 
> When this bug occurs, it freezes I/O to all devices and the only way to
> recover
> is to reboot the system.
That's obviously *not* the root cause.

It's not normal for an application that isn't even privileged to hang
all I/O and, subsequently everything on a system.

This is almost probably a kernel issue and asterisk just does something
that triggers this bug.

Regards,
Faidon

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
