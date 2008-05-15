Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 May 2008 00:38:13 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4F7c04n032262
	for <xfs@oss.sgi.com>; Thu, 15 May 2008 00:38:06 -0700
Date: Thu, 15 May 2008 09:38:37 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] don't run test 167 if killall is not installed
Message-ID: <20080515073837.GA28530@lst.de>
References: <20080515053918.GA16530@lst.de> <482BDAC1.7070407@sgi.com> <20080515071338.GA26247@lst.de> <20080515073605.GR155679365@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080515073605.GR155679365@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, Tim Shimmin <tes@sgi.com>, xfs@oss.sgi.com

On Thu, May 15, 2008 at 05:36:05PM +1000, David Chinner wrote:
> > Dave already commited the original version, but I'll send an update
> > to use set_prog_path later today.
> 
> Sorry, didn't see that Tim replied as well. set_prog_path is fine
> by me too, but stopping every test from running because killall is
> not present is a bit of overkill, isn't it?

My plan was to use it in 167 not common.config.  But I don't really care
either way.
