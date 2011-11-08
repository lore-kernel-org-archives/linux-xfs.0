Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA8NnQ9o164897 for <xfs@oss.sgi.com>; Tue, 8 Nov 2011 17:49:26 -0600
Received: from mail-vx0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6672E1CF5D3F
	for <xfs@oss.sgi.com>; Tue,  8 Nov 2011 15:49:25 -0800 (PST)
Received: from mail-vx0-f181.google.com (mail-vx0-f181.google.com
	[209.85.220.181]) by cuda.sgi.com with ESMTP id
	5V0DNefyO1rnmkiH for <xfs@oss.sgi.com>;
	Tue, 08 Nov 2011 15:49:25 -0800 (PST)
Received: by vcbfk26 with SMTP id fk26so1167259vcb.26
	for <xfs@oss.sgi.com>; Tue, 08 Nov 2011 15:49:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20111108225513.GO5534@dastard>
References: <CACXvBApxwWUyYNfRL9rS32t7f04XCDwafbR7fSFjmXg8fJRpTg@mail.gmail.com>
	<20111108225513.GO5534@dastard>
Date: Tue, 8 Nov 2011 14:49:24 -0900
Message-ID: <CACXvBAqAvdHA7-mQ2fGHu4VQF=XfVt-B7WtkpS5h+8JDV5n+OQ@mail.gmail.com>
Subject: Re: quota mismatch for NFS mount of XFS filesystem
From: Liam Forbes <loforbes@alaska.edu>
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
Cc: xfs@oss.sgi.com

On Tue, Nov 8, 2011 at 1:55 PM, Dave Chinner <david@fromorbit.com> wrote:
>
> That looks like a 32bit variable overflow. In 512 byte blocks
> (sectors), 2^32 sectors overflows at 2T. And 5.8T ~=3D 2T + 2T + 1.8T.
>
> This is most likely to be an NFS issue - I'm not familiar with the
> Linux NFS quota protocol implementation, so I can't really say much
> more than that.

Additional ad hoc testing seems to bear this out.  Thanks!  I'll take
the problem to Red Hat.

-- =

Regards,
-liam

-There are uncountably more irrational fears than rational ones. -P. Dolan
Liam Forbes=A0 =A0 =A0=A0 HPC Systems Analyst,=A0 =A0 =A0 HPC&S Group Leade=
r,=A0 =A0 =A0 CISSP
ARSC, U of AK, Fairbanks=A0=A0 lforbes@arsc.edu 907-450-8618 fax: 907-450-8=
605

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
