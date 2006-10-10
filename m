Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 09 Oct 2006 19:07:31 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9A27SaG003862
	for <xfs@oss.sgi.com>; Mon, 9 Oct 2006 19:07:28 -0700
Received: from prod.aconex.com (mail.app.aconex.com [203.89.192.138])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BB338D18599C
	for <xfs@oss.sgi.com>; Mon,  9 Oct 2006 19:06:46 -0700 (PDT)
Subject: Re: Directories > 2GB
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <20061010015512.GQ11034@melbourne.sgi.com>
References: <20061004165655.GD22010@schatzie.adilger.int>
	 <452AC4BE.6090905@xfs.org>  <20061010015512.GQ11034@melbourne.sgi.com>
Content-Type: text/plain
Date: Tue, 10 Oct 2006 12:07:15 +1000
Message-Id: <1160446035.8366.42.camel@edge>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: lord@xfs.org, xfs@oss.sgi.com

On Tue, 2006-10-10 at 11:55 +1000, David Chinner wrote:
> On Mon, Oct 09, 2006 at 04:53:02PM -0500, Steve Lord wrote:
> > You might want to think about keeping the directory a little
> > more contiguous than individual disk blocks. XFS does have
> > code in it to allocate the directory in chunks larger than
> > a single file system block. It does not get used on linux
> > because the code was written under the assumption you can
> > see the whole chunk as a single piece of memory which does not
> > work to well in the linux kernel.
> 
> This code is enabled and seems to work in Linux. I don't know if it
> passes xfsqa  so I don't know how reliable this feature is.

It did at one point - though I've not tested that combination for
awhile, I expect it will still work fine.  It should - the
artist-formerly-known-as-pagebuf does handle multiple discontiguous
pages, and the dir2 code is using that memory in a way thats going
to work correctly, IIRC.

cheer

-- 
Nathan
