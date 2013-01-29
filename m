Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E0C987F47
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2013 16:44:23 -0600 (CST)
Date: Tue, 29 Jan 2013 16:44:20 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfstests: test dump/restore of file capabilities
Message-ID: <20130129224420.GL27055@sgi.com>
References: <50E61CC3.1000108@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50E61CC3.1000108@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>
Cc: =?iso-8859-1?Q?fugazzi=AE?= <fugazzi99@gmail.com>, xfs-oss <xfs@oss.sgi.com>

Eric,

On Thu, Jan 03, 2013 at 06:05:23PM -0600, Eric Sandeen wrote:
> xfsrestore isn't properly restoring file capabilities; it restores
> them, but then chowns the file, which removes the caps:
> =

> Call Trace:
>  [<ffffffffa028de68>] xfs_xattr_set+0x118/0x120 [xfs]
>  [<ffffffff8119a8c0>] generic_removexattr+0x80/0x90
>  [<ffffffff8120b408>] cap_inode_killpriv+0x28/0x30
>  [<ffffffff8120c666>] security_inode_killpriv+0x16/0x20
>  [<ffffffff81192edf>] notify_change+0x18f/0x330
>  [<ffffffff81176b70>] chown_common+0x60/0xa0
>  [<ffffffff81176c30>] sys_fchown+0x80/0xd0
>  [<ffffffff81537c59>] system_call_fastpath+0x16/0x1b
> =

> This test demonstrates the problem.
> =

> Reported-by: fugazzi=AE <fugazzi99@gmail.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

This looks good to me.

Reviewed-by: Ben Myers <bpm@sgi.com>

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
