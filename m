Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E6DD27F5F
	for <xfs@oss.sgi.com>; Mon, 27 Apr 2015 20:27:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 82D1FAC001
	for <xfs@oss.sgi.com>; Mon, 27 Apr 2015 18:27:36 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	frbLahHgkEgDaTtf for <xfs@oss.sgi.com>;
	Mon, 27 Apr 2015 18:27:33 -0700 (PDT)
Date: Tue, 28 Apr 2015 11:20:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Proposal/RFC: new metadata-specific UUID for V5 supers
Message-ID: <20150428012003.GS15810@dastard>
References: <553EB3D1.10602@sandeen.net> <20150427233754.GT21261@dastard>
	<553ED9D8.4050106@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <553ED9D8.4050106@sandeen.net>
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

On Mon, Apr 27, 2015 at 07:52:40PM -0500, Eric Sandeen wrote:
> On 4/27/15 6:37 PM, Dave Chinner wrote:
> > On Mon, Apr 27, 2015 at 05:10:25PM -0500, Eric Sandeen wrote:
> >> Wanted to float this & see what people think...
> >>
> >> Today, it's impossible (FSVO impossible) to change a V5 filesystem's
> >> UUID, because that UUID is stamped into every bit of metadata.  If
> >> not impossible, it's unimplemented and any implementation would be
> >> terribly inefficient.
> >>
> >> With 20/20 hindsight, an sb_meta_uuid field, separate from the sb_uuid
> >> field that is userspace-visible, would have avoided this problem.
> > 
> > Actually, it was done like this intentionally.
> > 
> > AFAIA, the only time you need to change the UUID is if you are doing
> > clones or snapshots of the filesystem. If you are doing a clone,
> > then we are reading and writing every piece of metadata anyway, so
> > we /could/ add support for modifying the UUIDs to the cloning
> > program during the write. e.g. xfs_copy already does this UUID
> > modification for non-crc filesystems, so we could modify it to reuse
> > the db/metadump metadata walk to rewrite the UUIDs and recalculate
> > the CRCs once the copy has been done. That's the clone problem
> > solved.
> 
> Fair enough.
> 
> > If we have a snapshot, then changing the UUID means a COW of every
> > single metadata block as we change them, which will cause all sorts
> > of fragmentation and duplication problems in the underlying snapshot
> > device due to the random 4k distribution of the metadata throughout
> > the filesystem. So we take even more of a penalty there, as it also
> > affects runtime performance and space usage of the underlying
> > device. Hence I'm not sure we actually want to change behaviour
> > here.
> 
> This I'm not following.  Changing UUID by rewriting every piece
> would be painful in this case, yes.  I guess we're in violent agreement
> on this part?  (that changing the UUID of a RW snapshot would be nuts).
> 
> >> We can certainly add it, but it'd need to be an incompat change, because
> >> old kernels would see this as catastrophic mismatching of every bit
> >> of metadata on a V5 superblock filesystem.
> >>
> >> Other than that little problem (o_O) it'd be trivial to implement.
> > 
> > So what you are proposing is a fixed UUID for metadata, and a
> > variable UUID for userspace presentation (i.e. blkid) and mount
> > checking? Doesn't that defeat the purpose of the UUID which is to
> > identify the filesystem the metadata originated from? i.e. don't we
> > still need to change the internal metadata UUID if we want to retain
> > the original purpose of the UUID stamping in the metadata?
> 
> No, I don't think so.  sb_uuid could be changed just like it always ever
> could, for any reason one might wish to change it; it'd be relatively
> trivial. sb_meta_uuid would be set at mkfs time, and would never change;
> it's the matching, immutable metadata consistency number.
> 
> sb_uuid is for external filesystem identification; sb_meta_uuid is for
> internal consistency.
> 
> If we got a metadata uuid mismatch from xfs_repair, xfs_db (or xfs_admin)
> could easily tell us what the sb_meta_uuid of any given filesystem might
> be, and we wouldn't care about the external identifier UUID for this purpose.

We already have a field for that - it's called the filesystem
label and the entire userspace infrastructure is already aware of
it. 

# blkid /dev/md0 /dev/sda1
/dev/md0: LABEL="root" UUID="91e3089c-f00f-4c56-ab5a-ea8f18b6c011" TYPE="xfs" 
/dev/sda1: LABEL="boot" UUID="509d4612-3bbc-4876-a6ac-1d5454ea074d" TYPE="ext2"
# $ ls -l /dev/disk/by-label
total 0
lrwxrwxrwx 1 root root 10 Mar 16 09:01 boot -> ../../sda1
lrwxrwxrwx 1 root root  9 Mar 16 09:01 root -> ../../md0
# man 5 fstab
.....
    Instead  of  giving  the  device  explicitly,  one  may indicate
    the (ext2 or xfs) filesystem that is to be mounted by its UUID
    or volume label (cf.  e2label(8) or xfs_admin(8)), writing
    LABEL=<label> or UUID=<uuid>, e.g., `LABEL=Boot'  or
    `UUID=3e6be9de-8139-11d1-9106-a43f08d823a6'.

> > what's the use case that has brought this up? I'd like to know if
> > there is a problem other than writable snapshots being required to
> > be mounted "-o nouuid", which we already require for read-only
> > snapshots (i.e "-o ro,norecovery,nouuid")?
> 
> Well, it's just the loss of ability to change UUID, which is something
> People Used To Do(tm), and now can't.  It does come up.  Honestly if it
> had been done from day 0, it'd be a no-brainer I think.  Doing it now,
> with an incompat flag, might not be a reasonable tradeoff.

I think that labels are a far better way of dealing with this
problem. Get rid of the UUID mount checking (and hence the nouuid
mount option), and tell people to use by-label instead of by-uuid to
identify their filesystems when doing clones and snapshots. Labels
make it much easier for humans to identify the filesystem than
UUIDs...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
