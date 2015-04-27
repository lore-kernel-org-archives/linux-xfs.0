Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EB3F37F56
	for <xfs@oss.sgi.com>; Mon, 27 Apr 2015 18:38:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DD8D88F8037
	for <xfs@oss.sgi.com>; Mon, 27 Apr 2015 16:37:58 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	DgGzO8eSeq2ZxSCr for <xfs@oss.sgi.com>;
	Mon, 27 Apr 2015 16:37:56 -0700 (PDT)
Date: Tue, 28 Apr 2015 09:37:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Proposal/RFC: new metadata-specific UUID for V5 supers
Message-ID: <20150427233754.GT21261@dastard>
References: <553EB3D1.10602@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <553EB3D1.10602@sandeen.net>
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
Cc: xfs-oss <xfs@oss.sgi.com>

On Mon, Apr 27, 2015 at 05:10:25PM -0500, Eric Sandeen wrote:
> Wanted to float this & see what people think...
> 
> Today, it's impossible (FSVO impossible) to change a V5 filesystem's
> UUID, because that UUID is stamped into every bit of metadata.  If
> not impossible, it's unimplemented and any implementation would be
> terribly inefficient.
> 
> With 20/20 hindsight, an sb_meta_uuid field, separate from the sb_uuid
> field that is userspace-visible, would have avoided this problem.

Actually, it was done like this intentionally.

AFAIA, the only time you need to change the UUID is if you are doing
clones or snapshots of the filesystem. If you are doing a clone,
then we are reading and writing every piece of metadata anyway, so
we /could/ add support for modifying the UUIDs to the cloning
program during the write. e.g. xfs_copy already does this UUID
modification for non-crc filesystems, so we could modify it to reuse
the db/metadump metadata walk to rewrite the UUIDs and recalculate
the CRCs once the copy has been done. That's the clone problem
solved.

If we have a snapshot, then changing the UUID means a COW of every
single metadata block as we change them, which will cause all sorts
of fragmentation and duplication problems in the underlying snapshot
device due to the random 4k distribution of the metadata throughout
the filesystem. So we take even more of a penalty there, as it also
affects runtime performance and space usage of the underlying
device. Hence I'm not sure we actually want to change behaviour
here.

> We can certainly add it, but it'd need to be an incompat change, because
> old kernels would see this as catastrophic mismatching of every bit
> of metadata on a V5 superblock filesystem.
> 
> Other than that little problem (o_O) it'd be trivial to implement.

So what you are proposing is a fixed UUID for metadata, and a
variable UUID for userspace presentation (i.e. blkid) and mount
checking? Doesn't that defeat the purpose of the UUID which is to
identify the filesystem the metadata originated from? i.e. don't we
still need to change the internal metadata UUID if we want to retain
the original purpose of the UUID stamping in the metadata?

> Thoughts?

Can you describe the motivation for needing to change UUIDs? i.e.
what's the use case that has brought this up? I'd like to know if
there is a problem other than writable snapshots being required to
be mounted "-o nouuid", which we already require for read-only
snapshots (i.e "-o ro,norecovery,nouuid")?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
