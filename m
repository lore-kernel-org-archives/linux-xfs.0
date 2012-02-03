Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q13BsdJG125802 for <xfs@oss.sgi.com>; Fri, 3 Feb 2012 05:54:39 -0600
Received: from smtp.pobox.com (b-pb-sasl-quonix.pobox.com [208.72.237.35]) by
	cuda.sgi.com with ESMTP id OemHo9j1LQ6uomYA for
	<xfs@oss.sgi.com>; Fri, 03 Feb 2012 03:54:37 -0800 (PST)
Date: Fri, 3 Feb 2012 11:54:34 +0000
From: Brian Candler <B.Candler@pobox.com>
Subject: Re: Performance problem - reads slower than writes
Message-ID: <20120203115434.GA649@nsrc.org>
References: <20120130220019.GA45782@nsrc.org> <20120131020508.GF9090@dastard>
	<20120131103126.GA46170@nsrc.org>
	<20120131145205.GA6607@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120131145205.GA6607@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

uOn Tue, Jan 31, 2012 at 09:52:05AM -0500, Christoph Hellwig wrote:
> Try playing with the following tweaks to get larger I/O to the disk:
> 
>  a) make sure you use the noop or deadline elevators
>  b) increase /sys/block/sdX/queue/max_sectors_kb from its low default
>  c) dramatically increase /sys/devices/virtual/bdi/<major>:<minor>/read_ahead_kb

The default settings on this system are:

# cat /sys/block/sdb/queue/scheduler 
noop [deadline] cfq 

(I think the one in brackets is the active one)

# cat /sys/block/sdb/queue/max_sectors_kb 
512
# cat /sys/devices/virtual/bdi/8:16/read_ahead_kb
128

I did a series of tests where I increased either or both of those to 1024,
but it didn't make any difference to read throughput, which sat stubbornly
at 25MB/sec.  However I could see the difference in btrace and in tps
figures, showing a smaller number of larger transfers taking place.  It was
clearly doing the right thing: seek and read a large block of data, seek and
read the next large block of data, and so on.

Writing the files should (to my mind) require the same amount of seeking and
disk passing under the head, but it runs at 75MB/sec.

So I realised: when you are writing lots of files with write-behind caching,
the drive has a lot of opportunity for reordering those writes to minimise
the seek and rotational latency.  But when reading in a single thread, you
are doing sequential seek one - read one - seek two - read two - ...

It turns out the -c (concurrency) option to bonnie++ is ignored for the file
creation and reading test. So my next steps were:

* run 4 instances of bonnie++ concurrently on the same filesystem.

This did make some improvement. For the sequential file reading part, it got
me to 30MB/sec with bonnie++ reading 32k chunks, and 40MB/sec with it
reading 1024k chunks.  It fell back to 33MB/sec in the random file reading
part.

* write a script to do just a random read test, with varying levels of
concurrency.  The script is given below: it forks a varying number of
processes, each of which runs "dd" sequentially on a subset of the files.

First running with default params (max_sectors_kb=512, read_ahead_kb=128)

 #p  files/sec  dd_args
  1      39.87  bs=1024k iflag=direct		=> 25.9 MB/sec
  1      42.51  bs=1024k
  2      43.88  bs=1024k iflag=direct
  2      29.53  bs=1024k
  5      57.40  bs=1024k iflag=direct
  5      43.48  bs=1024k
 10      68.68  bs=1024k iflag=direct
 10      48.02  bs=1024k
 20      75.51  bs=1024k iflag=direct
 20      53.08  bs=1024k
 50      79.37  bs=1024k iflag=direct		=> 51.6 MB/sec
 50      51.30  bs=1024k

The files have an average size of 0.65MB, so I've converted some files/sec
into MB/sec.  What I found surprising was that the performance is lower with
iflag=direct for a single reader, but much higher with iflag=direct for
concurrent readers.

So I tried again with max_sectors_kb=1024, read_ahead_kb=1024

 #p  files/sec  dd_args
  1      39.95  bs=1024k iflag=direct
  1      42.21  bs=1024k
  2      43.14  bs=1024k iflag=direct
  2      47.93  bs=1024k
  5      56.68  bs=1024k iflag=direct
  5      61.95  bs=1024k
 10      68.35  bs=1024k iflag=direct
 10      75.50  bs=1024k                        => 49.1 MB/sec
 20      75.74  bs=1024k iflag=direct
 20      83.36  bs=1024k			=> 54.2 MB/sec
 50      79.45  bs=1024k iflag=direct
 50      86.58  bs=1024k			=> 56.3 MB/sec

Now it works better without iflag=direct. With 20+ readers the throughput is
approaching decent, albeit still a way from the 75MB/sec I achieve when
writing.

Next with max_sectors_kb=128, read_ahead_kb=1024 (just to see if smaller SATA
transfers work better than large ones)

 #p  files/sec  dd_args
  1      39.74  bs=1024k iflag=direct
  1      42.49  bs=1024k
  2      43.92  bs=1024k iflag=direct
  2      48.22  bs=1024k
  5      56.39  bs=1024k iflag=direct
  5      62.61  bs=1024k
 10      61.50  bs=1024k iflag=direct
 10      68.67  bs=1024k
 20      68.21  bs=1024k iflag=direct
 20      75.28  bs=1024k			=> 48.9 MB/s
 50      68.36  bs=1024k iflag=direct
 50      75.32  bs=1024k			=> 49.0 MB/s

Maybe tiny improvement at low concurrency, but worse at high concurrency
(presumably a larger number of queued I/Os is hitting a queue depth limit)

Finally with max_sectors_kb=1024, read_ahead_kb=1024, and the noop
scheduler:

root@storage1:~# echo noop >/sys/block/sdc/queue/scheduler
root@storage1:~# cat /sys/block/sdc/queue/scheduler
[noop] deadline cfq 

 #p  files/sec  dd_args
  1      40.19  bs=1024k iflag=direct
  1      41.98  bs=1024k
  2      43.63  bs=1024k iflag=direct
  2      48.24  bs=1024k
  5      56.97  bs=1024k iflag=direct
  5      62.86  bs=1024k
 10      68.68  bs=1024k iflag=direct
 10      76.81  bs=1024k
 20      76.03  bs=1024k iflag=direct
 20      85.17  bs=1024k			=> 55.4 MB/s
 50      76.58  bs=1024k iflag=direct
 50      83.66  bs=1024k

This may be slightly better than the deadline scheduler until we get to 50
concurrent readers.

FWIW, this is the controller:

[   12.855639] mpt2sas1: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (8183856 kB)
[   12.855801] mpt2sas1: PCI-MSI-X enabled: IRQ 68
[   12.855804] mpt2sas1: iomem(0x00000000fb8c0000), mapped(0xffffc90011788000), size(16384)
[   12.855806] mpt2sas1: ioport(0x0000000000008000), size(256)
[   13.142189] mpt2sas1: sending message unit reset !!
[   13.150164] mpt2sas1: message unit reset: SUCCESS
[   13.323195] mpt2sas1: Allocated physical memory: size(16611 kB)
[   13.323200] mpt2sas1: Current Controller Queue Depth(7386), Max Controller Queue Depth(7647)
[   13.323203] mpt2sas1: Scatter Gather Elements per IO(128)
[   13.553727] mpt2sas1: LSISAS2116: FWVersion(05.00.13.00), ChipRevision(0x02), BiosVersion(07.11.00.00)
[   13.553737] mpt2sas1: Protocol=(Initiator,Target), Capabilities=(TLR,EEDP,Snapshot Buffer,Diag Trace Buffer,Task Set Full,NCQ)
[   13.553814] mpt2sas1: sending port enable !!
[   13.555001] mpt2sas1: port enable: SUCCESS
[   13.559519] mpt2sas1: host_add: handle(0x0001), sas_addr(0x500062b2000b4c00), phys(16)

and the drives are Hitachi Deskstar 5K3000 HDS5C3030ALA630:

[   13.567932] scsi 5:0:1:0: Direct-Access     ATA      Hitachi HDS5C303 A580 PQ: 0 ANSI: 5
[   13.567946] scsi 5:0:1:0: SATA: handle(0x0012), sas_addr(0x4433221101000000), phy(1), device_name(0xcca2500032cd28c0)
[   13.567953] scsi 5:0:1:0: SATA: enclosure_logical_id(0x500062b2000b4c00), slot(1)
[   13.568041] scsi 5:0:1:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
[   13.568049] scsi 5:0:1:0: qdepth(32), tagged(1), simple(0), ordered(0), scsi_level(6), cmd_que(1)
[   13.568185] sd 5:0:1:0: Attached scsi generic sg2 type 0
[   13.569753] sd 5:0:1:0: [sdc] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
...
[   13.797275] sd 5:0:1:0: [sdc] Write Protect is off
[   13.797284] sd 5:0:1:0: [sdc] Mode Sense: 73 00 00 08
[   13.800400] sd 5:0:1:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA

They are "CoolSpin" drives of unspecified RPM, i.e. definitely not high
performance in absolute terms.  But if I can get the filesystem read
throughput to approach the write throughput, I'll be extremely happy.

Regards,

Brian.

------ 8< ---------------------------------------------------------------
#!/usr/bin/ruby -w

CORPUS = "/data/sdc/Bonnie.26384/*/*"

module Perftest
  def self.run(n_files, n_procs=1, dd_args="")
    files = Dir[CORPUS].sort_by { rand }[0, n_files]
    chunks = files.each_slice(n_files/n_procs).to_a[0, n_procs]
    n_files = chunks.map { |chunk| chunk.size }.inject(:+)
    t1 = Time.now
    @pids = chunks.map { |chunk| fork { run_single(chunk, dd_args); exit! } }
    @pids.delete_if { |pid| Process.waitpid(pid) }
    t2 = Time.now
    printf "%3d %10.2f  %s\n", n_procs, n_files/(t2-t1), dd_args
  end

  def self.run_single(files, dd_args)
    files.each do |f|
      system("dd if='#{f}' of=/dev/null #{dd_args} 2>/dev/null")
    end
  end

  def self.kill_all(sig="TERM")
    @pids.each { |pid| Process.kill(sig, pid) rescue nil }
  end
end

at_exit { Perftest.kill_all }

puts " #p  files/sec  dd_args"
[1,2,5,10,20,50].each do |nprocs|
  Perftest.run(4000, nprocs, "bs=1024k iflag=direct")
  Perftest.run(4000, nprocs, "bs=1024k")
end

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
