Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D8D94E73AF;
	Fri, 18 Sep 2026 11:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789731858; cv=none; b=s7XRn+si9h/MJnBVk2X9+nZrhLN1WKruX7WZiZoV/+4UFyLEIv9OaTUjU8XQSBjuXIcUny4D6Oq+LLRa2carcb51kUfsWUfiTY7vkcBd0HIvxTVKl0f8425CeFfuCVTh/2g4YpiiCzyhQSF/5fmawHWP3FsQoiFQtTr2ft5DMLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789731858; c=relaxed/simple;
	bh=MbAuGLR6IyXXEzqjalXjozskcbk8rLHdZrNkFg2Qk+k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LuJ/f/BmTkrPkF7NtV+pFIrT/2ISRoz7bMRdbhbZiLNQajn2kMy3ywZTSI1Ln2csxxpuRK0a3XU++9yzDLsWOjnjnsDQbS8I0FypO/VtuCz4wzciFE39lYst05Rdi5YI3yUAkw7gMPh479pWzWiWA7JIG9150IgCqokuXPKWmqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ih9X3Zzs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ih9X3Zzs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D91F1F00893;
	Fri, 18 Sep 2026 11:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789731856;
	bh=Do1tuTNTzX2QLjpWKaNXPZ78GPW84geW/qG9bZOwISM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ih9X3Zzsa1Uar/0zKKbFHY7WhndK1+hd1YEMZCODG70r/73e/Aa2U2J0F8yql1AdK
	 WpyemRrj7waBCSEaHCKQmJ6/ApVB5LPAvVDmrX88jpRcgDpYYTkM7aP+Y4Um5BlNDz
	 rSW8dpGlZ0QzsaR/y0nR5XHfXIFYT24cyLCIvk9A3QVtaQFy1pd3pTwXEO/lB5gjoQ
	 DS+w8o69yZ87mA+TuPK0vcY9c2nExRJ2aiokoptMRdWjQmqERScjAqzt274Wqx1zvG
	 ei7WT0yJLTBNr7Q8SNxRPIjckKmFf19M4KHshiNqIqWH89D5eX5QijX+9r86khfLYR
	 RPqaOXlsTk3cQ==
Date: Fri, 18 Sep 2026 13:44:12 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Lalit Shankar Chowdhury <lalitshankarch@gmail.com>, 
	"open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfs: replace kvmalloc_array with kvzalloc_objs
Message-ID: <aq0i-bfEEMpwJ_Dk@nidhogg.toxiclabs.cc>
References: <20260917200835.31027-1-lalitshankarch@gmail.com>
 <aqzHPqgh-rKqHRo-@nidhogg.toxiclabs.cc>
 <aq0dnoWhkq9JZkiu@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aq0dnoWhkq9JZkiu@infradead.org>

On Fri, Sep 18, 2026 at 04:16:46AM -0700, Christoph Hellwig wrote:
> On Fri, Sep 18, 2026 at 07:16:32AM +0200, Carlos Maiolino wrote:
> > On Thu, Sep 17, 2026 at 08:08:35PM +0000, Lalit Shankar Chowdhury wrote:
> > > Replace kvmalloc_array() with the more concise kvzalloc_objs()
> > > implementation.
> > > 
> > > Signed-off-by: Lalit Shankar Chowdhury <lalitshankarch@gmail.com>
> > 
> > NAK...
> > 
> > This is used to allocate composite objects managed through a
> > slab cache. This is not for fundamental basic data types....
> 
> I don't think so.  While the naming of the helper is a bit
> unfortunate, it is intended for allocating arrays.
> 
> But this function really should not exist, instead bitmap_alloc/free
> should be switched to th kvmalloc family so that it will just work
> for large allocations and we can kill the wrappers in XFS.
> 

You meant something like this? Leaving xfs_alloc_bucket_bitmap() looks
a bit better for me, to avoid overly long indentation.
I don't think there are free_bitmap_bucket though, buckets are straight
kvfree()'ed.


diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index 28c1e48909fa..864020603dfb 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -1234,14 +1234,6 @@ xfs_calc_open_zones(
 	return 0;
 }
 
-static unsigned long *
-xfs_alloc_bucket_bitmap(
-	struct xfs_mount	*mp)
-{
-	return kvmalloc_array(BITS_TO_LONGS(mp->m_sb.sb_rgcount),
-			sizeof(unsigned long), GFP_KERNEL | __GFP_ZERO);
-}
-
 static struct xfs_zone_info *
 xfs_alloc_zone_info(
 	struct xfs_mount	*mp)
@@ -1260,7 +1252,10 @@ xfs_alloc_zone_info(
 	init_waitqueue_head(&zi->zi_zone_wait);
 	spin_lock_init(&zi->zi_used_buckets_lock);
 	for (i = 0; i < XFS_ZONE_USED_BUCKETS; i++) {
-		zi->zi_used_bucket_bitmap[i] = xfs_alloc_bucket_bitmap(mp);
+		zi->zi_used_bucket_bitmap[i] =
+			kvmalloc_array(BITS_TO_LONGS(mp->m_sb.sb_rgcount),
+					sizeof(unsigned long),
+					GFP_KERNEL | GFP_ZERO);
 		if (!zi->zi_used_bucket_bitmap[i])
 			goto out_free_bitmaps;
 	}
