Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 14 May 2008 23:40:10 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4F6ducS019723
	for <xfs@oss.sgi.com>; Wed, 14 May 2008 23:40:02 -0700
Date: Thu, 15 May 2008 16:40:35 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] don't run test 167 if killall is not installed
Message-ID: <20080515064035.GQ155679365@sgi.com>
References: <20080515053918.GA16530@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080515053918.GA16530@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Thu, May 15, 2008 at 07:39:18AM +0200, Christoph Hellwig wrote:
> Test 167 will leave runaway fsstress processes around in case killall is
> not installed and thus make all following tests fail.  This patch checks
> for killall beeing installed and error out otherwise.

Looks sane to me. I'll check it in in a minute....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
