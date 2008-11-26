Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAQ0B23L019751 for <xfs@oss.sgi.com>; Tue, 25 Nov 2008 18:11:02 -0600
Date: Wed, 26 Nov 2008 11:11:09 +1100
Subject: Re: Badness in key lookup (length)
From: "Barry Naujok" <bnaujok@sgi.com>
MIME-Version: 1.0
References: <200811252302.55944.Martin@Lichtvoll.de>
Message-ID: <op.uk69gvj73jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <200811252302.55944.Martin@Lichtvoll.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Martin Steigerwald <Martin@lichtvoll.de>, xfs@oss.sgi.com

On Wed, 26 Nov 2008 09:02:55 +1100, Martin Steigerwald  
<Martin@lichtvoll.de> wrote:

> Hi!
>
> I also checked my / XFS filesystem after that failed attempt to hibernate
> via TuxOnIce (see my mail "truncated files"). Well BTW this happened on a
> ThinkPad T42.
>
> While /home was fine, / had some rather minor - it seems - issues.  
> Whether
> they have been from today or from whenever - I do not know.

[snip]

> My questions:
>
> 1) Whats those Badness in key lookup messages? Anything to worry about?

Generally not - the xfsprogs cache indexes read blocks by offset and
I/O size. It will generate this warning if it encounters a read to the
same offset with different I/O size. Basically there to tell me that
there's a scenario where this may happen and should be fixed.

> 2) Why did xfs_repair -n after I ran xfs_repair yield yet another
> error "would have reset inode 94530 nlinks from 2 to 3"? Why didn't it
> appear in the first pass?

There are remote cases where the first pass does not get the nlinks
quite right - I would have needed a metadump before the first run to
isolate where it miscounted the nlinks. All problems like this in
the past have been related to lost+found.

> martin@shambhala:~/Zeit/xfs-probleme-2008-11-25> grep 94530
> xfsrepair-sda1-repair.txt
> martin@shambhala:~/Zeit/xfs-probleme-2008-11-25#1>
>
> 3) Any idea how these problems occured in the first time?

I think Dave pointed the cause out quite nicely :)

Regards,
Barry.

PS. Update the email address in your mailer to xfs@oss.sgi.com,
not xfs-linux@oss.sgi.com.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
