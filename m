Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5TLUdG6143963 for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 16:30:39 -0500
Received: from mail1.slb.deg.dub.stisp.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id AFAAE17801BF
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 14:30:38 -0700 (PDT)
Received: from mail1.slb.deg.dub.stisp.net (mail1.slb.deg.dub.stisp.net
	[84.203.253.98]) by cuda.sgi.com with SMTP id HHfv9nNg5EBBBazF
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 14:30:38 -0700 (PDT)
Message-ID: <4E0B9955.3040905@draigBrady.com>
Date: Wed, 29 Jun 2011 22:29:57 +0100
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests 255: add a seek_data/seek_hole tester
References: <1309275199-10801-1-git-send-email-josef@redhat.com>
	<1309275199-10801-5-git-send-email-josef@redhat.com>
	<20110629065306.GC1026@dastard>
	<20110629074021.GA26086@infradead.org>
	<4E0B019E.8080800@draigBrady.com> <4E0B60DE.50908@oracle.com>
In-Reply-To: <4E0B60DE.50908@oracle.com>
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
To: Sunil Mushran <sunil.mushran@oracle.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org, Josef Bacik <josef@redhat.com>

On 29/06/11 18:29, Sunil Mushran wrote:
> On 06/29/2011 03:42 AM, P=E1draig Brady wrote:
>> There is the argument, that if this interface can distinguish
>> these dirty unwritten extents, then why can't the fiemap interface too?
>> The advantage of the fiemap interface is that it can distinguish
>> empty extents vs holes. Empty extents will become increasingly common
>> I think, given the fragmentation and space guarantee benefits they give.
>> It would be cool for cp for example to be able to efficiently copy
>> empty extents from source to dest.
> =

> I'm not too sure about that. Atleast not enabled by default. Most users
> use cp to backup data. Not empty space. In this case, this empty extent
> may not even be de-dupable.

That's a fair point. On the other hand if
you wanted to start working with the backup copy,
you might want it allocated to avoid fragmentation and ENOSPC issues.
What we were going with was empty -> hole with cp --sparse=3Dalways
and empty -> empty otherwise. If empty and hole can not be
distinguished though, then this process will be impacted.

> =

> Frankly I'd be happier of cp started to exploited fallocate() to create
> larger
> extents before copying data into them. Atleast for the large files.

Yes we definitely will start doing that.
That will help fragmentation and give early ENOSPC.
We can't use fiemap for this at the moment
(on XSF or ext4 (without a sync))
but the seek_data interface should allow us
to do this to some extent (pardon the pun).

cheers,
P=E1draig.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
