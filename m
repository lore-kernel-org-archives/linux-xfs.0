Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 03 Jun 2008 11:43:30 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m53IhQEa010702
	for <xfs@oss.sgi.com>; Tue, 3 Jun 2008 11:43:26 -0700
Received: from atlantis.cc.ndsu.NoDak.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8D4F611AD440
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2008 11:44:18 -0700 (PDT)
Received: from atlantis.cc.ndsu.NoDak.edu (atlantis.cc.ndsu.NoDak.edu [134.129.99.37]) by cuda.sgi.com with ESMTP id lZDqv4SpsKrmBiqC for <xfs@oss.sgi.com>; Tue, 03 Jun 2008 11:44:18 -0700 (PDT)
Date: Tue, 3 Jun 2008 13:44:17 -0500
From: Bryan Mesich <bryan.mesich@ndsu.edu>
Subject: Re: Limits of the 965 chipset & 3 PCI-e cards/southbridge?
	~774MiB/s peak for read, ~650MiB/s peak for write?
Message-ID: <20080603184417.GA23450@atlantis.cc.ndsu.NoDak.edu>
Reply-To: Bryan Mesich <bryan.mesich@ndsu.edu>
References: <alpine.DEB.1.10.0806010539430.24757@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0806010539430.24757@p34.internal.lan>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com

On Sun, Jun 01, 2008 at 05:45:39AM -0400, Justin Piszcz wrote:

> I am testing some drives for someone and was curious to see how far one can 
> push the disks/backplane to their theoretical limit.

This testing would indeed only suggest theoretical limits.  In a
production environment, I think a person would be hard pressed to
reproduce these numbers. 

> Does/has anyone done this with server intel board/would greater speeds be 
> achievable?

Nope, but your post inspired me to give it a try.  My setup is as
follows:

Kernel:			linux 2.6.25.3-18 (Fedora 9)
Motherboard:		Intel SE7520BD2-DDR2
SATA Controller:	(2) 8 port 3Ware 9550SX
Disks			(12) 750GB Seagate ST3750640NS

Disks sd[a-h] are plugged into the first 3Ware controller while
sd[i-l] are plugged into the second controller.  Both 3Ware cards
are plugged onto PCIX 100 slots.  The disks are being exported as
"single disk" and write caching has been disabled.  The OS is 
loaded on sd[a-d] (small 10GB partitions mirrored). For my first 
test, I ran dd on a single disk:

dd if=/dev/sde of=/dev/null bs=1M

dstat -D sde

----total-cpu-usage---- --dsk/sde-- -net/total- ---paging-- ---system--
usr sys idl wai hiq siq| read  writ| recv  send|  in   out | int   csw 
  0   7  53  40   0   0|  78M    0 | 526B  420B|   0     0 |1263  2559 
  0   8  53  38   0   0|  79M    0 | 574B  420B|   0     0 |1262  2529 
  0   7  54  39   0   0|  78M    0 | 390B  420B|   0     0 |1262  2576 
  0   7  54  39   0   0|  76M    0 | 284B  420B|   0     0 |1216  2450 
  0   8  54  38   0   0|  76M    0 | 376B  420B|   0     0 |1236  2489 
  0   9  54  36   0   0|  79M    0 | 397B  420B|   0     0 |1265  2537 
  0   9  54  37   0   0|  77M    0 | 344B  510B|   0     0 |1262  2872 
  0   8  54  38   0   0|  75M    0 | 637B  420B|   0     0 |1214  2992 
  0   8  53  38   0   0|  78M    0 | 422B  420B|   0     0 |1279  3179 

And for a write:

dd if=/dev/zero of=/dev/sde bs=1M

dstat -D sde

----total-cpu-usage---- --dsk/sde-- -net/total- ---paging-- ---system--
usr sys idl wai hiq siq| read  writ| recv  send|  in   out | int   csw 
  0   7   2  90   0   0|   0    73M| 637B  420B|   0     0 | 614   166 
  0   7   0  93   0   0|   0    73M| 344B  420B|   0     0 | 586   105 
  0   7   0  93   0   0|   0    75M| 344B  420B|   0     0 | 629   177 
  0   7   0  93   0   0|   0    74M| 344B  420B|   0     0 | 600   103 
  0   7   0  93   0   0|   0    73M| 875B  420B|   0     0 | 612   219 
  0   8   0  92   0   0|   0    68M| 595B  420B|   0     0 | 546   374 
  0   8   5  86   0   0|   0    76M| 132B  420B|   0     0 | 632   453 
  0   9   0  91   0   0|   0    74M| 799B  420B|   0     0 | 596   421 
  0   8   0  92   0   0|   0    74M| 693B  420B|   0     0 | 624   436 


For my next test, I ran dd on 8 disks (sd[e-l]).  These are
non-system disks (OS is installed on sd[a-d) and they are split
between the 3Ware controllers.  Here are my results:

dd if=/dev/sd[e-l] of=/dev/null bs=1M

dstat

----total-cpu-usage---- -dsk/total- -net/total- ---paging-- ---system--
usr sys idl wai hiq siq| read  writ| recv  send|  in   out | int   csw 
  0  91   0   0   1   8| 397M    0 | 811B  306B|   0     0 |6194  6654 
  0  91   0   0   1   7| 420M    0 | 158B  322B|   0     0 |6596  7097 
  1  91   0   0   1   8| 415M    0 | 324B  322B|   0     0 |6406  6839 
  1  91   0   0   1   8| 413M    0 | 316B  436B|   0     0 |6464  6941 
  0  90   0   0   2   8| 419M    0 |  66B  306B|   0     0 |6588  7121 
  1  91   0   0   2   7| 412M    0 | 461B  322B|   0     0 |6449  6916 
  0  91   0   0   1   7| 415M    0 | 665B  436B|   0     0 |6535  7044 
  0  92   0   0   1   7| 418M    0 | 299B  306B|   0     0 |6555  7028 
  0  90   0   0   1   8| 412M    0 | 192B  436B|   0     0 |6496  7014 

And for write:

dd if=/dev/zero of=/dev/sd[e-l] bs=1M

dstat

----total-cpu-usage---- -dsk/total- -net/total- ---paging-- ---system--
usr sys idl wai hiq siq| read  writ| recv  send|  in   out | int   csw 
  0  86   0   0   1  12|   0   399M| 370B  306B|   0     0 |3520   855 
  0  87   0   0   1  12|   0   407M| 310B  322B|   0     0 |3506   813 
  1  87   0   0   1  12|   0   413M| 218B  322B|   0     0 |3568   827 
  0  87   0   0   0  12|   0   425M| 278B  322B|   0     0 |3641   785 
  0  87   0   0   1  12|   0   430M| 310B  322B|   0     0 |3658   845 
  0  86   0   0   1  14|   0   421M| 218B  322B|   0     0 |3605   756 
  1  85   0   0   1  14|   0   417M| 627B  322B|   0     0 |3579   984 
  0  84   0   0   1  14|   0   420M| 224B  436B|   0     0 |3548  1006 
  0  86   0   0   1  13|   0   433M| 310B  306B|   0     0 |3679   836 


It seems that I'm running into a wall around 420-430M.  Assuming
the disks can push 75M, 8 disks should push 600M together.  This
is obviously not the case.  According to Intel's Tech
Specifications:

http://download.intel.com/support/motherboards/server/se7520bd2/sb/se7520bd2_server_board_tps_r23.pdf

I think the IO contention (in my case) is due to the PXH.

All and all, when it comes down to moving IO in reality, these
tests are pretty much useless in my opinion.  Filesystem overhead
and other operations limit the amount of IO that can be serviced
by the PCI bus and/or the block devices (although it's interesting 
to see if the theoretical speeds are possible).

For example, the box I used in the above example will be used as
a fibre channel target server. Below is a performance print out
of a running fibre target with the same hardware as tested above:

mayacli> show performance controller=fc1
        read/sec  write/sec IOPS      
        16k       844k      141       
        52k       548k      62        
        1m        344k      64        
        52k       132k      26        
        0         208k      27        
        12k       396k      42        
        168k      356k      64        
        32k       76k       16        
        952k      248k      124       
        860k      264k      132       
        1m        544k      165       
        1m        280k      166       
        900k      344k      105       
        340k      284k      60        
        1m        280k      125       
        1m        340k      138       
        764k      592k      118       
        1m        448k      127       
        2m        356k      276       
        2m        480k      174       
        2m        8m        144       
        540k      376k      89        
        324k      380k      77        
        4k        348k      71        

This particular fibre target is providing storage to 8
initiators, 4 of which are busy IMAP mail servers.  Granted this
isn't the busiest time of the year for us, but were not comming even
close to the numbers mentioned in the above example.

As always, corrections to my above bable are appreciated and
welcomed :-)

Bryan
