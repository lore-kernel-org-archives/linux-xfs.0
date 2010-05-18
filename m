Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4I4XeuN028089 for <xfs@oss.sgi.com>; Mon, 17 May 2010 23:33:41 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 63AB89CB22B
	for <xfs@oss.sgi.com>; Mon, 17 May 2010 21:36:57 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id bS4jqM7B3QXffBpM
	for <xfs@oss.sgi.com>; Mon, 17 May 2010 21:36:57 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 129256C2B1
	for <xfs@oss.sgi.com>; Mon, 17 May 2010 23:35:57 -0500 (CDT)
Message-ID: <4BF219A6.4010900@hardwarefreak.com>
Date: Mon, 17 May 2010 23:37:58 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
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
To: xfs@oss.sgi.com

big beer put forth on 5/17/2010 10:34 PM:
>> On Mon, May 17, 2010 at 6:24 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
>> big beer put forth on 5/17/2010 7:08 PM:
>>
>>> If anyone has any ideas on what to do, and/or where to start, I'd
>>> greatly appreciate it.
>>
>> Why are you avoiding the obvious solution in favor of hacking?
>>
> Sending back to the list this time instead of Stan directly (Sorry Stan) :)

No problem.  I love my Tbird "reply-to-list" option. :)

> The obvious solution for me would be a backup or rsync. Unfortunately
> both of those have issues with this particular setup.
> 
> Using a backup over the network to migrate will be way too slow
> (days). There are way too many files to index and this poor little nas
> box is already falling over with cpu load from daily activities. I can
> quickly make a mirror on the storage, and move it over to another
> larger host quickly (minutes). Mounting the FS on another machine will
> greatly improve the time and accuracy, as I won't have to worry about
> inconsistencies as it's a block level copy.

> The black-box solution is also very painful to work with, no gcc, no
> automake, no rsync, etc.
> I would also think that for some reason I can't think of, it would be
> nice to have support for this version of XFS be available for free for
> others. Some other poor sap might find some value.
> 
> So I went and changed the magic number to 0x58465342 by dumping the
> 1st 512 bytes off the volume, editing, and writing back, now I'm
> getting "Can't verify primary superblock". Using xfs_db to look at the
> other superblocks indeed still shows HXFS. Any advise how I can
> find/dump/re-write one of the other superblocks? I'd like to see if I
> can change another one of them if xfs_repair will run.

Seems to me you're taking some big chances with live data.  One wrong turn
and you could hose the FS and lose all the data, yes?  I'd rather give you
recommendations not related to this current path you're taking.  Would you
please provide the model or part number of this Hitachi NAS so I can get an
idea of what exactly it is you're dealing with, and possibly offer other
solutions?

Maybe someone else here can help you pull this off via XFS.  I can't.  But
I'll gladly spend some time researching other possible solutions, mainly
getting a high capacity drive connected so you can do a cp -a or tar and be
done with this overnight, in a data-safe manner.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
