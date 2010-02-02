Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o12Ff5gZ177797 for <xfs@oss.sgi.com>; Tue, 2 Feb 2010 09:41:05 -0600
Received: from mail-bw0-f227.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1E27A1A5DC5
	for <xfs@oss.sgi.com>; Tue,  2 Feb 2010 07:42:13 -0800 (PST)
Received: from mail-bw0-f227.google.com (mail-bw0-f227.google.com
	[209.85.218.227]) by cuda.sgi.com with ESMTP id
	OOxtF6MYT45UoZbk for <xfs@oss.sgi.com>;
	Tue, 02 Feb 2010 07:42:13 -0800 (PST)
Received: by bwz27 with SMTP id 27so186411bwz.19
	for <xfs@oss.sgi.com>; Tue, 02 Feb 2010 07:42:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20100202112300.GA23809@infradead.org>
References: <13bb8ce11002011924h611099feh4955eedcc6e588a6@mail.gmail.com>
	<20100202112300.GA23809@infradead.org>
Date: Tue, 2 Feb 2010 07:42:11 -0800
Message-ID: <46b8a8851002020742w28891d18g24d01982631cdf2b@mail.gmail.com>
Subject: Re: State of XFS on ARM
From: Richard Sharpe <realrichardsharpe@gmail.com>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: James.Bottomley@hansenpartnership.com, xfs@oss.sgi.com, Daniel Goller <morfic@gmail.com>

On Tue, Feb 2, 2010 at 3:23 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, Feb 01, 2010 at 09:24:33PM -0600, Daniel Goller wrote:
>> It seems i have not been able to unmount it and then mounting it
>> cleanly once, always required xfs_repair -L =A0 /dev/sdc3
>> I Could understand power issues or lockups causing this, but on clean
>> umount and followed mount to see it fail is surprising.
>> When mounting fails on the headless arm machine i move the drive to a
>> x86_64 and run xfs_repair there when mounting there fails too (so log
>> can't be replayed, making -L necessary).
>> All of this leads me to ask: =A0"Is XFS as well maintained on ARM as it
>> is on x86/x86_64?"
>
> XFS itself is platform neutral. =A0But it seems like you have an ARM
> platform with virtually indexed caches, which currently can't support
> the I/O XFS does. =A0James has been working on fixing this for a while,
> but so far the architecture support patches for it unfortunately still
> haven't made it to mainline despite many people running into this issue.

I would be interested in a precise explanation for this problem. We
ran into an issue here with XFS on the Marvell 78200 (ARM) which has a
VIVT cache. We eventually solved the problem by using
flush_icache_range in a strategic place (after also discovering the
need for flush_dcache_page, but that has to do with doing IO between
the cores on the 78200), but we really did not understand why that
fixed the problem. However, it stopped the corruption we were
experiencing when using a file system exerciser.

(We have subsequently stopped using XFS, but not because of any
corruption issues.)

-- =

Regards,
Richard Sharpe

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
