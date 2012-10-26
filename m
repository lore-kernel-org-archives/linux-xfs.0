Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9QKTkYJ254610 for <xfs@oss.sgi.com>; Fri, 26 Oct 2012 15:29:46 -0500
Date: Fri, 26 Oct 2012 15:31:29 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfsdump: Revert dump version bump for 32bit projid fix
Message-ID: <20121026203129.GA405@sgi.com>
References: <5085AB70.2060904@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5085AB70.2060904@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Hey Eric,

On Mon, Oct 22, 2012 at 03:24:16PM -0500, Eric Sandeen wrote:
> commit 1e309da7a4f7e2a2f456bf6b7cea4c5f1181cd36 fixed xfsdump to
> properly save & restore the top 16 bits of a 32-bit projid, which
> otherwise was being dropped (and restored as 0) in older xfsdump.
> 
> The original thought was to bump the dump version, so that we know
> whether the dump (may) have the top 16 bits filled in.  In practice
> this would prevent older restores from restoring newer dumps, and
> losing the top 16 bits contained in these newer dumps.
> 
> However, in hindsight this appears to be of limited value.  I
> propose that the dump version change is unuseful/unwanted for a
> couple reasons:
> 
> * There is no actual dump *format* change; the structure size
>   is the same, and the top 16 bits were properly zeroed before; old
>   restores will read these fixed dumps without problems and without
>   restoring garbage.  IOW, they will behave exactly as buggily as
>   they did before.  And worst case, if a dump containing the top 16
>   bits is mangled by an old restore, this can be easily remedied by
>   simply re-restoring with updated userspace.
> 
> * We have no reliable method to know whether 32 bit project IDs are
>   in use; the feature flag was not added to the GEOM call at the time
>   of implementation.  Therefore we cannot reliably bump to V4 only
>   for projid32bit filesystems, and we cannot restrict V4 restores
>   only to projid32bit filesystems.  So the dump version is not
>   useful for feature cross-checking purposes.
> 
> I spoke with wkendall via email, and although he may not have given
> it the most scrutiny (having moved on from xfsdump-land), he also
> felt that a version dump may not be warranted.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    
Pulled this into git://oss.sgi.com/xfs/cmds/xfsdump.git, master branch.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
