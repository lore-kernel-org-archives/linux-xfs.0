Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9257Rn5146722 for <xfs@oss.sgi.com>; Fri, 2 Oct 2009 00:07:27 -0500
Received: from mail-bw0-f216.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 931D3499FF6
	for <xfs@oss.sgi.com>; Thu,  1 Oct 2009 22:08:49 -0700 (PDT)
Received: from mail-bw0-f216.google.com (mail-bw0-f216.google.com
	[209.85.218.216]) by cuda.sgi.com with ESMTP id
	HaHxQuIkqqYDoZPT for <xfs@oss.sgi.com>;
	Thu, 01 Oct 2009 22:08:49 -0700 (PDT)
Received: by bwz12 with SMTP id 12so701083bwz.20
	for <xfs@oss.sgi.com>; Thu, 01 Oct 2009 22:08:48 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 1 Oct 2009 22:08:48 -0700
Message-ID: <46b8a8850910012208n789eeacfva03c0cf404201f0d@mail.gmail.com>
Subject: Apology: Was: Re: Possible small bug in xfsprogs-dev/db/metadump.c
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Sep 29, 2009 at 5:16 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Tue, Sep 29, 2009 at 08:45:56AM -0700, Richard Sharpe wrote:
>> However, now I understand what is going on.
>>
>> Assume a free space tree with levels =3D 3 (from the AGF). However, not
>> all leaf nodes will be at depth 3 in the tree, some will be at depth 2
>> in the tree.
>
> No, that is not possible. By definition, a consistent filesystem
> image has all leaf nodes at level zero.

I got back to this today and reproduced my test case, and you are correct.

[some deletia]

> This sounds to me like the log has not been replayed on this
> filesystem. AFAICT, when looking at a raw disk image of an XFS
> filesystem, the only way to get leaf nodes at non-zero levels is to
> have a dirty log. i.e. the log contains allocation/free transactions
> that have resulted in a multi-level rebalance of the tree
> that have not been replayed and written to disk and hence on-disk
> image of the tree is unbalanced. When the log is replayed, the
> on disk image will get updated and the tree will appear balanced
> with all leaves at level 0.

Dunno. I just umounted again ...

>> However, if the user does "metadump -w" they will see warnings that
>> are bogus and suggests that the author was not really aware of the
>> real structure of the tree.
>
> I think he was aware of the structure. ;)

It was, in fact, I who was confused ... I apologize for the statement I mad=
e.

> It seems to me that you are trying to use the wrong tool to walk
> free space trees and interpret the number of extents. =A0xfs_metadump
> is intended to capture the exact layout of the filesystem metadata
> so that it can be reproduced exactly in a different environment. It
> was not intended as a method of interpreting the potentially
> inconsistent metadata that it records.
>
> xfs_db does what you are trying to do. It already has commands that
> walk the per AG free space trees and tells you the number of
> extents, gives an extent size histogram, etc....
>
> Cheers,
>
> Dave.

-- =

Regards,
Richard Sharpe

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
