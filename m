Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 Apr 2008 05:57:10 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m37Cv1En004477
	for <xfs@oss.sgi.com>; Mon, 7 Apr 2008 05:57:02 -0700
Date: Mon, 7 Apr 2008 08:57:38 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Patch] unique per-AG inode generation number initialisation
Message-ID: <20080407125738.GD27350@infradead.org>
References: <20080401231815.GW103491721@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080401231815.GW103491721@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

I don't really like this.  The chance to hit a previously used
generation seems to high.  What about making the first few bits
of each generation number a per-ag counter that's incremented anytime
we deallocate an inode cluster?
