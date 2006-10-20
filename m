Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 20 Oct 2006 05:44:31 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9KCiNaG024356
	for <xfs@oss.sgi.com>; Fri, 20 Oct 2006 05:44:25 -0700
Received: from mail.gmx.net (mail.gmx.de [213.165.64.20])
	by cuda.sgi.com (Spam Firewall) with SMTP id 06E824B7A2A
	for <xfs@oss.sgi.com>; Fri, 20 Oct 2006 05:43:38 -0700 (PDT)
From: peyytmek@gmx.de
Subject: Re: Fwd: Re: xfs mounting problem, hdb1 just freezes
Date: Fri, 20 Oct 2006 14:40:52 +0000
References: <200610191436.13773.peyytmek@gmx.de> <93BCAC8A8F8B13AB0095C1B8@timothy-shimmins-power-mac-g5.local>
In-Reply-To: <93BCAC8A8F8B13AB0095C1B8@timothy-shimmins-power-mac-g5.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Message-Id: <200610201440.52934.peyytmek@gmx.de>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: xfs@oss.sgi.com

On Friday 20 October 2006 04:06, Timothy Shimmin wrote:
> > Hello.
> > Thanks for your answer.
> >
> > That's what i have: dmesg print with kernel-2.6.16-gentoo-r3 and an print
> > of xfs_bg.
> >
> >> You could print out the offending inode with xfs_db to show us
> >> what it looks like: $xfs_db -r /dev/hdb1 -c "inode 950759" -c "print".
> >
> > I don't know what you mean with it but i added it anyway. (done with
> > kernel-2.6.18-gentoo if it matters)
> >
> > xfs_db:
> >
> > CLX ~ # xfs_db -r /dev/hdb1 -c "inode 950759" -c "print"
> > core.magic = 0x494e
> > core.mode = 0100644
> > core.version = 1
> > core.format = 3 (btree)
> > core.nlinkv1 = 0
> > core.uid = 1000
> > core.gid = 100
> > core.flushiter = 0
> > core.atime.sec = Sun Aug 27 14:56:52 2006
> > core.atime.nsec = 657389250
> > core.mtime.sec = Sun Aug 27 16:29:40 2006
> > core.mtime.nsec = 080196250
> > core.ctime.sec = Thu Oct  5 01:17:40 2006
> > core.ctime.nsec = 976565958
> > core.size = 32071862
> > core.nblocks = 7833
> > core.extsize = 0
> > core.nextents = 28
> > core.naextents = 0
> > core.forkoff = 0
> > core.aformat = 2 (extents)
> > core.dmevmask = 0
> > core.dmstate = 0
> > core.newrtbm = 0
> > core.prealloc = 0
> > core.realtime = 0
> > core.immutable = 0
> > core.append = 0
> > core.sync = 0
> > core.noatime = 0
> > core.nodump = 0
> > core.rtinherit = 0
> > core.projinherit = 0
> > core.nosymlinks = 0
> > core.extsz = 0
> > core.extszinherit = 0
> > core.gen = 0
> > next_unlinked = null
> > u.bmbt.level = 1
> > u.bmbt.numrecs = 1
> > u.bmbt.keys[1] = [startoff] 1:[0]
> > u.bmbt.ptrs[1] = 1:185933
>
> And now:
>
> xfs_db -r /dev/hadb1 -c "fsb 185933" -c "type bmapbtd" -c "p"
>
> to look at the 28 extent records.
>
> --Tim


Hello, thanks again for your fast answer
Sorry for the double post last time.
here it comes


CLX ~ # xfs_db -r /dev/hdb1 -c "fsb 185933" -c "type bmapbtd" -c "p"
magic = 0x424d4150
level = 0
numrecs = 27
leftsib = null
rightsib = null
recs[1-27] = [startoff,startblock,blockcount,extentflag] 1:[0,185637,16,0] 2:
[16,185537,8,0] 3:[24,185718,8,0] 4:[32,185706,8,0] 5:[40,185836,8,0] 6:
[48,185848,16,0] 7:[64,185865,16,0] 8:[80,185882,8,0] 9:[96,185899,16,0] 10:
[112,185916,16,0] 11:[340,185934,2,0] 12:[342,4768704,1320,0] 13:
[1662,4770389,239,0] 14:[1901,4770919,264,0] 15:[2165,4771391,165,0] 16:
[2330,4771860,227,0] 17:[2557,4861204,351,0] 18:[2908,4861800,257,0] 19:
[3165,4862282,349,0] 20:[3514,4862934,230,0] 21:[3744,4863506,383,0] 22:
[4127,4864141,348,0] 23:[4475,4864871,228,0] 24:[4703,4865358,268,0] 25:
[4971,4865882,593,0] 26:[5564,4866818,339,0] 27:[5903,4867729,1928,0]
