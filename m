Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 30 Oct 2006 17:59:00 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9V1wpaG009102
	for <xfs@oss.sgi.com>; Mon, 30 Oct 2006 17:58:53 -0800
Received: from prod.aconex.com (mail.app.aconex.com [203.89.192.138])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 305534E40D5
	for <xfs@oss.sgi.com>; Mon, 30 Oct 2006 17:58:06 -0800 (PST)
Subject: Re: xfs_quota project + symlinks
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <EFAEF35C8D3C3C927A1C43D3@timothy-shimmins-power-mac-g5.local>
References: <Pine.LNX.4.64.0610261519250.30903@zaphod.blinkenlights.nl>
	 <Pine.LNX.4.64.0610261544020.31061@zaphod.blinkenlights.nl>
	 <2F2FC01C6C9DD207E49DFC0B@timothy-shimmins-power-mac-g5.local>
	 <1162247043.17754.160.camel@edge>
	 <EFAEF35C8D3C3C927A1C43D3@timothy-shimmins-power-mac-g5.local>
Content-Type: text/plain
Date: Tue, 31 Oct 2006 13:01:43 +1100
Message-Id: <1162260103.17754.165.camel@edge>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: Sten Spans <sten@blinkenlights.nl>, xfs@oss.sgi.com

On Tue, 2006-10-31 at 11:08 +1000, Timothy Shimmin wrote:
> 
> Okay, thanks, Nathan,
> 
> So does that mean we need a way for FSGETXATTR and FSSETXATTR
> ioctls to work on the symlink inode? Is this (symlink ioctls)
> done elsewhere? :)

The by-handle interfaces xfsdump is using must support symlinks,
right?  So, I assume theres a way (but I don't know for sure).

cheers.

-- 
Nathan
