Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Nov 2006 02:46:41 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kA7AkYaG030004
	for <xfs@oss.sgi.com>; Tue, 7 Nov 2006 02:46:36 -0800
Received: from server1.spsn.net (server1.spsn.net [195.234.231.102])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5125550F14E
	for <xfs@oss.sgi.com>; Tue,  7 Nov 2006 02:45:47 -0800 (PST)
From: Sascha Nitsch <sgi@linuxhowtos.org>
Subject: Re: Weird performance decrease
Date: Tue, 7 Nov 2006 11:44:32 +0100
References: <200611061028.08963.sgi@linuxhowtos.org> <454FC5C3.8080803@agami.com>
In-Reply-To: <454FC5C3.8080803@agami.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200611071144.32925.sgi@linuxhowtos.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Shailendra Tripathi <stripathi@agami.com>
Cc: xfs@oss.sgi.com

On Tuesday 07 November 2006 00:31, you wrote:
> Hi Sascha,
>                   Did you notice the iostat -x on the device ? Please
> verify the turnaround time of the device when you are getting the slowdown.
>
> For example, if %b is closer towards 100, perhaps you are maxing out on
> the disk I/O ops per sec.
> Since you have only one disk, once I/O becomes random, the disk wouldn't
> be able to do more than 200-250 disk ops per sec.
>
> # iostat -x sda 1
>                              extended device statistics
> device mgr/s mgw/s    r/s    w/s    kr/s    kw/s   size queue   wait
> svc_t  %b
> sda        3     7    3.5   18.5   157.0   112.9   12.3   0.2    9.7
> 1.7   4
>
>
> Regards,
> Shailendra

Hi Shailendra,

here are some measurements:

== startup (very high performance) ==

top:
Cpu0  :  0.2% us,  0.0% sy,  0.0% ni, 99.8% id,  0.0% wa,  0.0% hi,  0.0% si
Cpu1  :  0.0% us,  0.0% sy,  0.0% ni, 100.0% id,  0.0% wa,  0.0% hi,  0.0% si
Cpu2  :  0.0% us,  0.0% sy,  0.0% ni, 100.0% id,  0.0% wa,  0.0% hi,  0.0% si
Cpu3  :  0.0% us,  0.0% sy,  0.0% ni, 100.0% id,  0.0% wa,  0.0% hi,  0.0% si
Mem:   2074432k total,   133784k used,  1940648k free,    15652k buffers
Swap:  2618488k total,      160k used,  2618328k free,    53508k cached

iostat -x
Device:    rrqm/s wrqm/s   r/s   w/s  rsec/s  wsec/s    rkB/s    wkB/s 
avgrq-sz avgqu-sz   await  svctm  %util
sdc          0.08   1.77  0.47  2.48    9.37   58.29     4.68    29.14    
22.94     0.32  107.23   3.07   0.91

== shortly before performance drops ==

top:
Cpu0  :  0.0% us,  0.2% sy,  0.0% ni, 99.8% id,  0.0% wa,  0.0% hi,  0.0% si
Cpu1  :  0.0% us,  0.2% sy,  0.0% ni, 99.8% id,  0.0% wa,  0.0% hi,  0.0% si
Cpu2  :  0.0% us,  0.0% sy,  0.0% ni, 100.0% id,  0.0% wa,  0.0% hi,  0.0% si
Cpu3  :  0.0% us,  0.0% sy,  0.0% ni, 100.0% id,  0.0% wa,  0.0% hi,  0.0% si
Mem:   2074432k total,  1342464k used,   731968k free,    17300k buffers
Swap:  2618488k total,      160k used,  2618328k free,   645180k cached

iostat -x
Device:    rrqm/s wrqm/s   r/s   w/s  rsec/s  wsec/s    rkB/s    wkB/s 
avgrq-sz avgqu-sz   await  svctm  %util
sdc          0.08   1.96  0.47  2.55    9.35   63.53     4.68    31.77    
24.11     0.35  115.27   3.05   0.92

== directly after drop ==
top:
Cpu0  :  0.0% us,  0.6% sy,  0.0% ni, 98.6% id,  0.6% wa,  0.2% hi,  0.0% si
Cpu1  :  0.0% us,  0.2% sy,  0.0% ni, 99.8% id,  0.0% wa,  0.0% hi,  0.0% si
Cpu2  :  0.0% us,  0.0% sy,  0.0% ni, 100.0% id,  0.0% wa,  0.0% hi,  0.0% si
Cpu3  :  0.0% us,  0.0% sy,  0.0% ni, 100.0% id,  0.0% wa,  0.0% hi,  0.0% si
Mem:   2074432k total,  1355704k used,   718728k free,      532k buffers
Swap:  2618488k total,      160k used,  2618328k free,   656548k cached

iostat -x
Device:    rrqm/s wrqm/s   r/s   w/s  rsec/s  wsec/s    rkB/s    wkB/s 
avgrq-sz avgqu-sz   await  svctm  %util
sdc          0.08   1.96  0.47  2.56    9.36   63.87     4.68    31.93    
24.16     0.35  115.32   3.05   0.93

notice the buffer size drop

== after running for a while with slow performance ==
top:
Cpu0  :  0.0% us,  1.0% sy,  0.0% ni, 85.0% id, 14.0% wa,  0.0% hi,  0.0% si
Cpu1  :  0.0% us,  0.2% sy,  0.0% ni, 97.0% id,  2.8% wa,  0.0% hi,  0.0% si
Cpu2  :  0.0% us,  0.0% sy,  0.0% ni, 100.0% id,  0.0% wa,  0.0% hi,  0.0% si
Cpu3  :  0.0% us,  0.0% sy,  0.0% ni, 100.0% id,  0.0% wa,  0.0% hi,  0.0% si
Mem:   2074432k total,  1065216k used,  1009216k free,      292k buffers
Swap:  2618488k total,      160k used,  2618328k free,   296888k cached

iostat -x
Device:    rrqm/s wrqm/s   r/s   w/s  rsec/s  wsec/s    rkB/s    wkB/s 
avgrq-sz avgqu-sz   await  svctm  %util
sdc          0.08   1.97  0.50  2.69   10.16   67.99     5.08    34.00    
24.52     0.36  111.35   3.10   0.99

without buffers and low cache it's no wonder that the io wait increases.
But why get the buffers and and cache disabled and not rebuild?


A Note: the workload and types of io operations are the same from the first to 
the last second, nothing is changing.
what iostat fails to detect ist that on average, there are ~60 reads/s and ~60 
writes/s.

Average read time is starting at 30ns/read attempt (on a non-existig file; 
put still pretty impressive)
write time (including average creation of 4.3 directories/write) starts 
at .3ms and it stays at that speed until the drop.

After that it start to increase to more than 19ms for read ops and 4ms for 
write ops.

I'm absolutely running out of possible ideas and workarounds.

Regards,
Sascha
