Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4IGtQ0X062954 for <xfs@oss.sgi.com>; Tue, 18 May 2010 11:55:26 -0500
Received: from a.mx.filmlight.ltd.uk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id ECDE43565C1
	for <xfs@oss.sgi.com>; Tue, 18 May 2010 09:57:40 -0700 (PDT)
Received: from a.mx.filmlight.ltd.uk (alto.filmlight.ltd.uk [77.107.81.250])
	by cuda.sgi.com with SMTP id 1Wd1rOP4oiiZz57A for
	<xfs@oss.sgi.com>; Tue, 18 May 2010 09:57:40 -0700 (PDT)
Subject: Re: mounting hixfs (Hitachi "tuned" XFS) on 2.6 kernel
From: Roger Willcocks <roger@filmlight.ltd.uk>
In-Reply-To: <AANLkTim17eZcbW3gCOdziY3-Vsyd-XjBkmWV875yOWIC@mail.gmail.com>
References: <AANLkTikek9K8-BqNgee_tXz72beHpWEUl41YtDPrD-3P@mail.gmail.com>
	<4BF1EC44.7070803@hardwarefreak.com>
	<AANLkTin_WoxWP3JXHvflVVP_2fGzgbSVfpPW1KGiyd1z@mail.gmail.com>
	<4BF219A6.4010900@hardwarefreak.com>
	<AANLkTim93-4YueMBizXKLGRFka2vwqzJzDx5_P5gs0bl@mail.gmail.com>
	<AANLkTim17eZcbW3gCOdziY3-Vsyd-XjBkmWV875yOWIC@mail.gmail.com>
Date: Tue, 18 May 2010 17:57:37 +0100
Message-Id: <1274201857.17233.144.camel@montana.filmlight.ltd.uk>
Mime-Version: 1.0
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
To: Benjamin Lau <benjamin.a.lau@gmail.com>
Cc: xfs@oss.sgi.com

The '-' character in the url in the pdf is a literal:

http://www.hitachi.co.jp/products/it/storage-solutions/techsupport/download/index.html

the page points to:

http://www2.hitachi.co.jp/products/it/rsd/download/kernel-src-05-00-02.tgz



On Tue, 2010-05-18 at 09:44 -0700, Benjamin Lau wrote:
> I think this is the document you might be looking for:
> http://www.hds.com/assets/pdf/open-source-licenses-applicable-to-hds-products.pdf
> 
> This outlines all of the licenses for the various bits of Hitachi Data
> Systems for the FOSS components.
> 
> V. NAS File Sharing
> Contact information:
> Project Manager
> NAS File Sharing
> Hitachi Data Systems
> 750 Central Expressway
> Santa Clara, California 95050
> 
> Please note that the source code for the NAS File Sharing kernel is
> available for
> download at: http://www.hitachi.co.jp/products/it/storagesolutions/
> techsupport/download/index.html. Other GPL source code in the NAS File
> Sharing product is available by request.
> 
> Unfortunately that link seems to give back a 404 (I understand a
> smidgen of Japanese. So you may have no choice but to contact them in
> a more direct manner.  But it looks like they had the code posted
> someplace at some point in the past.
> 
> Hope that helps,
> 
> Ben
> 
> On Tue, May 18, 2010 at 8:19 AM, big beer <bigbeerjr@gmail.com> wrote:
> > On Mon, May 17, 2010 at 9:37 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> >> big beer put forth on 5/17/2010 10:34 PM:
> >>>> On Mon, May 17, 2010 at 6:24 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> >>>> big beer put forth on 5/17/2010 7:08 PM:
> >>>>
> >>>>> If anyone has any ideas on what to do, and/or where to start, I'd
> >>>>> greatly appreciate it.
> >>>>
> >>>> Why are you avoiding the obvious solution in favor of hacking?
> >>>>
> >>> Sending back to the list this time instead of Stan directly (Sorry Stan) :)
> >>
> >> No problem.  I love my Tbird "reply-to-list" option. :)
> >>
> >>> The obvious solution for me would be a backup or rsync. Unfortunately
> >>> both of those have issues with this particular setup.
> >>>
> >>> Using a backup over the network to migrate will be way too slow
> >>> (days). There are way too many files to index and this poor little nas
> >>> box is already falling over with cpu load from daily activities. I can
> >>> quickly make a mirror on the storage, and move it over to another
> >>> larger host quickly (minutes). Mounting the FS on another machine will
> >>> greatly improve the time and accuracy, as I won't have to worry about
> >>> inconsistencies as it's a block level copy.
> >>
> >>> The black-box solution is also very painful to work with, no gcc, no
> >>> automake, no rsync, etc.
> >>> I would also think that for some reason I can't think of, it would be
> >>> nice to have support for this version of XFS be available for free for
> >>> others. Some other poor sap might find some value.
> >>>
> >>> So I went and changed the magic number to 0x58465342 by dumping the
> >>> 1st 512 bytes off the volume, editing, and writing back, now I'm
> >>> getting "Can't verify primary superblock". Using xfs_db to look at the
> >>> other superblocks indeed still shows HXFS. Any advise how I can
> >>> find/dump/re-write one of the other superblocks? I'd like to see if I
> >>> can change another one of them if xfs_repair will run.
> >>
> >> Seems to me you're taking some big chances with live data.  One wrong turn
> >> and you could hose the FS and lose all the data, yes?  I'd rather give you
> >> recommendations not related to this current path you're taking.  Would you
> >> please provide the model or part number of this Hitachi NAS so I can get an
> >> idea of what exactly it is you're dealing with, and possibly offer other
> >> solutions?
> >>
> >> Maybe someone else here can help you pull this off via XFS.  I can't.  But
> >> I'll gladly spend some time researching other possible solutions, mainly
> >> getting a high capacity drive connected so you can do a cp -a or tar and be
> >> done with this overnight, in a data-safe manner.
> >>
> >> --
> >> Stan
> >>
> >> _______________________________________________
> >> xfs mailing list
> >> xfs@oss.sgi.com
> >> http://oss.sgi.com/mailman/listinfo/xfs
> >>
> >
> >
> > It's called a eNAS, but it's really just 2 linux 2.4 blades (debian
> > woody), with failsafe (think heartbeat), LVM, custom XFS, samba, nfs,
> > and a pile of sudo available scripts that are 700 and a web based gui
> > to manage it.
> >
> > I though about moving it via another FS on the NAS and then connecting
> > it to my target migration host also. The only exposed connections on
> > the hardware are ethernet, and it's integrated in the storage
> > subsystem. I'd have to call a tech  to even come take it out. So I'm
> > limited to something that is fiber attached to the sub-system, ok
> > that's fine, just means no USB disk or the like. The real problem is
> > that since I don't have root there is no way to create or mount any
> > other devices that contain another FS. The restrictive GUI/scripts
> > automatically creates and mounts FS's with their modified XFS version,
> > and there are no options to do otherwise.
> >
> > I'm playing it "safe" by taking a block level copy of the luns that
> > are exposed to this thing, and then presenting the copy over to my
> > target host. I'm not brave enough to totally trash live data. I'm
> > going to give some of the suggestions a go with a fresh copy of the
> > data and see what comes of it.
> >
> > Of course the 1st thing I did was call Hitachi support and ask them
> > what the deal is, dropping words like "GPL" and "license bound to
> > distribute", but to no avail. Of course I'm dealing with low level
> > support people that more than likely didn't work for the big H when
> > this thing was built. I've escalated through the channels I have
> > available to me.
> >
> > We'll see what comes of it.
> >
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> >
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
-- 
Roger Willcocks <roger@filmlight.ltd.uk>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
