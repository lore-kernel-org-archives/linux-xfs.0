Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4I3cR8x025397 for <xfs@oss.sgi.com>; Mon, 17 May 2010 22:38:28 -0500
Received: from mail-qy0-f193.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 78ACF13F634F
	for <xfs@oss.sgi.com>; Mon, 17 May 2010 20:40:44 -0700 (PDT)
Received: from mail-qy0-f193.google.com (mail-qy0-f193.google.com
	[209.85.221.193]) by cuda.sgi.com with ESMTP id
	iGbP66Zpzh4ZYawO for <xfs@oss.sgi.com>;
	Mon, 17 May 2010 20:40:44 -0700 (PDT)
Received: by qyk31 with SMTP id 31so8832811qyk.25
	for <xfs@oss.sgi.com>; Mon, 17 May 2010 20:40:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BF1EC44.7070803@hardwarefreak.com>
References: <AANLkTikek9K8-BqNgee_tXz72beHpWEUl41YtDPrD-3P@mail.gmail.com>
	<4BF1EC44.7070803@hardwarefreak.com>
Date: Mon, 17 May 2010 20:34:14 -0700
Message-ID: <AANLkTin_WoxWP3JXHvflVVP_2fGzgbSVfpPW1KGiyd1z@mail.gmail.com>
Subject: Re: mounting hixfs (Hitachi "tuned" XFS) on 2.6 kernel
From: big beer <bigbeerjr@gmail.com>
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
To: xfs@oss.sgi.com

>On Mon, May 17, 2010 at 6:24 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> big beer put forth on 5/17/2010 7:08 PM:
>
>> If anyone has any ideas on what to do, and/or where to start, I'd
>> greatly appreciate it.
>
> Why are you avoiding the obvious solution in favor of hacking?
>
> --
> Stan
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>
Sending back to the list this time instead of Stan directly (Sorry Stan) :)


The obvious solution for me would be a backup or rsync. Unfortunately
both of those have issues with this particular setup.

Using a backup over the network to migrate will be way too slow
(days). There are way too many files to index and this poor little nas
box is already falling over with cpu load from daily activities. I can
quickly make a mirror on the storage, and move it over to another
larger host quickly (minutes). Mounting the FS on another machine will
greatly improve the time and accuracy, as I won't have to worry about
inconsistencies as it's a block level copy.

The black-box solution is also very painful to work with, no gcc, no
automake, no rsync, etc.
I would also think that for some reason I can't think of, it would be
nice to have support for this version of XFS be available for free for
others. Some other poor sap might find some value.

So I went and changed the magic number to 0x58465342 by dumping the
1st 512 bytes off the volume, editing, and writing back, now I'm
getting "Can't verify primary superblock". Using xfs_db to look at the
other superblocks indeed still shows HXFS. Any advise how I can
find/dump/re-write one of the other superblocks? I'd like to see if I
can change another one of them if xfs_repair will run.

Thanks!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
