Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4I4LBm7027461 for <xfs@oss.sgi.com>; Mon, 17 May 2010 23:21:11 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7CD6C13F3EBE
	for <xfs@oss.sgi.com>; Mon, 17 May 2010 21:23:28 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id rnMXnfrZrUBLe0vH for
	<xfs@oss.sgi.com>; Mon, 17 May 2010 21:23:28 -0700 (PDT)
Message-ID: <4BF2163F.5070908@sandeen.net>
Date: Mon, 17 May 2010 23:23:27 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: mounting hixfs (Hitachi "tuned" XFS) on 2.6 kernel
References: <AANLkTikek9K8-BqNgee_tXz72beHpWEUl41YtDPrD-3P@mail.gmail.com>	<4BF1EC44.7070803@hardwarefreak.com>
	<AANLkTin_WoxWP3JXHvflVVP_2fGzgbSVfpPW1KGiyd1z@mail.gmail.com>
In-Reply-To: <AANLkTin_WoxWP3JXHvflVVP_2fGzgbSVfpPW1KGiyd1z@mail.gmail.com>
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
To: big beer <bigbeerjr@gmail.com>
Cc: xfs@oss.sgi.com

big beer wrote:

> So I went and changed the magic number to 0x58465342 by dumping the
> 1st 512 bytes off the volume, editing, and writing back, now I'm
> getting "Can't verify primary superblock". Using xfs_db to look at the
> other superblocks indeed still shows HXFS. Any advise how I can
> find/dump/re-write one of the other superblocks? I'd like to see if I
> can change another one of them if xfs_repair will run.


You can select each superblock and write it.

xfs_db -x /dev/blah
xfs_db> sb 1
xfs_db> write magicnum 0x58465342
xfs_db> sb 2
xfs_db> write magicnum 0x58465342
...

this could be scripted with -c <command1> -c <command2>

I don't know if they changed anything other than the magic though,
so you get to keep all pieces if it breaks!

-Eric	

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
