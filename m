Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 08 Apr 2008 04:45:15 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m38Bj6A8014833
	for <xfs@oss.sgi.com>; Tue, 8 Apr 2008 04:45:08 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E61FB760290
	for <xfs@oss.sgi.com>; Tue,  8 Apr 2008 04:45:44 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id 3LnLNaYIl5YGHOrW for <xfs@oss.sgi.com>; Tue, 08 Apr 2008 04:45:44 -0700 (PDT)
Date: Tue, 8 Apr 2008 07:45:13 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/7] XFS: case-insensitive lookup and Unicode support
Message-ID: <20080408114513.GA31734@infradead.org>
References: <20080402062508.017738664@chook.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080402062508.017738664@chook.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

btw, a little comment on how to proceed.  After your xfs_name patch it
would be good to get the nameops and leafn cleanup in as almost
independent cleanups and then the ascii only CI but already using the
complex and correct lookup method.  I think unicocde will take a bit
longer to sort out and getting the simpler bit in first would be
helpful.
