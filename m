Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0K3pJ4r073630 for <xfs@oss.sgi.com>; Thu, 19 Jan 2012 21:51:20 -0600
Received: from mail-iy0-f181.google.com (mail-iy0-f181.google.com
	[209.85.210.181]) by cuda.sgi.com with ESMTP id
	xdBPZqiWebQP4H6M for <xfs@oss.sgi.com>;
	Thu, 19 Jan 2012 19:51:18 -0800 (PST)
Received: by iagz35 with SMTP id z35so283971iag.26
	for <xfs@oss.sgi.com>; Thu, 19 Jan 2012 19:51:18 -0800 (PST)
Date: Fri, 20 Jan 2012 11:55:08 +0800
From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: The question about parallel direct IO in xfs
Message-ID: <20120120035508.GA12703@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi all,

Recently we encounter an issue in ext4. The issue is that, when we do a direct
IO, ext4 will acquire inode->i_mutex in generic_file_aio_write(). It declines
the performance. Here is the detailed conversation.
http://www.spinics.net/lists/linux-ext4/msg30058.html

I know that in xfs it uses i_iolock, which is a rw_semaphore, to make parallel
operations in direct IO. But I have a question. As we do some read/write
operations in direct IO, it seems that there has a window to cause data
inconsistency. For example, One thread does a write operation to overlay some
data at a offset. Meanwhile another thread does a read operation at the same
offset. We assume that write is earlier than read. Hence, we should read new
data. Although it is diffculty to occur, it is possible that read is issued to
the disk firstly and we read old data. I don't know whether it exists or not in
xfs. Thank you.

Sorry, I don't subscribe this mailing list. Please CC to me
<gnehzuil.liu@gmail.com>. Thank you.

Regards,
Zheng

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
