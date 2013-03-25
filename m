Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C1FFD7F54
	for <xfs@oss.sgi.com>; Mon, 25 Mar 2013 15:08:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9E66430405F
	for <xfs@oss.sgi.com>; Mon, 25 Mar 2013 13:08:42 -0700 (PDT)
Received: from e7.ny.us.ibm.com (e7.ny.us.ibm.com [32.97.182.137]) by
	cuda.sgi.com with ESMTP id mGvlVBAe3zCcg44M (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 25 Mar 2013 13:08:38 -0700 (PDT)
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Mon, 25 Mar 2013 16:08:38 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 83ED5C90058
	for <xfs@oss.sgi.com>; Mon, 25 Mar 2013 16:08:34 -0400 (EDT)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r2PK8Vb8201014 for <xfs@oss.sgi.com>; Mon, 25 Mar 2013 16:08:32 -0400
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r2PK82Of019870
	for <xfs@oss.sgi.com>; Mon, 25 Mar 2013 14:08:03 -0600
Subject: Re: [PATCH v7 0/5] xfs: Allow pquota and gquota to be used together
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20130324231435.GG6369@dastard>
References: <1363902774-19292-1-git-send-email-sekharan@us.ibm.com>
	<20130322020243.GR17758@dastard>
	<1363964446.27672.14.camel@chandra-dt.ibm.com>
	<20130324231435.GG6369@dastard>
Date: Mon, 25 Mar 2013 15:08:01 -0500
Message-ID: <1364242081.27672.15.camel@chandra-dt.ibm.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, 2013-03-25 at 10:14 +1100, Dave Chinner wrote:
> On Fri, Mar 22, 2013 at 10:00:46AM -0500, Chandra Seetharaman wrote:
> > Sure. I will look at your CRC patchset and see what changes are needed
> > to mine.
> > 
> > Meantime, you can answer my dilemma with the change in fs_quota_stat
> > (see patch 4).
> > 
> > As per your suggestion, I changed the data structure, to include pads at
> > relevant places in the data structure, which also means that the new
> > modified structure is not compatible with older user space code. 
> > 
> > So, I created a copy of the older structure (fs_quota_stat_v1) and used
> > that if the user space request has older structure. So, now the new
> > kernel code is backward compatible with the old (already running) user
> > space code. All is well till now....
> > 
> > Now, I make the changes to the user space code so as to use the new
> > fs_quota_stat. Since the data structure has changed, the new user space
> > code will not work with the old kernel code.
> 
> The issue that the userspace code has to handle is that old kernels
> decide the version of the structure, not userspace. i.e. the
> version number is an output parameter, not an input parameter. Hence
> on old kernels we have to detect the version after the call rather
> than assume the kernel treated the version as an input...
> 
> > This is where I have the dilemma. 
> > 
> > 1. Leave the user space code to work only with the newer version,
> > breaking the compatibility with the older kernel (with an error
> > message).
> >    or
> > 2. Read the superblock, and if pquotino is _not_ present conclude older
> > version of fs_quota_stat would suffice for getting quota information
> > from kernel (note that this will work properly with newer kernel code
> > too), and use the older version of fs_quota_stat_v1 for quotactl.
> >    or
> > 3. Any other clever way ? :)
> 
> Because the version is only an output field for old kernels, the
> userspace code should be able to handle it like this:
> 
> 	struct fs_quota_stat fqs;
> 
> 	ASSERT(sizeof(struct fs_quota_stat) >= sizeof(struct fs_quota_stat_v1));
> 
> 	memset(&fqs, 0, sizeof(fqs));
> 	fqs.version = FS_QSTAT_VERSION_2;
> 	error = quotactl(...., &fqs);
> 
> 	if (fqs.version == FS_QSTAT_VERSION) {
> 		struct fs_quota_stat_v1 *fqsv1 = &fqs;
> 
> 		/* process as version 1 */
> 		.....
> 		return error;
> 	}
> 
> 	/* process as version 2 */
> 	.....
> 	return error;
> 
> However, with the version field in the same place for both
> structures, userspace can read the version number after the call and
> determine the correct structure type for the information returned by
> the kernel...

Oh yeah. I didn't think about it.

Thanks.
> 
> Cheers,
> 
> Dave.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
