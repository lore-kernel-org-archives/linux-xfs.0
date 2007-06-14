Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 13 Jun 2007 18:32:58 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5E1WrWt027569
	for <xfs@oss.sgi.com>; Wed, 13 Jun 2007 18:32:55 -0700
Date: Thu, 14 Jun 2007 11:32:48 +1000
From: Timothy Shimmin <tes@sgi.com>
Subject: Re: REVIEW: Filestreams support for xfs_io chattr command
Message-ID: <643D90500ABD7F8FF6B185F8@boing.melbourne.sgi.com>
In-Reply-To: <op.ttuhisz03jf8g2@pc-bnaujok.melbourne.sgi.com>
References: <op.ttuhisz03jf8g2@pc-bnaujok.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>, xfs@oss.sgi.com, xfs-dev <xfs-dev@sgi.com>

Barry,

Looks reasonable to me.

Just looking at checkin (master-melb:xfs-cmds:24368a)
in a similar area and what it modified,
it also changed, db/inode.c, man3/xfsctl.3, repair/dinode.c
so there might be some other
files to change in the same mod?

OOI, do you run xfstests/040?

--Tim

--On 13 June 2007 3:29:06 PM +1000 Barry Naujok <bnaujok@sgi.com> wrote:

>
> The attached patch lets you enable the filestreams allocator on a
> per-directory basis which can be used instead of enabling it via
> the mount option with the xfs_io chattr command.
