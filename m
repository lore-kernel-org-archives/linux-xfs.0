Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Mar 2008 18:20:39 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2K1KKux012815
	for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 18:20:23 -0700
Message-ID: <47E1BB82.105@sgi.com>
Date: Thu, 20 Mar 2008 12:18:58 +1100
From: Mark Goodwin <markgw@sgi.com>
Reply-To: markgw@sgi.com
MIME-Version: 1.0
Subject: Re: xfsqa failures
References: <20080319064959.GD11349@josefsipek.net>
In-Reply-To: <20080319064959.GD11349@josefsipek.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
Cc: XFS Mailing List <xfs@oss.sgi.com>

Thanks for the report. You're seeing roughly the same failures
that we're seeing. There is a fairly big effort going on internally
here at SGI to get the QA suite cleaned up and usable again.
Once that's done, we'll push out the fixes of course.

Cheers
-- Mark

Josef 'Jeff' Sipek wrote:
> Hello all!
> 
> I'm going to be blut...what's the deal with xfsqa? There are far too many
> tests that seem broken (or at least I hope it's the tests and not XFS). It
> makes it really hard to know if a test failed because the test's golden
> output is wrong, or because XFS has a bug - doubly so when one changes
> something in XFS.
> 
> I ran the "auto" group of tests (which uses about 2/3 of the tests in qa),
> and out of the 109 tests run, 17 failed for me.  Some failed because the output
> didn't match, but one test leaks a reference of some sort forcing me to
> reboot, and resume the tests from that point, and another test trips an
> assertion. Running the other tests (not part of the auto group) is even
> worse (e.g., one test deadlocks the system).
> 
> Summary:
> 
> Not run:  010 022 023 024 025 035 036 037 038 039 040 043 044 050 052 055
> 	  057 058 077 090 092 093 094 095 097 098 099 101 102 112 142 143
> 	  144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159
> 	  160 161 162 163 168 180
> Failures: 016 018 081 082 103 130 132 166 167 171 172 173 175 176 177 178
> 	  182
> Failed 17 of 109 tests
> 
> Josef 'Jeff' Sipek.
> 
> ---
> Here's some detailed info (xfsqa output, the assertion backtrace) about tests
> that fail on a pretty average dual CPU Athlon (the first gen Athlon MP - if you
> want detailed specs, let me know):
> 
> # ./check -g auto
> FSTYP         -- xfs (debug)
> PLATFORM      -- Linux/i686 fstest 2.6.25-rc6
> MKFS_OPTIONS  -- -f -bsize=4096 /dev/hda6
> MOUNT_OPTIONS -- /dev/hda6 /mnt/xfs_scratch
> 
> 001 13s ...
> 002 1s ...
> 003 1s ...
> 004 2s ...
> 005 1s ...
> 006 40s ...
> 007 61s ...
> 008 7s ...
> 009 1s ...
> 010      [not run] dbtest was not built for this platform
> 011 52s ...
> 012 6s ...
> 013 271s ...
> 014 71s ...
> 015 6s ...
> 016 31s ... [failed, exit status 1] - output mismatch (see 016.out.bad)
> 10,114c10,11
> < *** generate log traffic
> <    *** mount
> <    *** fiddle
> <    *** unmount
> < *** check for corruption
> < *** generate log traffic
> <    *** mount
> <    *** fiddle
> <    *** unmount
> < *** check for corruption
> < *** generate log traffic
> <    *** mount
> <    *** fiddle
> <    *** unmount
> < *** check for corruption
> < *** generate log traffic
> <    *** mount
> <    *** fiddle
> <    *** unmount
> < *** check for corruption
> < *** generate log traffic
> <    *** mount
> <    *** fiddle
> <    *** unmount
> < *** check for corruption
> < *** generate log traffic
> <    *** mount
> <    *** fiddle
> <    *** unmount
> < *** check for corruption
> < *** generate log traffic
> <    *** mount
> <    *** fiddle
> <    *** unmount
> < *** check for corruption
> < *** generate log traffic
> <    *** mount
> <    *** fiddle
> <    *** unmount
> < *** check for corruption
> < *** generate log traffic
> <    *** mount
> <    *** fiddle
> <    *** unmount
> < *** check for corruption
> < *** generate log traffic
> <    *** mount
> <    *** fiddle
> <    *** unmount
> < *** check for corruption
> < *** generate log traffic
> <    *** mount
> <    *** fiddle
> <    *** unmount
> < *** check for corruption
> < *** generate log traffic
> <    *** mount
> <    *** fiddle
> <    *** unmount
> < *** check for corruption
> < *** generate log traffic
> <    *** mount
> <    *** fiddle
> <    *** unmount
> < *** check for corruption
> < *** generate log traffic
> <    *** mount
> <    *** fiddle
> <    *** unmount
> < *** check for corruption
> < *** generate log traffic
> <    *** mount
> <    *** fiddle
> <    *** unmount
> < *** check for corruption
> < *** generate log traffic
> <    *** mount
> <    *** fiddle
> <    *** unmount
> < *** check for corruption
> < *** generate log traffic
> <    *** mount
> <    *** fiddle
> <    *** unmount
> < *** check for corruption
> < *** generate log traffic
> <    *** mount
> <    *** fiddle
> <    *** unmount
> < *** check for corruption
> < *** generate log traffic
> <    *** mount
> <    *** fiddle
> <    *** unmount
> < *** check for corruption
> < *** generate log traffic
> <    *** mount
> <    *** fiddle
> <    *** unmount
> < *** check for corruption
> < *** generate log traffic
> <    *** mount
> <    *** fiddle
> <    *** unmount
> < *** check for corruption
> ---
>> !!! unexpected log position 3318
>> (see 016.full for details)
> 017 41s ...
> 018 22s ... - output mismatch (see 018.out.bad)
> 4,17c4,6
> < *** compare logprint: 018.trans_inode with 018.fulldir/trans_inode.mnt-onoalign,logbsize=32k.mkfs-lsize=2000b-lversion=1.filtered
> < *** compare logprint: 018.trans_buf with 018.fulldir/trans_buf.mnt-onoalign,logbsize=32k.mkfs-lsize=2000b-lversion=1.filtered
> < *** compare logprint: 018.op with 018.fulldir/op.mnt-onoalign,logbsize=32k.mkfs-lsize=2000b-lversion=2.filtered
> < *** compare logprint: 018.trans_inode with 018.fulldir/trans_inode.mnt-onoalign,logbsize=32k.mkfs-lsize=2000b-lversion=2.filtered
> < *** compare logprint: 018.trans_buf with 018.fulldir/trans_buf.mnt-onoalign,logbsize=32k.mkfs-lsize=2000b-lversion=2.filtered
> < *** compare logprint: 018.op with 018.fulldir/op.mnt-onoalign,logbsize=64k.mkfs-lsize=2000b-lversion=2.filtered
> < *** compare logprint: 018.trans_inode with 018.fulldir/trans_inode.mnt-onoalign,logbsize=64k.mkfs-lsize=2000b-lversion=2.filtered
> < *** compare logprint: 018.trans_buf with 018.fulldir/trans_buf.mnt-onoalign,logbsize=64k.mkfs-lsize=2000b-lversion=2.filtered
> < *** compare logprint: 018.op with 018.fulldir/op.mnt-onoalign,logbsize=128k.mkfs-lsize=2000b-lversion=2.filtered
> < *** compare logprint: 018.trans_inode with 018.fulldir/trans_inode.mnt-onoalign,logbsize=128k.mkfs-lsize=2000b-lversion=2.filtered
> < *** compare logprint: 018.trans_buf with 018.fulldir/trans_buf.mnt-onoalign,logbsize=128k.mkfs-lsize=2000b-lversion=2.filtered
> < *** compare logprint: 018.op with 018.fulldir/op.mnt-onoalign,logbsize=256k.mkfs-lsize=2000b-lversion=2.filtered
> < *** compare logprint: 018.trans_inode with 018.fulldir/trans_inode.mnt-onoalign,logbsize=256k.mkfs-lsize=2000b-lversion=2.filtered
> < *** compare logprint: 018.trans_buf with 018.fulldir/trans_buf.mnt-onoalign,logbsize=256k.mkfs-lsize=2000b-lversion=2.filtered
> ---
>> 0  split(s) found prior to diff cmd:  50,54d49
>> logprint output 018.op differs to 018.fulldir/op.mnt-onoalign,logbsize=32k.mkfs-lsize=2000b-lversion=1.filtered considering splits
>> (see 018.full for details)
> 019 3s ...
> 020 10s ...
> 021 2s ...
> 022      [not run] No dump tape specified
> 023      [not run] No dump tape specified
> 024      [not run] No dump tape specified
> 025      [not run] No dump tape specified
> 026 15s ...
> 027 15s ...
> 028 24s ...
> 029 2s ...
> 030 22s ...
> 031 22s ...
> 032 25s ...
> 033 17s ...
> 034 3s ...
> 035      [not run] No dump tape specified
> 036      [not run] No dump tape specified
> 037      [not run] No dump tape specified
> 038      [not run] No dump tape specified
> 039      [not run] No dump tape specified
> 040      [not run] Can't run srcdiff without KWORKAREA set
> 041 58s ...
> 042 131s ...
> 043      [not run] No dump tape specified
> 044      [not run] This test requires a valid $SCRATCH_LOGDEV
> 045 2s ...
> 046 14s ...
> 047 24s ...
> 048 0s ...
> 049 13s ...
> 050 25s ... [not run] Installed kernel does not support XFS quota
> 051 2s ...
> 052 4s ... [not run] Installed kernel does not support XFS quota
> 053 3s ...
> 054 5s ...
> 055      [not run] No dump tape specified
> 056 14s ...
> 057      [not run] Place holder for IRIX test 057
> 058      [not run] Place holder for IRIX test 058
> 061 13s ...
> 062 3s ...
> 063 14s ...
> 065 37s ...
> 066 2s ...
> 067 3s ...
> 068 54s ...
> 069 28s ...
> 070 25s ...
> 072 1s ...
> 073 53s ...
> 074 521s ...
> 075 60s ...
> 076 148s ...
> 077      [not run] No linux directory to source files from
> 078 43s ...
> 079 1s ...
> 081 6s ... [failed, exit status 1] - output mismatch (see 081.out.bad)
> 3a4,5
>> logprint output 081.ugquota.trans_inode differs to 081.fulldir/trans_inode.mnt-oquota,gquota.mkfs-lsize=2000b-lversion=1.filtered
>> (see 081.full for details)
> 082 40s ... - output mismatch (see 082.out.bad)
> 5,19c5,6
> < *** compare logprint: 082.trans_buf with 082.fulldir/trans_buf.mnt-ologbsize=32k.mkfs-lsize=2000b-lversion=2.sync.filtered
> < --- mkfs=version=2,su=4096, mnt=logbsize=32k, sync=sync ---
> < *** compare logprint: 082.trans_inode with 082.fulldir/trans_inode.mnt-ologbsize=32k.mkfs-lsize=2000b-lversion=2,su=4096.sync.filtered
> < *** compare logprint: 082.trans_buf with 082.fulldir/trans_buf.mnt-ologbsize=32k.mkfs-lsize=2000b-lversion=2,su=4096.sync.filtered
> < --- mkfs=version=2,su=32768, mnt=logbsize=32k, sync=sync ---
> < *** compare logprint: 082.trans_inode with 082.fulldir/trans_inode.mnt-ologbsize=32k.mkfs-lsize=2000b-lversion=2,su=32768.sync.filtered
> < *** compare logprint: 082.trans_buf with 082.fulldir/trans_buf.mnt-ologbsize=32k.mkfs-lsize=2000b-lversion=2,su=32768.sync.filtered
> < --- mkfs=version=2,su=36864, mnt=logbsize=32k, sync=sync ---
> <
> < *** Cannot mkfs for this test using option specified: -l size=2000b -l version=2,su=36864 ***
> <
> < --- mkfs=version=2,su=5120, mnt=logbsize=32k, sync=sync ---
> <
> < *** Cannot mkfs for this test using option specified: -l size=2000b -l version=2,su=5120 ***
> <
> ---
>> logprint output 082.trans_inode differs to 082.fulldir/trans_inode.mnt-ologbsize=32k.mkfs-lsize=2000b-lversion=2.sync.filtered
>> (see 082.full for details)
> 22,39c9,11
> < *** compare logprint: 082.trans_inode with 082.fulldir/trans_inode.mnt-ologbsize=32k.mkfs-lsize=2000b-lversion=2.nosync.filtered
> < *** compare logprint: 082.trans_buf with 082.fulldir/trans_buf.mnt-ologbsize=32k.mkfs-lsize=2000b-lversion=2.nosync.filtered
> < --- mkfs=version=2,su=4096, mnt=logbsize=32k, sync=nosync ---
> < *** compare logprint: 082.op with 082.fulldir/op.mnt-ologbsize=32k.mkfs-lsize=2000b-lversion=2,su=4096.nosync.filtered
> < *** compare logprint: 082.trans_inode with 082.fulldir/trans_inode.mnt-ologbsize=32k.mkfs-lsize=2000b-lversion=2,su=4096.nosync.filtered
> < *** compare logprint: 082.trans_buf with 082.fulldir/trans_buf.mnt-ologbsize=32k.mkfs-lsize=2000b-lversion=2,su=4096.nosync.filtered
> < --- mkfs=version=2,su=32768, mnt=logbsize=32k, sync=nosync ---
> < *** compare logprint: 082.op with 082.fulldir/op.mnt-ologbsize=32k.mkfs-lsize=2000b-lversion=2,su=32768.nosync.filtered
> < *** compare logprint: 082.trans_inode with 082.fulldir/trans_inode.mnt-ologbsize=32k.mkfs-lsize=2000b-lversion=2,su=32768.nosync.filtered
> < *** compare logprint: 082.trans_buf with 082.fulldir/trans_buf.mnt-ologbsize=32k.mkfs-lsize=2000b-lversion=2,su=32768.nosync.filtered
> < --- mkfs=version=2,su=36864, mnt=logbsize=32k, sync=nosync ---
> <
> < *** Cannot mkfs for this test using option specified: -l size=2000b -l version=2,su=36864 ***
> <
> < --- mkfs=version=2,su=5120, mnt=logbsize=32k, sync=nosync ---
> <
> < *** Cannot mkfs for this test using option specified: -l size=2000b -l version=2,su=5120 ***
> <
> ---
>> 0  split(s) found prior to diff cmd:  50,54d49
>> logprint output 082.op differs to 082.fulldir/op.mnt-ologbsize=32k.mkfs-lsize=2000b-lversion=2.nosync.filtered considering splits
>> (see 082.full for details)
> 083 213s ...
> 084 61s ...
> 088 1s ...
> 089 258s ...
> 090      [not run] External volumes not in use, skipped this test
> 091 149s ...
> 092      [not run] inode64 not checked on this platform
> 093      [not run] not suitable for this OS: Linux
> 094      [not run] External volumes not in use, skipped this test
> 095      [not run] not suitable for this OS: Linux
> 096 4s ...
> 097      [not run] not suitable for this OS: Linux
> 098      [not run] not suitable for this filesystem type: xfs
> 099      [not run] not suitable for this OS: Linux
> 100 59s ...
> 101      [not run] not suitable for this filesystem type: xfs
> 102      [not run] not suitable for this filesystem type: xfs
> 103 2s ... - output mismatch (see 103.out.bad)
> 7c7
> < ln: creating symbolic link `SCRATCH_MNT/nosymlink/target' to `SCRATCH_MNT/nosymlink/source': Operation not permitted
> ---
>> ln: creating symbolic link `SCRATCH_MNT/nosymlink/target': Operation not permitted
> 105 2s ...
> 112      [not run] fsx not built with AIO for this platform
> 117 36s ...
> 120 17s ...
> 121 9s ...
> 122 3s ...
> 123 0s ...
> 124 14s ...
> 125 62s ...
> 126 1s ...
> 127 630s ...
> 128 3s ...
> 129 41s ...
> 130      - output mismatch (see 130.out.bad)
> 20c20
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 3 KiB, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 24c24
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1000.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 26c26
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1000.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 30c30
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 4 KiB, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 89c89
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 2.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 101c101
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 0.000000 bytes, 0 ops; 0.0000 sec (nan bytes/sec and nan ops/sec)
> 103c103
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 0.000000 bytes, 0 ops; 0.0000 sec (nan bytes/sec and nan ops/sec)
> 105c105
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 0.000000 bytes, 0 ops; 0.0000 sec (nan bytes/sec and nan ops/sec)
> 107c107
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 0.000000 bytes, 0 ops; 0.0000 sec (nan bytes/sec and nan ops/sec)
> 109c109
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 0.000000 bytes, 0 ops; 0.0000 sec (nan bytes/sec and nan ops/sec)
> 111c111
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 0.000000 bytes, 0 ops; 0.0000 sec (nan bytes/sec and nan ops/sec)
> 113c113
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 0.000000 bytes, 0 ops; 0.0000 sec (nan bytes/sec and nan ops/sec)
> 115c115
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 0.000000 bytes, 0 ops; 0.0000 sec (nan bytes/sec and nan ops/sec)
> 117c117
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 0.000000 bytes, 0 ops; 0.0000 sec (nan bytes/sec and nan ops/sec)
> 119c119
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 0.000000 bytes, 0 ops; 0.0000 sec (nan bytes/sec and nan ops/sec)
> 124c124
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 10.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 128c128
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 23.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 133c133
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 136c136
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 139c139
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 142c142
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 145c145
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 148c148
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 151c151
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 154c154
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 157c157
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 160c160
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 163c163
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 166c166
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 169c169
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 172c172
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 13.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 174c174
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 176c176
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 178c178
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 180c180
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 182c182
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 184c184
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 186c186
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 188c188
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 190c190
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 192c192
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 194c194
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 196c196
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 198c198
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 200c200
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 202c202
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 204c204
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 207c207
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 4.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 210c210
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 4.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 213c213
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 4.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 216c216
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 4.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 218c218
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 220c220
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 222c222
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 224c224
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 226c226
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 228c228
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 230c230
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 232c232
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 234c234
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 236c236
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 238c238
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 240c240
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 242c242
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 244c244
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 246c246
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 248c248
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 251c251
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 4.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 254c254
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 4.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 257c257
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 4.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 260c260
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 4.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 265c265
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 268c268
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 271c271
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 274c274
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 277c277
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 280c280
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 283c283
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 286c286
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 289c289
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 292c292
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 295c295
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 298c298
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 301c301
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 304c304
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 13.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 339c339
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 4.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 342c342
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 4.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 345c345
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 4.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 348c348
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 4.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 383c383
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 4.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 386c386
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 4.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 389c389
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 4.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 392c392
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 4.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 131 1s ...
> 132      - output mismatch (see 132.out.bad)
> 3c3
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 512.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 5c5
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 512.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 7c7
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 512.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 9c9
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 512.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 11c11
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 512.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 13c13
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 512.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 15c15
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 512.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 17c17
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 512.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 21c21
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 512.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 25c25
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 512.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 29c29
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 512.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 33c33
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 512.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 37c37
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 512.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 41c41
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 512.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 45c45
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 512.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 49c49
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 512.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 51c51
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1 KiB, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 53c53
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1 KiB, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 55c55
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1 KiB, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 57c57
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1 KiB, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 63c63
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1 KiB, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 69c69
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1 KiB, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 75c75
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1 KiB, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 81c81
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1 KiB, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 85c85
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1 KiB, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 89c89
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1 KiB, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 93c93
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1 KiB, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 97c97
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 1 KiB, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 99c99
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 2 KiB, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 101c101
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 2 KiB, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 121c121
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 2 KiB, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 133c133
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 2 KiB, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 141c141
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 2 KiB, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 143c143
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 4 KiB, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 171c171
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 4 KiB, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 177c177
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 4 KiB, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 183c183
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 8 KiB, 2 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 185c185
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 8 KiB, 2 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 233c233
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 16 KiB, 4 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 235c235
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 16 KiB, 4 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 283c283
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 32 KiB, 8 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 285c285
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 32 KiB, 8 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 337c337
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 64 KiB, 16 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 339c339
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 64 KiB, 16 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 393c393
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 128 KiB, 32 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 395c395
> < XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ---
>> 128 KiB, 32 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
> 134 2s ...
> 135 2s ...
> 137 37s ...
> 138 75s ...
> 139 84s ...
> 140 55s ...
> 141 2s ...
> 142      [not run] Assuming DMAPI modules are not loaded
> 143      [not run] Assuming DMAPI modules are not loaded
> 144      [not run] Assuming DMAPI modules are not loaded
> 145      [not run] Assuming DMAPI modules are not loaded
> 146      [not run] Assuming DMAPI modules are not loaded
> 147      [not run] Assuming DMAPI modules are not loaded
> 148      [not run] parallel repair binary xfs_prepair64 is not installed
> 149      [not run] parallel repair binary xfs_prepair is not installed
> 150      [not run] Assuming DMAPI modules are not loaded
> 151      [not run] Assuming DMAPI modules are not loaded
> 152      [not run] Assuming DMAPI modules are not loaded
> 153      [not run] Assuming DMAPI modules are not loaded
> 154      [not run] Assuming DMAPI modules are not loaded
> 155      [not run] Assuming DMAPI modules are not loaded
> 156      [not run] Assuming DMAPI modules are not loaded
> 157      [not run] Assuming DMAPI modules are not loaded
> 158      [not run] Assuming DMAPI modules are not loaded
> 159      [not run] Assuming DMAPI modules are not loaded
> 160      [not run] Assuming DMAPI modules are not loaded
> 161      [not run] Assuming DMAPI modules are not loaded
> 162      [not run] Assuming DMAPI modules are not loaded
> 163      [not run] Assuming DMAPI modules are not loaded
> 164 0s ...
> 165 1s ...
> 166      - output mismatch (see 166.out.bad)
> 2,6c2,6
> < 0: [0..31]: XX..YY AG (AA..BB) 32
> < 1: [32..127]: XX..YY AG (AA..BB) 96 10000
> < 2: [128..159]: XX..YY AG (AA..BB) 32
> < 3: [160..223]: XX..YY AG (AA..BB) 64 10000
> < 4: [224..255]: XX..YY AG (AA..BB) 32
> ---
>> 0: [0..7]: XX..YY AG (AA..BB) 8
>> 1: [8..127]: XX..YY AG (AA..BB) 120 10000
>> 2: [128..135]: XX..YY AG (AA..BB) 8
>> 3: [136..247]: XX..YY AG (AA..BB) 112 10000
>> 4: [248..255]: XX..YY AG (AA..BB) 8
> 167 274s ...
> 
> ****************************
> 167 leaks a reference of some sort, unable to unmount xfs_scratch (-EBUSY), but
> test does not die; reboot
> ****************************
> 
> 168      [not run] Assuming DMAPI modules are not loaded
> 169
> 170 26s ...
> 171      [failed, exit status 1] - output mismatch (see 171.out.bad)
> 6,21c6,7
> < + passed, streams are in seperate AGs
> < # testing 64 16 8 100 1 1 1 ....
> < # streaming
> < # sync AGs...
> < # checking stream AGs...
> < + passed, streams are in seperate AGs
> < # testing 64 16 8 100 1 0 0 ....
> < # streaming
> < # sync AGs...
> < # checking stream AGs...
> < + passed, streams are in seperate AGs
> < # testing 64 16 8 100 1 0 1 ....
> < # streaming
> < # sync AGs...
> < # checking stream AGs...
> < + passed, streams are in seperate AGs
> ---
>> - failed, 7 streams with matching AGs
>> (see 171.full for details)
> 172      [failed, exit status 1] - output mismatch (see 172.out.bad)
> 11c11,12
> < + passed, streams are in seperate AGs
> ---
>> - failed, 1 streams with matching AGs
>> (see 172.full for details)
> 173
> 
> ****************************
> 173 trips an assertion...dmesg:
> 
> Ending clean XFS mount for filesystem: hda6
> Assertion failed: pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks), file: fs/xfs/xfs_alloc.c, line: 2216
> ------------[ cut here ]------------
> kernel BUG at fs/xfs/support/debug.c:81!
> invalid opcode: 0000 [#1] SMP
> Modules linked in: xfs crc32c libcrc32c dm_snapshot dm_mirror dm_mod loop amd_k7_agp evdev ext3 jbd mbcache ide_disk aic7xxx scsi_transport_spi scsi_mod amd74xx ohci_hcd e1000 ide_pci_generic ide_core usbcore
> 
> Pid: 6039, comm: mkdir Not tainted (2.6.25-rc6 #12)
> EIP: 0060:[<f935f3d4>] EFLAGS: 00010282 CPU: 0
> EIP is at assfail+0x10/0x17 [xfs]
> EAX: 00000070 EBX: f7bc8a6c ECX: 00000000 EDX: 00000000
> ESI: 00000000 EDI: f7878200 EBP: f7463b20 ESP: f7463b10
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process mkdir (pid: 6039, ti=f7463000 task=f7cd50c0 task.ti=f7463000)
> Stack: f9371761 f9360e4c f9360d8f 000008a8 f7463b50 f92f73bb 000b8001 00000000
>        f6ca97b0 00000017 f78f9aa0 f7af2590 f7a288c8 00000ef8 00000000 f7463ccc
>        f7463bf0 f92fa0f7 00000000 f7463be0 00000000 00000001 00000046 f7af2590
> Call Trace:
>  [<f92f73bb>] ? xfs_alloc_read_agf+0x231/0x2f7 [xfs]
>  [<f92fa0f7>] ? xfs_alloc_fix_freelist+0x176/0x422 [xfs]
>  [<c011a385>] ? hrtick_set+0xce/0xd6
>  [<c024375c>] ? schedule+0x715/0x747
>  [<f92fa6db>] ? xfs_alloc_vextent+0x1ff/0x8d8 [xfs]
>  [<c0244468>] ? down_read+0x19/0x2d
>  [<f92fa6ff>] ? xfs_alloc_vextent+0x223/0x8d8 [xfs]
>  [<f93196f7>] ? xfs_buf_item_trace+0xa4/0xae [xfs]
>  [<f932b346>] ? xfs_ialloc_ag_alloc+0x280/0x6e7 [xfs]
>  [<f932a782>] ? xfs_ialloc_read_agi+0x93/0x1e4 [xfs]
>  [<f932a7f3>] ? xfs_ialloc_read_agi+0x104/0x1e4 [xfs]
>  [<f932b914>] ? xfs_dialloc+0x167/0xb12 [xfs]
>  [<f933dde4>] ? xlog_trace_loggrant+0xa8/0xb3 [xfs]
>  [<f9334ff3>] ? xfs_ialloc+0x4b/0x537 [xfs]
>  [<c0245024>] ? _spin_unlock+0x1d/0x20
>  [<f933e580>] ? xlog_grant_log_space+0x2a0/0x2ea [xfs]
>  [<f934d2c0>] ? xfs_dir_ialloc+0x6f/0x253 [xfs]
>  [<f935325a>] ? xfs_mkdir+0x204/0x498 [xfs]
>  [<f92f62ed>] ? xfs_acl_get_attr+0x66/0x89 [xfs]
>  [<f935bc5b>] ? xfs_vn_mknod+0x140/0x22a [xfs]
>  [<f935bd52>] ? xfs_vn_mkdir+0xd/0xf [xfs]
>  [<c016c922>] ? vfs_mkdir+0x94/0xd7
>  [<c016e7b9>] ? sys_mkdirat+0x85/0xbd
>  [<c01319db>] ? up_read+0x16/0x2b
>  [<c0246bc4>] ? do_page_fault+0x2af/0x535
>  [<c016e801>] ? sys_mkdir+0x10/0x12
>  [<c0103932>] ? sysenter_past_esp+0x5f/0xa5
>  =======================
> Code: 01 52 ba 5c 17 37 f9 50 b8 5d 17 37 f9 6a 01 6a 10 e8 5a 8e e5 c6 83 c4 14 c9 c3 55 89 e5 51 52 50 68 61 17 37 f9 e8 81 fc db c6 <0f> 0b 83 c4 10 eb fe 55 89 e5 57 89 c7 b8 50 ee 38 f9 83 e7 07
> EIP: [<f935f3d4>] assfail+0x10/0x17 [xfs] SS:ESP 0068:f7463b10
> ---[ end trace ad759a5a28c539de ]---
> 
> rebooted, before running more tests.
> ****************************
> 
> 174 37s ...
> 175      - output mismatch (see 175.out.bad)
> 5,31c5,8
> < # spawning test file with 4096 256 0 punch_test_file noresv
> < [0] punch_test_file
> < + not using resvsp at file creation
> < # writing with 4096 0 256 punch_test_file
> < # showing file state punch_test_file
> < punch_test_file:
> <  EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
> <    0: [0..2047]:       96..2143          0 (96..2143)        2048 00000
> <  FLAG Values:
> <     010000 Unwritten preallocated extent
> <     001000 Doesn't begin on stripe unit
> <     000100 Doesn't end   on stripe unit
> <     000010 Doesn't begin on stripe width
> <     000001 Doesn't end   on stripe width
> < # punching with 4096 240 16 d punch_test_file
> < + hole punch using dmapi punch_hole
> < # showing file state punch_test_file
> < punch_test_file:
> <  EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
> <    0: [0..1919]:       96..2015          0 (96..2015)        1920 00000
> <    1: [1920..2047]:    hole                                   128
> <  FLAG Values:
> <     010000 Unwritten preallocated extent
> <     001000 Doesn't begin on stripe unit
> <     000100 Doesn't end   on stripe unit
> <     000010 Doesn't begin on stripe width
> <     000001 Doesn't end   on stripe width
> ---
>> mount: wrong fs type, bad option, bad superblock on /dev/hda6,
>>        missing codepage or helper program, or other error
>>        In some cases useful info is found in syslog - try
>>        dmesg | tail  or so
> 33,63c10
> < -- this time use a 4k (one block) extent size hint --
> < # testing 4096 1 256 240 16 d 0 256 w p noresv ...
> < + mounting with dmapi enabled
> < # spawning test file with 4096 256 1 punch_test_file noresv
> < + setting extent size hint to 4096
> < [4096] punch_test_file
> < + not using resvsp at file creation
> < # writing with 4096 0 256 punch_test_file
> < # showing file state punch_test_file
> < punch_test_file:
> <  EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
> <    0: [0..2047]:       96..2143          0 (96..2143)        2048 00000
> <  FLAG Values:
> <     010000 Unwritten preallocated extent
> <     001000 Doesn't begin on stripe unit
> <     000100 Doesn't end   on stripe unit
> <     000010 Doesn't begin on stripe width
> <     000001 Doesn't end   on stripe width
> < # punching with 4096 240 16 d punch_test_file
> < + hole punch using dmapi punch_hole
> < # showing file state punch_test_file
> < punch_test_file:
> <  EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
> <    0: [0..1919]:       96..2015          0 (96..2015)        1920 00000
> <    1: [1920..2047]:    hole                                   128
> <  FLAG Values:
> <     010000 Unwritten preallocated extent
> <     001000 Doesn't begin on stripe unit
> <     000100 Doesn't end   on stripe unit
> <     000010 Doesn't begin on stripe width
> <     000001 Doesn't end   on stripe width
> ---
>> 175 not run: Assuming DMAPI modules are not loaded
> 176      - output mismatch (see 176.out.bad)
> 5,30c5,8
> < # spawning test file with 4096 256 0 punch_test_file
> < [0] punch_test_file
> < # writing with 4096 0 256 punch_test_file
> < # showing file state punch_test_file
> < punch_test_file:
> <  EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
> <    0: [0..2047]:       96..2143          0 (96..2143)        2048 00000
> <  FLAG Values:
> <     010000 Unwritten preallocated extent
> <     001000 Doesn't begin on stripe unit
> <     000100 Doesn't end   on stripe unit
> <     000010 Doesn't begin on stripe width
> <     000001 Doesn't end   on stripe width
> < # punching with 4096 240 16 d punch_test_file
> < + hole punch using dmapi punch_hole
> < # showing file state punch_test_file
> < punch_test_file:
> <  EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
> <    0: [0..1919]:       96..2015          0 (96..2015)        1920 00000
> <    1: [1920..2047]:    hole                                   128
> <  FLAG Values:
> <     010000 Unwritten preallocated extent
> <     001000 Doesn't begin on stripe unit
> <     000100 Doesn't end   on stripe unit
> <     000010 Doesn't begin on stripe width
> <     000001 Doesn't end   on stripe width
> ---
>> mount: wrong fs type, bad option, bad superblock on /dev/hda6,
>>        missing codepage or helper program, or other error
>>        In some cases useful info is found in syslog - try
>>        dmesg | tail  or so
> 32,121c10
> < -- this time dont use resvsp --
> < # testing 4096 0 256 240 16 d 0 256 w p noresv ...
> < + mounting with dmapi enabled
> < # spawning test file with 4096 256 0 punch_test_file noresv
> < [0] punch_test_file
> < + not using resvsp at file creation
> < # writing with 4096 0 256 punch_test_file
> < # showing file state punch_test_file
> < punch_test_file:
> <  EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
> <    0: [0..2047]:       96..2143          0 (96..2143)        2048 00000
> <  FLAG Values:
> <     010000 Unwritten preallocated extent
> <     001000 Doesn't begin on stripe unit
> <     000100 Doesn't end   on stripe unit
> <     000010 Doesn't begin on stripe width
> <     000001 Doesn't end   on stripe width
> < # punching with 4096 240 16 d punch_test_file
> < + hole punch using dmapi punch_hole
> < # showing file state punch_test_file
> < punch_test_file:
> <  EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
> <    0: [0..1919]:       96..2015          0 (96..2015)        1920 00000
> <    1: [1920..2047]:    hole                                   128
> <  FLAG Values:
> <     010000 Unwritten preallocated extent
> <     001000 Doesn't begin on stripe unit
> <     000100 Doesn't end   on stripe unit
> <     000010 Doesn't begin on stripe width
> <     000001 Doesn't end   on stripe width
> <
> <
> < -- test unresvsp hole punch with resvsp on file create --
> < # testing 4096 0 256 240 16 u 0 256 w p ...
> < # spawning test file with 4096 256 0 punch_test_file
> < [0] punch_test_file
> < # writing with 4096 0 256 punch_test_file
> < # showing file state punch_test_file
> < punch_test_file:
> <  EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
> <    0: [0..2047]:       96..2143          0 (96..2143)        2048 00000
> <  FLAG Values:
> <     010000 Unwritten preallocated extent
> <     001000 Doesn't begin on stripe unit
> <     000100 Doesn't end   on stripe unit
> <     000010 Doesn't begin on stripe width
> <     000001 Doesn't end   on stripe width
> < # punching with 4096 240 16 u punch_test_file
> < + hole punch using unresvsp
> < # showing file state punch_test_file
> < punch_test_file:
> <  EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
> <    0: [0..1919]:       96..2015          0 (96..2015)        1920 00000
> <    1: [1920..2047]:    hole                                   128
> <  FLAG Values:
> <     010000 Unwritten preallocated extent
> <     001000 Doesn't begin on stripe unit
> <     000100 Doesn't end   on stripe unit
> <     000010 Doesn't begin on stripe width
> <     000001 Doesn't end   on stripe width
> <
> < -- this time dont use resvsp --
> < # testing 4096 0 256 240 16 u 0 256 w p noresv ...
> < # spawning test file with 4096 256 0 punch_test_file noresv
> < [0] punch_test_file
> < + not using resvsp at file creation
> < # writing with 4096 0 256 punch_test_file
> < # showing file state punch_test_file
> < punch_test_file:
> <  EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
> <    0: [0..2047]:       96..2143          0 (96..2143)        2048 00000
> <  FLAG Values:
> <     010000 Unwritten preallocated extent
> <     001000 Doesn't begin on stripe unit
> <     000100 Doesn't end   on stripe unit
> <     000010 Doesn't begin on stripe width
> <     000001 Doesn't end   on stripe width
> < # punching with 4096 240 16 u punch_test_file
> < + hole punch using unresvsp
> < # showing file state punch_test_file
> < punch_test_file:
> <  EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
> <    0: [0..1919]:       96..2015          0 (96..2015)        1920 00000
> <    1: [1920..2047]:    hole                                   128
> <  FLAG Values:
> <     010000 Unwritten preallocated extent
> <     001000 Doesn't begin on stripe unit
> <     000100 Doesn't end   on stripe unit
> <     000010 Doesn't begin on stripe width
> <     000001 Doesn't end   on stripe width
> ---
>> 176 not run: Assuming DMAPI modules are not loaded
> 177      [failed, exit status 1] - output mismatch (see 177.out.bad)
> 58,88c58,64
> < Start bulkstat_unlink_test_modified
> < Iteration 0 ...
> < testFiles 1000 ...
> < passed
> < Iteration 1 ...
> < testFiles 1000 ...
> < passed
> < Iteration 2 ...
> < testFiles 1000 ...
> < passed
> < Iteration 3 ...
> < testFiles 1000 ...
> < passed
> < Iteration 4 ...
> < testFiles 1000 ...
> < passed
> < Iteration 5 ...
> < testFiles 1000 ...
> < passed
> < Iteration 6 ...
> < testFiles 1000 ...
> < passed
> < Iteration 7 ...
> < testFiles 1000 ...
> < passed
> < Iteration 8 ...
> < testFiles 1000 ...
> < passed
> < Iteration 9 ...
> < testFiles 1000 ...
> < passed
> ---
>> mount: wrong fs type, bad option, bad superblock on /dev/hda6,
>>        missing codepage or helper program, or other error
>>        In some cases useful info is found in syslog - try
>>        dmesg | tail  or so
>>
>> mount failed
>> (see 177.full for details)
> 178      - output mismatch (see 178.out.bad)
> 15,16d14
> < sb root inode value INO inconsistent with calculated value INO
> < resetting superblock root inode pointer to INO
> 51,52d48
> < sb root inode value INO inconsistent with calculated value INO
> < resetting superblock root inode pointer to INO
> 179
> 180      [not run] This test requires at least 10GB of                                           /dev/hda6 to run
> 181
> 182      - output mismatch (see 182.out.bad)
> 1a2,491
>> file /mnt/xfs_scratch/510 has incorrect size - sync failed
>> file /mnt/xfs_scratch/511 has incorrect size - sync failed
>> file /mnt/xfs_scratch/512 has incorrect size - sync failed
>> file /mnt/xfs_scratch/513 has incorrect size - sync failed
>> file /mnt/xfs_scratch/514 has incorrect size - sync failed
>> file /mnt/xfs_scratch/515 has incorrect size - sync failed
>> file /mnt/xfs_scratch/516 has incorrect size - sync failed
>> file /mnt/xfs_scratch/517 has incorrect size - sync failed
>> file /mnt/xfs_scratch/518 has incorrect size - sync failed
>> file /mnt/xfs_scratch/519 has incorrect size - sync failed
>> file /mnt/xfs_scratch/520 has incorrect size - sync failed
>> file /mnt/xfs_scratch/521 has incorrect size - sync failed
>> file /mnt/xfs_scratch/522 has incorrect size - sync failed
>> file /mnt/xfs_scratch/523 has incorrect size - sync failed
>> file /mnt/xfs_scratch/524 has incorrect size - sync failed
>> file /mnt/xfs_scratch/525 has incorrect size - sync failed
>> file /mnt/xfs_scratch/526 has incorrect size - sync failed
>> file /mnt/xfs_scratch/527 has incorrect size - sync failed
>> file /mnt/xfs_scratch/528 has incorrect size - sync failed
>> file /mnt/xfs_scratch/529 has incorrect size - sync failed
>> file /mnt/xfs_scratch/530 has incorrect size - sync failed
>> file /mnt/xfs_scratch/531 has incorrect size - sync failed
>> file /mnt/xfs_scratch/532 has incorrect size - sync failed
>> file /mnt/xfs_scratch/533 has incorrect size - sync failed
>> file /mnt/xfs_scratch/534 has incorrect size - sync failed
>> file /mnt/xfs_scratch/535 has incorrect size - sync failed
>> file /mnt/xfs_scratch/536 has incorrect size - sync failed
>> file /mnt/xfs_scratch/537 has incorrect size - sync failed
>> file /mnt/xfs_scratch/538 has incorrect size - sync failed
>> file /mnt/xfs_scratch/539 has incorrect size - sync failed
>> file /mnt/xfs_scratch/540 has incorrect size - sync failed
>> file /mnt/xfs_scratch/541 has incorrect size - sync failed
>> file /mnt/xfs_scratch/542 has incorrect size - sync failed
>> file /mnt/xfs_scratch/543 has incorrect size - sync failed
>> file /mnt/xfs_scratch/544 has incorrect size - sync failed
>> file /mnt/xfs_scratch/545 has incorrect size - sync failed
>> file /mnt/xfs_scratch/546 has incorrect size - sync failed
>> file /mnt/xfs_scratch/547 has incorrect size - sync failed
>> file /mnt/xfs_scratch/548 has incorrect size - sync failed
>> file /mnt/xfs_scratch/549 has incorrect size - sync failed
>> file /mnt/xfs_scratch/550 has incorrect size - sync failed
>> file /mnt/xfs_scratch/551 has incorrect size - sync failed
>> file /mnt/xfs_scratch/552 has incorrect size - sync failed
>> file /mnt/xfs_scratch/553 has incorrect size - sync failed
>> file /mnt/xfs_scratch/554 has incorrect size - sync failed
>> file /mnt/xfs_scratch/555 has incorrect size - sync failed
>> file /mnt/xfs_scratch/556 has incorrect size - sync failed
>> file /mnt/xfs_scratch/557 has incorrect size - sync failed
>> file /mnt/xfs_scratch/558 has incorrect size - sync failed
>> file /mnt/xfs_scratch/559 has incorrect size - sync failed
>> file /mnt/xfs_scratch/560 has incorrect size - sync failed
>> file /mnt/xfs_scratch/561 has incorrect size - sync failed
>> file /mnt/xfs_scratch/562 has incorrect size - sync failed
>> file /mnt/xfs_scratch/563 has incorrect size - sync failed
>> file /mnt/xfs_scratch/564 has incorrect size - sync failed
>> file /mnt/xfs_scratch/565 has incorrect size - sync failed
>> file /mnt/xfs_scratch/566 has incorrect size - sync failed
>> file /mnt/xfs_scratch/567 has incorrect size - sync failed
>> file /mnt/xfs_scratch/568 has incorrect size - sync failed
>> file /mnt/xfs_scratch/569 has incorrect size - sync failed
>> file /mnt/xfs_scratch/570 has incorrect size - sync failed
>> file /mnt/xfs_scratch/571 has incorrect size - sync failed
>> file /mnt/xfs_scratch/572 has incorrect size - sync failed
>> file /mnt/xfs_scratch/573 has incorrect size - sync failed
>> file /mnt/xfs_scratch/574 has incorrect size - sync failed
>> file /mnt/xfs_scratch/575 has incorrect size - sync failed
>> file /mnt/xfs_scratch/576 has incorrect size - sync failed
>> file /mnt/xfs_scratch/577 has incorrect size - sync failed
>> file /mnt/xfs_scratch/578 has incorrect size - sync failed
>> file /mnt/xfs_scratch/579 has incorrect size - sync failed
>> file /mnt/xfs_scratch/580 has incorrect size - sync failed
>> file /mnt/xfs_scratch/581 has incorrect size - sync failed
>> file /mnt/xfs_scratch/582 has incorrect size - sync failed
>> file /mnt/xfs_scratch/583 has incorrect size - sync failed
>> file /mnt/xfs_scratch/584 has incorrect size - sync failed
>> file /mnt/xfs_scratch/585 has incorrect size - sync failed
>> file /mnt/xfs_scratch/586 has incorrect size - sync failed
>> file /mnt/xfs_scratch/587 has incorrect size - sync failed
>> file /mnt/xfs_scratch/588 has incorrect size - sync failed
>> file /mnt/xfs_scratch/589 has incorrect size - sync failed
>> file /mnt/xfs_scratch/590 has incorrect size - sync failed
>> file /mnt/xfs_scratch/591 has incorrect size - sync failed
>> file /mnt/xfs_scratch/592 has incorrect size - sync failed
>> file /mnt/xfs_scratch/593 has incorrect size - sync failed
>> file /mnt/xfs_scratch/594 has incorrect size - sync failed
>> file /mnt/xfs_scratch/595 has incorrect size - sync failed
>> file /mnt/xfs_scratch/596 has incorrect size - sync failed
>> file /mnt/xfs_scratch/597 has incorrect size - sync failed
>> file /mnt/xfs_scratch/598 has incorrect size - sync failed
>> file /mnt/xfs_scratch/599 has incorrect size - sync failed
>> file /mnt/xfs_scratch/600 has incorrect size - sync failed
>> file /mnt/xfs_scratch/601 has incorrect size - sync failed
>> file /mnt/xfs_scratch/602 has incorrect size - sync failed
>> file /mnt/xfs_scratch/603 has incorrect size - sync failed
>> file /mnt/xfs_scratch/604 has incorrect size - sync failed
>> file /mnt/xfs_scratch/605 has incorrect size - sync failed
>> file /mnt/xfs_scratch/606 has incorrect size - sync failed
>> file /mnt/xfs_scratch/607 has incorrect size - sync failed
>> file /mnt/xfs_scratch/608 has incorrect size - sync failed
>> file /mnt/xfs_scratch/609 has incorrect size - sync failed
>> file /mnt/xfs_scratch/610 has incorrect size - sync failed
>> file /mnt/xfs_scratch/611 has incorrect size - sync failed
>> file /mnt/xfs_scratch/612 has incorrect size - sync failed
>> file /mnt/xfs_scratch/613 has incorrect size - sync failed
>> file /mnt/xfs_scratch/614 has incorrect size - sync failed
>> file /mnt/xfs_scratch/615 has incorrect size - sync failed
>> file /mnt/xfs_scratch/616 has incorrect size - sync failed
>> file /mnt/xfs_scratch/617 has incorrect size - sync failed
>> file /mnt/xfs_scratch/618 has incorrect size - sync failed
>> file /mnt/xfs_scratch/619 has incorrect size - sync failed
>> file /mnt/xfs_scratch/620 has incorrect size - sync failed
>> file /mnt/xfs_scratch/621 has incorrect size - sync failed
>> file /mnt/xfs_scratch/622 has incorrect size - sync failed
>> file /mnt/xfs_scratch/623 has incorrect size - sync failed
>> file /mnt/xfs_scratch/624 has incorrect size - sync failed
>> file /mnt/xfs_scratch/625 has incorrect size - sync failed
>> file /mnt/xfs_scratch/626 has incorrect size - sync failed
>> file /mnt/xfs_scratch/627 has incorrect size - sync failed
>> file /mnt/xfs_scratch/628 has incorrect size - sync failed
>> file /mnt/xfs_scratch/629 has incorrect size - sync failed
>> file /mnt/xfs_scratch/630 has incorrect size - sync failed
>> file /mnt/xfs_scratch/631 has incorrect size - sync failed
>> file /mnt/xfs_scratch/632 has incorrect size - sync failed
>> file /mnt/xfs_scratch/633 has incorrect size - sync failed
>> file /mnt/xfs_scratch/634 has incorrect size - sync failed
>> file /mnt/xfs_scratch/635 has incorrect size - sync failed
>> file /mnt/xfs_scratch/636 has incorrect size - sync failed
>> file /mnt/xfs_scratch/637 has incorrect size - sync failed
>> file /mnt/xfs_scratch/638 has incorrect size - sync failed
>> file /mnt/xfs_scratch/639 has incorrect size - sync failed
>> file /mnt/xfs_scratch/640 has incorrect size - sync failed
>> file /mnt/xfs_scratch/641 has incorrect size - sync failed
>> file /mnt/xfs_scratch/642 has incorrect size - sync failed
>> file /mnt/xfs_scratch/643 has incorrect size - sync failed
>> file /mnt/xfs_scratch/644 has incorrect size - sync failed
>> file /mnt/xfs_scratch/645 has incorrect size - sync failed
>> file /mnt/xfs_scratch/646 has incorrect size - sync failed
>> file /mnt/xfs_scratch/647 has incorrect size - sync failed
>> file /mnt/xfs_scratch/648 has incorrect size - sync failed
>> file /mnt/xfs_scratch/649 has incorrect size - sync failed
>> file /mnt/xfs_scratch/650 has incorrect size - sync failed
>> file /mnt/xfs_scratch/651 has incorrect size - sync failed
>> file /mnt/xfs_scratch/652 has incorrect size - sync failed
>> file /mnt/xfs_scratch/653 has incorrect size - sync failed
>> file /mnt/xfs_scratch/654 has incorrect size - sync failed
>> file /mnt/xfs_scratch/655 has incorrect size - sync failed
>> file /mnt/xfs_scratch/656 has incorrect size - sync failed
>> file /mnt/xfs_scratch/657 has incorrect size - sync failed
>> file /mnt/xfs_scratch/658 has incorrect size - sync failed
>> file /mnt/xfs_scratch/659 has incorrect size - sync failed
>> file /mnt/xfs_scratch/660 has incorrect size - sync failed
>> file /mnt/xfs_scratch/661 has incorrect size - sync failed
>> file /mnt/xfs_scratch/662 has incorrect size - sync failed
>> file /mnt/xfs_scratch/663 has incorrect size - sync failed
>> file /mnt/xfs_scratch/664 has incorrect size - sync failed
>> file /mnt/xfs_scratch/665 has incorrect size - sync failed
>> file /mnt/xfs_scratch/666 has incorrect size - sync failed
>> file /mnt/xfs_scratch/667 has incorrect size - sync failed
>> file /mnt/xfs_scratch/668 has incorrect size - sync failed
>> file /mnt/xfs_scratch/669 has incorrect size - sync failed
>> file /mnt/xfs_scratch/670 has incorrect size - sync failed
>> file /mnt/xfs_scratch/671 has incorrect size - sync failed
>> file /mnt/xfs_scratch/672 has incorrect size - sync failed
>> file /mnt/xfs_scratch/673 has incorrect size - sync failed
>> file /mnt/xfs_scratch/674 has incorrect size - sync failed
>> file /mnt/xfs_scratch/675 has incorrect size - sync failed
>> file /mnt/xfs_scratch/676 has incorrect size - sync failed
>> file /mnt/xfs_scratch/677 has incorrect size - sync failed
>> file /mnt/xfs_scratch/678 has incorrect size - sync failed
>> file /mnt/xfs_scratch/679 has incorrect size - sync failed
>> file /mnt/xfs_scratch/680 has incorrect size - sync failed
>> file /mnt/xfs_scratch/681 has incorrect size - sync failed
>> file /mnt/xfs_scratch/682 has incorrect size - sync failed
>> file /mnt/xfs_scratch/683 has incorrect size - sync failed
>> file /mnt/xfs_scratch/684 has incorrect size - sync failed
>> file /mnt/xfs_scratch/685 has incorrect size - sync failed
>> file /mnt/xfs_scratch/686 has incorrect size - sync failed
>> file /mnt/xfs_scratch/687 has incorrect size - sync failed
>> file /mnt/xfs_scratch/688 has incorrect size - sync failed
>> file /mnt/xfs_scratch/689 has incorrect size - sync failed
>> file /mnt/xfs_scratch/690 has incorrect size - sync failed
>> file /mnt/xfs_scratch/691 has incorrect size - sync failed
>> file /mnt/xfs_scratch/692 has incorrect size - sync failed
>> file /mnt/xfs_scratch/693 has incorrect size - sync failed
>> file /mnt/xfs_scratch/694 has incorrect size - sync failed
>> file /mnt/xfs_scratch/695 has incorrect size - sync failed
>> file /mnt/xfs_scratch/696 has incorrect size - sync failed
>> file /mnt/xfs_scratch/697 has incorrect size - sync failed
>> file /mnt/xfs_scratch/698 has incorrect size - sync failed
>> file /mnt/xfs_scratch/699 has incorrect size - sync failed
>> file /mnt/xfs_scratch/700 has incorrect size - sync failed
>> file /mnt/xfs_scratch/701 has incorrect size - sync failed
>> file /mnt/xfs_scratch/702 has incorrect size - sync failed
>> file /mnt/xfs_scratch/703 has incorrect size - sync failed
>> file /mnt/xfs_scratch/704 has incorrect size - sync failed
>> file /mnt/xfs_scratch/705 has incorrect size - sync failed
>> file /mnt/xfs_scratch/706 has incorrect size - sync failed
>> file /mnt/xfs_scratch/707 has incorrect size - sync failed
>> file /mnt/xfs_scratch/708 has incorrect size - sync failed
>> file /mnt/xfs_scratch/709 has incorrect size - sync failed
>> file /mnt/xfs_scratch/710 has incorrect size - sync failed
>> file /mnt/xfs_scratch/711 has incorrect size - sync failed
>> file /mnt/xfs_scratch/712 has incorrect size - sync failed
>> file /mnt/xfs_scratch/713 has incorrect size - sync failed
>> file /mnt/xfs_scratch/714 has incorrect size - sync failed
>> file /mnt/xfs_scratch/715 has incorrect size - sync failed
>> file /mnt/xfs_scratch/716 has incorrect size - sync failed
>> file /mnt/xfs_scratch/717 has incorrect size - sync failed
>> file /mnt/xfs_scratch/718 has incorrect size - sync failed
>> file /mnt/xfs_scratch/719 has incorrect size - sync failed
>> file /mnt/xfs_scratch/720 has incorrect size - sync failed
>> file /mnt/xfs_scratch/721 has incorrect size - sync failed
>> file /mnt/xfs_scratch/722 has incorrect size - sync failed
>> file /mnt/xfs_scratch/723 has incorrect size - sync failed
>> file /mnt/xfs_scratch/724 has incorrect size - sync failed
>> file /mnt/xfs_scratch/725 has incorrect size - sync failed
>> file /mnt/xfs_scratch/726 has incorrect size - sync failed
>> file /mnt/xfs_scratch/727 has incorrect size - sync failed
>> file /mnt/xfs_scratch/728 has incorrect size - sync failed
>> file /mnt/xfs_scratch/729 has incorrect size - sync failed
>> file /mnt/xfs_scratch/730 has incorrect size - sync failed
>> file /mnt/xfs_scratch/731 has incorrect size - sync failed
>> file /mnt/xfs_scratch/732 has incorrect size - sync failed
>> file /mnt/xfs_scratch/733 has incorrect size - sync failed
>> file /mnt/xfs_scratch/734 has incorrect size - sync failed
>> file /mnt/xfs_scratch/735 has incorrect size - sync failed
>> file /mnt/xfs_scratch/736 has incorrect size - sync failed
>> file /mnt/xfs_scratch/737 has incorrect size - sync failed
>> file /mnt/xfs_scratch/738 has incorrect size - sync failed
>> file /mnt/xfs_scratch/739 has incorrect size - sync failed
>> file /mnt/xfs_scratch/740 has incorrect size - sync failed
>> file /mnt/xfs_scratch/741 has incorrect size - sync failed
>> file /mnt/xfs_scratch/742 has incorrect size - sync failed
>> file /mnt/xfs_scratch/743 has incorrect size - sync failed
>> file /mnt/xfs_scratch/744 has incorrect size - sync failed
>> file /mnt/xfs_scratch/745 has incorrect size - sync failed
>> file /mnt/xfs_scratch/746 has incorrect size - sync failed
>> file /mnt/xfs_scratch/747 has incorrect size - sync failed
>> file /mnt/xfs_scratch/748 has incorrect size - sync failed
>> file /mnt/xfs_scratch/749 has incorrect size - sync failed
>> file /mnt/xfs_scratch/750 has incorrect size - sync failed
>> file /mnt/xfs_scratch/751 has incorrect size - sync failed
>> file /mnt/xfs_scratch/752 has incorrect size - sync failed
>> file /mnt/xfs_scratch/753 has incorrect size - sync failed
>> file /mnt/xfs_scratch/754 has incorrect size - sync failed
>> file /mnt/xfs_scratch/755 has incorrect size - sync failed
>> file /mnt/xfs_scratch/756 has incorrect size - sync failed
>> file /mnt/xfs_scratch/757 has incorrect size - sync failed
>> file /mnt/xfs_scratch/758 has incorrect size - sync failed
>> file /mnt/xfs_scratch/759 has incorrect size - sync failed
>> file /mnt/xfs_scratch/760 has incorrect size - sync failed
>> file /mnt/xfs_scratch/761 has incorrect size - sync failed
>> file /mnt/xfs_scratch/762 has incorrect size - sync failed
>> file /mnt/xfs_scratch/763 has incorrect size - sync failed
>> file /mnt/xfs_scratch/764 has incorrect size - sync failed
>> file /mnt/xfs_scratch/765 has incorrect size - sync failed
>> file /mnt/xfs_scratch/766 has incorrect size - sync failed
>> file /mnt/xfs_scratch/767 has incorrect size - sync failed
>> file /mnt/xfs_scratch/768 has incorrect size - sync failed
>> file /mnt/xfs_scratch/769 has incorrect size - sync failed
>> file /mnt/xfs_scratch/770 has incorrect size - sync failed
>> file /mnt/xfs_scratch/771 has incorrect size - sync failed
>> file /mnt/xfs_scratch/772 has incorrect size - sync failed
>> file /mnt/xfs_scratch/773 has incorrect size - sync failed
>> file /mnt/xfs_scratch/774 has incorrect size - sync failed
>> file /mnt/xfs_scratch/775 has incorrect size - sync failed
>> file /mnt/xfs_scratch/776 has incorrect size - sync failed
>> file /mnt/xfs_scratch/777 has incorrect size - sync failed
>> file /mnt/xfs_scratch/778 has incorrect size - sync failed
>> file /mnt/xfs_scratch/779 has incorrect size - sync failed
>> file /mnt/xfs_scratch/780 has incorrect size - sync failed
>> file /mnt/xfs_scratch/781 has incorrect size - sync failed
>> file /mnt/xfs_scratch/782 has incorrect size - sync failed
>> file /mnt/xfs_scratch/783 has incorrect size - sync failed
>> file /mnt/xfs_scratch/784 has incorrect size - sync failed
>> file /mnt/xfs_scratch/785 has incorrect size - sync failed
>> file /mnt/xfs_scratch/786 has incorrect size - sync failed
>> file /mnt/xfs_scratch/787 has incorrect size - sync failed
>> file /mnt/xfs_scratch/788 has incorrect size - sync failed
>> file /mnt/xfs_scratch/789 has incorrect size - sync failed
>> file /mnt/xfs_scratch/790 has incorrect size - sync failed
>> file /mnt/xfs_scratch/791 has incorrect size - sync failed
>> file /mnt/xfs_scratch/792 has incorrect size - sync failed
>> file /mnt/xfs_scratch/793 has incorrect size - sync failed
>> file /mnt/xfs_scratch/794 has incorrect size - sync failed
>> file /mnt/xfs_scratch/795 has incorrect size - sync failed
>> file /mnt/xfs_scratch/796 has incorrect size - sync failed
>> file /mnt/xfs_scratch/797 has incorrect size - sync failed
>> file /mnt/xfs_scratch/798 has incorrect size - sync failed
>> file /mnt/xfs_scratch/799 has incorrect size - sync failed
>> file /mnt/xfs_scratch/800 has incorrect size - sync failed
>> file /mnt/xfs_scratch/801 has incorrect size - sync failed
>> file /mnt/xfs_scratch/802 has incorrect size - sync failed
>> file /mnt/xfs_scratch/803 has incorrect size - sync failed
>> file /mnt/xfs_scratch/804 has incorrect size - sync failed
>> file /mnt/xfs_scratch/805 has incorrect size - sync failed
>> file /mnt/xfs_scratch/806 has incorrect size - sync failed
>> file /mnt/xfs_scratch/807 has incorrect size - sync failed
>> file /mnt/xfs_scratch/808 has incorrect size - sync failed
>> file /mnt/xfs_scratch/809 has incorrect size - sync failed
>> file /mnt/xfs_scratch/810 has incorrect size - sync failed
>> file /mnt/xfs_scratch/811 has incorrect size - sync failed
>> file /mnt/xfs_scratch/812 has incorrect size - sync failed
>> file /mnt/xfs_scratch/813 has incorrect size - sync failed
>> file /mnt/xfs_scratch/814 has incorrect size - sync failed
>> file /mnt/xfs_scratch/815 has incorrect size - sync failed
>> file /mnt/xfs_scratch/816 has incorrect size - sync failed
>> file /mnt/xfs_scratch/817 has incorrect size - sync failed
>> file /mnt/xfs_scratch/818 has incorrect size - sync failed
>> file /mnt/xfs_scratch/819 has incorrect size - sync failed
>> file /mnt/xfs_scratch/820 has incorrect size - sync failed
>> file /mnt/xfs_scratch/821 has incorrect size - sync failed
>> file /mnt/xfs_scratch/822 has incorrect size - sync failed
>> file /mnt/xfs_scratch/823 has incorrect size - sync failed
>> file /mnt/xfs_scratch/824 has incorrect size - sync failed
>> file /mnt/xfs_scratch/825 has incorrect size - sync failed
>> file /mnt/xfs_scratch/826 has incorrect size - sync failed
>> file /mnt/xfs_scratch/827 has incorrect size - sync failed
>> file /mnt/xfs_scratch/828 has incorrect size - sync failed
>> file /mnt/xfs_scratch/829 has incorrect size - sync failed
>> file /mnt/xfs_scratch/830 has incorrect size - sync failed
>> file /mnt/xfs_scratch/831 has incorrect size - sync failed
>> file /mnt/xfs_scratch/832 has incorrect size - sync failed
>> file /mnt/xfs_scratch/833 has incorrect size - sync failed
>> file /mnt/xfs_scratch/834 has incorrect size - sync failed
>> file /mnt/xfs_scratch/835 has incorrect size - sync failed
>> file /mnt/xfs_scratch/836 has incorrect size - sync failed
>> file /mnt/xfs_scratch/837 has incorrect size - sync failed
>> file /mnt/xfs_scratch/838 has incorrect size - sync failed
>> file /mnt/xfs_scratch/839 has incorrect size - sync failed
>> file /mnt/xfs_scratch/840 has incorrect size - sync failed
>> file /mnt/xfs_scratch/841 has incorrect size - sync failed
>> file /mnt/xfs_scratch/842 has incorrect size - sync failed
>> file /mnt/xfs_scratch/843 has incorrect size - sync failed
>> file /mnt/xfs_scratch/844 has incorrect size - sync failed
>> file /mnt/xfs_scratch/845 has incorrect size - sync failed
>> file /mnt/xfs_scratch/846 has incorrect size - sync failed
>> file /mnt/xfs_scratch/847 has incorrect size - sync failed
>> file /mnt/xfs_scratch/848 has incorrect size - sync failed
>> file /mnt/xfs_scratch/849 has incorrect size - sync failed
>> file /mnt/xfs_scratch/850 has incorrect size - sync failed
>> file /mnt/xfs_scratch/851 has incorrect size - sync failed
>> file /mnt/xfs_scratch/852 has incorrect size - sync failed
>> file /mnt/xfs_scratch/853 has incorrect size - sync failed
>> file /mnt/xfs_scratch/854 has incorrect size - sync failed
>> file /mnt/xfs_scratch/855 has incorrect size - sync failed
>> file /mnt/xfs_scratch/856 has incorrect size - sync failed
>> file /mnt/xfs_scratch/857 has incorrect size - sync failed
>> file /mnt/xfs_scratch/858 has incorrect size - sync failed
>> file /mnt/xfs_scratch/859 has incorrect size - sync failed
>> file /mnt/xfs_scratch/860 has incorrect size - sync failed
>> file /mnt/xfs_scratch/861 has incorrect size - sync failed
>> file /mnt/xfs_scratch/862 has incorrect size - sync failed
>> file /mnt/xfs_scratch/863 has incorrect size - sync failed
>> file /mnt/xfs_scratch/864 has incorrect size - sync failed
>> file /mnt/xfs_scratch/865 has incorrect size - sync failed
>> file /mnt/xfs_scratch/866 has incorrect size - sync failed
>> file /mnt/xfs_scratch/867 has incorrect size - sync failed
>> file /mnt/xfs_scratch/868 has incorrect size - sync failed
>> file /mnt/xfs_scratch/869 has incorrect size - sync failed
>> file /mnt/xfs_scratch/870 has incorrect size - sync failed
>> file /mnt/xfs_scratch/871 has incorrect size - sync failed
>> file /mnt/xfs_scratch/872 has incorrect size - sync failed
>> file /mnt/xfs_scratch/873 has incorrect size - sync failed
>> file /mnt/xfs_scratch/874 has incorrect size - sync failed
>> file /mnt/xfs_scratch/875 has incorrect size - sync failed
>> file /mnt/xfs_scratch/876 has incorrect size - sync failed
>> file /mnt/xfs_scratch/877 has incorrect size - sync failed
>> file /mnt/xfs_scratch/878 has incorrect size - sync failed
>> file /mnt/xfs_scratch/879 has incorrect size - sync failed
>> file /mnt/xfs_scratch/880 has incorrect size - sync failed
>> file /mnt/xfs_scratch/881 has incorrect size - sync failed
>> file /mnt/xfs_scratch/882 has incorrect size - sync failed
>> file /mnt/xfs_scratch/883 has incorrect size - sync failed
>> file /mnt/xfs_scratch/884 has incorrect size - sync failed
>> file /mnt/xfs_scratch/885 has incorrect size - sync failed
>> file /mnt/xfs_scratch/886 has incorrect size - sync failed
>> file /mnt/xfs_scratch/887 has incorrect size - sync failed
>> file /mnt/xfs_scratch/888 has incorrect size - sync failed
>> file /mnt/xfs_scratch/889 has incorrect size - sync failed
>> file /mnt/xfs_scratch/890 has incorrect size - sync failed
>> file /mnt/xfs_scratch/891 has incorrect size - sync failed
>> file /mnt/xfs_scratch/892 has incorrect size - sync failed
>> file /mnt/xfs_scratch/893 has incorrect size - sync failed
>> file /mnt/xfs_scratch/894 has incorrect size - sync failed
>> file /mnt/xfs_scratch/895 has incorrect size - sync failed
>> file /mnt/xfs_scratch/896 has incorrect size - sync failed
>> file /mnt/xfs_scratch/897 has incorrect size - sync failed
>> file /mnt/xfs_scratch/898 has incorrect size - sync failed
>> file /mnt/xfs_scratch/899 has incorrect size - sync failed
>> file /mnt/xfs_scratch/900 has incorrect size - sync failed
>> file /mnt/xfs_scratch/901 has incorrect size - sync failed
>> file /mnt/xfs_scratch/902 has incorrect size - sync failed
>> file /mnt/xfs_scratch/903 has incorrect size - sync failed
>> file /mnt/xfs_scratch/904 has incorrect size - sync failed
>> file /mnt/xfs_scratch/905 has incorrect size - sync failed
>> file /mnt/xfs_scratch/906 has incorrect size - sync failed
>> file /mnt/xfs_scratch/907 has incorrect size - sync failed
>> file /mnt/xfs_scratch/908 has incorrect size - sync failed
>> file /mnt/xfs_scratch/909 has incorrect size - sync failed
>> file /mnt/xfs_scratch/910 has incorrect size - sync failed
>> file /mnt/xfs_scratch/911 has incorrect size - sync failed
>> file /mnt/xfs_scratch/912 has incorrect size - sync failed
>> file /mnt/xfs_scratch/913 has incorrect size - sync failed
>> file /mnt/xfs_scratch/914 has incorrect size - sync failed
>> file /mnt/xfs_scratch/915 has incorrect size - sync failed
>> file /mnt/xfs_scratch/916 has incorrect size - sync failed
>> file /mnt/xfs_scratch/917 has incorrect size - sync failed
>> file /mnt/xfs_scratch/918 has incorrect size - sync failed
>> file /mnt/xfs_scratch/919 has incorrect size - sync failed
>> file /mnt/xfs_scratch/920 has incorrect size - sync failed
>> file /mnt/xfs_scratch/921 has incorrect size - sync failed
>> file /mnt/xfs_scratch/922 has incorrect size - sync failed
>> file /mnt/xfs_scratch/923 has incorrect size - sync failed
>> file /mnt/xfs_scratch/924 has incorrect size - sync failed
>> file /mnt/xfs_scratch/925 has incorrect size - sync failed
>> file /mnt/xfs_scratch/926 has incorrect size - sync failed
>> file /mnt/xfs_scratch/927 has incorrect size - sync failed
>> file /mnt/xfs_scratch/928 has incorrect size - sync failed
>> file /mnt/xfs_scratch/929 has incorrect size - sync failed
>> file /mnt/xfs_scratch/930 has incorrect size - sync failed
>> file /mnt/xfs_scratch/931 has incorrect size - sync failed
>> file /mnt/xfs_scratch/932 has incorrect size - sync failed
>> file /mnt/xfs_scratch/933 has incorrect size - sync failed
>> file /mnt/xfs_scratch/934 has incorrect size - sync failed
>> file /mnt/xfs_scratch/935 has incorrect size - sync failed
>> file /mnt/xfs_scratch/936 has incorrect size - sync failed
>> file /mnt/xfs_scratch/937 has incorrect size - sync failed
>> file /mnt/xfs_scratch/938 has incorrect size - sync failed
>> file /mnt/xfs_scratch/939 has incorrect size - sync failed
>> file /mnt/xfs_scratch/940 has incorrect size - sync failed
>> file /mnt/xfs_scratch/941 has incorrect size - sync failed
>> file /mnt/xfs_scratch/942 has incorrect size - sync failed
>> file /mnt/xfs_scratch/943 has incorrect size - sync failed
>> file /mnt/xfs_scratch/944 has incorrect size - sync failed
>> file /mnt/xfs_scratch/945 has incorrect size - sync failed
>> file /mnt/xfs_scratch/946 has incorrect size - sync failed
>> file /mnt/xfs_scratch/947 has incorrect size - sync failed
>> file /mnt/xfs_scratch/948 has incorrect size - sync failed
>> file /mnt/xfs_scratch/949 has incorrect size - sync failed
>> file /mnt/xfs_scratch/950 has incorrect size - sync failed
>> file /mnt/xfs_scratch/951 has incorrect size - sync failed
>> file /mnt/xfs_scratch/952 has incorrect size - sync failed
>> file /mnt/xfs_scratch/953 has incorrect size - sync failed
>> file /mnt/xfs_scratch/954 has incorrect size - sync failed
>> file /mnt/xfs_scratch/955 has incorrect size - sync failed
>> file /mnt/xfs_scratch/956 has incorrect size - sync failed
>> file /mnt/xfs_scratch/957 has incorrect size - sync failed
>> file /mnt/xfs_scratch/958 has incorrect size - sync failed
>> file /mnt/xfs_scratch/959 has incorrect size - sync failed
>> file /mnt/xfs_scratch/960 has incorrect size - sync failed
>> file /mnt/xfs_scratch/961 has incorrect size - sync failed
>> file /mnt/xfs_scratch/962 has incorrect size - sync failed
>> file /mnt/xfs_scratch/963 has incorrect size - sync failed
>> file /mnt/xfs_scratch/964 has incorrect size - sync failed
>> file /mnt/xfs_scratch/965 has incorrect size - sync failed
>> file /mnt/xfs_scratch/966 has incorrect size - sync failed
>> file /mnt/xfs_scratch/967 has incorrect size - sync failed
>> file /mnt/xfs_scratch/968 has incorrect size - sync failed
>> file /mnt/xfs_scratch/969 has incorrect size - sync failed
>> file /mnt/xfs_scratch/970 has incorrect size - sync failed
>> file /mnt/xfs_scratch/971 has incorrect size - sync failed
>> file /mnt/xfs_scratch/972 has incorrect size - sync failed
>> file /mnt/xfs_scratch/973 has incorrect size - sync failed
>> file /mnt/xfs_scratch/974 has incorrect size - sync failed
>> file /mnt/xfs_scratch/975 has incorrect size - sync failed
>> file /mnt/xfs_scratch/976 has incorrect size - sync failed
>> file /mnt/xfs_scratch/977 has incorrect size - sync failed
>> file /mnt/xfs_scratch/978 has incorrect size - sync failed
>> file /mnt/xfs_scratch/979 has incorrect size - sync failed
>> file /mnt/xfs_scratch/980 has incorrect size - sync failed
>> file /mnt/xfs_scratch/981 has incorrect size - sync failed
>> file /mnt/xfs_scratch/982 has incorrect size - sync failed
>> file /mnt/xfs_scratch/983 has incorrect size - sync failed
>> file /mnt/xfs_scratch/984 has incorrect size - sync failed
>> file /mnt/xfs_scratch/985 has incorrect size - sync failed
>> file /mnt/xfs_scratch/986 has incorrect size - sync failed
>> file /mnt/xfs_scratch/987 has incorrect size - sync failed
>> file /mnt/xfs_scratch/988 has incorrect size - sync failed
>> file /mnt/xfs_scratch/989 has incorrect size - sync failed
>> file /mnt/xfs_scratch/990 has incorrect size - sync failed
>> file /mnt/xfs_scratch/991 has incorrect size - sync failed
>> file /mnt/xfs_scratch/992 has incorrect size - sync failed
>> file /mnt/xfs_scratch/993 has incorrect size - sync failed
>> file /mnt/xfs_scratch/994 has incorrect size - sync failed
>> file /mnt/xfs_scratch/995 has incorrect size - sync failed
>> file /mnt/xfs_scratch/996 has incorrect size - sync failed
>> file /mnt/xfs_scratch/997 has incorrect size - sync failed
>> file /mnt/xfs_scratch/998 has incorrect size - sync failed
>> file /mnt/xfs_scratch/999 has incorrect size - sync failed
> 183
> 184 0s ...
> 
> Not run: 010 022 023 024 025 035 036 037 038 039 040 043 044 050 052 055 057 058 077 090 092 093 094 095 097 098 099 101 102 112 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 168 180
> Failures: 016 018 081 082 103 130 132 166 167 171 172 173 175 176 177 178 182
> Failed 17 of 109 tests
> 
> 

-- 

  Mark Goodwin                                  markgw@sgi.com
  Engineering Manager for XFS and PCP    Phone: +61-3-99631937
  SGI Australian Software Group           Cell: +61-4-18969583
-------------------------------------------------------------
