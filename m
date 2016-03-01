Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3731E7CB9
	for <xfs@oss.sgi.com>; Tue,  1 Mar 2016 14:45:50 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1311F8F8035
	for <xfs@oss.sgi.com>; Tue,  1 Mar 2016 12:45:41 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 8ohOA4cFHFLDfKQo (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 01 Mar 2016 12:45:39 -0800 (PST)
Date: Tue, 1 Mar 2016 12:45:38 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: ASSERT in xlog_find_verify_log_record during xfs/098
Message-ID: <20160301204538.GA6371@infradead.org>
References: <56D5E7DA.3080900@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56D5E7DA.3080900@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, xfs@oss.sgi.com

On Tue, Mar 01, 2016 at 01:04:58PM -0600, Eric Sandeen wrote:
> Should that assert even be there?  Looks like it's gracefully
> handled, I don't see offhand that anything should have caught
> this corruption earlier, and we don't really want to bug on disk
> corruption.  Am I missing something?

We used to have a couple of these, especially in log recovery - whoever
wrote this code probably though trapping on these corruptions for
a debug kernel makes sense.

I'm fine with dropping them, and a little audit for more of them
might not hurt.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
