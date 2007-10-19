Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 18 Oct 2007 18:27:39 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9J1RRgn004695
	for <xfs@oss.sgi.com>; Thu, 18 Oct 2007 18:27:29 -0700
Message-ID: <47180922.4040709@sgi.com>
Date: Fri, 19 Oct 2007 11:32:18 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: review: use correct buffer flags when reading superblock
References: <470C8F5B.90705@sgi.com> <20071010093451.GA7655@infradead.org> <20071010112505.GH23367404@sgi.com> <20071018154649.GA16837@infradead.org>
In-Reply-To: <20071018154649.GA16837@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Wed, Oct 10, 2007 at 09:25:06PM +1000, David Chinner wrote:
>>> Where are these set up in the first time?  AFAICS the buffer only written
>>> out by xfs_unmountfs_writesb, xfs_syncsub and xfs_trans_log_buf, and all
>>> these should only ever happen after log recovery has finished.
>> It can also be written by xfsbufd when it has been bdwrite()
>> or as a result of log tail pushing.
> 
> Hmm, true.
> 
>> Because the superblock buffer is XBF_FS_MANAGED, it does not get
>> torn down when it is clean and has no references, so the XBF_ASYNC
>> flag never gets cleared unless the fs specifically clears it. If the
>> superblock is then not recovered out of any further transactions
>> during recovery after xfsbufd flushed it, the XBF_ASYNC flag remains
>> set for the re-read that is issued in xlog_do_recover() and we
>> hang.....
> 
> Makes sense as an explanation.  I still don't really like patch, maybe
> we should always clear the ASYNC flag in the b_iodone callback?
> 

That sounds like a good idea.  Or get rid of the XBF_FS_MANAGED special
case and get a new fresh buffer each time.
