Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n14CNOMJ151233 for <xfs@oss.sgi.com>; Wed, 4 Feb 2009 06:23:24 -0600
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 628B81BB51F9
	for <xfs@oss.sgi.com>; Wed,  4 Feb 2009 04:22:44 -0800 (PST)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net
	[203.16.214.146]) by cuda.sgi.com with ESMTP id
	GcfPnUZVxOKONv4i for <xfs@oss.sgi.com>;
	Wed, 04 Feb 2009 04:22:44 -0800 (PST)
Date: Wed, 4 Feb 2009 23:22:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_force_shutdown after Raid crash
Message-ID: <20090204122241.GL24173@disturbed>
References: <498376CF.8020806@renderforce.de> <200902031140.08576@zmi.at>
	<20090203154907.GA21278@infradead.org> <200902040952.45440@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200902040952.45440@zmi.at>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On Wed, Feb 04, 2009 at 09:52:45AM +0100, Michael Monnerie wrote:
> On Dienstag 03 Februar 2009 Christoph Hellwig wrote:
> > Yeah, that sounds correct. =A0Do you volunteer for the FAQ entry?
> > =A0xfs.org is a wiki so you could add it. =A0I'm happy to proof-read it
> > if you want.
> =

> I don't know if it's good and correct, I just put this in the wiki, and =

> additionally changed 2 sections, please check the wiki log if it's =

> correct:
> =

> =3D=3D Q. What about the hard disk write cache? =3D=3D
> =

> The problem with hard disk write caches is that their contents are lost =

> in case of a power outage. With hard disk cache sizes of currently up to =

> 32MB that can be a lot of valuable information.
> =

> With a single hard disk and barriers turned on (on=3Ddefault), a powerfai=
l =

> "only" looses data in the cache but at least does not destroy the =

> filesystem.

I'd drop this paragraph - powerfail can destroy filesystems even on
a single disk (e.g. root directory gets corrupted).

> With a RAID controller with battery backed cache, you should turn off =

> barriers, as recommended above. But then you *must* disable the hard =

> disk write cache in order to ensure to keep the filesystem intact after =

> a power failure.

I'd change this to say "*must* disable the individual hard disk
write caches" to make it clear that it is referencing the disks
behind the raid controller. I'd also say "The method for doing this
is different for each RAID controller. Please consult your RAID
controller documentation to determine how to change these settings."

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
