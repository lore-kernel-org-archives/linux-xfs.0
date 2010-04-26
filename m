Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3QNNpkW113911 for <xfs@oss.sgi.com>; Mon, 26 Apr 2010 18:23:51 -0500
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6CE6412683BA
	for <xfs@oss.sgi.com>; Mon, 26 Apr 2010 16:25:50 -0700 (PDT)
Received: from postoffice2.aconex.com (mail.aconex.com [203.89.202.182]) by
	cuda.sgi.com with ESMTP id RpPg5FR7evYtdl8l for
	<xfs@oss.sgi.com>; Mon, 26 Apr 2010 16:25:50 -0700 (PDT)
Date: Tue, 27 Apr 2010 09:25:43 +1000 (EST)
From: Nathan Scott <nathans@aconex.com>
Message-ID: <537687191.239471272324343715.JavaMail.root@mail-au.aconex.com>
In-Reply-To: <20100426225627.GA7106@esri.com>
Subject: Re: O_SYNC behavior?
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
To: Ray Van Dolson <rvandolson@esri.com>
Cc: xfs@oss.sgi.com


----- "Ray Van Dolson" <rvandolson@esri.com> wrote:

> End-user question:
> 
> NFS client accessing an NFS export on an XFS based filesystem via
> "sync" (O_SYNC) mode.
> 
> Will write confirmation be sent back from the NFS server when the
> data is written to the xfs journal,

Data is never written to the journal.

cheers.

-- 
Nathan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
