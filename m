Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 802BC7F3F
	for <xfs@oss.sgi.com>; Tue, 25 Nov 2014 09:32:20 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 43191304067
	for <xfs@oss.sgi.com>; Tue, 25 Nov 2014 07:32:17 -0800 (PST)
Received: from mail-wi0-f175.google.com (mail-wi0-f175.google.com
	[209.85.212.175]) by cuda.sgi.com with ESMTP id
	6pZdU42f6G17C2oP (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Nov 2014 07:32:15 -0800 (PST)
Received: by mail-wi0-f175.google.com with SMTP id l15so9549910wiw.2
	for <xfs@oss.sgi.com>; Tue, 25 Nov 2014 07:32:14 -0800 (PST)
Message-ID: <5474A0FB.1000504@gmail.com>
Date: Tue, 25 Nov 2014 17:32:11 +0200
From: Boaz Harrosh <openosd@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/4] vfs: add support for a lazytime mount option
References: <1416599964-21892-1-git-send-email-tytso@mit.edu>
	<1416599964-21892-3-git-send-email-tytso@mit.edu>
	<20141125015239.GD27262@dastard> <20141125043335.GF31339@thunk.org>
In-Reply-To: <20141125043335.GF31339@thunk.org>
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
To: Theodore Ts'o <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On 11/25/2014 06:33 AM, Theodore Ts'o wrote:
<>
> 
> I was concerned about putting them on the dirty inode list because it
> would be extra inodes for the writeback threads would have to skip
> over and ignore (since they would not be dirty in the inde or data
> pages sense).
> 
> Another solution would be to use a separate linked list for dirtytime
> inodes, but that means adding some extra fields to the inode
> structure, which some might view as bloat.  

You could use the same list-head for both lists. 

If the inode is on the dirty-inode-list then no need to add it
to the list-for-dirtytime, it will be written soon anyway.
else you add it to the list-for-dirtytime.

If you (real)dirty an inode then you first remove it from the
list-for-dirtytime first, and then add it to the dirty-inode-list.

So at each given time it is only on one list

<>

Cheers
Boaz

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
