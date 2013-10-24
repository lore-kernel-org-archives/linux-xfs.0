Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 71AEB7F37
	for <xfs@oss.sgi.com>; Thu, 24 Oct 2013 05:17:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4B2AE8F8059
	for <xfs@oss.sgi.com>; Thu, 24 Oct 2013 03:17:36 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id xDb2pX1r3Ct1QQSk for <xfs@oss.sgi.com>;
	Thu, 24 Oct 2013 03:17:33 -0700 (PDT)
Date: Thu, 24 Oct 2013 12:17:30 +0200
From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v2] xfstests btrfs/020: test device replace on RO btrfs
Message-ID: <20131024101730.GD1032@twin.jikos.cz>
References: <1382527446-16053-1-git-send-email-eguan@redhat.com>
	<1382546683-454-1-git-send-email-eguan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1382546683-454-1-git-send-email-eguan@redhat.com>
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
To: Eryu Guan <eguan@redhat.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Thu, Oct 24, 2013 at 12:44:43AM +0800, Eryu Guan wrote:
> +_cleanup()
> +{
> +	cd /

Using root as temporary directory?

> +	rm -f $tmp.*
> +	$UMOUNT_PROG $loop_mnt
> +	_destroy_loop_device $loop_dev1
> +	losetup -d $loop_dev2 >/dev/null 2>&1
> +	_destroy_loop_device $loop_dev3
> +	rm -rf $loop_mnt
> +	rm -f $fs_img1 $fs_img2 $fs_img3
> +}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
