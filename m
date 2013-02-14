Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 095208027
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2013 12:45:10 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 90773AC002
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2013 10:45:09 -0800 (PST)
Received: from mta01.ornl.gov (mta01.ornl.gov [128.219.177.14]) by
	cuda.sgi.com with ESMTP id EGvBO7RTVV6r6gF7 (version=TLSv1
	cipher=RC4-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 14 Feb 2013 10:45:08 -0800 (PST)
Received: from exchhub1.ornl.gov (exchhub1.ornl.gov [160.91.2.111])
	by emgwy2.ornl.gov (Postfix) with ESMTPS id AEF7EE09D4
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2013 13:45:07 -0500 (EST)
From: "Settlemyer, Bradley W." <settlemyerbw@ornl.gov>
Date: Thu, 14 Feb 2013 13:45:04 -0500
Subject: Weird performance on a FusionIO Octal (Random writes faster than Seq.)
Message-ID: <CD429AE0.4B5E%settlemyerbw@ornl.gov>
Content-Language: en-US
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hello

  So I'm getting weird performance using XFS on a 5TB FusionIO octal (a
solid state device plugged into my pcie bus).  It seems to be a newish
problem, but I can't go back to an old version of everything to prove
that, because I've only got one working Octal right now (they are a little
pricy).

  At any rate, when doing random 16MB requests to a file with 16 threads,
I get about 4.5GB/s.  When writing sequentially with 16 threads doing 16MB
requests, I get about 3.5GB/s -- the first time.  Once the file is written
the first time, a second pass results in 4.5GB/s.

  The thing is, I'm using preallocate on both types of I/O (that is, I
always preallocate the entire file whether its random or sequential).  I
allocate the exact same size file in both cases, its just faster the first
time with random writes rather than sequential writes.

  So if you had xdd 7.0 and an octal plugged into slot 6 of an HP DL585 G7
(running CentOS 6.3), you could replicate these test results with the
following commands (note xdd's default block size is 1024, so you'll see
everything is accounting for 1024 byte size blocks):

# Generate a set of random seek offsets within a file
data_size=$((256*8*1024*1024*1024))
rand_range=$((data_size / 16384 / 1024 - 1))
    shuf -i 0-$rand_range | awk "{i += 1}; {print i-1, \$0*16384,  \"16384
w 0 0\" };" > wseek_file


# Perform the random writes
numactl --cpunodebind=4 xdd -op write -target
/data/xfs-numa4/baseline-rand1 -reqsize 16384 -qd 16 -dio -verbose -bytes
2199023255552 -preallocate 2199023255552 -seek load wseek file

# Perform sequential writes
numactl --cpunodebind=4 xdd -op write -target
/data/xfs-numa4/baseline-seq1 -reqsize 16384 -qd 16 -dio -verbose -bytes
2199023255552 -preallocate 2199023255552

And so for the results I get the following (if you know xdd results):
COMBINED             1       1      16    2199023255552      131072
483.311   4549.910    271.196     0.230    67.644    write     16777216
 COMBINED             1       1      16    2199023255552      131072
605.366   3632.550    216.517     0.289    53.971    write     16777216


The bandwidths here are 4549.910 MB/s for the random, and 3632.550 MB/s
for the sequential.  If I run it again to the already existing file, I get:

COMBINED 1 1 16 2199023255552 131072 482.851 4554.248 271.454 0.230 66.016
write 16777216

Which is a write bandwidth of 4554.248MB/s.


Weird, right?

Cheers,
Brad

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
