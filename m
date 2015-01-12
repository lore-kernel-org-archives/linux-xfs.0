Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C9DAC7F51
	for <xfs@oss.sgi.com>; Mon, 12 Jan 2015 10:09:09 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8C327304051
	for <xfs@oss.sgi.com>; Mon, 12 Jan 2015 08:09:06 -0800 (PST)
Received: from smtp.welcomes-you.com (welcomes-you.com [144.76.218.113]) by
	cuda.sgi.com with ESMTP id rB54442FDf7B7rjM for
	<xfs@oss.sgi.com>; Mon, 12 Jan 2015 08:09:04 -0800 (PST)
Message-ID: <54B3F19D.6030307@aei.mpg.de>
Date: Mon, 12 Jan 2015 17:09:01 +0100
From: Carsten Aulbert <Carsten.Aulbert@aei.mpg.de>
MIME-Version: 1.0
Subject: Re: extremely slow file creation/deletion after xfs ran full
References: <54B387A1.6000807@aei.mpg.de> <54B3CC6A.4080405@aei.mpg.de>
	<20150112155206.GD25944@bfoster.bfoster>
In-Reply-To: <20150112155206.GD25944@bfoster.bfoster>
Content-Type: multipart/mixed; boundary="------------000503080006080407090303"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------000503080006080407090303
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hi Brian

On 01/12/2015 04:52 PM, Brian Foster wrote:
> I can't see any symbols associated with the perf output. I suspect
> because I'm not running on your kernel. It might be better to run 'perf
> report -g' and copy/paste the stack trace for some of the larger
> consumers.
> 

Sorry, I rarely need to use perf and of course forgot that the
intermediate output it tightly coupled to the running kernel. Attaching
the output of perf report -g here.
> 
> Sounds good. FWIW, something like the following should tell us how many
> free inodes are available in each ag, and thus whether we have to search
> for free inodes in existing records rather than allocate new ones:
> 
> for i in $(seq 0 15); do
> 	xfs_db -c "agi $i" -c "p freecount" <dev>
> done
> 
Another metric :)

freecount = 53795884
freecount = 251
freecount = 45
freecount = 381
freecount = 11009
freecount = 6748
freecount = 663
freecount = 595
freecount = 693
freecount = 9089
freecount = 37122
freecount = 2657
freecount = 60497
freecount = 1790275
freecount = 54544

That looks... not really uniform to me.

Cheers

Carsten



--------------000503080006080407090303
Content-Type: application/gzip;
 name="touch.stack.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="touch.stack.gz"

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
--------------000503080006080407090303
Content-Type: application/gzip;
 name="rm.stack.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="rm.stack.gz"

H4sIAK3ws1QAA+2WTW/bMAyG7/kVBIqhLdB4ceLEda/Ddu2huw2FoMh07FWWDElO7GE/frST
du0iJ+5lpxKII0iPqA++lHQB3zWkha0kb8HlCBWaLEi545AjT9FAoTJ9A5VEbhFq+k2n+5bP
z4WpVrIFXblCKxtMLiYX8MBL6mHvIJwB6Axwi8rBpWgF1V4S8LWvELqm7xWvKqOb4PoO5mG0
DBdx7+N+i6YbAOCLLkuuqNDZQ84NpnC//onCgdce2nKtJbkIDgbwb+GveapejObR+YsWwTL+
dHBuSoAfT2gUyuCJS2nb0j52VY/AWKEE+6UVMuu4w32HydH8fh9XTafTo+7HVGcv7YV1hbB+
aIOOVXyDLDO6pA+iJNzPMkar0KLnLVM6xZLbJz/7mtyW3A/lFCuJrKSBeS0HR031YYrD0Ajk
XPusibP5KktiEc2ipZ+5UoW8nvRtiySIwxGh1iROU6TIBInRPjsaHeq33f2zsq11WDJBA9MC
rau4y0+vkaOYJ/E5hqfpgLRmTZQsV1G4jKMQl7dJdLvflDAKkvmITenODtanOuN1w4Rr3rUp
x90HQv6GO8vQ2VH5IWwqkioJcad23AzF4UBRyomBrLDo6opxs9lnhh+SmqcMZcbWheKmHfLE
jcgPCNsnkhnMDWxQbElDdDxqFRTW8GC+OEMPau10u6vXJ4FOXuswFpmYr1bxXjYQBqsxufQq
Vt1SmK5dVXvS+bxsTnbv7J3S6fwNhpw5OiZPI6QKhbt+4z5EcRDFLAiTEaJQdMHRMnamcHSV
WMMsz3D8WeLt7p9loRxKVpU1Q8XXdHHRRPxkc7t6xZ1QzyjoWWI0fOOYFTmm9AD40OT/1eSk
f2tefdMG6MlbbHJ68kraadnf0dsCdzfgTHvXhwAMVto4Upjt/rr13KRWX5OPP0hHW+FJCwAA

--------------000503080006080407090303
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------000503080006080407090303--
