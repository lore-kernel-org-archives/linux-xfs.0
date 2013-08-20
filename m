Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 735707FB8
	for <xfs@oss.sgi.com>; Tue, 20 Aug 2013 11:01:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5E85D8F8037
	for <xfs@oss.sgi.com>; Tue, 20 Aug 2013 09:01:06 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id FcFvrzlSxvGfFvKP for <xfs@oss.sgi.com>;
	Tue, 20 Aug 2013 09:01:04 -0700 (PDT)
Date: Tue, 20 Aug 2013 18:00:57 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v3 3/5] mm: Notify filesystems when it's time to apply a
	deferred cmtime update
Message-ID: <20130820160057.GC2862@quack.suse.cz>
References: <cover.1376679411.git.luto@amacapital.net>
	<ec267e95fd21891986373c7af1c72b4c8b507332.1376679411.git.luto@amacapital.net>
	<20130820023615.GE6023@dastard>
	<CALCETrV-Toj-NGpmWnmoUbCwrMUXOSbjQdYsSVuTiH+2dEgPTQ@mail.gmail.com>
	<20130820040814.GH6023@dastard>
	<CALCETrWreWBwKdKS2w=fS+MwdaZv1eEsKjYo=P9eeXe7fZS6Jw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CALCETrWreWBwKdKS2w=fS+MwdaZv1eEsKjYo=P9eeXe7fZS6Jw@mail.gmail.com>
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
To: Andy Lutomirski <luto@amacapital.net>
Cc: Theodore Ts'o <tytso@mit.edu>, Dave Hansen <dave.hansen@linux.intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, Tim Chen <tim.c.chen@linux.intel.com>

On Mon 19-08-13 21:14:44, Andy Lutomirski wrote:
> >> I could require ->writepages *and* ->flush_cmtime to handle the time
> >> update, but that would complicate non-transactional filesystems.
> >> Those filesystems should just flush cmtime at the end of writepages.
> >
> > do_writepages() is the wrong place to do such updates - we can get
> > writeback directly through .writepage, so the time updates need to
> > be in .writepage. That first .writepage call will clear the bit on
> > the mapping, so it's only done on the first call to .writepage on
> > the given mapping.
> 
> Last time I checked, all the paths that actually needed the timestamp
> update went through .writepages.  I'll double-check.
  kswapd can call just .writepage to do the writeout so timestamp update
should be handled there as well. Otherwise all pages in a mapping can be
cleaned without timestamp being updated.

Which btw made me realize that even your scheme doesn't completely make
sure timestamp is updated after mmap write - if you have pages 0 and 1, you
write to both of them - CMTIME flag gets set. Then fsync_range(fd, 0, 4096)
is called. We write the page 0, writeprotect it, update timestamps. But
page 1 is still writeable so writes to it won't set CMTIME flag, neither
update the timestamp... Not that I think this can be reasonably solved but
it is a food for thought.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
