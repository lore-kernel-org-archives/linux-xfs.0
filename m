Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2H02Xhr195780 for <xfs@OSS.SGI.com>; Fri, 16 Mar 2012 19:02:34 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id VJmp7NmWkNy50LqZ
	for <xfs@OSS.SGI.com>; Fri, 16 Mar 2012 17:02:25 -0700 (PDT)
Message-ID: <4F63D48E.9080109@hardwarefreak.com>
Date: Fri, 16 Mar 2012 19:02:22 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: raid10n2/xfs setup guidance on write-cache/barrier
References: <CAA8mOyDKrWg0QUEHxcD4ocXXD42nJu0TG+sXjC4j2RsigHTcmw@mail.gmail.com>
	<4F61803A.60009@hardwarefreak.com>
	<CAA8mOyCzs36YD_QUMq25HQf8zuq1=tmSTPjYdoFJwy2Oq9sLmw@mail.gmail.com>
	<4F633121.10800@hardwarefreak.com>
	<CAKuK5J3GHgWcnYLqwRV8s_wMjO2nBVf7h=yONtn90kPn9A_3Gg@mail.gmail.com>
	<CAKuK5J11JTdwZSBWj7DH7c+hE--MVNQVVrcKXaV2AO-wEpWBog@mail.gmail.com>
	<20323.37976.162802.876821@tree.ty.sabi.co.UK>
In-Reply-To: <20323.37976.162802.876821@tree.ty.sabi.co.UK>
Reply-To: stan@hardwarefreak.com
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
To: Peter Grandi <pg@lxra2.to.sabi.co.UK>
Cc: Linux RAID <linux-raid@vger.kernel.org>, Linux fs XFS <xfs@oss.sgi.com>

On 3/16/2012 2:28 PM, Peter Grandi wrote:
> [ ... ]
> 
>>>> write barriers will ensure journal and thus filesystem
>>>> integrity in a crash/power fail event.  They do NOT guarantee
>>>> file data integrity as file data isn't journaled.
> 
> Not well expressed, 

Given the audience, the OP, I was simply avoiding getting too deep in
the weeds Peter.  This thread is on the linux-raid list, not xfs@oss.
You know I have a tendency to get too deep in the weeds.  I think I did
nice job of balance here. ;)

> as XFS barriers do ensure file data integrity,
> *if the applications uses them* (and uses them in exactly the
> right way).

How will the OP know which, if any, of his users' desktop applications
do fsyncs, properly?  He won't.  Which is why I made the general
statement, which is correct, if not elaborate, nor down in the weeds.

> The difference between metadata and data with XFS is that XFS
> itself will use barriers on metadata at the right times, because
> that's data to XFS, but it won't use barriers on data[1], leaving
> that entirely to the application.

[1]File data, just to be clear

>>>>  No filesystem (Linux anyway) journals data, only metadata.
> 
>>> That's not true, is it? ext3 and ext4 support journal=data.
> 
> They do, because they journal blocks, which is not generally a
> great choice, but gives the option to journal data blocks too more
> easily than other choices. But it is a very special case that few
> people use.

Few use it because the performance is absolutely horrible.  data=journal
disables delayed allocation (which serious contributes to any modern
filesystem's performance--EXT devs stole/borrowed delayed allocation
from XFS BTW) and it disables O_DIRECT.  It also doubles the number of
data writes to media, once to the journal, once to the filesystem, for
every block of every file written.

> On a more general note, journaling and barriers are sort of
> distinct issues.
> 
> The real purpose of barriers is to ensure that updates are
> actually on the recording medium, whether in the journal or
> directly on final destination.
> That is barriers are used to ensure that data or metadata on the
> persistent layer is current.

Correct.  Again, trying to stay out of the weeds.  I'd established that
XFS uses barriers on journal writes for metadata consistency, which
prevents filesystem corruption after a crash, but not necessarily file
corruption.  Making the statement that XFS doesn't journal data gets the
point across more quickly, while staying out of the weeds.

[...]

> The 'freeze' features of XFS does not rely on snapshotting, it
> relies on suspending all processes that are writing to the
> filetree, so updates are avoided for the duration.

xfs_freeze was moved into the VFS in 2.6.29 and is called automatically
when doing an LVM snapshot of any Linux FS supporting such.  Thus,
snapshotting relies on xfs_freeze, not the other way round.  And
xfs_freeze doesn't suspend all processes that are writing to the
filesystem.  All write system calls to the filesystem are simply halted,
and the process blocks on IO until the filesystem is unfrozen.

> As the XFS team have been adding or planning to add various "new"
> features like checksums, maybe one day they will add COW to XFS
> too (not such an easy task when considering how large XFS extents
> can be, but the hole punching code can help there).

Not at all an easy rewrite of XFS.  And that's what COW would be, a
massive rewrite.  Copy on write definitely has some advantages for some
usage scenarios, but it's not yet been proven the holy grail of
filesystem design.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
