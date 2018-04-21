Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36704 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750784AbeDUEnx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 21 Apr 2018 00:43:53 -0400
Subject: Re: question about mkfs.xfs
References: <5ADAAE79.5020803@cn.fujitsu.com>
 <b663f0ab-ab78-961f-7e24-a9794eb07d98@sandeen.net>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <855f13dc-7cb7-b211-94e6-65f600c99ddd@redhat.com>
Date: Fri, 20 Apr 2018 23:43:51 -0500
MIME-Version: 1.0
In-Reply-To: <b663f0ab-ab78-961f-7e24-a9794eb07d98@sandeen.net>
Content-Type: text/plain; charset=gbk
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, Xiao Yang <yangx.jy@cn.fujitsu.com>
Cc: linux-xfs@vger.kernel.org

On 4/20/18 11:34 PM, Eric Sandeen wrote:
> 
> 
> On 4/20/18 10:22 PM, Xiao Yang wrote:
>> Hi Eric£¬
>>
>> Before commit 16adcb8 in xfsprogs-dev, only "sunit=0,swidth=0" is vaild
>> and will convert
>> into the default stripe config as expected.
> 
> It behaved the same as the default, because it looked the same as
> "not set" to all the conditionals in mkfs.
> 
>> After this commit, both
>> "sunit=0,swidth=0"
>> and "sunit=0,swidth=64" will be forced to convert into the default
>> stripe config.
> 
> 0,0 should be allowed, to force mkfs to ignore any stripe geometry
> reported by the device.
> 
>> If either of sunit and swidth is not 0, should we do a forced conversion?
>> I am not sure if we should reject the combination(e.g. sunit=0,swidth=64).
> 
> I am not sure what you mean by "forced conversion" - can you give specific
> examples?
> 
> However, a stripe unit of 0 with a non-zero stripe width should probably
> also be rejected, because it has no meaning.  I think it was rejected
> before, and my commit accidentally allowed it again.
> 
> It probably needs another test added back in, to check for "both options
> were specified, but (only) one was zero."

Maybe like this:

mkfs.xfs: if either sunit or swidth is nonzero, the other must be as well

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 78d0ce5..b356d4d 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2271,7 +2271,8 @@ _("data stripe width (%lld) is too large of a multiple of the data stripe unit (
 		dswidth = big_dswidth;
 	}
 
-	if (dsunit && (!dswidth || (dswidth % dsunit != 0))) {
+	if ((dsunit && !dswidth) || (!dsunit && dswidth) ||
+           (dsunit && (dswidth % dsunit != 0))) {
 		fprintf(stderr,
 _("data stripe width (%d) must be a multiple of the data stripe unit (%d)\n"),
 			dswidth, dsunit);


which yields:

# mkfs.xfs -f -dsunit=0,swidth=64,file,name=fsfile,size=1g
data stripe width (64) must be a multiple of the data stripe unit (0)

# mkfs.xfs -f -dsunit=64,swidth=0,file,name=fsfile,size=1g
data stripe width (0) must be a multiple of the data stripe unit (64)

# mkfs.xfs -f -dsunit=64,swidth=7,file,name=fsfile,size=1g
data stripe width (7) must be a multiple of the data stripe unit (64)

# mkfs.xfs -f -dsunit=0,swidth=0,file,name=fsfile,size=1g
<success>

-Eric
