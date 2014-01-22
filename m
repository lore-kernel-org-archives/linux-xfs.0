Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4E6217F6D
	for <xfs@oss.sgi.com>; Wed, 22 Jan 2014 07:27:38 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 403DF304066
	for <xfs@oss.sgi.com>; Wed, 22 Jan 2014 05:27:38 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 60ryAz3zWvSd59lE (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 22 Jan 2014 05:27:31 -0800 (PST)
Date: Wed, 22 Jan 2014 14:27:29 +0100
From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH RESEND] xfstests: btrfs: cross-subvolume sparse copy
Message-ID: <20140122132729.GJ6498@twin.jikos.cz>
References: <1390304448-25752-1-git-send-email-koen.de.wit@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1390304448-25752-1-git-send-email-koen.de.wit@oracle.com>
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
To: Koen De Wit <koen.de.wit@oracle.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Tue, Jan 21, 2014 at 12:40:48PM +0100, Koen De Wit wrote:
> +btrfs subvol delete $SUBVOL1 >/dev/null 2>&1
> +btrfs subvol delete $SUBVOL2 >/dev/null 2>&1

Please use $BTRFS_UTIL_PROG instead of 'btrfs' and don't shorten the
command names, ie 'subvolume'.

> +cp --reflink $TESTDIR1/file1 $SUBVOL1
> +cp --reflink $TESTDIR1/file1 $SUBVOL2
> +cp --reflink $SUBVOL1/file2 $TESTDIR1/
> +cp --reflink $SUBVOL1/file2 $SUBVOL2
> +cp --reflink $SUBVOL2/file3 $TESTDIR1/
> +cp --reflink $SUBVOL2/file3 $SUBVOL1

--reflink without any parameter means 'always', that's what we want, but
can we possibly make it explicit? 'cp' is an external tool and if the
default changes, the test would not work as expected.

Otherwise ok,
Reviewed-by: David Sterba <dsterba@suse.cz>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
