Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3UMNwaY141059 for <xfs@OSS.SGI.com>; Sat, 30 Apr 2011 17:23:59 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 246B815CE27C
	for <xfs@OSS.SGI.com>; Sat, 30 Apr 2011 15:27:32 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id SAV2KQMI0UnwCGFW for <xfs@OSS.SGI.com>;
	Sat, 30 Apr 2011 15:27:32 -0700 (PDT)
Date: Sun, 1 May 2011 08:27:17 +1000
From: NeilBrown <neilb@suse.de>
Subject: Re: RAID6 r-m-w, op-journaled fs, SSDs
Message-ID: <20110501082717.5116e575@notabene.brown>
In-Reply-To: <19900.10868.583555.849181@tree.ty.sabi.co.UK>
References: <19900.10868.583555.849181@tree.ty.sabi.co.UK>
Mime-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Peter Grandi <pg_xf2@xf2.for.sabi.co.UK>
Cc: Linux RAID <linux-raid@vger.kernel.org>, Linux fs JFS <jfs-discussion@lists.SourceForge.net>, Linux fs XFS <xfs@oss.sgi.com>

On Sat, 30 Apr 2011 16:27:48 +0100 pg_xf2@xf2.for.sabi.co.UK (Peter Grandi)
wrote:

> While I agree with BAARF.com arguments fully, I sometimes have
> to deal with legacy systems with wide RAID6 sets (for example 16
> drives, quite revolting) which have op-journaled filesystems on
> them like XFS or JFS (sometimes block-journaled ext[34], but I
> am not that interested in them for this).
> 
> Sometimes (but fortunately not that recently) I have had to deal
> with small-file filesystems setup on wide-stripe RAID6 setup by
> morons who don't understand the difference between a database
> and a filesystem (and I have strong doubts that RAID6 is
> remotely appropriate to databases).
> 
> So I'd like to figure out how much effort I should invest in
> undoing cases of the above, that is how badly they are likely to
> be and degrade over time (usually very badly).
> 
> First a couple of question purely about RAID, but indirectly
> relevant to op-journaled filesystems:
> 
>   * Can Linux MD do "abbreviated" read-modify-write RAID6
>     updates like for RAID5? That is where not the whole stripe
>     is read in, modified and written, but just the block to be
>     updated and the parity wblocks.

No.  (patches welcome).

> 
>   * When reading or writing part of RAID[456] stripe for example
>     smaller than a sector, what is the minimum unit of transfer
>     with Linux MD? The full stripe, the chunk containing the
>     sector, or just the sector containing the bytes to be
>     written or updated (and potentially the parity sectors)? I
>     would expect reads to always read just the sector, but not
>     so sure about writing.

1 "PAGE" - normally 4K.


> 
>   * What about popular HW RAID host adapter (e.g. LSI, Adaptec,
>     Areca, 3ware), where is the documentation if any on how they
>     behave in these cases?
> 
> Regardless, op-journaled file system designs like JFS and XFS
> write small records (way below a stripe set size, and usually
> way below a chunk size) to the journal when they queue
> operations, even if sometimes depending on design and options
> may "batch" the journal updates (potentially breaking safety
> semantics). Also they do small write when they dequeue the
> operations from the journal to the actual metadata records
> involved.

The ideal config for a journalled filesystem is for put the journal on a
separate smaller lower-latency device.  e.g. a small RAID1 pair.

In a previous work place I had good results with:
  RAID1 pair of small disks with root, swap, journal
  Large RAID5/6 array with bulk of filesystem.

I also did data journalling as it helps a lot with NFS.



> 
> How bad can this be when the journal is say internal for a
> filesystem that is held on wide-stride RAID6 set? I suspect very
> very bad, with apocalyptic read-modify-write storms, eating IOPS.
> 
> I suspect that this happens a lot with SSDs too, where the role
> of stripe set size is played by the erase block size (often in
> the hundreds of KBytes, and even more expensive).
> 
> Where are studies or even just impressions of anedoctes on how
> bad this is?
> 
> Are there instrumentation tools in JFS or XFS that may allow me
> to watch/inspect what is happening with the journal? For Linux
> MD to see what are the rates of stripe r-m-w cases?

Not that I am aware of.


NeilBrown

> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
