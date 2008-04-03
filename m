Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 03 Apr 2008 13:56:49 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m33KuDt3005138
	for <xfs@oss.sgi.com>; Thu, 3 Apr 2008 13:56:14 -0700
Received: from lists.samba.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CD202739452
	for <xfs@oss.sgi.com>; Thu,  3 Apr 2008 11:22:29 -0700 (PDT)
Received: from lists.samba.org (mail.samba.org [66.70.73.150]) by cuda.sgi.com with ESMTP id eJUFtWL76tQmunTS for <xfs@oss.sgi.com>; Thu, 03 Apr 2008 11:22:29 -0700 (PDT)
Date: Thu, 3 Apr 2008 11:22:26 -0700
From: Jeremy Allison <jra@samba.org>
Subject: Re: [PATCH 5/7] XFS: Unicode case-insensitive lookup implementation
Message-ID: <20080403182226.GA6100@samba1>
Reply-To: Jeremy Allison <jra@samba.org>
References: <20080402062508.017738664@chook.melbourne.sgi.com> <20080402062709.011126702@chook.melbourne.sgi.com> <20080403171450.GB22385@infradead.org> <20080403172400.GC22812@samba1> <47F51DDE.8070501@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47F51DDE.8070501@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Jeremy Allison <jra@samba.org>, Christoph Hellwig <hch@infradead.org>, Barry Naujok <bnaujok@sgi.com>, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

On Thu, Apr 03, 2008 at 01:11:42PM -0500, Eric Sandeen wrote:
> Jeremy Allison wrote:
> > On Thu, Apr 03, 2008 at 01:14:50PM -0400, Christoph Hellwig wrote:
> >> Validating file names is not the filesystem job.  In fact it's utterly
> >> stupid, a unix filename is a sequence of bytes without special meaning
> >> except for ., .., / and \0
> > 
> > This patch will be extremely useful for users who are serving
> > Windows clients using Samba. It allow admins to turn off the
> > userspace case insensitivity we have to emulate and be a significant
> > speed increase.
> 
> I'd like to see the numbers... Simo tested an earlier version of this
> patch, and it was not faster.... Jeremy, what would be a representative
> test setup to use?

It very much depends on the usage case. We have many users who have
large numbers of files per directory, and not having to search these
in userspace when we get a stat cache miss is helpful. Just running a
generic "netbench" test won't show any difference, as that test
uses separate directories for each client with small numbers of
files per directory.

There's a reason I wrote this HOWTO (having to use an alternate
link as samba.org seems to be down right now):

http://man.chinaunix.net/newsoft/samba/docs/man/Samba-HOWTO-Collection/largefile.html

Jeremy.
