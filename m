Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 25 Oct 2008 13:25:36 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9PKPTKi030343
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 13:25:29 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7AF35546AEB
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 13:25:29 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id 6JUst9LBOGAl8NRx for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 13:25:29 -0700 (PDT)
Date: Sat, 25 Oct 2008 16:25:28 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2 v2] convert xfs_getbmap to take formatter functions
Message-ID: <20081025202528.GF28002@infradead.org>
References: <49031E81.7040807@sandeen.net> <49032017.6070408@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49032017.6070408@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Sat, Oct 25, 2008 at 08:33:11AM -0500, Eric Sandeen wrote:
> ("*thing" because fiemap doesn't pass the user pointer around, but rather
> has a pointer to a fiemap info structure, and helpers associated with it)

Which means sparse won't like it.  You declare the first argument to the
filler as __user pointer here, but without it in the fiemap version.  I
think the better interface would be to pass a void *buffer, which is
casted to a

	struct {
		struct getbmap(x) __user	*base,
		unsigned			nr;
	}

for the XFS ioctl case and something different for fiemap.  And please
run sparse over it :)

Except for that the patch looks good to me.
