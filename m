Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C9FF17F3F
	for <xfs@oss.sgi.com>; Thu,  6 Nov 2014 11:55:28 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 75045AC010
	for <xfs@oss.sgi.com>; Thu,  6 Nov 2014 09:55:28 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 1qqbFyctcJWZshhC
	for <xfs@oss.sgi.com>; Thu, 06 Nov 2014 09:55:23 -0800 (PST)
Message-ID: <545BB62C.5020603@hardwarefreak.com>
Date: Thu, 06 Nov 2014 11:55:56 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: EIO and data corruption on XFS file system
References: <BLU175-W376F83659C1C70DE51C3D9DF840@phx.gbl>
In-Reply-To: <BLU175-W376F83659C1C70DE51C3D9DF840@phx.gbl>
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
To: GuangYang <yguang11@outlook.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 11/06/2014 07:03 AM, GuangYang wrote:
> Hello,
> While working on the storage system, I got one question in terms of the
> XFS utilities to fix file system corruption. Basically, our storage
> system put 3 copies of data and the system would detect data
> inconsistency on regular basis, there are two patterns we observed so
> far: 1) the data is corrupted which result in an EIO, 2) data is still
> accessible but the content is changed.
> 
> I am wondering the way to fix such issues from file system's
> perspective, do we expect hardware failure for both cases or some xfs
> repairing tools could help for such case?

xfs_repair addresses filesystem metadata inconsistencies/corruption.  It
does not inspect file contents.  If a file is corrupted xfs_repair can
do nothing for you.  If you're seeing inconsistencies in file data the
problem is not XFS but something else, possibly hardware, as you suspect.

What hardware is this?  What RAID controllers?

Cheers,
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
