Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q129TZkj041809 for <xfs@oss.sgi.com>; Thu, 2 Feb 2012 03:29:35 -0600
Received: from mexforward.lss.emc.com (mexforward.lss.emc.com [128.222.32.20])
	by cuda.sgi.com with ESMTP id M60lYMAEwI8TVRS1 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 02 Feb 2012 01:29:34 -0800 (PST)
From: <Kiran.Chandapu@emc.com>
Date: Thu, 2 Feb 2012 04:29:00 -0500
Subject: RE: xfs_repair takes long time
Message-ID: <D6BB8A3C30275C45A0A5CA53D5CC37F80242C12A10@MX03A.corp.emc.com>
References: <D6BB8A3C30275C45A0A5CA53D5CC37F80242C12A02@MX03A.corp.emc.com>
	<20120202091715.GC31203@infradead.org>
In-Reply-To: <20120202091715.GC31203@infradead.org>
Content-Language: en-US
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
To: hch@infradead.org
Cc: xfs@oss.sgi.com

Hello Christoph, 

Thanks, I would try to upgrade it. Could you please tell me whether we can recover the data, actually we have all our data about 12 TB resides on that volume which has the issue. 

Thanks
-Kiran

-----Original Message-----
From: Christoph Hellwig [mailto:hch@infradead.org] 
Sent: Thursday, February 02, 2012 2:47 PM
To: Chandapu, Kiran
Cc: xfs@oss.sgi.com
Subject: Re: xfs_repair takes long time

On Thu, Feb 02, 2012 at 03:19:01AM -0500, Kiran.Chandapu@emc.com wrote:
> So I have realized that the file system might have corrupted and started running xfs_repair but it takes such a long time, not sure it is because of the amount of data we have on the volume around 12TB.
> First time it took 3 days, incomplete and unfortunately the session got terminated. Now again I have to run the repair.
> 
> Could anyone please let me know, is there any way I can speed up the process or any rough idea who much time the file system repair going to take.

Grab the latests version from
git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git, and run it in verbose mode (xfs_repair -v).

I suspect you actually have a a volume that doesn't resemble a filesystem anymore and it's looking for a superblock but can't find it.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
