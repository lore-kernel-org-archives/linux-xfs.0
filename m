Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8KI9qWY075338 for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 13:09:52 -0500
Date: Tue, 20 Sep 2011 14:09:50 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] xfs: Check the return value of xfs_trans_get_buf()
Message-ID: <20110920180950.GA1327@infradead.org>
References: <1316527015.9298.60.camel@chandra-lucid.austin.ibm.com>
	<20110920150029.GA5239@infradead.org>
	<1316541954.9298.65.camel@chandra-lucid.austin.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1316541954.9298.65.camel@chandra-lucid.austin.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, Alex Elder <aelder@sgi.com>, XFS Mailing List <xfs@oss.sgi.com>

On Tue, Sep 20, 2011 at 01:05:54PM -0500, Chandra Seetharaman wrote:
> 
> Hi Christoph,
> 
> I do not understand. Can you elaborate on what needs to be done.

All callers that do the xfs_trans_binval only really care about buffers
that already exist.  So we don't even have to allocate a new buffer
if it isn't in memory yet - note that it generally will be given that
the buffer is attached to the transaction.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
