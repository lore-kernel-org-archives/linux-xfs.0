Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 19 Mar 2007 22:36:29 -0700 (PDT)
Received: from mx1.suse.de (mail.suse.de [195.135.220.2])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2K5aL6p005294
	for <xfs@oss.sgi.com>; Mon, 19 Mar 2007 22:36:22 -0700
Date: Tue, 20 Mar 2007 06:36:18 +0100
From: Nick Piggin <npiggin@suse.de>
Subject: Re: Announce: new-aops-1 for 2.6.21-rc3
Message-ID: <20070320053618.GB30766@wotan.suse.de>
References: <20070315161704.GH8321@wotan.suse.de> <20070315234713.GH21942@ca-server1.us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070315234713.GH21942@ca-server1.us.oracle.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mark Fasheh <mark.fasheh@oracle.com>
Cc: Linux Filesystems <linux-fsdevel@vger.kernel.org>, reiserfs-list@namesys.com, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, nfs@lists.sourceforge.net, cluster-devel@redhat.com, jfs-discussion@lists.sourceforge.net

On Thu, Mar 15, 2007 at 04:47:13PM -0700, Mark Fasheh wrote:
> On Thu, Mar 15, 2007 at 05:17:04PM +0100, Nick Piggin wrote:
> > (excludes the OCFS2 patch that Mark sent, in anticipation of an update)
> 
> Attached is said patch. I needed to export __grab_cache_page (ext2/ext3 also
> need this if they're to be built as modules), so a patch to do that is also
> attached.
> 
> This passed some preliminary testing on a two node cluster I have here at
> Oracle.

Thanks Mark, I've merged these.

Nick
