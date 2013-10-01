Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 685577F57
	for <xfs@oss.sgi.com>; Tue,  1 Oct 2013 09:25:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4470C30406A
	for <xfs@oss.sgi.com>; Tue,  1 Oct 2013 07:25:45 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id SOJk1ABiTxr6ICs7 for <xfs@oss.sgi.com>;
	Tue, 01 Oct 2013 07:25:44 -0700 (PDT)
Date: Tue, 1 Oct 2013 16:25:41 +0200
From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] xfstests: btrfs/015 regression test for prealloc with
	balance
Message-ID: <20131001142541.GG18291@twin.jikos.cz>
References: <1380292053-8123-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1380292053-8123-1-git-send-email-jbacik@fusionio.com>
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
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Fri, Sep 27, 2013 at 10:27:33AM -0400, Josef Bacik wrote:
> +$BTRFS_UTIL_PROG fi ba $SCRATCH_MNT >> $seqres.full 2>&1 || \
> +	_fail "balance failed"

Please use the full command names, also 'filesystem balance' is the
obsolete form, it's spelled 'btrfs balance start'.

david

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
