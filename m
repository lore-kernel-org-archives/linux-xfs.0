Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 06 Jul 2008 05:12:01 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m66CBvu9026375
	for <xfs@oss.sgi.com>; Sun, 6 Jul 2008 05:11:58 -0700
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3900F1882023
	for <xfs@oss.sgi.com>; Sun,  6 Jul 2008 05:13:00 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by cuda.sgi.com with ESMTP id PIx9q5kjpHAwonIm for <xfs@oss.sgi.com>; Sun, 06 Jul 2008 05:13:00 -0700 (PDT)
Date: Sun, 6 Jul 2008 08:13:00 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Lots of con-current I/O = resets SATA link? (2.6.25.10)
In-Reply-To: <alpine.DEB.1.10.0807060447180.5005@p34.internal.lan>
Message-ID: <alpine.DEB.1.10.0807060741010.4930@p34.internal.lan>
References: <fa.u8J+BqAcxU1mg8ob9pMBJaAHBPo@ifi.uio.no> <486FBFAB.5050303@shaw.ca> <alpine.DEB.1.10.0807051527210.8002@p34.internal.lan> <48700228.7060904@shaw.ca> <alpine.DEB.1.10.0807051923380.23222@p34.internal.lan>
 <alpine.DEB.1.10.0807060447180.5005@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, xfs@oss.sgi.com, Alan Piszcz <ap@solarrain.com>



On Sun, 6 Jul 2008, Justin Piszcz wrote:
> On Sat, 5 Jul 2008, Justin Piszcz wrote:
>> On Sat, 5 Jul 2008, Robert Hancock wrote:
>
> In short, utilizing Raptors (especially veliciraptors)+NCQ on the ICH8 w/AHCI 
> & other cards in a RAID 5 configuration is a death trap (a good way to lose 
> your data), it appears unsafe to use NCQ w/raptors in a RAID 5
> configuration.  I've defaulted back to disabling it like I always do
> and my RAID5 is rebuilding now.
>
> After the rebuild is completed I will perform more testing.

Running many parallel, tar, untar and copies of big fileskernel tarball and the kernel
source tree)

$ ps auxww | grep -c cp
437

$ ps auxww | grep -c tar
71

More than ~50k context switches..

procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
  9  8    160  48092    160 6640044    0    0   524 21776 2264 50571  0 27 30 43
  0  9    160  46572    160 6642572    0    0   220 22956 2032 45197  0 40 11 49
  0 47    160  51424    160 6642800    0    0     0 22900 1799 39694  0 57  5 38
  0  6    160  48916    160 6646272    0    0   112 23932 1763 41746  0 49 13 38
  0  7    160  49316    160 6646192    0    0     0 25712 1513 37190  0 20 30 50
  0  7    160  49240    160 6646264    0    0     0 28352 1853 38319  0 27 18 55
  0  1    160  46652    160 6649688    0    0   548 22800 1933 34609  0 22 69  8
  0  0    160  47032    160 6651108    0    0  2268 23652 1998 40729  0 22 56 22
  1  0    160  47192    160 6651580    0    0   340 21220 1718 34293  1 17 60 23

This is with the "noapic" boot option and NCQ disabled.

If there are no further errors I will reboot once more and re-run these tests 
without the "noapic" boot option and NCQ+irqbalance disabled as before I left 
NCQ enabled when irqbalance was disabled.

Trying to find a pattern here but not having much luck.

When all is said and done with over > 500 processes doing I/O with NCQ 
disabled and IRQ balance disabled w/noapic, I could not reproduce the 
problem.

The problem here is look at the IRQ routing, nearly every device is on IRQ 11:

$ cat /proc/interrupts
            CPU0       CPU1       CPU2       CPU3
   0:        100          0          0          0    XT-PIC-XT        timer
   1:          2          0          0          0    XT-PIC-XT        i8042
   2:          0          0          0          0    XT-PIC-XT        cascade
   8:          1          0          0          0    XT-PIC-XT        rtc
   9:      60454          0          0          0    XT-PIC-XT        acpi, HDA Intel, eth2
  10:     129911          0          0          0    XT-PIC-XT        pata_marvell, uhci_hcd:usb4, eth1
  11:   10278157          0          0          0    XT-PIC-XT        sata_sil24, sata_sil24, sata_sil24, ohci1394, ehci_hcd:usb1, ehci_hcd:usb2, uhci_hcd:usb3, uhci_hcd:usb5, uhci_hcd:usb6, uhci_hcd:usb7, i915@pci:0000:00:02.0
  12:          4          0          0          0    XT-PIC-XT        i8042
377:    3027113          0          0          0   PCI-MSI-edge      eth0
378:    9168537          0          0          0   PCI-MSI-edge      ahci
NMI:          0          0          0          0   Non-maskable interrupts
LOC:    9832917    9837364    9833540    9842241   Local timer interrupts
RES:    2313942    5729262    5207216    5776735   Rescheduling interrupts
CAL:      24888        884      25272      25155   function call interrupts
TLB:       7990      21120      23055      43247   TLB shootdowns
TRM:          0          0          0          0   Thermal event interrupts
THR:          0          0          0          0   Threshold APIC interrupts
SPU:          0          0          0          0   Spurious interrupts
ERR:          0

Justin.
