Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9BKdJK3234524 for <xfs@oss.sgi.com>; Thu, 11 Oct 2012 15:39:19 -0500
Message-ID: <50772ECF.5050308@sgi.com>
Date: Thu, 11 Oct 2012 15:40:47 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] xfs_io: include headers for preadv/pwritev
References: <50749EE2.6070408@redhat.com>
In-Reply-To: <50749EE2.6070408@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="windows-1252"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 10/09/12 17:02, Eric Sandeen wrote:
> We need to include uio.h to avoid:
>
>      [CC]     pread.o
> pread.c: In function =91do_pread=92:
> pread.c:198: warning: implicit declaration of function =91preadv=92
>      [CC]     pwrite.o
> pwrite.c: In function =91do_pwrite=92:
> pwrite.c:85: warning: implicit declaration of function =91pwritev=92
>
> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
> ---

I had a problem downloading this patch. It was small, so I recreated.
I hope it was correct.

Committed to git://oss.sgi.com/xfs/cmds/xfsprogs.git, master branch.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
