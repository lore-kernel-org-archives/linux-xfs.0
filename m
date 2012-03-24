Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2OI6Z5i088035 for <xfs@oss.sgi.com>; Sat, 24 Mar 2012 13:06:35 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id ymNb6mHr5Lz7FQSP for <xfs@oss.sgi.com>;
	Sat, 24 Mar 2012 11:06:32 -0700 (PDT)
Message-ID: <4F6E0D28.7000203@sandeen.net>
Date: Sat, 24 Mar 2012 13:06:32 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_fsr XFS_IOC_SWAPEXT failed
References: <alpine.LRH.2.02.1203231552490.21859@mail.vlasiu.net>
	<4F6CD1DC.7010706@sandeen.net>
	<alpine.LRH.2.02.1203232159210.3056@mail.vlasiu.net>
	<4F6CD799.9090903@sandeen.net>
	<alpine.LRH.2.02.1203232220010.4760@mail.vlasiu.net>
	<4F6CE137.3020405@sandeen.net>
	<alpine.LRH.2.02.1203232259450.5980@mail.vlasiu.net>
In-Reply-To: <alpine.LRH.2.02.1203232259450.5980@mail.vlasiu.net>
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
To: Gabriel VLASIU <gabriel@vlasiu.net>
Cc: xfs@oss.sgi.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 3/23/12 4:02 PM, Gabriel VLASIU wrote:
> On Fri, 23 Mar 2012, Eric Sandeen wrote:
> 
>> Sure, that'd be great.
> OK.
> 
>> If you want to supply an xfs_metadump metadata image (in public or in
>> private), we would have a reproducer.  It obfuscates most metadata by
>> default.
> I will suppliy the metadata image as long it will remain private.
> 
> Thank you for your support.

I got the image, and I can recreate the problem.

and I also get:

           <...>-27689 [000] .... 1295775.018602: xfs_swap_extent_before: dev 7:0 ino 0x400dd2e4 (target), btree format, num_extents 1463, broot size 120, fork offset 104
           <...>-27689 [000] .... 1295775.018604: xfs_swap_extent_before: dev 7:0 ino 0x83 (temp), extent format, num_extents 1, broot size 0, fork offset 104

Dave pointed out on IRC that we shouldn't ever have a file with a broot size larger than the fork offset.

i.e. the attribute fork offset is 104, which is inside the root size of 120.  So we are hitting this check and failing, which results in the EINVAL:

        /* Reciprocal target->temp btree format checks */
        if (ip->i_d.di_format == XFS_DINODE_FMT_BTREE) {
                if (XFS_IFORK_BOFF(tip) &&
                    ip->i_df.if_broot_bytes > XFS_IFORK_BOFF(tip)) /* 120 > 104 */
                        return EINVAL;

but the original inode seems to be in a bad state.  It's a little odd that repair never checks for this; perhaps it should.

Here is the inode in question:

# xfs_db fsr-testcase.img 
xfs_db> inode 1074647780
xfs_db> p
core.magic = 0x494e
core.mode = 0100600
core.version = 2
core.format = 3 (btree)
core.nlinkv2 = 1
core.onlink = 0
core.projid = 0
core.uid = 1000
core.gid = 1000
core.flushiter = 718
core.atime.sec = Fri Mar 23 08:38:01 2012
core.atime.nsec = 599598672
core.mtime.sec = Fri Mar 23 02:28:37 2012
core.mtime.nsec = 121002365
core.ctime.sec = Fri Mar 23 16:18:42 2012
core.ctime.nsec = 100197078
core.size = 5320806400
core.nblocks = 1299031
core.extsize = 0
core.nextents = 1463
core.naextents = 0
core.forkoff = 13
core.aformat = 1 (local)
core.dmevmask = 0
core.dmstate = 0
core.newrtbm = 0
core.prealloc = 0
core.realtime = 0
core.immutable = 0
core.append = 0
core.sync = 0
core.noatime = 0
core.nodump = 0
core.rtinherit = 0
core.projinherit = 0
core.nosymlinks = 0
core.extsz = 0
core.extszinherit = 0
core.nodefrag = 0
core.filestream = 0
core.gen = 450641109
next_unlinked = null
u.bmbt.level = 1
u.bmbt.numrecs = 6
u.bmbt.keys[1-6] = [startoff] 1:[0] 2:[521297] 3:[586321] 4:[651345] 5:[716369] 6:[766033]
u.bmbt.ptrs[1-6] = 1:67984662 2:15986522 3:15921258 4:15856233 5:15789027 6:15719804
a.sfattr.hdr.totsize = 51
a.sfattr.hdr.count = 1
a.sfattr.list[0].namelen = 7
a.sfattr.list[0].valuelen = 37
a.sfattr.list[0].root = 0
a.sfattr.list[0].secure = 1
a.sfattr.list[0].name = "63\fijXN"
a.sfattr.list[0].value = "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000"
xfs_db> quit

for numrecs = 6, the root size of 120 is correct.

So it seems that perhaps our attribute fork offset has been miscalculated somehow in the past.  This'll be a tough one to figure out.

Any idea what's the oldest kernel this filesystem has been run under?  (or maybe more to the point, what kernel versions this particular file was created & modified under?)  There was an attribute fork offset calculation bug long ago, but it's long-since fixed....

Thanks,
- -Eric
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.17 (Darwin)
Comment: GPGTools - http://gpgtools.org
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPbg0mAAoJECCuFpLhPd7gUWIQAJybMa0IBt5i+jtbqE2GWJZr
iXe+FPp7h3OJBhlHLJAXcqWduh60EedwL3fCjki6VMFCBQ3ksxmvsfx9grxpgK80
He4wXR4JUA9Kpz/xNF/N7TXq0VgbdMME+CllKpqxeBX1TRehti8jvTXz3Mwzv5nJ
scWs4GsD/PIMQE1jGZZrLufPvXdIz3adaBzLN/mrr6rjJJNTJL5IgMb43udkjZ39
ktIhei3lRBTDQSHUOjv/BaLKq90O7gfoP0SUOKYC4sXZARqpj3qHaIkf62Z8Edaz
a9WbRJ+HkmnYPpBvRAJJbYn1tVpfICNyguKVq1VGmnce7Ybg9Y700sIVwY+wCo+g
vN76MJHX93xg105BPrMzhCViHQIMqtjCapG5npLlbG8Owm+9R6dA8Regrtzc8y6y
qRPGRW8OMAFQZ4ub/XWvIRZ9zpgvlUzjPCr2NRJ4uzJB6SrEo/I+pw4U+5T0dH/O
YhvaObApHVMWBh4mqyKERTSCm+vP0ynsT4hWFbbYlyII6mnn68zxme1eTv6X6BBs
jkrrSFp2GT2y38hGG/v3N80InMHzBnuI8Ow7eqRDxJzCaOKJ4h+7HBWxS1IUGFLK
OoMU9Vx5myQDi0aA9X3LxCxAqIBHKcsLZkNupSlZwZsgIPlF9SVLwRJF1wpWC84j
8McB7+zptvPqltSCON/K
=hnid
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
