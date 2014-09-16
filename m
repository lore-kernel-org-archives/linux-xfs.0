Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A31377F4E
	for <xfs@oss.sgi.com>; Tue, 16 Sep 2014 17:10:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 61D6D8F8054
	for <xfs@oss.sgi.com>; Tue, 16 Sep 2014 15:10:22 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	SbT3fXMkcEK9JFDD for <xfs@oss.sgi.com>;
	Tue, 16 Sep 2014 15:10:19 -0700 (PDT)
Date: Wed, 17 Sep 2014 08:10:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: unclean shutdown of usb hdd destroyed xfs partially
Message-ID: <20140916221005.GN4322@dastard>
References: <3999c95c0dc7ebfdfbb2853a6d13f7dc@zbfmail.de>
	<082ebd288523ee6155b66debade2a775@zbfmail.de>
	<20140913220916.GC4267@dastard>
	<330c89398cb4eef9b7289c1ffef8bcc3@zbfmail.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <330c89398cb4eef9b7289c1ffef8bcc3@zbfmail.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: weber@zbfmail.de
Cc: Xfs <xfs@oss.sgi.com>

On Tue, Sep 16, 2014 at 11:27:45PM +0200, Marko Weber|8000 wrote:
> =

> =

> Am 2014-09-14 00:09, schrieb Dave Chinner:
> >On Sat, Sep 13, 2014 at 04:36:59PM +0200, Marko Weber|8000 wrote:
> >>
> >>an output of  xfs_repair -v -L /dev/sde1
> >...
> >>
> >> # xfs_repair -v -L /dev/sde1
> >
> >What version?
> =

> first it was 3.1.10
> later like posted 3.2.1
> =

> >
> >>Phase 1 - Superblock finden und =FCberpr=FCfen...
> >>        - Berichts-Prozess in Abst=E4nden von 15 Minutes
> >>        - Block-Zwischenspeichergr=F6=DFe ist auf 1487792 Eintr=E4ge ge=
setzt
> >>Phase 2 - ein internes Protokoll benutzen
> >>        - Null-Protokoll...
> >>zero_log: head block 40 tail block 40
> >>        - freier Speicher und Inode-Karten des Dateisystems werden
> >>gescannt...
> >>bad magic numberbad magic numberbad magic number
> >....
> >>falscher on-disk-Superblock 12 - falsche Magische Nummer
> >>Metadata corruption detected at block
> >>0x20bf8e50/0x1000prim=E4re/sekund=E4rer Superblock-12-Konflikt -
> >>AG-Superblock-Geometrie-Info hat einen Konflikt mit der
> >>Dateisystem-Geometrie
> >>flasche magische # 0x0 f=FCr agf 12
> >>falsche Version # 0 f=FCr agf 12
> >>
> >>Metadata corruption detected at block 0x417f1c90/0x1000
> >>falscher on-disk-Superblock 6 - falsche Magische Nummer
> >>prim=E4re/sekund=E4rer Superblock-6-Konflikt -
> >>AG-Superblock-Geometrie-Info hat einen Konflikt mit der
> >>Dateisystem-Geometrie
> >>falscher on-disk-Superblock 3 - falsche Magische Nummer
> >>ungenutzten Anteil des =BBsekund=E4r=AB-Superblocks nullen (AG #6)
> >>Metadata corruption detected at block 0x57542610/0x1000
> >>falsche Sequenz # 0 f=FCr agf 12
> >>Metadata corruption detected at block
> >>0x7813b450/0x1000Speicherzugriffsfehler
> >
> >I don't read german(?) but that looks like many AG header block
> >have been overwritten with zeros (0 magic number, 0 sequence #, 0
> >length, etc) and so even if we can repair the filesystem, I'd
> >suggest that you need to verify that the data in every file in the
> >filesystem is correct.
> >
> >Is that as far as xfs_repair got? If so, it would have appeared to
> >crash.  Can you run the lastest version inside gdb to get a stack
> >trace when it dies? Or, alternatively, provide a metadump for one of
> >us to look at more closely?
> =

> yes, this is as far xfs_repair got it.
> what is ment 'run latest version in gdb?' gnudebugger? how do i do
> that? console example needed.
> and how do i do the metadump?

# gdb /path/to/build/area/repair/xfs_repair
....
(gdb) run <command line options for repair>
.....
<crashes>
(gdb) bt
<stack trace output emitted>

Paste the entire output of the gdb session. Best if you can run it
with your language settings to output english error messages, too
(LANG=3DC, I think).

As for running metadump: 'man xfs_metadump', compress the resultant
image and send me a link to where I can download it from.

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
