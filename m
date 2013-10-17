Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BC2A27F3F
	for <linux-xfs@oss.sgi.com>; Thu, 17 Oct 2013 15:17:12 -0500 (CDT)
Date: Thu, 17 Oct 2013 15:17:11 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH, RFC] xfs: be more forgiving of a v4 secondary sb w/
	junk in v5 fields
Message-ID: <20131017201711.GJ1935@sgi.com>
References: <520D1BA3.1050500@redhat.com> <20130815210018.GR6023@dastard>
	<520D44E7.1000905@sandeen.net> <520D592D.4040600@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <520D592D.4040600@redhat.com>
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
Cc: "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>, Eric Sandeen <sandeen@sandeen.net>

On Thu, Aug 15, 2013 at 05:41:49PM -0500, Eric Sandeen wrote:
> Today, if xfs_sb_read_verify encounters a v4 superblock
> with junk past v4 fields which includes data in sb_crc,
> it will be treated as a failing checksum and significant
> corruption.
> 
> There are known prior bugs which leave junk at the end
> of the superblock; we don't need to actually fail the
> verification in this case if other checks pan out ok.
> 
> So if this is a secondary superblock, and the primary
> superblock is not V5, don't treat this as a serious
> checksum failure.
> 
> We should probably check the garbage condition as
> we do in xfs_repair, and possibly warn about it
> or self-heal, but that's a different scope of work.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Eric... is the one you're talking about?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
