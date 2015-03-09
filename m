Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8F9237F4E
	for <xfs@oss.sgi.com>; Mon,  9 Mar 2015 12:50:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 426BA304039
	for <xfs@oss.sgi.com>; Mon,  9 Mar 2015 10:50:38 -0700 (PDT)
Received: from mail.rvx.is (mail.rvx.is [178.19.51.189]) by cuda.sgi.com with
	ESMTP id rFRN6hz8RgFrHUKS (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 09 Mar 2015 10:50:35 -0700 (PDT)
Date: Mon, 9 Mar 2015 17:50:32 +0000 (GMT)
From: Rui Gomes <rgomes@rvx.is>
Message-ID: <514254492.412601.1425923432820.JavaMail.zimbra@rvx.is>
In-Reply-To: <54FDD995.5080307@sandeen.net>
References: <1145328183.409860.1425916240318.JavaMail.zimbra@rvx.is>
	<54FDC6FC.1070303@sandeen.net>
	<572429630.410924.1425918276266.JavaMail.zimbra@rvx.is>
	<54FDD995.5080307@sandeen.net>
Subject: Re: xfs_repair segfault
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: omar <omar@rvx.is>, xfs <xfs@oss.sgi.com>

Hi,

Yeah I feel the same way what could possible happen here, since no "funky" business happen in this server.

In case this help the underline hardware is:
Raid Controller: MegaRAID SAS 2108 [Liberator] (rev 05)
With 16 7.2k SAS 2TB harddrives in raid6

The output from the command:
[root@icess8a ~]# xfs_db -c "inode 260256256" -c "p" /dev/sdb1 
Metadata corruption detected at block 0x4ffed6d08/0x1000
xfs_db: cannot init perag data (117). Continuing anyway.
core.magic = 0x494e
core.mode = 040755
core.version = 2
core.format = 1 (local)
core.nlinkv2 = 2
core.onlink = 0
core.projid_lo = 0
core.projid_hi = 0
core.uid = 0
core.gid = 0
core.flushiter = 0
core.atime.sec = Fri May 16 10:52:31 2014
core.atime.nsec = 051443134
core.mtime.sec = Thu Aug 25 11:05:18 2011
core.mtime.nsec = 000000000
core.ctime.sec = Wed Feb 26 04:39:42 2014
core.ctime.nsec = 964671556
core.size = 47
core.nblocks = 7
core.extsize = 0
core.nextents = 1
core.naextents = 0
core.forkoff = 0
core.aformat = 2 (extents)
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
core.gen = 270972429
next_unlinked = null
u.sfdir2.hdr.count = 2
u.sfdir2.hdr.i8count = 1
u.sfdir2.hdr.parent.i8 = 51672582160
u.sfdir2.list[0].namelen = 24
u.sfdir2.list[0].offset = 0x63d
u.sfdir2.list[0].name = "kchnfig\000\000\000\000\017\2032\030\b\000\210Makefi"
u.sfdir2.list[0].inumber.i8 = 7810649128743997315
u.sfdir2.list[1].namelen = 50
u.sfdir2.list[1].offset = 0x1900
u.sfdir2.list[1].name = "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000"
u.sfdir2.list[1].inumber.i8 = 0


Regards 

------------------------------- 
Rui Gomes 
CTO 


RVX - Reykjavik Visual Effects 
Seljavegur 2, 
101 Reykjavik 
Iceland 


Tel: + 354 527 3330 
Mob: + 354 663 3360

----- Original Message -----
From: "Eric Sandeen" <sandeen@sandeen.net>
To: "Rui Gomes" <rgomes@rvx.is>
Cc: "xfs" <xfs@oss.sgi.com>, "omar" <omar@rvx.is>
Sent: Monday, 9 March, 2015 17:34:13
Subject: Re: xfs_repair segfault

On 3/9/15 12:24 PM, Rui Gomes wrote:
> Hello Eric, 
> 
> I would love to send you the xfs metadump but it segfaults as well.

woohoo!  \o/

> This is the output of xfs_repair truncated:
> 
...

> no . entry for directory 260215042
> no .. entry for directory 260215042
> problem with directory contents in inode 260215042
> would have cleared inode 260215042
> bad nblocks 7 for inode 260256256, would reset to 0
> bad nextents 1 for inode 260256256, would reset to 0
> entry "                 kchnfig" in shortform directory 260256256 references invalid inode 28428972647780227
> entry contains illegal character in shortform dir 260256256
> would have junked entry "kchnfig" in directory inode 260256256
> entry "                                                  " in shortform directory 260256256 references invalid inode 0
> size of last entry overflows space left in in shortform dir 260256256, would reset to -1
> *** buffer overflow detected ***: /usr/sbin/xfs_repair terminated

Ok, looking at the sheer number of errors, I really wonder what happened to the fs.

You''d do well to be 100% sure that storage is OK, and that you're not trying to
repair a filesytem on scrambled disks but in any case, xfs should not segfault.

But anyway, this:

> size of last entry overflows space left in in shortform dir 260256256, would reset to -1

is a good clue; it must be in here:

                        if (i == num_entries - 1)  {
                                namelen = ino_dir_size -
                                        ((__psint_t) &sfep->name[0] -
                                         (__psint_t) sfp);
                                do_warn(
_("size of last entry overflows space left in in shortform dir %" PRIu64 ", "),
                                        ino);
                                if (!no_modify)  {
                                        do_warn(_("resetting to %d\n"),
                                                namelen);
                                        sfep->namelen = namelen;
                                        *dino_dirty = 1;

which means the -1 namelen memmove choked on came from:

ino_dir_size - ((__psint_t) &sfep->name[0] - (__psint_t) sfp);

and those come from:

sfp = (struct xfs_dir2_sf_hdr *)XFS_DFORK_DPTR(dip) = ((char *)dip + xfs_dinode_size(dip->di_version))
ino_dir_size = be64_to_cpu(dip->di_size);
sfep = ... xfs_dir2_sf_firstentry(sfp);

We could just be defensive against a negative namelen, but maybe we should
understand a bit more clearly how we got here.

Might start by trying:

# xfs_db -c "inode 260256256" -c "p" /dev/whatever

and show us what you get.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
