Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 03 Apr 2008 10:15:05 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m33HEjPh023358
	for <xfs@oss.sgi.com>; Thu, 3 Apr 2008 10:14:46 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 16BDD90236B
	for <xfs@oss.sgi.com>; Thu,  3 Apr 2008 10:15:21 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id p6U2TnfXFpySXTXU for <xfs@oss.sgi.com>; Thu, 03 Apr 2008 10:15:21 -0700 (PDT)
Date: Thu, 3 Apr 2008 13:14:50 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/7] XFS: Unicode case-insensitive lookup implementation
Message-ID: <20080403171450.GB22385@infradead.org>
References: <20080402062508.017738664@chook.melbourne.sgi.com> <20080402062709.011126702@chook.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080402062709.011126702@chook.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

Validating file names is not the filesystem job.  In fact it's utterly
stupid, a unix filename is a sequence of bytes without special meaning
except for ., .., / and \0
