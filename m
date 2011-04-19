Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3JB4tof033851 for <xfs@oss.sgi.com>; Tue, 19 Apr 2011 06:04:56 -0500
Received: from mail-wy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 091EE3F63FE
	for <xfs@oss.sgi.com>; Tue, 19 Apr 2011 04:08:21 -0700 (PDT)
Received: from mail-wy0-f181.google.com (mail-wy0-f181.google.com
	[74.125.82.181]) by cuda.sgi.com with ESMTP id Nb5qoiKsytAzw5Dd
	for <xfs@oss.sgi.com>; Tue, 19 Apr 2011 04:08:21 -0700 (PDT)
Received: by wyi11 with SMTP id 11so6629336wyi.26
	for <xfs@oss.sgi.com>; Tue, 19 Apr 2011 04:08:20 -0700 (PDT)
Date: Tue, 19 Apr 2011 13:07:37 +0200
From: Anisse Astier <anisse@astier.eu>
Subject: Re: xfs_repair crashing (versions 3.1.4 and 3.1.5)
Message-ID: <20110419130737.45beb611@destiny.ordissimo>
In-Reply-To: <20110419082705.GI23985@dastard>
References: <BANLkTikh1i3aYgXNZut+AGT-1kz=aqv-Eg@mail.gmail.com>
	<20110419082705.GI23985@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, 19 Apr 2011 18:27:05 +1000, Dave Chinner <david@fromorbit.com> wrote :

> On Mon, Apr 18, 2011 at 09:24:22PM +0200, Anisse Astier wrote:
> > directory flags set on non-directory inode 2283178100, would fix bad flags.
> > bad key in bmbt root (is 73434, would reset to 74194) in inode
> > 2283178100 data fork
> > bad fwd (right) sibling pointer (saw 145202888 should be NULLDFSBNO)
> > Segmentation fault
> 
> Hmmm. The very next line doesn't appear before the segfault, making
> me think that it's the printf that is causing it to crash.
> 
>         if (check_dups == 0 &&
>                 cursor.level[0].right_fsbno != NULLDFSBNO)  {
>                 do_warn(
>         _("bad fwd (right) sibling pointer (saw %llu should be NULLDFSBNO)\n"),
>                         cursor.level[0].right_fsbno);
> 
> We get this line of output.
> 
>                 do_warn(
>         _("\tin inode %u (%s fork) bmap btree block %llu\n"),
>                         XFS_AGINO_TO_INO(mp, agno, ino), forkname,
>                         cursor.level[0].fsbno);
> 
> But not this one. I wonder if passing a 64bit number to a %u format
> string (shoul dbe %llu) causes problems on ARM? All the variables
> are valid as they are printed or accessed elsewhere in the function,
> so that's the only thing I can think of without a stack trace to
> tell me otherwise....

I have no idea. I did not succeed in getting a stacktrace. CPU is an
ARM9, and I used Debian armel squeeze & wheezy  xfsprogs binaries.


Regards,

Anisse

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
