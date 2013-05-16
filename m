Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 798487F37
	for <xfs@oss.sgi.com>; Thu, 16 May 2013 10:35:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DD456AC00A
	for <xfs@oss.sgi.com>; Thu, 16 May 2013 08:35:16 -0700 (PDT)
Received: from mx2.ll.mit.edu (MX2.LL.MIT.EDU [129.55.12.46]) by cuda.sgi.com
	with ESMTP id AecZShvqa4xvIBXJ for <xfs@oss.sgi.com>;
	Thu, 16 May 2013 08:35:14 -0700 (PDT)
Message-ID: <5194FCAC.1010300@ll.mit.edu>
Date: Thu, 16 May 2013 11:35:08 -0400
From: David Oostdyk <daveo@ll.mit.edu>
MIME-Version: 1.0
Subject: Re: high-speed disk I/O is CPU-bound?
References: <518CFE7C.9080708@ll.mit.edu> <20130516005913.GE24635@dastard>
	<5194C4BB.9080406@hardwarefreak.com>
In-Reply-To: <5194C4BB.9080406@hardwarefreak.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6632954173790294043=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "stan@hardwarefreak.com" <stan@hardwarefreak.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============6632954173790294043==
Content-Type: multipart/signed; protocol="application/pkcs7-signature";
	micalg=sha1; boundary="------------ms040004020406070802070009"

--------------ms040004020406070802070009
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

On 05/16/13 07:36, Stan Hoeppner wrote:
> On 5/15/2013 7:59 PM, Dave Chinner wrote:
>> [cc xfs list, seeing as that's where all the people who use XFS in
>> these sorts of configurations hang out. ]
>>
>> On Fri, May 10, 2013 at 10:04:44AM -0400, David Oostdyk wrote:
>>> Hello,
>>>
>>> I have a few relatively high-end systems with hardware RAIDs which
>>> are being used for recording systems, and I'm trying to get a better
>>> understanding of contiguous write performance.
>>>
>>> The hardware that I've tested with includes two high-end Intel
>>> E5-2600 and E5-4600 (~3GHz) series systems, as well as a slightly
>>> older Xeon 5600 system.  The JBODs include a 45x3.5" JBOD, a 28x3.5"
>>> JBOD (with either 7200RPM or 10kRPM SAS drives), and a 24x2.5" JBOD
>>> with 10kRPM drives.  I've tried LSI controllers (9285-8e, 9266-8i,
>>> as well as the integrated Intel LSI controllers) as well as Adaptec
>>> Series 7 RAID controllers (72405 and 71685).
> So, you have something like the following raw aggregate drive b/w,
> assuming average outer-inner track 120MB/s streaming write throughput
> per drive:
>
> 45 drives ~5.4 GB/s
> 28 drives ~3.4 GB/s
> 24 drives ~2.8 GB/s
>
> The two LSI HBAs you mention are PCIe 2.0 devices.  Note that PCIe 2.0
> x8 is limited to ~4GB/s each way.  If those 45 drives are connected to
> the 9285-8e via all 8 SAS lanes, you are still losing about 1/3rd of th=
e
> aggregate drive b/w.  If they're connected to the 71685 via 8 lanes and=

> this HBA is in a PCIe 3.0 slot then you're only losing about 600MB/s.
>
>>> Normally I'll setup the RAIDs as RAID60 and format them as XFS, but
>>> the exact RAID level, filesystem type, and even RAID hardware don't
>>> seem to matter very much from my observations (but I'm willing to
>>> try any suggestions).
> Lack of performance variability here tends to suggest your workloads ar=
e
> all streaming in nature, and/or your application profile isn't taking
> full advantage of the software stack and the hardware, i.e. insufficien=
t
> parallelism, overlapping IOs, etc.  Or, see down below for another
> possibility.
>
> These are all current generation HBAs with fast multi-core ASICs and bi=
g
> write cache.  RAID6 parity writes even with high drive counts shouldn't=

> significantly degrade large streaming write performance.  RMW workloads=

> will still suffer substantially as usual due to rotational latencies.
> Fast ASICs can't solve this problem.
>
>> Document them. There's many ways to screw them up and get bad
>> performance.
> More detailed info always helps.
>
>>> As a basic benchmark, I have an application
>>> that simply writes the same buffer (say, 128MB) to disk repeatedly.
>>> Alternatively you could use the "dd" utility.  (For these
>>> benchmarks, I set /proc/sys/vm/dirty_bytes to 512M or lower, since
>>> these systems have a lot of RAM.)
>>>
>>> The basic observations are:
>>>
>>> 1.  "single-threaded" writes, either a file on the mounted
>>> filesystem or with a "dd" to the raw RAID device, seem to be limited
>>> to 1200-1400MB/sec.  These numbers vary slightly based on whether
>>> TurboBoost is affecting the writing process or not.  "top" will show
>>> this process running at 100% CPU.
>> Expected. You are using buffered IO. Write speed is limited by the
>> rate at which your user process can memcpy data into the page cache.
>>
>>> 2.  With two benchmarks running on the same device, I see aggregate
>>> write speeds of up to ~2.4GB/sec, which is closer to what I'd expect
>>> the drives of being able to deliver.  This can either be with two
>>> applications writing to separate files on the same mounted file
>>> system, or two separate "dd" applications writing to distinct
>>> locations on the raw device.
> 2.4GB/s is the interface limit of quad lane 6G SAS.  Coincidence?  If
> you've daisy chained the SAS expander backplanes within a server chassi=
s
> (9266-8i/72405), or between external enclosures (9285-8e/71685), and
> have a single 4 lane cable (SFF-8087/8088/8643/8644) connected to your
> RAID card, this would fully explain the 2.4GB/s wall, regardless of how=

> many parallel processes are writing, or any other software factor.
>
> But surely you already know this, and you're using more than one 4 lane=

> cable.  Just covering all the bases here, due to seeing 2.4 GB/s as the=

> stated wall.  This number is just too coincidental to ignore.

We definitely have two 4-lane cables being used, but this is an=20
interesting coincidence.  I'd be surprised if anyone could really=20
achieve the theoretical throughput on one cable, though.  We have one=20
JBOD that only takes a single 4-lane cable, and we seem to cap out at=20
closer to 1450MB/sec on that unit.  (This is just a single point of=20
reference, and I don't have many tests where only one 4-lane cable was=20
in use.)

>>> (Increasing the number of writers
>>> beyond two does not seem to increase aggregate performance; "top"
>>> will show both processes running at perhaps 80% CPU).
> So you're not referring to dd processes when you say "writers beyond
> two".  Otherwise you'd say "four" or "eight" instead of "both" processe=
s.
>
>> Still using buffered IO, which means you are typically limited by
>> the rate at which the flusher thread can do writeback.
>>
>>> 3.  I haven't been able to find any tricks (lio_listio, multiple
>>> threads writing to distinct file offsets, etc) that seem to deliver
>>> higher write speeds when writing to a single file.  (This might be
>>> xfs-specific, though)
>> How about using direct IO? Single threaded direct IO will beslower
>> than buffered IO, but throughput should scale linearly with the
>> number of threads if the IO size is large enough (e.g. 32MB).
> Try this quick/dirty parallel write test using dd with O_DIRECT file
> based output using 1MB IOs.  It fires up 16 dd processes writing 16
> files in parallel, 4GB each.  This test should give a fairly accurate
> representation of real hardware throughput.  Sum the MB/s figures from
> all dd processes for the aggregate b/w.
>
> #!/bin/sh
> for i in {1..16}
> do
>      dd if=3D/dev/zero of=3D/XFS_dir/file.$i oflag=3Ddirect bs=3D1M cou=
nt=3D4k &
> done
> wait
>
>>> 4.  Cheap tricks like making a software RAID0 of two hardware RAID
>>> devices does not deliver any improved performance for
>>> single-threaded writes.
> As Dave C points out, you'll never reach peak throughput with single
> threaded buffered IO.  You'd think it would be easy to hit peak write
> speed with a single 7.2k SATA drive using a single write thread.  Here'=
s
> a salient demonstration of why this may not be the case.
>
> $ dd if=3D/dev/zero of=3D/XFS-mount/one-thread bs=3D1M count=3D1000
> 1000+0 records in
> 1000+0 records out
> 1048576000 bytes (1.0 GB) copied, 17.8513 s, 58.7 MB/s
>
> Now a 4 thread variant of the script mentioned above:
>
> #!/bin/sh
> for i in {1..4}
> do
>      dd if=3D/dev/zero of=3D/XFS-mount/file.$i oflag=3Ddirect bs=3D1M c=
ount=3D512 &
> done
> wait
>
> $ test.sh
> 512+0 records in
> 512+0 records out
> 536870912 bytes (537 MB) copied, 20.3012 s, 26.4 MB/s
> 512+0 records in
> 512+0 records out
> 536870912 bytes (537 MB) copied, 20.3006 s, 26.4 MB/s
> 512+0 records in
> 512+0 records out
> 536870912 bytes (537 MB) copied, 20.3204 s, 26.4 MB/s
> 512+0 records in
> 512+0 records out
> 536870912 bytes (537 MB) copied, 20.324 s, 26.4 MB/s
>
> Single thread buffered write:	 59 MB/s
> Quad thread O_DIRECT write:	105 MB/s
>
> Again both targeting a single SATA disk.  I just ran these tests on a 1=
3
> year old machine with dual 550MHz Celeron CPUs and 384MB of PC100 DRAM,=

> vanilla kernel 3.2.6, deadline elevator.  The WD SATA disk is attached
> via a $20 USD Silicon Image 3512 SATA 150 32 bit PCI card lacking NCQ
> support.  The system bus is 33MHz/32 bit PCI only, 132MB/s peak, tested=

> at 115MB/s net after PCI 2.1 protocol overhead.  I keep this system
> around for such demonstrations.  Note that the SATA card and drive are
> 10 years newer than the core system, acquired in 2009.
>
> On this machine the single thread buffered IO dd run reaches only some
> 51% of the net PCI throughput and eats 98% of one of the two 550MHz
> CPUs.  This is due to a number of factors including, but not limited to=
,
> memcpy as Dave C points out, tiny 128KB L2 cache, no L3, the fact that
> this platform performs snooping on the P6 bus, and other inefficiencies=

> of the 440BX chipset.
>
> Now for the kicker.  Quad parallel dd direct IO reaches 92% of net PCI
> throughput with each dd process eating only 14% CPU, or 28% of each CPU=

> total.  Its aggregate file write throughput into XFS is some 78% higher=

> than single thread dd using buffered IO.
>
>> (Have not thoroughly tested this
>>> configuration fully with multiple writers, though.)
> You may not see a 78% bump with parallel O_DIRECT, but it should be
> substantial nonetheless.
>
>> Of course not - you are CPU bound and nothing you do to the storage
>> will change that.
> I'd agree 100% with Chinner if not for that pesky coincidental 2.4GB/s
> number reported as the "brick wall".  A little more info should clear
> this up.
>

You guys hit the nail on the head!  With O_DIRECT I can use a single=20
writer thread and easily see the same throughput that I _ever_ saw in=20
the multiple-writer case (~2.4GB/sec), and "top" shows the writer at 10% =

CPU usage.  I've modified my application to use O_DIRECT and it makes a=20
world of difference.

[It's interesting that you see performance benefits for O_DIRECT even=20
with a single SATA drive.  The reason it took me so long to test=20
O_DIRECT in this case, is that I never saw any significant benefit from=20
using it in the past.  But that is when I didn't have such fast storage, =

so I probably wasn't hitting the bottleneck with buffered I/O?]

So I have two systems, one with an LSI controller and one with an=20
Adaptec 71685, each has two 4-lane cables going to 24 and 28 disks=20
respectively, and they both are hitting about 2.4GB/sec.  I'm interested =

to test the Adaptec 74205 which is x8 3.0 and can connect six 4-lane=20
cables directly to 24 drives.  That might shed some light on whether the =

2.4GB/sec "limit" is due to cable throughput, and I will follow up if=20
that test proves interesting.

Thank you both for the suggestions!

- Dave O.



--------------ms040004020406070802070009
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
D0skdl6qA1tYS6574X3WMA4GA1UdDwEB/wQEAwIGwDAfBgNVHSMEGDAWgBSOSn2JoWMXHIGI
NFc3JkVeGYp+JDAzBgNVHR8ELDAqMCigJqAkhiJodHRwOi8vY3JsLmxsLm1pdC5lZHUvZ2V0
Y3JsL0xMQ0EyMGIGCCsGAQUFBwEBBFYwVDAtBggrBgEFBQcwAoYhaHR0cDovL2NybC5sbC5t
aXQuZWR1L2dldHRvL0xMQ0EyMCMGCCsGAQUFBzABhhdodHRwOi8vb2NzcC5sbC5taXQuZWR1
LzAMBgNVHRMBAf8EAjAAMD0GCSsGAQQBgjcVBwQwMC4GJisGAQQBgjcVCIOD5R2H7Kdmhq2H
FYPq8EWFtqEfHYXL3jKH/4pzAgFkAgEFMCIGA1UdJQEB/wQYMBYGCCsGAQUFBwMEBgorBgEE
AYI3CgMMMBgGA1UdIAQRMA8wDQYLKoZIhvcSAgEDAQgwGwYDVR0RBBQwEoEQZGF2ZW9AbGwu
bWl0LmVkdTANBgkqhkiG9w0BAQsFAAOCAQEACYYr080x/v17voPUMFd3/faEu5fnUZRwByaW
tiWl0ha7sPt79o+UbPLlyZH5p9O6nwb2TSyh4V3qWfZaohpck3CJJESddKzFiSE1PKC7Q0yY
gUUZyGSSO8YYwtVlxMWmmxEyF2fqUdiW83Y8q9K2NfpVoTB3Q9KGCBnVxQb7zwzXW44eEiFY
LqRO/bjLqrRbioeIts9AaoL9+9N4bhf9px3AMMv9V6ldZvxklsCAH9C9aKgnQwF/2ZxPMtuZ
CmzCekMApwNRKtp8nwnYHrELNHdyFGLFHz3ouv2X8z0/5QTpxjD5NaMy9X9mDtWFC2NVVWWB
gGprJ1tozPx87vtwDjCCBNEwggO5oAMCAQICCmIFT/YAAAAAOoIwDQYJKoZIhvcNAQELBQAw
UTELMAkGA1UEBhMCVVMxHzAdBgNVBAoTFk1JVCBMaW5jb2xuIExhYm9yYXRvcnkxDDAKBgNV
BAsTA1BLSTETMBEGA1UEAxMKTUlUTEwgQ0EtMjAeFw0xMjA1MjIxNDQwNDlaFw0xMzA1MjIx
NDQwNDlaMGIxCzAJBgNVBAYTAlVTMR8wHQYDVQQKExZNSVQgTGluY29sbiBMYWJvcmF0b3J5
MQ8wDQYDVQQLEwZQZW9wbGUxITAfBgNVBAMTGE9vc3RkeWsuRGF2aWQuSi41MDAwODgwMTCC
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
--------------ms040004020406070802070009--


--===============6632954173790294043==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6632954173790294043==--
