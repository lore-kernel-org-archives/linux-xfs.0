Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CB4B57FB6
	for <linux-xfs@oss.sgi.com>; Thu, 31 Oct 2013 10:51:58 -0500 (CDT)
Date: Thu, 31 Oct 2013 10:51:58 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH V2] xfs: be more forgiving of a v4 secondary sb w/ junk
	in v5 fields
Message-ID: <20131031155158.GN1935@sgi.com>
References: <520D1BA3.1050500@redhat.com> <20130815210018.GR6023@dastard>
	<520D44E7.1000905@sandeen.net> <520D592D.4040600@redhat.com>
	<522E3099.1040503@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <522E3099.1040503@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>, Eric Sandeen <sandeen@redhat.com>

Hey Eric,

On Mon, Sep 09, 2013 at 03:33:29PM -0500, Eric Sandeen wrote:
> Today, if xfs_sb_read_verify encounters a v4 superblock
> with junk past v4 fields which includes data in sb_crc,
> it will be treated as a failing checksum and a significant
> corruption.
> 
> There are known prior bugs which leave junk at the end
> of the V4 superblock; we don't need to actually fail the
> verification in this case if other checks pan out ok.
> 
> So if this is a secondary superblock, and the primary
> superblock doesn't indicate that this is a V5 filesystem,
> don't treat this as an actual checksum failure.
> 
> We should probably check the garbage condition as
> we do in xfs_repair, and possibly warn about it
> or self-heal, but that's a different scope of work.
> 
> Stable folks: This can go back to v3.10, which is what
> introduced the sb CRC checking that is tripped up by old,
> stale, incorrect V4 superblocks w/ unzeroed bits.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied this one.  Thanks.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
