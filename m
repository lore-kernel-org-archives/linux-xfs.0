Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 01 Aug 2007 04:17:28 -0700 (PDT)
Received: from mx1.suse.de (mx1.suse.de [195.135.220.2])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l71BHLbm016715
	for <xfs@oss.sgi.com>; Wed, 1 Aug 2007 04:17:24 -0700
Subject: Re: RFC: log record CRC validation
References: <20070725092445.GT12413810@sgi.com> <46A7226D.8080906@sgi.com>
	<46A8DF7E.4090006@agami.com> <20070726233129.GM12413810@sgi.com>
	<46A94963.7000103@agami.com> <20070727065930.GT12413810@sgi.com>
	<46AFD88E.9070403@agami.com> <20070801022418.GR31489@sgi.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 01 Aug 2007 14:11:58 +0200
In-Reply-To: <20070801022418.GR31489@sgi.com>
Message-ID: <p731wenpi7l.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Michael Nishimoto <miken@agami.com>, markgw@sgi.com, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

David Chinner <dgc@sgi.com> writes:
 
> I haven't looked at great depth into other structures in terms of
> implementation details. I know that if we use a 16 bit CRC on
> directories we can get away without a on-disk format change as the
> xfs_da_blkinfo structure has 16 bits of padding. However, given that
> directory block size can reach 64k, a CRC16 check is really only
> capable of single bit error detection. Hence I think we really need
> CRC32 here which means an on-disk format change.

When the directory format is changed it would be nice to also support
DT_* types at the same time. They can speed up some operations nicely
because file system walkers can avoid a stat() (and seek to the inode)
just to find out if a name is a directory or not. Right now there is
no space for this unfortunately.

-Andi
