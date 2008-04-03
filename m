Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 03 Apr 2008 12:06:19 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m33J6BVN023216
	for <xfs@oss.sgi.com>; Thu, 3 Apr 2008 12:06:12 -0700
Received: from lists.samba.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 37E8C90B8D8
	for <xfs@oss.sgi.com>; Thu,  3 Apr 2008 11:47:41 -0700 (PDT)
Received: from lists.samba.org (mail.samba.org [66.70.73.150]) by cuda.sgi.com with ESMTP id J6icIARE6dnAPTcC for <xfs@oss.sgi.com>; Thu, 03 Apr 2008 11:47:41 -0700 (PDT)
Date: Thu, 3 Apr 2008 11:47:39 -0700
From: Jeremy Allison <jra@samba.org>
Subject: Re: [PATCH 5/7] XFS: Unicode case-insensitive lookup implementation
Message-ID: <20080403184739.GB6100@samba1>
Reply-To: Jeremy Allison <jra@samba.org>
References: <20080402062508.017738664@chook.melbourne.sgi.com> <20080402062709.011126702@chook.melbourne.sgi.com> <20080403171450.GB22385@infradead.org> <20080403172400.GC22812@samba1> <20080403184333.GA30595@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080403184333.GA30595@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeremy Allison <jra@samba.org>, Barry Naujok <bnaujok@sgi.com>, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

On Thu, Apr 03, 2008 at 02:43:33PM -0400, Christoph Hellwig wrote:
> On Thu, Apr 03, 2008 at 10:24:00AM -0700, Jeremy Allison wrote:
> > On Thu, Apr 03, 2008 at 01:14:50PM -0400, Christoph Hellwig wrote:
> > > Validating file names is not the filesystem job.  In fact it's utterly
> > > stupid, a unix filename is a sequence of bytes without special meaning
> > > except for ., .., / and \0
> > 
> > This patch will be extremely useful for users who are serving
> > Windows clients using Samba. It allow admins to turn off the
> > userspace case insensitivity we have to emulate and be a significant
> > speed increase.
> 
> CI filenames can work perfectly fine without adding validation of file
> names by treating non-conformant bytestreams as not having lower/upper
> case variants.

Sorry, then I'm not understanding your objection to this patch (and I
don't think I understood that sentence :-).

Jeremy.
