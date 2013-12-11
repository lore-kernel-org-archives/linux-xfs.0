Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1FF727FF7
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 01:44:23 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EC2E5304043
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 23:44:22 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id QpmSiRGT1GEWSwPg (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 10 Dec 2013 23:44:22 -0800 (PST)
Date: Tue, 10 Dec 2013 23:44:22 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 03/10] xfstests: _scratch_mkfs_sized() for tmpfs
Message-ID: <20131211074422.GC19248@infradead.org>
References: <1386706321-15795-1-git-send-email-jayr@google.com>
	<1386706321-15795-4-git-send-email-jayr@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1386706321-15795-4-git-send-email-jayr@google.com>
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

On Tue, Dec 10, 2013 at 12:11:54PM -0800, Junho Ryu wrote:
> From: Hugh Dickins <hughd@google.com>
> 
> _scratch_mkfs_sized() avoid blockdev and update MOUNT_OPTIONS with
> required size on tmpfs, so those tests using it can now run.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>
> Signed-off-by: Junho Ryu <jayr@google.com>

Ah, here we go.

>      blocks=`expr $fssize / $blocksize`
>  
> -    if [ "$HOSTOS" == "Linux" ]; then
> +    if [ "$HOSTOS" == "Linux" -a "$FSTYP" != "tmpfs" ]; then

Should just check if SCRATCH_DEV is a block devices instead of
hardcoding a filesystem.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
