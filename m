Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2OMkbh3148905 for <xfs@oss.sgi.com>; Sat, 24 Mar 2012 17:46:38 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id nu9gW4aS63DnD5z2 for <xfs@oss.sgi.com>;
	Sat, 24 Mar 2012 15:46:35 -0700 (PDT)
Message-ID: <4F6E4ECA.3020502@sandeen.net>
Date: Sat, 24 Mar 2012 17:46:34 -0500
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
	<4F6E0D28.7000203@sandeen.net>
In-Reply-To: <4F6E0D28.7000203@sandeen.net>
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

On 3/24/12 1:06 PM, Eric Sandeen wrote:
> On 3/23/12 4:02 PM, Gabriel VLASIU wrote:
>> On Fri, 23 Mar 2012, Eric Sandeen wrote:
> 
>>> Sure, that'd be great.
>> OK.
> 
>>> If you want to supply an xfs_metadump metadata image (in public or in
>>> private), we would have a reproducer.  It obfuscates most metadata by
>>> default.
>> I will suppliy the metadata image as long it will remain private.
> 
>> Thank you for your support.
> 
> I got the image, and I can recreate the problem.

<snip>

> for numrecs = 6, the root size of 120 is correct.
> 
> So it seems that perhaps our attribute fork offset has been miscalculated somehow in the past.  This'll be a tough one to figure out.

Actually, scratch that idea.
 
> Any idea what's the oldest kernel this filesystem has been run under?  (or maybe more to the point, what kernel versions this particular file was created & modified under?)  There was an attribute fork offset calculation bug long ago, but it's long-since fixed....

What's interesting is that nothing actually looks corrupted (good news for you) ;)

xfs_db> 
xfs_db> inode 1074647780
xfs_db> p u.bmbt
u.bmbt.level = 1
u.bmbt.numrecs = 6
u.bmbt.keys[1-6] = [startoff] 1:[0] 2:[521297] 3:[586321] 4:[651345] 5:[716369] 6:[766033]
u.bmbt.ptrs[1-6] = 1:67984662 2:15986522 3:15921258 4:15856233 5:15789027 6:15719804
xfs_db> type text
xfs_db> p u.bmbt
00:  49 4e 81 80 02 03 00 00 00 00 03 e8 00 00 03 e8  IN..............	XFS_DINODE_MAGIC / ...
10:  00 00 00 01 00 00 00 00 00 00 00 00 00 00 02 ce  ................  ... xfs_dinode_t ...
20:  4f 6c 7c b9 23 bd 26 50 4f 6c 26 25 07 36 59 7d  Ol.....POl...6Y.
30:  4f 6c e8 b2 05 f8 e2 d6 00 00 00 01 3d 25 10 00  Ol.............. ... di_size ...
40:  00 00 00 00 00 13 d2 57 00 00 00 00 00 00 05 b7  .......W........
50:  00 00 0d 01 00 00 00 00 00 00 00 00 1a dc 3c d5  ................
60:  ff ff ff ff 00 01 00 06 00 00 00 00 00 00 00 00  ................ dinode_t | level 1, numrecs 6 / key 1
70:  00 00 00 00 00 07 f4 51 00 00 00 00 00 08 f2 51  .......Q.......Q key 2 / key 3
80:  00 00 00 00 00 09 f0 51 00 00 00 00 00 0a ee 51  .......Q.......Q key 4 / key 5
90:  00 00 00 00 00 0b b0 51 00 00 00 00 04 0d 5d 16  .......Q........ key 6 / ptr 1
a0:  00 00 00 00 00 f3 ef 5a 00 00 00 00 00 f2 f0 6a  .......Z.......j ptr 2 / ptr 3
b0:  00 00 00 00 00 f1 f2 69 00 00 00 00 00 f0 eb e3  .......i........ ptr 4 / ptr 5
c0:  00 00 00 00 00 ef dd 7c 00 00 00 00 00 33 01 00  .............3.. ptr 6 / ...
d0:  07 25 04 36 33 0c 69 6a 58 4e 00 00 00 00 00 00  ...63.ijXN......
e0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
f0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................

and the (obfuscated) text around offset 0xd0 (63.ijXN) is what's in the attribute:

xfs_db> p a.sfattr
a.sfattr.hdr.totsize = 51
a.sfattr.hdr.count = 1
a.sfattr.list[0].namelen = 7
a.sfattr.list[0].valuelen = 37
a.sfattr.list[0].root = 0
a.sfattr.list[0].secure = 1
a.sfattr.list[0].name = "63\fijXN"
a.sfattr.list[0].value = "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000"

But it's not overlapping the root node at all, despite the sizes calculated in xfs_dfrag.c thinking that it is.

Talking with Dave more, the way we are calculating the space for the root node (via XFS_BMAP_BROOT_SPACE_CALC) seems to be over-allocating - the value of 120 is bigger than what's actually on disk.  But that's not an on-disk value, just in memory.

So even though the offset to the attribute data within the inode is 104, and the in-memory if_broot_bytes says the root node is 120 bytes, the attr data is actually safely _past_ the root node data, which is really only about 100 bytes, not 120.

Short answer is, your file does NOT look corrupted, it's just that the checks in dfrag.c have noticed this obscure bug.

Long answer is, somebody(tm) will have to think a little more about how to fix the bug properly.

- -Eric
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.17 (Darwin)
Comment: GPGTools - http://gpgtools.org
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPbk7JAAoJECCuFpLhPd7gLWMP/1Iu8CNE1dVdmCZR+9DygDld
F2cgw9lfvril/96kzC4lnHPLTOvNVWwn6894VmFIzyVWdomKy+qq0may/rp6tgYn
YDLpLCKGZHo6OblKuvrmi6UkhioeshCSIoV/MwzSUyq+dHtJ4qg90lBsJJmmd8w0
Z9DReNrejl1SoyNSH98jmJm2/FTJdLWYX7Hej/gVRl70w+hxt36L19x4EzRPnZ0B
Sy0OdBkdNC//o5tzyiTsfQqmdXYAljUoGPptXK7UUEOvaQKqS1qwSynxucQLxznt
1vXIw8FlIp1c+c/sraADOXPSrK5y8bNvWlWgL3Iqb+ELxNtEYOtJW6fypS0oeuzS
j1MEDSRYWMPhJOemDAnu7XuVxMyeBHXJRKjD8ygHmY3BxXnTkweHKd+79EJE8LcN
ItUOSPCNIC8VFXiBIUUv9Zff3WMY+2UBsWkD67m0h243ZM1+YNf2tfbLoJ/n7s1y
w3El6mE97VmQxqBZCEKenxkVxqWyALKlDJFPcAIPdgamzej8za6Rs+Sf7zmoLdwN
C/+uOJf1JyzRNEkgINPBwfUTvq9l/noULPwHowoXy2GxDZnNgmCxp0fKd0acaRCs
w6W1avsPStZMozWnF9J+lMT2HVgVg5tQZLyGN2ai06QOS83/14usaHjJFxn5tNYw
lP87ln4RSilTfzocRMPf
=4g41
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
