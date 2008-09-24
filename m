Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Sep 2008 11:04:12 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8OI4AXX030109
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 11:04:10 -0700
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id Tp1iDwxFSqxziJqy; Wed, 24 Sep 2008 11:05:41 -0700 (PDT)
Date: Wed, 24 Sep 2008 14:05:40 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: TAKE 985583 - make btree tracing generic
Message-ID: <20080924180540.GA28138@infradead.org>
References: <20080924074713.2A8EC58C52AE@chook.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080924074713.2A8EC58C52AE@chook.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

This commit forgot to add the new xfs_btree_trace.h file and thus breaks
the compile of btree tracing is enabled.
