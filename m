Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E52828023
	for <xfs@oss.sgi.com>; Fri, 15 Mar 2013 09:55:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D5D858F8035
	for <xfs@oss.sgi.com>; Fri, 15 Mar 2013 07:55:43 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id F5unC1fN29A07xbP for <xfs@oss.sgi.com>;
	Fri, 15 Mar 2013 07:55:42 -0700 (PDT)
Date: Fri, 15 Mar 2013 15:55:40 +0100
From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] xfstests: make defrag test 222 generic
Message-ID: <20130315145540.GG7229@twin.jikos.cz>
References: <513F5B0A.4030405@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <513F5B0A.4030405@redhat.com>
Reply-To: dsterba@suse.cz
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: ext4 development <linux-ext4@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On Tue, Mar 12, 2013 at 11:42:50AM -0500, Eric Sandeen wrote:
> Define a new _defrag_dir() helper which just runs noisy/debug
> dir defrag for ext4 and/or btrfs as well, and use that in 222
> instead of hardcoded xfs_fsr.

Dir defrag on btrfs does not recurse in the given directory to defrag
all files, but defragments the tree of the containing subvolume and the
whole extent tree (thus needs CAP_SYS_ADMIN).

This is known (and not very intuitive) behaviour, it would be better to
add a special parameter to defrag the root and/or the extent root and
pass it down to the ioctl via flags.

Until this is implemented I suggest to use a workaround via 'find':

 find $dir -print -execdir $DEFRAG_PROG '{}' +

Otherwise the test looks ok.

david

> +# Defrag a whole directory.  No checking as above, just run it, noisily
> +# output should be sent to $seq.full since it's very fs-specific
> +_defrag_dir()
> +{
> +    case "$FSTYP" in
> +    xfs)
> +	$DEFRAG_PROG -d -v $1
> +	;;
> +    ext4|ext4dev|btrfs)
       ext4|ext4dev)
> +	$DEFRAG_PROG -v $1
> +	;;
       btrfs)
        find $1 -print -execdir $DEFRAG_PROG '{}' +
        ;;
> +    *)
> +	$DEFRAG_PROG $1
> +	;;
> +    esac
> +}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
