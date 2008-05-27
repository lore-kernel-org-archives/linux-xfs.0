Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 27 May 2008 16:48:53 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4RNmmwq028687
	for <xfs@oss.sgi.com>; Tue, 27 May 2008 16:48:50 -0700
Subject: Re: xfs_check
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <20080527162605.GA30344@lst.de>
Content-Transfer-Encoding: 7bit
Date: Wed, 28 May 2008 09:49:46 +1000
Message-ID: <op.ubt648og3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <20080527162605.GA30344@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Wed, 28 May 2008 02:26:05 +1000, Christoph Hellwig <hch@lst.de> wrote:

> In the past we had quite a few cases where we told people to run
> xfs_repair -n instead of xfs_check.  I think that makes a lot of sense
> because xfs_repair -n generally gives output at least as useful as
> xfs_check if not more so and also is a lot faster.  Is there any reason
> why we shouldn't simply kill xfs_check and replaced it with a wrapper
> around xfs_repair?

It's on my "todo" list! Some stuff called case-insensitive support is
delaying work like that :)
