Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p575m8TA006241 for <xfs@oss.sgi.com>; Tue, 7 Jun 2011 00:48:08 -0500
Received: from kaylee.flamingspork.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 935AFD0F36E
	for <xfs@oss.sgi.com>; Mon,  6 Jun 2011 22:48:06 -0700 (PDT)
Received: from kaylee.flamingspork.com (kaylee.flamingspork.com
	[74.207.245.61]) by cuda.sgi.com with ESMTP id xa52eXSIa6VABzrY
	for <xfs@oss.sgi.com>; Mon, 06 Jun 2011 22:48:06 -0700 (PDT)
From: Stewart Smith <stewart@flamingspork.com>
Subject: Re: Defragging XFS File Systems
In-Reply-To: <BANLkTi=40mmE+DCbLcSWBwNQtWpP=N=tXw@mail.gmail.com>
References: <BANLkTi=40mmE+DCbLcSWBwNQtWpP=N=tXw@mail.gmail.com>
Date: Tue, 07 Jun 2011 15:48:05 +1000
Message-ID: <8739jmjip6.fsf@flamingspork.com>
MIME-Version: 1.0
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
To: Kenneth Emerson <kenneth.emerson@gmail.com>, xfs@oss.sgi.com

On Mon, 6 Jun 2011 22:52:48 -0500, Kenneth Emerson <kenneth.emerson@gmail.com> wrote:
> I hadn't given much thought to fragmentation of my TV recordings volume
> (XFS) until reading through some MythTV-users threads recently that
> mentioned how fragmented an XFS file system could become.  After running
> xfs_db, I found out that my fs appeared to be quite bad:

MythTV can end up with fragmentation on XFS due to an fsync() call that
attempts to work raound limitations in ext3.

Workarounds include:
- allocsize mount parameter
- patch mythtv source not to fsync (you could easily write a patch that
only did fsync if not xfs... I've been meaning to do this for
years... not enough hours in day).
- run mythbackend with libeatmydata, thus disabling the fsync

-- 
Stewart Smith

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
