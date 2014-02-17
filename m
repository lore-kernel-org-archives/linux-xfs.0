Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2DC937FA3
	for <xfs@oss.sgi.com>; Mon, 17 Feb 2014 17:21:08 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EE4F48F804B
	for <xfs@oss.sgi.com>; Mon, 17 Feb 2014 15:21:07 -0800 (PST)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id OYRCwDFiZncTl8ns (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 17 Feb 2014 15:21:06 -0800 (PST)
Date: Mon, 17 Feb 2014 18:21:00 -0500
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/6] ext4: Update inode i_size after the preallocation
Message-ID: <20140217232100.GA26580@thunk.org>
References: <1392649703-10772-1-git-send-email-lczerner@redhat.com>
	<1392649703-10772-2-git-send-email-lczerner@redhat.com>
	<9288BED9-A44E-4ACC-9A3D-BC086AB4E121@dilger.ca>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <9288BED9-A44E-4ACC-9A3D-BC086AB4E121@dilger.ca>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Andreas Dilger <adilger@dilger.ca>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Lukas Czerner <lczerner@redhat.com>, Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com

On Mon, Feb 17, 2014 at 04:12:14PM -0700, Andreas Dilger wrote:
> 
> I don't necessarily agree about this.  Calling fallocate() will not
> change the user-visible data at all, so there is no reason to e.g.
> do a new backup of the file or reprocess the contents, or any other
> reason that an application cares about a changed mtime.

Well, if i_size has changed, then the visible results of reading from
the file will change, so in that case I'd argue m_time should change.
If the results of reading file doesn't change then we can keep m_time
unchanged --- but since the inode is changing, c_time *should* always
change any time we've made any changes to the extent tree.

	      	  	    	     - Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
