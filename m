Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 20 Oct 2008 17:59:58 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9L0xsD6002057
	for <xfs@oss.sgi.com>; Mon, 20 Oct 2008 17:59:54 -0700
Message-ID: <48FD37C5.9040309@sgi.com>
Date: Tue, 21 Oct 2008 12:00:37 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: git tree updates....
References: <20081017054742.GH31761@disturbed> <20081020214310.GA26172@infradead.org>
In-Reply-To: <20081020214310.GA26172@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> While we at it, the b0rked m_vfsmount addition for DMAPI keeps on
> leaking into the git tree for -next..

Thanks for pointing that out - that shouldn't have happened.  It wont
be going to mainline.

The OSS xfs trees are in a bit of a mess and have been for a while.
I've been wanting to clean them up but figured it would be easier to
wait until we've moved over to git internally and then clone new trees.
