Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6OHBPNc138948 for <xfs@oss.sgi.com>; Fri, 24 Jul 2009 12:11:26 -0500
Received: from enyo.dsw2k3.info (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7C189383E4B
	for <xfs@oss.sgi.com>; Fri, 24 Jul 2009 10:12:09 -0700 (PDT)
Received: from enyo.dsw2k3.info (enyo.dsw2k3.info [195.71.86.239]) by
	cuda.sgi.com with ESMTP id 1cEBBrHndyeD3Zzh for
	<xfs@oss.sgi.com>; Fri, 24 Jul 2009 10:12:09 -0700 (PDT)
Date: Fri, 24 Jul 2009 19:11:51 +0200
From: Matthias Schniedermeyer <ms@citd.de>
Subject: Re: Using xfsdump On Linux With IRIX Version 1 FS?
Message-ID: <20090724171151.GA23077@citd.de>
References: <20090724073030.GA15785@citd.de> <C68F4D3F.B931%elbles@sessys.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <C68F4D3F.B931%elbles@sessys.com>
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
To: Sean Elble <elbles@sessys.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On 24.07.2009 11:36, Sean Elble wrote:
> On 7/24/09 3:30 AM, "Matthias Schniedermeyer" <ms@citd.de> wrote:
> 
> >> 
> >> Looks like the version 1 directory code was removed as of June 15th, 2006,
> >> per this:
> >> 
> >> http://oss.sgi.com/archives/xfs/2006-06/msg00067.html
> >> 
> >> But another post <http://oss.sgi.com/archives/xfs/2003-07/msg00495.html> has
> >> a 2.4.21 kernel being used with a patch, so I'm not sure if I want to try a
> >> 2.6 kernel, or see if I can patch together a 2.4.x kernel on an old FC4 box
> >> I have laying around.  Truth be told, it's a lot of work just to blank the
> >> entries in /etc/shadow so I can login to a 150 MHz box again, so who knows
> >> if I'll even try at this point, hah.
> >> 
> >> In any event, thanks a lot for the pointers in the right direction.
> > 
> > I'd guess the disc isn't very big.
> > 
> > You just dd it completly (for backup).
> > 
> > Then search for the content of the shadow-file and blank out the entry
> > with a hex-editor. Make sure that you don't change the filesize, pad
> > the previous/following entry with any character you have to remove.
> 
> Right, the disk is only 2 GB.  Presumably, to back the disk up, all I'd have
> to do would be something like:
> 
>     dd if=/dev/sda of=IRIXbackup
> 
> Correct?  No need to specify bs or count, I presume...

Exactly.

> Then, I could use hexedit in the following manner to edit the disk:
> 
>     hexedit -d -f /dev/sda

Don't know hexedit. Last time i used a hex editor it was "khexedit", 
worked good enough.

> I suppose I could search for the encrypted password string itself, but as
> Chris Wedgwood suggested, I might be better off finding the offset of the
> /etc/shadow file by doing something like the following:
>     
>     xfs_ncheck /dev/sda | grep /etc/shadow
> 
> I'm not sure if I can use the inode number directly as an offset or not, but
> I *think* I could use it in conjunction with a xfs_db convert command to get
> something usable as an offset.  Something like the following, perhaps?
> 
>     xfs_db -c convert inode <inode from xfs_ncheck command> daddr /dev/sda

2GB is small enough to just use "brute force".

- Make a backup-copy of the image
- Open the image in a/the hexeditor
- Search for something that appears in the shadow file
  it should be pretty obvious if the hit is inside the shadow file.
- Make the changes, (Remember filesize has to stay the same!) 
- dd the image back to the HDD.

Not very complicated and it still shouldn't take too long. :-)



Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
