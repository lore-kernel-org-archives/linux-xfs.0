Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5EL8pI7130236 for <xfs@oss.sgi.com>; Tue, 14 Jun 2011 16:08:51 -0500
Received: from e5.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 79EE31348C77
	for <xfs@oss.sgi.com>; Tue, 14 Jun 2011 14:08:49 -0700 (PDT)
Received: from e5.ny.us.ibm.com (e5.ny.us.ibm.com [32.97.182.145]) by
	cuda.sgi.com with ESMTP id exxQJhLRd5HqEOcK for
	<xfs@oss.sgi.com>; Tue, 14 Jun 2011 14:08:49 -0700 (PDT)
Received: from d01relay01.pok.ibm.com (d01relay01.pok.ibm.com [9.56.227.233])
	by e5.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p5EKex3g014933
	for <xfs@oss.sgi.com>; Tue, 14 Jun 2011 16:40:59 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p5EL8nPf112526 for <xfs@oss.sgi.com>; Tue, 14 Jun 2011 17:08:49 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p5EH8bs4000641 for <xfs@oss.sgi.com>; Tue, 14 Jun 2011 14:08:37 -0300
Subject: Re: Failure of test case 244
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <4DF7B89E.8010000@sandeen.net>
References: <1308076910.7661.470.camel@chandra-lucid.beaverton.ibm.com>
	<4DF7B89E.8010000@sandeen.net>
Date: Tue, 14 Jun 2011 14:08:47 -0700
Message-ID: <1308085727.7661.484.camel@chandra-lucid.beaverton.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: XFS Mailing List <xfs@oss.sgi.com>

Ran the test with new mkfs.xfs. Got this failure. Wondering if any other
tools need to be replaced.

-------------
STYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 elm3c201 2.6.39-rc4-xfs.git.p2+
MKFS_OPTIONS  -- -f -bsize=4096 /dev/sdd2
MOUNT_OPTIONS -- -o context=system_u:object_r:nfs_t:s0 /dev/sdd2 /mnt/xfsScratchMntPt

244	 [failed, exit status 1] - output mismatch (see 244.out.bad)
--- 244.out	2011-06-10 17:25:22.000000000 -0700
+++ 244.out.bad	2011-06-14 14:05:36.000000000 -0700
@@ -1,2 +1,4 @@
 QA output created by 244
 Silence is golden
+FAIL: projid32bit enabled: setting over 32bit projid succeeded
+      while it should fail
Ran: 244
Failures: 244
Failed 1 of 1 tests
-----------------------

Thanks
chandra
On Tue, 2011-06-14 at 14:38 -0500, Eric Sandeen wrote:
> On 6/14/11 1:41 PM, Chandra Seetharaman wrote:
> > Hello,
> > 
> > test case 244 expects a mkfs option projid32bit, which is not present in
> > older version of mkfs.xfs(for example 3.1.1 in RHEL 6.1).
> > 
> > I though of making it a "requires" for this test, so that the test case
> > doesn't generate a "failure" when the test is run on older versions.
> > 
> > Opinions ?
> 
> Yes, that make sense; care to send a patch with proper signoff?
> 
> Thanks,
> -Eric
> 
> > regards
> > 
> > chandra
> > 
> > PS: here is the test o/p
> > 
> > FSTYP         -- xfs (non-debug)
> > PLATFORM      -- Linux/x86_64 elm3c201 2.6.39-rc4-xfs.git.p2+
> > MKFS_OPTIONS  -- -f -bsize=4096 /dev/sdd2
> > MOUNT_OPTIONS -- -o context=system_u:object_r:nfs_t:s0 /dev/sdd2 /mnt/xfsScratchMntPt
> > 
> > 244	 [failed, exit status 1] - output mismatch (see 244.out.bad)
> > --- 244.out	2011-04-20 08:34:36.000000000 -0700
> > +++ 244.out.bad	2011-06-14 11:29:57.000000000 -0700
> > @@ -1,2 +1,25 @@
> >  QA output created by 244
> > -Silence is golden
> > +unknown option -i projid32bit=0
> > +Usage: mkfs.xfs
> > +/* blocksize */		[-b log=n|size=num]
> > +/* data subvol */	[-d agcount=n,agsize=n,file,name=xxx,size=num,
> > +			    (sunit=value,swidth=value|su=num,sw=num),
> > +			    sectlog=n|sectsize=num
> > +/* inode size */	[-i log=n|perblock=n|size=num,maxpct=n,attr=0|1|2]
> > +/* log subvol */	[-l agnum=n,internal,size=num,logdev=xxx,version=n
> > +			    sunit=value|su=num,sectlog=n|sectsize=num,
> > +			    lazy-count=0|1]
> > +/* label */		[-L label (maximum 12 characters)]
> > +/* naming */		[-n log=n|size=num,version=2|ci]
> > +/* prototype file */	[-p fname]
> > +/* quiet */		[-q]
> > +/* realtime subvol */	[-r extsize=num,size=num,rtdev=xxx]
> > +/* sectorsize */	[-s log=n|size=num]
> > +/* version */		[-V]
> > +			devicename
> > +<devicename> is required unless -d name=xxx is given.
> > +<num> is xxx (bytes), xxxs (sectors), xxxb (fs blocks), xxxk (xxx KiB),
> > +      xxxm (xxx MiB), xxxg (xxx GiB), xxxt (xxx TiB) or xxxp (xxx PiB).
> > +<value> is xxx (512 byte blocks).
> > +mkfs failed
> > +(see 244.full for details)
> > Ran: 244
> > Failures: 244
> > Failed 1 of 1 tests
> > 
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> > 
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
