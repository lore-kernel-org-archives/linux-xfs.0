Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB6DKTVw017186 for <xfs@oss.sgi.com>; Sat, 6 Dec 2008 07:20:29 -0600
Received: from bob.dscon.sk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 162221B949EA
	for <xfs@oss.sgi.com>; Sat,  6 Dec 2008 05:20:28 -0800 (PST)
Received: from bob.dscon.sk (bob.dscon.sk [88.86.113.10]) by cuda.sgi.com with
	ESMTP id ew8qzk8DwZZaXe6u for <xfs@oss.sgi.com>;
	Sat, 06 Dec 2008 05:20:28 -0800 (PST)
Date: Sat, 6 Dec 2008 14:20:26 +0100
Subject: Re: kernel 2.6.27.7 problem
Message-ID: <20081206132026.GA24765@bob.dscon.sk>
References: <20081206023608.GA22135@bob.dscon.sk>
	<4939F104.9060201@sandeen.net>
	<20081206091022.GA24158@bob.dscon.sk>
	<alpine.DEB.1.10.0812060712160.8516@p34.internal.lan>
	<alpine.DEB.1.10.0812060713010.8516@p34.internal.lan>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0812060713010.8516@p34.internal.lan>
From: xfs@bob.dscon.sk (DS)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: xfs@oss.sgi.com

iSCSI storage is nexsan SATA boy with 2 controlers, firmware was updated
few months ago

other 3 servers has data on this storage without problems (all on XFS)
all is going on same switch, all ports are in one storage VLAN

I don't know where "start debug" and it must be safe for data.

Dusan


On Sat, Dec 06, 2008 at 07:13:22AM -0500, Justin Piszcz wrote:
> 
> 
> On Sat, 6 Dec 2008, Justin Piszcz wrote:
> 
> >
> >
> >On Sat, 6 Dec 2008, DS wrote:
> >
> >>No other messages before. No iSCSI/network messages...nothing.
> >>Only this few lines and FS is down. After remount it works ....while and
> >>hangs again.
> >>Few hours it runs back on 2.6.24.3 and everything is OK.
> >>
> >>It's production system, but I test it again in late night.
> >>What can I do to identify problem?
> >>
> >>Dusan
> >
> >Run:
> >smartctl -a /dev/sde
> >
> >Post output.
> >
> >Justin.
> >
> >
> 
> AMD x64, debian stable (etch)
> filesytem is on iSCSI  storage
>                 ^^^^^^^^^^^^^^
> 
> Nevermind my comment above:
> 
> Is there anyway to test the health of the disks on the system?
> 
> Justin.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
