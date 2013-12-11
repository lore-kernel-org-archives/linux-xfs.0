Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 11F9D7FF7
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 01:42:58 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E105E304043
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 23:42:57 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id x0EivotuA5bjTFkH (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 10 Dec 2013 23:42:57 -0800 (PST)
Date: Tue, 10 Dec 2013 23:42:56 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/10] xfstests: use mount point instead of device name
Message-ID: <20131211074256.GB19248@infradead.org>
References: <1386706321-15795-1-git-send-email-jayr@google.com>
	<1386706321-15795-3-git-send-email-jayr@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1386706321-15795-3-git-send-email-jayr@google.com>
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
To: Junho Ryu <jayr@google.com>
Cc: hughd@google.com, tytso@mit.edu, branto@redhat.com, xfs@oss.sgi.com

On Tue, Dec 10, 2013 at 12:11:53PM -0800, Junho Ryu wrote:
> From: Hugh Dickins <hughd@google.com>
> 
> A tmpfs mount does not involve any block device, its $SCRATCH_DEV is
> nothing but a place-holder, so apply 'df' or 'stat' to its mount point
> $SCRATCH_MNT instead of to $SCRATCH_DEV.
> 
> It also fixes a bug in generic/256: "stat -f $SCRATCH_DEV" returning the
> block size of the root file system, but not the test file system.
> 
> $ df | grep sda
> /dev/sda1    233191    62959    157791    29%    /boot
> 
> $ sudo dumpe2fs -h /dev/sda1 | grep "Block size"
> Block size:               1024
> 
> $ stat -f /dev/sda1 | grep "Block size"
> Block size: 4096       Fundamental block size: 4096
> 
> $ stat -f /boot | grep "Block size"
> Block size: 1024       Fundamental block size: 1024
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Junho Ryu <jayr@google.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>


Although I have to wonder how you got these tests to run, as it seems
like you didn't implement _scratch_mkfs_sized for tmpfs.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
