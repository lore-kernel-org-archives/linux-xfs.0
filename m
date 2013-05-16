Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0C4AA7F37
	for <xfs@oss.sgi.com>; Thu, 16 May 2013 07:29:02 -0500 (CDT)
Message-ID: <5194D12E.4000903@sgi.com>
Date: Thu, 16 May 2013 07:29:34 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/3] xfstests: generic/235 breaks /etc/mtab symlinks breaks
	xfs/189
References: <1368062501-15046-1-git-send-email-david@fromorbit.com>
	<1368062501-15046-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1368062501-15046-4-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 05/08/2013 08:21 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> Serenity lost.
> Insanity looms darkly.
> /etc/mtab
>
> Random behaviour.
> xfs/189 fails
> After a week passing.
>
> -SCRATCH_DEV on SCRATCH_MNT type xfs (ro,filestreams)
> +SCRATCH_DEV on SCRATCH_MNT type xfs (ro,relatime,attr2,filestreams,inode64,noquota)
>
> Confusion prevails.
> /proc/mounts can never give success.
> Anything but golden.
>
> ls -l
> /etc/mtab shows:
> lrwxrwxrwx 1 root root 12 May  8 16:05 /etc/mtab -> /proc/mounts
>
> symlink modified.
> Stealth. Deception. WTF?
> Ninjas go unseen.
>
> "git grep mtab". Yay!
> generic/235: sad
> SElinux hack.
>
> Remount context grot.
> Mount uses all options from
> /etc/mtab
>
> Kernel rejects mount.
> sed hacks /etc/mtab
> Symlink becomes file.
>
> Test frobulation.
> xfs/189 passes
> Randomness tamed.
>
> Double face-palm. Tears.
> Crack-inspired insanity.
> mount(8) needs fixing.
>
> Schizophrenia.
> /etc/mtab. Same thing.
> Test psychiatry.
>
> Hack, slash, glue, polish.
> xfs/189 fixed.
> Made shiny again.
>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Thanks for the cleanup patches.  Only comment is although I enjoy the 
humorous patch description, can we make it shorter?

Other than that, looks good.
Reviewed-by: Rich Johnston <rjohnston@sgi.com>

--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
