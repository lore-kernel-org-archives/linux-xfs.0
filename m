Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C9D187F37
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 18:35:08 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A56318F804B
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 16:35:08 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id JoO5zVaZ7TY61mzF for <xfs@oss.sgi.com>;
	Wed, 13 Nov 2013 16:35:07 -0800 (PST)
Message-ID: <52841AB9.9050906@sandeen.net>
Date: Wed, 13 Nov 2013 18:35:05 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH RFC] xfs: set block device logical sector size on
	xfs_buftarg
References: <5283C41D.7070503@redhat.com>
In-Reply-To: <5283C41D.7070503@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>

On 11/13/13, 12:25 PM, Eric Sandeen wrote:
> Pure RFC; this might be crazy.  Here's the problem I'm trying to solve:
> 
> Today, mkfs.xfs will select a 4k sector size for a 4k physical / 512 logical
> drive.  (that change was done by me).  The thought was that it'd be an
> efficiency gain to not make the drive do the (possible) RMW cycles on
> 512-byte log IO, primarily.
> 
> However, now this restricts all DIO to 4k alignment, not the otherwise-
> possible 512.

So, backing up... ;)

XFS isn't doing anything wrong here.  It can make sector sizes as it pleases,
and apps had darned well better accommodate its whims if they do direct IO.

But some apps don't.  And users are sad and confused, and grow to dislike
XFS, because it all worked just fine on that other filesystem, so screw you
XFS, and your flux capacitor drives with your power-fail interrupts!

So my overarching goal here is to have XFS do its internal IO as efficiently
as possible on an "advanced format" drive, i.e. in 4k chunks, but not to
break apps that don't bother to check whether ye olde 512 DIO will work,
if the underlying storage can actually handle it.

We could even ensure that XFS_IOC_DIOINFO offers up "4k" as the answer
to miniosz, so that apps which bother to ask get the optimal answer.

But if we know, deep in our hearts, that a 512 byte DIO is ok, let's
let it pass.

Hacking up bt_sshift and friends might be the wrong way to do it, although
I'm not so sure - that's really all it's used for (today).

Christoph's suggestion to leave sector size at 512 but set a log stripe seems
interesting, too.

Or, we could stop setting 4k sectors for AF drives.

Or we could just carry on, and keep telling users that it's their fault,
their app's fault, etc...

(I'm sympathetic to pushing the envelope and dragging apps into the 21st
century, but it's s double edged sword).

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
