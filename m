Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 04 May 2008 23:19:45 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m456JKo1024762
	for <xfs@oss.sgi.com>; Sun, 4 May 2008 23:19:23 -0700
Message-ID: <481EA70A.2030500@sgi.com>
Date: Mon, 05 May 2008 16:19:54 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: review: xfstests/016 change
References: <481E7F17.5090601@sgi.com> <20080505055446.GB15609@infradead.org>
In-Reply-To: <20080505055446.GB15609@infradead.org>
Content-Type: multipart/mixed;
 boundary="------------040506090206080500000808"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

This is a multi-part message in MIME format.
--------------040506090206080500000808
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Christoph Hellwig wrote:
> On Mon, May 05, 2008 at 01:29:27PM +1000, Timothy Shimmin wrote:
>> Hi there,
>>
>> xfstests/016 has been failing for a while in many cases.
>> It was relying on the log traffic for create/rm to be unaltered
>> in XFS over the life of XFS.
>> Its initial purpose was to test out the writing of the log around
>> wrapping and checking that as we wrapped we didn't corrupt any data
>> after the end of the log.
>>
>> The patch is to modify xfstest, 016, to take a sampling of the log traffic
>> to guestimate how many ops are needed to get to the end of the log,
>> instead of hard-coding in how many ops are expected to get there.
> 
> I get four rejects out of four hunk when trying to apply this patch,
> looks like whitespace-damage.

Groan. Sorry.
I'll attach 016.patch for the moment.

Need to see where things went wrong with the whitespace.

--Tim


--------------040506090206080500000808
Content-Type: text/x-patch;
 name="016.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="016.patch"


===========================================================================
Index: xfstests/016
===========================================================================

--- a/xfstests/016	2008-05-05 11:26:50.000000000 +1000
+++ b/xfstests/016	2008-05-05 13:07:01.040000000 +1000
@@ -50,7 +50,7 @@ _init()
     echo "*** reset partition"
     $here/src/devzero -b 2048 -n 50 -v 198 $SCRATCH_DEV
     echo "*** mkfs"
-    force_opts="-dsize=50m -lsize=2097152"
+    force_opts="-dsize=50m -lsize=$log_size"
     echo mkfs_xfs $force_opts $SCRATCH_DEV >>$seq.full
     _scratch_mkfs_xfs $force_opts >$tmp.mkfs0 2>&1
     [ $? -ne 0 ] && \
@@ -156,6 +156,10 @@ _supported_os Linux
 
 rm -f $seq.full
 
+# mkfs sizes
+log_size=2097152
+log_size_bb=`expr $log_size / 512`
+
 _require_scratch
 _init
 
@@ -163,27 +167,47 @@ block=`_after_log $SCRATCH_DEV`
 echo "fsblock after log = $block"               >>$seq.full
 _check_corrupt $SCRATCH_DEV $block
 
-size=`_log_size`
-echo "log size = $size BB"                      >>$seq.full
+actual_log_size=`_log_size`
+echo "log size = $actual_log_size BB"                      >>$seq.full
 head=`_log_head`
 echo "log position = $head"                     >>$seq.full
 lsunit=`_log_sunit`
 echo "log sunit = $lsunit"			>>$seq.full
 
-[ $size -eq 4096 ] || \
+# sanity checks
+[ $actual_log_size -eq $log_size_bb ] || \
     _fail "!!! unexpected log size $size"
 [ $head -eq 2 -o $head -eq $((lsunit/512)) ] || \
     _fail "!!! unexpected initial log position $head vs. $((lsunit/512))"
 
-echo "    lots of traffic"                      >>$seq.full
-_log_traffic 850
+# find how how many blocks per op for 100 ops
+# ignore the fact that it will also include an unmount record etc...
+# this should be small overall
+echo "    lots of traffic for sampling" >>$seq.full
+sample_size_ops=100
+_log_traffic $sample_size_ops
+head1=`_log_head`
+num_blocks=`expr $head1 - $head`
+blocks_per_op=`echo "scale=3; $num_blocks / $sample_size_ops" | bc`
+echo "blocks_per_op = $blocks_per_op" >>$seq.full
+num_expected_ops=`echo "$log_size_bb / $blocks_per_op" | bc`
+echo "num_expected_ops = $num_expected_ops" >>$seq.full
+num_expected_to_go=`echo "$num_expected_ops - $sample_size_ops" | bc`
+echo "num_expected_to_go = $num_expected_to_go" >>$seq.full
+
+echo "    lots more traffic" >>$seq.full
+_log_traffic $num_expected_to_go
 head=`_log_head`
 echo "log position = $head"                     >>$seq.full
 
-[ $head -gt 3850 -a $head -lt 4050 ] || \
-    _fail "!!! unexpected log position $head"
+# e.g. 3891
+near_end_min=`echo "0.95 * $log_size_bb" | bc | sed 's/\..*//'`
+echo "near_end_min = $near_end_min" >>$seq.full
+
+[ $head -gt $near_end_min -a $head -lt $log_size_bb ] || \
+    _fail "!!! unexpected near end log position $head"
 
-for c in 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
+for c in `seq 0 20`
 do
     echo "   little traffic"            >>$seq.full
     _log_traffic 2
@@ -193,7 +217,7 @@ do
 done
 
 [ $head -lt 1000 ] || \
-    _fail "!!! unexpected log position $head"
+    _fail "!!! unexpected wrapped log position $head"
 
 # success, all done
 status=0

--------------040506090206080500000808--
