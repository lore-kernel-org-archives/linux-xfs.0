Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 03 Apr 2008 15:50:55 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m33MoiWU005940
	for <xfs@oss.sgi.com>; Thu, 3 Apr 2008 15:50:48 -0700
Date: Thu, 3 Apr 2008 18:51:20 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/7] XFS: Name operation vector for hash and compare
Message-ID: <20080403225120.GA448@infradead.org>
References: <20080402062508.017738664@chook.melbourne.sgi.com> <20080402062707.797672682@chook.melbourne.sgi.com> <20080403012912.GO103491721@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080403012912.GO103491721@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Barry Naujok <bnaujok@sgi.com>, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

On Thu, Apr 03, 2008 at 11:29:12AM +1000, David Chinner wrote:
> > +#define xfs_dir_hashname(dp, n, l) \
> > +		((dp)->i_mount->m_dirnameops->hashname((n), (l)))
> > +
> > +#define xfs_dir_compname(dp, n1, l1, n2, l2) \
> > +		((dp)->i_mount->m_dirnameops->compname((n1), (l1), (n2), (l2)))
> > +
> 
> Static inline functions, please.

Or kill them completely.  I find the common Linux style that jut
opencodes method invocations a lot more readable.
