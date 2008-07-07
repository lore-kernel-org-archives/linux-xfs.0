Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 Jul 2008 11:45:28 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m67IjPRh014564
	for <xfs@oss.sgi.com>; Mon, 7 Jul 2008 11:45:25 -0700
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 78DCE188738B
	for <xfs@oss.sgi.com>; Mon,  7 Jul 2008 11:46:29 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by cuda.sgi.com with ESMTP id zKX8fPDbbdWbNjbe for <xfs@oss.sgi.com>; Mon, 07 Jul 2008 11:46:29 -0700 (PDT)
Date: Mon, 7 Jul 2008 14:46:28 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 12 Veliciraptors again w/x4 card (1.1gbytes/sec aggregate
 read)!
In-Reply-To: <alpine.DEB.1.10.0807071436080.5166@p34.internal.lan>
Message-ID: <alpine.DEB.1.10.0807071442570.4709@p34.internal.lan>
References: <alpine.DEB.1.10.0807071424100.4694@p34.internal.lan> <alpine.DEB.1.10.0807071436080.5166@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com
Cc: Alan Piszcz <ap@solarrain.com>



On Mon, 7 Jul 2008, Justin Piszcz wrote:

>
>
> On Mon, 7 Jul 2008, Justin Piszcz wrote:
>
>> Each PCI-e x1 card has 1 veliciraptor on it now.
>> Got an x4 card wit 4 sata ports:
>> 
>> Not quite the > 1 gbyte/sec I was hoping for in regards to the reads
>> but pretty close!
>
> Going to remove one of the drives from the x1 card and put it on the x4
> card instead, then I will use all 4 SATA ports on the x4 and hopefully get
> better bw.
>

Four drives on the x4 card, MAX bandwidth for every disk.

p34:~# dd if=/dev/sdi of=/dev/null bs=1M &
[1] 4720
p34:~# dd if=/dev/sdj of=/dev/null bs=1M &
[2] 4721
p34:~# dd if=/dev/sdk of=/dev/null bs=1M &
[3] 4722
p34:~# dd if=/dev/sdl of=/dev/null bs=1M &
[4] 4723
p34:~#

120MiB/s per each one!

Re-running dd test with all 12 disks:

1.1 gigabytes per second read!

  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
  1  0    120  59104 6632220  52228    0    0     0    40  168  517  0  0 100  0
  0  0    120  59104 6632220  52228    0    0     0     0   20  291  0  0 100  0
  3 10    120  43516 6635576  51924    0    0 1051776    62 4221 12301  1 70 11 19
  6  9    160  44420 6634720  51788    0    0 1117284     0 4435 12308  1 75  5 19
  6  9    160  47436 6631100  51676    0    0 1110300     0 4449 11438  1 76  3 20
  2 10    160  46740 6632048  51948    0    0 1137920     0 4447 12251  1 75  8 17
  9  7    160  45248 6632056  52004    0    8 1127940    45 4559 13259  1 74  9 17
  3  9    160  44152 6634780  49960    0    0 1132032    12 4471 12962  0 75  8 16
  4  9    160  44160 6634960  49380    0    0 1129216     8 4430 12545  0 76  7 16

After:

About the same for write:
$ dd if=/dev/zero of=bigfile.1 bs=1M count=10240
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 20.4056 s, 526 MB/s

'nuff said for read :)
$ dd if=bigfile.1 of=/dev/null bs=1M count=10240
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 10.2841 s, 1.0 GB/s

Justin.
