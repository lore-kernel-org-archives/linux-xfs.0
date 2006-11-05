Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 04 Nov 2006 16:49:44 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kA50nfaG023799
	for <xfs@oss.sgi.com>; Sat, 4 Nov 2006 16:49:42 -0800
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by cuda.sgi.com (Spam Firewall) with SMTP id 7655A5075F7
	for <xfs@oss.sgi.com>; Sat,  4 Nov 2006 16:48:53 -0800 (PST)
From: peyytmek@gmx.de
Subject: Re: Xfs-mailinglist question  (xfs mounting problem, hdb1 just freezes)
Date: Sun, 5 Nov 2006 00:48:43 +0000
References: <200611012255.46008.peyytmek@gmx.de> <3B2B6490C980DD2C8B4C9645@timothy-shimmins-power-mac-g5.local> <200611040214.29997.peyytmek@gmx.de>
In-Reply-To: <200611040214.29997.peyytmek@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Disposition: inline
Message-Id: <200611050048.43868.peyytmek@gmx.de>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: xfs@oss.sgi.com

On Saturday 04 November 2006 02:14, you wrote:

Hi
Well. I kinda managed to recover my data
I used another computer for it and just plugged and xfs_repair /dev/hdb1
now it works just fine.
Althought I have no idea what caused all the freezing if i accessed /dev/hdb1 
on my server

Thanks for help. 

Bye
D.H.


> On Friday 03 November 2006 00:58, you wrote:
>
> Hello  again
> Thanks for your email
>
> First of all, everytime I do xfs_logprint /dev/hdb1, with -ti or -tibo
> or mounting the partition with a kernel pre May 26
> (kernel-2.16.3-gentoo-r3) or even xfs_repair -L /dev/hdb1 it's always the
> same. my terminal just freezes
>
> There is also nothing in /var/log/messages
>
> Well, I'm going to try my hdd in another computer with a different
> ide-controller. maybe that's the problem althought i doubt it would really
> work that way out.
>
> Bye,
> D.H.
>
> > Hi there,
> >
> > Sorry about not getting back to you.
> >
> > The inode details you sent me look reasonable to me (AFAICS).
> > However, the inode that we are processing which has problems
> > is probably coming from the log.
> > Basically, during log replay we reinstate metadata such as inodes,
> > inode buffers,
> > and later process an unlinked-list which this inode appears to be on.
> > It's during the truncating (as part of inactivating the inode) that we
> > have problems when looking at its extents.
> >
> > You should be able to see this inode in the log if you use:
> > # xfs_logprint -ti device
> > (or possibly I guess
> >  # xfs_logrpint -tibo device - if the inode is in a buffer of inodes)
> > I'd be curious to see this.
> >
> > My thoughts for a plan of action were either:
> > (1) forget the log and do an "xfs_repair -L" to zero it out and repair
> > or
> > (2) somehow try to do a mount which avoids the unlinked list processing
> > (an older kernel (pre May 26)  would do this because of a bug in
> > recovery); then unmount, then do a normal "xfs_repair"
> > or
> > (3) we try to stop this particular inode from being processed in the
> > unlinked-list inode processing during mount; unmount; repair and then
> > mount again
> >
> > The simplest is to do option (1). However, it means that any other
> > outstanding metadata changes would be lost.
> > Option (2) might be a goer but you need such a kernel and in that case it
> > won't do any unlinked processing for a group of such inodes (one's hashed
> > to that bucket in the AGI's). I'm unsure on how to stop this unlinked
> > processing otherwise.
> > Option (3) I'm unsure as how to do. Also, there could be more inodes in
> > the same boat which could cause recovery to crash.
> >
> > May be others have suggestions.
> >
> > Regards,
> > Tim.
> >
> > --On 1 November 2006 10:55:43 PM +0000 peyytmek@gmx.de wrote:
> > > Hello,
> > > Thanks for your last answer. Since you didn't answer my email for 2
> > > weeks i thought you might have deleted it accidently
> > >
> > > Here's the email conversation:
> > >> > Hello.
> > >> > Thanks for your answer.
> > >> >
> > >> > That's what i have: dmesg print with kernel-2.6.16-gentoo-r3 and an
> > >> > print of xfs_bg.
> > >> >
> > >> >> You could print out the offending inode with xfs_db to show us
> > >> >> what it looks like: $xfs_db -r /dev/hdb1 -c "inode 950759" -c
> > >> >> "print".
> > >> >
> > >> > I don't know what you mean with it but i added it anyway. (done with
> > >> > kernel-2.6.18-gentoo if it matters)
> > >> >
> > >> > xfs_db:
> > >> >
> > >> > CLX ~ # xfs_db -r /dev/hdb1 -c "inode 950759" -c "print"
> > >> > core.magic = 0x494e
> > >> > core.mode = 0100644
> > >> > core.version = 1
> > >> > core.format = 3 (btree)
> > >> > core.nlinkv1 = 0
> > >> > core.uid = 1000
> > >> > core.gid = 100
> > >> > core.flushiter = 0
> > >> > core.atime.sec = Sun Aug 27 14:56:52 2006
> > >> > core.atime.nsec = 657389250
> > >> > core.mtime.sec = Sun Aug 27 16:29:40 2006
> > >> > core.mtime.nsec = 080196250
> > >> > core.ctime.sec = Thu Oct  5 01:17:40 2006
> > >> > core.ctime.nsec = 976565958
> > >> > core.size = 32071862
> > >> > core.nblocks = 7833
> > >> > core.extsize = 0
> > >> > core.nextents = 28
> > >> > core.naextents = 0
> > >> > core.forkoff = 0
> > >> > core.aformat = 2 (extents)
> > >> > core.dmevmask = 0
> > >> > core.dmstate = 0
> > >> > core.newrtbm = 0
> > >> > core.prealloc = 0
> > >> > core.realtime = 0
> > >> > core.immutable = 0
> > >> > core.append = 0
> > >> > core.sync = 0
> > >> > core.noatime = 0
> > >> > core.nodump = 0
> > >> > core.rtinherit = 0
> > >> > core.projinherit = 0
> > >> > core.nosymlinks = 0
> > >> > core.extsz = 0
> > >> > core.extszinherit = 0
> > >> > core.gen = 0
> > >> > next_unlinked = null
> > >> > u.bmbt.level = 1
> > >> > u.bmbt.numrecs = 1
> > >> > u.bmbt.keys[1] = [startoff] 1:[0]
> > >> > u.bmbt.ptrs[1] = 1:185933
> > >>
> > >> And now:
> > >>
> > >> xfs_db -r /dev/hadb1 -c "fsb 185933" -c "type bmapbtd" -c "p"
> > >>
> > >> to look at the 28 extent records.
> > >>
> > >> --Tim
> > >
> > > Here's the content of my last Email
> > >
> > >
> > > Hello, thanks again for your fast answer
> > > Sorry for the double post last time.
> > > here it comes
> > >
> > >
> > > CLX ~ # xfs_db -r /dev/hdb1 -c "fsb 185933" -c "type bmapbtd" -c "p"
> > > magic = 0x424d4150
> > > level = 0
> > > numrecs = 27
> > > leftsib = null
> > > rightsib = null
> > > recs[1-27] = [startoff,startblock,blockcount,extentflag]
> > > 1:[0,185637,16,0] 2: [16,185537,8,0] 3:[24,185718,8,0]
> > > 4:[32,185706,8,0] 5:[40,185836,8,0] 6: [48,185848,16,0]
> > > 7:[64,185865,16,0]
> > > 8:[80,185882,8,0] 9:[96,185899,16,0] 10: [112,185916,16,0]
> > > 11:[340,185934,2,0] 12:[342,4768704,1320,0] 13: [1662,4770389,239,0]
> > > 14:[1901,4770919,264,0] 15:[2165,4771391,165,0] 16:
> > > [2330,4771860,227,0] 17:[2557,4861204,351,0] 18:[2908,4861800,257,0]
> > > 19: [3165,4862282,349,0] 20:[3514,4862934,230,0]
> > > 21:[3744,4863506,383,0] 22: [4127,4864141,348,0]
> > > 23:[4475,4864871,228,0] 24:[4703,4865358,268,0] 25:
> > > [4971,4865882,593,0] 26:[5564,4866818,339,0] 27:[5903,4867729,1928,0]
