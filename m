Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 25 Sep 2007 07:10:55 -0700 (PDT)
Received: from smtp101-mob.biz.mail.re2.yahoo.com (smtp101-mob.biz.mail.re2.yahoo.com [206.190.36.116])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8PEAkQ3031471
	for <linux-xfs@oss.sgi.com>; Tue, 25 Sep 2007 07:10:50 -0700
Message-ID: <2136069753-1190727845-cardhu_decombobulator_blackberry.rim.net-1977171728-@bxe108.bisx.prod.on.blackberry>
Reply-To: b.j.smith@ieee.org
References: <20070923093841.GH19983@p15145560.pureserver.info><20070924173155.GI19983@p15145560.pureserver.info><Pine.LNX.4.64.0709241400370.12025@p34.internal.lan><20070924203958.GA4082@p15145560.pureserver.info><Pine.LNX.4.64.0709241642110.19847@p34.internal.lan><20070924213358.GB4082@p15145560.pureserver.info><Pine.LNX.4.64.0709241736370.19847@p34.internal.lan><20070924215223.GC4082@p15145560.pureserver.info><20070925123501.GA20499@p15145560.pureserver.info><Pine.LNX.4.64.0709250849560.11391@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0709250849560.11391@p34.internal.lan>
Subject: Re: mkfs options for a 16x hw raid5 and xfs (mostly large files)
From: "=?utf-8?B?QnJ5YW4gSiBTbWl0aA==?=" <b.j.smith@ieee.org>
Date: Tue, 25 Sep 2007 13:44:01 +0000
Content-Type: text/plain; charset="Windows-1252"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>, xfs-bounce@oss.sgi.com, Ralf Gross <Ralf-Lists@ralfgross.de>
Cc: linux-xfs@oss.sgi.com

There is not a week that goes by without this on some list.

Benchmarks not under load are useless, and hardware RAID
shows no advantage at all, and can actually be hurt since all
data is committed to the I/O controller synchronously at the driver.

Furthermore, there is a huge difference between software
RAID-5 reads and writes, and read benchmarks are basic RAID-0
(minus one disc) which is always faster with software RAID-0.

Again, testing under actual, production load is how you gage performance.

If your application is CPU bound, like most web servers, then software
RAID-5 is fine because A) little I/O is require, so there is plenty of
systen interconnect throughput available for LOAD-XOR-STOR,
and B) web servers are heavily reads more than writes.

But if your server is a file server, the the amount of inteconnect
required for the LOAD-XOR-STO of software RAID-5 detracts from
that available for the I/O intensive operations of the file service.
You can't measure that at the kernel at all, much less not under load.
Benchmark multiple clients hitting the server to see what they get.

Furthermore, when you're concerned about I/O, you don't stop
at your storage controller, but RX TOE with your HBA GbE NIC(s),
your latency v. throughput of your discs, etc...

--  
Bryan J Smith - mailto:b.j.smith@ieee.org  
http://thebs413.blogspot.com  
Sent via BlackBerry from T-Mobile  
    

-----Original Message-----
From: Justin Piszcz <jpiszcz@lucidpixels.com>

Date: Tue, 25 Sep 2007 08:50:15 
To:Ralf Gross <Ralf-Lists@ralfgross.de>
Cc:linux-xfs@oss.sgi.com
Subject: Re: mkfs options for a 16x hw raid5 and xfs (mostly large files)




On Tue, 25 Sep 2007, Ralf Gross wrote:

> Ralf Gross schrieb:
>>> What do you get when (reading) from the raw device?
>>>
>>> dd if=/dev/sda bs=1M count=10240
>>
>> The server has 16 GB RAM, so I tried it with 20 GB of data.
>>
>> dd if=/dev/sdd of=/dev/null bs=1M count=20480
>> 20480+0 Datensätze ein
>> 20480+0 Datensätze aus
>> 21474836480 Bytes (21 GB) kopiert, 95,3738 Sekunden, 225 MB/s
>>
>> and a second try:
>>
>> dd if=/dev/sdd of=/dev/null bs=1M count=20480
>> 20480+0 Datensätze ein
>> 20480+0 Datensätze aus
>> 21474836480 Bytes (21 GB) kopiert, 123,78 Sekunden, 173 MB/s
>>
>> I'm taoo tired to interprete these numbers at the moment, I'll do some
>> more testing tomorrow.
>
> There is a second RAID device attached to the server (24x RAID5). The
> numbers I get from this device are a bit worse than the 16x RAID 5
> numbers (150MB/s read with dd).
>
> I'm really wondering how people can achieve transfer rates of
> 400MB/s and more. I know that I'm limited by the FC controller, but
> I don't even get >200MB/s.
>
> Ralf
>
>

Perhaps something is wrong with your setup?

Here are my 10 raptors in RAID5 using Software RAID (no hw raid 
controller):

p34:~# dd if=/dev/md3 of=/dev/null bs=1M count=16384
16384+0 records in
16384+0 records out
17179869184 bytes (17 GB) copied, 29.8193 seconds, 576 MB/s
p34:~#
