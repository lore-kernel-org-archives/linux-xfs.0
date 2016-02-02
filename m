Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0E2A27CB1
	for <xfs@oss.sgi.com>; Tue,  2 Feb 2016 05:20:54 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E41398F8033
	for <xfs@oss.sgi.com>; Tue,  2 Feb 2016 03:20:50 -0800 (PST)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id KFqg2Q8DHIDh75h8 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 02 Feb 2016 03:20:48 -0800 (PST)
Date: Tue, 2 Feb 2016 12:20:46 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: stop using ioends for direct write completions
Message-ID: <20160202112046.GB28777@lst.de>
References: <1452766237-2314-1-git-send-email-hch@lst.de>
	<20160128131656.GB14876@infradead.org>
	<20160129141232.GA43184@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160129141232.GA43184@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@lst.de>, darrick.wong@oracle.com

On Fri, Jan 29, 2016 at 09:12:33AM -0500, Brian Foster wrote:
> My understanding is that the original requirement for ioends here was to
> track the state necessary in order to defer (to wq) completions that had
> to allocate transactions. Eventually, the deferred buffer state was
> implemented and we no longer required an ioend for that, so we removed
> the ioends here:
> 
>   2ba6623 xfs: don't allocate an ioend for direct I/O completions
> 
> Then just a couple months later, we merged the following to re-add the
> ioend into the dio path:
> 
>   d5cc2e3f xfs: DIO needs an ioend for writes

And I complained about that one!  I didn't have time to provide a full
analysis and the patches around this one were criticial enough.  But this
patch has the analysis on why ioends are not needed and bad which should
have been the full review back then.  Note that this new version is
better than the old ioend removal as it does not just use the private
data as a boolean, but as a bitmask so that additional information
such as the COW status can be communicated.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
