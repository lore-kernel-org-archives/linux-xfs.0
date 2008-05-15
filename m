Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 May 2008 00:13:19 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4F7D31l025618
	for <xfs@oss.sgi.com>; Thu, 15 May 2008 00:13:12 -0700
Date: Thu, 15 May 2008 09:13:38 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] don't run test 167 if killall is not installed
Message-ID: <20080515071338.GA26247@lst.de>
References: <20080515053918.GA16530@lst.de> <482BDAC1.7070407@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <482BDAC1.7070407@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Tim Shimmin <tes@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Thu, May 15, 2008 at 04:40:01PM +1000, Tim Shimmin wrote:
> Looks reasonable.
> 
> However:
> 
> * could use set_prog_path like we do in common.config.
> 
> * I wonder if one could use "kill -$pgid" on the process group
> for fsstress instead of killall (I've never tried it :).

Dave already commited the original version, but I'll send an update
to use set_prog_path later today.
