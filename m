Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Nov 2006 10:38:48 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kA7IccaG015202
	for <xfs@oss.sgi.com>; Tue, 7 Nov 2006 10:38:39 -0800
Received: from ext.agami.com (64.221.212.177.ptr.us.xo.net [64.221.212.177])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B351CD1C6091
	for <xfs@oss.sgi.com>; Tue,  7 Nov 2006 10:37:50 -0800 (PST)
Message-ID: <4550D082.3030802@agami.com>
Date: Tue, 07 Nov 2006 10:29:22 -0800
From: Shailendra Tripathi <stripathi@agami.com>
MIME-Version: 1.0
Subject: Re: Weird performance decrease
References: <200611061028.08963.sgi@linuxhowtos.org> <454FC5C3.8080803@agami.com> <200611071144.32925.sgi@linuxhowtos.org>
In-Reply-To: <200611071144.32925.sgi@linuxhowtos.org>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Sascha Nitsch <sgi@linuxhowtos.org>
Cc: xfs@oss.sgi.com

Hi Sascha,
                 Please run the iostat continuously to monitor the disk 
performance. Please monitor the await field and %util field on the 
device. Looking at this, it does look like there is some bottleneck in 
I/O path (or number of requests generated are too high). Please note 
that when you take iostat just once, it gives the average stats on the 
device (accumulative). So, you are not getting the real picture.

However, I can see that the average I/O response time is way too high. 
(await=115.27). This means that an I/O has been spending average 115 ms 
(too bad). It includes the time it spent in the disk I/O queue (called 
elevator queue) and actual service time. Your disk is performing good as 
it is service time is 3.05 ms  This time has less to do with 
caching/buffers availability.

Again, it appears to me the number of requests generated are 
overwhelming the device. That is. the deivce has seen overwhelming I/O 
in recent past.

For example, when I do this:

dd if=/dev/zero of=/tmp/1 bs=32k count=100000

I see this (below). Note that I see await of 218 ms.
$  iostat -x  hda6

avg-cpu:  %user   %nice    %sys %iowait   %idle
           1.75    0.00    0.41    0.21   97.63

Device:    rrqm/s wrqm/s   r/s   w/s  rsec/s  wsec/s    rkB/s    wkB/s 
avgrq-sz avgqu-sz   await  svctm  %util
hda6         0.00   0.77  0.00  0.06    0.00    6.59     0.00     3.30   
114.62     0.01  218.10   2.22   0.01


> here are some measurements:
>
> == startup (very high performance) ==
>
> top:
> Cpu0  :  0.2% us,  0.0% sy,  0.0% ni, 99.8% id,  0.0% wa,  0.0% hi,  0.0% si
> Cpu1  :  0.0% us,  0.0% sy,  0.0% ni, 100.0% id,  0.0% wa,  0.0% hi,  0.0% si
> Cpu2  :  0.0% us,  0.0% sy,  0.0% ni, 100.0% id,  0.0% wa,  0.0% hi,  0.0% si
> Cpu3  :  0.0% us,  0.0% sy,  0.0% ni, 100.0% id,  0.0% wa,  0.0% hi,  0.0% si
> Mem:   2074432k total,   133784k used,  1940648k free,    15652k buffers
> Swap:  2618488k total,      160k used,  2618328k free,    53508k cached
>
> iostat -x
> Device:    rrqm/s wrqm/s   r/s   w/s  rsec/s  wsec/s    rkB/s    wkB/s 
> avgrq-sz avgqu-sz   await  svctm  %util
> sdc          0.08   1.77  0.47  2.48    9.37   58.29     4.68    29.14    
> 22.94     0.32  107.23   3.07   0.91
>
> == shortly before performance drops ==
>
> top:
> Cpu0  :  0.0% us,  0.2% sy,  0.0% ni, 99.8% id,  0.0% wa,  0.0% hi,  0.0% si
> Cpu1  :  0.0% us,  0.2% sy,  0.0% ni, 99.8% id,  0.0% wa,  0.0% hi,  0.0% si
> Cpu2  :  0.0% us,  0.0% sy,  0.0% ni, 100.0% id,  0.0% wa,  0.0% hi,  0.0% si
> Cpu3  :  0.0% us,  0.0% sy,  0.0% ni, 100.0% id,  0.0% wa,  0.0% hi,  0.0% si
> Mem:   2074432k total,  1342464k used,   731968k free,    17300k buffers
> Swap:  2618488k total,      160k used,  2618328k free,   645180k cached
>
> iostat -x
> Device:    rrqm/s wrqm/s   r/s   w/s  rsec/s  wsec/s    rkB/s    wkB/s 
> avgrq-sz avgqu-sz   await  svctm  %util
> sdc          0.08   1.96  0.47  2.55    9.35   63.53     4.68    31.77    
> 24.11     0.35  115.27   3.05   0.92
>
> == directly after drop ==
> top:
> Cpu0  :  0.0% us,  0.6% sy,  0.0% ni, 98.6% id,  0.6% wa,  0.2% hi,  0.0% si
> Cpu1  :  0.0% us,  0.2% sy,  0.0% ni, 99.8% id,  0.0% wa,  0.0% hi,  0.0% si
> Cpu2  :  0.0% us,  0.0% sy,  0.0% ni, 100.0% id,  0.0% wa,  0.0% hi,  0.0% si
> Cpu3  :  0.0% us,  0.0% sy,  0.0% ni, 100.0% id,  0.0% wa,  0.0% hi,  0.0% si
> Mem:   2074432k total,  1355704k used,   718728k free,      532k buffers
> Swap:  2618488k total,      160k used,  2618328k free,   656548k cached
>
> iostat -x
> Device:    rrqm/s wrqm/s   r/s   w/s  rsec/s  wsec/s    rkB/s    wkB/s 
> avgrq-sz avgqu-sz   await  svctm  %util
> sdc          0.08   1.96  0.47  2.56    9.36   63.87     4.68    31.93    
> 24.16     0.35  115.32   3.05   0.93
>
> notice the buffer size drop
>
> == after running for a while with slow performance ==
> top:
> Cpu0  :  0.0% us,  1.0% sy,  0.0% ni, 85.0% id, 14.0% wa,  0.0% hi,  0.0% si
> Cpu1  :  0.0% us,  0.2% sy,  0.0% ni, 97.0% id,  2.8% wa,  0.0% hi,  0.0% si
> Cpu2  :  0.0% us,  0.0% sy,  0.0% ni, 100.0% id,  0.0% wa,  0.0% hi,  0.0% si
> Cpu3  :  0.0% us,  0.0% sy,  0.0% ni, 100.0% id,  0.0% wa,  0.0% hi,  0.0% si
> Mem:   2074432k total,  1065216k used,  1009216k free,      292k buffers
> Swap:  2618488k total,      160k used,  2618328k free,   296888k cached
>
> iostat -x
> Device:    rrqm/s wrqm/s   r/s   w/s  rsec/s  wsec/s    rkB/s    wkB/s 
> avgrq-sz avgqu-sz   await  svctm  %util
> sdc          0.08   1.97  0.50  2.69   10.16   67.99     5.08    34.00    
> 24.52     0.36  111.35   3.10   0.99
>
> without buffers and low cache it's no wonder that the io wait increases.
> But why get the buffers and and cache disabled and not rebuild?
>
>
> A Note: the workload and types of io operations are the same from the first to 
> the last second, nothing is changing.
> what iostat fails to detect ist that on average, there are ~60 reads/s and ~60 
> writes/s.
>
> Average read time is starting at 30ns/read attempt (on a non-existig file; 
> put still pretty impressive)
> write time (including average creation of 4.3 directories/write) starts 
> at .3ms and it stays at that speed until the drop.
>
> After that it start to increase to more than 19ms for read ops and 4ms for 
> write ops.
>
> I'm absolutely running out of possible ideas and workarounds.
>
> Regards,
> Sascha
>   
