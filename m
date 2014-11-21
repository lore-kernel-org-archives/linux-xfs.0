Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EA6157F3F
	for <xfs@oss.sgi.com>; Fri, 21 Nov 2014 14:09:16 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6A8E8AC008
	for <xfs@oss.sgi.com>; Fri, 21 Nov 2014 12:09:13 -0800 (PST)
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com
	[67.231.145.42]) by cuda.sgi.com with ESMTP id 8oV2rxfLTH9TAgf9
	for <xfs@oss.sgi.com>; Fri, 21 Nov 2014 12:09:11 -0800 (PST)
Date: Fri, 21 Nov 2014 15:08:48 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH 1/4] fs: split update_time() into update_time() and
	write_time()
Message-ID: <1416600528.24312.10@mail.thefacebook.com>
In-Reply-To: <1416599964-21892-2-git-send-email-tytso@mit.edu>
References: <1416599964-21892-1-git-send-email-tytso@mit.edu>
	<1416599964-21892-2-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Theodore Ts'o <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Fri, Nov 21, 2014 at 2:59 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> In preparation for adding support for the lazytime mount option, we
> need to be able to separate out the update_time() and write_time()
> inode operations.  Currently, only btrfs and xfs uses update_time().
> 
> We needed to preserve update_time() because btrfs wants to have a
> special btrfs_root_readonly() check; otherwise we could drop the
> update_time() inode operation entirely.

No objections here, I'll give the queue a whirl.  You can add my 
acked-by-or-Ill-fix-whatever-breaks

I look forward to the patch that makes us all lazy by default.

-chris



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
