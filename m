Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5NEGI8Q194108 for <xfs@oss.sgi.com>; Thu, 23 Jun 2011 09:16:18 -0500
Received: from mail-fx0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1CD59286B6
	for <xfs@oss.sgi.com>; Thu, 23 Jun 2011 07:16:17 -0700 (PDT)
Received: from mail-fx0-f53.google.com (mail-fx0-f53.google.com
	[209.85.161.53]) by cuda.sgi.com with ESMTP id f5ldiESTt1esHx2p
	for <xfs@oss.sgi.com>; Thu, 23 Jun 2011 07:16:17 -0700 (PDT)
Received: by fxm8 with SMTP id 8so1431955fxm.26
	for <xfs@oss.sgi.com>; Thu, 23 Jun 2011 07:16:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E02EE71.7010300@hardwarefreak.com>
References: <BANLkTi=gS5iO9R9pVk_df-4ofkkb0ZJgfw@mail.gmail.com>
	<4E026C42.2030500@sandeen.net> <20110622232418.GV32466@dastard>
	<BANLkTinu03WnKTL=SzoWt+Sd9YHjy0_w6g@mail.gmail.com>
	<4E02EE71.7010300@hardwarefreak.com>
Date: Thu, 23 Jun 2011 07:16:16 -0700
Message-ID: <BANLkTineesbE2OWczDLgsyQHV71jKFgU7g@mail.gmail.com>
Subject: Re: xfs_repair: "fatal error -- ran out of disk space!"
From: "Patrick J. LoPresti" <lopresti@gmail.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

Of course we monitor our file systems.   But as I thought I made
clear, we were "unaware" the file system was full because df said it
still had 399 gigabytes of free space.  Granted, this is "only" 7%,
but it could just as easily been 30% or 50% or 80% because _the file
system was corrupt_.

Also, given your "80% rule", I suspect you have never worked in an
environment like mine. This file system is one of around 40 of similar
size in a single pool.  Am I supposed to tell my boss that we need
more disk as soon as our free space goes below 40 terabytes?

The bottom line is that the file system was full but appeared  not to
be, and thus xfs_repair bombed out.  I realize this is a corner case,
but it is a nasty one, and it has nothing to do with my "policy on
filesystem space management".

But thank you for your input.

 - Pat


On Thu, Jun 23, 2011 at 12:42 AM, Stan Hoeppner <stan@hardwarefreak.com> wr=
ote:
> On 6/22/2011 6:41 PM, Patrick J. LoPresti wrote:
>
>> I guess one question is how xfs_repair should behave in this case. =A0I
>> mean, what if the file system had been full, but too corrupt for me to
>> delete anything?
>
> Maybe you should rethink your policy on filesystem space management.
> From what you stated the FS in question actually was full. =A0You
> apparently were unaware of it until a problem (misbehaving nfsd process)
> brought it to your attention. =A0You should be monitoring your FS usage.
> Something as simple as logwatch daily summaries can save your bacon here.
>
> As a general rule, when an FS begins steadily growing past the 80% mark
> heading toward 90%, you need to take action, either adding more disk to
> the underlying LVM device and growing the FS, mounting a new device/FS
> into a new directory in the tree and manually moving files, or making
> use of some HSM software.
>
> Full filesystems have been a source of problems basically forever. =A0It's
> best to avoid such situations instead of tickling the dragon.
>
> --
> Stan
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
