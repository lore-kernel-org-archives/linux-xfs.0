Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 903187F56
	for <xfs@oss.sgi.com>; Sat, 12 Apr 2014 08:49:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 143BBAC004
	for <xfs@oss.sgi.com>; Sat, 12 Apr 2014 06:49:09 -0700 (PDT)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id oCASoy7b33JhtlBu (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 12 Apr 2014 06:49:08 -0700 (PDT)
Date: Sat, 12 Apr 2014 09:49:05 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/4] fs: Prevent doing FALLOC_FL_ZERO_RANGE on append
	only file
Message-ID: <20140412134905.GB13837@thunk.org>
References: <1397242665-2183-1-git-send-email-lczerner@redhat.com>
	<1397242665-2183-2-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1397242665-2183-2-git-send-email-lczerner@redhat.com>
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Fri, Apr 11, 2014 at 08:57:43PM +0200, Lukas Czerner wrote:
> Currently punch hole and collapse range fallocate operation are not
> allowed on append only file. This should be case for zero range as well.
> Fix it.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Looks good to me.  If people don't object, I'll carry this in the ext4
tree for merging in 3.15, since this is a bug fix...

     	 	    	  	     	  - Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
