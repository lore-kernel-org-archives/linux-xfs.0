Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q13L1LOE160207 for <xfs@oss.sgi.com>; Fri, 3 Feb 2012 15:01:21 -0600
Received: from smtp.pobox.com (b-pb-sasl-quonix.pobox.com [208.72.237.35]) by
	cuda.sgi.com with ESMTP id IzTjCnr06MBwnYCE for
	<xfs@oss.sgi.com>; Fri, 03 Feb 2012 13:01:19 -0800 (PST)
Date: Fri, 3 Feb 2012 21:01:14 +0000
From: Brian Candler <B.Candler@pobox.com>
Subject: Re: Performance problem - reads slower than writes
Message-ID: <20120203210114.GD2479@nsrc.org>
References: <20120130220019.GA45782@nsrc.org> <20120131020508.GF9090@dastard>
	<20120131103126.GA46170@nsrc.org> <20120131141604.GB46571@nsrc.org>
	<20120131202526.GJ9090@dastard> <20120203184723.GA2261@nsrc.org>
	<20120203190304.GA11809@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120203190304.GA11809@infradead.org>
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

On Fri, Feb 03, 2012 at 02:03:04PM -0500, Christoph Hellwig wrote:
> > With defaults, the files in one directory are spread all over the
> > filesystem.  But with -i size=1024, the files in a directory are stored
> > adjacent to each other. Hence reading all the files in one directory
> > requires far less seeking across the disk, and runs about 3 times faster.
> 
> Not sure if you mentioned it somewhere before, but:
> 
>  a) how large is the filesystem?

3TB.

>  b) do use the inode64 mount option

No: the only mount options I've given are noatime,nodiratime.

>  c) can you see the same good behaviour when using inode64 and small
>     inodes (not that inode64 can NOT be set using remount)

I created a fresh filesystem (/dev/sdh), default parameters, but mounted it
with inode64.  Then I tar'd across my corpus of 100K files.  Result: files
are located close to the directories they belong to, and read performance
zooms.

So I conclude that XFS *does* try to keep file extents close to the
enclosing directory, but was being thwarted by the limitations of 32-bit
inodes.

There is a comment "performance sucks" at:
http://xfs.org/index.php/XFS_FAQ#Q:_What_is_the_inode64_mount_option_for.3F

However, there it talks about files [extents?] being located close to their
inodes, rather than file extents being located close to their parent
directory.

Regards,

Brian.


root@storage1:~# find /data/sdh | head -50 | xargs xfs_bmap 
/data/sdh: no extents
/data/sdh/Bonnie.26384: no extents
/data/sdh/Bonnie.26384/00000:
	0: [0..7]: 1465133488..1465133495
/data/sdh/Bonnie.26384/00000/0icoeTRPHKX0000000000:
	0: [0..1015]: 1465134032..1465135047
/data/sdh/Bonnie.26384/00000/Q0000000001:
	0: [0..1543]: 1465135048..1465136591
/data/sdh/Bonnie.26384/00000/JFXQyeq6diG0000000002:
	0: [0..1295]: 1465136592..1465137887
/data/sdh/Bonnie.26384/00000/TK7ciXkkj0000000003:
	0: [0..1519]: 1465137888..1465139407
/data/sdh/Bonnie.26384/00000/0000000004:
	0: [0..1207]: 1465139408..1465140615
/data/sdh/Bonnie.26384/00000/acJKZWAwEnu0000000005:
	0: [0..1223]: 1465140616..1465141839
/data/sdh/Bonnie.26384/00000/9wIgxPKeI4B0000000006:
	0: [0..1319]: 1465141840..1465143159
/data/sdh/Bonnie.26384/00000/C6QLFdND0000000007:
	0: [0..1111]: 1465143160..1465144271
/data/sdh/Bonnie.26384/00000/6xc1Wydh0000000008:
	0: [0..1223]: 1465144272..1465145495
/data/sdh/Bonnie.26384/00000/0000000009:
	0: [0..1167]: 1465145496..1465146663
/data/sdh/Bonnie.26384/00000/HdlN0000000000a:
	0: [0..1535]: 1465146664..1465148199
/data/sdh/Bonnie.26384/00000/52IabyC5pvis000000000b:
	0: [0..1287]: 1465148200..1465149487
/data/sdh/Bonnie.26384/00000/LvDhxcdLf000000000c:
	0: [0..1583]: 1465149488..1465151071
/data/sdh/Bonnie.26384/00000/08P3JAR000000000d:
	0: [0..1255]: 1465151072..1465152327
/data/sdh/Bonnie.26384/00000/000000000e:
	0: [0..1095]: 1465152328..1465153423
/data/sdh/Bonnie.26384/00000/s0gtPGPecXu000000000f:
	0: [0..1319]: 1465153424..1465154743
/data/sdh/Bonnie.26384/00000/HFLOcN0000000010:
	0: [0..1503]: 1465154744..1465156247
/data/sdh/Bonnie.26384/00000/LQZly0000000011:
	0: [0..1591]: 1465156248..1465157839
/data/sdh/Bonnie.26384/00000/Cgx2O3Km9db0000000012:
	0: [0..1463]: 1465157840..1465159303
/data/sdh/Bonnie.26384/00000/QdqMvy30000000013:
	0: [0..1063]: 1465159304..1465160367
/data/sdh/Bonnie.26384/00000/kraVgKMdTiS60000000014:
	0: [0..1263]: 1465160368..1465161631
/data/sdh/Bonnie.26384/00000/qYaHGnrJm30000000015:
	0: [0..1575]: 1465161760..1465163335
/data/sdh/Bonnie.26384/00000/oJu9fLAncA0000000016:
	0: [0..1023]: 1465163336..1465164359
/data/sdh/Bonnie.26384/00000/gsTjmbcIoq0000000017:
	0: [0..1535]: 1465164360..1465165895
/data/sdh/Bonnie.26384/00000/0000000018:
	0: [0..1271]: 1465165896..1465167167
/data/sdh/Bonnie.26384/00000/Xu0000000019:
	0: [0..1199]: 1465167168..1465168367
/data/sdh/Bonnie.26384/00000/mbAF9Ow000000001a:
	0: [0..1479]: 1465168368..1465169847
/data/sdh/Bonnie.26384/00000/x2CVDC4MIM000000001b:
	0: [0..1319]: 1465169848..1465171167
/data/sdh/Bonnie.26384/00000/SYFSGTgs000000001c:
	0: [0..1239]: 1465171168..1465172407
/data/sdh/Bonnie.26384/00000/dA3oCdRjRmbm000000001d:
	0: [0..1551]: 1465172408..1465173959
/data/sdh/Bonnie.26384/00000/B000000001e:
	0: [0..1319]: 1465173960..1465175279
/data/sdh/Bonnie.26384/00000/p000000001f:
	0: [0..1559]: 1465175280..1465176839
/data/sdh/Bonnie.26384/00000/CaUyF0000000020:
	0: [0..1199]: 1465176840..1465178039
/data/sdh/Bonnie.26384/00000/xsCb0000000021:
	0: [0..1319]: 1465178040..1465179359
/data/sdh/Bonnie.26384/00000/IupKUGW4JNE80000000022:
	0: [0..1471]: 1465179360..1465180831
/data/sdh/Bonnie.26384/00000/DKBmSRy2Rt0000000023:
	0: [0..1399]: 1465180832..1465182231
/data/sdh/Bonnie.26384/00000/4dmLGnWw50000000024:
	0: [0..1247]: 1465182232..1465183479
/data/sdh/Bonnie.26384/00000/0000000025:
	0: [0..1495]: 1465183480..1465184975
/data/sdh/Bonnie.26384/00000/yPcS6O0000000026:
	0: [0..1223]: 1465184976..1465186199
/data/sdh/Bonnie.26384/00000/eNhPxu0000000027:
	0: [0..1471]: 1465186200..1465187671
/data/sdh/Bonnie.26384/00000/oGidZ0000000028:
	0: [0..1063]: 1465187672..1465188735
/data/sdh/Bonnie.26384/00000/5blq0000000029:
	0: [0..1151]: 1465188736..1465189887
/data/sdh/Bonnie.26384/00000/wlbSsioikgEY000000002a:
	0: [0..1159]: 1465189888..1465191047
/data/sdh/Bonnie.26384/00000/HKG6hYj000000002b:
	0: [0..1039]: 1465191048..1465192087
/data/sdh/Bonnie.26384/00000/FruCoPDzes000000002c:
	0: [0..1407]: 1465192088..1465193495
/data/sdh/Bonnie.26384/00000/puA70OD8U000000002d:
	0: [0..1247]: 1465193496..1465194743
/data/sdh/Bonnie.26384/00000/53Vpi1ueADH000000002e:
	0: [0..1063]: 1465194744..1465195807

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
