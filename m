Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Aug 2008 23:44:00 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7K6hviG025149
	for <linux-xfs@oss.sgi.com>; Tue, 19 Aug 2008 23:43:58 -0700
Received: from nf-out-0910.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 98008F7CA5E
	for <linux-xfs@oss.sgi.com>; Tue, 19 Aug 2008 23:45:17 -0700 (PDT)
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.188]) by cuda.sgi.com with ESMTP id WlhoBCiAcjkEO4SB for <linux-xfs@oss.sgi.com>; Tue, 19 Aug 2008 23:45:17 -0700 (PDT)
Received: by nf-out-0910.google.com with SMTP id h3so174975nfh.42
        for <linux-xfs@oss.sgi.com>; Tue, 19 Aug 2008 23:45:16 -0700 (PDT)
Message-ID: <702ec7d40808192345s17b02fdaxc0e667743896de@mail.gmail.com>
Date: Wed, 20 Aug 2008 08:45:16 +0200
From: daniel <luriad@gmail.com>
Subject: Re: xfs _ slow rewrite ?
In-Reply-To: <702ec7d40808180408u57c14e82p778cfb7af6f3dc9e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <702ec7d40808180408u57c14e82p778cfb7af6f3dc9e@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

I'm working on a new server and test the performance from xfs and ext3
with iozone.

iozone -T -t 32 -F /data/iozonefile{0..31} -o -O -i6 -i7 -i0 -i1 -i2
-s512m -r16k -+u

system : SLES 10.2 : 2.6.16.60-0.27-smp #1 SMP on a DELL 2950 : 1 GB RAM:
raid: raid 10 with 8 disks 15k : 64k chunksize : dell md 1000 : perc
6/e : WriteBack, ReadAheadNone, Cached,

echo "3" >  /proc/sys/vm/drop_caches

why is the xfs read, reread and rewrite so slow ?

1) xfs
mkfs.xfs -f -L DATA /dev/sdb1
/dev/sdb1 on /data type xfs (rw,noatime,nodiratime)

        Children see throughput for 32 initial writers  =    5940.92 ops/sec
        Parent sees throughput for 32 initial writers   =    1244.99 ops/sec
        Min throughput per thread                       =     127.88 ops/sec
        Max throughput per thread                       =     742.80 ops/sec
        Avg throughput per thread                       =     185.65 ops/sec
        Min xfer
              =    5641.00 ops
        CPU Utilization: Wall time  210.499    CPU time 3323.852
CPU utilization 1579.03 %


        Children see throughput for 32 rewriters        =    2298.54 ops/sec
        Parent sees throughput for 32 rewriters         =    2293.51 ops/sec
        Min throughput per thread                       =      66.23 ops/sec
        Max throughput per thread                       =      79.09 ops/sec
        Avg throughput per thread                       =      71.83 ops/sec
        Min xfer                                        =   27439.00 ops
        CPU utilization: Wall time  415.265    CPU time 1032.129
CPU utilization 248.55 %


        Children see throughput for 32 readers          =    6923.75 ops/sec
        Parent sees throughput for 32 readers           =    6920.53 ops/sec
        Min throughput per thread                       =     211.00 ops/sec
        Max throughput per thread                       =     226.58 ops/sec
        Avg throughput per thread                       =     216.37 ops/sec
        Min xfer                                        =   30525.00 ops
        CPU utilization: Wall time  144.732    CPU time  389.016
CPU utilization 268.78 %


        Children see throughput for 32 re-readers       =    6864.93 ops/sec
        Parent sees throughput for 32 re-readers        =    6861.38 ops/sec
        Min throughput per thread                       =     209.57 ops/sec
        Max throughput per thread                       =     220.73 ops/sec
        Avg throughput per thread                       =     214.53 ops/sec
        Min xfer                                        =   31133.00 ops
        CPU utilization: Wall time  148.571    CPU time  400.709
CPU utilization 269.71 %


        Children see throughput for 32 random readers   =    2335.44 ops/sec
        Parent sees throughput for 32 random readers    =    2335.30 ops/sec
        Min throughput per thread                       =      70.48 ops/sec
        Max throughput per thread                       =      74.36 ops/sec
        Avg throughput per thread                       =      72.98 ops/sec
        Min xfer                                        =   31058.00 ops
        CPU utilization: Wall time  440.693    CPU time  647.208
CPU utilization 146.86 %

2) ext3
mkfs.ext3 /dev/sdb1 -E stride=16
/dev/sdb1 on /data type ext3 (rw,noatime,nodiratime)

    Children see throughput for 32 initial writers     =    3238.64 ops/sec
    Parent sees throughput for 32 initial writers     =    3238.20 ops/sec
    Min throughput per thread             =     101.20 ops/sec
    Max throughput per thread             =     101.21 ops/sec
    Avg throughput per thread             =     101.21 ops/sec
    Min xfer                     =   32763.00 ops
    CPU Utilization: Wall time  323.791    CPU time  281.362    CPU
utilization  86.90 %


    Children see throughput for 32 rewriters     =   10553.17 ops/sec
    Parent sees throughput for 32 rewriters     =   10517.38 ops/sec
    Min throughput per thread             =     307.10 ops/sec
    Max throughput per thread             =     378.34 ops/sec
    Avg throughput per thread             =     329.79 ops/sec
    Min xfer                     =   26628.00 ops
    CPU utilization: Wall time   87.079    CPU time  966.580    CPU
utilization 1110.00 %


    Children see throughput for 32 readers         =   20602.73 ops/sec
    Parent sees throughput for 32 readers         =   20579.60 ops/sec
    Min throughput per thread             =     518.61 ops/sec
    Max throughput per thread             =     683.18 ops/sec
    Avg throughput per thread             =     643.84 ops/sec
    Min xfer                     =   24893.00 ops
    CPU utilization: Wall time   48.045    CPU time  292.886    CPU
utilization 609.61 %


    Children see throughput for 32 re-readers     =   20938.47 ops/sec
    Parent sees throughput for 32 re-readers     =   20912.34 ops/sec
    Min throughput per thread             =     587.57 ops/sec
    Max throughput per thread             =     685.95 ops/sec
    Avg throughput per thread             =     654.33 ops/sec
    Min xfer                     =   28093.00 ops
    CPU utilization: Wall time   47.864    CPU time  291.858    CPU
utilization 609.76 %


    Children see throughput for 32 random readers     =    3315.69 ops/sec
    Parent sees throughput for 32 random readers     =    3315.50 ops/sec
    Min throughput per thread             =     102.18 ops/sec
    Max throughput per thread             =     105.06 ops/sec
    Avg throughput per thread             =     103.62 ops/sec
    Min xfer                     =   31868.00 ops
    CPU utilization: Wall time  311.905    CPU time  619.687    CPU
utilization 198.68 %

who can me please explain that results ?
the differences between both file systems are really strange.

thanks, daniel
