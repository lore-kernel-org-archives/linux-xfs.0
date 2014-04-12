Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4CE177F4E
	for <xfs@oss.sgi.com>; Sat, 12 Apr 2014 18:03:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2C05E8F8049
	for <xfs@oss.sgi.com>; Sat, 12 Apr 2014 16:03:03 -0700 (PDT)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id a42CipOQxgflM5DA (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 12 Apr 2014 16:03:02 -0700 (PDT)
Date: Sat, 12 Apr 2014 19:03:01 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: add a new spinlock i_raw_lock to protect the
	ext4's raw inode
Message-ID: <20140412230301.GB14599@thunk.org>
References: <1397343317-14669-1-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1397343317-14669-1-git-send-email-tytso@mit.edu>
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
To: xfs@oss.sgi.com
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>

On Sat, Apr 12, 2014 at 06:55:14PM -0400, Theodore Ts'o wrote:
> To avoid potential data races, use a spinlock which protects the raw
> (on-disk) inode.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Sigh, sorry, left over patch in the /tmp/p directory.  Please ignore....

      	     	       	     	    - Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
