Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 244CF7F83
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2014 15:03:59 -0500 (CDT)
Message-ID: <53AC7CA9.9050505@sgi.com>
Date: Thu, 26 Jun 2014 15:03:53 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: Metadata CRC error upon unclean unmount
References: <CA+o=1OW0OXhzU+b9ACMZzg0dq=B7BSj+yPXD2Vrr9F6mWK8ruQ@mail.gmail.com>
	<20140624201946.GJ9508@dastard>
	<CA+o=1OVnORG0Ah3Zx8dkGzs7vtT7odRH=v12KqtLW0MP_3oHjQ@mail.gmail.com>
	<20140625012144.GK9508@dastard> <20140626002859.GQ9508@dastard>
In-Reply-To: <20140626002859.GQ9508@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Fanael Linithien <fanael4@gmail.com>, xfs@oss.sgi.com

On 06/25/14 19:28, Dave Chinner wrote:
> On Wed, Jun 25, 2014 at 11:21:44AM +1000, Dave Chinner wrote:
>> On Tue, Jun 24, 2014 at 11:50:52PM +0200, Fanael Linithien wrote:
>> Ok, so the CRC corresponds to the version of the AGI that was logged
>> at lsn = 0x30000017e. That means the version on disk is a partial
>> update without a CRC recalculation. Ok, so how can that happen?
>>
>> Given the lsn mismatch, I suspect log recovery has played a part as
>> it will not update the LSN when replaying changes in the log. It
>> should, however, always be attaching the appropriate verifier to
>> the buffers being recovered so the CRC should be recalculated
>> correctly.
>
> Ok, I have confirmed that this is occurring and behaving correctly.
>
> [   24.437878] XFS (vdb): Mounting V5 Filesystem
> [   24.554429] XFS (vdb): Starting recovery (logdev: internal)
> [   24.623466] XFS (vdb): xfs_agi_write_verify: lsn reset block 0x2
> [   24.625263] XFS (vdb): xfs_btree_sblock_calc_crc: lsn reset block 0x8
> [   24.627307] XFS (vdb): xfs_btree_sblock_calc_crc: lsn reset block 0x10
> [   24.628729] XFS (vdb): xfs_btree_sblock_calc_crc: lsn reset block 0x18
> [   24.630085] XFS (vdb): xfs_dir3_data_write_verify: lsn reset block 0x20000
> [   24.631504] XFS (vdb): xfs_da3_node_write_verify: lsn reset block 0x20008
> [   24.632935] XFS (vdb): xfs_dir3_data_write_verify: lsn reset block 0x20010
> [   24.634360] XFS (vdb): xfs_dir3_data_write_verify: lsn reset block 0x20018
> [   24.635622] XFS (vdb): xfs_dir3_free_write_verify: lsn reset block 0x201e0
> [   24.636656] XFS (vdb): __write_verify: lsn reset block 0x201e8
> [   24.637510] XFS (vdb): __write_verify: lsn reset block 0x201f0
> [   24.638365] XFS (vdb): xfs_dir3_data_write_verify: lsn reset block 0x201f8
> [   24.639378] XFS (vdb): xfs_dir3_data_write_verify: lsn reset block 0x202c0
> [   24.640397] XFS (vdb): __write_verify: lsn reset block 0x202c8
> [   24.641260] XFS (vdb): xfs_dir3_data_write_verify: lsn reset block 0x202d0
> [   24.664330] XFS (vdb): Ending recovery (logdev: internal)
>
> But that also confirms that log recovery is recalculating the CRC
> after replaying changes into that block:
>
> # xfs_db -c "agi 0" -c "p lsn" -c "p crc" /dev/vdb
> lsn = 0xffffffffffffffff
> crc = 0x788c4f63 (correct)
>
> So the common log recovery path for buffers is working as it is
> designed to do.
>
> What I still don't understand yet is how changes after this recovery
> phase are getting to disk without updating the CRC. That implies
> buffers without verifiers being written....
>
> More debug to come...
>
> Cheers,
>
> Dave.

Could an out of order CIL push cause this?

SGI saw sequence 2 (and sometimes 3/4) of the cil push get in front of 
cil push sequence 1. Looks like the setting of 
log->l_cilp->xc_ctx->commit_lsn in xlog_cil_init_post_recovery() lets 
this happen.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
