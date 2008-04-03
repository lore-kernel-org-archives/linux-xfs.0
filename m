Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 03 Apr 2008 16:00:11 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m33N02nv009527
	for <xfs@oss.sgi.com>; Thu, 3 Apr 2008 16:00:02 -0700
Received: from mail2.shareable.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EA5CC910E62
	for <xfs@oss.sgi.com>; Thu,  3 Apr 2008 16:00:38 -0700 (PDT)
Received: from mail2.shareable.org (mail2.shareable.org [80.68.89.115]) by cuda.sgi.com with ESMTP id VKd1ByEt16FYACtZ for <xfs@oss.sgi.com>; Thu, 03 Apr 2008 16:00:38 -0700 (PDT)
Date: Fri, 4 Apr 2008 00:00:04 +0100
From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH 5/7] XFS: Unicode case-insensitive lookup implementation
Message-ID: <20080403230003.GA3422@shareable.org>
References: <20080402062508.017738664@chook.melbourne.sgi.com> <20080402062709.011126702@chook.melbourne.sgi.com> <20080403171450.GB22385@infradead.org> <20080403222059.GU103491721@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080403222059.GU103491721@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Barry Naujok <bnaujok@sgi.com>, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

David Chinner wrote:
> On Thu, Apr 03, 2008 at 01:14:50PM -0400, Christoph Hellwig wrote:
> > Validating file names is not the filesystem job.  In fact it's utterly
> > stupid, a unix filename is a sequence of bytes without special meaning
> > except for ., .., / and \0
> 
> So you're suggesting that we should rely on userspace being bug free
> and always only using valid unicode sequences in it's names?

You can bet that one person's "invalid unicode sequence" will have
been used as a valid filename on someone else's filesystem even using
unicode.  Meanings of "invalid unicode sequence" vary (a lot)
depending on which standard you follow.  Annoyance will come when they
try to copy the directory.

Such things are no great surprise on Windows and MacOS (both of which
do even worse things than rejecting sequences), but in POSIX land we
expect things like that to work.

The rules for ., .., / and \0, and accepting the rest as a blob, have
been well defined and understood for a long time.

-- Jamie
