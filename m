Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 01BE77F5E
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2014 19:29:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D337B8F8071
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2014 17:29:27 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	pYoz8oqk3VyermeK for <xfs@oss.sgi.com>;
	Wed, 25 Jun 2014 17:29:13 -0700 (PDT)
Date: Thu, 26 Jun 2014 10:28:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Metadata CRC error upon unclean unmount
Message-ID: <20140626002859.GQ9508@dastard>
References: <CA+o=1OW0OXhzU+b9ACMZzg0dq=B7BSj+yPXD2Vrr9F6mWK8ruQ@mail.gmail.com>
	<20140624201946.GJ9508@dastard>
	<CA+o=1OVnORG0Ah3Zx8dkGzs7vtT7odRH=v12KqtLW0MP_3oHjQ@mail.gmail.com>
	<20140625012144.GK9508@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140625012144.GK9508@dastard>
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
To: Fanael Linithien <fanael4@gmail.com>
Cc: xfs@oss.sgi.com

On Wed, Jun 25, 2014 at 11:21:44AM +1000, Dave Chinner wrote:
> On Tue, Jun 24, 2014 at 11:50:52PM +0200, Fanael Linithien wrote:
> Ok, so the CRC corresponds to the version of the AGI that was logged
> at lsn = 0x30000017e. That means the version on disk is a partial
> update without a CRC recalculation. Ok, so how can that happen?
> 
> Given the lsn mismatch, I suspect log recovery has played a part as
> it will not update the LSN when replaying changes in the log. It
> should, however, always be attaching the appropriate verifier to
> the buffers being recovered so the CRC should be recalculated
> correctly.

Ok, I have confirmed that this is occurring and behaving correctly.

[   24.437878] XFS (vdb): Mounting V5 Filesystem
[   24.554429] XFS (vdb): Starting recovery (logdev: internal)
[   24.623466] XFS (vdb): xfs_agi_write_verify: lsn reset block 0x2
[   24.625263] XFS (vdb): xfs_btree_sblock_calc_crc: lsn reset block 0x8
[   24.627307] XFS (vdb): xfs_btree_sblock_calc_crc: lsn reset block 0x10
[   24.628729] XFS (vdb): xfs_btree_sblock_calc_crc: lsn reset block 0x18
[   24.630085] XFS (vdb): xfs_dir3_data_write_verify: lsn reset block 0x20000
[   24.631504] XFS (vdb): xfs_da3_node_write_verify: lsn reset block 0x20008
[   24.632935] XFS (vdb): xfs_dir3_data_write_verify: lsn reset block 0x20010
[   24.634360] XFS (vdb): xfs_dir3_data_write_verify: lsn reset block 0x20018
[   24.635622] XFS (vdb): xfs_dir3_free_write_verify: lsn reset block 0x201e0
[   24.636656] XFS (vdb): __write_verify: lsn reset block 0x201e8
[   24.637510] XFS (vdb): __write_verify: lsn reset block 0x201f0
[   24.638365] XFS (vdb): xfs_dir3_data_write_verify: lsn reset block 0x201f8
[   24.639378] XFS (vdb): xfs_dir3_data_write_verify: lsn reset block 0x202c0
[   24.640397] XFS (vdb): __write_verify: lsn reset block 0x202c8
[   24.641260] XFS (vdb): xfs_dir3_data_write_verify: lsn reset block 0x202d0
[   24.664330] XFS (vdb): Ending recovery (logdev: internal)

But that also confirms that log recovery is recalculating the CRC
after replaying changes into that block:

# xfs_db -c "agi 0" -c "p lsn" -c "p crc" /dev/vdb
lsn = 0xffffffffffffffff
crc = 0x788c4f63 (correct)

So the common log recovery path for buffers is working as it is
designed to do.

What I still don't understand yet is how changes after this recovery
phase are getting to disk without updating the CRC. That implies
buffers without verifiers being written....

More debug to come...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
