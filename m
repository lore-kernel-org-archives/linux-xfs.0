Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="R+ElWhJl"
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20F572D5E
	for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2023 13:08:42 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1cfbda041f3so28207805ad.2
        for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2023 13:08:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1701205721; x=1701810521; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0maxqd6QUCXYfuuM92Wu4ssCdvyg3J3K+gOKQF5YwAg=;
        b=R+ElWhJlqF9yDNUI7WxxEZIo4uwFygXlmFlO3Rfhn0iilkFZtXE47gRfDDmZq0kHny
         vzO2/0+cHrV8d7TBfGrsOpNs7I/ZbwXxnHUMZH2G1ESXT3yCh1Dt8n0Smk+ZKrmNs0i5
         mmAyJZ/D4iPizgWCqWq1nnQv9iQjzekGBMxTZtv4erLjBFKoqwAnzH3l0RBvAp431byp
         JTTHKUowip2n/Hh/K7SH8x+sn9OFwAbT10V4IJUrtlo5P6LZ/63zQddeEo/7az2Wb8ru
         pvqGyO4uDnGlRmy8+ERXQLv+gD2IsOigSFkihh5KR9TP5MYkwNTITh3MWKzfW5ym0QsD
         dBxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701205721; x=1701810521;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0maxqd6QUCXYfuuM92Wu4ssCdvyg3J3K+gOKQF5YwAg=;
        b=RC9mT6xaas7qygWL0inIRuW9BORbRzZ4IZ8dDwSmp5G5fDyBZ/bXtcmmKLFpX1vsLS
         q9mm6Spwnm50vYeg+EjApknzRG6jni+aGf+J2dCS1+Iw6UkLsaW7JuRQsrChxLSb4wH9
         /lAEK/3mxhF49SfXxplLMb6e6CbQjud8PSuFJal94h8D1u6REf0fCL21d4/DENjH9toL
         SeiCYu/2JeiVUiEw6C5/AA0J73jD/Nco/0tc/5N/9/ArzI5VbQg0MKY+ktZ7Ea1szWs+
         cQjwC3GNAd8MrYFgG8jfgBr/KLzRP4c2l957/P7QEuQuYdciOo0EgFPMaWrLXpvDBuOB
         ux6A==
X-Gm-Message-State: AOJu0YyMdwWVOqORr/021OdgetG/xzin4JdemztXZzySHEVWgv+ufYNV
	NsVVRZoPWijw+YxBBO+Knpddfw==
X-Google-Smtp-Source: AGHT+IHn0Q6ZzPVmcfzv7nzaYBge1d1cok3N/3eRaEEqQM4wqplzs8UYbKQbZeR9iSR8LXd/zewMqg==
X-Received: by 2002:a17:903:183:b0:1cf:6590:70 with SMTP id z3-20020a170903018300b001cf65900070mr21526921plg.23.1701205721403;
        Tue, 28 Nov 2023 13:08:41 -0800 (PST)
Received: from dread.disaster.area (pa49-180-125-5.pa.nsw.optusnet.com.au. [49.180.125.5])
        by smtp.gmail.com with ESMTPSA id bf11-20020a170902b90b00b001cfb971edfbsm6613923plb.156.2023.11.28.13.08.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Nov 2023 13:08:40 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1r85Jt-001Dyy-34;
	Wed, 29 Nov 2023 08:08:37 +1100
Date: Wed, 29 Nov 2023 08:08:37 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	Dave Chinner <dchinner@redhat.com>
Subject: Re: XBF_DONE semantics
Message-ID: <ZWZW1bb+ih16tU+5@dread.disaster.area>
References: <20231128153808.GA19360@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231128153808.GA19360@lst.de>

On Tue, Nov 28, 2023 at 04:38:08PM +0100, Christoph Hellwig wrote:
> Hi Darrick,
> 
> while reviewing your online repair series I've noticed that the new
> xfs_buf_delwri_queue_here helper sets XBF_DONE in addition to waiting
> for the buffer to go off a delwri list, and that reminded me off an
> assert I saw during my allocator experiments, where
> xfs_trans_read_buf_map or xfs_buf_reverify trip on a buffer that doesn't
> have XBF_DONE set because it comes from an ifree transaction (see
> my current not fully thought out bandaid below).

I'll come back to the bug later, because I know what it is and I
just haven't had time to fix it yet. I'll address XBF_DONE first.

XBF_DONE means the data in the buffer is valid. It's equivalent to
the uptodate bit in a folio. It has no other meaning.

> The way we currently set and check XBF_DONE seems a bit undefined.  The
> one clear use case is that read uses it to see if a buffer was read in.

Yes.

> But places that use buf_get and manually fill in data only use it in a
> few cases. 

Yes. the caller of buf_get always needs to set XBF_DONE if it is
initialising a new buffer ready for it to be written. It should be
done before the caller drops the buffer lock so that no other lookup
can see the buffer in the state of "contains valid data but does not
have XBF_DONE set".

Also, there are cases where we use buf_get but we don't care about
the contents being initialised because we are invalidating
the buffer and need the buffer+buf_log_item to log the invalidation
to the journal.

In these cases we just don't care that the contents
are valid, because xfs_trans_binval() calls xfs_buf_stale() to
invalidate the contents and that removes the XBF_DONE flag. We do
this in places like inode chunk removal to invalidate the cluster
buffers to ensure they are written back after then chunk has been
freed.

.... and this brings us to the bug that you mentioned about an ifree
transaction leaving an inode cluster buffer in cache without
XBF_DONE set....

The issue is xfs_inode_item_precommit() attaching inodes to the
cluster buffer. In the old days before we delayed inode logging to
the end of the ifree transaction, the order was:

xfs_ifree
  xfs_difree(ip)
    xfs_imap_to_bp()
      xfs_trans_buf_read()
    xfs_trans_brelse()
  xfs_trans_log_inode(ip)
  xfs_ifree_cluster(ip)
    for each incore inode {
      set XFS_ISTALE
    }
    for each cluster buffer {
      xfs_trans_buf_get()
      xfs_trans_binval()
    }
  xfs_trans_commit()

IOWs, the attachment of the inode to the cluster buffer in
xfs_trans_log_inode() occurred before both the inode was marked
XFS_ISTALE and the cluster buffer was marked XBF_STALE and XBF_DONE
was removed from it. Hence the lookup in xfs_difree() always found a
valid XBF_DONE buffer.

With the fixes for AGF->AGI->inode cluster buffer locking order done
a while back, we moved the processing that was done in
xfs_trans_log_inode() to xfs_inode_item_precommit(), which is called
from xfs_trans_commit(). This moved the xfs_imap_to_bp() call when
logging th einode from before the cluster invalidation to after it.

The result is that imap_to_bp() now finds the inode cluster buffer
in memory (as it should), but it has been marked stale (correctly!)
and xfs_trans_buf_read_map() freaks out over that (again,
correctly!).

The key to triggering this situation is that the inode cluster
buffer needs to be written back between the unlink() syscall and the
inactivation processing that frees the cluster buffer. Inode cluster
buffer IO completion removes the inodes from the cluster buffer, so
when they are next dirtied they need to be re-added. If this inode
cluster buffer writeback coincides with the transaction removing of
the last inode from an inode chunk and hence freeing the inode
chunk, we end up with this stiuation occurring and assert failures
in xfs_trans_read_buf_map().

So, like I said: I know what the bug is, I worked it out from the
one time one of my test machines tripped over it about 4 weeks ago,
but I just haven't had the time since then to work out a fix.

I suspect that we can check XFS_ISTALE in xfs_inode_item_precommit()
and do something different, but I'd much prefer that the inode still
gets added to the inode cluster buffer and cleaned up with all the
other XFS_ISTALE indoes on the cluster buffer at journal commit
completion time. Maybe we can pass a new flag to xfs_imap_to_bp() to
say "stale buffer ok here" or something similar, because I really
want the general case of xfs_trans_buf_read_map() to fail loudly if
a buffer without XBF_DONE is returned....

> Do we need to define clear semantics for it?  Or maybe
> replace with an XBF_READ_DONE flag for that main read use case and
> then think what do do with the rest?

To me, the semantics of XBF_DONE are pretty clear. Apart from fixing
the bug you are seeing, I'm not sure that anything really needs to
change....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
