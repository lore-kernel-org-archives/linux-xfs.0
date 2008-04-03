Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 03 Apr 2008 10:36:22 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m33HaAPQ030015
	for <xfs@oss.sgi.com>; Thu, 3 Apr 2008 10:36:13 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B97BB903C0B
	for <xfs@oss.sgi.com>; Thu,  3 Apr 2008 10:21:23 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id ZMEbgoFbpoefCx1l for <xfs@oss.sgi.com>; Thu, 03 Apr 2008 10:21:23 -0700 (PDT)
Date: Thu, 3 Apr 2008 10:56:38 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/7] XFS: Return case-insensitive match for dentry cache
Message-ID: <20080403145638.GA3373@infradead.org>
References: <20080402062508.017738664@chook.melbourne.sgi.com> <20080402062708.654277049@chook.melbourne.sgi.com> <20080403052209.GR103491721@sgi.com> <20080403164120.87e2e44b.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080403164120.87e2e44b.sfr@canb.auug.org.au>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Chinner <dgc@sgi.com>, Barry Naujok <bnaujok@sgi.com>, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

On Thu, Apr 03, 2008 at 04:41:20PM +1100, Stephen Rothwell wrote:
> I haven't really been following this, but I was wondering if this could
> be made generic and used in the CIFS code as well.  They currently (I
> think) have an awefull hack where they update the name in the dentry
> (which throws a warning about dropping a const attribute in the memcpy).

yes, it should.  the new lookup higher level code added here should
probably be a helper in dcache.c although that'll need a new abstraction
for the unicode table handling.
