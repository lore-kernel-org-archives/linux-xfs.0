Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Oct 2006 21:07:21 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k9K475aG031669
	for <xfs@oss.sgi.com>; Thu, 19 Oct 2006 21:07:07 -0700
Date: Fri, 20 Oct 2006 14:06:29 +1000
From: Timothy Shimmin <tes@sgi.com>
Subject: Re: Fwd: Re: xfs mounting problem, hdb1 just freezes
Message-ID: <93BCAC8A8F8B13AB0095C1B8@timothy-shimmins-power-mac-g5.local>
In-Reply-To: <200610191436.13773.peyytmek@gmx.de>
References: <200610191436.13773.peyytmek@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: peyytmek@gmx.de, xfs@oss.sgi.com



--On 19 October 2006 2:36:13 PM +0000 peyytmek@gmx.de wrote:

> Hello.
> Thanks for your answer.
>
> That's what i have: dmesg print with kernel-2.6.16-gentoo-r3 and an print of
> xfs_bg.
>
>> You could print out the offending inode with xfs_db to show us
>> what it looks like: $xfs_db -r /dev/hdb1 -c "inode 950759" -c "print".
>
> I don't know what you mean with it but i added it anyway. (done with
> kernel-2.6.18-gentoo if it matters)
>
> xfs_db:
>
> CLX ~ # xfs_db -r /dev/hdb1 -c "inode 950759" -c "print"
> core.magic = 0x494e
> core.mode = 0100644
> core.version = 1
> core.format = 3 (btree)
> core.nlinkv1 = 0
> core.uid = 1000
> core.gid = 100
> core.flushiter = 0
> core.atime.sec = Sun Aug 27 14:56:52 2006
> core.atime.nsec = 657389250
> core.mtime.sec = Sun Aug 27 16:29:40 2006
> core.mtime.nsec = 080196250
> core.ctime.sec = Thu Oct  5 01:17:40 2006
> core.ctime.nsec = 976565958
> core.size = 32071862
> core.nblocks = 7833
> core.extsize = 0
> core.nextents = 28
> core.naextents = 0
> core.forkoff = 0
> core.aformat = 2 (extents)
> core.dmevmask = 0
> core.dmstate = 0
> core.newrtbm = 0
> core.prealloc = 0
> core.realtime = 0
> core.immutable = 0
> core.append = 0
> core.sync = 0
> core.noatime = 0
> core.nodump = 0
> core.rtinherit = 0
> core.projinherit = 0
> core.nosymlinks = 0
> core.extsz = 0
> core.extszinherit = 0
> core.gen = 0
> next_unlinked = null
> u.bmbt.level = 1
> u.bmbt.numrecs = 1
> u.bmbt.keys[1] = [startoff] 1:[0]
> u.bmbt.ptrs[1] = 1:185933
>

And now:

xfs_db -r /dev/hadb1 -c "fsb 185933" -c "type bmapbtd" -c "p"

to look at the 28 extent records.

--Tim
