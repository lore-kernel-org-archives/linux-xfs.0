Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0DLoHAu188728 for <xfs@oss.sgi.com>; Thu, 13 Jan 2011 15:50:17 -0600
Date: Thu, 13 Jan 2011 15:52:28 -0600
From: Geoffrey Wehrman <gwehrman@sgi.com>
Subject: Re: Problem with XFS on USB 2TB HD
Message-ID: <20110113215228.GB15881@sgi.com>
References: <4D0C9A4F.4040108@pzystorm.de> <20101220001024.GH5193@dastard>
	<4D0EC5C5.2070407@pzystorm.de> <20101220045126.GK5193@dastard>
	<20101220105547.4f9e7218@galadriel.home>
	<4D2E3B38.6010506@pzystorm.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4D2E3B38.6010506@pzystorm.de>
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
To: Kevin Richter <xfs@pzystorm.de>
Cc: xfs@oss.sgi.com

On Thu, Jan 13, 2011 at 12:37:28AM +0100, Kevin Richter wrote:
| > That's because you had the misfortune of garbling the root directory
| > inode along with the superblock. That's a very specific corruption,
| > but if the corruption occurred a few blocks away in a data extent
| > you wouldn't even know about it until you restore from backup and
| > realised the file content in the backup are corrupted. Indeed - you
| > should consider that entire backup as corrupted and redo it from
| > scratch.
| 
| I am wondering if there is a simple solution to backup/restore the inode
| table (the relation "inode <-> filename").
| 
| With "ls -aliR" I get a list which I am now saving every few days.
| The parameter "-i" displays the inode, that I can reconstruct the
| filename from the inode, if this garbling error occurs a second time.
| 
| The reconstruction process probably would be a simple "grep | cut" thing.
| 
| Is there perhaps a finished script doing exactly this? Or any other ideas?

xfs_ncheck(8) will generate the patname/inode mapping, but does not
provide a restore service.


-- 
Geoffrey Wehrman

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
