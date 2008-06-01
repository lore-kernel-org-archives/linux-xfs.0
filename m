Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 01 Jun 2008 04:25:22 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m51BPJMg025841
	for <xfs@oss.sgi.com>; Sun, 1 Jun 2008 04:25:19 -0700
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BD3ECC350E4
	for <xfs@oss.sgi.com>; Sun,  1 Jun 2008 04:26:10 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by cuda.sgi.com with ESMTP id TE43MHIAPR9a0CWz for <xfs@oss.sgi.com>; Sun, 01 Jun 2008 04:26:10 -0700 (PDT)
Date: Sun, 1 Jun 2008 07:26:09 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Limits of the 965 chipset & 3 PCI-e cards/southbridge? ~774MiB/s
 peak for read, ~650MiB/s peak for write?
In-Reply-To: <alpine.DEB.1.10.0806010700170.10729@p34.internal.lan>
Message-ID: <alpine.DEB.1.10.0806010721230.10729@p34.internal.lan>
References: <alpine.DEB.1.10.0806010539430.24757@p34.internal.lan> <alpine.DEB.1.10.0806010700170.10729@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com



On Sun, 1 Jun 2008, Justin Piszcz wrote:

>
> On Sun, 1 Jun 2008, Justin Piszcz wrote:
>
>> I have 12 enterprise-class seagate 1TiB disks on a 965 desktop board and it 
>> appears I have hit the limit, if I were able to get the maximum speed of 
>> all drives, ~70MiB/avg * 12 = 840MiB/s but it seems to stop aound 774 MiB/s 
>> (currently running badblocks on all drives)..
>
> Small correction, they are 7200.11 Seagate Desktop Drives (ST31000340AS), not 
> enterprise drives:
>
> http://www.seagate.com/ww/v/index.jsp?vgnextoid=0732f141e7f43110VgnVCM100000f5ee0a0aRCRD
> http://www.newegg.com/Product/Product.aspx?Item=N82E16822148274
>
>

http://www.intel.com/products/chipsets/g965/diagram.jpg

Basically it appears I am hammering the southbridge as for this board the 
PCI-e (x1) slots also traverse through the southbridge.

  6_SATA -> G965 ICH8
3_PCI-e -> G965 ICH8

>From which has to ship that data across the DMI (2GB) link to the 
northbridge.

If one utilized a 12, 16 or 24 port raid card (but used SW RAID) on the 
x16 slot on the northbridge itself, would this barrier exist as the:
GMCH<->CPU is (8.5GB/s)..?

Also on the X38 and X48 the speed increases slightly:
http://www.intel.com/products/chipsets/X38/X38_Block_Diagram.jpg (10.6GB/s)
http://www.intel.com/products/chipsets/x48/x48_block_diagram.jpg (12.8GB/s)

If one asks why would one need such speed?

Example:
LTO-4 drives can write at 120 MiB/s each:
http://en.wikipedia.org/wiki/Linear_Tape-Open

It is then therefore imperative one could sustain this rate to possibly 
multiple(!) tape drives on a single system.

Justin.
