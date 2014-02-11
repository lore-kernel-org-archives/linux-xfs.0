Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4DFFE7F50
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 17:24:15 -0600 (CST)
Message-ID: <52FAB11E.2090803@sgi.com>
Date: Tue, 11 Feb 2014 17:24:14 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: xfs_sb_read_verify() doesn't flag bad crcs on primary
	sb
References: <52FAA85F.1060708@redhat.com>
In-Reply-To: <52FAA85F.1060708@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 02/11/14 16:46, Eric Sandeen wrote:
> My earlier commit 10e6e65 deserves a layer or two of brown paper
> bags.  The logic in that commit means that a CRC failure on the
> primary superblock will *never* result in an error return.
>
> Hopefully this fixes it, so that we always return the error
> if it's a primary superblock, otherwise only if the filesystem
> has CRCs enabled.
>
> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
> ---


Augh, blame the reviewer who is always sdrawkcab:)

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
