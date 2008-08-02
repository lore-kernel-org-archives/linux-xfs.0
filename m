Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 02 Aug 2008 08:33:51 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m72FXnjW012065
	for <xfs@oss.sgi.com>; Sat, 2 Aug 2008 08:33:49 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 85B68353CDF
	for <xfs@oss.sgi.com>; Sat,  2 Aug 2008 08:35:02 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id V4VEmyKZfFRJKZ8j for <xfs@oss.sgi.com>; Sat, 02 Aug 2008 08:35:02 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m72FZ3IF021004
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sat, 2 Aug 2008 17:35:04 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m72FZ31Y021002
	for xfs@oss.sgi.com; Sat, 2 Aug 2008 17:35:03 +0200
Date: Sat, 2 Aug 2008 17:35:03 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 16/21] implement generic xfs_btree_lshift
Message-ID: <20080802153503.GE19689@lst.de>
References: <20080729193132.GQ19104@lst.de> <20080730062422.GQ13395@disturbed> <20080801195249.GJ1263@lst.de> <20080802012803.GO6201@disturbed>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080802012803.GO6201@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Sat, Aug 02, 2008 at 11:28:03AM +1000, Dave Chinner wrote:
> It might make sense to go back to a single implementation,
> though at the time I did it it made sense to split the move/copy
> operations because it made both cases simpler. Seeing as you've
> stuck more closely to the original structure of the code, the
> distinction is not as great as so it might be best to go back to a
> single memmove based interface.

Btw, one other idea I still have in my mind is to add rec_len
and key_len methods to the core btree code, that way quite a few
methods (ptr_addr, key_addr, rec_addr, set_key, move_keys, move_recs,
copy_keys, copy_recs, log_keys, and log_recs) could be implemented
in common code, leaving the actual btree implementations really small.
