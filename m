Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9PGxOXi188742 for <xfs@oss.sgi.com>; Tue, 25 Oct 2011 11:59:26 -0500
Received: from e9.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8C3A71F26FF0
	for <xfs@oss.sgi.com>; Tue, 25 Oct 2011 09:59:23 -0700 (PDT)
Received: from e9.ny.us.ibm.com (e9.ny.us.ibm.com [32.97.182.139]) by
	cuda.sgi.com with ESMTP id YzMfEopilAetE0Is for
	<xfs@oss.sgi.com>; Tue, 25 Oct 2011 09:59:23 -0700 (PDT)
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by e9.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p9PGMfIQ007968
	for <xfs@oss.sgi.com>; Tue, 25 Oct 2011 12:22:41 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p9PGxH8Y190890 for <xfs@oss.sgi.com>; Tue, 25 Oct 2011 12:59:18 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p9PGxEki003953 for <xfs@oss.sgi.com>; Tue, 25 Oct 2011 14:59:17 -0200
Subject: Re: A question in the context of independent pquota
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20111025115428.GC22103@infradead.org>
References: <1319151746.1959.63.camel@chandra-lucid.austin.ibm.com>
	<20111025115428.GC22103@infradead.org>
Date: Tue, 25 Oct 2011 11:59:12 -0500
Message-ID: <1319561952.1959.85.camel@chandra-lucid.austin.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
To: Christoph Hellwig <hch@infradead.org>
Cc: XFS Mailing List <xfs@oss.sgi.com>

On Tue, 2011-10-25 at 07:54 -0400, Christoph Hellwig wrote:
> Hi Chandra,
> 
> I don't think there is an easy way to add a field there.  Please
> just add a new Q_XGETQSTAT_2 call that takes the new, larger structure.

Christoph,

I came up with couple of ideas.

- Add a new version FS_QSTAT_VERSION2 (with a value of 2) that uses
  the newer fs_quota_stat
- Start using qs_version in the user space code, with the bigger 
  fs_quota_stat
- Define a macro to check if the given version is a valid one.
- In xfs_qm_scall_getqstat()(kernel), copy in the newer fs_quota_stat
  structure from user space.
  If copy in succeeded, check qs_version. 
     If valid, use the structure relevant to the version.
     If invalid, use structure for the version FS_QSTAT_VERSION.
  If copy in failed,
     use structure for the version FS_QSTAT_VERSION.

I think it should work with the current user space code.

Let me know what you think of it.

Thanks & Regards,

Chandra
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
