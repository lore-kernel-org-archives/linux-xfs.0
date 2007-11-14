Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 13 Nov 2007 21:08:49 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAE585WW006020
	for <linux-xfs@oss.sgi.com>; Tue, 13 Nov 2007 21:08:10 -0800
Message-ID: <473A82E6.50709@sgi.com>
Date: Wed, 14 Nov 2007 16:08:54 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: acl and attr: Fix path walking code
References: <200710281858.24428.agruen@suse.de> <4733F301.9020706@sgi.com> <200711102152.05619.agruen@suse.de>
In-Reply-To: <200711102152.05619.agruen@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andreas Gruenbacher <agruen@suse.de>
Cc: linux-xfs@oss.sgi.com, Gerald Bringhurst <gbringhurst@novell.com>, Brandon Philips <bphilips@suse.de>

Andreas Gruenbacher wrote:
 > On Friday 09 November 2007 06:41:21 Timothy Shimmin wrote:
 >> I applied attr patch and tried it out on xfstests/062
 >> (which I believe was based on one of your tests).
 >>
 >> ==========================================================
 >> --- 062.out     2006-03-28 12:52:32.000000000 +1000
 >> +++ 062.out.bad 2007-11-09 15:38:09.000000000 +1100
 >> @@ -526,6 +526,10 @@
 >>   user.name=0xbabe
 >>   user.name3=0xdeface
 >>
 >> +# file: SCRATCH_MNT/lnk
 >> +trusted.name=0xbabe
 >> +trusted.name3=0xdeface
 >> +
 >>   # file: SCRATCH_MNT/dev/b
 >>   trusted.name=0xbabe
 >>   trusted.name3=0xdeface
 >> @@ -562,6 +566,10 @@
 >>   user.1=0x3233
 >>   user.x=0x797a
 >>
 >> +# file: SCRATCH_MNT/descend/and/ascend
 >> +trusted.9=0x3837
 >> +trusted.a=0x6263
 >> +
 >>
 >>   *** directory descent without following symlinks
 >>   # file: SCRATCH_MNT/reg
 >> ==========================================================
 >>
 >> So for the following of symlinks with getfattr -L
 >> i.e.
 >>    echo "*** directory descent with us following symlinks"
 >>    getfattr -h -L -R -m '.' -e hex $SCRATCH_MNT
 >>
 >> Looking at the 2nd difference...
 >> It now picks up descend/and/ascend which contains the symlink
 >> of descend/and --> here/up.
 >> So that makes sense, it is following a symlink which it
 >> didn't before and finding a dir, "up" in the linked dir.
 >> Good.
 >>
 >> Looking at 1st difference...
 >> It is now showing up "lnk" which is a symlink: lnk --> dir
 >> So why is it showing this up
 >> and yet it is not showing descend/and (which is a link to here/up)?
 >> So yes we are following symlinks but are we supposed
 >> to just do the symlinks themselves as well?
 >
 > With -h, the utilities operate on the symlinks rather than the files that the
 > symlinks point to. The test case sets attributes on SCRATCH_MNT/lnk, but not
 > on descend/and.

Oops, yep, there is no EA on descend/and.

 >
 > The -h and -L options together don't make much sense actually.
 >
No they don't :)
So will it not follow the argument but follow any descendents that
it finds on the walk.
It kind of looked from the manpage that the -h is about just
the argument and not about the walk.

<okay you clarified this below...>

Anyway, I took out the -h with the -L,
i.e. $ getfattr  -L -R -m '.' -e hex $SCRATCH_MNT

And it is still reporting
 >> +# file: SCRATCH_MNT/lnk
 >> +trusted.name=0xbabe
 >> +trusted.name3=0xdeface
 >> +

So I presume following symlinks also mean operating on symlinks too
(i.e. getting the EA)?

---


 > On Friday 09 November 2007 08:39:56 Timothy Shimmin wrote:
 >> > You mention -L/-P is like chown.
 >> > However, -P for getattr isn't about not walking symlinks
 >> > to directories,
 >> > it's about skipping symlinks altogether, right?
 >
 > Hmm, -L and -P define which files and directories are visited, and -h defines
 > whether we are looking at symlinks or the files they point to. The two
 > concepts are orthogonal. -P is not about skipping symlinks, only about not
 > recursing into them.
 >
Oh okay.
There is the concept of following the symlink for traversal versus
following the symlink to get the EA on.

So with -L should it just follow the symlink or look at the symlink first
and then follow it?
And will -h modify this behavior?
I'm still confused about the 1st difference in 062 output.

I wonder if the man pages can be clarified in this area :)

--Tim
