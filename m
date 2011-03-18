Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2IJO7vf051552 for <xfs@oss.sgi.com>; Fri, 18 Mar 2011 14:24:12 -0500
Received: from netrider.rowland.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 8BB035065C0
	for <xfs@oss.sgi.com>; Fri, 18 Mar 2011 12:26:53 -0700 (PDT)
Received: from netrider.rowland.org (netrider.rowland.org [192.131.102.5]) by
	cuda.sgi.com with SMTP id jDwRbKmRgzPUmhrO for
	<xfs@oss.sgi.com>; Fri, 18 Mar 2011 12:26:53 -0700 (PDT)
Date: Fri, 18 Mar 2011 15:26:52 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: 2.6.38: XFS/USB/HW issue, or failing USB stick?
In-Reply-To: <alpine.DEB.2.02.1103181346340.21715@p34.internal.lan>
Message-ID: <Pine.LNX.4.44L0.1103181523500.14876-100000@netrider.rowland.org>
MIME-Version: 1.0
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
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Alan Piszcz <ap@solarrain.com>, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Fri, 18 Mar 2011, Justin Piszcz wrote:

> > The stick didn't "fail" in any obvious way, but for some reason it was
> > disconnected from the USB bus.  (If it initiated that disconnect by
> > itself, I guess you could consider that a failure.)  Maybe it was
> > something as simple as overheating causing a loss of electrical contact
> > between the connector and the pins in the USB port.
> 
> It is possible, but the box is kept cool:

Then something else caused the disconnection.  Maybe a bug in the USB 
stick's firmware.

> >> Mar 18 08:33:06 atom [ 2283.963059] usb 1-1: new high speed USB device using ehci_hcd and address 4
> >> Mar 18 08:33:06 atom [ 2284.080647] usb 1-1: New USB device found, idVendor=0325, idProduct=ac02
> >> Mar 18 08:33:06 atom [ 2284.080707] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> >> Mar 18 08:33:06 atom [ 2284.080752] usb 1-1: Product: R2_TURBO
> >> Mar 18 08:33:06 atom [ 2284.080794] usb 1-1: Manufacturer: OCZ Technology
> >> Mar 18 08:33:06 atom [ 2284.080831] usb 1-1: SerialNumber: (removed)
> >
> > And then 22 seconds later it reconnected.
> >
> > Alan Stern
> >
> 
> Very strange, could some USB option cause this?

No.

>  I guess next step is use
> ext2 and a different stick in the same port to see if I can get it to recur.
> Then if it happens again, try a different port.

Okay, go ahead and see what happens.

Alan Stern

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
